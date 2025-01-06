#using scripts/codescripts/struct;
#using scripts/cp/_accolades;
#using scripts/cp/_util;
#using scripts/cp/gametypes/_save;
#using scripts/shared/callbacks_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/util_shared;

#namespace namespace_37a1dc33;

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x39b206bc, Offset: 0x5d0
// Size: 0x29c
function function_4d39a2af() {
    accolades::register("MISSION_NEWWORLD_UNTOUCHED");
    accolades::register("MISSION_NEWWORLD_SCORE");
    accolades::register("MISSION_NEWWORLD_COLLECTIBLE");
    accolades::register("MISSION_NEWWORLD_CHALLENGE3", "ch03_light_enemies_on_fire");
    accolades::register("MISSION_NEWWORLD_CHALLENGE4", "ch04_wall_run_kills");
    accolades::register("MISSION_NEWWORLD_CHALLENGE5", "ch05_penetrate_bullet_kills");
    accolades::register("MISSION_NEWWORLD_CHALLENGE6", "ch06_cybercom_robot_kills");
    accolades::register("MISSION_NEWWORLD_CHALLENGE7", "ch07_explosion_triple_kill");
    accolades::register("MISSION_NEWWORLD_CHALLENGE8", "ch08_grenade_throwback_kill");
    accolades::register("MISSION_NEWWORLD_CHALLENGE9", "ch09_icicle_kill");
    accolades::register("MISSION_NEWWORLD_CHALLENGE10", "ch10_disabled_robot_kill");
    accolades::register("MISSION_NEWWORLD_CHALLENGE11", "ch11_chase_no_reload");
    accolades::register("MISSION_NEWWORLD_CHALLENGE12", "ch12_chase_no_civilians");
    accolades::register("MISSION_NEWWORLD_CHALLENGE13", "ch13_turret_kill");
    accolades::register("MISSION_NEWWORLD_CHALLENGE14", "ch14_shotgun_kills");
    accolades::register("MISSION_NEWWORLD_CHALLENGE15", "ch15_wall_run_train");
    callback::on_spawned(&function_3a6b5b3e);
    function_89a4c66f();
    function_314eff4a();
    function_2b972244();
    function_e346bcd4();
    function_5a3da660();
    function_a87e96e();
    function_353e449e();
    function_6972c343();
    function_80820e19();
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0xd029393, Offset: 0x878
// Size: 0x64
function function_3a6b5b3e() {
    self function_9f8d841b();
    self function_b4b1da62();
    self function_9c7144b6();
    self thread function_7e35ccbc();
}

// Namespace namespace_37a1dc33
// Params 2, eflags: 0x0
// Checksum 0xcf9ad48f, Offset: 0x8e8
// Size: 0xd6
function function_c27610f9(var_8e087689, var_70b01bd3) {
    if (self == level) {
        foreach (player in level.activeplayers) {
            player notify(var_8e087689);
        }
    } else if (isplayer(self)) {
        self notify(var_8e087689);
    }
    if (isdefined(var_70b01bd3)) {
        [[ var_70b01bd3 ]]();
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x9afad62e, Offset: 0x9c8
// Size: 0x1a
function function_9f8d841b() {
    self.var_57582aca = 0;
    self.var_6659e536 = undefined;
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0xe8e41c32, Offset: 0x9f0
// Size: 0x24
function function_89a4c66f() {
    callback::on_actor_killed(&function_595dc718);
}

// Namespace namespace_37a1dc33
// Params 1, eflags: 0x0
// Checksum 0xab731fc9, Offset: 0xa20
// Size: 0x214
function function_595dc718(params) {
    if (isplayer(params.eattacker) && params.smeansofdeath == "MOD_BURNED") {
        if (!isdefined(params.eattacker.var_6659e536) || params.eattacker.var_6659e536 != params.einflictor) {
            params.eattacker.var_6659e536 = params.einflictor;
            params.eattacker.var_57582aca = 1;
            params.eattacker notify(#"hash_6daef24a");
            wait 0.05;
            if (params.eattacker.var_6659e536 == params.eattacker) {
                params.eattacker thread function_840d3bcc();
            }
            return;
        }
        if (params.eattacker.var_6659e536 === params.einflictor && !isdefined(self.var_93eeceb)) {
            params.eattacker.var_57582aca++;
            self.var_93eeceb = 1;
            if (params.eattacker.var_57582aca == 3) {
                params.eattacker notify(#"ch03_light_enemies_on_fire");
            }
            return;
        }
        params.eattacker.var_6659e536 = params.einflictor;
        params.eattacker.var_57582aca = 1;
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x42cbaa63, Offset: 0xc40
// Size: 0x4c
function function_840d3bcc() {
    self endon(#"death");
    self endon(#"hash_6daef24a");
    self endon(#"ch03_light_enemies_on_fire");
    wait 0.5;
    self.var_6659e536 = undefined;
    self.var_57582aca = 0;
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x79546174, Offset: 0xc98
// Size: 0x24
function function_314eff4a() {
    callback::on_ai_killed(&function_9257e223);
}

// Namespace namespace_37a1dc33
// Params 1, eflags: 0x0
// Checksum 0xb2b3a567, Offset: 0xcc8
// Size: 0x7c
function function_9257e223(params) {
    if (isplayer(params.eattacker)) {
        player = params.eattacker;
        if (player iswallrunning()) {
            player function_c27610f9("ch04_wall_run_kills");
        }
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0xabeaf6aa, Offset: 0xd50
// Size: 0x24
function function_2b972244() {
    callback::on_ai_killed(&function_9d5a87b1);
}

// Namespace namespace_37a1dc33
// Params 1, eflags: 0x0
// Checksum 0x74218bb8, Offset: 0xd80
// Size: 0xfc
function function_9d5a87b1(params) {
    if (self.team !== "axis") {
        return;
    }
    if (isplayer(params.eattacker)) {
        player = params.eattacker;
        var_3d9e461f = !bullettracepassed(player geteye(), self geteye(), 0, self);
        if (util::isbulletimpactmod(params.smeansofdeath) && var_3d9e461f) {
            player function_c27610f9("ch05_penetrate_bullet_kills");
        }
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x6040bbbe, Offset: 0xe88
// Size: 0x2c
function function_b4b1da62() {
    self.var_c81126e8 = 0;
    self.s_timer = util::new_timer(2);
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x83cfe33c, Offset: 0xec0
// Size: 0x2c
function function_5a3da660() {
    spawner::add_archetype_spawn_function("robot", &function_f9a5c6a1);
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x1243f60c, Offset: 0xef8
// Size: 0x14c
function function_f9a5c6a1() {
    self waittill(#"cybercom_action", weapon, eattacker);
    if (isplayer(eattacker)) {
        if (eattacker.var_c81126e8 == 0) {
            eattacker.s_timer = util::new_timer(2);
            eattacker.var_c81126e8++;
            return;
        }
        eattacker.var_c81126e8++;
        if (eattacker.var_c81126e8 >= 5 && eattacker.s_timer util::get_time_left() > 0) {
            eattacker notify(#"ch06_cybercom_robot_kills");
            return;
        }
        if (eattacker.s_timer util::get_time_left() <= 0) {
            eattacker.s_timer = util::new_timer(2);
            eattacker.var_c81126e8 = 1;
        }
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0xf948f2e1, Offset: 0x1050
// Size: 0x1a
function function_9c7144b6() {
    self.var_b2c73b97 = 0;
    self.var_b5385d9d = undefined;
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0xfff9a42f, Offset: 0x1078
// Size: 0x24
function function_e346bcd4() {
    callback::on_ai_killed(&function_1b6f43c5);
}

// Namespace namespace_37a1dc33
// Params 1, eflags: 0x0
// Checksum 0x7847d504, Offset: 0x10a8
// Size: 0x210
function function_1b6f43c5(params) {
    if (self.team !== "axis") {
        return;
    }
    if (params.smeansofdeath == "MOD_GRENADE" || params.smeansofdeath == "MOD_GRENADE_SPLASH" || params.smeansofdeath == "MOD_EXPLOSIVE" || params.smeansofdeath == "MOD_EXPLOSIVE_SPLASH" || params.smeansofdeath == "MOD_PROJECTILE" || isplayer(params.eattacker) && params.smeansofdeath == "MOD_PROJECTILE_SPLASH") {
        if (!isdefined(params.eattacker.var_b5385d9d)) {
            params.eattacker.var_b5385d9d = params.einflictor;
            params.eattacker.var_b2c73b97 = 1;
            return;
        }
        if (params.eattacker.var_b5385d9d === params.einflictor) {
            params.eattacker.var_b2c73b97++;
            if (params.eattacker.var_b2c73b97 >= 3) {
                params.eattacker notify(#"ch07_explosion_triple_kill");
            }
            return;
        }
        params.eattacker.var_b5385d9d = params.einflictor;
        params.eattacker.var_b2c73b97 = 1;
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x172db8b4, Offset: 0x12c0
// Size: 0x88
function function_7e35ccbc() {
    self endon(#"death");
    self.var_c6c262e8 = 0;
    while (true) {
        self waittill(#"grenade_throwback", var_2d789ddd, grenade);
        if (var_2d789ddd.team == "axis") {
            self.var_fc30fc22 = grenade;
            self thread function_23ad043b();
        }
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x66e2613, Offset: 0x1350
// Size: 0x40
function function_23ad043b() {
    self endon(#"death");
    self.var_fc30fc22 waittill(#"explode");
    self.var_fc30fc22 = undefined;
    wait 0.5;
    self.var_c6c262e8 = 0;
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0xc6610f5, Offset: 0x1398
// Size: 0x24
function function_a87e96e() {
    callback::on_ai_killed(&function_ee3272c2);
}

// Namespace namespace_37a1dc33
// Params 1, eflags: 0x0
// Checksum 0xe61e089a, Offset: 0x13c8
// Size: 0xc0
function function_ee3272c2(params) {
    if (isplayer(params.eattacker)) {
        if (isdefined(params.eattacker.var_fc30fc22)) {
            if (params.einflictor == params.eattacker.var_fc30fc22) {
                params.eattacker.var_c6c262e8++;
                if (params.eattacker.var_c6c262e8 == 3) {
                    params.eattacker notify(#"ch08_grenade_throwback_kill");
                }
            }
        }
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x842fce29, Offset: 0x1490
// Size: 0x24
function function_353e449e() {
    callback::on_ai_killed(&function_3867e45c);
}

// Namespace namespace_37a1dc33
// Params 1, eflags: 0x0
// Checksum 0x7097be11, Offset: 0x14c0
// Size: 0x68
function function_3867e45c(params) {
    if (isplayer(params.eattacker) && params.eattacker.weap === "icicle") {
        params.eattacker notify(#"ch09_icicle_kill");
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x7a38cffb, Offset: 0x1530
// Size: 0x4c
function function_6972c343() {
    spawner::add_archetype_spawn_function("robot", &function_deb99e6);
    callback::on_ai_killed(&function_c008ffe2);
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0xdb4b6e99, Offset: 0x1588
// Size: 0x54
function function_deb99e6() {
    self endon(#"death");
    while (true) {
        self.b_disabled = 0;
        self waittill(#"emp_fx_start");
        self.b_disabled = 1;
        self waittill(#"emp_shutdown_end");
        self.b_disabled = 0;
    }
}

// Namespace namespace_37a1dc33
// Params 1, eflags: 0x0
// Checksum 0x734ea42e, Offset: 0x15e8
// Size: 0x64
function function_c008ffe2(params) {
    if (isplayer(params.eattacker) && self.archetype == "robot") {
        if (self.b_disabled) {
            params.eattacker notify(#"ch10_disabled_robot_kill");
        }
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0xd12fa721, Offset: 0x1658
// Size: 0x142
function function_cd261d0b() {
    level flag::wait_till("all_players_spawned");
    foreach (player in level.players) {
        player thread function_af529683();
    }
    level flag::wait_till("chase_done");
    foreach (player in level.players) {
        player thread function_2d344335();
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x7c53d562, Offset: 0x17a8
// Size: 0x4c
function function_af529683() {
    self endon(#"death");
    level endon(#"chase_done");
    self waittill(#"reload");
    self savegame::set_player_data("b_nw_accolade_11_failed", 1);
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x8d1db050, Offset: 0x1800
// Size: 0xa4
function function_2d344335() {
    if (self savegame::function_36adbb9c("b_nw_accolade_11_failed") !== 1 && self savegame::function_36adbb9c("b_has_done_chase") !== 0 && self savegame::function_36adbb9c("b_nw_accolade_11_completed") !== 1) {
        self notify(#"ch11_chase_no_reload");
        self savegame::set_player_data("b_nw_accolade_11_completed", 1);
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0xa450f35a, Offset: 0x18b0
// Size: 0x14c
function function_323baa37() {
    level flag::wait_till("all_players_spawned");
    callback::on_actor_killed(&function_bc7f04af);
    callback::on_ai_spawned(&function_829b12c4);
    level flag::wait_till("chase_done");
    foreach (player in level.players) {
        player thread function_8af9d448();
    }
    callback::remove_on_actor_killed(&function_bc7f04af);
    callback::remove_on_ai_spawned(&function_829b12c4);
}

// Namespace namespace_37a1dc33
// Params 1, eflags: 0x0
// Checksum 0x46cc825d, Offset: 0x1a08
// Size: 0x7c
function function_bc7f04af(params) {
    if ((self.archetype == "civilian" || self.archetype == "allies") && isplayer(params.eattacker)) {
        params.eattacker savegame::set_player_data("b_nw_accolade_12_failed", 1);
    }
}

// Namespace namespace_37a1dc33
// Params 1, eflags: 0x0
// Checksum 0x5029a397, Offset: 0x1a90
// Size: 0x9c
function function_829b12c4(params) {
    self endon(#"death");
    if (self.archetype == "civilian" || isdefined(self.archetype) && self.archetype == "allies") {
        self waittill(#"touch", var_efb53e77);
        if (isplayer(var_efb53e77)) {
            var_efb53e77 savegame::set_player_data("b_nw_accolade_12_failed", 1);
        }
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x4c2a8bbd, Offset: 0x1b38
// Size: 0xa4
function function_8af9d448() {
    if (self savegame::function_36adbb9c("b_nw_accolade_12_failed") !== 1 && self savegame::function_36adbb9c("b_has_done_chase") !== 0 && self savegame::function_36adbb9c("b_nw_accolade_12_completed") !== 1) {
        self notify(#"ch12_chase_no_civilians");
        self savegame::set_player_data("b_nw_accolade_12_completed", 1);
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x178d951e, Offset: 0x1be8
// Size: 0x54
function function_f7dd9b2c() {
    callback::on_ai_killed(&function_e50c8d4a);
    level waittill(#"hash_c37d20e3");
    callback::remove_on_ai_killed(&function_e50c8d4a);
}

// Namespace namespace_37a1dc33
// Params 1, eflags: 0x0
// Checksum 0x41f26345, Offset: 0x1c48
// Size: 0xb8
function function_e50c8d4a(params) {
    if (isdefined(params.eattacker) && isplayer(params.eattacker) && isdefined(params.eattacker.hijacked_vehicle_entity) && params.eattacker.hijacked_vehicle_entity.archetype === "turret") {
        if (params.eattacker.hijacked_vehicle_entity !== self) {
            params.eattacker notify(#"ch13_turret_kill");
        }
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x4b4a0419, Offset: 0x1d08
// Size: 0xcc
function function_8bb97e0() {
    foreach (player in level.players) {
        player thread function_ee166ee8();
    }
    callback::on_spawned(&function_ee166ee8);
    callback::on_ai_killed(&function_85ed003e);
}

// Namespace namespace_37a1dc33
// Params 1, eflags: 0x0
// Checksum 0x83940a47, Offset: 0x1de0
// Size: 0xb0
function function_85ed003e(params) {
    var_8c90e32b = util::getweaponclass(params.weapon);
    if (self.archetype === "robot" && var_8c90e32b === "weapon_cqb") {
        player = params.eattacker;
        player.var_89be6da0++;
        if (player.var_89be6da0 >= 8) {
            player notify(#"ch14_shotgun_kills");
        }
    }
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0xfa6e1c5d, Offset: 0x1e98
// Size: 0x44
function function_ee166ee8() {
    self endon(#"death");
    self.var_89be6da0 = 0;
    self waittill(#"reload");
    wait 0.05;
    self thread function_ee166ee8();
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0xf1321c52, Offset: 0x1ee8
// Size: 0x44
function function_80820e19() {
    var_4fa896d4 = getent("newworld_accolade_15", "targetname");
    var_4fa896d4 thread function_14316bd1();
}

// Namespace namespace_37a1dc33
// Params 0, eflags: 0x0
// Checksum 0x8bdb8abc, Offset: 0x1f38
// Size: 0xf4
function function_14316bd1() {
    level endon(#"train_station_end_gate_closed");
    while (true) {
        self waittill(#"trigger", ent);
        if (isplayer(ent) && ent iswallrunning()) {
            a_trace = bullettrace(ent.origin, ent.origin - (0, 0, 1000), 0, ent);
            if (isdefined(a_trace["entity"]) && a_trace["entity"].script_noteworthy === "chase_train") {
                ent notify(#"ch15_wall_run_train");
            }
        }
    }
}

