module spring.unit.unit_def;

import spring.bind.callback;
import spring.bind.defines;
import spring.economy.resource;
import spring.unit.flanking_bonus;
import spring.unit.move_data;
import spring.weapon.weapon_mount;
import spring.util.float4;
import dplug.core.nogc;

struct SUnitDef {
	mixin TEntity;

nothrow @nogc:
	static bool hasYardMap(int unitDefId) {
		return gCallback.UnitDef_getYardMap(gSkirmishAIId, unitDefId, UnitFacing.UNIT_FACING_SOUTH, null, -1) > 0;
	}

	SFlankingBonus getFlankingBonus() const {
		return SFlankingBonus(id);
	}

	SMoveData getMoveData() const {
		return SMoveData(id);
	}

	float getHeight() const {
		return gCallback.UnitDef_getHeight(gSkirmishAIId, id);
	}

	float getRadius() const {
		return gCallback.UnitDef_getRadius(gSkirmishAIId, id);
	}

	const(char)* getName() const {
		return gCallback.UnitDef_getName(gSkirmishAIId, id);
	}

	const(char)* getHumanName() const {
		return gCallback.UnitDef_getHumanName(gSkirmishAIId, id);
	}

	float getUpkeep(in SResource resource) const {
		return gCallback.UnitDef_getUpkeep(gSkirmishAIId, id, resource.id);
	}

	float getResourceMake(in SResource resource) const {
		return gCallback.UnitDef_getResourceMake(gSkirmishAIId, id, resource.id);
	}

	float getMakesResource(in SResource resource) const {
		return gCallback.UnitDef_getMakesResource(gSkirmishAIId, id, resource.id);
	}

	float getCost(in SResource resource) const {
		return gCallback.UnitDef_getCost(gSkirmishAIId, id, resource.id);
	}

	float getExtractsResource(in SResource resource) const {
		return gCallback.UnitDef_getExtractsResource(gSkirmishAIId, id, resource.id);
	}

	float getResourceExtractorRange(in SResource resource) const {
		return gCallback.UnitDef_getResourceExtractorRange(gSkirmishAIId, id, resource.id);
	}

	float getWindResourceGenerator(in SResource resource) const {
		return gCallback.UnitDef_getWindResourceGenerator(gSkirmishAIId, id, resource.id);
	}

	float getTidalResourceGenerator(in SResource resource) const {
		return gCallback.UnitDef_getTidalResourceGenerator(gSkirmishAIId, id, resource.id);
	}

	float getStorage(in SResource resource) const {
		return gCallback.UnitDef_getStorage(gSkirmishAIId, id, resource.id);
	}

	float getBuildTime() const {
		return gCallback.UnitDef_getBuildTime(gSkirmishAIId, id);
	}

	float getAutoHeal() const {
		return gCallback.UnitDef_getAutoHeal(gSkirmishAIId, id);
	}

	float getIdleAutoHeal() const {
		return gCallback.UnitDef_getIdleAutoHeal(gSkirmishAIId, id);
	}

	int getIdleTime() const {
		return gCallback.UnitDef_getIdleTime(gSkirmishAIId, id);
	}

	float getPower() const {
		return gCallback.UnitDef_getPower(gSkirmishAIId, id);
	}

	float getHealth() const {
		return gCallback.UnitDef_getHealth(gSkirmishAIId, id);
	}

	int getCategory() const {
		return gCallback.UnitDef_getCategory(gSkirmishAIId, id);
	}

	float getSpeed() const {
		return gCallback.UnitDef_getSpeed(gSkirmishAIId, id);
	}

	float getTurnRate() const {
		return gCallback.UnitDef_getTurnRate(gSkirmishAIId, id);
	}

	bool isTurnInPlace() const {
		return gCallback.UnitDef_isTurnInPlace(gSkirmishAIId, id);
	}

	float getTurnInPlaceDistance() const {
		return gCallback.UnitDef_getTurnInPlaceDistance(gSkirmishAIId, id);
	}

