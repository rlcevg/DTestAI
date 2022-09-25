import ai.ai : gAIs, CAI;
import spring.bind.callback : addCallback, delCallback, setCallback, SSkirmishAICallback;
import std.exception;
import core.runtime;

enum int ERROR_UNKNOWN = 100;
enum int ERROR_EXCEPT  = ERROR_UNKNOWN + 1;
enum int ERROR_RUNTIME = ERROR_UNKNOWN + 2;

int tryCatch(int delegate() func) {
	int ret = ERROR_UNKNOWN;

	try {
		ret = func();
	} catch (Exception e) {
		ret = ERROR_EXCEPT;
	}

	return ret;
}

version(unittest)
int main() {
	return 0;
}

version(Windows) {
import core.sys.windows.windows;
import core.sys.windows.dll;

mixin SimpleDllMain;
}

extern (C) export:

	int init(int skirmishAIId, const(SSkirmishAICallback)* innerCallback) {
	if (!Runtime.initialize())
		return ERROR_RUNTIME;
	int initAI() {
		addCallback(skirmishAIId, innerCallback);
		gAIs[skirmishAIId] = new CAI(skirmishAIId);
		return 0;
	}
	return tryCatch(&initAI);  // (ret != 0) => error
}

int release(int skirmishAIId) {
	scope(exit) Runtime.terminate();
	int releaseAI() {
		gAIs.remove(skirmishAIId);
		delCallback(skirmishAIId);
		return 0;
	}
	return tryCatch(&releaseAI);  // (ret != 0) => error
}

int handleEvent(int skirmishAIId, int topic, const(void)* data) {
	int handleEventAI() {
		setCallback(skirmishAIId);
		return gAIs[skirmishAIId].handleEvent(topic, data);
	}
	return tryCatch(&handleEventAI);  // (ret != 0) => error
}
