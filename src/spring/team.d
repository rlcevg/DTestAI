module spring.team;

import spring.bind.callback;
static {
	import std.conv;
	import std.string;
}

struct STeam {
	mixin TEntity;

	bool hasAIController() const {
		return gCallback.Team_hasAIController(gSkirmishAIId, id);
	}

	float getRulesParamFloat(string rulesParamName, float defaultValue) const
	in (rulesParamName) {
		return gCallback.Team_getRulesParamFloat(gSkirmishAIId, id, std.string.toStringz(rulesParamName), defaultValue);
	}

	string getRulesParamString(string rulesParamName, string defaultValue) const
	in (rulesParamName)
	in (defaultValue) {
		return std.conv.to!string(gCallback.Team_getRulesParamString(gSkirmishAIId, id,
				std.string.toStringz(rulesParamName), std.string.toStringz(defaultValue)));
	}
}
