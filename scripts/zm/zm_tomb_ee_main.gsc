#using scripts/codescripts/struct;
#using scripts/shared/ai/zombie_shared;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/ai_shared;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/hud_shared;
#using scripts/shared/lui_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_zm;
#using scripts/zm/_zm_sidequests;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_unitrigger;
#using scripts/zm/_zm_weapons;
#using scripts/zm/zm_tomb_amb;
#using scripts/zm/zm_tomb_craftables;
#using scripts/zm/zm_tomb_ee_main;
#using scripts/zm/zm_tomb_ee_main_step_1;
#using scripts/zm/zm_tomb_ee_main_step_2;
#using scripts/zm/zm_tomb_ee_main_step_3;
#using scripts/zm/zm_tomb_ee_main_step_4;
#using scripts/zm/zm_tomb_ee_main_step_5;
#using scripts/zm/zm_tomb_ee_main_step_6;
#using scripts/zm/zm_tomb_ee_main_step_7;
#using scripts/zm/zm_tomb_ee_main_step_8;
#using scripts/zm/zm_tomb_utility;
#using scripts/zm/zm_tomb_vo;

#namespace zm_tomb_ee_main;

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0xafea48ff, Offset: 0x8d0
// Size: 0x374
function init()
{
    clientfield::register( "actor", "ee_zombie_fist_fx", 21000, 1, "int" );
    clientfield::register( "actor", "ee_zombie_soul_portal", 21000, 1, "int" );
    clientfield::register( "world", "ee_sam_portal", 21000, 2, "int" );
    clientfield::register( "vehicle", "ee_plane_fx", 21000, 1, "int" );
    clientfield::register( "world", "TombEndGameBlackScreen", 21000, 1, "int" );
    level flag::init( "ee_all_staffs_crafted" );
    level flag::init( "ee_all_staffs_upgraded" );
    level flag::init( "ee_all_staffs_placed" );
    level flag::init( "ee_mech_zombie_hole_opened" );
    level flag::init( "ee_mech_zombie_fight_completed" );
    level flag::init( "ee_maxis_drone_retrieved" );
    level flag::init( "ee_all_players_upgraded_punch" );
    level flag::init( "ee_souls_absorbed" );
    level flag::init( "ee_samantha_released" );
    level flag::init( "ee_quadrotor_disabled" );
    level flag::init( "ee_sam_portal_active" );
    
    if ( !zm_sidequests::is_sidequest_allowed( "zclassic" ) )
    {
        return;
    }
    
    /#
        level thread setup_ee_main_devgui();
    #/
    
    zm_sidequests::declare_sidequest( "little_girl_lost", &init_sidequest, &sidequest_logic, &complete_sidequest, &generic_stage_start, &generic_stage_end );
    zm_tomb_ee_main_step_1::init();
    zm_tomb_ee_main_step_2::init();
    zm_tomb_ee_main_step_3::init();
    zm_tomb_ee_main_step_4::init();
    zm_tomb_ee_main_step_5::init();
    zm_tomb_ee_main_step_6::init();
    zm_tomb_ee_main_step_7::init();
    zm_tomb_ee_main_step_8::init();
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0x4bdea872, Offset: 0xc50
// Size: 0x3c
function main()
{
    level flag::wait_till( "start_zombie_round_logic" );
    zm_sidequests::sidequest_start( "little_girl_lost" );
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0xa387ee0f, Offset: 0xc98
// Size: 0x1c
function init_sidequest()
{
    level.n_ee_step = 0;
    level.n_ee_robot_staffs_planted = 0;
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0xa87c316, Offset: 0xcc0
// Size: 0x280
function sidequest_logic()
{
    level._cur_stage_name = "step_0";
    level flag::wait_till( "ee_all_staffs_crafted" );
    level flag::wait_till( "all_zones_captured" );
    level.n_ee_step++;
    level thread zombie_blood_hint_watch();
    zm_sidequests::stage_start( "little_girl_lost", "step_1" );
    level waittill( #"little_girl_lost_step_1_over" );
    zm_sidequests::stage_start( "little_girl_lost", "step_2" );
    level waittill( #"little_girl_lost_step_2_over" );
    level thread zm_tomb_amb::sndplaystingerwithoverride( "ee_main_1" );
    zm_sidequests::stage_start( "little_girl_lost", "step_3" );
    level waittill( #"little_girl_lost_step_3_over" );
    level thread zm_tomb_amb::sndplaystingerwithoverride( "ee_main_2" );
    zm_sidequests::stage_start( "little_girl_lost", "step_4" );
    level waittill( #"little_girl_lost_step_4_over" );
    level thread zm_tomb_amb::sndplaystingerwithoverride( "ee_main_3" );
    zm_sidequests::stage_start( "little_girl_lost", "step_5" );
    level waittill( #"little_girl_lost_step_5_over" );
    level thread zm_tomb_amb::sndplaystingerwithoverride( "ee_main_4" );
    zm_sidequests::stage_start( "little_girl_lost", "step_6" );
    level waittill( #"little_girl_lost_step_6_over" );
    level thread zm_tomb_amb::sndplaystingerwithoverride( "ee_main_5" );
    zm_sidequests::stage_start( "little_girl_lost", "step_7" );
    level waittill( #"little_girl_lost_step_7_over" );
    level thread zm_tomb_amb::sndplaystingerwithoverride( "ee_main_6" );
    zm_sidequests::stage_start( "little_girl_lost", "step_8" );
    level waittill( #"little_girl_lost_step_8_over" );
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0x9543f944, Offset: 0xf48
// Size: 0x3e0
function zombie_blood_hint_watch()
{
    n_curr_step = level.n_ee_step;
    a_player_hint[ 0 ] = 0;
    a_player_hint[ 1 ] = 0;
    a_player_hint[ 2 ] = 0;
    a_player_hint[ 3 ] = 0;
    
    while ( !level flag::get( "ee_samantha_released" ) )
    {
        level waittill( #"player_zombie_blood", e_player );
        
        if ( n_curr_step != level.n_ee_step )
        {
            n_curr_step = level.n_ee_step;
            
            for ( i = 0; i < a_player_hint.size ; i++ )
            {
                a_player_hint[ i ] = 0;
            }
        }
        
        if ( !a_player_hint[ e_player.characterindex ] )
        {
            wait randomfloatrange( 3, 7 );
            
            if ( isdefined( e_player.vo_promises_playing ) && e_player.vo_promises_playing )
            {
                continue;
            }
            
            while ( isdefined( level.sam_talking ) && level.sam_talking )
            {
                wait 0.05;
            }
            
            if ( isdefined( e_player ) && isplayer( e_player ) && e_player.zombie_vars[ "zombie_powerup_zombie_blood_on" ] )
            {
                a_player_hint[ e_player.characterindex ] = 1;
                zm_tomb_vo::set_players_dontspeak( 1 );
                level.sam_talking = 1;
                str_vox = get_zombie_blood_hint_vox();
                e_player playsoundtoplayer( str_vox, e_player );
                n_duration = soundgetplaybacktime( str_vox );
                wait n_duration / 1000;
                level.sam_talking = 0;
                zm_tomb_vo::set_players_dontspeak( 0 );
            }
            
            continue;
        }
        
        if ( randomint( 100 ) < 20 )
        {
            wait randomfloatrange( 3, 7 );
            
            if ( isdefined( e_player.vo_promises_playing ) && e_player.vo_promises_playing )
            {
                continue;
            }
            
            while ( isdefined( level.sam_talking ) && level.sam_talking )
            {
                wait 0.05;
            }
            
            if ( isdefined( e_player ) && isplayer( e_player ) && e_player.zombie_vars[ "zombie_powerup_zombie_blood_on" ] )
            {
                str_vox = get_zombie_blood_hint_generic_vox();
                
                if ( isdefined( str_vox ) )
                {
                    zm_tomb_vo::set_players_dontspeak( 1 );
                    level.sam_talking = 1;
                    e_player playsoundtoplayer( str_vox, e_player );
                    n_duration = soundgetplaybacktime( str_vox );
                    wait n_duration / 1000;
                    level.sam_talking = 0;
                    zm_tomb_vo::set_players_dontspeak( 0 );
                }
            }
        }
    }
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0xa1c5980f, Offset: 0x1330
// Size: 0x4e
function get_step_announce_vox()
{
    switch ( level.n_ee_step )
    {
        case 1:
            return "vox_sam_all_staff_upgrade_key_0";
        case 2:
            return "vox_sam_all_staff_ascend_darkness_0";
        case 3:
            return "vox_sam_all_staff_rain_fire_0";
        case 4:
            return "vox_sam_all_staff_unleash_hoard_0";
        case 5:
            return "vox_sam_all_staff_skewer_beast_0";
        case 6:
            return "vox_sam_all_staff_fist_iron_0";
        case 7:
            return "vox_sam_all_staff_raise_hell_0";
        default:
            return undefined;
    }
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0xd702fb28, Offset: 0x13d0
// Size: 0x5c
function get_zombie_blood_hint_vox()
{
    if ( level flag::get( "all_zones_captured" ) )
    {
        return ( "vox_sam_upgrade_staff_clue_" + level.n_ee_step + "_0" );
    }
    
    return "vox_sam_upgrade_staff_clue_" + level.n_ee_step + "_grbld_0";
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0xcdebaaa4, Offset: 0x1438
// Size: 0xd8
function get_zombie_blood_hint_generic_vox()
{
    if ( !isdefined( level.generic_clue_index ) )
    {
        level.generic_clue_index = 0;
    }
    
    vo_array[ 0 ] = "vox_sam_heard_by_all_1_0";
    vo_array[ 1 ] = "vox_sam_heard_by_all_2_0";
    vo_array[ 2 ] = "vox_sam_heard_by_all_3_0";
    vo_array[ 3 ] = "vox_sam_slow_progress_0";
    vo_array[ 4 ] = "vox_sam_slow_progress_2";
    vo_array[ 5 ] = "vox_sam_slow_progress_3";
    
    if ( level.generic_clue_index >= vo_array.size )
    {
        return undefined;
    }
    
    str_vo = vo_array[ level.generic_clue_index ];
    level.generic_clue_index++;
    return str_vo;
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0x32d747dd, Offset: 0x1518
// Size: 0x2ea
function complete_sidequest()
{
    level lui::prime_movie( "zm_outro_tomb", 0, "" );
    level.sndgameovermusicoverride = "game_over_ee";
    a_players = getplayers();
    
    foreach ( player in a_players )
    {
        player freezecontrols( 1 );
        player enableinvulnerability();
    }
    
    level flag::clear( "spawn_zombies" );
    level thread function_ab51bfd();
    playsoundatposition( "zmb_squest_whiteout", ( 0, 0, 0 ) );
    level lui::screen_fade_out( 1, "white", "starting_ee_screen" );
    util::delay( 0.5, undefined, &remove_portal_beam );
    level thread lui::play_movie( "zm_outro_tomb", "fullscreen", 0, 0, "" );
    level lui::screen_fade_out( 0, "black", "starting_ee_screen" );
    level waittill( #"movie_done" );
    level.custom_intermission = &player_intermission_ee;
    level notify( #"end_game" );
    level thread lui::screen_fade_in( 2, "black", "starting_ee_screen" );
    wait 1.5;
    
    foreach ( player in a_players )
    {
        player freezecontrols( 0 );
        player disableinvulnerability();
    }
}

// Namespace zm_tomb_ee_main
// Params 1
// Checksum 0x1fbca3d, Offset: 0x1810
// Size: 0x2c
function function_202bf99e( var_87423d00 )
{
    self endon( #"end_game" );
    self lui::screen_fade_in( var_87423d00 );
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0x18a1cb50, Offset: 0x1848
// Size: 0x2c
function remove_portal_beam()
{
    if ( isdefined( level.ee_ending_beam_fx ) )
    {
        level.ee_ending_beam_fx delete();
    }
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0xdd48341, Offset: 0x1880
// Size: 0x44
function generic_stage_start()
{
    str_vox = get_step_announce_vox();
    
    if ( isdefined( str_vox ) )
    {
        level thread ee_samantha_say( str_vox );
    }
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0x2be560b1, Offset: 0x18d0
// Size: 0x5c
function generic_stage_end()
{
    level.n_ee_step++;
    
    if ( level.n_ee_step <= 6 )
    {
        level flag::wait_till( "all_zones_captured" );
    }
    
    util::wait_network_frame();
    util::wait_network_frame();
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0xe989e181, Offset: 0x1938
// Size: 0xc6
function all_staffs_inserted_in_puzzle_room()
{
    n_staffs_inserted = 0;
    
    foreach ( staff in level.a_elemental_staffs )
    {
        if ( staff.upgrade.charger.is_inserted )
        {
            n_staffs_inserted++;
        }
    }
    
    if ( n_staffs_inserted == 4 )
    {
        return 1;
    }
    
    return 0;
}

// Namespace zm_tomb_ee_main
// Params 1
// Checksum 0xc5cb19d3, Offset: 0x1a08
// Size: 0xcc
function ee_samantha_say( str_vox )
{
    level flag::wait_till_clear( "story_vo_playing" );
    level flag::set( "story_vo_playing" );
    zm_tomb_vo::set_players_dontspeak( 1 );
    zm_tomb_vo::samanthasay( str_vox, getplayers()[ 0 ] );
    zm_tomb_vo::set_players_dontspeak( 0 );
    level flag::clear( "story_vo_playing" );
}

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0xde1d59b2, Offset: 0x1ae0
// Size: 0x622
function player_intermission_ee()
{
    self closeingamemenu();
    level endon( #"stop_intermission" );
    self endon( #"disconnect" );
    self endon( #"death" );
    self notify( #"_zombie_game_over" );
    self.score = self.score_total;
    self.sessionstate = "intermission";
    self.spectatorclient = -1;
    self.killcamentity = -1;
    self.archivetime = 0;
    self.psoffsettime = 0;
    self.friendlydamage = undefined;
    points = struct::get_array( "ee_cam", "targetname" );
    
    if ( !isdefined( points ) || points.size == 0 )
    {
        points = getentarray( "info_intermission", "classname" );
        
        if ( points.size < 1 )
        {
            println( "<dev string:x28>" );
            return;
        }
    }
    
    self.game_over_bg = newclienthudelem( self );
    self.game_over_bg.horzalign = "fullscreen";
    self.game_over_bg.vertalign = "fullscreen";
    self.game_over_bg setshader( "black", 640, 480 );
    self.game_over_bg.alpha = 1;
    visionsetnaked( "cheat_bw", 0.05 );
    org = undefined;
    
    while ( true )
    {
        points = array::randomize( points );
        
        for ( i = 0; i < points.size ; i++ )
        {
            point = points[ i ];
            
            if ( !isdefined( org ) )
            {
                self spawn( point.origin, point.angles );
            }
            
            if ( isdefined( points[ i ].target ) )
            {
                if ( !isdefined( org ) )
                {
                    org = spawn( "script_model", self.origin + ( 0, 0, -60 ) );
                    org setmodel( "tag_origin" );
                }
                
                org.origin = points[ i ].origin;
                org.angles = points[ i ].angles;
                
                for ( j = 0; j < getplayers().size ; j++ )
                {
                    player = getplayers()[ j ];
                    player camerasetposition( org );
                    player camerasetlookat();
                    player cameraactivate( 1 );
                }
                
                speed = 20;
                
                if ( isdefined( points[ i ].speed ) )
                {
                    speed = points[ i ].speed;
                }
                
                target_point = struct::get( points[ i ].target, "targetname" );
                dist = distance( points[ i ].origin, target_point.origin );
                time = dist / speed;
                q_time = time * 0.25;
                
                if ( q_time > 1 )
                {
                    q_time = 1;
                }
                
                self.game_over_bg fadeovertime( q_time );
                self.game_over_bg.alpha = 0;
                org moveto( target_point.origin, time, q_time, q_time );
                org rotateto( target_point.angles, time, q_time, q_time );
                wait time - q_time;
                self.game_over_bg fadeovertime( q_time );
                self.game_over_bg.alpha = 1;
                wait q_time;
                continue;
            }
            
            self.game_over_bg fadeovertime( 1 );
            self.game_over_bg.alpha = 0;
            wait 5;
            self.game_over_bg thread zm::fade_up_over_time( 1 );
        }
    }
}

/#

    // Namespace zm_tomb_ee_main
    // Params 0
    // Checksum 0xf901b9c4, Offset: 0x2110
    // Size: 0x1ec, Type: dev
    function setup_ee_main_devgui()
    {
        wait 5;
        b_activated = 0;
        
        while ( !b_activated )
        {
            foreach ( player in getplayers() )
            {
                if ( distance2d( player.origin, ( 2904, 5040, -336 ) ) < 100 && player usebuttonpressed() )
                {
                    wait 2;
                    
                    if ( player usebuttonpressed() )
                    {
                        b_activated = 1;
                    }
                }
            }
            
            wait 0.05;
        }
        
        setdvar( "<dev string:x4b>", "<dev string:x5c>" );
        setdvar( "<dev string:x60>", "<dev string:x5c>" );
        setdvar( "<dev string:x72>", "<dev string:x5c>" );
        adddebugcommand( "<dev string:x84>" );
        adddebugcommand( "<dev string:xc4>" );
        adddebugcommand( "<dev string:x10a>" );
        level thread watch_devgui_ee_main();
    }

    // Namespace zm_tomb_ee_main
    // Params 0
    // Checksum 0x19a833d3, Offset: 0x2308
    // Size: 0x478, Type: dev
    function watch_devgui_ee_main()
    {
        while ( true )
        {
            if ( getdvarstring( "<dev string:x4b>" ) == "<dev string:x14b>" )
            {
                setdvar( "<dev string:x4b>", "<dev string:x5c>" );
                level.ee_debug = 1;
                level flag::set( "<dev string:x14e>" );
                
                switch ( level._cur_stage_name )
                {
                    case "<dev string:x162>":
                        level flag::set( "<dev string:x169>" );
                        level flag::set( "<dev string:x17f>" );
                        break;
                    case "<dev string:x192>":
                        level flag::set( "<dev string:x199>" );
                        level waittill( #"little_girl_lost_step_1_over" );
                        break;
                    case "<dev string:x1b0>":
                        level flag::set( "<dev string:x1b7>" );
                        level waittill( #"little_girl_lost_step_2_over" );
                        break;
                    case "<dev string:x1cc>":
                        level flag::set( "<dev string:x1d3>" );
                        m_floor = getent( "<dev string:x1ee>", "<dev string:x206>" );
                        
                        if ( isdefined( m_floor ) )
                        {
                            m_floor delete();
                        }
                        
                        level waittill( #"little_girl_lost_step_3_over" );
                        break;
                    case "<dev string:x211>":
                        level flag::set( "<dev string:x218>" );
                        level flag::set( "<dev string:x237>" );
                        level waittill( #"little_girl_lost_step_4_over" );
                        break;
                    case "<dev string:x24d>":
                        level flag::set( "<dev string:x254>" );
                        level flag::clear( "<dev string:x237>" );
                        level waittill( #"little_girl_lost_step_5_over" );
                        break;
                    case "<dev string:x26d>":
                        level flag::set( "<dev string:x274>" );
                        level waittill( #"little_girl_lost_step_6_over" );
                        break;
                    case "<dev string:x292>":
                        level flag::set( "<dev string:x299>" );
                        level waittill( #"little_girl_lost_step_7_over" );
                        break;
                    case "<dev string:x2ab>":
                        level flag::set( "<dev string:x237>" );
                        level waittill( #"little_girl_lost_step_8_over" );
                        break;
                    default:
                        break;
                }
            }
            
            if ( getdvarstring( "<dev string:x60>" ) == "<dev string:x14b>" )
            {
                setdvar( "<dev string:x60>", "<dev string:x5c>" );
                level clientfield::set( "<dev string:x2b2>", 2 );
                complete_sidequest();
            }
            
            if ( getdvarstring( "<dev string:x72>" ) == "<dev string:x14b>" )
            {
                setdvar( "<dev string:x72>", "<dev string:x5c>" );
                setdvar( "<dev string:x2c0>", "<dev string:x14b>" );
                level flag::set( "<dev string:x2d8>" );
                array::thread_all( getplayers(), &zm_weapons::weapon_give, "<dev string:x2ea>" );
            }
            
            wait 0.05;
        }
    }

#/

// Namespace zm_tomb_ee_main
// Params 0
// Checksum 0xf95ea982, Offset: 0x2788
// Size: 0x1a2
function function_ab51bfd()
{
    a_ai_enemies = getaiteamarray( "axis" );
    
    foreach ( ai in a_ai_enemies )
    {
        if ( isalive( ai ) )
        {
            ai.marked_for_death = 1;
            ai ai::set_ignoreall( 1 );
        }
        
        util::wait_network_frame();
    }
    
    foreach ( ai in a_ai_enemies )
    {
        if ( isalive( ai ) )
        {
            ai dodamage( ai.health + 666, ai.origin );
        }
    }
}

