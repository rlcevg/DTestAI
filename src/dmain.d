module dmain;

import spring.bind.callback;
import spring.bind.events_struct;
import spring.unit.unit;
import spring.util.float4;

import dplug.core.thread;
import dplug.core.nogc;
import dplug.core.lockedqueue;
import core.stdc.stdlib : free;

import core.runtime : Runtime;
import core.sync.event : Event;
import core.atomic : atomicStore, atomicLoad, atomicExchange;
static import core.thread.osthread;  // Thread.yield
static import core.time;  // dur
import std.stdio : writeln;
import std.exception;
import core.exception : AssertError, RangeError;

// extern (C) __gshared string[] rt_options = ["gcopt=parallel:4"];  // core.cpuid.threadsPerCPU-1

enum ErrorD {
	OK      = 0,
	UNKNOWN = 100,
	RUNTIME = UNKNOWN + 1,
	THREAD  = UNKNOWN + 2,  // unused
	LOOP    = UNKNOWN + 3,  // unused
	EXCEPT  = UNKNOWN + 4,
	NULL    = UNKNOWN + 5,  // unused
	PTR     = UNKNOWN + 6,  // unused
	ASSERT  = UNKNOWN + 7,
	RANGE   = UNKNOWN + 8,
}

enum MainEvent {
	RUNTIME = 100,
	INIT    = 101,
	RELEASE = 102,
}

__gshared SMainC mainC;
__gshared SMainD mainD;

struct SMainC {
	void ctor() nothrow @nogc {
		_initCount = 0;
		_controlAIId = 0;
		mainD.ctor();
	}

	void dtor() nothrow @nogc {
		mainD.dtor();
	}

	int initialize(int skirmishAIId, const(SSkirmishAICallback)* innerCallback) nothrow @nogc {
		if (_initCount++ <= 0) {
			_await.initialize(false, false);
			mainD.runLoop();
			_await.wait();  // wait for Runtime.initialize
		}

		if (!mainD._isRunning) return mainD._mainError;

		addCallback(skirmishAIId, innerCallback);
		setCallback(skirmishAIId);

		_mailboxes[skirmishAIId].initialize(MAX_REQUESTS);

		_controlAIId.atomicStore(skirmishAIId + 1);
		_await.wait();

		SRequest request = SRequest(null, (AAI ai, in UResponse data) {
			assert(ai is null);
			mainC._ret = mainD.initialize(data.toInt);
			mainC._await.set();
		});
		request.data.toInt = skirmishAIId;
		return waitResponse(skirmishAIId, request);
	}

	int terminate(int skirmishAIId) nothrow @nogc {
		int ret = ErrorD.OK;
		if (hasCallback(skirmishAIId)) {
			if (mainD._isRunning) {
				setCallback(skirmishAIId);

				SRequest request = SRequest(null, (AAI ai, in UResponse data) {
					assert(ai !is null);
					mainC._ret = mainD.terminate(data.toInt);
					mainC._await.set();
				});
				request.data.toInt = skirmishAIId;
				ret = waitResponse(skirmishAIId, request);

				_controlAIId.atomicStore(-(skirmishAIId + 1));
				_await.wait();
			}
			_mailboxes[skirmishAIId].terminate();

			delCallback(skirmishAIId);
		}

		if (--_initCount <= 0)
			mainD.stopLoop();

		return ret;
	}

	int popControlAIId() nothrow @nogc {
		int result = _controlAIId.atomicLoad();
		if (result != 0) _controlAIId = 0;
		return result;
	}

