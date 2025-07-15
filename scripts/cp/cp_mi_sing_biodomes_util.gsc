#using scripts/codescripts/struct;
#using scripts/cp/_ammo_cache;
#using scripts/cp/_dialog;
#using scripts/cp/_load;
#using scripts/cp/_objectives;
#using scripts/cp/_skipto;
#using scripts/cp/_spawn_manager;
#using scripts/cp/_util;
#using scripts/shared/ai/archetype_warlord_interface;
#using scripts/shared/ai/warlord;
#using scripts/shared/ai_shared;
#using scripts/shared/animation_shared;
#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/colors_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/fx_shared;
#using scripts/shared/gameobjects_shared;
#using scripts/shared/hud_message_shared;
#using scripts/shared/laststand_shared;
#using scripts/shared/lui_shared;
#using scripts/shared/math_shared;
#using scripts/shared/scene_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/teamgather_shared;
#using scripts/shared/trigger_shared;
#using scripts/shared/util_shared;
#using scripts/shared/vehicle_ai_shared;
#using scripts/shared/vehicle_shared;
#using scripts/shared/visionset_mgr_shared;

#namespace cp_mi_sing_biodomes_util;

/#

    // Namespace cp_mi_sing_biodomes_util
    // Params 1
    // Checksum 0xb1513ff6, Offset: 0x6d0
    // Size: 0x34, Type: dev
    function objective_message( msg )
    {
        println( "<dev string:x28>" + msg );
    }

#/

// Namespace cp_mi_sing_biodomes_util
// Params 1
// Checksum 0x5245256d, Offset: 0x710
// Size: 0x84
function init_hendricks( str_objective )
{
    level.ai_hendricks = util::get_hero( "hendricks" );
    level.ai_hendricks flag::init( "hendricks_on_zipline" );
    level.ai_hendricks setthreatbiasgroup( "heroes" );
    skipto::teleport_ai( str_objective );
}

// Namespace cp_mi_sing_biodomes_util
// Params 1
// Checksum 0xf7cd0514, Offset: 0x7a0
// Size: 0x13c
function kill_previous_spawns( spawn_str )
{
    if ( !spawn_manager::is_killed( spawn_str ) && spawn_manager::is_enabled( spawn_str ) )
    {
        a_enemies = spawn_manager::get_ai( spawn_str );
        
        if ( isdefined( a_enemies ) )
        {
            foreach ( ai in a_enemies )
            {
                ai util::stop_magic_bullet_shield();
                ai kill();
            }
        }
        
        if ( !spawn_manager::is_killed( spawn_str ) )
        {
            spawn_manager::kill( spawn_str );
        }
    }
}

// Namespace cp_mi_sing_biodomes_util
// Params 2
// Checksum 0xc6b11af8, Offset: 0x8e8
// Size: 0x102
function group_triggers_enable( str_group, b_enable )
{
    a_triggers = getentarray( str_group, "script_noteworthy" );
    assert( isdefined( a_triggers ), str_group + "<dev string:x36>" );
    
    if ( isdefined( a_triggers ) )
    {
        foreach ( trigger in a_triggers )
        {
            trigger triggerenable( b_enable );
        }
    }
}

// Namespace cp_mi_sing_biodomes_util
// Params 3
// Checksum 0x1906a8a9, Offset: 0x9f8
// Size: 0xca
function enable_traversals( b_enable, str_name, str_key )
{
    a_nd_traversals = getnodearray( str_name, str_key );
    
    foreach ( node in a_nd_traversals )
    {
        setenablenode( node, b_enable );
    }
}

// Namespace cp_mi_sing_biodomes_util
// Params 1
// Checksum 0x3355764b, Offset: 0xad0
// Size: 0x22
function vo_pick_random_line( a_dialogue_lines )
{
    return array::random( a_dialogue_lines );
}

