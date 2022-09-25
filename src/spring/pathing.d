module spring.pathing;

import spring.bind.callback;
import spring.bind.commands;
import spring.util.float4;

struct SPathing {
	int initPath(in SFloat4 start, in SFloat4 end, int pathType, float goalRadius) const {
		SInitPathCommand commandData ={
			start_posF3:start.ptr,
			end_posF3:end.ptr,
			pathType:pathType,
			goalRadius:goalRadius
		};
		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				CommandTopic.COMMAND_PATH_INIT, &commandData);
		return (internal_ret == 0) ? commandData.ret_pathId : -1;
	}

	float getApproximateLength(in SFloat4 start, in SFloat4 end, int pathType, float goalRadius) const {
		SGetApproximateLengthPathCommand commandData = {
			start_posF3:start.ptr,
			end_posF3:end.ptr,
			pathType:pathType,
			goalRadius:goalRadius
		};
		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				CommandTopic.COMMAND_PATH_GET_APPROXIMATE_LENGTH, &commandData);
		return (internal_ret == 0) ? commandData.ret_approximatePathLength : 0f;
	}

	SFloat4 getNextWaypoint(int pathId) const {
		SFloat4 nextWaypoint_posF3_out;
		SGetNextWaypointPathCommand commandData = {
			pathId:pathId,
			ret_nextWaypoint_posF3_out:nextWaypoint_posF3_out.ptr
		};
		execCmd(CommandTopic.COMMAND_PATH_GET_NEXT_WAYPOINT, &commandData, exceptMsg!__FUNCTION__);
		return nextWaypoint_posF3_out;
	}

	void freePath(int pathId) const {
		SFreePathCommand commandData = {pathId:pathId};
		execCmd(CommandTopic.COMMAND_PATH_FREE, &commandData, exceptMsg!__FUNCTION__);
	}
}
