module spring.spring;

import spring.bind.callback;
import spring.team;
import spring.group;
import spring.unit.unit_def;
import spring.unit.unit;
import spring.feature.feature_def;
import spring.feature.feature;
import spring.economy.resource;
import spring.weapon.weapon_def;
import spring.util.float4;
import spring.game;
import spring.pathing;
import spring.cheats;
import spring.log;
import spring.file;
import spring.lua;
import spring.mod;
import spring.engine;
import spring.skirmish.skirmish;
import spring.economy.economy;
import spring.map.map;
import spring.drawer.debug_drawer;
/+public +/import std.typecons : nullable, Nullable;
import dplug.core.nogc;

/++
 * Single-thread root interface object, thread unsafe
 +/
class CSpring {
nothrow @nogc:
	this(int skirmishAIId, const(SSkirmishAICallback)* callback) {
		version(assert) {
			import core.thread : ThreadID;
			import std.process : thisThreadID;
			_threadId = assumeNoGC(&thisThreadID)();
		}

		_skirmishAIId = skirmishAIId;
		_callback = callback;

		_skirmish = mallocNew!CSkirmishAI();
		_pathing = mallocNew!CPathing();
		_economy = mallocNew!CEconomy();
		_game = mallocNew!CGame();
		_cheats = mallocNew!CCheats();
		_map = mallocNew!CMap();
		_log = mallocNew!CLog();
		_debugDrawer = mallocNew!CDebugDrawer();
		_file = mallocNew!CFile();
		_lua = mallocNew!CLua();
		_mod = mallocNew!CMod();
		_engine = mallocNew!CEngine();
	}

	~this() {
		destroyFree(_skirmish);
		destroyFree(_pathing);
		destroyFree(_economy);
		destroyFree(_game);
		destroyFree(_cheats);
		destroyFree(_map);
		destroyFree(_log);
		destroyFree(_debugDrawer);
		destroyFree(_file);
		destroyFree(_lua);
		destroyFree(_mod);
		destroyFree(_engine);
		import core.stdc.stdio : printf;
		printf("This is " ~ CSpring.stringof ~ "'s @nogc destructor!!!\n");
	}

	void applyCallback() {
		gSkirmishAIId = _skirmishAIId;
		gCallback = _callback;
		version(assert) gThreadId = _threadId;
	}

	STeam[] getEnemyTeams(STeam[] buf = []) {
		return makeEntityVec(gCallback.getEnemyTeams, buf);
	}
	int getEnemyTeamSize() const {
		return gCallback.getEnemyTeams(gSkirmishAIId, null, -1) - 1;  // -1 for Gaia team :(
	}

	STeam[] getAlliedTeams(STeam[] buf = []) {
		return makeEntityVec(gCallback.getAlliedTeams, buf);
	}

	SUnit[] getEnemyUnits(SUnit[] buf = []) {
		return makeEntityVec(gCallback.getEnemyUnits, buf);
	}

	SUnit[] getEnemyUnitsIn(in SFloat4 pos, float radius, bool spherical = true, SUnit[] buf = []) {
		return makeEntityVec(gCallback.getEnemyUnitsIn, buf, pos, radius, spherical);
	}

	SUnit[] getEnemyUnitsInRadarAndLos(SUnit[] buf = []) {
		return makeEntityVec(gCallback.getEnemyUnitsInRadarAndLos, buf);
	}

	SUnit[] getFriendlyUnits(SUnit[] buf = []) {
		return makeEntityVec(gCallback.getFriendlyUnits, buf);
	}

	SUnit[] getFriendlyUnitsIn(in SFloat4 pos, float radius, bool spherical = true, SUnit[] buf = []) {
		return makeEntityVec(gCallback.getFriendlyUnitsIn, buf, pos, radius, spherical);
	}
	bool isFriendlyUnitsIn(in SFloat4 pos, float radius, bool spherical = true) const {
		return gCallback.getFriendlyUnitsIn(gSkirmishAIId, pos.ptr, radius, spherical, null, -1) > 0;
	}

	SUnit[] getNeutralUnits(SUnit[] buf = []) {
		return makeEntityVec(gCallback.getNeutralUnits, buf);
	}

	SUnit[] getNeutralUnitsIn(in SFloat4 pos, float radius, bool spherical = true, SUnit[] buf = []) {
		return makeEntityVec(gCallback.getNeutralUnitsIn, buf, pos, radius, spherical);
	}
	bool isNeutralUnitsIn(in SFloat4 pos, float radius, bool spherical = true) const {
		return gCallback.getNeutralUnitsIn(gSkirmishAIId, pos.ptr, radius, spherical, null, -1) > 0;
	}

	SUnit[] getTeamUnits(SUnit[] buf = []) {
		return makeEntityVec(gCallback.getTeamUnits, buf);
	}

	SUnit[] getSelectedUnits(SUnit[] buf = []) {
		return makeEntityVec(gCallback.getSelectedUnits, buf);
	}

