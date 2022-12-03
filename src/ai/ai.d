module ai.ai;

import spring;
import dplug.core.nogc : freeSlice;
import std.format : format;
import std.string : toStringz;

enum ErrorAI {
	OK      = 0,
	UNKNOWN = 200,
	INIT    = UNKNOWN + EventTopic.EVENT_INIT,
	RELEASE = UNKNOWN + EventTopic.EVENT_RELEASE,
}

class CAI : AAI {  // root of all evil
	int lastFrame = -2;
	float elmoWidth;
	float elmoHeight;
	struct Mex {
		SFloat4 pos;
		bool isTaken = false;
	}
	Mex[] mexes;
	CMyUnit[SUnit.Id] myUnits;
	CMyUnitDef[SUnitDef.Id] myDefs;
	SUnitDef.Id[3][SUnitDef.Id] buildEco;
	SUnitDef.Id[SUnitDef.Id] buildFac;
	SUnitDef.Id[SUnitDef.Id] buildArmy;
	string[] taunts = [
		"All Your Base Are Belong To US",
		"It is a good day to die",
		"There is no cow level",
		"You Shall Not Pass",
		"Око за око - и весь мир ослепнет",
	];
	int lastTauntFrame = 0;

	private SUnit[] _unitsBuf;
	private SUnit[] _targetsBuf;

	this(int skirmishAIId) {
		super(skirmishAIId);
		_unitsBuf.length = MAX_UNITS;
		_targetsBuf.length = MAX_UNITS;
	}
	~this() {
		import std.stdio : writeln;
		writeln("This is " ~ CAI.stringof ~ "'s GC destructor!!!");
	}

	final override int initSync(CSpring api, bool isSavedGame) {
		elmoWidth = api.map.getWidth() * SQUARE_SIZE;
		elmoHeight = api.map.getHeight() * SQUARE_SIZE;

		auto res = api.getResourceByName("Metal");
		if (res.isNull)
			return ErrorAI.INIT;
		SFloat4[] spots = api.map.getResourceMapSpotsPositions(res.get);
		mexes.length = spots.length;
		foreach (i, spot; spots) {
			spot.x += 24;
			spot.z += 24;
			mexes[i].pos = spot;
		}
		freeSlice(spots);

		string[3][string] buildEcoName = [
			"armcom": ["armmex", "armsolar", "armsolar"/+, "armwin"+/],
			"corcom": ["cormex", "corsolar", "corsolar"/+, "corwin"+/],
		];
		string[string] buildFacName = [
			"armcom": "armlab",
			"corcom": "corlab",
		];
		string[string] buildArmyName = [
			"armlab": "armpw",
			"corlab": "corak"
		];
		foreach (kv; buildEcoName.byKeyValue) {
			auto def = api.getUnitDefByName(toStringz(kv.key));
			if (def.isNull)
				return ErrorAI.INIT;
			buildEco[def.get.id] = buildEco[def.get.id].init;
			foreach (i, n; kv.value) {
				auto subdef = api.getUnitDefByName(toStringz(n));
				if (subdef.isNull)
					return ErrorAI.INIT;
				buildEco[def.get.id][i] = subdef.get.id;
			}
		}
		import std.typecons : Tuple, tuple;
		Tuple!(string[string]*, SUnitDef.Id[SUnitDef.Id]*)[2] links = [
			tuple(&buildFacName, &buildFac), tuple(&buildArmyName, &buildArmy)
		];
		foreach (l; links) {
			foreach (kv; l[0].byKeyValue) {
				auto def = api.getUnitDefByName(toStringz(kv.key));
				if (def.isNull)
					return ErrorAI.INIT;
				auto subdef = api.getUnitDefByName(toStringz(kv.value));
				if (subdef.isNull)
					return ErrorAI.INIT;
				(*l[1])[def.get.id] = subdef.get.id;
			}
		}

		SUnitDef[] defs = api.getUnitDefs();
		foreach (d; defs)
			myDefs[d.id] = new CMyUnitDef(this, d);
		freeSlice(defs);

		return ErrorAI.OK;
	}
	final override int releaseSync(CSpring api, int reason) {
		return 0;
	}

	final override int loadSync(CSpring api, const(char)* filename) { return 0; }
	final override int saveSync(CSpring api, const(char)* filename) { return 0; }

