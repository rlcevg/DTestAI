module spring.log;

import spring.bind.callback;

class CLog {
nothrow @nogc:
	void log(const(char)* msg) const
	in (msg) {
		gCallback.Log_log(gSkirmishAIId, msg);
	}

	void exception(const(char)* msg, int severety, bool die) const
	in (msg) {
		gCallback.Log_exception(gSkirmishAIId, msg, severety, die);
	}
}
