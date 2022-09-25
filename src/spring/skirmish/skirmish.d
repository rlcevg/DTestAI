module spring.skirmish.skirmish;

import spring.bind.callback;
import spring.skirmish.info;
import spring.skirmish.options;
static import std.conv;
static import std.string;

struct SSkirmishAI {
	int getTeamId() const {
		return gCallback.SkirmishAI_getTeamId(gSkirmishAIId);
	}

	SInfo getInfo() const {
		return SInfo();
	}

	SOptions getOptions() const {
		return SOptions();
	}
}
