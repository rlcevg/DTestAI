module spring.bind.callback_struct;

extern (C):

/**
 * @brief Skirmish AI Callback function pointers.
 * Each Skirmish AI instance will receive an instance of this struct
 * in its init(skirmishAIId) function and with the SInitEvent.
 *
 * This struct contains only activities that leave the game state as it is,
 * in spring terms: unsynced events
 * Activities that change game state (-> synced events) are handled through
 * AI commands, defined in AISCommands.h.
 *
 * The skirmishAIId passed as the first parameter to each function in this
 * struct has to be the ID of the AI instance using the callback.
 */
struct SSkirmishAICallback
{
	/**
	 * Whenever an AI wants to change the engine state in any way,
	 * it has to call this method.
	 * In other words, all commands from AIs to the engine (and other AIs)
	 * go through this method.
	 *
	 * @param skirmishAIId the ID of the AI that sends the command
	 * @param toId         the team number of the AI that should receive
	 *                     the command, or COMMAND_TO_ID_ENGINE if it is addressed
	 *                     to the engine
	 * @param commandId    used on asynchronous commands, this allows the AI to
	 *                     identify a possible result event, which would come
	 *                     with the same id
	 * @param commandTopic unique identifier of a command
	 *                     (see COMMAND_* defines in AISCommands.h)
	 * @param commandData  a commandTopic specific struct, which contains
	 *                     the data associated with the command
	 *                     (see *Command structs)
	 * @return     0: if command handling ok
	 *          != 0: something else otherwise
	 */
	int function (int skirmishAIId, int toId, int commandId, int commandTopic, void* commandData) Engine_handleCommand;

	int function (int skirmishAIId, int unitId, int groupId, void* commandData) Engine_executeCommand;

	/// Returns the major engine revision number (e.g. 83)
	const(char)* function (int skirmishAIId) Engine_Version_getMajor;

	/**
	 * Minor version number (e.g. "5")
	 * @deprecated since 4. October 2011 (pre release 83), will always return "0"
	 */
	const(char)* function (int skirmishAIId) Engine_Version_getMinor;

	/**
	 * Clients that only differ in patchset can still play together.
	 * Also demos should be compatible between patchsets.
	 */
	const(char)* function (int skirmishAIId) Engine_Version_getPatchset;

	/**
	 * SCM Commits version part (e.g. "" or "13")
	 * Number of commits since the last version tag.
	 * This matches the regex "[0-9]*".
	 */
	const(char)* function (int skirmishAIId) Engine_Version_getCommits;

	/**
	 * SCM unique identifier for the current commit.
	 * This matches the regex "([0-9a-f]{6})?".
	 */
	const(char)* function (int skirmishAIId) Engine_Version_getHash;

	/**
	 * SCM branch name (e.g. "master" or "develop")
	 */
	const(char)* function (int skirmishAIId) Engine_Version_getBranch;

	/// Additional information (compiler flags, svn revision etc.)
	const(char)* function (int skirmishAIId) Engine_Version_getAdditional;

	/// time of build
	const(char)* function (int skirmishAIId) Engine_Version_getBuildTime;

	/// Returns whether this is a release build of the engine
	bool function (int skirmishAIId) Engine_Version_isRelease;

	/**
	 * The basic part of a spring version.
	 * This may only be used for sync-checking if IsRelease() returns true.
	 * @return "Major.PatchSet" or "Major.PatchSet.1"
	 */
	const(char)* function (int skirmishAIId) Engine_Version_getNormal;

	/**
	 * The sync relevant part of a spring version.
	 * This may be used for sync-checking through a simple string-equality test.
	 * @return "Major" or "Major.PatchSet.1-Commits-gHash Branch"
	 */
	const(char)* function (int skirmishAIId) Engine_Version_getSync;

	/**
	 * The verbose, human readable version.
	 * @return "Major.Patchset[.1-Commits-gHash Branch] (Additional)"
	 */
	const(char)* function (int skirmishAIId) Engine_Version_getFull;

	/** Returns the number of teams in this game */
	int function (int skirmishAIId) Teams_getSize;

	/** Returns the number of skirmish AIs in this game */
	int function (int skirmishAIId) SkirmishAIs_getSize;

	/** Returns the maximum number of skirmish AIs in any game */
	int function (int skirmishAIId) SkirmishAIs_getMax;

	/**
	 * Returns the ID of the team controled by this Skirmish AI.
	 */
	int function (int skirmishAIId) SkirmishAI_getTeamId;

	/**
	 * Returns the number of info key-value pairs in the info map
	 * for this Skirmish AI.
	 */
	int function (int skirmishAIId) SkirmishAI_Info_getSize;

	/**
	 * Returns the key at index infoIndex in the info map
	 * for this Skirmish AI, or NULL if the infoIndex is invalid.
	 */
	const(char)* function (int skirmishAIId, int infoIndex) SkirmishAI_Info_getKey;

	/**
	 * Returns the value at index infoIndex in the info map
	 * for this Skirmish AI, or NULL if the infoIndex is invalid.
	 */
	const(char)* function (int skirmishAIId, int infoIndex) SkirmishAI_Info_getValue;

	/**
	 * Returns the description of the key at index infoIndex in the info map
	 * for this Skirmish AI, or NULL if the infoIndex is invalid.
	 */
	const(char)* function (int skirmishAIId, int infoIndex) SkirmishAI_Info_getDescription;

	/**
	 * Returns the value associated with the given key in the info map
	 * for this Skirmish AI, or NULL if not found.
	 */
	const(char)* function (int skirmishAIId, const char* key) SkirmishAI_Info_getValueByKey;

	/**
	 * Returns the number of option key-value pairs in the options map
	 * for this Skirmish AI.
	 */
	int function (int skirmishAIId) SkirmishAI_OptionValues_getSize;

	/**
	 * Returns the key at index optionIndex in the options map
	 * for this Skirmish AI, or NULL if the optionIndex is invalid.
	 */
	const(char)* function (int skirmishAIId, int optionIndex) SkirmishAI_OptionValues_getKey;

	/**
	 * Returns the value at index optionIndex in the options map
	 * for this Skirmish AI, or NULL if the optionIndex is invalid.
	 */
	const(char)* function (int skirmishAIId, int optionIndex) SkirmishAI_OptionValues_getValue;

	/**
	 * Returns the value associated with the given key in the options map
	 * for this Skirmish AI, or NULL if not found.
	 */
	const(char)* function (int skirmishAIId, const char* key) SkirmishAI_OptionValues_getValueByKey;

	/** This will end up in infolog */
	void function (int skirmishAIId, const char* msg) Log_log;

	/**
	 * Inform the engine of an error that happend in the interface.
	 * @param   msg       error message
	 * @param   severety  from 10 for minor to 0 for fatal
	 * @param   die       if this is set to true, the engine assumes
	 *                    the interface is in an irreparable state, and it will
	 *                    unload it immediately.
	 */
	void function (int skirmishAIId, const char* msg, int severety, bool die) Log_exception;

	/** Returns '/' on posix and '\\' on windows */
	char function (int skirmishAIId) DataDirs_getPathSeparator;

	/**
	 * This interfaces main data dir, which is where the shared library
	 * and the InterfaceInfo.lua file are located, e.g.:
	 * /usr/share/games/spring/AI/Skirmish/RAI/0.601/
	 */
	const(char)* function (int skirmishAIId) DataDirs_getConfigDir;

	/**
	 * This interfaces writable data dir, which is where eg logs, caches
	 * and learning data should be stored, e.g.:
	 * /home/userX/.spring/AI/Skirmish/RAI/0.601/
	 */
	const(char)* function (int skirmishAIId) DataDirs_getWriteableDir;

	/**
	 * Returns an absolute path which consists of:
	 * data-dir + Skirmish-AI-path + relative-path.
	 *
	 * example:
	 * input:  "log/main.log", writeable, create, !dir, !common
	 * output: "/home/userX/.spring/AI/Skirmish/RAI/0.601/log/main.log"
	 * The path "/home/userX/.spring/AI/Skirmish/RAI/0.601/log/" is created,
	 * if it does not yet exist.
	 *
	 * @see DataDirs_Roots_locatePath
	 * @param   path          store for the resulting absolute path
	 * @param   path_sizeMax  storage size of the above
	 * @param   writeable  if true, only the writable data-dir is considered
	 * @param   create     if true, and realPath is not found, its dir structure
	 *                     is created recursively under the writable data-dir
	 * @param   dir        if true, realPath specifies a dir, which means if
	 *                     create is true, the whole path will be created,
	 *                     including the last part
	 * @param   common     if true, the version independent data-dir is formed,
	 *                     which uses "common" instead of the version, eg:
	 *                     "/home/userX/.spring/AI/Skirmish/RAI/common/..."
	 * @return  whether the locating process was successfull
	 *          -> the path exists and is stored in an absolute form in path
	 */
	bool function (int skirmishAIId, char* path, int path_sizeMax, const char* relPath, bool writeable, bool create, bool dir, bool common) DataDirs_locatePath;

	/**
	 * @see     locatePath()
	 */
	char* function (int skirmishAIId, const char* relPath, bool writeable, bool create, bool dir, bool common) DataDirs_allocatePath;

	/** Returns the number of springs data dirs. */
	int function (int skirmishAIId) DataDirs_Roots_getSize;

	/** Returns the data dir at dirIndex, which is valid between 0 and (DataDirs_Roots_getSize() - 1). */
	bool function (int skirmishAIId, char* path, int path_sizeMax, int dirIndex) DataDirs_Roots_getDir;

	/**
	 * Returns an absolute path which consists of:
	 * data-dir + relative-path.
	 *
	 * example:
	 * input:  "AI/Skirmish", writeable, create, dir
	 * output: "/home/userX/.spring/AI/Skirmish/"
	 * The path "/home/userX/.spring/AI/Skirmish/" is created,
	 * if it does not yet exist.
	 *
	 * @see DataDirs_locatePath
	 * @param   path          store for the resulting absolute path
	 * @param   path_sizeMax  storage size of the above
	 * @param   relPath    the relative path to find
	 * @param   writeable  if true, only the writable data-dir is considered
	 * @param   create     if true, and realPath is not found, its dir structure
	 *                     is created recursively under the writable data-dir
	 * @param   dir        if true, realPath specifies a dir, which means if
	 *                     create is true, the whole path will be created,
	 *                     including the last part
	 * @return  whether the locating process was successfull
	 *          -> the path exists and is stored in an absolute form in path
	 */
	bool function (int skirmishAIId, char* path, int path_sizeMax, const char* relPath, bool writeable, bool create, bool dir) DataDirs_Roots_locatePath;

