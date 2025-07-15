#using scripts/codescripts/struct;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/trigger_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_zm;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_equipment;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_unitrigger;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_weapons;
#using scripts/zm/craftables/_zm_craftables;
#using scripts/zm/zm_stalingrad_ee_main;
#using scripts/zm/zm_stalingrad_pap_quest;
#using scripts/zm/zm_stalingrad_util;

#namespace zm_stalingrad_wearables;

/#

    // Namespace zm_stalingrad_wearables
    // Params 0
    // Checksum 0xfe5fb99d, Offset: 0xa80
    // Size: 0x54, Type: dev
    function function_ea91e52b()
    {
        adddebugcommand( "<dev string:x28>" );
        adddebugcommand( "<dev string:x79>" );
        adddebugcommand( "<dev string:xd4>" );
    }

#/

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0xdc6a3072, Offset: 0xae0
// Size: 0x4bc
function function_eed58360()
{
    /#
        if ( getdvarint( "<dev string:x12f>" ) > 0 )
        {
            level thread function_ea91e52b();
        }
    #/
    
    level.var_72cf9806 = [];
    level.var_72cf9806[ 0 ] = 3;
    level.var_72cf9806[ 1 ] = 1;
    level.var_72cf9806[ 2 ] = 4;
    level.var_72cf9806[ 3 ] = 2;
    level flag::init( "dragon_wings_items_aquired" );
    level flag::init( "dragon_platforms_all_used" );
    level flag::init( "wearables_raz_arms_complete" );
    level flag::init( "wearables_raz_mask_complete" );
    level flag::init( "wearables_sentinel_arms_complete" );
    level flag::init( "wearables_sentinel_camera_complete" );
    level.var_f090ed38 = struct::spawn();
    level.var_f090ed38.var_6755afc7 = 0;
    level.var_f090ed38.var_68da43c3 = 5;
    level.var_f090ed38.var_8fefef40 = 0;
    level.var_f090ed38.var_7c69aa76 = 5;
    level.var_f090ed38.var_24859f92 = 0;
    level.var_f090ed38.var_10d3c700 = 5;
    level.var_f090ed38.var_4da5ec78 = 0;
    level.var_f090ed38.var_e34dd99e = 5;
    level.var_f090ed38.var_f957bac3 = 0;
    level.var_f090ed38.var_c18c0bbb = 0;
    level.var_f090ed38.var_a7e89eae = 0;
    level thread function_8cde51de();
    callback::on_connect( &function_1fc9779e );
    var_b9b5d81a = struct::get( "wearable_dragon_wings", "targetname" );
    var_b9b5d81a zm_unitrigger::create_unitrigger( &"ZM_STALINGRAD_WEARABLE_WINGS_EQUIP", undefined, &function_2c1e6f00, &function_18dda0a0 );
    zm_unitrigger::unitrigger_force_per_player_triggers( var_b9b5d81a.s_unitrigger, 1 );
    level thread function_1a6de86e();
    level thread function_ac75c48f();
    level thread function_42a9380e();
    var_94cd901e = struct::get( "wearable_raz_hat", "targetname" );
    var_94cd901e zm_unitrigger::create_unitrigger( &"ZM_STALINGRAD_WEARABLE_RAZ_MASK_EQUIP", undefined, &function_449ba539, &function_ad641a9f );
    zm_unitrigger::unitrigger_force_per_player_triggers( var_94cd901e.s_unitrigger, 1 );
    level thread function_69f1fce3();
    level thread function_fe559f6c();
    level thread function_ba204ad8();
    var_494ee1d1 = struct::get( "wearable_sentinel_hat", "targetname" );
    var_494ee1d1 zm_unitrigger::create_unitrigger( &"ZM_STALINGRAD_WEARABLE_VALKYRIE_HAT_EQUIP", undefined, &function_a6595bd6, &function_f3b06f8e );
    zm_unitrigger::unitrigger_force_per_player_triggers( var_494ee1d1.s_unitrigger, 1 );
    level thread function_14b98ab6();
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0xf5de549f, Offset: 0xfa8
// Size: 0x96
function function_ad78a144()
{
    clientfield::register( "scriptmover", "show_wearable", 12000, 1, "int" );
    
    for ( i = 0; i < 4 ; i++ )
    {
        registerclientfield( "world", "player" + i + "wearableItem", 12000, 2, "int" );
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0x299ca586, Offset: 0x1048
// Size: 0x8c
function function_2436f867()
{
    self notify( #"hash_2436f867" );
    self endon( #"hash_2436f867" );
    self util::waittill_any( "disconnect", "bled_out", "death" );
    self.var_bc5f242a = undefined;
    self.str_wearable = undefined;
    level clientfield::set( "player" + self.entity_num + "wearableItem", 0 );
}

// Namespace zm_stalingrad_wearables
// Params 1
// Checksum 0x1ccc2213, Offset: 0x10e0
// Size: 0x3c
function function_793f10ed( var_908867a0 )
{
    level clientfield::set( "player" + self.entity_num + "wearableItem", var_908867a0 );
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0xf0c1bf20, Offset: 0x1128
// Size: 0xec
function function_8cde51de()
{
    a_str_flags = [];
    array::add( a_str_flags, "dragon_shield_used" );
    array::add( a_str_flags, "dragon_gauntlet_acquired" );
    array::add( a_str_flags, "dragon_strike_acquired" );
    flag::wait_till_all( a_str_flags );
    level flag::set( "dragon_wings_items_aquired" );
    
    if ( !level flag::get( "dragon_platforms_all_used" ) )
    {
        playsoundatposition( "zmb_wearable_wing_success_step", ( 0, 0, 0 ) );
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0x316d6e06, Offset: 0x1220
// Size: 0x16a
function function_1fc9779e()
{
    /#
        level endon( #"hash_b7bed0ed" );
    #/
    
    self endon( #"disconnect" );
    
    while ( true )
    {
        self waittill( #"hash_2e47bc4a" );
        
        switch ( level.var_9d19c7e )
        {
            case "judicial":
                level.var_f090ed38.var_f957bac3 = 1;
                break;
            default:
                level.var_f090ed38.var_c18c0bbb = 1;
                break;
            case "factory":
                level.var_f090ed38.var_a7e89eae = 1;
                break;
        }
        
        if ( level.var_f090ed38.var_a7e89eae && level.var_f090ed38.var_c18c0bbb && level.var_f090ed38.var_f957bac3 )
        {
            level flag::set( "dragon_platforms_all_used" );
            callback::remove_on_connect( &function_1fc9779e );
            
            if ( !level flag::get( "dragon_wings_items_aquired" ) )
            {
                playsoundatposition( "zmb_wearable_wing_success_step", ( 0, 0, 0 ) );
            }
            
            return;
        }
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0xe74d4058, Offset: 0x1398
// Size: 0x14c
function function_1a6de86e()
{
    var_20843b0d = [];
    array::add( var_20843b0d, "dragon_wings_items_aquired", 0 );
    array::add( var_20843b0d, "dragon_platforms_all_used", 0 );
    level flag::wait_till_all( var_20843b0d );
    playsoundatposition( "zmb_wearable_wing_success", ( 0, 0, 0 ) );
    var_24f783f3 = struct::get( "wearable_dragon_wings", "targetname" );
    var_24f783f3.model = spawn( "script_model", var_24f783f3.origin );
    var_24f783f3.model.angles = var_24f783f3.angles;
    var_24f783f3.model setmodel( "c_zom_dlc3_player_wings" );
    level function_484ecd5();
}

// Namespace zm_stalingrad_wearables
// Params 1
// Checksum 0x98cd440b, Offset: 0x14f0
// Size: 0xce, Type: bool
function function_2c1e6f00( e_player )
{
    if ( e_player.str_wearable === "dragon_wings" )
    {
        self sethintstring( &"ZM_STALINGRAD_WEARABLE_EQUIPPED" );
        return false;
    }
    else if ( level flag::get( "dragon_platforms_all_used" ) && level flag::get( "dragon_wings_items_aquired" ) )
    {
        self sethintstring( &"ZM_STALINGRAD_WEARABLE_WINGS_EQUIP" );
        return true;
    }
    
    self sethintstring( "" );
    return false;
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0x859dfed6, Offset: 0x15c8
// Size: 0x1a8
function function_18dda0a0()
{
    self endon( #"death" );
    
    while ( true )
    {
        self trigger::wait_till();
        player = self.who;
        player clientfield::increment_to_player( "interact_rumble" );
        
        if ( isdefined( player.var_bc5f242a ) )
        {
            player function_caffcf07();
        }
        else
        {
            player.var_bc5f242a = spawnstruct();
        }
        
        player.var_bc5f242a.model = "c_zom_dlc3_player_wings";
        player.var_bc5f242a.tag = "j_spine4";
        player function_20f2df00();
        player.str_wearable = "dragon_wings";
        player playsound( "zmb_wearable_wing_wear" );
        zm::register_player_damage_callback( &function_9c197fbf );
        player function_793f10ed( 3 );
        player thread function_2436f867();
        array::run_all( level.var_37e960a1, &showtoplayer, player );
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0xe5ac651, Offset: 0x1778
// Size: 0x1ba
function function_484ecd5()
{
    var_e48fcb77 = struct::get_array( "wings_transport_struct", "targetname" );
    level.var_37e960a1 = [];
    
    foreach ( var_c4917757 in var_e48fcb77 )
    {
        mdl_wings = util::spawn_model( var_c4917757.model, var_c4917757.origin, var_c4917757.angles );
        mdl_wings setscale( 0.3 );
        
        if ( !isdefined( level.var_37e960a1 ) )
        {
            level.var_37e960a1 = [];
        }
        else if ( !isarray( level.var_37e960a1 ) )
        {
            level.var_37e960a1 = array( level.var_37e960a1 );
        }
        
        level.var_37e960a1[ level.var_37e960a1.size ] = mdl_wings;
        mdl_wings hide();
        var_c4917757 thread function_7e873fe6();
        util::wait_network_frame();
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0xd59d7be6, Offset: 0x1940
// Size: 0xc8
function function_7e873fe6()
{
    self zm_unitrigger::create_unitrigger( "", 100, &function_9a167439 );
    zm_unitrigger::unitrigger_force_per_player_triggers( self.s_unitrigger, 1 );
    
    while ( true )
    {
        self waittill( #"trigger_activated", e_player );
        
        if ( e_player.str_wearable === "dragon_wings" )
        {
            e_player playsound( "zmb_wearable_wing_teleport" );
            e_player function_cc32e7df();
        }
    }
}

// Namespace zm_stalingrad_wearables
// Params 1
// Checksum 0x8efee36, Offset: 0x1a10
// Size: 0x66, Type: bool
function function_9a167439( e_player )
{
    if ( e_player.str_wearable === "dragon_wings" )
    {
        self sethintstring( &"ZM_STALINGRAD_WINGS_TRANSPORT" );
        return true;
    }
    
    self sethintstring( "" );
    return false;
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0x685d9e82, Offset: 0x1a80
// Size: 0x130
function function_cc32e7df()
{
    self zm_utility::increment_ignoreme();
    self.var_fa6d2a24 = 1;
    s_pavlov_player = struct::get_array( "s_pavlov_player", "targetname" );
    n_player_number = self getentitynumber();
    self dontinterpolate();
    self setorigin( s_pavlov_player[ n_player_number ].origin );
    self setplayerangles( s_pavlov_player[ n_player_number ].angles + ( 0, 180, 0 ) );
    self notify( #"hash_2e47bc4a" );
    level notify( #"hash_9a634383" );
    wait 3;
    self zm_utility::decrement_ignoreme();
    self.var_fa6d2a24 = 0;
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0x664f3f91, Offset: 0x1bb8
// Size: 0x44
function function_588ad36a()
{
    if ( self.str_wearable === "dragon_wings" )
    {
        array::run_all( level.var_37e960a1, &setinvisibletoplayer, self );
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0xf3a0af1a, Offset: 0x1c08
// Size: 0xb8
function function_42a9380e()
{
    level endon( #"wearables_raz_arms_complete" );
    
    while ( true )
    {
        level waittill( #"raz_arm_detach" );
        level.var_f090ed38.var_6755afc7++;
        
        if ( level.var_f090ed38.var_6755afc7 >= level.var_f090ed38.var_68da43c3 )
        {
            if ( !level flag::get( "wearables_raz_mask_complete" ) )
            {
                playsoundatposition( "zmb_wearable_raz_success_step", ( 0, 0, 0 ) );
            }
            
            level flag::set( "wearables_raz_arms_complete" );
        }
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0x79843760, Offset: 0x1cc8
// Size: 0xb8
function function_ac75c48f()
{
    level endon( #"wearables_raz_mask_complete" );
    
    while ( true )
    {
        level waittill( #"raz_mask_destroyed" );
        level.var_f090ed38.var_8fefef40++;
        
        if ( level.var_f090ed38.var_8fefef40 >= level.var_f090ed38.var_7c69aa76 )
        {
            if ( !level flag::get( "wearables_raz_arms_complete" ) )
            {
                playsoundatposition( "zmb_wearable_raz_success_step", ( 0, 0, 0 ) );
            }
            
            level flag::set( "wearables_raz_mask_complete" );
        }
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0xd4f19b2d, Offset: 0x1d88
// Size: 0x134
function function_69f1fce3()
{
    var_17eaa53a = [];
    array::add( var_17eaa53a, "wearables_raz_mask_complete", 0 );
    array::add( var_17eaa53a, "wearables_raz_arms_complete", 0 );
    level flag::wait_till_all( var_17eaa53a );
    playsoundatposition( "zmb_wearable_raz_success", ( 0, 0, 0 ) );
    var_94cd901e = struct::get( "wearable_raz_hat", "targetname" );
    var_94cd901e.model = spawn( "script_model", var_94cd901e.origin );
    var_94cd901e.model.angles = var_94cd901e.angles;
    var_94cd901e.model setmodel( "c_zom_dlc3_player_raz_facemask" );
}

// Namespace zm_stalingrad_wearables
// Params 1
// Checksum 0x9565e6cd, Offset: 0x1ec8
// Size: 0xce, Type: bool
function function_449ba539( e_player )
{
    if ( e_player.str_wearable === "raz_hat" )
    {
        self sethintstring( &"ZM_STALINGRAD_WEARABLE_EQUIPPED" );
        return false;
    }
    else if ( level flag::get( "wearables_raz_mask_complete" ) && level flag::get( "wearables_raz_arms_complete" ) )
    {
        self sethintstring( &"ZM_STALINGRAD_WEARABLE_RAZ_MASK_EQUIP" );
        return true;
    }
    
    self sethintstring( "" );
    return false;
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0xa3300b6e, Offset: 0x1fa0
// Size: 0x190
function function_ad641a9f()
{
    self endon( #"death" );
    
    while ( true )
    {
        self trigger::wait_till();
        player = self.who;
        player clientfield::increment_to_player( "interact_rumble" );
        
        if ( isdefined( player.var_bc5f242a ) )
        {
            player function_caffcf07();
            player function_588ad36a();
        }
        else
        {
            player.var_bc5f242a = spawnstruct();
        }
        
        player.var_bc5f242a.model = "c_zom_dlc3_player_raz_facemask";
        player.var_bc5f242a.tag = "j_head";
        player function_20f2df00();
        player.str_wearable = "raz_hat";
        player playsound( "zmb_wearable_raz_wear" );
        zm::register_player_damage_callback( &function_9c197fbf );
        player function_793f10ed( 1 );
        player thread function_2436f867();
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0x4472df9, Offset: 0x2138
// Size: 0xb8
function function_fe559f6c()
{
    level endon( #"hash_f40b8221" );
    
    while ( true )
    {
        level waittill( #"all_sentinel_arms_destroyed" );
        level.var_f090ed38.var_4da5ec78++;
        
        if ( level.var_f090ed38.var_4da5ec78 >= level.var_f090ed38.var_e34dd99e )
        {
            if ( !level flag::get( "wearables_sentinel_camera_complete" ) )
            {
                playsoundatposition( "zmb_wearable_sent_success_step", ( 0, 0, 0 ) );
            }
            
            level flag::set( "wearables_sentinel_arms_complete" );
        }
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0x9740cb5a, Offset: 0x21f8
// Size: 0xb8
function function_ba204ad8()
{
    level endon( #"wearables_sentinel_camera_complete" );
    
    while ( true )
    {
        level waittill( #"sentinel_camera_destroyed" );
        level.var_f090ed38.var_24859f92++;
        
        if ( level.var_f090ed38.var_24859f92 >= level.var_f090ed38.var_10d3c700 )
        {
            if ( !level flag::get( "wearables_sentinel_arms_complete" ) )
            {
                playsoundatposition( "zmb_wearable_sent_success_step", ( 0, 0, 0 ) );
            }
            
            level flag::set( "wearables_sentinel_camera_complete" );
        }
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0x9d7ce7c, Offset: 0x22b8
// Size: 0x134
function function_14b98ab6()
{
    var_830c4b35 = [];
    array::add( var_830c4b35, "wearables_sentinel_camera_complete", 0 );
    array::add( var_830c4b35, "wearables_sentinel_arms_complete", 0 );
    level flag::wait_till_all( var_830c4b35 );
    playsoundatposition( "zmb_wearable_sent_success", ( 0, 0, 0 ) );
    var_494ee1d1 = struct::get( "wearable_sentinel_hat", "targetname" );
    var_494ee1d1.model = spawn( "script_model", var_494ee1d1.origin );
    var_494ee1d1.model.angles = var_494ee1d1.angles;
    var_494ee1d1.model setmodel( "c_zom_dlc3_player_sentinel_drone_hat" );
}

// Namespace zm_stalingrad_wearables
// Params 1
// Checksum 0x99861f05, Offset: 0x23f8
// Size: 0xce, Type: bool
function function_a6595bd6( e_player )
{
    if ( e_player.str_wearable === "sentinel_hat" )
    {
        self sethintstring( &"ZM_STALINGRAD_WEARABLE_EQUIPPED" );
        return false;
    }
    else if ( level flag::get( "wearables_sentinel_arms_complete" ) && level flag::get( "wearables_sentinel_camera_complete" ) )
    {
        self sethintstring( &"ZM_STALINGRAD_WEARABLE_VALKYRIE_HAT_EQUIP" );
        return true;
    }
    
    self sethintstring( "" );
    return false;
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0x86a40f63, Offset: 0x24d0
// Size: 0x198
function function_f3b06f8e()
{
    self endon( #"death" );
    
    while ( true )
    {
        self trigger::wait_till();
        player = self.who;
        player clientfield::increment_to_player( "interact_rumble" );
        
        if ( isdefined( player.var_bc5f242a ) )
        {
            player function_caffcf07();
            player function_588ad36a();
        }
        else
        {
            player.var_bc5f242a = spawnstruct();
        }
        
        player.var_bc5f242a.model = "c_zom_dlc3_player_sentinel_drone_hat";
        player.var_bc5f242a.tag = "j_head";
        player function_20f2df00();
        player playsound( "zmb_wearable_sent_wear" );
        player.str_wearable = "sentinel_hat";
        zm::register_player_damage_callback( &function_9c197fbf );
        player function_793f10ed( 2 );
        player thread function_2436f867();
    }
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0x8b4b2c81, Offset: 0x2670
// Size: 0x3c
function function_caffcf07()
{
    self detach( self.var_bc5f242a.model, self.var_bc5f242a.tag );
}

// Namespace zm_stalingrad_wearables
// Params 0
// Checksum 0xe8312dd2, Offset: 0x26b8
// Size: 0x3c
function function_20f2df00()
{
    self attach( self.var_bc5f242a.model, self.var_bc5f242a.tag );
}

// Namespace zm_stalingrad_wearables
// Params 10
// Checksum 0xdc35553c, Offset: 0x2700
// Size: 0x1da
function function_9c197fbf( e_inflictor, e_attacker, i_damage, idflags, str_meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime )
{
    if ( isdefined( self.str_wearable ) )
    {
        switch ( self.str_wearable )
        {
            case "sentinel_hat":
                if ( isdefined( e_attacker ) && e_attacker.archetype === "sentinel_drone" )
                {
                    i_damage *= 0.5;
                    return int( i_damage );
                }
            case "raz_hat":
                if ( isdefined( e_attacker ) && e_attacker.archetype === "raz" )
                {
                    i_damage *= 0.5;
                    return int( i_damage );
                }
            case "dragon_wings":
                if ( isdefined( str_meansofdeath ) )
                {
                    switch ( str_meansofdeath )
                    {
                        case "MOD_FIRE":
                            i_damage *= 0.5;
                            return int( i_damage );
                        case "MOD_EXPLOSIVE":
                        case "MOD_GRENADE":
                        case "MOD_GRENADE_SPLASH":
                        case "MOD_PROJECTILE":
                        default:
                            i_damage *= 0.5;
                            return int( i_damage );
                    }
                }
            default:
                return -1;
        }
    }
    
    return -1;
}

#namespace namespace_5132b4d6;

// Namespace namespace_5132b4d6
// Params 0
// Checksum 0xa73cfe9a, Offset: 0x28e8
// Size: 0x40c
function function_19458e73()
{
    level flag::init( "drshup_step_1_done" );
    level flag::init( "drshup_library_rune_hit" );
    level flag::init( "drshup_judicial_rune_hit" );
    level flag::init( "drshup_factory_rune_hit" );
    level flag::init( "drshup_rune_step_done" );
    level flag::init( "drshup_bathed_in_flame" );
    level flag::init( "drshup_bathed_in_blood" );
    level flag::init( "drshup_quest_done" );
    level.var_8f92a57b = struct::spawn();
    level.var_8f92a57b.n_shield_kills = 0;
    level.var_8f92a57b.var_31e59fa8 = 50;
    level.var_8f92a57b.var_3ec0a9c2 = struct::get_array( "mee_drshup_rune", "targetname" );
    level.var_8f92a57b.var_7cd42d94 = 0;
    level.craftable_crafted_custom_func = &function_8ad194d1;
    level thread function_5e8bb6cc();
    level thread function_4052556b();
    level flag::wait_till_all( array( "drshup_factory_rune_hit", "drshup_judicial_rune_hit", "drshup_library_rune_hit" ) );
    playsoundatposition( "zmb_dragshield_success_medium", ( 0, 0, 0 ) );
    level flag::set( "drshup_rune_step_done" );
    callback::remove_on_connect( &function_70aa26aa );
    level flag::wait_till( "drshup_bathed_in_flame" );
    playsoundatposition( "zmb_dragshield_success_medium", ( 0, 0, 0 ) );
    level.var_8f92a57b.var_3297395c = struct::get( "drshup_quench_loc", "targetname" );
    level.var_8f92a57b.var_3297395c zm_unitrigger::create_unitrigger( "", 32, &function_cf47076, &function_ac90554d );
    level flag::wait_till( "drshup_quest_done" );
    level.var_8f92a57b.var_18d10053 zm_equipment::buy( "dragonshield_upgraded" );
    
    foreach ( player in level.activeplayers )
    {
        player thread function_fa020cda();
    }
    
    callback::on_connect( &function_fa020cda );
}

// Namespace namespace_5132b4d6
// Params 0
// Checksum 0x99ec1590, Offset: 0x2d00
// Size: 0x4
function function_9f500475()
{
    
}

// Namespace namespace_5132b4d6
// Params 0
// Checksum 0x5af740fc, Offset: 0x2d10
// Size: 0x74
function function_4052556b()
{
    level flag::wait_till( "dragon_shield_used" );
    
    /#
        if ( isdefined( level.var_f9c3fe97 ) && level.var_f9c3fe97 )
        {
            level.var_8f92a57b.var_31e59fa8 = 2;
        }
    #/
    
    zm_spawner::register_zombie_death_event_callback( &function_a3232de );
}

// Namespace namespace_5132b4d6
// Params 1
// Checksum 0x22b6ff27, Offset: 0x2d90
// Size: 0xe4
function function_a3232de( e_attacker )
{
    if ( !isdefined( self ) || self.archetype === "sentinel_drone" )
    {
        return;
    }
    
    if ( self.damageweapon.name == "dragonshield" )
    {
        level.var_8f92a57b.n_shield_kills++;
        
        if ( level.var_8f92a57b.n_shield_kills >= level.var_8f92a57b.var_31e59fa8 )
        {
            zm_spawner::deregister_zombie_death_event_callback( &function_a3232de );
            level flag::set( "drshup_step_1_done" );
            playsoundatposition( "zmb_dragshield_success_medium", ( 0, 0, 0 ) );
        }
    }
}

// Namespace namespace_5132b4d6
// Params 0
// Checksum 0xd6a1534f, Offset: 0x2e80
// Size: 0x1c4
function function_5e8bb6cc()
{
    level flag::wait_till( "drshup_step_1_done" );
    
    foreach ( s_loc in level.var_8f92a57b.var_3ec0a9c2 )
    {
        s_loc.model = spawn( "script_model", s_loc.origin );
        s_loc.model setmodel( "p7_zm_sta_dragon_shield_rune_shoot_light" );
        s_loc.model.angles = s_loc.angles;
    }
    
    foreach ( player in level.activeplayers )
    {
        player thread function_70aa26aa();
    }
    
    callback::on_connect( &function_70aa26aa );
}

// Namespace namespace_5132b4d6
// Params 0
// Checksum 0x7f1dd508, Offset: 0x3050
// Size: 0x2d6
function function_70aa26aa()
{
    level endon( #"drshup_rune_step_done" );
    self endon( #"disconnect" );
    
    while ( true )
    {
        self waittill( #"hash_10fa975d" );
        var_7dda366c = self getweaponmuzzlepoint();
        var_3ec0a9c2 = array::get_all_closest( var_7dda366c, level.var_8f92a57b.var_3ec0a9c2, undefined, undefined, level.zombie_vars[ "dragonshield_knockdown_range" ] );
        
        if ( !isdefined( var_3ec0a9c2 ) )
        {
            break;
        }
        
        knockdown_range_squared = level.zombie_vars[ "dragonshield_knockdown_range" ] * level.zombie_vars[ "dragonshield_knockdown_range" ];
        forward_view_angles = self getweaponforwarddir();
        end_pos = var_7dda366c + vectorscale( forward_view_angles, level.zombie_vars[ "dragonshield_knockdown_range" ] );
        
        foreach ( s_rune in var_3ec0a9c2 )
        {
            var_cb78916d = s_rune.origin;
            var_8112eb05 = distancesquared( var_7dda366c, var_cb78916d );
            
            if ( var_8112eb05 > knockdown_range_squared )
            {
                break;
            }
            
            v_normal = vectornormalize( var_cb78916d - var_7dda366c );
            dot = vectordot( forward_view_angles, v_normal );
            
            if ( 0 > dot )
            {
                break;
            }
            
            s_rune.model delete();
            arrayremovevalue( level.var_8f92a57b.var_3ec0a9c2, s_rune );
            level flag::set( "drshup_" + s_rune.script_string + "_rune_hit" );
            playsoundatposition( "zmb_dragshield_success_small", ( 0, 0, 0 ) );
        }
    }
}

// Namespace namespace_5132b4d6
// Params 1
// Checksum 0x7af7f947, Offset: 0x3330
// Size: 0xb8
function function_cf47076( e_player )
{
    if ( !level flag::get( "drshup_bathed_in_blood" ) && level flag::get( "drshup_bathed_in_flame" ) && level flag::get( "drshup_rune_step_done" ) )
    {
        self sethintstring( &"ZM_STALINGRAD_SHIELD_UPGRADE" );
        return 1;
    }
    
    self sethintstring( "" );
    return 0;
}

// Namespace namespace_5132b4d6
// Params 0
// Checksum 0x6a9e7da3, Offset: 0x33f0
// Size: 0xe0
function function_ac90554d()
{
    while ( true )
    {
        self trigger::wait_till();
        
        if ( !level flag::get( "drshup_bathed_in_blood" ) )
        {
            level flag::set( "drshup_bathed_in_blood" );
            self.who clientfield::increment_to_player( "interact_rumble" );
            level.var_8f92a57b.var_18d10053 = self.who;
            self.who zm_equipment::take( self.who.weaponriotshield );
            level thread function_771fddfa();
        }
    }
}

// Namespace namespace_5132b4d6
// Params 0
// Checksum 0xcab698a3, Offset: 0x34d8
// Size: 0x1cc
function function_771fddfa()
{
    var_af232cd6 = struct::get( "drchup_bathing_loc", "targetname" );
    var_8df43d42 = spawn( "script_model", var_af232cd6.origin );
    var_8df43d42 setmodel( "wpn_t7_zmb_dlc3_dragon_shield_dmg0_world" );
    var_8df43d42.angles = var_af232cd6.angles;
    var_8df43d42 playsound( "zmb_dragshield_upgrade_place" );
    playrumbleonposition( "zm_stalingrad_shield_upgrade", var_af232cd6.origin );
    exploder::exploder( "fxexp_717" );
    var_8df43d42 movez( -150, 2 );
    var_8df43d42 waittill( #"movedone" );
    var_8df43d42 setmodel( "wpn_t7_zmb_dlc3_dragon_shield_dmg0_upg_world" );
    wait 2;
    var_8df43d42 movez( 150, 4 );
    var_8df43d42 waittill( #"movedone" );
    var_8df43d42 delete();
    level flag::set( "drshup_quest_done" );
    playsoundatposition( "zmb_dragshield_success_large", ( 0, 0, 0 ) );
}

// Namespace namespace_5132b4d6
// Params 0
// Checksum 0x88b681da, Offset: 0x36b0
// Size: 0x100
function function_fa020cda()
{
    self notify( #"player_watch_upgraded_pickup_from_table" );
    self endon( #"player_watch_upgraded_pickup_from_table" );
    var_4e7bbc60 = level.weaponriotshield.name;
    str_notify = var_4e7bbc60 + "_pickup_from_table";
    
    for ( ;; )
    {
        self waittill( str_notify );
        
        if ( level flag::get( "drshup_quest_done" ) && !( isdefined( self zm_equipment::get_player_equipment() == getweapon( "dragonshield_upgraded" ) ) && self zm_equipment::get_player_equipment() == getweapon( "dragonshield_upgraded" ) ) )
        {
            self zm_equipment::buy( "dragonshield_upgraded" );
        }
    }
}

// Namespace namespace_5132b4d6
// Params 1
// Checksum 0x720c755b, Offset: 0x37b8
// Size: 0xe0
function function_8ad194d1( var_94c6b1d7 )
{
    if ( var_94c6b1d7.craftable_name == "craft_shield_zm" )
    {
        level flag::wait_till( "drshup_quest_done" );
        var_94c6b1d7.stub.model setmodel( "wpn_t7_zmb_dlc3_dragon_shield_dmg0_upg_world" );
        var_94c6b1d7.stub.trigger_hintstring = &"ZM_STALINGRAD_SHIELD_UPGRADE_PICKUP";
        var_94c6b1d7.stub.craftablestub.str_taken = &"ZM_STALINGRAD_SHIELD_UPGRADE_TAKEN";
        var_94c6b1d7.stub.weaponname = getweapon( "dragonshield_upgraded" );
    }
}

