module spring.economy.economy;

import spring.bind.callback;
import spring.bind.commands;
import spring.team;
import spring.unit.unit;
import spring.economy.resource;

class CEconomy {
	float getCurrent(in CResource resource) const {
		return gCallback.Economy_getCurrent(gSkirmishAIId, resource.id);
	}

	float getIncome(in CResource resource) const {
		return gCallback.Economy_getIncome(gSkirmishAIId, resource.id);
	}

	float getUsage(in CResource resource) const {
		return gCallback.Economy_getUsage(gSkirmishAIId, resource.id);
	}

	float getStorage(in CResource resource) const {
		return gCallback.Economy_getStorage(gSkirmishAIId, resource.id);
	}

	float getPull(in CResource resource) const {
		return gCallback.Economy_getPull(gSkirmishAIId, resource.id);
	}

	float getShare(in CResource resource) const {
		return gCallback.Economy_getShare(gSkirmishAIId, resource.id);
	}

	float getSent(in CResource resource) const {
		return gCallback.Economy_getSent(gSkirmishAIId, resource.id);
	}

	float getReceived(in CResource resource) const {
		return gCallback.Economy_getReceived(gSkirmishAIId, resource.id);
	}

	float getExcess(in CResource resource) const {
		return gCallback.Economy_getExcess(gSkirmishAIId, resource.id);
	}

	bool sendResource(in CResource resource, float amount, in CTeam receivingTeam) const {
		SSendResourcesCommand commandData = {
			resourceId:resource.id,
			amount:amount,
			receivingTeamId:receivingTeam.id
		};
		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				CommandTopic.COMMAND_SEND_RESOURCES, &commandData);
		return (internal_ret == 0) ? commandData.ret_isExecuted : false;
	}

	int sendUnits(T: CUnit)(in T[] units, in CTeam receivingTeam) const {
		if (_ids.length < units.length)
			_ids.length = units.length;
		foreach (i, u; units)
			_ids[i] = u.id;
		return sendUnits(unitIds[0..units.length], receivingTeam);
	}
	int sendUnitIds(in int[] unitIds, in CTeam receivingTeam) const {
		SSendUnitsCommand commandData = {
			unitIds:unitIds.ptr,
			unitIds_size:cast(int)unitIds.length,
			receivingTeamId:receivingTeam.id
		};
		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				CommandTopic.COMMAND_SEND_UNITS, &commandData);
		return (internal_ret == 0) ? commandData.ret_sentUnits : false;
	}

	private int[] _ids;
}
