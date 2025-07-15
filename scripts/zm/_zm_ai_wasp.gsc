#using scripts/codescripts/struct;
#using scripts/shared/aat_shared;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/ai_shared;
#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/system_shared;
#using scripts/shared/trigger_shared;
#using scripts/shared/util_shared;
#using scripts/shared/vehicle_shared;
#using scripts/shared/vehicles/_parasite;
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
#using scripts/zm/zm_zod_idgun_quest;

#namespace zm_ai_wasp;

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x25027067, Offset: 0x708
// Size: 0x2fc
function init()
{
    level.wasp_enabled = 1;
    level.wasp_rounds_enabled = 0;
    level.wasp_round_count = 1;
    level.wasp_spawners = [];
    level.a_wasp_priority_targets = [];
    level flag::init( "wasp_round" );
    level flag::init( "wasp_round_in_progress" );
    level.melee_range_sav = getdvarstring( "ai_meleeRange" );
    level.melee_width_sav = getdvarstring( "ai_meleeWidth" );
    level.melee_height_sav = getdvarstring( "ai_meleeHeight" );
    
    if ( !isdefined( level.vsmgr_prio_overlay_zm_wasp_round ) )
    {
        level.vsmgr_prio_overlay_zm_wasp_round = 22;
    }
    
    clientfield::register( "toplayer", "parasite_round_fx", 1, 1, "counter" );
    clientfield::register( "toplayer", "parasite_round_ring_fx", 1, 1, "counter" );
    clientfield::register( "world", "toggle_on_parasite_fog", 1, 2, "int" );
    visionset_mgr::register_info( "visionset", "zm_wasp_round_visionset", 1, level.vsmgr_prio_overlay_zm_wasp_round, 31, 0, &visionset_mgr::ramp_in_out_thread, 0 );
    level._effect[ "lightning_wasp_spawn" ] = "zombie/fx_parasite_spawn_buildup_zod_zmb";
    callback::on_connect( &watch_player_melee_events );
    level thread aat::register_immunity( "zm_aat_blast_furnace", "parasite", 1, 1, 1 );
    level thread aat::register_immunity( "zm_aat_dead_wire", "parasite", 1, 1, 1 );
    level thread aat::register_immunity( "zm_aat_fire_works", "parasite", 1, 1, 1 );
    level thread aat::register_immunity( "zm_aat_thunder_wall", "parasite", 1, 1, 1 );
    level thread aat::register_immunity( "zm_aat_turned", "parasite", 1, 1, 1 );
    wasp_spawner_init();
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x3af4fd52, Offset: 0xa10
// Size: 0x44
function enable_wasp_rounds()
{
    level.wasp_rounds_enabled = 1;
    
    if ( !isdefined( level.wasp_round_track_override ) )
    {
        level.wasp_round_track_override = &wasp_round_tracker;
    }
    
    level thread [[ level.wasp_round_track_override ]]();
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x91ef11c5, Offset: 0xa60
// Size: 0x19c
function wasp_spawner_init()
{
    level.wasp_spawners = getentarray( "zombie_wasp_spawner", "script_noteworthy" );
    later_wasp = getentarray( "later_round_wasp_spawners", "script_noteworthy" );
    level.wasp_spawners = arraycombine( level.wasp_spawners, later_wasp, 1, 0 );
    
    if ( level.wasp_spawners.size == 0 )
    {
        return;
    }
    
    for ( i = 0; i < level.wasp_spawners.size ; i++ )
    {
        if ( zm_spawner::is_spawner_targeted_by_blocker( level.wasp_spawners[ i ] ) )
        {
            level.wasp_spawners[ i ].is_enabled = 0;
            continue;
        }
        
        level.wasp_spawners[ i ].is_enabled = 1;
        level.wasp_spawners[ i ].script_forcespawn = 1;
    }
    
    assert( level.wasp_spawners.size > 0 );
    level.wasp_health = 100;
    vehicle::add_main_callback( "spawner_bo3_parasite_enemy_tool", &wasp_init );
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x20a6146e, Offset: 0xc08
// Size: 0xd6
function get_current_wasp_count()
{
    wasps = getentarray( "zombie_wasp", "targetname" );
    num_alive_wasps = wasps.size;
    
    foreach ( wasp in wasps )
    {
        if ( !isalive( wasp ) )
        {
            num_alive_wasps--;
        }
    }
    
    return num_alive_wasps;
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0xaea5a0b, Offset: 0xce8
// Size: 0x390
function wasp_round_spawning()
{
    level endon( #"intermission" );
    level endon( #"wasp_round" );
    level.wasp_targets = level.players;
    
    for ( i = 0; i < level.wasp_targets.size ; i++ )
    {
        level.wasp_targets[ i ].hunted_by = 0;
    }
    
    level endon( #"restart_round" );
    level endon( #"kill_round" );
    
    /#
        if ( getdvarint( "<dev string:x28>" ) == 2 || getdvarint( "<dev string:x28>" ) >= 4 )
        {
            return;
        }
    #/
    
    if ( level.intermission )
    {
        return;
    }
    
    array::thread_all( level.players, &play_wasp_round );
    n_wave_count = 10;
    
    if ( level.players.size > 1 )
    {
        n_wave_count *= level.players.size * 0.75;
    }
    
    wasp_health_increase();
    level.zombie_total = int( n_wave_count * 1 );
    
    /#
        if ( getdvarstring( "<dev string:x35>" ) != "<dev string:x40>" && getdvarint( "<dev string:x35>" ) > 0 )
        {
            level.zombie_total = getdvarint( "<dev string:x35>" );
            setdvar( "<dev string:x35>", 0 );
        }
    #/
    
    wait 1;
    parasite_round_fx();
    visionset_mgr::activate( "visionset", "zm_wasp_round_visionset", undefined, 1.5, 1.5, 2 );
    level clientfield::set( "toggle_on_parasite_fog", 1 );
    playsoundatposition( "vox_zmba_event_waspstart_0", ( 0, 0, 0 ) );
    wait 6;
    n_wasps_alive = 0;
    level flag::set( "wasp_round_in_progress" );
    level endon( #"last_ai_down" );
    level thread wasp_round_aftermath();
    
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
                spawn_wasp();
            }
            
            util::wait_network_frame();
        }
        
        util::wait_network_frame();
    }
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0xde38381d, Offset: 0x1080
// Size: 0x560
function spawn_wasp()
{
    b_swarm_spawned = 0;
    
    while ( !b_swarm_spawned )
    {
        while ( !ready_to_spawn_wasp() )
        {
            wait 1;
        }
        
        spawn_point = undefined;
        
        while ( !isdefined( spawn_point ) )
        {
            favorite_enemy = get_favorite_enemy();
            spawn_enemy = favorite_enemy;
            
            if ( !isdefined( spawn_enemy ) )
            {
                spawn_enemy = getplayers()[ 0 ];
            }
            
            if ( isdefined( level.wasp_spawn_func ) )
            {
                spawn_point = [[ level.wasp_spawn_func ]]( spawn_enemy );
            }
            else
            {
                spawn_point = wasp_spawn_logic( spawn_enemy );
            }
            
            if ( !isdefined( spawn_point ) )
            {
                wait randomfloatrange( 0.666667, 1.33333 );
            }
        }
        
        v_spawn_origin = spawn_point.origin;
        v_ground = bullettrace( spawn_point.origin + ( 0, 0, 60 ), spawn_point.origin + ( 0, 0, 60 ) + ( 0, 0, -100000 ), 0, undefined )[ "position" ];
        
        if ( distancesquared( v_ground, spawn_point.origin ) < 3600 )
        {
            v_spawn_origin = v_ground + ( 0, 0, 60 );
        }
        
        queryresult = positionquery_source_navigation( v_spawn_origin, 0, 80, 80, 15, "navvolume_small" );
        a_points = array::randomize( queryresult.data );
        a_spawn_origins = [];
        n_points_found = 0;
        
        foreach ( point in a_points )
        {
            if ( bullettracepassed( point.origin, spawn_point.origin, 0, spawn_enemy ) )
            {
                if ( !isdefined( a_spawn_origins ) )
                {
                    a_spawn_origins = [];
                }
                else if ( !isarray( a_spawn_origins ) )
                {
                    a_spawn_origins = array( a_spawn_origins );
                }
                
                a_spawn_origins[ a_spawn_origins.size ] = point.origin;
                n_points_found++;
                
                if ( n_points_found >= 1 )
                {
                    break;
                }
            }
        }
        
        if ( a_spawn_origins.size >= 1 )
        {
            n_spawn = 0;
            
            while ( n_spawn < 1 && level.zombie_total > 0 )
            {
                for ( i = a_spawn_origins.size - 1; i >= 0 ; i-- )
                {
                    v_origin = a_spawn_origins[ i ];
                    level.wasp_spawners[ 0 ].origin = v_origin;
                    ai = zombie_utility::spawn_zombie( level.wasp_spawners[ 0 ] );
                    
                    if ( isdefined( ai ) )
                    {
                        ai parasite::set_parasite_enemy( favorite_enemy );
                        level thread wasp_spawn_init( ai, v_origin );
                        arrayremoveindex( a_spawn_origins, i );
                        
                        if ( isdefined( level.zm_wasp_spawn_callback ) )
                        {
                            ai thread [[ level.zm_wasp_spawn_callback ]]();
                        }
                        
                        n_spawn++;
                        level.zombie_total--;
                        wait randomfloatrange( 0.0666667, 0.133333 );
                        break;
                    }
                    
                    wait randomfloatrange( 0.0666667, 0.133333 );
                }
            }
            
            b_swarm_spawned = 1;
        }
        
        util::wait_network_frame();
    }
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x29cb2f2c, Offset: 0x15e8
// Size: 0xb2
function parasite_round_fx()
{
    foreach ( player in level.players )
    {
        player clientfield::increment_to_player( "parasite_round_fx" );
        player clientfield::increment_to_player( "parasite_round_ring_fx" );
    }
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0xced6635, Offset: 0x16a8
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

// Namespace zm_ai_wasp
// Params 12
// Checksum 0x8c5c2dcb, Offset: 0x1738
// Size: 0x88
function waspdamage( inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex )
{
    if ( isdefined( attacker ) )
    {
        attacker show_hit_marker();
    }
    
    return damage;
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0xb5770994, Offset: 0x17c8
// Size: 0x90, Type: bool
function ready_to_spawn_wasp()
{
    n_wasps_alive = get_current_wasp_count();
    b_wasp_count_at_max = n_wasps_alive >= 16;
    b_wasp_count_per_player_at_max = n_wasps_alive >= level.players.size * 5;
    
    if ( b_wasp_count_at_max || b_wasp_count_per_player_at_max || !level flag::get( "spawn_zombies" ) )
    {
        return false;
    }
    
    return true;
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0xd9a4f3aa, Offset: 0x1860
// Size: 0x12c
function wasp_round_aftermath()
{
    level waittill( #"last_ai_down", e_wasp );
    level thread zm_audio::sndmusicsystem_playstate( "parasite_over" );
    
    if ( isdefined( level.zm_override_ai_aftermath_powerup_drop ) )
    {
        [[ level.zm_override_ai_aftermath_powerup_drop ]]( e_wasp, level.last_ai_origin );
    }
    else if ( isdefined( level.last_ai_origin ) )
    {
        enemy = e_wasp.favoriteenemy;
        
        if ( !isdefined( enemy ) )
        {
            enemy = array::random( level.players );
        }
        
        enemy parasite_drop_item( level.last_ai_origin );
    }
    
    wait 2;
    level clientfield::set( "toggle_on_parasite_fog", 2 );
    level.sndmusicspecialround = 0;
    wait 6;
    level flag::clear( "wasp_round_in_progress" );
}

// Namespace zm_ai_wasp
// Params 1
// Checksum 0x3c5a9e1a, Offset: 0x1998
// Size: 0x38c
function parasite_drop_item( v_parasite_origin )
{
    if ( !zm_utility::check_point_in_enabled_zone( v_parasite_origin, 1, level.active_zones ) )
    {
        e_parasite_drop = level zm_powerups::specific_powerup_drop( "full_ammo", v_parasite_origin );
        current_zone = self zm_utility::get_current_zone();
        
        if ( isdefined( current_zone ) )
        {
            v_start = e_parasite_drop.origin;
            e_closest_player = arraygetclosest( v_start, level.activeplayers );
            
            if ( isdefined( e_closest_player ) )
            {
                v_target = e_closest_player.origin + ( 0, 0, 20 );
                n_distance_to_target = distance( v_start, v_target );
                v_dir = vectornormalize( v_target - v_start );
                n_step = 50;
                n_distance_moved = 0;
                v_position = v_start;
                
                while ( n_distance_moved <= n_distance_to_target )
                {
                    v_position += v_dir * n_step;
                    
                    if ( zm_utility::check_point_in_enabled_zone( v_position, 1, level.active_zones ) )
                    {
                        n_height_diff = abs( v_target[ 2 ] - v_position[ 2 ] );
                        
                        if ( n_height_diff < 60 )
                        {
                            break;
                        }
                    }
                    
                    n_distance_moved += n_step;
                }
                
                trace = bullettrace( v_position, v_position + ( 0, 0, -256 ), 0, undefined );
                v_ground_position = trace[ "position" ];
                
                if ( isdefined( v_ground_position ) )
                {
                    v_position = ( v_position[ 0 ], v_position[ 1 ], v_ground_position[ 2 ] + 20 );
                }
                
                n_flight_time = distance( v_start, v_position ) / 100;
                
                if ( n_flight_time > 4 )
                {
                    n_flight_time = 4;
                }
                
                e_parasite_drop moveto( v_position, n_flight_time );
            }
            else
            {
                v_nav_check = getclosestpointonnavmesh( e_parasite_drop.origin, 2000, 32 );
            }
        }
        
        return;
    }
    
    level zm_powerups::specific_powerup_drop( "full_ammo", getclosestpointonnavmesh( v_parasite_origin, 1000, 30 ) );
}

// Namespace zm_ai_wasp
// Params 3
// Checksum 0x91120360, Offset: 0x1d30
// Size: 0x294
function wasp_spawn_init( ai, origin, should_spawn_fx )
{
    if ( !isdefined( should_spawn_fx ) )
    {
        should_spawn_fx = 1;
    }
    
    ai endon( #"death" );
    ai setinvisibletoall();
    
    if ( isdefined( origin ) )
    {
        v_origin = origin;
    }
    else
    {
        v_origin = ai.origin;
    }
    
    if ( should_spawn_fx )
    {
        playfx( level._effect[ "lightning_wasp_spawn" ], v_origin );
    }
    
    wait 1.5;
    earthquake( 0.3, 0.5, v_origin, 256 );
    
    if ( isdefined( ai.favoriteenemy ) )
    {
        angle = vectortoangles( ai.favoriteenemy.origin - v_origin );
    }
    else
    {
        angle = ai.angles;
    }
    
    angles = ( ai.angles[ 0 ], angle[ 1 ], ai.angles[ 2 ] );
    ai.origin = v_origin;
    ai.angles = angles;
    assert( isdefined( ai ), "<dev string:x41>" );
    assert( isalive( ai ), "<dev string:x54>" );
    ai thread zombie_setup_attack_properties_wasp();
    
    if ( isdefined( level._wasp_death_cb ) )
    {
        ai callback::add_callback( #"hash_acb66515", level._wasp_death_cb );
    }
    
    ai setvisibletoall();
    ai.ignoreme = 0;
    ai notify( #"visible" );
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x2571f410, Offset: 0x1fd0
// Size: 0x17a
function create_global_wasp_spawn_locations_list()
{
    if ( !isdefined( level.enemy_wasp_global_locations ) )
    {
        level.enemy_wasp_global_locations = [];
        keys = getarraykeys( level.zones );
        
        for ( i = 0; i < keys.size ; i++ )
        {
            zone = level.zones[ keys[ i ] ];
            
            foreach ( loc in zone.a_locs[ "wasp_location" ] )
            {
                if ( !isdefined( level.enemy_wasp_global_locations ) )
                {
                    level.enemy_wasp_global_locations = [];
                }
                else if ( !isarray( level.enemy_wasp_global_locations ) )
                {
                    level.enemy_wasp_global_locations = array( level.enemy_wasp_global_locations );
                }
                
                level.enemy_wasp_global_locations[ level.enemy_wasp_global_locations.size ] = loc;
            }
        }
    }
}

// Namespace zm_ai_wasp
// Params 1
// Checksum 0x4cc4f14f, Offset: 0x2158
// Size: 0x118
function wasp_find_closest_in_global_pool( favorite_enemy )
{
    index_to_use = 0;
    closest_distance_squared = distancesquared( level.enemy_wasp_global_locations[ index_to_use ].origin, favorite_enemy.origin );
    
    for ( i = 0; i < level.enemy_wasp_global_locations.size ; i++ )
    {
        if ( level.enemy_wasp_global_locations[ i ].is_enabled )
        {
            dist_squared = distancesquared( level.enemy_wasp_global_locations[ i ].origin, favorite_enemy.origin );
            
            if ( dist_squared < closest_distance_squared )
            {
                index_to_use = i;
                closest_distance_squared = dist_squared;
            }
        }
    }
    
    return level.enemy_wasp_global_locations[ index_to_use ];
}

// Namespace zm_ai_wasp
// Params 1
// Checksum 0x80244fa0, Offset: 0x2278
// Size: 0x398
function wasp_spawn_logic( favorite_enemy )
{
    if ( !getdvarint( "zm_wasp_open_spawning", 0 ) )
    {
        wasp_locs = level.zm_loc_types[ "wasp_location" ];
        
        if ( wasp_locs.size == 0 )
        {
            create_global_wasp_spawn_locations_list();
            return wasp_find_closest_in_global_pool( favorite_enemy );
        }
        
        if ( isdefined( level.old_wasp_spawn ) )
        {
            dist_squared = distancesquared( level.old_wasp_spawn.origin, favorite_enemy.origin );
            
            if ( dist_squared > 160000 && dist_squared < 360000 )
            {
                return level.old_wasp_spawn;
            }
        }
        
        foreach ( loc in wasp_locs )
        {
            dist_squared = distancesquared( loc.origin, favorite_enemy.origin );
            
            if ( dist_squared > 160000 && dist_squared < 360000 )
            {
                level.old_wasp_spawn = loc;
                return loc;
            }
        }
    }
    
    switch ( level.players.size )
    {
        case 4:
            spawn_dist_max = 600;
            break;
        case 3:
            spawn_dist_max = 700;
            break;
        case 2:
            spawn_dist_max = 900;
            break;
        case 1:
        default:
            spawn_dist_max = 1200;
            break;
    }
    
    queryresult = positionquery_source_navigation( favorite_enemy.origin + ( 0, 0, randomintrange( 40, 100 ) ), 300, spawn_dist_max, 10, 10, "navvolume_small" );
    a_points = array::randomize( queryresult.data );
    
    foreach ( point in a_points )
    {
        if ( bullettracepassed( point.origin, favorite_enemy.origin, 0, favorite_enemy ) )
        {
            level.old_wasp_spawn = point;
            return point;
        }
    }
    
    return a_points[ 0 ];
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x582bfe2e, Offset: 0x2618
// Size: 0xa4
function get_favorite_enemy()
{
    if ( level.a_wasp_priority_targets.size > 0 )
    {
        e_enemy = level.a_wasp_priority_targets[ 0 ];
        
        if ( isdefined( e_enemy ) )
        {
            arrayremovevalue( level.a_wasp_priority_targets, e_enemy );
            return e_enemy;
        }
    }
    
    if ( isdefined( level.fn_custom_wasp_favourate_enemy ) )
    {
        e_enemy = [[ level.fn_custom_wasp_favourate_enemy ]]();
        return e_enemy;
    }
    
    target = parasite::get_parasite_enemy();
    return target;
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0xe4ae1203, Offset: 0x26c8
// Size: 0x50
function wasp_health_increase()
{
    players = getplayers();
    level.wasp_health = level.round_number * 50;
    
    if ( level.wasp_health > 1600 )
    {
        level.wasp_health = 1600;
    }
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0xa3f839ef, Offset: 0x2720
// Size: 0x74
function wasp_round_wait_func()
{
    level endon( #"restart_round" );
    level endon( #"kill_round" );
    
    if ( level flag::get( "wasp_round" ) )
    {
        level flag::wait_till( "wasp_round_in_progress" );
        level flag::wait_till_clear( "wasp_round_in_progress" );
    }
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x5181c307, Offset: 0x27a0
// Size: 0x22c
function wasp_round_tracker()
{
    level.wasp_round_count = 1;
    level.next_wasp_round = level.round_number + randomintrange( 4, 6 );
    old_spawn_func = level.round_spawn_func;
    old_wait_func = level.round_wait_func;
    
    while ( true )
    {
        level waittill( #"between_round_over" );
        
        /#
            if ( getdvarint( "<dev string:x35>" ) > 0 )
            {
                level.next_wasp_round = level.round_number;
            }
        #/
        
        if ( level.round_number == level.next_wasp_round )
        {
            level.sndmusicspecialround = 1;
            old_spawn_func = level.round_spawn_func;
            old_wait_func = level.round_wait_func;
            wasp_round_start();
            level.round_spawn_func = &wasp_round_spawning;
            level.round_wait_func = &wasp_round_wait_func;
            
            if ( isdefined( level.zm_custom_get_next_wasp_round ) )
            {
                level.next_wasp_round = [[ level.zm_custom_get_next_wasp_round ]]();
            }
            else
            {
                level.next_wasp_round = 5 + level.wasp_round_count * 10 + randomintrange( -1, 1 );
            }
            
            /#
                getplayers()[ 0 ] iprintln( "<dev string:x61>" + level.next_wasp_round );
            #/
            
            continue;
        }
        
        if ( level flag::get( "wasp_round" ) )
        {
            wasp_round_stop();
            level.round_spawn_func = old_spawn_func;
            level.round_wait_func = old_wait_func;
            level.wasp_round_count += 1;
        }
    }
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x7b7e6d9c, Offset: 0x29d8
// Size: 0xe4
function wasp_round_start()
{
    level flag::set( "wasp_round" );
    level flag::set( "special_round" );
    
    if ( !isdefined( level.waspround_nomusic ) )
    {
        level.waspround_nomusic = 0;
    }
    
    level.waspround_nomusic = 1;
    level notify( #"wasp_round_starting" );
    level thread zm_audio::sndmusicsystem_playstate( "parasite_start" );
    
    if ( isdefined( level.wasp_melee_range ) )
    {
        setdvar( "ai_meleeRange", level.wasp_melee_range );
        return;
    }
    
    setdvar( "ai_meleeRange", 100 );
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x70247676, Offset: 0x2ac8
// Size: 0xd4
function wasp_round_stop()
{
    level flag::clear( "wasp_round" );
    level flag::clear( "special_round" );
    
    if ( !isdefined( level.waspround_nomusic ) )
    {
        level.waspround_nomusic = 0;
    }
    
    level.waspround_nomusic = 0;
    level notify( #"wasp_round_ending" );
    setdvar( "ai_meleeRange", level.melee_range_sav );
    setdvar( "ai_meleeWidth", level.melee_width_sav );
    setdvar( "ai_meleeHeight", level.melee_height_sav );
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x918d379c, Offset: 0x2ba8
// Size: 0xb4
function play_wasp_round()
{
    self playlocalsound( "zmb_wasp_round_start" );
    variation_count = 5;
    wait 4.5;
    players = getplayers();
    num = randomintrange( 0, players.size );
    players[ num ] zm_audio::create_and_play_dialog( "general", "wasp_spawn" );
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x17699e32, Offset: 0x2c68
// Size: 0x400
function wasp_init()
{
    self.targetname = "zombie_wasp";
    self.script_noteworthy = undefined;
    self.animname = "zombie_wasp";
    self.ignoreall = 1;
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
    self.holdfire = 0;
    self.grenadeawareness = 0;
    self.badplaceawareness = 0;
    self.ignoresuppression = 1;
    self.suppressionthreshold = 1;
    self.nododgemove = 1;
    self.dontshootwhilemoving = 1;
    self.pathenemylookahead = 0;
    self.badplaceawareness = 0;
    self.chatinitialized = 0;
    self.missinglegs = 0;
    self.isdog = 0;
    self.teslafxtag = "tag_origin";
    self.grapple_type = 2;
    self setgrapplabletype( self.grapple_type );
    self.team = level.zombie_team;
    self.sword_kill_power = 2;
    parasite::parasite_initialize();
    health_multiplier = 1;
    
    if ( getdvarstring( "scr_wasp_health_walk_multiplier" ) != "" )
    {
        health_multiplier = getdvarfloat( "scr_wasp_health_walk_multiplier" );
    }
    
    self.maxhealth = int( level.wasp_health * health_multiplier );
    
    if ( isdefined( level.a_zombie_respawn_health[ self.archetype ] ) && level.a_zombie_respawn_health[ self.archetype ].size > 0 )
    {
        self.health = level.a_zombie_respawn_health[ self.archetype ][ 0 ];
        arrayremovevalue( level.a_zombie_respawn_health[ self.archetype ], level.a_zombie_respawn_health[ self.archetype ][ 0 ] );
    }
    else
    {
        self.health = int( level.wasp_health * health_multiplier );
    }
    
    self thread wasp_run_think();
    self thread watch_player_melee();
    self setinvisibletoall();
    self thread wasp_death();
    self thread wasp_cleanup_failsafe();
    level thread zm_spawner::zombie_death_event( self );
    self thread zm_spawner::enemy_death_detection();
    self.thundergun_knockdown_func = &wasp_thundergun_knockdown;
    self zm_spawner::zombie_history( "zombie_wasp_spawn_init -> Spawned = " + self.origin );
    
    if ( isdefined( level.achievement_monitor_func ) )
    {
        self [[ level.achievement_monitor_func ]]();
    }
}

// Namespace zm_ai_wasp
// Params 2
// Checksum 0x131b23b9, Offset: 0x3070
// Size: 0x74
function wasp_thundergun_knockdown( e_player, gib )
{
    self endon( #"death" );
    n_damage = int( self.maxhealth * 0.5 );
    self dodamage( n_damage, self.origin, e_player );
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x7e0bc6a2, Offset: 0x30f0
// Size: 0x164
function wasp_cleanup_failsafe()
{
    self endon( #"death" );
    n_wasp_created_time = gettime();
    n_check_time = n_wasp_created_time;
    v_check_position = self.origin;
    
    while ( true )
    {
        n_current_time = gettime();
        
        if ( isdefined( level.bzm_worldpaused ) && level.bzm_worldpaused )
        {
            n_check_time = n_current_time;
            wait 1;
            continue;
        }
        
        n_dist = distance( v_check_position, self.origin );
        
        if ( n_dist > 100 )
        {
            n_check_time = n_current_time;
            v_check_position = self.origin;
        }
        else
        {
            n_delta_time = ( n_current_time - n_check_time ) / 1000;
            
            if ( n_delta_time >= 20 )
            {
                break;
            }
        }
        
        n_delta_time = ( n_current_time - n_wasp_created_time ) / 1000;
        
        if ( n_delta_time >= 150 )
        {
            break;
        }
        
        wait 1;
    }
    
    self dodamage( self.health + 100, self.origin );
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0xb8ba0f2b, Offset: 0x3260
// Size: 0x1e4
function wasp_death()
{
    self waittill( #"death", attacker );
    
    if ( get_current_wasp_count() == 0 && level.zombie_total == 0 )
    {
        if ( !isdefined( level.zm_ai_round_over ) || [[ level.zm_ai_round_over ]]() )
        {
            level.last_ai_origin = self.origin;
            level notify( #"last_ai_down", self );
        }
    }
    
    if ( isplayer( attacker ) )
    {
        if ( isdefined( attacker.on_train ) && attacker.on_train )
        {
            attacker notify( #"wasp_train_kill" );
        }
        
        attacker zm_score::player_add_points( "death_wasp", 70 );
        
        if ( isdefined( level.hero_power_update ) )
        {
            [[ level.hero_power_update ]]( attacker, self );
        }
        
        if ( randomintrange( 0, 100 ) >= 80 )
        {
            attacker zm_audio::create_and_play_dialog( "kill", "hellhound" );
        }
        
        attacker zm_stats::increment_client_stat( "zwasp_killed" );
        attacker zm_stats::increment_player_stat( "zwasp_killed" );
    }
    
    if ( isdefined( attacker ) && isai( attacker ) )
    {
        attacker notify( #"killed", self );
    }
    
    self stoploopsound();
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x5af9698f, Offset: 0x3450
// Size: 0xdc
function zombie_setup_attack_properties_wasp()
{
    self zm_spawner::zombie_history( "zombie_setup_attack_properties()" );
    self thread wasp_behind_audio();
    self.ignoreall = 0;
    self.meleeattackdist = 64;
    self.disablearrivals = 1;
    self.disableexits = 1;
    
    if ( level.wasp_round_count == 2 )
    {
        self ai::set_behavior_attribute( "firing_rate", "medium" );
        return;
    }
    
    if ( level.wasp_round_count > 2 )
    {
        self ai::set_behavior_attribute( "firing_rate", "fast" );
    }
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x701eedf6, Offset: 0x3538
// Size: 0x24
function stop_wasp_sound_on_death()
{
    self waittill( #"death" );
    self stopsounds();
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x85dd8d48, Offset: 0x3568
// Size: 0x1b0
function wasp_behind_audio()
{
    self thread stop_wasp_sound_on_death();
    self endon( #"death" );
    self util::waittill_any( "wasp_running", "wasp_combat" );
    wait 3;
    
    while ( true )
    {
        players = getplayers();
        
        for ( i = 0; i < players.size ; i++ )
        {
            waspangle = angleclamp180( vectortoangles( self.origin - players[ i ].origin )[ 1 ] - players[ i ].angles[ 1 ] );
            
            if ( isalive( players[ i ] ) && !isdefined( players[ i ].revivetrigger ) )
            {
                if ( abs( waspangle ) > 90 && distance2d( self.origin, players[ i ].origin ) > 100 )
                {
                    wait 3;
                }
            }
        }
        
        wait 0.75;
    }
}

// Namespace zm_ai_wasp
// Params 8
// Checksum 0x22f50d56, Offset: 0x3720
// Size: 0x394
function special_wasp_spawn( n_to_spawn, spawn_point, n_radius, n_half_height, b_non_round, spawn_fx, b_return_ai, spawner_override )
{
    if ( !isdefined( n_to_spawn ) )
    {
        n_to_spawn = 1;
    }
    
    if ( !isdefined( n_radius ) )
    {
        n_radius = 32;
    }
    
    if ( !isdefined( n_half_height ) )
    {
        n_half_height = 32;
    }
    
    if ( !isdefined( spawn_fx ) )
    {
        spawn_fx = 1;
    }
    
    if ( !isdefined( b_return_ai ) )
    {
        b_return_ai = 0;
    }
    
    if ( !isdefined( spawner_override ) )
    {
        spawner_override = undefined;
    }
    
    wasp = getentarray( "zombie_wasp", "targetname" );
    
    if ( isdefined( wasp ) && wasp.size >= 9 )
    {
        return 0;
    }
    
    count = 0;
    
    while ( count < n_to_spawn )
    {
        players = getplayers();
        favorite_enemy = get_favorite_enemy();
        spawn_enemy = favorite_enemy;
        
        if ( !isdefined( spawn_enemy ) )
        {
            spawn_enemy = players[ 0 ];
        }
        
        if ( isdefined( level.wasp_spawn_func ) )
        {
            spawn_point = [[ level.wasp_spawn_func ]]( spawn_enemy );
        }
        
        while ( !isdefined( spawn_point ) )
        {
            if ( !isdefined( spawn_point ) )
            {
                spawn_point = wasp_spawn_logic( spawn_enemy );
            }
            
            if ( isdefined( spawn_point ) )
            {
                break;
            }
            
            wait 0.05;
        }
        
        spawner = level.wasp_spawners[ 0 ];
        
        if ( isdefined( spawner_override ) )
        {
            spawner = spawner_override;
        }
        
        ai = zombie_utility::spawn_zombie( spawner );
        v_spawn_origin = spawn_point.origin;
        
        if ( isdefined( ai ) )
        {
            queryresult = positionquery_source_navigation( v_spawn_origin, 0, n_radius, n_half_height, 15, "navvolume_small" );
            
            if ( queryresult.data.size )
            {
                point = queryresult.data[ randomint( queryresult.data.size ) ];
                v_spawn_origin = point.origin;
            }
            
            ai parasite::set_parasite_enemy( favorite_enemy );
            ai.does_not_count_to_round = b_non_round;
            level thread wasp_spawn_init( ai, v_spawn_origin, spawn_fx );
            count++;
        }
        
        wait level.zombie_vars[ "zombie_spawn_delay" ];
    }
    
    if ( b_return_ai )
    {
        return ai;
    }
    
    return 1;
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0x294d19e6, Offset: 0x3ac0
// Size: 0x84
function wasp_run_think()
{
    self endon( #"death" );
    self waittill( #"visible" );
    
    if ( self.health > level.wasp_health )
    {
        self.maxhealth = level.wasp_health;
        self.health = level.wasp_health;
    }
    
    while ( true )
    {
        if ( zm_utility::is_player_valid( self.favoriteenemy ) )
        {
        }
        
        wait 0.2;
    }
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0xce9384df, Offset: 0x3b50
// Size: 0x1d8
function watch_player_melee()
{
    self endon( #"death" );
    self waittill( #"visible" );
    
    while ( isdefined( self ) )
    {
        level waittill( #"player_melee", player, weapon );
        peye = player geteye();
        dist2 = distance2dsquared( peye, self.origin );
        
        if ( dist2 > 5184 )
        {
            continue;
        }
        
        if ( abs( peye[ 2 ] - self.origin[ 2 ] ) > 64 )
        {
            continue;
        }
        
        pfwd = player getweaponforwarddir();
        tome = self.origin - peye;
        tome = vectornormalize( tome );
        dot = vectordot( pfwd, tome );
        
        if ( dot < 0.5 )
        {
            continue;
        }
        
        damage = 150;
        
        if ( isdefined( weapon ) )
        {
            damage = weapon.meleedamage;
        }
        
        self dodamage( damage, peye, player, player, "none", "MOD_MELEE", 0, weapon );
    }
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0xca68be58, Offset: 0x3d30
// Size: 0x3e
function watch_player_melee_events()
{
    self endon( #"disconnect" );
    
    for ( ;; )
    {
        self waittill( #"weapon_melee", weapon );
        level notify( #"player_melee", self, weapon );
    }
}

// Namespace zm_ai_wasp
// Params 0
// Checksum 0xebcbc968, Offset: 0x3d78
// Size: 0x50
function wasp_stalk_audio()
{
    self endon( #"death" );
    self endon( #"wasp_running" );
    self endon( #"wasp_combat" );
    
    while ( true )
    {
        wait randomfloatrange( 3, 6 );
    }
}

// Namespace zm_ai_wasp
// Params 1
// Checksum 0x3bdf36fb, Offset: 0x3dd0
// Size: 0x3c
function wasp_add_to_spawn_pool( optional_player_target )
{
    if ( isdefined( optional_player_target ) )
    {
        array::add( level.a_wasp_priority_targets, optional_player_target );
    }
    
    level.zombie_total++;
}

