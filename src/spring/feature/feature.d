module spring.feature.feature;

import spring.bind.callback;
import spring.feature.feature_def;
import spring.util.float4;

struct SFeature {
	mixin TEntity;

nothrow @nogc:
	static bool isResurrectable(int featureId) {
		return gCallback.Feature_getResurrectDef(gSkirmishAIId, featureId) != -1;
	}

	SFeatureDef getDef() const {
		return SFeatureDef(gCallback.Feature_getDef(gSkirmishAIId, id));
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

	float getRulesParamFloat(const(char)* rulesParamName, float defaultValue) const
	in (rulesParamName) {
		return gCallback.Feature_getRulesParamFloat(gSkirmishAIId, id, rulesParamName, defaultValue);
	}

	const(char)* getRulesParamString(const(char)* rulesParamName, const(char)* defaultValue) const
	in (rulesParamName)
	in (defaultValue) {
		return gCallback.Feature_getRulesParamString(gSkirmishAIId, id,
				rulesParamName, defaultValue);
	}

	int getResurrectDef() const {
		return gCallback.Feature_getResurrectDef(gSkirmishAIId, id);
	}

	short getBuildingFacing() const {
		return gCallback.Feature_getBuildingFacing(gSkirmishAIId, id);
	}
}