	int handleEvent(int skirmishAIId, int topic, const(void)* data) nothrow @nogc {
		if (!mainD._isRunning) return mainD._mainError;
		if (!hasCallback(skirmishAIId)) return ErrorD.OK;

		switch (topic) {
		case EventTopic.EVENT_INIT:
			setCallback(skirmishAIId);
			return await!((CSpring api, AAI ai, const(SInitEvent*) evt) {
				return ai.initSync(api, evt.savedGame);
			})(skirmishAIId, cast(SInitEvent*)data);
		case EventTopic.EVENT_RELEASE:
			setCallback(skirmishAIId);
			return await!((CSpring api, AAI ai, const(SReleaseEvent*) evt) {
				return ai.releaseSync(api, evt.reason);
			})(skirmishAIId, cast(SReleaseEvent*)data);
		case EventTopic.EVENT_UPDATE: {
			version(assert) {
				import core.stdc.stdio : printf;
				size_t rql = _mailboxes[skirmishAIId]._requests.length;
				if (rql > 10) printf("requests: %lu\n", rql);
			}
			// process requests
			setCallback(skirmishAIId);
			SRequest request;
			while (_mailboxes[skirmishAIId]._requests.tryPopFront(request)) {
				request.action(_api, request.data);
				if (request.finish !is null)
					_mailboxes[skirmishAIId].respond(request);
			}
			// send update
			async!((AAI ai, const(SUpdateEvent*) evt) {
				ai.update(evt.frame);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SUpdateEvent*)data).update);
			version(assert) {
				import core.stdc.stdio : printf;
				size_t rpl = _mailboxes[skirmishAIId]._responses.length;
				if (rpl > 10) printf("responses: %lu\n", rpl);
			}
		} break;
		case EventTopic.EVENT_MESSAGE:
			async!((AAI ai, const(SDMessageEvent*) evt) {
				ai.message(evt.message);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SMessageEvent*)data).message);
			break;
		case EventTopic.EVENT_UNIT_CREATED:
			SDUnitCreatedEvent* event = &_mailboxes[skirmishAIId].getEventHandle(cast(SUnitCreatedEvent*)data).unitCreated;
			setCallback(skirmishAIId);
			event.unitDef = SUnit(event.unit).getDef().id;
			async!((AAI ai, const(SDUnitCreatedEvent*) evt) {
				ai.unitCreated(evt.unit, evt.unitDef, evt.builder);
			})(skirmishAIId, event);
			break;
		case EventTopic.EVENT_UNIT_FINISHED:
			SDUnitFinishedEvent* event = &_mailboxes[skirmishAIId].getEventHandle(cast(SUnitFinishedEvent*)data).unitFinished;
			setCallback(skirmishAIId);
			event.unitDef = SUnit(event.unit).getDef().id;
			async!((AAI ai, const(SDUnitFinishedEvent*) evt) {
				ai.unitFinished(evt.unit, evt.unitDef);
			})(skirmishAIId, event);
			break;
		case EventTopic.EVENT_UNIT_IDLE:
			async!((AAI ai, const(SUnitIdleEvent*) evt) {
				ai.unitIdle(evt.unit);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SUnitIdleEvent*)data).unitIdle);
			break;
		case EventTopic.EVENT_UNIT_MOVE_FAILED:
			async!((AAI ai, const(SUnitMoveFailedEvent*) evt) {
				ai.unitMoveFailed(evt.unit);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SUnitMoveFailedEvent*)data).unitMoveFailed);
			break;
		case EventTopic.EVENT_UNIT_DAMAGED:
			async!((AAI ai, const(SDUnitDamagedEvent*) evt) {
				ai.unitDamaged(evt.unit, evt.attacker, evt.damage, evt.dir, evt.weaponDefId, evt.paralyzer);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SUnitDamagedEvent*)data).unitDamaged);
			break;
		case EventTopic.EVENT_UNIT_DESTROYED:
			async!((AAI ai, const(SUnitDestroyedEvent*) evt) {
				ai.unitDestroyed(evt.unit, evt.attacker);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SUnitDestroyedEvent*)data).unitDestroyd);
			break;
		case EventTopic.EVENT_UNIT_GIVEN:
			async!((AAI ai, const(SUnitGivenEvent*) evt) {
				ai.unitGiven(evt.unitId, evt.oldTeamId, evt.newTeamId);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SUnitGivenEvent*)data).unitGiven);
			break;
		case EventTopic.EVENT_UNIT_CAPTURED:
			async!((AAI ai, const(SUnitCapturedEvent*) evt) {
				ai.unitCaptured(evt.unitId, evt.oldTeamId, evt.newTeamId);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SUnitCapturedEvent*)data).unitCaptured);
			break;
		case EventTopic.EVENT_ENEMY_ENTER_LOS:
			async!((AAI ai, const(SEnemyEnterLOSEvent*) evt) {
				ai.enemyEnterLOS(evt.enemy);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SEnemyEnterLOSEvent*)data).enemyEnterLOS);
			break;
		case EventTopic.EVENT_ENEMY_LEAVE_LOS:
			async!((AAI ai, const(SEnemyLeaveLOSEvent*) evt) {
				ai.enemyLeaveLOS(evt.enemy);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SEnemyLeaveLOSEvent*)data).enemyLeaveLOS);
			break;
		case EventTopic.EVENT_ENEMY_ENTER_RADAR:
			async!((AAI ai, const(SEnemyEnterRadarEvent*) evt) {
				ai.enemyEnterRadar(evt.enemy);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SEnemyEnterRadarEvent*)data).enemyEnterRadar);
			break;
		case EventTopic.EVENT_ENEMY_LEAVE_RADAR:
			async!((AAI ai, const(SEnemyLeaveRadarEvent*) evt) {
				ai.enemyLeaveRadar(evt.enemy);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SEnemyLeaveRadarEvent*)data).enemyLeaveRadar);
			break;
		case EventTopic.EVENT_ENEMY_DAMAGED:
			async!((AAI ai, const(SDEnemyDamagedEvent*) evt) {
				ai.enemyDamaged(evt.enemy, evt.attacker, evt.damage, evt.dir, evt.weaponDefId, evt.paralyzer);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SEnemyDamagedEvent*)data).enemyDamaged);
			break;
		case EventTopic.EVENT_ENEMY_DESTROYED:
			async!((AAI ai, const(SEnemyDestroyedEvent*) evt) {
				ai.enemyDestroyed(evt.enemy, evt.attacker);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SEnemyDestroyedEvent*)data).enemyDestroyed);
			break;
		case EventTopic.EVENT_WEAPON_FIRED:
			async!((AAI ai, const(SWeaponFiredEvent*) evt) {
				ai.weaponFired(evt.unitId, evt.weaponDefId);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SWeaponFiredEvent*)data).weaponFired);
			break;
		case EventTopic.EVENT_PLAYER_COMMAND:
			async!((AAI ai, const(SDPlayerCommandEvent*) evt) {
				ai.playerCommand(evt.units, evt.commandTopicId, evt.playerId);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SPlayerCommandEvent*)data).playerCommand);
			break;
		case EventTopic.EVENT_SEISMIC_PING:
			async!((AAI ai, const(SDSeismicPingEvent*) evt) {
				ai.seismicPing(evt.pos, evt.strength);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SSeismicPingEvent*)data).seismicPing);
			break;
		case EventTopic.EVENT_COMMAND_FINISHED:
			async!((AAI ai, const(SCommandFinishedEvent*) evt) {
				ai.commandFinished(evt.unitId, evt.commandId, evt.commandTopicId);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SCommandFinishedEvent*)data).commandFinished);
			break;
		case EventTopic.EVENT_LOAD:
			setCallback(skirmishAIId);
			return await!((CSpring api, AAI ai, const(SLoadEvent*) evt) {
				return ai.loadSync(api, evt.file);
			})(skirmishAIId, cast(SLoadEvent*)data);
		case EventTopic.EVENT_SAVE:
			setCallback(skirmishAIId);
			return await!((CSpring api, AAI ai, const(SSaveEvent*) evt) {
				return ai.saveSync(api, evt.file);
			})(skirmishAIId, cast(SSaveEvent*)data);
		case EventTopic.EVENT_ENEMY_CREATED:
			async!((AAI ai, const(SEnemyCreatedEvent*) evt) {
				ai.enemyCreated(evt.enemy);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SEnemyCreatedEvent*)data).enemyCreated);
			break;
		case EventTopic.EVENT_ENEMY_FINISHED:
			async!((AAI ai, const(SEnemyFinishedEvent*) evt) {
				ai.enemyFinished(evt.enemy);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SEnemyFinishedEvent*)data).enemyFinished);
			break;
		case EventTopic.EVENT_LUA_MESSAGE:
			async!((AAI ai, const(SDLuaMessageEvent*) evt) {
				ai.luaMessage(evt.inData);
			})(skirmishAIId, &_mailboxes[skirmishAIId].getEventHandle(cast(SLuaMessageEvent*)data).luaMessage);
			break;
		default:
		}

		return ErrorD.OK;
	}

	bool send(int skirmishAIId, in SRequest request) {
		return _mailboxes[skirmishAIId].send(request);
	}

