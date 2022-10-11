module spring.bind.commands;

public import spring.bind.commands_struct;
import spring.bind.callback;
import std.exception;
import std.string;

class CCallbackAIException : Exception {
	int errorNumber;

	this(string msg, int eNum, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null)
	pure nothrow @nogc @safe {
		super(msg, file, line, nextInChain);
		errorNumber = eNum;
	}
}

template exceptMsg(string msg) {
	string exceptMsg = msg.split(".")[$ - 1];
}

void execCmd(CommandTopic topic, void* pCmd, lazy string msg) {
	int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1, topic, pCmd);
	if (internal_ret != 0)
		throw new CCallbackAIException(msg, internal_ret);
}
