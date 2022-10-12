module dmain;

import spring.bind.callback;
import dplug.core.thread;
import dplug.core.nogc;
import core.runtime : Runtime;
import core.sync.event : Event;
import std.stdio : writeln;
import std.exception;
import core.exception : AssertError, RangeError;

version(linux)
version(DigitalMars) {
	version = linux_dmd;
	import etc.linux.memoryerror : NullPointerError, InvalidPointerError;
}

enum ErrorD {
	OK      = 0,
	UNKNOWN = 100,
	RUNTIME = UNKNOWN + 1,
	THREAD  = UNKNOWN + 2,
	LOOP    = UNKNOWN + 3,
	EXCEPT  = UNKNOWN + 4,
	NULL    = UNKNOWN + 5,
	PTR     = UNKNOWN + 6,
	ASSERT  = UNKNOWN + 7,
	RANGE   = UNKNOWN + 8,
}

enum MainEvent {
	RUNTIME = 100,
	INIT    = 101,
	RELEASE = 102,
}

struct SMain {
	void ctor() nothrow @nogc {
		_isRuntime = false;
	}

	void dtor() nothrow @nogc {
		if (_isRuntime)
			try { assumeNoGC(&Runtime.terminate)(); } catch (Exception e) {}
	}

	void initialize() nothrow @nogc {
		if (_initCount++ > 0) return;

		_isRunning = false;
		_message.initialize(false, false);
		_parking.initialize(false, false);

		// NB: assumeNoGC is intentional lie, don't want to edit dplug.core.thread
		_mainThread = launchInAThread(assumeNoGC(&mainLoop));  // failure is not an option, no ErrorD.THREAD

		_parking.wait();  // wait for Runtime.initialize
	}

	void terminate() nothrow @nogc {
		if (--_initCount > 0) return;

		if (!_isRunning) return;
		_isRunning = false;
		_topic = MainEvent.RUNTIME;
		_message.set();
		_mainThread.join();
	}

	int initC(int skirmishAIId, const(SSkirmishAICallback)* innerCallback) nothrow @nogc {
		if (!_isRunning) return _mainError;
		_skirmishAIId = skirmishAIId;
		_topic        = MainEvent.INIT;
		_data         = innerCallback;
		return waitResponse();
	}

	int releaseC(int skirmishAIId) nothrow @nogc {
		if (!_isRunning) return _mainError;
		_skirmishAIId = skirmishAIId;
		_topic        = MainEvent.RELEASE;
		return waitResponse();
	}

	int handleEventC(int skirmishAIId, int topic, const(void)* data) nothrow @nogc {
		if (!_isRunning) return _mainError;
		_skirmishAIId = skirmishAIId;
		_topic        = topic;
		_data         = data;
		return waitResponse();
	}

private:
	int waitResponse() nothrow @nogc {
		_message.set();
		_parking.wait();  // or while(!continue.atomicLoad) Thread.yield(); ?
		return _ret;  // (ret != 0) => error
	}

	void mainLoop() nothrow {
		try {
			if (!_isRuntime && !Runtime.initialize()) {
				_ret = _mainError = ErrorD.RUNTIME;
				return;
			}
			version(Windows)
			_isRuntime = true;
		} catch (Exception e) {
			_ret = _mainError = ErrorD.RUNTIME;
			_parking.set();
			return;
		}

		try {
			_storage.registerGC();
			_ret = _mainError = ErrorD.OK;

			_isRunning = true;
			while (_isRunning) {
				_parking.set();

				_storage.collectGC();

				_message.wait();

				switch (_topic) {
				case MainEvent.RUNTIME: break;
				case MainEvent.INIT:
					_ret = tryCatch!(initD)(_skirmishAIId, cast(const(SSkirmishAICallback)*)_data);
					break;
				case MainEvent.RELEASE:
					_ret = tryCatch!(releaseD)(_skirmishAIId);
					break;
				default:
					_ret = tryCatch!(handleEventD)(_skirmishAIId, _topic, _data);
					_storage.updateGC(_topic, _data);
				}
			}

		} catch(Exception e) {
			_ret = _mainError = ErrorD.LOOP;
		} finally {
			_storage.unregisterGC();
			_isRunning = false;
			_parking.set();
		}

		version(linux)  // Windows kills stuff and crashes on Dll unload
		try { Runtime.terminate(); } catch (Exception e) {}
	}

	int initD(int skirmishAIId, const(SSkirmishAICallback)* innerCallback) {
		import ai.ai : CAI;
		_storage.addCallback(skirmishAIId, innerCallback, new CAI(skirmishAIId));
		return 0;
	}

	int releaseD(int skirmishAIId) {
		if (_storage.hasCallback(skirmishAIId))
			_storage.delCallback(skirmishAIId);
		return 0;
	}

	int handleEventD(int skirmishAIId, int topic, const(void)* data) {
		if (!_storage.hasCallback(skirmishAIId)) return 0;
		IAI ai = _storage.setCallback(skirmishAIId);
		return ai.handleEvent(topic, data);
	}

	int tryCatch(alias func, V...)(in V va)
	in (_skirmishAIId == va[0])
	{
		int ret = ErrorD.UNKNOWN;

		version(linux_dmd) {
			try {
				ret = func(va);
			} catch (Exception e) {
				ret = ErrorD.EXCEPT;
				writeln(e);
			} catch (NullPointerError e) {
				ret = ErrorD.NULL;
				writeln(e);
			} catch (InvalidPointerError e) {
				ret = ErrorD.PTR;
				writeln(e);
			} catch (AssertError e) {
				ret = ErrorD.ASSERT;
				writeln(e);
			} catch (RangeError e) {
				ret = ErrorD.RANGE;
				writeln(e);
			}
		} else {
			try {
				ret = func(va);
			} catch (Exception e) {
				ret = ErrorD.EXCEPT;
				writeln(e);
			} catch (AssertError e) {
				ret = ErrorD.ASSERT;
				writeln(e);
			} catch (RangeError e) {
				ret = ErrorD.RANGE;
				writeln(e);
			}
		}

		if (ErrorD.NULL <= ret && ret <= ErrorD.RANGE) {
			// NB: Catching Error's only because linux core-dump issue - hangs on std::abort().
			//     Though InactiveAI may be appropriate solution instead of killing app.
			_storage.delCallback(_skirmishAIId);
		}

		return ret;
	}

	size_t _initCount;
	shared bool _isRunning;
	bool _isRuntime;
	Thread _mainThread;
	Event _message;
	Event _parking;

	int _skirmishAIId;
	int _topic;
	const(void)* _data;
	int _ret;
	ErrorD _mainError;

	SClbStorage _storage;
}
