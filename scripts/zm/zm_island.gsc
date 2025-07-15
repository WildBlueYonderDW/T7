#using scripts/codescripts/struct;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/ai_shared;
#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/fx_shared;
#using scripts/shared/math_shared;
#using scripts/shared/scene_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/trigger_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_load;
#using scripts/zm/_zm;
#using scripts/zm/_zm_ai_clone;
#using scripts/zm/_zm_ai_spiders;
#using scripts/zm/_zm_ai_thrasher;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_bgb_machine;
#using scripts/zm/_zm_equipment;
#using scripts/zm/_zm_pack_a_punch;
#using scripts/zm/_zm_pack_a_punch_util;
#using scripts/zm/_zm_perks;
#using scripts/zm/_zm_power;
#using scripts/zm/_zm_powerup_bonus_points_player;
#using scripts/zm/_zm_powerup_bonus_points_team;
#using scripts/zm/_zm_powerup_carpenter;
#using scripts/zm/_zm_powerup_double_points;
#using scripts/zm/_zm_powerup_empty_perk;
#using scripts/zm/_zm_powerup_fire_sale;
#using scripts/zm/_zm_powerup_free_perk;
#using scripts/zm/_zm_powerup_full_ammo;
#using scripts/zm/_zm_powerup_insta_kill;
#using scripts/zm/_zm_powerup_island_seed;
#using scripts/zm/_zm_powerup_nuke;
#using scripts/zm/_zm_powerup_weapon_minigun;
#using scripts/zm/_zm_powerups;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_weap_bouncingbetty;
#using scripts/zm/_zm_weap_bowie;
#using scripts/zm/_zm_weap_controllable_spider;
#using scripts/zm/_zm_weap_cymbal_monkey;
#using scripts/zm/_zm_weap_island_shield;
#using scripts/zm/_zm_weap_keeper_skull;
#using scripts/zm/_zm_weap_mirg2000;
#using scripts/zm/_zm_weap_riotshield;
#using scripts/zm/_zm_weapons;
#using scripts/zm/_zm_zonemgr;
#using scripts/zm/bgbs/_zm_bgb_anywhere_but_here;
#using scripts/zm/craftables/_zm_craft_shield;
#using scripts/zm/craftables/_zm_craftables;
#using scripts/zm/zm_island_achievements;
#using scripts/zm/zm_island_bgb;
#using scripts/zm/zm_island_challenges;
#using scripts/zm/zm_island_cleanup_mgr;
#using scripts/zm/zm_island_craftables;
#using scripts/zm/zm_island_dogfights;
#using scripts/zm/zm_island_ffotd;
#using scripts/zm/zm_island_fx;
#using scripts/zm/zm_island_gamemodes;
#using scripts/zm/zm_island_inventory;
#using scripts/zm/zm_island_main_ee_quest;
#using scripts/zm/zm_island_pap_quest;
#using scripts/zm/zm_island_perks;
#using scripts/zm/zm_island_planting;
#using scripts/zm/zm_island_portals;
#using scripts/zm/zm_island_power;
#using scripts/zm/zm_island_side_ee_distant_monster;
#using scripts/zm/zm_island_side_ee_doppleganger;
#using scripts/zm/zm_island_side_ee_golden_bucket;
#using scripts/zm/zm_island_side_ee_good_thrasher;
#using scripts/zm/zm_island_side_ee_secret_maxammo;
#using scripts/zm/zm_island_side_ee_song;
#using scripts/zm/zm_island_side_ee_spore_hallucinations;
#using scripts/zm/zm_island_skullweapon_quest;
#using scripts/zm/zm_island_spider_ee_quest;
#using scripts/zm/zm_island_spider_quest;
#using scripts/zm/zm_island_spiders;
#using scripts/zm/zm_island_spores;
#using scripts/zm/zm_island_takeo_fight;
#using scripts/zm/zm_island_thrasher;
#using scripts/zm/zm_island_transport;
#using scripts/zm/zm_island_traps;
#using scripts/zm/zm_island_vo;
#using scripts/zm/zm_island_ww_quest;
#using scripts/zm/zm_island_zombie;
#using scripts/zm/zm_island_zones;

#namespace zm_island;

// Namespace zm_island
// Params 0, eflags: 0x2
// Checksum 0x66bd17d7, Offset: 0x2478
// Size: 0x40
function autoexec opt_in()
{
    level.aat_in_use = 1;
    level.bgb_in_use = 1;
    level.randomize_perk_machine_location = 1;
    level.var_615d751 = 1;
    level.pack_a_punch_camo_index = 81;
}

// Namespace zm_island
// Params 0
// Checksum 0x97da93e1, Offset: 0x24c0
// Size: 0x14
function gamemode_callback_setup()
{
    zm_island_gamemodes::init();
}

// Namespace zm_island
// Params 0
// Checksum 0x9899cd56, Offset: 0x24e0
// Size: 0x84
function setup_rex_starts()
{
    zm_utility::add_gametype( "zclassic", &dummy, "zclassic", &dummy );
    zm_utility::add_gameloc( "default", &dummy, "default", &dummy );
}

// Namespace zm_island
// Params 0
// Checksum 0x99ec1590, Offset: 0x2570
// Size: 0x4
function dummy()
{
    
}

