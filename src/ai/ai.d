module ai.ai;

import spring;
import std.format : format;

enum ERROR_UNKNOWN   = 200;
enum ERROR_INIT      = ERROR_UNKNOWN + EventTopic.EVENT_INIT;
enum ERROR_UNIT_IDLE = ERROR_UNKNOWN + EventTopic.EVENT_UNIT_IDLE;

CAI[int] gAIs;

class CAI {  // root of all evil
	immutable int id;  // skirmishAIId
	CRoot!(CMyUnit) root;
	SCheats cheats;
	SGame game;
	SLog log;
	CMap map;

	int lastFrame = -2;
	struct Mex {
		SFloat4 pos;
		bool isTaken = false;
	}
	Mex[] mexes;
	CMyUnit[int] myUnits;
	CMyUnitDef[int] myDefs;
	string[3][string] buildEco;
	string[string] buildFac;
	string[] taunts = [
		"All Your Base Are Belong To US",
		"It is a good day to die",
		"There is no cow level",
		"You Shall Not Pass",
		"Око за око - и весь мир ослепнет",
	];
	int lastTauntFrame = 0;

	this(int skirmishAIId) {
		id = skirmishAIId;
		root = new CRoot!(CMyUnit);
		cheats = root.getCheats();
		game = root.getGame();
		log = root.getLog();
		map = root.getMap();
		buildEco = [
			"armcom": ["armmex", "armsolar", "armwin"],
			"corcom": ["cormex", "corsolar", "corwin"]
		];
		buildFac = [
			"armcom": "armlab",
			"corcom": "corlab"
		];
	}

	final int handleEvent(int topic, const(void)* data) {
		int ret = ERROR_UNKNOWN;
		switch (topic) {
			case EventTopic.EVENT_INIT:
			const SInitEvent* evt = cast(SInitEvent*)data;
				ret = initEvent();
				break;
			case EventTopic.EVENT_UPDATE:
				const SUpdateEvent* evt = cast(SUpdateEvent*)data;
				ret = update(evt.frame);
				break;
			case EventTopic.EVENT_UNIT_FINISHED:
				const SUnitFinishedEvent* evt = cast(SUnitFinishedEvent*)data;
				ret = unitFinished(myUnits[evt.unit] = new CMyUnit(evt.unit));
				break;
			case EventTopic.EVENT_UNIT_IDLE:
				const SUnitIdleEvent* evt = cast(SUnitIdleEvent*)data;
				CMyUnit unit = sanitizeMyUnit(evt.unit);
				ret = (unit is null) ? 0 : unitIdle(unit);
				break;
			case EventTopic.EVENT_UNIT_DESTROYED:
				const SUnitDestroyedEvent* evt = cast(SUnitDestroyedEvent*)data;
				CMyUnit unit = sanitizeMyUnit(evt.unit);
				ret = (unit is null) ? 0 : unitDestroyed(unit);
				myUnits.remove(evt.unit);
				break;
			default:
				ret = 0;
		}
		return ret;  // (ret != 0) => error
	}

	int initEvent() {
		auto res = root.getResourceByName!CResource("Metal");
		if (res is null)
			return ERROR_INIT;
		SFloat4[] spots = map.getResourceMapSpotsPositions(res);
		mexes.length = spots.length;
		foreach (i, spot; spots)
			mexes[i].pos = spot;
		foreach (d; root.getUnitDefs!CMyUnitDef)
			myDefs[d.id] = d;
		return 0;
	}

	int unitFinished(CMyUnit unit) {
		unit.def = myDefs[unit.getDefId];
		log.log(format("%s | %s | %s", __FUNCTION__, unit.def.getName, unit.id));
		with (unit.def) {
			string name = getName();
			isCommander = name == "armcom" || name == "corcom";
			isFactory = name == buildFac["armcom"] || name == buildFac["corcom"];
			isMobile = getSpeed > .1f;
			count++;
		}

		if (!unit.def.isCommander && unit.def.isMobile && lastFrame - lastTauntFrame > FRAMES_PER_SEC * 60) {
			lastTauntFrame = lastFrame;
			string name = unit.def.getName;
			if (unit.def.count > 1)
				name ~= "'s";
			string msg = format("/say AI%s: I have %s %s", id, unit.def.count, name);
			game.sendTextMessage(msg, 0);  // throws CCallbackAIException
		}
		return CMyUnit.hasCommands(unit.id) ? 0 : unitIdle(unit);
	}

