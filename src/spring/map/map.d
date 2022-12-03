module spring.map.map;

import spring.bind.callback;
import spring.bind.defines;
import spring.drawer.drawer;
import spring.economy.resource;
import spring.unit.unit_def;
import spring.util.float4;
import spring.map.point;
import spring.map.line;
import dplug.core.nogc;
import dplug.core.vec;

class CMap {
nothrow @nogc:
	SDrawer getDrawer() const {
		return SDrawer();
	}

	int getChecksum() const {
		return gCallback.Map_getChecksum(gSkirmishAIId);
	}

	SFloat4 getStartPos() const {
		SFloat4 posF3_out;
		gCallback.Map_getStartPos(gSkirmishAIId, posF3_out.ptr);
		return posF3_out;
	}

	SFloat4 getMousePos() const {
		SFloat4 posF3_out;
		gCallback.Map_getMousePos(gSkirmishAIId, posF3_out.ptr);
		return posF3_out;
	}

	bool isPosInCamera(in SFloat4 pos, float radius) const {
		return gCallback.Map_isPosInCamera(gSkirmishAIId, pos.ptr, radius);
	}

	int getWidth() const {
		return gCallback.Map_getWidth(gSkirmishAIId);
	}

	int getHeight() const {
		return gCallback.Map_getHeight(gSkirmishAIId);
	}

	float[] getHeightMap(float[] heights = []) const {
		return fillVec(gCallback.Map_getHeightMap, heights);
	}

	float[] getCornersHeightMap(float[] cornerHeights = []) const {
		return fillVec(gCallback.Map_getCornersHeightMap, cornerHeights);
	}

	float getMinHeight() const {
		return gCallback.Map_getMinHeight(gSkirmishAIId);
	}

	float getMaxHeight() const {
		return gCallback.Map_getMaxHeight(gSkirmishAIId);
	}

	float[] getSlopeMap(float[] slopes = []) const {
		return fillVec(gCallback.Map_getSlopeMap, slopes);
	}

	int[] getLosMap(int[] losValues = []) const {
		return fillVec(gCallback.Map_getLosMap, losValues);
	}

	int[] getAirLosMap(int[] airLosValues = []) const {
		return fillVec(gCallback.Map_getAirLosMap, airLosValues);
	}

	int[] getRadarMap(int[] radarValues = []) const {
		return fillVec(gCallback.Map_getRadarMap, radarValues);
	}

	int[] getSonarMap(int[] sonarValues = []) const {
		return fillVec(gCallback.Map_getSonarMap, sonarValues);
	}

	int[] getSeismicMap(int[] seismicValues = []) const {
		return fillVec(gCallback.Map_getSeismicMap, seismicValues);
	}

	int[] getJammerMap(int[] jammerValues = []) const {
		return fillVec(gCallback.Map_getJammerMap, jammerValues);
	}

	int[] getSonarJammerMap(int[] sonarJammerValues = []) const {
		return fillVec(gCallback.Map_getSonarJammerMap, sonarJammerValues);
	}

	short[] getResourceMapRaw(in SResource resource, short[] resources = []) const {
		if (resources.length == 0)
			resources = mallocSliceNoInit!short(gCallback.Map_getResourceMapRaw(gSkirmishAIId, resource.id, null, -1));
		int size = gCallback.Map_getResourceMapRaw(gSkirmishAIId, resource.id, resources.ptr, cast(int)resources.length);
		return resources[0..size];
	}

	SFloat4[] getResourceMapSpotsPositions(in SResource resource, SFloat4[] spots = []) const {
		int spots_size_raw = gCallback.Map_getResourceMapSpotsPositions(gSkirmishAIId, resource.id, null, -1);
		if (spots_size_raw % 3 != 0)
			return [];  // error
		float[10_000 * 3] spots_AposF3;  // stack
		if (spots_size_raw < spots_AposF3.length)
			spots_size_raw = spots_AposF3.length;
		gCallback.Map_getResourceMapSpotsPositions(gSkirmishAIId, resource.id, spots_AposF3.ptr, spots_size_raw);
		int size = spots_size_raw / 3;
		if (spots.length == 0)
			spots = mallocSliceNoInit!SFloat4(size);
		foreach (i; 0 .. size)
			spots[i] = SFloat4(spots_AposF3[i * 3 + 0], spots_AposF3[i * 3 + 1], spots_AposF3[i * 3 + 2]);
		return spots[0..size];
	}

