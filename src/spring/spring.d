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
static import std.string;
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

/++
 * Single-thread root interface object, thread unsafe
 +/
class CSpring {
	this() {
		_ids.length = MAX_UNITS;  // preallocated container of ID's
	}

	STeam[] getEnemyTeams() {
		return makeEntityVec!STeam(gCallback.getEnemyTeams);
	}
	int getEnemyTeamSize() const {
		return gCallback.getEnemyTeams(gSkirmishAIId, null, -1) - 1;  // -1 for Gaia team :(
	}

	STeam[] getAlliedTeams() {
		return makeEntityVec!STeam(gCallback.getAlliedTeams);
	}

	SUnit[] getEnemyUnits() {
		return makeEntityVec!SUnit(gCallback.getEnemyUnits);
	}

	SUnit[] getEnemyUnitsIn(in SFloat4 pos, float radius, bool spherical = true) {
		return makeEntityVec!SUnit(gCallback.getEnemyUnitsIn, pos, radius, spherical);
	}

	SUnit[] getEnemyUnitsInRadarAndLos() {
		return makeEntityVec!SUnit(gCallback.getEnemyUnitsInRadarAndLos);
	}

	SUnit[] getFriendlyUnits() {
		return makeEntityVec!SUnit(gCallback.getFriendlyUnits);
	}

	SUnit[] getFriendlyUnitsIn(in SFloat4 pos, float radius, bool spherical = true) {
		return makeEntityVec!SUnit(gCallback.getFriendlyUnitsIn, pos, radius, spherical);
	}
	bool isFriendlyUnitsIn(in SFloat4 pos, float radius, bool spherical = true) const {
		return gCallback.getFriendlyUnitsIn(gSkirmishAIId, pos.ptr, radius, spherical, null, -1) > 0;
	}

	SUnit[] getNeutralUnits() {
		return makeEntityVec!SUnit(gCallback.getNeutralUnits);
	}

	SUnit[] getNeutralUnitsIn(in SFloat4 pos, float radius, bool spherical = true) {
		return makeEntityVec!SUnit(gCallback.getNeutralUnitsIn, pos, radius, spherical);
	}
	bool isNeutralUnitsIn(in SFloat4 pos, float radius, bool spherical = true) const {
		return gCallback.getNeutralUnitsIn(gSkirmishAIId, pos.ptr, radius, spherical, null, -1) > 0;
	}

	SUnit[] getTeamUnits() {
		return makeEntityVec!SUnit(gCallback.getTeamUnits);
	}

	SUnit[] getSelectedUnits() {
		return makeEntityVec!SUnit(gCallback.getSelectedUnits);
	}

	SFeatureDef[] getFeatureDefs() {
		return makeEntityVec!SFeatureDef(gCallback.getFeatureDefs);
	}

	SFeature[] getFeatures() {
		return makeEntityVec!SFeature(gCallback.getFeatures);
	}
	bool hasFeatures() const {  // NB: geo spot is a Feature
		return gCallback.getFeatures(gSkirmishAIId, null, -1) > 0;
	}

	SFeature[] getFeaturesIn(in SFloat4 pos, float radius, bool spherical = true) {
		return makeEntityVec!SFeature(gCallback.getFeaturesIn, pos, radius, spherical);
	}
	bool isFeaturesIn(in SFloat4 pos, float radius, bool spherical = true) const {
		return gCallback.getFeaturesIn(gSkirmishAIId, pos.ptr, radius, spherical, null, -1) > 0;
	}

	SGroup[] getGroups() {
		return makeEntityVec!SGroup(gCallback.getGroups);
	}

	SResource[] getResources() const {
		return makeSerialVec!SResource(gCallback.getResources);
	}

	Nullable!SResource getResourceByName(string resourceName) const
	in (resourceName) {
		int internal_ret = gCallback.getResourceByName(gSkirmishAIId, std.string.toStringz(resourceName));
		return (internal_ret < 0) ? Nullable!SResource.init : nullable(SResource(internal_ret));
	}

	SUnitDef[] getUnitDefs() {
		return makeEntityVec!SUnitDef(gCallback.getUnitDefs);
	}

	Nullable!SUnitDef getUnitDefByName(string unitName) const
	in (unitName) {
		int internal_ret = gCallback.getUnitDefByName(gSkirmishAIId, std.string.toStringz(unitName));
		return (internal_ret < 0) ? Nullable!SUnitDef.init : nullable(SUnitDef(internal_ret));
	}

	SWeaponDef[] getWeaponDefs() const {
		return makeSerialVec!SWeaponDef(gCallback.getWeaponDefs);
	}

	Nullable!SWeaponDef getWeaponDefByName(string weaponDefName) const
	in (weaponDefName) {
		int internal_ret = gCallback.getWeaponDefByName(gSkirmishAIId, std.string.toStringz(weaponDefName));
		return (internal_ret < 0) ? Nullable!SWeaponDef.init : nullable(SWeaponDef(internal_ret));
	}

	int getNumTeams() const {
		return gCallback.Teams_getSize(gSkirmishAIId);
	}

	int getNumSkirmishAIs() const {
		return gCallback.SkirmishAIs_getSize(gSkirmishAIId);
	}

	int getMaxSkirmishAIs() const {
		return gCallback.SkirmishAIs_getMax(gSkirmishAIId);
	}

	CSkirmishAI getSkirmishAI() const {
		return new CSkirmishAI();
	}
	CPathing getPathing() const {
		return new CPathing();
	}
	CEconomy getEconomy() const {
		return new CEconomy();
	}
	CGame getGame() const {
		return new CGame();
	}
	CCheats getCheats() const {
		return new CCheats();
	}
	CMap getMap() const {
		return new CMap();
	}
	CLog getLog() const {
		return new CLog();
	}
	CDebugDrawer getDebugDrawer() const {
		return new CDebugDrawer();
	}
	CFile getFile() const {
		return new CFile();
	}
	CLua getLua() const {
		return new CLua();
	}
	CMod getMod() const {
		return new CMod();
	}
	CEngine getEngine() const {
		return new CEngine();
	}

private:
	int[] _ids;

	T[] makeEntityVec(T, F, V...)(F readIds, in V va) {  // Target, Function, Variadic types
		static assert(T.sizeof == int.sizeof);
		static assert(va.length == 0 || va.length == 3);
		int size;
		static if (va.length > 0) {
			size = readIds(gSkirmishAIId, va[0].ptr, va[1], va[2], _ids.ptr, cast(int)_ids.length);
		} else {
			size = readIds(gSkirmishAIId, _ids.ptr, cast(int)_ids.length);
		}
		return cast(T[])_ids[0..size];
	}

	T[] makeSerialVec(T, F)(F readSize) const {
		int size = readSize(gSkirmishAIId);
		T[] values;
		values.reserve(size);
		foreach (i; 0 .. size)
			values ~= T(i);
		return values;
	}
}
