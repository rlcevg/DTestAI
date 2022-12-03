module spring.weapon.weapon_def;

import spring.bind.callback;
import spring.economy.resource;
import spring.weapon.damage;
import spring.weapon.shield;

struct SWeaponDef {
	mixin TEntity;

nothrow @nogc:
	SDamage getDamage() const {
		return SDamage(id);
	}

	SShield getShield() const {
		return SShield(id);
	}

	const(char)* getName() const {
		return gCallback.WeaponDef_getName(gSkirmishAIId, id);
	}

	const(char)* getType() const {
		return gCallback.WeaponDef_getType(gSkirmishAIId, id);
	}

	const(char)* getDescription() const {
		return gCallback.WeaponDef_getDescription(gSkirmishAIId, id);
	}

	float getRange() const {
		return gCallback.WeaponDef_getRange(gSkirmishAIId, id);
	}

	float getHeightMod() const {
		return gCallback.WeaponDef_getHeightMod(gSkirmishAIId, id);
	}

	float getAccuracy() const {
		return gCallback.WeaponDef_getAccuracy(gSkirmishAIId, id);
	}

	float getSprayAngle() const {
		return gCallback.WeaponDef_getSprayAngle(gSkirmishAIId, id);
	}

	float getMovingAccuracy() const {
		return gCallback.WeaponDef_getMovingAccuracy(gSkirmishAIId, id);
	}

	float getTargetMoveError() const {
		return gCallback.WeaponDef_getTargetMoveError(gSkirmishAIId, id);
	}

	float getLeadLimit() const {
		return gCallback.WeaponDef_getLeadLimit(gSkirmishAIId, id);
	}

	float getLeadBonus() const {
		return gCallback.WeaponDef_getLeadBonus(gSkirmishAIId, id);
	}

	float getPredictBoost() const {
		return gCallback.WeaponDef_getPredictBoost(gSkirmishAIId, id);
	}

	int getNumDamageTypes(int gSkirmishAIId) const {
		return gCallback.WeaponDef_getNumDamageTypes(gSkirmishAIId);
	}

	float getAreaOfEffect() const {
		return gCallback.WeaponDef_getAreaOfEffect(gSkirmishAIId, id);
	}

	bool isNoSelfDamage() const {
		return gCallback.WeaponDef_isNoSelfDamage(gSkirmishAIId, id);
	}

	float getFireStarter() const {
		return gCallback.WeaponDef_getFireStarter(gSkirmishAIId, id);
	}

	float getEdgeEffectiveness() const {
		return gCallback.WeaponDef_getEdgeEffectiveness(gSkirmishAIId, id);
	}

	float getSize() const {
		return gCallback.WeaponDef_getSize(gSkirmishAIId, id);
	}

	float getSizeGrowth() const {
		return gCallback.WeaponDef_getSizeGrowth(gSkirmishAIId, id);
	}

	float getCollisionSize() const {
		return gCallback.WeaponDef_getCollisionSize(gSkirmishAIId, id);
	}

	int getSalvoSize() const {
		return gCallback.WeaponDef_getSalvoSize(gSkirmishAIId, id);
	}

	float getSalvoDelay() const {
		return gCallback.WeaponDef_getSalvoDelay(gSkirmishAIId, id);
	}

	float getReload() const {
		return gCallback.WeaponDef_getReload(gSkirmishAIId, id);
	}

	float getBeamTime() const {
		return gCallback.WeaponDef_getBeamTime(gSkirmishAIId, id);
	}

	bool isBeamBurst() const {
		return gCallback.WeaponDef_isBeamBurst(gSkirmishAIId, id);
	}

	bool isWaterBounce() const {
		return gCallback.WeaponDef_isWaterBounce(gSkirmishAIId, id);
	}

	bool isGroundBounce() const {
		return gCallback.WeaponDef_isGroundBounce(gSkirmishAIId, id);
	}

	float getBounceRebound() const {
		return gCallback.WeaponDef_getBounceRebound(gSkirmishAIId, id);
	}

	float getBounceSlip() const {
		return gCallback.WeaponDef_getBounceSlip(gSkirmishAIId, id);
	}

	int getNumBounce() const {
		return gCallback.WeaponDef_getNumBounce(gSkirmishAIId, id);
	}

	float getMaxAngle() const {
		return gCallback.WeaponDef_getMaxAngle(gSkirmishAIId, id);
	}

