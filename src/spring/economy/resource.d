module spring.economy.resource;

import spring.bind.callback;

struct SResource {
	mixin TEntity;

nothrow @nogc:
	const(char)* getName() const {
		return gCallback.Resource_getName(gSkirmishAIId, id);
	}

	float getOptimum() const {
		return gCallback.Resource_getOptimum(gSkirmishAIId, id);
	}
}
