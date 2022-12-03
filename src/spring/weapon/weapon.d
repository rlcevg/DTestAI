module spring.weapon.weapon;

import spring.bind.callback;
import spring.weapon.weapon_def;

struct SWeapon {
	mixin TSubEntity!"unitId";

nothrow @nogc:
	SWeaponDef getDef() const {
		return SWeaponDef(gCallback.Unit_Weapon_getDef(gSkirmishAIId, unitId, id));
	}

	int getReloadFrame() const {
		return gCallback.Unit_Weapon_getReloadFrame(gSkirmishAIId, unitId, id);
	}

	int getReloadTime() const {
		return gCallback.Unit_Weapon_getReloadTime(gSkirmishAIId, unitId, id);
	}

	float getRange() const {
		return gCallback.Unit_Weapon_getRange(gSkirmishAIId, unitId, id);
	}

	bool isShieldEnabled() const {
		return gCallback.Unit_Weapon_isShieldEnabled(gSkirmishAIId, unitId, id);
	}

	float getShieldPower() const {
		return gCallback.Unit_Weapon_getShieldPower(gSkirmishAIId, unitId, id);
	}
}
