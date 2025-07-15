#using scripts/codescripts/struct;
#using scripts/shared/abilities/_ability_player;
#using scripts/shared/abilities/_ability_util;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flagsys_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/system_shared;
#using scripts/shared/util_shared;

#namespace _gadget_concussive_wave;

// Namespace _gadget_concussive_wave
// Params 0, eflags: 0x2
// Checksum 0x64d5294a, Offset: 0x208
// Size: 0x34
function autoexec __init__sytem__()
{
    system::register( "gadget_concussive_wave", &__init__, undefined, undefined );
}

// Namespace _gadget_concussive_wave
// Params 0
// Checksum 0xb71919aa, Offset: 0x248
// Size: 0x104
function __init__()
{
    ability_player::register_gadget_activation_callbacks( 27, &gadget_concussive_wave_on, &gadget_concussive_wave_off );
    ability_player::register_gadget_possession_callbacks( 27, &gadget_concussive_wave_on_give, &gadget_concussive_wave_on_take );
    ability_player::register_gadget_flicker_callbacks( 27, &gadget_concussive_wave_on_flicker );
    ability_player::register_gadget_is_inuse_callbacks( 27, &gadget_concussive_wave_is_inuse );
    ability_player::register_gadget_is_flickering_callbacks( 27, &gadget_concussive_wave_is_flickering );
    ability_player::register_gadget_primed_callbacks( 27, &gadget_concussive_wave_is_primed );
    callback::on_connect( &gadget_concussive_wave_on_connect );
}

// Namespace _gadget_concussive_wave
// Params 1
// Checksum 0xa1f9988a, Offset: 0x358
// Size: 0x2a
function gadget_concussive_wave_is_inuse( slot )
{
    return self flagsys::get( "gadget_concussive_wave_on" );
}

// Namespace _gadget_concussive_wave
// Params 1
// Checksum 0x49c1803, Offset: 0x390
// Size: 0x52
function gadget_concussive_wave_is_flickering( slot )
{
    if ( isdefined( level.cybercom ) && isdefined( level.cybercom.concussive_wave ) )
    {
        return self [[ level.cybercom.concussive_wave._is_flickering ]]( slot );
    }
    
    return 0;
}

// Namespace _gadget_concussive_wave
// Params 2
// Checksum 0x9a0380ce, Offset: 0x3f0
// Size: 0x5c
function gadget_concussive_wave_on_flicker( slot, weapon )
{
    if ( isdefined( level.cybercom ) && isdefined( level.cybercom.concussive_wave ) )
    {
        self [[ level.cybercom.concussive_wave._on_flicker ]]( slot, weapon );
    }
}

// Namespace _gadget_concussive_wave
// Params 2
// Checksum 0xc9b81509, Offset: 0x458
// Size: 0x5c
function gadget_concussive_wave_on_give( slot, weapon )
{
    if ( isdefined( level.cybercom ) && isdefined( level.cybercom.concussive_wave ) )
    {
        self [[ level.cybercom.concussive_wave._on_give ]]( slot, weapon );
    }
}

// Namespace _gadget_concussive_wave
// Params 2
// Checksum 0x6c92f5f8, Offset: 0x4c0
// Size: 0x5c
function gadget_concussive_wave_on_take( slot, weapon )
{
    if ( isdefined( level.cybercom ) && isdefined( level.cybercom.concussive_wave ) )
    {
        self [[ level.cybercom.concussive_wave._on_take ]]( slot, weapon );
    }
}

// Namespace _gadget_concussive_wave
// Params 0
// Checksum 0xdd2c0e16, Offset: 0x528
// Size: 0x44
function gadget_concussive_wave_on_connect()
{
    if ( isdefined( level.cybercom ) && isdefined( level.cybercom.concussive_wave ) )
    {
        self [[ level.cybercom.concussive_wave._on_connect ]]();
    }
}

// Namespace _gadget_concussive_wave
// Params 2
// Checksum 0x236d6dd8, Offset: 0x578
// Size: 0x7c
function gadget_concussive_wave_on( slot, weapon )
{
    self flagsys::set( "gadget_concussive_wave_on" );
    
    if ( isdefined( level.cybercom ) && isdefined( level.cybercom.concussive_wave ) )
    {
        self [[ level.cybercom.concussive_wave._on ]]( slot, weapon );
    }
}

// Namespace _gadget_concussive_wave
// Params 2
// Checksum 0x1f32f8a9, Offset: 0x600
// Size: 0x7c
function gadget_concussive_wave_off( slot, weapon )
{
    self flagsys::clear( "gadget_concussive_wave_on" );
    
    if ( isdefined( level.cybercom ) && isdefined( level.cybercom.concussive_wave ) )
    {
        self [[ level.cybercom.concussive_wave._off ]]( slot, weapon );
    }
}

// Namespace _gadget_concussive_wave
// Params 2
// Checksum 0xaa8b8870, Offset: 0x688
// Size: 0x5c
function gadget_concussive_wave_is_primed( slot, weapon )
{
    if ( isdefined( level.cybercom ) && isdefined( level.cybercom.concussive_wave ) )
    {
        self [[ level.cybercom.concussive_wave._is_primed ]]( slot, weapon );
    }
}