	float getUpTime() const {
		return gCallback.WeaponDef_getUpTime(gSkirmishAIId, id);
	}

	int getFlightTime() const {
		return gCallback.WeaponDef_getFlightTime(gSkirmishAIId, id);
	}

	float getCost(in SResource resource) const {
		return gCallback.WeaponDef_getCost(gSkirmishAIId, id, resource.id);
	}

	int getProjectilesPerShot() const {
		return gCallback.WeaponDef_getProjectilesPerShot(gSkirmishAIId, id);
	}

	bool isTurret() const {
		return gCallback.WeaponDef_isTurret(gSkirmishAIId, id);
	}

	bool isOnlyForward() const {
		return gCallback.WeaponDef_isOnlyForward(gSkirmishAIId, id);
	}

	bool isFixedLauncher() const {
		return gCallback.WeaponDef_isFixedLauncher(gSkirmishAIId, id);
	}

	bool isWaterWeapon() const {
		return gCallback.WeaponDef_isWaterWeapon(gSkirmishAIId, id);
	}

	bool isFireSubmersed() const {
		return gCallback.WeaponDef_isFireSubmersed(gSkirmishAIId, id);
	}

	bool isSubMissile() const {
		return gCallback.WeaponDef_isSubMissile(gSkirmishAIId, id);
	}

	bool isTracks() const {
		return gCallback.WeaponDef_isTracks(gSkirmishAIId, id);
	}

	bool isDropped() const {
		return gCallback.WeaponDef_isDropped(gSkirmishAIId, id);
	}

	bool isParalyzer() const {
		return gCallback.WeaponDef_isParalyzer(gSkirmishAIId, id);
	}

	bool isImpactOnly() const {
		return gCallback.WeaponDef_isImpactOnly(gSkirmishAIId, id);
	}

	bool isNoAutoTarget() const {
		return gCallback.WeaponDef_isNoAutoTarget(gSkirmishAIId, id);
	}

	bool isManualFire() const {
		return gCallback.WeaponDef_isManualFire(gSkirmishAIId, id);
	}

	int getInterceptor() const {
		return gCallback.WeaponDef_getInterceptor(gSkirmishAIId, id);
	}

	int getTargetable() const {
		return gCallback.WeaponDef_getTargetable(gSkirmishAIId, id);
	}

	bool isStockpileable() const {
		return gCallback.WeaponDef_isStockpileable(gSkirmishAIId, id);
	}

	float getCoverageRange() const {
		return gCallback.WeaponDef_getCoverageRange(gSkirmishAIId, id);
	}

	float getStockpileTime() const {
		return gCallback.WeaponDef_getStockpileTime(gSkirmishAIId, id);
	}

	float getIntensity() const {
		return gCallback.WeaponDef_getIntensity(gSkirmishAIId, id);
	}

	float getDuration() const {
		return gCallback.WeaponDef_getDuration(gSkirmishAIId, id);
	}

	float getFalloffRate() const {
		return gCallback.WeaponDef_getFalloffRate(gSkirmishAIId, id);
	}

	bool isSelfExplode() const {
		return gCallback.WeaponDef_isSelfExplode(gSkirmishAIId, id);
	}

	bool isGravityAffected() const {
		return gCallback.WeaponDef_isGravityAffected(gSkirmishAIId, id);
	}

	int getHighTrajectory() const {
		return gCallback.WeaponDef_getHighTrajectory(gSkirmishAIId, id);
	}

	float getMyGravity() const {
		return gCallback.WeaponDef_getMyGravity(gSkirmishAIId, id);
	}

	bool isNoExplode() const {
		return gCallback.WeaponDef_isNoExplode(gSkirmishAIId, id);
	}

	float getStartVelocity() const {
		return gCallback.WeaponDef_getStartVelocity(gSkirmishAIId, id);
	}

	float getWeaponAcceleration() const {
		return gCallback.WeaponDef_getWeaponAcceleration(gSkirmishAIId, id);
	}

	float getTurnRate() const {
		return gCallback.WeaponDef_getTurnRate(gSkirmishAIId, id);
	}

	float getMaxVelocity() const {
		return gCallback.WeaponDef_getMaxVelocity(gSkirmishAIId, id);
	}

