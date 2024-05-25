#using scripts/zm/bgbs/_zm_bgb_anywhere_but_here;
#using scripts/zm/_zm_zonemgr;
#using scripts/zm/_zm_weapons;
#using scripts/zm/_zm_unitrigger;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_pack_a_punch_util;
#using scripts/zm/_zm_magicbox;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm;
#using scripts/zm/_load;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/util_shared;
#using scripts/shared/system_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/laststand_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/array_shared;
#using scripts/codescripts/struct;

#namespace namespace_f694d9ca;

// Namespace namespace_f694d9ca
// Params 0, eflags: 0x1 linked
// Checksum 0xc3fd3aaf, Offset: 0x3a8
// Size: 0x34
function init() {
    level.var_2c12d9a6 = &function_fa778ca4;
    level.var_2d0e5eb6 = &function_2d0e5eb6;
}

// Namespace namespace_f694d9ca
// Params 0, eflags: 0x1 linked
// Checksum 0x19c8ce9d, Offset: 0x3e8
// Size: 0x144
function function_fa778ca4() {
    str_player_zone = self zm_zonemgr::get_player_zone();
    if (str_player_zone == "zone_bunker_prison" && !level flag::get("flag_outro_cutscene_done")) {
        var_14452bdb = struct::get_array("zone_bunker_prison_player_respawns", "targetname");
        s_respawn_point = array::random(var_14452bdb);
    } else if (str_player_zone == "zone_bunker_prison_entrance" && !level flag::get("flag_outro_cutscene_done")) {
        var_14452bdb = struct::get_array("zone_bunker_prison_entrance_player_respawns", "targetname");
        s_respawn_point = array::random(var_14452bdb);
    } else {
        s_respawn_point = self zm_bgb_anywhere_but_here::function_728dfe3();
    }
    return s_respawn_point;
}

// Namespace namespace_f694d9ca
// Params 0, eflags: 0x1 linked
// Checksum 0xd2510803, Offset: 0x538
// Size: 0x1d4
function function_2d0e5eb6() {
    var_cdb0f86b = getarraykeys(level.zombie_powerups);
    var_b4442b55 = array("shield_charge", "ww_grenade", "bonus_points_team");
    var_62e2eaf2 = [];
    for (i = 0; i < var_cdb0f86b.size; i++) {
        var_77917a61 = 0;
        foreach (var_68de493a in var_b4442b55) {
            if (var_cdb0f86b[i] == var_68de493a) {
                var_77917a61 = 1;
                break;
            }
        }
        if (var_77917a61) {
            continue;
        }
        if (!isdefined(var_62e2eaf2)) {
            var_62e2eaf2 = [];
        } else if (!isarray(var_62e2eaf2)) {
            var_62e2eaf2 = array(var_62e2eaf2);
        }
        var_62e2eaf2[var_62e2eaf2.size] = var_cdb0f86b[i];
    }
    str_powerup = array::random(var_62e2eaf2);
    return str_powerup;
}