private:
	int waitResponse(int skirmishAIId, in SRequest request) nothrow @nogc {
		if (_mailboxes[skirmishAIId].respond(request))
			_await.wait();
		else
			_ret = ErrorD.OK;
		return _ret;  // (ret != 0) => error
	}

	int await(alias event, T)(int skirmishAIId, const(T)* evt) {
		SRequest request = SRequest(null, (AAI ai, in UResponse data) {
			mainC._ret = event(mainC._api, ai, cast(const(T)*)data.toConstPtr);
			mainC._await.set();
		});
		request.data.toConstPtr = evt;
		return waitResponse(skirmishAIId, request);
	}

	void async(alias event, T)(int skirmishAIId, const(T)* evt) {
		SRequest request = SRequest(null, (AAI ai, in UResponse data) {
			event(ai, cast(const(T)*)data.toConstPtr);
		});
		request.data.toConstPtr = evt;
		_mailboxes[skirmishAIId].respond(request);
	}

	void addCallback(int skirmishAIId, const(SSkirmishAICallback)* clb) nothrow @nogc
	in (cast(uint)skirmishAIId < MAX_AIS)  // 0 <= skirmishAIId && skirmishAIId < MAX_AIS
	in (_apis[skirmishAIId] is null && clb !is null)
	out (; _apis[skirmishAIId] !is null) {
		_apis[skirmishAIId] = mallocNew!CSpring(skirmishAIId, clb);
	}

	void delCallback(int skirmishAIId) nothrow @nogc
	in (cast(uint)skirmishAIId < MAX_AIS)
	out (; _apis[skirmishAIId] is null) {
		destroyFree(_apis[skirmishAIId]);
		_apis[skirmishAIId] = null;
	}

	void setCallback(int skirmishAIId) nothrow @nogc
	in (cast(uint)skirmishAIId < MAX_AIS)
	in (_apis[skirmishAIId] !is null) {
		_api = _apis[skirmishAIId];
		_api.applyCallback();
	}

	bool hasCallback(int skirmishAIId) nothrow @nogc
	in (cast(uint)skirmishAIId < MAX_AIS) {
		return _apis[skirmishAIId] !is null;
	}

	size_t _initCount;
	CSpring[MAX_AIS] _apis;  // skirmishAIId -> CSpring -> SSkirmishAICallback*
	SMail[MAX_AIS] _mailboxes;

	// Synced part
	Event _await;
	int _ret;
	shared int _controlAIId;  // 0:no-command, +1:add-0-skirmishAIId, -1:remove-0-skirmishAIId
	CSpring _api;  // current set API
}

