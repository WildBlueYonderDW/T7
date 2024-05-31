#using scripts/zm/zm_genesis_undercroft_low_grav;
#using scripts/zm/zm_genesis_timer;
#using scripts/zm/zm_genesis_wearables;
#using scripts/zm/zm_genesis_wasp;
#using scripts/zm/zm_genesis_traps;
#using scripts/zm/zm_genesis_spiders;
#using scripts/zm/zm_genesis_sound;
#using scripts/zm/zm_genesis_skull_turret;
#using scripts/zm/zm_genesis_shadowman;
#using scripts/zm/zm_genesis_power;
#using scripts/zm/zm_genesis_portals;
#using scripts/zm/zm_genesis_wisps;
#using scripts/zm/zm_genesis_minor_ee;
#using scripts/zm/zm_genesis_mechz;
#using scripts/zm/zm_genesis_keeper_companion;
#using scripts/zm/zm_genesis_keeper;
#using scripts/zm/zm_genesis_hope;
#using scripts/zm/zm_genesis_fx;
#using scripts/zm/zm_genesis_flingers;
#using scripts/zm/zm_genesis_ffotd;
#using scripts/zm/zm_genesis_ee_quest;
#using scripts/zm/zm_genesis_challenges;
#using scripts/zm/zm_genesis_boss;
#using scripts/zm/zm_genesis_arena;
#using scripts/zm/zm_genesis_apothicon_god;
#using scripts/zm/zm_genesis_apothicon_fury;
#using scripts/zm/zm_genesis_apothican;
#using scripts/zm/zm_genesis_amb;
#using scripts/zm/zm_genesis_ai_spawning;
#using scripts/zm/archetype_genesis_keeper_companion;
#using scripts/zm/_zm_weapons;
#using scripts/zm/_zm_weap_thundergun;
#using scripts/zm/_zm_weap_octobomb;
#using scripts/zm/_zm_weap_idgun;
#using scripts/zm/_zm_weap_gravityspikes;
#using scripts/zm/_zm_weap_dragon_scale_shield;
#using scripts/zm/_zm_weap_bouncingbetty;
#using scripts/zm/_zm_weap_ball;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_shadow_zombie;
#using scripts/zm/_zm_powerup_genesis_random_weapon;
#using scripts/zm/_zm_powerup_free_perk;
#using scripts/zm/_zm_powerup_weapon_minigun;
#using scripts/zm/_zm_powerup_nuke;
#using scripts/zm/_zm_powerup_insta_kill;
#using scripts/zm/_zm_powerup_full_ammo;
#using scripts/zm/_zm_powerup_fire_sale;
#using scripts/zm/_zm_powerup_carpenter;
#using scripts/zm/_zm_powerup_double_points;
#using scripts/zm/_zm_perk_random;
#using scripts/zm/_zm_perk_electric_cherry;
#using scripts/zm/_zm_perk_deadshot;
#using scripts/zm/_zm_perk_widows_wine;
#using scripts/zm/_zm_perk_staminup;
#using scripts/zm/_zm_perk_sleight_of_hand;
#using scripts/zm/_zm_perk_quick_revive;
#using scripts/zm/_zm_perk_juggernaut;
#using scripts/zm/_zm_perk_doubletap2;
#using scripts/zm/_zm_perk_additionalprimaryweapon;
#using scripts/zm/_zm_pack_a_punch;
#using scripts/zm/_zm_light_zombie;
#using scripts/zm/_zm_grappler;
#using scripts/zm/_zm_genesis_spiders;
#using scripts/zm/_zm_fog;
#using scripts/zm/_zm_ai_mechz;
#using scripts/zm/_zm_ai_margwa_elemental;
#using scripts/zm/_zm;
#using scripts/zm/_load;
#using scripts/zm/_electroball_grenade;
#using scripts/zm/craftables/_zm_craft_shield;
#using scripts/zm/craftables/_zm_craftables;
#using scripts/shared/util_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/vehicles/_spider;
#using scripts/shared/ai/mechz;
#using scripts/shared/ai/margwa;
#using scripts/codescripts/struct;

#namespace namespace_9d0831d9;

// Namespace namespace_9d0831d9
// Params 0, eflags: 0x2
// Checksum 0x672dab30, Offset: 0x1788
// Size: 0x28
function autoexec opt_in() {
    level.aat_in_use = 1;
    level.bgb_in_use = 1;
    level.clientfieldaicheck = 1;
}

