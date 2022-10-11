module spring.economy.economy;

import spring.bind.callback;
import spring.bind.commands;
import spring.team;
import spring.unit.unit;
import spring.economy.resource;

class CEconomy {
	float getCurrent(in SResource resource) const {
		return gCallback.Economy_getCurrent(gSkirmishAIId, resource.id);
	}

	float getIncome(in SResource resource) const {
		return gCallback.Economy_getIncome(gSkirmishAIId, resource.id);
	}

	float getUsage(in SResource resource) const {
		return gCallback.Economy_getUsage(gSkirmishAIId, resource.id);
	}

	float getStorage(in SResource resource) const {
		return gCallback.Economy_getStorage(gSkirmishAIId, resource.id);
	}

	float getPull(in SResource resource) const {
		return gCallback.Economy_getPull(gSkirmishAIId, resource.id);
	}

	float getShare(in SResource resource) const {
		return gCallback.Economy_getShare(gSkirmishAIId, resource.id);
	}

	float getSent(in SResource resource) const {
		return gCallback.Economy_getSent(gSkirmishAIId, resource.id);
	}

	float getReceived(in SResource resource) const {
		return gCallback.Economy_getReceived(gSkirmishAIId, resource.id);
	}

	float getExcess(in SResource resource) const {
		return gCallback.Economy_getExcess(gSkirmishAIId, resource.id);
	}

	bool sendResource(in SResource resource, float amount, in STeam receivingTeam) const {
		SSendResourcesCommand commandData = {
			resourceId:resource.id,
			amount:amount,
			receivingTeamId:receivingTeam.id
		};
		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				CommandTopic.COMMAND_SEND_RESOURCES, &commandData);
		return (internal_ret == 0) ? commandData.ret_isExecuted : false;
	}

	int sendUnitIds(in SUnit[] units, in STeam receivingTeam) const {
		static assert(SUnit.sizeof == int.sizeof);
		SSendUnitsCommand commandData = {
			unitIds:cast(const(int)*)units.ptr,
			unitIds_size:cast(int)units.length,
			receivingTeamId:receivingTeam.id
		};
		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				CommandTopic.COMMAND_SEND_UNITS, &commandData);
		return (internal_ret == 0) ? commandData.ret_sentUnits : -1;
	}
}