	char* function (int skirmishAIId, const char* relPath, bool writeable, bool create, bool dir) DataDirs_Roots_allocatePath;

	// BEGINN misc callback functions
	/**
	 * Returns the current game time measured in frames (the
	 * simulation runs at 30 frames per second at normal speed)
	 *
	 * This should not be used, as we get the frame from the SUpdateEvent.
	 * @deprecated
	 */
	int function (int skirmishAIId) Game_getCurrentFrame;

	int function (int skirmishAIId) Game_getAiInterfaceVersion;

	int function (int skirmishAIId) Game_getMyTeam;

	int function (int skirmishAIId) Game_getMyAllyTeam;

	int function (int skirmishAIId, int playerId) Game_getPlayerTeam;

	/**
	 * Returns the number of active teams participating
	 * in the currently running game.
	 * A return value of 6 for example, would mean that teams 0 till 5
	 * take part in the game.
	 */
	int function (int skirmishAIId) Game_getTeams;

	/**
	 * Returns the name of the side of a team in the game.
	 *
	 * This should not be used, as it may be "",
	 * and as the AI should rather rely on the units it has,
	 * which will lead to a more stable and versatile AI.
	 * @deprecated
	 *
	 * @return eg. "ARM" or "CORE"; may be "", depending on how the game was setup
	 */
	const(char)* function (int skirmishAIId, int otherTeamId) Game_getTeamSide;

	/**
	 * Returns the color of a team in the game.
	 *
	 * This should only be used when drawing stuff,
	 * and not for team-identification.
	 * @return the RGB color of a team, with values in [0, 255]
	 */
	void function (int skirmishAIId, int otherTeamId, short* return_colorS3_out) Game_getTeamColor;

	/**
	 * Returns the income multiplier of a team in the game.
	 * All the teams resource income is multiplied by this factor.
	 * The default value is 1.0f, the valid range is [0.0, FLOAT_MAX].
	 */
	float function (int skirmishAIId, int otherTeamId) Game_getTeamIncomeMultiplier;

	/// Returns the ally-team of a team
	int function (int skirmishAIId, int otherTeamId) Game_getTeamAllyTeam;

	/**
	 * Returns the current level of a resource of another team.
	 * Allways works for allied teams.
	 * Works for all teams when cheating is enabled.
	 * @return current level of the requested resource of the other team, or -1.0 on an invalid request
	 */
	float function (int skirmishAIId, int otherTeamId, int resourceId) Game_getTeamResourceCurrent;

	/**
	 * Returns the current income of a resource of another team.
	 * Allways works for allied teams.
	 * Works for all teams when cheating is enabled.
	 * @return current income of the requested resource of the other team, or -1.0 on an invalid request
	 */
	float function (int skirmishAIId, int otherTeamId, int resourceId) Game_getTeamResourceIncome;

	/**
	 * Returns the current usage of a resource of another team.
	 * Allways works for allied teams.
	 * Works for all teams when cheating is enabled.
	 * @return current usage of the requested resource of the other team, or -1.0 on an invalid request
	 */
	float function (int skirmishAIId, int otherTeamId, int resourceId) Game_getTeamResourceUsage;

	/**
	 * Returns the storage capacity for a resource of another team.
	 * Allways works for allied teams.
	 * Works for all teams when cheating is enabled.
	 * @return storage capacity for the requested resource of the other team, or -1.0 on an invalid request
	 */
	float function (int skirmishAIId, int otherTeamId, int resourceId) Game_getTeamResourceStorage;

	float function (int skirmishAIId, int otherTeamId, int resourceId) Game_getTeamResourcePull;

	float function (int skirmishAIId, int otherTeamId, int resourceId) Game_getTeamResourceShare;

	float function (int skirmishAIId, int otherTeamId, int resourceId) Game_getTeamResourceSent;

	float function (int skirmishAIId, int otherTeamId, int resourceId) Game_getTeamResourceReceived;

	float function (int skirmishAIId, int otherTeamId, int resourceId) Game_getTeamResourceExcess;

	/// Returns true, if the two supplied ally-teams are currently allied
	bool function (int skirmishAIId, int firstAllyTeamId, int secondAllyTeamId) Game_isAllied;

	bool function (int skirmishAIId) Game_isDebugModeEnabled;

	int function (int skirmishAIId) Game_getMode;

	bool function (int skirmishAIId) Game_isPaused;

	float function (int skirmishAIId) Game_getSpeedFactor;

	const(char)* function (int skirmishAIId) Game_getSetupScript;

	/**
	 * Returns the categories bit field value.
	 * @return the categories bit field value or 0,
	 *         in case of empty name or too many categories
	 * @see getCategoryName
	 */
	int function (int skirmishAIId, const(char)* categoryName) Game_getCategoryFlag;

	/**
	 * Returns the bitfield values of a list of category names.
	 * @param categoryNames space delimited list of names
	 * @see Game#getCategoryFlag
	 */
	int function (int skirmishAIId, const(char)* categoryNames) Game_getCategoriesFlag;

	/**
	 * Return the name of the category described by a category flag.
	 * @see Game#getCategoryFlag
	 */
	void function (int skirmishAIId, int categoryFlag, char* name, int name_sizeMax) Game_getCategoryName;

	/**
	 * @return float value of parameter if it's set, defaultValue otherwise.
	 */
	float function (int skirmishAIId, const(char)* gameRulesParamName, float defaultValue) Game_getRulesParamFloat;

	/**
	 * @return string value of parameter if it's set, defaultValue otherwise.
	 */
	const(char)* function (int skirmishAIId, const(char)* gameRulesParamName, const(char)* defaultValue) Game_getRulesParamString;

	// END misc callback functions

	// BEGINN Visualization related callback functions
	float function (int skirmishAIId) Gui_getViewRange;

	float function (int skirmishAIId) Gui_getScreenX;

	float function (int skirmishAIId) Gui_getScreenY;

	void function (int skirmishAIId, float* return_posF3_out) Gui_Camera_getDirection;

	void function (int skirmishAIId, float* return_posF3_out) Gui_Camera_getPosition;

	// END Visualization related callback functions

	// BEGINN OBJECT Cheats
	/**
	 * Returns whether this AI may use active cheats.
	 */
	bool function (int skirmishAIId) Cheats_isEnabled;

	/**
	 * Set whether this AI may use active cheats.
	 */
	bool function (int skirmishAIId, bool enable) Cheats_setEnabled;

	/**
	 * Set whether this AI may receive cheat events.
	 * When enabled, you would for example get informed when enemy units are
	 * created, even without sensor coverage.
	 */
	bool function (int skirmishAIId, bool enabled) Cheats_setEventsEnabled;

	/**
	 * Returns whether cheats will desync if used by an AI.
	 * @return always true, unless we are both the host and the only client.
	 */
	bool function (int skirmishAIId) Cheats_isOnlyPassive;

	// END OBJECT Cheats

	// BEGINN OBJECT Resource
	int function (int skirmishAIId) getResources; //$ FETCHER:MULTI:NUM:Resource

	int function (int skirmishAIId, const(char)* resourceName) getResourceByName; //$ REF:RETURN->Resource

	const(char)* function (int skirmishAIId, int resourceId) Resource_getName;

	float function (int skirmishAIId, int resourceId) Resource_getOptimum;

