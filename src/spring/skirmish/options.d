module spring.skirmish.options;

import spring.bind.callback;
static {
	import std.conv;
	import std.string;
}

struct SOptions {
	int getSize() const {
		return gCallback.SkirmishAI_OptionValues_getSize(gSkirmishAIId);
	}

	string getKey(int optionIndex) const {
		return std.conv.to!string(gCallback.SkirmishAI_OptionValues_getKey(gSkirmishAIId, optionIndex));
	}

	string getValue(int optionIndex) const {
		return std.conv.to!string(gCallback.SkirmishAI_OptionValues_getValue(gSkirmishAIId, optionIndex));
	}

	string getValueByKey(string key) const
	in (key) {
		return std.conv.to!string(gCallback.SkirmishAI_OptionValues_getValueByKey(gSkirmishAIId, std.string.toStringz(key)));
	}
}
