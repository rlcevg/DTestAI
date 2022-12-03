module spring.game;

import spring.bind.callback;
import spring.bind.commands;
import spring.team;
import spring.economy.resource;
import spring.util.color4;
import spring.util.float4;

class CGame {
nothrow @nogc {
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

	const(char)* getTeamSide(in STeam team) const {
		return gCallback.Game_getTeamSide(gSkirmishAIId, team.id);
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

	const(char)* getSetupScript() const {
		return gCallback.Game_getSetupScript(gSkirmishAIId);
	}

	int getCategoryFlag(const(char)* categoryName) const
	in (categoryName) {
		return gCallback.Game_getCategoryFlag(gSkirmishAIId, categoryName);
	}

	int getCategoriesFlag(const(char)* categoryNames) const
	in (categoryNames) {
		return gCallback.Game_getCategoriesFlag(gSkirmishAIId, categoryNames);
	}

	const(char)* getCategoryName(int categoryFlag) const {
		gCallback.Game_getCategoryName(gSkirmishAIId, categoryFlag, _buffer.ptr, MAX_CHARS);
		return _buffer.ptr;
	}

	float getRulesParamFloat(const(char)* rulesParamName, float defaultValue) const
	in (rulesParamName) {
		return gCallback.Game_getRulesParamFloat(gSkirmishAIId, rulesParamName, defaultValue);
	}

	const(char)* getRulesParamString(const(char)* rulesParamName, const(char)* defaultValue) const
	in (rulesParamName)
	in (defaultValue) {
		return gCallback.Game_getRulesParamString(gSkirmishAIId, rulesParamName, defaultValue);
	}
}
@nogc:
	void sendTextMessage(const(char)* text, int zone) const {
		SSendTextMessageCommand commandData = {text:text, zone:zone};
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

	void setPause(bool enable, const(char)* reason) const {
		SPauseCommand commandData = {enable:enable, reason:reason};
		execCmd(CommandTopic.COMMAND_PAUSE, &commandData, exceptMsg!__FUNCTION__);
	}

private:
	static char[MAX_CHARS] _buffer;
}