struct SMainD {
	void ctor() nothrow @nogc {
		_isRuntime = false;
	}

	void dtor() nothrow @nogc {
		if (_isRuntime)
			try { assumeNoGC(&Runtime.terminate)(); } catch (Exception e) {}
	}

	void runLoop() nothrow @nogc {
		_isRunning = false;
		// NB: fake nogc, don't want to edit dplug.core.thread
		_mainThread = launchInAThread(assumeNoGC(&mainLoop));  // failure is not an option, no ErrorD.THREAD
	}

	void stopLoop() nothrow @nogc {
		if (_isRunning) {
			_isRunning = false;
			_mainThread.join();
		}
	}

private:
	void mainLoop() nothrow {  // event loop with runtime
		try {
			if (!_isRuntime && !Runtime.initialize()) {
				mainC._ret = _mainError = ErrorD.RUNTIME;
				return;
			}
			_isRuntime = true;
		} catch (Exception e) {
			mainC._ret = _mainError = ErrorD.RUNTIME;
			mainC._await.set();
			return;
		}

		try {
			registerGC();
			mainC._ret = _mainError = ErrorD.OK;
			mainC._await.set();

			int numProcessed = 0;
			_isRunning = true;
			while (_isRunning) {
				int controlAIId = mainC.popControlAIId();
				if (controlAIId != 0) {
					if (controlAIId > 0)
						_activeMail.pushBack(controlAIId - 1);
					else
						_activeMail.remove(-controlAIId - 1);
					mainC._await.set();
				}

				int lastProcessed = numProcessed;
				for (int i = 0; i < _activeMail.count; ++i) {
					int skirmishAIId = _activeMail.ids[i];
					SRequest request;
					while (mainC._mailboxes[skirmishAIId].receive(request)) {
						request.finish(getAI(skirmishAIId), request.data);
						++numProcessed;
					}
				}
				if (lastProcessed == numProcessed)
					core.thread.osthread.Thread.sleep(core.time.dur!"msecs"(1));
				else if (numProcessed > _activeMail.count * MAX_REQUESTS) {
					numProcessed = 0;
					collectGC();  // should help avoid GC-stop-the-world while in LockedQueue, if D side spawns more threads.
				}
			}

		} catch (Exception e) {
			mainC._ret = _mainError = ErrorD.EXCEPT;  // ErrorD.LOOP was here
			try { writeln(e); } catch (Exception e) {}
		} catch (AssertError e) {
			mainC._ret = ErrorD.ASSERT;
			try { writeln(e); } catch (Exception e) {}
		} catch (RangeError e) {
			mainC._ret = ErrorD.RANGE;
			try { writeln(e); } catch (Exception e) {}
		} finally {
			unregisterGC();
			_isRunning = false;
			mainC._await.set();
		}

		version(linux)  // Windows kills stuff and crashes on DLL unload
		try { Runtime.terminate(); _isRuntime = false; } catch (Exception e) {}
	}

