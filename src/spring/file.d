module spring.file;

import spring.bind.callback;

class CFile {
nothrow @nogc:
	int getSize(const(char)* fileName) const
	in (fileName) {
		return gCallback.File_getSize(gSkirmishAIId, fileName);
	}

	bool getContent(const(char)* fileName, void* buffer, int bufferLen) const
	in (fileName) {
		return gCallback.File_getContent(gSkirmishAIId, fileName, buffer, bufferLen);
	}

	char getPathSeparator() const {
		return gCallback.DataDirs_getPathSeparator(gSkirmishAIId);
	}

	int roots_getSize() const {
		return gCallback.DataDirs_Roots_getSize(gSkirmishAIId);
	}

	const(char)* roots_getDir(int dirIndex) const {
		return gCallback.DataDirs_Roots_getDir(gSkirmishAIId, _path.ptr, MAX_PATH_SIZE, dirIndex)
				? _path.ptr : null;
	}

	const(char)* roots_locatePath(const(char)* relPath, bool writeable, bool create, bool dir) const
	in (relPath) {
		char[MAX_PATH_SIZE] path;
		return gCallback.DataDirs_Roots_locatePath(gSkirmishAIId, _path.ptr, MAX_PATH_SIZE,
				relPath, writeable, create, dir)
				? _path.ptr : null;
	}

	const(char)* getConfigDir() const {
		return gCallback.DataDirs_getConfigDir(gSkirmishAIId);
	}

	const(char)* locatePath(const(char)* relPath, bool writeable, bool create, bool dir, bool common) const
	in (relPath) {
		char[MAX_PATH_SIZE] path;
		return gCallback.DataDirs_locatePath(gSkirmishAIId, _path.ptr, MAX_PATH_SIZE,
				relPath, writeable, create, dir, common)
				? _path.ptr : null;
	}

	const(char)* getWriteableDir() const {
		return gCallback.DataDirs_getWriteableDir(gSkirmishAIId);
	}

private:
	static char[MAX_PATH_SIZE] _path;
}
