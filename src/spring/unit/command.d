module spring.unit.command;

import spring.bind.callback;

struct SCommand {
	mixin TSubEntity!"unitId";

	int getType() const {
		return gCallback.Unit_CurrentCommand_getType(gSkirmishAIId, unitId);
	}

	int getCmdId() const {
		return gCallback.Unit_CurrentCommand_getId(gSkirmishAIId, unitId, id);
	}

	short getOptions() const {
		return gCallback.Unit_CurrentCommand_getOptions(gSkirmishAIId, unitId, id);
	}

	int getTag() const {
		return gCallback.Unit_CurrentCommand_getTag(gSkirmishAIId, unitId, id);
	}

	int getTimeOut() const {
		return gCallback.Unit_CurrentCommand_getTimeOut(gSkirmishAIId, unitId, id);
	}

	float[] getParams() const {
		float[] params = new float [gCallback.Unit_CurrentCommand_getParams(gSkirmishAIId, unitId, id, null, -1)];
		gCallback.Unit_CurrentCommand_getParams(gSkirmishAIId, unitId, id, params.ptr, cast(int)params.length);
		return params;
	}
}
