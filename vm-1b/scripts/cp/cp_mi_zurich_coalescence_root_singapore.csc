#using scripts/codescripts/struct;
#using scripts/cp/cp_mi_zurich_coalescence_util;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/math_shared;
#using scripts/shared/scene_shared;
#using scripts/shared/util_shared;

#namespace root_singapore;

// Namespace root_singapore
// Params 0, eflags: 0x0
// Checksum 0xdb25adf6, Offset: 0x4d0
// Size: 0x43
function main() {
    init_clientfields();
    level._effect["green_light"] = "light/fx_light_depth_charge_inactive";
    level._effect["yellow_light"] = "light/fx_light_depth_charge_warning";
}

// Namespace root_singapore
// Params 0, eflags: 0x0
// Checksum 0x979b2a5a, Offset: 0x520
// Size: 0xaa
function init_clientfields() {
    clientfield::register("scriptmover", "sm_depth_charge_fx", 1, 1, "int", &function_21197c95, 0, 0);
    clientfield::register("scriptmover", "water_disturbance", 1, 1, "int", &water_disturbance, 0, 0);
    clientfield::register("toplayer", "umbra_tome_singapore", 1, 1, "counter", &umbra_tome_singapore, 0, 0);
}

// Namespace root_singapore
// Params 2, eflags: 0x0
// Checksum 0x13748bef, Offset: 0x5d8
// Size: 0x9a
function function_5bcd68f2(str_objective, var_74cd64bc) {
    level thread function_5f80268d();
    level thread function_b087f50();
    level thread function_69ec3f06();
    level thread function_320f5638();
    level thread function_a9bc976();
    setwavewaterenabled("sing_water", 1);
    level thread scene::play("root_singapore_shutters", "targetname");
}

// Namespace root_singapore
// Params 2, eflags: 0x0
// Checksum 0xd5203c65, Offset: 0x680
// Size: 0x4a
function function_95b88092(str_objective, var_74cd64bc) {
    if (var_74cd64bc) {
        level thread function_5f80268d();
        level thread function_b087f50();
        level thread function_69ec3f06();
    }
}