	int initialize(int skirmishAIId) {
		import ai.ai : CAI;
		addAI(skirmishAIId, new CAI(skirmishAIId));
		return ErrorD.OK;
	}

	int terminate(int skirmishAIId) {
		delAI(skirmishAIId);
		return ErrorD.OK;
	}

	import core.memory : GC;
	void registerGC() nothrow @nogc {
		GC.addRange(_ais.ptr, _ais.sizeof);
	}

	void unregisterGC() nothrow @nogc {
		GC.removeRange(_ais.ptr);
	}

	void collectGC() nothrow {
		GC.collect();
		// GC.minimize();
	}

	void addAI(int skirmishAIId, AAI ai) nothrow @nogc
	in (cast(uint)skirmishAIId < MAX_AIS)  // 0 <= skirmishAIId && skirmishAIId < MAX_AIS
	in (ai !is null)
	out (; _ais[skirmishAIId] is ai) {
		// GC.addRoot(cast(void*)ai);
		_ais[skirmishAIId] = ai;
	}

	void delAI(int skirmishAIId) nothrow @nogc
	in (cast(uint)skirmishAIId < MAX_AIS)
	in (_ais[skirmishAIId] !is null)
	out (; _ais[skirmishAIId] is null) {
		// GC.removeRoot(cast(void*)_ais[skirmishAIId]);
		_ais[skirmishAIId] = null;
	}