	float getTurnInPlaceSpeedLimit() const {
		return gCallback.UnitDef_getTurnInPlaceSpeedLimit(gSkirmishAIId, id);
	}

	bool isUpright() const {
		return gCallback.UnitDef_isUpright(gSkirmishAIId, id);
	}

	bool isCollide() const {
		return gCallback.UnitDef_isCollide(gSkirmishAIId, id);
	}

	float getLosRadius() const {
		return gCallback.UnitDef_getLosRadius(gSkirmishAIId, id);
	}

	float getAirLosRadius() const {
		return gCallback.UnitDef_getAirLosRadius(gSkirmishAIId, id);
	}

	float getLosHeight() const {
		return gCallback.UnitDef_getLosHeight(gSkirmishAIId, id);
	}

	int getRadarRadius() const {
		return gCallback.UnitDef_getRadarRadius(gSkirmishAIId, id);
	}

	int getSonarRadius() const {
		return gCallback.UnitDef_getSonarRadius(gSkirmishAIId, id);
	}

	int getJammerRadius() const {
		return gCallback.UnitDef_getJammerRadius(gSkirmishAIId, id);
	}

	int getSonarJamRadius() const {
		return gCallback.UnitDef_getSonarJamRadius(gSkirmishAIId, id);
	}

	int getSeismicRadius() const {
		return gCallback.UnitDef_getSeismicRadius(gSkirmishAIId, id);
	}

	float getSeismicSignature() const {
		return gCallback.UnitDef_getSeismicSignature(gSkirmishAIId, id);
	}

	bool isStealth() const {
		return gCallback.UnitDef_isStealth(gSkirmishAIId, id);
	}

	bool isSonarStealth() const {
		return gCallback.UnitDef_isSonarStealth(gSkirmishAIId, id);
	}

	bool isBuildRange3D() const {
		return gCallback.UnitDef_isBuildRange3D(gSkirmishAIId, id);
	}

	float getBuildDistance() const {
		return gCallback.UnitDef_getBuildDistance(gSkirmishAIId, id);
	}

	float getBuildSpeed() const {
		return gCallback.UnitDef_getBuildSpeed(gSkirmishAIId, id);
	}

	float getReclaimSpeed() const {
		return gCallback.UnitDef_getReclaimSpeed(gSkirmishAIId, id);
	}

	float getRepairSpeed() const {
		return gCallback.UnitDef_getRepairSpeed(gSkirmishAIId, id);
	}

	float getMaxRepairSpeed() const {
		return gCallback.UnitDef_getMaxRepairSpeed(gSkirmishAIId, id);
	}

	float getResurrectSpeed() const {
		return gCallback.UnitDef_getResurrectSpeed(gSkirmishAIId, id);
	}

	float getCaptureSpeed() const {
		return gCallback.UnitDef_getCaptureSpeed(gSkirmishAIId, id);
	}

	float getTerraformSpeed() const {
		return gCallback.UnitDef_getTerraformSpeed(gSkirmishAIId, id);
	}

	float getUpDirSmoothing() const {
		return gCallback.UnitDef_getUpDirSmoothing(gSkirmishAIId, id);
	}

	float getMass() const {
		return gCallback.UnitDef_getMass(gSkirmishAIId, id);
	}

	bool isPushResistant() const {
		return gCallback.UnitDef_isPushResistant(gSkirmishAIId, id);
	}

	bool isStrafeToAttack() const {
		return gCallback.UnitDef_isStrafeToAttack(gSkirmishAIId, id);
	}

	float getMinCollisionSpeed() const {
		return gCallback.UnitDef_getMinCollisionSpeed(gSkirmishAIId, id);
	}

	float getSlideTolerance() const {
		return gCallback.UnitDef_getSlideTolerance(gSkirmishAIId, id);
	}

	float getMaxHeightDif() const {
		return gCallback.UnitDef_getMaxHeightDif(gSkirmishAIId, id);
	}

