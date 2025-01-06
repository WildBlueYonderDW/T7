#using scripts/codescripts/struct;
#using scripts/shared/ai_shared;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/fx_shared;
#using scripts/shared/hud_util_shared;
#using scripts/shared/laststand_shared;
#using scripts/shared/scene_shared;
#using scripts/shared/util_shared;
#using scripts/shared/vehicle_shared;
#using scripts/zm/_zm_ai_spiders;
#using scripts/zm/_zm_laststand;
#using scripts/zm/_zm_perk_additionalprimaryweapon;
#using scripts/zm/_zm_perk_deadshot;
#using scripts/zm/_zm_perk_doubletap2;
#using scripts/zm/_zm_perk_electric_cherry;
#using scripts/zm/_zm_perk_juggernaut;
#using scripts/zm/_zm_perk_quick_revive;
#using scripts/zm/_zm_perk_random;
#using scripts/zm/_zm_perk_sleight_of_hand;
#using scripts/zm/_zm_perk_staminup;
#using scripts/zm/_zm_perk_widows_wine;
#using scripts/zm/_zm_perks;
#using scripts/zm/_zm_power;
#using scripts/zm/_zm_unitrigger;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_weapons;
#using scripts/zm/craftables/_zm_craftables;
#using scripts/zm/zm_island_vo;

