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
-preview=shortenedMethods -op -fPIC

dmd -ofdata/libSkirmishAI.so \
src/AIExport.o src/ai/ai.o src/ai/package.o \
src/spring/bind/callback.o src/spring/bind/callback_struct.o src/spring/bind/commands.o src/spring/bind/commands_struct.o \
src/spring/bind/defines.o src/spring/bind/events.o src/spring/bind/events_struct.o src/spring/bind/package.o \
src/spring/drawer/drawer.o src/spring/drawer/debug_drawer.o src/spring/drawer/graph_drawer.o src/spring/drawer/package.o \
src/spring/economy/economy.o src/spring/economy/resource.o src/spring/economy/package.o \
src/spring/feature/feature.o src/spring/feature/feature_def.o src/spring/feature/package.o \
src/spring/map/map.o src/spring/map/line.o src/spring/map/point.o src/spring/map/package.o \
src/spring/skirmish/skirmish.o src/spring/skirmish/info.o src/spring/skirmish/options.o src/spring/skirmish/package.o \
src/spring/unit/unit.o src/spring/unit/unit_def.o src/spring/unit/move_data.o src/spring/unit/flanking_bonus.o \
src/spring/unit/command.o src/spring/unit/command_desc.o src/spring/unit/package.o \
src/spring/util/float4.o src/spring/util/color4.o src/spring/util/package.o \
src/spring/weapon/weapon.o src/spring/weapon/weapon_mount.o src/spring/weapon/weapon_def.o \
src/spring/weapon/damage.o src/spring/weapon/shield.o src/spring/weapon/package.o \
src/spring/cheats.o src/spring/engine.o src/spring/file.o src/spring/game.o src/spring/group.o \
src/spring/log.o src/spring/lua.o src/spring/mod.o src/spring/pathing.o src/spring/root.o \
src/spring/team.o src/spring/package.o \
-shared -defaultlib=libphobos2.so -L-rpath=.:/usr/lib
