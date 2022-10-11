module spring.group;

import spring.bind.callback;

struct SGroup {
	mixin TEntity;

	bool isSelected() const {
		return gCallback.Group_isSelected(gSkirmishAIId, id);
	}

	// int getSupportedCommands(int groupId) const {
	// 	return gCallback.Group_getSupportedCommands(gSkirmishAIId, groupId);
	// }

	// int SupportedCommand_getId(int groupId, int supportedCommandId) const {
	// 	return gCallback.Group_SupportedCommand_getId(gSkirmishAIId, groupId, supportedCommandId);
	// }

	// string SupportedCommand_getName(int groupId, int supportedCommandId) const {
	// 	return std.conv.to!string(gCallback.Group_SupportedCommand_getName(gSkirmishAIId, groupId, supportedCommandId));
	// }

	// string SupportedCommand_getToolTip(int groupId, int supportedCommandId) const {
	// 	return std.conv.to!string(gCallback.Group_SupportedCommand_getToolTip(gSkirmishAIId, groupId, supportedCommandId));
	// }

	// bool SupportedCommand_isShowUnique(int groupId, int supportedCommandId) const {
	// 	return new bool(gCallback.Group_SupportedCommand_isShowUnique(gSkirmishAIId, groupId, supportedCommandId), true);
	// }

	// bool SupportedCommand_isDisabled(int groupId, int supportedCommandId) const {
	// 	return new bool(gCallback.Group_SupportedCommand_isDisabled(gSkirmishAIId, groupId, supportedCommandId), true);
	// }

	// int SupportedCommand_getParams(int groupId, int supportedCommandId, char** params, int params_sizeMax) const {
	// 	return gCallback.Group_SupportedCommand_getParams(gSkirmishAIId, groupId, supportedCommandId, cast(void*)params, params_sizeMax);
	// }

	// int OrderPreview_getId(int groupId) const {
	// 	return gCallback.Group_OrderPreview_getId(gSkirmishAIId, groupId);
	// }

	// short OrderPreview_getOptions(int groupId) const {
	// 	return gCallback.Group_OrderPreview_getOptions(gSkirmishAIId, groupId);
	// }

	// int OrderPreview_getTag(int groupId) const {
	// 	return gCallback.Group_OrderPreview_getTag(gSkirmishAIId, groupId);
	// }

	// int OrderPreview_getTimeOut(int groupId) const {
	// 	return gCallback.Group_OrderPreview_getTimeOut(gSkirmishAIId, groupId);
	// }

	// int OrderPreview_getParams(int groupId, float* params, int params_sizeMax) const {
	// 	return gCallback.Group_OrderPreview_getParams(gSkirmishAIId, groupId, cast(void*)params, params_sizeMax);
	// }
}