	AAI getAI(int skirmishAIId) nothrow @nogc
	in (cast(uint)skirmishAIId < MAX_AIS) {
		return _ais[skirmishAIId];
	}

	Thread _mainThread;
	shared bool _isRunning;
	bool _isRuntime;
	ErrorD _mainError;
	AAI[MAX_AIS] _ais;

	SActiveMail _activeMail;
}

struct SMail {
	bool send(in SRequest request) nothrow @nogc {
		if (_canSend.atomicLoad()) {
			_requests.pushBack(request);
			return true;
		}
		return false;
	}
	bool respond(in SRequest request) nothrow @nogc {
		if (_canSend.atomicLoad()) {
			_responses.pushBack(request);
			return true;
		}
		return false;
	}
	bool receive(out SRequest request) nothrow @nogc {
		return _responses.tryPopFront(request);
	}

	UHandleEvent* getEventHandle(T)(const(T)* evt) nothrow @nogc {
		with (_events[_eventIdx])
			if (alloc !is null) {
				free(alloc);
				alloc = null;
			}

		UHandleEvent* result = &_events[_eventIdx].event;
		static if (is(T : SMessageEvent)) {
			result.message.player = evt.player;
			result.message.message = stringIDup(evt.message);
			_events[_eventIdx].alloc = cast(void*)result.message.message.ptr;
		} else static if (is(T : SUnitDamagedEvent)) {
			with (result.unitDamaged) {
				unit = evt.unit;
				attacker = evt.attacker;
				damage = evt.damage;
				dir = SFloat4(evt.dir_posF3);
				weaponDefId = evt.weaponDefId;
				paralyzer = evt.paralyzer;
			}
		} else static if (is(T : SEnemyDamagedEvent)) {
			with (result.enemyDamaged) {
				enemy = evt.enemy;
				attacker = evt.attacker;
				damage = evt.damage;
				dir = SFloat4(evt.dir_posF3);
				weaponDefId = evt.weaponDefId;
				paralyzer = evt.paralyzer;
			}
		} else static if (is(T : SPlayerCommandEvent)) {
			with (result.playerCommand) {
				units = cast(SUnit[])mallocDup(evt.unitIds[0..evt.unitIds_size]);
				_events[_eventIdx].alloc = units.ptr;
				commandTopicId = evt.commandTopicId;
				playerId = evt.playerId;
			}
		} else static if (is(T : SSeismicPingEvent)) {
			with (result.seismicPing) {
				pos = SFloat4(evt.pos_posF3);
				strength = evt.strength;
			}
		} else static if (is(T : SLuaMessageEvent)) {
			result.luaMessage.inData = stringIDup(evt.inData);
			_events[_eventIdx].alloc = cast(void*)result.luaMessage.inData.ptr;
		} else {
			*cast(T*)result = *evt;
		}

		_eventIdx = (_eventIdx + 1) % cast(int)_events.length;
		return result;
	}

private:
	void initialize(int capacity) nothrow @nogc {
		_eventIdx = 0;
		_events = mallocSlice!SEventData(capacity);
		_requests = makeLockedQueue!SRequest(capacity);
		_responses = makeLockedQueue!SRequest(capacity);
		_canSend.atomicStore(true);
	}
	void terminate() nothrow @nogc {
		_canSend.atomicStore(false);
		core.thread.osthread.Thread.yield();
		_requests.clear();
		_responses.clear();
		foreach (data; _events)
			if (data.alloc !is null)
				free(data.alloc);
		freeSlice(_events);
	}

	// FIXME: Forbid pushing SRequest when queue is full,
	//        in other words don't overwrite _events
	//        (possible memory leak for "alloc" members)
	SEventData[] _events;
	int _eventIdx;
	// TODO: use single queue instead of separate requests and responses,
	//       requires way to advance queue without popping item in C thread,
	//       mark as processed; D thread should pop processed requests.
	LockedQueue!SRequest _requests;
	LockedQueue!SRequest _responses;
	shared bool _canSend;
}