// Namespace root_singapore
// Params 2, eflags: 0x0
// Checksum 0x8cad41d4, Offset: 0x6d8
// Size: 0x122
function skipto_end(str_objective, var_74cd64bc) {
    level thread scene::stop("root_singapore_shutters", "targetname");
    setwavewaterenabled("sing_water", 0);
    level thread scene::stop("cin_zur_16_02_singapore_vign_bodies01");
    level thread scene::stop("cin_zur_16_02_singapore_vign_bodies02");
    level thread scene::stop("cin_zur_16_02_singapore_vign_bodies03");
    level thread scene::stop("cin_zur_16_02_singapore_vign_pulled01");
    level thread scene::stop("cin_zur_16_02_singapore_vign_pulled02");
    level thread scene::stop("cin_zur_16_02_singapore_vign_pulled03");
    level thread scene::stop("cin_zur_16_02_singapore_hanging_shortrope");
    level thread scene::stop("cin_zur_16_02_singapore_hanging_shortrope_2");
    level notify(#"root_singapore_cleanup");
    level thread zurich_util::function_3bf27f88(str_objective);
}

// Namespace root_singapore
// Params 7, eflags: 0x0
// Checksum 0xc1df4434, Offset: 0x808
// Size: 0x52
function umbra_tome_singapore(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump) {
    umbra_settometrigger(localclientnum, "");
}

// Namespace root_singapore
// Params 0, eflags: 0x0
// Checksum 0xe21d73bd, Offset: 0x868
// Size: 0x312
function function_5f80268d() {
    scene::add_scene_func("p7_fxanim_cp_zurich_roots_water01_bundle", &zurich_util::function_4dd02a03, "done", "root_singapore_cleanup");
    scene::add_scene_func("p7_fxanim_cp_zurich_roots_water02_bundle", &zurich_util::function_4dd02a03, "done", "root_singapore_cleanup");
    scene::add_scene_func("p7_fxanim_gp_shutter_lt_02_red_bundle", &zurich_util::function_4dd02a03, "done", "root_singapore_cleanup");
    scene::add_scene_func("p7_fxanim_gp_shutter_rt_02_red_bundle", &zurich_util::function_4dd02a03, "done", "root_singapore_cleanup");
    scene::add_scene_func("p7_fxanim_gp_shutter_lt_10_red_white_bundle", &zurich_util::function_4dd02a03, "done", "root_singapore_cleanup");
    scene::add_scene_func("p7_fxanim_gp_shutter_rt_10_red_white_bundle", &zurich_util::function_4dd02a03, "done", "root_singapore_cleanup");
    scene::add_scene_func("cin_zur_16_02_singapore_vign_bodies01", &zurich_util::function_4dd02a03, "play", "root_singapore_cleanup");
    scene::add_scene_func("cin_zur_16_02_singapore_vign_bodies02", &zurich_util::function_4dd02a03, "play", "root_singapore_cleanup");
    scene::add_scene_func("cin_zur_16_02_singapore_vign_bodies03", &zurich_util::function_4dd02a03, "play", "root_singapore_cleanup");
    scene::add_scene_func("cin_zur_16_02_singapore_vign_pulled01", &zurich_util::function_4dd02a03, "play", "root_singapore_cleanup");
    scene::add_scene_func("cin_zur_16_02_singapore_vign_pulled02", &zurich_util::function_4dd02a03, "play", "root_singapore_cleanup");
    scene::add_scene_func("cin_zur_16_02_singapore_vign_pulled03", &zurich_util::function_4dd02a03, "play", "root_singapore_cleanup");
    scene::add_scene_func("cin_zur_16_02_singapore_hanging_shortrope", &zurich_util::function_4dd02a03, "play", "root_singapore_cleanup");
    scene::add_scene_func("cin_zur_16_02_singapore_hanging_shortrope_2", &zurich_util::function_4dd02a03, "play", "root_singapore_cleanup");
}

// Namespace root_singapore
// Params 0, eflags: 0x0
// Checksum 0xc5e1147b, Offset: 0xb88
// Size: 0x6a
function function_b087f50() {
    level thread scene::init("p7_fxanim_cp_zurich_roots_water01_bundle");
    level thread scene::init("p7_fxanim_cp_zurich_roots_water02_bundle");
    wait 2.5;
    level thread scene::play("p7_fxanim_cp_zurich_roots_water01_bundle");
    wait 2;
    level thread scene::play("p7_fxanim_cp_zurich_roots_water02_bundle");
}

// Namespace root_singapore
// Params 0, eflags: 0x0
// Checksum 0x2cbacbd3, Offset: 0xc00
// Size: 0x4a
function function_69ec3f06() {
    level thread scene::play("cin_zur_16_02_singapore_vign_bodies01");
    level thread scene::play("cin_zur_16_02_singapore_vign_bodies02");
    level thread scene::play("cin_zur_16_02_singapore_vign_bodies03");
}

// Namespace root_singapore
// Params 0, eflags: 0x0
// Checksum 0x1d42989c, Offset: 0xc58
// Size: 0x6a
function function_320f5638() {
    level thread scene::play("cin_zur_16_02_singapore_vign_pulled01");
    wait randomfloatrange(2, 5);
    level thread scene::play("cin_zur_16_02_singapore_vign_pulled02");
    wait randomfloatrange(2, 5);
    level thread scene::play("cin_zur_16_02_singapore_vign_pulled03");
}

// Namespace root_singapore
// Params 0, eflags: 0x0
// Checksum 0xc5326e3b, Offset: 0xcd0
// Size: 0x42
function function_a9bc976() {
    level thread scene::play("cin_zur_16_02_singapore_hanging_shortrope");
    wait randomfloatrange(2, 5);
    level thread scene::play("cin_zur_16_02_singapore_hanging_shortrope_2");
}

// Namespace root_singapore
// Params 7, eflags: 0x0
// Checksum 0xd1297380, Offset: 0xd20
// Size: 0x12a
function water_disturbance(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump) {
    if (!isdefined(self.var_2e7c1306)) {
        str_tag = "zur_wave_jnt";
        self.var_2e7c1306 = util::spawn_model(localclientnum, "tag_origin", self gettagorigin(str_tag), self gettagangles(str_tag));
        self.var_2e7c1306 linkto(self, str_tag);
        self.var_2e7c1306 setwaterdisturbanceparams(0.4, 1000, 2500, 1, 0);
    }
    if (newval) {
        self.var_2e7c1306.waterdisturbance = 1;
        return;
    }
    self.var_2e7c1306.waterdisturbance = 0;
    wait 0.016;
    self.var_2e7c1306 delete();
}

// Namespace root_singapore
// Params 7, eflags: 0x0
// Checksum 0x8be7c799, Offset: 0xe58
// Size: 0xed
function function_21197c95(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump) {
    if (isdefined(self.light_fx)) {
        stopfx(localclientnum, self.light_fx);
        self.light_fx = undefined;
    }
    switch (newval) {
    case 0:
        self.light_fx = playfxontag(localclientnum, level._effect["yellow_light"], self, "tag_origin");
        break;
    case 1:
        self.light_fx = playfxontag(localclientnum, level._effect["green_light"], self, "tag_origin");
        break;
    }
}

