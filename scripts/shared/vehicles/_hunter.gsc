#using scripts/codescripts/struct;
#using scripts/shared/ai/systems/ai_interface;
#using scripts/shared/ai_shared;
#using scripts/shared/array_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/gameskill_shared;
#using scripts/shared/hostmigration_shared;
#using scripts/shared/math_shared;
#using scripts/shared/statemachine_shared;
#using scripts/shared/system_shared;
#using scripts/shared/turret_shared;
#using scripts/shared/util_shared;
#using scripts/shared/vehicle_ai_shared;
#using scripts/shared/vehicle_death_shared;
#using scripts/shared/vehicle_shared;
#using scripts/shared/vehicles/_attack_drone;

#namespace hunter;

// Namespace hunter
// Params 0, eflags: 0x2
// Checksum 0xe96a82b8, Offset: 0x598
// Size: 0x34
function autoexec __init__sytem__()
{
    system::register( "hunter", &__init__, undefined, undefined );
}

// Namespace hunter
// Params 0
// Checksum 0x6d1e5fa9, Offset: 0x5d8
// Size: 0x44
function __init__()
{
    registerinterfaceattributes( "hunter" );
    vehicle::add_main_callback( "hunter", &hunter_initialize );
}

// Namespace hunter
// Params 1
// Checksum 0x254f2268, Offset: 0x628
// Size: 0x74
function registerinterfaceattributes( archetype )
{
    vehicle_ai::registersharedinterfaceattributes( archetype );
    ai::registernumericinterface( archetype, "strafe_speed", 0, 0, 100 );
    ai::registernumericinterface( archetype, "strafe_distance", 0, 0, 10000 );
}

// Namespace hunter
// Params 0
// Checksum 0x882abc09, Offset: 0x6a8
// Size: 0x3be
function hunter_inittagarrays()
{
    self.weakspottags = [];
    
    if ( false )
    {
        if ( !isdefined( self.weakspottags ) )
        {
            self.weakspottags = [];
        }
        else if ( !isarray( self.weakspottags ) )
        {
            self.weakspottags = array( self.weakspottags );
        }
        
        self.weakspottags[ self.weakspottags.size ] = "tag_target_l";
        
        if ( !isdefined( self.weakspottags ) )
        {
            self.weakspottags = [];
        }
        else if ( !isarray( self.weakspottags ) )
        {
            self.weakspottags = array( self.weakspottags );
        }
        
        self.weakspottags[ self.weakspottags.size ] = "tag_target_r";
    }
    
    self.explosiveweakspottags = [];
    
    if ( false )
    {
        if ( !isdefined( self.explosiveweakspottags ) )
        {
            self.explosiveweakspottags = [];
        }
        else if ( !isarray( self.explosiveweakspottags ) )
        {
            self.explosiveweakspottags = array( self.explosiveweakspottags );
        }
        
        self.explosiveweakspottags[ self.explosiveweakspottags.size ] = "tag_fan_base_l";
        
        if ( !isdefined( self.explosiveweakspottags ) )
        {
            self.explosiveweakspottags = [];
        }
        else if ( !isarray( self.explosiveweakspottags ) )
        {
            self.explosiveweakspottags = array( self.explosiveweakspottags );
        }
        
        self.explosiveweakspottags[ self.explosiveweakspottags.size ] = "tag_fan_base_r";
    }
    
    self.missiletags = [];
    
    if ( !isdefined( self.missiletags ) )
    {
        self.missiletags = [];
    }
    else if ( !isarray( self.missiletags ) )
    {
        self.missiletags = array( self.missiletags );
    }
    
    self.missiletags[ self.missiletags.size ] = "tag_rocket1";
    
    if ( !isdefined( self.missiletags ) )
    {
        self.missiletags = [];
    }
    else if ( !isarray( self.missiletags ) )
    {
        self.missiletags = array( self.missiletags );
    }
    
    self.missiletags[ self.missiletags.size ] = "tag_rocket2";
    self.droneattachtags = [];
    
    if ( false )
    {
        if ( !isdefined( self.droneattachtags ) )
        {
            self.droneattachtags = [];
        }
        else if ( !isarray( self.droneattachtags ) )
        {
            self.droneattachtags = array( self.droneattachtags );
        }
        
        self.droneattachtags[ self.droneattachtags.size ] = "tag_drone_attach_l";
        
        if ( !isdefined( self.droneattachtags ) )
        {
            self.droneattachtags = [];
        }
        else if ( !isarray( self.droneattachtags ) )
        {
            self.droneattachtags = array( self.droneattachtags );
        }
        
        self.droneattachtags[ self.droneattachtags.size ] = "tag_drone_attach_r";
    }
}

// Namespace hunter
// Params 0
// Checksum 0x2ce814d, Offset: 0xa70
// Size: 0x1a8
function hunter_spawndrones()
{
    self.dronesowned = [];
    
    if ( false )
    {
        foreach ( dronetag in self.droneattachtags )
        {
            origin = self gettagorigin( dronetag );
            angles = self gettagangles( dronetag );
            drone = spawnvehicle( "spawner_bo3_attack_drone_enemy", origin, angles );
            drone.owner = self;
            drone.attachtag = dronetag;
            drone.team = self.team;
            
            if ( !isdefined( self.dronesowned ) )
            {
                self.dronesowned = [];
            }
            else if ( !isarray( self.dronesowned ) )
            {
                self.dronesowned = array( self.dronesowned );
            }
            
            self.dronesowned[ self.dronesowned.size ] = drone;
        }
    }
}

#using_animtree( "generic" );

