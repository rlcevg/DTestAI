module spring.mod;

import spring.bind.callback;

class CMod {
nothrow @nogc:
	const(char)* getFileName() const {
		return gCallback.Mod_getFileName(gSkirmishAIId);
	}

	int getHash() const {
		return gCallback.Mod_getHash(gSkirmishAIId);
	}

	const(char)* getHumanName() const {
		return gCallback.Mod_getHumanName(gSkirmishAIId);
	}

	const(char)* getShortName() const {
		return gCallback.Mod_getShortName(gSkirmishAIId);
	}

	const(char)* getVersion() const {
		return gCallback.Mod_getVersion(gSkirmishAIId);
	}

	const(char)* getMutator() const {
		return gCallback.Mod_getMutator(gSkirmishAIId);
	}

	const(char)* getDescription() const {
		return gCallback.Mod_getDescription(gSkirmishAIId);
	}

	bool getConstructionDecay() const {
		return gCallback.Mod_getConstructionDecay(gSkirmishAIId);
	}

	int getConstructionDecayTime() const {
		return gCallback.Mod_getConstructionDecayTime(gSkirmishAIId);
	}

	float getConstructionDecaySpeed() const {
		return gCallback.Mod_getConstructionDecaySpeed(gSkirmishAIId);
	}

	int getMultiReclaim() const {
		return gCallback.Mod_getMultiReclaim(gSkirmishAIId);
	}

	int getReclaimMethod() const {
		return gCallback.Mod_getReclaimMethod(gSkirmishAIId);
	}

	int getReclaimUnitMethod() const {
		return gCallback.Mod_getReclaimUnitMethod(gSkirmishAIId);
	}

	float getReclaimUnitEnergyCostFactor() const {
		return gCallback.Mod_getReclaimUnitEnergyCostFactor(gSkirmishAIId);
	}

	float getReclaimUnitEfficiency() const {
		return gCallback.Mod_getReclaimUnitEfficiency(gSkirmishAIId);
	}

	float getReclaimFeatureEnergyCostFactor() const {
		return gCallback.Mod_getReclaimFeatureEnergyCostFactor(gSkirmishAIId);
	}

	bool getReclaimAllowEnemies() const {
		return gCallback.Mod_getReclaimAllowEnemies(gSkirmishAIId);
	}

	bool getReclaimAllowAllies() const {
		return gCallback.Mod_getReclaimAllowAllies(gSkirmishAIId);
	}

	float getRepairEnergyCostFactor() const {
		return gCallback.Mod_getRepairEnergyCostFactor(gSkirmishAIId);
	}

	float getResurrectEnergyCostFactor() const {
		return gCallback.Mod_getResurrectEnergyCostFactor(gSkirmishAIId);
	}

	float getCaptureEnergyCostFactor() const {
		return gCallback.Mod_getCaptureEnergyCostFactor(gSkirmishAIId);
	}

	int getTransportGround() const {
		return gCallback.Mod_getTransportGround(gSkirmishAIId);
	}

	int getTransportHover() const {
		return gCallback.Mod_getTransportHover(gSkirmishAIId);
	}

	int getTransportShip() const {
		return gCallback.Mod_getTransportShip(gSkirmishAIId);
	}

	int getTransportAir() const {
		return gCallback.Mod_getTransportAir(gSkirmishAIId);
	}

	int getFireAtKilled() const {
		return gCallback.Mod_getFireAtKilled(gSkirmishAIId);
	}

	int getFireAtCrashing() const {
		return gCallback.Mod_getFireAtCrashing(gSkirmishAIId);
	}

	int getFlankingBonusModeDefault() const {
		return gCallback.Mod_getFlankingBonusModeDefault(gSkirmishAIId);
	}

	int getLosMipLevel() const {
		return gCallback.Mod_getLosMipLevel(gSkirmishAIId);
	}

	int getAirMipLevel() const {
		return gCallback.Mod_getAirMipLevel(gSkirmishAIId);
	}

	int getRadarMipLevel() const {
		return gCallback.Mod_getRadarMipLevel(gSkirmishAIId);
	}

	bool getRequireSonarUnderWater() const {
		return gCallback.Mod_getRequireSonarUnderWater(gSkirmishAIId);
	}
}
