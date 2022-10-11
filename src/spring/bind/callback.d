module spring.bind.callback;

public import spring.bind.callback_struct;

enum int MAX_AIS = 255;
enum int MAX_UNITS = 32_000;

struct SClbStorage {
	import spring.bind.events_struct;
	import spring.bind.defines;
	import std.typecons : tuple, Tuple;
	import core.memory : GC;

	void registerGC() nothrow @nogc {
		GC.addRange(_callbacks.ptr, IAI.sizeof * MAX_AIS);
	}

	void unregisterGC() nothrow @nogc {
		GC.removeRange(_callbacks.ptr);
	}

	void updateGC(int topic, const(void)* data) nothrow @nogc {
		if (topic != EventTopic.EVENT_UPDATE) return;
		const SUpdateEvent* evt = cast(SUpdateEvent*)data;
		// FIXME: random value, 1st collect may happen on 10th minute
		if (evt.frame - _lastFrame >= FRAMES_PER_SEC * 60) {
			_lastFrame = evt.frame;
			_isCollect = true;
		}
	}

	void collectGC() nothrow {
		if (!_isCollect) return;
		_isCollect = false;
		GC.collect();
		// GC.minimize();
	}

	void addCallback(int skirmishAIId, const(SSkirmishAICallback)* clb, IAI ai) nothrow @nogc
	in (cast(uint)skirmishAIId < MAX_AIS)  // 0 <= skirmishAIId && skirmishAIId < MAX_AIS
	in (clb !is null && ai !is null)
	out (; _callbacks[skirmishAIId][0] == clb && _callbacks[skirmishAIId][1] is ai)
	{
		// GC.addRoot(cast(void*)ai);
		_callbacks[skirmishAIId] = tuple(clb, ai);
	}

	void delCallback(int skirmishAIId) nothrow @nogc
	in (cast(uint)skirmishAIId < MAX_AIS)
	in (_callbacks[skirmishAIId][1] !is null)
	out (; _callbacks[skirmishAIId] == tuple(null, null))
	{
		// GC.removeRoot(cast(void*)_callbacks[skirmishAIId][1]);
		_callbacks[skirmishAIId] = tuple(null, null);
	}

	IAI setCallback(int skirmishAIId) nothrow @nogc
	in (cast(uint)skirmishAIId < MAX_AIS)
	out (; gCallback == _callbacks[skirmishAIId][0])
	out (; gSkirmishAIId == skirmishAIId)
	out (r; r !is null)
	{
		gCallback = _callbacks[skirmishAIId][0];
		gSkirmishAIId = skirmishAIId;
		return _callbacks[skirmishAIId][1];
	}

	bool hasCallback(int skirmishAIId) nothrow @nogc
	in (cast(uint)skirmishAIId < MAX_AIS)
	{
		return _callbacks[skirmishAIId][0] !is null;
	}

private:
	Tuple!(const(SSkirmishAICallback)*, IAI)[MAX_AIS] _callbacks;  // skirmishAIId -> SSkirmishAICallback*
	bool _isCollect = false;
	int _lastFrame = 0;
}

interface IAI {
	int handleEvent(int topic, const(void)* data);
}


package(spring)
{
enum int MAX_CHARS = 120;
enum int MAX_PATH_SIZE = 2048;
enum int MAX_RESPONSE_SIZE = 10_240;
enum int MAX_STACK_KEYS = 1024;

__gshared const(SSkirmishAICallback)* gCallback;
__gshared int gSkirmishAIId;

deprecated("in favor of struct")
abstract class AEntity {
	immutable int id;
	@disable this();
	protected this(int _id) pure/+ in (_id >= 0)+/ { id = _id; }
}

deprecated("in favor of struct")
abstract class AEntityPool : AEntity {
	protected this(int _id) pure { super(_id); }
	static pure T getInstance(T : AEntityPool)(int id) {
		return (id < 0) ? null : new T(id);
	}
}

mixin template TEntity() {
	immutable int id;
	@disable this();
	this(int _id) { id = _id; }
}

mixin template TSubEntity(string name) {
	mixin TEntity;
	mixin("immutable int " ~ name ~ ";");
	@disable this(int _id);

	static import std.format;
	mixin(std.format.format("this(int _%1$s, int _id) {
		%1$s = _%1$s;
		id = _id;
	}", name));
}

mixin template TCustomParam() {
	private string[string] readCustomParams(T)(T readValues) const {
		int internal_size = readValues(gSkirmishAIId, id, null, null);

		string[string] fillMap(const(char*)* keys, const(char*)* values) {
			string[string] internal_map;
			readValues(gSkirmishAIId, id, keys, values);
			foreach (i; 0 .. internal_size)
				internal_map[std.conv.to!string(keys[i])] = std.conv.to!string(values[i]);
			return internal_map;
		}

		if (internal_size <= MAX_STACK_KEYS) {
			const(char)*[MAX_STACK_KEYS] keys;  // stack
			const(char)*[MAX_STACK_KEYS] values;  // stack
			return fillMap(keys.ptr, values.ptr);
		}
		const(char)*[] keys = new const(char)* [internal_size];  // keys.destroy();
		const(char)*[] values = new const(char)* [internal_size];  // values.destroy();
		return fillMap(keys.ptr, values.ptr);
	}
}

mixin template TSubEntities() {
	private T[] makeSubEntities(T, F)(F readSize) const {
		int size = readSize(gSkirmishAIId, id);
		T[] subEnts;
		subEnts.reserve(size);
		foreach (i; 0 .. size)
			subEnts ~= T(id, i);
		return subEnts;
	}
}
}
