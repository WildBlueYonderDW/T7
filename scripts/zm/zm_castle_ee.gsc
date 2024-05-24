#using scripts/zm/zm_castle_mechz;
#using scripts/zm/zm_castle_dogs;
#using scripts/zm/zm_castle_weap_quest_upgrade;
#using scripts/zm/zm_castle_vo;
#using scripts/zm/zm_castle_util;
#using scripts/zm/zm_castle_teleporter;
#using scripts/zm/_zm_stats;
#using scripts/zm/_zm_zonemgr;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_unitrigger;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_magicbox;
#using scripts/zm/_zm_devgui;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_ai_dogs;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/ai/zombie_death;
#using scripts/shared/util_shared;
#using scripts/shared/scoreevents_shared;
#using scripts/shared/scene_shared;
#using scripts/shared/lui_shared;
#using scripts/shared/fx_shared;
#using scripts/shared/flagsys_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/audio_shared;
#using scripts/shared/array_shared;
#using scripts/codescripts/struct;

#namespace namespace_c93e4c32;

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x86a3762d, Offset: 0x1858
// Size: 0x6c
function main() {
    init_flags();
    register_clientfields();
    function_70b74a2d();
    /#
        if (getdvarint("p7_fxanim_zm_castle_rocket_bell_tower_bundle") > 0) {
            level thread function_d6026710();
        }
    #/
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x2a5889f8, Offset: 0x18d0
// Size: 0x1ac
function register_clientfields() {
    n_bits = getminbitcountfornum(4);
    clientfield::register("toplayer", "player_ee_cs_circle", 5000, n_bits, "int");
    clientfield::register("actor", "ghost_actor", 1, 1, "int");
    clientfield::register("scriptmover", "channeling_stone_glow", 5000, 2, "int");
    clientfield::register("scriptmover", "pod_monitor_enable", 5000, 1, "int");
    clientfield::register("world", "flip_skybox", 5000, 1, "int");
    clientfield::register("world", "sndDeathRayToMoon", 5000, 1, "int");
    clientfield::register("toplayer", "outro_lighting_banks", 5000, 1, "int");
    clientfield::register("toplayer", "moon_explosion_bank", 5000, 1, "int");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xfc8c81e1, Offset: 0x1a88
// Size: 0x37c
function init_flags() {
    level flag::init("ee_start_done");
    level flag::init("choose_time_travel_target");
    level flag::init("reset_time_travel_target");
    level flag::init("time_travel_teleporter_ready");
    level flag::init("stop_time_travel");
    level flag::init("switch_to_death_ray");
    level flag::init("death_ray_trap_used");
    level flag::init("dimension_set");
    level flag::init("tesla_connector_launch_platform");
    level flag::init("tesla_connector_lower_tower");
    level flag::init("mpd_canister_replacement");
    level flag::init("end_simon");
    level flag::init("simon_press_check");
    level flag::init("simon_terminal_activated");
    level flag::init("simon_timed_out");
    level flag::init("channeling_stone_replacement");
    level flag::init("start_channeling_stone_step");
    level flag::init("next_channeling_stone");
    level flag::init("see_keeper");
    level flag::init("sent_rockets_to_the_moon");
    level flag::init("rockets_to_moon_vo_complete");
    level flag::init("ee_fuse_held_by_team");
    level flag::init("ee_fuse_placed");
    level flag::init("ee_safe_open");
    level flag::init("ee_golden_key");
    level flag::init("ee_outro");
    if (!level.rankedmatch && !getdvarint("zm_private_rankedmatch")) {
        level.var_dfc343e9 = 1;
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x4b04b444, Offset: 0x1e10
// Size: 0x15c
function function_70b74a2d() {
    level thread function_4458164a();
    level thread function_c21dcd15();
    level thread function_560b77f5();
    level thread function_1ab64038();
    level thread function_82075ffb();
    level thread function_627c8411();
    level thread function_af12b9a4();
    level thread function_c460669e();
    level thread function_a4b7a410();
    level thread function_71568f8();
    level thread function_d2c78092();
    level thread function_f200c253();
    level scene::init("p7_fxanim_zm_castle_rocket_bell_tower_bundle");
    level thread function_6cd00f33();
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x484b0315, Offset: 0x1f78
// Size: 0x12a
function function_4458164a() {
    level waittill(#"hash_59e5a3dd");
    wait(60);
    var_effa4ac5 = struct::get("dempsey_rocket_twinkle");
    var_bfa03783 = fx::play("dempsey_rocket_twinkle", var_effa4ac5.origin, var_effa4ac5.angles, "delete_fx", 0, undefined, 1);
    while (!level flag::get("dimension_set")) {
        var_bcfda8b9 = struct::get(var_effa4ac5.target, "targetname");
        var_effa4ac5 = var_bcfda8b9;
        var_bfa03783 moveto(var_effa4ac5.origin, 60);
        var_bfa03783 waittill(#"movedone");
    }
    level notify(#"hash_629fd78d");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x5fa89d90, Offset: 0x20b0
// Size: 0x1e4
function function_560b77f5() {
    function_3918d831("safe_code_past");
    function_3918d831("safe_code_present");
    level waittill(#"start_zombie_round_logic");
    var_1bdfdb3b = array("demon_gate_upgraded", "elemental_storm_upgraded", "rune_prison_upgraded", "wolf_howl_upgraded");
    level flag::wait_till_any(var_1bdfdb3b);
    var_be9116cc = getentarray("activate_targets_object", "targetname");
    foreach (var_4e591161 in var_be9116cc) {
        var_4e591161 setcandamage(1);
        var_4e591161.health = 999999;
        var_4e591161 thread function_676d98e4();
    }
    level flag::wait_till("ee_start_done");
    array::run_all(var_be9116cc, &delete);
    zm_zonemgr::enable_zone("zone_past_laboratory");
    level thread function_2634b833();
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x7a6864ca, Offset: 0x22a0
// Size: 0x1f0
function function_676d98e4() {
    while (!(isdefined(self.b_shot) && self.b_shot)) {
        n_damage, e_attacker, v_direction, v_point, str_means_of_death, str_tag_name, str_model_name, var_829b9480, w_weapon = self waittill(#"damage");
        if (issubstr(w_weapon.name, "elemental_bow")) {
            if (!issubstr(w_weapon.name, "elemental_bow_demongate") && !issubstr(w_weapon.name, "elemental_bow_rune_prison") && !issubstr(w_weapon.name, "elemental_bow_storm") && !issubstr(w_weapon.name, "elemental_bow_wolf_howl")) {
                s_fx = struct::get(self.target);
                self fx::play("summoning_key_glow", s_fx.origin, s_fx.angles, "delete_fx", 0, undefined, 1);
                self.b_shot = 1;
                function_9dd0cf1();
            }
        }
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xbb9f7258, Offset: 0x2498
// Size: 0x1dc
function function_9dd0cf1() {
    var_be9116cc = getentarray("activate_targets_object", "targetname");
    var_64c4082d = 0;
    foreach (var_4e591161 in var_be9116cc) {
        if (isdefined(var_4e591161.b_shot) && var_4e591161.b_shot) {
            var_64c4082d++;
        }
    }
    if (var_64c4082d >= 6) {
        foreach (var_4e591161 in var_be9116cc) {
            s_fx = struct::get(self.target);
            var_4e591161 fx::play("summoning_key_done", s_fx.origin, s_fx.angles, undefined, 0, undefined, 1);
        }
        level flag::set("ee_start_done");
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x39d92184, Offset: 0x2680
// Size: 0x4c6
function function_2634b833() {
    a_targets = getentarray("activate_teleporter_object", "targetname");
    foreach (e_target in a_targets) {
        e_target setcandamage(1);
        e_target.health = 999999;
        e_target.var_ebeea021 = 0;
    }
    var_64c4082d = 0;
    level.var_a0ef3c5e = undefined;
    level thread function_98d9769f();
    while (!level flag::get("stop_time_travel")) {
        level.var_a0ef3c5e = function_ee0ff0d1(a_targets, level.var_a0ef3c5e);
        level.var_a0ef3c5e.var_ebeea021 = 1;
        level.var_a0ef3c5e thread function_7317cab3();
        foreach (e_target in a_targets) {
            if (!e_target.var_ebeea021) {
                e_target thread function_10a07e71();
            }
        }
        s_fx = struct::get(level.var_a0ef3c5e.target, "targetname");
        s_fx fx::play("battery_charge", s_fx.origin, undefined, "delete_fx", 0, undefined, 1);
        level thread function_d613eb57();
        level thread function_67147dcf();
        playsoundatposition("zmb_object_success", (0, 0, 0));
        a_flags = array("choose_time_travel_target", "reset_time_travel_target");
        level flag::wait_till_any(a_flags);
        s_fx notify(#"hash_629fd78d");
        level.var_a0ef3c5e.var_ebeea021 = 0;
        level flag::clear("choose_time_travel_target");
        if (level flag::get("reset_time_travel_target")) {
            level.var_a0ef3c5e = undefined;
            function_dd452f0e(a_targets);
            level flag::clear("reset_time_travel_target");
            var_64c4082d = 0;
            level waittill(#"start_of_round");
        } else {
            level.var_a0ef3c5e.var_25a8b5d5 = 1;
            var_64c4082d++;
            if (var_64c4082d >= 4) {
                level.var_a0ef3c5e = undefined;
                function_dd452f0e(a_targets);
                level thread function_61036bd1();
                playsoundatposition("zmb_object_final_success", (0, 0, 0));
                level flag::set("time_travel_teleporter_ready");
                level waittill(#"start_of_round");
                var_64c4082d = 0;
                level notify(#"hash_a8200e36");
                level flag::clear("time_travel_teleporter_ready");
            }
        }
        wait(9);
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xb77f8f2c, Offset: 0x2b50
// Size: 0x64
function function_98d9769f() {
    level flag::wait_till("mpd_canister_replacement");
    level flag::wait_till("channeling_stone_replacement");
    level flag::set("stop_time_travel");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x481d39d9, Offset: 0x2bc0
// Size: 0x84
function function_61036bd1() {
    level clientfield::set("ee_quest_time_travel_ready", 1);
    level flag::wait_till("time_travel_teleporter_ready");
    level flag::wait_till_clear("time_travel_teleporter_ready");
    level clientfield::set("ee_quest_time_travel_ready", 0);
}

// Namespace namespace_c93e4c32
// Params 2, eflags: 0x0
// Checksum 0xf59e086f, Offset: 0x2c50
// Size: 0x27c
function function_ee0ff0d1(a_targets, var_3285d63c) {
    var_4573b5e6 = undefined;
    if (!isdefined(var_3285d63c)) {
        var_4573b5e6 = array::random(a_targets);
    } else {
        var_8717daa1 = [];
        foreach (e_target in a_targets) {
            if (!(isdefined(e_target.var_25a8b5d5) && e_target.var_25a8b5d5)) {
                if (!isdefined(var_8717daa1)) {
                    var_8717daa1 = [];
                } else if (!isarray(var_8717daa1)) {
                    var_8717daa1 = array(var_8717daa1);
                }
                var_8717daa1[var_8717daa1.size] = e_target;
            }
        }
        if (var_8717daa1.size > level.activeplayers.size) {
            var_8717daa1 = arraysort(var_8717daa1, var_3285d63c.origin);
            var_fd3f8bfd = [];
            var_5ba9a4ce = level.activeplayers.size + 1;
            for (i = 0; i < var_5ba9a4ce; i++) {
                if (!isdefined(var_fd3f8bfd)) {
                    var_fd3f8bfd = [];
                } else if (!isarray(var_fd3f8bfd)) {
                    var_fd3f8bfd = array(var_fd3f8bfd);
                }
                var_fd3f8bfd[var_fd3f8bfd.size] = var_8717daa1[i];
            }
            var_4573b5e6 = array::random(var_fd3f8bfd);
        } else {
            var_4573b5e6 = array::random(var_8717daa1);
        }
    }
    return var_4573b5e6;
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x203c79a2, Offset: 0x2ed8
// Size: 0x9a
function function_dd452f0e(a_targets) {
    var_64c4082d = 0;
    foreach (e_target in a_targets) {
        e_target.var_25a8b5d5 = 0;
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xfc3eef08, Offset: 0x2f80
// Size: 0x194
function function_7317cab3() {
    level endon(#"hash_ff289ba7");
    level endon(#"hash_9137333");
    n_damage, e_attacker, v_direction, v_point, str_means_of_death, str_tag_name, str_model_name, var_829b9480, w_weapon = self waittill(#"damage");
    if (issubstr(w_weapon.name, "elemental_bow_demongate") || issubstr(w_weapon.name, "elemental_bow_rune_prison") || issubstr(w_weapon.name, "elemental_bow_storm") || issubstr(w_weapon.name, "elemental_bow_wolf_howl")) {
        level flag::set("choose_time_travel_target");
        return;
    }
    playsoundatposition("zmb_object_fail", (0, 0, 0));
    level flag::set("reset_time_travel_target");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x757451f3, Offset: 0x3120
// Size: 0x64
function function_10a07e71() {
    level endon(#"hash_9137333");
    level endon(#"hash_ff289ba7");
    self waittill(#"damage");
    playsoundatposition("zmb_object_fail", (0, 0, 0));
    level flag::set("reset_time_travel_target");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xae47ae12, Offset: 0x3190
// Size: 0x5c
function function_d613eb57() {
    level endon(#"hash_9137333");
    level endon(#"hash_ff289ba7");
    wait(111);
    playsoundatposition("zmb_object_fail", (0, 0, 0));
    level flag::set("reset_time_travel_target");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xa775c227, Offset: 0x31f8
// Size: 0x64
function function_67147dcf() {
    level endon(#"hash_9137333");
    level endon(#"hash_ff289ba7");
    level waittill(#"between_round_over");
    playsoundatposition("zmb_object_fail", (0, 0, 0));
    level flag::set("reset_time_travel_target");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x4efb2858, Offset: 0x3268
// Size: 0x2bc
function function_627c8411() {
    level flag::wait_till("ee_golden_key");
    level flag::wait_till("time_travel_teleporter_ready");
    level endon(#"hash_a8200e36");
    level thread function_f5156f29();
    s_key = struct::get("golden_key_slot_past");
    s_key namespace_744abc1c::create_unitrigger();
    s_key waittill(#"trigger_activated");
    zm_unitrigger::unregister_unitrigger(s_key.s_unitrigger);
    mdl_key = util::spawn_model("p7_zm_ctl_keycard_ee", s_key.origin, s_key.angles);
    mdl_key.targetname = "golden_key_past";
    s_stone = struct::get("cs_replacement");
    mdl_stone = util::spawn_model("p7_zm_ctl_channeling_stone", s_stone.origin, s_stone.angles);
    mdl_stone.targetname = "stone_past";
    var_79488a88 = getent("lid_crate_stone", "targetname");
    var_79488a88 rotatepitch(-90, 1);
    var_79488a88.b_rotated = 1;
    var_79488a88 playsound("zmb_ee_lid_open");
    playsoundatposition("zmb_ee_lid_keyinsert", s_key.origin);
    mdl_stone namespace_744abc1c::create_unitrigger();
    mdl_stone waittill(#"trigger_activated");
    zm_unitrigger::unregister_unitrigger(mdl_stone.s_unitrigger);
    mdl_stone delete();
    var_79488a88.b_rotated = undefined;
    level flag::set("channeling_stone_replacement");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x1e4c8efe, Offset: 0x3530
// Size: 0x23c
function function_f5156f29() {
    level waittill(#"hash_a8200e36");
    s_key = struct::get("golden_key_slot_past");
    if (isdefined(s_key.s_unitrigger)) {
        zm_unitrigger::unregister_unitrigger(s_key.s_unitrigger);
    }
    mdl_key = getent("golden_key_past", "targetname");
    if (isdefined(mdl_key)) {
        mdl_key delete();
    }
    mdl_stone = getent("stone_past", "targetname");
    if (isdefined(mdl_stone) && isdefined(mdl_stone.s_unitrigger)) {
        zm_unitrigger::unregister_unitrigger(mdl_stone.s_unitrigger);
    }
    mdl_stone = getent("stone_past", "targetname");
    if (isdefined(mdl_stone)) {
        mdl_stone delete();
    }
    var_79488a88 = getent("lid_crate_stone", "targetname");
    if (isdefined(var_79488a88.b_rotated) && var_79488a88.b_rotated) {
        var_79488a88 rotatepitch(90, 1);
        var_79488a88.b_rotated = undefined;
        var_79488a88 playsound("zmb_ee_lid_slide");
    }
    if (!level flag::get("channeling_stone_replacement")) {
        level thread function_627c8411();
    }
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xdd48f9e1, Offset: 0x3778
// Size: 0xa4
function function_eb855685(var_f63ec558) {
    level flag::wait_till("channeling_stone_replacement");
    self namespace_744abc1c::create_unitrigger();
    self waittill(#"trigger_activated");
    zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
    self show();
    self flagsys::clear("channeling_stone_cracked");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x91626296, Offset: 0x3828
// Size: 0x3a4
function function_af12b9a4() {
    for (i = 1; i <= 4; i++) {
        mdl_glow = getent("cs_glow_" + i, "targetname");
        mdl_glow hide();
    }
    mdl_stone = getent("cs_stone_2", "targetname");
    mdl_stone hide();
    mdl_stone flagsys::set("channeling_stone_cracked");
    a_str_tokens = strtok(mdl_stone.model, "p7_zm_ctl_channeling_stone");
    var_f63ec558 = undefined;
    if (a_str_tokens.size > 0) {
        var_f63ec558 = 1;
    }
    mdl_stone thread function_eb855685(var_f63ec558);
    level flag::wait_till("start_channeling_stone_step");
    level waittill(#"hash_4619f71b");
    zm_spawner::register_zombie_death_event_callback(&function_e8de9974);
    var_b2b5bc6e = struct::get("keeper_spawn_loc", "targetname");
    var_aae59061 = getent("keeper_archon", "targetname");
    var_747532f4 = zombie_utility::spawn_zombie(var_aae59061, "keeper_archon_ai", var_b2b5bc6e);
    var_747532f4 function_2d0c5aa1(var_b2b5bc6e);
    var_747532f4 playsound("zmb_ee_resurrect_keeper_spawn");
    var_747532f4 playloopsound("zmb_ee_resurrect_keeper_lp", 2);
    var_747532f4 fx::play("ghost_torso", var_747532f4.origin, var_747532f4.angles, "ghost_torso", 1, "j_spineupper", 1);
    var_747532f4 fx::play("ghost_trail", var_747532f4.origin, var_747532f4.angles, "ghost_trail", 1, "j_robe_front_03", 1);
    wait(0.15);
    var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_charge_stone_intro", var_747532f4);
    var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_charge_stone_outro", var_747532f4);
    level thread function_fb090902();
    function_3faf6b59(var_747532f4);
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xba19dccc, Offset: 0x3bd8
// Size: 0x3d2
function function_bd20fe8(var_e8245e5f) {
    var_79b48eac = undefined;
    if (isdefined(var_e8245e5f) && var_e8245e5f) {
        level waittill(#"hash_b5927dd");
        var_79b48eac = getent("vril_generator", "targetname");
        var_79b48eac delete();
    }
    var_3b32e496 = struct::get("vril_generator");
    var_79b48eac = util::spawn_model("p7_zm_ctl_vril_generator", var_3b32e496.origin, var_3b32e496.angles);
    var_79b48eac setscale(1.7);
    var_79b48eac namespace_744abc1c::create_unitrigger();
    var_79b48eac waittill(#"trigger_activated");
    var_79b48eac playsound("zmb_ee_resurrect_vril_pickup");
    zm_unitrigger::unregister_unitrigger(var_79b48eac.s_unitrigger);
    var_79b48eac delete();
    var_ff02be4a = struct::get("vril_generator_family");
    var_ff02be4a namespace_744abc1c::create_unitrigger();
    var_ff02be4a waittill(#"trigger_activated");
    playsoundatposition("zmb_ee_resurrect_vril_place", var_ff02be4a.origin);
    zm_unitrigger::unregister_unitrigger(var_ff02be4a.s_unitrigger);
    var_79b48eac = util::spawn_model("p7_zm_ctl_vril_generator", var_ff02be4a.origin, var_ff02be4a.angles);
    var_79b48eac setscale(1.7);
    var_79b48eac fx::play("keeper_summon", var_79b48eac.origin + (0, 0, 12), var_79b48eac.angles, "delete_fx", 0, undefined, 1);
    wait(3);
    foreach (player in level.players) {
        str_player_zone = player zm_zonemgr::get_player_zone();
        if (zm_utility::is_player_valid(player) && str_player_zone === "zone_undercroft_chapel") {
            player thread lui::screen_flash(0.15, 1, 0.35, 0.95, "white");
        }
    }
    var_79b48eac notify(#"hash_629fd78d");
    var_79b48eac playsound("zmb_ee_resurrect_vril_end");
    level notify(#"hash_4619f71b");
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x7ba35502, Offset: 0x3fb8
// Size: 0x1ec
function function_2d0c5aa1(s_spawn_point) {
    self endon(#"death");
    self setphysparams(15, 0, 72);
    self.ignore_enemy_count = 1;
    self.no_eye_glow = 1;
    self.deathpoints_already_given = 1;
    self.var_8ac75273 = 1;
    self.exclude_cleanup_adding_to_total = 1;
    self.b_ignore_cleanup = 1;
    self.ignoreall = 1;
    self.ignoreme = 1;
    self util::magic_bullet_shield();
    self setcandamage(0);
    self setplayercollision(0);
    self setteam("allies");
    self.var_6f905818 = 1;
    self.var_3531cf2b = 1;
    self.var_e05d0be2 = 1;
    self.ignoremelee = 1;
    self.var_1e3fb1c = 1;
    self notsolid();
    self thread function_d1963bbd();
    self.start_inert = 1;
    self zm_spawner::zombie_think();
    if (self.zombie_move_speed === "walk") {
        self zombie_utility::set_zombie_run_cycle("run");
    }
    self.nocrawler = 1;
    self.no_powerups = 1;
    self clientfield::set("ghost_actor", 1);
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xf57b88f2, Offset: 0x41b0
// Size: 0x38
function function_d1963bbd() {
    self endon(#"death");
    self endon(#"entityshutdown");
    while (true) {
        self.knockdown = 0;
        wait(0.2);
    }
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xda0f5433, Offset: 0x41f0
// Size: 0x364
function function_e8de9974(e_attacker) {
    if (self.archetype === "zombie") {
        if (isdefined(e_attacker.var_507ad4a9) && isdefined(e_attacker.var_babefc4c) && zm_utility::is_player_valid(e_attacker) && e_attacker.var_babefc4c && e_attacker.var_507ad4a9) {
            if (issubstr(self.damageweapon.name, "elemental_bow_" + level.var_1f18338d)) {
                mdl_stone = getent("cs_stone_" + level.var_f1b0baba, "targetname");
                if (!isdefined(mdl_stone) || !mdl_stone flagsys::get("channeling_stone_cracked")) {
                    e_volume = getent("cs_zone_" + level.var_f1b0baba, "targetname");
                    if (self istouching(e_volume)) {
                        mdl_glow = getent("cs_glow_" + level.var_f1b0baba, "targetname");
                        var_25c1c42e = function_6fc08711();
                        self thread namespace_99cb5531::function_55c48922(self.origin, mdl_glow.origin, var_25c1c42e, isdefined(self.missinglegs) && self.missinglegs);
                        level.var_8bdb0713++;
                        if (level.var_8bdb0713 == 1) {
                            level waittill(#"hash_d8b279ab");
                            mdl_glow clientfield::set("channeling_stone_glow", 1);
                            var_747532f4 = getent("keeper_archon_ai", "targetname");
                            var_747532f4 notify(#"hash_72e982f4");
                            var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_charge_stone_intro", var_747532f4);
                            var_747532f4 thread scene::play("cin_zm_dlc1_corrupted_keeper_charge_stone_loop", var_747532f4);
                            var_747532f4 fx::play("keeper_charge", var_747532f4.origin, var_747532f4.angles, "keeper_charge", 1, "j_spineupper", 1);
                            str_exploder = function_ac7d9299();
                            exploder::exploder(str_exploder);
                        }
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x971d69c7, Offset: 0x4560
// Size: 0x9a
function function_6fc08711() {
    var_25c1c42e = undefined;
    switch (level.var_1f18338d) {
    case 111:
        var_25c1c42e = "demon";
        break;
    case 112:
        var_25c1c42e = "rune";
        break;
    case 109:
        var_25c1c42e = "storm";
        break;
    case 113:
        var_25c1c42e = "wolf";
        break;
    default:
        break;
    }
    return var_25c1c42e;
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xbc5f63af, Offset: 0x4608
// Size: 0x9a
function function_ac7d9299() {
    str_exploder = undefined;
    switch (level.var_f1b0baba) {
    case 1:
        str_exploder = "fxexp_631";
        break;
    case 2:
        str_exploder = "fxexp_632";
        break;
    case 3:
        str_exploder = "fxexp_630";
        break;
    case 4:
        str_exploder = "fxexp_633";
        break;
    default:
        break;
    }
    return str_exploder;
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xca5ccc10, Offset: 0x46b0
// Size: 0xac
function function_a760f135() {
    level.var_e2ce8e32 = [];
    level thread function_afc77531("demon_gate_upgraded", "demongate");
    level thread function_afc77531("elemental_storm_upgraded", "storm");
    level thread function_afc77531("rune_prison_upgraded", "rune_prison");
    level thread function_afc77531("wolf_howl_upgraded", "wolf_howl");
}

// Namespace namespace_c93e4c32
// Params 2, eflags: 0x0
// Checksum 0x37a05170, Offset: 0x4768
// Size: 0xca
function function_afc77531(str_flag, str_element) {
    if (!(isdefined(level.var_dfc343e9) && level.var_dfc343e9)) {
        if (!level flag::get(str_flag)) {
            level flag::wait_till(str_flag);
        }
    }
    if (!isdefined(level.var_e2ce8e32)) {
        level.var_e2ce8e32 = [];
    } else if (!isarray(level.var_e2ce8e32)) {
        level.var_e2ce8e32 = array(level.var_e2ce8e32);
    }
    level.var_e2ce8e32[level.var_e2ce8e32.size] = str_element;
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xd6379da1, Offset: 0x4840
// Size: 0x10e
function function_4ce3eea5(var_bda73276) {
    str_element = level.var_e2ce8e32[var_bda73276];
    if (!isdefined(str_element)) {
        n_players = level.players.size;
        /#
            n_players += level.var_b5231dfb;
            if (n_players > 4) {
                n_players = 4;
            }
        #/
        if (var_bda73276 >= n_players) {
            n_index = var_bda73276 - n_players;
            for (str_element = level.var_e2ce8e32[n_index]; !isdefined(str_element); str_element = level.var_e2ce8e32[n_index]) {
                n_index -= n_players;
            }
        } else {
            while (!isdefined(str_element)) {
                wait(0.15);
                str_element = level.var_e2ce8e32[var_bda73276];
            }
        }
    }
    return str_element;
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x23699f88, Offset: 0x4958
// Size: 0xa7c
function function_3faf6b59(var_747532f4) {
    a_zones = array(1, 2, 3, 4);
    function_a760f135();
    level.var_e2ce8e32 = array::randomize(level.var_e2ce8e32);
    a_zones = array::randomize(a_zones);
    for (i = 0; i < a_zones.size; i++) {
        foreach (player in level.players) {
            player thread function_812faaaf();
        }
        level.var_f1b0baba = a_zones[i];
        level.var_8bdb0713 = 0;
        s_stone = struct::get("cs_keeper_pos_" + level.var_f1b0baba);
        var_747532f4 setgoal(s_stone.origin);
        var_747532f4 waittill(#"goal");
        var_747532f4 thread function_37fb253(s_stone);
        var_747532f4 playsound("zmb_ee_resurrect_start_circle");
        level.var_1f18338d = function_4ce3eea5(i);
        level thread function_99ac27a();
        if (i > 1) {
            if (!level flag::get("solo_game") || i > 2) {
                var_747532f4 thread function_88e260d();
            }
        }
        function_4f8445d7(a_zones[i]);
        playsoundatposition("zmb_ee_resurrect_circle_complete", (0, 0, 0));
        level flag::clear("next_channeling_stone");
        var_747532f4 scene::stop("cin_zm_dlc1_corrupted_keeper_charge_stone_loop");
        var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_charge_stone_outro", var_747532f4);
        var_747532f4 playsound("zmb_ee_resurrect_power_complete");
        wait(0.15);
    }
    zm_spawner::deregister_zombie_death_event_callback(&function_e8de9974);
    var_82a4f07b = struct::get("keeper_end_loc");
    var_82a4f07b fx::play("mpd_fx", var_82a4f07b.origin, var_82a4f07b.angles, "delete_fx", 0, undefined, 1);
    level.var_8ef26cd9 = 1;
    foreach (player in level.players) {
        player thread namespace_744abc1c::function_fa7da172();
    }
    callback::on_connect(&namespace_744abc1c::function_fa7da172);
    var_57615f80 = getentarray("pyramid", "targetname");
    foreach (var_27fd0c6f in var_57615f80) {
        var_54a70b81 = (var_27fd0c6f.origin[0], var_27fd0c6f.origin[1], var_27fd0c6f.origin[2] - 96);
        var_27fd0c6f notsolid();
        var_27fd0c6f connectpaths();
        var_27fd0c6f moveto(var_54a70b81, 3);
    }
    var_747532f4 clientfield::set("ghost_actor", 0);
    var_747532f4 notify(#"hash_d448e75e");
    var_747532f4 notify(#"ghost_trail");
    var_747532f4 playsound("zmb_ee_resurrect_keeper_notghost");
    var_747532f4 playloopsound("zmb_ee_resurrect_keeper_notghost_lp");
    var_747532f4 fx::play("keeper_torso", var_747532f4.origin, var_747532f4.angles, "keeper_torso", 1, "j_spineupper", 1);
    var_747532f4 fx::play("keeper_mouth", var_747532f4.origin, var_747532f4.angles, "keeper_torso", 1, "j_head", 1);
    var_747532f4 fx::play("keeper_trail", var_747532f4.origin, var_747532f4.angles, "keeper_trail", 1, "j_robe_front_03", 1);
    wait(3);
    level.var_cc2ea6e8 = undefined;
    var_747532f4 notify(#"hash_72e982f4");
    s_stone = struct::get("keeper_end_loc");
    var_747532f4 setgoal(s_stone.origin);
    var_747532f4 waittill(#"goal");
    var_747532f4 playsound("zmb_ee_resurrect_end_warpaway");
    var_747532f4 fx::play("keeper_beam", var_747532f4.origin, var_747532f4.angles, undefined, 1, "j_mainroot", 1);
    exploder::exploder("fxexp_601");
    exploder::exploder("fxexp_602");
    exploder::exploder("fxexp_603");
    exploder::exploder("fxexp_604");
    foreach (player in level.players) {
        player thread function_6ff05666();
    }
    callback::on_connect(&function_6ff05666);
    level flag::wait_till("see_keeper");
    callback::remove_on_connect(&function_6ff05666);
    pause_zombies(1);
    var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_float_emerge", var_747532f4);
    exploder::kill_exploder("fxexp_601");
    exploder::kill_exploder("fxexp_602");
    exploder::kill_exploder("fxexp_603");
    exploder::kill_exploder("fxexp_604");
    var_747532f4 delete();
    var_82a4f07b notify(#"hash_629fd78d");
    callback::remove_on_connect(&namespace_744abc1c::function_fa7da172);
    level.var_8ef26cd9 = undefined;
    namespace_97ddfc0d::function_70721c81();
    pause_zombies(0);
    level flag::set("boss_fight_ready");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xb940aa85, Offset: 0x53e0
// Size: 0xc4
function function_6ff05666() {
    self endon(#"death");
    var_747532f4 = getent("keeper_archon_ai", "targetname");
    for (str_player_zone = self zm_zonemgr::get_player_zone(); !zm_utility::is_player_valid(self) || str_player_zone !== "zone_undercroft"; str_player_zone = self zm_zonemgr::get_player_zone()) {
        wait(0.15);
    }
    level flag::set("see_keeper");
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xf299ef06, Offset: 0x54b0
// Size: 0x11c
function function_37fb253(var_33b10d19) {
    var_4811f4e0 = util::spawn_model("tag_origin", self.origin, self.angles);
    self linkto(var_4811f4e0);
    var_4811f4e0 rotateto(var_33b10d19.angles, 1);
    var_91e5f72f = (var_33b10d19.origin[0], var_33b10d19.origin[1], self.origin[2]);
    var_4811f4e0 moveto(var_91e5f72f, 1);
    self waittill(#"hash_72e982f4");
    self unlink();
    var_4811f4e0 delete();
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xd6f18307, Offset: 0x55d8
// Size: 0x1c8
function function_99ac27a() {
    level endon(#"hash_f10dc438");
    mdl_stone = getent("cs_stone_" + level.var_f1b0baba, "targetname");
    if (isdefined(mdl_stone)) {
        mdl_stone flagsys::wait_till_clear("channeling_stone_cracked");
    }
    mdl_glow = getent("cs_glow_" + level.var_f1b0baba, "targetname");
    mdl_glow show();
    level thread function_6bfbde41();
    var_dd155127 = function_f507c094();
    while (true) {
        if (function_1f8ca830()) {
            var_747532f4 = getent("keeper_archon_ai", "targetname");
            var_747532f4 notify(#"hash_22a2d66");
            str_exploder = function_ac7d9299();
            exploder::kill_exploder(str_exploder);
            mdl_glow clientfield::set("channeling_stone_glow", 2);
            level flag::set("next_channeling_stone");
        }
        wait(0.15);
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xaef7895d, Offset: 0x57a8
// Size: 0x96
function function_4400f882() {
    var_dd155127 = 16;
    switch (level.var_1f18338d) {
    case 111:
        var_dd155127 = 17;
        break;
    case 112:
        var_dd155127 = 16;
        break;
    case 109:
        var_dd155127 = 20;
        break;
    case 113:
        var_dd155127 = 18;
        break;
    default:
        break;
    }
    return var_dd155127;
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xa7d29162, Offset: 0x5848
// Size: 0xa0
function function_f507c094() {
    var_dd155127 = function_4400f882();
    n_players = level.players.size;
    /#
        n_players += level.var_b5231dfb;
        if (n_players > 4) {
            n_players = 4;
        }
    #/
    var_4b5cecfa = 4 - n_players - 1;
    var_dd155127 *= var_4b5cecfa;
    return var_dd155127;
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x1840cdd4, Offset: 0x58f0
// Size: 0x48
function function_6bfbde41() {
    level endon(#"hash_f10dc438");
    while (true) {
        level.var_f91118d9 = undefined;
        level waittill(#"end_of_round");
        level.var_f91118d9 = 1;
        level waittill(#"start_of_round");
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x5f499735, Offset: 0x5940
// Size: 0x7e
function function_1f8ca830() {
    var_7ec3e0eb = 0;
    if (level.var_8bdb0713 >= function_4400f882()) {
        if (isdefined(level.var_f91118d9) && level.var_f91118d9) {
            var_7ec3e0eb = 1;
        } else if (level.var_8bdb0713 >= function_f507c094()) {
            var_7ec3e0eb = 1;
        }
    }
    return var_7ec3e0eb;
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xaf9643da, Offset: 0x59c8
// Size: 0xdc
function function_812faaaf() {
    self endon(#"death");
    level endon(#"hash_f10dc438");
    while (true) {
        var_3fee16b8, var_e1041201 = self waittill(#"missile_fire");
        if (isdefined(self.var_507ad4a9) && zm_utility::is_player_valid(self) && self.var_507ad4a9) {
            if (issubstr(var_e1041201.name, "elemental_bow_" + level.var_1f18338d)) {
                self.var_babefc4c = 1;
            } else {
                self.var_babefc4c = undefined;
            }
        } else {
            self.var_babefc4c = undefined;
        }
        wait(0.05);
    }
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x797394f8, Offset: 0x5ab0
// Size: 0x480
function function_4f8445d7(n_zone) {
    level.var_b5231dfb = 0;
    var_1171297b = function_f5a8624();
    var_d8c501d = var_1171297b.var_d8c501d;
    var_e715c2a4 = var_1171297b.var_e715c2a4;
    var_d8702dd1 = [];
    for (i = 0; i < var_d8c501d.size; i++) {
        var_d8702dd1[i] = var_d8c501d[i] * var_d8c501d[i];
    }
    var_560e7570 = var_d8702dd1[0];
    var_6998342d = var_d8c501d[0];
    var_d139aee0 = "" + var_6998342d;
    var_1acc807d = struct::get_array("cscircle_" + n_zone);
    var_87367d4f = array::random(var_1acc807d);
    var_fcfee273 = "lgt_channel_stones_" + n_zone + var_e715c2a4[var_d139aee0];
    exploder::exploder(var_fcfee273);
    var_bffe8a31 = 0;
    while (!level flag::get("next_channeling_stone")) {
        var_470f6bc3 = 0;
        foreach (player in level.players) {
            if (zm_utility::is_player_valid(player) && distance2dsquared(player.origin, var_87367d4f.origin) < var_560e7570) {
                player.var_507ad4a9 = 1;
                var_470f6bc3++;
                player thread function_af71af0e();
                continue;
            }
            player.var_507ad4a9 = undefined;
        }
        if (level flag::get("solo_game")) {
            var_470f6bc3 += 2;
        }
        /#
            var_470f6bc3 += level.var_b5231dfb;
        #/
        if (var_470f6bc3 > 4) {
            var_470f6bc3 = 4;
        }
        if (var_470f6bc3 != var_bffe8a31) {
            exploder::kill_exploder(var_fcfee273);
            var_560e7570 = var_d8702dd1[var_470f6bc3];
            var_6998342d = var_d8c501d[var_470f6bc3];
            var_d139aee0 = "" + var_6998342d;
            var_fcfee273 = "lgt_channel_stones_" + n_zone + var_e715c2a4[var_d139aee0];
            exploder::exploder(var_fcfee273);
            var_bffe8a31 = var_470f6bc3;
        }
        wait(0.05);
    }
    exploder::kill_exploder(var_fcfee273);
    foreach (player in level.players) {
        player.var_507ad4a9 = undefined;
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x32b4c416, Offset: 0x5f38
// Size: 0xfc
function function_f5a8624() {
    var_d8c501d = array(48, 80, 112, -64, 256);
    var_e715c2a4 = [];
    for (i = 0; i < var_d8c501d.size; i++) {
        var_d8a81ebe = "" + var_d8c501d[i];
        var_e715c2a4[var_d8a81ebe] = "_" + i + 1;
    }
    var_1171297b = spawnstruct();
    var_1171297b.var_d8c501d = var_d8c501d;
    var_1171297b.var_e715c2a4 = var_e715c2a4;
    return var_1171297b;
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x72cf883f, Offset: 0x6040
// Size: 0x3cc
function function_c460669e() {
    function_2925fac8();
    a_models = getentarray("script_model", "classname");
    foreach (var_568ffe7c in a_models) {
        if (var_568ffe7c.model === "veh_t7_dlc1_mil_halftrack_dead_snow") {
            var_568ffe7c setcontents(8192);
        }
    }
    var_ee79aaa6 = getent("uc_capsule_crash_after", "targetname");
    var_ee79aaa6 hide();
    var_c4556169 = getent("uc_crash_cryo_after", "targetname");
    var_c4556169 hide();
    level flag::wait_till("ee_golden_key");
    var_e7113aa6 = 0;
    level.var_cf5a713 = undefined;
    var_18b93ed0 = struct::get_array("golden_key_slot");
    while (var_e7113aa6 < 2) {
        var_18b93ed0[0] thread function_bb8e762c(var_18b93ed0[1]);
        var_18b93ed0[1] thread function_bb8e762c(var_18b93ed0[0]);
        var_b5aa6f14 = function_19abb192(var_e7113aa6);
        function_15752140(var_b5aa6f14);
        if (level.var_e3162591 && level flag::get("switch_to_death_ray") && level flag::get("tesla_connector_" + level.var_cf5a713.script_noteworthy)) {
            var_e7113aa6++;
        } else {
            var_e7113aa6 = 0;
            foreach (var_4ae0fc9f in var_18b93ed0) {
                var_4ae0fc9f.b_done = undefined;
            }
            exploder::stop_exploder("fxexp_730");
            exploder::stop_exploder("fxexp_731");
        }
        level flag::clear("simon_terminal_activated");
    }
    function_7d8964c9();
    level flag::set("start_channeling_stone_step");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x7061644b, Offset: 0x6418
// Size: 0xc4
function function_6cd00f33() {
    for (var_37c17be6 = undefined; !isdefined(var_37c17be6); var_37c17be6 = getent("rocket_bell", "targetname")) {
        wait(0.5);
    }
    var_37c17be6 thread function_c7c38164("stop_damage_loop");
    var_37c17be6 waittill(#"hash_7969a7d6");
    var_47017e15 = getent("fallen_bell_damage_trigger", "targetname");
    var_47017e15 function_c7c38164();
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xab723f22, Offset: 0x64e8
// Size: 0xa0
function function_c7c38164(str_endon) {
    if (!isdefined(str_endon)) {
        str_endon = undefined;
    }
    if (isdefined(str_endon)) {
        self endon(str_endon);
    }
    while (true) {
        n_amount, e_attacker = self waittill(#"damage");
        if (isplayer(e_attacker)) {
            self playsound("zmb_ee_rocketcrash_bell_imp_1");
            wait(0.1);
        }
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x6ae17290, Offset: 0x6590
// Size: 0x36c
function function_7d8964c9() {
    if (level scene::is_playing("p7_fxanim_zm_castle_rocket_bell_tower_bundle")) {
        level scene::stop("p7_fxanim_zm_castle_rocket_bell_tower_bundle");
    }
    if (level scene::is_playing("p7_fxanim_zm_castle_rocket_tip_bundle")) {
        level scene::stop("p7_fxanim_zm_castle_rocket_tip_bundle");
    }
    exploder::exploder("lgt_deathray_back");
    var_cf2402ea = struct::get("death_ray_button");
    var_cf2402ea namespace_744abc1c::create_unitrigger();
    var_cf2402ea waittill(#"trigger_activated");
    playsoundatposition("zmb_ee_rocketcrash_ray_button", var_cf2402ea.origin);
    level clientfield::set("sndDeathRayToMoon", 1);
    zm_unitrigger::unregister_unitrigger(var_cf2402ea.s_unitrigger);
    exploder::stop_exploder("lgt_deathray_back");
    exploder::exploder("fxexp_698");
    exploder::exploder("fxexp_740");
    playrumbleonposition("zm_castle_death_ray_ee_rumble", var_cf2402ea.origin);
    wait(3);
    exploder::stop_exploder("fxexp_698");
    exploder::stop_exploder("fxexp_740");
    exploder::stop_exploder("fxexp_730");
    exploder::stop_exploder("fxexp_731");
    level clientfield::set("sndDeathRayToMoon", 0);
    var_977dbe2f = struct::get("ee_rocket_explosion");
    var_977dbe2f fx::play("rocket_explosion", var_977dbe2f.origin, var_977dbe2f.angles);
    wait(2.5);
    level thread function_bd20fe8(1);
    level flag::set("start_channeling_stone_step");
    scene::add_scene_func("p7_fxanim_zm_castle_rocket_tip_bundle", &function_1ca91be4);
    scene::add_scene_func("p7_fxanim_zm_castle_rocket_tip_bundle", &function_b404c31d);
    level thread scene::play("p7_fxanim_zm_castle_rocket_tip_bundle");
    level thread scene::play("p7_fxanim_zm_castle_rocket_bell_tower_bundle");
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x82b33a55, Offset: 0x6908
// Size: 0x3ac
function function_1ca91be4(a_ents) {
    var_3e414a21 = a_ents["rocket_tip"];
    var_a723142d = a_ents["cryo_chamber"];
    var_2d13d22c = a_ents["dempsey_02"];
    var_2d13d22c ghost();
    wait(5);
    array::run_all(level.players, &playrumbleonentity, "zm_castle_rocket_tip");
    var_3e414a21 waittill(#"hash_43ba2284");
    array::run_all(level.players, &playrumbleonentity, "zm_castle_rocket_tip_tower_crash");
    var_3e414a21 waittill(#"hash_87acceea");
    array::run_all(level.players, &playrumbleonentity, "zm_castle_rocket_tip_ground_crash");
    var_a723142d clientfield::set("pod_monitor_enable", 1);
    var_2d13d22c show();
    var_ee79aaa6 = getent("uc_capsule_crash_after", "targetname");
    var_ee79aaa6 show();
    var_7385ffad = getentarray("uc_capsule_crash_before", "targetname");
    foreach (var_de31b779 in var_7385ffad) {
        var_de31b779 delete();
    }
    var_a723142d waittill(#"hash_9a7af34f");
    foreach (e_player in level.players) {
        e_player thread function_35c1d14d();
    }
    callback::on_connect(&function_d4be5c9f);
    level thread scene::play("cin_cas_01_outro_3rd_static_poses");
    wait(3);
    var_a723142d delete();
    mdl_pod = getent("pod", "targetname");
    mdl_pod clientfield::set("pod_monitor_enable", 1);
    namespace_97ddfc0d::function_44c11f63();
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x4a1754be, Offset: 0x6cc0
// Size: 0xb4
function function_b404c31d(a_ents) {
    var_a723142d = a_ents["cryo_chamber"];
    var_a723142d waittill(#"hash_225501ad");
    var_c4556169 = getent("uc_crash_cryo_after", "targetname");
    var_c4556169 show();
    var_e7d455cc = getent("uc_crash_cryo_before", "targetname");
    var_e7d455cc delete();
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x5f64afbb, Offset: 0x6d80
// Size: 0x114
function function_35c1d14d() {
    self endon(#"death");
    level endon(#"hash_f200c253");
    var_6326f93a = getent("cryo_chamber_shock_volume", "targetname");
    while (true) {
        if (self istouching(var_6326f93a)) {
            self setelectrified(1.5);
            self shellshock("electrocution", 1.5);
            self playsound("wpn_teslatrap_zap");
            self playrumbleonentity("zm_castle_tesla_electrocution");
            wait(1.5);
            continue;
        }
        wait(0.25);
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x5a77101c, Offset: 0x6ea0
// Size: 0x1c
function function_d4be5c9f() {
    self thread function_35c1d14d();
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xd20703ac, Offset: 0x6ec8
// Size: 0x6a
function function_19abb192(var_e7113aa6) {
    var_b5aa6f14 = undefined;
    switch (var_e7113aa6) {
    case 0:
        var_b5aa6f14 = 7;
        break;
    case 1:
        var_b5aa6f14 = 8;
        break;
    default:
        break;
    }
    return var_b5aa6f14;
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x3e3df18b, Offset: 0x6f40
// Size: 0xb4
function function_bb8e762c(var_ff508804) {
    level endon(#"hash_1d81c74c");
    if (isdefined(self.b_done) && self.b_done) {
        return;
    }
    self namespace_744abc1c::create_unitrigger(undefined, 8);
    self waittill(#"trigger_activated");
    zm_unitrigger::unregister_unitrigger(var_ff508804.s_unitrigger);
    zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
    level.var_cf5a713 = self;
    level flag::set("simon_terminal_activated");
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x1ed09234, Offset: 0x7000
// Size: 0x7cc
function function_15752140(var_b5aa6f14) {
    level.var_e3162591 = 0;
    level flag::wait_till("simon_terminal_activated");
    var_d733da61 = 1;
    if (level.var_cf5a713.script_noteworthy == "launch_platform") {
        var_d733da61 = 2;
    }
    var_e131c06 = util::spawn_model("p7_zm_ctl_keycard_ee", level.var_cf5a713.origin, level.var_cf5a713.angles);
    var_4d74106b = getent("symbols_" + level.var_cf5a713.script_noteworthy, "targetname");
    var_4d74106b playsound("zmb_ee_simonsays_insertcard");
    var_c5ea7ad8 = array("1", "2", "3", "4");
    var_c5ea7ad8 = array::randomize(var_c5ea7ad8);
    var_a6116854 = [];
    for (i = 0; i < 4; i++) {
        var_a6116854[var_c5ea7ad8[i]] = struct::get("monitor_" + level.var_cf5a713.script_noteworthy + "_" + i + 1);
        var_a6116854[var_c5ea7ad8[i]].var_73527aa3 = undefined;
        var_a6116854[var_c5ea7ad8[i]] namespace_744abc1c::create_unitrigger(undefined, 16);
        var_4d74106b showpart("tag_scn" + i + 1 + "_sym" + var_c5ea7ad8[i]);
        level thread function_b76d0c45(var_a6116854[var_c5ea7ad8[i]], "tag_scn" + i + 1 + "_sym" + var_c5ea7ad8[i], "lgt_EE_consol" + var_d733da61 + "_monitor_" + i + 1);
    }
    level waittill(#"hash_706f7f9a");
    level thread function_fb090902(1);
    var_1a972685 = spawnstruct();
    level.var_521b0bd1 = 0;
    while (!level flag::get("end_simon")) {
        var_2fe972c1 = array::random(var_c5ea7ad8);
        var_a6116854[var_2fe972c1].var_73527aa3 = 1;
        var_1a972685.var_94287343 = "tag_scn0_sym" + var_2fe972c1;
        var_4d74106b showpart("tag_scn0_sym" + var_2fe972c1);
        var_4d74106b playsound("zmb_ee_simonsays_show");
        exploder::exploder("lgt_EE_consol" + var_d733da61 + "_monitor_main");
        level thread function_5ed05adc(var_4d74106b, var_d733da61);
        a_flags = array("simon_timed_out", "simon_press_check");
        level flag::wait_till_any(a_flags);
        exploder::exploder("lgt_EE_consol" + var_d733da61 + "_monitor_main");
        if (level flag::get("simon_timed_out")) {
            level flag::set("end_simon");
            level flag::clear("simon_timed_out");
            var_4d74106b playsound("zmb_ee_simonsays_nay");
        } else {
            level waittill(#"hash_b7f06cd9");
            level flag::clear("simon_press_check");
        }
        exploder::kill_exploder("lgt_EE_consol" + var_d733da61 + "_monitor_main");
        var_4d74106b hidepart(var_1a972685.var_94287343);
        var_a6116854[var_2fe972c1].var_73527aa3 = undefined;
        if (level.var_521b0bd1 >= var_b5aa6f14) {
            level flag::set("end_simon");
            level.var_cf5a713.b_done = 1;
            level.var_e3162591 = 1;
            var_4d74106b playsound("zmb_ee_simonsays_complete");
            if (level.var_cf5a713.script_noteworthy == "lower_tower") {
                exploder::exploder("fxexp_730");
            } else if (level.var_cf5a713.script_noteworthy == "launch_platform") {
                exploder::exploder("fxexp_731");
            }
        }
        wait(0.25);
    }
    level notify(#"hash_b0b992fb");
    function_2925fac8();
    foreach (var_901d8fb2 in var_a6116854) {
        zm_unitrigger::unregister_unitrigger(var_901d8fb2.s_unitrigger);
    }
    level.var_cc2ea6e8 = undefined;
    var_e131c06 delete();
    level flag::clear("simon_press_check");
    level flag::clear("simon_timed_out");
    level flag::clear("end_simon");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xd3bef49c, Offset: 0x77d8
// Size: 0x166
function function_2925fac8() {
    var_91d3caa4 = struct::get_array("golden_key_slot");
    foreach (s_slot in var_91d3caa4) {
        var_4d74106b = getent("symbols_" + s_slot.script_noteworthy, "targetname");
        for (i = 0; i < 5; i++) {
            for (j = 1; j <= 4; j++) {
                var_4d74106b hidepart("tag_scn" + i + "_sym" + j);
            }
        }
    }
}

// Namespace namespace_c93e4c32
// Params 3, eflags: 0x0
// Checksum 0x51c02fe4, Offset: 0x7948
// Size: 0x258
function function_b76d0c45(var_9ed14cca, var_2fe972c1, var_8d53d8ef) {
    level endon(#"hash_b0b992fb");
    exploder::exploder(var_8d53d8ef);
    wait(6);
    exploder::kill_exploder(var_8d53d8ef);
    var_4d74106b = getent("symbols_" + level.var_cf5a713.script_noteworthy, "targetname");
    var_4d74106b hidepart(var_2fe972c1);
    level notify(#"hash_706f7f9a");
    while (true) {
        var_9ed14cca waittill(#"trigger_activated");
        if (!level flag::get("simon_press_check")) {
            level flag::set("simon_press_check");
            var_4d74106b showpart(var_2fe972c1);
            playsoundatposition("zmb_ee_simonsays_button", var_9ed14cca.origin);
            exploder::exploder(var_8d53d8ef);
            wait(3);
            exploder::kill_exploder(var_8d53d8ef);
            var_4d74106b hidepart(var_2fe972c1);
            if (isdefined(var_9ed14cca.var_73527aa3) && var_9ed14cca.var_73527aa3) {
                level.var_521b0bd1++;
                var_4d74106b playsound("zmb_ee_simonsays_yay");
            } else {
                level flag::set("end_simon");
                var_4d74106b playsound("zmb_ee_simonsays_nay");
            }
            level notify(#"hash_b7f06cd9");
        }
        wait(0.15);
    }
}

// Namespace namespace_c93e4c32
// Params 2, eflags: 0x0
// Checksum 0xeca7f81e, Offset: 0x7ba8
// Size: 0xfc
function function_5ed05adc(var_4d74106b, var_d733da61) {
    level endon(#"hash_7c1a71c8");
    for (i = 6; i != -1; i--) {
        var_4d74106b playsound("zmb_ee_simonsays_timer");
        wait(1);
        if (i % 2) {
            exploder::kill_exploder("lgt_EE_consol" + var_d733da61 + "_monitor_main");
            continue;
        }
        exploder::exploder("lgt_EE_consol" + var_d733da61 + "_monitor_main");
    }
    level flag::set("simon_timed_out");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xf96b1ee3, Offset: 0x7cb0
// Size: 0x104
function function_71152937() {
    level scene::stop("cin_zm_castle_drgroph_easteregg");
    level.sndvoxoverride = 0;
    var_5fbf9989 = getentarray("safe_uc_clean", "targetname");
    foreach (var_fba414fd in var_5fbf9989) {
        var_fba414fd show();
    }
    level notify(#"hash_a8200e36");
    level namespace_97ddfc0d::function_8ac5430();
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x59667dba, Offset: 0x7dc0
// Size: 0x2fe
function function_2c1aa78f() {
    if (!isdefined(level.var_ab58bca7)) {
        level.var_ab58bca7 = array(0, 0, 0);
    }
    var_b873610a = level flag::get("ee_safe_open");
    if (var_b873610a == 0) {
        for (i = 0; i < 3; i++) {
            level.var_ab58bca7[i] = randomint(4);
        }
    }
    if (!level flag::get("dimension_set")) {
        var_5fbf9989 = getentarray("safe_uc_clean", "targetname");
        foreach (var_fba414fd in var_5fbf9989) {
            var_fba414fd hide();
        }
        s_scriptbundle = struct::get("cin_zm_castle_drgroph_easteregg", "scriptbundlename");
        s_scriptbundle.scene_played = 0;
        level thread scene::init("cin_zm_castle_drgroph_easteregg");
        level namespace_97ddfc0d::function_8ac5430(1, s_scriptbundle.origin);
        level waittill(#"hash_59b7ed");
        level thread scene::play("cin_zm_castle_drgroph_easteregg");
        var_4bff825e = getent("safe_code_past", "targetname");
        for (i = 0; i < 3; i++) {
            if (!level flag::get("dimension_set")) {
                level waittill("ee_button_" + i + 1);
            }
            var_4bff825e showpart("tag_scn" + i + "_sym" + level.var_ab58bca7[i] + 1);
        }
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xda2d7ef4, Offset: 0x80c8
// Size: 0x2f8
function function_1ab64038() {
    level endon(#"hash_d74466b6");
    var_cf2f0df8 = struct::get("ee_lab_fuse");
    var_7698e9a4 = getent("fuse_box", "targetname");
    while (true) {
        var_7698e9a4 hidepart("j_chip01");
        var_7698e9a4 hidepart("j_chip02");
        level flag::wait_till("time_travel_teleporter_ready");
        var_5a28c976 = util::spawn_model("p7_zm_ctl_console_deathray_relay_2x", var_cf2f0df8.origin, var_cf2f0df8.angles);
        var_5a28c976 namespace_744abc1c::create_unitrigger();
        var_5a28c976 waittill(#"trigger_activated");
        level flag::set("ee_fuse_held_by_team");
        zm_unitrigger::unregister_unitrigger(var_5a28c976.s_unitrigger);
        playsoundatposition("zmb_fuse_pickup", var_5a28c976.origin);
        var_5a28c976 delete();
        var_7698e9a4 namespace_744abc1c::create_unitrigger();
        var_7698e9a4 waittill(#"trigger_activated");
        zm_unitrigger::unregister_unitrigger(var_7698e9a4.s_unitrigger);
        var_7698e9a4 playsound("zmb_fuse_place");
        var_7698e9a4 showpart("j_chip01");
        var_7698e9a4 showpart("j_chip02");
        exploder::exploder("fxexp_750");
        level flag::set("ee_fuse_placed");
        level flag::clear("ee_fuse_held_by_team");
        level flag::wait_till_clear("ee_fuse_placed");
        var_7698e9a4 playsound("zmb_fuse_explo");
        exploder::stop_exploder("fxexp_750");
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x89d74508, Offset: 0x83c8
// Size: 0x2b4
function function_71568f8() {
    var_abee83e8 = getent("ee_death_ray_switch_pointer", "targetname");
    var_abee83e8 rotatepitch(45, 0.25);
    level flag::set("switch_to_death_ray");
    mdl_lever = getent("ee_death_ray_switch", "targetname");
    mdl_lever rotatepitch(-180, 0.25);
    level flag::wait_till("ee_fuse_placed");
    mdl_lever namespace_744abc1c::create_unitrigger(undefined, 32);
    while (true) {
        while (!level flag::get("switch_to_death_ray")) {
            mdl_lever waittill(#"trigger_activated");
            if (level flag::get("ee_fuse_placed")) {
                mdl_lever rotatepitch(-180, 0.25);
                var_abee83e8 rotatepitch(90, 0.25);
                var_abee83e8 playsound("zmb_deathray_switch");
                level flag::set("switch_to_death_ray");
            }
        }
        while (level flag::get("switch_to_death_ray")) {
            mdl_lever waittill(#"trigger_activated");
            if (level flag::get("ee_fuse_placed")) {
                mdl_lever rotatepitch(-76, 0.25);
                var_abee83e8 rotatepitch(-90, 0.25);
                var_abee83e8 playsound("zmb_deathray_switch");
                level flag::clear("switch_to_death_ray");
            }
        }
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x8deb68e6, Offset: 0x8688
// Size: 0x6fa
function function_d2c78092() {
    var_c5ea7ad8 = array(1, 2, 3, 4);
    while (!level flag::get("ee_safe_open")) {
        level flag::wait_till("ee_fuse_placed");
        level flag::wait_till("death_ray_trap_used");
        level thread function_fb090902(1);
        var_c5ea7ad8 = array::randomize(var_c5ea7ad8);
        level.var_a44ebbe8 = [];
        var_ebbefa14 = [];
        var_91d3caa4 = struct::get_array("golden_key_slot");
        foreach (s_slot in var_91d3caa4) {
            var_d733da61 = 1;
            if (s_slot.script_noteworthy == "launch_platform") {
                var_d733da61 = 2;
            }
            var_4d74106b = getent("symbols_" + s_slot.script_noteworthy, "targetname");
            for (i = 1; i <= 4; i++) {
                var_4d74106b showpart("tag_scn" + i + "_sym" + var_c5ea7ad8[i - 1]);
                exploder::exploder("lgt_EE_consol" + var_d733da61 + "_monitor_" + i);
                var_e349e3f = struct::get("monitor_" + s_slot.script_noteworthy + "_" + i);
                var_e349e3f.var_a95f1f56 = i;
                var_e349e3f.var_d82c7c68 = var_c5ea7ad8[i - 1];
                var_e349e3f namespace_744abc1c::create_unitrigger(undefined, 16);
                level thread function_96ca12f5(var_e349e3f);
                if (!isdefined(var_ebbefa14)) {
                    var_ebbefa14 = [];
                } else if (!isarray(var_ebbefa14)) {
                    var_ebbefa14 = array(var_ebbefa14);
                }
                var_ebbefa14[var_ebbefa14.size] = var_e349e3f;
            }
        }
        level waittill(#"hash_a126360f");
        foreach (var_2bfe2eca in var_ebbefa14) {
            zm_unitrigger::unregister_unitrigger(var_2bfe2eca.s_unitrigger);
            exploder::kill_exploder("lgt_EE_consol1_monitor_" + var_2bfe2eca.var_a95f1f56);
            exploder::kill_exploder("lgt_EE_consol2_monitor_" + var_2bfe2eca.var_a95f1f56);
        }
        function_2925fac8();
        var_d9768e8b = 1;
        for (i = 0; i < level.var_a44ebbe8.size; i++) {
            var_6aae6c38 = level.var_a44ebbe8[i] - 1;
            if (var_6aae6c38 != level.var_ab58bca7[i]) {
                var_d9768e8b = 0;
            }
        }
        if (var_d9768e8b && !level flag::get("switch_to_death_ray")) {
            foreach (slot in var_91d3caa4) {
                playsoundatposition("zmb_ee_simonsays_complete", slot.origin);
            }
            playsoundatposition("zmb_object_final_success", (0, 0, 0));
            level flag::set("dimension_set");
            level flag::set("ee_safe_open");
        } else {
            foreach (slot in var_91d3caa4) {
                playsoundatposition("zmb_ee_simonsays_nay", slot.origin);
            }
            playsoundatposition("zmb_object_fail", (0, 0, 0));
            function_3918d831("safe_code_present");
            level flag::clear("ee_fuse_placed");
        }
        level.var_cc2ea6e8 = undefined;
    }
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xa16a123a, Offset: 0x8d90
// Size: 0xc8
function function_3918d831(var_ff61ccd6) {
    var_4bff825e = getent(var_ff61ccd6, "targetname");
    for (i = 0; i < 3; i++) {
        for (j = 1; j <= 4; j++) {
            var_4bff825e hidepart("tag_scn" + i + "_sym" + j);
        }
    }
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xa00c8b42, Offset: 0x8e60
// Size: 0x508
function function_96ca12f5(var_2bfe2eca) {
    level endon(#"hash_a126360f");
    var_6589e15e = getent("symbols_lower_tower", "targetname");
    var_d665b72a = getent("symbols_launch_platform", "targetname");
    while (true) {
        var_2bfe2eca waittill(#"trigger_activated");
        playsoundatposition("zmb_ee_simonsays_button", var_2bfe2eca.origin);
        if (!level flag::get("simon_press_check")) {
            level flag::set("simon_press_check");
            var_6589e15e hidepart("tag_scn" + var_2bfe2eca.var_a95f1f56 + "_sym" + var_2bfe2eca.var_d82c7c68);
            var_d665b72a hidepart("tag_scn" + var_2bfe2eca.var_a95f1f56 + "_sym" + var_2bfe2eca.var_d82c7c68);
            exploder::kill_exploder("lgt_EE_consol1_monitor_" + var_2bfe2eca.var_a95f1f56);
            exploder::kill_exploder("lgt_EE_consol2_monitor_" + var_2bfe2eca.var_a95f1f56);
            var_6589e15e showpart("tag_scn0_sym" + var_2bfe2eca.var_d82c7c68);
            var_d665b72a showpart("tag_scn0_sym" + var_2bfe2eca.var_d82c7c68);
            exploder::exploder("lgt_EE_consol1_monitor_main");
            exploder::exploder("lgt_EE_consol2_monitor_main");
            var_4bff825e = getent("safe_code_present", "targetname");
            var_4bff825e showpart("tag_scn" + level.var_a44ebbe8.size + "_sym" + var_2bfe2eca.var_d82c7c68);
            wait(1);
            var_6589e15e showpart("tag_scn" + var_2bfe2eca.var_a95f1f56 + "_sym" + var_2bfe2eca.var_d82c7c68);
            var_d665b72a showpart("tag_scn" + var_2bfe2eca.var_a95f1f56 + "_sym" + var_2bfe2eca.var_d82c7c68);
            exploder::exploder("lgt_EE_consol1_monitor_" + var_2bfe2eca.var_a95f1f56);
            exploder::exploder("lgt_EE_consol2_monitor_" + var_2bfe2eca.var_a95f1f56);
            var_6589e15e hidepart("tag_scn0_sym" + var_2bfe2eca.var_d82c7c68);
            var_d665b72a hidepart("tag_scn0_sym" + var_2bfe2eca.var_d82c7c68);
            exploder::kill_exploder("lgt_EE_consol1_monitor_main");
            exploder::kill_exploder("lgt_EE_consol2_monitor_main");
            if (!isdefined(level.var_a44ebbe8)) {
                level.var_a44ebbe8 = [];
            } else if (!isarray(level.var_a44ebbe8)) {
                level.var_a44ebbe8 = array(level.var_a44ebbe8);
            }
            level.var_a44ebbe8[level.var_a44ebbe8.size] = var_2bfe2eca.var_d82c7c68;
            level flag::clear("simon_press_check");
            if (level.var_a44ebbe8.size == 3) {
                level notify(#"hash_a126360f");
                return;
            }
        }
        wait(0.15);
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x93e02523, Offset: 0x9370
// Size: 0x35c
function function_c21dcd15() {
    level flag::wait_till("ee_safe_open");
    var_f3f0fbd = [];
    var_726d0daa = struct::get_array("tesla_connector");
    foreach (var_47bafa4c in var_726d0daa) {
        var_bb46ee5a = util::spawn_model("p7_zm_ctl_deathray_base_part", var_47bafa4c.origin, var_47bafa4c.angles);
        if (!isdefined(var_f3f0fbd)) {
            var_f3f0fbd = [];
        } else if (!isarray(var_f3f0fbd)) {
            var_f3f0fbd = array(var_f3f0fbd);
        }
        var_f3f0fbd[var_f3f0fbd.size] = var_bb46ee5a;
    }
    var_176b8aac = struct::get("ee_gold_key");
    mdl_key = util::spawn_model("p7_zm_ctl_keycard_ee", var_176b8aac.origin, var_176b8aac.angles);
    mdl_key.targetname = "golden_key";
    mdl_key namespace_744abc1c::create_unitrigger();
    var_8cf273a9 = getent("safe_uc_dmg_door", "targetname");
    var_8cf273a9 rotateyaw(-135, 1);
    var_8cf273a9 playsound("zmb_safe_open");
    mdl_key waittill(#"trigger_activated");
    zm_unitrigger::unregister_unitrigger(mdl_key.s_unitrigger);
    mdl_key ghost();
    for (i = 0; i < var_f3f0fbd.size; i++) {
        var_f3f0fbd[i] delete();
    }
    level thread function_8d27746("launch_platform", 21);
    level thread function_8d27746("lower_tower", 11);
    level flag::set("ee_golden_key");
    namespace_97ddfc0d::function_6184b9c1();
}

// Namespace namespace_c93e4c32
// Params 2, eflags: 0x0
// Checksum 0x368ac576, Offset: 0x96d8
// Size: 0xf4
function function_8d27746(str_suffix, var_b1ac3ec5) {
    var_96a3d068 = struct::get("tc_" + str_suffix);
    var_96a3d068 namespace_744abc1c::create_unitrigger();
    var_96a3d068 waittill(#"trigger_activated");
    zm_unitrigger::unregister_unitrigger(var_96a3d068.s_unitrigger);
    util::spawn_model("p7_zm_ctl_deathray_base_part", var_96a3d068.origin, var_96a3d068.angles);
    exploder::exploder("fxexp_7" + var_b1ac3ec5);
    level flag::set("tesla_connector_" + str_suffix);
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x54a75f2d, Offset: 0x97d8
// Size: 0x11c
function function_82075ffb() {
    level flag::wait_till("time_travel_teleporter_ready");
    s_canister = struct::get("mpd_canister");
    var_bcaed8fa = util::spawn_model("p7_zm_ctl_undercroft_pyramid_canister", s_canister.origin, s_canister.angles);
    var_bcaed8fa namespace_744abc1c::create_unitrigger();
    var_bcaed8fa waittill(#"trigger_activated");
    var_bcaed8fa playsound("zmb_ee_mpd_broken_canister_pickup");
    zm_unitrigger::unregister_unitrigger(var_bcaed8fa.s_unitrigger);
    var_bcaed8fa delete();
    level flag::set("mpd_canister_replacement");
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x9f287f73, Offset: 0x9900
// Size: 0x7aa
function function_a4b7a410() {
    level flag::wait_till("start_channeling_stone_step");
    level flag::wait_till("boss_fight_completed");
    var_649d30e8 = struct::get("mpd_pos");
    var_293d02aa = util::spawn_model("p7_zm_ctl_undercroft_pyramid", var_649d30e8.origin, var_649d30e8.angles);
    var_293d02aa.targetname = "undercroft_pyramid";
    level scene::init("p7_fxanim_zm_castle_moon_rocket_front_bundle");
    s_summoning_key = struct::get("ee_mpd_summoning_key");
    s_summoning_key namespace_744abc1c::create_unitrigger();
    s_summoning_key fx::play("summoning_key_glow", s_summoning_key.origin, s_summoning_key.angles, "delete_fx", 0, undefined, 1);
    s_summoning_key waittill(#"trigger_activated");
    zm_unitrigger::unregister_unitrigger(s_summoning_key.s_unitrigger);
    level thread namespace_97ddfc0d::function_3ed74336();
    var_530ae70 = util::spawn_model("p7_zm_ctl_summoning_key_small", s_summoning_key.origin, s_summoning_key.angles);
    var_530ae70 setscale(1.5);
    level.var_758b41e = 1;
    foreach (player in level.players) {
        player thread function_ca73b878(var_530ae70.origin, "zone_undercroft");
    }
    playsoundatposition("evt_sum_key_place", var_530ae70.origin);
    wait(3);
    level.var_758b41e = undefined;
    s_summoning_key notify(#"hash_629fd78d");
    var_530ae70 fx::play("summoning_key_done", s_summoning_key.origin, s_summoning_key.angles, undefined, 0, undefined, 1);
    playsoundatposition("evt_sum_key_charged", s_summoning_key.origin);
    s_summoning_key namespace_744abc1c::create_unitrigger();
    s_summoning_key waittill(#"trigger_activated");
    zm_unitrigger::unregister_unitrigger(s_summoning_key.s_unitrigger);
    var_530ae70 notify(#"hash_629fd78d");
    var_530ae70 hide();
    playsoundatposition("evt_sum_key_take", var_530ae70.origin);
    s_summoning_key = struct::get("terminal_summoning_key");
    s_summoning_key namespace_744abc1c::create_unitrigger();
    s_summoning_key waittill(#"trigger_activated");
    zm_unitrigger::unregister_unitrigger(s_summoning_key.s_unitrigger);
    var_530ae70.origin = s_summoning_key.origin;
    var_530ae70 show();
    playsoundatposition("zmb_fuse_place", var_530ae70.origin);
    var_530ae70 fx::play("summoning_key_glow", var_530ae70.origin, var_530ae70.angles, "delete_fx", 0, undefined, 1);
    var_530ae70 fx::play("summoning_key_source", var_530ae70.origin, var_530ae70.angles, "delete_fx", 1, "tag_fx", 1);
    exploder::exploder("fxexp_620");
    function_f6678e99();
    level.var_513683a6 = undefined;
    exploder::stop_exploder("fxexp_620");
    var_530ae70 delete();
    exploder::stop_exploder("lgt_MPD_exp");
    exploder::stop_exploder("lgt_MPD_broken_exp");
    var_76c91f56 = getentarray("undercroft_pyramid", "targetname");
    foreach (var_293d02aa in var_76c91f56) {
        var_293d02aa connectpaths();
        var_293d02aa delete();
    }
    var_57615f80 = getentarray("pyramid", "targetname");
    foreach (var_27fd0c6f in var_57615f80) {
        var_54a70b81 = (var_27fd0c6f.origin[0], var_27fd0c6f.origin[1], var_27fd0c6f.origin[2] + 96);
        var_27fd0c6f moveto(var_54a70b81, 3);
        var_27fd0c6f thread function_ea0d3a5d();
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x8c6aa52f, Offset: 0xa0b8
// Size: 0x3c
function function_ea0d3a5d() {
    self waittill(#"movedone");
    self solid();
    self disconnectpaths();
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xaa5865b4, Offset: 0xa100
// Size: 0x1cc
function function_f6678e99() {
    level flag::set("sent_rockets_to_the_moon");
    /#
        level.var_844f510c = 1;
    #/
    if (level scene::is_playing("p7_fxanim_zm_castle_moon_rockets_bundle")) {
        level scene::stop("p7_fxanim_zm_castle_moon_rockets_bundle");
    }
    if (level scene::is_playing("p7_fxanim_zm_castle_moon_rockets_bck_bundle")) {
        level scene::stop("p7_fxanim_zm_castle_moon_rockets_bck_bundle");
    }
    pause_zombies(1);
    level thread namespace_97ddfc0d::function_f28fd307();
    array::run_all(level.players, &playrumbleonentity, "zm_castle_moon_rocket_launch");
    level thread scene::play("p7_fxanim_zm_castle_moon_rocket_front_bundle");
    level thread zm_audio::sndmusicsystem_playstate("moon_rockets");
    wait(1);
    scene::add_scene_func("p7_fxanim_zm_castle_moon_rockets_bundle", &function_6a8d41d1);
    level thread scene::play("p7_fxanim_zm_castle_moon_rockets_bundle");
    wait(5.5);
    level scene::play("p7_fxanim_zm_castle_moon_rockets_bck_bundle");
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x45b8704b, Offset: 0xa2d8
// Size: 0x104
function function_6a8d41d1(a_ents) {
    var_abd3814e = a_ents["moon_rocket_02"];
    var_abd3814e waittill(#"hash_c79f61d1");
    level thread function_6d74c298();
    exploder::exploder("fxexp_610");
    level scene::init("cin_cas_01_outro_3rd_sh010");
    wait(4);
    level clientfield::set("flip_skybox", 1);
    level function_339377d6();
    level flag::wait_till_timeout(17, "rockets_to_moon_vo_complete");
    level flag::set("ee_outro");
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x86887c33, Offset: 0xa3e8
// Size: 0x18a
function function_6d74c298(var_e0e0227e) {
    wait(3.5);
    array::run_all(level.players, &playrumbleonentity, "zm_castle_moon_explosion_rumble");
    setlightingstate(1);
    foreach (e_player in level.players) {
        e_player clientfield::set_to_player("moon_explosion_bank", 1);
    }
    wait(1);
    setlightingstate(0);
    foreach (e_player in level.players) {
        e_player clientfield::set_to_player("moon_explosion_bank", 0);
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xb4791d41, Offset: 0xa580
// Size: 0x92
function function_821a61ed() {
    foreach (e_player in level.activeplayers) {
        if (e_player.characterindex == 2) {
            return true;
        }
    }
    return false;
}

// Namespace namespace_c93e4c32
// Params 2, eflags: 0x0
// Checksum 0x2ac0cee3, Offset: 0xa620
// Size: 0x1c4
function function_ca73b878(var_6ec25e68, str_zone) {
    self endon(#"death");
    var_77b9bd02 = 0;
    while (isdefined(level.var_758b41e) && level.var_758b41e) {
        str_player_zone = self zm_zonemgr::get_player_zone();
        if (zm_utility::is_player_valid(self) && str_player_zone === str_zone) {
            if (!(isdefined(var_77b9bd02) && var_77b9bd02) && distance2dsquared(var_6ec25e68, self.origin) <= 15129) {
                self clientfield::set_to_player("gravity_trap_rumble", 1);
                var_77b9bd02 = 1;
            } else if (isdefined(var_77b9bd02) && var_77b9bd02 && distance2dsquared(var_6ec25e68, self.origin) > 15129) {
                self clientfield::set_to_player("gravity_trap_rumble", 0);
                var_77b9bd02 = 0;
            }
        } else if (isdefined(var_77b9bd02) && var_77b9bd02) {
            self clientfield::set_to_player("gravity_trap_rumble", 0);
            var_77b9bd02 = 0;
        }
        wait(0.15);
    }
    self clientfield::set_to_player("gravity_trap_rumble", 0);
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0xc145fc79, Offset: 0xa7f0
// Size: 0x324
function function_f200c253() {
    level flag::wait_till("ee_outro");
    level.var_99cccf77 = 1;
    var_6f038754 = struct::get("tag_align_outro", "targetname");
    level namespace_97ddfc0d::function_8ac5430(1, var_6f038754.origin);
    /#
        level pause_zombies(1, 0);
    #/
    namespace_97ddfc0d::function_218256bd(1);
    var_d7e14379 = level function_58db5243(0);
    callback::remove_on_connect(&function_d4be5c9f);
    scene::add_scene_func("cin_cas_01_outro_3rd_sh010", &function_a029a5f1);
    scene::add_scene_func("cin_cas_01_outro_3rd_sh195", &function_3c1114e8);
    level scene::play("cin_cas_01_outro_3rd_sh010");
    level waittill(#"hash_8478520");
    level thread function_605386ad(0);
    pause_zombies(0);
    namespace_97ddfc0d::function_218256bd(0);
    level namespace_97ddfc0d::function_8ac5430();
    if (var_d7e14379) {
        level function_58db5243(1);
    }
    level notify(#"hash_b39ccbbf");
    players = getplayers();
    foreach (player in players) {
        scoreevents::processscoreevent("main_EE_quest_castle", player);
        player zm_stats::increment_global_stat("DARKOPS_CASTLE_EE");
        player zm_stats::increment_global_stat("DARKOPS_CASTLE_SUPER_EE");
    }
    level.var_99cccf77 = 0;
    array::thread_all(level.activeplayers, &zm_utility::function_82a5cc4);
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x66394900, Offset: 0xab20
// Size: 0x1b4
function function_339377d6() {
    /#
        if (isdefined(level.var_9a9741a5) && level.var_9a9741a5) {
            return;
        }
        level.var_9a9741a5 = 1;
    #/
    mdl_prop = util::spawn_model("wpn_t7_pistol_mr6_prop", (600, 600, -170));
    mdl_prop.targetname = "mr6_demp_left";
    mdl_prop = util::spawn_model("wpn_t7_pistol_mr6_prop", (600, 600, -170));
    mdl_prop.targetname = "mr6_demp_right";
    mdl_prop = util::spawn_model("wpn_t7_pistol_mr6_prop", (600, 600, -170));
    mdl_prop.targetname = "mr6_richtofen";
    mdl_prop = util::spawn_model("wpn_t7_pistol_mr6_prop", (600, 600, -170));
    mdl_prop.targetname = "mr6_takeo";
    mdl_prop = util::spawn_model("wpn_t7_shotgun_spartan_prop", (600, 600, -170));
    mdl_prop.targetname = "spartan";
    mdl_prop = util::spawn_model("p7_zm_ctl_summoning_key_small", (600, 600, -170));
    mdl_prop.targetname = "key";
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x37ac1863, Offset: 0xace0
// Size: 0x5c
function function_a029a5f1(a_ents) {
    function_a624c051(a_ents);
    level function_605386ad(1);
    wait(0.1);
    level thread function_36bef27a();
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xacb9b5cb, Offset: 0xad48
// Size: 0x44
function function_a624c051(a_ents) {
    mdl_pod = a_ents["pod"];
    mdl_pod clientfield::set("pod_monitor_enable", 1);
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xd5e94308, Offset: 0xad98
// Size: 0x44
function function_3c1114e8(a_ents) {
    mdl_pod = a_ents["pod"];
    mdl_pod clientfield::set("pod_monitor_enable", 0);
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x571f6097, Offset: 0xade8
// Size: 0x132
function function_605386ad(var_1e73529b) {
    if (var_1e73529b) {
        foreach (e_player in level.players) {
            e_player clientfield::set_to_player("outro_lighting_banks", 1);
        }
        return;
    }
    foreach (e_player in level.players) {
        e_player clientfield::set_to_player("outro_lighting_banks", 0);
    }
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x98ebe603, Offset: 0xaf28
// Size: 0x10e
function function_58db5243(b_show) {
    foreach (s_chest in level.chests) {
        if (s_chest.script_noteworthy == "courtyard_chest") {
            if (!b_show && s_chest.hidden === 0) {
                s_chest zm_magicbox::hide_chest();
                return 1;
            } else if (b_show && s_chest.hidden == 1) {
                s_chest zm_magicbox::show_chest();
            }
            return 0;
        }
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x17292107, Offset: 0xb040
// Size: 0x102
function function_36bef27a() {
    foreach (e_player in level.players) {
        str_position = "ee_outro_end_position_" + e_player.characterindex;
        s_spawn = struct::get(str_position, "targetname");
        e_player setorigin(s_spawn.origin);
        e_player setplayerangles(s_spawn.angles);
    }
}

// Namespace namespace_c93e4c32
// Params 2, eflags: 0x0
// Checksum 0xcce7c621, Offset: 0xb150
// Size: 0xb4
function pause_zombies(b_pause, var_9d3d4d3f) {
    if (!isdefined(b_pause)) {
        b_pause = 0;
    }
    if (!isdefined(var_9d3d4d3f)) {
        var_9d3d4d3f = 1;
    }
    if (b_pause) {
        level.disable_nuke_delay_spawning = 1;
        level flag::clear("spawn_zombies");
        function_5db6ba34(var_9d3d4d3f);
        return;
    }
    level.disable_nuke_delay_spawning = 0;
    level flag::set("spawn_zombies");
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xbf3a67d0, Offset: 0xb210
// Size: 0x554
function function_5db6ba34(var_1a60ad71) {
    if (!isdefined(var_1a60ad71)) {
        var_1a60ad71 = 1;
    }
    if (var_1a60ad71) {
        level thread lui::screen_flash(0.2, 0.5, 1, 0.8, "white");
    }
    wait(0.5);
    a_ai_zombies = getaiteamarray(level.zombie_team);
    var_6b1085eb = [];
    foreach (ai_zombie in a_ai_zombies) {
        ai_zombie.no_powerups = 1;
        ai_zombie.deathpoints_already_given = 1;
        if (isdefined(ai_zombie.ignore_nuke) && ai_zombie.ignore_nuke) {
            continue;
        }
        if (isdefined(ai_zombie.marked_for_death) && ai_zombie.marked_for_death) {
            continue;
        }
        if (isdefined(ai_zombie.nuke_damage_func)) {
            ai_zombie thread [[ ai_zombie.nuke_damage_func ]]();
            continue;
        }
        if (zm_utility::is_magic_bullet_shield_enabled(ai_zombie)) {
            continue;
        }
        ai_zombie.marked_for_death = 1;
        ai_zombie.nuked = 1;
        var_6b1085eb[var_6b1085eb.size] = ai_zombie;
    }
    foreach (i, var_f92b3d80 in var_6b1085eb) {
        wait(randomfloatrange(0.1, 0.2));
        if (!isdefined(var_f92b3d80)) {
            continue;
        }
        if (zm_utility::is_magic_bullet_shield_enabled(var_f92b3d80)) {
            continue;
        }
        if (i < 5 && !(isdefined(var_f92b3d80.isdog) && var_f92b3d80.isdog)) {
            var_f92b3d80 thread zombie_death::flame_death_fx();
        }
        if (!(isdefined(var_f92b3d80.isdog) && var_f92b3d80.isdog)) {
            if (!(isdefined(var_f92b3d80.no_gib) && var_f92b3d80.no_gib)) {
                var_f92b3d80 zombie_utility::zombie_head_gib();
            }
        }
        var_f92b3d80 dodamage(var_f92b3d80.health, var_f92b3d80.origin);
        if (!level flag::get("special_round")) {
            level.zombie_total++;
        }
    }
    var_6cbdc65 = [];
    var_c94c86a8 = getentarray("mechz", "targetname");
    foreach (var_99c3dd59 in var_c94c86a8) {
        var_63b71acf = 0;
        if (isdefined(var_99c3dd59.no_damage_points) && var_99c3dd59.no_damage_points) {
            var_63b71acf = 1;
        }
        if (!isdefined(var_6cbdc65)) {
            var_6cbdc65 = [];
        } else if (!isarray(var_6cbdc65)) {
            var_6cbdc65 = array(var_6cbdc65);
        }
        var_6cbdc65[var_6cbdc65.size] = var_63b71acf;
        var_99c3dd59.no_powerups = 1;
        var_99c3dd59 kill();
    }
    level thread function_3fade785(var_6cbdc65);
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xfcc7c465, Offset: 0xb770
// Size: 0x182
function function_3fade785(var_6cbdc65) {
    level flag::wait_till("spawn_zombies");
    for (i = 0; i < var_6cbdc65.size; i++) {
        for (e_target = array::random(level.players); !zm_utility::is_player_valid(e_target); e_target = array::random(level.players)) {
            wait(0.05);
        }
        s_spawn_pos = arraygetclosest(e_target.origin, level.zm_loc_types["mechz_location"]);
        if (isdefined(s_spawn_pos)) {
            var_99c3dd59 = namespace_48131a3f::function_314d744b(0, s_spawn_pos, 1);
            if (isdefined(var_6cbdc65[i]) && var_6cbdc65[i]) {
                var_99c3dd59.no_damage_points = 1;
                var_99c3dd59.deathpoints_already_given = 1;
                var_99c3dd59.exclude_cleanup_adding_to_total = 1;
            }
        }
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x2eee209c, Offset: 0xb900
// Size: 0x156
function function_af71af0e() {
    if (!isdefined(level.var_1f18338d)) {
        return;
    }
    if (isdefined(self.var_1ceefee5) && self.var_1ceefee5) {
        return;
    }
    self.var_1ceefee5 = 1;
    switch (level.var_1f18338d) {
    case 111:
        self clientfield::set_to_player("player_ee_cs_circle", 1);
        break;
    case 112:
        self clientfield::set_to_player("player_ee_cs_circle", 2);
        break;
    case 109:
        self clientfield::set_to_player("player_ee_cs_circle", 3);
        break;
    case 113:
        self clientfield::set_to_player("player_ee_cs_circle", 4);
        break;
    }
    while (isdefined(self.var_507ad4a9) && self.var_507ad4a9) {
        wait(0.1);
    }
    self clientfield::set_to_player("player_ee_cs_circle", 0);
    self.var_1ceefee5 = undefined;
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0x6d8da07a, Offset: 0xba60
// Size: 0x2ba
function function_fb090902(var_f3afc16d) {
    level notify(#"hash_dbc0b10c");
    level endon(#"hash_dbc0b10c");
    level.var_cc2ea6e8 = 1;
    var_fe586166 = 0;
    while (isdefined(level.var_cc2ea6e8) && level.var_cc2ea6e8) {
        if (function_dd1b044(var_f3afc16d)) {
            var_565450eb = zombie_utility::get_current_zombie_count();
            var_fe586166 = function_36c5b9b9();
            var_c33cc7f2 = 8;
            if (level flag::get("solo_game")) {
                var_c33cc7f2 = 3;
            }
            if (var_fe586166 <= var_c33cc7f2 && var_fe586166 + var_565450eb < level.zombie_vars["zombie_max_ai"]) {
                var_19764360 = namespace_cc5bac97::get_favorite_enemy();
                s_spawn_pos = namespace_2545f7c9::function_92e4eaff(level.dog_spawners[0], var_19764360);
                if (isdefined(s_spawn_pos)) {
                    ai_dog = zombie_utility::spawn_zombie(level.dog_spawners[0]);
                    if (isdefined(ai_dog)) {
                        ai_dog.favoriteenemy = var_19764360;
                        ai_dog.ignore_enemy_count = 1;
                        ai_dog.no_damage_points = 1;
                        ai_dog.deathpoints_already_given = 1;
                        ai_dog.exclude_cleanup_adding_to_total = 1;
                        s_spawn_pos thread namespace_cc5bac97::dog_spawn_fx(ai_dog, s_spawn_pos);
                        level flag::set("dog_clips");
                        ai_dog.no_powerups = 1;
                        ai_dog thread function_e5803575();
                    }
                }
            }
        }
        n_wait = 3;
        if (level flag::get("solo_game")) {
            n_wait = 9;
        }
        wait(n_wait);
    }
}

// Namespace namespace_c93e4c32
// Params 1, eflags: 0x0
// Checksum 0xe51a09b7, Offset: 0xbd28
// Size: 0x62
function function_dd1b044(var_f3afc16d) {
    var_d695363e = 1;
    if (isdefined(var_f3afc16d) && var_f3afc16d && level flag::get("solo_game")) {
        var_d695363e = 0;
    }
    return var_d695363e;
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x76b0b9b3, Offset: 0xbd98
// Size: 0x36
function function_36c5b9b9() {
    var_1cea043e = getentarray("zombie_dog", "targetname");
    return var_1cea043e.size;
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x88667b42, Offset: 0xbdd8
// Size: 0xaa
function function_e5803575() {
    self endon(#"death");
    v_start_pos = self.origin;
    for (var_20a609dc = 0; true; var_20a609dc++) {
        wait(5);
        if (v_start_pos === self.origin) {
            if (var_20a609dc >= 2) {
                self kill();
            }
            self.favoriteenemy = namespace_cc5bac97::get_favorite_enemy();
            v_start_pos = self.origin;
        }
    }
}

// Namespace namespace_c93e4c32
// Params 0, eflags: 0x0
// Checksum 0x31b4a817, Offset: 0xbe90
// Size: 0x17c
function function_88e260d() {
    level waittill(#"hash_d8b279ab");
    s_spawn_pos = arraygetclosest(self.origin, level.zm_loc_types["mechz_location"]);
    if (!isdefined(s_spawn_pos)) {
        var_79ed5347 = struct::get_array("mechz_location", "script_noteworthy");
        foreach (var_6000fab5 in var_79ed5347) {
            if (var_6000fab5.targetname == "zone_start_spawners") {
                s_spawn_pos = var_6000fab5;
            }
        }
    }
    var_99c3dd59 = namespace_48131a3f::function_314d744b(0, s_spawn_pos, 1);
    var_99c3dd59.no_damage_points = 1;
    var_99c3dd59.deathpoints_already_given = 1;
    var_99c3dd59.exclude_cleanup_adding_to_total = 1;
}

/#

    // Namespace namespace_c93e4c32
    // Params 0, eflags: 0x0
    // Checksum 0xeaea441, Offset: 0xc018
    // Size: 0x42c
    function function_d6026710() {
        level flag::init("elemental_bow_demongate");
        setdvar("keeper_archon", 0);
        setdvar("run", 0);
        setdvar("cs_keeper_pos_", 0);
        level thread namespace_744abc1c::function_72260d3a("j_mainroot", "fxexp_698", 1, &function_690690ef);
        level thread namespace_744abc1c::function_72260d3a("zmb_ee_simonsays_insertcard", "ee_lab_fuse", 1, &function_b1c42655);
        level thread namespace_744abc1c::function_72260d3a("lgt_EE_consol2_monitor_", "tag_fx", 1, &function_dc5045eb);
        level thread namespace_744abc1c::function_72260d3a("DARKOPS_CASTLE_EE", "<unknown string>", 1, &function_c197b24a);
        level thread namespace_744abc1c::function_72260d3a("<unknown string>", "<unknown string>", 1, &function_3c8db42b);
        level thread namespace_744abc1c::function_72260d3a("<unknown string>", "<unknown string>", 1, &function_64783c5e);
        level thread namespace_744abc1c::function_72260d3a("<unknown string>", "<unknown string>", 1, &function_a1ac1452);
        level thread namespace_744abc1c::function_72260d3a("<unknown string>", "<unknown string>", 1, &function_bbf6c2d0);
        level thread namespace_744abc1c::function_72260d3a("<unknown string>", "<unknown string>", 1, &function_a9a41cbd);
        adddebugcommand("<unknown string>");
        adddebugcommand("<unknown string>");
        adddebugcommand("<unknown string>");
        adddebugcommand("<unknown string>");
        adddebugcommand("<unknown string>");
        adddebugcommand("<unknown string>");
        adddebugcommand("<unknown string>");
        level thread function_72260d3a("<unknown string>", "<unknown string>", 1, &function_71b77de5);
        level thread function_72260d3a("<unknown string>", "<unknown string>", 1, &function_d6a136ff);
        level thread function_72260d3a("<unknown string>", "<unknown string>", 1, &function_f62f3c89);
        adddebugcommand("<unknown string>");
        adddebugcommand("<unknown string>");
        level thread function_ef5eaa6e();
        level thread function_dd0c3214();
        level thread function_b38b0751();
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0x4e4ff8ed, Offset: 0xc450
    // Size: 0xba
    function function_690690ef(n_val) {
        level endon(#"hash_a8200e36");
        if (!level flag::get("<unknown string>")) {
            level thread function_61036bd1();
        }
        zm_zonemgr::enable_zone("<unknown string>");
        level flag::set("<unknown string>");
        level waittill(#"start_of_round");
        level flag::clear("<unknown string>");
        level notify(#"hash_a8200e36");
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0xccd5333, Offset: 0xc518
    // Size: 0x24
    function function_a9a41cbd(n_val) {
        namespace_97ddfc0d::function_70721c81();
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0x36f4cb9d, Offset: 0xc548
    // Size: 0x24
    function function_d6a136ff(n_val) {
        namespace_97ddfc0d::function_44c11f63();
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0xe549dfa3, Offset: 0xc578
    // Size: 0x2c
    function function_b1c42655(n_val) {
        level flag::set("ee_lab_fuse");
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0xb85839ce, Offset: 0xc5b0
    // Size: 0x84
    function function_dc5045eb(n_val) {
        level scene::stop("<unknown string>");
        s_scriptbundle = struct::get("<unknown string>", "<unknown string>");
        s_scriptbundle.scene_played = 0;
        level thread scene::play("<unknown string>");
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0x546db962, Offset: 0xc640
    // Size: 0x2c
    function function_c197b24a(n_val) {
        level flag::set("<unknown string>");
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0x8ca594f7, Offset: 0xc678
    // Size: 0xea
    function function_3c8db42b(n_val) {
        players = level.activeplayers;
        foreach (player in players) {
            b_on = player clientfield::get_to_player("<unknown string>");
            b_on = !b_on;
            player clientfield::set_to_player("<unknown string>", b_on);
        }
    }

    // Namespace namespace_c93e4c32
    // Params 0, eflags: 0x0
    // Checksum 0x7fe5ee, Offset: 0xc770
    // Size: 0x178
    function function_ef5eaa6e() {
        level waittill(#"start_zombie_round_logic");
        var_1bdfdb3b = array("<unknown string>", "<unknown string>", "<unknown string>", "<unknown string>");
        level flag::wait_till_any(var_1bdfdb3b);
        while (true) {
            if (getdvarint("keeper_archon") == 1 && isdefined(level.var_a0ef3c5e) && level.var_a0ef3c5e.var_ebeea021) {
                if (!level flag::get("elemental_bow_demongate")) {
                    level flag::set("elemental_bow_demongate");
                }
                print3d(level.var_a0ef3c5e.origin, "<unknown string>", (0, 255, 0), 1, 3);
            } else if (level flag::get("elemental_bow_demongate")) {
                level flag::clear("elemental_bow_demongate");
            }
            wait(0.15);
        }
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0x697c9d02, Offset: 0xc8f0
    // Size: 0x7c
    function function_64783c5e(n_val) {
        level flag::set("<unknown string>");
        wait(0.15);
        level.var_521b0bd1 = 9;
        level notify(#"hash_b7f06cd9");
        level.var_e3162591 = 1;
        level flag::set("<unknown string>");
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0x86a4640e, Offset: 0xc978
    // Size: 0x24
    function function_71b77de5(n_val) {
        function_7d8964c9();
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0x1af791c2, Offset: 0xc9a8
    // Size: 0x24
    function function_a1ac1452(n_val) {
        function_f6678e99();
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0x460d5b46, Offset: 0xc9d8
    // Size: 0x44
    function function_f62f3c89(n_val) {
        level thread function_bd20fe8();
        level flag::set("<unknown string>");
    }

    // Namespace namespace_c93e4c32
    // Params 0, eflags: 0x0
    // Checksum 0xb85c191e, Offset: 0xca28
    // Size: 0x40
    function function_dd0c3214() {
        while (true) {
            level.var_b5231dfb = getdvarint("run");
            wait(0.15);
        }
    }

    // Namespace namespace_c93e4c32
    // Params 0, eflags: 0x0
    // Checksum 0xa3649fc3, Offset: 0xca70
    // Size: 0xf8
    function function_b38b0751() {
        while (true) {
            if (getdvarint("cs_keeper_pos_") == 1) {
                setdvar("cs_keeper_pos_", 0);
                var_747532f4 = getent("<unknown string>", "<unknown string>");
                var_747532f4 notify(#"hash_22a2d66");
                var_747532f4 notify(#"hash_72e982f4");
                str_exploder = function_ac7d9299();
                exploder::kill_exploder(str_exploder);
                level flag::set("<unknown string>");
            }
            wait(0.15);
        }
    }

    // Namespace namespace_c93e4c32
    // Params 1, eflags: 0x0
    // Checksum 0x46c5aa05, Offset: 0xcb70
    // Size: 0x14c
    function function_bbf6c2d0(n_val) {
        if (!(isdefined(level.var_844f510c) && level.var_844f510c)) {
            level function_339377d6();
        }
        if (!level scene::is_playing("<unknown string>")) {
            level thread scene::play("<unknown string>");
        }
        var_c4556169 = getent("<unknown string>", "<unknown string>");
        var_c4556169 show();
        var_e7d455cc = getent("<unknown string>", "<unknown string>");
        if (isdefined(var_e7d455cc)) {
            var_e7d455cc delete();
        }
        level scene::init("<unknown string>");
        wait(3);
        level flag::set("<unknown string>");
    }

    // Namespace namespace_c93e4c32
    // Params 5, eflags: 0x0
    // Checksum 0x2b4eec46, Offset: 0xccc8
    // Size: 0x120
    function function_72260d3a(var_2fa24527, str_dvar, n_value, func, var_f0ee45c9) {
        if (!isdefined(var_f0ee45c9)) {
            var_f0ee45c9 = -1;
        }
        setdvar(str_dvar, var_f0ee45c9);
        adddebugcommand("<unknown string>" + var_2fa24527 + "<unknown string>" + str_dvar + "<unknown string>" + n_value + "<unknown string>");
        while (true) {
            var_608d58e3 = getdvarint(str_dvar);
            if (var_608d58e3 > var_f0ee45c9) {
                [[ func ]](var_608d58e3);
                setdvar(str_dvar, var_f0ee45c9);
            }
            util::wait_network_frame();
        }
    }

#/
