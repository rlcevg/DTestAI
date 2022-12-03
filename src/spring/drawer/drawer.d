module spring.drawer.drawer;

import spring.bind.callback;
import spring.bind.commands;
import spring.unit.unit;
import spring.unit.unit_def;
import spring.unit.command;
import spring.util.float4;
import spring.util.color4;
/+public+/ import std.typecons : tuple, Tuple;

struct SDrawer {
@nogc:
	void addNotification(in SFloat4 pos, in SColor4 color, short alpha) const {
		short[3] color_colorS3;
		color.loadInto(color_colorS3);
		SAddNotificationDrawerCommand commandData = {pos_posF3:pos.ptr, color_colorS3:color_colorS3.ptr, alpha:alpha};
		execCmd(CommandTopic.COMMAND_DRAWER_ADD_NOTIFICATION, &commandData, exceptMsg!__FUNCTION__);
	}

	void addPoint(in SFloat4 pos, const(char)* label) const
	in (label) {
		// TODO: ensure that engine makes copy of texLabel
		SAddPointDrawCommand commandData = {pos_posF3:pos.ptr, label:label};
		execCmd(CommandTopic.COMMAND_DRAWER_POINT_ADD, &commandData, exceptMsg!__FUNCTION__);
	}

	void deletePointsAndLines(in SFloat4 pos) const {
		SRemovePointDrawCommand commandData = {pos_posF3:pos.ptr};
		execCmd(CommandTopic.COMMAND_DRAWER_POINT_REMOVE, &commandData, exceptMsg!__FUNCTION__);
	}

	void addLine(in SFloat4 posFrom, in SFloat4 posTo) const {
		SAddLineDrawCommand commandData = {posFrom_posF3:posFrom.ptr, posTo_posF3:posTo.ptr};
		execCmd(CommandTopic.COMMAND_DRAWER_LINE_ADD, &commandData, exceptMsg!__FUNCTION__);
	}

