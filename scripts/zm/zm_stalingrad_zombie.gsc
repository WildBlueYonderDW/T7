#using scripts/zm/_zm;
#using scripts/zm/_zm_zonemgr;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_elemental_zombies;
#using scripts/zm/_zm_behavior;
#using scripts/zm/_zm_ai_sentinel_drone;
#using scripts/zm/_zm_ai_raz;
#using scripts/shared/vehicles/_sentinel_drone;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/ai/zombie;
#using scripts/shared/ai/systems/behavior_tree_utility;
#using scripts/shared/ai/systems/animation_state_machine_mocomp;
#using scripts/shared/ai/systems/animation_state_machine_notetracks;
#using scripts/shared/ai/systems/animation_state_machine_utility;
#using scripts/shared/spawner_shared;
#using scripts/shared/util_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/array_shared;
#using scripts/shared/ai_shared;
#using scripts/codescripts/struct;

#namespace namespace_eec93adf;

// Namespace namespace_eec93adf
// Params 0, eflags: 0x2
// Checksum 0x9e3cb516, Offset: 0x508
// Size: 0x1b4
function autoexec init() {
    function_88f50e30();
    level.zombie_init_done = &function_ffa96b23;
    setdvar("scr_zm_use_code_enemy_selection", 0);
    level.closest_player_override = &function_285fbe6e;
    level.closest_player_targets_override = &function_6d4522d4;
    level.var_f7c913a = &function_5915f3d5;
    level.var_1ace2307 = 2;
    level thread function_72e6c1d6();
    level thread function_cec23cbf();
    level thread function_9b4d9341();
    spawner::add_archetype_spawn_function("zombie", &function_7854f310);
    spawner::add_archetype_spawn_function("sentinel_drone", &function_b10a912a);
    spawner::add_archetype_spawn_function("raz", &function_ec1b37df);
    level.var_dc87592f = 0;
    level.var_44d3a45c = struct::get("sentinel_back_door_goto", "targetname");
    level.var_ca793258 = struct::get("sentinel_back_door_teleport", "targetname");
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x4
// Checksum 0xad484c45, Offset: 0x6c8
// Size: 0x2c
function private function_88f50e30() {
    behaviortreenetworkutility::registerbehaviortreescriptapi("ZmStalingradAttackableObjectService", &function_972af829);
}

// Namespace namespace_eec93adf
// Params 1, eflags: 0x4
// Checksum 0x71e31e69, Offset: 0x700
// Size: 0x7c
function private function_972af829(entity) {
    if (!(isdefined(entity.completed_emerging_into_playable_area) && entity.completed_emerging_into_playable_area)) {
        if (!(isdefined(entity.var_9d6ece1a) && entity.var_9d6ece1a)) {
            entity.attackable = undefined;
            return 0;
        }
    }
    zm_behavior::zombieattackableobjectservice(entity);
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x4
// Checksum 0xee1007e9, Offset: 0x788
// Size: 0x60
function private function_7854f310() {
    self ai::set_behavior_attribute("use_attackable", 1);
    self.cant_move_cb = &function_c2866c1b;
    self thread function_72fad482();
    self.attackable_goal_radius = 8;
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x4
// Checksum 0x4d53d231, Offset: 0x7f0
// Size: 0x80
function private function_72fad482() {
    self endon(#"death");
    while (true) {
        if (isdefined(self.zone_name)) {
            if (self.zone_name == "pavlovs_A_zone" || self.zone_name == "pavlovs_B_zone") {
                self.var_edfdda83 = 1;
                return;
            }
        }
        wait(randomfloatrange(0.25, 0.5));
    }
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x4
// Checksum 0x8e6d37aa, Offset: 0x878
// Size: 0x5c
function private function_c2866c1b() {
    if (isdefined(self.attackable)) {
        if (isdefined(self.attackable.is_active) && self.attackable.is_active) {
            self function_1762804b(0);
            self.enablepushtime = gettime() + 1000;
        }
    }
}

// Namespace namespace_eec93adf
// Params 1, eflags: 0x4
// Checksum 0x53f365f, Offset: 0x8e0
// Size: 0x12a
function private function_a796c73f(player) {
    var_c3cc60d3 = 0;
    var_4d53d2ae = 0;
    if (isdefined(player.zone_name)) {
        if (player.zone_name == "pavlovs_A_zone" || player.zone_name == "pavlovs_B_zone" || player.zone_name == "pavlovs_C_zone") {
            var_c3cc60d3 = 1;
        }
    }
    if (isdefined(self.zone_name)) {
        if (self.zone_name == "pavlovs_A_zone" || self.zone_name == "pavlovs_B_zone" || self.zone_name == "pavlovs_C_zone") {
            var_4d53d2ae = 1;
        }
    }
    if (isdefined(self.var_edfdda83) && self.var_edfdda83) {
        var_4d53d2ae = 1;
    }
    if (var_c3cc60d3 != var_4d53d2ae) {
        return false;
    }
    return true;
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x0
// Checksum 0x62aaa2b3, Offset: 0xa18
// Size: 0x1c
function function_ffa96b23() {
    self function_1762804b(0);
}

// Namespace namespace_eec93adf
// Params 1, eflags: 0x4
// Checksum 0x83dd9480, Offset: 0xa40
// Size: 0xee
function private function_a0740c5a(players) {
    if (isdefined(self.last_closest_player.am_i_valid) && isdefined(self.last_closest_player) && self.last_closest_player.am_i_valid) {
        return;
    }
    self.need_closest_player = 1;
    foreach (player in players) {
        if (self function_a796c73f(player)) {
            self.last_closest_player = player;
            return;
        }
    }
    self.last_closest_player = undefined;
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x4
// Checksum 0x653dd38b, Offset: 0xb38
// Size: 0x8a
function private function_6d4522d4() {
    targets = getplayers();
    for (i = 0; i < targets.size; i++) {
        if (!function_a796c73f(targets[i])) {
            arrayremovevalue(targets, targets[i]);
        }
    }
    return targets;
}

// Namespace namespace_eec93adf
// Params 1, eflags: 0x4
// Checksum 0x6c8b4f37, Offset: 0xbd0
// Size: 0x5c
function private function_5915f3d5(target) {
    distance = distance2dsquared(target.origin, self.origin);
    if (distance > 10000 * 10000) {
        return false;
    }
    return true;
}

// Namespace namespace_eec93adf
// Params 2, eflags: 0x4
// Checksum 0xa470b310, Offset: 0xc38
// Size: 0x57a
function private function_285fbe6e(origin, players) {
    if (isdefined(self.zombie_poi)) {
        return undefined;
    }
    done = 0;
    while (players.size && !done) {
        done = 1;
        for (i = 0; i < players.size; i++) {
            target = players[i];
            if (!zombie_utility::is_player_valid(target, 1, 1)) {
                arrayremovevalue(players, target);
                done = 0;
                break;
            }
        }
    }
    if (players.size == 0) {
        return undefined;
    }
    designated_target = 0;
    foreach (player in players) {
        if (isdefined(player.b_is_designated_target) && player.b_is_designated_target) {
            designated_target = 1;
            break;
        }
    }
    if (!designated_target) {
        if (isdefined(self.attackable) && self.attackable.is_active) {
            return undefined;
        }
    }
    if (players.size == 1) {
        if (self function_a796c73f(players[0])) {
            self.last_closest_player = players[0];
            return self.last_closest_player;
        }
        return undefined;
    }
    if (!isdefined(self.last_closest_player)) {
        self.last_closest_player = players[0];
    }
    if (!isdefined(self.need_closest_player)) {
        self.need_closest_player = 1;
    }
    if (isdefined(level.last_closest_time) && level.last_closest_time >= level.time) {
        self function_a0740c5a(players);
        return self.last_closest_player;
    }
    if (isdefined(self.need_closest_player) && self.need_closest_player) {
        level.last_closest_time = level.time;
        self.need_closest_player = 0;
        closest = players[0];
        closest_dist = undefined;
        if (isdefined(players[0].am_i_valid) && players[0].am_i_valid && self function_a796c73f(players[0])) {
            if (isactor(self)) {
                closest_dist = self zm_utility::approximate_path_dist(closest);
            } else {
                closest_dist = distancesquared(self.origin, closest.origin);
            }
        }
        if (!isdefined(closest_dist)) {
            closest = undefined;
        }
        for (index = 1; index < players.size; index++) {
            dist = undefined;
            if (isdefined(players[index].am_i_valid) && players[index].am_i_valid && self function_a796c73f(players[index])) {
                if (isactor(self)) {
                    dist = self zm_utility::approximate_path_dist(players[index]);
                } else {
                    dist = distancesquared(self.origin, players[index].origin);
                }
            }
            if (isdefined(dist)) {
                if (isdefined(closest_dist)) {
                    if (dist < closest_dist) {
                        closest = players[index];
                        closest_dist = dist;
                    }
                    continue;
                }
                closest = players[index];
                closest_dist = dist;
            }
        }
        self.last_closest_player = closest;
    }
    if (players.size > 1 && isdefined(closest)) {
        if (isactor(self)) {
            self zm_utility::approximate_path_dist(closest);
        }
    }
    self function_a0740c5a(players);
    return self.last_closest_player;
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x4
// Checksum 0xc50735de, Offset: 0x11c0
// Size: 0x18c
function private function_72e6c1d6() {
    level waittill(#"start_of_round");
    while (true) {
        reset_closest_player = 1;
        zombies = zombie_utility::get_round_enemy_array();
        foreach (zombie in zombies) {
            if (isdefined(zombie.need_closest_player) && zombie.need_closest_player) {
                reset_closest_player = 0;
                break;
            }
        }
        if (reset_closest_player) {
            foreach (zombie in zombies) {
                if (isdefined(zombie.need_closest_player)) {
                    zombie.need_closest_player = 1;
                }
            }
        }
        wait(0.05);
    }
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x0
// Checksum 0x1accea1, Offset: 0x1358
// Size: 0x80
function function_b10a912a() {
    self endon(#"death");
    self waittill(#"hash_f07646c0");
    if (isdefined(self.s_spawn_loc) && issubstr(self.s_spawn_loc.targetname, "pavlov")) {
        self.var_5de5a96c = 1;
        if (self.var_c94972aa === 1) {
            self.var_98bec529 = 1;
        }
    }
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x0
// Checksum 0xc37056a7, Offset: 0x13e0
// Size: 0x34
function function_ec1b37df() {
    self thread zm::update_zone_name();
    self thread function_72fad482();
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x0
// Checksum 0x95d89736, Offset: 0x1420
// Size: 0x5a6
function function_cec23cbf() {
    level waittill(#"start_of_round");
    n_current_time = gettime();
    var_36eeba73 = 0;
    var_c48f3f8a = 0;
    var_b8e747cf = 1;
    var_c9b19c0c = [];
    var_bb6abcd9 = [];
    var_bcfa504e = struct::get_array("pavlovs_B_spawn", "targetname");
    foreach (s_spawn in var_bcfa504e) {
        if (s_spawn.script_noteworthy == "raz_location") {
            if (!isdefined(var_c9b19c0c)) {
                var_c9b19c0c = [];
            } else if (!isarray(var_c9b19c0c)) {
                var_c9b19c0c = array(var_c9b19c0c);
            }
            var_c9b19c0c[var_c9b19c0c.size] = s_spawn;
        }
        if (s_spawn.script_noteworthy == "sentinel_location") {
            if (!isdefined(var_bb6abcd9)) {
                var_bb6abcd9 = [];
            } else if (!isarray(var_bb6abcd9)) {
                var_bb6abcd9 = array(var_bb6abcd9);
            }
            var_bb6abcd9[var_bb6abcd9.size] = s_spawn;
        }
    }
    while (true) {
        if (level flag::get("special_round")) {
            level flag::wait_till_clear("special_round");
            continue;
        }
        if (flag::exists("world_is_paused")) {
            level flag::wait_till_clear("world_is_paused");
        }
        if (!level flag::get("spawn_zombies")) {
            level waittill(#"spawn_zombies");
        }
        n_current_time = gettime();
        var_a62c1873 = 0;
        foreach (e_player in level.players) {
            if (zm_utility::is_player_valid(e_player)) {
                var_54bcb829 = zm_zonemgr::get_zone_from_position(e_player.origin + (0, 0, 32), 0);
                if (var_54bcb829 === "pavlovs_A_zone" || var_54bcb829 === "pavlovs_B_zone" || var_54bcb829 === "pavlovs_C_zone") {
                    var_a62c1873++;
                }
            }
        }
        if (var_a62c1873 > 0) {
            if (var_b8e747cf) {
                n_current_time = gettime();
                var_36eeba73 = function_8caf1f25(var_a62c1873);
                var_c48f3f8a = n_current_time + 15000;
                var_b8e747cf = 0;
            }
            if (var_36eeba73 <= n_current_time) {
                if (zombie_utility::get_current_zombie_count() + level.zombie_total > 5) {
                    s_spawn_loc = array::random(var_c9b19c0c);
                    if (namespace_1c31c03d::function_7ed6c714(1, undefined, 1, s_spawn_loc)) {
                        level.zombie_total--;
                        var_36eeba73 = function_8caf1f25(var_a62c1873);
                    }
                }
            } else if (level.var_f73b438a > 1 && var_c48f3f8a <= n_current_time) {
                if (namespace_8bc21961::function_74ab7484() && zombie_utility::get_current_zombie_count() + level.zombie_total > 5) {
                    s_spawn_loc = array::random(var_bb6abcd9);
                    if (namespace_8bc21961::function_19d0b055(1, undefined, 1, s_spawn_loc)) {
                        level.zombie_total--;
                        level.var_bd1e3d02++;
                        var_c48f3f8a = function_c7a940c4(var_a62c1873);
                    }
                }
            }
        } else {
            level waittill(#"hash_9a634383");
            wait(5);
            var_b8e747cf = 1;
            continue;
        }
        wait(5);
    }
}

// Namespace namespace_eec93adf
// Params 1, eflags: 0x0
// Checksum 0x5f079d38, Offset: 0x19d0
// Size: 0x9e
function function_8caf1f25(n_players) {
    n_current_time = gettime();
    if (n_players > 0 && n_players <= 2) {
        var_36eeba73 = n_current_time + 180000;
    } else if (n_players == 3) {
        var_36eeba73 = n_current_time + 120000;
    } else if (n_players == 4) {
        var_36eeba73 = n_current_time + 90000;
    }
    return var_36eeba73;
}

// Namespace namespace_eec93adf
// Params 1, eflags: 0x0
// Checksum 0x403166b, Offset: 0x1a78
// Size: 0x9e
function function_c7a940c4(n_players) {
    n_current_time = gettime();
    if (n_players > 0 && n_players <= 2) {
        var_c48f3f8a = n_current_time + 180000;
    } else if (n_players == 3) {
        var_c48f3f8a = n_current_time + 120000;
    } else if (n_players == 4) {
        var_c48f3f8a = n_current_time + 90000;
    }
    return var_c48f3f8a;
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x0
// Checksum 0x9c556507, Offset: 0x1b20
// Size: 0x128
function function_3de9d297() {
    var_eb1ae81f = 0;
    var_1916d2ed = getentarray("zombie_sentinel", "targetname");
    foreach (var_663b2442 in var_1916d2ed) {
        str_zone = zm_zonemgr::get_zone_from_position(var_663b2442.origin + (0, 0, 32), 0);
        if (str_zone === "pavlovs_A_zone" || str_zone === "pavlovs_B_zone" || str_zone === "pavlovs_C_zone") {
            var_eb1ae81f++;
        }
    }
    return var_eb1ae81f;
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x0
// Checksum 0xd56c7e3d, Offset: 0x1c50
// Size: 0x1d6
function function_9b4d9341() {
    level waittill(#"start_of_round");
    while (true) {
        if (flag::exists("world_is_paused")) {
            level flag::wait_till_clear("world_is_paused");
        }
        var_a62c1873 = 0;
        var_110db1be = undefined;
        foreach (e_player in level.players) {
            if (zm_utility::is_player_valid(e_player)) {
                var_54bcb829 = zm_zonemgr::get_zone_from_position(e_player.origin + (0, 0, 32), 0);
                if (var_54bcb829 === "pavlovs_A_zone" || var_54bcb829 === "pavlovs_B_zone" || var_54bcb829 === "pavlovs_C_zone") {
                    var_110db1be = e_player;
                    var_a62c1873++;
                }
            }
        }
        if (var_a62c1873 > 0) {
            level.var_809d579e = &function_8b981aa0;
            level thread function_a442e988(var_110db1be);
        } else {
            level.var_809d579e = undefined;
            wait(15);
            continue;
        }
        wait(5);
    }
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x0
// Checksum 0xbd063d43, Offset: 0x1e30
// Size: 0x84
function function_8b981aa0() {
    var_eb1ae81f = function_3de9d297();
    if (var_eb1ae81f == 0) {
        a_s_spawn_locs = struct::get_array("pavlovs_A_spawn", "targetname");
        return array::random(a_s_spawn_locs);
    }
    return namespace_8bc21961::function_f9c9e7e0();
}

// Namespace namespace_eec93adf
// Params 1, eflags: 0x0
// Checksum 0xfd70c948, Offset: 0x1ec0
// Size: 0x36c
function function_a442e988(e_player) {
    if (level.var_dc87592f) {
        return;
    }
    var_1916d2ed = getentarray("zombie_sentinel", "targetname");
    foreach (var_663b2442 in var_1916d2ed) {
        while (isdefined(var_663b2442) && !var_663b2442 flag::exists("completed_spawning")) {
            wait(0.05);
        }
        if (!isdefined(var_663b2442)) {
            continue;
        }
        var_663b2442 flag::wait_till("completed_spawning");
        str_zone = zm_zonemgr::get_zone_from_position(var_663b2442.origin + (0, 0, 32), 0);
        if (str_zone === "pavlovs_A_zone" || str_zone === "pavlovs_B_zone" || str_zone === "pavlovs_C_zone") {
            return;
        }
        if (distance2dsquared(var_663b2442.origin, e_player.origin) < 6250000 && distance2dsquared(var_663b2442.origin, level.var_ca793258.origin) > 250000) {
            if (var_663b2442.var_c94972aa === 1) {
                if (var_663b2442.var_7e04bb3 === 1) {
                    continue;
                } else {
                    var_663b2442 notify(#"hash_d600cb9a");
                }
            }
            var_d7b33d0c = var_663b2442;
            break;
        }
    }
    if (isdefined(var_d7b33d0c)) {
        level.var_dc87592f = 1;
        var_d7b33d0c thread function_f05eb36e();
        var_d7b33d0c endon(#"death");
        var_663b2442 flag::wait_till("completed_spawning");
        var_d7b33d0c namespace_58ca6a3a::function_aed5ff39(1, level.var_44d3a45c.origin);
        var_d7b33d0c waittill(#"goal");
        var_d7b33d0c.origin = level.var_ca793258.origin;
        var_d7b33d0c namespace_58ca6a3a::function_aed5ff39(0);
        var_d7b33d0c.var_5de5a96c = 0;
        if (var_d7b33d0c.var_c94972aa === 1) {
            var_d7b33d0c.var_98bec529 = 0;
            var_d7b33d0c thread namespace_8bc21961::function_d600cb9a();
        }
    }
}

// Namespace namespace_eec93adf
// Params 0, eflags: 0x0
// Checksum 0xb60129c6, Offset: 0x2238
// Size: 0x1c
function function_f05eb36e() {
    self waittill(#"death");
    level.var_dc87592f = 0;
}