// Namespace cp_mi_sing_biodomes_util
// Params 1
// Checksum 0xcd8776db, Offset: 0xb00
// Size: 0x22c
function player_interact_anim_generic( n_duration )
{
    if ( !isdefined( n_duration ) )
    {
        n_duration = 1;
    }
    
    self endon( #"death" );
    weapon_current = self getcurrentweapon();
    weapon_fake_interact = getweapon( "syrette" );
    self giveweapon( weapon_fake_interact );
    self switchtoweapon( weapon_fake_interact );
    self setweaponammostock( weapon_fake_interact, 1 );
    self disableweaponfire();
    self disableweaponcycling();
    self disableusability();
    self disableoffhandweapons();
    wait n_duration;
    self takeweapon( weapon_fake_interact );
    self enableweaponfire();
    self enableweaponcycling();
    self enableusability();
    self enableoffhandweapons();
    
    if ( self hasweapon( weapon_current ) )
    {
        self switchtoweapon( weapon_current );
        return;
    }
    
    primaryweapons = self getweaponslistprimaries();
    
    if ( isdefined( primaryweapons ) && primaryweapons.size > 0 )
    {
        self switchtoweapon( primaryweapons[ 0 ] );
    }
}

// Namespace cp_mi_sing_biodomes_util
// Params 3
// Checksum 0x71a266a1, Offset: 0xd38
// Size: 0xea
function function_f61c0df8( var_e39815ad, n_time_min, n_time_max )
{
    var_91efa0da = getnodearray( var_e39815ad, "targetname" );
    
    foreach ( node in var_91efa0da )
    {
        self warlordinterface::addpreferedpoint( node.origin, n_time_min * 1000, n_time_max * 1000 );
    }
}

// Namespace cp_mi_sing_biodomes_util
// Params 4
// Checksum 0xef2aab5a, Offset: 0xe30
// Size: 0x94
function aigroup_retreat( str_aigroup, str_volume, n_delay_min, n_delay_max )
{
    if ( !isdefined( n_delay_min ) )
    {
        n_delay_min = 0;
    }
    
    if ( !isdefined( n_delay_max ) )
    {
        n_delay_max = 0;
    }
    
    a_enemies = spawner::get_ai_group_ai( str_aigroup );
    
    if ( isdefined( a_enemies ) )
    {
        a_enemies set_group_goal_volume( str_volume, n_delay_min, n_delay_max );
    }
}

// Namespace cp_mi_sing_biodomes_util
// Params 3
// Checksum 0x99be592e, Offset: 0xed0
// Size: 0x172
function set_group_goal_volume( str_volume, n_delay_min, n_delay_max )
{
    if ( !isdefined( n_delay_min ) )
    {
        n_delay_min = 0;
    }
    
    if ( !isdefined( n_delay_max ) )
    {
        n_delay_max = 0;
    }
    
    volume = getent( str_volume, "targetname" );
    assert( isdefined( volume ), "<dev string:x72>" + str_volume + "<dev string:x7f>" );
    
    if ( isdefined( volume ) )
    {
        foreach ( ai in self )
        {
            if ( isalive( ai ) )
            {
                ai setgoal( volume, 1 );
            }
            
            if ( n_delay_max > n_delay_min )
            {
                wait randomfloatrange( n_delay_min, n_delay_max );
            }
        }
    }
}

// Namespace cp_mi_sing_biodomes_util
// Params 1
// Checksum 0x43e12498, Offset: 0x1050
// Size: 0x49e
function function_753a859( str_objective )
{
    switch ( str_objective )
    {
        case "objective_igc":
            hidemiscmodels( "fxanim_nursery" );
            hidemiscmodels( "fxanim_markets2" );
            hidemiscmodels( "fxanim_warehouse" );
            hidemiscmodels( "fxanim_cloud_mountain" );
            break;
        case "objective_markets_start":
            hidemiscmodels( "fxanim_nursery" );
            hidemiscmodels( "fxanim_markets2" );
            hidemiscmodels( "fxanim_warehouse" );
            hidemiscmodels( "fxanim_cloud_mountain" );
            break;
        case "objective_markets_rpg":
            hidemiscmodels( "fxanim_warehouse" );
            hidemiscmodels( "fxanim_cloud_mountain" );
            break;
        case "objective_markets2_start":
            hidemiscmodels( "fxanim_cloud_mountain" );
            break;
        case "objective_warehouse":
            hidemiscmodels( "fxanim_party_house" );
            break;
        case "objective_cloudmountain":
            hidemiscmodels( "fxanim_party_house" );
            hidemiscmodels( "fxanim_markets1" );
            hidemiscmodels( "fxanim_nursery" );
            break;
        case "objective_cloudmountain_level_2":
            hidemiscmodels( "fxanim_party_house" );
            hidemiscmodels( "fxanim_markets1" );
            hidemiscmodels( "fxanim_nursery" );
            hidemiscmodels( "fxanim_markets2" );
            hidemiscmodels( "fxanim_warehouse" );
            break;
        case "objective_turret_hallway":
            hidemiscmodels( "fxanim_party_house" );
            hidemiscmodels( "fxanim_markets1" );
            hidemiscmodels( "fxanim_nursery" );
            hidemiscmodels( "fxanim_markets2" );
            hidemiscmodels( "fxanim_warehouse" );
            break;
        default:
            hidemiscmodels( "fxanim_party_house" );
            hidemiscmodels( "fxanim_markets1" );
            hidemiscmodels( "fxanim_nursery" );
            hidemiscmodels( "fxanim_markets2" );
            hidemiscmodels( "fxanim_warehouse" );
            break;
        case "objective_server_room_defend":
            hidemiscmodels( "fxanim_party_house" );
            hidemiscmodels( "fxanim_markets1" );
            hidemiscmodels( "fxanim_nursery" );
            hidemiscmodels( "fxanim_markets2" );
            hidemiscmodels( "fxanim_warehouse" );
            break;
        case "objective_fighttothedome":
            hidemiscmodels( "fxanim_party_house" );
            hidemiscmodels( "fxanim_markets1" );
            hidemiscmodels( "fxanim_nursery" );
            hidemiscmodels( "fxanim_markets2" );
            hidemiscmodels( "fxanim_warehouse" );
            hidemiscmodels( "fxanim_cloud_mountain" );
            break;
    }
}

// Namespace cp_mi_sing_biodomes_util
// Params 0
// Checksum 0xd3e8b52c, Offset: 0x14f8
// Size: 0xf4
function function_d28654c9()
{
    if ( sessionmodeiscampaignzombiesgame() )
    {
        return;
    }
    
    n_body_id = getcharacterbodystyleindex( 0, "CPUI_OUTFIT_BIODOMES" );
    
    if ( self ishost() )
    {
        if ( self getdstat( "highestMapReached" ) <= getmaporder( "cp_mi_sing_biodomes" ) )
        {
            self setcharacterbodystyle( n_body_id );
        }
        
        return;
    }
    
    if ( !self getdstat( "PlayerStatsByMap", "cp_mi_sing_biodomes", "hasBeenCompleted" ) )
    {
        self setcharacterbodystyle( n_body_id );
    }
}

// Namespace cp_mi_sing_biodomes_util
// Params 2
// Checksum 0x447e3411, Offset: 0x15f8
// Size: 0x144
function function_cc20e187( str_area, var_da49671a )
{
    if ( !isdefined( var_da49671a ) )
    {
        var_da49671a = 0;
    }
    
    if ( sessionmodeiscampaignzombiesgame() )
    {
        return;
    }
    
    var_9108873 = getent( "trig_out_of_bound_" + str_area, "targetname" );
    e_clip = getent( "player_clip_" + str_area, "targetname" );
    
    if ( var_da49671a )
    {
        var_9108873 triggerenable( 0 );
        e_clip notsolid();
        trigger::wait_till( "trig_regroup_" + str_area, "script_noteworthy" );
    }
    
    var_9108873 triggerenable( 1 );
    e_clip solid();
}

