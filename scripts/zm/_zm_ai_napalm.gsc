#using scripts/shared/ai/systems/animation_state_machine_mocomp;
#using scripts/shared/ai/systems/animation_state_machine_utility;
#using scripts/shared/ai/systems/behavior_tree_utility;
#using scripts/shared/ai/systems/blackboard;
#using scripts/shared/ai/zombie_death;
#using scripts/shared/ai/zombie_shared;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/system_shared;
#using scripts/shared/util_shared;
#using scripts/shared/visionset_mgr_shared;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_net;
#using scripts/zm/_zm_score;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_utility;

#namespace zm_ai_napalm;

// Namespace zm_ai_napalm
// Params 0, eflags: 0x2
// Checksum 0x8ff137dd, Offset: 0x8f8
// Size: 0x3c
function autoexec __init__sytem__()
{
    system::register( "zm_ai_napalm", &__init__, &__main__, undefined );
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0xa7308638, Offset: 0x940
// Size: 0x24
function __init__()
{
    init_clientfields();
    registerbehaviorscriptfunctions();
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x1627b888, Offset: 0x970
// Size: 0x22c
function __main__()
{
    init_napalm_fx();
    level.napalmzombiesenabled = 1;
    level.napalmzombieminroundwait = 1;
    level.napalmzombiemaxroundwait = 2;
    level.napalmzombieroundrequirement = 5;
    level.nextnapalmspawnround = level.napalmzombieroundrequirement + randomintrange( 0, level.napalmzombiemaxroundwait + 1 );
    level.napalmzombiedamageradius = 250;
    level.napalmexploderadius = 90;
    level.napalmexplodekillradiusjugs = 90;
    level.napalmexplodekillradius = 150;
    level.napalmexplodedamageradius = 400;
    level.napalmexplodedamageradiuswet = 250;
    level.napalmexplodedamagemin = 50;
    level.napalmhealthmultiplier = 4;
    level.var_57ecc1a3 = 0;
    level.var_4e4c9791 = [];
    level.napalm_zombie_spawners = getentarray( "napalm_zombie_spawner", "script_noteworthy" );
    level flag::init( "zombie_napalm_force_spawn" );
    array::thread_all( level.napalm_zombie_spawners, &spawner::add_spawn_function, &napalm_zombie_spawn );
    array::thread_all( level.napalm_zombie_spawners, &spawner::add_spawn_function, &zombie_utility::round_spawn_failsafe );
    _napalm_initsounds();
    zm_spawner::register_zombie_damage_callback( &_napalm_damage_callback );
    level thread function_7cce5d95();
    println( "<dev string:x28>" + level.nextnapalmspawnround );
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0xafabcf7b, Offset: 0xba8
// Size: 0x7c
function registerbehaviorscriptfunctions()
{
    behaviortreenetworkutility::registerbehaviortreescriptapi( "napalmExplodeInitialize", &napalmexplodeinitialize );
    behaviortreenetworkutility::registerbehaviortreescriptapi( "napalmExplodeTerminate", &napalmexplodeterminate );
    behaviortreenetworkutility::registerbehaviortreescriptapi( "napalmCanExplode", &napalmcanexplode );
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x81a19d12, Offset: 0xc30
// Size: 0xa
function get_napalm_spawners()
{
    return level.napalm_zombie_spawners;
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x36dbdd3e, Offset: 0xc48
// Size: 0x14
function get_napalm_locations()
{
    return level.zm_loc_types[ "napalm_location" ];
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0xf1a597e3, Offset: 0xc68
// Size: 0x12c, Type: bool
function napalm_spawn_check()
{
    forcespawn = level flag::get( "zombie_napalm_force_spawn" );
    
    if ( !isdefined( level.napalmzombiesenabled ) || level.napalmzombiesenabled == 0 || level.napalm_zombie_spawners.size == 0 || level.zm_loc_types[ "napalm_location" ].size == 0 )
    {
        return false;
    }
    
    if ( isdefined( level.napalmzombiecount ) && level.napalmzombiecount > 0 )
    {
        return false;
    }
    
    /#
        if ( getdvarint( "<dev string:x45>" ) != 0 )
        {
            return true;
        }
    #/
    
    if ( level.var_57ecc1a3 >= level.round_number )
    {
        return false;
    }
    
    if ( forcespawn )
    {
        return true;
    }
    
    if ( level.nextnapalmspawnround > level.round_number )
    {
        return false;
    }
    
    if ( level.zombie_total == 0 )
    {
        return false;
    }
    
    return level.zombie_total < level.zombiesleftbeforenapalmspawn;
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0xcdd92b83, Offset: 0xda0
// Size: 0x108
function function_7cce5d95()
{
    level waittill( #"start_of_round" );
    
    while ( true )
    {
        if ( napalm_spawn_check() )
        {
            spawner_list = get_napalm_spawners();
            location_list = get_napalm_locations();
            spawner = array::random( spawner_list );
            location = array::random( location_list );
            ai = zombie_utility::spawn_zombie( spawner, spawner.targetname, location );
            
            if ( isdefined( ai ) )
            {
                ai.spawn_point_override = location;
            }
        }
        
        wait 3;
    }
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0xc8ccaf8a, Offset: 0xeb0
// Size: 0xdc
function function_8f86441a()
{
    self endon( #"death" );
    spot = self.spawn_point_override;
    self.spawn_point = spot;
    
    if ( isdefined( spot.target ) )
    {
        self.target = spot.target;
    }
    
    if ( isdefined( spot.zone_name ) )
    {
        self.zone_name = spot.zone_name;
    }
    
    if ( isdefined( spot.script_parameters ) )
    {
        self.script_parameters = spot.script_parameters;
    }
    
    self thread zm_spawner::do_zombie_rise( spot );
    thread function_df01587c();
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x337c0ca3, Offset: 0xf98
// Size: 0x6c
function function_df01587c()
{
    wait 2;
    players = getplayers();
    players[ randomintrange( 0, players.size ) ] thread zm_audio::create_and_play_dialog( "general", "napalm_spawn" );
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x5eb49ddd, Offset: 0x1010
// Size: 0x13c
function _napalm_initsounds()
{
    level.zmb_vox[ "napalm_zombie" ] = [];
    level.zmb_vox[ "napalm_zombie" ][ "ambient" ] = "napalm_ambient";
    level.zmb_vox[ "napalm_zombie" ][ "sprint" ] = "napalm_ambient";
    level.zmb_vox[ "napalm_zombie" ][ "attack" ] = "napalm_attack";
    level.zmb_vox[ "napalm_zombie" ][ "teardown" ] = "napalm_attack";
    level.zmb_vox[ "napalm_zombie" ][ "taunt" ] = "napalm_ambient";
    level.zmb_vox[ "napalm_zombie" ][ "behind" ] = "napalm_ambient";
    level.zmb_vox[ "napalm_zombie" ][ "death" ] = "napalm_explode";
    level.zmb_vox[ "napalm_zombie" ][ "crawler" ] = "napalm_ambient";
}

// Namespace zm_ai_napalm
// Params 1
// Checksum 0x8c421f49, Offset: 0x1158
// Size: 0x70, Type: bool
function _entity_in_zone( zone )
{
    for ( i = 0; i < zone.volumes.size ; i++ )
    {
        if ( self istouching( zone.volumes[ i ] ) )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x21e0b5c, Offset: 0x11d0
// Size: 0x136
function init_napalm_fx()
{
    level._effect[ "napalm_fire_forearm" ] = "dlc5/temple/fx_ztem_napalm_zombie_forearm";
    level._effect[ "napalm_fire_torso" ] = "dlc5/temple/fx_ztem_napalm_zombie_torso";
    level._effect[ "napalm_fire_ground" ] = "dlc5/temple/fx_ztem_napalm_zombie_ground2";
    level._effect[ "napalm_explosion" ] = "dlc5/temple/fx_ztem_napalm_zombie_exp";
    level._effect[ "napalm_fire_trigger" ] = "dlc5/temple/fx_ztem_napalm_zombie_end2";
    level._effect[ "napalm_spawn" ] = "dlc5/temple/fx_ztem_napalm_zombie_spawn7";
    level._effect[ "napalm_distortion" ] = "dlc5/temple/fx_ztem_napalm_zombie_heat";
    level._effect[ "napalm_fire_forearm_end" ] = "dlc5/temple/fx_ztem_napalm_zombie_torso_end";
    level._effect[ "napalm_fire_torso_end" ] = "dlc5/temple/fx_ztem_napalm_zombie_forearm_end";
    level._effect[ "napalm_steam" ] = "dlc5/temple/fx_ztem_zombie_torso_steam_runner";
    level._effect[ "napalm_feet_steam" ] = "dlc5/temple/fx_ztem_zombie_torso_steam_runner";
}

// Namespace zm_ai_napalm
// Params 1
// Checksum 0x8e9c65eb, Offset: 0x1310
// Size: 0x2b4
function napalm_zombie_spawn( animname_set )
{
    self.custom_location = &function_8f86441a;
    zm_spawner::zombie_spawn_init( animname_set );
    
    /#
        println( "<dev string:x5d>" );
        setdvar( "<dev string:x45>", 0 );
    #/
    
    level.var_57ecc1a3 = level.round_number;
    self.animname = "napalm_zombie";
    self thread napalm_zombie_client_flag();
    self.napalm_zombie_glowing = 0;
    self.maxhealth *= getplayers().size * level.napalmhealthmultiplier;
    self.health = self.maxhealth;
    self.no_gib = 1;
    self.rising = 1;
    self.no_damage_points = 1;
    self.explosive_volume = 0;
    self.ignore_enemy_count = 1;
    self.deathfunction = &napalm_zombie_death;
    self.actor_full_damage_func = &_napalm_zombie_damage;
    self.nuke_damage_func = &_napalm_nuke_damage;
    self.instakill_func = undefined;
    self._zombie_shrink_callback = &_napalm_shrink;
    self._zombie_unshrink_callback = &_napalm_unshrink;
    self.water_trigger_func = &napalm_enter_water_trigger;
    self.custom_damage_func = &napalm_custom_damage;
    self.monkey_bolt_taunts = &napalm_monkey_bolt_taunts;
    self.canexplodetime = gettime() + 2000;
    self thread _zombie_watchstopeffects();
    self thread napalm_watch_for_sliding();
    self thread napalm_zombie_count_watch();
    self.zombie_move_speed = "walk";
    self.zombie_arms_position = "up";
    self.variant_type = randomint( 3 );
    self playsound( "evt_napalm_zombie_spawn" );
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x9df19e78, Offset: 0x15d0
// Size: 0x5c
function napalm_zombie_client_flag()
{
    self clientfield::set( "isnapalm", 1 );
    self waittill( #"death" );
    self clientfield::set( "isnapalm", 0 );
    napalm_clear_radius_fx_all_players();
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x99ec1590, Offset: 0x1638
// Size: 0x4
function _napalm_nuke_damage()
{
    
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x99ec1590, Offset: 0x1648
// Size: 0x4
function _napalm_instakill_func()
{
    
}

// Namespace zm_ai_napalm
// Params 1
// Checksum 0xae1b7e2f, Offset: 0x1658
// Size: 0x4c
function napalm_custom_damage( player )
{
    damage = self.meleedamage;
    
    if ( isdefined( self.overridedeathdamage ) )
    {
        damage = int( self.overridedeathdamage );
    }
    
    return damage;
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x3134ea64, Offset: 0x16b0
// Size: 0x1e6
function _zombie_runexplosionwindupeffects()
{
    fx = [];
    fx[ "J_Elbow_LE" ] = "napalm_fire_forearm_end";
    fx[ "J_Elbow_RI" ] = "napalm_fire_forearm_end";
    fx[ "J_Clavicle_RI" ] = "napalm_fire_forearm_end";
    fx[ "J_Clavicle_LE" ] = "napalm_fire_forearm_end";
    fx[ "J_SpineLower" ] = "napalm_fire_torso_end";
    offsets[ "J_SpineLower" ] = ( 0, 10, 0 );
    watch = [];
    keys = getarraykeys( fx );
    
    for ( i = 0; i < keys.size ; i++ )
    {
        jointname = keys[ i ];
        fxname = fx[ jointname ];
        offset = offsets[ jointname ];
        effectent = self _zombie_setupfxonjoint( jointname, fxname, offset );
        watch[ i ] = effectent;
    }
    
    self waittill( #"stop_fx" );
    
    if ( !isdefined( self ) )
    {
        return;
    }
    
    for ( i = 0; i < watch.size ; i++ )
    {
        watch[ i ] delete();
    }
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0xe07f6530, Offset: 0x18a0
// Size: 0x54
function _zombie_watchstopeffects()
{
    self waittill( #"death" );
    self notify( #"stop_fx" );
    
    if ( level flag::get( "world_is_paused" ) )
    {
        self setignorepauseworld( 1 );
    }
}

// Namespace zm_ai_napalm
// Params 1, eflags: 0x4
// Checksum 0xc45317e8, Offset: 0x1900
// Size: 0x312, Type: bool
function private napalmcanexplode( entity )
{
    if ( entity.animname !== "napalm_zombie" )
    {
        return false;
    }
    
    if ( level.napalmexploderadius <= 0 )
    {
        return false;
    }
    
    napalmexploderadiussqr = level.napalmexploderadius * level.napalmexploderadius;
    napalmplayerwarningradius = level.napalmexplodedamageradius;
    napalmplayerwarningradiussqr = napalmplayerwarningradius * napalmplayerwarningradius;
    players = getplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        player = players[ i ];
        
        if ( !zombie_utility::is_player_valid( player ) )
        {
            continue;
        }
        
        if ( distance2dsquared( player.origin, entity.origin ) < napalmplayerwarningradiussqr )
        {
            if ( !isdefined( player.napalmradiuswarningtime ) || player.napalmradiuswarningtime <= gettime() - 0.1 )
            {
                player clientfield::set_to_player( "napalm_pstfx_burn", 1 );
                player playloopsound( "chr_burning_loop", 1 );
                player.napalmradiuswarningtime = gettime() + 10000;
            }
        }
        else
        {
            if ( isdefined( player.napalmradiuswarningtime ) && player.napalmradiuswarningtime > gettime() )
            {
                player exit_napalm_radius();
            }
            
            continue;
        }
        
        if ( !isdefined( entity.favoriteenemy ) || !isplayer( entity.favoriteenemy ) )
        {
            continue;
        }
        
        if ( isdefined( entity.in_the_ground ) && entity.in_the_ground )
        {
            continue;
        }
        
        if ( entity.canexplodetime > gettime() )
        {
            continue;
        }
        
        if ( abs( player.origin[ 2 ] - entity.origin[ 2 ] ) > 50 )
        {
            continue;
        }
        
        if ( distance2dsquared( player.origin, entity.origin ) > napalmexploderadiussqr )
        {
            continue;
        }
        
        return true;
    }
    
    return false;
}

// Namespace zm_ai_napalm
// Params 2, eflags: 0x4
// Checksum 0x65a80b3d, Offset: 0x1c20
// Size: 0x94
function private napalmexplodeinitialize( entity, asmstatename )
{
    if ( level flag::get( "world_is_paused" ) )
    {
        entity setignorepauseworld( 1 );
    }
    
    entity clientfield::set( "napalmexplode", 1 );
    entity playsound( "evt_napalm_zombie_charge" );
}

// Namespace zm_ai_napalm
// Params 2, eflags: 0x4
// Checksum 0x994bba71, Offset: 0x1cc0
// Size: 0x6c
function private napalmexplodeterminate( entity, asmstatename )
{
    napalm_clear_radius_fx_all_players();
    entity.killed_self = 1;
    entity dodamage( entity.health + 666, entity.origin );
}

// Namespace zm_ai_napalm
// Params 8
// Checksum 0x853f0eff, Offset: 0x1d38
// Size: 0x36a
function napalm_zombie_death( einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime )
{
    zombies_axis = array::get_all_closest( self.origin, getaispeciesarray( "axis", "all" ), undefined, undefined, level.napalmzombiedamageradius );
    dogs = array::get_all_closest( self.origin, getaispeciesarray( "allies", "zombie_dog" ), undefined, undefined, level.napalmzombiedamageradius );
    zombies = arraycombine( zombies_axis, dogs, 0, 0 );
    
    if ( isdefined( level._effect[ "napalm_explosion" ] ) )
    {
        playfxontag( level._effect[ "napalm_explosion" ], self, "J_SpineLower" );
    }
    
    self playsound( "evt_napalm_zombie_explo" );
    
    if ( isdefined( self.attacker ) && isplayer( self.attacker ) )
    {
        self.attacker thread zm_audio::create_and_play_dialog( "kill", "napalm" );
    }
    
    level notify( #"napalm_death", self.explosive_volume );
    self thread napalm_delay_delete();
    
    if ( !self napalm_standing_in_water( 1 ) )
    {
        level thread napalm_fire_trigger( self, 80, 20, 0 );
    }
    
    self thread _napalm_damage_zombies( zombies );
    napalm_clear_radius_fx_all_players();
    self _napalm_damage_players();
    
    if ( isdefined( self.attacker ) && isplayer( self.attacker ) && !( isdefined( self.killed_self ) && self.killed_self ) && !( isdefined( self.shrinked ) && self.shrinked ) )
    {
        players = level.players;
        
        for ( i = 0; i < players.size ; i++ )
        {
            player = players[ i ];
            
            if ( zombie_utility::is_player_valid( player ) )
            {
                player zm_score::player_add_points( "thundergun_fling", 300, ( 0, 0, 0 ), 0 );
            }
        }
    }
    
    return self zm_spawner::zombie_death_animscript();
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x6bbb7a0a, Offset: 0x20b0
// Size: 0x64
function napalm_delay_delete()
{
    self endon( #"death" );
    self setplayercollision( 0 );
    self thread zombie_utility::zombie_eye_glow_stop();
    util::wait_network_frame();
    self hide();
}

// Namespace zm_ai_napalm
// Params 1
// Checksum 0x24248c19, Offset: 0x2120
// Size: 0x28e
function _napalm_damage_zombies( zombies )
{
    eyeorigin = self geteye();
    
    if ( !isdefined( zombies ) )
    {
        return;
    }
    
    damageorigin = self.origin;
    standinginwater = self napalm_standing_in_water();
    
    for ( i = 0; i < zombies.size ; i++ )
    {
        if ( !isdefined( zombies[ i ] ) )
        {
            continue;
        }
        
        if ( zm_utility::is_magic_bullet_shield_enabled( zombies[ i ] ) )
        {
            continue;
        }
        
        test_origin = zombies[ i ] geteye();
        
        if ( !bullettracepassed( eyeorigin, test_origin, 0, undefined ) )
        {
            continue;
        }
        
        if ( zombies[ i ].animname == "napalm_zombie" )
        {
            continue;
        }
        
        if ( !standinginwater )
        {
            zombies[ i ] thread zombie_death::flame_death_fx();
        }
        
        refs = [];
        refs[ refs.size ] = "guts";
        refs[ refs.size ] = "right_arm";
        refs[ refs.size ] = "left_arm";
        refs[ refs.size ] = "right_leg";
        refs[ refs.size ] = "left_leg";
        refs[ refs.size ] = "no_legs";
        refs[ refs.size ] = "head";
        
        if ( refs.size )
        {
            zombies[ i ].a.gib_ref = array::random( refs );
        }
        
        zombies[ i ] dodamage( zombies[ i ].health + 666, damageorigin );
        util::wait_network_frame();
    }
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x2e8a8fe6, Offset: 0x23b8
// Size: 0x51a
function _napalm_damage_players()
{
    eyeorigin = self geteye();
    footorigin = self.origin + ( 0, 0, 8 );
    midorigin = ( footorigin[ 0 ], footorigin[ 1 ], ( footorigin[ 2 ] + eyeorigin[ 2 ] ) / 2 );
    players_damaged_by_explosion = 0;
    players = getplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        if ( !zombie_utility::is_player_valid( players[ i ] ) )
        {
            continue;
        }
        
        test_origin = players[ i ] geteye();
        damageradius = level.napalmexplodedamageradius;
        
        if ( isdefined( self.wet ) && self.wet )
        {
            damageradius = level.napalmexplodedamageradiuswet;
        }
        
        if ( distancesquared( eyeorigin, test_origin ) > damageradius * damageradius )
        {
            continue;
        }
        
        test_origin_foot = players[ i ].origin + ( 0, 0, 8 );
        test_origin_mid = ( test_origin_foot[ 0 ], test_origin_foot[ 1 ], ( test_origin_foot[ 2 ] + test_origin[ 2 ] ) / 2 );
        
        if ( !bullettracepassed( eyeorigin, test_origin, 0, undefined ) )
        {
            if ( !bullettracepassed( midorigin, test_origin_mid, 0, undefined ) )
            {
                if ( !bullettracepassed( footorigin, test_origin_foot, 0, undefined ) )
                {
                    continue;
                }
            }
        }
        
        players_damaged_by_explosion = 1;
        
        if ( isdefined( level._effect[ "player_fire_death_napalm" ] ) )
        {
            playfxontag( level._effect[ "player_fire_death_napalm" ], players[ i ], "J_SpineLower" );
        }
        
        dist = distance( eyeorigin, test_origin );
        killplayerdamage = 100;
        killjusgsplayerdamage = 250;
        shellshockmintime = 1.5;
        shellshockmaxtime = 3;
        damage = level.napalmexplodedamagemin;
        shellshocktime = shellshockmaxtime;
        
        if ( dist < level.napalmexplodekillradiusjugs )
        {
            damage = killjusgsplayerdamage;
        }
        else if ( dist < level.napalmexplodekillradius )
        {
            damage = killplayerdamage;
        }
        else
        {
            scale = ( level.napalmexplodedamageradius - dist ) / ( level.napalmexplodedamageradius - level.napalmexplodekillradius );
            shellshocktime = scale * ( shellshockmaxtime - shellshockmintime ) + shellshockmintime;
            damage = scale * ( killplayerdamage - level.napalmexplodedamagemin ) + level.napalmexplodedamagemin;
        }
        
        if ( isdefined( self.shrinked ) && self.shrinked )
        {
            damage *= 0.25;
            shellshocktime *= 0.25;
        }
        
        if ( isdefined( self.wet ) && self.wet )
        {
            damage *= 0.25;
            shellshocktime *= 0.25;
        }
        
        self.overridedeathdamage = damage;
        players[ i ] dodamage( damage, self.origin, self );
        players[ i ] shellshock( "explosion", shellshocktime );
        players[ i ] thread zm_audio::create_and_play_dialog( "kill", "napalm" );
    }
    
    if ( !players_damaged_by_explosion )
    {
        level notify( #"zomb_disposal_achieved" );
    }
}

// Namespace zm_ai_napalm
// Params 4
// Checksum 0xf99d30ad, Offset: 0x28e0
// Size: 0x28c
function napalm_fire_trigger( ai, radius, time, spawnfire )
{
    aiisnapalm = ai.animname == "napalm_zombie";
    
    if ( !aiisnapalm )
    {
        radius /= 2;
    }
    
    spawnflags = 1;
    trigger = spawn( "trigger_radius", ai.origin, spawnflags, radius, 70 );
    sound_ent = undefined;
    
    if ( !isdefined( trigger ) )
    {
        return;
    }
    
    if ( aiisnapalm )
    {
        if ( spawnfire )
        {
            trigger.napalm_fire_damage = 10;
        }
        else
        {
            trigger.napalm_fire_damage = 40;
        }
        
        trigger.napalm_fire_damage_type = "burned";
        
        if ( !spawnfire && isdefined( level._effect[ "napalm_fire_trigger" ] ) )
        {
            sound_ent = spawn( "script_origin", ai.origin );
            sound_ent playloopsound( "evt_napalm_fire", 1 );
            playfx( level._effect[ "napalm_fire_trigger" ], ai.origin );
        }
    }
    else
    {
        trigger.napalm_fire_damage = 10;
        trigger.napalm_fire_damage_type = "triggerhurt";
        
        if ( spawnfire )
        {
            ai thread zombie_death::flame_death_fx();
        }
    }
    
    trigger thread triggerdamage();
    wait time;
    trigger notify( #"end_fire_effect" );
    trigger delete();
    
    if ( isdefined( sound_ent ) )
    {
        sound_ent stoploopsound( 1 );
        wait 1;
        sound_ent delete();
    }
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0xe959757b, Offset: 0x2b78
// Size: 0x140
function triggerdamage()
{
    self endon( #"end_fire_effect" );
    
    while ( true )
    {
        self waittill( #"trigger", guy );
        
        if ( isplayer( guy ) )
        {
            if ( zombie_utility::is_player_valid( guy ) )
            {
                debounce = 500;
                
                if ( !isdefined( guy.last_napalm_fire_damage ) )
                {
                    guy.last_napalm_fire_damage = -1 * debounce;
                }
                
                if ( guy.last_napalm_fire_damage + debounce < gettime() )
                {
                    guy dodamage( self.napalm_fire_damage, guy.origin, undefined, undefined, self.napalm_fire_damage_type );
                    guy.last_napalm_fire_damage = gettime();
                }
            }
            
            continue;
        }
        
        if ( guy.animname != "napalm_zombie" )
        {
            guy thread kill_with_fire( self.napalm_fire_damage_type );
        }
    }
}

// Namespace zm_ai_napalm
// Params 1
// Checksum 0x484bf1bd, Offset: 0x2cc0
// Size: 0x11c
function kill_with_fire( damagetype )
{
    self endon( #"death" );
    
    if ( isdefined( self.marked_for_death ) )
    {
        return;
    }
    
    self.marked_for_death = 1;
    
    if ( self.animname == "monkey_zombie" )
    {
    }
    else
    {
        if ( !isdefined( level.burning_zombies ) )
        {
            level.burning_zombies = [];
        }
        
        if ( level.burning_zombies.size < 6 )
        {
            level.burning_zombies[ level.burning_zombies.size ] = self;
            self thread zombie_flame_watch();
            self playsound( "evt_zombie_ignite" );
            self thread zombie_death::flame_death_fx();
            wait randomfloat( 1.25 );
        }
    }
    
    self dodamage( self.health + 666, self.origin, undefined, undefined, damagetype );
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x37b30d6c, Offset: 0x2de8
// Size: 0x8c
function zombie_flame_watch()
{
    if ( isdefined( level.mutators ) && level.mutators[ "mutator_noTraps" ] )
    {
        return;
    }
    
    self waittill( #"death" );
    
    if ( isdefined( self ) )
    {
        self stoploopsound();
        arrayremovevalue( level.burning_zombies, self );
        return;
    }
    
    array::remove_undefined( level.burning_zombies );
}

// Namespace zm_ai_napalm
// Params 2
// Checksum 0xdbc1d952, Offset: 0x2e80
// Size: 0x11c
function array_remove( array, object )
{
    if ( !isdefined( array ) && !isdefined( object ) )
    {
        return;
    }
    
    new_array = [];
    
    foreach ( item in array )
    {
        if ( item != object )
        {
            if ( !isdefined( new_array ) )
            {
                new_array = [];
            }
            else if ( !isarray( new_array ) )
            {
                new_array = array( new_array );
            }
            
            new_array[ new_array.size ] = item;
        }
    }
    
    return new_array;
}

// Namespace zm_ai_napalm
// Params 3
// Checksum 0x143b6f64, Offset: 0x2fa8
// Size: 0x110
function _zombie_setupfxonjoint( jointname, fxname, offset )
{
    origin = self gettagorigin( jointname );
    effectent = spawn( "script_model", origin );
    effectent setmodel( "tag_origin" );
    effectent.angles = self gettagangles( jointname );
    
    if ( !isdefined( offset ) )
    {
        offset = ( 0, 0, 0 );
    }
    
    effectent linkto( self, jointname, offset );
    playfxontag( level._effect[ fxname ], effectent, "tag_origin" );
    return effectent;
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x99ec1590, Offset: 0x30c0
// Size: 0x4
function _napalm_shrink()
{
    
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x99ec1590, Offset: 0x30d0
// Size: 0x4
function _napalm_unshrink()
{
    
}

// Namespace zm_ai_napalm
// Params 13
// Checksum 0x6d4173ff, Offset: 0x30e0
// Size: 0x88, Type: bool
function _napalm_damage_callback( str_mod, str_hit_location, v_hit_origin, e_player, n_amount, w_weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel )
{
    if ( self.classname == "actor_spawner_zm_temple_napalm" )
    {
        return true;
    }
    
    return false;
}

// Namespace zm_ai_napalm
// Params 11
// Checksum 0xc6adeea3, Offset: 0x3170
// Size: 0xfa
function _napalm_zombie_damage( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, modelindex, psoffsettime )
{
    if ( level.zombie_vars[ "zombie_insta_kill" ] )
    {
        damage *= 2;
    }
    
    if ( isdefined( self.wet ) && self.wet )
    {
        damage *= 5;
    }
    else if ( self napalm_standing_in_water() )
    {
        damage *= 2;
    }
    
    switch ( weapon )
    {
        default:
            damage = 0;
            break;
    }
    
    return damage;
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0xa533374, Offset: 0x3278
// Size: 0xf4
function napalm_zombie_count_watch()
{
    if ( !isdefined( level.napalmzombiecount ) )
    {
        level.napalmzombiecount = 0;
    }
    
    level.napalmzombiecount++;
    level.var_4e4c9791[ level.var_4e4c9791.size ] = self;
    self waittill( #"death" );
    level.napalmzombiecount--;
    arrayremovevalue( level.var_4e4c9791, self, 0 );
    
    if ( isdefined( self.shrinked ) && self.shrinked )
    {
        level.nextnapalmspawnround = level.round_number + 1;
    }
    else
    {
        level.nextnapalmspawnround = level.round_number + randomintrange( level.napalmzombieminroundwait, level.napalmzombiemaxroundwait + 1 );
    }
    
    println( "<dev string:x28>" + level.nextnapalmspawnround );
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0xf6b61c0e, Offset: 0x3378
// Size: 0x86
function napalm_clear_radius_fx_all_players()
{
    players = getplayers();
    
    for ( j = 0; j < players.size ; j++ )
    {
        player_to_clear = players[ j ];
        
        if ( !isdefined( player_to_clear ) )
        {
            continue;
        }
        
        player_to_clear exit_napalm_radius();
    }
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x1e096059, Offset: 0x3408
// Size: 0x48
function exit_napalm_radius()
{
    self clientfield::set_to_player( "napalm_pstfx_burn", 0 );
    self stoploopsound( 2 );
    self.napalmradiuswarningtime = gettime();
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x682a88f5, Offset: 0x3458
// Size: 0xc4
function init_clientfields()
{
    clientfield::register( "actor", "napalmwet", 21000, 1, "int" );
    clientfield::register( "actor", "napalmexplode", 21000, 1, "int" );
    clientfield::register( "actor", "isnapalm", 21000, 1, "int" );
    clientfield::register( "toplayer", "napalm_pstfx_burn", 21000, 1, "int" );
}

// Namespace zm_ai_napalm
// Params 1
// Checksum 0xbda720e0, Offset: 0x3528
// Size: 0x2c
function napalm_enter_water_trigger( trigger )
{
    self endon( #"death" );
    self thread napalm_add_wet_time( 4 );
}

// Namespace zm_ai_napalm
// Params 1
// Checksum 0x6ab671e7, Offset: 0x3560
// Size: 0xb8
function napalm_add_wet_time( time )
{
    self endon( #"death" );
    wettime = time * 1000;
    self.wet_time = gettime() + wettime;
    
    if ( isdefined( self.wet ) && self.wet )
    {
        return;
    }
    
    self.wet = 1;
    self thread napalm_start_wet_fx();
    
    while ( self.wet_time > gettime() )
    {
        wait 0.1;
    }
    
    self thread napalm_end_wet_fx();
    self.wet = 0;
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0xfd512e4f, Offset: 0x3620
// Size: 0x4e
function napalm_watch_for_sliding()
{
    self endon( #"death" );
    
    while ( true )
    {
        if ( isdefined( self.sliding ) && self.sliding )
        {
            self thread napalm_add_wet_time( 4 );
        }
        
        wait 1;
    }
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0xed7171bc, Offset: 0x3678
// Size: 0x24
function napalm_start_wet_fx()
{
    self clientfield::set( "napalmwet", 1 );
}

// Namespace zm_ai_napalm
// Params 0
// Checksum 0x7af64c26, Offset: 0x36a8
// Size: 0x24
function napalm_end_wet_fx()
{
    self clientfield::set( "napalmwet", 0 );
}

// Namespace zm_ai_napalm
// Params 1
// Checksum 0xdd0bddd5, Offset: 0x36d8
// Size: 0xba
function napalm_standing_in_water( forcecheck )
{
    dotrace = !isdefined( self.standing_in_water_debounce );
    dotrace = dotrace || self.standing_in_water_debounce < gettime();
    dotrace = isdefined( forcecheck ) && ( dotrace || forcecheck );
    
    if ( dotrace )
    {
        self.standing_in_water_debounce = gettime() + 500;
        waterheight = getwaterheight( self.origin );
        self.standing_in_water = waterheight > self.origin[ 2 ];
    }
    
    return self.standing_in_water;
}

// Namespace zm_ai_napalm
// Params 1
// Checksum 0xec576843, Offset: 0x37a0
// Size: 0x10, Type: bool
function napalm_monkey_bolt_taunts( monkey_bolt )
{
    return true;
}