	final override void update(int frame) {
		lastFrame = frame;

		if (frame == FRAMES_PER_SEC * 60 * 20)
			async((CSpring api, out UResponse data) nothrow @nogc {
				api.cheats.setEnabled(true);
			});

		int tick = frame % (FRAMES_PER_SEC * 60 * 2);
		switch (tick) {
		case 0, 60 * FRAMES_PER_SEC:
			SFloat4* retPos = new SFloat4;
			async((CSpring api, out UResponse data) nothrow @nogc {
				SUnit[] targets = api.getEnemyUnits(_targetsBuf);
				if (targets.length == 0) {
					retPos.x = -1;
					return;
				}
				*retPos = targets[0].getPos();
			}, (AAI ai, in UResponse data) {
				if (retPos.x != -1)
					attack(*retPos);
			});
			break;
		case 30 * FRAMES_PER_SEC, 90 * FRAMES_PER_SEC:
			attack(randomPos);
			break;
		case 42 * FRAMES_PER_SEC:
			import std.conv : to;
			import std.random;
			auto rnd = MinstdRand(unpredictableSeed);
			const(char)* msg = toStringz("/say AI" ~ to!string(id) ~ ": " ~ taunts.choice(rnd));
			async((CSpring api, out UResponse data) nothrow @nogc {
				try { api.game.sendTextMessage(msg, 0); } catch (Exception e) {}  // throws CCallbackAIException
			});
			break;
		default: break;
		}
	}

	final override void message(string text) {  // text is @nogc
		import std.stdio : writeln;
		writeln("Message: ", text);
	}

	final override void unitCreated(int unitId, int unitDefId, int builderId) {}

	final override void unitFinished(int unitId, int unitDefId) {
		CMyUnit unit = myUnits[unitId] = new CMyUnit(SUnit(unitId));
		unit.def = myDefs[unitDefId];
		const(char)* text = toStringz(format("%s | %s | %s", __FUNCTION__, unit.def.name, unit.id));
		async((CSpring api, out UResponse data) nothrow @nogc {
			api.log.log(text);
			data.toBool = !unit.hasCommands();
		}, (AAI ai, in UResponse data) {
			if (data.toBool)
				ai.unitIdle(unit.id);
		});
		unit.def.count++;

		if (!unit.def.isCommander && unit.def.isMobile && lastFrame - lastTauntFrame > FRAMES_PER_SEC * 60) {
			lastTauntFrame = lastFrame;
			string name = unit.def.name;
			if (unit.def.count > 1)
				name ~= "'s";
			const(char)* msg = toStringz(format("/say AI%s: I have %s %s", id, unit.def.count, name));
			async((CSpring api, out UResponse data) nothrow @nogc {
				try { api.game.sendTextMessage(msg, 0); } catch (Exception e) {}  // throws CCallbackAIException
			});
		}
	}

	final override void unitIdle(int unitId) {
		CMyUnit unit = myUnits.get(unitId, null);
		if (unit is null)
			return;

		const(char)* text = toStringz(format("%s | %s | %s", __FUNCTION__, unit.def.getName(), unit.id));
		async((CSpring api, out UResponse data) nothrow @nogc {
			api.log.log(text);
		});

		if (unit.def.isCommander) {
			if (unit.buildCount > 15) {
				SUnit[] units;
				async((CSpring api, out UResponse data) nothrow @nogc {
					units = api.getTeamUnits(_unitsBuf);
				}, (AAI ai, in UResponse data) {
					import std.algorithm : map;
					import std.array : array;
					CMyUnit[] teamUnits = units.map!(u => myUnits.get(u.id, null)).array;
					foreach (u; teamUnits)
						if (u !is null && u.def.id == buildFac[unit.def.id]) {
							async((CSpring api, out UResponse data) nothrow @nogc {
								try { unit.guard(u); } catch (Exception e) {}  // throws CCallbackAIException
							});
							return;
						}
				});
				return;
			}

			SUnitDef.Id toBuildId = (unit.buildCount++ == 6)
				? buildFac[unit.def.id]
				: buildEco[unit.def.id][unit.lastEcoIdx++ % $];
			auto toBuild = myDefs[toBuildId];

			import std.algorithm : canFind;
			if (["armmex", "cormex"].canFind(toBuild.name)) {
				SFloat4* retPos = new SFloat4;
				async((CSpring api, out UResponse data) nothrow @nogc {
					*retPos = unit.getPos();
				}, (AAI ai, in UResponse data) {
					int idx = findNextMexSpot(*retPos);
					if (idx >= 0)
						*retPos = mexes[idx].pos;
					async((CSpring api, out UResponse data) nothrow @nogc {
						SFloat4 newPos = api.map.findClosestBuildSite(toBuild.unitDef, *retPos, 300, 0, UnitFacing.UNIT_NO_FACING);
						if (newPos.x == -1)
							newPos = *retPos;
						try { unit.build(toBuild.unitDef, newPos, UnitFacing.UNIT_NO_FACING); } catch (Exception e) {}  // throws CCallbackAIException
					});
				});
			} else {
				async((CSpring api, out UResponse data) nothrow @nogc {
					SFloat4 pos = unit.getPos();
					SFloat4 newPos = api.map.findClosestBuildSite(toBuild.unitDef, pos, 1000, 0, UnitFacing.UNIT_NO_FACING);
					if (newPos.x == -1)
						newPos = pos;
					try { unit.build(toBuild.unitDef, newPos, UnitFacing.UNIT_NO_FACING); } catch (Exception e) {}  // throws CCallbackAIException
				});
			}

		} else if (unit.def.isFactory) {
			auto toBuild = myDefs[buildArmy[unit.def.id]];
			async((CSpring api, out UResponse data) nothrow @nogc {
				try { unit.build(toBuild.unitDef, unit.getPos(), UnitFacing.UNIT_NO_FACING); } catch (Exception e) {}  // throws CCallbackAIException
			});

		} else if (unit.def.isMobile) {
			SFloat4 pos = randomPos();
			async((CSpring api, out UResponse data) nothrow @nogc {
				try { unit.fight(pos); } catch (Exception e) {}  // throws CCallbackAIException
			});
		}
	}

