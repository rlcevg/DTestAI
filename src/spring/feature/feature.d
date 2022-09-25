module spring.feature.feature;

import spring.bind.callback;
import spring.feature.feature_def;
import spring.util.float4;
static import std.conv;
static import std.string;

class CFeature : AEntityPool {
	this(int _id) pure in (_id >= 0) { super(_id); }

	static bool isResurrectable(int featureId) {
		return gCallback.Feature_getResurrectDef(gSkirmishAIId, featureId) != -1;
	}

	T getDef(T : CFeatureDef = CFeatureDef)() const {
		return new T(gCallback.Feature_getDef(gSkirmishAIId, id));
	}
	int getDefId() const {
		return gCallback.Feature_getDef(gSkirmishAIId, id);
	}

	float getHealth() const {
		return gCallback.Feature_getHealth(gSkirmishAIId, id);
	}

	float getReclaimLeft() const {
		return gCallback.Feature_getReclaimLeft(gSkirmishAIId, id);
	}

	SFloat4 getPosition() const {
		SFloat4 posF3_out;
		gCallback.Feature_getPosition(gSkirmishAIId, id, posF3_out.ptr);
		return posF3_out;
	}

	float getRulesParamFloat(string rulesParamName, float defaultValue) const
	in (rulesParamName) {
		return gCallback.Feature_getRulesParamFloat(gSkirmishAIId, id, std.string.toStringz(rulesParamName), defaultValue);
	}

	string getRulesParamString(string rulesParamName, string defaultValue) const
	in (rulesParamName)
	in (defaultValue) {
		return std.conv.to!string(gCallback.Feature_getRulesParamString(gSkirmishAIId, id,
				std.string.toStringz(rulesParamName), std.string.toStringz(defaultValue)));
	}

	int getResurrectDef() const {
		return gCallback.Feature_getResurrectDef(gSkirmishAIId, id);
	}

	short getBuildingFacing() const {
		return gCallback.Feature_getBuildingFacing(gSkirmishAIId, id);
	}
}