// Namespace zm_island
// Params 0
// Checksum 0x27bb76f1, Offset: 0x2580
// Size: 0x13ac
function main()
{
    zm_island_ffotd::main_start();
    setup_weapons();
    init_flags();
    level.zm_aat_turned_validation_override = &function_490a2312;
    level._uses_sticky_grenades = 1;
    level._uses_taser_knuckles = 1;
    scene::add_scene_func( "p7_fxanim_zm_island_power_plant_on_bundle", &zm_island_power::function_f0a1682d, "init" );
    scene::add_scene_func( "p7_fxanim_zm_island_power_plant_on_bundle", &zm_island_power::raw\fulljap\sound\vox\scripted\zma\vox_plr_3_anim_pain_2_d_0.SN55.xenon.snd, "play" );
    level.temporary_power_switch_logic = &zm_island_power::function_156f973e;
    level.var_7b5a9e65 = 120;
    level.var_7ccadaab = getdvarint( "loc_language" );
    zm::init_fx();
    callback::on_spawned( &on_player_spawned );
    callback::on_connect( &zm_island_challenges::on_player_connect );
    callback::on_disconnect( &zm_island_skullquest::function_c7cd5585 );
    callback::on_disconnect( &zm_island_challenges::on_player_disconnect );
    callback::on_ai_spawned( &function_e50fed59 );
    var_ddba80d7 = getminbitcountfornum( 3 );
    var_d1cfa380 = getminbitcountfornum( 7 );
    var_a15256dd = getminbitcountfornum( 3 );
    var_a17d01a1 = getminbitcountfornum( 5 );
    var_850da4c5 = getminbitcountfornum( 4 );
    var_8b462b02 = getminbitcountfornum( 2 );
    var_fbab08c0 = getminbitcountfornum( 3 );
    clientfield::register( "clientuimodel", "player_lives", 9000, 2, "int" );
    clientfield::register( "clientuimodel", "zmInventory.widget_shield_parts", 9000, 1, "int" );
    clientfield::register( "clientuimodel", "zmInventory.player_crafted_shield", 9000, 1, "int" );
    clientfield::register( "clientuimodel", "trialWidget.visible", 9000, 1, "int" );
    clientfield::register( "clientuimodel", "trialWidget.progress", 9000, 7, "float" );
    clientfield::register( "scriptmover", "bucket_fx", 9000, 1, "int" );
    clientfield::register( "world", "power_switch_1_fx", 9000, 1, "int" );
    clientfield::register( "world", "power_switch_2_fx", 9000, 1, "int" );
    clientfield::register( "world", "penstock_fx_anim", 9000, 1, "int" );
    clientfield::register( "scriptmover", "power_plant_glow", 9000, 1, "int" );
    clientfield::register( "toplayer", "postfx_futz_mild", 9000, 1, "counter" );
    clientfield::register( "toplayer", "water_motes", 9000, 1, "int" );
    clientfield::register( "toplayer", "play_bubbles", 9000, 1, "int" );
    clientfield::register( "toplayer", "set_world_fog", 9000, var_ddba80d7, "int" );
    clientfield::register( "toplayer", "speed_burst", 9000, 1, "int" );
    clientfield::register( "toplayer", "tp_water_sheeting", 9000, 1, "int" );
    clientfield::register( "toplayer", "wind_blur", 9000, 1, "int" );
    clientfield::register( "vehicle", "sewer_current_fx", 9000, 1, "int" );
    clientfield::register( "scriptmover", "spore_glow_fx", 9000, 1, "int" );
    clientfield::register( "scriptmover", "spore_cloud_fx", 9000, var_d1cfa380, "int" );
    clientfield::register( "actor", "spore_trail_enemy_fx", 9000, var_a15256dd, "int" );
    clientfield::register( "allplayers", "spore_trail_player_fx", 9000, var_a15256dd, "int" );
    clientfield::register( "scriptmover", "spore_grows", 9000, var_a17d01a1, "int" );
    clientfield::register( "toplayer", "play_spore_bubbles", 9000, 1, "int" );
    clientfield::register( "toplayer", "spore_camera_fx", 9000, var_a15256dd, "int" );
    clientfield::register( "scriptmover", "set_heavy_web_fade_material", 9000, 1, "int" );
    clientfield::register( "world", "pillar_challenge_0_1", 9000, var_850da4c5, "int" );
    clientfield::register( "world", "pillar_challenge_0_2", 9000, var_850da4c5, "int" );
    clientfield::register( "world", "pillar_challenge_0_3", 9000, var_850da4c5, "int" );
    clientfield::register( "world", "pillar_challenge_1_1", 9000, var_850da4c5, "int" );
    clientfield::register( "world", "pillar_challenge_1_2", 9000, var_850da4c5, "int" );
    clientfield::register( "world", "pillar_challenge_1_3", 9000, var_850da4c5, "int" );
    clientfield::register( "world", "pillar_challenge_2_1", 9000, var_850da4c5, "int" );
    clientfield::register( "world", "pillar_challenge_2_2", 9000, var_850da4c5, "int" );
    clientfield::register( "world", "pillar_challenge_2_3", 9000, var_850da4c5, "int" );
    clientfield::register( "world", "pillar_challenge_3_1", 9000, var_850da4c5, "int" );
    clientfield::register( "world", "pillar_challenge_3_2", 9000, var_850da4c5, "int" );
    clientfield::register( "world", "pillar_challenge_3_3", 9000, var_850da4c5, "int" );
    clientfield::register( "scriptmover", "spider_queen_mouth_weakspot", 9000, var_8b462b02, "int" );
    clientfield::register( "scriptmover", "spider_queen_bleed", 9000, 1, "counter" );
    clientfield::register( "scriptmover", "spider_queen_stage_bleed", 9000, var_fbab08c0, "int" );
    clientfield::register( "scriptmover", "spider_queen_emissive_material", 9000, 1, "int" );
    clientfield::register( "scriptmover", "challenge_glow_fx", 9000, 2, "int" );
    clientfield::register( "world", "force_stream_spiders", 9001, 1, "int" );
    clientfield::register( "world", "force_stream_takeo_arms", 11001, 1, "int" );
    clientfield::register( "scriptmover", "do_fade_material", 9000, 3, "float" );
    clientfield::register( "scriptmover", "do_fade_material_slow", 9000, 3, "float" );
    clientfield::register( "scriptmover", "do_fade_material_direct", 9000, 3, "float" );
    clientfield::register( "scriptmover", "do_emissive_material", 9000, 3, "float" );
    clientfield::register( "scriptmover", "do_emissive_material_direct", 9000, 3, "float" );
    level.default_start_location = "start_room";
    level.default_game_mode = "zclassic";
    level.precachecustomcharacters = &precachecustomcharacters;
    level.givecustomcharacters = &givecustomcharacters;
    initcharacterstartindex();
    level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
    level.zombiemode_offhand_weapon_give_override = &offhand_weapon_give_override;
    level._zombie_custom_add_weapons = &custom_add_weapons;
    level._allow_melee_weapon_switching = 1;
    level.zombiemode_reusing_pack_a_punch = 1;
    level.dont_unset_perk_when_machine_paused = 1;
    level.bgb_machine_movement_frequency_override_func = &function_f51a1980;
    level thread zm_island_bgb::init();
    level thread custom_add_vox();
    level thread setup_personality_character_exerts();
    level.do_randomized_zigzag_path = 1;
    zm_craftables::init();
    zm_island_craftables::include_craftables();
    zm_island_craftables::init_craftables();
    zm_island_ww_quest::init_quest();
    main_quest::init_quest();
    zm_island_pap_quest::init();
    spider_ee_quest::init();
    side_ee_golden_bucket::init();
    zm_island_inventory::init();
    level thread zm_island_dogfights::init();
    zm_island_planting::main();
    zm_island_perks::init();
    zm_island_spiders::function_8e89793a();
    spawner::add_global_spawn_function( "axis", &function_b487bafd );
    load::main();
    _zm_weap_bowie::init();
    _zm_weap_cymbal_monkey::init();
    level._round_start_func = &zm::round_start;
    init_sounds();
    level.no_target_override = &no_target_override;
    level.player_intersection_tracker_override = &function_4fc0dcb3;
    level.fn_custom_round_ai_spawn = &zm_island_spiders::function_33aa4940;
    level thread zm_ai_spiders::function_d2716ad8();
    level.var_5f1b87ca = &zm_island_vo::function_5f161c52;
    level function_1b14c4b0();
    level thread zm_ai_thrasher::function_5e5433d8();
    level thread zm_island_zones::main();
    level thread function_1f00b569();
    level thread placed_powerups();
    zm_powerups::powerup_remove_from_regular_drops( "bonus_points_player" );
    zm_powerups::powerup_remove_from_regular_drops( "bonus_points_team" );
    zm_powerups::powerup_remove_from_regular_drops( "empty_perk" );
    zm_powerups::powerup_remove_from_regular_drops( "island_seed" );
    level._custom_powerups[ "ww_grenade" ].setup_powerup = &function_8608b597;
    level._powerup_grab_check = &function_66e965d8;
    level flag::wait_till( "start_zombie_round_logic" );
    level thread zm_island_perks::function_c97259e9();
    level thread zm_perks::spare_change();
    level thread zm_island_traps::function_7309e48();
    level thread sndfunctions();
    level thread zm_island_fx::main();
    level thread zm_island_spider_quest::init();
    level thread zm_island_spores::init();
    level thread zm_island_pap_quest::main();
    level thread zm_island_ww_quest::main();
    level thread zm_island_transport::init();
    level thread zm_island_power::main();
    level thread main_quest::main();
    level thread zm_island_portals::function_16616103();
    level thread zm_island_skullquest::main();
    level thread zm_ai_spiders::function_b4fb1b85();
    level thread zm_island_takeo_fight::main();
    level thread zm_island_dogfights::main();
    level thread zm_island_challenges::main();
    level thread spider_ee_quest::main();
    level thread zm_island_side_ee_distant_monster::main();
    level thread zm_island_side_ee_doppleganger::main();
    level thread zm_island_side_ee_good_thrasher::main();
    level thread zm_island_side_ee_secret_maxammo::main();
    level thread zm_island_side_ee_song::main();
    level thread zm_island_side_ee_spore_hallucinations::main();
    level thread side_ee_golden_bucket::main();
    level thread function_94fc6a19();
    level thread function_8a2a48bb();
    setdvar( "dlc2_fix_scripted_looping_linked_animations", 1 );
    setdvar( "dlc2_show_damage_feedback_when_drowning", 1 );
    setdvar( "player_useWaterWadeScale", "0" );
    setdvar( "r_waveWaterNewFormula", 1 );
    setdvar( "hkai_pathfindIterationLimit", 1200 );
    level thread zm_island_vo::main();
    zm_island_ffotd::main_end();
}

// Namespace zm_island
// Params 0
// Checksum 0x8614951b, Offset: 0x3938
// Size: 0xda
function function_1b14c4b0()
{
    a_nodes = getnodesinradius( ( -3239, 1360, 72 ), 2, 0 );
    
    foreach ( node in a_nodes )
    {
        if ( node.type === "Begin" )
        {
            unlinktraversal( node );
        }
    }
}

