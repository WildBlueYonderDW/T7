#using scripts/codescripts/struct;
#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/sound_shared;
#using scripts/shared/util_shared;
#using scripts/shared/visionset_mgr_shared;
#using scripts/zm/_load;
#using scripts/zm/_zm;
#using scripts/zm/_zm_ai_monkey;
#using scripts/zm/_zm_ai_napalm;
#using scripts/zm/_zm_ai_sonic;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_audio_zhd;
#using scripts/zm/_zm_pack_a_punch;
#using scripts/zm/_zm_perk_additionalprimaryweapon;
#using scripts/zm/_zm_perk_deadshot;
#using scripts/zm/_zm_perk_doubletap2;
#using scripts/zm/_zm_perk_juggernaut;
#using scripts/zm/_zm_perk_quick_revive;
#using scripts/zm/_zm_perk_sleight_of_hand;
#using scripts/zm/_zm_perk_staminup;
#using scripts/zm/_zm_perk_widows_wine;
#using scripts/zm/_zm_powerup_carpenter;
#using scripts/zm/_zm_powerup_double_points;
#using scripts/zm/_zm_powerup_fire_sale;
#using scripts/zm/_zm_powerup_free_perk;
#using scripts/zm/_zm_powerup_full_ammo;
#using scripts/zm/_zm_powerup_insta_kill;
#using scripts/zm/_zm_powerup_nuke;
#using scripts/zm/_zm_powerup_weapon_minigun;
#using scripts/zm/_zm_radio;
#using scripts/zm/_zm_weap_bouncingbetty;
#using scripts/zm/_zm_weap_cymbal_monkey;
#using scripts/zm/_zm_weap_shrink_ray;
#using scripts/zm/_zm_weapons;
#using scripts/zm/zm_temple_ai_monkey;
#using scripts/zm/zm_temple_amb;
#using scripts/zm/zm_temple_ffotd;
#using scripts/zm/zm_temple_fx;
#using scripts/zm/zm_temple_geyser;
#using scripts/zm/zm_temple_maze;
#using scripts/zm/zm_temple_sq;

#namespace zm_temple;

// Namespace zm_temple
// Params 0, eflags: 0x2
// Checksum 0x29d47e65, Offset: 0xc98
// Size: 0x1c
function autoexec function_d9af860b()
{
    level.aat_in_use = 1;
    level.bgb_in_use = 1;
}

// Namespace zm_temple
// Params 0
// Checksum 0x494b97b9, Offset: 0xcc0
// Size: 0x314
function main()
{
    zm_temple_ffotd::main_start();
    setdvar( "player_sliding_velocity_cap", 50 );
    setdvar( "player_sliding_wishspeed", 600 );
    level.default_game_mode = "zclassic";
    level.default_start_location = "default";
    thread zm_temple_fx::main();
    level._uses_sticky_grenades = 1;
    level._temple_vision_set = "zombie_temple";
    level._temple_vision_set_priority = 1;
    level._temple_caves_vision_set = "zombie_temple_caves";
    level._temple_caves_vision_set_priority = 2;
    level._temple_water_vision_set = "zombie_temple";
    level._temple_eclipse_vision_set = "zombie_temple_eclipse";
    level._temple_eclipse_vision_set_priority = 3;
    level._temple_caves_eclipse_vision_set = "zombie_temple_eclipseCave";
    level._temple_caves_eclipse_vision_set_priority = 3;
    level.riser_fx_on_client = 1;
    level.use_new_riser_water = 1;
    level.use_clientside_rock_tearin_fx = 1;
    level.use_clientside_board_fx = 1;
    level.var_e34b793e = 0;
    include_weapons();
    init_level_specific_wall_buy_fx();
    visionset_mgr::register_overlay_info_style_blur( "zm_ai_screecher_blur", 21000, 15, 0.1, 0.25, 20 );
    level thread zm_temple_amb::main();
    function_80cb4231();
    zm_temple_sq::init_clientfields();
    zm_temple_geyser::main();
    load::main();
    _zm_weap_cymbal_monkey::init();
    level thread power_watch();
    callback::on_localclient_connect( &temple_player_connect );
    callback::on_localplayer_spawned( &temple_player_spawned );
    level thread temple_light_model_swap_init();
    level thread sq_std_watcher();
    level._in_eclipse = 0;
    level thread crystal_sauce_monitor();
    util::waitforclient( 0 );
    level thread function_6ac83719();
    println( "<dev string:x28>" );
    zm_temple_ffotd::main_end();
}

// Namespace zm_temple
// Params 0
// Checksum 0xaba209c, Offset: 0xfe0
// Size: 0x7c
function function_6ac83719()
{
    visionset_mgr::init_fog_vol_to_visionset_monitor( "zombie_temple", 2 );
    visionset_mgr::fog_vol_to_visionset_set_suffix( "" );
    visionset_mgr::fog_vol_to_visionset_set_info( 0, "zombie_temple" );
    visionset_mgr::fog_vol_to_visionset_set_info( 1, "zombie_temple_caves" );
}