	SFeatureDef[] getFeatureDefs(SFeatureDef[] buf = []) {
		return makeEntityVec(gCallback.getFeatureDefs, buf);
	}

	SFeature[] getFeatures(SFeature[] buf = []) {
		return makeEntityVec(gCallback.getFeatures, buf);
	}
	bool hasFeatures() const {  // NB: geo spot is a Feature
		return gCallback.getFeatures(gSkirmishAIId, null, -1) > 0;
	}

	SFeature[] getFeaturesIn(in SFloat4 pos, float radius, bool spherical = true, SFeature[] buf = []) {
		return makeEntityVec(gCallback.getFeaturesIn, buf, pos, radius, spherical);
	}
	bool isFeaturesIn(in SFloat4 pos, float radius, bool spherical = true) const {
		return gCallback.getFeaturesIn(gSkirmishAIId, pos.ptr, radius, spherical, null, -1) > 0;
	}

	SGroup[] getGroups(SGroup[] buf = []) {
		return makeEntityVec(gCallback.getGroups, buf);
	}

	SResource[] getResources(SResource[] buf = []) const {
		return makeSerialVec(gCallback.getResources, buf);
	}

	Nullable!SResource getResourceByName(const(char)* resourceName) const
	in (resourceName) {
		int internal_ret = gCallback.getResourceByName(gSkirmishAIId, resourceName);
		return (internal_ret < 0) ? Nullable!SResource.init : nullable(SResource(internal_ret));
	}

	SUnitDef[] getUnitDefs(SUnitDef[] buf = []) {
		return makeEntityVec(gCallback.getUnitDefs, buf);
	}

	Nullable!SUnitDef getUnitDefByName(const(char)* unitName) const
	in (unitName) {
		int internal_ret = gCallback.getUnitDefByName(gSkirmishAIId, unitName);
		return (internal_ret < 0) ? Nullable!SUnitDef.init : nullable(SUnitDef(internal_ret));
	}

	SWeaponDef[] getWeaponDefs(SWeaponDef[] buf = []) const {
		return makeSerialVec(gCallback.getWeaponDefs, buf);
	}

	Nullable!SWeaponDef getWeaponDefByName(const(char)* weaponDefName) const
	in (weaponDefName) {
		int internal_ret = gCallback.getWeaponDefByName(gSkirmishAIId, weaponDefName);
		return (internal_ret < 0) ? Nullable!SWeaponDef.init : nullable(SWeaponDef(internal_ret));
	}

	int getNumTeams() const {
		return gCallback.getNumTeams(gSkirmishAIId);
	}

	int getNumSkirmishAIs() const {
		return gCallback.getNumSkirmishAIs(gSkirmishAIId);
	}

	int getMaxSkirmishAIs() const {
		return gCallback.getMaxSkirmishAIs(gSkirmishAIId);
	}

	CSkirmishAI skirmish() { return _skirmish; }
	CPathing pathing() { return _pathing; }
	CEconomy economy() { return _economy; }
	CGame game() { return _game; }
	CCheats cheats() { return _cheats; }
	CMap map() { return _map; }
	CLog log() { return _log; }
	CDebugDrawer debugDrawer() { return _debugDrawer; }
	CFile file() { return _file; }
	CLua lua() { return _lua; }
	CMod mod() { return _mod; }
	CEngine engine() { return _engine; }

private:
	int _skirmishAIId;
	const(SSkirmishAICallback)* _callback;
	version(assert) ThreadID _threadId;

	CSkirmishAI _skirmish;
	CPathing _pathing;
	CEconomy _economy;
	CGame _game;
	CCheats _cheats;
	CMap _map;
	CLog _log;
	CDebugDrawer _debugDrawer;
	CFile _file;
	CLua _lua;
	CMod _mod;
	CEngine _engine;

	T[] makeEntityVec(T, F, V...)(F readIds, T[] buf, in V va) {  // Target, Function, Variadic types
		static assert(T.sizeof == int.sizeof);
		static assert(va.length == 0 || va.length == 3);
		int size;
		if (buf.length == 0) {
			static if (va.length > 0) {
				size = readIds(gSkirmishAIId, va[0].ptr, va[1], va[2], null, -1);
			} else {
				size = readIds(gSkirmishAIId, null, -1);
			}
			buf = mallocSliceNoInit!T(size);
		}
		static if (va.length > 0) {
			size = readIds(gSkirmishAIId, va[0].ptr, va[1], va[2], cast(int*)buf.ptr, cast(int)buf.length);
		} else {
			size = readIds(gSkirmishAIId, cast(int*)buf.ptr, cast(int)buf.length);
		}
		return buf[0..size];
	}

	T[] makeSerialVec(T, F)(F readSize, T[] buf) const {
		int size = readSize(gSkirmishAIId);
		if (buf.length == 0)
			buf = mallocSliceNoInit!T(size);
		foreach (i; 0 .. size)
			buf[i] = T(i);
		return buf[0..size];
	}
}
