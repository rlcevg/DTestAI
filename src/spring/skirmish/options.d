module spring.skirmish.options;

import spring.bind.callback;

struct SOptions {
nothrow @nogc:
	int getSize() const {
		return gCallback.SkirmishAI_OptionValues_getSize(gSkirmishAIId);
	}

	const(char)* getKey(int optionIndex) const {
		return gCallback.SkirmishAI_OptionValues_getKey(gSkirmishAIId, optionIndex);
	}

	const(char)* getValue(int optionIndex) const {
		return gCallback.SkirmishAI_OptionValues_getValue(gSkirmishAIId, optionIndex);
	}

	const(char)* getValueByKey(const(char)* key) const
	in (key) {
		return gCallback.SkirmishAI_OptionValues_getValueByKey(gSkirmishAIId, key);
	}
}
