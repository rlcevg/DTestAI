module spring.file;

import spring.bind.callback;
static {
	import std.conv;
	import std.string;
}

class CFile {
	int getSize(string fileName) const
	in (fileName) {
		return gCallback.File_getSize(gSkirmishAIId, std.string.toStringz(fileName));
	}

	bool getContent(string fileName, void* buffer, int bufferLen) const
	in (fileName) {
		return gCallback.File_getContent(gSkirmishAIId, std.string.toStringz(fileName), buffer, bufferLen);
	}

	char getPathSeparator() const {
		return gCallback.DataDirs_getPathSeparator(gSkirmishAIId);
	}

	int roots_getSize() const {
		return gCallback.DataDirs_Roots_getSize(gSkirmishAIId);
	}

	string roots_getDir(int dirIndex) const {
		char[MAX_PATH_SIZE] path;
		return gCallback.DataDirs_Roots_getDir(gSkirmishAIId, path.ptr, MAX_PATH_SIZE, dirIndex)
				? std.conv.to!string(path) : null;
	}

	string roots_locatePath(string relPath, bool writeable, bool create, bool dir) const
	in (relPath) {
		char[MAX_PATH_SIZE] path;
		return gCallback.DataDirs_Roots_locatePath(gSkirmishAIId, path.ptr, MAX_PATH_SIZE,
				std.string.toStringz(relPath), writeable, create, dir)
				? std.conv.to!string(path) : null;
	}

	string getConfigDir() const {
		return std.conv.to!string(gCallback.DataDirs_getConfigDir(gSkirmishAIId));
	}

	string locatePath(string relPath, bool writeable, bool create, bool dir, bool common) const
	in (relPath) {
		char[MAX_PATH_SIZE] path;
		return gCallback.DataDirs_locatePath(gSkirmishAIId, path.ptr, MAX_PATH_SIZE,
				std.string.toStringz(relPath), writeable, create, dir, common)
				? std.conv.to!string(path) : null;
	}

	string getWriteableDir() const {
		return std.conv.to!string(gCallback.DataDirs_getWriteableDir(gSkirmishAIId));
	}
}