	float getProjectileSpeed() const {
		return gCallback.WeaponDef_getProjectileSpeed(gSkirmishAIId, id);
	}

	float getExplosionSpeed() const {
		return gCallback.WeaponDef_getExplosionSpeed(gSkirmishAIId, id);
	}

	int getOnlyTargetCategory() const {
		return gCallback.WeaponDef_getOnlyTargetCategory(gSkirmishAIId, id);
	}

	float getWobble() const {
		return gCallback.WeaponDef_getWobble(gSkirmishAIId, id);
	}

	float getDance() const {
		return gCallback.WeaponDef_getDance(gSkirmishAIId, id);
	}

	float getTrajectoryHeight() const {
		return gCallback.WeaponDef_getTrajectoryHeight(gSkirmishAIId, id);
	}

	bool isLargeBeamLaser() const {
		return gCallback.WeaponDef_isLargeBeamLaser(gSkirmishAIId, id);
	}

	bool isShield() const {
		return gCallback.WeaponDef_isShield(gSkirmishAIId, id);
	}

	bool isShieldRepulser() const {
		return gCallback.WeaponDef_isShieldRepulser(gSkirmishAIId, id);
	}

	bool isSmartShield() const {
		return gCallback.WeaponDef_isSmartShield(gSkirmishAIId, id);
	}

	bool isExteriorShield() const {
		return gCallback.WeaponDef_isExteriorShield(gSkirmishAIId, id);
	}

	bool isVisibleShield() const {
		return gCallback.WeaponDef_isVisibleShield(gSkirmishAIId, id);
	}

	bool isVisibleShieldRepulse() const {
		return gCallback.WeaponDef_isVisibleShieldRepulse(gSkirmishAIId, id);
	}

	int getVisibleShieldHitFrames() const {
		return gCallback.WeaponDef_getVisibleShieldHitFrames(gSkirmishAIId, id);
	}

	int getInterceptedByShieldType() const {
		return gCallback.WeaponDef_getInterceptedByShieldType(gSkirmishAIId, id);
	}

	bool isAvoidFriendly() const {
		return gCallback.WeaponDef_isAvoidFriendly(gSkirmishAIId, id);
	}

	bool isAvoidFeature() const {
		return gCallback.WeaponDef_isAvoidFeature(gSkirmishAIId, id);
	}

	bool isAvoidNeutral() const {
		return gCallback.WeaponDef_isAvoidNeutral(gSkirmishAIId, id);
	}

	float getTargetBorder() const {
		return gCallback.WeaponDef_getTargetBorder(gSkirmishAIId, id);
	}

	float getCylinderTargetting() const {
		return gCallback.WeaponDef_getCylinderTargetting(gSkirmishAIId, id);
	}

	float getMinIntensity() const {
		return gCallback.WeaponDef_getMinIntensity(gSkirmishAIId, id);
	}

	float getHeightBoostFactor() const {
		return gCallback.WeaponDef_getHeightBoostFactor(gSkirmishAIId, id);
	}

	float getProximityPriority() const {
		return gCallback.WeaponDef_getProximityPriority(gSkirmishAIId, id);
	}

	int getCollisionFlags() const {
		return gCallback.WeaponDef_getCollisionFlags(gSkirmishAIId, id);
	}

	bool isSweepFire() const {
		return gCallback.WeaponDef_isSweepFire(gSkirmishAIId, id);
	}

	bool isAbleToAttackGround() const {
		return gCallback.WeaponDef_isAbleToAttackGround(gSkirmishAIId, id);
	}

	float getCameraShake() const {
		return gCallback.WeaponDef_getCameraShake(gSkirmishAIId, id);
	}

	float getDynDamageExp() const {
		return gCallback.WeaponDef_getDynDamageExp(gSkirmishAIId, id);
	}

	float getDynDamageMin() const {
		return gCallback.WeaponDef_getDynDamageMin(gSkirmishAIId, id);
	}

	float getDynDamageRange() const {
		return gCallback.WeaponDef_getDynDamageRange(gSkirmishAIId, id);
	}

	bool isDynDamageInverted() const {
		return gCallback.WeaponDef_isDynDamageInverted(gSkirmishAIId, id);
	}

	import dplug.core.map;
	mixin TCustomParam;
	Map!(const(char)*, const(char)*) getCustomParams() const {
		return readCustomParams(gCallback.WeaponDef_getCustomParams);
	}
}
