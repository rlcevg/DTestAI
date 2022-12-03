module spring.bind.callback;

public import spring.bind.callback_struct;
public import spring.spring;

enum int MAX_AIS = 255;
enum int MAX_UNITS = 32_000;

enum MAX_REQUESTS = 1024;

struct SRequest {
	alias DgAction = void delegate(CSpring, out UResponse) nothrow @nogc;
	alias DgFinish = void delegate(AAI, in UResponse);

nothrow @nogc:
	this(DgAction act, DgFinish fin) {
		action = act;
		finish = fin;
	}

	DgAction action;
	DgFinish finish;
	UResponse data;  // to reduce GC allocations for simple cases with primitive types
}

union UResponse {
	static assert(UResponse.sizeof <= (void*).sizeof);
	// void[] toSlice;
	const(void)* toConstPtr;
	void* toPtr;
	int toInt;
	bool toBool;
}

abstract class AAI {
	immutable int id; //skirmishAIId() const pure nothrow @nogc @safe;
	@disable this();
	this(int ident) const pure nothrow @nogc @safe { id = ident; }

	import dmain : mainC;
	final bool async(SRequest.DgAction action, SRequest.DgFinish finish = null)
	in (action) {
		_action[actionIdx] = action;  // save closure for GC
		actionIdx = (actionIdx + 1) % _action.length;
		if (finish) {
			_finish[finishIdx] = finish;  // save closure for GC
			finishIdx = (finishIdx + 1) % _finish.length;
		}
		return mainC.send(id, SRequest(action, finish));
	}

	import spring.unit.unit;
	import spring.util.float4;

	int initSync(CSpring api, bool isSavedGame);
	int releaseSync(CSpring api, int reason);
	int loadSync(CSpring api, const(char)* filename);
	int saveSync(CSpring api, const(char)* filename);

	void update(int frame);
	void message(string text);  // text is @nogc
	void unitCreated(int unitId, int unitDefId, int builderId);
	void unitFinished(int unitId, int unitDefId);
	void unitIdle(int unitId);
	void unitMoveFailed(int unitId);
	void unitDamaged(int unitId, int attackerId, float damage, SFloat4 dir, int weaponDefId, bool paralyzer);
	void unitDestroyed(int unitId, int attackerId);
	void unitGiven(int unitId, int oldTeamId, int newTeamId);
	void unitCaptured(int unitId, int oldTeamId, int newTeamId);
	void enemyEnterLOS(int enemyId);
	void enemyLeaveLOS(int enemyId);
	void enemyEnterRadar(int enemyId);
	void enemyLeaveRadar(int enemyId);
	void enemyDamaged(int enemyId, int attackerId, float damage, SFloat4 dir, int weaponDefId, bool paralyzer);
	void enemyDestroyed(int enemyId, int attackerId);
	void weaponFired(int unitId, int weaponDefId);
	void playerCommand(const(SUnit)[] units, int commandTopicId, int playerId);  // units is @nogc
	void seismicPing(SFloat4 pos, float strength);
	void commandFinished(int unitId, int commandId, int commandTopicId);
	void enemyCreated(int enemyId);
	void enemyFinished(int enemyId);
	void luaMessage(string data);  // data is @nogc

private:
	SRequest.DgAction[MAX_REQUESTS] _action;
	int actionIdx = 0;
	SRequest.DgFinish[MAX_REQUESTS] _finish;
	int finishIdx = 0;
}


package(spring)
{
enum int MAX_CHARS = 120;
enum int MAX_PATH_SIZE = 2048;
enum int MAX_RESPONSE_SIZE = 10_240;
enum int MAX_STACK_KEYS = 1024;

__gshared int gSkirmishAIId;
__gshared const(SSkirmishAICallback)* gCallback;
version(assert) {
	import core.thread : ThreadID;
	__gshared ThreadID gThreadId;
}

deprecated("in favor of struct")
abstract class AEntity {
	immutable int id;
	@disable this();
	protected this(int ident) pure/+ in (ident >= 0)+/ { id = ident; }
}

deprecated("in favor of struct")
abstract class AEntityPool : AEntity {
	protected this(int ident) pure { super(ident); }
	static pure T getInstance(T : AEntityPool)(int id) {
		return (id < 0) ? null : new T(id);
	}
}

mixin template TEntity() {
	alias Id = int;
	private int _id;
	// @disable this();  // this() required for array pre-allocation
	this(int id) pure nothrow @nogc @safe { _id = id; }
	int id() const pure nothrow @nogc @safe { return _id; }
}

mixin template TSubEntity(string name) {
	mixin TEntity;
	mixin("private int _" ~ name ~ ";");
	@disable this(int id);

	static import std.format;
	mixin(std.format.format("this(int %1$s, int id) pure nothrow @nogc @safe {
		_%1$s = %1$s;
		_id = id;
	}
	int %1$s() const pure nothrow @nogc @safe { return _%1$s; }", name));
}

mixin template TCustomParam() {
	import dplug.core.map;
	private Map!(const(char)*, const(char)*) readCustomParams(T)(T readValues) const {
		int internal_size = readValues(gSkirmishAIId, id, null, null);
		auto internal_map = makeMap!(const(char)*, const(char)*)();

		if (internal_size > MAX_STACK_KEYS)  // NB: AFAIK there shouldn't be long lists. Otherwise malloc and free
			return internal_map;

		const(char)*[MAX_STACK_KEYS] keys;  // stack
		const(char)*[MAX_STACK_KEYS] values;  // stack

		readValues(gSkirmishAIId, id, keys.ptr, values.ptr);
		foreach (i; 0 .. internal_size)
			internal_map[keys[i]] = values[i];
		return internal_map;
	}
}

mixin template TSubEntities() {
	private T[] makeSubEntities(T, F)(F readSize) const nothrow @nogc {
		int size = readSize(gSkirmishAIId, id);
		import dplug.core.nogc : mallocSliceNoInit;
		T[] subEnts = mallocSliceNoInit!T(size);
		foreach (i; 0 .. size)
			subEnts[i] = T(id, i);
		return subEnts;
	}
}
}
