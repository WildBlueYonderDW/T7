#using scripts/shared/ai/archetype_apothicon_fury;
#using scripts/shared/ai/archetype_utility;
#using scripts/shared/ai/systems/ai_blackboard;
#using scripts/shared/ai/systems/ai_interface;
#using scripts/shared/ai/systems/behavior_tree_utility;
#using scripts/shared/ai/systems/blackboard;
#using scripts/shared/util_shared;

#namespace apothiconfuryinterface;

// Namespace apothiconfuryinterface
// Params 0
// Checksum 0xaea2fca8, Offset: 0x210
// Size: 0x114
function registerapothiconfuryinterfaceattributes()
{
    ai::registermatchedinterface( "apothicon_fury", "can_juke", 1, array( 1, 0 ) );
    ai::registermatchedinterface( "apothicon_fury", "can_bamf", 1, array( 1, 0 ) );
    ai::registermatchedinterface( "apothicon_fury", "can_be_furious", 1, array( 1, 0 ) );
    ai::registermatchedinterface( "apothicon_fury", "move_speed", "walk", array( "walk", "run", "sprint", "super_sprint" ), &apothiconfurybehaviorinterface::movespeedattributecallback );
}

