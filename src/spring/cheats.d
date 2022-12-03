module spring.cheats;

import spring.bind.callback;
import spring.bind.commands;
import spring.economy.resource;
import spring.unit.unit;
import spring.unit.unit_def;
import spring.util.float4;
/+public +/import std.typecons : nullable, Nullable;

class CCheats {
nothrow @nogc {
	bool isEnabled() const {
		return gCallback.Cheats_isEnabled(gSkirmishAIId);
	}

	bool setEnabled(bool value) const {
		return gCallback.Cheats_setEnabled(gSkirmishAIId, value);
	}

	bool setEventsEnabled(bool value) const {
		return gCallback.Cheats_setEventsEnabled(gSkirmishAIId, value);
	}

	bool isOnlyPassive() const {
		return gCallback.Cheats_isOnlyPassive(gSkirmishAIId);
	}

	Nullable!SUnit giveMeUnit(in SUnitDef unitDef, in SFloat4 pos) const {
		SGiveMeNewUnitCheatCommand commandData = {unitDefId:unitDef.id, pos_posF3:pos.ptr};
		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				CommandTopic.COMMAND_CHEATS_GIVE_ME_NEW_UNIT, &commandData);
		auto ret = nullable(SUnit(commandData.ret_newUnitId));
		if (internal_ret != 0) ret.nullify;
		return ret;
	}
}
@nogc:
	void setMyIncomeMultiplier(float factor) const {
		SSetMyIncomeMultiplierCheatCommand commandData = {factor:factor};
		execCmd(CommandTopic.COMMAND_CHEATS_SET_MY_INCOME_MULTIPLIER, &commandData, exceptMsg!__FUNCTION__);
	}

	void giveMeResource(in SResource resource, float amount) const {
		SGiveMeResourceCheatCommand commandData = {resourceId:resource.id, amount:amount};
		execCmd(CommandTopic.COMMAND_CHEATS_GIVE_ME_RESOURCE, &commandData, exceptMsg!__FUNCTION__);
	}
}
