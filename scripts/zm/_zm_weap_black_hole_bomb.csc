#using scripts/codescripts/struct;
#using scripts/shared/ai/zombie_vortex;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/system_shared;
#using scripts/shared/util_shared;
#using scripts/shared/visionset_mgr_shared;
#using scripts/zm/_zm;
#using scripts/zm/_zm_weapons;

#namespace zm_weap_black_hole_bomb;

// Namespace zm_weap_black_hole_bomb
// Params 0, eflags: 0x2
// Checksum 0xacd98a2a, Offset: 0x390
// Size: 0x34
function autoexec __init__sytem__()
{
    system::register( "zm_weap_black_hole_bomb", &__init__, undefined, undefined );
}

// Namespace zm_weap_black_hole_bomb
// Params 0
// Checksum 0x59e6f1eb, Offset: 0x3d0
// Size: 0x1bc
function __init__()
{
    level._effect[ "black_hole_bomb_portal" ] = "dlc5/cosmo/fx_zmb_blackhole_looping";
    level._effect[ "black_hole_bomb_event_horizon" ] = "dlc5/cosmo/fx_zmb_blackhole_implode";
    level._effect[ "black_hole_bomb_marker_flare" ] = "dlc5/cosmo/fx_zmb_blackhole_flare_marker";
    level._effect[ "black_hole_bomb_zombie_pull" ] = "dlc5/cosmo/fx_blackhole_zombie_breakup";
    level._current_black_hole_bombs = [];
    level._visionset_black_hole_bomb = "zombie_cosmodrome_blackhole";
    level._visionset_black_hole_bomb_transition_time_in = 2;
    level._visionset_black_hole_bomb_transition_time_out = 1;
    level._visionset_black_hole_bomb_priority = 10;
    visionset_mgr::register_visionset_info( "zombie_cosmodrome_blackhole", 21000, 30, undefined, "zombie_cosmodrome_blackhole" );
    clientfield::register( "toplayer", "bhb_viewlights", 21000, 2, "int", &bhb_viewlights, 0, 0 );
    clientfield::register( "scriptmover", "toggle_black_hole_deployed", 21000, 1, "int", &black_hole_deployed, 0, 0 );
    clientfield::register( "actor", "toggle_black_hole_being_pulled", 21000, 1, "int", &black_hole_zombie_being_pulled, 0, 1 );
}

// Namespace zm_weap_black_hole_bomb
// Params 7
// Checksum 0xff77edf9, Offset: 0x598
// Size: 0xa4
function bhb_viewlights( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump )
{
    if ( newval )
    {
        self mapshaderconstant( localclientnum, 0, "scriptVector2", 0, 100, newval, 0 );
        return;
    }
    
    self mapshaderconstant( localclientnum, 0, "scriptVector2", 0, 0, 0, 0 );
}

// Namespace zm_weap_black_hole_bomb
// Params 7
// Checksum 0x933466e6, Offset: 0x648
// Size: 0xae
function black_hole_deployed( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( localclientnum != 0 )
    {
        return;
    }
    
    players = getlocalplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        level thread black_hole_fx_start( i, self );
    }
}

// Namespace zm_weap_black_hole_bomb
// Params 2
// Checksum 0xaf4a9b68, Offset: 0x700
// Size: 0x224
function black_hole_fx_start( local_client_num, ent_bomb )
{
    bomb_fx_spot = spawn( local_client_num, ent_bomb.origin, "script_model" );
    bomb_fx_spot setmodel( "tag_origin" );
    playsound( 0, "wpn_bhbomb_portal_start", bomb_fx_spot.origin );
    bomb_fx_spot.sndlooper = bomb_fx_spot playloopsound( "wpn_bhbomb_portal_loop" );
    playfxontag( local_client_num, level._effect[ "black_hole_bomb_portal" ], bomb_fx_spot, "tag_origin" );
    playfxontag( local_client_num, level._effect[ "black_hole_bomb_marker_flare" ], bomb_fx_spot, "tag_origin" );
    ent_bomb waittill( #"entityshutdown" );
    
    if ( isdefined( bomb_fx_spot.sndlooper ) )
    {
        bomb_fx_spot stoploopsound( bomb_fx_spot.sndlooper );
    }
    
    event_horizon_spot = spawn( local_client_num, bomb_fx_spot.origin, "script_model" );
    event_horizon_spot setmodel( "tag_origin" );
    bomb_fx_spot delete();
    playfxontag( local_client_num, level._effect[ "black_hole_bomb_event_horizon" ], event_horizon_spot, "tag_origin" );
    wait 0.2;
    event_horizon_spot delete();
}

// Namespace zm_weap_black_hole_bomb
// Params 2
// Checksum 0x726acbc3, Offset: 0x930
// Size: 0xa4
function black_hole_activated( ent_model, int_local_client_num )
{
    new_black_hole_struct = spawnstruct();
    new_black_hole_struct.origin = ent_model.origin;
    new_black_hole_struct._black_hole_active = 1;
    array::add( level._current_black_hole_bombs, new_black_hole_struct );
    ent_model waittill( #"entityshutdown" );
    new_black_hole_struct._black_hole_active = 0;
    wait 0.2;
}

// Namespace zm_weap_black_hole_bomb
// Params 7
// Checksum 0xab804352, Offset: 0x9e0
// Size: 0x1e4
function black_hole_zombie_being_pulled( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    self endon( #"death" );
    self endon( #"entityshutdown" );
    
    if ( localclientnum != 0 )
    {
        return;
    }
    
    if ( newval )
    {
        self._bhb_pulled_in_fx = spawn( localclientnum, self.origin, "script_model" );
        self._bhb_pulled_in_fx.angles = self.angles;
        self._bhb_pulled_in_fx linkto( self, "tag_origin" );
        self._bhb_pulled_in_fx setmodel( "tag_origin" );
        level thread black_hole_bomb_pulled_in_fx_clean( self, self._bhb_pulled_in_fx );
        players = getlocalplayers();
        
        for ( i = 0; i < players.size ; i++ )
        {
            playfxontag( i, level._effect[ "black_hole_bomb_zombie_pull" ], self._bhb_pulled_in_fx, "tag_origin" );
        }
        
        return;
    }
    
    if ( isdefined( self._bhb_pulled_in_fx ) )
    {
        self._bhb_pulled_in_fx notify( #"no_clean_up_needed" );
        self._bhb_pulled_in_fx unlink();
        self._bhb_pulled_in_fx delete();
    }
}

// Namespace zm_weap_black_hole_bomb
// Params 2
// Checksum 0x675d8ea9, Offset: 0xbd0
// Size: 0x5c
function black_hole_bomb_pulled_in_fx_clean( ent_zombie, ent_fx_origin )
{
    ent_fx_origin endon( #"no_clean_up_needed" );
    
    if ( !isdefined( ent_zombie ) )
    {
        return;
    }
    
    ent_zombie waittill( #"entityshutdown" );
    
    if ( isdefined( ent_fx_origin ) )
    {
        ent_fx_origin delete();
    }
}