// Namespace hunter
// Params 0
// Checksum 0xccb19683, Offset: 0xc20
// Size: 0x384
function hunter_initialize()
{
    self endon( #"death" );
    self useanimtree( #animtree );
    target_set( self, ( 0, 0, 90 ) );
    ai::createinterfaceforentity( self );
    self.health = self.healthdefault;
    self vehicle::friendly_fire_shield();
    self setneargoalnotifydist( 50 );
    self sethoverparams( 15, 100, 40 );
    self.flyheight = getdvarfloat( "g_quadrotorFlyHeight" );
    self.fovcosine = 0;
    self.fovcosinebusy = 0.574;
    self.vehaircraftcollisionenabled = 1;
    self.original_vehicle_type = self.vehicletype;
    self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
    self.goalradius = 999999;
    self.goalheight = 999999;
    self setgoal( self.origin, 0, self.goalradius, self.goalheight );
    self hunter_inittagarrays();
    self.overridevehicledamage = &huntercallback_vehicledamage;
    self thread vehicle_ai::nudge_collision();
    
    if ( isdefined( level.vehicle_initializer_cb ) )
    {
        [[ level.vehicle_initializer_cb ]]( self );
    }
    
    self.ignorefirefly = 1;
    self.ignoredecoy = 1;
    self vehicle_ai::initthreatbias();
    self turret::_init_turret( 1 );
    self turret::_init_turret( 2 );
    self turret::set_best_target_func( &side_turret_get_best_target, 1 );
    self turret::set_best_target_func( &side_turret_get_best_target, 2 );
    self turret::set_burst_parameters( 1, 2, 1, 2, 1 );
    self turret::set_burst_parameters( 1, 2, 1, 2, 2 );
    self turret::set_target_flags( 3, 1 );
    self turret::set_target_flags( 3, 2 );
    self side_turrets_forward();
    self pathvariableoffset( ( 10, 10, -30 ), 1 );
    defaultrole();
}

// Namespace hunter
// Params 0
// Checksum 0x36b16c4b, Offset: 0xfb0
// Size: 0x41c
function defaultrole()
{
    self vehicle_ai::init_state_machine_for_role();
    self vehicle_ai::get_state_callbacks( "combat" ).enter_func = &state_combat_enter;
    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
    self vehicle_ai::get_state_callbacks( "combat" ).exit_func = &state_combat_exit;
    self vehicle_ai::get_state_callbacks( "driving" ).enter_func = &hunter_scripted;
    self vehicle_ai::get_state_callbacks( "scripted" ).enter_func = &hunter_scripted;
    self vehicle_ai::get_state_callbacks( "death" ).enter_func = &state_death_enter;
    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;
    self vehicle_ai::get_state_callbacks( "emped" ).update_func = &hunter_emped;
    self vehicle_ai::add_state( "unaware", undefined, &state_unaware_update, &state_unaware_exit );
    vehicle_ai::add_interrupt_connection( "unaware", "scripted", "enter_scripted" );
    vehicle_ai::add_interrupt_connection( "unaware", "emped", "emped" );
    vehicle_ai::add_interrupt_connection( "unaware", "off", "shut_off" );
    vehicle_ai::add_interrupt_connection( "unaware", "driving", "enter_vehicle" );
    vehicle_ai::add_interrupt_connection( "unaware", "pain", "pain" );
    self vehicle_ai::add_state( "strafe", &state_strafe_enter, &state_strafe_update, &state_strafe_exit );
    vehicle_ai::add_interrupt_connection( "strafe", "scripted", "enter_scripted" );
    vehicle_ai::add_interrupt_connection( "strafe", "emped", "emped" );
    vehicle_ai::add_interrupt_connection( "strafe", "off", "shut_off" );
    vehicle_ai::add_interrupt_connection( "strafe", "driving", "enter_vehicle" );
    vehicle_ai::add_interrupt_connection( "strafe", "pain", "pain" );
    vehicle_ai::add_utility_connection( "strafe", "combat" );
    vehicle_ai::add_utility_connection( "emped", "strafe" );
    vehicle_ai::add_utility_connection( "pain", "strafe" );
    vehicle_ai::startinitialstate();
}

// Namespace hunter
// Params 0
// Checksum 0x79798c, Offset: 0x13d8
// Size: 0x64
function shut_off_fx()
{
    self endon( #"death" );
    self notify( #"death_shut_off" );
    
    if ( isdefined( self.frontscanner ) )
    {
        self.frontscanner.sndscanningent delete();
        self.frontscanner delete();
    }
}

// Namespace hunter
// Params 0
// Checksum 0x96b642ac, Offset: 0x1448
// Size: 0x152
function kill_drones()
{
    self endon( #"death" );
    
    foreach ( drone in self.dronesowned )
    {
        if ( isalive( drone ) && distance2dsquared( self.origin, drone.origin ) < 80 * 80 )
        {
            damageorigin = self.origin + ( 0, 0, 1 );
            drone finishvehicleradiusdamage( self.death_info.attacker, self.death_info.attacker, 32000, 32000, 10, 0, "MOD_EXPLOSIVE", level.weaponnone, damageorigin, 400, -1, ( 0, 0, 1 ), 0 );
        }
    }
}

// Namespace hunter
// Params 1
// Checksum 0x3d61d9d4, Offset: 0x15a8
// Size: 0x6c
function state_death_enter( params )
{
    self endon( #"death" );
    
    if ( isdefined( self.faketargetent ) )
    {
        self.faketargetent delete();
    }
    
    vehicle_ai::defaultstate_death_enter();
    self.inpain = 1;
    self thread shut_off_fx();
}

// Namespace hunter
// Params 1
// Checksum 0x9c03e0dd, Offset: 0x1620
// Size: 0x12c
function state_death_update( params )
{
    self endon( #"death" );
    death_type = vehicle_ai::get_death_type( params );
    
    if ( !isdefined( death_type ) )
    {
        params.death_type = "gibbed";
        death_type = params.death_type;
    }
    
    self vehicle_ai::clearalllookingandtargeting();
    self vehicle_ai::clearallmovement();
    self cancelaimove();
    self setspeedimmediate( 0 );
    self setvehvelocity( ( 0, 0, 0 ) );
    self setphysacceleration( ( 0, 0, 0 ) );
    self setangularvelocity( ( 0, 0, 0 ) );
    self vehicle_ai::defaultstate_death_update( params );
}

// Namespace hunter
// Params 1
// Checksum 0xc1de2d5e, Offset: 0x1758
// Size: 0x7c
function state_unaware_enter( params )
{
    ratio = 0.5;
    accel = self getdefaultacceleration();
    self setspeed( ratio * self.settings.defaultmovespeed, ratio * accel, ratio * accel );
}

// Namespace hunter
// Params 1
// Checksum 0x6b20d791, Offset: 0x17e0
// Size: 0xc8
function state_unaware_update( params )
{
    self endon( #"change_state" );
    self endon( #"death" );
    
    if ( isdefined( self.enemy ) )
    {
        self vehicle_ai::set_state( "combat" );
    }
    
    self clearlookatent();
    self disable_turrets();
    self thread movement_thread_wander();
    
    while ( true )
    {
        self waittill( #"enemy" );
        self vehicle_ai::set_state( "combat" );
    }
}

// Namespace hunter
// Params 1
// Checksum 0x5828622e, Offset: 0x18b0
// Size: 0x1a
function state_unaware_exit( params )
{
    self notify( #"end_movement_thread" );
}

// Namespace hunter
// Params 0
// Checksum 0x47831faf, Offset: 0x18d8
// Size: 0x30a
function movement_thread_wander()
{
    self endon( #"death" );
    self notify( #"end_movement_thread" );
    self endon( #"end_movement_thread" );
    constminsearchradius = 120;
    constmaxsearchradius = 800;
    minsearchradius = math::clamp( constminsearchradius, 0, self.goalradius );
    maxsearchradius = math::clamp( constmaxsearchradius, constminsearchradius, self.goalradius );
    halfheight = 400;
    innerspacing = 80;
    outerspacing = 50;
    maxgoaltimeout = 15;
    timeatsameposition = 2.5 + randomfloat( 1 );
    
    while ( true )
    {
        queryresult = positionquery_source_navigation( self.origin, minsearchradius, maxsearchradius, halfheight, innerspacing, self, outerspacing );
        positionquery_filter_distancetogoal( queryresult, self );
        vehicle_ai::positionquery_filter_outofgoalanchor( queryresult );
        vehicle_ai::positionquery_filter_random( queryresult, 0, 10 );
        vehicle_ai::positionquery_postprocess_sortscore( queryresult );
        stayatgoal = timeatsameposition > 0.2;
        foundpath = 0;
        
        for ( i = 0; i < queryresult.data.size && !foundpath ; i++ )
        {
            goalpos = queryresult.data[ i ].origin;
            foundpath = self setvehgoalpos( goalpos, stayatgoal, 1 );
        }
        
        if ( foundpath )
        {
            msg = self util::waittill_any_timeout( maxgoaltimeout, "near_goal", "force_goal", "reached_end_node", "goal" );
            
            if ( stayatgoal )
            {
                wait randomfloatrange( 0.5 * timeatsameposition, timeatsameposition );
            }
            
            continue;
        }
        
        wait 1;
    }
}

// Namespace hunter
// Params 0
// Checksum 0xbc2692dc, Offset: 0x1bf0
// Size: 0x34
function enable_turrets()
{
    self turret::enable( 1, 0 );
    self turret::enable( 2, 0 );
}

// Namespace hunter
// Params 0
// Checksum 0x70a988a6, Offset: 0x1c30
// Size: 0x4c
function disable_turrets()
{
    self turret::disable( 1 );
    self turret::disable( 2 );
    self side_turrets_forward();
}

// Namespace hunter
// Params 0
// Checksum 0x1b974c69, Offset: 0x1c88
// Size: 0x54
function side_turrets_forward()
{
    self setturrettargetrelativeangles( ( 10, -90, 0 ), 1 );
    self setturrettargetrelativeangles( ( 10, 90, 0 ), 2 );
}

// Namespace hunter
// Params 1
// Checksum 0x3c3c6000, Offset: 0x1ce8
// Size: 0xac
function state_combat_enter( params )
{
    ratio = 1;
    accel = self getdefaultacceleration();
    self setspeed( ratio * self.settings.defaultmovespeed, ratio * accel, ratio * accel );
    self hunter_lockon_fx();
    self enable_turrets();
}

// Namespace hunter
// Params 1
// Checksum 0xb1cab2d2, Offset: 0x1da0
// Size: 0xc8
function state_combat_update( params )
{
    self endon( #"change_state" );
    self endon( #"death" );
    
    if ( !isdefined( self.enemy ) )
    {
        self vehicle_ai::set_state( "unaware" );
    }
    
    self thread movement_thread_stayindistance();
    self thread attack_thread_mainturret();
    self thread attack_thread_rocket();
    
    while ( true )
    {
        self waittill( #"no_enemy" );
        self vehicle_ai::set_state( "unaware" );
    }
}

// Namespace hunter
// Params 1
// Checksum 0x30b50306, Offset: 0x1e70
// Size: 0x3c
function state_combat_exit( params )
{
    self notify( #"end_attack_thread" );
    self notify( #"end_movement_thread" );
    self clearturrettarget();
}

// Namespace hunter
// Params 1
// Checksum 0x2c2c8a7, Offset: 0x1eb8
// Size: 0xc4
function state_strafe_enter( params )
{
    ratio = 2;
    accel = ratio * self getdefaultacceleration();
    speed = ratio * self.settings.defaultmovespeed;
    strafe_speed_attribute = ai::get_behavior_attribute( "strafe_speed" );
    
    if ( strafe_speed_attribute > 0 )
    {
        speed = strafe_speed_attribute;
    }
    
    self setspeed( speed, accel, accel );
}

// Namespace hunter
// Params 1
// Checksum 0xe06314f3, Offset: 0x1f88
// Size: 0x7ec
function state_strafe_update( params )
{
    self endon( #"change_state" );
    self endon( #"death" );
    self clearvehgoalpos();
    distancetotarget = 0.5 * ( self.settings.engagementdistmin + self.settings.engagementdistmax );
    target = self.origin + anglestoforward( self.angles ) * distancetotarget;
    
    if ( isdefined( self.enemy ) )
    {
        distancetotarget = distance( self.origin, self.enemy.origin );
    }
    
    distancethreshold = 500 + distancetotarget * 0.08;
    strafe_distance_attribute = ai::get_behavior_attribute( "strafe_distance" );
    
    if ( strafe_distance_attribute > 0 )
    {
        distancethreshold = strafe_distance_attribute;
    }
    
    maxsearchradius = distancethreshold * 1.5;
    halfheight = 300;
    outerspacing = maxsearchradius * 0.05;
    innerspacing = outerspacing * 2;
    queryresult = positionquery_source_navigation( self.origin, 0, maxsearchradius, halfheight, innerspacing, self, outerspacing );
    positionquery_filter_directness( queryresult, self.origin, target );
    positionquery_filter_distancetogoal( queryresult, self );
    positionquery_filter_inclaimedlocation( queryresult, self );
    self vehicle_ai::positionquery_filter_outofgoalanchor( queryresult, 200 );
    
    foreach ( point in queryresult.data )
    {
        distancetopointsqr = distancesquared( point.origin, self.origin );
        
        if ( distancetopointsqr < distancethreshold * 0.5 )
        {
            /#
                if ( !isdefined( point._scoredebug ) )
                {
                    point._scoredebug = [];
                }
                
                point._scoredebug[ "<dev string:x28>" ] = distancethreshold * -1;
            #/
            
            point.score += distancethreshold * -1;
        }
        
        /#
            if ( !isdefined( point._scoredebug ) )
            {
                point._scoredebug = [];
            }
            
            point._scoredebug[ "<dev string:x28>" ] = sqrt( distancetopointsqr );
        #/
        
        point.score += sqrt( distancetopointsqr );
        difftoprefereddirectness = abs( point.directness - 0 );
        directnessscore = mapfloat( 0, 1, 1000, 0, difftoprefereddirectness );
        
        if ( difftoprefereddirectness > 0.1 )
        {
            directnessscore -= 500;
        }
        
        /#
            if ( !isdefined( point._scoredebug ) )
            {
                point._scoredebug = [];
            }
            
            point._scoredebug[ "<dev string:x31>" ] = point.directness;
        #/
        
        point.score += point.directness;
        
        /#
            if ( !isdefined( point._scoredebug ) )
            {
                point._scoredebug = [];
            }
            
            point._scoredebug[ "<dev string:x3f>" ] = directnessscore;
        #/
        
        point.score += directnessscore;
        
        if ( point.directionchange < 0.6 )
        {
            /#
                if ( !isdefined( point._scoredebug ) )
                {
                    point._scoredebug = [];
                }
                
                point._scoredebug[ "<dev string:x4a>" ] = -2000;
            #/
            
            point.score += -2000;
        }
        
        /#
            if ( !isdefined( point._scoredebug ) )
            {
                point._scoredebug = [];
            }
            
            point._scoredebug[ "<dev string:x5a>" ] = point.directionchange;
        #/
        
        point.score += point.directionchange;
    }
    
    vehicle_ai::positionquery_postprocess_sortscore( queryresult );
    self vehicle_ai::positionquery_debugscores( queryresult );
    
    foreach ( point in queryresult.data )
    {
        self.current_pathto_pos = point.origin;
        foundpath = self setvehgoalpos( self.current_pathto_pos, 1, 1 );
        
        if ( foundpath )
        {
            msg = self util::waittill_any_timeout( 5, "near_goal", "force_goal", "goal", "enemy_visible" );
            break;
        }
    }
    
    previous_state = self vehicle_ai::get_previous_state();
    
    if ( !isdefined( previous_state ) || previous_state == "strafe" )
    {
        previous_state = "combat";
    }
    
    self vehicle_ai::set_state( previous_state );
}

// Namespace hunter
// Params 1
// Checksum 0x371a2020, Offset: 0x2780
// Size: 0x2c
function state_strafe_exit( params )
{
    vehicle_ai::cooldown( "strafe_again", 2 );
}

// Namespace hunter
// Params 1
// Checksum 0x448ee6b6, Offset: 0x27b8
// Size: 0x6da
function getnextmoveposition_tactical( enemy )
{
    if ( self.goalforced )
    {
        return self.goalpos;
    }
    
    selfdisttoenemy = distance2d( self.origin, enemy.origin );
    gooddist = 0.5 * ( self.settings.engagementdistmin + self.settings.engagementdistmax );
    tooclosedist = 0.8 * gooddist;
    closedist = 1.2 * gooddist;
    fardist = 3 * gooddist;
    querymultiplier = mapfloat( closedist, fardist, 1, 3, selfdisttoenemy );
    prefereddistawayfromorigin = 150;
    maxsearchradius = 1000 * querymultiplier;
    halfheight = 300 * querymultiplier;
    innerspacing = 80 * querymultiplier;
    outerspacing = 80 * querymultiplier;
    queryresult = positionquery_source_navigation( self.origin, 0, maxsearchradius, halfheight, innerspacing, self, outerspacing );
    positionquery_filter_distancetogoal( queryresult, self );
    positionquery_filter_inclaimedlocation( queryresult, self );
    positionquery_filter_sight( queryresult, enemy.origin, self geteye() - self.origin, self, 0, enemy );
    self vehicle_ai::positionquery_filter_outofgoalanchor( queryresult, 200 );
    self vehicle_ai::positionquery_filter_engagementdist( queryresult, enemy, self.settings.engagementdistmin, self.settings.engagementdistmax );
    self vehicle_ai::positionquery_filter_random( queryresult, 0, 30 );
    goalheight = enemy.origin[ 2 ] + 0.5 * ( self.settings.engagementheightmin + self.settings.engagementheightmax );
    
    foreach ( point in queryresult.data )
    {
        if ( !point.visibility )
        {
            /#
                if ( !isdefined( point._scoredebug ) )
                {
                    point._scoredebug = [];
                }
                
                point._scoredebug[ "<dev string:x6d>" ] = -600;
            #/
            
            point.score += -600;
        }
        
        /#
            if ( !isdefined( point._scoredebug ) )
            {
                point._scoredebug = [];
            }
            
            point._scoredebug[ "<dev string:x7b>" ] = point.distawayfromengagementarea * -1;
        #/
        
        point.score += point.distawayfromengagementarea * -1;
        
        /#
            if ( !isdefined( point._scoredebug ) )
            {
                point._scoredebug = [];
            }
            
            point._scoredebug[ "<dev string:x8a>" ] = mapfloat( 0, prefereddistawayfromorigin, 0, 600, point.disttoorigin2d );
        #/
        
        point.score += mapfloat( 0, prefereddistawayfromorigin, 0, 600, point.disttoorigin2d );
        
        if ( point.inclaimedlocation )
        {
            /#
                if ( !isdefined( point._scoredebug ) )
                {
                    point._scoredebug = [];
                }
                
                point._scoredebug[ "<dev string:x97>" ] = -500;
            #/
            
            point.score += -500;
        }
        
        preferedheightrange = 75;
        distfrompreferredheight = abs( point.origin[ 2 ] - goalheight );
        
        if ( distfrompreferredheight > preferedheightrange )
        {
            heightscore = mapfloat( preferedheightrange, 5000, 0, 9000, distfrompreferredheight ) * -1;
            
            /#
                if ( !isdefined( point._scoredebug ) )
                {
                    point._scoredebug = [];
                }
                
                point._scoredebug[ "<dev string:xa9>" ] = heightscore;
            #/
            
            point.score += heightscore;
        }
    }
    
    self vehicle_ai::positionquery_debugscores( queryresult );
    vehicle_ai::positionquery_postprocess_sortscore( queryresult );
    
    if ( queryresult.data.size )
    {
        return queryresult.data[ 0 ].origin;
    }
    
    return self.origin;
}

// Namespace hunter
// Params 0
// Checksum 0x7232b6b0, Offset: 0x2ea0
// Size: 0x88c
function movement_thread_stayindistance()
{
    self endon( #"death" );
    self notify( #"end_movement_thread" );
    self endon( #"end_movement_thread" );
    maxgoaltimeout = 10;
    stuckcount = 0;
    
    while ( true )
    {
        enemy = self.enemy;
        
        if ( !isdefined( enemy ) )
        {
            wait 1;
            continue;
        }
        
        usepathfinding = 1;
        onnavvolume = ispointinnavvolume( self.origin, "navvolume_big" );
        
        if ( !onnavvolume )
        {
            getbackpoint = undefined;
            pointonnavvolume = self getclosestpointonnavvolume( self.origin, 500 );
            
            if ( isdefined( pointonnavvolume ) )
            {
                if ( sighttracepassed( self.origin, pointonnavvolume, 0, self ) )
                {
                    getbackpoint = pointonnavvolume;
                }
            }
            
            if ( !isdefined( getbackpoint ) )
            {
                queryresult = positionquery_source_navigation( self.origin, 0, 800, 400, 1.5 * self.radius );
                positionquery_filter_sight( queryresult, self.origin, ( 0, 0, 0 ), self, 1 );
                getbackpoint = undefined;
                
                foreach ( point in queryresult.data )
                {
                    if ( point.visibility === 1 )
                    {
                        getbackpoint = point.origin;
                        break;
                    }
                }
            }
            
            if ( isdefined( getbackpoint ) )
            {
                self.current_pathto_pos = getbackpoint;
                usepathfinding = 0;
            }
            else
            {
                stuckcount++;
                
                if ( stuckcount == 1 )
                {
                    stucklocation = self.origin;
                }
                else if ( stuckcount > 10 )
                {
                    /#
                        assert( 0, "<dev string:xb0>" + self.origin );
                        v_box_min = ( self.radius * -1, self.radius * -1, self.radius * -1 );
                        v_box_max = ( self.radius, self.radius, self.radius );
                        box( self.origin, v_box_min, v_box_max, self.angles[ 1 ], ( 1, 0, 0 ), 1, 0, 1000000 );
                        
                        if ( isdefined( stucklocation ) )
                        {
                            line( stucklocation, self.origin, ( 1, 0, 0 ), 1, 1, 1000000 );
                        }
                    #/
                    
                    self kill();
                }
            }
        }
        else
        {
            stuckcount = 0;
            
            if ( self.goalforced )
            {
                goalpos = self getclosestpointonnavvolume( self.goalpos, 200 );
                
                if ( isdefined( goalpos ) )
                {
                    self.current_pathto_pos = goalpos;
                    usepathfinding = 1;
                }
                else
                {
                    self.current_pathto_pos = self.goalpos;
                    usepathfinding = 0;
                }
            }
            else
            {
                self.current_pathto_pos = getnextmoveposition_tactical( enemy );
                usepathfinding = 1;
            }
        }
        
        if ( !isdefined( self.current_pathto_pos ) )
        {
            wait 0.5;
            continue;
        }
        
        distancetogoalsq = distancesquared( self.current_pathto_pos, self.origin );
        
        if ( distancetogoalsq > 0.5 * ( self.settings.engagementdistmin + self.settings.engagementdistmax ) * 0.5 * ( self.settings.engagementdistmin + self.settings.engagementdistmax ) )
        {
            self setspeed( self.settings.defaultmovespeed * 2 );
        }
        else
        {
            self setspeed( self.settings.defaultmovespeed );
        }
        
        self setlookatent( enemy );
        foundpath = self setvehgoalpos( self.current_pathto_pos, 1, usepathfinding );
        
        if ( foundpath )
        {
            /#
                if ( isdefined( getdvarint( "<dev string:xd5>" ) ) && getdvarint( "<dev string:xd5>" ) )
                {
                    recordline( self.origin, self.current_pathto_pos, ( 0.3, 1, 0 ) );
                    recordline( self.origin, enemy.origin, ( 1, 0, 0.4 ) );
                }
            #/
            
            msg = self util::waittill_any_timeout( maxgoaltimeout, "near_goal", "force_goal", "goal" );
        }
        else
        {
            wait 0.5;
        }
        
        enemy = self.enemy;
        
        if ( isdefined( enemy ) )
        {
            goalheight = enemy.origin[ 2 ] + 0.5 * ( self.settings.engagementheightmin + self.settings.engagementheightmax );
            distfrompreferredheight = abs( self.origin[ 2 ] - goalheight );
            fardist = self.settings.engagementdistmax;
            neardist = self.settings.engagementdistmin;
            selfdisttoenemy = distance2d( self.origin, enemy.origin );
            
            if ( self vehcansee( enemy ) && selfdisttoenemy < fardist && selfdisttoenemy > neardist && distfrompreferredheight < 230 )
            {
                msg = self util::waittill_any_timeout( randomfloatrange( 2, 4 ), "enemy_not_visible" );
                
                if ( msg == "enemy_not_visible" )
                {
                    msg = self util::waittill_any_timeout( 1, "enemy_visible" );
                    
                    if ( msg != "timeout" )
                    {
                        wait 1;
                    }
                }
            }
            
            continue;
        }
        
        wait 1;
    }
}

// Namespace hunter
// Params 3
// Checksum 0x6b660e09, Offset: 0x3738
// Size: 0x204
function delay_target_toenemy_thread( point, enemy, timetohit )
{
    self endon( #"death" );
    self endon( #"change_state" );
    self endon( #"end_attack_thread" );
    self endon( #"faketarget_stop_moving" );
    enemy endon( #"death" );
    
    if ( !isdefined( self.faketargetent ) )
    {
        self.faketargetent = spawn( "script_origin", point );
    }
    
    self.faketargetent unlink();
    self.faketargetent.origin = point;
    self setturrettargetent( self.faketargetent );
    self waittill( #"turret_on_target" );
    timestart = gettime();
    offset = ( 0, 0, 0 );
    
    if ( issentient( enemy ) )
    {
        offset = enemy geteye() - enemy.origin;
    }
    
    while ( gettime() < timestart + timetohit * 1000 )
    {
        self.faketargetent.origin = lerpvector( point, enemy.origin + offset, ( gettime() - timestart ) / timetohit * 1000 );
        wait 0.05;
    }
    
    self.faketargetent.origin = enemy.origin + offset;
    wait 0.05;
    self.faketargetent linkto( enemy );
}

// Namespace hunter
// Params 0
// Checksum 0x2ea057ed, Offset: 0x3948
// Size: 0x238
function attack_thread_mainturret()
{
    self endon( #"death" );
    self endon( #"change_state" );
    self endon( #"end_attack_thread" );
    
    while ( true )
    {
        enemy = self.enemy;
        
        if ( isdefined( enemy ) )
        {
            self setlookatent( enemy );
            
            if ( self vehcansee( enemy ) )
            {
                vectorfromenemy = vectornormalize( ( ( self.origin - enemy.origin )[ 0 ], ( self.origin - enemy.origin )[ 1 ], 0 ) );
                self thread delay_target_toenemy_thread( enemy.origin + vectorfromenemy * 300, enemy, 1.5 );
                self waittill( #"turret_on_target" );
                self vehicle_ai::fire_for_time( 2 + randomfloat( 0.8 ) );
                self clearturrettarget();
                self setturrettargetrelativeangles( ( 15, 0, 0 ), 0 );
                
                if ( isdefined( enemy ) && isai( enemy ) )
                {
                    wait 2.5 + randomfloat( 0.5 );
                }
                else
                {
                    wait 2 + randomfloat( 0.4 );
                }
            }
            else
            {
                wait 0.4;
            }
            
            continue;
        }
        
        self clearturrettarget();
        self clearlookatent();
        wait 0.4;
    }
}

// Namespace hunter
// Params 0
// Checksum 0xf4557ed0, Offset: 0x3b88
// Size: 0x4b8
function attack_thread_rocket()
{
    self endon( #"death" );
    self endon( #"change_state" );
    self endon( #"end_attack_thread" );
    
    while ( true )
    {
        enemy = self.enemy;
        
        if ( !isdefined( enemy ) )
        {
            wait 1;
            continue;
        }
        
        if ( isdefined( enemy ) && self vehcansee( enemy ) && vehicle_ai::iscooldownready( "rocket_launcher" ) )
        {
            vehicle_ai::cooldown( "rocket_launcher", 8 );
            self notify( #"end_movement_thread" );
            self clearvehgoalpos();
            self setvehgoalpos( self.origin, 1, 0 );
            target = enemy.origin;
            self setlookatent( enemy );
            self hunter_lockon_fx();
            wait 1.5;
            eye = self gettagorigin( "tag_eye" );
            
            if ( isdefined( enemy ) )
            {
                anglestotarget = vectortoangles( enemy.origin - eye );
                angles = anglestotarget - self.angles;
                
                if ( -30 < angles[ 0 ] && angles[ 0 ] < 60 && -70 < angles[ 1 ] && angles[ 1 ] < 70 )
                {
                    target = enemy.origin;
                }
                else
                {
                    anglestotarget = vectortoangles( target - eye );
                }
            }
            else
            {
                anglestotarget = vectortoangles( target - eye );
            }
            
            rightdir = anglestoright( anglestotarget );
            randomrange = 30;
            offset = [];
            offset[ 0 ] = rightdir * -1 * randomrange * 2 + ( randomfloatrange( randomrange * -1, randomrange ), randomfloatrange( randomrange * -1, randomrange ), 0 );
            offset[ 1 ] = rightdir * randomrange * 2 + ( randomfloatrange( randomrange * -1, randomrange ), randomfloatrange( randomrange * -1, randomrange ), 0 );
            self hunter_fire_one_missile( 0, target, offset[ 0 ] );
            wait 0.5;
            
            if ( isdefined( enemy ) )
            {
                eye = self gettagorigin( "tag_eye" );
                angles = vectortoangles( enemy.origin - eye ) - self.angles;
                
                if ( -30 < angles[ 0 ] && angles[ 0 ] < 60 && -70 < angles[ 1 ] && angles[ 1 ] < 70 )
                {
                    target = enemy.origin;
                }
            }
            
            self hunter_fire_one_missile( 1, target, offset[ 1 ] );
            wait 1;
            self thread movement_thread_stayindistance();
        }
        
        wait 0.5;
    }
}

// Namespace hunter
// Params 2
// Checksum 0xb9ce47c9, Offset: 0x4048
// Size: 0x16c
function side_turret_get_best_target( a_potential_targets, n_index )
{
    if ( self.ignoreall === 1 )
    {
        return undefined;
    }
    
    shouldyield = 1 && level.gameskill < 3;
    main_turret_target = self.enemy;
    
    if ( n_index === 2 )
    {
        other_turret_target = turret::get_target( 1 );
    }
    
    if ( shouldyield )
    {
        arrayremovevalue( a_potential_targets, main_turret_target );
        arrayremovevalue( a_potential_targets, other_turret_target );
    }
    
    e_best_target = undefined;
    
    while ( !isdefined( e_best_target ) && a_potential_targets.size > 0 )
    {
        e_closest_target = arraygetclosest( self.origin, a_potential_targets );
        
        if ( self turret::can_hit_target( e_closest_target, n_index ) )
        {
            e_best_target = e_closest_target;
            continue;
        }
        
        arrayremovevalue( a_potential_targets, e_closest_target );
    }
    
    return e_best_target;
}

// Namespace hunter
// Params 5
// Checksum 0xe2b50b79, Offset: 0x41c0
// Size: 0x248
function hunter_fire_one_missile( launcher_index, target, offset, blinklights, waittimeafterblinklights )
{
    self endon( #"death" );
    
    if ( isdefined( blinklights ) && blinklights )
    {
        self vehicle_ai::blink_lights_for_time( 1 );
        
        if ( isdefined( waittimeafterblinklights ) && waittimeafterblinklights > 0 )
        {
            wait waittimeafterblinklights;
        }
    }
    
    if ( !isdefined( offset ) )
    {
        offset = ( 0, 0, 0 );
    }
    
    spawntag = self.missiletags[ launcher_index ];
    origin = self gettagorigin( spawntag );
    angles = self gettagangles( spawntag );
    forward = anglestoforward( angles );
    up = anglestoup( angles );
    
    if ( isdefined( spawntag ) && isdefined( target ) )
    {
        weapon = getweapon( "hunter_rocket_turret" );
        
        if ( isentity( target ) )
        {
            missile = magicbullet( weapon, origin, target.origin + offset, self, target, offset );
            return;
        }
        
        if ( isvec( target ) )
        {
            missile = magicbullet( weapon, origin, target + offset, self );
            return;
        }
        
        missile = magicbullet( weapon, origin, target.origin + offset, self );
    }
}

// Namespace hunter
// Params 0
// Checksum 0xcad06e6b, Offset: 0x4410
// Size: 0x8c
function remote_missile_life()
{
    self endon( #"death" );
    hostmigration::waitlongdurationwithhostmigrationpause( 10 );
    playfx( level.remote_mortar_fx[ "missileExplode" ], self.origin );
    self playlocalsound( "mpl_ks_reaper_explosion" );
    self delete();
}

// Namespace hunter
// Params 0
// Checksum 0x1a4bb596, Offset: 0x44a8
// Size: 0x44
function hunter_lockon_fx()
{
    self thread vehicle_ai::blink_lights_for_time( 1.5 );
    self playsound( "veh_hunter_alarm_target" );
}

// Namespace hunter
// Params 2
// Checksum 0xd1e5e1d6, Offset: 0x44f8
// Size: 0xec
function getenemyarray( include_ai, include_player )
{
    enemyarray = [];
    enemy_team = "allies";
    
    if ( isdefined( include_ai ) && include_ai )
    {
        aiarray = getaiteamarray( enemy_team );
        enemyarray = arraycombine( enemyarray, aiarray, 0, 0 );
    }
    
    if ( isdefined( include_player ) && include_player )
    {
        playerarray = getplayers( enemy_team );
        enemyarray = arraycombine( enemyarray, playerarray, 0, 0 );
    }
    
    return enemyarray;
}

// Namespace hunter
// Params 2
// Checksum 0xc9a47357, Offset: 0x45f0
// Size: 0x134
function is_point_in_view( point, do_trace )
{
    if ( !isdefined( point ) )
    {
        return 0;
    }
    
    scanner = self.frontscanner;
    vector_to_point = point - scanner.origin;
    in_view = lengthsquared( vector_to_point ) <= 10000 * 10000;
    
    if ( in_view )
    {
        in_view = util::within_fov( scanner.origin, scanner.angles, point, cos( 190 ) );
    }
    
    if ( isdefined( do_trace ) && in_view && do_trace && isdefined( self.enemy ) )
    {
        in_view = sighttracepassed( scanner.origin, point, 0, self.enemy );
    }
    
    return in_view;
}

// Namespace hunter
// Params 2
// Checksum 0xa11f8b2, Offset: 0x4730
// Size: 0x104
function is_valid_target( target, do_trace )
{
    target_is_valid = 1;
    
    if ( isdefined( target.ignoreme ) && target.ignoreme || target.health <= 0 )
    {
        target_is_valid = 0;
    }
    else if ( target isnotarget() || issentient( target ) && target ai::is_dead_sentient() )
    {
        target_is_valid = 0;
    }
    else if ( isdefined( target.origin ) && !is_point_in_view( target.origin, do_trace ) )
    {
        target_is_valid = 0;
    }
    
    return target_is_valid;
}

// Namespace hunter
// Params 1
// Checksum 0x28c2dac3, Offset: 0x4840
// Size: 0x12c
function get_enemies_in_view( do_trace )
{
    validenemyarray = [];
    enemyarray = getenemyarray( 1, 1 );
    
    foreach ( enemy in enemyarray )
    {
        if ( is_valid_target( enemy, do_trace ) )
        {
            if ( !isdefined( validenemyarray ) )
            {
                validenemyarray = [];
            }
            else if ( !isarray( validenemyarray ) )
            {
                validenemyarray = array( validenemyarray );
            }
            
            validenemyarray[ validenemyarray.size ] = enemy;
        }
    }
    
    return validenemyarray;
}

// Namespace hunter
// Params 0
// Checksum 0xcb503ea2, Offset: 0x4978
// Size: 0x19c
function hunter_scanner_init()
{
    self.frontscanner = spawn( "script_model", self gettagorigin( "tag_gunner_flash3" ) );
    self.frontscanner setmodel( "tag_origin" );
    self.frontscanner.angles = self gettagangles( "tag_gunner_flash3" );
    self.frontscanner linkto( self, "tag_gunner_flash3" );
    self.frontscanner.owner = self;
    self.frontscanner.hastargetent = 0;
    self.frontscanner.sndscanningent = spawn( "script_origin", self.frontscanner.origin + anglestoforward( self.angles ) * 1000 );
    self.frontscanner.sndscanningent linkto( self.frontscanner );
    wait 0.25;
    
    if ( false )
    {
        playfxontag( self.settings.spotlightfx, self.frontscanner, "tag_origin" );
    }
}

// Namespace hunter
// Params 2
// Checksum 0x108d492f, Offset: 0x4b20
// Size: 0x8c
function hunter_scanner_settargetentity( targetent, offset )
{
    if ( !isdefined( offset ) )
    {
        offset = ( 0, 0, 0 );
    }
    
    if ( isdefined( targetent ) )
    {
        self.frontscanner.targetent = targetent;
        self.frontscanner.hastargetent = 1;
        self setgunnertargetent( self.frontscanner.targetent, offset, 2 );
    }
}

// Namespace hunter
// Params 0
// Checksum 0x1590370b, Offset: 0x4bb8
// Size: 0x34
function hunter_scanner_clearlooktarget()
{
    self.frontscanner.hastargetent = 0;
    self cleargunnertarget( 2 );
}

// Namespace hunter
// Params 1
// Checksum 0xff2ae343, Offset: 0x4bf8
// Size: 0x54
function hunter_scanner_settargetposition( targetpos )
{
    if ( isdefined( targetpos ) )
    {
        self.frontscanner.targetpos = targetpos;
        self setgunnertargetvec( self.frontscanner.targetpos, 2 );
    }
}

// Namespace hunter
// Params 0
// Checksum 0xa20ecea, Offset: 0x4c58
// Size: 0x430
function hunter_frontscanning()
{
    self endon( #"death_shut_off" );
    self endon( #"crash_done" );
    self endon( #"death" );
    hunter_scanner_init();
    offsetfactorpitch = 0;
    offsetfactoryaw = 0;
    pitchstep = 2.23607;
    yawstep = 3.14159;
    pitchrange = 20;
    yawrange = 45;
    scannerdirection = undefined;
    
    while ( true )
    {
        scannerorigin = self.frontscanner.origin;
        
        if ( isdefined( self.inpain ) && self.inpain )
        {
            wait 0.3;
            offset = ( 50, 0, 0 ) + ( math::randomsign() * randomfloatrange( 1, 2 ) * pitchrange, math::randomsign() * randomfloatrange( 1, 2 ) * yawrange, 0 );
            scannerdirection = anglestoforward( self.angles + offset );
        }
        else if ( !isdefined( self.enemy ) )
        {
            if ( false )
            {
                self.frontscanner.sndscanningent playloopsound( "veh_hunter_scanner_loop", 1 );
            }
            
            offsetfactorpitch += pitchstep;
            offsetfactoryaw += yawstep;
            offset = ( 50, 0, 0 ) + ( sin( offsetfactorpitch ) * pitchrange, cos( offsetfactoryaw ) * yawrange, 0 );
            scannerdirection = anglestoforward( self.angles + offset );
            enemies = get_enemies_in_view( 1 );
            
            if ( enemies.size > 0 )
            {
                closest_enemy = arraygetclosest( self.origin, enemies );
                self.favoriteenemy = closest_enemy;
                
                /#
                    line( scannerorigin, closest_enemy.origin, ( 0, 1, 0 ), 1, 3 );
                #/
            }
        }
        else
        {
            if ( self is_point_in_view( self.enemy.origin, 1 ) )
            {
                self notify( #"hunter_lockontargetinsight" );
            }
            else
            {
                self notify( #"hunter_lockontargetoutsight" );
            }
            
            scannerdirection = vectornormalize( self.enemy.origin - scannerorigin );
            
            if ( false )
            {
                self.frontscanner.sndscanningent stoploopsound( 1 );
            }
        }
        
        targetlocation = scannerorigin + scannerdirection * 1000;
        self hunter_scanner_settargetposition( targetlocation );
        
        /#
            line( scannerorigin, self.frontscanner.targetpos, ( 0, 1, 0 ), 1, 1000 );
        #/
        
        wait 0.1;
    }
}

// Namespace hunter
// Params 0
// Checksum 0x31ef45a4, Offset: 0x5090
// Size: 0xc4
function hunter_exit_vehicle()
{
    self waittill( #"exit_vehicle", player );
    player.ignoreme = 0;
    player disableinvulnerability();
    self setheliheightlock( 0 );
    self enableaimassist();
    self setvehicletype( self.original_vehicle_type );
    self.attachedpath = undefined;
    self setgoal( self.origin, 0, 4096, 512 );
}

// Namespace hunter
// Params 1
// Checksum 0x28342e1a, Offset: 0x5160
// Size: 0x20c
function hunter_scripted( params )
{
    params.driver = self getseatoccupant( 0 );
    
    if ( isdefined( params.driver ) )
    {
        self disableaimassist();
        self thread vehicle_death::vehicle_damage_filter( "firestorm_turret" );
        params.driver.ignoreme = 1;
        params.driver enableinvulnerability();
        
        if ( isdefined( self.vehicle_weapon_override ) )
        {
            self setvehweapon( self.vehicle_weapon_override );
        }
        
        self thread hunter_exit_vehicle();
        self thread hunter_collision_player();
        self thread player_fire_update_side_turret_1();
        self thread player_fire_update_side_turret_2();
        self thread player_fire_update_rocket();
    }
    
    if ( isdefined( self.goal_node ) && isdefined( self.goal_node.hunter_claimed ) )
    {
        self.goal_node.hunter_claimed = undefined;
    }
    
    self cleartargetentity();
    self clearvehgoalpos();
    self pathvariableoffsetclear();
    self pathfixedoffsetclear();
    self clearlookatent();
    self resumespeed();
}

// Namespace hunter
// Params 0
// Checksum 0x9c2a8d07, Offset: 0x5378
// Size: 0xc6
function player_fire_update_side_turret_1()
{
    self endon( #"death" );
    self endon( #"exit_vehicle" );
    weapon = self seatgetweapon( 1 );
    firetime = weapon.firetime;
    
    while ( true )
    {
        self setgunnertargetvec( self getturrettargetvec( 0 ), 0 );
        
        if ( self isdriverfiring() )
        {
            self fireweapon( 1 );
        }
        
        wait firetime;
    }
}

// Namespace hunter
// Params 0
// Checksum 0x91bf6139, Offset: 0x5448
// Size: 0xce
function player_fire_update_side_turret_2()
{
    self endon( #"death" );
    self endon( #"exit_vehicle" );
    weapon = self seatgetweapon( 2 );
    firetime = weapon.firetime;
    
    while ( true )
    {
        self setgunnertargetvec( self getturrettargetvec( 0 ), 1 );
        
        if ( self isdriverfiring() )
        {
            self fireweapon( 2 );
        }
        
        wait firetime;
    }
}

// Namespace hunter
// Params 0
// Checksum 0x63af35c, Offset: 0x5520
// Size: 0x198
function player_fire_update_rocket()
{
    self endon( #"death" );
    self endon( #"exit_vehicle" );
    weapon = getweapon( "hunter_rocket_turret_player" );
    firetime = weapon.firetime;
    driver = self getseatoccupant( 0 );
    
    while ( true )
    {
        if ( driver buttonpressed( "BUTTON_A" ) )
        {
            spawntag0 = self.missiletags[ 0 ];
            spawntag1 = self.missiletags[ 1 ];
            origin0 = self gettagorigin( spawntag0 );
            origin1 = self gettagorigin( spawntag1 );
            target = self getturrettargetvec( 0 );
            magicbullet( weapon, origin0, target );
            magicbullet( weapon, origin1, target );
            wait firetime;
        }
        
        wait 0.05;
    }
}

// Namespace hunter
// Params 0
// Checksum 0xaf53d3c4, Offset: 0x56c0
// Size: 0xf8
function hunter_collision_player()
{
    self endon( #"change_state" );
    self endon( #"crash_done" );
    self endon( #"death" );
    
    while ( true )
    {
        self waittill( #"veh_collision", velocity, normal );
        driver = self getseatoccupant( 0 );
        
        if ( isdefined( driver ) && lengthsquared( velocity ) > 4900 )
        {
            earthquake( 0.25, 0.25, driver.origin, 50 );
            driver playrumbleonentity( "damage_heavy" );
        }
    }
}

// Namespace hunter
// Params 0
// Checksum 0xf342b0ff, Offset: 0x57c0
// Size: 0x146
function hunter_update_rumble()
{
    self endon( #"death" );
    self endon( #"exit_vehicle" );
    
    while ( true )
    {
        vr = abs( self getspeed() / self getmaxspeed() );
        
        if ( vr < 0.1 )
        {
            level.player playrumbleonentity( "hunter_fly" );
            wait 0.35;
            continue;
        }
        
        time = randomfloatrange( 0.1, 0.2 );
        earthquake( randomfloatrange( 0.1, 0.15 ), time, self.origin, 200 );
        level.player playrumbleonentity( "hunter_fly" );
        wait time;
    }
}

// Namespace hunter
// Params 0
// Checksum 0x10f5c715, Offset: 0x5910
// Size: 0x1a4
function hunter_self_destruct()
{
    self endon( #"death" );
    self endon( #"exit_vehicle" );
    self_destruct = 0;
    self_destruct_time = 0;
    
    while ( true )
    {
        if ( !self_destruct )
        {
            if ( level.player meleebuttonpressed() )
            {
                self_destruct = 1;
                self_destruct_time = 5;
            }
            
            wait 0.05;
            continue;
        }
        
        iprintlnbold( self_destruct_time );
        wait 1;
        self_destruct_time -= 1;
        
        if ( self_destruct_time == 0 )
        {
            driver = self getseatoccupant( 0 );
            
            if ( isdefined( driver ) )
            {
                driver disableinvulnerability();
            }
            
            earthquake( 3, 1, self.origin, 256 );
            radiusdamage( self.origin, 1000, 15000, 15000, level.player, "MOD_EXPLOSIVE" );
            self dodamage( self.health + 1000, self.origin );
        }
        
        continue;
    }
}

// Namespace hunter
// Params 0
// Checksum 0x12a28aa9, Offset: 0x5ac0
// Size: 0xf0
function hunter_level_out_for_landing()
{
    self endon( #"death" );
    self endon( #"emped" );
    self endon( #"landed" );
    
    while ( isdefined( self.emped ) )
    {
        velocity = self.velocity;
        self.angles = ( self.angles[ 0 ] * 0.85, self.angles[ 1 ], self.angles[ 2 ] * 0.85 );
        ang_vel = self getangularvelocity() * 0.85;
        self setangularvelocity( ang_vel );
        self setvehvelocity( velocity );
        wait 0.05;
    }
}

// Namespace hunter
// Params 1
// Checksum 0xb78645a1, Offset: 0x5bb8
// Size: 0x64
function hunter_emped( params )
{
    self endon( #"death" );
    self endon( #"emped" );
    self.emped = 1;
    wait randomfloatrange( 4, 7 );
    self vehicle_ai::evaluate_connections();
}

// Namespace hunter
// Params 4
// Checksum 0x885364e1, Offset: 0x5c28
// Size: 0x1c8
function hunter_pain_for_time( time, velocitystablizeparam, rotationstablizeparam, restorelookpoint )
{
    self endon( #"death" );
    self.painstarttime = gettime();
    
    if ( !( isdefined( self.inpain ) && self.inpain ) )
    {
        self.inpain = 1;
        
        while ( gettime() < self.painstarttime + time * 1000 )
        {
            self setvehvelocity( self.velocity * velocitystablizeparam );
            self setangularvelocity( self getangularvelocity() * rotationstablizeparam );
            wait 0.1;
        }
        
        if ( isdefined( restorelookpoint ) )
        {
            restorelookent = spawn( "script_model", restorelookpoint );
            restorelookent setmodel( "tag_origin" );
            self clearlookatent();
            self setlookatent( restorelookent );
            self setturrettargetent( restorelookent );
            wait 1.5;
            self clearlookatent();
            self clearturrettarget();
            restorelookent delete();
        }
        
        self.inpain = 0;
    }
}

// Namespace hunter
// Params 6
// Checksum 0x5972b480, Offset: 0x5df8
// Size: 0x1ec
function hunter_pain_small( eattacker, damagetype, hitpoint, hitdirection, hitlocationinfo, partname )
{
    if ( !isdefined( hitpoint ) || !isdefined( hitdirection ) )
    {
        return;
    }
    
    self setvehvelocity( self.velocity + vectornormalize( hitdirection ) * 20 );
    
    if ( !( isdefined( self.inpain ) && self.inpain ) )
    {
        vecright = anglestoright( self.angles );
        sign = math::sign( vectordot( vecright, hitdirection ) );
        yaw_vel = sign * randomfloatrange( 100, 140 );
        ang_vel = self getangularvelocity();
        ang_vel += ( randomfloatrange( -120, -100 ), yaw_vel, randomfloatrange( -100, 100 ) );
        self setangularvelocity( ang_vel );
        self thread hunter_pain_for_time( 1.5, 1, 0.8 );
    }
    
    self vehicle_ai::set_state( "strafe" );
}

// Namespace hunter
// Params 15
// Checksum 0x28a9f65a, Offset: 0x5ff0
// Size: 0x290
function huntercallback_vehicledamage( einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal )
{
    driver = self getseatoccupant( 0 );
    
    if ( isdefined( eattacker ) && eattacker.team == self.team )
    {
        return 0;
    }
    
    num_players = getplayers().size;
    maxdamage = self.healthdefault * ( 0.35 - 0.025 * num_players );
    
    if ( smeansofdeath !== "MOD_UNKNOWN" && idamage > maxdamage )
    {
        idamage = maxdamage;
    }
    
    if ( !isdefined( self.damagelevel ) )
    {
        self.damagelevel = 0;
        self.newdamagelevel = self.damagelevel;
    }
    
    newdamagelevel = vehicle::should_update_damage_fx_level( self.health, idamage, self.healthdefault );
    
    if ( newdamagelevel > self.damagelevel )
    {
        self.newdamagelevel = newdamagelevel;
    }
    
    if ( self.newdamagelevel > self.damagelevel )
    {
        self.damagelevel = self.newdamagelevel;
        
        if ( self.pain_when_damagelevel_change === 1 )
        {
            hunter_pain_small( eattacker, smeansofdeath, vpoint, vdir, shitloc, partname );
        }
        
        vehicle::set_damage_fx_level( self.damagelevel );
    }
    
    if ( vehicle_ai::should_emp( self, weapon, smeansofdeath, einflictor, eattacker ) )
    {
        hunter_pain_small( eattacker, smeansofdeath, vpoint, vdir, shitloc, partname );
    }
    
    return idamage;
}