	final override void unitMoveFailed(int unitId) {}

	final override void unitDamaged(int unitId, int attackerId,
		float damage, SFloat4 dir, int weaponDefId, bool paralyzer) {}

	final override void unitDestroyed(int unitId, int attackerId) {
		CMyUnit unit = myUnits.get(unitId, null);
		if (unit is null)
			return;
		myUnits.remove(unitId);

		const(char)* text = toStringz(format("%s | %s | %s", __FUNCTION__, unit.def.getName, unit.id));
		async((CSpring api, out UResponse data) nothrow @nogc {
			api.log.log(text);
		});
		unit.def.count--;
	}

	final override void unitGiven(int unitId, int oldTeamId, int newTeamId) {}

	final override void unitCaptured(int unitId, int oldTeamId, int newTeamId) {}

	final override void enemyEnterLOS(int enemyId) {}

	final override void enemyLeaveLOS(int enemyId) {}

	final override void enemyEnterRadar(int enemyId) {}

	final override void enemyLeaveRadar(int enemyId) {}

	final override void enemyDamaged(int enemyId, int attackerId,
		float damage, SFloat4 dir, int weaponDefId, bool paralyzer) {}

	final override void enemyDestroyed(int enemyId, int attackerId) {}

	final override void weaponFired(int unitId, int weaponDefId) {}

	final override void playerCommand(const(SUnit)[] units, int commandTopicId, int playerId) {}

	final override void seismicPing(SFloat4 pos, float strength) {}

	final override void commandFinished(int unitId, int commandId, int commandTopicId) {}

	final override void enemyCreated(int enemyId) {}

	final override void enemyFinished(int enemyId) {}

	final override void luaMessage(string data) {  // data is @nogc
		import std.stdio : writeln;
		writeln("Lua message: ", data);
	}

	private SFloat4 randomPos() {
		import std.random;
		auto rnd = MinstdRand(unpredictableSeed);
		float u1 = rnd.uniform01!float;
		float u2 = rnd.uniform01!float;
		return SFloat4(elmoWidth * u1, 0, elmoHeight * u2);
	}

	private int findNextMexSpot(in SFloat4 pos) {
		float sqDist = float.max;
		int result = -1;
		foreach (i, m; mexes)
			if (!m.isTaken && sqDist > pos.sqDistance2(m.pos)) {
				sqDist = pos.sqDistance2(m.pos);
				result = cast(int)i;
			}
		if (result >= 0) {
			mexes[result].isTaken = true;
			async((CSpring api, out UResponse data) nothrow @nogc {
				try {
					api.map.getDrawer.addPoint(mexes[result].pos, "next");  // throws CCallbackAIException
					api.map.getDrawer.addLine(pos, mexes[result].pos);  // throws CCallbackAIException
				} catch (Exception e) {}
			});
		}
		return result;
	}

	private void attack(in SFloat4 pos) {
		const auto units = myUnits.values.dup;
		async((CSpring api, out UResponse data) nothrow @nogc {
			foreach (u; units)
				if (u.def.isMobile && !u.def.isCommander)
					try { u.fight(pos); } catch (Exception e) {}  // throws CCallbackAIException
		});
	}
}

class CMyUnitDef {
	SUnitDef unitDef;
	alias unitDef this;
	this(in CAI ai, in SUnitDef ud) {
		unitDef = ud;
		import std.conv : to;
		name = to!string(ud.getName());
		isCommander = (id in ai.buildFac) !is null;
		isMobile = ud.getSpeed() > .1f;
		isFactory = (id in ai.buildArmy) !is null;
	}

	string name;
	bool isCommander = false;
	bool isMobile = false;
	bool isFactory = false;
	int count = 0;
}

class CMyUnit {
	SUnit unit;
	alias unit this;
	this(in SUnit u) pure { unit = u; }

	CMyUnitDef def = null;
	int lastEcoIdx = 0;
	int buildCount = 0;
	int lastOrderFrame = 0;
}