// Namespace namespace_9d0831d9
// Params 0, eflags: 0x1 linked
// Checksum 0x321aa31d, Offset: 0x17b8
// Size: 0x21c
function main() {
    callback::on_localclient_connect(&on_player_connected);
    namespace_b6963cd7::main_start();
    namespace_d7c5f6de::main();
    namespace_a714a13e::main();
    level.debug_keyline_zombies = 0;
    level.setupcustomcharacterexerts = &setup_personality_character_exerts;
    level._effect["eye_glow"] = "dlc3/stalingrad/fx_glow_eye_red_stal";
    level._uses_sticky_grenades = 1;
    level._uses_taser_knuckles = 1;
    include_weapons();
    namespace_d95aef6::main();
    namespace_57c513b2::main();
    setdvar("waypointVerticalSeparation", -2001);
    namespace_50411410::function_ad78a144();
    clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 12000, 1, "int", undefined, 0, 0);
    clientfield::register("clientuimodel", "zmInventory.widget_dragon_strike", 12000, 1, "int", undefined, 0, 0);
    clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 12000, 1, "int", undefined, 0, 0);
    load::main();
    level thread namespace_a7ac3fc4::main();
    level thread namespace_d7c5f6de::function_2c301fae();
    util::waitforclient(0);
    namespace_b6963cd7::main_end();
}

// Namespace namespace_9d0831d9
// Params 1, eflags: 0x1 linked
// Checksum 0x281d24c9, Offset: 0x19e0
// Size: 0x24
function on_player_connected(var_6575414d) {
    self thread function_1407a431(var_6575414d);
}

