#using scripts/shared/scene_shared;
#using scripts/mp/mp_veiled_sound;
#using scripts/mp/mp_veiled_fx;
#using scripts/mp/gametypes/_spawnlogic;
#using scripts/mp/_util;
#using scripts/mp/_load;
#using scripts/shared/util_shared;
#using scripts/shared/compass;
#using scripts/codescripts/struct;

#namespace namespace_b949d622;

// Namespace namespace_b949d622
// Params 0, eflags: 0x1 linked
// namespace_b949d622<file_0>::function_d290ebfa
// Checksum 0xad65a792, Offset: 0x2d8
// Size: 0x33c
function main() {
    precache();
    spawnlogic::move_spawn_point("mp_dm_spawn_start", (1687.56, -465.166, 45.625), (-1164.6, 603.783, 29.625), (0, 315.516, 0));
    namespace_f7008227::main();
    namespace_8f273e4e::main();
    load::main();
    compass::setupminimap("compass_map_mp_veiled");
    setdvar("compassmaxrange", "2100");
    spawncollision("collision_clip_wall_32x32x10", "collider", (-2091.09, 803.526, 140.663), (27, 82, -2));
    spawncollision("collision_clip_wall_32x32x10", "collider", (-1905.67, 876.398, 140.663), (27, 97, 2));
    spawncollision("collision_clip_wall_128x128x10", "collider", (881, -352, 116), (0, 0, 0));
    spawncollision("collision_clip_wall_128x128x10", "collider", (885, -352, 116), (0, 0, 0));
    if (util::isprophuntgametype()) {
        spawncollision("collision_clip_wall_256x256x10", "collider", (-2043.05, 820.365, 156.942), (0, 113.394, 90));
        spawncollision("collision_clip_wall_256x256x10", "collider", (-1970.05, 854.365, 368), (0, 113.394, 90));
        spawncollision("collision_clip_wall_256x256x10", "collider", (-1970.05, 854.365, 541.5), (0, 113.394, 90));
    }
    level.cleandepositpoints = array((-63.6408, -499.434, -19.875), (-1363.59, 509.905, -20.1416), (1362.85, -166.119, 1.5134), (-237.83, 1105.17, 10));
    level thread function_e8eaac79();
}

// Namespace namespace_b949d622
// Params 0, eflags: 0x1 linked
// namespace_b949d622<file_0>::function_f7046c76
// Checksum 0x99ec1590, Offset: 0x620
// Size: 0x4
function precache() {
    
}

// Namespace namespace_b949d622
// Params 0, eflags: 0x1 linked
// namespace_b949d622<file_0>::function_e8eaac79
// Checksum 0x80b207eb, Offset: 0x630
// Size: 0x1bc
function function_e8eaac79() {
    var_c6821b9b = 15;
    var_810de4c4 = 45;
    var_7b825480 = 120;
    var_da509659 = 120;
    wait(var_c6821b9b + var_810de4c4);
    var_13d61abf = struct::get("tag_align_rocket_2", "targetname");
    var_13d61abf thread scene::play("p7_fxanim_mp_veiled_rocket_launch_2");
    playsoundatposition("evt_rocket_launch_01", (-4313, 623, 316));
    wait(var_7b825480);
    var_a1ceab84 = struct::get("tag_align_rocket_1", "targetname");
    var_a1ceab84 thread scene::play("p7_fxanim_mp_veiled_rocket_launch_1");
    playsoundatposition("evt_rocket_launch_01", (-4313, 623, 316));
    wait(var_da509659);
    var_edd3a056 = struct::get("tag_align_rocket_3", "targetname");
    var_edd3a056 thread scene::play("p7_fxanim_mp_veiled_rocket_launch_3");
    playsoundatposition("evt_rocket_launch_01", (-3696, -2879, 322));
}

