Dlang AI Interface Wrapper  
for Spring RTS Engine  
=========
(gamma version)
* `src/spring` - AI interface wrapper.
* `src/ai` - AI example.
* `src/AIExport.d` - DLL interface.
----
### Build
Tested with DMD64 D Compiler v2.100.1  
and LDC D Compiler v1.30.0  
https://dlang.org/download.html
##### Linux, LDC
Common compile options:
* `$ dub build --build=debug --compiler=ldc2`
* `$ dub build --build=release --compiler=ldc2`
##### Windows cross-compile, LDC
https://forum.dlang.org/thread/qnsbjdamttlklurnplhx@forum.dlang.org  
https://wiki.dlang.org/Cross-compiling_with_LDC  
Prerequisites
* https://github.com/ldc-developers/ldc/releases/download/v1.30.0/ldc2-1.30.0-windows-x64.7z
* Extract `lib` as `lib-win64`
* Add platform in `/etc/ldc2.conf` with proper `path/to/lib-win64`:  
```
"x86_64-.*-windows-msvc":
{
    switches = [
        "-defaultlib=phobos2-ldc,druntime-ldc",
        "-link-defaultlib-shared=false",
    ];
    lib-dirs = [
        // "%%ldcbinarypath%%/../lib-win64",
        "path/to/lib-win64",
    ];
};
```
Common compile options:
* `$ dub build --build=debug --compiler=ldc2 --arch=x86_64-pc-windows-msvc`
* `$ dub build --build=release --compiler=ldc2 --arch=x86_64-pc-windows-msvc`
##### Windows, DMD
https://dlang.org/dmd-windows.html  
As only 64bit spring is supported make sure correct dmd `/dmd2/windows/bin64` is in PATH.  
Or `-m64` flag used for 32bit compiler, requires proper hinting at `/dmd2/windows/lib64`.
### Installation
* Copy content of `data/*` (@see AI/Skirmish/NullAI).
