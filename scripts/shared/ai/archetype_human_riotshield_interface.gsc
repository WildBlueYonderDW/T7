#using scripts/shared/ai/archetype_human_riotshield;
#using scripts/shared/ai/systems/ai_interface;

#namespace humanriotshieldinterface;

// Namespace humanriotshieldinterface
// Params 0
// Checksum 0xb3adaaba, Offset: 0x188
// Size: 0x1ec
function registerhumanriotshieldinterfaceattributes()
{
    ai::registermatchedinterface( "human_riotshield", "can_be_meleed", 1, array( 1, 0 ) );
    ai::registermatchedinterface( "human_riotshield", "can_melee", 1, array( 1, 0 ) );
    ai::registermatchedinterface( "human_riotshield", "can_initiateaivsaimelee", 1, array( 1, 0 ) );
    ai::registermatchedinterface( "human_riotshield", "coverIdleOnly", 0, array( 1, 0 ) );
    ai::registermatchedinterface( "human_riotshield", "phalanx", 0, array( 1, 0 ) );
    ai::registermatchedinterface( "human_riotshield", "phalanx_force_stance", "normal", array( "normal", "stand", "crouch" ) );
    ai::registermatchedinterface( "human_riotshield", "sprint", 0, array( 1, 0 ) );
    ai::registermatchedinterface( "human_riotshield", "attack_mode", "normal", array( "normal", "unarmed" ) );
}

