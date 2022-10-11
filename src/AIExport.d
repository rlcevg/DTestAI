import spring.bind.callback : SSkirmishAICallback;
import dmain : SMain;

version(unittest)
int main() {
	return 0;
}

version(Windows) {
	import core.sys.windows.windef : HINSTANCE, BOOL, DWORD, LPVOID;
	extern (Windows) BOOL DllMain(HINSTANCE hInstance, DWORD ulReason, LPVOID reserved) {
		import core.sys.windows.winnt;
		import core.sys.windows.dll : dll_process_attach, dll_process_detach, dll_thread_attach, dll_thread_detach;
		switch (ulReason) {
			default: assert(0);
			case DLL_PROCESS_ATTACH:
				return true;  // return dll_process_attach( hInstance, true );
			case DLL_PROCESS_DETACH:
				// dll_process_detach( hInstance, true );
				return true;
			case DLL_THREAD_ATTACH:
				return true;  // return dll_thread_attach( true, true );
			case DLL_THREAD_DETACH:
				return true;  // return dll_thread_detach( true, true );
		}
	}
}

pragma(crt_constructor)
extern (C) void initDll() nothrow @nogc {
	proxy.ctor();
}

pragma(crt_destructor)
extern (C) void finiDll() nothrow @nogc {
	proxy.dtor();
}

SMain proxy;


extern (C) export nothrow @nogc:

int init(int skirmishAIId, const(SSkirmishAICallback)* innerCallback) {
	proxy.initialize();
	return proxy.initC(skirmishAIId, innerCallback);
}

int release(int skirmishAIId) {
	scope(exit) proxy.terminate();
	return proxy.releaseC(skirmishAIId);
}

int handleEvent(int skirmishAIId, int topic, const(void)* data) {
	return proxy.handleEventC(skirmishAIId, topic, data);
}
