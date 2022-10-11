module spring.skirmish.skirmish;

import spring.bind.callback;
import spring.skirmish.info;
import spring.skirmish.options;
import spring.team;
static {
	import std.conv;
	import std.string;
}

class CSkirmishAI {
	STeam getTeam() const {
		return STeam(gCallback.SkirmishAI_getTeamId(gSkirmishAIId));
	}

	SInfo getInfo() const {
		return SInfo();
	}

	SOptions getOptions() const {
		return SOptions();
	}
}
