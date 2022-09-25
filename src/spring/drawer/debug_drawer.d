module spring.drawer.debug_drawer;

import spring.bind.callback;
import spring.bind.commands;
import spring.drawer.graph_drawer;
static import std.string;

struct SDebugDrawer {
	SGraphDrawer getGraphDrawer() const {
		return SGraphDrawer();
	}

	SOverlayTexture addOverlayTexture(in float[] texData, int w, int h) const {
		SAddOverlayTextureDrawerDebugCommand commandData = {texData:texData.ptr, w:w, h:h};
		int internal_ret = gCallback.Engine_handleCommand(gSkirmishAIId, COMMAND_TO_ID_ENGINE, -1,
				CommandTopic.COMMAND_DEBUG_DRAWER_OVERLAYTEXTURE_ADD, &commandData);
		return SOverlayTexture((internal_ret == 0) ? commandData.ret_overlayTextureId : -1);
	}

	struct SOverlayTexture {
		mixin TEntity;

		void update(in float[] texData, int x, int y, int w, int h) const {
			SUpdateOverlayTextureDrawerDebugCommand commandData = {id, texData.ptr, x, y, w, h};
			execCmd(CommandTopic.COMMAND_DEBUG_DRAWER_OVERLAYTEXTURE_UPDATE, &commandData, exceptMsg!__FUNCTION__);
		}

		void del() const {
			SDeleteOverlayTextureDrawerDebugCommand commandData = {id};
			execCmd(CommandTopic.COMMAND_DEBUG_DRAWER_OVERLAYTEXTURE_DELETE, &commandData, exceptMsg!__FUNCTION__);
		}

		void setPos(float x, float y) const {
			SSetPositionOverlayTextureDrawerDebugCommand commandData = {id, x, y};
			execCmd(CommandTopic.COMMAND_DEBUG_DRAWER_OVERLAYTEXTURE_SET_POS, &commandData, exceptMsg!__FUNCTION__);
		}

		void setSize(float w, float h) const {
			SSetSizeOverlayTextureDrawerDebugCommand commandData = {id, w, h};
			execCmd(CommandTopic.COMMAND_DEBUG_DRAWER_OVERLAYTEXTURE_SET_SIZE, &commandData, exceptMsg!__FUNCTION__);
		}

		void setLabel(string texLabel) const
		in (texLabel) {
			// TODO: ensure that engine makes copy of texLabel
			SSetLabelOverlayTextureDrawerDebugCommand commandData = {id, std.string.toStringz(texLabel)};
			execCmd(CommandTopic.COMMAND_DEBUG_DRAWER_OVERLAYTEXTURE_SET_LABEL, &commandData, exceptMsg!__FUNCTION__);
		}
	}
}
