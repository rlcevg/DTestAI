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

	static CCallbackAIException getInstance(string msg, int eNum, string file = __FILE__, size_t line = __LINE__)
	nothrow @nogc {
		import core.lifetime : emplace;
		emplace(cast(CCallbackAIException)_store.ptr, msg, eNum, file, line);
		return cast(CCallbackAIException)_store.ptr;
	}

private:
	static align(2 * size_t.sizeof) void[__traits(classInstanceSize, CCallbackAIException)] _store;
}

template exceptMsg(string msg) {
	string exceptMsg = msg.split(".")[$ - 1];
}

void execCmd(CommandTopic topic, void* pCmd, /+lazy +/string msg) @nogc {
	int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1, topic, pCmd);
	if (internal_ret != 0)
		throw CCallbackAIException.getInstance(msg, internal_ret);
}
