#using scripts/codescripts/struct;
#using scripts/shared/aat_shared;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/system_shared;
#using scripts/shared/trigger_shared;
#using scripts/shared/util_shared;
#using scripts/shared/visionset_mgr_shared;
#using scripts/zm/_util;
#using scripts/zm/_zm;
#using scripts/zm/_zm_ai_spiders;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_net;
#using scripts/zm/_zm_powerups;
#using scripts/zm/_zm_score;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_stats;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_zonemgr;

#namespace zm_island_spiders;

// Namespace zm_island_spiders
// Params 0, eflags: 0x0
// Checksum 0xf7cca825, Offset: 0x3e0
// Size: 0x3c
function function_8e89793a() {
    level.var_ab7eb3d4 = 0;
    level.var_c102a998 = &function_c102a998;
    level thread function_419bf2ad();
}

// Namespace zm_island_spiders
// Params 0, eflags: 0x0
// Checksum 0x89bdfc37, Offset: 0x428
// Size: 0x17a
function function_c102a998() {
    wait 6;
    level flag::clear("spider_round_in_progress");
    foreach (player in level.players) {
        if (player isplayerunderwater()) {
            var_f97c401 = player zm_utility::get_current_zone();
            if (isdefined(var_f97c401)) {
                if (var_f97c401 == "zone_start_water" || var_f97c401 == "zone_meteor_site" || var_f97c401 == "zone_meteor_site_2") {
                    player clientfield::set_to_player("set_world_fog", 1);
                } else {
                    player clientfield::set_to_player("set_world_fog", 2);
                }
            }
            continue;
        }
        player clientfield::increment_to_player("spider_end_of_round_reset", 1);
    }
}

// Namespace zm_island_spiders
// Params 0, eflags: 0x0
// Checksum 0x89677d46, Offset: 0x5b0
// Size: 0x398
function function_33aa4940() {
    var_7ac5425b = 0;
    var_622d2c20 = 0;
    if (level.round_number > 35) {
        if (randomfloat(100) < 10) {
            var_7ac5425b = 1;
        }
    } else if (level.round_number > 30) {
        if (randomfloat(100) < 8) {
            var_7ac5425b = 1;
        }
    } else if (level.round_number > 25) {
        if (randomfloat(100) < 7) {
            var_7ac5425b = 1;
        }
    } else if (level.round_number > 20) {
        if (randomfloat(100) < 5) {
            var_7ac5425b = 1;
        }
    }
    if (level.round_number > level.var_5ccd3661 && level.round_number > 7) {
        if ((zm_zonemgr::any_player_in_zone("zone_jungle_lab") || zm_zonemgr::any_player_in_zone("zone_jungle_lab_upper")) && (zm_zonemgr::any_player_in_zone("zone_spider_lair") || level.var_90e478e7)) {
            if (randomfloat(100) < 30 && level.var_ab7eb3d4 < 3) {
                var_7ac5425b = 1;
                var_622d2c20 = 1;
            }
        }
    }
    if (var_7ac5425b) {
        if (var_622d2c20) {
            var_a5f01313 = struct::get_array("zone_spider_lair_spawners", "targetname");
            var_901f5ace = [];
            foreach (s_spawner in var_a5f01313) {
                if (s_spawner.script_noteworthy == "spider_location") {
                    if (!isdefined(var_901f5ace)) {
                        var_901f5ace = [];
                    } else if (!isarray(var_901f5ace)) {
                        var_901f5ace = array(var_901f5ace);
                    }
                    var_901f5ace[var_901f5ace.size] = s_spawner;
                }
            }
            zm_ai_spiders::function_f4bd92a2(1, array::random(var_901f5ace));
            level.var_ab7eb3d4++;
        } else {
            zm_ai_spiders::function_f4bd92a2(1);
        }
        level.zombie_total--;
    }
    return var_7ac5425b;
}

// Namespace zm_island_spiders
// Params 0, eflags: 0x0
// Checksum 0xbc786d21, Offset: 0x950
// Size: 0x34
function function_419bf2ad() {
    level endon(#"end_game");
    while (true) {
        level waittill(#"between_round_over");
        level.var_ab7eb3d4 = 0;
    }
}