	int unitIdle(CMyUnit unit) {
		log.log(format("%s | %s | %s", __FUNCTION__, unit.def.getName, unit.id));
		if (unit.def.isCommander) {
			if (unit.buildCount > 15) {
				import std.algorithm : map;
				import std.array : array;
				CMyUnit[] teamUnits = root.getTeamUnitIds.map!(i => (i < 0) ? null : sanitizeMyUnit(i)).array;
				foreach (u; teamUnits)
					if (u !is null && u.def.getName == buildFac[unit.def.getName]) {
						unit.guard(u);  // throws CCallbackAIException
						return 0;
					}
			}
			CMyUnitDef toBuild = root.getUnitDefByName!CMyUnitDef((unit.buildCount++ == 6)
					? buildFac[unit.def.getName]
					: buildEco[unit.def.getName][unit.lastEcoIdx++ % $]);
			if (toBuild is null)
				return ERROR_UNIT_IDLE;
			SFloat4 pos = unit.getPos;
			import std.algorithm : canFind;
			if (["armmex", "cormex"].canFind(toBuild.getName)) {
				int idx = findNextMexSpot(pos);
				if (idx >= 0)
					pos = mexes[idx].pos;
			} else {
				pos = map.findClosestBuildSite(toBuild, pos, 1000, 0, UnitFacing.UNIT_NO_FACING);
				if (pos.x == -1)
					pos = unit.getPos;
			}
			unit.build(toBuild, pos, UnitFacing.UNIT_NO_FACING);  // throws CCallbackAIException
		} else if (unit.def.isFactory) {
			string buildName;
			switch (unit.def.getName) {
				case "armlab":
					buildName = "armpw";
					break;
				case "corlab":
					buildName = "corak";
					break;
				default: break;
			}
			unit.build(root.getUnitDefByName(buildName), unit.getPos, UnitFacing.UNIT_NO_FACING);  // throws CCallbackAIException
		} else if (unit.def.isMobile) {
			unit.fight(randomPos);  // throws CCallbackAIException
		}
		return 0;
	}

	int unitDestroyed(CMyUnit unit) {
		log.log(format("%s | %s | %s", __FUNCTION__, unit.def.getName, unit.id));
		unit.def.count--;
		return 0;
	}

	int update(int frame) {
		lastFrame = frame;
		if (frame == FRAMES_PER_SEC * 60 * 20)
			cheats.setEnabled(true);
		int tick = frame % (FRAMES_PER_SEC * 60 * 2);
		switch (tick) {
			case 0, 60 * FRAMES_PER_SEC:
				auto targets = root.getEnemyUnits;
				if (targets.length != 0 && targets[0] !is null)
					attack(targets[0].getPos);
				break;
			case 30 * FRAMES_PER_SEC, 90 * FRAMES_PER_SEC:
				attack(randomPos);
				break;
			case 42 * FRAMES_PER_SEC:
				import std.conv : to;
				import std.random;
				auto rnd = MinstdRand(unpredictableSeed);
				game.sendTextMessage("/say AI" ~ to!string(id) ~ ": " ~ taunts.choice(rnd), 0);  // throws CCallbackAIException
				break;
			default: break;
		}
		return 0;
	}

	private CMyUnit sanitizeMyUnit(int unitId) {
		CMyUnit* unit = unitId in myUnits;
		return (unit is null) ? null : *unit;
	}

	private SFloat4 randomPos() {
		float elmoWidth = map.getWidth * SQUARE_SIZE;
		float elmoHeight = map.getHeight * SQUARE_SIZE;
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
			map.getDrawer.addPoint(mexes[result].pos, "next");  // throws CCallbackAIException
			map.getDrawer.addLine(pos, mexes[result].pos);  // throws CCallbackAIException
		}
		return result;
	}

	private void attack(in SFloat4 pos) {
		foreach (u; myUnits.values)
			if (u.def.isMobile && !u.def.isCommander)
				u.fight(pos);  // throws CCallbackAIException
	}
}

class CMyUnitDef : CUnitDef {
	this(int id) { super(id); }

	bool isCommander = false;
	bool isMobile = false;
	bool isFactory = false;
	int count = 0;
}

class CMyUnit : CUnit {
	this(int id) pure { super(id); }

	CMyUnitDef def = null;
	int lastEcoIdx = 0;
	int buildCount = 0;
	int lastOrderFrame = 0;
}