	float getMinWaterDepth() const {
		return gCallback.UnitDef_getMinWaterDepth(gSkirmishAIId, id);
	}

	float getWaterline() const {
		return gCallback.UnitDef_getWaterline(gSkirmishAIId, id);
	}

	float getMaxWaterDepth() const {
		return gCallback.UnitDef_getMaxWaterDepth(gSkirmishAIId, id);
	}

	float getArmoredMultiple() const {
		return gCallback.UnitDef_getArmoredMultiple(gSkirmishAIId, id);
	}

	int getArmorType() const {
		return gCallback.UnitDef_getArmorType(gSkirmishAIId, id);
	}

	float getMaxWeaponRange() const {
		return gCallback.UnitDef_getMaxWeaponRange(gSkirmishAIId, id);
	}

	const(char)* getTooltip() const {
		return gCallback.UnitDef_getTooltip(gSkirmishAIId, id);
	}

	const(char)* getWreckName() const {
		return gCallback.UnitDef_getWreckName(gSkirmishAIId, id);
	}

	int getDeathExplosion() const {
		return gCallback.UnitDef_getDeathExplosion(gSkirmishAIId, id);
	}

	int getSelfDExplosion() const {
		return gCallback.UnitDef_getSelfDExplosion(gSkirmishAIId, id);
	}

	const(char)* getCategoryString() const {
		return gCallback.UnitDef_getCategoryString(gSkirmishAIId, id);
	}

	bool isAbleToSelfD() const {
		return gCallback.UnitDef_isAbleToSelfD(gSkirmishAIId, id);
	}

	int getSelfDCountdown() const {
		return gCallback.UnitDef_getSelfDCountdown(gSkirmishAIId, id);
	}

	bool isAbleToSubmerge() const {
		return gCallback.UnitDef_isAbleToSubmerge(gSkirmishAIId, id);
	}

	bool isAbleToFly() const {
		return gCallback.UnitDef_isAbleToFly(gSkirmishAIId, id);
	}

	bool isAbleToMove() const {
		return gCallback.UnitDef_isAbleToMove(gSkirmishAIId, id);
	}

	bool isAbleToHover() const {
		return gCallback.UnitDef_isAbleToHover(gSkirmishAIId, id);
	}

	bool isFloater() const {
		return gCallback.UnitDef_isFloater(gSkirmishAIId, id);
	}

	bool isBuilder() const {
		return gCallback.UnitDef_isBuilder(gSkirmishAIId, id);
	}

	bool isActivateWhenBuilt() const {
		return gCallback.UnitDef_isActivateWhenBuilt(gSkirmishAIId, id);
	}

	bool isOnOffable() const {
		return gCallback.UnitDef_isOnOffable(gSkirmishAIId, id);
	}

	bool isFullHealthFactory() const {
		return gCallback.UnitDef_isFullHealthFactory(gSkirmishAIId, id);
	}

	bool isFactoryHeadingTakeoff() const {
		return gCallback.UnitDef_isFactoryHeadingTakeoff(gSkirmishAIId, id);
	}

	bool isReclaimable() const {
		return gCallback.UnitDef_isReclaimable(gSkirmishAIId, id);
	}

	bool isCapturable() const {
		return gCallback.UnitDef_isCapturable(gSkirmishAIId, id);
	}

	bool isAbleToRestore() const {
		return gCallback.UnitDef_isAbleToRestore(gSkirmishAIId, id);
	}

	bool isAbleToRepair() const {
		return gCallback.UnitDef_isAbleToRepair(gSkirmishAIId, id);
	}

	bool isAbleToSelfRepair() const {
		return gCallback.UnitDef_isAbleToSelfRepair(gSkirmishAIId, id);
	}

	bool isAbleToReclaim() const {
		return gCallback.UnitDef_isAbleToReclaim(gSkirmishAIId, id);
	}

