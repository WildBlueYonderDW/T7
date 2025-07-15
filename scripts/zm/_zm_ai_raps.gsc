#using scripts/codescripts/struct;
#using scripts/shared/aat_shared;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/system_shared;
#using scripts/shared/trigger_shared;
#using scripts/shared/util_shared;
#using scripts/shared/vehicle_ai_shared;
#using scripts/shared/vehicle_shared;
#using scripts/shared/vehicles/_raps;
#using scripts/shared/visionset_mgr_shared;
#using scripts/zm/_util;
#using scripts/zm/_zm;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_net;
#using scripts/zm/_zm_powerups;
#using scripts/zm/_zm_score;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_stats;
#using scripts/zm/_zm_utility;

#namespace zm_ai_raps;

// Namespace zm_ai_raps
// Params 0
// Checksum 0x6c2c62c3, Offset: 0x810
// Size: 0x32c
function init()
{
    level.raps_enabled = 1;
    level.raps_rounds_enabled = 0;
    level.raps_round_count = 1;
    level.raps_spawners = [];
    level flag::init( "raps_round" );
    level flag::init( "raps_round_in_progress" );
    level.melee_range_sav = getdvarstring( "ai_meleeRange" );
    level.melee_width_sav = getdvarstring( "ai_meleeWidth" );
    level.melee_height_sav = getdvarstring( "ai_meleeHeight" );
    
    if ( !isdefined( level.vsmgr_prio_overlay_zm_raps_round ) )
    {
        level.vsmgr_prio_overlay_zm_raps_round = 21;
    }
    
    clientfield::register( "toplayer", "elemental_round_fx", 1, 1, "counter" );
    clientfield::register( "toplayer", "elemental_round_ring_fx", 1, 1, "counter" );
    visionset_mgr::register_info( "visionset", "zm_elemental_round_visionset", 1, level.vsmgr_prio_overlay_zm_raps_round, 31, 0, &visionset_mgr::ramp_in_out_thread, 0 );
    level._effect[ "raps_meteor_fire" ] = "zombie/fx_meatball_trail_sky_zod_zmb";
    level._effect[ "raps_ground_spawn" ] = "zombie/fx_meatball_impact_ground_tell_zod_zmb";
    level._effect[ "raps_portal" ] = "zombie/fx_meatball_portal_sky_zod_zmb";
    level._effect[ "raps_gib" ] = "zombie/fx_meatball_explo_zod_zmb";
    level._effect[ "raps_trail_blood" ] = "zombie/fx_meatball_trail_ground_zod_zmb";
    level._effect[ "raps_impact" ] = "zombie/fx_meatball_impact_ground_zod_zmb";
    level thread aat::register_immunity( "zm_aat_blast_furnace", "raps", 0, 1, 0 );
    level thread aat::register_immunity( "zm_aat_dead_wire", "raps", 1, 1, 1 );
    level thread aat::register_immunity( "zm_aat_fire_works", "raps", 1, 1, 1 );
    level thread aat::register_immunity( "zm_aat_thunder_wall", "raps", 0, 0, 1 );
    level thread aat::register_immunity( "zm_aat_turned", "raps", 1, 1, 1 );
    raps_spawner_init();
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xfd95145b, Offset: 0xb48
// Size: 0x44
function enable_raps_rounds()
{
    level.raps_rounds_enabled = 1;
    
    if ( !isdefined( level.raps_round_track_override ) )
    {
        level.raps_round_track_override = &raps_round_tracker;
    }
    
    level thread [[ level.raps_round_track_override ]]();
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0x9fc93947, Offset: 0xb98
// Size: 0x19c
function raps_spawner_init()
{
    level.raps_spawners = getentarray( "zombie_raps_spawner", "script_noteworthy" );
    later_raps = getentarray( "later_round_raps_spawners", "script_noteworthy" );
    level.raps_spawners = arraycombine( level.raps_spawners, later_raps, 1, 0 );
    
    if ( level.raps_spawners.size == 0 )
    {
        return;
    }
    
    for ( i = 0; i < level.raps_spawners.size ; i++ )
    {
        if ( zm_spawner::is_spawner_targeted_by_blocker( level.raps_spawners[ i ] ) )
        {
            level.raps_spawners[ i ].is_enabled = 0;
            continue;
        }
        
        level.raps_spawners[ i ].is_enabled = 1;
        level.raps_spawners[ i ].script_forcespawn = 1;
    }
    
    assert( level.raps_spawners.size > 0 );
    level.n_raps_health = 100;
    vehicle::add_main_callback( "spawner_enemy_zombie_vehicle_raps_suicide", &raps_init );
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0x8c951f3b, Offset: 0xd40
// Size: 0x218
function raps_round_tracker()
{
    level.raps_round_count = 1;
    level.n_next_raps_round = randomintrange( 9, 11 );
    old_spawn_func = level.round_spawn_func;
    old_wait_func = level.round_wait_func;
    
    while ( true )
    {
        level waittill( #"between_round_over" );
        
        /#
            if ( getdvarint( "<dev string:x28>" ) > 0 )
            {
                level.n_next_raps_round = level.round_number;
            }
        #/
        
        if ( level.round_number == level.n_next_raps_round )
        {
            level.sndmusicspecialround = 1;
            old_spawn_func = level.round_spawn_func;
            old_wait_func = level.round_wait_func;
            raps_round_start();
            level.round_spawn_func = &raps_round_spawning;
            level.round_wait_func = &raps_round_wait_func;
            
            if ( isdefined( level.zm_custom_get_next_raps_round ) )
            {
                level.n_next_raps_round = [[ level.zm_custom_get_next_raps_round ]]();
            }
            else
            {
                level.n_next_raps_round = 10 + level.raps_round_count * 10 + randomintrange( -1, 1 );
            }
            
            /#
                getplayers()[ 0 ] iprintln( "<dev string:x33>" + level.n_next_raps_round );
            #/
            
            continue;
        }
        
        if ( level flag::get( "raps_round" ) )
        {
            raps_round_stop();
            level.round_spawn_func = old_spawn_func;
            level.round_wait_func = old_wait_func;
            level.raps_round_count++;
        }
    }
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xfbd44935, Offset: 0xf60
// Size: 0xe4
function raps_round_start()
{
    level flag::set( "raps_round" );
    level flag::set( "special_round" );
    
    if ( !isdefined( level.rapsround_nomusic ) )
    {
        level.rapsround_nomusic = 0;
    }
    
    level.rapsround_nomusic = 1;
    level notify( #"raps_round_starting" );
    level thread zm_audio::sndmusicsystem_playstate( "meatball_start" );
    
    if ( isdefined( level.raps_melee_range ) )
    {
        setdvar( "ai_meleeRange", level.raps_melee_range );
        return;
    }
    
    setdvar( "ai_meleeRange", 100 );
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xcee835b7, Offset: 0x1050
// Size: 0xd4
function raps_round_stop()
{
    level flag::clear( "raps_round" );
    level flag::clear( "special_round" );
    
    if ( !isdefined( level.rapsround_nomusic ) )
    {
        level.rapsround_nomusic = 0;
    }
    
    level.rapsround_nomusic = 0;
    level notify( #"raps_round_ending" );
    setdvar( "ai_meleeRange", level.melee_range_sav );
    setdvar( "ai_meleeWidth", level.melee_width_sav );
    setdvar( "ai_meleeHeight", level.melee_height_sav );
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xa875a308, Offset: 0x1130
// Size: 0x348
function raps_round_spawning()
{
    level endon( #"intermission" );
    level endon( #"raps_round" );
    level.raps_targets = getplayers();
    
    for ( i = 0; i < level.raps_targets.size ; i++ )
    {
        level.raps_targets[ i ].hunted_by = 0;
    }
    
    level endon( #"restart_round" );
    level endon( #"kill_round" );
    
    /#
        if ( getdvarint( "<dev string:x45>" ) == 2 || getdvarint( "<dev string:x45>" ) >= 4 )
        {
            return;
        }
    #/
    
    if ( level.intermission )
    {
        return;
    }
    
    array::thread_all( level.players, &play_raps_round );
    n_wave_count = get_raps_spawn_total();
    raps_health_increase();
    level.zombie_total = int( n_wave_count );
    
    /#
        if ( getdvarstring( "<dev string:x28>" ) != "<dev string:x52>" && getdvarint( "<dev string:x28>" ) > 0 )
        {
            level.zombie_total = getdvarint( "<dev string:x28>" );
            setdvar( "<dev string:x28>", 0 );
        }
    #/
    
    wait 1;
    elemental_round_fx();
    visionset_mgr::activate( "visionset", "zm_elemental_round_visionset", undefined, 1.5, 1.5, 2 );
    playsoundatposition( "vox_zmba_event_rapsstart_0", ( 0, 0, 0 ) );
    wait 6;
    n_raps_alive = 0;
    level flag::set( "raps_round_in_progress" );
    level endon( #"last_ai_down" );
    level thread raps_round_aftermath();
    
    while ( true )
    {
        while ( level.zombie_total > 0 )
        {
            if ( isdefined( level.bzm_worldpaused ) && level.bzm_worldpaused )
            {
                util::wait_network_frame();
                continue;
            }
            
            if ( isdefined( level.zm_mixed_wasp_raps_spawning ) )
            {
                [[ level.zm_mixed_wasp_raps_spawning ]]();
            }
            else
            {
                spawn_raps();
            }
            
            util::wait_network_frame();
        }
        
        util::wait_network_frame();
    }
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xf0956d72, Offset: 0x1480
// Size: 0x184
function spawn_raps()
{
    while ( !can_we_spawn_raps() )
    {
        wait 0.1;
    }
    
    s_spawn_loc = undefined;
    favorite_enemy = get_favorite_enemy();
    
    if ( !isdefined( favorite_enemy ) )
    {
        wait randomfloatrange( 0.333333, 0.666667 );
        return;
    }
    
    if ( isdefined( level.raps_spawn_func ) )
    {
        s_spawn_loc = [[ level.raps_spawn_func ]]( favorite_enemy );
    }
    else
    {
        s_spawn_loc = calculate_spawn_position( favorite_enemy );
    }
    
    if ( !isdefined( s_spawn_loc ) )
    {
        wait randomfloatrange( 0.333333, 0.666667 );
        return;
    }
    
    ai = zombie_utility::spawn_zombie( level.raps_spawners[ 0 ] );
    
    if ( isdefined( ai ) )
    {
        ai.favoriteenemy = favorite_enemy;
        ai.favoriteenemy.hunted_by++;
        s_spawn_loc thread raps_spawn_fx( ai, s_spawn_loc );
        level.zombie_total--;
        waiting_for_next_raps_spawn();
    }
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0x8895cace, Offset: 0x1610
// Size: 0x86
function get_raps_spawn_total()
{
    switch ( level.players.size )
    {
        case 1:
            n_wave_count = 10;
            break;
        case 2:
            n_wave_count = 18;
            break;
        case 3:
            n_wave_count = 28;
            break;
        case 4:
        default:
            n_wave_count = 34;
            break;
    }
    
    return n_wave_count;
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0x15f29129, Offset: 0x16a0
// Size: 0x80
function raps_round_wait_func()
{
    level endon( #"restart_round" );
    level endon( #"kill_round" );
    
    if ( level flag::get( "raps_round" ) )
    {
        level flag::wait_till( "raps_round_in_progress" );
        level flag::wait_till_clear( "raps_round_in_progress" );
    }
    
    level.sndmusicspecialround = 0;
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xcef90d98, Offset: 0x1728
// Size: 0xd6
function get_current_raps_count()
{
    raps = getentarray( "zombie_raps", "targetname" );
    num_alive_raps = raps.size;
    
    foreach ( rapsai in raps )
    {
        if ( !isalive( rapsai ) )
        {
            num_alive_raps--;
        }
    }
    
    return num_alive_raps;
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0x6de4ac00, Offset: 0x1808
// Size: 0xb2
function elemental_round_fx()
{
    foreach ( player in level.players )
    {
        player clientfield::increment_to_player( "elemental_round_fx" );
        player clientfield::increment_to_player( "elemental_round_ring_fx" );
    }
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xe8964bb6, Offset: 0x18c8
// Size: 0x88
function show_hit_marker()
{
    if ( isdefined( self ) && isdefined( self.hud_damagefeedback ) )
    {
        self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
        self.hud_damagefeedback.alpha = 1;
        self.hud_damagefeedback fadeovertime( 1 );
        self.hud_damagefeedback.alpha = 0;
    }
}

// Namespace zm_ai_raps
// Params 12
// Checksum 0x33a004f4, Offset: 0x1958
// Size: 0x88
function rapsdamage( inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex )
{
    if ( isdefined( attacker ) )
    {
        attacker show_hit_marker();
    }
    
    return damage;
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0x13e4ff16, Offset: 0x19e8
// Size: 0x90, Type: bool
function can_we_spawn_raps()
{
    n_raps_alive = get_current_raps_count();
    b_raps_count_at_max = n_raps_alive >= 13;
    b_raps_count_per_player_at_max = n_raps_alive >= level.players.size * 4;
    
    if ( b_raps_count_at_max || b_raps_count_per_player_at_max || !level flag::get( "spawn_zombies" ) )
    {
        return false;
    }
    
    return true;
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xb879ff61, Offset: 0x1a80
// Size: 0x88
function waiting_for_next_raps_spawn()
{
    switch ( level.players.size )
    {
        case 1:
            n_default_wait = 2.25;
            break;
        case 2:
            n_default_wait = 1.75;
            break;
        case 3:
            n_default_wait = 1.25;
            break;
        default:
            n_default_wait = 0.75;
            break;
    }
    
    wait n_default_wait;
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0x6cca7e17, Offset: 0x1b10
// Size: 0x134
function raps_round_aftermath()
{
    level waittill( #"last_ai_down", e_enemy_ai );
    level thread zm_audio::sndmusicsystem_playstate( "meatball_over" );
    
    if ( isdefined( level.zm_override_ai_aftermath_powerup_drop ) )
    {
        [[ level.zm_override_ai_aftermath_powerup_drop ]]( e_enemy_ai, level.last_ai_origin );
    }
    else
    {
        power_up_origin = level.last_ai_origin;
        trace = groundtrace( power_up_origin + ( 0, 0, 100 ), power_up_origin + ( 0, 0, -1000 ), 0, undefined );
        power_up_origin = trace[ "position" ];
        
        if ( isdefined( power_up_origin ) )
        {
            level thread zm_powerups::specific_powerup_drop( "full_ammo", power_up_origin );
        }
    }
    
    wait 2;
    level.sndmusicspecialround = 0;
    wait 6;
    level flag::clear( "raps_round_in_progress" );
}

// Namespace zm_ai_raps
// Params 2
// Checksum 0xc19c348, Offset: 0x1c50
// Size: 0x68c
function raps_spawn_fx( ai, ent )
{
    ai endon( #"death" );
    
    if ( !isdefined( ent ) )
    {
        ent = self;
    }
    
    ai vehicle_ai::set_state( "scripted" );
    trace = bullettrace( ent.origin, ent.origin + ( 0, 0, -720 ), 0, ai );
    raps_impact_location = trace[ "position" ];
    angle = vectortoangles( ai.favoriteenemy.origin - ent.origin );
    angles = ( ai.angles[ 0 ], angle[ 1 ], ai.angles[ 2 ] );
    ai.origin = raps_impact_location;
    ai.angles = angles;
    ai hide();
    pos = raps_impact_location + ( 0, 0, 720 );
    
    if ( !bullettracepassed( ent.origin, pos, 0, ai ) )
    {
        trace = bullettrace( ent.origin, pos, 0, ai );
        pos = trace[ "position" ];
    }
    
    portal_fx_location = spawn( "script_model", pos );
    portal_fx_location setmodel( "tag_origin" );
    playfxontag( level._effect[ "raps_portal" ], portal_fx_location, "tag_origin" );
    ground_tell_location = spawn( "script_model", raps_impact_location );
    ground_tell_location setmodel( "tag_origin" );
    playfxontag( level._effect[ "raps_ground_spawn" ], ground_tell_location, "tag_origin" );
    ground_tell_location playsound( "zmb_meatball_spawn_tell" );
    playsoundatposition( "zmb_meatball_spawn_rise", pos );
    ai thread cleanup_meteor_fx( portal_fx_location, ground_tell_location );
    wait 0.5;
    raps_meteor = spawn( "script_model", pos );
    model = ai.model;
    raps_meteor setmodel( model );
    raps_meteor.angles = angles;
    raps_meteor playloopsound( "zmb_meatball_spawn_loop", 0.25 );
    playfxontag( level._effect[ "raps_meteor_fire" ], raps_meteor, "tag_origin" );
    fall_dist = sqrt( distancesquared( pos, raps_impact_location ) );
    fall_time = fall_dist / 720;
    raps_meteor moveto( raps_impact_location, fall_time );
    raps_meteor.ai = ai;
    raps_meteor thread cleanup_meteor();
    wait fall_time;
    raps_meteor delete();
    
    if ( isdefined( portal_fx_location ) )
    {
        portal_fx_location delete();
    }
    
    if ( isdefined( ground_tell_location ) )
    {
        ground_tell_location delete();
    }
    
    ai vehicle_ai::set_state( "combat" );
    ai.origin = raps_impact_location;
    ai.angles = angles;
    ai show();
    playfx( level._effect[ "raps_impact" ], raps_impact_location );
    playsoundatposition( "zmb_meatball_spawn_impact", raps_impact_location );
    earthquake( 0.3, 0.75, raps_impact_location, 512 );
    assert( isdefined( ai ), "<dev string:x53>" );
    assert( isalive( ai ), "<dev string:x66>" );
    ai zombie_setup_attack_properties_raps();
    ai setvisibletoall();
    ai.ignoreme = 0;
    ai notify( #"visible" );
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xd667e70d, Offset: 0x22e8
// Size: 0x34
function cleanup_meteor()
{
    self endon( #"death" );
    self.ai waittill( #"death" );
    self delete();
}

// Namespace zm_ai_raps
// Params 2
// Checksum 0xbb561483, Offset: 0x2328
// Size: 0x64
function cleanup_meteor_fx( portal_fx, ground_tell )
{
    self waittill( #"death" );
    
    if ( isdefined( portal_fx ) )
    {
        portal_fx delete();
    }
    
    if ( isdefined( ground_tell ) )
    {
        ground_tell delete();
    }
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xb5849964, Offset: 0x2398
// Size: 0x17a
function create_global_raps_spawn_locations_list()
{
    if ( !isdefined( level.enemy_raps_global_locations ) )
    {
        level.enemy_raps_global_locations = [];
        keys = getarraykeys( level.zones );
        
        for ( i = 0; i < keys.size ; i++ )
        {
            zone = level.zones[ keys[ i ] ];
            
            foreach ( loc in zone.a_locs[ "raps_location" ] )
            {
                if ( !isdefined( level.enemy_raps_global_locations ) )
                {
                    level.enemy_raps_global_locations = [];
                }
                else if ( !isarray( level.enemy_raps_global_locations ) )
                {
                    level.enemy_raps_global_locations = array( level.enemy_raps_global_locations );
                }
                
                level.enemy_raps_global_locations[ level.enemy_raps_global_locations.size ] = loc;
            }
        }
    }
}

// Namespace zm_ai_raps
// Params 1
// Checksum 0xc1acc1be, Offset: 0x2520
// Size: 0x118
function raps_find_closest_in_global_pool( favorite_enemy )
{
    index_to_use = 0;
    closest_distance_squared = distancesquared( level.enemy_raps_global_locations[ index_to_use ].origin, favorite_enemy.origin );
    
    for ( i = 0; i < level.enemy_raps_global_locations.size ; i++ )
    {
        if ( level.enemy_raps_global_locations[ i ].is_enabled )
        {
            dist_squared = distancesquared( level.enemy_raps_global_locations[ i ].origin, favorite_enemy.origin );
            
            if ( dist_squared < closest_distance_squared )
            {
                index_to_use = i;
                closest_distance_squared = dist_squared;
            }
        }
    }
    
    return level.enemy_raps_global_locations[ index_to_use ];
}

// Namespace zm_ai_raps
// Params 1
// Checksum 0x9afd7a01, Offset: 0x2640
// Size: 0x236
function calculate_spawn_position( favorite_enemy )
{
    position = favorite_enemy.last_valid_position;
    
    if ( !isdefined( position ) )
    {
        position = favorite_enemy.origin;
    }
    
    if ( level.players.size == 1 )
    {
        n_raps_spawn_dist_min = 450;
        n_raps_spawn_dist_max = 900;
    }
    else if ( level.players.size == 2 )
    {
        n_raps_spawn_dist_min = 450;
        n_raps_spawn_dist_max = 850;
    }
    else if ( level.players.size == 3 )
    {
        n_raps_spawn_dist_min = 700;
        n_raps_spawn_dist_max = 1000;
    }
    else
    {
        n_raps_spawn_dist_min = 800;
        n_raps_spawn_dist_max = 1200;
    }
    
    query_result = positionquery_source_navigation( position, n_raps_spawn_dist_min, n_raps_spawn_dist_max, 200, 32, 16 );
    
    if ( query_result.data.size )
    {
        a_s_locs = array::randomize( query_result.data );
        
        if ( isdefined( a_s_locs ) )
        {
            foreach ( s_loc in a_s_locs )
            {
                if ( zm_utility::check_point_in_enabled_zone( s_loc.origin, 1, level.active_zones ) )
                {
                    s_loc.origin += ( 0, 0, 16 );
                    return s_loc;
                }
            }
        }
    }
    
    return undefined;
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xf0646d4c, Offset: 0x2880
// Size: 0x124
function get_favorite_enemy()
{
    raps_targets = getplayers();
    e_least_hunted = undefined;
    
    for ( i = 0; i < raps_targets.size ; i++ )
    {
        e_target = raps_targets[ i ];
        
        if ( !isdefined( e_target.hunted_by ) )
        {
            e_target.hunted_by = 0;
        }
        
        if ( !zm_utility::is_player_valid( e_target ) )
        {
            continue;
        }
        
        if ( isdefined( level.is_player_accessible_to_raps ) && ![[ level.is_player_accessible_to_raps ]]( e_target ) )
        {
            continue;
        }
        
        if ( !isdefined( e_least_hunted ) )
        {
            e_least_hunted = e_target;
            continue;
        }
        
        if ( e_target.hunted_by < e_least_hunted.hunted_by )
        {
            e_least_hunted = e_target;
        }
    }
    
    return e_least_hunted;
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xc9fc147e, Offset: 0x29b0
// Size: 0x50
function raps_health_increase()
{
    players = getplayers();
    level.n_raps_health = level.round_number * 50;
    
    if ( level.n_raps_health > 1600 )
    {
        level.n_raps_health = 1600;
    }
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xddef4989, Offset: 0x2a08
// Size: 0xb4
function play_raps_round()
{
    self playlocalsound( "zmb_raps_round_start" );
    variation_count = 5;
    wait 4.5;
    players = getplayers();
    num = randomintrange( 0, players.size );
    players[ num ] zm_audio::create_and_play_dialog( "general", "raps_spawn" );
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xe0118ea8, Offset: 0x2ac8
// Size: 0x400
function raps_init()
{
    self.inpain = 1;
    thread raps::raps_initialize();
    self.inpain = 0;
    self.targetname = "zombie_raps";
    self.script_noteworthy = undefined;
    self.animname = "zombie_raps";
    self.ignoreme = 1;
    self.allowdeath = 1;
    self.allowpain = 0;
    self.no_gib = 1;
    self.is_zombie = 1;
    self.gibbed = 0;
    self.head_gibbed = 0;
    self.default_goalheight = 40;
    self.ignore_inert = 1;
    self.no_eye_glow = 1;
    self.lightning_chain_immune = 1;
    self.holdfire = 1;
    self.grenadeawareness = 0;
    self.badplaceawareness = 0;
    self.ignoresuppression = 1;
    self.suppressionthreshold = 1;
    self.nododgemove = 1;
    self.dontshootwhilemoving = 1;
    self.pathenemylookahead = 0;
    self.test_failed_path = 1;
    self.badplaceawareness = 0;
    self.chatinitialized = 0;
    self.missinglegs = 0;
    self.isdog = 0;
    self.teslafxtag = "tag_origin";
    self.custom_player_shellshock = &raps_custom_player_shellshock;
    self.grapple_type = 2;
    self setgrapplabletype( self.grapple_type );
    self.team = level.zombie_team;
    self.sword_kill_power = 2;
    health_multiplier = 1;
    
    if ( getdvarstring( "scr_raps_health_walk_multiplier" ) != "" )
    {
        health_multiplier = getdvarfloat( "scr_raps_health_walk_multiplier" );
    }
    
    self.maxhealth = int( level.n_raps_health * health_multiplier );
    
    if ( isdefined( level.a_zombie_respawn_health[ self.archetype ] ) && level.a_zombie_respawn_health[ self.archetype ].size > 0 )
    {
        self.health = level.a_zombie_respawn_health[ self.archetype ][ 0 ];
        arrayremovevalue( level.a_zombie_respawn_health[ self.archetype ], level.a_zombie_respawn_health[ self.archetype ][ 0 ] );
    }
    else
    {
        self.health = int( level.n_raps_health * health_multiplier );
    }
    
    self thread raps_run_think();
    self setinvisibletoall();
    self thread raps_death();
    self thread raps_timeout_after_xsec( 90 );
    level thread zm_spawner::zombie_death_event( self );
    self thread zm_spawner::enemy_death_detection();
    self zm_spawner::zombie_history( "zombie_raps_spawn_init -> Spawned = " + self.origin );
    
    if ( isdefined( level.achievement_monitor_func ) )
    {
        self [[ level.achievement_monitor_func ]]();
    }
}

// Namespace zm_ai_raps
// Params 1
// Checksum 0x44e7196, Offset: 0x2ed0
// Size: 0x5c
function raps_timeout_after_xsec( timeout )
{
    self endon( #"death" );
    wait timeout;
    self dodamage( self.health + 100, self.origin, self, undefined, "none", "MOD_UNKNOWN" );
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xc9d28211, Offset: 0x2f38
// Size: 0x1ec
function raps_death()
{
    self waittill( #"death", attacker );
    
    if ( get_current_raps_count() == 0 && level.zombie_total == 0 )
    {
        if ( !isdefined( level.zm_ai_round_over ) || [[ level.zm_ai_round_over ]]() )
        {
            level.last_ai_origin = self.origin;
            level notify( #"last_ai_down", self );
        }
    }
    
    if ( isplayer( attacker ) )
    {
        if ( !( isdefined( self.deathpoints_already_given ) && self.deathpoints_already_given ) )
        {
            attacker zm_score::player_add_points( "death_raps", 70 );
        }
        
        if ( isdefined( level.hero_power_update ) )
        {
            [[ level.hero_power_update ]]( attacker, self );
        }
        
        if ( randomintrange( 0, 100 ) >= 80 )
        {
            attacker zm_audio::create_and_play_dialog( "kill", "hellhound" );
        }
        
        attacker zm_stats::increment_client_stat( "zraps_killed" );
        attacker zm_stats::increment_player_stat( "zraps_killed" );
    }
    
    if ( isdefined( attacker ) && isai( attacker ) )
    {
        attacker notify( #"killed", self );
    }
    
    if ( isdefined( self ) )
    {
        self stoploopsound();
        self thread raps_explode_fx( self.origin );
    }
}

// Namespace zm_ai_raps
// Params 5
// Checksum 0x5d55e2df, Offset: 0x3130
// Size: 0x54
function raps_custom_player_shellshock( damage, attacker, direction_vec, point, mod )
{
    if ( mod == "MOD_EXPLOSIVE" )
    {
        self thread player_watch_shellshock_accumulation();
    }
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xc58aa36, Offset: 0x3190
// Size: 0x8c
function player_watch_shellshock_accumulation()
{
    self endon( #"death" );
    
    if ( !isdefined( self.raps_recent_explosions ) )
    {
        self.raps_recent_explosions = 0;
    }
    
    self.raps_recent_explosions++;
    
    if ( self.raps_recent_explosions >= 4 )
    {
        self shellshock( "explosion_elementals", 2 );
    }
    
    self util::waittill_any_timeout( 20, "death" );
    self.raps_recent_explosions--;
}

// Namespace zm_ai_raps
// Params 1
// Checksum 0x5b7c5fae, Offset: 0x3228
// Size: 0x34
function raps_explode_fx( origin )
{
    playfx( level._effect[ "raps_gib" ], origin );
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xf20030cd, Offset: 0x3268
// Size: 0x54
function zombie_setup_attack_properties_raps()
{
    self zm_spawner::zombie_history( "zombie_setup_attack_properties()" );
    self.ignoreall = 0;
    self.meleeattackdist = 64;
    self.disablearrivals = 1;
    self.disableexits = 1;
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0xcf7cc83c, Offset: 0x32c8
// Size: 0x24
function stop_raps_sound_on_death()
{
    self waittill( #"death" );
    self stopsounds();
}

// Namespace zm_ai_raps
// Params 3
// Checksum 0xff9f9fe2, Offset: 0x32f8
// Size: 0x22c, Type: bool
function special_raps_spawn( n_to_spawn, s_spawn_loc, fn_on_spawned )
{
    if ( !isdefined( n_to_spawn ) )
    {
        n_to_spawn = 1;
    }
    
    raps = getentarray( "zombie_raps", "targetname" );
    
    if ( isdefined( raps ) && raps.size >= 9 )
    {
        return false;
    }
    
    count = 0;
    
    while ( count < n_to_spawn )
    {
        players = getplayers();
        favorite_enemy = get_favorite_enemy();
        
        if ( !isdefined( favorite_enemy ) )
        {
            wait randomfloatrange( 0.666667, 1.33333 );
            continue;
        }
        
        if ( isdefined( level.raps_spawn_func ) )
        {
            s_spawn_loc = [[ level.raps_spawn_func ]]( favorite_enemy );
        }
        else
        {
            s_spawn_loc = calculate_spawn_position( favorite_enemy );
        }
        
        if ( !isdefined( s_spawn_loc ) )
        {
            wait randomfloatrange( 0.666667, 1.33333 );
            continue;
        }
        
        ai = zombie_utility::spawn_zombie( level.raps_spawners[ 0 ] );
        
        if ( isdefined( ai ) )
        {
            ai.favoriteenemy = favorite_enemy;
            ai.favoriteenemy.hunted_by++;
            s_spawn_loc thread raps_spawn_fx( ai, s_spawn_loc );
            count++;
            
            if ( isdefined( fn_on_spawned ) )
            {
                ai thread [[ fn_on_spawned ]]();
            }
        }
        
        waiting_for_next_raps_spawn();
    }
    
    return true;
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0x3e529835, Offset: 0x3530
// Size: 0x118
function raps_run_think()
{
    self endon( #"death" );
    self waittill( #"visible" );
    
    if ( self.health > level.n_raps_health )
    {
        self.maxhealth = level.n_raps_health;
        self.health = level.n_raps_health;
    }
    
    while ( true )
    {
        if ( !zm_utility::is_player_valid( self.favoriteenemy ) && self.b_attracted_to_octobomb !== 1 || self should_raps_giveup_inaccessible_player( self.favoriteenemy ) )
        {
            potential_target = get_favorite_enemy();
            
            if ( isdefined( potential_target ) )
            {
                self.favoriteenemy = potential_target;
                self.favoriteenemy.hunted_by++;
                self.raps_force_patrol_behavior = undefined;
            }
            else
            {
                self.raps_force_patrol_behavior = 1;
            }
        }
        
        wait 0.1;
    }
}

// Namespace zm_ai_raps
// Params 1
// Checksum 0xc9244c05, Offset: 0x3650
// Size: 0x5c, Type: bool
function should_raps_giveup_inaccessible_player( player )
{
    if ( isdefined( level.raps_can_reach_inaccessible_location ) && self [[ level.raps_can_reach_inaccessible_location ]]() )
    {
        return false;
    }
    
    if ( isdefined( level.is_player_accessible_to_raps ) && ![[ level.is_player_accessible_to_raps ]]( player ) )
    {
        return true;
    }
    
    return false;
}

// Namespace zm_ai_raps
// Params 0
// Checksum 0x53ac9673, Offset: 0x36b8
// Size: 0x50
function raps_stalk_audio()
{
    self endon( #"death" );
    
    while ( true )
    {
        self playsound( "zmb_hellhound_vocals_amb" );
        wait randomfloatrange( 3, 6 );
    }
}

// Namespace zm_ai_raps
// Params 2
// Checksum 0xc9765c0a, Offset: 0x3710
// Size: 0x8c
function raps_thundergun_knockdown( player, gib )
{
    self endon( #"death" );
    damage = int( self.maxhealth * 0.5 );
    self dodamage( damage, player.origin, player, undefined, "none", "MOD_UNKNOWN" );
}

