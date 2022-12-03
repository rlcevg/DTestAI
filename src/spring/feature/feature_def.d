module spring.feature.feature_def;

import spring.bind.callback;
import spring.economy.resource;

struct SFeatureDef {
	mixin TEntity;

nothrow @nogc:
	const(char)* getName() const {
		return gCallback.FeatureDef_getName(gSkirmishAIId, id);
	}

	const(char)* getDescription() const {
		return gCallback.FeatureDef_getDescription(gSkirmishAIId, id);
	}

	float getContainedResource(in SResource resource) const {
		return gCallback.FeatureDef_getContainedResource(gSkirmishAIId, id, resource.id);
	}

	float getMaxHealth() const {
		return gCallback.FeatureDef_getMaxHealth(gSkirmishAIId, id);
	}

	float getReclaimTime() const {
		return gCallback.FeatureDef_getReclaimTime(gSkirmishAIId, id);
	}

	float getMass() const {
		return gCallback.FeatureDef_getMass(gSkirmishAIId, id);
	}

	bool isUpright() const {
		return gCallback.FeatureDef_isUpright(gSkirmishAIId, id);
	}

	int getDrawType() const {
		return gCallback.FeatureDef_getDrawType(gSkirmishAIId, id);
	}

	const(char)* getModelName() const {
		return gCallback.FeatureDef_getModelName(gSkirmishAIId, id);
	}

	int getResurrectable() const {
		return gCallback.FeatureDef_getResurrectable(gSkirmishAIId, id);
	}

	int getSmokeTime() const {
		return gCallback.FeatureDef_getSmokeTime(gSkirmishAIId, id);
	}

	bool isDestructable() const {
		return gCallback.FeatureDef_isDestructable(gSkirmishAIId, id);
	}

	bool isReclaimable() const {
		return gCallback.FeatureDef_isReclaimable(gSkirmishAIId, id);
	}

	bool isAutoreclaimable() const {
		return gCallback.FeatureDef_isAutoreclaimable(gSkirmishAIId, id);
	}

	bool isBlocking() const {
		return gCallback.FeatureDef_isBlocking(gSkirmishAIId, id);
	}

	bool isBurnable() const {
		return gCallback.FeatureDef_isBurnable(gSkirmishAIId, id);
	}

	bool isFloating() const {
		return gCallback.FeatureDef_isFloating(gSkirmishAIId, id);
	}

	bool isNoSelect() const {
		return gCallback.FeatureDef_isNoSelect(gSkirmishAIId, id);
	}

	bool isGeoThermal() const {
		 return gCallback.FeatureDef_isGeoThermal(gSkirmishAIId, id);
	}

	int getXSize() const {
		return gCallback.FeatureDef_getXSize(gSkirmishAIId, id);
	}

	int getZSize() const {
		return gCallback.FeatureDef_getZSize(gSkirmishAIId, id);
	}

	import dplug.core.map;
	mixin TCustomParam;
	Map!(const(char)*, const(char)*) getCustomParams() const {
		return readCustomParams(gCallback.FeatureDef_getCustomParams);
	}
}