struct SActiveMail {
	int count = 0;
	int[MAX_AIS] ids;

	this(ref return scope SActiveMail rhs) {
		ids[0..rhs.count] = rhs.ids[0..rhs.count];
		count = rhs.count;
	}

	void pushBack(int skirmishAIId) nothrow @nogc {
		ids[count++] = skirmishAIId;
	}

	void remove(int skirmishAIId) nothrow @nogc {
		for (int i = 0; i < count; ++i)
			if (ids[i] == skirmishAIId) {
				for (; i + 1 < count; ++i)
					ids[i] = ids[i + 1];
				--count;
				break;
			}
	}
}

struct SEventData {
	void* alloc = null;
	UHandleEvent event;
}

union UHandleEvent {
	// SInitEvent initEvent;  // sync, no copy
	// SReleaseEvent release;  // sync, no copy
	SUpdateEvent update;
	SDMessageEvent message;  // copy char* => string
	SDUnitCreatedEvent unitCreated;  // added unitDefId
	SDUnitFinishedEvent unitFinished;  // added unitDefId
	SUnitIdleEvent unitIdle;
	SUnitMoveFailedEvent unitMoveFailed;
	SDUnitDamagedEvent unitDamaged;  // copy float* dir_posF3 => SFloat4
	SUnitDestroyedEvent unitDestroyd;
	SUnitGivenEvent unitGiven;
	SUnitCapturedEvent unitCaptured;
	SEnemyEnterLOSEvent enemyEnterLOS;
	SEnemyLeaveLOSEvent enemyLeaveLOS;
	SEnemyEnterRadarEvent enemyEnterRadar;
	SEnemyLeaveRadarEvent enemyLeaveRadar;
	SDEnemyDamagedEvent enemyDamaged;  // copy float* dir_posF3 => SFloat4
	SEnemyDestroyedEvent enemyDestroyed;
	SWeaponFiredEvent weaponFired;
	SDPlayerCommandEvent playerCommand;  // copy int* unitIds => SUnit[]
	SCommandFinishedEvent commandFinished;
	SDSeismicPingEvent seismicPing;  // copy float* pos_posF3 => SFloat4
	// SLoadEvent load;  // sync, no copy
	// SSaveEvent save;  // sync, no copy
	SEnemyCreatedEvent enemyCreated;
	SEnemyFinishedEvent enemyFinished;
	SDLuaMessageEvent luaMessage;  // copy char* => string
}

struct SDMessageEvent {
	static assert(__traits(allMembers, SMessageEvent) == __traits(allMembers, SDMessageEvent));
	int player;
	string message;
}

struct SDUnitCreatedEvent {
	static assert([__traits(allMembers, SUnitCreatedEvent), "unitDef"] == [__traits(allMembers, SDUnitCreatedEvent)]);
	int unit;
	int builder;
	int unitDef;
}

struct SDUnitFinishedEvent {
	static assert([__traits(allMembers, SUnitFinishedEvent), "unitDef"] == [__traits(allMembers, SDUnitFinishedEvent)]);
	int unit;
	int unitDef;
}

struct SDUnitDamagedEvent {
	int unit;
	int attacker;
	float damage;
	SFloat4 dir;
	int weaponDefId;
	bool paralyzer;
}

struct SDEnemyDamagedEvent {
	int enemy;
	int attacker;
	float damage;
	SFloat4 dir;
	int weaponDefId;
	bool paralyzer;
}

struct SDPlayerCommandEvent {
	static assert(SUnit.sizeof == int.sizeof);
	SUnit[] units;
	int commandTopicId;
	int playerId;
}

struct SDSeismicPingEvent {
	SFloat4 pos;
	float strength;
}

struct SDLuaMessageEvent {
	static assert(__traits(allMembers, SLuaMessageEvent) == __traits(allMembers, SDLuaMessageEvent));
	string inData;
}