#namespace zm_island_perks;

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0x22813044, Offset: 0xc40
// Size: 0x1c0
function init() {
    clientfield::register("world", "perk_light_speed_cola", 1, 3, "int");
    clientfield::register("world", "perk_light_doubletap", 1, 3, "int");
    clientfield::register("world", "perk_light_quick_revive", 1, 3, "int");
    clientfield::register("world", "perk_light_staminup", 1, 3, "int");
    clientfield::register("world", "perk_light_juggernog", 1, 3, "int");
    clientfield::register("world", "perk_light_mule_kick", 1, 1, "int");
    level thread function_8b929f79();
    level thread function_588068b3();
    level thread function_6753e7bb();
    level thread function_5508b348();
    level thread function_e840e164();
    level thread function_55b919e6();
    level.var_1eddc9ee = 9;
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0x94b4ff3, Offset: 0xe08
// Size: 0x1fc
function function_c97259e9() {
    if (!isdefined(level.var_c54e133)) {
        level.var_c54e133 = struct::get_array("perk_random_machine_location", "targetname");
        level.var_922007f3 = &function_afa51c0f;
        var_7a46d09b = struct::get("perk_spot_bunker1");
        var_ff311e3a = struct::get("perk_spot_construction");
        array::add(level.var_c54e133, var_7a46d09b);
        array::add(level.var_c54e133, var_ff311e3a);
    }
    if (!isdefined(level.var_961b3545)) {
        level.var_961b3545 = getentarray("zombie_vending", "targetname");
    }
    function_8abc06a5();
    level thread function_3bccea41();
    function_f9d235ed();
    foreach (var_271d87d8 in level.var_961b3545) {
        var_271d87d8.machine.b_keep_when_turned_off = 1;
    }
    level thread function_d2e344e9();
    function_80cf986b();
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0xcca647ad, Offset: 0x1010
// Size: 0x4de
function function_8abc06a5() {
    level.var_44ebf6d = 1;
    level flag::wait_till("all_players_spawned");
    level flag::wait_till("zones_initialized");
    while (!isdefined(level.quick_revive_machine) || !isdefined(level.chests)) {
        wait 0.05;
    }
    level.var_47ff1ff7 = [];
    foreach (chest in level.chests) {
        if (chest.zbarrier.state == "initial") {
            if (chest.zbarrier.script_noteworthy == "zone_crash_site_chest_zbarrier") {
                level.var_844a554b[0] = "right";
                level.var_844a554b[1] = "left";
            } else if (chest.zbarrier.script_noteworthy == "zone_ruins_chest_zbarrier") {
                level.var_844a554b[0] = "left";
                level.var_844a554b[1] = "right";
            } else {
                iprintlnbold("ERROR: Magic Box not started in either left nor right side.");
            }
            break;
        }
    }
    level.var_3f48878 = [];
    for (i = 0; i < level.var_844a554b.size; i++) {
        var_b2a1f4eb = "airdrop_" + level.var_844a554b[i];
        level.var_3f48878[i] = struct::get(var_b2a1f4eb, "script_noteworthy");
    }
    var_79578271 = function_d6286636(level.var_3f48878[0].origin);
    var_81d49f84 = function_f2a3ece3("vending_revive");
    if (var_79578271 != var_81d49f84) {
        function_83158efb(var_79578271, var_81d49f84);
    }
    if (level.players.size > 1) {
        var_415d2262 = function_f2a3ece3("vending_jugg");
        function_83158efb(var_81d49f84, var_415d2262);
        var_3aacf417 = struct::get("perk_spot_bunker1");
        level.quick_revive_machine.original_pos = var_3aacf417.origin;
        level.quick_revive_machine.original_angles = var_3aacf417.angles;
    } else {
        level.quick_revive_machine.original_pos = level.var_3f48878[0].origin;
        level.quick_revive_machine.original_angles = level.var_3f48878[0].angles;
    }
    level.var_fd5c770c = [];
    for (i = 0; i < level.var_3f48878.size; i++) {
        level.var_fd5c770c[i] = function_d6286636(level.var_3f48878[i].origin);
        level.var_fd5c770c[i].var_5a70972b = 1;
    }
    for (i = 0; i < level.var_fd5c770c.size; i++) {
        if (level.var_fd5c770c[i].var_f11ace87 === undefined) {
            level.var_fd5c770c[i] function_17f9c5ad(1);
        }
    }
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0xd4c0e729, Offset: 0x14f8
// Size: 0x88
function function_3bccea41() {
    while (level.round_number <= 6) {
        level waittill(#"end_of_round");
        wait 6;
        if (level.round_number == 2) {
            function_233e0157(0);
        }
        if (level.round_number == 6) {
            function_233e0157(1);
        }
    }
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xa4e8a92b, Offset: 0x1588
// Size: 0x36c
function function_233e0157(var_b8cb4c1e) {
    var_3661504c = [];
    var_3661504c["vending_revive"] = "p7_fxanim_zm_island_perk_drop1_revive_bundle";
    var_3661504c["vending_doubletap"] = "p7_fxanim_zm_island_perk_drop1_doubletap_bundle";
    var_3661504c["vending_sleight"] = "p7_fxanim_zm_island_perk_drop1_speed_bundle";
    var_3661504c["vending_marathon"] = "p7_fxanim_zm_island_perk_drop1_stamina_bundle";
    var_3661504c["vending_jugg"] = "p7_fxanim_zm_island_perk_drop1_jug_bundle";
    var_e2093f63 = [];
    var_e2093f63["vending_revive"] = "p7_fxanim_zm_island_perk_drop2_revive_bundle";
    var_e2093f63["vending_doubletap"] = "p7_fxanim_zm_island_perk_drop2_doubletap_bundle";
    var_e2093f63["vending_sleight"] = "p7_fxanim_zm_island_perk_drop2_speed_bundle";
    var_e2093f63["vending_marathon"] = "p7_fxanim_zm_island_perk_drop2_stamina_bundle";
    var_e2093f63["vending_jugg"] = "p7_fxanim_zm_island_perk_drop2_jug_bundle";
    var_f9e9760b = [];
    var_f9e9760b["left"] = "fxanim_perk_drop1_b17";
    var_f9e9760b["right"] = "fxanim_perk_drop2_b17";
    level.var_5697feca = level.var_844a554b[var_b8cb4c1e];
    if (level.var_5697feca == "left") {
        level.var_e9331fab = "fxanim_perk_drop1_b17";
        var_9419d2c4 = var_3661504c;
    } else {
        level.var_e9331fab = "fxanim_perk_drop2_b17";
        var_9419d2c4 = var_e2093f63;
    }
    var_c9340b8 = level.var_fd5c770c[var_b8cb4c1e];
    var_3df944fc = var_9419d2c4[var_c9340b8.target];
    level.var_58f37cc3 = var_c9340b8.machine;
    scene::add_scene_func(var_3df944fc, &function_3c8f18a8, "play");
    scene::add_scene_func(var_3df944fc, &function_89159ff6, "done");
    level thread scene::play(var_3df944fc);
    level waittill(#"hash_7c6b5254");
    level.var_58f37cc3 unlink();
    level.var_fd5c770c[var_b8cb4c1e] function_17f9c5ad(0);
    if (var_c9340b8.target === "vending_revive" && level.players.size == 1) {
        var_c9340b8 function_37ca6cbb(1);
        var_c9340b8.machine playsound("evt_perk_poweron");
        return;
    }
    var_c9340b8 function_c14f3d0d(level.var_3f48878[var_b8cb4c1e].var_7cc697d0);
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xf3cca0e, Offset: 0x1900
// Size: 0x26c
function function_3c8f18a8(a_ents) {
    var_100583a4 = a_ents["vending_links"];
    var_c739e142 = [];
    var_c739e142["vending_doubletap"] = "link_doubletap_jnt";
    var_c739e142["vending_jugg"] = "link_jugg_jnt";
    var_c739e142["vending_revive"] = "link_revive_jnt";
    var_c739e142["vending_sleight"] = "link_sleight_jnt";
    var_c739e142["vending_marathon"] = "link_marathon_jnt";
    if (isdefined(level.var_58f37cc3)) {
        str_tag = var_c739e142[level.var_58f37cc3.targetname];
        level.var_58f37cc3.origin = var_100583a4 gettagorigin(str_tag);
        level.var_58f37cc3.angles = var_100583a4 gettagangles(str_tag);
        level.var_58f37cc3 show();
        level.var_58f37cc3 linkto(var_100583a4, str_tag);
    }
    var_c3f519a9 = a_ents["airdrop_plane"];
    var_c5f81ff5 = var_c3f519a9 gettagorigin("tag_engine_inner_left");
    var_4bde0ff5 = var_c3f519a9 gettagangles("tag_engine_inner_left");
    var_503f61aa = util::spawn_model("tag_origin", var_c5f81ff5, var_4bde0ff5);
    var_503f61aa linkto(var_c3f519a9);
    var_503f61aa thread vehicle_rumble(0, 2);
    wait 20;
    var_503f61aa notify(#"rumble_stop");
    var_503f61aa delete();
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0x2918a157, Offset: 0x1b78
// Size: 0x8c
function function_89159ff6(a_ents) {
    if (isdefined(a_ents["airdrop_plane"])) {
        a_ents["airdrop_plane"] delete();
    }
    var_c3f519a9 = getent("airdrop_plane", "targetname");
    if (isdefined(var_c3f519a9)) {
        var_c3f519a9 delete();
    }
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0xf165955d, Offset: 0x1c10
// Size: 0x13a
function function_d2e344e9() {
    while (!level flag::exists("power_on" + 4)) {
        wait 0.1;
    }
    foreach (var_f184b6b4 in level.var_961b3545) {
        if (var_f184b6b4.target !== "vending_revive" && !(isdefined(var_f184b6b4.var_5a70972b) && var_f184b6b4.var_5a70972b)) {
            var_7ec79867 = arraygetclosest(var_f184b6b4.origin, level.var_c54e133);
            var_f184b6b4 thread function_c14f3d0d(var_7ec79867.var_7cc697d0);
        }
    }
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0x6642c445, Offset: 0x1d58
// Size: 0x16c
function function_c14f3d0d(var_efa86ccd) {
    if (!isdefined(self.script_int)) {
        self.script_int = var_efa86ccd;
        foreach (var_49c78343 in level.powered_items) {
            if (self === var_49c78343.target) {
                powered_perk = var_49c78343;
                break;
            }
        }
        if (isdefined(powered_perk)) {
            powered_perk thread zm_power::zone_controlled_perk(self.script_int);
            str_power = "power_on" + var_efa86ccd;
            if (level flag::get(str_power)) {
                self function_37ca6cbb(1);
                self playsound("evt_perk_poweron");
            }
            return;
        }
        iprintlnbold("perk not found in level.powered_items");
    }
}

// Namespace zm_island_perks
// Params 3, eflags: 0x0
// Checksum 0xb1260446, Offset: 0x1ed0
// Size: 0x16c
function function_235019b6(var_c335265b, n_speed, n_acceleration) {
    if (!isdefined(n_speed)) {
        n_speed = 35;
    }
    if (!isdefined(n_acceleration)) {
        n_acceleration = 100;
    }
    var_9a17836d = var_c335265b + "_end";
    self endon(#"death");
    nd_start = getvehiclenode(self.target, "targetname");
    self attachpath(nd_start);
    if (isdefined(n_speed)) {
        if (!isdefined(n_acceleration)) {
            self setspeed(n_speed);
        } else {
            self setspeed(n_speed, n_acceleration);
        }
    }
    self startpath();
    self thread vehicle_rumble();
    self waittill(#"reached_end_node");
    self notify(var_9a17836d);
    self notify(#"rumble_stop");
    self delete();
}

// Namespace zm_island_perks
// Params 2, eflags: 0x0
// Checksum 0xfd2aa83c, Offset: 0x2048
// Size: 0xdc
function vehicle_rumble(var_6dc777dc, b_delay) {
    if (!isdefined(var_6dc777dc)) {
        var_6dc777dc = 1;
    }
    if (!isdefined(b_delay)) {
        b_delay = 0;
    }
    self endon(#"rumble_stop");
    var_8e09e52a = 0;
    if (isdefined(var_6dc777dc) && var_6dc777dc) {
        level flag::wait_till("flag_plane_start_rumble");
    }
    if (b_delay > 0) {
        wait b_delay;
    }
    while (isdefined(self) && var_8e09e52a < 1) {
        self playrumbleonentity("zm_island_plane_rumble");
        wait 20;
        var_8e09e52a++;
    }
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xec2d0948, Offset: 0x2130
// Size: 0x3c
function function_afa51c0f(e_who) {
    self thread function_ed4dd4e3(e_who);
    self thread function_12b8ab88(e_who);
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0xe699d504, Offset: 0x2178
// Size: 0x432
function function_f9d235ed() {
    level.var_fed21619 = [];
    for (i = 0; i < 2; i++) {
        var_f45b435c = "s_webbing" + i;
        var_284427db = "destructible_webbing" + i;
        var_7716d15a = "t_webbing_extra_damage" + i;
        level.var_fed21619[i] = struct::get(var_f45b435c, "targetname");
        level.var_fed21619[i].e_destructible = getent(var_284427db, "targetname");
        level.var_fed21619[i].e_destructible.var_7117876c = level.var_fed21619[i].e_destructible.origin;
        level.var_fed21619[i].e_destructible.var_380861c6 = level.var_fed21619[i].e_destructible.angles;
        level.var_fed21619[i].e_destructible.var_c780fb80 = level.var_fed21619[i].e_destructible.var_7117876c - (0, 0, 256);
        level.var_fed21619[i].e_destructible.var_401e166a = level.var_fed21619[i].e_destructible.angles;
        level.var_fed21619[i].e_destructible setcandamage(1);
        level.var_fed21619[i].e_destructible clientfield::set("web_fade_material", 0.5);
        level.var_fed21619[i].var_ae94a833 = &function_4680ee05;
        level.var_fed21619[i].t_webbing_extra_damage = getent(var_7716d15a, "targetname");
        if (isdefined(level.var_fed21619[i].t_webbing_extra_damage)) {
            var_7872c6f9 = level.var_fed21619[i].t_webbing_extra_damage;
            var_7872c6f9.e_destructible = level.var_fed21619[i].e_destructible;
            var_7872c6f9.var_1c12769f = struct::get(var_7872c6f9.target, "targetname");
            var_7872c6f9.var_f83345c7 = 1;
            var_7872c6f9.var_20cd3c71 = i;
            var_7872c6f9 thread function_1ec3c42a();
        }
        level.var_fed21619[i] function_869d004a(0);
        level.var_fed21619[i] function_e8e25ea9();
        level.var_fed21619[i].var_20cd3c71 = i;
        level.var_fed21619[i].e_destructible.var_20cd3c71 = i;
        level.var_fed21619[i].s_unitrigger.var_20cd3c71 = i;
    }
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0xc79deaca, Offset: 0x25b8
// Size: 0x88
function function_1ec3c42a() {
    self endon(#"death");
    while (!isdefined(level.var_d3b40681)) {
        wait 1;
    }
    array::add(level.var_d3b40681, self);
    while (true) {
        self waittill(#"web_torn");
        if (self.var_f83345c7) {
            level.var_fed21619[self.var_20cd3c71] thread function_4680ee05();
        }
    }
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xf6381ab1, Offset: 0x2648
// Size: 0x84
function function_4680ee05(e_player) {
    self function_749646f5(e_player);
    level waittill(#"hash_9c49b4a8");
    do {
        var_340c2125 = zm_ai_spiders::function_f67965ad(self.origin);
        wait 2;
    } while (!(isdefined(var_340c2125) && var_340c2125));
    self function_660e6649();
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0xe42080a5, Offset: 0x26d8
// Size: 0x114
function function_660e6649() {
    if (isdefined(self.t_webbing_extra_damage.var_1c12769f)) {
        var_fde3dbd8 = self.t_webbing_extra_damage.var_1c12769f.origin;
        var_e1a86b86 = self.t_webbing_extra_damage.var_1c12769f.angles;
        self.t_webbing_extra_damage thread fx::play("spider_web_perk_machine_reweb", var_fde3dbd8, var_fde3dbd8);
    }
    self.e_destructible show();
    self.e_destructible solid();
    self.t_webbing_extra_damage.var_f83345c7 = 1;
    zm_unitrigger::register_static_unitrigger(self.s_unitrigger, &zm_ai_spiders::function_c915f7a9);
    self function_869d004a(0);
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xfbcab1e9, Offset: 0x27f8
// Size: 0xc4
function function_749646f5(e_player) {
    zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
    self.e_destructible notsolid();
    self.e_destructible hide();
    self.t_webbing_extra_damage notify(#"web_torn");
    self.t_webbing_extra_damage.var_f83345c7 = 0;
    if (zm_utility::is_player_valid(e_player)) {
        e_player zm_ai_spiders::function_20915a1a();
    }
    self function_869d004a(1);
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xc700fccd, Offset: 0x28c8
// Size: 0x7c
function function_869d004a(b_enable) {
    var_9b28ee1d = getentarray("zombie_vending", "targetname");
    var_e6579eb2 = arraygetclosest(self.origin, var_9b28ee1d);
    var_e6579eb2 triggerenable(b_enable);
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0x84f32bdf, Offset: 0x2950
// Size: 0x54
function function_6cda4851(e_player) {
    var_77f9de0d = arraygetclosest(self.origin, level.var_fed21619);
    var_77f9de0d function_4680ee05(e_player);
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0x49c0b712, Offset: 0x29b0
// Size: 0x18c
function function_e8e25ea9() {
    if (!isdefined(self.s_unitrigger)) {
        s_unitrigger = spawnstruct();
    } else {
        s_unitrigger = self.s_unitrigger;
    }
    s_unitrigger.origin = self.origin;
    s_unitrigger.angles = self.angles;
    s_unitrigger.script_unitrigger_type = "unitrigger_box_use";
    s_unitrigger.cursor_hint = "HINT_NOICON";
    s_unitrigger.require_look_at = 0;
    s_unitrigger.var_a6a648f0 = self.t_webbing_extra_damage;
    s_unitrigger.related_parent = self;
    s_unitrigger.script_width = -126;
    s_unitrigger.script_length = -126;
    s_unitrigger.script_height = 100;
    s_unitrigger.prompt_and_visibility_func = &zm_ai_spiders::function_e433eb78;
    self.s_unitrigger = s_unitrigger;
    self.s_unitrigger.var_20cd3c71 = self.var_20cd3c71;
    self.b_occupied = 0;
    self.b_destroyed = 0;
    self.n_hits = 0;
    zm_unitrigger::register_static_unitrigger(self.s_unitrigger, &zm_ai_spiders::function_c915f7a9);
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xd4765065, Offset: 0x2b48
// Size: 0x120
function function_9b238648(player) {
    var_77f9de0d = arraygetclosest(player.origin, level.var_fed21619);
    if (!player zm_utility::is_player_looking_at(var_77f9de0d.e_destructible.origin, 0.4, 0)) {
        self sethintstring("");
        return 0;
    }
    if (!isdefined(var_77f9de0d.b_occupied) || !(isdefined(var_77f9de0d.b_occupied) && var_77f9de0d.b_occupied)) {
        self sethintstring(%ZM_ISLAND_TEAR_WEB);
        return 1;
    }
    self sethintstring("");
    return 0;
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0x294edb8, Offset: 0x2c70
// Size: 0x110
function function_54db2b79() {
    while (true) {
        for (b_done = 0; !(isdefined(b_done) && b_done); b_done = self function_647fcf70(e_who)) {
            self waittill(#"trigger", e_who);
            if (!zm_utility::is_player_valid(e_who)) {
                continue;
            }
            if (e_who zm_utility::in_revive_trigger()) {
                continue;
            }
            if (e_who.is_drinking > 0) {
                continue;
            }
            if (isdefined(self.related_parent)) {
                self.related_parent notify(#"trigger_activated", e_who);
            }
            if (!isdefined(e_who.usebar)) {
            }
        }
        self thread function_6cda4851(e_who);
    }
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xafd5fd81, Offset: 0x2d88
// Size: 0xf0
function function_647fcf70(player) {
    player.var_77f9de0d = arraygetclosest(player.origin, level.var_fed21619);
    player.var_77f9de0d.b_occupied = 1;
    self thread function_ed4dd4e3(player);
    self thread function_12b8ab88(player);
    var_a7579b72 = self util::waittill_any_return("webtear_succeed", "webtear_failed");
    player.var_77f9de0d.b_occupied = 0;
    if (var_a7579b72 == "webtear_succeed") {
        return true;
    }
    return false;
}

// Namespace zm_island_perks
// Params 2, eflags: 0x0
// Checksum 0xc00f8ecb, Offset: 0x2e80
// Size: 0x534
function function_12b8ab88(player, var_41b6c34b) {
    if (!isdefined(var_41b6c34b)) {
        var_41b6c34b = 2;
    }
    var_a6a648f0 = self.stub.var_a6a648f0;
    wait 0.01;
    if (!isdefined(self)) {
        if (isdefined(var_a6a648f0.var_160abeb7)) {
            var_a6a648f0.var_160abeb7 zm_ai_spiders::function_9b41e249(0);
        }
        if (isdefined(player.var_652fc581)) {
            player.var_652fc581 delete();
            player.var_652fc581 = undefined;
        }
        return;
    }
    w_bowie_knife = getweapon("bowie_knife");
    var_43f0e707 = getweapon("bowie_knife_widows_wine");
    var_1e74f559 = player hasweapon(w_bowie_knife) || player hasweapon(var_43f0e707);
    if (var_1e74f559) {
        var_41b6c34b /= 2;
    }
    var_41b6c34b = int(var_41b6c34b * 1000);
    self.var_41b6c34b = var_41b6c34b;
    self.var_57d3f07b = self.var_41b6c34b;
    self.var_21104f30 = gettime();
    var_57d3f07b = self.var_57d3f07b;
    var_21104f30 = self.var_21104f30;
    var_c6160fd4 = self.var_21104f30 + self.var_57d3f07b;
    if (var_57d3f07b > 0) {
        player zm_utility::disable_player_move_states(1);
        player zm_utility::increment_is_drinking();
        var_48baa69f = player getcurrentweapon();
        var_352c1778 = getweapon("zombie_spider_web_tear");
        player giveweapon(var_352c1778);
        util::wait_network_frame();
        player switchtoweapon(var_352c1778);
        player thread function_a0c0f437(var_21104f30, var_57d3f07b);
        while (isdefined(self) && player function_afb24eeb(self) && gettime() < var_c6160fd4) {
            wait 0.05;
        }
        player notify(#"hash_bd5f338b");
        if (isdefined(var_48baa69f)) {
            player switchtoweapon(var_48baa69f);
        }
        if (isdefined(var_352c1778)) {
            player takeweapon(var_352c1778);
        }
        if (isdefined(player.is_drinking) && player.is_drinking) {
            player zm_utility::decrement_is_drinking();
        }
        player zm_utility::enable_player_move_states();
    }
    if (isdefined(player.var_6adb8298)) {
        player.var_6adb8298 hud::destroyelem();
    }
    if (isdefined(player.usebar)) {
        player.usebar hud::destroyelem();
    }
    if (isdefined(self) && player function_afb24eeb(self) && self.var_57d3f07b <= 0 || gettime() >= var_c6160fd4) {
        self notify(#"webtear_succeed");
        if (var_1e74f559) {
            player.var_f795ee17 = 1;
        }
        return;
    }
    if (isdefined(player.var_652fc581)) {
        player.var_652fc581 delete();
        player.var_652fc581 = undefined;
    }
    if (isdefined(self)) {
        self notify(#"webtear_failed");
        return;
    }
    if (isdefined(var_a6a648f0.var_160abeb7)) {
        var_a6a648f0.var_160abeb7 zm_ai_spiders::function_9b41e249(0);
    }
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xc60856e4, Offset: 0x33c0
// Size: 0x11c
function function_afb24eeb(s_unitrigger) {
    if (self laststand::player_is_in_laststand() || self zm_laststand::is_reviving_any()) {
        return false;
    }
    if (!self usebuttonpressed()) {
        return false;
    }
    if (!self zm_utility::is_player_looking_at(self.var_77f9de0d.e_destructible.origin, 0.4, 0)) {
        return false;
    }
    if (isdefined(s_unitrigger.stub.origin) && isdefined(s_unitrigger.stub.radius)) {
        if (distance(self.origin, s_unitrigger.stub.origin) > s_unitrigger.stub.radius) {
            return false;
        }
    }
    return true;
}

// Namespace zm_island_perks
// Params 2, eflags: 0x0
// Checksum 0xcf33a882, Offset: 0x34e8
// Size: 0xd0
function function_2f6a6dcd(n_start_time, var_ddb12d5c) {
    self endon(#"entering_last_stand");
    self endon(#"death");
    self endon(#"disconnect");
    self endon(#"hash_bd5f338b");
    while (isdefined(self) && gettime() - n_start_time < var_ddb12d5c) {
        n_progress = (gettime() - n_start_time) / var_ddb12d5c;
        if (n_progress < 0) {
            n_progress = 0;
        }
        if (n_progress > 1) {
            n_progress = 1;
        }
        self.usebar hud::updatebar(n_progress);
        wait 0.05;
    }
}

// Namespace zm_island_perks
// Params 2, eflags: 0x0
// Checksum 0x223ec67c, Offset: 0x35c0
// Size: 0x14c
function function_a0c0f437(start_time, var_8aa1e537) {
    if (isdefined(self.var_6adb8298)) {
        self.var_6adb8298 hud::destroyelem();
    }
    if (isdefined(self.usebar)) {
        self.usebar hud::destroyelem();
    }
    self.usebar = self hud::createprimaryprogressbar();
    self.var_6adb8298 = self hud::createprimaryprogressbartext();
    self.var_6adb8298 settext(%ZM_ISLAND_TEARING_WEB);
    if (isdefined(self) && isdefined(start_time) && isdefined(var_8aa1e537)) {
        self function_2f6a6dcd(start_time, var_8aa1e537);
    }
    if (isdefined(self.var_6adb8298)) {
        self.var_6adb8298 hud::destroyelem();
    }
    if (isdefined(self.usebar)) {
        self.usebar hud::destroyelem();
    }
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xdcdd9044, Offset: 0x3718
// Size: 0x98
function function_ed4dd4e3(player) {
    self endon(#"kill_trigger");
    self endon(#"webtear_succeed");
    self endon(#"webtear_failed");
    self endon(#"hash_bd5f338b");
    while (true) {
        playfx(level._effect["building_dust"], player getplayercamerapos(), player.angles);
        wait 0.5;
    }
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xe62eb1be, Offset: 0x37b8
// Size: 0xbc
function function_37ca6cbb(var_5eeae9f2) {
    if (!isdefined(var_5eeae9f2)) {
        var_5eeae9f2 = 0;
    }
    var_c12b618 = self.target;
    a_str_keys = strtok(var_c12b618, "_");
    if (isdefined(var_5eeae9f2) && var_5eeae9f2) {
        function_1957d78d(a_str_keys[1], 1);
        wait 0.1;
    }
    function_1957d78d(a_str_keys[1]);
}

// Namespace zm_island_perks
// Params 2, eflags: 0x0
// Checksum 0x5aed1539, Offset: 0x3880
// Size: 0xae
function function_1957d78d(str_perk, b_off) {
    if (!isdefined(b_off)) {
        b_off = 0;
    }
    if (!(isdefined(b_off) && b_off)) {
        str_msg = str_perk + "_on";
        var_e3e6c76a = str_perk + "_power_on";
    } else {
        str_msg = str_perk + "_off";
        var_e3e6c76a = str_perk + "_power_off";
    }
    level notify(str_msg);
    level notify(var_e3e6c76a);
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xfcfea481, Offset: 0x3938
// Size: 0x40
function function_d6286636(v_pos) {
    var_b70d1559 = arraysortclosest(level.var_961b3545, v_pos);
    return var_b70d1559[0];
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xd2fb7416, Offset: 0x3980
// Size: 0xb4
function function_f2a3ece3(str_type) {
    var_1ed8ce62 = undefined;
    foreach (vending in level.var_961b3545) {
        if (vending.target == str_type) {
            var_1ed8ce62 = vending;
            break;
        }
    }
    return var_1ed8ce62;
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0x66d3986e, Offset: 0x3a40
// Size: 0xb4
function function_122682ad(b_visible) {
    if (!b_visible) {
        self.machine hide();
        self.clip hide();
    } else {
        self.machine show();
        self.clip show();
    }
    self.bump triggerenable(b_visible);
    self triggerenable(b_visible);
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0xe0863708, Offset: 0x3b00
// Size: 0x168
function function_17f9c5ad(var_861443b0) {
    if (!isdefined(var_861443b0)) {
        var_861443b0 = 1;
    }
    if (var_861443b0) {
        assert(!isdefined(self.var_f11ace87), "<dev string:x28>");
        self.var_f11ace87 = self.origin;
        self.var_d7ae6fe9 = self.machine.angles;
        s_bury_loc = struct::get("s_bury_loc", "targetname");
        var_382a4db = s_bury_loc.origin;
        self function_4ecb5bf5(var_382a4db, self.var_d7ae6fe9);
        self.var_f391d884 = 1;
        return;
    }
    assert(isdefined(self.var_f11ace87), "<dev string:x5b>");
    self function_4ecb5bf5(self.var_f11ace87, self.var_d7ae6fe9);
    self.var_f11ace87 = undefined;
    self.var_d7ae6fe9 = undefined;
    self.var_f391d884 = 0;
}

// Namespace zm_island_perks
// Params 3, eflags: 0x0
// Checksum 0x299db956, Offset: 0x3c70
// Size: 0x184
function function_4ecb5bf5(v_loc, v_angles, var_352943cd) {
    if (!isdefined(var_352943cd)) {
        var_352943cd = 1;
    }
    if (var_352943cd) {
        self.origin = v_loc;
        self.clip.origin = v_loc - (0, 0, 60);
        self.machine.origin = v_loc - (0, 0, 60);
        self.bump.origin = v_loc - (0, 0, 30);
    } else {
        self.origin = v_loc + (0, 0, 60);
        self.clip.origin = v_loc + (0, 0, 60);
        self.machine.origin = v_loc - (0, 0, 60);
        self.bump.origin = v_loc - (0, 0, 30);
    }
    self.angles = v_angles;
    self.machine.angles = v_angles;
    self.clip.angles = v_angles;
    self.bump.angles = v_angles;
}

// Namespace zm_island_perks
// Params 2, eflags: 0x0
// Checksum 0x220e6ea2, Offset: 0x3e00
// Size: 0x214
function function_83158efb(var_220103b4, var_940872ef) {
    var_1f0a690d = var_220103b4.origin;
    var_6dcfdccd = var_220103b4.machine.angles;
    var_458c6947 = var_220103b4.machine.origin;
    var_ce7a742f = var_220103b4.machine.angles;
    var_f84a1658 = var_220103b4.clip.origin;
    var_3dd86ca2 = var_220103b4.clip.angles;
    var_e089f21a = var_220103b4.bump.origin;
    var_2e5bdafc = var_220103b4.bump.angles;
    var_220103b4 function_dd961efc(var_940872ef.origin, var_940872ef.machine.origin, var_940872ef.clip.origin, var_940872ef.bump.origin, var_940872ef.angles, var_940872ef.machine.angles, var_940872ef.clip.angles, var_940872ef.bump.angles);
    var_940872ef function_dd961efc(var_1f0a690d, var_458c6947, var_f84a1658, var_e089f21a, var_6dcfdccd, var_ce7a742f, var_3dd86ca2, var_2e5bdafc);
    wait 0.1;
}

// Namespace zm_island_perks
// Params 8, eflags: 0x0
// Checksum 0x7de51f8c, Offset: 0x4020
// Size: 0xd4
function function_dd961efc(var_34b28fe3, var_b6584494, var_6c749069, var_e03f87ff, var_b483c937, var_ebd3afa, var_65ff7c3d, var_9fbc3dab) {
    self.origin = var_34b28fe3;
    self.angles = var_b483c937;
    self.machine.origin = var_b6584494;
    self.machine.angles = var_ebd3afa;
    self.clip.origin = var_6c749069;
    self.clip.angles = var_65ff7c3d;
    self.bump.origin = var_e03f87ff;
    self.bump.angles = var_9fbc3dab;
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0xd68824c0, Offset: 0x4100
// Size: 0x34
function function_5508b348() {
    level thread function_90a782bd("revive", "vending_revive", "perk_light_quick_revive");
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0x97441058, Offset: 0x4140
// Size: 0x34
function function_55b919e6() {
    level thread function_90a782bd("marathon", "vending_marathon", "perk_light_staminup");
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0x74c3158b, Offset: 0x4180
// Size: 0x34
function function_e840e164() {
    level thread function_90a782bd("sleight", "vending_sleight", "perk_light_speed_cola");
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0x96e09eb, Offset: 0x41c0
// Size: 0x34
function function_8b929f79() {
    level thread function_90a782bd("doubletap", "vending_doubletap", "perk_light_doubletap");
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0x2294eb82, Offset: 0x4200
// Size: 0x34
function function_588068b3() {
    level thread function_90a782bd("juggernog", "vending_jugg", "perk_light_juggernog");
}

// Namespace zm_island_perks
// Params 3, eflags: 0x0
// Checksum 0xbeefd6d2, Offset: 0x4240
// Size: 0xc8
function function_90a782bd(var_aa9ee7dd, var_6a2f816c, var_c16251e2) {
    var_95ac3b8c = var_aa9ee7dd + "_on";
    var_a7367b5a = var_aa9ee7dd + "_off";
    while (true) {
        level util::waittill_any(var_95ac3b8c, "power_on");
        function_4f44d932(var_6a2f816c, var_c16251e2, "on");
        level waittill(var_a7367b5a);
        function_4f44d932(var_6a2f816c, var_c16251e2, "off");
    }
}

// Namespace zm_island_perks
// Params 1, eflags: 0x0
// Checksum 0x231ac552, Offset: 0x4310
// Size: 0x9c
function function_53fbb551(v_pos) {
    if (!isdefined(level.var_e115ec55)) {
        level.var_c54e133 = struct::get_array("perk_random_machine_location", "targetname");
        level.var_c54e133[level.var_c54e133.size] = struct::get("vending_loc_bunker");
    }
    var_7ec79867 = arraygetclosest(v_pos, level.var_c54e133);
    return var_7ec79867;
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0xa09b0ff7, Offset: 0x43b8
// Size: 0x242
function function_80cf986b() {
    foreach (var_48b5604f in level.var_fed21619) {
        var_e6579eb2 = arraygetclosest(var_48b5604f.origin, level.var_961b3545);
        switch (var_e6579eb2.script_noteworthy) {
        case "specialty_doubletap2":
            var_48b5604f.e_destructible setmodel("p7_zm_isl_web_vending_doubletap2");
            break;
        case "specialty_quickrevive":
            var_48b5604f.e_destructible setmodel("p7_zm_isl_web_vending_revive");
            break;
        case "specialty_fastreload":
            var_48b5604f.e_destructible setmodel("p7_zm_isl_web_vending_sleight");
            break;
        case "specialty_staminup":
            var_48b5604f.e_destructible setmodel("p7_zm_isl_web_vending_marathon");
            break;
        case "specialty_armorvest":
            var_48b5604f.e_destructible setmodel("p7_zm_isl_web_vending_jugg");
            break;
        case "specialty_additionalprimaryweapon":
            var_48b5604f.e_destructible setmodel("p7_zm_isl_web_vending_three_gun");
        default:
            break;
        }
        var_48b5604f.e_destructible.origin = var_e6579eb2.machine.origin;
        var_48b5604f.e_destructible.angles = var_e6579eb2.machine.angles;
    }
}

// Namespace zm_island_perks
// Params 3, eflags: 0x0
// Checksum 0x93388a8e, Offset: 0x4608
// Size: 0x124
function function_4f44d932(var_6a2f816c, str_clientfield, var_96296bd9) {
    if (!isdefined(var_96296bd9)) {
        var_96296bd9 = "on";
    }
    var_8bcf7b93 = function_f2a3ece3(var_6a2f816c);
    var_7ec79867 = arraygetclosest(var_8bcf7b93.machine.origin, level.var_c54e133);
    if (var_96296bd9 == "on") {
        clientfield::set(str_clientfield, var_7ec79867.script_index);
        var_8bcf7b93 function_5c8137e6(var_6a2f816c, 1);
        return;
    }
    clientfield::set(str_clientfield, 0);
    var_8bcf7b93 function_5c8137e6(var_6a2f816c, 0);
}

// Namespace zm_island_perks
// Params 2, eflags: 0x0
// Checksum 0x370abeb, Offset: 0x4738
// Size: 0x104
function function_5c8137e6(var_6a2f816c, b_on) {
    if (!isdefined(b_on)) {
        b_on = 1;
    }
    if (isdefined(b_on) && b_on) {
        if (!isdefined(self.var_3966775a)) {
            self.var_3966775a = util::spawn_model("tag_origin", self.origin);
            str_fx = "islandfx_" + var_6a2f816c;
            self.var_3966775a linkto(self);
            playfxontag(level._effect[str_fx], self.var_3966775a, "tag_origin");
        }
        return;
    }
    if (isdefined(self.var_3966775a)) {
        self.var_3966775a delete();
    }
}

// Namespace zm_island_perks
// Params 0, eflags: 0x0
// Checksum 0x80693a04, Offset: 0x4848
// Size: 0x74
function function_6753e7bb() {
    level waittill(#"hash_62ee2b14");
    clientfield::set("perk_light_mule_kick", 1);
    var_8bcf7b93 = function_f2a3ece3("vending_additionalprimaryweapon");
    var_8bcf7b93 function_5c8137e6("vending_additionalprimaryweapon", 1);
}

