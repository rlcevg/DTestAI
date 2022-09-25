module spring.unit.command_desc;

import spring.bind.callback;
static import std.conv;

struct SCommandDescription {
	mixin TSubEntity!"unitId";

	int getCmdId() const {
		return gCallback.Unit_SupportedCommand_getId(gSkirmishAIId, unitId, id);
	}

	string getName() const {
		return std.conv.to!string(gCallback.Unit_SupportedCommand_getName(gSkirmishAIId, unitId, id));
	}

	string getToolTip() const {
		return std.conv.to!string(gCallback.Unit_SupportedCommand_getToolTip(gSkirmishAIId, unitId, id));
	}

	bool isShowUnique() const {
		return gCallback.Unit_SupportedCommand_isShowUnique(gSkirmishAIId, unitId, id);
	}

	bool isDisabled() const {
		return gCallback.Unit_SupportedCommand_isDisabled(gSkirmishAIId, unitId, id);
	}

	string[] getParams() const {
		int internal_size = gCallback.Unit_SupportedCommand_getParams(gSkirmishAIId, unitId, id, null, -1);
		const(char)*[] charParams = new const(char)* [internal_size];
		gCallback.Unit_SupportedCommand_getParams(gSkirmishAIId, unitId, id, charParams.ptr, internal_size);
		string[] params;
		params.reserve(internal_size);
		foreach (p; charParams)
			params ~= std.conv.to!string(p);
		return params;
	}
}