	void drawUnit(in SUnitDef toDrawUnitDef, in SFloat4 pos, float rotation, int lifeTime, int teamId,
			bool transparent, bool drawBorder, int facing) const
	{
		SDrawUnitDrawerCommand commandData;
		commandData.toDrawUnitDefId = toDrawUnitDef.id;
		commandData.pos_posF3 = pos.ptr;
		commandData.rotation = rotation;
		commandData.lifeTime = lifeTime;
		commandData.teamId = teamId;
		commandData.transparent = transparent;
		commandData.drawBorder = drawBorder;
		commandData.facing = facing;
		execCmd(CommandTopic.COMMAND_DRAWER_DRAW_UNIT, &commandData, exceptMsg!__FUNCTION__);
	}

nothrow:
	Tuple!(int, float) traceRay(in SFloat4 rayPos, in SFloat4 rayDir, float rayLen,
			in SUnit srcUnit, int flags) const
	{
		STraceRayCommand commandData = {
			rayPos_posF3:rayPos.ptr,
			rayDir_posF3:rayDir.ptr,
			rayLen:rayLen,
			srcUnitId:srcUnit.id,
			flags:flags
		};
		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				CommandTopic.COMMAND_TRACE_RAY, &commandData);
		return (internal_ret == 0) ? tuple(commandData.ret_hitUnitId, commandData.rayLen) : tuple(-1, 0f);
	}

	Tuple!(int, float) traceRayFeature(in SFloat4 rayPos, in SFloat4 rayDir, float rayLen,
			in SUnit srcUnit, int flags) const
	{
		SFeatureTraceRayCommand commandData = {
			rayPos_posF3:rayPos.ptr,
			rayDir_posF3:rayDir.ptr,
			rayLen:rayLen,
			srcUnitId:srcUnit.id,
			flags:flags
		};
		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				CommandTopic.COMMAND_TRACE_RAY_FEATURE, &commandData);
		return (internal_ret == 0) ? tuple(commandData.ret_hitFeatureId, commandData.rayLen) : tuple(-1, 0f);
	}

	SFigure getFigure() const {
		return SFigure();
	}

	SPathDrawer getPathDrawer() const {
		return SPathDrawer();
	}

	struct SFigure {
	nothrow @nogc {
		int drawSpline(in SFloat4 pos1, in SFloat4 pos2, in SFloat4 pos3, in SFloat4 pos4,
				float width, bool arrow, int lifeTime, int figureGroupId) const
		{
			SCreateSplineFigureDrawerCommand commandData;
			commandData.pos1_posF3 = pos1.ptr;
			commandData.pos2_posF3 = pos2.ptr;
			commandData.pos3_posF3 = pos3.ptr;
			commandData.pos4_posF3 = pos4.ptr;
			commandData.width = width;
			commandData.arrow = arrow;
			commandData.lifeTime = lifeTime;
			commandData.figureGroupId = figureGroupId;
			int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
					CommandTopic.COMMAND_DRAWER_FIGURE_CREATE_SPLINE, &commandData);
			return (internal_ret == 0) ? commandData.ret_newFigureGroupId : -1;
		}

		int drawLine(in SFloat4 pos1, in SFloat4 pos2, float width, bool arrow, int lifeTime, int figureGroupId) const {
			SCreateLineFigureDrawerCommand commandData;
			commandData.pos1_posF3 = pos1.ptr;
			commandData.pos2_posF3 = pos2.ptr;
			commandData.width = width;
			commandData.arrow = arrow;
			commandData.lifeTime = lifeTime;
			commandData.figureGroupId = figureGroupId;
			int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
					CommandTopic.COMMAND_DRAWER_FIGURE_CREATE_LINE, &commandData);
			return (internal_ret == 0) ? commandData.ret_newFigureGroupId : -1;
		}
	}
	@nogc:
		void setColor(int figureGroupId, in SColor4 color, short alpha) const {
			short[3] color_colorS3;
			color.loadInto(color_colorS3);
			SSetColorFigureDrawerCommand commandData = {
				figureGroupId:figureGroupId,
				color_colorS3:color_colorS3.ptr,
				alpha:alpha
			};
			execCmd(CommandTopic.COMMAND_DRAWER_FIGURE_SET_COLOR, &commandData, exceptMsg!__FUNCTION__);
		}

		void remove(int figureGroupId) const {
			SDeleteFigureDrawerCommand commandData = {figureGroupId:figureGroupId};
			execCmd(CommandTopic.COMMAND_DRAWER_FIGURE_DELETE, &commandData, exceptMsg!__FUNCTION__);
		}
	}

	struct SPathDrawer {
	@nogc:
		void start(in SFloat4 pos, in SColor4 color, short alpha) const {
			short[3] color_colorS3;
			color.loadInto(color_colorS3);
			SStartPathDrawerCommand commandData = {
				pos_posF3:pos.ptr,
				color_colorS3:color_colorS3.ptr,
				alpha:alpha
			};
			execCmd(CommandTopic.COMMAND_DRAWER_PATH_START, &commandData, exceptMsg!__FUNCTION__);
		}

		void finish(bool iAmUseless) const {
			SFinishPathDrawerCommand commandData = {iAmUseless:iAmUseless};
			execCmd(CommandTopic.COMMAND_DRAWER_PATH_FINISH, &commandData, exceptMsg!__FUNCTION__);
		}

		void drawLine(in SFloat4 endPos, in SColor4 color, short alpha) const {
			short[3] color_colorS3;
			color.loadInto(color_colorS3);
			SDrawLinePathDrawerCommand commandData = {
				endPos_posF3:endPos.ptr,
				color_colorS3:color_colorS3.ptr,
				alpha:alpha,
			};
			execCmd(CommandTopic.COMMAND_DRAWER_PATH_DRAW_LINE, &commandData, exceptMsg!__FUNCTION__);
		}

		void drawLineAndCommandIcon(in SCommand cmd, in SFloat4 endPos, in SColor4 color, short alpha) const {
			short[3] color_colorS3;
			color.loadInto(color_colorS3);
			SDrawLineAndIconPathDrawerCommand commandData = {
				cmdId:cmd.id,
				endPos_posF3:endPos.ptr,
				color_colorS3:color_colorS3.ptr,
				alpha:alpha
			};
			execCmd(CommandTopic.COMMAND_DRAWER_PATH_DRAW_LINE_AND_ICON, &commandData, exceptMsg!__FUNCTION__);
		}

		void drawIcon(in SCommand cmd) const {
			SDrawIconAtLastPosPathDrawerCommand commandData = {cmdId:cmd.id};
			execCmd(CommandTopic.COMMAND_DRAWER_PATH_DRAW_ICON_AT_LAST_POS, &commandData, exceptMsg!__FUNCTION__);
		}

		void suspend(in SFloat4 endPos, in SColor4 color, short alpha) const {
			short[3] color_colorS3;
			color.loadInto(color_colorS3);
			SBreakPathDrawerCommand commandData = {
				endPos_posF3:endPos.ptr,
				color_colorS3:color_colorS3.ptr,
				alpha:alpha
			};
			execCmd(CommandTopic.COMMAND_DRAWER_PATH_BREAK, &commandData, exceptMsg!__FUNCTION__);
		}

		void restart(bool sameColor) const {
			SRestartPathDrawerCommand commandData = {sameColor:sameColor};
			execCmd(CommandTopic.COMMAND_DRAWER_PATH_RESTART, &commandData, exceptMsg!__FUNCTION__);
		}
	}
}
