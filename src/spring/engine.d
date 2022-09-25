module spring.engine;

import spring.bind.callback;
static import std.conv;

immutable struct SEngine {
	string getVersionFull() const {
		return std.conv.to!string(gCallback.Engine_Version_getFull(gSkirmishAIId));
	}

	string getVersionMajor() const {
		return std.conv.to!string(gCallback.Engine_Version_getMajor(gSkirmishAIId));
	}

	string getVersionMinor() const {
		return std.conv.to!string(gCallback.Engine_Version_getMinor(gSkirmishAIId));
	}

	string getVersionPatchset() const {
		return std.conv.to!string(gCallback.Engine_Version_getPatchset(gSkirmishAIId));
	}

	string getVersionCommits() const {
		return std.conv.to!string(gCallback.Engine_Version_getCommits(gSkirmishAIId));
	}

	string getVersionHash() const {
		return std.conv.to!string(gCallback.Engine_Version_getHash(gSkirmishAIId));
	}

	string getVersionBranch() const {
		return std.conv.to!string(gCallback.Engine_Version_getBranch(gSkirmishAIId));
	}

	string getVersionAdditional() const {
		return std.conv.to!string(gCallback.Engine_Version_getAdditional(gSkirmishAIId));
	}

	string getVersionBuildTime() const {
		return std.conv.to!string(gCallback.Engine_Version_getBuildTime(gSkirmishAIId));
	}

	bool isVersionRelease() const {
		return gCallback.Engine_Version_isRelease(gSkirmishAIId);
	}

	string getVersionNormal() const {
		return std.conv.to!string(gCallback.Engine_Version_getNormal(gSkirmishAIId));
	}

	string getVersionSync() const {
		return std.conv.to!string(gCallback.Engine_Version_getSync(gSkirmishAIId));
	}
}
