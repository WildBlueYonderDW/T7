#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/laststand_shared;
#using scripts/shared/trigger_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_laststand;
#using scripts/zm/_zm_score;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_unitrigger;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_weapons;
#using scripts/zm/craftables/_zm_craftables;
#using scripts/zm/zm_stalingrad_vo;

#namespace zm_stalingrad_craftables;

// Namespace zm_stalingrad_craftables
// Params 0
// Checksum 0xfd679755, Offset: 0x580
// Size: 0x384
function include_craftables()
{
    level.craftable_piece_swap_allowed = 0;
    shared_pieces = getnumexpectedplayers() == 1;
    craftable_name = "dragonride";
    var_67638a1e = zm_craftables::generate_zombie_craftable_piece( craftable_name, "part_transmitter", 64, 64, 0, undefined, &function_6545e739, undefined, &function_7de936c2, undefined, undefined, undefined, "dragonride" + "_" + "part_transmitter", 1, undefined, undefined, &"ZM_STALINGRAD_DRAGONRIDE_TRANSMITTER", 1 );
    var_a4054f7d = zm_craftables::generate_zombie_craftable_piece( craftable_name, "part_codes", 64, 64, 0, undefined, &function_6545e739, undefined, &function_7de936c2, undefined, undefined, undefined, "dragonride" + "_" + "part_codes", 1, undefined, undefined, &"ZM_STALINGRAD_DRAGONRIDE_CODES", 1 );
    var_a9ad06c5 = zm_craftables::generate_zombie_craftable_piece( craftable_name, "part_map", 64, 64, 0, undefined, &function_6545e739, undefined, &function_7de936c2, undefined, undefined, undefined, "dragonride" + "_" + "part_map", 1, undefined, undefined, &"ZM_STALINGRAD_DRAGONRIDE_MAP", 1 );
    var_67638a1e.client_field_state = undefined;
    var_a4054f7d.client_field_state = undefined;
    var_a9ad06c5.client_field_state = undefined;
    dragonride = spawnstruct();
    dragonride.name = craftable_name;
    dragonride zm_craftables::add_craftable_piece( var_a4054f7d, "tag_dragon_network_console_part01_socket" );
    dragonride zm_craftables::add_craftable_piece( var_67638a1e, "tag_dragon_network_console_part02_socket" );
    dragonride zm_craftables::add_craftable_piece( var_a9ad06c5, "tag_dragon_network_console_part03_socket" );
    dragonride.triggerthink = &function_16bbd78d;
    zm_craftables::include_zombie_craftable( dragonride );
    level flag::init( craftable_name + "_" + "part_transmitter" + "_found" );
    level flag::init( craftable_name + "_" + "part_codes" + "_found" );
    level flag::init( craftable_name + "_" + "part_map" + "_found" );
    level flag::init( "dragonride_crafted" );
}

// Namespace zm_stalingrad_craftables
// Params 0
// Checksum 0x2bc26657, Offset: 0x910
// Size: 0x3c
function function_16bbd78d()
{
    zm_craftables::craftable_trigger_think( "dragonride_zm_craftable_trigger", "dragonride", "dragonride", "", 1, 0 );
}

// Namespace zm_stalingrad_craftables
// Params 0
// Checksum 0xd644cb81, Offset: 0x958
// Size: 0x84
function init_craftables()
{
    register_clientfields();
    zm_craftables::add_zombie_craftable( "dragonride", &"ZM_STALINGRAD_DRAGONRIDE_CRAFT", "", "", &function_39c3c699 );
    zm_craftables::set_build_time( "dragonride", 0 );
    level thread function_d7eb8f21();
}

// Namespace zm_stalingrad_craftables
// Params 0
// Checksum 0x87cdb941, Offset: 0x9e8
// Size: 0x17c
function register_clientfields()
{
    shared_bits = 1;
    registerclientfield( "world", "dragonride" + "_" + "part_transmitter", 12000, shared_bits, "int", undefined, 0 );
    registerclientfield( "world", "dragonride" + "_" + "part_codes", 12000, shared_bits, "int", undefined, 0 );
    registerclientfield( "world", "dragonride" + "_" + "part_map", 12000, shared_bits, "int", undefined, 0 );
    clientfield::register( "toplayer", "ZMUI_DRAGONRIDE_PART_PICKUP", 12000, 1, "int" );
    clientfield::register( "toplayer", "ZMUI_DRAGONRIDE_CRAFTED", 12000, 1, "int" );
    clientfield::register( "clientuimodel", "zmInventory.widget_dragonride_parts", 12000, 1, "int" );
}

