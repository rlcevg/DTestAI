module spring.engine;

import spring.bind.callback;

class CEngine {
nothrow @nogc:
	const(char)* getVersionFull() const {
		return gCallback.Engine_Version_getFull(gSkirmishAIId);
	}

	const(char)* getVersionMajor() const {
		return gCallback.Engine_Version_getMajor(gSkirmishAIId);
	}

	const(char)* getVersionMinor() const {
		return gCallback.Engine_Version_getMinor(gSkirmishAIId);
	}

	const(char)* getVersionPatchset() const {
		return gCallback.Engine_Version_getPatchset(gSkirmishAIId);
	}

	const(char)* getVersionCommits() const {
		return gCallback.Engine_Version_getCommits(gSkirmishAIId);
	}

	const(char)* getVersionHash() const {
		return gCallback.Engine_Version_getHash(gSkirmishAIId);
	}

	const(char)* getVersionBranch() const {
		return gCallback.Engine_Version_getBranch(gSkirmishAIId);
	}

	const(char)* getVersionAdditional() const {
		return gCallback.Engine_Version_getAdditional(gSkirmishAIId);
	}

	const(char)* getVersionBuildTime() const {
		return gCallback.Engine_Version_getBuildTime(gSkirmishAIId);
	}

	bool isVersionRelease() const {
		return gCallback.Engine_Version_isRelease(gSkirmishAIId);
	}

	const(char)* getVersionNormal() const {
		return gCallback.Engine_Version_getNormal(gSkirmishAIId);
	}

	const(char)* getVersionSync() const {
		return gCallback.Engine_Version_getSync(gSkirmishAIId);
	}
}
