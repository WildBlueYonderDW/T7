#using scripts/codescripts/struct;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/hud_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_zm_powerup_zombie_blood;
#using scripts/zm/_zm_sidequests;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_unitrigger;
#using scripts/zm/zm_tomb_chamber;
#using scripts/zm/zm_tomb_ee_main;
#using scripts/zm/zm_tomb_utility;
#using scripts/zm/zm_tomb_vo;

#namespace zm_tomb_ee_main_step_5;

// Namespace zm_tomb_ee_main_step_5
// Params 0
// Checksum 0x7394ab09, Offset: 0x470
// Size: 0x54
function init()
{
    zm_sidequests::declare_sidequest_stage( "little_girl_lost", "step_5", &init_stage, &stage_logic, &exit_stage );
}

// Namespace zm_tomb_ee_main_step_5
// Params 0
// Checksum 0x119a68a1, Offset: 0x4d0
// Size: 0x34
function init_stage()
{
    level._cur_stage_name = "step_5";
    level.callbackvehicledamage = &ee_plane_vehicledamage;
    level.zombie_ai_limit--;
}

// Namespace zm_tomb_ee_main_step_5
// Params 0
// Checksum 0xb43ebf60, Offset: 0x510
// Size: 0x94
function stage_logic()
{
    /#
        iprintln( level._cur_stage_name + "<dev string:x28>" );
    #/
    
    level thread spawn_zombie_blood_plane();
    level flag::wait_till( "ee_maxis_drone_retrieved" );
    util::wait_network_frame();
    zm_sidequests::stage_completed( "little_girl_lost", level._cur_stage_name );
}