// Namespace namespace_9d0831d9
// Params 1, eflags: 0x1 linked
// Checksum 0x374ad294, Offset: 0x1a10
// Size: 0x198
function function_1407a431(var_6575414d) {
    self endon(#"disconnect");
    self endon(#"death");
    self endon(#"entityshutdown");
    var_c2a0c80a = getent(var_6575414d, "sun_flame", "targetname");
    var_c2a0c80a setscale(6);
    player = getlocalplayer(var_6575414d);
    while (isdefined(player)) {
        if (!var_c2a0c80a hasdobj(var_6575414d)) {
            var_c2a0c80a util::waittill_dobj(var_6575414d);
            wait(0.016);
        }
        if (!isdefined(player)) {
            player = getlocalplayer(var_6575414d);
            wait(0.016);
        }
        v_to_player = player.origin - var_c2a0c80a.origin;
        var_b514ffc0 = vectortoangles(v_to_player) + (89, 0, 0);
        var_c2a0c80a.angles = var_b514ffc0;
        wait(0.01);
    }
}

// Namespace namespace_9d0831d9
// Params 0, eflags: 0x1 linked
// Checksum 0xf4ca3379, Offset: 0x1bb0
// Size: 0x34
function include_weapons() {
    zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_genesis_weapons.csv", 1);
    zm_weapons::function_9e8dccbe();
}

// Namespace namespace_9d0831d9
// Params 0, eflags: 0x1 linked
// Checksum 0x6db0a5e6, Offset: 0x1bf0
// Size: 0x1072
function setup_personality_character_exerts() {
    level.exert_sounds[1]["playerbreathinsound"][0] = "vox_plr_0_exert_inhale_0";
    level.exert_sounds[2]["playerbreathinsound"][0] = "vox_plr_1_exert_inhale_0";
    level.exert_sounds[3]["playerbreathinsound"][0] = "vox_plr_2_exert_inhale_0";
    level.exert_sounds[4]["playerbreathinsound"][0] = "vox_plr_3_exert_inhale_0";
    level.exert_sounds[1]["playerbreathoutsound"][0] = "vox_plr_0_exert_exhale_0";
    level.exert_sounds[2]["playerbreathoutsound"][0] = "vox_plr_1_exert_exhale_0";
    level.exert_sounds[3]["playerbreathoutsound"][0] = "vox_plr_2_exert_exhale_0";
    level.exert_sounds[4]["playerbreathoutsound"][0] = "vox_plr_3_exert_exhale_0";
    level.exert_sounds[1]["playerbreathgaspsound"][0] = "vox_plr_0_exert_exhale_0";
    level.exert_sounds[2]["playerbreathgaspsound"][0] = "vox_plr_1_exert_exhale_0";
    level.exert_sounds[3]["playerbreathgaspsound"][0] = "vox_plr_2_exert_exhale_0";
    level.exert_sounds[4]["playerbreathgaspsound"][0] = "vox_plr_3_exert_exhale_0";
    level.exert_sounds[1]["falldamage"][0] = "vox_plr_0_exert_pain_low_0";
    level.exert_sounds[1]["falldamage"][1] = "vox_plr_0_exert_pain_low_1";
    level.exert_sounds[1]["falldamage"][2] = "vox_plr_0_exert_pain_low_2";
    level.exert_sounds[1]["falldamage"][3] = "vox_plr_0_exert_pain_low_3";
    level.exert_sounds[1]["falldamage"][4] = "vox_plr_0_exert_pain_low_4";
    level.exert_sounds[1]["falldamage"][5] = "vox_plr_0_exert_pain_low_5";
    level.exert_sounds[1]["falldamage"][6] = "vox_plr_0_exert_pain_low_6";
    level.exert_sounds[1]["falldamage"][7] = "vox_plr_0_exert_pain_low_7";
    level.exert_sounds[2]["falldamage"][0] = "vox_plr_1_exert_pain_low_0";
    level.exert_sounds[2]["falldamage"][1] = "vox_plr_1_exert_pain_low_1";
    level.exert_sounds[2]["falldamage"][2] = "vox_plr_1_exert_pain_low_2";
    level.exert_sounds[2]["falldamage"][3] = "vox_plr_1_exert_pain_low_3";
    level.exert_sounds[2]["falldamage"][4] = "vox_plr_1_exert_pain_low_4";
    level.exert_sounds[2]["falldamage"][5] = "vox_plr_1_exert_pain_low_5";
    level.exert_sounds[2]["falldamage"][6] = "vox_plr_1_exert_pain_low_6";
    level.exert_sounds[2]["falldamage"][7] = "vox_plr_1_exert_pain_low_7";
    level.exert_sounds[3]["falldamage"][0] = "vox_plr_2_exert_pain_low_0";
    level.exert_sounds[3]["falldamage"][1] = "vox_plr_2_exert_pain_low_1";
    level.exert_sounds[3]["falldamage"][2] = "vox_plr_2_exert_pain_low_2";
    level.exert_sounds[3]["falldamage"][3] = "vox_plr_2_exert_pain_low_3";
    level.exert_sounds[3]["falldamage"][4] = "vox_plr_2_exert_pain_low_4";
    level.exert_sounds[3]["falldamage"][5] = "vox_plr_2_exert_pain_low_5";
    level.exert_sounds[3]["falldamage"][6] = "vox_plr_2_exert_pain_low_6";
    level.exert_sounds[3]["falldamage"][7] = "vox_plr_2_exert_pain_low_7";
    level.exert_sounds[4]["falldamage"][0] = "vox_plr_3_exert_pain_low_0";
    level.exert_sounds[4]["falldamage"][1] = "vox_plr_3_exert_pain_low_1";
    level.exert_sounds[4]["falldamage"][2] = "vox_plr_3_exert_pain_low_2";
    level.exert_sounds[4]["falldamage"][3] = "vox_plr_3_exert_pain_low_3";
    level.exert_sounds[4]["falldamage"][4] = "vox_plr_3_exert_pain_low_4";
    level.exert_sounds[4]["falldamage"][5] = "vox_plr_3_exert_pain_low_5";
    level.exert_sounds[4]["falldamage"][6] = "vox_plr_3_exert_pain_low_6";
    level.exert_sounds[4]["falldamage"][7] = "vox_plr_3_exert_pain_low_7";
    level.exert_sounds[1]["mantlesoundplayer"][0] = "vox_plr_0_exert_grunt_0";
    level.exert_sounds[1]["mantlesoundplayer"][1] = "vox_plr_0_exert_grunt_1";
    level.exert_sounds[1]["mantlesoundplayer"][2] = "vox_plr_0_exert_grunt_2";
    level.exert_sounds[1]["mantlesoundplayer"][3] = "vox_plr_0_exert_grunt_3";
    level.exert_sounds[1]["mantlesoundplayer"][4] = "vox_plr_0_exert_grunt_4";
    level.exert_sounds[1]["mantlesoundplayer"][5] = "vox_plr_0_exert_grunt_5";
    level.exert_sounds[1]["mantlesoundplayer"][6] = "vox_plr_0_exert_grunt_6";
    level.exert_sounds[2]["mantlesoundplayer"][0] = "vox_plr_1_exert_grunt_0";
    level.exert_sounds[2]["mantlesoundplayer"][1] = "vox_plr_1_exert_grunt_1";
    level.exert_sounds[2]["mantlesoundplayer"][2] = "vox_plr_1_exert_grunt_2";
    level.exert_sounds[2]["mantlesoundplayer"][3] = "vox_plr_1_exert_grunt_3";
    level.exert_sounds[2]["mantlesoundplayer"][4] = "vox_plr_1_exert_grunt_4";
    level.exert_sounds[2]["mantlesoundplayer"][5] = "vox_plr_1_exert_grunt_5";
    level.exert_sounds[2]["mantlesoundplayer"][6] = "vox_plr_1_exert_grunt_6";
    level.exert_sounds[3]["mantlesoundplayer"][0] = "vox_plr_2_exert_grunt_0";
    level.exert_sounds[3]["mantlesoundplayer"][1] = "vox_plr_2_exert_grunt_1";
    level.exert_sounds[3]["mantlesoundplayer"][2] = "vox_plr_2_exert_grunt_2";
    level.exert_sounds[3]["mantlesoundplayer"][3] = "vox_plr_2_exert_grunt_3";
    level.exert_sounds[3]["mantlesoundplayer"][4] = "vox_plr_2_exert_grunt_4";
    level.exert_sounds[3]["mantlesoundplayer"][5] = "vox_plr_2_exert_grunt_5";
    level.exert_sounds[3]["mantlesoundplayer"][6] = "vox_plr_2_exert_grunt_6";
    level.exert_sounds[4]["mantlesoundplayer"][0] = "vox_plr_3_exert_grunt_0";
    level.exert_sounds[4]["mantlesoundplayer"][1] = "vox_plr_3_exert_grunt_1";
    level.exert_sounds[4]["mantlesoundplayer"][2] = "vox_plr_3_exert_grunt_2";
    level.exert_sounds[4]["mantlesoundplayer"][3] = "vox_plr_3_exert_grunt_3";
    level.exert_sounds[4]["mantlesoundplayer"][4] = "vox_plr_3_exert_grunt_4";
    level.exert_sounds[4]["mantlesoundplayer"][5] = "vox_plr_3_exert_grunt_5";
    level.exert_sounds[4]["mantlesoundplayer"][6] = "vox_plr_3_exert_grunt_6";
    level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_knife_swipe_0";
    level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_knife_swipe_1";
    level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_knife_swipe_2";
    level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_knife_swipe_3";
    level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_knife_swipe_4";
    level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_knife_swipe_0";
    level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_knife_swipe_1";
    level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_knife_swipe_2";
    level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_knife_swipe_3";
    level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_knife_swipe_4";
    level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_knife_swipe_0";
    level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_knife_swipe_1";
    level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_knife_swipe_2";
    level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_knife_swipe_3";
    level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_knife_swipe_4";
    level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_knife_swipe_0";
    level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_knife_swipe_1";
    level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_knife_swipe_2";
    level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_knife_swipe_3";
    level.exert_sounds[4]["meleeswipesoundplayer"][4] = "vox_plr_3_exert_knife_swipe_4";
    level.exert_sounds[1]["dtplandsoundplayer"][0] = "vox_plr_0_exert_pain_medium_0";
    level.exert_sounds[1]["dtplandsoundplayer"][1] = "vox_plr_0_exert_pain_medium_1";
    level.exert_sounds[1]["dtplandsoundplayer"][2] = "vox_plr_0_exert_pain_medium_2";
    level.exert_sounds[1]["dtplandsoundplayer"][3] = "vox_plr_0_exert_pain_medium_3";
    level.exert_sounds[2]["dtplandsoundplayer"][0] = "vox_plr_1_exert_pain_medium_0";
    level.exert_sounds[2]["dtplandsoundplayer"][1] = "vox_plr_1_exert_pain_medium_1";
    level.exert_sounds[2]["dtplandsoundplayer"][2] = "vox_plr_1_exert_pain_medium_2";
    level.exert_sounds[2]["dtplandsoundplayer"][3] = "vox_plr_1_exert_pain_medium_3";
    level.exert_sounds[3]["dtplandsoundplayer"][0] = "vox_plr_2_exert_pain_medium_0";
    level.exert_sounds[3]["dtplandsoundplayer"][1] = "vox_plr_2_exert_pain_medium_1";
    level.exert_sounds[3]["dtplandsoundplayer"][2] = "vox_plr_2_exert_pain_medium_2";
    level.exert_sounds[3]["dtplandsoundplayer"][3] = "vox_plr_2_exert_pain_medium_3";
    level.exert_sounds[4]["dtplandsoundplayer"][0] = "vox_plr_3_exert_pain_medium_0";
    level.exert_sounds[4]["dtplandsoundplayer"][1] = "vox_plr_3_exert_pain_medium_1";
    level.exert_sounds[4]["dtplandsoundplayer"][2] = "vox_plr_3_exert_pain_medium_2";
    level.exert_sounds[4]["dtplandsoundplayer"][3] = "vox_plr_3_exert_pain_medium_3";
}

