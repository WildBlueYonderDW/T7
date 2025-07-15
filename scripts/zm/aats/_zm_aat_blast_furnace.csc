#using scripts/shared/aat_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/system_shared;

#namespace zm_aat_blast_furnace;

// Namespace zm_aat_blast_furnace
// Params 0, eflags: 0x2
// Checksum 0xd0f7f4e4, Offset: 0x208
// Size: 0x34
function autoexec __init__sytem__()
{
    system::register( "zm_aat_blast_furnace", &__init__, undefined, undefined );
}

// Namespace zm_aat_blast_furnace
// Params 0
// Checksum 0xcc7fffcc, Offset: 0x248
// Size: 0x19e
function __init__()
{
    if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
    {
        return;
    }
    
    aat::register( "zm_aat_blast_furnace", "zmui_zm_aat_blast_furnace", "t7_icon_zm_aat_blast_furnace" );
    clientfield::register( "actor", "zm_aat_blast_furnace" + "_explosion", 1, 1, "counter", &zm_aat_blast_furnace_explosion, 0, 0 );
    clientfield::register( "vehicle", "zm_aat_blast_furnace" + "_explosion_vehicle", 1, 1, "counter", &zm_aat_blast_furnace_explosion_vehicle, 0, 0 );
    clientfield::register( "actor", "zm_aat_blast_furnace" + "_burn", 1, 1, "counter", &zm_aat_blast_furnace_burn, 0, 0 );
    clientfield::register( "vehicle", "zm_aat_blast_furnace" + "_burn_vehicle", 1, 1, "counter", &zm_aat_blast_furnace_burn_vehicle, 0, 0 );
    level._effect[ "zm_aat_blast_furnace" ] = "zombie/fx_aat_blast_furnace_zmb";
}

// Namespace zm_aat_blast_furnace
// Params 7
// Checksum 0xcd864aef, Offset: 0x3f0
// Size: 0xc4
function zm_aat_blast_furnace_explosion( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump )
{
    playsound( 0, "wpn_aat_blastfurnace_explo", self.origin );
    s_aat_blast_furnace_explosion = spawnstruct();
    s_aat_blast_furnace_explosion.origin = self.origin;
    s_aat_blast_furnace_explosion.angles = self.angles;
    s_aat_blast_furnace_explosion thread zm_aat_blast_furnace_explosion_think( localclientnum );
}

// Namespace zm_aat_blast_furnace
// Params 7
// Checksum 0x94a81634, Offset: 0x4c0
// Size: 0xc4
function zm_aat_blast_furnace_explosion_vehicle( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump )
{
    playsound( 0, "wpn_aat_blastfurnace_explo", self.origin );
    s_aat_blast_furnace_explosion = spawnstruct();
    s_aat_blast_furnace_explosion.origin = self.origin;
    s_aat_blast_furnace_explosion.angles = self.angles;
    s_aat_blast_furnace_explosion thread zm_aat_blast_furnace_explosion_think( localclientnum );
}

// Namespace zm_aat_blast_furnace
// Params 1
// Checksum 0x24f5845d, Offset: 0x590
// Size: 0xae
function zm_aat_blast_furnace_explosion_think( localclientnum )
{
    angles = self.angles;
    
    if ( lengthsquared( angles ) < 0.001 )
    {
        angles = ( 1, 0, 0 );
    }
    
    self.fx_aat_blast_furnace_explode = playfx( localclientnum, "zombie/fx_aat_blast_furnace_zmb", self.origin, angles );
    wait 2.5;
    stopfx( localclientnum, self.fx_aat_blast_furnace_explode );
    self.fx_aat_blast_furnace_explode = undefined;
}

// Namespace zm_aat_blast_furnace
// Params 7
// Checksum 0xc1cce69, Offset: 0x648
// Size: 0xac
function zm_aat_blast_furnace_burn( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump )
{
    tag = "j_spine4";
    v_tag = self gettagorigin( tag );
    
    if ( !isdefined( v_tag ) )
    {
        tag = "tag_origin";
    }
    
    level thread zm_aat_blast_furnace_burn_think( localclientnum, self, tag );
}

// Namespace zm_aat_blast_furnace
// Params 7
// Checksum 0xa860803b, Offset: 0x700
// Size: 0xac
function zm_aat_blast_furnace_burn_vehicle( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump )
{
    tag = "tag_body";
    v_tag = self gettagorigin( tag );
    
    if ( !isdefined( v_tag ) )
    {
        tag = "tag_origin";
    }
    
    level thread zm_aat_blast_furnace_burn_think( localclientnum, self, tag );
}

// Namespace zm_aat_blast_furnace
// Params 3
// Checksum 0x590d4a43, Offset: 0x7b8
// Size: 0xcc
function zm_aat_blast_furnace_burn_think( localclientnum, e_zombie, tag )
{
    e_zombie.fx_aat_blast_furnace_burn = playfxontag( localclientnum, "zombie/fx_bgb_burned_out_fire_torso_zmb", e_zombie, tag );
    e_zombie playloopsound( "chr_burn_npc_loop1", 0.5 );
    e_zombie waittill( #"entityshutdown" );
    
    if ( isdefined( e_zombie ) )
    {
        e_zombie stopallloopsounds( 1.5 );
        stopfx( localclientnum, e_zombie.fx_aat_blast_furnace_burn );
    }
}