// Namespace zm_temple
// Params 0
// Checksum 0xf327756b, Offset: 0x1068
// Size: 0x4e4
function function_80cb4231()
{
    clientfield::register( "actor", "ragimpactgib", 21000, 1, "int", &ragdoll_impact_watch_start, 0, 0 );
    clientfield::register( "scriptmover", "spiketrap", 21000, 1, "int", &spike_trap_move, 0, 0 );
    clientfield::register( "scriptmover", "mazewall", 21000, 1, "int", &maze_wall_move, 0, 0 );
    clientfield::register( "scriptmover", "weaksauce", 21000, 1, "int", &crystal_weaksauce_start, 0, 0 );
    clientfield::register( "scriptmover", "hotsauce", 21000, 1, "int", &crystal_hotsauce_start, 0, 0 );
    clientfield::register( "scriptmover", "sauceend", 21000, 1, "int", &crystal_sauce_end, 0, 0 );
    clientfield::register( "scriptmover", "watertrail", 21000, 1, "int", &water_trail_monitor, 0, 0 );
    clientfield::register( "toplayer", "floorrumble", 21000, 1, "int", &maze_floor_controller_rumble, 0, 0 );
    clientfield::register( "toplayer", "minecart_rumble", 21000, 1, "int", &function_425904c0, 0, 0 );
    clientfield::register( "world", "papspinners", 21000, 4, "int", &function_9fe44296, 0, 0 );
    clientfield::register( "world", "water_wheel_right", 21000, 1, "int", &water_wheel_right, 0, 0 );
    clientfield::register( "world", "water_wheel_left", 21000, 1, "int", &water_wheel_left, 0, 0 );
    clientfield::register( "world", "waterfall_trap", 21000, 1, "int", &waterfall_watcher, 0, 0 );
    clientfield::register( "world", "time_transition", 21000, 1, "int", &timetravel_watcher, 0, 1 );
    clientfield::register( "allplayers", "player_legs_hide", 21000, 1, "int", &player_legs_hide, 0, 0 );
    clientfield::register( "scriptmover", "zombie_has_eyes", 21000, 1, "int", &zm::zombie_eyes_clientfield_cb, 0, 0 );
    visionset_mgr::register_overlay_info_style_postfx_bundle( "zm_waterfall_postfx", 21000, 32, "pstfx_waterfall_soft", 3 );
    visionset_mgr::register_overlay_info_style_postfx_bundle( "zm_temple_eclipse", 21000, 1, "pstfx_temple_eclipse_in", 3 );
}

// Namespace zm_temple
// Params 7
// Checksum 0xfe83413a, Offset: 0x1558
// Size: 0x54
function spike_trap_move( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    spike_trap_move_spikes( localclientnum, newval );
}

// Namespace zm_temple
// Params 7
// Checksum 0x3ccb0870, Offset: 0x15b8
// Size: 0x54
function maze_wall_move( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    zm_temple_maze::maze_trap_move_wall( localclientnum, newval );
}

// Namespace zm_temple
// Params 0
// Checksum 0xcecb248, Offset: 0x1618
// Size: 0x5e
function delete_water_trail()
{
    wait 1.2;
    
    for ( i = 0; i < self.fx_ents.size ; i++ )
    {
        self.fx_ents[ i ] delete();
    }
    
    self.fx_ents = undefined;
}

// Namespace zm_temple
// Params 7
// Checksum 0xaf4a88d9, Offset: 0x1680
// Size: 0x18c
function water_trail_monitor( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( localclientnum != 0 )
    {
        return;
    }
    
    if ( newval )
    {
        players = getlocalplayers();
        self.fx_ents = [];
        
        for ( i = 0; i < players.size ; i++ )
        {
            self.fx_ents[ i ] = spawn( i, ( 0, 0, 0 ), "script_model" );
            self.fx_ents[ i ] setmodel( "tag_origin" );
            self.fx_ents[ i ] linkto( self, "tag_origin" );
            playfxontag( i, level._effect[ "fx_crystal_water_trail" ], self.fx_ents[ i ], "tag_origin" );
        }
        
        return;
    }
    
    if ( isdefined( self.fx_ents ) )
    {
        self thread delete_water_trail();
    }
}

// Namespace zm_temple
// Params 7
// Checksum 0x91475ab1, Offset: 0x1818
// Size: 0xb4
function crystal_weaksauce_start( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( localclientnum != 0 )
    {
        return;
    }
    
    if ( !newval )
    {
        return;
    }
    
    s = spawnstruct();
    s.fx = "fx_weak_sauce_trail";
    s.origin = self.origin + ( 0, 0, 134 );
    level._crystal_sauce_start = s;
}

// Namespace zm_temple
// Params 7
// Checksum 0x47bdcb72, Offset: 0x18d8
// Size: 0xb4
function crystal_hotsauce_start( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( localclientnum != 0 )
    {
        return;
    }
    
    if ( !newval )
    {
        return;
    }
    
    s = spawnstruct();
    s.fx = "fx_hot_sauce_trail";
    s.origin = self.origin + ( 0, 0, 134 );
    level._crystal_sauce_start = s;
}

// Namespace zm_temple
// Params 7
// Checksum 0x45e97701, Offset: 0x1998
// Size: 0x98
function crystal_sauce_end( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( localclientnum != 0 )
    {
        return;
    }
    
    if ( !newval )
    {
        return;
    }
    
    level._crystal_sauce_end = self.origin;
    
    if ( self.model == "p7_zm_sha_crystal_holder_full" )
    {
        level._crystal_sauce_end += ( 0, 0, 134 );
    }
}

