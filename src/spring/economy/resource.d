module spring.economy.resource;

import spring.bind.callback;
static import std.conv;

struct SResource {
	mixin TEntity;

	string getName() const {
		return std.conv.to!string(gCallback.Resource_getName(gSkirmishAIId, id));
	}

	float getOptimum() const {
		return gCallback.Resource_getOptimum(gSkirmishAIId, id);
	}
}
