module spring.root;

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

class CRoot(TU : CUnit = CUnit, TF : CFeature = CFeature) {
	// static assert(is(TU : CUnit));
	// static assert(is(TF : CFeature));
	this() {
		_ids.length = MAX_UNITS;  // preallocated container of ID's
		_units.length = MAX_UNITS;  // preallocated container of CUnit's
		_features.length = MAX_UNITS;  // preallocated container of CFeature's
	}

	T[] getEnemyTeams(T : CTeam = CTeam)() {
		return makeEntityVec!T(gCallback.getEnemyTeams);
	}
	int getEnemyTeamSize() const {
		return gCallback.getEnemyTeams(gSkirmishAIId, null, -1) - 1;  // -1 for Gaia team :(
	}

	T[] getAlliedTeams(T : CTeam = CTeam)() {
		return makeEntityVec!T(gCallback.getAlliedTeams);
	}

	// NB : may contain nulls
	TU[] getEnemyUnits() {
		return makeEntityPoolVec(gCallback.getEnemyUnits, _units);
	}
	int[] getEnemyUnitIds() {
		return fillIdVec(gCallback.getEnemyUnits);
	}

	// NB : may contain nulls
	TU[] getEnemyUnitsIn()(in SFloat4 pos, float radius, bool spherical = true) {
		return makeEntityPoolVec(gCallback.getEnemyUnitsIn, _units, pos, radius, spherical);
	}
	int[] getEnemyUnitIdsIn()(in SFloat4 pos, float radius, bool spherical = true) {
		return fillIdVec(gCallback.getEnemyUnitsIn, pos, radius, spherical);
	}

	// NB : may contain nulls
	TU[] getEnemyUnitsInRadarAndLos() {
		return makeEntityPoolVec(gCallback.getEnemyUnitsInRadarAndLos, _units);
	}
	int[] getEnemyUnitIdsInRadarAndLos() {
		return fillIdVec(gCallback.getEnemyUnitsInRadarAndLos);
	}

	// NB : may contain nulls
	TU[] getFriendlyUnits() {
		return makeEntityPoolVec(gCallback.getFriendlyUnits, _units);
	}
	int[] getFriendlyUnitIds() {
		return fillIdVec(gCallback.getFriendlyUnits);
	}

	// NB : may contain nulls
	TU[] getFriendlyUnitsIn(in SFloat4 pos, float radius, bool spherical = true) {
		return makeEntityPoolVec(gCallback.getFriendlyUnitsIn, _units, pos, radius, spherical);
	}
	int[] getFriendlyUnitIdsIn(in SFloat4 pos, float radius, bool spherical = true) {
		return fillIdVec(gCallback.getFriendlyUnitsIn, pos, radius, spherical);
	}
	bool isFriendlyUnitsIn(in SFloat4 pos, float radius, bool spherical = true) const {
		return gCallback.getFriendlyUnitsIn(gSkirmishAIId, pos.ptr, radius, spherical, null, -1) > 0;
	}

	// NB : may contain nulls
	TU[] getNeutralUnits() {
		return makeEntityPoolVec(gCallback.getNeutralUnits, _units);
	}
	int[] getNeutralUnitIds() {
		return fillIdVec(gCallback.getNeutralUnits);
	}

	// NB : may contain nulls
	TU[] getNeutralUnitsIn(in SFloat4 pos, float radius, bool spherical = true) {
		return makeEntityPoolVec(gCallback.getNeutralUnitsIn, _units, pos, radius, spherical);
	}
	int[] getNeutralUnitIdsIn(in SFloat4 pos, float radius, bool spherical = true) {
		return fillIdVec(gCallback.getNeutralUnitsIn, pos, radius, spherical);
	}
	bool isNeutralUnitsIn(in SFloat4 pos, float radius, bool spherical = true) const {
		return gCallback.getNeutralUnitsIn(gSkirmishAIId, pos.ptr, radius, spherical, null, -1) > 0;
	}

	// NB : may contain nulls
	TU[] getTeamUnits() {
		return makeEntityPoolVec(gCallback.getTeamUnits, _units);
	}
	int[] getTeamUnitIds() {
		return fillIdVec(gCallback.getTeamUnits);
	}

	// NB : may contain nulls
	TU[] getSelectedUnits() {
		return makeEntityPoolVec(gCallback.getSelectedUnits, _units);
	}
	int[] getSelectedUnitIds() {
		return fillIdVec(gCallback.getSelectedUnits);
	}

	T[] getFeatureDefs(T : CFeatureDef = CFeatureDef)() {
		return makeEntityVec!T(gCallback.getFeatureDefs);
	}

