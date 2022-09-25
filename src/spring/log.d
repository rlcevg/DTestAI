module spring.log;

import spring.bind.callback;
static import std.string;

struct SLog {
	void log(string msg) const
	in (msg) {
		gCallback.Log_log(gSkirmishAIId, std.string.toStringz(msg));
	}

	void exception(string msg, int severety, bool die) const
	in (msg) {
		gCallback.Log_exception(gSkirmishAIId, std.string.toStringz(msg), severety, die);
	}
}
