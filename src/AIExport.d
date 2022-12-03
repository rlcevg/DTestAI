import spring.bind.callback : SSkirmishAICallback;
import dmain : mainC;

version(unittest)
int main() {
	return 0;
}

version(Windows) {
	import core.sys.windows.windef : HINSTANCE, BOOL, DWORD, LPVOID;
	extern (Windows) BOOL DllMain(HINSTANCE hInstance, DWORD ulReason, LPVOID reserved) { // @suppress(dscanner.style.phobos_naming_convention)
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
	mainC.ctor();
}

pragma(crt_destructor)
extern (C) void finiDll() nothrow @nogc {
	mainC.dtor();
}


extern (C) export nothrow @nogc:

int init(int skirmishAIId, const(SSkirmishAICallback)* innerCallback) {
	return mainC.initialize(skirmishAIId, innerCallback);
}

int release(int skirmishAIId) {
	return mainC.terminate(skirmishAIId);
}

int handleEvent(int skirmishAIId, int topic, const(void)* data) {
	return mainC.handleEvent(skirmishAIId, topic, data);
}
