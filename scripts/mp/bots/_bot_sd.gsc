#using scripts/mp/bots/_bot;
#using scripts/mp/bots/_bot_combat;
#using scripts/mp/gametypes/_globallogic_utils;
#using scripts/shared/array_shared;
#using scripts/shared/bots/_bot;
#using scripts/shared/bots/_bot_combat;
#using scripts/shared/bots/bot_buttons;
#using scripts/shared/gameobjects_shared;
#using scripts/shared/math_shared;
#using scripts/shared/util_shared;

#namespace bot_sd;

// Namespace bot_sd
// Params 0
// Checksum 0xfe20f631, Offset: 0x1c8
// Size: 0x1c
function init()
{
    level.botidle = &bot_idle;
}

// Namespace bot_sd
// Params 0
// Checksum 0x4c5c965d, Offset: 0x1f0
// Size: 0x544
function bot_idle()
{
    if ( !level.bombplanted && !level.multibomb && self.team == game[ "attackers" ] )
    {
        carrier = level.sdbomb gameobjects::get_carrier();
        
        if ( !isdefined( carrier ) )
        {
            self botsetgoal( level.sdbomb.trigger.origin );
            self bot::sprint_to_goal();
            return;
        }
    }
    
    approachradiussq = 562500;
    
    foreach ( zone in level.bombzones )
    {
        if ( isdefined( level.bombplanted ) && level.bombplanted && !( isdefined( zone.isplanted ) && zone.isplanted ) )
        {
            continue;
        }
        
        zonetrigger = self get_zone_trigger( zone );
        
        if ( self istouching( zonetrigger ) )
        {
            if ( self can_plant( zone ) || self can_defuse( zone ) )
            {
                self bot::press_use_button();
                return;
            }
        }
        
        if ( distancesquared( self.origin, zone.trigger.origin ) < approachradiussq )
        {
            if ( self can_plant( zone ) || self can_defuse( zone ) )
            {
                self bot::path_to_trigger( zonetrigger );
                self bot::sprint_to_goal();
                return;
            }
        }
    }
    
    zones = array::randomize( level.bombzones );
    
    foreach ( zone in zones )
    {
        if ( isdefined( level.bombplanted ) && level.bombplanted && !( isdefined( zone.isplanted ) && zone.isplanted ) )
        {
            continue;
        }
        
        if ( self can_defuse( zone ) )
        {
            self bot::approach_goal_trigger( zonetrigger, 750 );
            self bot::sprint_to_goal();
            return;
        }
    }
    
    foreach ( zone in zones )
    {
        if ( isdefined( level.bombplanted ) && level.bombplanted && !( isdefined( zone.isplanted ) && zone.isplanted ) )
        {
            continue;
        }
        
        if ( distancesquared( self.origin, zone.trigger.origin ) < approachradiussq && randomint( 100 ) < 70 )
        {
            triggerradius = self bot::get_trigger_radius( zone.trigger );
            self bot::approach_point( zone.trigger.origin, triggerradius, 750 );
            self bot::sprint_to_goal();
            return;
        }
    }
    
    self bot::bot_idle();
}

// Namespace bot_sd
// Params 1
// Checksum 0xa5c6b1d4, Offset: 0x740
// Size: 0x4e
function get_zone_trigger( zone )
{
    if ( self.team == zone gameobjects::get_owner_team() )
    {
        return zone.bombdefusetrig;
    }
    
    return zone.trigger;
}

// Namespace bot_sd
// Params 1
// Checksum 0x9b949b38, Offset: 0x798
// Size: 0x92, Type: bool
function can_plant( zone )
{
    if ( level.multibomb )
    {
        return ( !( isdefined( zone.isplanted ) && zone.isplanted ) && self.team != zone gameobjects::get_owner_team() );
    }
    
    carrier = level.sdbomb gameobjects::get_carrier();
    return isdefined( carrier ) && self == carrier;
}

// Namespace bot_sd
// Params 1
// Checksum 0x5d98de95, Offset: 0x838
// Size: 0x54, Type: bool
function can_defuse( zone )
{
    return isdefined( zone.isplanted ) && zone.isplanted && self.team == zone gameobjects::get_owner_team();
}

