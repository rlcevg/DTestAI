module spring.weapon.damage;

import spring.bind.callback;

struct SDamage {
	mixin TEntity;  // weaponDefId

	int getParalyzeDamageTime() const {
		return gCallback.WeaponDef_Damage_getParalyzeDamageTime(gSkirmishAIId, id);
	}

	float getImpulseFactor() const {
		return gCallback.WeaponDef_Damage_getImpulseFactor(gSkirmishAIId, id);
	}

	float getImpulseBoost() const {
		return gCallback.WeaponDef_Damage_getImpulseBoost(gSkirmishAIId, id);
	}

	float getCraterMult() const {
		return gCallback.WeaponDef_Damage_getCraterMult(gSkirmishAIId, id);
	}

	float getCraterBoost() const {
		return gCallback.WeaponDef_Damage_getCraterBoost(gSkirmishAIId, id);
	}

	float[] getTypes() const {
		float[] types = new float [gCallback.WeaponDef_Damage_getTypes(gSkirmishAIId, id, null, -1)];
		gCallback.WeaponDef_Damage_getTypes(gSkirmishAIId, id, types.ptr, cast(int)types.length);
		return types;
	}
}
