module spring.weapon.shield;

import spring.bind.callback;
import spring.economy.resource;

struct SShield {
	mixin TEntity;  // weaponDefId

nothrow @nogc:
	float getResourceUse(in SResource resource) const {
		return gCallback.WeaponDef_Shield_getResourceUse(gSkirmishAIId, id, resource.id);
	}

	float getRadius() const {
		return gCallback.WeaponDef_Shield_getRadius(gSkirmishAIId, id);
	}

	float getForce() const {
		return gCallback.WeaponDef_Shield_getForce(gSkirmishAIId, id);
	}

	float getMaxSpeed() const {
		return gCallback.WeaponDef_Shield_getMaxSpeed(gSkirmishAIId, id);
	}

	float getPower() const {
		return gCallback.WeaponDef_Shield_getPower(gSkirmishAIId, id);
	}

	float getPowerRegen() const {
		return gCallback.WeaponDef_Shield_getPowerRegen(gSkirmishAIId, id);
	}

	float getPowerRegenResource(in SResource resource) const {
		return gCallback.WeaponDef_Shield_getPowerRegenResource(gSkirmishAIId, id, resource.id);
	}

	float getStartingPower() const {
		return gCallback.WeaponDef_Shield_getStartingPower(gSkirmishAIId, id);
	}

	int getRechargeDelay() const {
		return gCallback.WeaponDef_Shield_getRechargeDelay(gSkirmishAIId, id);
	}

	int getInterceptType() const {
		return gCallback.WeaponDef_Shield_getInterceptType(gSkirmishAIId, id);
	}
}
