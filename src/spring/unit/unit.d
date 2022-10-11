module spring.unit.unit;

import spring.bind.callback;
import spring.bind.commands;
import spring.team;
import spring.group;
import spring.unit.unit_def;
import spring.unit.command;
import spring.unit.command_desc;
import spring.feature.feature;
import spring.economy.resource;
import spring.weapon.weapon;
import spring.weapon.weapon_mount;
import spring.util.float4;
static {
	import std.conv;
	import std.string;
}

struct SUnit {
	mixin TEntity;

	SUnitDef getDef() const {
		return SUnitDef(gCallback.Unit_getDef(gSkirmishAIId, id));
	}

	int getLimit() const {
		return gCallback.Unit_getLimit(gSkirmishAIId);
	}

	int getMax() const {
		return gCallback.Unit_getMax(gSkirmishAIId);
	}

	float getRulesParamFloat(string rulesParamName, float defaultValue) const
	in (rulesParamName) {
		return gCallback.Unit_getRulesParamFloat(gSkirmishAIId, id, std.string.toStringz(rulesParamName), defaultValue);
	}

	string getRulesParamString(string rulesParamName, string defaultValue) const
	in (rulesParamName)
	in (defaultValue) {
		return std.conv.to!string(gCallback.Unit_getRulesParamString(gSkirmishAIId, id,
				std.string.toStringz(rulesParamName), std.string.toStringz(defaultValue)));
	}

	STeam getTeam() const {
		return STeam(gCallback.Unit_getTeam(gSkirmishAIId, id));
	}

	int getAllyTeamId() const {
		return gCallback.Unit_getAllyTeam(gSkirmishAIId, id);
	}

	int getStockpile() const {
		return gCallback.Unit_getStockpile(gSkirmishAIId, id);
	}

	int getStockpileQueued() const {
		return gCallback.Unit_getStockpileQueued(gSkirmishAIId, id);
	}

	float getMaxSpeed() const {
		return gCallback.Unit_getMaxSpeed(gSkirmishAIId, id);
	}

	float getMaxRange() const {
		return gCallback.Unit_getMaxRange(gSkirmishAIId, id);
	}

	float getMaxHealth() const {
		return gCallback.Unit_getMaxHealth(gSkirmishAIId, id);
	}

	float getExperience() const {
		return gCallback.Unit_getExperience(gSkirmishAIId, id);
	}

	SGroup getGroup() const {
		return SGroup(gCallback.Unit_getGroup(gSkirmishAIId, id));
	}

	float getHealth() const {
		return gCallback.Unit_getHealth(gSkirmishAIId, id);
	}

	float getParalyzeDamage() const {
		return gCallback.Unit_getParalyzeDamage(gSkirmishAIId, id);
	}

	float getCaptureProgress() const {
		return gCallback.Unit_getCaptureProgress(gSkirmishAIId, id);
	}

	float getBuildProgress() const {
		return gCallback.Unit_getBuildProgress(gSkirmishAIId, id);
	}

	float getSpeed() const {
		return gCallback.Unit_getSpeed(gSkirmishAIId, id);
	}

	float getPower() const {
		return gCallback.Unit_getPower(gSkirmishAIId, id);
	}

	float getResourceUse(in SResource resource) const {
		return gCallback.Unit_getResourceUse(gSkirmishAIId, id, resource.id);
	}

	float getResourceMake(in SResource resource) const {
		return gCallback.Unit_getResourceMake(gSkirmishAIId, id, resource.id);
	}

	SFloat4 getPos() const {
		SFloat4 posF3_out;
		gCallback.Unit_getPos(gSkirmishAIId, id, posF3_out.ptr);
		return posF3_out;
	}

	SFloat4 getVel() const {
		SFloat4 posF3_out;
		gCallback.Unit_getVel(gSkirmishAIId, id, posF3_out.ptr);
		return posF3_out;
	}

	bool isActivated() const {
		return gCallback.Unit_isActivated(gSkirmishAIId, id);
	}

	bool isBeingBuilt() const {
		return gCallback.Unit_isBeingBuilt(gSkirmishAIId, id);
	}

	bool isCloaked() const {
		return gCallback.Unit_isCloaked(gSkirmishAIId, id);
	}

	bool isParalyzed() const {
		return gCallback.Unit_isParalyzed(gSkirmishAIId, id);
	}

	bool isNeutral() const {
		return gCallback.Unit_isNeutral(gSkirmishAIId, id);
	}

	int getBuildingFacing() const {
		return gCallback.Unit_getBuildingFacing(gSkirmishAIId, id);
	}

	int getLastUserOrderFrame() const {
		return gCallback.Unit_getLastUserOrderFrame(gSkirmishAIId, id);
	}

