#using scripts/shared/ai/zombie_utility;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_zonemgr;
#using scripts/zm/_zm_unitrigger;
#using scripts/zm/_zm_traps;
#using scripts/zm/_zm_score;
#using scripts/zm/_zm_net;
#using scripts/zm/_zm_audio;
#using scripts/shared/scene_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/util_shared;
#using scripts/shared/math_shared;
#using scripts/shared/laststand_shared;
#using scripts/shared/hud_util_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/array_shared;
#using scripts/codescripts/struct;

#namespace namespace_2eabe570;

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0x87641cc1, Offset: 0x580
// Size: 0x154
function main() {
    register_clientfields();
    level waittill(#"start_zombie_round_logic");
    level flag::init("masher_on");
    level flag::init("masher_unlocked");
    level flag::init("masher_cooldown");
    scene::add_scene_func("p7_fxanim_zm_castle_gate_smash_lift_bundle", &function_ef9ad3c0, "init");
    level thread function_6a74bee8();
    level thread function_a61df505();
    level.var_6ac4e9cb = getent("masher_gate", "script_noteworthy");
    level.var_6ac4e9cb thread function_faccc214();
    level thread scene::init("p7_fxanim_zm_castle_gate_smash_lift_bundle");
    /#
        level thread function_9087381a();
    #/
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0x99ec1590, Offset: 0x6e0
// Size: 0x4
function register_clientfields() {
    
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0x3e290825, Offset: 0x6f0
// Size: 0x64
function function_a61df505() {
    var_fb9e67a8 = getent("masher_buy_door", "script_noteworthy");
    if (isdefined(var_fb9e67a8)) {
        var_fb9e67a8 waittill(#"door_opened");
    }
    level flag::set("masher_unlocked");
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0x147088a7, Offset: 0x760
// Size: 0x54
function function_6a74bee8() {
    var_4aa9fb47 = struct::get_array("s_masher_button", "targetname");
    array::thread_all(var_4aa9fb47, &function_a5062ebd);
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0x3054fedb, Offset: 0x7c0
// Size: 0x332
function function_a5062ebd() {
    s_unitrigger_stub = spawnstruct();
    s_unitrigger_stub.origin = self.origin;
    s_unitrigger_stub.angles = self.angles;
    s_unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
    s_unitrigger_stub.cursor_hint = "HINT_NOICON";
    s_unitrigger_stub.hint_parm1 = 1500;
    s_unitrigger_stub.radius = 64;
    s_unitrigger_stub.require_look_at = 0;
    s_unitrigger_stub.var_42d723eb = self;
    s_unitrigger_stub.prompt_and_visibility_func = &function_d7e7dcf9;
    thread zm_unitrigger::register_static_unitrigger(s_unitrigger_stub, &function_b776b443);
    s_unitrigger_stub._trap_lights = [];
    s_unitrigger_stub._trap_switches = [];
    var_a22f946c = getentarray(self.target, "targetname");
    for (i = 0; i < var_a22f946c.size; i++) {
        if (isdefined(var_a22f946c[i].script_noteworthy)) {
            switch (var_a22f946c[i].script_noteworthy) {
            case 13:
                s_unitrigger_stub._trap_switches[s_unitrigger_stub._trap_switches.size] = var_a22f946c[i];
                s_unitrigger_stub thread function_aaf7f74d();
                break;
            case 12:
                s_unitrigger_stub._trap_lights[s_unitrigger_stub._trap_lights.size] = var_a22f946c[i];
                s_unitrigger_stub function_81b05f08();
                break;
            }
        }
    }
    a_t_traps = getentarray("zombie_trap", "targetname");
    array::thread_all(a_t_traps, &function_5054a970);
    foreach (t_trap in a_t_traps) {
        if (t_trap.target === "trap_b") {
            t_trap thread function_aaf2ece7();
        }
    }
}

// Namespace namespace_2eabe570
// Params 1, eflags: 0x1 linked
// Checksum 0x6fa2a879, Offset: 0xb00
// Size: 0x9c
function function_ef9ad3c0(a_ents) {
    level.var_995bb84e = a_ents["castle_gate_door_smash_lift"];
    if (isdefined(level.var_995bb84e)) {
        level.var_995bb84e.var_beb932f1 = getentarray("masher_gate_trig_1", "targetname");
        array::thread_all(level.var_995bb84e.var_beb932f1, &function_1a554e00, level.var_995bb84e, "gate_jnt");
    }
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0x499c3657, Offset: 0xba8
// Size: 0x80
function function_df78b782() {
    self thread function_994bb49e();
    while (level flag::get("masher_on")) {
        level scene::play("p7_fxanim_zm_castle_gate_smash_lift_bundle");
        level function_1ff56fb0("p7_fxanim_zm_castle_gate_smash_lift_bundle");
    }
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0x9092aa, Offset: 0xc30
// Size: 0x98
function function_994bb49e() {
    while (level flag::get("masher_on")) {
        level waittill(#"hash_d1d080bc");
        array::run_all(self.var_beb932f1, &setvisibletoall);
        level waittill(#"hash_e30b0e08");
        array::run_all(self.var_beb932f1, &setinvisibletoall);
    }
}

// Namespace namespace_2eabe570
// Params 1, eflags: 0x1 linked
// Checksum 0xf5a2c843, Offset: 0xcd0
// Size: 0x48
function function_1ff56fb0(str_scene) {
    s_scene = struct::get(str_scene, "scriptbundlename");
    s_scene.scene_played = 0;
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0xa5df5dd3, Offset: 0xd20
// Size: 0x88
function function_aaf2ece7() {
    while (true) {
        self waittill(#"trap_activate");
        if (isdefined(self.activated_by_player)) {
            self.activated_by_player playrumbleonentity("zm_castle_interact_rumble");
        }
        exploder::exploder("fxexp_116");
        self waittill(#"trap_done");
        exploder::stop_exploder("fxexp_116");
    }
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0x1c5ca8be, Offset: 0xdb0
// Size: 0x34
function function_81b05f08() {
    self._trap_light_model_off = "p7_zm_der_light_bulb_small_off";
    self._trap_light_model_green = "p7_zm_der_light_bulb_small_emissive";
    self._trap_light_model_red = "p7_zm_der_light_bulb_small";
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0xec1022ae, Offset: 0xdf0
// Size: 0x4e
function function_5054a970() {
    level waittill(#"power_on");
    for (i = 0; i < self._trap_lights.size; i++) {
        self function_81b05f08();
    }
}

// Namespace namespace_2eabe570
// Params 1, eflags: 0x1 linked
// Checksum 0xc3929fe3, Offset: 0xe48
// Size: 0x198
function function_d7e7dcf9(player) {
    if (player.is_drinking > 0) {
        self sethintstring("");
        return false;
    } else if (!level flag::get("power_on")) {
        self sethintstring(%ZM_CASTLE_MASHER_POWER);
        return false;
    } else if (!level flag::get("masher_unlocked")) {
        self sethintstring(%ZM_CASTLE_MASHER_UNAVAILABLE);
        return false;
    } else if (level flag::get("masher_on")) {
        self sethintstring("");
        return false;
    } else if (level flag::get("masher_cooldown")) {
        self sethintstring(%ZM_CASTLE_MASHER_COOLDOWN);
        return false;
    } else {
        self sethintstring(%ZM_CASTLE_MASHER_TRAP, self.stub.hint_parm1);
    }
    return true;
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0x60a93d04, Offset: 0xfe8
// Size: 0x180
function function_b776b443() {
    while (true) {
        if (level flag::get("masher_cooldown")) {
            level flag::wait_till_clear("masher_cooldown");
        }
        e_who = self waittill(#"trigger");
        if (!level flag::get("masher_on") && !level flag::get("masher_cooldown")) {
            if (!e_who zm_score::can_player_purchase(1500)) {
                e_who zm_audio::create_and_play_dialog("general", "transport_deny");
                continue;
            }
            e_who zm_score::minus_to_player_score(1500);
            self.stub.var_42d723eb thread function_d12a18d7(e_who);
            e_who zm_audio::create_and_play_dialog("trap", "start");
            e_who playrumbleonentity("zm_castle_interact_rumble");
        }
    }
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0x654af9f9, Offset: 0x1170
// Size: 0x2f8
function function_aaf7f74d() {
    self function_13fd863b(self._trap_light_model_red);
    exploder::stop_exploder("masher_trap_green");
    exploder::exploder("masher_trap_red");
    for (i = 0; i < self._trap_switches.size; i++) {
        self._trap_switches[i] rotatepitch(-76, 0.5);
        self._trap_switches[i] playsound("evt_switch_flip_trap");
    }
    level flag::wait_till_all(array("power_on", "masher_unlocked"));
    while (true) {
        level flag::wait_till_clear("masher_cooldown");
        for (i = 0; i < self._trap_switches.size; i++) {
            self._trap_switches[i] rotatepitch(-180, 0.5);
        }
        self._trap_switches[0] waittill(#"rotatedone");
        self function_13fd863b(self._trap_light_model_green);
        exploder::stop_exploder("masher_trap_red");
        exploder::exploder("masher_trap_green");
        level flag::wait_till("masher_on");
        self function_13fd863b(self._trap_light_model_red);
        exploder::stop_exploder("masher_trap_green");
        exploder::exploder("masher_trap_red");
        for (i = 0; i < self._trap_switches.size; i++) {
            self._trap_switches[i] rotatepitch(-76, 0.5);
            self._trap_switches[i] playsound("evt_switch_flip_trap");
        }
        level flag::wait_till("masher_cooldown");
    }
}

// Namespace namespace_2eabe570
// Params 1, eflags: 0x1 linked
// Checksum 0xd8c3e079, Offset: 0x1470
// Size: 0x6e
function function_13fd863b(str_model) {
    for (i = 0; i < self._trap_lights.size; i++) {
        mdl_light = self._trap_lights[i];
        mdl_light setmodel(str_model);
    }
}

// Namespace namespace_2eabe570
// Params 1, eflags: 0x1 linked
// Checksum 0x4ba1df7f, Offset: 0x14e8
// Size: 0x10c
function function_d12a18d7(e_player) {
    level flag::set("masher_on");
    level.var_6ac4e9cb.activated_by_player = e_player;
    level.var_995bb84e.activated_by_player = e_player;
    level.var_995bb84e thread function_df78b782();
    wait(0.5);
    level.var_6ac4e9cb function_8123d15a();
    level flag::clear("masher_on");
    level flag::set("masher_cooldown");
    level.var_6ac4e9cb.activated_by_player = undefined;
    level.var_995bb84e.activated_by_player = undefined;
    wait(60);
    level flag::clear("masher_cooldown");
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0x38dbe76c, Offset: 0x1600
// Size: 0x1ac
function function_8123d15a() {
    array::run_all(self.var_beb932f1, &show);
    n_start_time = gettime();
    for (n_total_time = 0; 20 > n_total_time && level flag::get("masher_on"); n_total_time = (gettime() - n_start_time) / 1000) {
        self movez(-116, 0.25);
        self playsound("zmb_mashertrap_descend");
        self waittill(#"movedone");
        playrumbleonposition("zm_castle_gate_mash", self.origin);
        array::run_all(self.var_beb932f1, &hide);
        self movez(116, 0.25);
        self waittill(#"movedone");
        wait(0.25);
        array::run_all(self.var_beb932f1, &show);
    }
    array::run_all(self.var_beb932f1, &hide);
}

// Namespace namespace_2eabe570
// Params 0, eflags: 0x1 linked
// Checksum 0xb4e389d5, Offset: 0x17b8
// Size: 0x54
function function_faccc214() {
    self.var_beb932f1 = getentarray(self.target, "targetname");
    array::thread_all(self.var_beb932f1, &function_1a554e00, self);
}

// Namespace namespace_2eabe570
// Params 2, eflags: 0x1 linked
// Checksum 0x87e0ac2e, Offset: 0x1818
// Size: 0xb4
function function_1a554e00(var_6ac4e9cb, var_8f915eab) {
    self._trap_type = "masher";
    self enablelinkto();
    if (isdefined(var_8f915eab)) {
        self linkto(var_6ac4e9cb, var_8f915eab);
    } else {
        self linkto(var_6ac4e9cb);
    }
    self thread trigger_damage(var_6ac4e9cb);
    self hide();
}

// Namespace namespace_2eabe570
// Params 1, eflags: 0x1 linked
// Checksum 0x6b17049b, Offset: 0x18d8
// Size: 0x174
function trigger_damage(var_6ac4e9cb) {
    while (true) {
        e_who = self waittill(#"trigger");
        self.activated_by_player = var_6ac4e9cb.activated_by_player;
        if (level flag::get("masher_on")) {
            if (e_who.archetype === "zombie" && !(isdefined(e_who.var_bd3a4420) && e_who.var_bd3a4420)) {
                e_who thread function_e80df8bf(var_6ac4e9cb.activated_by_player, self);
            } else if (e_who.archetype === "mechz") {
                level flag::clear("masher_on");
            } else if (isdefined(e_who)) {
                e_who dodamage(e_who.health, e_who.origin, self, undefined, "none", "MOD_IMPACT");
            }
        } else {
            wait(0.5);
        }
        wait(0.05);
    }
}

// Namespace namespace_2eabe570
// Params 2, eflags: 0x1 linked
// Checksum 0xd4c140c6, Offset: 0x1a58
// Size: 0x16c
function function_e80df8bf(var_ecf98bb6, t_trap) {
    n_chance = randomint(100);
    if (n_chance > 90) {
        self.var_bd3a4420 = 1;
        self thread zombie_utility::makezombiecrawler();
        wait(4);
        if (isdefined(self)) {
            self.var_bd3a4420 = undefined;
        }
    } else if (n_chance > 50) {
        self thread zombie_utility::zombie_gut_explosion();
        level notify(#"hash_de71acc2", self, var_ecf98bb6);
        self dodamage(self.health + 100, self.origin, t_trap, undefined, "none", "MOD_IMPACT");
    } else {
        self thread zombie_utility::gib_random_parts();
        level notify(#"hash_de71acc2", self, var_ecf98bb6);
        self dodamage(self.health + 100, self.origin, t_trap, undefined, "none", "MOD_IMPACT");
    }
    level.zombie_total++;
}

/#

    // Namespace namespace_2eabe570
    // Params 0, eflags: 0x1 linked
    // Checksum 0x39eb0332, Offset: 0x1bd0
    // Size: 0xb8
    function function_9087381a() {
        wait(0.05);
        level waittill(#"start_zombie_round_logic");
        wait(0.05);
        setdvar("targetname", 0);
        adddebugcommand("targetname");
        while (true) {
            if (getdvarint("targetname")) {
                setdvar("targetname", 0);
                level thread function_d12a18d7(1);
            }
            wait(0.5);
        }
    }

#/
