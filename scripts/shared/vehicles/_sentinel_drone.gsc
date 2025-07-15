#using scripts/codescripts/struct;
#using scripts/shared/ai/blackboard_vehicle;
#using scripts/shared/ai/systems/ai_interface;
#using scripts/shared/ai/systems/blackboard;
#using scripts/shared/animation_shared;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/math_shared;
#using scripts/shared/statemachine_shared;
#using scripts/shared/system_shared;
#using scripts/shared/util_shared;
#using scripts/shared/vehicle_ai_shared;
#using scripts/shared/vehicle_death_shared;
#using scripts/shared/vehicle_shared;

#namespace sentinel_drone;

// Namespace sentinel_drone
// Params 0, eflags: 0x2
// Checksum 0x9518ac67, Offset: 0xbc0
// Size: 0x34
function autoexec __init__sytem__()
{
    system::register( "sentinel_drone", &__init__, undefined, undefined );
}

// Namespace sentinel_drone
// Params 0
// Checksum 0x6b80916, Offset: 0xc00
// Size: 0x73e
function __init__()
{
    clientfield::register( "scriptmover", "sentinel_drone_beam_set_target_id", 12000, 5, "int" );
    clientfield::register( "vehicle", "sentinel_drone_beam_set_source_to_target", 12000, 5, "int" );
    clientfield::register( "toplayer", "sentinel_drone_damage_player_fx", 12000, 1, "counter" );
    clientfield::register( "vehicle", "sentinel_drone_beam_fire1", 12000, 1, "int" );
    clientfield::register( "vehicle", "sentinel_drone_beam_fire2", 12000, 1, "int" );
    clientfield::register( "vehicle", "sentinel_drone_beam_fire3", 12000, 1, "int" );
    clientfield::register( "vehicle", "sentinel_drone_arm_cut_1", 12000, 1, "int" );
    clientfield::register( "vehicle", "sentinel_drone_arm_cut_2", 12000, 1, "int" );
    clientfield::register( "vehicle", "sentinel_drone_arm_cut_3", 12000, 1, "int" );
    clientfield::register( "vehicle", "sentinel_drone_face_cut", 12000, 1, "int" );
    clientfield::register( "vehicle", "sentinel_drone_beam_charge", 12000, 1, "int" );
    clientfield::register( "vehicle", "sentinel_drone_camera_scanner", 12000, 1, "int" );
    clientfield::register( "vehicle", "sentinel_drone_camera_destroyed", 12000, 1, "int" );
    clientfield::register( "scriptmover", "sentinel_drone_deathfx", 1, 1, "int" );
    vehicle::add_main_callback( "sentinel_drone", &sentinel_drone_initialize );
    level._sentinel_enemy_detected_taunts = [];
    
    if ( !isdefined( level._sentinel_enemy_detected_taunts ) )
    {
        level._sentinel_enemy_detected_taunts = [];
    }
    else if ( !isarray( level._sentinel_enemy_detected_taunts ) )
    {
        level._sentinel_enemy_detected_taunts = array( level._sentinel_enemy_detected_taunts );
    }
    
    level._sentinel_enemy_detected_taunts[ level._sentinel_enemy_detected_taunts.size ] = "vox_valk_valkyrie_detected_0";
    
    if ( !isdefined( level._sentinel_enemy_detected_taunts ) )
    {
        level._sentinel_enemy_detected_taunts = [];
    }
    else if ( !isarray( level._sentinel_enemy_detected_taunts ) )
    {
        level._sentinel_enemy_detected_taunts = array( level._sentinel_enemy_detected_taunts );
    }
    
    level._sentinel_enemy_detected_taunts[ level._sentinel_enemy_detected_taunts.size ] = "vox_valk_valkyrie_detected_1";
    
    if ( !isdefined( level._sentinel_enemy_detected_taunts ) )
    {
        level._sentinel_enemy_detected_taunts = [];
    }
    else if ( !isarray( level._sentinel_enemy_detected_taunts ) )
    {
        level._sentinel_enemy_detected_taunts = array( level._sentinel_enemy_detected_taunts );
    }
    
    level._sentinel_enemy_detected_taunts[ level._sentinel_enemy_detected_taunts.size ] = "vox_valk_valkyrie_detected_2";
    
    if ( !isdefined( level._sentinel_enemy_detected_taunts ) )
    {
        level._sentinel_enemy_detected_taunts = [];
    }
    else if ( !isarray( level._sentinel_enemy_detected_taunts ) )
    {
        level._sentinel_enemy_detected_taunts = array( level._sentinel_enemy_detected_taunts );
    }
    
    level._sentinel_enemy_detected_taunts[ level._sentinel_enemy_detected_taunts.size ] = "vox_valk_valkyrie_detected_3";
    
    if ( !isdefined( level._sentinel_enemy_detected_taunts ) )
    {
        level._sentinel_enemy_detected_taunts = [];
    }
    else if ( !isarray( level._sentinel_enemy_detected_taunts ) )
    {
        level._sentinel_enemy_detected_taunts = array( level._sentinel_enemy_detected_taunts );
    }
    
    level._sentinel_enemy_detected_taunts[ level._sentinel_enemy_detected_taunts.size ] = "vox_valk_valkyrie_detected_4";
    level._sentinel_system_critical_taunts = [];
    
    if ( !isdefined( level._sentinel_system_critical_taunts ) )
    {
        level._sentinel_system_critical_taunts = [];
    }
    else if ( !isarray( level._sentinel_system_critical_taunts ) )
    {
        level._sentinel_system_critical_taunts = array( level._sentinel_system_critical_taunts );
    }
    
    level._sentinel_system_critical_taunts[ level._sentinel_system_critical_taunts.size ] = "vox_valk_valkyrie_health_low_0";
    
    if ( !isdefined( level._sentinel_system_critical_taunts ) )
    {
        level._sentinel_system_critical_taunts = [];
    }
    else if ( !isarray( level._sentinel_system_critical_taunts ) )
    {
        level._sentinel_system_critical_taunts = array( level._sentinel_system_critical_taunts );
    }
    
    level._sentinel_system_critical_taunts[ level._sentinel_system_critical_taunts.size ] = "vox_valk_valkyrie_health_low_1";
    
    if ( !isdefined( level._sentinel_system_critical_taunts ) )
    {
        level._sentinel_system_critical_taunts = [];
    }
    else if ( !isarray( level._sentinel_system_critical_taunts ) )
    {
        level._sentinel_system_critical_taunts = array( level._sentinel_system_critical_taunts );
    }
    
    level._sentinel_system_critical_taunts[ level._sentinel_system_critical_taunts.size ] = "vox_valk_valkyrie_health_low_2";
    
    if ( !isdefined( level._sentinel_system_critical_taunts ) )
    {
        level._sentinel_system_critical_taunts = [];
    }
    else if ( !isarray( level._sentinel_system_critical_taunts ) )
    {
        level._sentinel_system_critical_taunts = array( level._sentinel_system_critical_taunts );
    }
    
    level._sentinel_system_critical_taunts[ level._sentinel_system_critical_taunts.size ] = "vox_valk_valkyrie_health_low_3";
    
    if ( !isdefined( level._sentinel_system_critical_taunts ) )
    {
        level._sentinel_system_critical_taunts = [];
    }
    else if ( !isarray( level._sentinel_system_critical_taunts ) )
    {
        level._sentinel_system_critical_taunts = array( level._sentinel_system_critical_taunts );
    }
    
    level._sentinel_system_critical_taunts[ level._sentinel_system_critical_taunts.size ] = "vox_valk_valkyrie_health_low_4";
}