	// NB : may contain nulls
	TF[] getFeatures() {
		return makeEntityPoolVec(gCallback.getFeatures, _features);
	}
	bool hasFeatures() const {  // NB: geo spot is a Feature
		return gCallback.getFeatures(gSkirmishAIId, null, -1) > 0;
	}

	// NB : may contain nulls
	TF[] getFeaturesIn(in SFloat4 pos, float radius, bool spherical = true) {
		return makeEntityPoolVec(gCallback.getFeaturesIn, _features, pos, radius, spherical);
	}
	bool isFeaturesIn(in SFloat4 pos, float radius, bool spherical = true) const {
		return gCallback.getFeaturesIn(gSkirmishAIId, pos.ptr, radius, spherical, null, -1) > 0;
	}

	T[] getGroups(T : CGroup = CGroup)() {
		return makeEntityVec!T(gCallback.getGroups);
	}

	T[] getResources(T = CResource)() const {
		int size = gCallback.getResources(gSkirmishAIId);
		T[] resources;
		resources.reserve(size);
		foreach (i; 0 .. size)
			resources ~= new T(i);
		return resources;
	}

	T getResourceByName(T : CResource = CResource)(string resourceName) const
	in (resourceName) {
		int internal_ret = gCallback.getResourceByName(gSkirmishAIId, std.string.toStringz(resourceName));
		return (internal_ret < 0) ? null : new T(internal_ret);
	}

	T[] getUnitDefs(T : CUnitDef = CUnitDef)() {
		return makeEntityVec!T(gCallback.getUnitDefs);
	}

	T getUnitDefByName(T : CUnitDef = CUnitDef)(string unitName) const
	in (unitName) {
		int internal_ret = gCallback.getUnitDefByName(gSkirmishAIId, std.string.toStringz(unitName));
		return (internal_ret < 0) ? null : new T(internal_ret);
	}

	T[] getWeaponDefs(T : CWeaponDef = CWeaponDef)() {
		return makeEntityVec!T(gCallback.getWeaponDefs);
	}

	T getWeaponDefByName(T : CWeaponDef = CWeaponDef)(string weaponDefName) const
	in (weaponDefName) {
		return new T(gCallback.getWeaponDefByName(gSkirmishAIId, std.string.toStringz(weaponDefName)));
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

	SSkirmishAI getSkirmishAI() const {
		return SSkirmishAI();
	}
	SPathing getPathing() const {
		return SPathing();
	}
	CEconomy getEconomy() const {
		return new CEconomy();
	}
	SGame getGame() const {
		return SGame();
	}
	SCheats getCheats() const {
		return SCheats();
	}
	CMap getMap() const {
		return new CMap();
	}
	SLog getLog() const {
		return SLog();
	}
	SDebugDrawer getDebugDrawer() const {
		return SDebugDrawer();
	}
	SFile getFile() const {
		return SFile();
	}
	SLua getLua() const {
		return SLua();
	}
	SMod getMod() const {
		return SMod();
	}
	SEngine getEngine() const {
		return SEngine();
	}

private:
	int[] _ids;
	TU[] _units;
	TF[] _features;

	T[] makeEntityVec(T, F)(F readIds) {  // Target, Function types
		int size = readIds(gSkirmishAIId, _ids.ptr, cast(int)_ids.length);
		int[] sliceIds = _ids[0..size];
		T[] ents;
		ents.reserve(size);
		foreach (eid; sliceIds)
			ents ~= new T(eid);
		return ents;
	}

	T[] makeEntityPoolVec(T, F, V...)(F readIds, ref T[] buffer, in V va) {  // Target, Function, Variadic types
		static assert(va.length < 4);

		int size;
		static if (va.length > 0) {
			size = readIds(gSkirmishAIId, va[0].ptr, va[1], va[2], _ids.ptr, cast(int)_ids.length);
		} else {
			size = readIds(gSkirmishAIId, _ids.ptr, cast(int)_ids.length);
		}
		int[] sliceIds = _ids[0..size];
		foreach (i, eid; sliceIds)
			buffer[i] = T.getInstance!T(eid);
		return buffer[0..size];
	}

	int[] fillIdVec(F, V...)(F readIds, V va) {  // Function, Variadic types
		static assert(va.length < 4);

		int size;
		static if (va.length > 0) {
			size = readIds(gSkirmishAIId, va[0].ptr, va[1], va[2], _ids.ptr, cast(int)_ids.length);
		} else {
			size = readIds(gSkirmishAIId, _ids.ptr, cast(int)_ids.length);
		}
		return _ids[0..size];
	}
}
