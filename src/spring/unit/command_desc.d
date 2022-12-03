module spring.unit.command_desc;

import spring.bind.callback;
import dplug.core.nogc;

struct SCommandDescription {
	mixin TSubEntity!"unitId";

nothrow @nogc:
	int getCmdId() const {
		return gCallback.Unit_SupportedCommand_getId(gSkirmishAIId, unitId, id);
	}

	const(char)* getName() const {
		return gCallback.Unit_SupportedCommand_getName(gSkirmishAIId, unitId, id);
	}

	const(char)* getToolTip() const {
		return gCallback.Unit_SupportedCommand_getToolTip(gSkirmishAIId, unitId, id);
	}

	bool isShowUnique() const {
		return gCallback.Unit_SupportedCommand_isShowUnique(gSkirmishAIId, unitId, id);
	}

	bool isDisabled() const {
		return gCallback.Unit_SupportedCommand_isDisabled(gSkirmishAIId, unitId, id);
	}

	const(char)*[] getParams(const(char)*[] params = []) const {
		if (params.length == 0) {
			int size = gCallback.Unit_SupportedCommand_getParams(gSkirmishAIId, unitId, id, null, -1);
			params = mallocSliceNoInit!(const(char)*)(size);
		}
		int size = gCallback.Unit_SupportedCommand_getParams(gSkirmishAIId, unitId, id, params.ptr, cast(int)params.length);
		return params[0..size];
	}
}