	bool isAbleToAttack() const {
		return gCallback.UnitDef_isAbleToAttack(gSkirmishAIId, id);
	}

	bool isAbleToPatrol() const {
		return gCallback.UnitDef_isAbleToPatrol(gSkirmishAIId, id);
	}

	bool isAbleToFight() const {
		return gCallback.UnitDef_isAbleToFight(gSkirmishAIId, id);
	}

	bool isAbleToGuard() const {
		return gCallback.UnitDef_isAbleToGuard(gSkirmishAIId, id);
	}

	bool isAbleToAssist() const {
		return gCallback.UnitDef_isAbleToAssist(gSkirmishAIId, id);
	}

	bool isAssistable() const {
		return gCallback.UnitDef_isAssistable(gSkirmishAIId, id);
	}

	bool isAbleToRepeat() const {
		return gCallback.UnitDef_isAbleToRepeat(gSkirmishAIId, id);
	}

	bool isAbleToFireControl() const {
		return gCallback.UnitDef_isAbleToFireControl(gSkirmishAIId, id);
	}

	int getFireState() const {
		return gCallback.UnitDef_getFireState(gSkirmishAIId, id);
	}

	int getMoveState() const {
		return gCallback.UnitDef_getMoveState(gSkirmishAIId, id);
	}

	float getWingDrag() const {
		return gCallback.UnitDef_getWingDrag(gSkirmishAIId, id);
	}

	float getWingAngle() const {
		return gCallback.UnitDef_getWingAngle(gSkirmishAIId, id);
	}

	float getFrontToSpeed() const {
		return gCallback.UnitDef_getFrontToSpeed(gSkirmishAIId, id);
	}

	float getSpeedToFront() const {
		return gCallback.UnitDef_getSpeedToFront(gSkirmishAIId, id);
	}

	float getMyGravity() const {
		return gCallback.UnitDef_getMyGravity(gSkirmishAIId, id);
	}

	float getMaxBank() const {
		return gCallback.UnitDef_getMaxBank(gSkirmishAIId, id);
	}

	float getMaxPitch() const {
		return gCallback.UnitDef_getMaxPitch(gSkirmishAIId, id);
	}

	float getTurnRadius() const {
		return gCallback.UnitDef_getTurnRadius(gSkirmishAIId, id);
	}

	float getWantedHeight() const {
		return gCallback.UnitDef_getWantedHeight(gSkirmishAIId, id);
	}

	float getVerticalSpeed() const {
		return gCallback.UnitDef_getVerticalSpeed(gSkirmishAIId, id);
	}

	bool isHoverAttack() const {
		return gCallback.UnitDef_isHoverAttack(gSkirmishAIId, id);
	}

	bool isAirStrafe() const {
		return gCallback.UnitDef_isAirStrafe(gSkirmishAIId, id);
	}

	float getDlHoverFactor() const {
		return gCallback.UnitDef_getDlHoverFactor(gSkirmishAIId, id);
	}

	float getMaxAcceleration() const {
		return gCallback.UnitDef_getMaxAcceleration(gSkirmishAIId, id);
	}

	float getMaxDeceleration() const {
		return gCallback.UnitDef_getMaxDeceleration(gSkirmishAIId, id);
	}

	float getMaxAileron() const {
		return gCallback.UnitDef_getMaxAileron(gSkirmishAIId, id);
	}

	float getMaxElevator() const {
		return gCallback.UnitDef_getMaxElevator(gSkirmishAIId, id);
	}

	float getMaxRudder() const {
		return gCallback.UnitDef_getMaxRudder(gSkirmishAIId, id);
	}

	short[] getYardMap(UnitFacing facing) const {
		short[] yardMap = mallocSliceNoInit!short(gCallback.UnitDef_getYardMap(gSkirmishAIId, id, facing, null, -1));
		gCallback.UnitDef_getYardMap(gSkirmishAIId, id, facing, yardMap.ptr, cast(int)yardMap.length);
		return yardMap;
	}