// Namespace zm_stalingrad_craftables
// Params 1
// Checksum 0x39e83562, Offset: 0xb70
// Size: 0x1f4
function function_6545e739( player )
{
    level flag::set( self.craftablename + "_" + self.piecename + "_found" );
    level notify( #"hash_8d3f0071" );
    level.var_583e4a97.var_365bcb3c++;
    
    if ( isdefined( level.var_583e4a97.s_radio ) )
    {
        level.var_583e4a97.s_radio.b_used = 1;
    }
    
    str_piece = self.piecename;
    
    foreach ( e_player in level.players )
    {
        e_player thread show_infotext_for_duration( "ZMUI_DRAGONRIDE_PART_PICKUP", 3.5 );
        
        switch ( str_piece )
        {
            default:
                e_player thread zm_craftables::player_show_craftable_parts_ui( "zmInventory.dragonride_part_transmitter", "zmInventory.widget_dragonride_parts", 0 );
                break;
            case "part_codes":
                e_player thread zm_craftables::player_show_craftable_parts_ui( "zmInventory.dragonride_part_codes", "zmInventory.widget_dragonride_parts", 0 );
                break;
            case "part_map":
                e_player thread zm_craftables::player_show_craftable_parts_ui( "zmInventory.dragonride_part_map", "zmInventory.widget_dragonride_parts", 0 );
                break;
        }
    }
    
    player thread zm_stalingrad_vo::function_5adc22c7();
}

// Namespace zm_stalingrad_craftables
// Params 1
// Checksum 0xef7f0bb2, Offset: 0xd70
// Size: 0x5c
function function_7de936c2( player )
{
    var_a23d8924 = getent( "dragonride_fuse_box", "targetname" );
    
    if ( isdefined( var_a23d8924 ) )
    {
        var_a23d8924 playsound( "zmb_zod_fuse_place" );
    }
}

// Namespace zm_stalingrad_craftables
// Params 0
// Checksum 0x4c4c03b0, Offset: 0xdd8
// Size: 0xb8, Type: bool
function function_39c3c699()
{
    level flag::set( "dragonride_crafted" );
    zm_spawner::register_zombie_death_event_callback();
    var_a21e2a98 = getent( "dragonride_fuse_box", "targetname" );
    var_a21e2a98 hidepart( "tag_dragon_network_console_screen_red" );
    var_a21e2a98 showpart( "tag_dragon_network_console_screen_green" );
    level thread zm_stalingrad_vo::function_6576bb4b();
    return true;
}

// Namespace zm_stalingrad_craftables
// Params 1
// Checksum 0x96ba6d0c, Offset: 0xe98
// Size: 0x24, Type: bool
function function_7b29071e( player )
{
    return !flag::get( "dragonride_crafted" );
}

// Namespace zm_stalingrad_craftables
// Params 2
// Checksum 0xd193a5a1, Offset: 0xec8
// Size: 0x54
function show_infotext_for_duration( str_infotext, n_duration )
{
    self clientfield::set_to_player( str_infotext, 1 );
    wait n_duration;
    self clientfield::set_to_player( str_infotext, 0 );
}

// Namespace zm_stalingrad_craftables
// Params 0
// Checksum 0x25261cfd, Offset: 0xf28
// Size: 0xa4
function function_f5b7f61a()
{
    while ( true )
    {
        self waittill( #"trigger", player );
        
        if ( player zm_utility::in_revive_trigger() )
        {
            continue;
        }
        
        if ( player.is_drinking > 0 )
        {
            continue;
        }
        
        if ( !zm_utility::is_player_valid( player ) )
        {
            continue;
        }
        
        level thread function_59a8fb49( self.stub, player );
        break;
    }
}

// Namespace zm_stalingrad_craftables
// Params 2
// Checksum 0x48497906, Offset: 0xfd8
// Size: 0x14
function function_59a8fb49( trig_stub, player )
{
    
}

// Namespace zm_stalingrad_craftables
// Params 0
// Checksum 0x5251d626, Offset: 0xff8
// Size: 0xb8
function function_d7eb8f21()
{
    while ( true )
    {
        level waittill( #"shield_built", e_who );
        
        if ( e_who.characterindex == 0 )
        {
            var_4c5a66ad = 4;
        }
        else
        {
            var_4c5a66ad = 5;
        }
        
        str_vo_line = "vox_plr_" + e_who.characterindex + "_dragon_shield_acquire_" + randomint( var_4c5a66ad );
        e_who zm_stalingrad_vo::function_897246e4( str_vo_line );
    }
}

