module spring.weapon.weapon_mount;

import spring.bind.callback;
import spring.weapon.weapon_def;
import spring.util.float4;

struct SWeaponMount {
	mixin TSubEntity!"unitDefId";

nothrow @nogc:
	const(char)* getName() const {
		return gCallback.UnitDef_WeaponMount_getName(gSkirmishAIId, unitDefId, id);
	}

	SWeaponDef getWeaponDef() const {
		return SWeaponDef(gCallback.UnitDef_WeaponMount_getWeaponDef(gSkirmishAIId, unitDefId, id));
	}

	int getSlavedTo() const {
		return gCallback.UnitDef_WeaponMount_getSlavedTo(gSkirmishAIId, unitDefId, id);
	}

	SFloat4 getMainDir() const {
		SFloat4 posF3_out;
		gCallback.UnitDef_WeaponMount_getMainDir(gSkirmishAIId, unitDefId, id, posF3_out.ptr);
		return posF3_out;
	}

	float getMaxAngleDif() const {
		return gCallback.UnitDef_WeaponMount_getMaxAngleDif(gSkirmishAIId, unitDefId, id);
	}

	int getBadTargetCategory() const {
		return gCallback.UnitDef_WeaponMount_getBadTargetCategory(gSkirmishAIId, unitDefId, id);
	}

	int getOnlyTargetCategory() const {
		return gCallback.UnitDef_WeaponMount_getOnlyTargetCategory(gSkirmishAIId, unitDefId, id);
	}
}
