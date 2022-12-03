module spring.team;

import spring.bind.callback;

struct STeam {
	mixin TEntity;

nothrow @nogc:
	bool hasAIController() const {
		return gCallback.Team_hasAIController(gSkirmishAIId, id);
	}

	float getRulesParamFloat(const(char)* rulesParamName, float defaultValue) const
	in (rulesParamName) {
		return gCallback.Team_getRulesParamFloat(gSkirmishAIId, id, rulesParamName, defaultValue);
	}

	const(char)* getRulesParamString(const(char)* rulesParamName, const(char)* defaultValue) const
	in (rulesParamName)
	in (defaultValue) {
		return gCallback.Team_getRulesParamString(gSkirmishAIId, id,
				rulesParamName, defaultValue);
	}
}
