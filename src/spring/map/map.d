module spring.map.map;

import spring.bind.callback;
import spring.bind.defines;
import spring.drawer.drawer;
import spring.economy.resource;
import spring.unit.unit_def;
import spring.util.float4;
import spring.map.point;
import spring.map.line;
static import std.conv;

class CMap {
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

	void getHeightMap(ref float[] heights) const {
		fillVec(gCallback.Map_getHeightMap, heights);
	}

	void getCornersHeightMap(ref float[] cornerHeights) const {
		fillVec(gCallback.Map_getCornersHeightMap, cornerHeights);
	}

	float getMinHeight() const {
		return gCallback.Map_getMinHeight(gSkirmishAIId);
	}

	float getMaxHeight() const {
		return gCallback.Map_getMaxHeight(gSkirmishAIId);
	}

	void getSlopeMap(ref float[] slopes) const {
		fillVec(gCallback.Map_getSlopeMap, slopes);
	}

	void getLosMap(ref int[] losValues) const {
		fillVec(gCallback.Map_getLosMap, losValues);
	}

	void getAirLosMap(ref int[] airLosValues) const {
		fillVec(gCallback.Map_getAirLosMap, airLosValues);
	}

	void getRadarMap(ref int[] radarValues) const {
		fillVec(gCallback.Map_getRadarMap, radarValues);
	}

	void getSonarMap(ref int[] sonarValues) const {
		fillVec(gCallback.Map_getSonarMap, sonarValues);
	}

	void getSeismicMap(ref int[] seismicValues) const {
		fillVec(gCallback.Map_getSeismicMap, seismicValues);
	}

	void getJammerMap(ref int[] jammerValues) const {
		fillVec(gCallback.Map_getJammerMap, jammerValues);
	}

	void getSonarJammerMap(ref int[] sonarJammerValues) const {
		fillVec(gCallback.Map_getSonarJammerMap, sonarJammerValues);
	}

	short[] getResourceMapRaw(in SResource resource) const {
		short[] resources = new short [gCallback.Map_getResourceMapRaw(gSkirmishAIId, resource.id, null, -1)];
		gCallback.Map_getResourceMapRaw(gSkirmishAIId, resource.id, resources.ptr, cast(int)resources.length);
		return resources;
	}

	SFloat4[] getResourceMapSpotsPositions(in SResource resource) const {
		int spots_size_raw = gCallback.Map_getResourceMapSpotsPositions(gSkirmishAIId, resource.id, null, -1);
		if (spots_size_raw % 3 != 0)
			return [];  // error
		float[] spots_AposF3 = new float [spots_size_raw];  // spots_AposF3.destroy();
		gCallback.Map_getResourceMapSpotsPositions(gSkirmishAIId, resource.id, spots_AposF3.ptr, spots_size_raw);
		SFloat4[] spots;
		spots.reserve(spots_size_raw / 3);
		for (int i = 0; i < spots_size_raw; i += 3)
			spots ~= SFloat4(spots_AposF3[i], spots_AposF3[i + 1], spots_AposF3[i + 2]);
		return spots;
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

	string getName() const {
		return std.conv.to!string(gCallback.Map_getName(gSkirmishAIId));
	}

	string getHumanName() const {
		return std.conv.to!string(gCallback.Map_getHumanName(gSkirmishAIId));
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

	float[] getHardnessModMap() const {
		float[] hardMods;
		fillVec(gCallback.Map_getHardnessModMap, hardMods);
		return hardMods;
	}

	float[] getSpeedModMap(int speedModClass) const {
		float[] speedMods = new float [gCallback.Map_getSpeedModMap(gSkirmishAIId, speedModClass, null, -1)];
		gCallback.Map_getSpeedModMap(gSkirmishAIId, speedModClass, speedMods.ptr, cast(int)speedMods.length);
		return speedMods;
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
	SPoint[] _points;
	SLine[] _lines;

	void fillVec(T, F)(F readValues, ref T[] values) const {
		if (values.length == 0)
			values.length = readValues(gSkirmishAIId, null, -1);
		readValues(gSkirmishAIId, values.ptr, cast(int)values.length);
	}

	T[] makeArray(T, F)(F readSize, ref T[] buffer, bool includeAllies) {
		int lastSize = cast(int)buffer.length;
		int newSize = readSize(gSkirmishAIId, includeAllies);
		buffer.reserve(newSize);
		foreach (i; lastSize .. newSize)
			buffer ~= T(i);
		return buffer[0..newSize];
	}
}