// Namespace zm_temple
// Params 3
// Checksum 0x2fbb12ba, Offset: 0x1a38
// Size: 0xf4
function crystal_trail_runner( localclientnum, fx_name, dest )
{
    println( "<dev string:x4e>" + fx_name + "<dev string:x57>" + self.origin + "<dev string:x5e>" + dest );
    playfxontag( localclientnum, level._effect[ fx_name ], self, "tag_origin" );
    self playloopsound( "evt_sq_bag_crystal_bounce_loop", 0.05 );
    self moveto( dest, 0.5 );
    self waittill( #"movedone" );
    self delete();
}

// Namespace zm_temple
// Params 0
// Checksum 0xc708704, Offset: 0x1b38
// Size: 0x11a
function crystal_sauce_monitor()
{
    num_players = getlocalplayers().size;
    
    while ( true )
    {
        wait 0.016;
        
        if ( !isdefined( level._crystal_sauce_start ) || !isdefined( level._crystal_sauce_end ) )
        {
            continue;
        }
        
        for ( i = 0; i < num_players ; i++ )
        {
            e = spawn( i, level._crystal_sauce_start.origin, "script_model" );
            e setmodel( "tag_origin" );
            e thread crystal_trail_runner( i, level._crystal_sauce_start.fx, level._crystal_sauce_end );
        }
        
        level._crystal_sauce_start = undefined;
        level._crystal_sauce_end = undefined;
    }
}

// Namespace zm_temple
// Params 0
// Checksum 0xc21db335, Offset: 0x1c60
// Size: 0x3c
function power_watch()
{
    level.power = 0;
    level waittill( #"zpo" );
    level.power = 1;
    level thread start_generator_movement();
}

// Namespace zm_temple
// Params 7
// Checksum 0xf1cc01f4, Offset: 0x1ca8
// Size: 0x2d4
function timetravel_watcher( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval )
    {
        level notify( #"db" );
        level thread zm_temple_amb::function_e3a6a660( bnewent, binitialsnap, bwasdemojump );
        var_4796f90 = isdefined( level._in_eclipse ) && level._in_eclipse;
        level._in_eclipse = 0;
        visionset_mgr::fog_vol_to_visionset_set_suffix( "" );
        level notify( #"time_travel", level._in_eclipse );
        exploder::exploder( "fxexp_401" );
        
        if ( var_4796f90 )
        {
            exploder::kill_exploder( "fxexp_402" );
        }
        
        exploder::kill_exploder( "eclipse" );
        
        if ( bnewent || binitialsnap || bwasdemojump )
        {
            setdvar( "r_skyTransition", 0 );
        }
        else
        {
            level thread function_bf1b3728( 0, 2 );
        }
        
        setlitfogbank( localclientnum, -1, 0, 0 );
        setworldfogactivebank( localclientnum, 1 );
    }
    else
    {
        level thread zm_temple_amb::function_418a175a();
        level._in_eclipse = 1;
        level notify( #"time_travel", level._in_eclipse );
        visionset_mgr::fog_vol_to_visionset_set_suffix( "_eclipse" );
        exploder::exploder( "eclipse" );
        exploder::exploder( "fxexp_402" );
        exploder::kill_exploder( "fxexp_401" );
        level thread function_bf1b3728( 1, 2.5 );
        setlitfogbank( localclientnum, -1, 1, 1 );
        setworldfogactivebank( localclientnum, 2 );
    }
    
    if ( !isdefined( level._sidequest_firsttime ) )
    {
        level._sidequest_firsttime = 0;
        return;
    }
    
    level thread function_7b0ba395( localclientnum );
}

// Namespace zm_temple
// Params 2
// Checksum 0xa71c0b30, Offset: 0x1f88
// Size: 0x144
function function_bf1b3728( n_val, n_time )
{
    level notify( #"hash_47d048e6" );
    level endon( #"hash_47d048e6" );
    
    if ( !isdefined( level.var_3766c3d3 ) )
    {
        level.var_3766c3d3 = 0;
    }
    
    if ( level.var_3766c3d3 == n_val )
    {
        return;
    }
    
    if ( n_val > level.var_3766c3d3 )
    {
        var_83a6ec14 = n_val - level.var_3766c3d3;
    }
    else
    {
        var_83a6ec14 = ( level.var_3766c3d3 - n_val ) * -1;
        wait 0.5;
    }
    
    n_change = var_83a6ec14 / n_time / 0.1;
    
    while ( level.var_3766c3d3 != n_val )
    {
        level.var_3766c3d3 += n_change;
        setdvar( "r_skyTransition", level.var_3766c3d3 );
        wait 0.1;
    }
    
    setdvar( "r_skyTransition", n_val );
}

// Namespace zm_temple
// Params 1
// Checksum 0xcc539365, Offset: 0x20d8
// Size: 0x12c
function function_7b0ba395( localclientnum )
{
    level endon( #"end_rumble" );
    level endon( #"end_game" );
    player = getlocalplayers()[ localclientnum ];
    var_efeac590 = 0;
    n_end_time = 2;
    player playrumblelooponentity( localclientnum, "tank_rumble" );
    
    while ( isdefined( player ) && var_efeac590 < n_end_time )
    {
        player earthquake( 0.3, 0.1, player.origin, 100 );
        var_efeac590 += 0.1;
        wait 0.1;
    }
    
    if ( isdefined( player ) )
    {
        player stoprumble( localclientnum, "tank_rumble" );
    }
}

// Namespace zm_temple
// Params 0
// Checksum 0x6beb53e8, Offset: 0x2210
// Size: 0x8e
function start_generator_movement()
{
    players = getlocalplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        ent = getent( i, "power_generator", "targetname" );
        ent thread generator_move();
    }
}

// Namespace zm_temple
// Params 0
// Checksum 0xd5041863, Offset: 0x22a8
// Size: 0xc8
function generator_move()
{
    offsetangle = 0.25;
    rottime = 0.1;
    total = 0;
    self rotateroll( 0 - offsetangle, rottime );
    
    while ( true )
    {
        self waittill( #"rotatedone" );
        self rotateroll( offsetangle * 2, rottime );
        self waittill( #"rotatedone" );
        self rotateroll( 0 - offsetangle * 2, rottime );
    }
}

// Namespace zm_temple
// Params 7
// Checksum 0x67d9a957, Offset: 0x2378
// Size: 0x74
function player_legs_hide( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval )
    {
        self hideviewlegs();
        return;
    }
    
    self showviewlegs();
}

// Namespace zm_temple
// Params 7
// Checksum 0x68376b85, Offset: 0x23f8
// Size: 0xd6
function water_wheel_right( clientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    players = getlocalplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        wheel = getent( i, "water_wheel_right", "targetname" );
        wheel thread rotatewheel( 120, 2.2 );
    }
}

// Namespace zm_temple
// Params 7
// Checksum 0x32c227c6, Offset: 0x24d8
// Size: 0xd6
function water_wheel_left( clientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    players = getlocalplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        wheel = getent( i, "water_wheel_left", "targetname" );
        wheel thread rotatewheel( 120, 1.8 );
    }
}

// Namespace zm_temple
// Params 2
// Checksum 0xac8f2df7, Offset: 0x25b8
// Size: 0x9c
function rotatewheel( rotate, time )
{
    spinuptime = time - 0.5;
    self rotatepitch( rotate, time, spinuptime, 0.1 );
    self waittill( #"rotatedone" );
    
    while ( true )
    {
        self rotatepitch( rotate, time, 0, 0 );
        self waittill( #"rotatedone" );
    }
}

// Namespace zm_temple
// Params 1
// Checksum 0x3e3f6d46, Offset: 0x2660
// Size: 0x9e
function disable_deadshot( i_local_client_num )
{
    while ( !self hasdobj( i_local_client_num ) )
    {
        wait 0.05;
    }
    
    players = getlocalplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        if ( self == players[ i ] )
        {
            self clearalternateaimparams();
        }
    }
}

/#

    // Namespace zm_temple
    // Params 0
    // Checksum 0xff476da2, Offset: 0x2708
    // Size: 0xe6, Type: dev
    function water_gush_debug()
    {
        scale = 0.1;
        offset = ( 0, 0, 0 );
        dir = anglestoforward( self.angles );
        
        for ( i = 0; i < 5 ; i++ )
        {
            print3d( self.origin + offset, "<dev string:x63>", ( 60, 60, 255 ), 1, scale, 10 );
            scale *= 1.7;
            offset += dir * 6;
        }
    }

#/

// Namespace zm_temple
// Params 7
// Checksum 0x7e796d47, Offset: 0x27f8
// Size: 0xf6
function waterfall_watcher( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    targets = struct::get_array( "sq_sad", "targetname" );
    
    for ( i = 0; i < targets.size ; i++ )
    {
        if ( !isdefined( level._sq_std_status ) || !isdefined( level._sq_std_status[ i ] ) )
        {
            continue;
        }
        
        if ( level._sq_std_status[ i ] == 0 )
        {
            exploder::exploder( "fxexp_12" + i );
        }
        
        wait 0.25;
    }
}

// Namespace zm_temple
// Params 0
// Checksum 0x58e4e5d9, Offset: 0x28f8
// Size: 0x136
function sq_std_watcher()
{
    println( "<dev string:x65>" );
    println( "<dev string:x75>" );
    level waittill( #"sr" );
    players = getlocalplayers();
    println( "<dev string:x89>" );
    targets = struct::get_array( "sq_sad", "targetname" );
    println( "<dev string:x9b>" + targets.size + "<dev string:xc8>" );
    
    for ( i = 0; i < targets.size ; i++ )
    {
        targets[ i ] thread sq_std_struct_watcher( players.size );
    }
}

// Namespace zm_temple
// Params 1
// Checksum 0xc1f5770e, Offset: 0x2a38
// Size: 0x104
function sq_std_watch_for_restart( num_local_players )
{
    level waittill( #"sr" );
    
    if ( isdefined( level._sq_std_array[ self.script_int - 1 ] ) )
    {
        for ( i = 0; i < level._sq_std_array[ self.script_int - 1 ].size ; i++ )
        {
            if ( isdefined( level._sq_std_array[ self.script_int - 1 ][ i ] ) )
            {
                level._sq_std_array[ self.script_int - 1 ][ i ] delete();
            }
        }
        
        level._sq_std_array[ self.script_int - 1 ] = undefined;
    }
    
    level._sq_std_status[ self.script_int - 1 ] = 0;
    self thread sq_std_struct_watcher( num_local_players );
}

// Namespace zm_temple
// Params 0
// Checksum 0x976aff67, Offset: 0x2b48
// Size: 0x60
function sq_struct_debug()
{
    /#
        level endon( #"sr" );
        level endon( #"ksd" );
        
        while ( true )
        {
            print3d( self.origin, "<dev string:x63>", ( 255, 0, 0 ), 1 );
            wait 0.1;
        }
    #/
}

// Namespace zm_temple
// Params 1
// Checksum 0x71e2ad69, Offset: 0x2bb0
// Size: 0x1ee
function sq_std_struct_watcher( num_local_players )
{
    if ( !isdefined( level._sq_std_array ) )
    {
        level._sq_std_array = [];
        level._sq_std_status = [];
        
        for ( i = 0; i < 4 ; i++ )
        {
            level._sq_std_status[ i ] = 0;
        }
    }
    
    level endon( #"sr" );
    self thread sq_std_watch_for_restart( num_local_players );
    
    while ( true )
    {
        level waittill( "S" + self.script_int );
        println( "<dev string:xd2>" + self.script_int );
        self thread sq_struct_debug();
        level._sq_std_status[ self.script_int - 1 ] = 1;
        level._sq_std_array[ self.script_int - 1 ] = [];
        
        for ( i = 0; i < num_local_players ; i++ )
        {
            e = spawn( i, self.origin, "script_model" );
            e.angles = self.angles + ( 270, 0, 0 );
            e setmodel( "wpn_t7_spider_mine_world" );
            level._sq_std_array[ self.script_int - 1 ][ level._sq_std_array[ self.script_int - 1 ].size ] = e;
        }
    }
}

// Namespace zm_temple
// Params 1
// Checksum 0x84259e10, Offset: 0x2da8
// Size: 0x6c
function temple_player_spawned( localclientnum )
{
    if ( self != getlocalplayer( localclientnum ) )
    {
        return;
    }
    
    if ( isdefined( self.var_1687ae46 ) )
    {
        return;
    }
    
    self.var_1687ae46 = 1;
    
    if ( localclientnum != 0 )
    {
        return;
    }
    
    self thread disable_deadshot( localclientnum );
}

// Namespace zm_temple
// Params 1
// Checksum 0x4a6c83b4, Offset: 0x2e20
// Size: 0x54
function temple_player_connect( i_local_client_num )
{
    setsaveddvar( "phys_buoyancy", 1 );
    level thread _init_pap_indicators();
    thread floating_boards_init();
}

// Namespace zm_temple
// Params 0
// Checksum 0x9a8e1205, Offset: 0x2e80
// Size: 0x152
function init_level_specific_wall_buy_fx()
{
    level._effect[ "sticky_grenade_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_pistol";
    level._effect[ "frag_grenade_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_pistol";
    level._effect[ "pdw57_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_rifle";
    level._effect[ "870mcs_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_rifle";
    level._effect[ "ak74u_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_rifle";
    level._effect[ "beretta93r_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_pistol";
    level._effect[ "bowie_knife_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_rifle";
    level._effect[ "claymore_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_rifle";
    level._effect[ "m14_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_rifle";
    level._effect[ "m16_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_rifle";
    level._effect[ "mp5k_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_rifle";
    level._effect[ "rottweil72_zm_fx" ] = "maps/zombie/fx_zmb_wall_buy_rifle";
}

// Namespace zm_temple
// Params 0
// Checksum 0xf0cf972d, Offset: 0x2fe0
// Size: 0x24
function include_weapons()
{
    zm_weapons::load_weapon_spec_from_table( "gamedata/weapons/zm/zm_temple_weapons.csv", 1 );
}

// Namespace zm_temple
// Params 0
// Checksum 0x9378f69e, Offset: 0x3010
// Size: 0xb4
function _init_magic_box()
{
    level._custom_box_monitor = &temple_box_monitor;
    level._box_locations = array( "waterfall_upper_chest", "blender_chest", "pressure_chest", "bridge_chest", "caves_water_chest", "power_chest", "caves1_chest", "caves2_chest", "caves3_chest" );
    callback::on_localclient_connect( &_init_indicators );
    level.cachedinfo = [];
    level.initialized = [];
}

// Namespace zm_temple
// Params 1
// Checksum 0xcaa523bd, Offset: 0x30d0
// Size: 0x15e
function _init_indicators( clientnum )
{
    structs = struct::get_array( "magic_box_indicator", "targetname" );
    
    for ( i = 0; i < structs.size ; i++ )
    {
        s = structs[ i ];
        
        if ( !isdefined( s.viewmodels ) )
        {
            s.viewmodels = [];
        }
        
        s.viewmodels[ clientnum ] = undefined;
    }
    
    level.initialized[ clientnum ] = 1;
    keys = getarraykeys( level.cachedinfo );
    
    for ( i = 0; i < keys.size ; i++ )
    {
        key = keys[ i ];
        state = level.cachedinfo[ key ];
        temple_box_monitor( i, state, "" );
    }
}

// Namespace zm_temple
// Params 3
// Checksum 0xd035772c, Offset: 0x3238
// Size: 0xd6
function temple_box_monitor( clientnum, state, oldstate )
{
    if ( !isdefined( level.initialized[ clientnum ] ) )
    {
        level.cachedinfo[ clientnum ] = state;
        return;
    }
    
    switch ( state )
    {
        case "fire_sale":
            _all_locations( clientnum );
            break;
        case "moving":
            level thread _random_location( clientnum );
            break;
        default:
            level notify( "location_set" + clientnum );
            _setup_location( clientnum, state );
            break;
    }
}

// Namespace zm_temple
// Params 2
// Checksum 0x18d4db40, Offset: 0x3318
// Size: 0x64
function _delete_location( clientnum, location )
{
    structs = struct::get_array( location, "script_noteworthy" );
    array::thread_all( structs, &_setup_view_model, clientnum, undefined );
}

// Namespace zm_temple
// Params 1
// Checksum 0x823894bf, Offset: 0x3388
// Size: 0x6e
function _delete_all_locations( clientnum )
{
    for ( i = 0; i < level._box_locations.size ; i++ )
    {
        location = level._box_locations[ i ];
        _delete_location( clientnum, location );
    }
}

// Namespace zm_temple
// Params 2
// Checksum 0xc9175078, Offset: 0x3400
// Size: 0x6c
function _show_location( clientnum, location )
{
    structs = struct::get_array( location, "script_noteworthy" );
    array::thread_all( structs, &_setup_view_model, clientnum, "zt_map_knife" );
}

// Namespace zm_temple
// Params 2
// Checksum 0x1be4a054, Offset: 0x3478
// Size: 0x44
function _setup_location( clientnum, location )
{
    _delete_all_locations( clientnum );
    _show_location( clientnum, location );
}

// Namespace zm_temple
// Params 2
// Checksum 0x9a13c482, Offset: 0x34c8
// Size: 0xd4
function _setup_view_model( clientnum, viewmodel )
{
    if ( isdefined( self.viewmodels[ clientnum ] ) )
    {
        self.viewmodels[ clientnum ] delete();
        self.viewmodels[ clientnum ] = undefined;
    }
    
    if ( isdefined( viewmodel ) )
    {
        self.viewmodels[ clientnum ] = spawn( clientnum, self.origin, "script_model" );
        self.viewmodels[ clientnum ].angles = self.angles;
        self.viewmodels[ clientnum ] setmodel( viewmodel );
    }
}

// Namespace zm_temple
// Params 1
// Checksum 0x40261e40, Offset: 0x35a8
// Size: 0x9c
function _random_location( clientnum )
{
    level endon( "location_set" + clientnum );
    index = 0;
    
    while ( true )
    {
        location = level._box_locations[ index ];
        _setup_location( clientnum, location );
        index++;
        
        if ( index >= level._box_locations.size )
        {
            index = 0;
        }
        
        wait 0.25;
    }
}

// Namespace zm_temple
// Params 1
// Checksum 0x64276a61, Offset: 0x3650
// Size: 0x6e
function _all_locations( clientnum )
{
    for ( i = 0; i < level._box_locations.size ; i++ )
    {
        location = level._box_locations[ i ];
        _show_location( clientnum, location );
    }
}

// Namespace zm_temple
// Params 0
// Checksum 0x3773a9bd, Offset: 0x36c8
// Size: 0x96
function _init_pap_indicators()
{
    local_players = getlocalplayers();
    
    for ( index = 0; index < local_players.size ; index++ )
    {
        val = clientfield::get( "papspinners" );
        level _set_num_visible_spinners( index, level.var_e34b793e );
    }
}

// Namespace zm_temple
// Params 7
// Checksum 0xe40b666b, Offset: 0x3768
// Size: 0x7c
function function_9fe44296( clientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    level.var_e34b793e = newval;
    getlocalplayers()[ clientnum ] _set_num_visible_spinners( clientnum, level.var_e34b793e );
}

// Namespace zm_temple
// Params 2
// Checksum 0x42774a11, Offset: 0x37f0
// Size: 0x6c
function power( base, exp )
{
    assert( exp >= 0 );
    
    if ( exp == 0 )
    {
        return 1;
    }
    
    return base * power( base, exp - 1 );
}

// Namespace zm_temple
// Params 2
// Checksum 0x6a849ca1, Offset: 0x3868
// Size: 0x2b6
function _set_num_visible_spinners( clientnum, num )
{
    println( "<dev string:xe6>" + clientnum + "<dev string:xf1>" + num );
    
    if ( !isdefined( level.spinners ) )
    {
        level _init_pap_spinners( clientnum );
    }
    else if ( !isdefined( level.spinners[ clientnum ] ) )
    {
        level _init_pap_spinners( clientnum );
    }
    
    for ( i = 3; i >= 0 ; i-- )
    {
        println( "<dev string:xf8>" + i + "<dev string:x10a>" + clientnum );
        assert( isdefined( level.spinners ) );
        assert( isdefined( level.spinners[ clientnum ] ) );
        assert( isdefined( level.spinners[ clientnum ][ i ] ) );
        pow = power( 2, i );
        
        if ( num >= pow )
        {
            num -= pow;
            println( "<dev string:x118>" + clientnum + "<dev string:x128>" + i + "<dev string:x132>" + level.spinners[ clientnum ][ i ].size );
            array::thread_all( level.spinners[ clientnum ][ i ], &spin_to_start );
            continue;
        }
        
        println( "<dev string:x134>" + clientnum + "<dev string:x128>" + i + "<dev string:x132>" + level.spinners[ clientnum ][ i ].size );
        array::thread_all( level.spinners[ clientnum ][ i ], &spin_forever );
    }
}

// Namespace zm_temple
// Params 2
// Checksum 0xa0f8291f, Offset: 0x3b28
// Size: 0xe6
function spike_trap_move_spikes( localclientnum, active )
{
    if ( !isdefined( self.spears ) )
    {
        self set_trap_spears( localclientnum );
    }
    
    spears = self.spears;
    
    if ( isdefined( spears ) )
    {
        for ( i = 0; i < spears.size ; i++ )
        {
            playsound = i == 0;
            spears[ i ] thread spear_init( localclientnum );
            spears[ i ] thread spear_move( localclientnum, active, playsound );
        }
    }
}

// Namespace zm_temple
// Params 1
// Checksum 0x4953e3be, Offset: 0x3c18
// Size: 0x150
function set_trap_spears( localclientnum )
{
    allspears = getentarray( localclientnum, "spear_trap_spear", "targetname" );
    self.spears = [];
    
    for ( i = 0; i < allspears.size ; i++ )
    {
        spear = allspears[ i ];
        
        if ( isdefined( spear.assigned ) && spear.assigned )
        {
            continue;
        }
        
        delta = abs( self.origin[ 0 ] - spear.origin[ 0 ] );
        
        if ( abs( self.origin[ 0 ] - spear.origin[ 0 ] ) < 21 )
        {
            spear.assigned = 1;
            self.spears[ self.spears.size ] = spear;
        }
    }
}

// Namespace zm_temple
// Params 1
// Checksum 0xea4e7c42, Offset: 0x3d70
// Size: 0x80
function spear_init( localclientnum )
{
    if ( !isdefined( self.init ) || !self.init )
    {
        self.movedistmin = 90;
        self.movedistmax = 120;
        self.start = self.origin;
        self.movedir = -1 * anglestoright( self.angles );
        self.init = 1;
    }
}

// Namespace zm_temple
// Params 3
// Checksum 0x6b491da0, Offset: 0x3df8
// Size: 0x1bc
function spear_move( localclientnum, active, playsound )
{
    if ( active )
    {
        if ( playsound )
        {
            sound::play_in_space( 0, "evt_spiketrap_warn", self.origin );
        }
        
        movedist = randomfloatrange( self.movedistmin, self.movedistmax );
        endpos = self.start + self.movedir * movedist;
        playfx( localclientnum, level._effect[ "punji_dust" ], endpos );
        playsound( 0, "evt_spiketrap", self.origin );
        movetime = randomfloatrange( 0.08, 0.22 );
        self moveto( endpos, movetime );
        return;
    }
    
    if ( playsound )
    {
        playsound( 0, "evt_spiketrap_retract", self.origin );
    }
    
    movetime = randomfloatrange( 0.1, 0.2 );
    self moveto( self.start, movetime );
}

// Namespace zm_temple
// Params 0
// Checksum 0xf709c5b6, Offset: 0x3fc0
// Size: 0xbc
function floating_boards_init()
{
    boards = [];
    players = getlocalplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        boards = arraycombine( boards, getentarray( i, "plank_water", "targetname" ), 1, 0 );
    }
    
    array::thread_all( boards, &float_board );
}

// Namespace zm_temple
// Params 0
// Checksum 0x8e3d1ea9, Offset: 0x4088
// Size: 0x7c
function float_board()
{
    wait randomfloat( 1 );
    self.start_origin = self.origin;
    self.start_angles = self.angles;
    self.moment_move = self.origin;
    self thread board_bob();
    self thread board_rotate();
}

// Namespace zm_temple
// Params 0
// Checksum 0xd75907c5, Offset: 0x4110
// Size: 0x134
function board_bob()
{
    dist = randomfloatrange( 2.5, 3 );
    movetime = randomfloatrange( 3.5, 4.5 );
    minz = self.start_origin[ 2 ] - dist;
    maxz = self.start_origin[ 2 ] + dist;
    
    while ( true )
    {
        toz = minz - self.origin[ 2 ];
        self movez( toz, movetime );
        self waittill( #"movedone" );
        toz = maxz - self.origin[ 2 ];
        self movez( toz, movetime );
        self waittill( #"movedone" );
    }
}

// Namespace zm_temple
// Params 0
// Checksum 0xafe5cdfc, Offset: 0x4250
// Size: 0x84
function board_rotate()
{
    while ( true )
    {
        yaw = randomfloatrange( -360, 360 );
        self rotateyaw( yaw, randomfloatrange( 60, 90 ) );
        self waittill( #"rotatedone" );
    }
}

// Namespace zm_temple
// Params 0
// Checksum 0xaa01b0ac, Offset: 0x42e0
// Size: 0x168
function board_move()
{
    dist = randomfloatrange( 20, 30 );
    movetime = randomfloatrange( 5, 10 );
    
    while ( true )
    {
        yaw = randomfloatrange( 0, 360 );
        tovector = anglestoforward( ( 0, yaw, 0 ) );
        newloc = self.start_origin + tovector * dist;
        tox = newloc[ 0 ] - self.origin[ 0 ];
        self movex( tox, movetime );
        toy = newloc[ 1 ] - self.origin[ 1 ];
        self movey( toy, movetime );
    }
}

// Namespace zm_temple
// Params 1
// Checksum 0xf3f1697a, Offset: 0x4450
// Size: 0x186
function _init_pap_spinners( cnum )
{
    if ( !isdefined( level.spinners ) )
    {
        level.spinners = [];
    }
    
    if ( level.spinners.size <= cnum )
    {
        level.spinners[ level.spinners.size ] = array( [], [], [], [] );
    }
    
    println( "<dev string:x143>" + cnum + "<dev string:x14e>" );
    
    for ( i = 0; i < level.spinners[ cnum ].size ; i++ )
    {
        spinners = getentarray( cnum, "pap_spinner" + i + 1, "targetname" );
        println( "<dev string:x143>" + cnum + "<dev string:x128>" + i + "<dev string:x132>" + spinners.size );
        array::thread_all( spinners, &init_spinner, i + 1 );
        level.spinners[ cnum ][ i ] = spinners;
    }
}

// Namespace zm_temple
// Params 1
// Checksum 0x2edeb659, Offset: 0x45e0
// Size: 0x88
function init_spinner( listnum )
{
    self.spinner = listnum;
    self.startangles = self.angles;
    self.spin_sound = "evt_pap_spinner0" + listnum;
    self.spin_stop_sound = "evt_pap_timer_stop";
    self.angles = ( 0, 90 * ( listnum - 1 ) + randomfloatrange( 10, 80 ), 0 );
}

// Namespace zm_temple
// Params 0
// Checksum 0x997de786, Offset: 0x4670
// Size: 0x104
function spin_forever()
{
    if ( !level.power )
    {
        return;
    }
    
    if ( isdefined( self.spin_forever ) && self.spin_forever )
    {
        return;
    }
    
    self.spin_forever = 1;
    self.spin_to_start = 0;
    self notify( #"stop_spinning" );
    self endon( #"death" );
    self endon( #"stop_spinning" );
    spintime = self spinner_get_spin_time();
    self start_spinner_sound();
    self rotateyaw( 360, spintime, 0.25 );
    self waittill( #"rotatedone" );
    
    while ( true )
    {
        self rotateyaw( 360, spintime );
        self waittill( #"rotatedone" );
    }
}

// Namespace zm_temple
// Params 0
// Checksum 0x3fae0767, Offset: 0x4780
// Size: 0x78
function spinner_get_spin_time()
{
    spintime = 1.7;
    
    if ( self.spinner == 2 )
    {
        spintime = 1.5;
    }
    else if ( self.spinner == 3 )
    {
        spintime = 1.2;
    }
    else if ( self.spinner == 4 )
    {
        spintime = 0.8;
    }
    
    return spintime;
}

// Namespace zm_temple
// Params 0
// Checksum 0x38b2207f, Offset: 0x4800
// Size: 0x16c
function spin_to_start()
{
    if ( !level.power )
    {
        return;
    }
    
    if ( isdefined( self.spin_to_start ) && self.spin_to_start )
    {
        return;
    }
    
    self.spin_forever = 0;
    self.spin_to_start = 1;
    self notify( #"stop_spinning" );
    self endon( #"death" );
    self endon( #"stop_spinning" );
    endyaw = self.startangles[ 1 ];
    currentyaw = self.angles[ 1 ];
    deltayaw = endyaw - currentyaw;
    
    while ( deltayaw < 0 )
    {
        deltayaw += 360;
    }
    
    spintime = self spinner_get_spin_time();
    spintime *= deltayaw / 360;
    
    if ( spintime > 0 )
    {
        self rotateyaw( deltayaw, spintime, 0 );
        self waittill( #"rotatedone" );
    }
    
    self stop_spinner_sound();
    self.angles = self.startangles;
}

// Namespace zm_temple
// Params 0
// Checksum 0x39eb210f, Offset: 0x4978
// Size: 0x2c
function start_spinner_sound()
{
    self.var_3539b4ec = self playloopsound( self.spin_sound );
}

// Namespace zm_temple
// Params 0
// Checksum 0xc60f5d95, Offset: 0x49b0
// Size: 0x54
function stop_spinner_sound()
{
    if ( isdefined( self.var_3539b4ec ) )
    {
        self stoploopsound( self.var_3539b4ec, 0.1 );
    }
    
    self playsound( 0, self.spin_stop_sound );
}

// Namespace zm_temple
// Params 0
// Checksum 0x48cf36bd, Offset: 0x4a10
// Size: 0x1b8
function temple_light_model_swap_init()
{
    if ( !level clientfield::get( "zombie_power_on" ) )
    {
        level waittill( #"zpo" );
    }
    
    wait 4.5;
    level notify( #"pl1" );
    players = getlocalplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        light_models = getentarray( i, "model_lights_on", "targetname" );
        
        for ( x = 0; x < light_models.size ; x++ )
        {
            light = light_models[ x ];
            
            if ( isdefined( light.script_string ) )
            {
                light setmodel( light.script_string );
                continue;
            }
            
            if ( light.model == "p_ztem_power_hanging_light_off" )
            {
                light setmodel( "p_ztem_power_hanging_light" );
                continue;
            }
            
            if ( light.model == "p_lights_cagelight02_off" )
            {
                light setmodel( "p_lights_cagelight02_on" );
            }
        }
    }
}

// Namespace zm_temple
// Params 7
// Checksum 0xd7593ac4, Offset: 0x4bd0
// Size: 0x5c
function ragdoll_impact_watch_start( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    if ( newval )
    {
        self thread ragdoll_impact_watch( localclientnum );
    }
}

// Namespace zm_temple
// Params 1
// Checksum 0x659fd91e, Offset: 0x4c38
// Size: 0x1c6
function ragdoll_impact_watch( localclientnum )
{
    self endon( #"entityshutdown" );
    waittime = 0.016;
    gibspeed = 500;
    prevorigin = self.origin;
    wait waittime;
    prevvel = self.origin - prevorigin;
    prevspeed = length( prevvel );
    prevorigin = self.origin;
    wait waittime;
    firstloop = 1;
    
    while ( true )
    {
        vel = self.origin - prevorigin;
        speed = length( vel );
        
        if ( speed < prevspeed * 0.5 && prevspeed > gibspeed * waittime )
        {
            dir = vectornormalize( prevvel );
            self gib_ragdoll( localclientnum, dir );
            break;
        }
        
        if ( prevspeed < gibspeed * waittime && !firstloop )
        {
            break;
        }
        
        prevorigin = self.origin;
        prevvel = vel;
        prevspeed = speed;
        firstloop = 0;
        wait waittime;
    }
}

// Namespace zm_temple
// Params 2
// Checksum 0x124c3f6e, Offset: 0x4e08
// Size: 0x64
function gib_ragdoll( localclientnum, hitdir )
{
    if ( util::is_mature() )
    {
        playfx( localclientnum, level._effect[ "rag_doll_gib_mini" ], self.origin, hitdir * -1 );
    }
}

// Namespace zm_temple
// Params 7
// Checksum 0x71ac668e, Offset: 0x4e78
// Size: 0xe4
function maze_floor_controller_rumble( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
    player = getlocalplayers()[ localclientnum ];
    
    if ( player getentitynumber() != self getentitynumber() )
    {
        return;
    }
    
    if ( newval )
    {
        self thread maze_rumble_while_floor_shakes( localclientnum );
        return;
    }
    
    self notify( #"stop_maze_rumble" );
    self stoprumble( localclientnum, "slide_rumble" );
}

// Namespace zm_temple
// Params 1
// Checksum 0x36e38c48, Offset: 0x4f68
// Size: 0x48
function maze_rumble_while_floor_shakes( int_client_num )
{
    self endon( #"stop_maze_rumble" );
    
    while ( isdefined( self ) )
    {
        self playrumbleonentity( int_client_num, "slide_rumble" );
        wait 0.05;
    }
}

// Namespace zm_temple
// Params 7
// Checksum 0x2c7038a1, Offset: 0x4fb8
// Size: 0xdc
function function_425904c0( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump )
{
    if ( newval )
    {
        player = getlocalplayer( localclientnum );
        
        if ( self == player )
        {
            self playrumblelooponentity( localclientnum, "tank_rumble" );
        }
        
        return;
    }
    
    player = getlocalplayer( localclientnum );
    
    if ( self == player )
    {
        self stoprumble( localclientnum, "tank_rumble" );
    }
}

