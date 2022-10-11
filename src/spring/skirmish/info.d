module spring.skirmish.info;

import spring.bind.callback;
static {
	import std.conv;
	import std.string;
}

struct SInfo {
	int getSize() const {
		return gCallback.SkirmishAI_Info_getSize(gSkirmishAIId);
	}

	string getKey(int infoIndex) const {
		return std.conv.to!string(gCallback.SkirmishAI_Info_getKey(gSkirmishAIId, infoIndex));
	}

	string getValue(int infoIndex) const {
		return std.conv.to!string(gCallback.SkirmishAI_Info_getValue(gSkirmishAIId, infoIndex));
	}

	string getDescription(int infoIndex) const {
		return std.conv.to!string(gCallback.SkirmishAI_Info_getDescription(gSkirmishAIId, infoIndex));
	}

	string getValueByKey(int skirmishAIId, string key) const
	in (key) {
		return std.conv.to!string(gCallback.SkirmishAI_Info_getValueByKey(skirmishAIId, std.string.toStringz(key)));
	}
}