// Namespace sentinel_drone
// Params 0
// Checksum 0x27cbfd69, Offset: 0x1348
// Size: 0x58c
function sentinel_drone_initialize()
{
    self useanimtree( $generic );
    target_set( self, ( 0, 0, 0 ) );
    self.health = self.healthdefault;
    
    if ( !isdefined( level.sentineldronemaxhealth ) )
    {
        level.sentineldronemaxhealth = self.health;
    }
    
    self.maxhealth = level.sentineldronemaxhealth;
    
    if ( !isdefined( level.sentineldronehealtharmleft ) )
    {
        level.sentineldronehealtharmleft = 200;
    }
    
    if ( !isdefined( level.sentineldronehealtharmright ) )
    {
        level.sentineldronehealtharmright = 200;
    }
    
    if ( !isdefined( level.sentineldronehealtharmtop ) )
    {
        level.sentineldronehealtharmtop = 200;
    }
    
    if ( !isdefined( level.sentineldronehealthface ) )
    {
        level.sentineldronehealthface = 200;
    }
    
    if ( !isdefined( level.sentineldronehealthcamera ) )
    {
        level.sentineldronehealthcamera = 300;
    }
    
    if ( !isdefined( level.sentineldronehealthcore ) )
    {
        level.sentineldronehealthcore = 100;
    }
    
    self.sentineldronehealtharms = [];
    self.sentineldronehealtharms[ 2 ] = level.sentineldronehealtharmleft;
    self.sentineldronehealtharms[ 1 ] = level.sentineldronehealtharmright;
    self.sentineldronehealtharms[ 3 ] = level.sentineldronehealtharmtop;
    self.sentineldronehealthface = level.sentineldronehealthface;
    self.sentineldronehealthcamera = level.sentineldronehealthcamera;
    self.sentineldronehealthcore = level.sentineldronehealthcore;
    self.beam_fire_target = util::spawn_model( "tag_origin", self.position, self.angles );
    
    if ( !isdefined( level.sentinel_drone_target_id ) )
    {
        level.sentinel_drone_target_id = 0;
    }
    
    level.sentinel_drone_target_id = ( level.sentinel_drone_target_id + 1 ) % 32;
    
    if ( level.sentinel_drone_target_id == 0 )
    {
        level.sentinel_drone_target_id = 1;
    }
    
    self.drone_target_id = level.sentinel_drone_target_id;
    blackboard::createblackboardforentity( self );
    self blackboard::registervehicleblackboardattributes();
    ai::createinterfaceforentity( self );
    self vehicle::friendly_fire_shield();
    self enableaimassist();
    self setneargoalnotifydist( 35 );
    self setvehicleavoidance( 1 );
    self setdrawinfrared( 1 );
    self sethoverparams( 0, 0, 10 );
    self.no_gib = 1;
    self.fovcosine = 0;
    self.fovcosinebusy = 0;
    self.vehaircraftcollisionenabled = 1;
    assert( isdefined( self.scriptbundlesettings ) );
    self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
    self.goalradius = 999999;
    self.goalheight = 4000;
    self setgoal( self.origin, 0, self.goalradius, self.goalheight );
    self.nextjuketime = 0;
    self.nextrolltime = 0;
    self.arms_count = 3;
    setdvar( "Sentinel_Move_Speed", 25 );
    setdvar( "Sentinel_Evade_Speed", 40 );
    self.should_buff_zombies = 0;
    self.disable_flame_fx = 1;
    self.no_widows_wine = 1;
    self.targetplayertime = gettime() + 1000 + randomint( 1000 );
    self.pers = [];
    self.pers[ "team" ] = self.team;
    self.overridevehicledamage = &sentinel_callbackdamage;
    self.overridevehicleradiusdamage = &sentinel_drone_callbackradiusdamage;
    
    if ( !isdefined( level.a_sentinel_drones ) )
    {
        level.a_sentinel_drones = [];
    }
    
    array::add( level.a_sentinel_drones, self );
    
    if ( isdefined( level.func_custom_sentinel_drone_cleanup_check ) )
    {
        self.func_custom_cleanup_check = level.func_custom_sentinel_drone_cleanup_check;
    }
    
    self thread vehicle_ai::nudge_collision();
    self thread sentinel_hideinitialbrokenparts();
    self thread sentinel_initbeamlaunchers();
    
    /#
        self thread sentinel_debugfx();
        self thread sentinel_debugbehavior();
    #/
    
    defaultrole();
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xe4ac731e, Offset: 0x18e0
// Size: 0x90
function sentinel_initbeamlaunchers()
{
    self endon( #"death" );
    
    if ( !isdefined( self.target_initialized ) )
    {
        wait 1;
        self.beam_fire_target clientfield::set( "sentinel_drone_beam_set_target_id", self.drone_target_id );
        wait 0.1;
        self clientfield::set( "sentinel_drone_beam_set_source_to_target", self.drone_target_id );
        wait 1;
        self.target_initialized = 1;
    }
}

// Namespace sentinel_drone
// Params 0
// Checksum 0x8bbd90b0, Offset: 0x1978
// Size: 0xb4
function defaultrole()
{
    self vehicle_ai::init_state_machine_for_role( "default" );
    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;
    self vehicle_ai::call_custom_add_state_callbacks();
    vehicle_ai::startinitialstate( "combat" );
}

// Namespace sentinel_drone
// Params 1, eflags: 0x4
// Checksum 0xbc469000, Offset: 0x1a38
// Size: 0x198, Type: bool
function private is_target_valid( target )
{
    if ( !isdefined( target ) )
    {
        return false;
    }
    
    if ( !isalive( target ) )
    {
        return false;
    }
    
    if ( isplayer( target ) && target.sessionstate == "spectator" )
    {
        return false;
    }
    
    if ( isplayer( target ) && target.sessionstate == "intermission" )
    {
        return false;
    }
    
    if ( isdefined( target.ignoreme ) && target.ignoreme )
    {
        return false;
    }
    
    if ( target isnotarget() )
    {
        return false;
    }
    
    if ( isdefined( target.is_elemental_zombie ) && target.is_elemental_zombie )
    {
        return false;
    }
    
    if ( isdefined( level.is_valid_player_for_sentinel_drone ) )
    {
        if ( ![[ level.is_valid_player_for_sentinel_drone ]]( target ) )
        {
            return false;
        }
    }
    
    if ( isdefined( self.should_buff_zombies ) && self.should_buff_zombies && isplayer( target ) )
    {
        if ( isdefined( get_sentinel_nearest_zombie() ) )
        {
            return false;
        }
    }
    
    return true;
}

// Namespace sentinel_drone
// Params 3
// Checksum 0x38ec563e, Offset: 0x1bd8
// Size: 0x9c
function get_sentinel_nearest_zombie( b_ignore_elemental, b_outside_playable_area, radius )
{
    if ( !isdefined( b_ignore_elemental ) )
    {
        b_ignore_elemental = 1;
    }
    
    if ( !isdefined( b_outside_playable_area ) )
    {
        b_outside_playable_area = 1;
    }
    
    if ( !isdefined( radius ) )
    {
        radius = 2000;
    }
    
    if ( isdefined( self.sentinel_getnearestzombie ) )
    {
        ai_zombie = [[ self.sentinel_getnearestzombie ]]( self.origin, b_ignore_elemental, b_outside_playable_area, radius );
        return ai_zombie;
    }
    
    return undefined;
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xaf8fe969, Offset: 0x1c80
// Size: 0x1ec
function get_sentinel_drone_enemy()
{
    sentinel_drone_targets = getplayers();
    least_hunted = sentinel_drone_targets[ 0 ];
    search_distance_sq = 2000 * 2000;
    
    for ( i = 0; i < sentinel_drone_targets.size ; i++ )
    {
        if ( !isdefined( sentinel_drone_targets[ i ].hunted_by_sentinel ) )
        {
            sentinel_drone_targets[ i ].hunted_by_sentinel = 0;
        }
        
        if ( !is_target_valid( sentinel_drone_targets[ i ] ) )
        {
            continue;
        }
        
        if ( !is_target_valid( least_hunted ) )
        {
            least_hunted = sentinel_drone_targets[ i ];
            continue;
        }
        
        dist_to_target_sq = distance2dsquared( self.origin, sentinel_drone_targets[ i ].origin );
        dist_to_least_hunted_sq = distance2dsquared( self.origin, least_hunted.origin );
        
        if ( dist_to_least_hunted_sq >= search_distance_sq && dist_to_target_sq < search_distance_sq )
        {
            least_hunted = sentinel_drone_targets[ i ];
            continue;
        }
        
        if ( sentinel_drone_targets[ i ].hunted_by_sentinel < least_hunted.hunted_by_sentinel )
        {
            least_hunted = sentinel_drone_targets[ i ];
        }
    }
    
    if ( !is_target_valid( least_hunted ) )
    {
        return undefined;
    }
    
    return least_hunted;
}

// Namespace sentinel_drone
// Params 1
// Checksum 0x6ee4e7a5, Offset: 0x1e78
// Size: 0x184
function set_sentinel_drone_enemy( enemy )
{
    if ( isdefined( self.sentinel_droneenemy ) )
    {
        if ( !isdefined( self.sentinel_droneenemy.hunted_by_sentinel ) )
        {
            self.sentinel_droneenemy.hunted_by_sentinel = 0;
        }
        
        if ( self.sentinel_droneenemy.hunted_by_sentinel > 0 )
        {
            self.sentinel_droneenemy.hunted_by_sentinel--;
        }
    }
    
    if ( !is_target_valid( enemy ) )
    {
        self.sentinel_droneenemy = undefined;
        self clearlookatent();
        self clearturrettarget( 0 );
        return;
    }
    
    self.sentinel_droneenemy = enemy;
    
    if ( isdefined( self.skip_first_taunt ) )
    {
        if ( isplayer( enemy ) )
        {
            sentinel_play_taunt( level._sentinel_enemy_detected_taunts );
        }
    }
    else
    {
        self.skip_first_taunt = 1;
    }
    
    if ( !isdefined( self.sentinel_droneenemy.hunted_by_sentinel ) )
    {
        self.sentinel_droneenemy.hunted_by_sentinel = 0;
    }
    
    self.sentinel_droneenemy.hunted_by_sentinel++;
    self setlookatent( self.sentinel_droneenemy );
    self setturrettargetent( self.sentinel_droneenemy );
}

// Namespace sentinel_drone
// Params 0, eflags: 0x4
// Checksum 0x569eab27, Offset: 0x2008
// Size: 0xf8
function private sentinel_drone_target_selection()
{
    self endon( #"change_state" );
    self endon( #"death" );
    
    for ( ;; )
    {
        if ( isdefined( self.ignoreall ) && self.ignoreall )
        {
            wait 0.5;
            continue;
        }
        
        if ( is_target_valid( self.sentinel_droneenemy ) )
        {
            wait 0.5;
            continue;
        }
        
        if ( isdefined( self.should_buff_zombies ) && self.should_buff_zombies )
        {
            target = get_sentinel_nearest_zombie();
            
            if ( !isdefined( target ) )
            {
                target = get_sentinel_drone_enemy();
            }
        }
        else
        {
            target = get_sentinel_drone_enemy();
        }
        
        set_sentinel_drone_enemy( target );
        wait 0.5;
    }
}

// Namespace sentinel_drone
// Params 1
// Checksum 0xebcb5bf5, Offset: 0x2108
// Size: 0x1d0
function state_combat_update( params )
{
    self endon( #"change_state" );
    self endon( #"death" );
    self.lasttimetargetinsight = 0;
    self.nextjuketime = 0;
    wait 0.3;
    
    if ( isdefined( self.owner ) && isdefined( self.owner.enemy ) )
    {
        self.sentinel_droneenemy = self.owner.enemy;
    }
    
    thread sentinel_drone_target_selection();
    thread sentinel_navigatetheworld();
    thread sentine_rumblewhennearplayer();
    
    while ( true )
    {
        if ( isdefined( self.playing_intro_anim ) && self.playing_intro_anim )
        {
            wait 0.1;
        }
        else if ( isdefined( self.is_charging_at_player ) && self.is_charging_at_player )
        {
            wait 0.1;
        }
        else if ( isdefined( self.shouldroll ) && !isdefined( self.forced_pos ) && self.shouldroll )
        {
            if ( sentinel_dodgeroll() )
            {
                thread sentinel_navigatetheworld();
            }
        }
        else if ( !isdefined( self.sentinel_droneenemy ) )
        {
            wait 0.25;
        }
        else if ( self.arms_count > 0 )
        {
            if ( randomint( 100 ) < 30 )
            {
                if ( self sentinel_firelogic() )
                {
                    thread sentinel_navigatetheworld();
                }
            }
        }
        
        wait 0.1;
    }
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xddf5b2ba, Offset: 0x22e0
// Size: 0x3c
function sentinel_intro()
{
    sentinel_navigationstandstill();
    self.playing_intro_anim = 1;
    self asmrequestsubstate( "intro@default" );
}

// Namespace sentinel_drone
// Params 0
// Checksum 0x80a511ab, Offset: 0x2328
// Size: 0x44
function sentinel_introcompleted()
{
    self.playing_intro_anim = 0;
    
    if ( !self vehicle_ai::is_instate( "scripted" ) )
    {
        self thread sentinel_navigatetheworld();
    }
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xaf11c778, Offset: 0x2378
// Size: 0x4c8
function sentinel_dodgeroll()
{
    self endon( #"change_state" );
    self endon( #"death" );
    roll_dir = anglestoright( self.angles );
    roll_dir = vectornormalize( roll_dir );
    juke_initial_pause = getdvarfloat( "sentinel_drone_juke_initial_pause_dvar", 0.2 );
    juke_speed = getdvarint( "sentinel_drone_juke_speed_dvar", 300 );
    juke_offset = getdvarint( "sentinel_drone_juke_offset_dvar", 20 );
    juke_distance = getdvarint( "sentinel_drone_juke_distance_dvar", 100 );
    juke_distance_max = getdvarint( "sentinel_drone_juke_distance_max_dvar", 250 );
    juke_min_anim_rate = getdvarfloat( "sentinel_drone_juke_min_anim_rate_dvar", 0.9 );
    can_roll = 0;
    
    if ( math::cointoss() )
    {
        roll_point = self.origin + vectorscale( roll_dir, juke_distance_max );
        roll_asm_state = "dodge_right@attack";
    }
    else
    {
        roll_dir = vectorscale( roll_dir, -1 );
        roll_point = self.origin - vectorscale( roll_dir, juke_distance_max * -1 );
        roll_asm_state = "dodge_left@attack";
    }
    
    trace = sentinel_trace( self.origin, roll_point, self, 1 );
    
    if ( isdefined( trace[ "position" ] ) )
    {
        if ( !ispointinnavvolume( trace[ "position" ], "navvolume_small" ) )
        {
            trace[ "position" ] = self getclosestpointonnavvolume( trace[ "position" ], 100 );
        }
        
        if ( isdefined( trace[ "position" ] ) )
        {
            if ( trace[ "fraction" ] == 1 )
            {
                roll_distance = juke_distance_max - juke_offset;
            }
            else
            {
                roll_distance = juke_distance_max * trace[ "fraction" ] - juke_offset;
            }
            
            if ( roll_distance >= juke_distance )
            {
                roll_anim_rate = juke_distance / roll_distance;
                
                if ( roll_anim_rate < juke_min_anim_rate )
                {
                    roll_anim_rate = juke_min_anim_rate;
                }
                
                roll_speed = roll_distance / juke_distance * juke_speed;
                can_roll = 1;
            }
        }
    }
    
    self.shouldroll = 0;
    
    if ( can_roll )
    {
        sentinel_navigationstandstill();
        wait 0.1;
        self clientfield::set( "sentinel_drone_camera_scanner", 1 );
        self asmrequestsubstate( roll_asm_state );
        self asmsetanimationrate( roll_anim_rate );
        wait juke_initial_pause;
        self setspeed( roll_speed );
        self setvehvelocity( vectorscale( roll_dir, roll_speed ) );
        self setvehgoalpos( trace[ "position" ], 1, 0 );
        wait 1;
        self asmsetanimationrate( 1 );
        sentinel_navigationstandstill();
        self clientfield::set( "sentinel_drone_camera_scanner", 0 );
        wait 0.1;
    }
    
    if ( math::cointoss() )
    {
        self sentinel_firelogic();
    }
    
    return can_roll;
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xdbc99a36, Offset: 0x2848
// Size: 0x27c
function sentinel_navigationstandstill()
{
    self endon( #"change_state" );
    self endon( #"death" );
    self notify( #"abort_navigation" );
    self notify( #"near_goal" );
    wait 0.05;
    
    if ( getdvarint( "sentinel_NavigationStandStill_new", 0 ) > 0 )
    {
        self clearvehgoalpos();
        self setvehvelocity( ( 0, 0, 0 ) );
        self.vehaircraftcollisionenabled = 1;
        
        /#
            if ( getdvarint( "<dev string:x28>" ) > 0 )
            {
                recordsphere( self.origin, 30, ( 1, 0.5, 0 ) );
            }
        #/
        
        return;
    }
    
    if ( getdvarint( "sentinel_ClearVehGoalPos", 1 ) == 1 )
    {
        self clearvehgoalpos();
    }
    
    if ( getdvarint( "sentinel_PathVariableOffsetClear", 1 ) == 1 )
    {
        self pathvariableoffsetclear();
    }
    
    if ( getdvarint( "sentinel_PathFixedOffsetClear", 1 ) == 1 )
    {
        self pathfixedoffsetclear();
    }
    
    if ( getdvarint( "sentinel_ClearSpeed", 1 ) == 1 )
    {
        self setspeed( 0 );
        self setvehvelocity( ( 0, 0, 0 ) );
        self setphysacceleration( ( 0, 0, 0 ) );
        self setangularvelocity( ( 0, 0, 0 ) );
    }
    
    self.vehaircraftcollisionenabled = 1;
    
    /#
        if ( getdvarint( "<dev string:x28>" ) > 0 )
        {
            recordsphere( self.origin, 30, ( 1, 0.5, 0 ) );
        }
    #/
}

// Namespace sentinel_drone
// Params 0, eflags: 0x4
// Checksum 0x916d801a, Offset: 0x2ad0
// Size: 0xbe, Type: bool
function private sentinel_shouldchangesentinelposition()
{
    if ( gettime() > self.nextjuketime )
    {
        return true;
    }
    
    if ( isdefined( self.sentinel_droneenemy ) )
    {
        if ( isdefined( self.lastjuketime ) )
        {
            if ( gettime() - self.lastjuketime > 3000 )
            {
                speed = self getspeed();
                
                if ( speed < 1 )
                {
                    if ( !sentinel_isinsideengagementdistance( self.origin, self.sentinel_droneenemy.origin + ( 0, 0, 48 ), 1 ) )
                    {
                        return true;
                    }
                }
            }
        }
    }
    
    return false;
}

// Namespace sentinel_drone
// Params 0, eflags: 0x4
// Checksum 0xf6de3766, Offset: 0x2b98
// Size: 0x10
function private sentinel_changesentinelposition()
{
    self.nextjuketime = 0;
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xaa502140, Offset: 0x2bb0
// Size: 0xa80
function sentinel_navigatetheworld()
{
    self endon( #"change_state" );
    self endon( #"death" );
    self endon( #"abort_navigation" );
    self notify( #"sentinel_navigatetheworld" );
    self endon( #"sentinel_navigatetheworld" );
    lasttimechangeposition = 0;
    self.shouldgotonewposition = 0;
    self.last_failsafe_count = 0;
    sentinel_move_speed = getdvarint( "Sentinel_Move_Speed", 25 );
    sentinel_evade_speed = getdvarint( "Sentinel_Evade_Speed", 40 );
    self setspeed( sentinel_move_speed );
    self asmrequestsubstate( "locomotion@movement" );
    self.current_pathto_pos = undefined;
    self.next_near_player_check = 0;
    b_use_path_finding = 1;
    
    while ( true )
    {
        current_pathto_pos = undefined;
        b_in_tactical_position = 0;
        
        if ( isdefined( self.playing_intro_anim ) && self.playing_intro_anim )
        {
            wait 0.1;
        }
        else if ( self.goalforced )
        {
            returndata = [];
            returndata[ "origin" ] = self getclosestpointonnavvolume( self.goalpos, 100 );
            returndata[ "centerOnNav" ] = ispointinnavvolume( self.origin, "navvolume_small" );
            current_pathto_pos = returndata[ "origin" ];
        }
        else if ( isdefined( self.forced_pos ) )
        {
            returndata = [];
            returndata[ "origin" ] = self getclosestpointonnavvolume( self.forced_pos, 100 );
            returndata[ "centerOnNav" ] = ispointinnavvolume( self.origin, "navvolume_small" );
            current_pathto_pos = returndata[ "origin" ];
        }
        else if ( sentinel_shouldchangesentinelposition() )
        {
            if ( isdefined( self.evading_player ) && self.evading_player )
            {
                self.evading_player = 0;
                self setspeed( sentinel_evade_speed );
            }
            else
            {
                self setspeed( sentinel_move_speed );
            }
            
            returndata = sentinel_getnextmovepositiontactical( self.should_buff_zombies );
            current_pathto_pos = returndata[ "origin" ];
            self.lastjuketime = gettime();
            self.nextjuketime = gettime() + 1000 + randomint( 4000 );
            b_in_tactical_position = 1;
        }
        else if ( gettime() > self.next_near_player_check && sentinel_isnearanotherplayer( self.origin, 100 ) )
        {
            self.evading_player = 1;
            self.next_near_player_check = gettime() + 1000;
            self.nextjuketime = 0;
            self notify( #"near_goal" );
        }
        
        is_on_nav_volume = ispointinnavvolume( self.origin, "navvolume_small" );
        
        /#
            if ( getdvarint( "<dev string:x44>", 0 ) == 1 )
            {
                current_pathto_pos = undefined;
                is_on_nav_volume = 1;
            }
        #/
        
        if ( isdefined( current_pathto_pos ) )
        {
            if ( isdefined( is_on_nav_volume ) && isdefined( self.stucktime ) && is_on_nav_volume )
            {
                self.stucktime = undefined;
            }
            
            /#
                if ( getdvarint( "<dev string:x28>" ) > 0 )
                {
                    recordsphere( current_pathto_pos, 8, ( 0, 0, 1 ) );
                }
            #/
            
            /#
                if ( getdvarint( "<dev string:x5c>" ) > 0 )
                {
                    if ( !ispointinnavvolume( current_pathto_pos, "<dev string:x77>" ) )
                    {
                        recordline( current_pathto_pos, level.players[ 0 ].origin + ( 0, 0, 48 ), ( 1, 1, 1 ) );
                        recordsphere( current_pathto_pos, 10, ( 1, 1, 1 ) );
                        printtoprightln( "<dev string:x87>" + self getentitynumber(), ( 1, 1, 1 ) );
                    }
                    
                    if ( !( isdefined( is_on_nav_volume ) && is_on_nav_volume ) )
                    {
                        recordline( self.origin, level.players[ 0 ].origin + ( 0, 0, 48 ), ( 0, 1, 0 ) );
                        recordsphere( self.origin, 10, ( 0, 1, 0 ) );
                        printtoprightln( "<dev string:x98>" + self getentitynumber(), ( 0, 1, 0 ) );
                    }
                }
            #/
            
            if ( self setvehgoalpos( current_pathto_pos, 1, b_use_path_finding ) )
            {
                b_use_path_finding = 1;
                self.b_in_tactical_position = b_in_tactical_position;
                self thread sentinel_pathupdateinterrupt();
                self vehicle_ai::waittill_pathing_done( 5 );
                current_pathto_pos = undefined;
            }
            else if ( isdefined( is_on_nav_volume ) && is_on_nav_volume )
            {
                /#
                    if ( getdvarint( "<dev string:x5c>" ) > 0 )
                    {
                        printtoprightln( "<dev string:xa5>" + self getentitynumber(), ( 1, 0, 0 ) );
                        recordline( current_pathto_pos, level.players[ 0 ].origin + ( 0, 0, 48 ), ( 1, 0, 0 ) );
                        recordsphere( current_pathto_pos, 10, ( 1, 0, 0 ) );
                        recordline( self.origin, level.players[ 0 ].origin + ( 0, 0, 48 ), ( 1, 0.2, 0.2 ) );
                        recordsphere( self.origin, 10, ( 1, 0, 0 ) );
                    }
                #/
                
                self sentinel_killmyself();
                self.last_failsafe_time = undefined;
            }
        }
        
        if ( !( isdefined( is_on_nav_volume ) && is_on_nav_volume ) )
        {
            if ( !isdefined( self.last_failsafe_time ) )
            {
                self.last_failsafe_time = gettime();
            }
            
            if ( gettime() - self.last_failsafe_time >= 3000 )
            {
                self.last_failsafe_count = 0;
            }
            else
            {
                self.last_failsafe_count++;
            }
            
            self.last_failsafe_time = gettime();
            
            if ( self.last_failsafe_count > 25 )
            {
                new_sentinel_pos = self getclosestpointonnavvolume( self.origin, 120 );
                
                if ( isdefined( new_sentinel_pos ) )
                {
                    dvar_sentinel_getback_to_volume_epsilon = getdvarint( "dvar_sentinel_getback_to_volume_epsilon", 5 );
                    
                    if ( distance( self.origin, new_sentinel_pos ) < dvar_sentinel_getback_to_volume_epsilon )
                    {
                        self.origin = new_sentinel_pos;
                        
                        /#
                            if ( getdvarint( "<dev string:x28>" ) > 0 )
                            {
                                recordsphere( new_sentinel_pos, 8, ( 1, 0, 0 ) );
                            }
                        #/
                    }
                    else
                    {
                        self.vehaircraftcollisionenabled = 0;
                        
                        /#
                            if ( getdvarint( "<dev string:x28>" ) > 0 )
                            {
                                recordsphere( new_sentinel_pos, 8, ( 1, 0, 0 ) );
                            }
                        #/
                        
                        if ( self setvehgoalpos( new_sentinel_pos, 1, 0 ) )
                        {
                            self thread sentinel_pathupdateinterrupt();
                            self vehicle_ai::waittill_pathing_done( 5 );
                            current_pathto_pos = undefined;
                        }
                        
                        self.vehaircraftcollisionenabled = 1;
                    }
                }
                else if ( self.last_failsafe_count > 100 )
                {
                    self sentinel_killmyself();
                }
            }
        }
        
        if ( !( isdefined( is_on_nav_volume ) && is_on_nav_volume ) )
        {
            if ( !isdefined( self.stucktime ) )
            {
                self.stucktime = gettime();
            }
            
            if ( gettime() - self.stucktime > 15000 )
            {
                self sentinel_killmyself();
            }
        }
        
        wait 0.1;
    }
}

// Namespace sentinel_drone
// Params 1
// Checksum 0x56ef914c, Offset: 0x3638
// Size: 0xec6
function sentinel_getnextmovepositiontactical( b_do_not_chase_enemy )
{
    self endon( #"change_state" );
    self endon( #"death" );
    
    if ( isdefined( self.sentinel_droneenemy ) )
    {
        selfdisttotarget = distance2d( self.origin, self.sentinel_droneenemy.origin );
    }
    else
    {
        selfdisttotarget = 0;
    }
    
    gooddist = 0.5 * ( sentinel_getengagementdistmin() + sentinel_getengagementdistmax() );
    closedist = 1.2 * gooddist;
    fardist = 3 * gooddist;
    querymultiplier = mapfloat( closedist, fardist, 1, 3, selfdisttotarget );
    preferedheightrange = 0.5 * ( sentinel_getengagementheightmax() + sentinel_getengagementheightmin() );
    randomness = 20;
    sentinel_drone_too_close_to_self_dist_ex = getdvarint( "SENTINEL_DRONE_TOO_CLOSE_TO_SELF_DIST_EX", 70 );
    sentinel_drone_move_dist_max_ex = getdvarint( "SENTINEL_DRONE_MOVE_DIST_MAX_EX", 600 );
    sentinel_drone_move_spacing = getdvarint( "SENTINEL_DRONE_MOVE_SPACING", 25 );
    sentinel_drone_radius_ex = getdvarint( "SENTINEL_DRONE_RADIUS_EX", 35 );
    sentinel_drone_hight_ex = getdvarint( "SENTINEL_DRONE_HIGHT_EX", int( preferedheightrange ) );
    spacing_multiplier = 1.5;
    query_min_dist = self.settings.engagementdistmin;
    query_max_dist = sentinel_drone_move_dist_max_ex;
    
    if ( !( isdefined( b_do_not_chase_enemy ) && b_do_not_chase_enemy ) && isdefined( self.sentinel_droneenemy ) && gettime() > self.targetplayertime )
    {
        charge_at_position = self.sentinel_droneenemy.origin + ( 0, 0, 48 );
        
        if ( !ispointinnavvolume( charge_at_position, "navvolume_small" ) )
        {
            closest_point_on_nav_volume = getdvarint( "closest_point_on_nav_volume", 120 );
            charge_at_position = self getclosestpointonnavvolume( charge_at_position, closest_point_on_nav_volume );
        }
        
        if ( !isdefined( charge_at_position ) )
        {
            queryresult = positionquery_source_navigation( self.origin, sentinel_drone_too_close_to_self_dist_ex, sentinel_drone_move_dist_max_ex * querymultiplier, sentinel_drone_hight_ex * querymultiplier, sentinel_drone_move_spacing, "navvolume_small", sentinel_drone_move_spacing * spacing_multiplier );
        }
        else
        {
            if ( sentinel_isenemyinnarrowplace() )
            {
                spacing_multiplier = 1;
                sentinel_drone_move_spacing = 15;
                query_min_dist = self.settings.engagementdistmin * getdvarfloat( "sentinel_query_min_dist", 0.2 );
                query_max_dist *= 0.5;
            }
            else if ( isdefined( self.in_compact_mode ) && self.in_compact_mode || sentinel_isenemyindoors() )
            {
                spacing_multiplier = 1;
                sentinel_drone_move_spacing = 15;
                query_min_dist = self.settings.engagementdistmin * getdvarfloat( "sentinel_query_min_dist", 0.5 );
            }
            
            queryresult = positionquery_source_navigation( charge_at_position, query_min_dist, query_max_dist * querymultiplier, sentinel_drone_hight_ex * querymultiplier, sentinel_drone_move_spacing, "navvolume_small", sentinel_drone_move_spacing * spacing_multiplier );
        }
    }
    else
    {
        queryresult = positionquery_source_navigation( self.origin, sentinel_drone_too_close_to_self_dist_ex, sentinel_drone_move_dist_max_ex * querymultiplier, sentinel_drone_hight_ex * querymultiplier, sentinel_drone_move_spacing, "navvolume_small", sentinel_drone_move_spacing * spacing_multiplier );
    }
    
    positionquery_filter_distancetogoal( queryresult, self );
    vehicle_ai::positionquery_filter_outofgoalanchor( queryresult );
    
    if ( isdefined( self.sentinel_droneenemy ) )
    {
        if ( randomint( 100 ) > 15 )
        {
            self vehicle_ai::positionquery_filter_engagementdist( queryresult, self.sentinel_droneenemy, sentinel_getengagementdistmin(), sentinel_getengagementdistmax() );
        }
        
        goalheight = self.sentinel_droneenemy.origin[ 2 ] + 0.5 * ( sentinel_getengagementheightmin() + sentinel_getengagementheightmax() );
        enemy_origin = self.sentinel_droneenemy.origin + ( 0, 0, 48 );
    }
    else
    {
        goalheight = self.origin[ 2 ] + 0.5 * ( sentinel_getengagementheightmin() + sentinel_getengagementheightmax() );
        enemy_origin = self.origin;
    }
    
    best_point = undefined;
    best_score = undefined;
    trace_count = 0;
    
    foreach ( point in queryresult.data )
    {
        if ( sentinel_isinsideengagementdistance( enemy_origin, point.origin ) )
        {
            /#
                if ( !isdefined( point._scoredebug ) )
                {
                    point._scoredebug = [];
                }
                
                point._scoredebug[ "<dev string:xbe>" ] = 25;
            #/
            
            point.score += 25;
        }
        
        /#
            if ( !isdefined( point._scoredebug ) )
            {
                point._scoredebug = [];
            }
            
            point._scoredebug[ "<dev string:xd7>" ] = randomfloatrange( 0, randomness );
        #/
        
        point.score += randomfloatrange( 0, randomness );
        
        if ( isdefined( point.distawayfromengagementarea ) )
        {
            /#
                if ( !isdefined( point._scoredebug ) )
                {
                    point._scoredebug = [];
                }
                
                point._scoredebug[ "<dev string:xde>" ] = point.distawayfromengagementarea * -1;
            #/
            
            point.score += point.distawayfromengagementarea * -1;
        }
        
        is_near_another_sentinel = sentinel_isnearanothersentinel( point.origin, 200 );
        
        if ( isdefined( is_near_another_sentinel ) && is_near_another_sentinel )
        {
            /#
                if ( !isdefined( point._scoredebug ) )
                {
                    point._scoredebug = [];
                }
                
                point._scoredebug[ "<dev string:xed>" ] = -200;
            #/
            
            point.score += -200;
        }
        
        is_overlap_another_sentinel = sentinel_isnearanothersentinel( point.origin, 100 );
        
        if ( isdefined( is_overlap_another_sentinel ) && is_overlap_another_sentinel )
        {
            /#
                if ( !isdefined( point._scoredebug ) )
                {
                    point._scoredebug = [];
                }
                
                point._scoredebug[ "<dev string:x101>" ] = -2000;
            #/
            
            point.score += -2000;
        }
        
        is_near_another_player = sentinel_isnearanotherplayer( point.origin, 150 );
        
        if ( isdefined( is_near_another_player ) && is_near_another_player )
        {
            /#
                if ( !isdefined( point._scoredebug ) )
                {
                    point._scoredebug = [];
                }
                
                point._scoredebug[ "<dev string:x118>" ] = -200;
            #/
            
            point.score += -200;
        }
        
        distfrompreferredheight = abs( point.origin[ 2 ] - goalheight );
        
        if ( distfrompreferredheight > preferedheightrange )
        {
            heightscore = ( distfrompreferredheight - preferedheightrange ) * 3;
            
            /#
                if ( !isdefined( point._scoredebug ) )
                {
                    point._scoredebug = [];
                }
                
                point._scoredebug[ "<dev string:x12a>" ] = heightscore * -1;
            #/
            
            point.score += heightscore * -1;
        }
        
        if ( !isdefined( best_score ) )
        {
            best_score = point.score;
            best_point = point;
            
            if ( isdefined( self.sentinel_droneenemy ) )
            {
                best_point.visibile = int( bullettracepassed( point.origin, enemy_origin, 0, self, self.sentinel_droneenemy ) );
            }
            else
            {
                best_point.visibile = int( bullettracepassed( point.origin, enemy_origin, 0, self ) );
            }
            
            continue;
        }
        
        if ( point.score > best_score )
        {
            if ( isdefined( self.sentinel_droneenemy ) )
            {
                point.visibile = int( bullettracepassed( point.origin, enemy_origin, 0, self, self.sentinel_droneenemy ) );
            }
            else
            {
                point.visibile = int( bullettracepassed( point.origin, enemy_origin, 0, self ) );
            }
            
            if ( point.visibile >= best_point.visibile )
            {
                best_score = point.score;
                best_point = point;
            }
        }
    }
    
    if ( isdefined( best_point ) )
    {
        if ( best_point.score < -1000 )
        {
            best_point = undefined;
        }
    }
    
    self vehicle_ai::positionquery_debugscores( queryresult );
    
    /#
        if ( isdefined( getdvarint( "<dev string:x131>" ) ) && getdvarint( "<dev string:x131>" ) )
        {
            if ( isdefined( best_point ) )
            {
                recordline( self.origin, best_point.origin, ( 0.3, 1, 0 ) );
            }
            
            if ( isdefined( self.sentinel_droneenemy ) )
            {
                recordline( self.origin, self.sentinel_droneenemy.origin, ( 1, 0, 0.4 ) );
            }
        }
    #/
    
    returndata = [];
    returndata[ "origin" ] = isdefined( best_point ) ? best_point.origin : undefined;
    returndata[ "centerOnNav" ] = queryresult.centeronnav;
    return returndata;
}

// Namespace sentinel_drone
// Params 3
// Checksum 0x5b85a0a6, Offset: 0x4508
// Size: 0x38c
function sentinel_chargeatplayernavigation( b_charge_at_player, time_out, charge_at_position )
{
    self endon( #"change_state" );
    self endon( #"death" );
    
    if ( isdefined( time_out ) )
    {
        max_charge_time = gettime() + time_out;
    }
    
    if ( !isdefined( charge_at_position ) )
    {
        if ( isdefined( b_charge_at_player ) && b_charge_at_player )
        {
            charge_at_position = self.sentinel_droneenemy.origin + ( 0, 0, 48 );
        }
        else
        {
            sentinel_dir = anglestoforward( self.angles );
            charge_at_position = self.origin + sentinel_dir * length( self.sentinel_droneenemy.origin - self.origin );
            charge_at_position = ( charge_at_position[ 0 ], charge_at_position[ 1 ], self.sentinel_droneenemy.origin[ 2 ] );
        }
    }
    
    charge_at_dir = vectornormalize( charge_at_position - self.origin );
    charge_at_position = self.origin + charge_at_dir * 1200;
    self clearlookatent();
    self setvehgoalpos( charge_at_position, 1, 0 );
    self setlookatorigin( charge_at_position );
    
    while ( true )
    {
        velocity = self getvelocity() * 0.1;
        velocitymag = length( velocity );
        
        if ( velocitymag < 1 )
        {
            velocitymag = 1;
        }
        
        predicted_pos = self.origin + velocity;
        offset = vectornormalize( predicted_pos - self.origin ) * 35;
        trace = sentinel_trace( self.origin + offset, predicted_pos + offset, self, 1 );
        
        if ( trace[ "fraction" ] < 1 )
        {
            if ( !( isdefined( trace[ "entity" ] ) && trace[ "entity" ].archetype === "zombie" && isdefined( trace[ "entity" ].health ) && trace[ "entity" ].health == 0 ) )
            {
                sentinel_killmyself();
                return;
            }
        }
        
        if ( isdefined( max_charge_time ) && gettime() > max_charge_time )
        {
            sentinel_killmyself();
            return;
        }
        
        wait 0.1;
    }
}

// Namespace sentinel_drone
// Params 0
// Checksum 0x7326817c, Offset: 0x48a0
// Size: 0x138
function sentinel_pathupdateinterrupt()
{
    self endon( #"death" );
    self endon( #"change_state" );
    self endon( #"near_goal" );
    self endon( #"reached_end_node" );
    self notify( #"sentinel_pathupdateinterrupt" );
    self endon( #"sentinel_pathupdateinterrupt" );
    skip_sentinel_pathupdateinterrupt = getdvarint( "skip_sentinel_PathUpdateInterrupt", 1 );
    
    if ( skip_sentinel_pathupdateinterrupt == 1 )
    {
        return;
    }
    
    wait 1;
    
    while ( true )
    {
        if ( isdefined( self.current_pathto_pos ) )
        {
            if ( distance2dsquared( self.origin, self.goalpos ) < self.goalradius * self.goalradius )
            {
                /#
                    if ( getdvarint( "<dev string:x28>" ) > 0 )
                    {
                        recordsphere( self.origin, 30, ( 1, 0, 0 ) );
                    }
                #/
                
                wait 0.2;
                self notify( #"near_goal" );
            }
        }
        
        wait 0.2;
    }
}

// Namespace sentinel_drone
// Params 0
// Checksum 0x1297d62b, Offset: 0x49e0
// Size: 0x74
function sentine_rumblewhennearplayer()
{
    self endon( #"death" );
    self endon( #"change_state" );
    
    while ( true )
    {
        while ( sentinel_isnearanotherplayer( self.origin, 120 ) )
        {
            self playrumbleonentity( "damage_heavy" );
            wait 0.1;
        }
        
        wait 0.5;
    }
}

// Namespace sentinel_drone
// Params 2
// Checksum 0xff90b386, Offset: 0x4a60
// Size: 0x452
function sentinel_canseeenemy( sentinel_origin, prev_enemy_position )
{
    result = spawnstruct();
    result.can_see_enemy = 0;
    enemy_moved = 0;
    b_still_enemy_in_pos_check = 0;
    origin_point = sentinel_origin;
    
    if ( !isdefined( prev_enemy_position ) )
    {
        target_point = self.sentinel_droneenemy.origin + ( 0, 0, 48 );
        
        if ( isplayer( self.sentinel_droneenemy ) )
        {
            enemy_stance = self.sentinel_droneenemy getstance();
            
            if ( enemy_stance == "prone" )
            {
                target_point = self.sentinel_droneenemy.origin + ( 0, 0, 2 );
            }
        }
    }
    else
    {
        b_still_enemy_in_pos_check = 1;
        target_point = prev_enemy_position;
    }
    
    forward_vect = anglestoforward( self.angles );
    vect_to_enemy = target_point - origin_point;
    
    if ( vectordot( forward_vect, vect_to_enemy ) <= 0 )
    {
        if ( !b_still_enemy_in_pos_check )
        {
            return result;
        }
        else
        {
            enemy_moved = 1;
        }
    }
    
    if ( !( isdefined( enemy_moved ) && enemy_moved ) )
    {
        right_vect = anglestoright( self.angles );
        vect_to_enemy_2d = ( vect_to_enemy[ 0 ], vect_to_enemy[ 1 ], 0 );
        projected_distance = vectordot( vect_to_enemy_2d, right_vect );
        
        if ( abs( projected_distance ) > 50 )
        {
            if ( !b_still_enemy_in_pos_check )
            {
                return result;
            }
            else
            {
                enemy_moved = 1;
            }
        }
    }
    
    if ( b_still_enemy_in_pos_check )
    {
        beam_to_enemy_length = distance( target_point, origin_point );
        beam_to_enemy_dir = target_point - origin_point;
        beam_to_enemy_dir = vectornormalize( beam_to_enemy_dir );
        target_point = origin_point + vectorscale( beam_to_enemy_dir, 1200 );
    }
    
    trace = sentinel_trace( origin_point, target_point, self.sentinel_droneenemy, 0 );
    
    /#
        if ( getdvarint( "<dev string:x28>" ) > 0 )
        {
            recordline( origin_point, target_point, ( 0, 1, 0 ) );
            recordsphere( target_point, 8 );
        }
    #/
    
    result.hit_entity = trace[ "entity" ];
    result.hit_position = trace[ "position" ];
    
    if ( isdefined( self.should_buff_zombies ) && self.should_buff_zombies && isdefined( trace[ "entity" ] ) && isdefined( trace[ "entity" ].archetype ) && ( isplayer( trace[ "entity" ] ) || trace[ "entity" ].archetype == "zombie" ) )
    {
        result.can_see_enemy = 1;
        return result;
    }
    
    return result;
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xad1c204, Offset: 0x4ec0
// Size: 0x65c, Type: bool
function sentinel_firelogic()
{
    if ( isdefined( self.playing_intro_anim ) && self.playing_intro_anim )
    {
        return false;
    }
    
    if ( self.arms_count <= 0 )
    {
        return false;
    }
    
    if ( !( isdefined( self.target_initialized ) && self.target_initialized ) )
    {
        wait 0.5;
        return false;
    }
    
    if ( !isdefined( self.nextfiretime ) || isdefined( self.sentinel_droneenemy ) && gettime() > self.nextfiretime )
    {
        if ( sentinel_isinsideengagementdistance( self.origin, self.sentinel_droneenemy.origin + ( 0, 0, 48 ), 1 ) && ( isdefined( self.in_compact_mode ) && self.in_compact_mode || isdefined( self.b_in_tactical_position ) && self.b_in_tactical_position && sentinel_isenemyindoors() || ispointinnavvolume( self.origin, "navvolume_small" ) ) && !sentinel_isnearanothersentinel( self.origin, 100 ) )
        {
            result = sentinel_canseeenemy( self.origin );
            
            if ( result.can_see_enemy )
            {
                self.nextfiretime = gettime() + 2500 + randomint( 2500 );
                sentinel_navigationstandstill();
                wait 0.1;
                
                if ( !isdefined( self.sentinel_droneenemy ) )
                {
                    return true;
                }
                
                enemy_pos = self.sentinel_droneenemy.origin;
                
                if ( randomint( 100 ) < 70 )
                {
                    b_succession = 1;
                }
                
                self.beam_start_position = self.origin;
                
                if ( isdefined( b_succession ) && b_succession )
                {
                    fire_state_name = "fire_succession@attack";
                }
                else
                {
                    fire_state_name = "fire@attack";
                }
                
                self asmrequestsubstate( fire_state_name );
                self clientfield::set( "sentinel_drone_beam_charge", 1 );
                beam_dir = result.hit_position - self.origin;
                self.beam_fire_target.origin = result.hit_position;
                self.beam_fire_target.angles = vectortoangles( beam_dir * -1 );
                
                /#
                    if ( getdvarint( "<dev string:x28>" ) > 0 )
                    {
                        recordline( self.origin, result.hit_position, ( 0.9, 0.7, 0.6 ) );
                        recordsphere( result.hit_position, 8, ( 0.9, 0.7, 0.6 ) );
                    }
                #/
                
                self clearlookatent();
                self.angles = vectortoangles( beam_dir );
                self setlookatent( self.beam_fire_target );
                self setturrettargetent( self.beam_fire_target );
                self waittill( #"fire_beam" );
                self clientfield::set( "sentinel_drone_beam_charge", 0 );
                result = sentinel_canseeenemy( self.beam_start_position, result.hit_position );
                
                if ( result.can_see_enemy )
                {
                    if ( !( isdefined( b_succession ) && b_succession ) && isplayer( result.hit_entity ) )
                    {
                        result.hit_entity thread sentinel_damageplayer( int( 50 ), self );
                    }
                    
                    sentinel_firebeam( result.hit_position, b_succession );
                }
                else
                {
                    sentinel_firebeam( result.hit_position, b_succession );
                }
                
                self vehicle_ai::waittill_asm_complete( fire_state_name, 5 );
                
                if ( isdefined( self.sentinel_droneenemy ) )
                {
                    self setlookatent( self.sentinel_droneenemy );
                    self setturrettargetent( self.sentinel_droneenemy );
                }
                
                self asmrequestsubstate( "locomotion@movement" );
                
                if ( randomint( 100 ) < 40 )
                {
                    sentinel_changesentinelposition();
                }
                
                if ( randomint( 100 ) < 30 )
                {
                    self.nextfiretime = gettime() + 2500 + randomint( 2500 );
                }
                
                return true;
            }
        }
    }
    
    return false;
}

// Namespace sentinel_drone
// Params 2
// Checksum 0x946739c5, Offset: 0x5528
// Size: 0x148
function sentinel_firebeam( target_position, b_succession )
{
    self endon( #"change_state" );
    self endon( #"disconnect" );
    self endon( #"death" );
    self endon( #"death_state_activated" );
    self.lasttimefired = gettime();
    beam_dir = target_position - self.origin;
    self.beam_fire_target.origin = target_position;
    self.beam_fire_target.angles = vectortoangles( beam_dir * -1 );
    self.angles = vectortoangles( beam_dir );
    self setturrettargetent( self.beam_fire_target );
    self.is_firing_beam = 1;
    
    if ( !( isdefined( b_succession ) && b_succession ) )
    {
        sentinel_firebeamburst( target_position );
    }
    else
    {
        sentinel_firebeamsuccession( target_position );
    }
    
    self.is_firing_beam = 0;
}

// Namespace sentinel_drone
// Params 1
// Checksum 0x3b737772, Offset: 0x5678
// Size: 0x1ae
function sentinel_firebeamburst( target_position )
{
    self endon( #"change_state" );
    self endon( #"disconnect" );
    self endon( #"death" );
    self endon( #"death_state_activated" );
    
    for ( i = 1; i <= 3 ; i++ )
    {
        if ( self.sentineldronehealtharms[ i ] <= 0 )
        {
            continue;
        }
        
        self clientfield::set( "sentinel_drone_beam_fire" + i, 1 );
    }
    
    wait 0.1;
    start_beam_time = gettime() + 2000;
    beam_damage_update = 0.1;
    player_damage = int( 100 * beam_damage_update );
    
    while ( isdefined( self.sentinel_debugfx_playall ) && ( gettime() < start_beam_time || self.sentinel_debugfx_playall ) )
    {
        sentinel_damagebeamtouchingentity( player_damage, target_position );
        wait beam_damage_update;
    }
    
    for ( i = 1; i <= 3 ; i++ )
    {
        if ( self.sentineldronehealtharms[ i ] <= 0 )
        {
            continue;
        }
        
        self clientfield::set( "sentinel_drone_beam_fire" + i, 0 );
    }
}

// Namespace sentinel_drone
// Params 1
// Checksum 0x3e5ac691, Offset: 0x5830
// Size: 0x1f6
function sentinel_firebeamsuccession( target_position )
{
    self endon( #"change_state" );
    self endon( #"disconnect" );
    self endon( #"death" );
    self endon( #"death_state_activated" );
    player_damage = int( 30 );
    arms_order = [];
    arms_order[ 0 ] = 2;
    arms_order[ 1 ] = 1;
    arms_order[ 2 ] = 3;
    arms_notifies = [];
    arms_notifies[ 0 ] = "attack_quick_left";
    arms_notifies[ 1 ] = "attack_quick_right";
    arms_notifies[ 2 ] = "attack_quick_top";
    
    for ( i = 0; i < 3 ; i++ )
    {
        if ( self.sentineldronehealtharms[ arms_order[ i ] ] <= 0 )
        {
            continue;
        }
        
        self util::waittill_any_timeout( 0.3, arms_notifies[ i ], "change_state", "disconnect", "death", "death_state_activated" );
        self clientfield::set( "sentinel_drone_beam_fire" + arms_order[ i ], 1 );
        sentinel_damagebeamtouchingentity( player_damage, target_position, 1 );
        wait 0.1;
        self clientfield::set( "sentinel_drone_beam_fire" + arms_order[ i ], 0 );
    }
}

// Namespace sentinel_drone
// Params 3
// Checksum 0xeab9363e, Offset: 0x5a30
// Size: 0x11c
function sentinel_damagebeamtouchingentity( player_damage, target_position, b_succession )
{
    if ( !isdefined( b_succession ) )
    {
        b_succession = 0;
    }
    
    trace = sentinel_trace( self.origin, target_position, self.sentinel_droneenemy, 0 );
    trace_entity = trace[ "entity" ];
    
    if ( isplayer( trace_entity ) )
    {
        trace_entity thread sentinel_damageplayer( player_damage, self, b_succession );
        return;
    }
    
    if ( isdefined( trace_entity ) && isdefined( trace_entity.archetype ) && trace_entity.archetype == "zombie" )
    {
        self thread sentinel_electrifyzombie( trace_entity.origin, trace_entity, 80 );
    }
}

// Namespace sentinel_drone
// Params 1
// Checksum 0x9ce6490c, Offset: 0x5b58
// Size: 0x54
function sentinel_selfdestruct( time )
{
    self endon( #"change_state" );
    self endon( #"disconnect" );
    self endon( #"death" );
    self endon( #"death_state_activated" );
    wait time;
    sentinel_killmyself();
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xfde1ea61, Offset: 0x5bb8
// Size: 0x1f8
function sentinel_chargeatplayer()
{
    if ( !isdefined( self ) )
    {
        return;
    }
    
    self endon( #"change_state" );
    self endon( #"disconnect" );
    self endon( #"death" );
    self endon( #"death_state_activated" );
    charge_at_position = self.sentinel_droneenemy.origin + ( 0, 0, 48 );
    wait 0.3;
    self.is_charging_at_player = 1;
    self sentinel_navigationstandstill();
    sentinel_play_taunt( level._sentinel_system_critical_taunts );
    self asmrequestsubstate( "suicide_intro@death" );
    wait 2;
    
    if ( self.sentineldronehealthcamera <= 0 )
    {
        b_charge_at_player = 0;
    }
    else
    {
        charge_at_position = undefined;
        b_charge_at_player = 1;
    }
    
    self asmrequestsubstate( "suicide_charge@death" );
    self setspeed( 60 );
    self thread sentinel_chargeatplayernavigation( b_charge_at_player, 4000, charge_at_position );
    detonation_distance_sq = 10000;
    
    while ( isdefined( self ) && isdefined( self.sentinel_droneenemy ) )
    {
        distance_sq = distancesquared( self.sentinel_droneenemy.origin + ( 0, 0, 48 ), self.origin );
        
        if ( distance_sq <= detonation_distance_sq )
        {
            sentinel_killmyself();
        }
        
        wait 0.2;
    }
}

// Namespace sentinel_drone
// Params 1
// Checksum 0xb0505b17, Offset: 0x5db8
// Size: 0x32
function isleftarm( part_name )
{
    if ( !isdefined( part_name ) )
    {
        return 0;
    }
    
    return issubstr( part_name, "tag_arm_left" );
}

// Namespace sentinel_drone
// Params 1
// Checksum 0x140e0003, Offset: 0x5df8
// Size: 0x32
function isrightarm( part_name )
{
    if ( !isdefined( part_name ) )
    {
        return 0;
    }
    
    return issubstr( part_name, "tag_arm_right" );
}

// Namespace sentinel_drone
// Params 1
// Checksum 0xd6a530c5, Offset: 0x5e38
// Size: 0x32
function istoparm( part_name )
{
    if ( !isdefined( part_name ) )
    {
        return 0;
    }
    
    return issubstr( part_name, "tag_arm_top" );
}

// Namespace sentinel_drone
// Params 1
// Checksum 0x6407b716, Offset: 0x5e78
// Size: 0x64, Type: bool
function iscore( part_name )
{
    if ( !isdefined( part_name ) )
    {
        return false;
    }
    
    if ( part_name == "tag_faceplate_d0" || part_name == "ag_core_d0" || part_name == "tag_center_core" || part_name == "tag_core_spin" )
    {
        return true;
    }
    
    return false;
}

// Namespace sentinel_drone
// Params 1
// Checksum 0xa52dca07, Offset: 0x5ee8
// Size: 0x64, Type: bool
function iscamera( part_name )
{
    if ( !isdefined( part_name ) )
    {
        return false;
    }
    
    if ( part_name == "tag_camera_dead" || part_name == "tag_flash" || part_name == "tag_laser" || part_name == "tag_turret" )
    {
        return true;
    }
    
    return false;
}

// Namespace sentinel_drone
// Params 1
// Checksum 0x66814a8, Offset: 0x5f58
// Size: 0x7e
function sentinel_getarmnumber( part_name )
{
    if ( !isdefined( part_name ) )
    {
        return 0;
    }
    
    if ( isleftarm( part_name ) )
    {
        return 2;
    }
    else if ( isrightarm( part_name ) )
    {
        return 1;
    }
    else if ( istoparm( part_name ) )
    {
        return 3;
    }
    
    return 0;
}

// Namespace sentinel_drone
// Params 3, eflags: 0x4
// Checksum 0xfed62155, Offset: 0x5fe0
// Size: 0x2d6
function private sentinel_armdamage( damage, arm, eattacker )
{
    if ( !isdefined( eattacker ) )
    {
        eattacker = undefined;
    }
    
    if ( self.arms_count == 0 )
    {
        return;
    }
    
    if ( arm == 0 || damage == 0 )
    {
        return;
    }
    
    if ( self.sentineldronehealtharms[ arm ] <= 0 )
    {
        return;
    }
    
    self.sentineldronehealtharms[ arm ] -= damage;
    
    if ( self.sentineldronehealtharms[ arm ] <= 0 )
    {
        self.arms_count--;
        
        if ( isplayer( eattacker ) )
        {
            if ( !isdefined( self.e_arms_attacker ) && self.arms_count == 2 )
            {
                self.e_arms_attacker = eattacker;
                self.b_same_arms_attacker = 1;
            }
            else if ( self.e_arms_attacker !== eattacker )
            {
                self.b_same_arms_attacker = 0;
            }
        }
        
        self clientfield::set( "sentinel_drone_arm_cut_" + arm, 1 );
        
        if ( arm == 2 )
        {
            self hidepart( "tag_arm_left_01", "", 1 );
            self showpart( "tag_arm_left_01_d1", "", 1 );
        }
        else if ( arm == 1 )
        {
            self hidepart( "tag_arm_right_01", "", 1 );
            self showpart( "tag_arm_right_01_d1", "", 1 );
        }
        else if ( arm == 3 )
        {
            self hidepart( "tag_arm_top_01", "", 1 );
            self showpart( "tag_arm_top_01_d1", "", 1 );
        }
        
        if ( self.arms_count == 0 && !( isdefined( self.disable_charge_when_no_arms ) && self.disable_charge_when_no_arms ) )
        {
            sentinel_onallarmsdestroyed();
            
            if ( isplayer( eattacker ) )
            {
                level notify( #"all_sentinel_arms_destroyed", self.b_same_arms_attacker, eattacker );
            }
        }
    }
}

// Namespace sentinel_drone
// Params 1
// Checksum 0x7734b00b, Offset: 0x62c0
// Size: 0x9c
function sentinel_destroyallarms( b_disable_charge )
{
    self.disable_charge_when_no_arms = isdefined( b_disable_charge ) && b_disable_charge;
    sentinel_armdamage( self.sentineldronehealtharms[ 2 ] + 1000, 2 );
    sentinel_armdamage( self.sentineldronehealtharms[ 1 ] + 1000, 1 );
    sentinel_armdamage( self.sentineldronehealtharms[ 3 ] + 1000, 3 );
}

// Namespace sentinel_drone
// Params 0, eflags: 0x4
// Checksum 0x8416bfd3, Offset: 0x6368
// Size: 0x44
function private sentinel_onallarmsdestroyed()
{
    sentinel_destroyface();
    sentinel_destroycore();
    wait 0.1;
    self thread sentinel_chargeatplayer();
}

// Namespace sentinel_drone
// Params 0, eflags: 0x4
// Checksum 0x2d8066d6, Offset: 0x63b8
// Size: 0x2c
function private sentinel_destroyface()
{
    sentinel_facedamage( self.sentineldronehealthface + 1000, "tag_faceplate_d0" );
}

// Namespace sentinel_drone
// Params 0, eflags: 0x4
// Checksum 0xf99c708b, Offset: 0x63f0
// Size: 0x2c
function private sentinel_destroycore()
{
    sentinel_coredamage( self.sentineldronehealthcore + 1000, "ag_core_d0" );
}

// Namespace sentinel_drone
// Params 2, eflags: 0x4
// Checksum 0x940facbc, Offset: 0x6428
// Size: 0xbc
function private sentinel_facedamage( damage, partname )
{
    if ( damage == 0 )
    {
        return;
    }
    
    if ( self.sentineldronehealthface <= 0 )
    {
        return;
    }
    
    if ( !isdefined( partname ) || partname != "tag_faceplate_d0" )
    {
        return;
    }
    
    self.sentineldronehealthface -= damage;
    
    if ( self.sentineldronehealthface <= 0 )
    {
        self clientfield::set( "sentinel_drone_face_cut", 1 );
        self hidepart( "tag_faceplate_d0", "", 1 );
    }
}

// Namespace sentinel_drone
// Params 2, eflags: 0x4
// Checksum 0xb683a576, Offset: 0x64f0
// Size: 0xd4
function private sentinel_coredamage( damage, partname )
{
    if ( damage == 0 )
    {
        return;
    }
    
    if ( self.sentineldronehealthface > 0 )
    {
        return;
    }
    
    if ( self.sentineldronehealthcore <= 0 )
    {
        return;
    }
    
    if ( !iscore( partname ) )
    {
        return;
    }
    
    self.sentineldronehealthcore -= damage;
    
    if ( self.sentineldronehealthcore <= 0 )
    {
        self hidepart( "tag_center_core_emmisive_blue", "", 1 );
        self showpart( "tag_center_core_emmisive_red", "", 1 );
    }
}

// Namespace sentinel_drone
// Params 3, eflags: 0x4
// Checksum 0xd48a01ef, Offset: 0x65d0
// Size: 0x166
function private sentinel_cameradamage( damage, partname, eattacker )
{
    if ( damage == 0 )
    {
        return;
    }
    
    if ( self.sentineldronehealthcamera <= 0 )
    {
        return;
    }
    
    if ( !iscamera( partname ) )
    {
        return;
    }
    
    self.sentineldronehealthcamera -= damage;
    
    if ( self.sentineldronehealthcamera <= 0 )
    {
        self hidepart( "tag_turret", "", 1 );
        self showpart( "Tag_camera_dead", "", 1 );
        self clientfield::set( "sentinel_drone_camera_destroyed", 1 );
        sentinel_destroyface();
        sentinel_destroycore();
        self thread sentinel_selfdestruct( 2000 );
        self thread sentinel_chargeatplayer();
        
        if ( isplayer( eattacker ) )
        {
            level notify( #"sentinel_camera_destroyed", eattacker );
        }
    }
}

// Namespace sentinel_drone
// Params 15
// Checksum 0xa7b657ba, Offset: 0x6740
// Size: 0x268
function sentinel_callbackdamage( einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal )
{
    if ( isdefined( eattacker ) && eattacker.archetype === "sentinel_drone" )
    {
        return 0;
    }
    
    if ( isdefined( einflictor ) && einflictor.archetype === "sentinel_drone" )
    {
        return 0;
    }
    
    if ( isdefined( level.zombie_vars[ eattacker.team ][ "zombie_insta_kill" ] ) && isdefined( eattacker ) && isdefined( eattacker.team ) && isdefined( level.zombie_vars ) && isdefined( level.zombie_vars[ eattacker.team ] ) && level.zombie_vars[ eattacker.team ][ "zombie_insta_kill" ] )
    {
        idamage *= 4;
    }
    
    if ( self.sentineldronehealthface <= 0 && iscore( partname ) )
    {
        idamage *= 2;
    }
    
    if ( gettime() > self.nextrolltime )
    {
        if ( math::cointoss() )
        {
            self.shouldroll = 1;
        }
        else
        {
            self.nextrolltime = gettime() + randomint( 3000 );
        }
    }
    
    thread sentinel_armdamage( idamage, sentinel_getarmnumber( partname ), eattacker );
    thread sentinel_facedamage( idamage, partname );
    thread sentinel_cameradamage( idamage, partname, eattacker );
    return idamage;
}

// Namespace sentinel_drone
// Params 13
// Checksum 0x8c24240d, Offset: 0x69b0
// Size: 0x118
function sentinel_drone_callbackradiusdamage( einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, psoffsettime )
{
    if ( isdefined( eattacker ) && eattacker.archetype === "sentinel_drone" )
    {
        return 0;
    }
    
    if ( isdefined( einflictor ) && einflictor.archetype === "sentinel_drone" )
    {
        return 0;
    }
    
    if ( gettime() > self.nextrolltime )
    {
        if ( math::cointoss() )
        {
            self.shouldroll = 1;
        }
        else
        {
            self.nextrolltime = gettime() + 3000 + randomint( 4000 );
        }
    }
    
    return idamage;
}

// Namespace sentinel_drone
// Params 1
// Checksum 0xf81f82a0, Offset: 0x6ad0
// Size: 0x20c
function state_death_update( params )
{
    self endon( #"death" );
    self sentinel_removefromlevelarray();
    self sentinel_deactivatealleffects();
    self asmrequestsubstate( "normal@death" );
    set_sentinel_drone_enemy( undefined );
    self thread vehicle_death::death_fx();
    self.beam_fire_target thread sentinel_deletedronedeathfx( self.origin );
    min_distance = 110;
    players = getplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        if ( !is_target_valid( players[ i ] ) )
        {
            continue;
        }
        
        min_distance_sq = min_distance * min_distance;
        distance_sq = distancesquared( self.origin, players[ i ].origin + ( 0, 0, 48 ) );
        
        if ( distance_sq < min_distance_sq )
        {
            players[ i ] sentinel_damageplayer( 60, self );
        }
    }
    
    self sentinel_electrifyzombie( self.origin, undefined, 100 );
    wait 0.1;
    self delete();
}

// Namespace sentinel_drone
// Params 1
// Checksum 0xf14dfce6, Offset: 0x6ce8
// Size: 0x74
function sentinel_deletedronedeathfx( explosion_origin )
{
    self endon( #"disconnect" );
    self endon( #"death" );
    self.origin = explosion_origin;
    wait 0.1;
    self clientfield::set( "sentinel_drone_deathfx", 1 );
    wait 6;
    self delete();
}

// Namespace sentinel_drone
// Params 2
// Checksum 0xde1fad8d, Offset: 0x6d68
// Size: 0x4e
function sentinel_forcegoandstayinposition( b_enable, position )
{
    if ( isdefined( b_enable ) && b_enable )
    {
        self.forced_pos = position;
        return;
    }
    
    self.shouldroll = 0;
    self.forced_pos = undefined;
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xc6781416, Offset: 0x6dc0
// Size: 0x6e, Type: bool
function sentinel_isenemyindoors()
{
    if ( !isdefined( self.v_compact_mode ) )
    {
        v_compact_mode = getent( "sentinel_compact", "targetname" );
    }
    
    if ( isdefined( v_compact_mode ) )
    {
        if ( self.sentinel_droneenemy istouching( v_compact_mode ) )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xec305b13, Offset: 0x6e38
// Size: 0x8e, Type: bool
function sentinel_isenemyinnarrowplace()
{
    if ( !isdefined( self.sentinel_droneenemy ) )
    {
        return false;
    }
    
    if ( !isdefined( self.v_narrow_volume ) )
    {
        self.v_narrow_volume = getent( "sentinel_narrow_nav", "targetname" );
    }
    
    if ( isdefined( self.v_narrow_volume ) && isdefined( self.sentinel_droneenemy ) )
    {
        if ( self.sentinel_droneenemy istouching( self.v_narrow_volume ) )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace sentinel_drone
// Params 1
// Checksum 0x7e43d8d1, Offset: 0x6ed0
// Size: 0x8c
function sentinel_setcompactmode( b_compact )
{
    if ( isdefined( b_compact ) && b_compact )
    {
        self.in_compact_mode = 1;
        blackboard::setblackboardattribute( self, "_stance", "crouch" );
        return;
    }
    
    self.in_compact_mode = 0;
    blackboard::setblackboardattribute( self, "_stance", "stand" );
}

// Namespace sentinel_drone
// Params 0
// Checksum 0x9edde238, Offset: 0x6f68
// Size: 0xec
function sentinel_hideinitialbrokenparts()
{
    self endon( #"disconnect" );
    self endon( #"death" );
    wait 0.2;
    self hidepart( "tag_arm_left_01_d1", "", 1 );
    self hidepart( "tag_arm_right_01_d1", "", 1 );
    self hidepart( "tag_arm_top_01_d1", "", 1 );
    self hidepart( "Tag_camera_dead", "", 1 );
    self hidepart( "tag_center_core_emmisive_red", "", 1 );
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xfb352d20, Offset: 0x7060
// Size: 0x2c
function sentinel_killmyself()
{
    self dodamage( self.health + 100, self.origin );
}

// Namespace sentinel_drone
// Params 0
// Checksum 0x58e87d71, Offset: 0x7098
// Size: 0x7a
function sentinel_getengagementdistmax()
{
    if ( sentinel_isenemyinnarrowplace() )
    {
        return ( self.settings.engagementdistmax * 0.3 );
    }
    else if ( isdefined( self.in_compact_mode ) && self.in_compact_mode )
    {
        return ( self.settings.engagementdistmax * 0.85 );
    }
    
    return self.settings.engagementdistmax;
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xa1e7247a, Offset: 0x7120
// Size: 0x7a
function sentinel_getengagementdistmin()
{
    if ( sentinel_isenemyinnarrowplace() )
    {
        return ( self.settings.engagementdistmin * 0.2 );
    }
    else if ( isdefined( self.in_compact_mode ) && self.in_compact_mode )
    {
        return ( self.settings.engagementdistmin * 0.5 );
    }
    
    return self.settings.engagementdistmin;
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xf6769b2a, Offset: 0x71a8
// Size: 0x46
function sentinel_getengagementheightmax()
{
    if ( isdefined( self.in_compact_mode ) && self.in_compact_mode )
    {
        return ( self.settings.engagementheightmax * 0.8 );
    }
    
    return self.settings.engagementheightmax;
}

// Namespace sentinel_drone
// Params 0
// Checksum 0x34f011b2, Offset: 0x71f8
// Size: 0x36
function sentinel_getengagementheightmin()
{
    if ( !isdefined( self.sentinel_droneenemy ) )
    {
        return ( self.settings.engagementheightmin * 3 );
    }
    
    return self.settings.engagementheightmin;
}

// Namespace sentinel_drone
// Params 3
// Checksum 0x36b1d8af, Offset: 0x7238
// Size: 0x18e
function sentinel_isinsideengagementdistance( origin, position, b_accept_negative_height )
{
    if ( !( distance2dsquared( position, origin ) > sentinel_getengagementdistmin() * sentinel_getengagementdistmin() && distance2dsquared( position, origin ) < sentinel_getengagementdistmax() * sentinel_getengagementdistmax() ) )
    {
        return 0;
    }
    
    if ( isdefined( b_accept_negative_height ) && b_accept_negative_height )
    {
        return ( abs( origin[ 2 ] - position[ 2 ] ) >= sentinel_getengagementheightmin() && abs( origin[ 2 ] - position[ 2 ] ) <= sentinel_getengagementheightmax() );
    }
    
    return position[ 2 ] - origin[ 2 ] >= sentinel_getengagementheightmin() && position[ 2 ] - origin[ 2 ] <= sentinel_getengagementheightmax();
}

// Namespace sentinel_drone
// Params 5
// Checksum 0xac98f591, Offset: 0x73d0
// Size: 0xe4
function sentinel_trace( start, end, ignore_ent, b_physics_trace, ignore_characters )
{
    if ( isdefined( b_physics_trace ) && b_physics_trace )
    {
        trace = physicstrace( start, end, ( -10, -10, -10 ), ( 10, 10, 10 ), self, 1 | 2 );
        
        if ( trace[ "fraction" ] < 1 )
        {
            return trace;
        }
    }
    
    trace = bullettrace( start, end, !( isdefined( ignore_characters ) && ignore_characters ), self, 0, 0, self, 1 );
    return trace;
}

// Namespace sentinel_drone
// Params 3
// Checksum 0x5410a7ee, Offset: 0x74c0
// Size: 0x5c
function sentinel_electrifyzombie( origin, zombie, radius )
{
    self endon( #"disconnect" );
    self endon( #"death" );
    
    if ( isdefined( self.sentinel_electrifyzombie ) )
    {
        self thread [[ self.sentinel_electrifyzombie ]]( origin, zombie, radius );
    }
}

// Namespace sentinel_drone
// Params 0
// Checksum 0xe8cf9454, Offset: 0x7528
// Size: 0x4e
function sentinel_deactivatealleffects()
{
    for ( i = 1; i <= 3 ; i++ )
    {
        self clientfield::set( "sentinel_drone_arm_cut_" + i, 0 );
    }
}

// Namespace sentinel_drone
// Params 3
// Checksum 0x8db7204b, Offset: 0x7580
// Size: 0x174
function sentinel_damageplayer( damage, eattacker, b_light_damage )
{
    if ( !isdefined( b_light_damage ) )
    {
        b_light_damage = 0;
    }
    
    self notify( #"proximitygrenadedamagestart" );
    self endon( #"proximitygrenadedamagestart" );
    self endon( #"disconnect" );
    self endon( #"death" );
    eattacker endon( #"disconnect" );
    self dodamage( damage, eattacker.origin, eattacker, eattacker );
    
    if ( b_light_damage )
    {
        self playrumbleonentity( "damage_heavy" );
    }
    else
    {
        self playrumbleonentity( "proximity_grenade" );
    }
    
    if ( self util::mayapplyscreeneffect() )
    {
        self clientfield::increment_to_player( "sentinel_drone_damage_player_fx" );
        
        if ( b_light_damage )
        {
            self shellshock( "electrocution_sentinel_drone", 0.5 );
            return;
        }
        
        self shellshock( "electrocution_sentinel_drone", 1 );
    }
}

// Namespace sentinel_drone
// Params 0
// Checksum 0x4293b87b, Offset: 0x7700
// Size: 0x84
function sentinel_removefromlevelarray()
{
    if ( !isdefined( level.a_sentinel_drones ) )
    {
        return;
    }
    
    for ( i = 0; i < level.a_sentinel_drones.size ; i++ )
    {
        if ( level.a_sentinel_drones[ i ] == self )
        {
            level.a_sentinel_drones[ i ] = undefined;
            break;
        }
    }
    
    level.a_sentinel_drones = array::remove_undefined( level.a_sentinel_drones );
}

// Namespace sentinel_drone
// Params 2
// Checksum 0xf5920732, Offset: 0x7790
// Size: 0xe8, Type: bool
function sentinel_isnearanothersentinel( point, min_distance )
{
    if ( !isdefined( level.a_sentinel_drones ) )
    {
        return false;
    }
    
    for ( i = 0; i < level.a_sentinel_drones.size ; i++ )
    {
        if ( !isdefined( level.a_sentinel_drones[ i ] ) )
        {
            continue;
        }
        
        if ( level.a_sentinel_drones[ i ] == self )
        {
            continue;
        }
        
        min_distance_sq = min_distance * min_distance;
        distance_sq = distancesquared( level.a_sentinel_drones[ i ].origin, point );
        
        if ( distance_sq < min_distance_sq )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace sentinel_drone
// Params 2
// Checksum 0xb43b31d3, Offset: 0x7880
// Size: 0xf0, Type: bool
function sentinel_isnearanotherplayer( origin, min_distance )
{
    players = getplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        if ( !is_target_valid( players[ i ] ) )
        {
            continue;
        }
        
        min_distance_sq = min_distance * min_distance;
        distance_sq = distancesquared( origin, players[ i ].origin + ( 0, 0, 48 ) );
        
        if ( distance_sq < min_distance_sq )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace sentinel_drone
// Params 1
// Checksum 0xb1a15fe4, Offset: 0x7978
// Size: 0x84
function sentinel_play_taunt( taunt_arr )
{
    if ( isdefined( level._lastplayed_drone_taunt ) && gettime() - level._lastplayed_drone_taunt < 6000 )
    {
        return;
    }
    
    taunt = randomint( taunt_arr.size );
    level._lastplayed_drone_taunt = gettime();
    self playsound( taunt_arr[ taunt ] );
}

/#

    // Namespace sentinel_drone
    // Params 0
    // Checksum 0x48e97a3a, Offset: 0x7a08
    // Size: 0x78, Type: dev
    function sentinel_debugdrawsize()
    {
        self endon( #"death" );
        
        while ( true )
        {
            radius = getdvarint( "<dev string:x149>", 35 );
            sphere( self.origin, radius, ( 0, 1, 0 ), 0.5 );
            wait 0.01;
        }
    }

    // Namespace sentinel_drone
    // Params 0
    // Checksum 0x1ab3ef39, Offset: 0x7a88
    // Size: 0x266, Type: dev
    function sentinel_debugfx()
    {
        self endon( #"death" );
        
        while ( true )
        {
            if ( getdvarint( "<dev string:x157>", 0 ) == 1 )
            {
                self.sentinel_debugfx_playall = 1;
                forward_vector = anglestoforward( self.angles );
                forward_vector = self.origin + vectorscale( forward_vector, 1200 );
                thread sentinel_firebeam( forward_vector );
                self clientfield::set( "<dev string:x170>", 1 );
            }
            else if ( isdefined( self.sentinel_debugfx_playall ) && self.sentinel_debugfx_playall )
            {
                self.sentinel_debugfx_playall = 0;
                self clientfield::set( "<dev string:x170>", 0 );
            }
            
            if ( getdvarint( "<dev string:x18b>", 0 ) == 1 )
            {
                self.sentinel_debugfx_beamcharge = 1;
            }
            else if ( isdefined( self.sentinel_debugfx_beamcharge ) && self.sentinel_debugfx_beamcharge )
            {
                self.sentinel_debugfx_beamcharge = 0;
                self clientfield::set( "<dev string:x170>", 0 );
            }
            
            if ( getdvarint( "<dev string:x1a7>", 0 ) == 1 )
            {
                if ( !( isdefined( self.sentinel_debugfx_noarms ) && self.sentinel_debugfx_noarms ) )
                {
                    self.sentinel_debugfx_noarms = 1;
                    thread sentinel_armdamage( 1000, 2 );
                    thread sentinel_armdamage( 1000, 1 );
                    thread sentinel_armdamage( 1000, 3 );
                }
            }
            
            if ( getdvarint( "<dev string:x1bf>", 0 ) == 1 )
            {
                if ( !( isdefined( self.sentinel_debugfx_noface ) && self.sentinel_debugfx_noface ) )
                {
                    self.sentinel_debugfx_noface = 1;
                    thread sentinel_facedamage( 1000, "<dev string:x1d7>" );
                }
            }
            
            wait 3;
        }
    }

    // Namespace sentinel_drone
    // Params 0
    // Checksum 0x83d69f6d, Offset: 0x7cf8
    // Size: 0x116, Type: dev
    function sentinel_debugbehavior()
    {
        self endon( #"death" );
        
        while ( isdefined( self ) )
        {
            if ( getdvarint( "<dev string:x1e8>", 0 ) == 1 )
            {
                self.debug_should_buff_zombies = 1;
                self.should_buff_zombies = 1;
            }
            else if ( isdefined( self.debug_should_buff_zombies ) )
            {
                self.debug_should_buff_zombies = undefined;
                self.should_buff_zombies = 0;
            }
            
            if ( getdvarint( "<dev string:x204>", 0 ) == 1 )
            {
                self.debug_sentinel_debug_compact = 1;
                blackboard::setblackboardattribute( self, "<dev string:x21b>", "<dev string:x223>" );
            }
            else if ( isdefined( self.debug_sentinel_debug_compact ) )
            {
                self.debug_sentinel_debug_compact = undefined;
                blackboard::setblackboardattribute( self, "<dev string:x21b>", "<dev string:x22a>" );
            }
            
            wait 1;
        }
    }

#/
