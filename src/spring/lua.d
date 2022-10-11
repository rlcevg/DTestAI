module spring.lua;

import spring.bind.callback;
import spring.bind.commands;
static {
	import std.conv;
	import std.string;
}

class CLua {
	string callRules(const(char)* inData, int inSize) const {
		return callLua!SCallLuaRulesCommand(inData, inSize,
				CommandTopic.COMMAND_CALL_LUA_RULES, exceptMsg!__FUNCTION__);
	}

	string callUI(const(char)* inData, int inSize) const {
		return callLua!SCallLuaUICommand(inData, inSize,
				CommandTopic.COMMAND_CALL_LUA_UI, exceptMsg!__FUNCTION__);
	}

	private string callLua(T)(const(char)* inData, int inSize, CommandTopic topic, lazy string msg) const {
		char[MAX_RESPONSE_SIZE] ret_outData;
		T commandData = {
			inData:inData,
			inSize:inSize,
			ret_outData:ret_outData.ptr
		};

		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				topic, &commandData);

		if (internal_ret != 0)
			throw new CCallbackAIException(msg, internal_ret);

		return std.conv.to!string(ret_outData);
	}
}
