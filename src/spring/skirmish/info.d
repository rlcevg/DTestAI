module spring.skirmish.info;

import spring.bind.callback;

struct SInfo {
nothrow @nogc:
	int getSize() const {
		return gCallback.SkirmishAI_Info_getSize(gSkirmishAIId);
	}

	const(char)* getKey(int infoIndex) const {
		return gCallback.SkirmishAI_Info_getKey(gSkirmishAIId, infoIndex);
	}

	const(char)* getValue(int infoIndex) const {
		return gCallback.SkirmishAI_Info_getValue(gSkirmishAIId, infoIndex);
	}

	const(char)* getDescription(int infoIndex) const {
		return gCallback.SkirmishAI_Info_getDescription(gSkirmishAIId, infoIndex);
	}

	const(char)* getValueByKey(int skirmishAIId, const(char)* key) const
	in (key) {
		return gCallback.SkirmishAI_Info_getValueByKey(skirmishAIId, key);
	}
}