// Namespace zm_tomb_ee_main_step_5
// Params 1
// Checksum 0xae415ba0, Offset: 0x5b0
// Size: 0x22
function exit_stage( success )
{
    level.zombie_ai_limit++;
    level notify( #"hash_8b0d379e" );
}

// Namespace zm_tomb_ee_main_step_5
// Params 0
// Checksum 0xbe347344, Offset: 0x5e0
// Size: 0x514
function spawn_zombie_blood_plane()
{
    s_biplane_pos = struct::get( "air_crystal_biplane_pos", "targetname" );
    vh_biplane = spawnvehicle( "biplane_zm", ( 0, 0, 0 ), ( 0, 0, 0 ), "zombie_blood_biplane" );
    vh_biplane flag::init( "biplane_down" );
    vh_biplane zm_powerup_zombie_blood::make_zombie_blood_entity();
    vh_biplane playloopsound( "zmb_zombieblood_3rd_plane_loop", 1 );
    vh_biplane.health = 10000;
    vh_biplane setcandamage( 1 );
    vh_biplane setforcenocull();
    vh_biplane attachpath( getvehiclenode( "biplane_start", "targetname" ) );
    vh_biplane setspeed( 75, 15, 5 );
    vh_biplane startpath();
    vh_biplane clientfield::set( "ee_plane_fx", 1 );
    vh_biplane flag::wait_till( "biplane_down" );
    vh_biplane playsound( "wpn_rocket_explode" );
    e_special_zombie = getentarray( "zombie_spawner_dig", "script_noteworthy" )[ 0 ];
    ai_pilot = zombie_utility::spawn_zombie( e_special_zombie, "zombie_blood_pilot" );
    ai_pilot util::magic_bullet_shield();
    ai_pilot.ignore_enemy_count = 1;
    ai_pilot zm_powerup_zombie_blood::make_zombie_blood_entity();
    ai_pilot forceteleport( vh_biplane.origin, vh_biplane.angles );
    ai_pilot.sndname = "capzomb";
    ai_pilot.ignore_nuke = 1;
    ai_pilot.b_zombie_blood_damage_only = 1;
    ai_pilot.ignore_cleanup_mgr = 1;
    playfx( level._effect[ "biplane_explode" ], vh_biplane.origin );
    vh_biplane delete();
    a_start_pos = struct::get_array( "pilot_goal", "script_noteworthy" );
    a_start_pos = util::get_array_of_closest( ai_pilot.origin, a_start_pos );
    linker = spawn( "script_model", ai_pilot.origin );
    linker setmodel( "tag_origin" );
    ai_pilot linkto( linker );
    linker moveto( a_start_pos[ 0 ].origin, 3 );
    linker waittill( #"movedone" );
    linker delete();
    ai_pilot util::stop_magic_bullet_shield();
    level thread zombie_pilot_sound( ai_pilot );
    ai_pilot.ignoreall = 1;
    ai_pilot.zombie_move_speed = "sprint";
    ai_pilot zombie_utility::set_zombie_run_cycle( "sprint" );
    ai_pilot.zombie_think_done = 1;
    ai_pilot thread pilot_loop_logic( a_start_pos[ 0 ] );
    ai_pilot waittill( #"death" );
    level thread spawn_quadrotor_pickup( ai_pilot.origin, ai_pilot.angles );
}

// Namespace zm_tomb_ee_main_step_5
// Params 1
// Checksum 0xd6241b94, Offset: 0xb00
// Size: 0xbc
function zombie_pilot_sound( ai_pilot )
{
    sndent = spawn( "script_origin", ai_pilot.origin );
    sndent playloopsound( "zmb_zombieblood_3rd_loop_other" );
    
    while ( isdefined( ai_pilot ) && isalive( ai_pilot ) )
    {
        sndent.origin = ai_pilot.origin;
        wait 0.3;
    }
    
    sndent delete();
}

// Namespace zm_tomb_ee_main_step_5
// Params 1
// Checksum 0x77b8383, Offset: 0xbc8
// Size: 0x9c
function pilot_loop_logic( s_start )
{
    self endon( #"death" );
    
    for ( s_goal = s_start; isalive( self ) ; s_goal = struct::get( s_goal.target, "targetname" ) )
    {
        self setgoalpos( s_goal.origin );
        self waittill( #"goal" );
    }
}

// Namespace zm_tomb_ee_main_step_5
// Params 15
// Checksum 0x6a7b560e, Offset: 0xc70
// Size: 0x104
function ee_plane_vehicledamage( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, var_740c2c73, v_point, v_dir, str_hit_loc, v_origin, psoffsettime, b_damage_from_underneath, n_model_index, str_part_name, v_normal )
{
    if ( self.vehicletype == "biplane_zm" && !self flag::get( "biplane_down" ) )
    {
        if ( isplayer( e_attacker ) && e_attacker.zombie_vars[ "zombie_powerup_zombie_blood_on" ] )
        {
            self flag::set( "biplane_down" );
        }
        
        return 0;
    }
    
    return n_damage;
}

// Namespace zm_tomb_ee_main_step_5
// Params 2
// Checksum 0x7cf6eca9, Offset: 0xd80
// Size: 0x19c
function spawn_quadrotor_pickup( v_origin, v_angles )
{
    m_quadrotor = spawn( "script_model", v_origin + ( 0, 0, 30 ) );
    m_quadrotor.angles = v_angles;
    m_quadrotor setmodel( "veh_t7_dlc_zm_quadrotor" );
    m_quadrotor.targetname = "quadrotor_pickup";
    unitrigger_stub = spawnstruct();
    unitrigger_stub.origin = v_origin;
    unitrigger_stub.radius = 36;
    unitrigger_stub.height = 256;
    unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
    unitrigger_stub.hint_string = &"ZM_TOMB_DIHS";
    unitrigger_stub.cursor_hint = "HINT_NOICON";
    unitrigger_stub.require_look_at = 1;
    zm_unitrigger::register_static_unitrigger( unitrigger_stub, &quadrotor_pickup_think );
    level flag::wait_till( "ee_maxis_drone_retrieved" );
    zm_unitrigger::unregister_unitrigger( unitrigger_stub );
}

// Namespace zm_tomb_ee_main_step_5
// Params 0
// Checksum 0x4af01401, Offset: 0xf28
// Size: 0xd0
function quadrotor_pickup_think()
{
    self endon( #"kill_trigger" );
    m_quadrotor = getent( "quadrotor_pickup", "targetname" );
    
    while ( true )
    {
        self waittill( #"trigger", player );
        player playsound( "vox_maxi_drone_upgraded_0" );
        level flag::clear( "ee_quadrotor_disabled" );
        level flag::set( "ee_maxis_drone_retrieved" );
        m_quadrotor delete();
    }
}

