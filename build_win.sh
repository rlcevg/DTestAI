# Assuming git bash is installed, or
# other tool can run shell script.
# Make sure 64bit dmd is used
# ".../D/dmd2/windows/bin64/dmd"
# and not default 32bit dmd.
# Or add -m64 flag.
dmd -c \
src/AIExport.d src/ai/ai.d src/ai/package.d \
src/spring/bind/callback.d src/spring/bind/callback_struct.d src/spring/bind/commands.d src/spring/bind/commands_struct.d \
src/spring/bind/defines.d src/spring/bind/events.d src/spring/bind/events_struct.d src/spring/bind/package.d \
src/spring/drawer/drawer.d src/spring/drawer/debug_drawer.d src/spring/drawer/graph_drawer.d src/spring/drawer/package.d \
src/spring/economy/economy.d src/spring/economy/resource.d src/spring/economy/package.d \
src/spring/feature/feature.d src/spring/feature/feature_def.d src/spring/feature/package.d \
src/spring/map/map.d src/spring/map/line.d src/spring/map/point.d src/spring/map/package.d \
src/spring/skirmish/skirmish.d src/spring/skirmish/info.d src/spring/skirmish/options.d src/spring/skirmish/package.d \
src/spring/unit/unit.d src/spring/unit/unit_def.d src/spring/unit/move_data.d src/spring/unit/flanking_bonus.d \
src/spring/unit/command.d src/spring/unit/command_desc.d src/spring/unit/package.d \
src/spring/util/float4.d src/spring/util/color4.d src/spring/util/package.d \
src/spring/weapon/weapon.d src/spring/weapon/weapon_mount.d src/spring/weapon/weapon_def.d \
src/spring/weapon/damage.d src/spring/weapon/shield.d src/spring/weapon/package.d \
src/spring/cheats.d src/spring/engine.d src/spring/file.d src/spring/game.d src/spring/group.d \
src/spring/log.d src/spring/lua.d src/spring/mod.d src/spring/pathing.d src/spring/root.d \
src/spring/team.d src/spring/package.d \
-preview=shortenedMethods -op

dmd -ofdata/SkirmishAI.dll \
src/AIExport.obj src/ai/ai.obj src/ai/package.obj \
src/spring/bind/callback.obj src/spring/bind/callback_struct.obj src/spring/bind/commands.obj src/spring/bind/commands_struct.obj \
src/spring/bind/defines.obj src/spring/bind/events.obj src/spring/bind/events_struct.obj src/spring/bind/package.obj \
src/spring/drawer/drawer.obj src/spring/drawer/debug_drawer.obj src/spring/drawer/graph_drawer.obj src/spring/drawer/package.obj \
src/spring/economy/economy.obj src/spring/economy/resource.obj src/spring/economy/package.obj \
src/spring/feature/feature.obj src/spring/feature/feature_def.obj src/spring/feature/package.obj \
src/spring/map/map.obj src/spring/map/line.obj src/spring/map/point.obj src/spring/map/package.obj \
src/spring/skirmish/skirmish.obj src/spring/skirmish/info.obj src/spring/skirmish/options.obj src/spring/skirmish/package.obj \
src/spring/unit/unit.obj src/spring/unit/unit_def.obj src/spring/unit/move_data.obj src/spring/unit/flanking_bonus.obj \
src/spring/unit/command.obj src/spring/unit/command_desc.obj src/spring/unit/package.obj \
src/spring/util/float4.obj src/spring/util/color4.obj src/spring/util/package.obj \
src/spring/weapon/weapon.obj src/spring/weapon/weapon_mount.obj src/spring/weapon/weapon_def.obj \
src/spring/weapon/damage.obj src/spring/weapon/shield.obj src/spring/weapon/package.obj \
src/spring/cheats.obj src/spring/engine.obj src/spring/file.obj src/spring/game.obj src/spring/group.obj \
src/spring/log.obj src/spring/lua.obj src/spring/mod.obj src/spring/pathing.obj src/spring/root.obj \
src/spring/team.obj src/spring/package.obj \
-shared
