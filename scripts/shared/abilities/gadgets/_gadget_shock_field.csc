#using scripts/codescripts/struct;
#using scripts/shared/abilities/_ability_player;
#using scripts/shared/abilities/_ability_power;
#using scripts/shared/abilities/_ability_util;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/duplicaterender_mgr;
#using scripts/shared/filter_shared;
#using scripts/shared/system_shared;
#using scripts/shared/util_shared;
#using scripts/shared/visionset_mgr_shared;

#namespace _gadget_shock_field;

// Namespace _gadget_shock_field
// Params 0, eflags: 0x2
// Checksum 0xed55d009, Offset: 0x2a0
// Size: 0x34
function autoexec __init__sytem__()
{
    system::register( "gadget_shock_field", &__init__, undefined, undefined );
}

// Namespace _gadget_shock_field
// Params 0
// Checksum 0xf1c73c81, Offset: 0x2e0
// Size: 0x58
function __init__()
{
    clientfield::register( "allplayers", "shock_field", 1, 1, "int", &player_shock_changed, 0, 1 );
    level.shock_field_fx = [];
}

// Namespace _gadget_shock_field
// Params 1
// Checksum 0x73cf8c00, Offset: 0x340
// Size: 0x58
function is_local_player( localclientnum )
{
    player_view = getlocalplayer( localclientnum );
    
    if ( !isdefined( player_view ) )
    {
        return 0;
    }
    
    sameentity = self == player_view;
    return sameentity;
}

// Namespace _gadget_shock_field
// Params 7
// Checksum 0x1f156b61, Offset: 0x3a0
// Size: 0x150
function player_shock_changed( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump )
{
    entid = getlocalplayer( localclientnum ) getentitynumber();
    
    if ( newval )
    {
        if ( !isdefined( level.shock_field_fx[ entid ] ) )
        {
            fx = "player/fx_plyr_shock_field";
            
            if ( is_local_player( localclientnum ) )
            {
                fx = "player/fx_plyr_shock_field_1p";
            }
            
            tag = "j_spinelower";
            level.shock_field_fx[ entid ] = playfxontag( localclientnum, fx, self, tag );
        }
        
        return;
    }
    
    if ( isdefined( level.shock_field_fx[ entid ] ) )
    {
        stopfx( localclientnum, level.shock_field_fx[ entid ] );
        level.shock_field_fx[ entid ] = undefined;
    }
}

