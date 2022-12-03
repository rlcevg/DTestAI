module spring.lua;

import spring.bind.callback;
import spring.bind.commands;

class CLua {
@nogc:
	const(char)* callRules(const(char)* inData, int inSize) const {
		return callLua!SCallLuaRulesCommand(inData, inSize,
				CommandTopic.COMMAND_CALL_LUA_RULES, exceptMsg!__FUNCTION__);
	}

	const(char)* callUI(const(char)* inData, int inSize) const {
		return callLua!SCallLuaUICommand(inData, inSize,
				CommandTopic.COMMAND_CALL_LUA_UI, exceptMsg!__FUNCTION__);
	}

private:
	static char[MAX_RESPONSE_SIZE] _outData;

	const(char)* callLua(T)(const(char)* inData, int inSize, CommandTopic topic, /+lazy +/string msg) const {
		T commandData = {
			inData:inData,
			inSize:inSize,
			ret_outData:_outData.ptr
		};

		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				topic, &commandData);

		if (internal_ret != 0)
			throw CCallbackAIException.getInstance(msg, internal_ret);

		return _outData.ptr;
	}
}