// Namespace zm_island
// Params 0
// Checksum 0xfee7deaf, Offset: 0x3a20
// Size: 0x7c
function function_490a2312()
{
    if ( isdefined( self.var_ecc789a5 ) && ( isdefined( self.var_2f846873 ) && ( isdefined( self.var_8853cc2a ) && self.var_8853cc2a || self.var_2f846873 ) || self.var_ecc789a5 > 0 ) )
    {
        return 0;
    }
    
    if ( isdefined( self.var_bf5bc647 ) && self.var_bf5bc647 )
    {
        return 0;
    }
    
    return 1;
}

// Namespace zm_island
// Params 0
// Checksum 0x28d41df5, Offset: 0x3aa8
// Size: 0x1c
function function_f51a1980()
{
    level.bgb_machine_min_uses_before_move = 999;
    level.bgb_machine_max_uses_before_move = 999;
}

// Namespace zm_island
// Params 0
// Checksum 0xe7f848d8, Offset: 0x3ad0
// Size: 0x2be
function function_75015b6c()
{
    foreach ( chest in level.chests )
    {
        if ( chest.zbarrier.state == "initial" )
        {
            var_a44b86c3 = level.bgb_machines;
            
            if ( chest.zbarrier.script_noteworthy == "zone_crash_site_chest_zbarrier" )
            {
                foreach ( var_4fdd617e in var_a44b86c3 )
                {
                    if ( var_4fdd617e.script_string === "bgb_crash_site" )
                    {
                        arrayremovevalue( var_a44b86c3, var_4fdd617e );
                        var_4fdd617e thread bgb_machine::hide_bgb_machine();
                        function_a7fdfd3c( var_a44b86c3 );
                        break;
                    }
                }
            }
            else if ( chest.zbarrier.script_noteworthy == "zone_ruins_chest_zbarrier" )
            {
                foreach ( var_4fdd617e in var_a44b86c3 )
                {
                    if ( var_4fdd617e.script_string === "bgb_ruins" )
                    {
                        arrayremovevalue( var_a44b86c3, var_4fdd617e );
                        var_4fdd617e thread bgb_machine::hide_bgb_machine();
                        function_a7fdfd3c( var_a44b86c3 );
                        break;
                    }
                }
            }
            else
            {
                iprintlnbold( "ERROR: Magic Box not started in either left nor right side." );
            }
            
            break;
        }
    }
}

// Namespace zm_island
// Params 1
// Checksum 0xc3f6054e, Offset: 0x3d98
// Size: 0xce
function function_a7fdfd3c( var_a44b86c3 )
{
    var_a44b86c3 = array::randomize( var_a44b86c3 );
    
    foreach ( var_83788d7d in var_a44b86c3 )
    {
        if ( var_83788d7d.script_noteworthy !== "start_bgb_machine" )
        {
            var_83788d7d thread bgb_machine::show_bgb_machine();
            break;
        }
    }
}

// Namespace zm_island
// Params 1
// Checksum 0x81a7461f, Offset: 0x3e70
// Size: 0x12c
function no_target_override( ai_zombie )
{
    if ( isdefined( self.b_zombie_path_bad ) && self.b_zombie_path_bad )
    {
        return;
    }
    
    if ( isdefined( self.var_6eb9188d ) && ( isdefined( self.var_5017aabf ) && ( isdefined( self.var_8853cc2a ) && ( isdefined( self.var_9b59d7f8 ) && ( isdefined( self.var_3f6ea790 ) && ( isdefined( self.var_20b8c74a ) && self.var_20b8c74a || self.var_3f6ea790 ) || self.var_9b59d7f8 ) || self.var_8853cc2a ) || self.var_5017aabf ) || self.var_6eb9188d ) )
    {
        return;
    }
    
    var_6c8e700c = ai_zombie zm_island_cleanup::get_escape_position_in_current_zone();
    
    if ( isalive( ai_zombie ) && isdefined( var_6c8e700c ) && isdefined( var_6c8e700c.origin ) )
    {
        ai_zombie thread function_dc683d01( var_6c8e700c.origin );
    }
}