	int getXSize() const {
		return gCallback.UnitDef_getXSize(gSkirmishAIId, id);
	}

	int getZSize() const {
		return gCallback.UnitDef_getZSize(gSkirmishAIId, id);
	}

	float getLoadingRadius() const {
		return gCallback.UnitDef_getLoadingRadius(gSkirmishAIId, id);
	}

	float getUnloadSpread() const {
		return gCallback.UnitDef_getUnloadSpread(gSkirmishAIId, id);
	}

	int getTransportCapacity() const {
		return gCallback.UnitDef_getTransportCapacity(gSkirmishAIId, id);
	}

	int getTransportSize() const {
		return gCallback.UnitDef_getTransportSize(gSkirmishAIId, id);
	}

	int getMinTransportSize() const {
		return gCallback.UnitDef_getMinTransportSize(gSkirmishAIId, id);
	}

	bool isAirBase() const {
		return gCallback.UnitDef_isAirBase(gSkirmishAIId, id);
	}

	bool isFirePlatform() const {
		return gCallback.UnitDef_isFirePlatform(gSkirmishAIId, id);
	}

	float getTransportMass() const {
		return gCallback.UnitDef_getTransportMass(gSkirmishAIId, id);
	}

	float getMinTransportMass() const {
		return gCallback.UnitDef_getMinTransportMass(gSkirmishAIId, id);
	}

	bool isHoldSteady() const {
		return gCallback.UnitDef_isHoldSteady(gSkirmishAIId, id);
	}

	bool isReleaseHeld() const {
		return gCallback.UnitDef_isReleaseHeld(gSkirmishAIId, id);
	}

	bool isNotTransportable() const {
		return gCallback.UnitDef_isNotTransportable(gSkirmishAIId, id);
	}

	bool isTransportByEnemy() const {
		return gCallback.UnitDef_isTransportByEnemy(gSkirmishAIId, id);
	}

	int getTransportUnloadMethod() const {
		return gCallback.UnitDef_getTransportUnloadMethod(gSkirmishAIId, id);
	}

	float getFallSpeed() const {
		return gCallback.UnitDef_getFallSpeed(gSkirmishAIId, id);
	}

	float getUnitFallSpeed() const {
		return gCallback.UnitDef_getUnitFallSpeed(gSkirmishAIId, id);
	}

	bool isAbleToCloak() const {
		return gCallback.UnitDef_isAbleToCloak(gSkirmishAIId, id);
	}

	bool isStartCloaked() const {
		return gCallback.UnitDef_isStartCloaked(gSkirmishAIId, id);
	}

	float getCloakCost() const {
		return gCallback.UnitDef_getCloakCost(gSkirmishAIId, id);
	}

	float getCloakCostMoving() const {
		return gCallback.UnitDef_getCloakCostMoving(gSkirmishAIId, id);
	}

	float getDecloakDistance() const {
		return gCallback.UnitDef_getDecloakDistance(gSkirmishAIId, id);
	}

	bool isDecloakSpherical() const {
		return gCallback.UnitDef_isDecloakSpherical(gSkirmishAIId, id);
	}

	bool isDecloakOnFire() const {
		return gCallback.UnitDef_isDecloakOnFire(gSkirmishAIId, id);
	}

	bool isAbleToKamikaze() const {
		return gCallback.UnitDef_isAbleToKamikaze(gSkirmishAIId, id);
	}

	float getKamikazeDist() const {
		return gCallback.UnitDef_getKamikazeDist(gSkirmishAIId, id);
	}

	bool isTargetingFacility() const {
		return gCallback.UnitDef_isTargetingFacility(gSkirmishAIId, id);
	}

	bool canManualFire() const {
		return gCallback.UnitDef_canManualFire(gSkirmishAIId, id);
	}

	bool isNeedGeo() const {
		return gCallback.UnitDef_isNeedGeo(gSkirmishAIId, id);
	}

