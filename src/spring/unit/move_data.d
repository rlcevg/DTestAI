module spring.unit.move_data;

import spring.bind.callback;
static import std.conv;

struct SMoveData {
	mixin TEntity;  // unitDefId

	int getSpeedModClass() const {
		return gCallback.UnitDef_MoveData_getSpeedModClass(gSkirmishAIId, id);
	}

	int getXSize() const {
		return gCallback.UnitDef_MoveData_getXSize(gSkirmishAIId, id);
	}

	int getZSize() const {
		return gCallback.UnitDef_MoveData_getZSize(gSkirmishAIId, id);
	}

	float getDepth() const {
		return gCallback.UnitDef_MoveData_getDepth(gSkirmishAIId, id);
	}

	float getMaxSlope() const {
		return gCallback.UnitDef_MoveData_getMaxSlope(gSkirmishAIId, id);
	}

	float getSlopeMod() const {
		return gCallback.UnitDef_MoveData_getSlopeMod(gSkirmishAIId, id);
	}

	float getDepthMod(float height) const {
		return gCallback.UnitDef_MoveData_getDepthMod(gSkirmishAIId, id, height);
	}

	int getPathType() const {
		return gCallback.UnitDef_MoveData_getPathType(gSkirmishAIId, id);
	}

	float getCrushStrength() const {
		return gCallback.UnitDef_MoveData_getCrushStrength(gSkirmishAIId, id);
	}

	bool getFollowGround() const {
		return gCallback.UnitDef_MoveData_getFollowGround(gSkirmishAIId, id);
	}

	bool isSubMarine() const {
		return gCallback.UnitDef_MoveData_isSubMarine(gSkirmishAIId, id);
	}

	string getName() const {
		return std.conv.to!string(gCallback.UnitDef_MoveData_getName(gSkirmishAIId, id));
	}
}