	float function (int skirmishAIId, int resourceId) Economy_getCurrent; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int resourceId) Economy_getIncome; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int resourceId) Economy_getUsage; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int resourceId) Economy_getStorage; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int resourceId) Economy_getPull; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int resourceId) Economy_getShare; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int resourceId) Economy_getSent; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int resourceId) Economy_getReceived; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int resourceId) Economy_getExcess; //$ REF:resourceId->Resource

	// END OBJECT Resource

	// BEGINN OBJECT File
	/** Return -1 when the file does not exist */
	int function (int skirmishAIId, const(char)* fileName) File_getSize;

	/** Returns false when file does not exist, or the buffer is too small */
	bool function (int skirmishAIId, const(char)* fileName, void* buffer, int bufferLen) File_getContent;

	//bool              (CALLING_CONV *File_locateForReading)(int skirmishAIId, char* fileName, int fileName_sizeMax);

	//bool              (CALLING_CONV *File_locateForWriting)(int skirmishAIId, char* fileName, int fileName_sizeMax);

	// END OBJECT File

	// BEGINN OBJECT UnitDef
	/**
	 * A UnitDef contains all properties of a unit that are specific to its type,
	 * for example the number and type of weapons or max-speed.
	 * These properties are usually fixed, and not meant to change during a game.
	 * The unitId is a unique id for this type of unit.
	 */
	int function (int skirmishAIId, int* unitDefIds, int unitDefIds_sizeMax) getUnitDefs; //$ FETCHER:MULTI:IDs:UnitDef:unitDefIds

	int function (int skirmishAIId, const(char)* unitName) getUnitDefByName; //$ REF:RETURN->UnitDef

	/** Forces loading of the unit model */
	float function (int skirmishAIId, int unitDefId) UnitDef_getHeight;

	/** Forces loading of the unit model */
	float function (int skirmishAIId, int unitDefId) UnitDef_getRadius;

	const(char)* function (int skirmishAIId, int unitDefId) UnitDef_getName;

	const(char)* function (int skirmishAIId, int unitDefId) UnitDef_getHumanName;

	float function (int skirmishAIId, int unitDefId, int resourceId) UnitDef_getUpkeep; //$ REF:resourceId->Resource

	/** This amount of the resource will always be created. */
	float function (int skirmishAIId, int unitDefId, int resourceId) UnitDef_getResourceMake; //$ REF:resourceId->Resource

	/**
	 * This amount of the resource will be created when the unit is on and enough
	 * energy can be drained.
	 */
	float function (int skirmishAIId, int unitDefId, int resourceId) UnitDef_getMakesResource; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int unitDefId, int resourceId) UnitDef_getCost; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int unitDefId, int resourceId) UnitDef_getExtractsResource; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int unitDefId, int resourceId) UnitDef_getResourceExtractorRange; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int unitDefId, int resourceId) UnitDef_getWindResourceGenerator; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int unitDefId, int resourceId) UnitDef_getTidalResourceGenerator; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int unitDefId, int resourceId) UnitDef_getStorage; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int unitDefId) UnitDef_getBuildTime;

	/** This amount of auto-heal will always be applied. */
	float function (int skirmishAIId, int unitDefId) UnitDef_getAutoHeal;

	/** This amount of auto-heal will only be applied while the unit is idling. */
	float function (int skirmishAIId, int unitDefId) UnitDef_getIdleAutoHeal;

	/** Time a unit needs to idle before it is considered idling. */
	int function (int skirmishAIId, int unitDefId) UnitDef_getIdleTime;

	float function (int skirmishAIId, int unitDefId) UnitDef_getPower;

	float function (int skirmishAIId, int unitDefId) UnitDef_getHealth;

	/**
	 * Returns the bit field value denoting the categories this unit is in.
	 * @see Game#getCategoryFlag
	 * @see Game#getCategoryName
	 */
	int function (int skirmishAIId, int unitDefId) UnitDef_getCategory;

	float function (int skirmishAIId, int unitDefId) UnitDef_getSpeed;

	float function (int skirmishAIId, int unitDefId) UnitDef_getTurnRate;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isTurnInPlace;

	/**
	 * Units above this distance to goal will try to turn while keeping
	 * some of their speed.
	 * 0 to disable
	 */
	float function (int skirmishAIId, int unitDefId) UnitDef_getTurnInPlaceDistance;

	/**
	 * Units below this speed will turn in place regardless of their
	 * turnInPlace setting.
	 */
	float function (int skirmishAIId, int unitDefId) UnitDef_getTurnInPlaceSpeedLimit;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isUpright;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isCollide;

	float function (int skirmishAIId, int unitDefId) UnitDef_getLosRadius;

	float function (int skirmishAIId, int unitDefId) UnitDef_getAirLosRadius;

	float function (int skirmishAIId, int unitDefId) UnitDef_getLosHeight;

	int function (int skirmishAIId, int unitDefId) UnitDef_getRadarRadius;

	int function (int skirmishAIId, int unitDefId) UnitDef_getSonarRadius;

	int function (int skirmishAIId, int unitDefId) UnitDef_getJammerRadius;

	int function (int skirmishAIId, int unitDefId) UnitDef_getSonarJamRadius;

	int function (int skirmishAIId, int unitDefId) UnitDef_getSeismicRadius;

	float function (int skirmishAIId, int unitDefId) UnitDef_getSeismicSignature;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isStealth;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isSonarStealth;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isBuildRange3D;

	float function (int skirmishAIId, int unitDefId) UnitDef_getBuildDistance;

	float function (int skirmishAIId, int unitDefId) UnitDef_getBuildSpeed;

	float function (int skirmishAIId, int unitDefId) UnitDef_getReclaimSpeed;

	float function (int skirmishAIId, int unitDefId) UnitDef_getRepairSpeed;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMaxRepairSpeed;

	float function (int skirmishAIId, int unitDefId) UnitDef_getResurrectSpeed;

	float function (int skirmishAIId, int unitDefId) UnitDef_getCaptureSpeed;

	float function (int skirmishAIId, int unitDefId) UnitDef_getTerraformSpeed;

	float function (int skirmishAIId, int unitDefId) UnitDef_getUpDirSmoothing;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMass;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isPushResistant;

	/** Should the unit move sideways when it can not shoot? */
	bool function (int skirmishAIId, int unitDefId) UnitDef_isStrafeToAttack;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMinCollisionSpeed;

	float function (int skirmishAIId, int unitDefId) UnitDef_getSlideTolerance;

	/**
	 * Maximum terra-form height this building allows.
	 * If this value is 0.0, you can only build this structure on
	 * totally flat terrain.
	 */
	float function (int skirmishAIId, int unitDefId) UnitDef_getMaxHeightDif;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMinWaterDepth;

	float function (int skirmishAIId, int unitDefId) UnitDef_getWaterline;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMaxWaterDepth;

	float function (int skirmishAIId, int unitDefId) UnitDef_getArmoredMultiple;

	int function (int skirmishAIId, int unitDefId) UnitDef_getArmorType;

	/**
	 * The flanking bonus indicates how much additional damage you can inflict to
	 * a unit, if it gets attacked from different directions.
	 * See the spring source code if you want to know it more precisely.
	 *
	 * @return  0: no flanking bonus
	 *          1: global coords, mobile
	 *          2: unit coords, mobile
	 *          3: unit coords, locked
	 */
	int function (int skirmishAIId, int unitDefId) UnitDef_FlankingBonus_getMode;

	/**
	 * The unit takes less damage when attacked from this direction.
	 * This encourage flanking fire.
	 */
	void function (int skirmishAIId, int unitDefId, float* return_posF3_out) UnitDef_FlankingBonus_getDir;

	/** Damage factor for the least protected direction */
	float function (int skirmishAIId, int unitDefId) UnitDef_FlankingBonus_getMax;

	/** Damage factor for the most protected direction */
	float function (int skirmishAIId, int unitDefId) UnitDef_FlankingBonus_getMin;

	/**
	 * How much the ability of the flanking bonus direction to move builds up each
	 * frame.
	 */
	float function (int skirmishAIId, int unitDefId) UnitDef_FlankingBonus_getMobilityAdd;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMaxWeaponRange;

	const(char)* function (int skirmishAIId, int unitDefId) UnitDef_getTooltip;

	const(char)* function (int skirmishAIId, int unitDefId) UnitDef_getWreckName;

	int function (int skirmishAIId, int unitDefId) UnitDef_getDeathExplosion; //$ REF:RETURN->WeaponDef

	int function (int skirmishAIId, int unitDefId) UnitDef_getSelfDExplosion; //$ REF:RETURN->WeaponDef

	/**
	 * Returns the name of the category this unit is in.
	 * @see Game#getCategoryFlag
	 * @see Game#getCategoryName
	 */
	const(char)* function (int skirmishAIId, int unitDefId) UnitDef_getCategoryString;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToSelfD;

	int function (int skirmishAIId, int unitDefId) UnitDef_getSelfDCountdown;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToSubmerge;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToFly;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToMove;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToHover;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isFloater;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isBuilder;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isActivateWhenBuilt;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isOnOffable;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isFullHealthFactory;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isFactoryHeadingTakeoff;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isReclaimable;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isCapturable;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToRestore;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToRepair;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToSelfRepair;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToReclaim;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToAttack;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToPatrol;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToFight;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToGuard;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToAssist;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAssistable;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToRepeat;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToFireControl;

	int function (int skirmishAIId, int unitDefId) UnitDef_getFireState;

	int function (int skirmishAIId, int unitDefId) UnitDef_getMoveState;

	// beginn: aircraft stuff
	float function (int skirmishAIId, int unitDefId) UnitDef_getWingDrag;

	float function (int skirmishAIId, int unitDefId) UnitDef_getWingAngle;

	float function (int skirmishAIId, int unitDefId) UnitDef_getFrontToSpeed;

	float function (int skirmishAIId, int unitDefId) UnitDef_getSpeedToFront;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMyGravity;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMaxBank;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMaxPitch;

	float function (int skirmishAIId, int unitDefId) UnitDef_getTurnRadius;

	float function (int skirmishAIId, int unitDefId) UnitDef_getWantedHeight;

	float function (int skirmishAIId, int unitDefId) UnitDef_getVerticalSpeed;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isHoverAttack;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAirStrafe;

	/**
	 * @return  < 0:  it can land
	 *          >= 0: how much the unit will move during hovering on the spot
	 */
	float function (int skirmishAIId, int unitDefId) UnitDef_getDlHoverFactor;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMaxAcceleration;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMaxDeceleration;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMaxAileron;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMaxElevator;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMaxRudder;

	// end: aircraft stuff
	/**
	 * The yard map defines which parts of the square a unit occupies
	 * can still be walked on by other units.
	 * Example:
	 * In the BA Arm T2 K-Bot lab, htere is a line in hte middle where units
	 * walk, otherwise they would not be able ot exit the lab once they are
	 * built.
	 * @return 0 if invalid facing or the unit has no yard-map defined,
	 *         the size of the yard-map otherwise: getXSize() * getXSize()
	 */
	int function (int skirmishAIId, int unitDefId, int facing, short* yardMap, int yardMap_sizeMax) UnitDef_getYardMap; //$ ARRAY:yardMap

	int function (int skirmishAIId, int unitDefId) UnitDef_getXSize;

	int function (int skirmishAIId, int unitDefId) UnitDef_getZSize;

	// beginn: transports stuff
	float function (int skirmishAIId, int unitDefId) UnitDef_getLoadingRadius;

	float function (int skirmishAIId, int unitDefId) UnitDef_getUnloadSpread;

	int function (int skirmishAIId, int unitDefId) UnitDef_getTransportCapacity;

	int function (int skirmishAIId, int unitDefId) UnitDef_getTransportSize;

	int function (int skirmishAIId, int unitDefId) UnitDef_getMinTransportSize;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAirBase;

	/**  */
	bool function (int skirmishAIId, int unitDefId) UnitDef_isFirePlatform;

	float function (int skirmishAIId, int unitDefId) UnitDef_getTransportMass;

	float function (int skirmishAIId, int unitDefId) UnitDef_getMinTransportMass;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isHoldSteady;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isReleaseHeld;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isNotTransportable;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isTransportByEnemy;

	/**
	 * @return  0: land unload
	 *          1: fly-over drop
	 *          2: land flood
	 */
	int function (int skirmishAIId, int unitDefId) UnitDef_getTransportUnloadMethod;

	/**
	 * Dictates fall speed of all transported units.
	 * This only makes sense for air transports,
	 * if they an drop units while in the air.
	 */
	float function (int skirmishAIId, int unitDefId) UnitDef_getFallSpeed;

	/** Sets the transported units FBI, overrides fallSpeed */
	float function (int skirmishAIId, int unitDefId) UnitDef_getUnitFallSpeed;

	// end: transports stuff
	/** If the unit can cloak */
	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToCloak;

	/** If the unit wants to start out cloaked */
	bool function (int skirmishAIId, int unitDefId) UnitDef_isStartCloaked;

	/** Energy cost per second to stay cloaked when stationary */
	float function (int skirmishAIId, int unitDefId) UnitDef_getCloakCost;

	/** Energy cost per second to stay cloaked when moving */
	float function (int skirmishAIId, int unitDefId) UnitDef_getCloakCostMoving;

	/** If enemy unit comes within this range, decloaking is forced */
	float function (int skirmishAIId, int unitDefId) UnitDef_getDecloakDistance;

	/** Use a spherical, instead of a cylindrical test? */
	bool function (int skirmishAIId, int unitDefId) UnitDef_isDecloakSpherical;

	/** Will the unit decloak upon firing? */
	bool function (int skirmishAIId, int unitDefId) UnitDef_isDecloakOnFire;

	/** Will the unit self destruct if an enemy comes to close? */
	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToKamikaze;

	float function (int skirmishAIId, int unitDefId) UnitDef_getKamikazeDist;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isTargetingFacility;

	bool function (int skirmishAIId, int unitDefId) UnitDef_canManualFire;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isNeedGeo;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isFeature;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isHideDamage;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isShowPlayerName;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToResurrect;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToCapture;

	/**
	 * Indicates the trajectory types supported by this unit.
	 *
	 * @return  0: (default) = only low
	 *          1: only high
	 *          2: choose
	 */
	int function (int skirmishAIId, int unitDefId) UnitDef_getHighTrajectoryType;

	/**
	 * Returns the bit field value denoting the categories this unit shall not
	 * chase.
	 * @see Game#getCategoryFlag
	 * @see Game#getCategoryName
	 */
	int function (int skirmishAIId, int unitDefId) UnitDef_getNoChaseCategory;

	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToDropFlare;

	float function (int skirmishAIId, int unitDefId) UnitDef_getFlareReloadTime;

	float function (int skirmishAIId, int unitDefId) UnitDef_getFlareEfficiency;

	float function (int skirmishAIId, int unitDefId) UnitDef_getFlareDelay;

	void function (int skirmishAIId, int unitDefId, float* return_posF3_out) UnitDef_getFlareDropVector;

	int function (int skirmishAIId, int unitDefId) UnitDef_getFlareTime;

	int function (int skirmishAIId, int unitDefId) UnitDef_getFlareSalvoSize;

	int function (int skirmishAIId, int unitDefId) UnitDef_getFlareSalvoDelay;

	/** Only matters for fighter aircraft */
	bool function (int skirmishAIId, int unitDefId) UnitDef_isAbleToLoopbackAttack;

	/**
	 * Indicates whether the ground will be leveled/flattened out
	 * after this building has been built on it.
	 * Only matters for buildings.
	 */
	bool function (int skirmishAIId, int unitDefId) UnitDef_isLevelGround;

	/** Number of units of this type allowed simultaneously in the game */
	int function (int skirmishAIId, int unitDefId) UnitDef_getMaxThisUnit;

	int function (int skirmishAIId, int unitDefId) UnitDef_getDecoyDef; //$ REF:RETURN->UnitDef

	bool function (int skirmishAIId, int unitDefId) UnitDef_isDontLand;

	int function (int skirmishAIId, int unitDefId) UnitDef_getShieldDef; //$ REF:RETURN->WeaponDef

	int function (int skirmishAIId, int unitDefId) UnitDef_getStockpileDef; //$ REF:RETURN->WeaponDef

	int function (int skirmishAIId, int unitDefId, int* unitDefIds, int unitDefIds_sizeMax) UnitDef_getBuildOptions; //$ REF:MULTI:unitDefIds->UnitDef

	int function (int skirmishAIId, int unitDefId, const(char*)* keys, const(char*)* values) UnitDef_getCustomParams; //$ MAP

	bool function (int skirmishAIId, int unitDefId) UnitDef_isMoveDataAvailable; //$ AVAILABLE:MoveData

	int function (int skirmishAIId, int unitDefId) UnitDef_MoveData_getXSize;

	int function (int skirmishAIId, int unitDefId) UnitDef_MoveData_getZSize;

	float function (int skirmishAIId, int unitDefId) UnitDef_MoveData_getDepth;

	float function (int skirmishAIId, int unitDefId) UnitDef_MoveData_getMaxSlope;

	float function (int skirmishAIId, int unitDefId) UnitDef_MoveData_getSlopeMod;

	float function (int skirmishAIId, int unitDefId, float height) UnitDef_MoveData_getDepthMod;

	int function (int skirmishAIId, int unitDefId) UnitDef_MoveData_getPathType;

	float function (int skirmishAIId, int unitDefId) UnitDef_MoveData_getCrushStrength;

	/** enum SpeedModClass { Tank=0, KBot=1, Hover=2, Ship=3 }; */
	int function (int skirmishAIId, int unitDefId) UnitDef_MoveData_getSpeedModClass;

	int function (int skirmishAIId, int unitDefId) UnitDef_MoveData_getTerrainClass;

	bool function (int skirmishAIId, int unitDefId) UnitDef_MoveData_getFollowGround;

	bool function (int skirmishAIId, int unitDefId) UnitDef_MoveData_isSubMarine;

	const(char)* function (int skirmishAIId, int unitDefId) UnitDef_MoveData_getName;

	int function (int skirmishAIId, int unitDefId) UnitDef_getWeaponMounts; //$ FETCHER:MULTI:NUM:WeaponMount

	const(char)* function (int skirmishAIId, int unitDefId, int weaponMountId) UnitDef_WeaponMount_getName;

	int function (int skirmishAIId, int unitDefId, int weaponMountId) UnitDef_WeaponMount_getWeaponDef; //$ REF:RETURN->WeaponDef

	int function (int skirmishAIId, int unitDefId, int weaponMountId) UnitDef_WeaponMount_getSlavedTo;

	void function (int skirmishAIId, int unitDefId, int weaponMountId, float* return_posF3_out) UnitDef_WeaponMount_getMainDir;

	float function (int skirmishAIId, int unitDefId, int weaponMountId) UnitDef_WeaponMount_getMaxAngleDif;

	/**
	 * Returns the bit field value denoting the categories this weapon should
	 * not target.
	 * @see Game#getCategoryFlag
	 * @see Game#getCategoryName
	 */
	int function (int skirmishAIId, int unitDefId, int weaponMountId) UnitDef_WeaponMount_getBadTargetCategory;

	/**
	 * Returns the bit field value denoting the categories this weapon should
	 * target, excluding all others.
	 * @see Game#getCategoryFlag
	 * @see Game#getCategoryName
	 */
	int function (int skirmishAIId, int unitDefId, int weaponMountId) UnitDef_WeaponMount_getOnlyTargetCategory;

	// END OBJECT UnitDef

	// BEGINN OBJECT Unit
	/**
	 * Returns the number of units a team can have, after which it can not build
	 * any more. It is possible that a team has more units then this value at
	 * some point in the game. This is possible for example with taking,
	 * reclaiming or capturing units.
	 * This value is usefull for controlling game performance, and will
	 * therefore often be set on games with old hardware to prevent lagging
	 * because of too many units.
	 */
	int function (int skirmishAIId) Unit_getLimit; //$ STATIC

	/**
	 * Returns the maximum total number of units that may exist at any one point
	 * in time induring the current game.
	 */
	int function (int skirmishAIId) Unit_getMax; //$ STATIC

	/**
	 * Returns all units that are not in this teams ally-team nor neutral
	 * and are in LOS.
	 * If cheats are enabled, this will return all enemies on the map.
	 */
	int function (int skirmishAIId, int* unitIds, int unitIds_sizeMax) getEnemyUnits; //$ FETCHER:MULTI:IDs:Unit:unitIds

	/**
	 * Returns all units that are not in this teams ally-team nor neutral
	 * and are in LOS plus they have to be located in the specified area
	 * of the map.
	 * If cheats are enabled, this will return all enemies
	 * in the specified area.
	 */
	int function (int skirmishAIId, in float* pos_posF3, float radius, bool spherical, int* unitIds, int unitIds_sizeMax) getEnemyUnitsIn; //$ FETCHER:MULTI:IDs:Unit:unitIds

	/**
	 * Returns all units that are not in this teams ally-team nor neutral
	 * and are in under sensor coverage (sight or radar).
	 * If cheats are enabled, this will return all enemies on the map.
	 */
	int function (int skirmishAIId, int* unitIds, int unitIds_sizeMax) getEnemyUnitsInRadarAndLos; //$ FETCHER:MULTI:IDs:Unit:unitIds

	/**
	 * Returns all units that are in this teams ally-team, including this teams
	 * units.
	 */
	int function (int skirmishAIId, int* unitIds, int unitIds_sizeMax) getFriendlyUnits; //$ FETCHER:MULTI:IDs:Unit:unitIds

	/**
	 * Returns all units that are in this teams ally-team, including this teams
	 * units plus they have to be located in the specified area of the map.
	 */
	int function (int skirmishAIId, in float* pos_posF3, float radius, bool spherical, int* unitIds, int unitIds_sizeMax) getFriendlyUnitsIn; //$ FETCHER:MULTI:IDs:Unit:unitIds

	/**
	 * Returns all units that are neutral and are in LOS.
	 */
	int function (int skirmishAIId, int* unitIds, int unitIds_sizeMax) getNeutralUnits; //$ FETCHER:MULTI:IDs:Unit:unitIds

	/**
	 * Returns all units that are neutral and are in LOS plus they have to be
	 * located in the specified area of the map.
	 */
	int function (int skirmishAIId, in float* pos_posF3, float radius, bool spherical, int* unitIds, int unitIds_sizeMax) getNeutralUnitsIn; //$ FETCHER:MULTI:IDs:Unit:unitIds

	/**
	 * Returns all units that are of the team controlled by this AI instance. This
	 * list can also be created dynamically by the AI, through updating a list on
	 * each unit-created and unit-destroyed event.
	 */
	int function (int skirmishAIId, int* unitIds, int unitIds_sizeMax) getTeamUnits; //$ FETCHER:MULTI:IDs:Unit:unitIds

	/**
	 * Returns all units that are currently selected
	 * (usually only contains units if a human player
	 * is controlling this team as well).
	 */
	int function (int skirmishAIId, int* unitIds, int unitIds_sizeMax) getSelectedUnits; //$ FETCHER:MULTI:IDs:Unit:unitIds

	/**
	 * Returns the unit's unitdef struct from which you can read all
	 * the statistics of the unit, do NOT try to change any values in it.
	 */
	int function (int skirmishAIId, int unitId) Unit_getDef; //$ REF:RETURN->UnitDef

	/**
	 * @return float value of parameter if it's set, defaultValue otherwise.
	 */
	float function (int skirmishAIId, int unitId, const(char)* unitRulesParamName, float defaultValue) Unit_getRulesParamFloat;

	/**
	 * @return string value of parameter if it's set, defaultValue otherwise.
	 */
	const(char)* function (int skirmishAIId, int unitId, const(char)* unitRulesParamName, const(char)* defaultValue) Unit_getRulesParamString;

	int function (int skirmishAIId, int unitId) Unit_getTeam;

	int function (int skirmishAIId, int unitId) Unit_getAllyTeam;

	int function (int skirmishAIId, int unitId) Unit_getStockpile;

	int function (int skirmishAIId, int unitId) Unit_getStockpileQueued;

	/** The unit's max speed */
	float function (int skirmishAIId, int unitId) Unit_getMaxSpeed;

	/** The furthest any weapon of the unit can fire */
	float function (int skirmishAIId, int unitId) Unit_getMaxRange;

	/** The unit's max health */
	float function (int skirmishAIId, int unitId) Unit_getMaxHealth;

	/** How experienced the unit is (0.0f - 1.0f) */
	float function (int skirmishAIId, int unitId) Unit_getExperience;

	/** Returns the group a unit belongs to, -1 if none */
	int function (int skirmishAIId, int unitId) Unit_getGroup;

	int function (int skirmishAIId, int unitId) Unit_getCurrentCommands; //$ FETCHER:MULTI:NUM:CurrentCommand-Command

	/**
	 * For the type of the command queue, see CCommandQueue::CommandQueueType
	 * in Sim/Unit/CommandAI/CommandQueue.h
	 */
	int function (int skirmishAIId, int unitId) Unit_CurrentCommand_getType; //$ STATIC

	/**
	 * For the id, see CMD_xxx codes in Sim/Unit/CommandAI/Command.h
	 * (custom codes can also be used)
	 */
	int function (int skirmishAIId, int unitId, int commandId) Unit_CurrentCommand_getId;

	short function (int skirmishAIId, int unitId, int commandId) Unit_CurrentCommand_getOptions;

	int function (int skirmishAIId, int unitId, int commandId) Unit_CurrentCommand_getTag;

	int function (int skirmishAIId, int unitId, int commandId) Unit_CurrentCommand_getTimeOut;

	int function (int skirmishAIId, int unitId, int commandId, float* params, int params_sizeMax) Unit_CurrentCommand_getParams; //$ ARRAY:params

	/** The commands that this unit can understand, other commands will be ignored */
	int function (int skirmishAIId, int unitId) Unit_getSupportedCommands; //$ FETCHER:MULTI:NUM:SupportedCommand-CommandDescription

	/**
	 * For the id, see CMD_xxx codes in Sim/Unit/CommandAI/Command.h
	 * (custom codes can also be used)
	 */
	int function (int skirmishAIId, int unitId, int supportedCommandId) Unit_SupportedCommand_getId;

	const(char)* function (int skirmishAIId, int unitId, int supportedCommandId) Unit_SupportedCommand_getName;

	const(char)* function (int skirmishAIId, int unitId, int supportedCommandId) Unit_SupportedCommand_getToolTip;

	bool function (int skirmishAIId, int unitId, int supportedCommandId) Unit_SupportedCommand_isShowUnique;

	bool function (int skirmishAIId, int unitId, int supportedCommandId) Unit_SupportedCommand_isDisabled;

	int function (int skirmishAIId, int unitId, int supportedCommandId, const(char*)* params, int params_sizeMax) Unit_SupportedCommand_getParams; //$ ARRAY:params

	/** The unit's current health */
	float function (int skirmishAIId, int unitId) Unit_getHealth;

	float function (int skirmishAIId, int unitId) Unit_getParalyzeDamage;

	float function (int skirmishAIId, int unitId) Unit_getCaptureProgress;

	float function (int skirmishAIId, int unitId) Unit_getBuildProgress;

	float function (int skirmishAIId, int unitId) Unit_getSpeed;

	/**
	 * Indicate the relative power of the unit,
	 * used for experience calulations etc.
	 * This is sort of the measure of the units overall power.
	 */
	float function (int skirmishAIId, int unitId) Unit_getPower;

	//int               (CALLING_CONV *Unit_getResourceInfos)(int skirmishAIId, int unitId); //$ FETCHER:MULTI:NUM:ResourceInfo

	float function (int skirmishAIId, int unitId, int resourceId) Unit_getResourceUse; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int unitId, int resourceId) Unit_getResourceMake; //$ REF:resourceId->Resource

	void function (int skirmishAIId, int unitId, float* return_posF3_out) Unit_getPos;

	void function (int skirmishAIId, int unitId, float* return_posF3_out) Unit_getVel;

	bool function (int skirmishAIId, int unitId) Unit_isActivated;

	/** Returns true if the unit is currently being built */
	bool function (int skirmishAIId, int unitId) Unit_isBeingBuilt;

	bool function (int skirmishAIId, int unitId) Unit_isCloaked;

	bool function (int skirmishAIId, int unitId) Unit_isParalyzed;

	bool function (int skirmishAIId, int unitId) Unit_isNeutral;

	/** Returns the unit's build facing (0-3) */
	int function (int skirmishAIId, int unitId) Unit_getBuildingFacing;

	/** Number of the last frame this unit received an order from a player. */
	int function (int skirmishAIId, int unitId) Unit_getLastUserOrderFrame;

	int function (int skirmishAIId, int unitId) Unit_getWeapons; //$ FETCHER:MULTI:NUM:Weapon

	int function (int skirmishAIId, int unitId, int weaponMountId) Unit_getWeapon; //$ REF:weaponMountId->WeaponMount REF:RETURN->Weapon
	// END OBJECT Unit

	// BEGINN OBJECT Team
	bool function (int skirmishAIId, int teamId) Team_hasAIController;

	int function (int skirmishAIId, int* teamIds, int teamIds_sizeMax) getEnemyTeams; //$ FETCHER:MULTI:IDs:Team:teamIds

	int function (int skirmishAIId, int* teamIds, int teamIds_sizeMax) getAlliedTeams; //$ FETCHER:MULTI:IDs:Team:teamIds

	/**
	 * @return float value of parameter if it's set, defaultValue otherwise.
	 */
	float function (int skirmishAIId, int teamId, const(char)* teamRulesParamName, float defaultValue) Team_getRulesParamFloat;

	/**
	 * @return string value of parameter if it's set, defaultValue otherwise.
	 */
	const(char)* function (int skirmishAIId, int teamId, const(char)* teamRulesParamName, const(char)* defaultValue) Team_getRulesParamString;

	// END OBJECT Team

	// BEGINN OBJECT Group
	int function (int skirmishAIId, int* groupIds, int groupIds_sizeMax) getGroups; //$ FETCHER:MULTI:IDs:Group:groupIds

	int function (int skirmishAIId, int groupId) Group_getSupportedCommands; //$ FETCHER:MULTI:NUM:SupportedCommand-CommandDescription

	/**
	 * For the id, see CMD_xxx codes in Sim/Unit/CommandAI/Command.h
	 * (custom codes can also be used)
	 */
	int function (int skirmishAIId, int groupId, int supportedCommandId) Group_SupportedCommand_getId;

	const(char)* function (int skirmishAIId, int groupId, int supportedCommandId) Group_SupportedCommand_getName;

	const(char)* function (int skirmishAIId, int groupId, int supportedCommandId) Group_SupportedCommand_getToolTip;

	bool function (int skirmishAIId, int groupId, int supportedCommandId) Group_SupportedCommand_isShowUnique;

	bool function (int skirmishAIId, int groupId, int supportedCommandId) Group_SupportedCommand_isDisabled;

	int function (int skirmishAIId, int groupId, int supportedCommandId, const(char*)* params, int params_sizeMax) Group_SupportedCommand_getParams; //$ ARRAY:params

	/**
	 * For the id, see CMD_xxx codes in Sim/Unit/CommandAI/Command.h
	 * (custom codes can also be used)
	 */
	int function (int skirmishAIId, int groupId) Group_OrderPreview_getId;

	short function (int skirmishAIId, int groupId) Group_OrderPreview_getOptions;

	int function (int skirmishAIId, int groupId) Group_OrderPreview_getTag;

	int function (int skirmishAIId, int groupId) Group_OrderPreview_getTimeOut;

	int function (int skirmishAIId, int groupId, float* params, int params_sizeMax) Group_OrderPreview_getParams; //$ ARRAY:params

	bool function (int skirmishAIId, int groupId) Group_isSelected;

	// END OBJECT Group

	// BEGINN OBJECT Mod

	/**
	 * Returns the mod archive file name.
	 * CAUTION:
	 * Never use this as reference in eg. cache- or config-file names,
	 * as one and the same mod can be packaged in different ways.
	 * Use the human name instead.
	 * @see getHumanName()
	 * @deprecated
	 */
	const(char)* function (int skirmishAIId) Mod_getFileName;

	/**
	 * Returns the archive hash of the mod.
	 * Use this for reference to the mod, eg. in a cache-file, wherever human
	 * readability does not matter.
	 * This value will never be the same for two mods not having equal content.
	 * Tip: convert to 64 Hex chars for use in file names.
	 * @see getHumanName()
	 */
	int function (int skirmishAIId) Mod_getHash;

	/**
	 * Returns the human readable name of the mod, which includes the version.
	 * Use this for reference to the mod (including version), eg. in cache- or
	 * config-file names which are mod related, and wherever humans may come
	 * in contact with the reference.
	 * Be aware though, that this may contain special characters and spaces,
	 * and may not be used as a file name without checks and replaces.
	 * Alternatively, you may use the short name only, or the short name plus
	 * version. You should generally never use the file name.
	 * Tip: replace every char matching [^0-9a-zA-Z_-.] with '_'
	 * @see getHash()
	 * @see getShortName()
	 * @see getFileName()
	 * @see getVersion()
	 */
	const(char)* function (int skirmishAIId) Mod_getHumanName;

	/**
	 * Returns the short name of the mod, which does not include the version.
	 * Use this for reference to the mod in general, eg. as version independent
	 * reference.
	 * Be aware though, that this still contain special characters and spaces,
	 * and may not be used as a file name without checks and replaces.
	 * Tip: replace every char matching [^0-9a-zA-Z_-.] with '_'
	 * @see getVersion()
	 * @see getHumanName()
	 */
	const(char)* function (int skirmishAIId) Mod_getShortName;

	const(char)* function (int skirmishAIId) Mod_getVersion;

	const(char)* function (int skirmishAIId) Mod_getMutator;

	const(char)* function (int skirmishAIId) Mod_getDescription;

	/**
	 * Should constructions without builders decay?
	 */
	bool function (int skirmishAIId) Mod_getConstructionDecay;

	/**
	 * How long until they start decaying?
	 */
	int function (int skirmishAIId) Mod_getConstructionDecayTime;

	/**
	 * How fast do they decay?
	 */
	float function (int skirmishAIId) Mod_getConstructionDecaySpeed;

	/**
	 * 0 = 1 reclaimer per feature max, otherwise unlimited
	 */
	int function (int skirmishAIId) Mod_getMultiReclaim;

	/**
	 * 0 = gradual reclaim, 1 = all reclaimed at end, otherwise reclaim in reclaimMethod chunks
	 */
	int function (int skirmishAIId) Mod_getReclaimMethod;

	/**
	 * 0 = Revert to wireframe, gradual reclaim, 1 = Subtract HP, give full metal at end, default 1
	 */
	int function (int skirmishAIId) Mod_getReclaimUnitMethod;

	/**
	 * How much energy should reclaiming a unit cost, default 0.0
	 */
	float function (int skirmishAIId) Mod_getReclaimUnitEnergyCostFactor;

	/**
	 * How much metal should reclaim return, default 1.0
	 */
	float function (int skirmishAIId) Mod_getReclaimUnitEfficiency;

	/**
	 * How much should energy should reclaiming a feature cost, default 0.0
	 */
	float function (int skirmishAIId) Mod_getReclaimFeatureEnergyCostFactor;

	/**
	 * Allow reclaiming enemies? default true
	 */
	bool function (int skirmishAIId) Mod_getReclaimAllowEnemies;

	/**
	 * Allow reclaiming allies? default true
	 */
	bool function (int skirmishAIId) Mod_getReclaimAllowAllies;

	/**
	 * How much should energy should repair cost, default 0.0
	 */
	float function (int skirmishAIId) Mod_getRepairEnergyCostFactor;

	/**
	 * How much should energy should resurrect cost, default 0.5
	 */
	float function (int skirmishAIId) Mod_getResurrectEnergyCostFactor;

	/**
	 * How much should energy should capture cost, default 0.0
	 */
	float function (int skirmishAIId) Mod_getCaptureEnergyCostFactor;

	/**
	 * 0 = all ground units cannot be transported,
	 * 1 = all ground units can be transported
	 * (mass and size restrictions still apply).
	 * Defaults to 1.
	 */
	int function (int skirmishAIId) Mod_getTransportGround;

	/**
	 * 0 = all hover units cannot be transported,
	 * 1 = all hover units can be transported
	 * (mass and size restrictions still apply).
	 * Defaults to 0.
	 */
	int function (int skirmishAIId) Mod_getTransportHover;

	/**
	 * 0 = all naval units cannot be transported,
	 * 1 = all naval units can be transported
	 * (mass and size restrictions still apply).
	 * Defaults to 0.
	 */
	int function (int skirmishAIId) Mod_getTransportShip;

	/**
	 * 0 = all air units cannot be transported,
	 * 1 = all air units can be transported
	 * (mass and size restrictions still apply).
	 * Defaults to 0.
	 */
	int function (int skirmishAIId) Mod_getTransportAir;

	/**
	 * 1 = units fire at enemies running Killed() script, 0 = units ignore such enemies
	 */
	int function (int skirmishAIId) Mod_getFireAtKilled;

	/**
	 * 1 = units fire at crashing aircrafts, 0 = units ignore crashing aircrafts
	 */
	int function (int skirmishAIId) Mod_getFireAtCrashing;

	/**
	 * 0=no flanking bonus;  1=global coords, mobile;  2=unit coords, mobile;  3=unit coords, locked
	 */
	int function (int skirmishAIId) Mod_getFlankingBonusModeDefault;

	/**
	 * miplevel for los
	 */
	int function (int skirmishAIId) Mod_getLosMipLevel;

	/**
	 * miplevel to use for airlos
	 */
	int function (int skirmishAIId) Mod_getAirMipLevel;

	/**
	 * miplevel for radar
	 */
	int function (int skirmishAIId) Mod_getRadarMipLevel;

	/**
	 * when underwater, units are not in LOS unless also in sonar
	 */
	bool function (int skirmishAIId) Mod_getRequireSonarUnderWater;

	// END OBJECT Mod

	// BEGINN OBJECT Map
	int function (int skirmishAIId) Map_getChecksum;

	void function (int skirmishAIId, float* return_posF3_out) Map_getStartPos;

	void function (int skirmishAIId, float* return_posF3_out) Map_getMousePos;

	bool function (int skirmishAIId, in float* pos_posF3, float radius) Map_isPosInCamera;

	/**
	 * Returns the maps center heightmap width.
	 * @see getHeightMap()
	 */
	int function (int skirmishAIId) Map_getWidth;

	/**
	 * Returns the maps center heightmap height.
	 * @see getHeightMap()
	 */
	int function (int skirmishAIId) Map_getHeight;

	/**
	 * Returns the height for the center of the squares.
	 * This differs slightly from the drawn map, since
	 * that one uses the height at the corners.
	 * Note that the actual map is 8 times larger (in each dimension) and
	 * all other maps (slope, los, resources, etc.) are relative to the
	 * size of the heightmap.
	 *
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - each data position is 8*8 in size
	 * - the value for the full resolution position (x, z) is at index (z * width + x)
	 * - the last value, bottom right, is at index (width * height - 1)
	 *
	 * @see getCornersHeightMap()
	 */
	int function (int skirmishAIId, float* heights, int heights_sizeMax) Map_getHeightMap; //$ ARRAY:heights

	/**
	 * Returns the height for the corners of the squares.
	 * This is the same like the drawn map.
	 * It is one unit wider and one higher then the centers height map.
	 *
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - 4 points mark the edges of an area of 8*8 in size
	 * - the value for upper left corner of the full resolution position (x, z) is at index (z * width + x)
	 * - the last value, bottom right, is at index ((width+1) * (height+1) - 1)
	 *
	 * @see getHeightMap()
	 */
	int function (int skirmishAIId, float* cornerHeights, int cornerHeights_sizeMax) Map_getCornersHeightMap; //$ ARRAY:cornerHeights

	float function (int skirmishAIId) Map_getMinHeight;

	float function (int skirmishAIId) Map_getMaxHeight;

	/**
	 * @brief the slope map
	 * The values are 1 minus the y-component of the (average) facenormal of the square.
	 *
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - each data position is 2*2 in size
	 * - the value for the full resolution position (x, z) is at index ((z * width + x) / 2)
	 * - the last value, bottom right, is at index (width/2 * height/2 - 1)
	 */
	int function (int skirmishAIId, float* slopes, int slopes_sizeMax) Map_getSlopeMap; //$ ARRAY:slopes

	/**
	 * @brief the level of sight map
	 * mapDims.mapx >> losMipLevel
	 * A square with value zero means you do not have LOS coverage on it.
	 *Mod_getLosMipLevel
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - resolution factor (res) is min(1, 1 << Mod_getLosMipLevel())
	 *   examples:
	 *   + losMipLevel(0) -> res(1)
	 *   + losMipLevel(1) -> res(2)
	 *   + losMipLevel(2) -> res(4)
	 *   + losMipLevel(3) -> res(8)
	 * - each data position is res*res in size
	 * - the value for the full resolution position (x, z) is at index ((z * width + x) / res)
	 * - the last value, bottom right, is at index (width/res * height/res - 1)
	 */
	int function (int skirmishAIId, int* losValues, int losValues_sizeMax) Map_getLosMap; //$ ARRAY:losValues

	/**
	 * @brief the level of sight map
	 * mapDims.mapx >> airMipLevel
	 * @see getLosMap()
	 */
	int function (int skirmishAIId, int* airLosValues, int airLosValues_sizeMax) Map_getAirLosMap; //$ ARRAY:airLosValues

	/**
	 * @brief the radar map
	 * mapDims.mapx >> radarMipLevel
	 * @see getLosMap()
	 */
	int function (int skirmishAIId, int* radarValues, int radarValues_sizeMax) Map_getRadarMap; //$ ARRAY:radarValues

	/** @see getRadarMap() */
	int function (int skirmishAIId, int* sonarValues, int sonarValues_sizeMax) Map_getSonarMap; //$ ARRAY:sonarValues

	/** @see getRadarMap() */
	int function (int skirmishAIId, int* seismicValues, int seismicValues_sizeMax) Map_getSeismicMap; //$ ARRAY:seismicValues

	/** @see getRadarMap() */
	int function (int skirmishAIId, int* jammerValues, int jammerValues_sizeMax) Map_getJammerMap; //$ ARRAY:jammerValues

	/** @see getRadarMap() */
	int function (int skirmishAIId, int* sonarJammerValues, int sonarJammerValues_sizeMax) Map_getSonarJammerMap; //$ ARRAY:sonarJammerValues

	/**
	 * @brief resource maps
	 * This map shows the resource density on the map.
	 *
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - each data position is 2*2 in size
	 * - the value for the full resolution position (x, z) is at index ((z * width + x) / 2)
	 * - the last value, bottom right, is at index (width/2 * height/2 - 1)
	 */
	int function (int skirmishAIId, int resourceId, short* resources, int resources_sizeMax) Map_getResourceMapRaw; //$ REF:resourceId->Resource ARRAY:resources

	/**
	 * Returns positions indicating where to place resource extractors on the map.
	 * Only the x and z values give the location of the spots, while the y values
	 * represents the actual amount of resource an extractor placed there can make.
	 * You should only compare the y values to each other, and not try to estimate
	 * effective output from spots.
	 */
	int function (int skirmishAIId, int resourceId, float* spots_AposF3, int spots_AposF3_sizeMax) Map_getResourceMapSpotsPositions; //$ REF:resourceId->Resource ARRAY:spots_AposF3

	/**
	 * Returns the average resource income for an extractor on one of the evaluated positions.
	 */
	float function (int skirmishAIId, int resourceId) Map_getResourceMapSpotsAverageIncome; //$ REF:resourceId->Resource

	/**
	 * Returns the nearest resource extractor spot to a specified position out of the evaluated list.
	 */
	void function (int skirmishAIId, int resourceId, in float* pos_posF3, float* return_posF3_out) Map_getResourceMapSpotsNearest; //$ REF:resourceId->Resource

	/**
	 * Returns the archive hash of the map.
	 * Use this for reference to the map, eg. in a cache-file, wherever human
	 * readability does not matter.
	 * This value will never be the same for two maps not having equal content.
	 * Tip: convert to 64 Hex chars for use in file names.
	 * @see getName()
	 */
	int function (int skirmishAIId) Map_getHash;

	/**
	 * Returns the name of the map.
	 * Use this for reference to the map, eg. in cache- or config-file names
	 * which are map related, wherever humans may come in contact with the reference.
	 * Be aware though, that this may contain special characters and spaces,
	 * and may not be used as a file name without checks and replaces.
	 * Tip: replace every char matching [^0-9a-zA-Z_-.] with '_'
	 * @see getHash()
	 * @see getHumanName()
	 */
	const(char)* function (int skirmishAIId) Map_getName;

	/**
	 * Returns the human readbale name of the map.
	 * @see getName()
	 */
	const(char)* function (int skirmishAIId) Map_getHumanName;

	/** Gets the elevation of the map at position (x, z) */
	float function (int skirmishAIId, float x, float z) Map_getElevationAt;

	/** Returns what value 255 in the resource map is worth */
	float function (int skirmishAIId, int resourceId) Map_getMaxResource; //$ REF:resourceId->Resource

	/** Returns extraction radius for resource extractors */
	float function (int skirmishAIId, int resourceId) Map_getExtractorRadius; //$ REF:resourceId->Resource

	float function (int skirmishAIId) Map_getMinWind;

	float function (int skirmishAIId) Map_getMaxWind;

	float function (int skirmishAIId) Map_getCurWind;

	float function (int skirmishAIId) Map_getTidalStrength;

	float function (int skirmishAIId) Map_getGravity;

	float function (int skirmishAIId) Map_getWaterDamage;

	bool function (int skirmishAIId) Map_isDeformable;

	/** Returns global map hardness */
	float function (int skirmishAIId) Map_getHardness;

	/**
	 * Returns hardness modifiers of the squares adjusted by terrain type.
	 *
	 * - index 0 is top left
	 * - each data position is 2*2 in size (relative to heightmap)
	 * - the value for the full resolution position (x, z) is at index ((z * width + x) / 2)
	 * - the last value, bottom right, is at index (width/2 * height/2 - 1)
	 *
	 * @see getHardness()
	 */
	int function (int skirmishAIId, float* hardMods, int hardMods_sizeMax) Map_getHardnessModMap; //$ ARRAY:hardMods

	/**
	 * Returns speed modifiers of the squares
	 * for specific speedModClass adjusted by terrain type.
	 *
	 * - index 0 is top left
	 * - each data position is 2*2 in size (relative to heightmap)
	 * - the value for the full resolution position (x, z) is at index ((z * width + x) / 2)
	 * - the last value, bottom right, is at index (width/2 * height/2 - 1)
	 *
	 * @see MoveData#getSpeedModClass
	 */
	int function (int skirmishAIId, int speedModClass, float* speedMods, int speedMods_sizeMax) Map_getSpeedModMap; //$ ARRAY:speedMods

	/**
	 * Returns all points drawn with this AIs team color,
	 * and additionally the ones drawn with allied team colors,
	 * if <code>includeAllies</code> is true.
	 */
	int function (int skirmishAIId, bool includeAllies) Map_getPoints; //$ FETCHER:MULTI:NUM:Point

	void function (int skirmishAIId, int pointId, float* return_posF3_out) Map_Point_getPosition;

	void function (int skirmishAIId, int pointId, short* return_colorS3_out) Map_Point_getColor;

	const(char)* function (int skirmishAIId, int pointId) Map_Point_getLabel;

	/**
	 * Returns all lines drawn with this AIs team color,
	 * and additionally the ones drawn with allied team colors,
	 * if <code>includeAllies</code> is true.
	 */
	int function (int skirmishAIId, bool includeAllies) Map_getLines; //$ FETCHER:MULTI:NUM:Line

	void function (int skirmishAIId, int lineId, float* return_posF3_out) Map_Line_getFirstPosition;

	void function (int skirmishAIId, int lineId, float* return_posF3_out) Map_Line_getSecondPosition;

	void function (int skirmishAIId, int lineId, short* return_colorS3_out) Map_Line_getColor;

	bool function (int skirmishAIId, int unitDefId, in float* pos_posF3, int facing) Map_isPossibleToBuildAt; //$ REF:unitDefId->UnitDef

	/**
	 * Returns the closest position from a given position that a building can be
	 * built at.
	 * @param minDist the distance in 1/BUILD_SQUARE_SIZE = 1/16 of full map
	 *                resolution, that the building must keep to other
	 *                buildings; this makes it easier to keep free paths through
	 *                a base
	 * @return actual map position with x, y and z all beeing positive,
	 *         or float[3]{-1, 0, 0} if no suitable position is found.
	 */
	void function (int skirmishAIId, int unitDefId, in float* pos_posF3, float searchRadius, int minDist, int facing, float* return_posF3_out) Map_findClosestBuildSite; //$ REF:unitDefId->UnitDef

	// BEGINN OBJECT Map

	// BEGINN OBJECT FeatureDef
	int function (int skirmishAIId, int* featureDefIds, int featureDefIds_sizeMax) getFeatureDefs; //$ FETCHER:MULTI:IDs:FeatureDef:featureDefIds

	const(char)* function (int skirmishAIId, int featureDefId) FeatureDef_getName;

	const(char)* function (int skirmishAIId, int featureDefId) FeatureDef_getDescription;

	float function (int skirmishAIId, int featureDefId, int resourceId) FeatureDef_getContainedResource; //$ REF:resourceId->Resource

	float function (int skirmishAIId, int featureDefId) FeatureDef_getMaxHealth;

	float function (int skirmishAIId, int featureDefId) FeatureDef_getReclaimTime;

	/** Used to see if the object can be overrun by units of a certain heavyness */
	float function (int skirmishAIId, int featureDefId) FeatureDef_getMass;

	bool function (int skirmishAIId, int featureDefId) FeatureDef_isUpright;

	int function (int skirmishAIId, int featureDefId) FeatureDef_getDrawType;

	const(char)* function (int skirmishAIId, int featureDefId) FeatureDef_getModelName;

	/**
	 * Used to determine whether the feature is resurrectable.
	 *
	 * @return  -1: (default) only if it is the 1st wreckage of
	 *              the UnitDef it originates from
	 *           0: no, never
	 *           1: yes, always
	 */
	int function (int skirmishAIId, int featureDefId) FeatureDef_getResurrectable;

	int function (int skirmishAIId, int featureDefId) FeatureDef_getSmokeTime;

	bool function (int skirmishAIId, int featureDefId) FeatureDef_isDestructable;

	bool function (int skirmishAIId, int featureDefId) FeatureDef_isReclaimable;

	bool function (int skirmishAIId, int featureDefId) FeatureDef_isAutoreclaimable;

	bool function (int skirmishAIId, int featureDefId) FeatureDef_isBlocking;

	bool function (int skirmishAIId, int featureDefId) FeatureDef_isBurnable;

	bool function (int skirmishAIId, int featureDefId) FeatureDef_isFloating;

	bool function (int skirmishAIId, int featureDefId) FeatureDef_isNoSelect;

	bool function (int skirmishAIId, int featureDefId) FeatureDef_isGeoThermal;

	/**
	 * Size of the feature along the X axis - in other words: height.
	 * each size is 8 units
	 */
	int function (int skirmishAIId, int featureDefId) FeatureDef_getXSize;

	/**
	 * Size of the feature along the Z axis - in other words: width.
	 * each size is 8 units
	 */
	int function (int skirmishAIId, int featureDefId) FeatureDef_getZSize;

	int function (int skirmishAIId, int featureDefId, const(char*)* keys, const(char*)* values) FeatureDef_getCustomParams; //$ MAP

	// END OBJECT FeatureDef

	// BEGINN OBJECT Feature
	/**
	 * Returns all features currently in LOS, or all features on the map
	 * if cheating is enabled.
	 */
	int function (int skirmishAIId, int* featureIds, int featureIds_sizeMax) getFeatures; //$ REF:MULTI:featureIds->Feature

	/**
	 * Returns all features in a specified area that are currently in LOS,
	 * or all features in this area if cheating is enabled.
	 */
	int function (int skirmishAIId, in float* pos_posF3, float radius, bool spherical, int* featureIds, int featureIds_sizeMax) getFeaturesIn; //$ REF:MULTI:featureIds->Feature

	int function (int skirmishAIId, int featureId) Feature_getDef; //$ REF:RETURN->FeatureDef

	float function (int skirmishAIId, int featureId) Feature_getHealth;

	float function (int skirmishAIId, int featureId) Feature_getReclaimLeft;

	void function (int skirmishAIId, int featureId, float* return_posF3_out) Feature_getPosition;

	/**
	 * @return float value of parameter if it's set, defaultValue otherwise.
	 */
	float function (int skirmishAIId, int unitId, const(char)* featureRulesParamName, float defaultValue) Feature_getRulesParamFloat;

	/**
	 * @return string value of parameter if it's set, defaultValue otherwise.
	 */
	const(char)* function (int skirmishAIId, int unitId, const(char)* featureRulesParamName, const(char)* defaultValue) Feature_getRulesParamString;

	int function (int skirmishAIId, int featureId) Feature_getResurrectDef; //$ REF:RETURN->UnitDef

	short function (int skirmishAIId, int featureId) Feature_getBuildingFacing;

	// END OBJECT Feature

	// BEGINN OBJECT WeaponDef
	int function (int skirmishAIId) getWeaponDefs; //$ FETCHER:MULTI:NUM:WeaponDef

	int function (int skirmishAIId, const(char)* weaponDefName) getWeaponDefByName; //$ REF:RETURN->WeaponDef

	const(char)* function (int skirmishAIId, int weaponDefId) WeaponDef_getName;

	const(char)* function (int skirmishAIId, int weaponDefId) WeaponDef_getType;

	const(char)* function (int skirmishAIId, int weaponDefId) WeaponDef_getDescription;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getRange;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getHeightMod;

	/** Inaccuracy of whole burst */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getAccuracy;

	/** Inaccuracy of individual shots inside burst */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getSprayAngle;

	/** Inaccuracy while owner moving */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getMovingAccuracy;

	/** Fraction of targets move speed that is used as error offset */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getTargetMoveError;

	/** Maximum distance the weapon will lead the target */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getLeadLimit;

	/** Factor for increasing the leadLimit with experience */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getLeadBonus;

	/** Replaces hardcoded behaviour for burnblow cannons */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getPredictBoost;

	//TODO: Deprecate the following function, if no longer needed by legacy Cpp AIs
	int function (int skirmishAIId) WeaponDef_getNumDamageTypes; //$ STATIC

	//DamageArray (CALLING_CONV *WeaponDef_getDamages)(int skirmishAIId, int weaponDefId);

	int function (int skirmishAIId, int weaponDefId) WeaponDef_Damage_getParalyzeDamageTime;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_Damage_getImpulseFactor;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_Damage_getImpulseBoost;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_Damage_getCraterMult;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_Damage_getCraterBoost;

	//float (CALLING_CONV *WeaponDef_Damage_getType)(int skirmishAIId, int weaponDefId, int typeId);

	int function (int skirmishAIId, int weaponDefId, float* types, int types_sizeMax) WeaponDef_Damage_getTypes; //$ ARRAY:types

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getAreaOfEffect;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isNoSelfDamage;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getFireStarter;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getEdgeEffectiveness;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getSize;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getSizeGrowth;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getCollisionSize;

	int function (int skirmishAIId, int weaponDefId) WeaponDef_getSalvoSize;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getSalvoDelay;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getReload;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getBeamTime;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isBeamBurst;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isWaterBounce;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isGroundBounce;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getBounceRebound;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getBounceSlip;

	int function (int skirmishAIId, int weaponDefId) WeaponDef_getNumBounce;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getMaxAngle;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getUpTime;

	int function (int skirmishAIId, int weaponDefId) WeaponDef_getFlightTime;

	float function (int skirmishAIId, int weaponDefId, int resourceId) WeaponDef_getCost; //$ REF:resourceId->Resource

	int function (int skirmishAIId, int weaponDefId) WeaponDef_getProjectilesPerShot;

	///** The "id=" tag in the TDF */
	//int (CALLING_CONV *WeaponDef_getTdfId)(int skirmishAIId, int weaponDefId);

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isTurret;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isOnlyForward;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isFixedLauncher;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isWaterWeapon;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isFireSubmersed;

	/** Lets a torpedo travel above water like it does below water */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isSubMissile;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isTracks;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isDropped;

	/** The weapon will only paralyze, not do real damage. */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isParalyzer;

	/** The weapon damages by impacting, not by exploding. */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isImpactOnly;

	/** Can not target anything (for example: anti-nuke, D-Gun) */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isNoAutoTarget;

	/** Has to be fired manually (by the player or an AI, example: D-Gun) */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isManualFire;

	/**
	 * Can intercept targetable weapons shots.
	 *
	 * example: anti-nuke
	 *
	 * @see  getTargetable()
	 */
	int function (int skirmishAIId, int weaponDefId) WeaponDef_getInterceptor;

	/**
	 * Shoots interceptable projectiles.
	 * Shots can be intercepted by interceptors.
	 *
	 * example: nuke
	 *
	 * @see  getInterceptor()
	 */
	int function (int skirmishAIId, int weaponDefId) WeaponDef_getTargetable;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isStockpileable;

	/**
	 * Range of interceptors.
	 *
	 * example: anti-nuke
	 *
	 * @see  getInterceptor()
	 */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getCoverageRange;

	/** Build time of a missile */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getStockpileTime;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getIntensity;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getDuration;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getFalloffRate;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isSoundTrigger;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isSelfExplode;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isGravityAffected;

	/**
	 * Per weapon high trajectory setting.
	 * UnitDef also has this property.
	 *
	 * @return  0: low
	 *          1: high
	 *          2: unit
	 */
	int function (int skirmishAIId, int weaponDefId) WeaponDef_getHighTrajectory;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getMyGravity;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isNoExplode;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getStartVelocity;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getWeaponAcceleration;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getTurnRate;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getMaxVelocity;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getProjectileSpeed;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getExplosionSpeed;

	/**
	 * Returns the bit field value denoting the categories this weapon should
	 * target, excluding all others.
	 * @see Game#getCategoryFlag
	 * @see Game#getCategoryName
	 */
	int function (int skirmishAIId, int weaponDefId) WeaponDef_getOnlyTargetCategory;

	/** How much the missile will wobble around its course. */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getWobble;

	/** How much the missile will dance. */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getDance;

	/** How high trajectory missiles will try to fly in. */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getTrajectoryHeight;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isLargeBeamLaser;

	/** If the weapon is a shield rather than a weapon. */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isShield;

	/** If the weapon should be repulsed or absorbed. */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isShieldRepulser;

	/** If the shield only affects enemy projectiles. */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isSmartShield;

	/** If the shield only affects stuff coming from outside shield radius. */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isExteriorShield;

	/** If the shield should be graphically shown. */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isVisibleShield;

	/** If a small graphic should be shown at each repulse. */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isVisibleShieldRepulse;

	/** The number of frames to draw the shield after it has been hit. */
	int function (int skirmishAIId, int weaponDefId) WeaponDef_getVisibleShieldHitFrames;

	/**
	 * Amount of the resource used per shot or per second,
	 * depending on the type of projectile.
	 */
	float function (int skirmishAIId, int weaponDefId, int resourceId) WeaponDef_Shield_getResourceUse; //$ REF:resourceId->Resource

	/** Size of shield covered area */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_Shield_getRadius;

	/**
	 * Shield acceleration on plasma stuff.
	 * How much will plasma be accelerated into the other direction
	 * when it hits the shield.
	 */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_Shield_getForce;

	/** Maximum speed to which the shield can repulse plasma. */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_Shield_getMaxSpeed;

	/** Amount of damage the shield can reflect. (0=infinite) */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_Shield_getPower;

	/** Amount of power that is regenerated per second. */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_Shield_getPowerRegen;

	/**
	 * How much of a given resource is needed to regenerate power
	 * with max speed per second.
	 */
	float function (int skirmishAIId, int weaponDefId, int resourceId) WeaponDef_Shield_getPowerRegenResource; //$ REF:resourceId->Resource

	/** How much power the shield has when it is created. */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_Shield_getStartingPower;

	/** Number of frames to delay recharging by after each hit. */
	int function (int skirmishAIId, int weaponDefId) WeaponDef_Shield_getRechargeDelay;

	/**
	 * The type of the shield (bitfield).
	 * Defines what weapons can be intercepted by the shield.
	 *
	 * @see  getInterceptedByShieldType()
	 */
	int function (int skirmishAIId, int weaponDefId) WeaponDef_Shield_getInterceptType;

	/**
	 * The type of shields that can intercept this weapon (bitfield).
	 * The weapon can be affected by shields if:
	 * (shield.getInterceptType() & weapon.getInterceptedByShieldType()) != 0
	 *
	 * @see  getInterceptType()
	 */
	int function (int skirmishAIId, int weaponDefId) WeaponDef_getInterceptedByShieldType;

	/** Tries to avoid friendly units while aiming? */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isAvoidFriendly;

	/** Tries to avoid features while aiming? */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isAvoidFeature;

	/** Tries to avoid neutral units while aiming? */
	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isAvoidNeutral;

	/**
	 * If nonzero, targetting units will TryTarget at the edge of collision sphere
	 * (radius*tag value, [-1;1]) instead of its centre.
	 */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getTargetBorder;

	/**
	 * If greater than 0, the range will be checked in a cylinder
	 * (height=range*cylinderTargetting) instead of a sphere.
	 */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getCylinderTargetting;

	/**
	 * For beam-lasers only - always hit with some minimum intensity
	 * (a damage coeffcient normally dependent on distance).
	 * Do not confuse this with the intensity tag, it i completely unrelated.
	 */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getMinIntensity;

	/**
	 * Controls cannon range height boost.
	 *
	 * default: -1: automatically calculate a more or less sane value
	 */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getHeightBoostFactor;

	/** Multiplier for the distance to the target for priority calculations. */
	float function (int skirmishAIId, int weaponDefId) WeaponDef_getProximityPriority;

	int function (int skirmishAIId, int weaponDefId) WeaponDef_getCollisionFlags;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isSweepFire;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isAbleToAttackGround;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getCameraShake;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getDynDamageExp;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getDynDamageMin;

	float function (int skirmishAIId, int weaponDefId) WeaponDef_getDynDamageRange;

	bool function (int skirmishAIId, int weaponDefId) WeaponDef_isDynDamageInverted;

	int function (int skirmishAIId, int weaponDefId, const(char*)* keys, const(char*)* values) WeaponDef_getCustomParams; //$ MAP

	// END OBJECT WeaponDef

	// BEGINN OBJECT Weapon
	int function (int skirmishAIId, int unitId, int weaponId) Unit_Weapon_getDef; //$ REF:RETURN->WeaponDef

	/** Next tick the weapon can fire again. */
	int function (int skirmishAIId, int unitId, int weaponId) Unit_Weapon_getReloadFrame;

	/** Time between succesive fires in ticks. */
	int function (int skirmishAIId, int unitId, int weaponId) Unit_Weapon_getReloadTime;

	float function (int skirmishAIId, int unitId, int weaponId) Unit_Weapon_getRange;

	bool function (int skirmishAIId, int unitId, int weaponId) Unit_Weapon_isShieldEnabled;

	float function (int skirmishAIId, int unitId, int weaponId) Unit_Weapon_getShieldPower;

	// END OBJECT Weapon

	bool function (int skirmishAIId) Debug_GraphDrawer_isEnabled;
}
