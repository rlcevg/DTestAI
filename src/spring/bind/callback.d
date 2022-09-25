module spring.bind.callback;

public import spring.bind.callback_struct;

enum int MAX_CHARS = 120;
enum int MAX_PATH_SIZE = 2048;
enum int MAX_RESPONSE_SIZE = 10_240;
enum int MAX_UNITS = 32_000;
enum int MAX_STACK_KEYS = 1024;

const(SSkirmishAICallback)*[int] gCallbacks;  // skirmishAIId -> SSkirmishAICallback*
const(SSkirmishAICallback)* gCallback;
int gSkirmishAIId;

void addCallback(int skirmishAIId, const(SSkirmishAICallback)* clb) {
	gCallbacks[skirmishAIId] = clb;
}

void delCallback(int skirmishAIId) {
	gCallbacks.remove(skirmishAIId);
}

void setCallback(int skirmishAIId) {
	gCallback = gCallbacks[skirmishAIId];
	gSkirmishAIId = skirmishAIId;
}

abstract class AEntity {
	protected immutable int _id;
	// @property const int id() => _id;
	@property int id() const { return _id; }
	@disable this();
	protected this(int id) pure/+ in (id >= 0)+/ { _id = id; }
}

abstract class AEntityPool : AEntity {
	protected this(int id) pure { super(id); }
	static pure T getInstance(T : AEntityPool)(int id) {
		return (id < 0) ? null : new T(id);
	}
}

mixin template TEntity() {
	immutable int _id;
	alias id = _id;
	@disable this();
	this(int id) { _id = id; }
}

mixin template TSubEntity(string name) {
	template privName(string name) {
		const char[] privName = "_" ~ name;
	}
	mixin TEntity;
	mixin("int " ~ privName!name ~ ";");
	mixin("@property const int " ~ name ~ "() => " ~ privName!name ~";");
	@disable this(int id);

	static import std.format;
	mixin(std.format.format("this(int %2$s, int id) {
		%1$s = %2$s;
		_id = id;
	}", privName!name, name));
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