	bool isFeature() const {
		return gCallback.UnitDef_isFeature(gSkirmishAIId, id);
	}

	bool isHideDamage() const {
		return gCallback.UnitDef_isHideDamage(gSkirmishAIId, id);
	}

	bool isShowPlayerName() const {
		return gCallback.UnitDef_isShowPlayerName(gSkirmishAIId, id);
	}

	bool isAbleToResurrect() const {
		return gCallback.UnitDef_isAbleToResurrect(gSkirmishAIId, id);
	}

	bool isAbleToCapture() const {
		return gCallback.UnitDef_isAbleToCapture(gSkirmishAIId, id);
	}

	int getHighTrajectoryType() const {
		return gCallback.UnitDef_getHighTrajectoryType(gSkirmishAIId, id);
	}

	int getNoChaseCategory() const {
		return gCallback.UnitDef_getNoChaseCategory(gSkirmishAIId, id);
	}

	bool isAbleToDropFlare() const {
		return gCallback.UnitDef_isAbleToDropFlare(gSkirmishAIId, id);
	}

	float getFlareReloadTime() const {
		return gCallback.UnitDef_getFlareReloadTime(gSkirmishAIId, id);
	}

	float getFlareEfficiency() const {
		return gCallback.UnitDef_getFlareEfficiency(gSkirmishAIId, id);
	}

	float getFlareDelay() const {
		return gCallback.UnitDef_getFlareDelay(gSkirmishAIId, id);
	}

	SFloat4 getFlareDropVector() const {
		SFloat4 posF3_out;
		gCallback.UnitDef_getFlareDropVector(gSkirmishAIId, id, posF3_out.ptr);
		return posF3_out;
	}

	int getFlareTime() const {
		return gCallback.UnitDef_getFlareTime(gSkirmishAIId, id);
	}

	int getFlareSalvoSize() const {
		return gCallback.UnitDef_getFlareSalvoSize(gSkirmishAIId, id);
	}

	int getFlareSalvoDelay() const {
		return gCallback.UnitDef_getFlareSalvoDelay(gSkirmishAIId, id);
	}

	bool isAbleToLoopbackAttack() const {
		return gCallback.UnitDef_isAbleToLoopbackAttack(gSkirmishAIId, id);
	}

	bool isLevelGround() const {
		return gCallback.UnitDef_isLevelGround(gSkirmishAIId, id);
	}

	int getMaxThisUnit() const {
		return gCallback.UnitDef_getMaxThisUnit(gSkirmishAIId, id);
	}

	int getDecoyDef() const {
		return gCallback.UnitDef_getDecoyDef(gSkirmishAIId, id);
	}

	bool isDontLand() const {
		return gCallback.UnitDef_isDontLand(gSkirmishAIId, id);
	}

	int getShieldDef() const {
		return gCallback.UnitDef_getShieldDef(gSkirmishAIId, id);
	}

	int getStockpileDef() const {
		return gCallback.UnitDef_getStockpileDef(gSkirmishAIId, id);
	}

	SUnitDef[] getBuildOptions() const {
		static assert(SUnitDef.sizeof == int.sizeof);
		int[] ids = mallocSliceNoInit!int(gCallback.UnitDef_getBuildOptions(gSkirmishAIId, id, null, -1));
		gCallback.UnitDef_getBuildOptions(gSkirmishAIId, id, ids.ptr, cast(int)ids.length);
		return cast(SUnitDef[])ids;
	}

	bool isMoveDataAvailable() const {
		return gCallback.UnitDef_isMoveDataAvailable(gSkirmishAIId, id);
	}

	mixin TSubEntities;
	SWeaponMount[] getWeaponMounts() const {
		return makeSubEntities!SWeaponMount(gCallback.UnitDef_getWeaponMounts);
	}

	import dplug.core.map;
	mixin TCustomParam;
	Map!(const(char)*, const(char)*) getCustomParams() const {
		return readCustomParams(gCallback.UnitDef_getCustomParams);
	}
}