	float getResourceMapSpotsAverageIncome(in SResource resource) const {
		return gCallback.Map_getResourceMapSpotsAverageIncome(gSkirmishAIId, resource.id);
	}

	SFloat4 getResourceMapSpotsNearest(in SResource resource, in SFloat4 pos) const {
		SFloat4 posF3_out;
		gCallback.Map_getResourceMapSpotsNearest(gSkirmishAIId, resource.id, pos.ptr, posF3_out.ptr);
		return posF3_out;
	}

	int getHash() const {
		return gCallback.Map_getHash(gSkirmishAIId);
	}

	const(char)* getName() const {
		return gCallback.Map_getName(gSkirmishAIId);
	}

	const(char)* getHumanName() const {
		return gCallback.Map_getHumanName(gSkirmishAIId);
	}

	float getElevationAt(float x, float z) const {
		return gCallback.Map_getElevationAt(gSkirmishAIId, x, z);
	}

	float getMaxResource(in SResource resource) const {
		return gCallback.Map_getMaxResource(gSkirmishAIId, resource.id);
	}

	float getExtractorRadius(in SResource resource) const {
		return gCallback.Map_getExtractorRadius(gSkirmishAIId, resource.id);
	}

	float getMinWind() const {
		return gCallback.Map_getMinWind(gSkirmishAIId);
	}

	float getMaxWind() const {
		return gCallback.Map_getMaxWind(gSkirmishAIId);
	}

	float getTidalStrength() const {
		return gCallback.Map_getTidalStrength(gSkirmishAIId);
	}

	float getGravity() const {
		return gCallback.Map_getGravity(gSkirmishAIId);
	}

	float getWaterDamage() const {
		return gCallback.Map_getWaterDamage(gSkirmishAIId);
	}

	bool isDeformable() const {
		return gCallback.Map_isDeformable(gSkirmishAIId);
	}

	float getHardness() const {
		return gCallback.Map_getHardness(gSkirmishAIId);
	}

	float[] getHardnessModMap(float[] hardMods = []) const {
		return fillVec(gCallback.Map_getHardnessModMap, hardMods);
	}

	float[] getSpeedModMap(int speedModClass, float[] speedMods = []) const {
		if (speedMods.length == 0)
			speedMods = mallocSliceNoInit!float(gCallback.Map_getSpeedModMap(gSkirmishAIId, speedModClass, null, -1));
		int size = gCallback.Map_getSpeedModMap(gSkirmishAIId, speedModClass, speedMods.ptr, cast(int)speedMods.length);
		return speedMods[0..size];
	}

	SPoint[] getPoints(bool includeAllies) {
		return makeArray(gCallback.Map_getPoints, _points, includeAllies);
	}

	SLine[] getLines(bool includeAllies) {
		return makeArray(gCallback.Map_getLines, _lines, includeAllies);
	}

	bool isPossibleToBuildAt(in SUnitDef unitDef, in SFloat4 pos, UnitFacing facing) const {
		return gCallback.Map_isPossibleToBuildAt(gSkirmishAIId, unitDef.id, pos.ptr, facing);
	}

	SFloat4 findClosestBuildSite(in SUnitDef unitDef, in SFloat4 pos,
		float searchRadius, int minDist, UnitFacing facing) const
	{
		SFloat4 posF3_out;
		gCallback.Map_findClosestBuildSite(gSkirmishAIId, unitDef.id, pos.ptr,
				searchRadius, minDist, facing, posF3_out.ptr);
		return posF3_out;
	}

private:
	Vec!SPoint _points;
	Vec!SLine _lines;

	T[] fillVec(T, F)(F readValues, T[] values) const {
		if (values.length == 0)
			values = mallocSliceNoInit!T(readValues(gSkirmishAIId, null, -1));
		int size = readValues(gSkirmishAIId, values.ptr, cast(int)values.length);
		return values[0..size];
	}

	T[] makeArray(T, F)(F readSize, ref Vec!T buffer, bool includeAllies) {
		int lastSize = cast(int)buffer.length;
		int newSize = readSize(gSkirmishAIId, includeAllies);
		buffer.resize(newSize);
		foreach (i; lastSize .. newSize)
			buffer ~= T(i);
		return buffer[0..newSize];
	}
}