// Namespace zm_island
// Params 1, eflags: 0x4
// Checksum 0x57e72fab, Offset: 0x3fa8
// Size: 0xd6
function private function_dc683d01( var_b52b26b9 )
{
    self endon( #"death" );
    self notify( #"stop_find_flesh" );
    self notify( #"zombie_acquire_enemy" );
    self ai::set_ignoreall( 1 );
    self.b_zombie_path_bad = 1;
    self thread check_player_available();
    self setgoal( var_b52b26b9 );
    self util::waittill_any( "goal", "reaquire_player" );
    self.ai_state = "find_flesh";
    self ai::set_ignoreall( 0 );
    self.b_zombie_path_bad = undefined;
}

// Namespace zm_island
// Params 0, eflags: 0x4
// Checksum 0xd5370b87, Offset: 0x4088
// Size: 0x78
function private check_player_available()
{
    self endon( #"death" );
    
    while ( isdefined( self.b_zombie_path_bad ) && self.b_zombie_path_bad )
    {
        wait randomfloatrange( 0.2, 0.5 );
        
        if ( self can_zombie_see_any_player() )
        {
            self.b_zombie_path_bad = undefined;
            self notify( #"reaquire_player" );
            return;
        }
    }
}

// Namespace zm_island
// Params 0, eflags: 0x4
// Checksum 0x5348690b, Offset: 0x4108
// Size: 0x98, Type: bool
function private can_zombie_see_any_player()
{
    for ( i = 0; i < level.activeplayers.size ; i++ )
    {
        if ( zombie_utility::is_player_valid( level.activeplayers[ i ] ) && self findpath( self.origin, level.activeplayers[ i ].origin, 1, 0 ) )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace zm_island
// Params 0
// Checksum 0x859aaaf3, Offset: 0x41a8
// Size: 0x164
function on_player_spawned()
{
    if ( level flag::get( "flag_play_outro_cutscene" ) )
    {
        if ( self.characterindex != 2 )
        {
            wait 0.1;
            self setcharacterbodystyle( 1 );
        }
    }
    
    self.is_ziplining = 0;
    self.no_revive_trigger = 0;
    self.var_90f735f8 = 0;
    self thread function_dd7044da();
    self thread function_3363c147();
    self thread function_94ed46a2();
    self thread function_708908ca();
    self thread zm_island_inventory::function_1a9a4375();
    self thread zm_island_pap_quest::on_player_spawned();
    self thread function_6ca6d73d();
    self.tesla_network_death_choke = 0;
    self.var_7149fc41 = 0;
    
    if ( isdefined( self.thrasher ) )
    {
        self.thrasher kill();
    }
}

// Namespace zm_island
// Params 0
// Checksum 0x89fd60d1, Offset: 0x4318
// Size: 0x58
function function_e50fed59()
{
    self endon( #"death" );
    
    if ( self.archetype === "zombie" )
    {
        self.heroweapon_kill_power = 2;
        return;
    }
    
    if ( isdefined( self.var_61f7b3a0 ) && self.var_61f7b3a0 )
    {
        self.heroweapon_kill_power = 4;
    }
}

// Namespace zm_island
// Params 0
// Checksum 0xf988becb, Offset: 0x4378
// Size: 0xca
function function_b487bafd()
{
    self.is_underwater = 0;
    var_1282bf51 = getentarray( "trigger_underwater", "targetname" );
    
    foreach ( t_underwater in var_1282bf51 )
    {
        self thread zm_island_pap_quest::function_83af0b87( t_underwater );
    }
}

// Namespace zm_island
// Params 0
// Checksum 0x47226410, Offset: 0x4450
// Size: 0x102
function function_708908ca()
{
    self endon( #"disconnect" );
    self.var_b5f30643 = 0;
    
    while ( true )
    {
        str_notify = self util::waittill_any_array_return( array( "perk_acquired", "perk_lost", "disconnect" ) );
        
        if ( str_notify == "perk_acquired" && self hasperk( "specialty_staminup" ) && !self.var_b5f30643 )
        {
            self.var_b5f30643 = 1;
            self notify( #"player_has_staminup" );
        }
        else if ( str_notify == "perk_lost" && self.var_b5f30643 )
        {
            self.var_b5f30643 = 0;
            self notify( #"player_lost_staminup" );
        }
        
        str_notify = undefined;
    }
}

// Namespace zm_island
// Params 0
// Checksum 0xc6c20abd, Offset: 0x4560
// Size: 0x278
function function_3363c147()
{
    self endon( #"disconnect" );
    
    if ( !isdefined( self.is_under_water ) )
    {
        self.is_under_water = 0;
    }
    
    while ( true )
    {
        if ( self isplayerunderwater() )
        {
            if ( !self.is_under_water )
            {
                self.is_under_water = 1;
                self clientfield::set_to_player( "water_motes", 1 );
                self clientfield::set_to_player( "play_bubbles", 1 );
                self fx::play( "bubbles", self.origin, ( 0, 0, 0 ), "swim_done", 1, "j_spineupper" );
                var_f97c401 = self zm_utility::get_current_zone();
                
                if ( isdefined( var_f97c401 ) )
                {
                    if ( var_f97c401 == "zone_start_water" || var_f97c401 == "zone_meteor_site" || var_f97c401 == "zone_meteor_site_2" )
                    {
                        if ( !level flag::get( "spider_round_in_progress" ) )
                        {
                            self clientfield::set_to_player( "set_world_fog", 1 );
                        }
                    }
                    else if ( !level flag::get( "spider_round_in_progress" ) )
                    {
                        self clientfield::set_to_player( "set_world_fog", 2 );
                    }
                }
            }
        }
        else if ( self.is_under_water )
        {
            self.is_under_water = 0;
            self clientfield::set_to_player( "water_motes", 0 );
            self clientfield::set_to_player( "play_bubbles", 0 );
            
            if ( !level flag::get( "spider_round_in_progress" ) )
            {
                self clientfield::set_to_player( "set_world_fog", 0 );
            }
            
            self notify( #"swim_done" );
        }
        
        wait 0.05;
    }
}

// Namespace zm_island
// Params 0
// Checksum 0xb04c0820, Offset: 0x47e0
// Size: 0x34
function function_94ed46a2()
{
    self endon( #"disconnect" );
    
    while ( true )
    {
        self waittill( #"entering_last_stand" );
        self.laststandstarttime = gettime();
    }
}

// Namespace zm_island
// Params 0
// Checksum 0x44fcade6, Offset: 0x4820
// Size: 0x134
function function_dd7044da()
{
    self endon( #"disconnect" );
    var_d34e298b = 10;
    var_d64fdaf3 = 20;
    var_7bc01af9 = 30;
    self.drown_damage_after_time = var_d34e298b * 1000;
    
    while ( true )
    {
        self util::waittill_any( "player_has_gasmask", "player_lost_gasmask", "player_has_staminup", "player_lost_staminup" );
        
        if ( isdefined( self.has_gasmask ) && isdefined( self.var_b5f30643 ) && self.var_b5f30643 && self.has_gasmask )
        {
            self.drown_damage_after_time = var_7bc01af9 * 1000;
            continue;
        }
        
        if ( isdefined( self.has_gasmask ) && ( isdefined( self.var_b5f30643 ) && self.var_b5f30643 || self.has_gasmask ) )
        {
            self.drown_damage_after_time = var_d64fdaf3 * 1000;
            continue;
        }
        
        self.drown_damage_after_time = var_d34e298b * 1000;
    }
}

// Namespace zm_island
// Params 0
// Checksum 0xbf176fa4, Offset: 0x4960
// Size: 0x144
function init_flags()
{
    level flag::init( "craftable_valveone_crafted" );
    level flag::init( "craftable_valvetwo_crafted" );
    level flag::init( "craftable_valvethree_crafted" );
    level flag::init( "pap_open" );
    level flag::init( "trilogy_released" );
    level flag::init( "start_quest" );
    level flag::init( "flag_player_initialized_reward" );
    level flag::init( "all_challenges_completed" );
    level flag::init( "flag_init_player_challenges" );
    level flag::init( "flag_outro_cutscene_done" );
}

// Namespace zm_island
// Params 1
// Checksum 0x4f50f2d, Offset: 0x4ab0
// Size: 0x102, Type: bool
function function_4fc0dcb3( other_player )
{
    if ( self isplayerunderwater() && self isplayerswimming() )
    {
        return true;
    }
    
    if ( other_player isplayerunderwater() && other_player isplayerswimming() )
    {
        return true;
    }
    
    if ( isdefined( self.is_ziplining ) && ( isdefined( self.var_7a36438e ) && self.var_7a36438e || self.is_ziplining ) )
    {
        return true;
    }
    
    if ( isdefined( other_player.is_ziplining ) && ( isdefined( other_player.var_7a36438e ) && other_player.var_7a36438e || other_player.is_ziplining ) )
    {
        return true;
    }
    
    return false;
}

// Namespace zm_island
// Params 0
// Checksum 0x31f67132, Offset: 0x4bc0
// Size: 0xd6
function offhand_weapon_overrride()
{
    zm_utility::register_lethal_grenade_for_level( "frag_grenade" );
    level.zombie_lethal_grenade_player_init = getweapon( "frag_grenade" );
    zm_utility::register_tactical_grenade_for_level( "cymbal_monkey" );
    zm_utility::register_tactical_grenade_for_level( "emp_grenade" );
    zm_utility::register_melee_weapon_for_level( level.weaponbasemelee.name );
    zm_utility::register_melee_weapon_for_level( "bowie_knife" );
    zm_utility::register_melee_weapon_for_level( "tazer_knuckles" );
    level.zombie_melee_weapon_player_init = level.weaponbasemelee;
    level.zombie_equipment_player_init = undefined;
}

// Namespace zm_island
// Params 1
// Checksum 0x43fb3777, Offset: 0x4ca0
// Size: 0xbe, Type: bool
function offhand_weapon_give_override( str_weapon )
{
    self endon( #"death" );
    
    if ( zm_utility::is_tactical_grenade( str_weapon ) && isdefined( self zm_utility::get_player_tactical_grenade() ) && !self zm_utility::is_player_tactical_grenade( str_weapon ) )
    {
        self setweaponammoclip( self zm_utility::get_player_tactical_grenade(), 0 );
        self takeweapon( self zm_utility::get_player_tactical_grenade() );
    }
    
    return false;
}

// Namespace zm_island
// Params 0
// Checksum 0xdad7fd9, Offset: 0x4d68
// Size: 0x9e
function setup_weapons()
{
    level.random_pandora_box_start = 1;
    level.start_chest_name = "zone_crash_site_chest";
    level.open_chest_location = [];
    level.open_chest_location[ 0 ] = "zone_crash_site_chest";
    level.open_chest_location[ 1 ] = "zone_ruins_chest";
    level.open_chest_location[ 2 ] = "zone_bunker_interior_chest";
    level.open_chest_location[ 3 ] = "zone_cliffside_chest";
    level.open_chest_location[ 4 ] = "zone_meteor_site_chest";
}

// Namespace zm_island
// Params 0
// Checksum 0x9fd01b45, Offset: 0x4e10
// Size: 0x64
function init_sounds()
{
    zm_utility::add_sound( "gate_door", "zmb_gate_slide_open" );
    zm_utility::add_sound( "heavy_door", "zmb_heavy_door_open" );
    zm_utility::add_sound( "zmb_heavy_door_open", "zmb_heavy_door_open" );
}

// Namespace zm_island
// Params 0
// Checksum 0x99ec1590, Offset: 0x4e80
// Size: 0x4
function precachecustomcharacters()
{
    
}

// Namespace zm_island
// Params 0
// Checksum 0xb15a483b, Offset: 0x4e90
// Size: 0x24
function initcharacterstartindex()
{
    level.characterstartindex = randomint( 4 );
}

// Namespace zm_island
// Params 0
// Checksum 0xcd193cfe, Offset: 0x4ec0
// Size: 0x3e
function selectcharacterindextouse()
{
    if ( level.characterstartindex >= 4 )
    {
        level.characterstartindex = 0;
    }
    
    self.characterindex = level.characterstartindex;
    level.characterstartindex++;
    return self.characterindex;
}

// Namespace zm_island
// Params 0
// Checksum 0xbaa5bc0b, Offset: 0x4f08
// Size: 0x214
function assign_lowest_unused_character_index()
{
    charindexarray = [];
    charindexarray[ 0 ] = 0;
    charindexarray[ 1 ] = 1;
    charindexarray[ 2 ] = 2;
    charindexarray[ 3 ] = 3;
    a_players = getplayers();
    
    if ( a_players.size == 1 )
    {
        charindexarray = array::randomize( charindexarray );
        
        if ( charindexarray[ 0 ] == 2 )
        {
            level.var_c7ffdf5 = 1;
        }
        
        return charindexarray[ 0 ];
    }
    else
    {
        n_characters_defined = 0;
        
        foreach ( player in a_players )
        {
            if ( isdefined( player.characterindex ) )
            {
                arrayremovevalue( charindexarray, player.characterindex, 0 );
                n_characters_defined++;
            }
        }
        
        if ( charindexarray.size > 0 )
        {
            if ( n_characters_defined == a_players.size - 1 )
            {
                if ( !( isdefined( level.var_c7ffdf5 ) && level.var_c7ffdf5 ) )
                {
                    level.var_c7ffdf5 = 1;
                    return 2;
                }
            }
            
            charindexarray = array::randomize( charindexarray );
            
            if ( charindexarray[ 0 ] == 2 )
            {
                level.var_c7ffdf5 = 1;
            }
            
            return charindexarray[ 0 ];
        }
    }
    
    return 0;
}

// Namespace zm_island
// Params 0
// Checksum 0xa6aee012, Offset: 0x5128
// Size: 0x2bc
function givecustomcharacters()
{
    if ( isdefined( level.hotjoin_player_setup ) && [[ level.hotjoin_player_setup ]]( "c_zom_farmgirl_viewhands" ) )
    {
        return;
    }
    
    self detachall();
    
    if ( !isdefined( self.characterindex ) )
    {
        self.characterindex = assign_lowest_unused_character_index();
    }
    
    self.favorite_wall_weapons_list = [];
    self.talks_in_danger = 0;
    
    /#
        if ( getdvarstring( "<dev string:x28>" ) != "<dev string:x33>" )
        {
            self.characterindex = getdvarint( "<dev string:x28>" );
        }
    #/
    
    self setcharacterbodytype( self.characterindex );
    self setcharacterbodystyle( 0 );
    self setcharacterhelmetstyle( 0 );
    
    switch ( self.characterindex )
    {
        case 0:
            self.favorite_wall_weapons_list[ self.favorite_wall_weapons_list.size ] = getweapon( "frag_grenade" );
            self.favorite_wall_weapons_list[ self.favorite_wall_weapons_list.size ] = getweapon( "bouncingbetty" );
            break;
        case 1:
            self.talks_in_danger = 1;
            level.rich_sq_player = self;
            self.favorite_wall_weapons_list[ self.favorite_wall_weapons_list.size ] = getweapon( "pistol_standard" );
            break;
        case 2:
            self.favorite_wall_weapons_list[ self.favorite_wall_weapons_list.size ] = getweapon( "870mcs" );
            break;
        case 3:
            self.favorite_wall_weapons_list[ self.favorite_wall_weapons_list.size ] = getweapon( "hk416" );
            break;
    }
    
    self setmovespeedscale( 1 );
    self setsprintduration( 4 );
    self setsprintcooldown( 0 );
    self thread set_exert_id();
}

// Namespace zm_island
// Params 0
// Checksum 0x18738346, Offset: 0x53f0
// Size: 0x54
function set_exert_id()
{
    self endon( #"disconnect" );
    util::wait_network_frame();
    util::wait_network_frame();
    self zm_audio::setexertvoice( self.characterindex + 1 );
}

// Namespace zm_island
// Params 0
// Checksum 0xb61bcfdd, Offset: 0x5450
// Size: 0x113a
function setup_personality_character_exerts()
{
    level.exert_sounds[ 1 ][ "burp" ][ 0 ] = "vox_plr_0_exert_burp_0";
    level.exert_sounds[ 1 ][ "burp" ][ 1 ] = "vox_plr_0_exert_burp_1";
    level.exert_sounds[ 1 ][ "burp" ][ 2 ] = "vox_plr_0_exert_burp_2";
    level.exert_sounds[ 1 ][ "burp" ][ 3 ] = "vox_plr_0_exert_burp_3";
    level.exert_sounds[ 1 ][ "burp" ][ 4 ] = "vox_plr_0_exert_burp_4";
    level.exert_sounds[ 1 ][ "burp" ][ 5 ] = "vox_plr_0_exert_burp_5";
    level.exert_sounds[ 1 ][ "burp" ][ 6 ] = "vox_plr_0_exert_burp_6";
    level.exert_sounds[ 2 ][ "burp" ][ 0 ] = "vox_plr_1_exert_burp_0";
    level.exert_sounds[ 2 ][ "burp" ][ 1 ] = "vox_plr_1_exert_burp_1";
    level.exert_sounds[ 2 ][ "burp" ][ 2 ] = "vox_plr_1_exert_burp_2";
    level.exert_sounds[ 2 ][ "burp" ][ 3 ] = "vox_plr_1_exert_burp_3";
    level.exert_sounds[ 3 ][ "burp" ][ 0 ] = "vox_plr_2_exert_burp_0";
    level.exert_sounds[ 3 ][ "burp" ][ 1 ] = "vox_plr_2_exert_burp_1";
    level.exert_sounds[ 3 ][ "burp" ][ 2 ] = "vox_plr_2_exert_burp_2";
    level.exert_sounds[ 3 ][ "burp" ][ 3 ] = "vox_plr_2_exert_burp_3";
    level.exert_sounds[ 3 ][ "burp" ][ 4 ] = "vox_plr_2_exert_burp_4";
    level.exert_sounds[ 3 ][ "burp" ][ 5 ] = "vox_plr_2_exert_burp_5";
    level.exert_sounds[ 3 ][ "burp" ][ 6 ] = "vox_plr_2_exert_burp_6";
    level.exert_sounds[ 4 ][ "burp" ][ 0 ] = "vox_plr_3_exert_burp_0";
    level.exert_sounds[ 4 ][ "burp" ][ 1 ] = "vox_plr_3_exert_burp_1";
    level.exert_sounds[ 4 ][ "burp" ][ 2 ] = "vox_plr_3_exert_burp_2";
    level.exert_sounds[ 4 ][ "burp" ][ 3 ] = "vox_plr_3_exert_burp_3";
    level.exert_sounds[ 4 ][ "burp" ][ 4 ] = "vox_plr_3_exert_burp_4";
    level.exert_sounds[ 4 ][ "burp" ][ 5 ] = "vox_plr_3_exert_burp_5";
    level.exert_sounds[ 4 ][ "burp" ][ 6 ] = "vox_plr_3_exert_burp_6";
    level.exert_sounds[ 1 ][ "hitmed" ][ 0 ] = "vox_plr_0_exert_pain_0";
    level.exert_sounds[ 1 ][ "hitmed" ][ 1 ] = "vox_plr_0_exert_pain_1";
    level.exert_sounds[ 1 ][ "hitmed" ][ 2 ] = "vox_plr_0_exert_pain_2";
    level.exert_sounds[ 1 ][ "hitmed" ][ 3 ] = "vox_plr_0_exert_pain_3";
    level.exert_sounds[ 1 ][ "hitmed" ][ 4 ] = "vox_plr_0_exert_pain_4";
    level.exert_sounds[ 2 ][ "hitmed" ][ 0 ] = "vox_plr_1_exert_pain_0";
    level.exert_sounds[ 2 ][ "hitmed" ][ 1 ] = "vox_plr_1_exert_pain_1";
    level.exert_sounds[ 2 ][ "hitmed" ][ 2 ] = "vox_plr_1_exert_pain_2";
    level.exert_sounds[ 2 ][ "hitmed" ][ 3 ] = "vox_plr_1_exert_pain_3";
    level.exert_sounds[ 2 ][ "hitmed" ][ 4 ] = "vox_plr_1_exert_pain_4";
    level.exert_sounds[ 3 ][ "hitmed" ][ 0 ] = "vox_plr_2_exert_pain_0";
    level.exert_sounds[ 3 ][ "hitmed" ][ 1 ] = "vox_plr_2_exert_pain_1";
    level.exert_sounds[ 3 ][ "hitmed" ][ 2 ] = "vox_plr_2_exert_pain_2";
    level.exert_sounds[ 3 ][ "hitmed" ][ 3 ] = "vox_plr_2_exert_pain_3";
    level.exert_sounds[ 3 ][ "hitmed" ][ 4 ] = "vox_plr_2_exert_pain_4";
    level.exert_sounds[ 4 ][ "hitmed" ][ 0 ] = "vox_plr_3_exert_pain_0";
    level.exert_sounds[ 4 ][ "hitmed" ][ 1 ] = "vox_plr_3_exert_pain_1";
    level.exert_sounds[ 4 ][ "hitmed" ][ 2 ] = "vox_plr_3_exert_pain_2";
    level.exert_sounds[ 4 ][ "hitmed" ][ 3 ] = "vox_plr_3_exert_pain_3";
    level.exert_sounds[ 4 ][ "hitmed" ][ 3 ] = "vox_plr_3_exert_pain_4";
    level.exert_sounds[ 1 ][ "hitlrg" ][ 0 ] = "vox_plr_0_exert_pain_0";
    level.exert_sounds[ 1 ][ "hitlrg" ][ 1 ] = "vox_plr_0_exert_pain_1";
    level.exert_sounds[ 1 ][ "hitlrg" ][ 2 ] = "vox_plr_0_exert_pain_2";
    level.exert_sounds[ 1 ][ "hitlrg" ][ 3 ] = "vox_plr_0_exert_pain_3";
    level.exert_sounds[ 1 ][ "hitlrg" ][ 4 ] = "vox_plr_0_exert_pain_4";
    level.exert_sounds[ 2 ][ "hitlrg" ][ 0 ] = "vox_plr_1_exert_pain_0";
    level.exert_sounds[ 2 ][ "hitlrg" ][ 1 ] = "vox_plr_1_exert_pain_1";
    level.exert_sounds[ 2 ][ "hitlrg" ][ 2 ] = "vox_plr_1_exert_pain_2";
    level.exert_sounds[ 2 ][ "hitlrg" ][ 3 ] = "vox_plr_1_exert_pain_3";
    level.exert_sounds[ 2 ][ "hitlrg" ][ 4 ] = "vox_plr_1_exert_pain_4";
    level.exert_sounds[ 3 ][ "hitlrg" ][ 0 ] = "vox_plr_2_exert_pain_0";
    level.exert_sounds[ 3 ][ "hitlrg" ][ 1 ] = "vox_plr_2_exert_pain_1";
    level.exert_sounds[ 3 ][ "hitlrg" ][ 2 ] = "vox_plr_2_exert_pain_2";
    level.exert_sounds[ 3 ][ "hitlrg" ][ 3 ] = "vox_plr_2_exert_pain_3";
    level.exert_sounds[ 3 ][ "hitlrg" ][ 4 ] = "vox_plr_2_exert_pain_4";
    level.exert_sounds[ 4 ][ "hitlrg" ][ 0 ] = "vox_plr_3_exert_pain_0";
    level.exert_sounds[ 4 ][ "hitlrg" ][ 1 ] = "vox_plr_3_exert_pain_1";
    level.exert_sounds[ 4 ][ "hitlrg" ][ 2 ] = "vox_plr_3_exert_pain_2";
    level.exert_sounds[ 4 ][ "hitlrg" ][ 3 ] = "vox_plr_3_exert_pain_3";
    level.exert_sounds[ 4 ][ "hitlrg" ][ 4 ] = "vox_plr_3_exert_pain_4";
    level.exert_sounds[ 1 ][ "drowning" ][ 0 ] = "vox_plr_0_exert_underwater_air_low_0";
    level.exert_sounds[ 1 ][ "drowning" ][ 1 ] = "vox_plr_0_exert_underwater_air_low_1";
    level.exert_sounds[ 1 ][ "drowning" ][ 2 ] = "vox_plr_0_exert_underwater_air_low_2";
    level.exert_sounds[ 1 ][ "drowning" ][ 3 ] = "vox_plr_0_exert_underwater_air_low_3";
    level.exert_sounds[ 2 ][ "drowning" ][ 0 ] = "vox_plr_1_exert_underwater_air_low_0";
    level.exert_sounds[ 2 ][ "drowning" ][ 1 ] = "vox_plr_1_exert_underwater_air_low_1";
    level.exert_sounds[ 2 ][ "drowning" ][ 2 ] = "vox_plr_1_exert_underwater_air_low_2";
    level.exert_sounds[ 2 ][ "drowning" ][ 3 ] = "vox_plr_1_exert_underwater_air_low_3";
    level.exert_sounds[ 3 ][ "drowning" ][ 0 ] = "vox_plr_2_exert_underwater_air_low_0";
    level.exert_sounds[ 3 ][ "drowning" ][ 1 ] = "vox_plr_2_exert_underwater_air_low_1";
    level.exert_sounds[ 3 ][ "drowning" ][ 2 ] = "vox_plr_2_exert_underwater_air_low_2";
    level.exert_sounds[ 3 ][ "drowning" ][ 3 ] = "vox_plr_2_exert_underwater_air_low_3";
    level.exert_sounds[ 4 ][ "drowning" ][ 0 ] = "vox_plr_3_exert_underwater_air_low_0";
    level.exert_sounds[ 4 ][ "drowning" ][ 1 ] = "vox_plr_3_exert_underwater_air_low_1";
    level.exert_sounds[ 4 ][ "drowning" ][ 2 ] = "vox_plr_3_exert_underwater_air_low_2";
    level.exert_sounds[ 4 ][ "drowning" ][ 3 ] = "vox_plr_3_exert_underwater_air_low_3";
    level.exert_sounds[ 1 ][ "cough" ][ 0 ] = "vox_plr_0_exert_cough_0";
    level.exert_sounds[ 1 ][ "cough" ][ 1 ] = "vox_plr_0_exert_cough_1";
    level.exert_sounds[ 1 ][ "cough" ][ 2 ] = "vox_plr_0_exert_cough_2";
    level.exert_sounds[ 1 ][ "cough" ][ 3 ] = "vox_plr_0_exert_cough_3";
    level.exert_sounds[ 2 ][ "cough" ][ 0 ] = "vox_plr_1_exert_cough_0";
    level.exert_sounds[ 2 ][ "cough" ][ 1 ] = "vox_plr_1_exert_cough_1";
    level.exert_sounds[ 2 ][ "cough" ][ 2 ] = "vox_plr_1_exert_cough_2";
    level.exert_sounds[ 2 ][ "cough" ][ 3 ] = "vox_plr_1_exert_cough_3";
    level.exert_sounds[ 3 ][ "cough" ][ 0 ] = "vox_plr_2_exert_cough_0";
    level.exert_sounds[ 3 ][ "cough" ][ 1 ] = "vox_plr_2_exert_cough_1";
    level.exert_sounds[ 3 ][ "cough" ][ 2 ] = "vox_plr_2_exert_cough_2";
    level.exert_sounds[ 3 ][ "cough" ][ 3 ] = "vox_plr_2_exert_cough_3";
    level.exert_sounds[ 4 ][ "cough" ][ 0 ] = "vox_plr_3_exert_cough_0";
    level.exert_sounds[ 4 ][ "cough" ][ 1 ] = "vox_plr_3_exert_cough_1";
    level.exert_sounds[ 4 ][ "cough" ][ 2 ] = "vox_plr_3_exert_cough_2";
    level.exert_sounds[ 4 ][ "cough" ][ 3 ] = "vox_plr_3_exert_cough_3";
    level.exert_sounds[ 1 ][ "underwater_emerge" ][ 0 ] = "vox_plr_0_exert_underwater_emerge_0";
    level.exert_sounds[ 1 ][ "underwater_emerge" ][ 1 ] = "vox_plr_0_exert_underwater_emerge_1";
    level.exert_sounds[ 2 ][ "underwater_emerge" ][ 0 ] = "vox_plr_1_exert_underwater_emerge_0";
    level.exert_sounds[ 2 ][ "underwater_emerge" ][ 1 ] = "vox_plr_1_exert_underwater_emerge_1";
    level.exert_sounds[ 3 ][ "underwater_emerge" ][ 0 ] = "vox_plr_2_exert_underwater_emerge_0";
    level.exert_sounds[ 3 ][ "underwater_emerge" ][ 1 ] = "vox_plr_2_exert_underwater_emerge_1";
    level.exert_sounds[ 4 ][ "underwater_emerge" ][ 0 ] = "vox_plr_3_exert_underwater_emerge_0";
    level.exert_sounds[ 4 ][ "underwater_emerge" ][ 1 ] = "vox_plr_3_exert_underwater_emerge_1";
    level.exert_sounds[ 1 ][ "underwater_gasp" ][ 0 ] = "vox_plr_0_exert_underwater_gasp_0";
    level.exert_sounds[ 1 ][ "underwater_gasp" ][ 1 ] = "vox_plr_0_exert_underwater_gasp_1";
    level.exert_sounds[ 2 ][ "underwater_gasp" ][ 0 ] = "vox_plr_1_exert_underwater_gasp_0";
    level.exert_sounds[ 2 ][ "underwater_gasp" ][ 1 ] = "vox_plr_1_exert_underwater_gasp_1";
    level.exert_sounds[ 3 ][ "underwater_gasp" ][ 0 ] = "vox_plr_2_exert_underwater_gasp_0";
    level.exert_sounds[ 3 ][ "underwater_gasp" ][ 1 ] = "vox_plr_2_exert_underwater_gasp_1";
    level.exert_sounds[ 4 ][ "underwater_gasp" ][ 0 ] = "vox_plr_3_exert_underwater_gasp_0";
    level.exert_sounds[ 4 ][ "underwater_gasp" ][ 1 ] = "vox_plr_3_exert_underwater_gasp_1";
}

// Namespace zm_island
// Params 0
// Checksum 0xe84a6fe0, Offset: 0x6598
// Size: 0x34
function custom_add_weapons()
{
    zm_weapons::load_weapon_spec_from_table( "gamedata/weapons/zm/zm_island_weapons.csv", 1 );
    zm_weapons::autofill_wallbuys_init();
}

// Namespace zm_island
// Params 0
// Checksum 0x3bd981b9, Offset: 0x65d8
// Size: 0x1c
function custom_add_vox()
{
    zm_audio::loadplayervoicecategories( "gamedata/audio/zm/zm_island_vox.csv" );
}

// Namespace zm_island
// Params 0
// Checksum 0x8b2fbadf, Offset: 0x6600
// Size: 0x1c
function sndfunctions()
{
    level thread setupmusic();
}

// Namespace zm_island
// Params 0
// Checksum 0x7facfb24, Offset: 0x6628
// Size: 0x1cc
function setupmusic()
{
    zm_audio::musicstate_create( "round_start", 3, "island_roundstart_1", "island_roundstart_2", "island_roundstart_3", "island_roundstart_4" );
    zm_audio::musicstate_create( "round_start_short", 3, "island_roundstart_1", "island_roundstart_2", "island_roundstart_3", "island_roundstart_4" );
    zm_audio::musicstate_create( "round_start_first", 3, "island_roundstart_1", "island_roundstart_2", "island_roundstart_3", "island_roundstart_4" );
    zm_audio::musicstate_create( "round_end", 3, "island_roundend_1", "island_roundend_2", "island_roundend_3", "island_roundend_4" );
    zm_audio::musicstate_create( "spider_roundstart", 3, "island_spider_roundstart_1" );
    zm_audio::musicstate_create( "spider_roundend", 3, "island_spider_roundend_1" );
    zm_audio::musicstate_create( "game_over", 5, "island_gameover" );
    zm_audio::musicstate_create( "dead_flowers", 4, "dead_flowers" );
    zm_audio::musicstate_create( "none", 4, "none" );
}

// Namespace zm_island
// Params 1
// Checksum 0xac18cb3d, Offset: 0x6800
// Size: 0x94, Type: bool
function function_66e965d8( player )
{
    if ( isdefined( player.thrasherconsumed ) && player.thrasherconsumed )
    {
        return false;
    }
    
    if ( self.powerup_name == "island_seed" && player clientfield::get_to_player( "has_island_seed" ) == 3 )
    {
        player thread function_3ef1c13e();
        return false;
    }
    
    return true;
}

// Namespace zm_island
// Params 0
// Checksum 0xbe20a297, Offset: 0x68a0
// Size: 0x62
function function_3ef1c13e()
{
    if ( !( isdefined( self.var_521815d8 ) && self.var_521815d8 ) )
    {
        self.var_521815d8 = 1;
        self thread zm_equipment::show_hint_text( &"ZM_ISLAND_SEED_POWERUP_DENIED", 3 );
        wait 6;
        self.var_521815d8 = undefined;
    }
}

// Namespace zm_island
// Params 0
// Checksum 0xfbfec69a, Offset: 0x6910
// Size: 0x20c
function function_8608b597()
{
    if ( !zm_utility::check_point_in_playable_area( self.origin ) )
    {
        e_closest_player = arraygetclosest( self.origin, level.players );
        v_player_pos = e_closest_player.origin;
        a_v_pos = util::positionquery_pointarray( v_player_pos, 64, 256, 32, 64 );
        var_144498b3 = [];
        
        foreach ( v_pos in a_v_pos )
        {
            if ( zm_utility::check_point_in_playable_area( v_pos ) )
            {
                if ( !isdefined( var_144498b3 ) )
                {
                    var_144498b3 = [];
                }
                else if ( !isarray( var_144498b3 ) )
                {
                    var_144498b3 = array( var_144498b3 );
                }
                
                var_144498b3[ var_144498b3.size ] = v_pos;
            }
        }
        
        var_18130313 = arraygetfarthest( v_player_pos, var_144498b3 );
        
        if ( isdefined( var_18130313 ) )
        {
            self.origin = var_18130313 + ( 0, 0, 40 );
        }
    }
    
    self setmodel( level.zombie_powerups[ "ww_grenade" ].model_name );
}

// Namespace zm_island
// Params 0
// Checksum 0x86cd3e0d, Offset: 0x6b28
// Size: 0x1a2
function placed_powerups()
{
    array::thread_all( getentarray( "power_up_web", "targetname" ), &function_726351cf );
    zm_powerups::powerup_round_start();
    a_bonus_types = [];
    array::add( a_bonus_types, "double_points" );
    array::add( a_bonus_types, "insta_kill" );
    array::add( a_bonus_types, "full_ammo" );
    a_bonus = struct::get_array( "placed_powerup", "targetname" );
    
    foreach ( s_bonus in a_bonus )
    {
        str_type = array::random( a_bonus_types );
        spawn_infinite_powerup_drop( s_bonus.origin, str_type );
    }
}

// Namespace zm_island
// Params 2
// Checksum 0xbb0afdb3, Offset: 0x6cd8
// Size: 0x8a
function spawn_infinite_powerup_drop( v_origin, str_type )
{
    level._powerup_timeout_override = &powerup_infinite_time;
    
    if ( isdefined( str_type ) )
    {
        var_9f6494 = zm_powerups::specific_powerup_drop( str_type, v_origin );
    }
    else
    {
        var_9f6494 = zm_powerups::powerup_drop( v_origin );
    }
    
    level._powerup_timeout_override = undefined;
}

// Namespace zm_island
// Params 0
// Checksum 0x99ec1590, Offset: 0x6d70
// Size: 0x4
function powerup_infinite_time()
{
    
}

// Namespace zm_island
// Params 0
// Checksum 0x9596debc, Offset: 0x6d80
// Size: 0x1fc
function function_726351cf()
{
    self setcandamage( 1 );
    e_clip = getent( self.target, "targetname" );
    self clientfield::set( "set_heavy_web_fade_material", 1 );
    
    while ( true )
    {
        self waittill( #"damage", damage, attacker, direction_vec, point, type, modelname, tagname, partname, weapon, idflags );
        
        if ( mirg2000::is_wonder_weapon( weapon ) )
        {
            if ( mirg2000::is_wonder_weapon( weapon, "upgraded" ) )
            {
                self thread fx::play( "special_web_dissolve_ug", self.origin, self.angles );
            }
            else
            {
                self thread fx::play( "special_web_dissolve", self.origin, self.angles );
            }
            
            self clientfield::set( "set_heavy_web_fade_material", 0 );
            self notsolid();
            wait 3;
            self delete();
            e_clip delete();
            break;
        }
    }
}

// Namespace zm_island
// Params 0
// Checksum 0x93f1981a, Offset: 0x6f88
// Size: 0x158
function function_1f00b569()
{
    level flag::wait_till( "first_player_spawned" );
    wait 5;
    level thread exploder::exploder( "ex_lightning_start" );
    e_player = array::random( level.activeplayers );
    e_player playsound( "zmb_island_lightning_first" );
    wait 3;
    level notify( #"hash_5574fd9b" );
    level thread exploder::exploder( "ex_lightning_start" );
    e_player = array::random( level.activeplayers );
    e_player playsound( "zmb_island_lightning_first" );
    wait 8;
    
    while ( true )
    {
        e_player = array::random( level.activeplayers );
        e_player thread function_37f2c48b();
        wait randomfloatrange( 30, 60 );
    }
}

// Namespace zm_island
// Params 0
// Checksum 0x28a7b05d, Offset: 0x70e8
// Size: 0x12c
function function_37f2c48b()
{
    var_f97c401 = self zm_utility::get_current_zone();
    
    if ( isdefined( var_f97c401 ) )
    {
        switch ( var_f97c401 )
        {
            case "zone_start":
            case "zone_start_2":
            case "zone_start_water":
                var_c490d0cd = "ex_lightning_start";
                break;
            case "zone_ruins":
                var_c490d0cd = "ex_lightning_ruins";
                break;
            case "zone_swamp":
            case "zone_swamp_lab":
            default:
                var_c490d0cd = "ex_lightning_swamp";
                break;
            case "zone_jungle":
            case "zone_jungle_lab":
                var_c490d0cd = "ex_lightning_jungle";
                break;
            case "zone_bunker_exterior":
                var_c490d0cd = "ex_lightning_bunkerTop";
                break;
            case "zone_crash_site":
                var_c490d0cd = "ex_lightning_crash";
                break;
        }
        
        if ( isdefined( var_c490d0cd ) )
        {
            level thread function_bf1537b3( var_c490d0cd, self );
        }
    }
}

// Namespace zm_island
// Params 2
// Checksum 0x894fb30a, Offset: 0x7220
// Size: 0xc6
function function_bf1537b3( var_c490d0cd, e_player )
{
    for ( i = 0; i < randomintrange( 3, 7 ) ; i++ )
    {
        wait randomfloatrange( 0.8, 1.3 );
        
        if ( math::cointoss() )
        {
            if ( isdefined( e_player ) )
            {
                e_player playsound( "zmb_island_lightning" );
            }
        }
        
        level thread exploder::exploder( var_c490d0cd );
    }
}

// Namespace zm_island
// Params 0
// Checksum 0xc13ae0fa, Offset: 0x72f0
// Size: 0xb0
function function_6ca6d73d()
{
    self endon( #"disconnect" );
    self flag::wait_till( "has_skull" );
    
    while ( true )
    {
        if ( self util::attack_button_held() && self keeper_skull::function_97d08b97() )
        {
            self thread function_a9938318();
            self playrumbleonentity( "zm_island_skull_reveal" );
            wait 2;
        }
        
        wait 0.05;
    }
}

// Namespace zm_island
// Params 0
// Checksum 0x363bdb29, Offset: 0x73a8
// Size: 0x6c
function function_a9938318()
{
    self notify( #"hash_54edbfd4" );
    self endon( #"disconnect" );
    self endon( #"hash_54edbfd4" );
    
    while ( self util::attack_button_held() )
    {
        wait 0.05;
    }
    
    self stoprumble( "zm_island_skull_reveal" );
}

// Namespace zm_island
// Params 0
// Checksum 0xf2543f65, Offset: 0x7420
// Size: 0x10c
function function_94fc6a19()
{
    var_9e262618 = spawn( "trigger_radius", ( -1062, -121, 6 ), 0, 32, 100 );
    var_102d9553 = spawn( "trigger_radius", ( -1803, 1404, 62 ), 0, 32, 50 );
    var_ea2b1aea = spawn( "trigger_radius", ( 2158.5, 768, -270.5 ), 0, 32, 50 );
    var_9e262618 thread function_5a24e391( 1 );
    var_102d9553 thread function_5a24e391( 2 );
    var_ea2b1aea thread function_5a24e391( 3 );
}

// Namespace zm_island
// Params 1
// Checksum 0xb1b1af15, Offset: 0x7538
// Size: 0x234
function function_5a24e391( var_5ef5ba1 )
{
    self.var_796bbfeb = spawnstruct();
    self.var_796bbfeb.var_cb6e479f = [];
    
    switch ( var_5ef5ba1 )
    {
        case 1:
            var_a031d2e0 = ( -1019, -102, -135 );
            var_1239421b = ( -1021, -140, -135 );
            var_ec36c7b2 = ( -1062, -166, -135 );
            var_5e3e36ed = ( -1105, -151, -135 );
            break;
        case 2:
            var_a031d2e0 = ( -1827, 1451, -50 );
            var_1239421b = ( -1790, 1461, -50 );
            var_ec36c7b2 = ( -1753, 1433, -50 );
            var_5e3e36ed = ( -1750, 1399, -50 );
            break;
        case 3:
            var_a031d2e0 = ( 2185, 725, -346 );
            var_1239421b = ( 2143, 725, -346 );
            var_ec36c7b2 = ( 2111, 753, -346 );
            var_5e3e36ed = ( 2124, 791, -346 );
            break;
    }
    
    array::add( self.var_796bbfeb.var_cb6e479f, var_a031d2e0 );
    array::add( self.var_796bbfeb.var_cb6e479f, var_1239421b );
    array::add( self.var_796bbfeb.var_cb6e479f, var_ec36c7b2 );
    array::add( self.var_796bbfeb.var_cb6e479f, var_5e3e36ed );
    self thread function_cdab50cc();
}

// Namespace zm_island
// Params 0
// Checksum 0xa9f03550, Offset: 0x7778
// Size: 0x88
function function_cdab50cc()
{
    self setteamfortrigger( "allies" );
    
    while ( true )
    {
        self waittill( #"trigger", e_player );
        
        if ( !( isdefined( e_player.var_32ad034f ) && e_player.var_32ad034f ) )
        {
            e_player thread function_6c2447b1( self );
        }
    }
}

// Namespace zm_island
// Params 1
// Checksum 0x65060767, Offset: 0x7808
// Size: 0x124
function function_6c2447b1( var_df0dbc71 )
{
    self endon( #"disconnect" );
    self endon( #"player_downed" );
    self.var_32ad034f = 1;
    wait 2;
    
    if ( !self istouching( var_df0dbc71 ) )
    {
        self.var_32ad034f = 0;
        return;
    }
    
    v_moveto = undefined;
    var_8b72a0e = array::randomize( var_df0dbc71.var_796bbfeb.var_cb6e479f );
    
    for ( i = 0; i < var_8b72a0e.size ; i++ )
    {
        if ( !positionwouldtelefrag( var_8b72a0e[ i ] ) )
        {
            v_moveto = var_8b72a0e[ i ];
            break;
        }
    }
    
    self.var_32ad034f = 0;
    self setorigin( v_moveto );
}

// Namespace zm_island
// Params 0
// Checksum 0x67056ac6, Offset: 0x7938
// Size: 0x100
function function_8a2a48bb()
{
    var_771ec2b = spawn( "trigger_box", ( -3917, 875.5, -247.5 ), 0, 128, 256, 64 );
    var_771ec2b.angles = ( 0, 342.397, 0 );
    var_771ec2b setteamfortrigger( "allies" );
    
    while ( true )
    {
        var_771ec2b waittill( #"trigger", e_player );
        
        if ( !( isdefined( e_player.var_66064486 ) && e_player.var_66064486 ) )
        {
            e_player thread function_41c3dc27( var_771ec2b );
        }
    }
}

// Namespace zm_island
// Params 1
// Checksum 0xdf93440, Offset: 0x7a40
// Size: 0x1fc
function function_41c3dc27( var_771ec2b )
{
    self endon( #"disconnect" );
    var_8b72a0e = [];
    var_230ad12c = ( -4046, 923.5, -311 );
    var_95124067 = ( -4045, 1004.5, -311 );
    var_6f0fc5fe = ( -4075, 873.5, -311 );
    var_b10361f1 = ( -4074, 825.5, -311 );
    array::add( var_8b72a0e, var_230ad12c );
    array::add( var_8b72a0e, var_95124067 );
    array::add( var_8b72a0e, var_6f0fc5fe );
    array::add( var_8b72a0e, var_b10361f1 );
    self.var_66064486 = 1;
    wait 2;
    
    if ( !self istouching( var_771ec2b ) )
    {
        self.var_66064486 = 0;
        return;
    }
    
    v_moveto = undefined;
    var_8eb2dd6e = array::randomize( var_8b72a0e );
    
    for ( i = 0; i < var_8eb2dd6e.size ; i++ )
    {
        if ( !positionwouldtelefrag( var_8eb2dd6e[ i ] ) )
        {
            v_moveto = var_8eb2dd6e[ i ];
            break;
        }
    }
    
    self.var_66064486 = 0;
    self setorigin( v_moveto );
}

