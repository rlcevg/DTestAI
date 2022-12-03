module spring.drawer.graph_drawer;

import spring.bind.callback;
import spring.bind.commands;
import spring.util.color4;

struct SGraphDrawer {
@nogc:
	void setPosition(float x, float y) const {
		SSetPositionGraphDrawerDebugCommand commandData = {x:x, y:y};
		execCmd(CommandTopic.COMMAND_DEBUG_DRAWER_GRAPH_SET_POS, &commandData, exceptMsg!__FUNCTION__);
	}

	void setSize(float w, float h) const {
		SSetSizeGraphDrawerDebugCommand commandData = {w:w, h:h};
		execCmd(CommandTopic.COMMAND_DEBUG_DRAWER_GRAPH_SET_SIZE, &commandData, exceptMsg!__FUNCTION__);
	}

nothrow:
	bool isEnabled() const {
		return gCallback.Debug_GraphDrawer_isEnabled(gSkirmishAIId);
	}

	SGraphLine getGraphLine() const {
		return SGraphLine();
	}

	struct SGraphLine {
	@nogc:
		void addPoint(int lineId, float x, float y) const {
			SAddPointLineGraphDrawerDebugCommand commandData = {lineId:lineId, x:x, y:y};
			execCmd(CommandTopic.COMMAND_DEBUG_DRAWER_GRAPH_LINE_ADD_POINT, &commandData, exceptMsg!__FUNCTION__);
		}

		void deletePoints(int lineId, int numPoints) const {
			SDeletePointsLineGraphDrawerDebugCommand commandData = {lineId:lineId, numPoints:numPoints};
			execCmd(CommandTopic.COMMAND_DEBUG_DRAWER_GRAPH_LINE_DELETE_POINTS, &commandData, exceptMsg!__FUNCTION__);
		}

		void setColor(int lineId, in SColor4 color) const {
			short[3] color_colorS3;
			color.loadInto(color_colorS3);
			SSetColorLineGraphDrawerDebugCommand commandData = {lineId:lineId, color_colorS3:color_colorS3.ptr};
			execCmd(CommandTopic.COMMAND_DEBUG_DRAWER_GRAPH_LINE_SET_COLOR, &commandData, exceptMsg!__FUNCTION__);
		}

		void setLabel(int lineId, const(char)* label) const {
			// TODO: ensure that engine makes copy of label
			SSetLabelLineGraphDrawerDebugCommand commandData = {lineId:lineId, label:label};
			execCmd(CommandTopic.COMMAND_DEBUG_DRAWER_GRAPH_LINE_SET_LABEL, &commandData, exceptMsg!__FUNCTION__);
		}
	}
}