	SWeapon getWeapon(in SWeaponMount weaponMount) const {
		return SWeapon(id, gCallback.Unit_getWeapon(gSkirmishAIId, id, weaponMount.id));
	}

	mixin TSubEntities;
	SWeapon[] getWeapons() const {
		return makeSubEntities!SWeapon(gCallback.Unit_getWeapons);
	}
	SCommand[] getCurrentCommands() const {
		return makeSubEntities!SCommand(gCallback.Unit_getCurrentCommands);
	}
	bool hasCommands() const {
		return gCallback.Unit_getCurrentCommands(gSkirmishAIId, id) > 0;
	}
	SCommandDescription[] getSupportedCommands() const {
		return makeSubEntities!SCommandDescription(gCallback.Unit_getSupportedCommands);
	}

	void build(in SUnitDef toBuildUnitDef, in SFloat4 buildPos, int facing,
			short options = 0, int timeOut = int.max) const
	{
		SBuildUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toBuildUnitDefId:toBuildUnitDef.id,
			buildPos_posF3:buildPos.ptr,
			facing:facing
		};
		execCmd(CommandTopic.COMMAND_UNIT_BUILD, &commandData, exceptMsg!__FUNCTION__);
	}

	void stop(short options, int timeOut) const {
		SStopUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut
		};
		execCmd(CommandTopic.COMMAND_UNIT_STOP, &commandData, exceptMsg!__FUNCTION__);
	}

	void wait(short options, int timeOut) const {
		SWaitUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut
		};
		execCmd(CommandTopic.COMMAND_UNIT_WAIT, &commandData, exceptMsg!__FUNCTION__);
	}

	void waitFor(int time, short options, int timeOut) const {
		STimeWaitUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			time:time
		};
		execCmd(CommandTopic.COMMAND_UNIT_WAIT_TIME, &commandData, exceptMsg!__FUNCTION__);
	}

	void waitForDeathOf(in SUnit toDieUnit, short options, int timeOut) const {
		SDeathWaitUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toDieUnitId:toDieUnit.id
		};
		execCmd(CommandTopic.COMMAND_UNIT_WAIT_DEATH, &commandData, exceptMsg!__FUNCTION__);
	}

	void waitForSquadSize(int numUnits, short options, int timeOut) const {
		SSquadWaitUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			numUnits:numUnits
		};
		execCmd(CommandTopic.COMMAND_UNIT_WAIT_SQUAD, &commandData, exceptMsg!__FUNCTION__);
	}

	void waitForAll(short options, int timeOut) const {
		SGatherWaitUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut
		};
		execCmd(CommandTopic.COMMAND_UNIT_WAIT_GATHER, &commandData, exceptMsg!__FUNCTION__);
	}

	void moveTo(in SFloat4 toPos, short options, int timeOut) const {
		SMoveUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toPos_posF3:toPos.ptr
		};
		execCmd(CommandTopic.COMMAND_UNIT_MOVE, &commandData, exceptMsg!__FUNCTION__);
	}

	void patrolTo(in SFloat4 toPos, short options, int timeOut) const {
		SPatrolUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toPos_posF3:toPos.ptr
		};
		execCmd(CommandTopic.COMMAND_UNIT_PATROL, &commandData, exceptMsg!__FUNCTION__);
	}

	void fight(in SFloat4 toPos, short options = 0, int timeOut = int.max) const {
		SFightUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toPos_posF3:toPos.ptr
		};
		execCmd(CommandTopic.COMMAND_UNIT_FIGHT, &commandData, exceptMsg!__FUNCTION__);
	}

	void attack(in SUnit toAttackUnit, short options, int timeOut) const {
		SAttackUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toAttackUnitId:toAttackUnit.id
		 };
		execCmd(CommandTopic.COMMAND_UNIT_ATTACK, &commandData, exceptMsg!__FUNCTION__);
	}

	void attackArea(in SFloat4 toAttackPos, float radius, short options, int timeOut) const {
		SAttackAreaUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toAttackPos_posF3:toAttackPos.ptr,
			radius:radius
		};
		execCmd(CommandTopic.COMMAND_UNIT_ATTACK_AREA, &commandData, exceptMsg!__FUNCTION__);
	}

	void guard(in SUnit toGuardUnit, short options = 0, int timeOut = int.max) const {
		SGuardUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toGuardUnitId:toGuardUnit.id
		};
		execCmd(CommandTopic.COMMAND_UNIT_GUARD, &commandData, exceptMsg!__FUNCTION__);
	}

	void aiSelect(short options, int timeOut) const {
		SAiSelectUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut
		};
		execCmd(CommandTopic.COMMAND_UNIT_AI_SELECT, &commandData, exceptMsg!__FUNCTION__);
	}

	void addToGroup(in SGroup toGroup, short options, int timeOut) const {
		SGroupAddUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toGroupId:toGroup.id
		};
		execCmd(CommandTopic.COMMAND_UNIT_GROUP_ADD, &commandData, exceptMsg!__FUNCTION__);
	}

	void removeFromGroup(short options, int timeOut) const {
		SGroupClearUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut
		};
		execCmd(CommandTopic.COMMAND_UNIT_GROUP_CLEAR, &commandData, exceptMsg!__FUNCTION__);
	}

	void repair(in SUnit toRepairUnit, short options, int timeOut) const {
		SRepairUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toRepairUnitId:toRepairUnit.id
		};
		execCmd(CommandTopic.COMMAND_UNIT_REPAIR, &commandData, exceptMsg!__FUNCTION__);
	}

	void setFireState(int fireState, short options, int timeOut) const {
		SSetFireStateUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			fireState:fireState
		};
		execCmd(CommandTopic.COMMAND_UNIT_SET_FIRE_STATE, &commandData, exceptMsg!__FUNCTION__);
	}

	void setMoveState(int moveState, short options, int timeOut) const {
		SSetMoveStateUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			moveState:moveState
		};
		execCmd(CommandTopic.COMMAND_UNIT_SET_MOVE_STATE, &commandData, exceptMsg!__FUNCTION__);
	}

	void setBase(in SFloat4 basePos, short options, int timeOut) const {
		SSetBaseUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			basePos_posF3:basePos.ptr
		};
		execCmd(CommandTopic.COMMAND_UNIT_SET_BASE, &commandData, exceptMsg!__FUNCTION__);
	}

	void selfDestruct(short options, int timeOut) const {
		SSelfDestroyUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut
		};
		execCmd(CommandTopic.COMMAND_UNIT_SELF_DESTROY, &commandData, exceptMsg!__FUNCTION__);
	}

	void loadUnits(in SUnit[] toLoadUnits, short options, int timeOut) const {
		static assert(SUnit.sizeof == int.sizeof);
		SLoadUnitsUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toLoadUnitIds:cast(const(int)*)toLoadUnits.ptr,
			toLoadUnitIds_size:cast(int)toLoadUnits.length
		};
		execCmd(CommandTopic.COMMAND_UNIT_LOAD_UNITS, &commandData, exceptMsg!__FUNCTION__);
	}

	void loadUnitsInArea(in SFloat4 pos, float radius, short options, int timeOut) const {
		SLoadUnitsAreaUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			pos_posF3:pos.ptr,
			radius:radius
		};
		execCmd(CommandTopic.COMMAND_UNIT_LOAD_UNITS_AREA, &commandData, exceptMsg!__FUNCTION__);
	}

	void loadOnto(in SUnit transporterUnit, short options, int timeOut) const {
		SLoadOntoUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			transporterUnitId:transporterUnit.id
		};
		execCmd(CommandTopic.COMMAND_UNIT_LOAD_ONTO, &commandData, exceptMsg!__FUNCTION__);
	}

	void unload(in SFloat4 toPos, in SUnit toUnloadUnit, short options, int timeOut) const {
		SUnloadUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toPos_posF3:toPos.ptr,
			toUnloadUnitId:toUnloadUnit.id
		};
		execCmd(CommandTopic.COMMAND_UNIT_UNLOAD_UNIT, &commandData, exceptMsg!__FUNCTION__);
	}

	void unloadUnitsInArea(in SFloat4 toPos, float radius, short options, int timeOut) const {
		SUnloadUnitsAreaUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toPos_posF3:toPos.ptr,
			radius:radius
		};
		execCmd(CommandTopic.COMMAND_UNIT_UNLOAD_UNITS_AREA, &commandData, exceptMsg!__FUNCTION__);
	}

	void setOn(bool on, short options, int timeOut) const {
		SSetOnOffUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			on:on
		};
		execCmd(CommandTopic.COMMAND_UNIT_SET_ON_OFF, &commandData, exceptMsg!__FUNCTION__);
	}

	void reclaimUnit(in SUnit toReclaimUnit, short options, int timeOut) const {
		SReclaimUnitUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toReclaimUnitId:toReclaimUnit.id
		};
		execCmd(CommandTopic.COMMAND_UNIT_RECLAIM_UNIT, &commandData, exceptMsg!__FUNCTION__);
	}

	void reclaimFeature(in SFeature toReclaimFeature, short options, int timeOut) const {
		SReclaimFeatureUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toReclaimFeatureId:toReclaimFeature.id
		};
		execCmd(CommandTopic.COMMAND_UNIT_RECLAIM_FEATURE, &commandData, exceptMsg!__FUNCTION__);
	}

	void reclaimInArea(in SFloat4 pos, float radius, short options, int timeOut) const {
		SReclaimAreaUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			pos_posF3:pos.ptr,
			radius:radius
		};
		execCmd(CommandTopic.COMMAND_UNIT_RECLAIM_AREA, &commandData, exceptMsg!__FUNCTION__);
	}

	void cloak(bool cloak, short options, int timeOut) const {
		SCloakUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			cloak:cloak
		};
		execCmd(CommandTopic.COMMAND_UNIT_CLOAK, &commandData, exceptMsg!__FUNCTION__);
	}

	void stockpile(short options, int timeOut) const {
		SStockpileUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut
		};
		execCmd(CommandTopic.COMMAND_UNIT_STOCKPILE, &commandData, exceptMsg!__FUNCTION__);
	}

	void dGun(in SUnit toAttackUnit, short options, int timeOut) const {
		SDGunUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toAttackUnitId:toAttackUnit.id
		};
		execCmd(CommandTopic.COMMAND_UNIT_D_GUN, &commandData, exceptMsg!__FUNCTION__);
	}

	void dGunPosition(in SFloat4 pos, short options, int timeOut) const {
		SDGunPosUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			pos_posF3:pos.ptr
		};
		execCmd(CommandTopic.COMMAND_UNIT_D_GUN_POS, &commandData, exceptMsg!__FUNCTION__);
	}

	void restoreArea(in SFloat4 pos, float radius, short options, int timeOut) const {
		SRestoreAreaUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			pos_posF3:pos.ptr,
			radius:radius
		};
		execCmd(CommandTopic.COMMAND_UNIT_RESTORE_AREA, &commandData, exceptMsg!__FUNCTION__);
	}

	void setRepeat(bool repeat, short options, int timeOut) const {
		SSetRepeatUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			repeat:repeat
		};
		execCmd(CommandTopic.COMMAND_UNIT_SET_REPEAT, &commandData, exceptMsg!__FUNCTION__);
	}

	void setTrajectory(int trajectory, short options, int timeOut) const {
		SSetTrajectoryUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			trajectory:trajectory
		};
		execCmd(CommandTopic.COMMAND_UNIT_SET_TRAJECTORY, &commandData, exceptMsg!__FUNCTION__);
	}

	void resurrect(in SFeature toResurrectFeature, short options, int timeOut) const {
		SResurrectUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toResurrectFeatureId:toResurrectFeature.id
		};
		execCmd(CommandTopic.COMMAND_UNIT_RESURRECT, &commandData, exceptMsg!__FUNCTION__);
	}

	void resurrectInArea(in SFloat4 pos, float radius, short options, int timeOut) const {
		SResurrectAreaUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			pos_posF3:pos.ptr,
			radius:radius
		};
		execCmd(CommandTopic.COMMAND_UNIT_RESURRECT_AREA, &commandData, exceptMsg!__FUNCTION__);
	}

	void capture(in SUnit toCaptureUnit, short options, int timeOut) const {
		SCaptureUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			toCaptureUnitId:toCaptureUnit.id
		};
		execCmd(CommandTopic.COMMAND_UNIT_CAPTURE, &commandData, exceptMsg!__FUNCTION__);
	}

	void captureInArea(in SFloat4 pos, float radius, short options, int timeOut) const {
		SCaptureAreaUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			pos_posF3:pos.ptr,
			radius:radius
		};
		execCmd(CommandTopic.COMMAND_UNIT_CAPTURE_AREA, &commandData, exceptMsg!__FUNCTION__);
	}

	void setAutoRepairLevel(int autoRepairLevel, short options, int timeOut) const {
		SSetAutoRepairLevelUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			autoRepairLevel:autoRepairLevel
		};
		execCmd(CommandTopic.COMMAND_UNIT_SET_AUTO_REPAIR_LEVEL, &commandData, exceptMsg!__FUNCTION__);
	}

	void setIdleMode(int idleMode, short options, int timeOut) const {
		SSetIdleModeUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			idleMode:idleMode
		};
		execCmd(CommandTopic.COMMAND_UNIT_SET_IDLE_MODE, &commandData, exceptMsg!__FUNCTION__);
	}

	void executeCustomCommand(int cmdId, in float[] params, short options, int timeOut) const {
		SCustomUnitCommand commandData = {
			unitId:id,
			groupId:-1,
			options:options,
			timeOut:timeOut,
			cmdId:cmdId,
			params:params.ptr,
			params_size:cast(int)params.length
		};
		execCmd(CommandTopic.COMMAND_UNIT_CUSTOM, &commandData, exceptMsg!__FUNCTION__);
	}
}
