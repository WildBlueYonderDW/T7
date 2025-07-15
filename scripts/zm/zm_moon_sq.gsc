#using scripts/codescripts/struct;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/scene_shared;
#using scripts/shared/sound_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_zm;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_bgb;
#using scripts/zm/_zm_equip_hacker;
#using scripts/zm/_zm_perks;
#using scripts/zm/_zm_powerups;
#using scripts/zm/_zm_sidequests;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_weap_microwavegun;
#using scripts/zm/_zm_weapons;
#using scripts/zm/zm_moon_amb;
#using scripts/zm/zm_moon_sq;
#using scripts/zm/zm_moon_sq_be;
#using scripts/zm/zm_moon_sq_ctt;
#using scripts/zm/zm_moon_sq_ctvg;
#using scripts/zm/zm_moon_sq_datalogs;
#using scripts/zm/zm_moon_sq_osc;
#using scripts/zm/zm_moon_sq_sc;
#using scripts/zm/zm_moon_sq_ss;

#namespace zm_moon_sq;

// Namespace zm_moon_sq
// Params 0
// Checksum 0x10bf1914, Offset: 0x928
// Size: 0x36c
function init()
{
    ss_buttons = getentarray( "sq_ss_button", "targetname" );
    
    for ( i = 0; i < ss_buttons.size ; i++ )
    {
        ss_buttons[ i ] usetriggerrequirelookat();
        ss_buttons[ i ] sethintstring( "" );
        ss_buttons[ i ] setcursorhint( "HINT_NOICON" );
    }
    
    level flag::init( "first_tanks_charged" );
    level flag::init( "second_tanks_charged" );
    level flag::init( "first_tanks_drained" );
    level flag::init( "second_tanks_drained" );
    level flag::init( "c_built" );
    level flag::init( "vg_charged" );
    level flag::init( "switch_done" );
    level flag::init( "be2" );
    level flag::init( "ss1" );
    level flag::init( "soul_swap_done" );
    zm_sidequests::declare_sidequest( "sq", &init_sidequest, &sidequest_logic, &complete_sidequest, &generic_stage_start, &generic_stage_complete );
    zm_moon_sq_ss::init_1();
    zm_moon_sq_ss::init_2();
    zm_moon_sq_osc::init();
    zm_moon_sq_sc::init();
    zm_moon_sq_sc::init_2();
    zm_sidequests::declare_sidequest( "tanks", undefined, undefined, undefined, undefined, undefined );
    zm_moon_sq_ctt::init_1();
    zm_moon_sq_ctt::init_2();
    zm_sidequests::declare_sidequest( "ctvg", undefined, undefined, undefined, undefined, undefined );
    zm_moon_sq_ctvg::init();
    zm_sidequests::declare_sidequest( "be", undefined, undefined, undefined, undefined, undefined );
    zm_moon_sq_be::init();
    sd_init();
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x53be1393, Offset: 0xca0
// Size: 0x32c
function init_clientfields()
{
    zm_sidequests::register_sidequest_icon( "vril", 21000 );
    zm_sidequests::register_sidequest_icon( "anti115", 21000 );
    zm_sidequests::register_sidequest_icon( "generator", 21000 );
    zm_sidequests::register_sidequest_icon( "cgenerator", 21000 );
    zm_sidequests::register_sidequest_icon( "wire", 21000 );
    zm_sidequests::register_sidequest_icon( "datalog", 21000 );
    clientfield::register( "world", "raise_rockets", 21000, 1, "counter" );
    clientfield::register( "world", "rocket_launch", 21000, 1, "counter" );
    clientfield::register( "world", "rocket_explode", 21000, 1, "counter" );
    clientfield::register( "world", "charge_tank_1", 21000, 1, "counter" );
    clientfield::register( "world", "charge_tank_2", 21000, 1, "counter" );
    clientfield::register( "world", "charge_tank_cleanup", 21000, 1, "counter" );
    clientfield::register( "world", "sam_vo_rumble", 21000, 1, "int" );
    clientfield::register( "world", "charge_vril_init", 21000, 1, "int" );
    clientfield::register( "world", "sq_wire_init", 21000, 1, "int" );
    clientfield::register( "world", "sam_init", 21000, 1, "int" );
    n_bits = getminbitcountfornum( 4 );
    clientfield::register( "world", "vril_generator", 21000, n_bits, "int" );
    clientfield::register( "world", "sam_end_rumble", 21000, 1, "int" );
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x605cb2cd, Offset: 0xfd8
// Size: 0x54
function reward()
{
    level notify( #"moon_sidequest_achieved" );
    players = getplayers();
    array::thread_all( players, &give_perk_reward );
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x4aad2947, Offset: 0x1038
// Size: 0x106
function watch_for_respawn()
{
    self endon( #"disconnect" );
    
    while ( true )
    {
        self waittill( #"spawned_player" );
        waittillframeend();
        
        foreach ( perk in level._sq_perk_array )
        {
            if ( !self hasperk( perk ) )
            {
                if ( zm_perks::use_solo_revive() && perk == "specialty_quickrevive" )
                {
                    continue;
                }
                
                self zm_perks::give_perk( perk );
            }
        }
    }
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x50a625b5, Offset: 0x1148
// Size: 0x15c
function give_perk_reward()
{
    if ( isdefined( self._retain_perks ) )
    {
        return;
    }
    
    if ( !isdefined( level._sq_perk_array ) )
    {
        level._sq_perk_array = [];
        machines = getentarray( "zombie_vending", "targetname" );
        
        for ( i = 0; i < machines.size ; i++ )
        {
            level._sq_perk_array[ level._sq_perk_array.size ] = machines[ i ].script_noteworthy;
        }
    }
    
    for ( i = 0; i < level._sq_perk_array.size ; i++ )
    {
        if ( !self hasperk( level._sq_perk_array[ i ] ) )
        {
            self playsound( "evt_sq_bag_gain_perks" );
            self zm_perks::give_perk( level._sq_perk_array[ i ] );
            wait 0.25;
        }
    }
    
    self._retain_perks = 1;
    self thread watch_for_respawn();
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0xdc773eea, Offset: 0x12b0
// Size: 0x4c
function start_moon_sidequest()
{
    init();
    level flag::wait_till( "start_zombie_round_logic" );
    zm_sidequests::sidequest_start( "sq" );
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0xf8c8ce2b, Offset: 0x1308
// Size: 0x27c
function init_sidequest()
{
    players = getplayers();
    level._all_previous_done = 0;
    level._zombiemode_sidequest_icon_offset = -32;
    
    for ( i = 0; i < players.size ; i++ )
    {
        entnum = players[ i ].characterindex;
        println( "<dev string:x28>" + entnum );
        
        if ( isdefined( players[ i ].zm_random_char ) )
        {
            entnum = players[ i ].zm_random_char;
        }
        
        if ( entnum == 2 )
        {
            devmode = 1;
            
            if ( devmode )
            {
                players[ i ] zm_sidequests::add_sidequest_icon( "sq", "generator", 0 );
                level._all_previous_done = 1;
                continue;
            }
            
            if ( level.onlinegame )
            {
                if ( zm::is_sidequest_previously_completed( "EOA" ) )
                {
                    players[ i ] zm_sidequests::add_sidequest_icon( "sq", "generator", 0 );
                    level._all_previous_done = 1;
                    break;
                }
                
                players[ i ] zm_sidequests::add_sidequest_icon( "sq", "vril", 0 );
                break;
            }
        }
    }
    
    level thread tanks();
    level thread cassimir();
    level thread be();
    level thread zm_moon_sq_datalogs::init();
    
    if ( 1 == getdvarint( "scr_debug_launch" ) )
    {
        level thread rocket_test();
    }
    
    level thread rocket_raise();
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0xfd417ab, Offset: 0x1590
// Size: 0x74
function rocket_test()
{
    level flag::wait_till( "power_on" );
    wait 5;
    level notify( #"rl" );
    wait 2;
    level notify( #"rl" );
    wait 2;
    level notify( #"rl" );
    level thread do_launch();
}

// Namespace zm_moon_sq
// Params 1
// Checksum 0x559900b8, Offset: 0x1610
// Size: 0x15e
function rocket_raise( player_num )
{
    rockets = getentarray( "moon_rockets", "script_noteworthy" );
    array::thread_all( rockets, &nml_show_hide );
    
    for ( i = 3; i > 0 ; i-- )
    {
        level waittill( #"rl" );
        level clientfield::increment( "raise_rockets" );
        rockets[ i - 1 ] playsound( "evt_rocket_move_up" );
        str_scene = "p7_fxanim_zmhd_moon_rocket_launch_0" + i + "_bundle";
        level thread scene::init( str_scene );
    }
    
    level waittill( #"rl" );
    
    for ( i = 0; i < 3 ; i++ )
    {
        rockets[ i ] thread launch();
    }
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x3e5123e9, Offset: 0x1778
// Size: 0x90
function nml_show_hide()
{
    level endon( #"intermission" );
    self endon( #"death" );
    
    while ( true )
    {
        level flag::wait_till( "enter_nml" );
        self ghost();
        level flag::wait_till_clear( "enter_nml" );
        self show();
    }
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x230ce589, Offset: 0x1810
// Size: 0x13c
function launch()
{
    level clientfield::increment( "rocket_launch" );
    wait randomfloatrange( 0.1, 1 );
    self playsound( "evt_rocket_launch" );
    
    if ( !isdefined( level._n_rockets ) )
    {
        level._n_rockets = 0;
    }
    
    level._n_rockets++;
    println( "<dev string:x35>" + level._n_rockets + "<dev string:x3d>" );
    str_scene = "p7_fxanim_zmhd_moon_rocket_launch_0" + level._n_rockets + "_bundle";
    level thread zm_audio::sndmusicsystem_playstate( "end_is_near" );
    level scene::play( str_scene );
    println( "<dev string:x35>" + level._n_rockets + "<dev string:x49>" );
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x10d24ccb, Offset: 0x1958
// Size: 0x19c
function sidequest_logic()
{
    level thread sq_flatcard_logic();
    level flag::wait_till( "power_on" );
    zm_sidequests::stage_start( "sq", "ss1" );
    level flag::wait_till( "ss1" );
    zm_sidequests::stage_start( "sq", "osc" );
    level waittill( #"sq_osc_over" );
    level flag::wait_till( "complete_be_1" );
    wait 4;
    zm_sidequests::stage_start( "sq", "sc" );
    level waittill( #"sq_sc_over" );
    level flag::wait_till( "vg_charged" );
    zm_sidequests::stage_start( "sq", "sc2" );
    level waittill( #"sq_sc2_over" );
    wait 5;
    level thread maxis_story_vox();
    level waittill( #"sq_ss2_over" );
    level flag::wait_till( "be2" );
    level thread do_launch();
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x1b80b39a, Offset: 0x1b00
// Size: 0x22e
function do_launch()
{
    foreach ( e_player in level.players )
    {
        if ( e_player bgb::is_active( "zm_bgb_killing_time" ) )
        {
            e_player bgb::take();
        }
    }
    
    level.var_d8417111 = 1;
    zm_utility::play_sound_2d( "vox_xcomp_quest_step8_4" );
    wait 10;
    level notify( #"rl" );
    wait 30;
    zm_utility::play_sound_2d( "vox_xcomp_quest_step8_5" );
    wait 30;
    zm_utility::play_sound_2d( "evt_earth_explode" );
    level clientfield::increment( "rocket_explode" );
    util::wait_network_frame();
    util::wait_network_frame();
    exploder::exploder( "fxexp_2012" );
    wait 2;
    level clientfield::increment( "show_destroyed_earth" );
    level._dte_done = 1;
    level notify( #"moon_sidequest_big_bang_achieved" );
    zm_utility::play_sound_2d( "vox_xcomp_quest_laugh" );
    level thread play_end_lines_in_order();
    reward();
    level util::set_lighting_state( 1 );
    level function_7aca917c();
    level.var_d8417111 = undefined;
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x2e590baf, Offset: 0x1d38
// Size: 0x84
function function_7aca917c()
{
    if ( isdefined( level.var_1b3f87f7 ) )
    {
        level.var_1b3f87f7 delete();
    }
    
    level.var_1b3f87f7 = createstreamerhint( level.activeplayers[ 0 ].origin, 1, 0 );
    level.var_1b3f87f7 setlightingonly( 1 );
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x5a747106, Offset: 0x1dc8
// Size: 0x240
function play_end_lines_in_order()
{
    level.skit_vox_override = 1;
    players = getplayers();
    players[ randomintrange( 0, players.size ) ] thread zm_audio::create_and_play_dialog( "eggs", "quest8", 7 );
    wait 12;
    player = get_specific_player( 0 );
    
    if ( isdefined( player ) )
    {
        player thread zm_audio::create_and_play_dialog( "eggs", "quest8", 9 );
        wait 5;
    }
    
    player = get_specific_player( 1 );
    
    if ( isdefined( player ) )
    {
        player thread zm_audio::create_and_play_dialog( "eggs", "quest8", 9 );
        wait 5;
    }
    
    player = get_specific_player( 2 );
    
    if ( isdefined( player ) )
    {
        player thread zm_audio::create_and_play_dialog( "eggs", "quest8", 9 );
        wait 5;
    }
    
    player = get_specific_player( 3 );
    
    if ( isdefined( player ) )
    {
        player thread zm_audio::create_and_play_dialog( "eggs", "quest8", 9 );
        wait 5;
    }
    
    player = get_specific_player( 3 );
    
    if ( isdefined( player ) )
    {
        player thread zm_audio::create_and_play_dialog( "eggs", "quest8", 10 );
    }
    
    level.skit_vox_override = 0;
}

// Namespace zm_moon_sq
// Params 1
// Checksum 0xca50e0bf, Offset: 0x2010
// Size: 0xbe
function get_specific_player( num )
{
    players = getplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        ent_num = players[ i ].characterindex;
        
        if ( isdefined( players[ i ].zm_random_char ) )
        {
            ent_num = players[ i ].zm_random_char;
        }
        
        if ( ent_num == num )
        {
            return players[ i ];
        }
    }
    
    return undefined;
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x9fa88fd7, Offset: 0x20d8
// Size: 0xf4
function maxis_story_vox()
{
    s = struct::get( "sq_vg_final", "targetname" );
    level.skit_vox_override = 1;
    sound::play_in_space( "vox_plr_2_quest_step6_9", s.origin );
    wait 2.3;
    sound::play_in_space( "vox_plr_2_quest_step6_11", s.origin );
    wait 10.5;
    sound::play_in_space( "vox_xcomp_quest_step6_14", s.origin );
    level.skit_vox_override = 0;
    zm_sidequests::stage_start( "sq", "ss2" );
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0xfe6442f1, Offset: 0x21d8
// Size: 0x5c
function be()
{
    zm_sidequests::stage_start( "be", "stage_one" );
    level waittill( #"sq_sc2_over" );
    wait 2;
    zm_sidequests::stage_start( "be", "stage_two" );
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x45156d15, Offset: 0x2240
// Size: 0x94
function tanks()
{
    level flag::wait_till( "complete_be_1" );
    wait 4;
    zm_sidequests::stage_start( "tanks", "ctt1" );
    level waittill( #"sq_sc_over" );
    level flag::wait_till( "vg_charged" );
    zm_sidequests::stage_start( "tanks", "ctt2" );
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0xfe5b2d22, Offset: 0x22e0
// Size: 0x5c
function cassimir()
{
    zm_sidequests::stage_start( "ctvg", "build" );
    level waittill( #"ctvg_build_over" );
    wait 5;
    zm_sidequests::stage_start( "ctvg", "charge" );
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0xcad7aad, Offset: 0x2348
// Size: 0x90
function cheat_complete_stage()
{
    level endon( #"reset_sundial" );
    
    while ( true )
    {
        if ( getdvarstring( "cheat_sq" ) != "" )
        {
            if ( isdefined( level._last_stage_started ) )
            {
                setdvar( "cheat_sq", "" );
                zm_sidequests::stage_completed( "sq", level._last_stage_started );
            }
        }
        
        wait 0.1;
    }
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0xdc8f24ee, Offset: 0x23e0
// Size: 0x28
function generic_stage_start()
{
    /#
        level thread cheat_complete_stage();
    #/
    
    level._stage_active = 1;
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x33fd8d1, Offset: 0x2410
// Size: 0x10
function generic_stage_complete()
{
    level._stage_active = 0;
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0xa4d77552, Offset: 0x2428
// Size: 0x1c
function complete_sidequest()
{
    level thread sidequest_done();
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x99ec1590, Offset: 0x2450
// Size: 0x4
function sidequest_done()
{
    
}

// Namespace zm_moon_sq
// Params 1
// Checksum 0x4768315c, Offset: 0x2460
// Size: 0xaa
function get_variant_from_entity_num( player_number )
{
    if ( !isdefined( player_number ) )
    {
        player_number = 0;
    }
    
    post_fix = "a";
    
    switch ( player_number )
    {
        case 0:
            post_fix = "a";
            break;
        case 1:
            post_fix = "b";
            break;
        case 2:
            post_fix = "c";
            break;
        case 3:
            post_fix = "d";
            break;
    }
    
    return post_fix;
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0xffc80510, Offset: 0x2518
// Size: 0x100
function sq_flatcard_logic()
{
    nml_set = 0;
    
    while ( true )
    {
        if ( level flag::get( "enter_nml" ) && !nml_set )
        {
            if ( isdefined( level._dte_done ) && ( !isdefined( level._dte_done ) || level._dte_done ) )
            {
                level clientfield::increment( "hide_earth" );
            }
            
            nml_set = 1;
        }
        else if ( !level flag::get( "enter_nml" ) && nml_set )
        {
            if ( !isdefined( level._dte_done ) )
            {
                level clientfield::increment( "show_earth" );
            }
            
            nml_set = 0;
        }
        
        wait 0.1;
    }
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x8bcc1f, Offset: 0x2620
// Size: 0x23c
function sd_init()
{
    zm_spawner::add_custom_zombie_spawn_logic( &function_69090b83 );
    level flag::init( "sd_active" );
    level flag::wait_till( "start_zombie_round_logic" );
    level.var_c920d4c5 = struct::get( "sd_bowl", "targetname" );
    a_start = struct::get_array( "sd_start", "script_noteworthy" );
    
    foreach ( s_start in a_start )
    {
        var_12a1091 = util::spawn_model( s_start.model, s_start.origin, s_start.angles );
        var_12a1091.targetname = s_start.targetname;
        var_12a1091 setscale( s_start.script_float );
        var_2ad32714 = spawn( "trigger_damage", var_12a1091.origin, 0, 15, 15 );
        zm_weap_microwavegun::add_microwaveable_object( var_2ad32714 );
        var_12a1091 thread function_7e76fe45( var_2ad32714 );
        level flag::init( var_12a1091.targetname );
    }
    
    level thread function_4ee03f50();
}

// Namespace zm_moon_sq
// Params 1
// Checksum 0x868774fc, Offset: 0x2868
// Size: 0x128
function function_7e76fe45( var_2ad32714 )
{
    self endon( #"death" );
    
    while ( true )
    {
        var_2ad32714 waittill( #"microwaved" );
        level flag::set( self.targetname );
        var_6be16785 = struct::get( self.targetname + "_final", "targetname" );
        var_aee26521 = util::spawn_model( self.model, var_6be16785.origin, var_6be16785.angles );
        var_aee26521 setscale( var_6be16785.script_float );
        wait 0.05;
        var_2ad32714 delete();
        self delete();
    }
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x9bc57cf0, Offset: 0x2998
// Size: 0x1d4
function function_4ee03f50()
{
    a_start = struct::get_array( "sd_start", "script_noteworthy" );
    a_flags = [];
    
    foreach ( s_start in a_start )
    {
        if ( !isdefined( a_flags ) )
        {
            a_flags = [];
        }
        else if ( !isarray( a_flags ) )
        {
            a_flags = array( a_flags );
        }
        
        a_flags[ a_flags.size ] = s_start.targetname;
    }
    
    if ( !a_flags.size )
    {
        return;
    }
    
    level flag::wait_till_all( a_flags );
    s_sd = struct::get( "sd_bowl", "targetname" );
    s_sd.radius = 65;
    s_sd.height = 72;
    s_sd.script_float = 7;
    s_sd.custom_string = &"ZM_MOON_HACK_SILENT";
    zm_equip_hacker::register_pooled_hackable_struct( s_sd, &function_9391498d );
}

// Namespace zm_moon_sq
// Params 1
// Checksum 0x89d73f02, Offset: 0x2b78
// Size: 0x74
function function_9391498d( hacker )
{
    zm_equip_hacker::deregister_hackable_struct( self );
    level flag::set( "sd_active" );
    level thread function_948d4e7d();
    level thread function_66951281();
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0xdb040487, Offset: 0x2bf8
// Size: 0x1da
function function_948d4e7d()
{
    level flag::init( "sd_large_complete" );
    var_9f30ae72 = struct::get( "sd_big_soul", "targetname" );
    var_51aa97ed = util::spawn_model( var_9f30ae72.model, var_9f30ae72.origin, var_9f30ae72.angles );
    var_51aa97ed setscale( var_9f30ae72.script_float );
    var_c1b1cd1c = 2.3 / 30;
    var_fa77a9e7 = 0;
    
    while ( true )
    {
        level waittill( #"sd_zombie" );
        
        if ( var_fa77a9e7 < 30 )
        {
            var_fa77a9e7++;
            var_51aa97ed.origin += ( 0, 0, var_c1b1cd1c );
            continue;
        }
        
        level flag::set( "sd_large_complete" );
        function_cff1fcfb();
        var_51aa97ed moveto( var_9f30ae72.origin, 1.5, 0.1, 0.1 );
        var_51aa97ed waittill( #"movedone" );
        var_51aa97ed delete();
        return;
    }
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x7b0c0f2a, Offset: 0x2de0
// Size: 0x1da
function function_66951281()
{
    level flag::init( "sd_small_complete" );
    var_e7c6777b = struct::get( "sd_small_soul", "targetname" );
    var_51aa97ed = util::spawn_model( var_e7c6777b.model, var_e7c6777b.origin, var_e7c6777b.angles );
    var_51aa97ed setscale( var_e7c6777b.script_float );
    var_c1b1cd1c = 2 / 15;
    var_fa77a9e7 = 0;
    
    while ( true )
    {
        level waittill( #"hash_d7362b52" );
        
        if ( var_fa77a9e7 < 15 )
        {
            var_fa77a9e7++;
            var_51aa97ed.origin += ( 0, 0, var_c1b1cd1c );
            continue;
        }
        
        level flag::set( "sd_small_complete" );
        function_cff1fcfb();
        var_51aa97ed moveto( var_e7c6777b.origin, 1.5, 0.1, 0.1 );
        var_51aa97ed waittill( #"movedone" );
        var_51aa97ed delete();
        return;
    }
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x54542821, Offset: 0x2fc8
// Size: 0x14c
function function_69090b83()
{
    self waittill( #"death", attacker );
    
    if ( !isplayer( attacker ) )
    {
        return;
    }
    
    if ( !isdefined( self ) )
    {
        return;
    }
    
    if ( level flag::get( "sd_active" ) )
    {
        v_end_pos = level.var_c920d4c5.origin;
        n_dist = distance( v_end_pos, self.origin );
        
        if ( self.archetype === "zombie_quad" )
        {
            if ( level flag::get( "sd_small_complete" ) )
            {
                return;
            }
            
            level notify( #"hash_d7362b52" );
        }
        else
        {
            if ( level flag::get( "sd_large_complete" ) )
            {
                return;
            }
            
            level notify( #"sd_zombie" );
        }
        
        if ( n_dist <= 256 )
        {
            self clientfield::set( "sd", 1 );
        }
    }
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x2cdf0102, Offset: 0x3120
// Size: 0x9c
function function_cff1fcfb()
{
    if ( level flag::get( "sd_large_complete" ) && level flag::get( "sd_small_complete" ) )
    {
        level flag::clear( "sd_active" );
        level thread function_93878170();
        playsoundatposition( "zmb_k9_ee_bling", ( 0, 0, 0 ) );
    }
}

// Namespace zm_moon_sq
// Params 0
// Checksum 0x5455d1f8, Offset: 0x31c8
// Size: 0x138
function function_93878170()
{
    var_653beee4 = array( "p7_fxanim_zmhd_moon_spacedog_path1_sec1_bundle", "p7_fxanim_zmhd_moon_spacedog_path1_sec2_bundle", "p7_fxanim_zmhd_moon_spacedog_path2_bundle" );
    var_efac5d38 = array( "p7_fxanim_zmhd_moon_spacedog_path1_sec2_bundle", "p7_fxanim_zmhd_moon_spacedog_path2_bundle" );
    wait 1;
    
    while ( true )
    {
        if ( level flag::get( "start_hangar_digger" ) || level flag::get( "start_teleporter_digger" ) )
        {
            str_scene = array::random( var_efac5d38 );
        }
        else
        {
            str_scene = array::random( var_653beee4 );
        }
        
        scene::play( str_scene );
        wait randomfloatrange( 600, 900 );
    }
}

