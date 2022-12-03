module spring.unit.flanking_bonus;

import spring.bind.callback;
import spring.util.float4;

struct SFlankingBonus {
	mixin TEntity;  // unitDefId

nothrow @nogc:
	int getMode() const {
		return gCallback.UnitDef_FlankingBonus_getMode(gSkirmishAIId, id);
	}

	SFloat4 getDir() const {
		SFloat4 posF3_out;
		gCallback.UnitDef_FlankingBonus_getDir(gSkirmishAIId, id, posF3_out.ptr);
		return posF3_out;
	}

	float getMax() const {
		return gCallback.UnitDef_FlankingBonus_getMax(gSkirmishAIId, id);
	}

	float getMin() const {
		return gCallback.UnitDef_FlankingBonus_getMin(gSkirmishAIId, id);
	}

	float getMobilityAdd() const {
		return gCallback.UnitDef_FlankingBonus_getMobilityAdd(gSkirmishAIId, id);
	}
}
