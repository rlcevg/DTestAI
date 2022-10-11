module spring.game;

import spring.bind.callback;
import spring.bind.commands;
import spring.team;
import spring.economy.resource;
import spring.util.color4;
import spring.util.float4;
static {
	import std.conv;
	import std.string;
}

class CGame {
	int getCurrentFrame() const {
		return gCallback.Game_getCurrentFrame(gSkirmishAIId);
	}

	int getAiInterfaceVersion() const {
		return gCallback.Game_getAiInterfaceVersion(gSkirmishAIId);
	}

	int getMyTeam() const {
		return gCallback.Game_getMyTeam(gSkirmishAIId);
	}

	int getMyAllyTeam() const {
		return gCallback.Game_getMyAllyTeam(gSkirmishAIId);
	}

	int getPlayerTeam(int playerId) const {
		return gCallback.Game_getPlayerTeam(gSkirmishAIId, playerId);
	}

	string getTeamSide(in STeam team) const {
		return std.conv.to!string(gCallback.Game_getTeamSide(gSkirmishAIId, team.id));
	}

	SColor4 getTeamColor(in STeam team) const {
		short[3] colorS3_out;
		gCallback.Game_getTeamColor(gSkirmishAIId, team.id, colorS3_out.ptr);
		return SColor4(colorS3_out);
	}

	int getTeamAllyTeam(in STeam team) const {
		return gCallback.Game_getTeamAllyTeam(gSkirmishAIId, team.id);
	}

	float getTeamResourceCurrent(in STeam team, in SResource resource) const {
		return gCallback.Game_getTeamResourceCurrent(gSkirmishAIId, team.id, resource.id);
	}

	float getTeamResourceIncome(in STeam team, in SResource resource) const {
		return gCallback.Game_getTeamResourceIncome(gSkirmishAIId, team.id, resource.id);
	}

	float getTeamResourceUsage(in STeam team, in SResource resource) const {
		return gCallback.Game_getTeamResourceUsage(gSkirmishAIId, team.id, resource.id);
	}

	float getTeamResourceStorage(in STeam team, in SResource resource) const {
		return gCallback.Game_getTeamResourceStorage(gSkirmishAIId, team.id, resource.id);
	}

	float getTeamResourcePull(in STeam team, in SResource resource) const {
		return gCallback.Game_getTeamResourcePull(gSkirmishAIId, team.id, resource.id);
	}

	float getTeamResourceShare(in STeam team, in SResource resource) const {
		return gCallback.Game_getTeamResourceShare(gSkirmishAIId, team.id, resource.id);
	}

	float getTeamResourceSent(in STeam team, in SResource resource) const {
		return gCallback.Game_getTeamResourceSent(gSkirmishAIId, team.id, resource.id);
	}

	float getTeamResourceReceived(in STeam team, in SResource resource) const {
		return gCallback.Game_getTeamResourceReceived(gSkirmishAIId, team.id, resource.id);
	}

	float getTeamResourceExcess(in STeam team, in SResource resource) const {
		return gCallback.Game_getTeamResourceExcess(gSkirmishAIId, team.id, resource.id);
	}

	bool isAllied(int firstAllyTeamId, int secondAllyTeamId) const {
		return gCallback.Game_isAllied(gSkirmishAIId, firstAllyTeamId, secondAllyTeamId);
	}

	bool isDebugModeEnabled() const {
		return gCallback.Game_isDebugModeEnabled(gSkirmishAIId);
	}

	bool isPaused() const {
		return gCallback.Game_isPaused(gSkirmishAIId);
	}

	float getSpeedFactor() const {
		return gCallback.Game_getSpeedFactor(gSkirmishAIId);
	}

	string getSetupScript() const {
		return std.conv.to!string(gCallback.Game_getSetupScript(gSkirmishAIId));
	}

	int getCategoryFlag(string categoryName) const
	in (categoryName) {
		return gCallback.Game_getCategoryFlag(gSkirmishAIId, std.string.toStringz(categoryName));
	}

	int getCategoriesFlag(string categoryNames) const
	in (categoryNames) {
		return gCallback.Game_getCategoriesFlag(gSkirmishAIId, std.string.toStringz(categoryNames));
	}

	string getCategoryName(int categoryFlag) const {
		char[MAX_CHARS] buffer;
		gCallback.Game_getCategoryName(gSkirmishAIId, categoryFlag, buffer.ptr, MAX_CHARS);
		return std.conv.to!string(buffer);
	}

	float getRulesParamFloat(string rulesParamName, float defaultValue) const
	in (rulesParamName) {
		return gCallback.Game_getRulesParamFloat(gSkirmishAIId, std.string.toStringz(rulesParamName), defaultValue);
	}

	string getRulesParamString(string rulesParamName, string defaultValue) const
	in (rulesParamName)
	in (defaultValue) {
		return std.conv.to!string(gCallback.Game_getRulesParamString(gSkirmishAIId,
				std.string.toStringz(rulesParamName), std.string.toStringz(defaultValue)));
	}

	void sendTextMessage(string text, int zone) const {
		SSendTextMessageCommand commandData = {text:std.string.toStringz(text), zone:zone};
		execCmd(CommandTopic.COMMAND_SEND_TEXT_MESSAGE, &commandData, exceptMsg!__FUNCTION__);
	}

	void setLastMessagePosition(in SFloat4 pos) const {
		SSetLastPosMessageCommand commandData = {pos_posF3:pos.ptr};
		execCmd(CommandTopic.COMMAND_SET_LAST_POS_MESSAGE, &commandData, exceptMsg!__FUNCTION__);
	}

	void sendStartPosition(bool ready, in SFloat4 pos) const {
		SSendStartPosCommand commandData = {ready:ready, pos_posF3:pos.ptr};
		execCmd(CommandTopic.COMMAND_SEND_START_POS, &commandData, exceptMsg!__FUNCTION__);
	}

	void setPause(bool enable, string reason) const {
		SPauseCommand commandData = {enable:enable, reason:std.string.toStringz(reason)};
		execCmd(CommandTopic.COMMAND_PAUSE, &commandData, exceptMsg!__FUNCTION__);
	}
}
