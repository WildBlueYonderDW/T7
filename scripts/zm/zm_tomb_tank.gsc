#using scripts/codescripts/struct;
#using scripts/shared/ai/zombie_shared;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/array_shared;
#using scripts/shared/audio_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/hud_shared;
#using scripts/shared/laststand_shared;
#using scripts/shared/math_shared;
#using scripts/shared/util_shared;
#using scripts/shared/vehicle_shared;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_powerups;
#using scripts/zm/_zm_score;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_weap_staff_fire;
#using scripts/zm/_zm_zonemgr;
#using scripts/zm/zm_tomb_amb;
#using scripts/zm/zm_tomb_utility;
#using scripts/zm/zm_tomb_vo;

#namespace zm_tomb_tank;

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x42435215, Offset: 0xa50
// Size: 0xe4
function init()
{
    clientfield::register( "vehicle", "tank_tread_fx", 21000, 1, "int" );
    clientfield::register( "vehicle", "tank_flamethrower_fx", 21000, 2, "int" );
    clientfield::register( "vehicle", "tank_cooldown_fx", 21000, 2, "int" );
    callback::on_spawned( &onplayerspawned );
    level.enemy_location_override_func = &enemy_location_override;
    level.zm_mantle_over_40_move_speed_override = &zm_mantle_over_40_move_speed_override;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xed70b033, Offset: 0xb40
// Size: 0xec
function main()
{
    level.vh_tank = getent( "tank", "targetname" );
    level.vh_tank tank_setup();
    level.vh_tank thread tank_discovery_vo();
    level thread zm_tomb_vo::watch_occasional_line( "tank", "tank_flame_zombie", "vo_tank_flame_zombie" );
    level thread zm_tomb_vo::watch_occasional_line( "tank", "tank_leave", "vo_tank_leave" );
    level thread zm_tomb_vo::watch_occasional_line( "tank", "tank_cooling", "vo_tank_cooling" );
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x4db0abfb, Offset: 0xc38
// Size: 0x1c
function onplayerspawned()
{
    self.b_already_on_tank = 0;
    self.var_32857832 = 0;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x5aca20d2, Offset: 0xc60
// Size: 0x1c8
function tank_discovery_vo()
{
    max_dist_sq = 640000;
    level flag::wait_till( "activate_zone_village_0" );
    
    while ( true )
    {
        a_players = getplayers();
        
        foreach ( e_player in a_players )
        {
            dist_sq = distance2dsquared( level.vh_tank.origin, e_player.origin );
            height_diff = abs( level.vh_tank.origin[ 2 ] - e_player.origin[ 2 ] );
            
            if ( dist_sq < max_dist_sq && height_diff < 150 && !( isdefined( e_player.isspeaking ) && e_player.isspeaking ) )
            {
                e_player zm_audio::create_and_play_dialog( "tank", "discover_tank" );
                return;
            }
        }
        
        wait 0.1;
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x40d9feec, Offset: 0xe30
// Size: 0x340
function tank_drop_powerups()
{
    level flag::wait_till( "start_zombie_round_logic" );
    a_drop_nodes = [];
    
    for ( i = 0; i < 3 ; i++ )
    {
        drop_num = i + 1;
        a_drop_nodes[ i ] = getvehiclenode( "tank_powerup_drop_" + drop_num, "script_noteworthy" );
        a_drop_nodes[ i ].next_drop_round = level.round_number + i;
        s_drop = struct::get( "tank_powerup_drop_" + drop_num, "targetname" );
        a_drop_nodes[ i ].drop_pos = s_drop.origin;
    }
    
    a_possible_powerups = array( "nuke", "full_ammo", "zombie_blood", "insta_kill", "fire_sale", "double_points" );
    
    while ( true )
    {
        self flag::wait_till( "tank_moving" );
        
        foreach ( node in a_drop_nodes )
        {
            dist_sq = distance2dsquared( node.origin, self.origin );
            
            if ( dist_sq < 40000 )
            {
                a_players = get_players_on_tank( 1 );
                
                if ( a_players.size > 0 )
                {
                    if ( level.staff_part_count[ "elemental_staff_lightning" ] == 0 && level.round_number >= node.next_drop_round )
                    {
                        str_powerup = array::random( a_possible_powerups );
                        level thread zm_powerups::specific_powerup_drop( str_powerup, node.drop_pos );
                        node.next_drop_round = level.round_number + randomintrange( 8, 12 );
                        continue;
                    }
                    
                    level notify( #"sam_clue_tank", self );
                }
            }
        }
        
        wait 2;
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x6498439c, Offset: 0x1178
// Size: 0x86
function zm_mantle_over_40_move_speed_override()
{
    traversealias = "barrier_walk";
    
    switch ( self.zombie_move_speed )
    {
        case "chase_bus":
            traversealias = "barrier_sprint";
            break;
        default:
            assertmsg( "<dev string:x28>" + self.zombie_move_speed + "<dev string:x3f>" );
            break;
    }
    
    return traversealias;
}

#using_animtree( "generic" );

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xaf6d91fa, Offset: 0x1208
// Size: 0x24
function tankuseanimtree()
{
    self useanimtree( #animtree );
}

/#

    // Namespace zm_tomb_tank
    // Params 2
    // Checksum 0xb0fa175c, Offset: 0x1238
    // Size: 0xb4, Type: dev
    function drawtag( tag, opcolor )
    {
        org = self gettagorigin( tag );
        ang = self gettagangles( tag );
        box( org, ( -8, -8, 0 ), ( 8, 8, 8 ), ang[ 1 ], opcolor, 1, 0, 1 );
    }

    // Namespace zm_tomb_tank
    // Params 2
    // Checksum 0xa4d79dfc, Offset: 0x12f8
    // Size: 0xa8, Type: dev
    function draw_tank_tag( tag, opcolor )
    {
        self endon( #"death" );
        
        for ( ;; )
        {
            if ( self tank_tag_is_valid( tag ) )
            {
                drawtag( tag.str_tag, ( 0, 255, 0 ) );
            }
            else
            {
                drawtag( tag.str_tag, ( 255, 0, 0 ) );
            }
            
            wait 0.05;
        }
    }

    // Namespace zm_tomb_tank
    // Params 0
    // Checksum 0x895752b9, Offset: 0x13a8
    // Size: 0x368, Type: dev
    function tank_debug_tags()
    {
        setdvar( "<dev string:x66>", "<dev string:x71>" );
        adddebugcommand( "<dev string:x75>" );
        level flag::wait_till( "<dev string:xb1>" );
        a_spots = struct::get_array( "<dev string:xca>", "<dev string:xdf>" );
        
        while ( true )
        {
            if ( getdvarstring( "<dev string:x66>" ) == "<dev string:xf1>" )
            {
                if ( !( isdefined( self.tags_drawing ) && self.tags_drawing ) )
                {
                    foreach ( s_tag in self.a_tank_tags )
                    {
                        self thread draw_tank_tag( s_tag );
                    }
                    
                    self.tags_drawing = 1;
                }
                
                ang = self.angles;
                
                foreach ( s_spot in a_spots )
                {
                    org = self tank_get_jump_down_offset( s_spot );
                    box( org, ( -4, -4, 0 ), ( 4, 4, 4 ), ang[ 1 ], ( 128, 128, 0 ), 1, 0, 1 );
                }
                
                a_zombies = zombie_utility::get_round_enemy_array();
                
                foreach ( e_zombie in a_zombies )
                {
                    if ( isdefined( e_zombie.tank_state ) )
                    {
                        print3d( e_zombie.origin + ( 0, 0, 60 ), e_zombie.tank_state, ( 255, 0, 0 ), 1 );
                    }
                }
            }
            
            wait 0.05;
        }
    }

#/

// Namespace zm_tomb_tank
// Params 1
// Checksum 0xe418d3f8, Offset: 0x1718
// Size: 0x104
function tank_jump_down_store_offset( s_pos )
{
    v_up = anglestoup( self.angles );
    v_right = anglestoright( self.angles );
    v_fwd = anglestoforward( self.angles );
    offset = s_pos.origin - self.origin;
    s_pos.tank_offset = ( vectordot( v_fwd, offset ), vectordot( v_right, offset ), vectordot( v_up, offset ) );
}

// Namespace zm_tomb_tank
// Params 1
// Checksum 0x73325f26, Offset: 0x1828
// Size: 0xd6
function tank_get_jump_down_offset( s_pos )
{
    v_up = anglestoup( self.angles );
    v_right = anglestoright( self.angles );
    v_fwd = anglestoforward( self.angles );
    v_offset = s_pos.tank_offset;
    return self.origin + v_offset[ 0 ] * v_fwd + v_offset[ 1 ] * v_right + v_offset[ 2 ] * v_up;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x31a4d091, Offset: 0x1908
// Size: 0x714
function tank_setup()
{
    self flag::init( "tank_moving" );
    self flag::init( "tank_activated" );
    self flag::init( "tank_cooldown" );
    level.tank_boxes_enabled = 0;
    self.tag_occupied = [];
    self.health = 1000;
    self.n_players_on = 0;
    self.chase_pos_time = 0;
    self hidepart( "tag_flamethrower" );
    self setmovingplatformenabled( 1 );
    self.e_roof = getent( "vol_on_tank_watch", "targetname" );
    self.e_roof enablelinkto();
    self.e_roof linkto( self );
    self.var_4da798ac = spawn( "trigger_box", ( -8192, -3955.5, 144 ), 0, 96, 41.5, 52.5 );
    self.var_4da798ac enablelinkto();
    self.var_4da798ac linkto( self );
    self.t_use = getent( "trig_use_tank", "targetname" );
    self.t_use enablelinkto();
    self.t_use linkto( self );
    self.t_use sethintstring( &"ZM_TOMB_X2AT", 500 );
    self.t_use setcursorhint( "HINT_NOICON" );
    self.var_5c499e37 = getent( "tank_navmesh_cutter", "targetname" );
    self.var_5c499e37 enablelinkto();
    self.var_5c499e37 linkto( self );
    self.var_5c499e37 notsolid();
    self.t_hurt = getent( "trig_hurt_tank", "targetname" );
    self.t_hurt enablelinkto();
    self.t_hurt linkto( self );
    self.t_kill = spawn( "trigger_box", ( -8192, -4300, 36 ), 0, 200, 150, 80 );
    self.t_kill enablelinkto();
    self.t_kill linkto( self );
    self.var_e444d47d[ 0 ] = spawn( "trigger_box", ( -8280, -3960, 112 ), 0, 64, 60, 96 );
    self.var_e444d47d[ 0 ].angles = ( 0, 90, 0 );
    self.var_e444d47d[ 0 ] enablelinkto();
    self.var_e444d47d[ 0 ] linkto( self );
    self.var_e444d47d[ 1 ] = spawn( "trigger_box", ( -8104, -3960, 112 ), 0, 64, 60, 96 );
    self.var_e444d47d[ 1 ].angles = ( 0, 90, 0 );
    self.var_e444d47d[ 1 ] enablelinkto();
    self.var_e444d47d[ 1 ] linkto( self );
    self.w_flamethrower = getweapon( "zombie_markiv_flamethrower" );
    m_tank_path_blocker = getent( "tank_path_blocker", "targetname" );
    m_tank_path_blocker delete();
    a_tank_jump_down_spots = struct::get_array( "tank_jump_down_spots", "script_noteworthy" );
    
    foreach ( s_spot in a_tank_jump_down_spots )
    {
        self tank_jump_down_store_offset( s_spot );
    }
    
    self thread players_on_tank_update();
    self thread zombies_watch_tank();
    self thread function_c9714eb4();
    self thread function_617c74cb();
    self thread tank_station();
    self thread tank_run_flamethrowers();
    self thread do_treadfx();
    self thread do_cooldown_fx();
    self thread function_118e38b5();
    self thread tank_drop_powerups();
    
    /#
        self thread tank_debug_tags();
    #/
    
    self playloopsound( "zmb_tank_idle", 0.5 );
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x44384f02, Offset: 0x2028
// Size: 0x144
function function_c9714eb4()
{
    self endon( #"death" );
    level flag::wait_till( "start_zombie_round_logic" );
    
    do
    {
        for ( tag_index = 0; tag_index < self.a_tank_tags.size ; tag_index++ )
        {
            tag_origin = self gettagorigin( self.a_tank_tags[ tag_index ].str_tag );
            queryresult = positionquery_source_navigation( tag_origin, 0, 32, 128, 4 );
            
            if ( queryresult.data.size )
            {
                result = queryresult.data[ 0 ];
                self.a_tank_tags[ tag_index ].var_a6e72e82 = result.origin;
            }
        }
        
        self flag::wait_till( "tank_moving" );
        wait 0.05;
    }
    while ( true );
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x5999e775, Offset: 0x2178
// Size: 0x15c
function function_617c74cb()
{
    self endon( #"death" );
    level flag::wait_till( "start_zombie_round_logic" );
    
    do
    {
        for ( tag_index = 0; tag_index < self.a_mechz_tags.size ; tag_index++ )
        {
            tag_origin = self gettagorigin( self.a_mechz_tags[ tag_index ].str_tag );
            queryresult = positionquery_source_navigation( tag_origin, 0, 32, 128, 4 );
            
            if ( queryresult.data.size )
            {
                result = queryresult.data[ 0 ];
                self.a_mechz_tags[ tag_index ].var_a6e72e82 = result.origin;
            }
        }
        
        self flag::wait_till( "tank_moving" );
        self flag::wait_till_clear( "tank_moving" );
    }
    while ( true );
}

// Namespace zm_tomb_tank
// Params 1
// Checksum 0x9ca331f6, Offset: 0x22e0
// Size: 0xa4
function function_1db98f69( tag_name )
{
    foreach ( tag_struct in self.a_tank_tags )
    {
        if ( tag_struct.str_tag == tag_name )
        {
            return tag_struct.var_a6e72e82;
        }
    }
    
    return undefined;
}

// Namespace zm_tomb_tank
// Params 1
// Checksum 0xc045d631, Offset: 0x2390
// Size: 0xa4
function function_21d81b2c( tag_name )
{
    foreach ( tag_struct in self.a_mechz_tags )
    {
        if ( tag_struct.str_tag == tag_name )
        {
            return tag_struct.var_a6e72e82;
        }
    }
    
    return undefined;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x7434dae9, Offset: 0x2440
// Size: 0xf8
function do_cooldown_fx()
{
    self endon( #"death" );
    level flag::wait_till( "start_zombie_round_logic" );
    
    while ( true )
    {
        self clientfield::set( "tank_cooldown_fx", 2 );
        self flag::wait_till( "tank_moving" );
        self clientfield::set( "tank_cooldown_fx", 0 );
        self flag::wait_till( "tank_cooldown" );
        self clientfield::set( "tank_cooldown_fx", 1 );
        self flag::wait_till_clear( "tank_cooldown" );
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x8f1a1ced, Offset: 0x2540
// Size: 0x98
function do_treadfx()
{
    self endon( #"death" );
    
    while ( true )
    {
        self flag::wait_till( "tank_moving" );
        self clientfield::set( "tank_tread_fx", 1 );
        self flag::wait_till_clear( "tank_moving" );
        self clientfield::set( "tank_tread_fx", 0 );
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x977ee6f4, Offset: 0x25e0
// Size: 0xa0
function function_118e38b5()
{
    self endon( #"death" );
    self vehicle::lights_off();
    
    while ( true )
    {
        self flag::wait_till( "tank_moving" );
        self vehicle::lights_on();
        self flag::wait_till_clear( "tank_moving" );
        self vehicle::lights_off();
    }
}

// Namespace zm_tomb_tank
// Params 1
// Checksum 0xada032f4, Offset: 0x2688
// Size: 0x88
function disconnect_reconnect_paths( vh_tank )
{
    self endon( #"death" );
    
    while ( true )
    {
        self disconnectpaths();
        wait 1;
        
        while ( vh_tank getspeedmph() < 1 )
        {
            wait 0.05;
        }
        
        self connectpaths();
        wait 0.5;
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x649f6b6d, Offset: 0x2718
// Size: 0x94
function tank_rumble_update()
{
    while ( self.b_already_on_tank )
    {
        if ( level.vh_tank flag::get( "tank_moving" ) )
        {
            self clientfield::set_to_player( "player_rumble_and_shake", 6 );
        }
        else
        {
            self clientfield::set_to_player( "player_rumble_and_shake", 0 );
        }
        
        wait 1;
    }
    
    self clientfield::set_to_player( "player_rumble_and_shake", 0 );
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x996d8f02, Offset: 0x27b8
// Size: 0x330
function players_on_tank_update()
{
    level flag::wait_till( "start_zombie_round_logic" );
    self thread tank_disconnect_paths();
    
    while ( true )
    {
        a_players = getplayers();
        
        foreach ( e_player in a_players )
        {
            if ( zombie_utility::is_player_valid( e_player ) )
            {
                if ( isdefined( e_player.b_already_on_tank ) && !e_player.b_already_on_tank && e_player entity_on_tank() )
                {
                    e_player.b_already_on_tank = 1;
                    self.n_players_on++;
                    
                    if ( self flag::get( "tank_cooldown" ) )
                    {
                        level notify( #"vo_tank_cooling", e_player );
                    }
                    
                    e_player thread tank_rumble_update();
                    e_player thread tank_rides_around_map_achievement_watcher();
                    e_player thread tank_force_crouch_from_prone_after_on_tank();
                    
                    foreach ( trig in self.var_e444d47d )
                    {
                        e_player thread function_de2a4a6e( trig );
                    }
                    
                    e_player allowcrouch( 1 );
                    e_player allowprone( 0 );
                    continue;
                }
                
                if ( isdefined( e_player.b_already_on_tank ) && e_player.b_already_on_tank && !e_player entity_on_tank() )
                {
                    e_player.b_already_on_tank = 0;
                    self.n_players_on--;
                    level notify( #"vo_tank_leave", e_player );
                    e_player notify( #"player_jumped_off_tank" );
                    e_player clientfield::set_to_player( "player_rumble_and_shake", 0 );
                    e_player allowprone( 1 );
                }
            }
        }
        
        wait 0.05;
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x72ad89cd, Offset: 0x2af0
// Size: 0x5c
function tank_force_crouch_from_prone_after_on_tank()
{
    self endon( #"disconnect" );
    self endon( #"bled_out" );
    wait 1;
    
    if ( "prone" == self getstance() )
    {
        self setstance( "crouch" );
    }
}

// Namespace zm_tomb_tank
// Params 1
// Checksum 0x3b4fdc7b, Offset: 0x2b58
// Size: 0xb0
function function_de2a4a6e( trig )
{
    self endon( #"player_jumped_off_tank" );
    
    while ( self.b_already_on_tank )
    {
        trig waittill( #"trigger", player );
        
        if ( player == self && self isonground() )
        {
            v_push = anglestoforward( trig.angles ) * 150;
            self setvelocity( v_push );
        }
        
        wait 0.05;
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xc68f00da, Offset: 0x2c10
// Size: 0xe2
function tank_rides_around_map_achievement_watcher()
{
    self endon( #"death_or_disconnect" );
    self endon( #"player_jumped_off_tank" );
    
    if ( level.vh_tank flag::get( "tank_moving" ) )
    {
        level.vh_tank flag::wait_till_clear( "tank_moving" );
    }
    
    str_starting_location = level.vh_tank.str_location_current;
    
    do
    {
        level.vh_tank flag::wait_till( "tank_moving" );
        level.vh_tank flag::wait_till_clear( "tank_moving" );
    }
    while ( str_starting_location != level.vh_tank.str_location_current );
    
    self notify( #"rode_tank_around_map" );
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x8fcf0e4b, Offset: 0x2d00
// Size: 0xa0, Type: bool
function entity_on_tank()
{
    if ( self istouching( level.vh_tank.e_roof ) || !self isonground() && self istouching( level.vh_tank.var_4da798ac ) )
    {
        return true;
    }
    
    if ( self getgroundent() === level.vh_tank )
    {
        return true;
    }
    
    return false;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x22a3643f, Offset: 0x2da8
// Size: 0x104
function tank_station()
{
    self thread tank_watch_use();
    self thread tank_movement();
    a_call_boxes = getentarray( "trig_tank_station_call", "targetname" );
    
    foreach ( t_call_box in a_call_boxes )
    {
        t_call_box thread tank_call_box();
    }
    
    self.t_use waittill( #"trigger" );
    level.tank_boxes_enabled = 1;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x390023b2, Offset: 0x2eb8
// Size: 0x2a4
function tank_left_behind()
{
    wait 4;
    n_valid_dist_sq = 1000000;
    a_riders = get_players_on_tank( 1 );
    
    if ( a_riders.size == 0 )
    {
        return;
    }
    
    e_rider = array::random( a_riders );
    a_players = getplayers();
    a_victims = [];
    v_tank_fwd = anglestoforward( self.angles );
    
    foreach ( e_player in a_players )
    {
        if ( isdefined( e_player.b_already_on_tank ) && e_player.b_already_on_tank )
        {
            continue;
        }
        
        if ( distance2dsquared( e_player.origin, self.origin ) > n_valid_dist_sq )
        {
            continue;
        }
        
        v_to_tank = self.origin - e_player.origin;
        v_to_tank = vectornormalize( v_to_tank );
        
        if ( vectordot( v_to_tank, v_tank_fwd ) < 0 )
        {
            continue;
        }
        
        v_player_fwd = anglestoforward( e_player.angles );
        
        if ( vectordot( v_player_fwd, v_to_tank ) < 0 )
        {
            continue;
        }
        
        a_victims[ a_victims.size ] = e_player;
    }
    
    if ( a_victims.size == 0 )
    {
        return;
    }
    
    e_victim = array::random( a_victims );
    zm_tomb_vo::tank_left_behind_vo( e_victim, e_rider );
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x4ada75e, Offset: 0x3168
// Size: 0x1a0
function tank_watch_use()
{
    while ( true )
    {
        self.t_use waittill( #"trigger", e_player );
        cooling_down = self flag::get( "tank_cooldown" );
        
        if ( zombie_utility::is_player_valid( e_player ) && e_player.score >= 500 && !cooling_down )
        {
            self flag::set( "tank_activated" );
            self flag::set( "tank_moving" );
            e_player thread zm_audio::create_and_play_dialog( "tank", "tank_buy" );
            self thread tank_left_behind();
            e_player zm_score::minus_to_player_score( 500 );
            self waittill( #"tank_stop" );
            self playsound( "zmb_tank_stop" );
            self stoploopsound( 1.5 );
            
            if ( isdefined( self.b_call_box_used ) && self.b_call_box_used )
            {
                self.b_call_box_used = 0;
                self activate_tank_wait_with_no_cost();
            }
        }
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xb057ceb3, Offset: 0x3310
// Size: 0xa8
function activate_tank_wait_with_no_cost()
{
    self endon( #"call_box_used" );
    self.b_no_cost = 1;
    wait 0.05;
    self flag::wait_till_clear( "tank_cooldown" );
    self.t_use waittill( #"trigger", e_player );
    self flag::set( "tank_activated" );
    self flag::set( "tank_moving" );
    self.b_no_cost = 0;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x22e77461, Offset: 0x33c0
// Size: 0x19a
function tank_call_box()
{
    while ( true )
    {
        self waittill( #"trigger", e_player );
        cooling_down = level.vh_tank flag::get( "tank_cooldown" );
        
        if ( !level.vh_tank flag::get( "tank_activated" ) && e_player.score >= 500 && !cooling_down )
        {
            level.vh_tank notify( #"call_box_used" );
            level.vh_tank.b_call_box_used = 1;
            e_switch = getent( self.target, "targetname" );
            self setinvisibletoall();
            wait 0.05;
            e_switch rotatepitch( -180, 0.5 );
            e_switch waittill( #"rotatedone" );
            e_switch rotatepitch( 180, 0.5 );
            level.vh_tank.t_use useby( e_player );
            level.vh_tank waittill( #"tank_stop" );
        }
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x31bea109, Offset: 0x3568
// Size: 0x252
function tank_call_boxes_update()
{
    str_loc = level.vh_tank.str_location_current;
    a_trigs = getentarray( "trig_tank_station_call", "targetname" );
    moving = level.vh_tank flag::get( "tank_moving" );
    cooling = level.vh_tank flag::get( "tank_cooldown" );
    
    foreach ( trig in a_trigs )
    {
        at_this_station = trig.script_noteworthy == "call_box_" + str_loc;
        trig setcursorhint( "HINT_NOICON" );
        
        if ( moving )
        {
            trig setvisibletoall();
            trig sethintstring( &"ZM_TOMB_TNKM" );
            continue;
        }
        
        if ( !level.tank_boxes_enabled || at_this_station )
        {
            trig setinvisibletoall();
            continue;
        }
        
        if ( cooling )
        {
            trig setvisibletoall();
            trig sethintstring( &"ZM_TOMB_TNKC" );
            continue;
        }
        
        trig setvisibletoall();
        trig sethintstring( &"ZM_TOMB_X2CT", 500 );
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xce6a130e, Offset: 0x37c8
// Size: 0x420
function tank_movement()
{
    n_path_start = getvehiclenode( "tank_start", "targetname" );
    self.origin = n_path_start.origin;
    self.angles = n_path_start.angles;
    self.var_78665041 = 0;
    self.a_locations = array( "village", "bunkers" );
    n_location_index = 0;
    self.str_location_current = self.a_locations[ n_location_index ];
    tank_call_boxes_update();
    
    while ( true )
    {
        self flag::wait_till( "tank_activated" );
        
        if ( !self.var_78665041 )
        {
            self.var_78665041 = 1;
            self attachpath( n_path_start );
            self startpath();
            self thread follow_path( n_path_start );
            self setspeedimmediate( 0 );
        }
        
        /#
            iprintln( "<dev string:xf4>" );
        #/
        
        self thread tank_connect_paths();
        self playsound( "evt_tank_call" );
        self setspeedimmediate( 8 );
        self.t_use setinvisibletoall();
        tank_call_boxes_update();
        self thread tank_kill_players();
        self thread tank_cooldown_timer();
        self waittill( #"tank_stop" );
        self flag::set( "tank_cooldown" );
        self.t_use setvisibletoall();
        self.t_use sethintstring( &"ZM_TOMB_TNKC" );
        self flag::clear( "tank_moving" );
        self thread tank_disconnect_paths();
        self setspeedimmediate( 0 );
        n_location_index++;
        
        if ( n_location_index == self.a_locations.size )
        {
            n_location_index = 0;
        }
        
        self.str_location_current = self.a_locations[ n_location_index ];
        tank_call_boxes_update();
        self wait_for_tank_cooldown();
        self flag::clear( "tank_cooldown" );
        
        if ( isdefined( self.b_no_cost ) && self.b_no_cost )
        {
            self.t_use sethintstring( &"ZM_TOMB_X2ATF" );
        }
        else
        {
            self.t_use sethintstring( &"ZM_TOMB_X2AT", 500 );
        }
        
        self.t_use setcursorhint( "HINT_NOICON" );
        self flag::clear( "tank_activated" );
        tank_call_boxes_update();
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x96d977eb, Offset: 0x3bf0
// Size: 0x54
function tank_disconnect_paths()
{
    self endon( #"death" );
    
    while ( self getspeedmph() > 0 )
    {
        wait 0.05;
    }
    
    self.var_5c499e37 disconnectpaths();
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x2a167201, Offset: 0x3c50
// Size: 0x24
function tank_connect_paths()
{
    self endon( #"death" );
    self.var_5c499e37 connectpaths();
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x1693591a, Offset: 0x3c80
// Size: 0x134
function tank_kill_players()
{
    self endon( #"tank_cooldown" );
    
    foreach ( player in level.players )
    {
        player.var_32857832 = 0;
    }
    
    while ( true )
    {
        self.t_kill waittill( #"trigger", player );
        
        if ( !( isdefined( player.b_already_on_tank ) && player.b_already_on_tank ) && !( isdefined( player.var_d0cd73ec ) && player.var_d0cd73ec ) )
        {
            player thread tank_ran_me_over();
            wait 0.05;
            continue;
        }
        
        player.var_32857832 = 0;
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x4129078, Offset: 0x3dc0
// Size: 0x2fe
function tank_ran_me_over()
{
    self.var_32857832++;
    
    if ( self.var_32857832 < 20 )
    {
        self dodamage( 5, self.origin );
        return;
    }
    
    self.var_d0cd73ec = 1;
    self disableinvulnerability();
    self dodamage( self.health + 1000, self.origin );
    a_nodes = getnodesinradiussorted( self.origin, 256, 0, 72, "path", 15 );
    
    foreach ( node in a_nodes )
    {
        str_zone = zm_zonemgr::get_zone_from_position( node.origin );
        
        if ( !isdefined( str_zone ) )
        {
            continue;
        }
        
        if ( !( isdefined( node.b_player_downed_here ) && node.b_player_downed_here ) )
        {
            start_wait = 0;
            black_screen_wait = 4;
            fade_in_time = 0.01;
            fade_out_time = 0.2;
            self thread hud::fade_to_black_for_x_sec( start_wait, black_screen_wait, fade_in_time, fade_out_time, "black" );
            node.b_player_downed_here = 1;
            e_linker = spawn( "script_origin", self.origin );
            self playerlinkto( e_linker );
            e_linker moveto( node.origin + ( 0, 0, 8 ), 1 );
            e_linker wait_to_unlink( self );
            node.b_player_downed_here = undefined;
            e_linker delete();
            self.var_d0cd73ec = undefined;
            return;
        }
    }
    
    self.var_d0cd73ec = undefined;
}

// Namespace zm_tomb_tank
// Params 1
// Checksum 0x859f9844, Offset: 0x40c8
// Size: 0x34
function wait_to_unlink( player )
{
    player endon( #"disconnect" );
    wait 4;
    self unlink();
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x8e40fcf7, Offset: 0x4108
// Size: 0xcc
function tank_cooldown_timer()
{
    self.n_cooldown_timer = 0;
    str_location_original = self.str_location_current;
    self playsound( "zmb_tank_start" );
    self stoploopsound( 0.4 );
    wait 0.4;
    self playloopsound( "zmb_tank_loop", 1 );
    
    while ( str_location_original == self.str_location_current )
    {
        self.n_cooldown_timer += self.n_players_on * 0.05;
        wait 0.05;
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x66fb1fe3, Offset: 0x41e0
// Size: 0xbc
function wait_for_tank_cooldown()
{
    self thread snd_fuel();
    
    if ( self.n_cooldown_timer < 2 )
    {
        self.n_cooldown_timer = 2;
    }
    else if ( self.n_cooldown_timer > 120 )
    {
        self.n_cooldown_timer = 120;
    }
    
    wait self.n_cooldown_timer;
    level notify( #"stp_cd" );
    self playsound( "zmb_tank_ready" );
    self playloopsound( "zmb_tank_idle" );
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x99d2cf5e, Offset: 0x42a8
// Size: 0xfc
function snd_fuel()
{
    snd_cd_ent = spawn( "script_origin", self.origin );
    snd_cd_ent linkto( self );
    wait 4;
    snd_cd_ent playsound( "zmb_tank_fuel_start" );
    wait 0.5;
    snd_cd_ent playloopsound( "zmb_tank_fuel_loop" );
    level waittill( #"stp_cd" );
    snd_cd_ent stoploopsound( 0.5 );
    snd_cd_ent playsound( "zmb_tank_fuel_end" );
    wait 2;
    snd_cd_ent delete();
}

// Namespace zm_tomb_tank
// Params 1
// Checksum 0x6a064331, Offset: 0x43b0
// Size: 0x16c
function follow_path( n_path_start )
{
    self endon( #"death" );
    assert( isdefined( n_path_start ), "<dev string:x108>" );
    self notify( #"newpath" );
    self endon( #"newpath" );
    n_next_point = n_path_start;
    
    while ( isdefined( n_next_point ) )
    {
        self.n_next_node = getvehiclenode( n_next_point.target, "targetname" );
        self waittill( #"reached_node", n_next_point );
        
        if ( isdefined( n_next_point.script_noteworthy ) && issubstr( n_next_point.script_noteworthy, "fxexp" ) )
        {
            exploder::exploder( n_next_point.script_noteworthy );
        }
        
        self.n_current = n_next_point;
        n_next_point notify( #"trigger", self );
        
        if ( isdefined( n_next_point.script_noteworthy ) )
        {
            self notify( n_next_point.script_noteworthy );
            self notify( #"noteworthy", n_next_point.script_noteworthy, n_next_point );
        }
        
        waittillframeend();
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x18a250b9, Offset: 0x4528
// Size: 0x448
function tank_tag_array_setup()
{
    a_tank_tags = [];
    a_tank_tags[ 0 ] = spawnstruct();
    a_tank_tags[ 0 ].str_tag = "window_left_1_jmp_jnt";
    a_tank_tags[ 0 ].disabled_at_bunker = 1;
    a_tank_tags[ 0 ].disabled_at_church = 1;
    a_tank_tags[ 0 ].side = "left";
    a_tank_tags[ 0 ].anim_base = "_markiv_leftfront";
    a_tank_tags[ 1 ] = spawnstruct();
    a_tank_tags[ 1 ].str_tag = "window_left_2_jmp_jnt";
    a_tank_tags[ 1 ].disabled_at_bunker = 1;
    a_tank_tags[ 1 ].disabled_at_church = 1;
    a_tank_tags[ 1 ].side = "left";
    a_tank_tags[ 1 ].anim_base = "_markiv_leftmid";
    a_tank_tags[ 2 ] = spawnstruct();
    a_tank_tags[ 2 ].str_tag = "window_left_3_jmp_jnt";
    a_tank_tags[ 2 ].disabled_at_bunker = 1;
    a_tank_tags[ 2 ].disabled_at_church = 1;
    a_tank_tags[ 2 ].side = "left";
    a_tank_tags[ 2 ].anim_base = "_markiv_leftrear";
    a_tank_tags[ 3 ] = spawnstruct();
    a_tank_tags[ 3 ].str_tag = "window_right_front_jmp_jnt";
    a_tank_tags[ 3 ].side = "front";
    a_tank_tags[ 3 ].anim_base = "_markiv_front";
    a_tank_tags[ 4 ] = spawnstruct();
    a_tank_tags[ 4 ].str_tag = "window_right_1_jmp_jnt";
    a_tank_tags[ 4 ].side = "right";
    a_tank_tags[ 4 ].anim_base = "_markiv_rightfront";
    a_tank_tags[ 5 ] = spawnstruct();
    a_tank_tags[ 5 ].str_tag = "window_right_2_jmp_jnt";
    a_tank_tags[ 5 ].disabled_at_church = 1;
    a_tank_tags[ 5 ].side = "right";
    a_tank_tags[ 5 ].anim_base = "_markiv_rightmid";
    a_tank_tags[ 6 ] = spawnstruct();
    a_tank_tags[ 6 ].str_tag = "window_right_3_jmp_jnt";
    a_tank_tags[ 6 ].disabled_at_church = 1;
    a_tank_tags[ 6 ].side = "right";
    a_tank_tags[ 6 ].anim_base = "_markiv_rightrear";
    a_tank_tags[ 7 ] = spawnstruct();
    a_tank_tags[ 7 ].str_tag = "window_left_rear_jmp_jnt";
    a_tank_tags[ 7 ].side = "rear";
    a_tank_tags[ 7 ].anim_base = "_markiv_rear";
    return a_tank_tags;
}

// Namespace zm_tomb_tank
// Params 1
// Checksum 0xddf7fc78, Offset: 0x4978
// Size: 0x1a4
function get_players_on_tank( valid_targets_only )
{
    if ( !isdefined( valid_targets_only ) )
    {
        valid_targets_only = 0;
    }
    
    a_players_on_tank = [];
    a_players = getplayers();
    
    foreach ( e_player in a_players )
    {
        if ( isdefined( e_player.b_already_on_tank ) && zombie_utility::is_player_valid( e_player ) && e_player.b_already_on_tank )
        {
            if ( !( isdefined( e_player.ignoreme ) && e_player.ignoreme ) && ( !valid_targets_only || zombie_utility::is_player_valid( e_player ) ) )
            {
                if ( !isdefined( a_players_on_tank ) )
                {
                    a_players_on_tank = [];
                }
                else if ( !isarray( a_players_on_tank ) )
                {
                    a_players_on_tank = array( a_players_on_tank );
                }
                
                a_players_on_tank[ a_players_on_tank.size ] = e_player;
            }
        }
    }
    
    return a_players_on_tank;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x20ad0f7d, Offset: 0x4b28
// Size: 0x1a2
function mechz_tag_array_setup()
{
    a_mechz_tags = [];
    a_mechz_tags[ 0 ] = spawnstruct();
    a_mechz_tags[ 0 ].str_tag = "tag_mechz_1";
    a_mechz_tags[ 0 ].in_use = 0;
    a_mechz_tags[ 0 ].in_use_by = undefined;
    a_mechz_tags[ 1 ] = spawnstruct();
    a_mechz_tags[ 1 ].str_tag = "tag_mechz_2";
    a_mechz_tags[ 1 ].in_use = 0;
    a_mechz_tags[ 1 ].in_use_by = undefined;
    a_mechz_tags[ 2 ] = spawnstruct();
    a_mechz_tags[ 2 ].str_tag = "tag_mechz_3";
    a_mechz_tags[ 2 ].in_use = 0;
    a_mechz_tags[ 2 ].in_use_by = undefined;
    a_mechz_tags[ 3 ] = spawnstruct();
    a_mechz_tags[ 3 ].str_tag = "tag_mechz_4";
    a_mechz_tags[ 3 ].in_use = 0;
    a_mechz_tags[ 3 ].in_use_by = undefined;
    return a_mechz_tags;
}

// Namespace zm_tomb_tank
// Params 2
// Checksum 0xf421959, Offset: 0x4cd8
// Size: 0x8e
function mechz_tag_in_use_cleanup( mechz, tag_struct_index )
{
    mechz notify( #"kill_mechz_tag_in_use_cleanup" );
    mechz util::waittill_any_timeout( 30, "death", "kill_ft", "tank_flamethrower_attack_complete", "kill_mechz_tag_in_use_cleanup" );
    self.a_mechz_tags[ tag_struct_index ].in_use = 0;
    self.a_mechz_tags[ tag_struct_index ].in_use_by = undefined;
}

// Namespace zm_tomb_tank
// Params 2
// Checksum 0xbba25d5f, Offset: 0x4d70
// Size: 0x256
function get_closest_mechz_tag_on_tank( mechz, target_org )
{
    best_dist = -1;
    best_tag_index = undefined;
    
    for ( i = 0; i < self.a_mechz_tags.size ; i++ )
    {
        if ( self.a_mechz_tags[ i ].in_use && self.a_mechz_tags[ i ].in_use_by != mechz )
        {
            continue;
        }
        
        s_tag = self.a_mechz_tags[ i ];
        tag_org = self gettagorigin( s_tag.str_tag );
        dist = distancesquared( tag_org, target_org );
        
        if ( dist < best_dist || best_dist < 0 )
        {
            best_dist = dist;
            best_tag_index = i;
        }
    }
    
    if ( isdefined( best_tag_index ) )
    {
        for ( i = 0; i < self.a_mechz_tags.size ; i++ )
        {
            if ( self.a_mechz_tags[ i ].in_use && self.a_mechz_tags[ i ].in_use_by == mechz )
            {
                self.a_mechz_tags[ i ].in_use = 0;
                self.a_mechz_tags[ i ].in_use_by = undefined;
            }
        }
        
        self.a_mechz_tags[ best_tag_index ].in_use = 1;
        self.a_mechz_tags[ best_tag_index ].in_use_by = mechz;
        self thread mechz_tag_in_use_cleanup( mechz, best_tag_index );
        return self.a_mechz_tags[ best_tag_index ].str_tag;
    }
    
    return undefined;
}

// Namespace zm_tomb_tank
// Params 2
// Checksum 0x4539bd2, Offset: 0x4fd0
// Size: 0x1b2, Type: bool
function tank_tag_is_valid( s_tag, disable_sides )
{
    if ( !isdefined( disable_sides ) )
    {
        disable_sides = 0;
    }
    
    if ( disable_sides )
    {
        if ( s_tag.side == "right" || s_tag.side == "left" )
        {
            return false;
        }
    }
    
    if ( self flag::get( "tank_moving" ) )
    {
        if ( s_tag.side == "front" )
        {
            return false;
        }
        
        if ( !isdefined( self.n_next_node ) )
        {
            return true;
        }
        
        if ( !isdefined( self.n_next_node.script_string ) )
        {
            return true;
        }
        
        if ( issubstr( self.n_next_node.script_string, "disable_" + s_tag.side ) )
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    
    at_church = self.str_location_current == "village";
    at_bunker = self.str_location_current == "bunkers";
    
    if ( at_church )
    {
        return !( isdefined( s_tag.disabled_at_church ) && s_tag.disabled_at_church );
    }
    else if ( at_bunker )
    {
        return !( isdefined( s_tag.disabled_at_bunker ) && s_tag.disabled_at_bunker );
    }
    
    return true;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xe6e8d67d, Offset: 0x5190
// Size: 0x128
function zombies_watch_tank()
{
    a_tank_tags = tank_tag_array_setup();
    self.a_tank_tags = a_tank_tags;
    a_mechz_tags = mechz_tag_array_setup();
    self.a_mechz_tags = a_mechz_tags;
    
    while ( true )
    {
        a_zombies = zombie_utility::get_round_enemy_array();
        
        foreach ( e_zombie in a_zombies )
        {
            if ( !isdefined( e_zombie.tank_state ) )
            {
                e_zombie thread tank_zombie_think();
            }
        }
        
        util::wait_network_frame();
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x84933793, Offset: 0x52c0
// Size: 0x14
function start_chasing_tank()
{
    self.tank_state = "tank_chase";
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xa3ffb19a, Offset: 0x52e0
// Size: 0x7c
function stop_chasing_tank()
{
    self.tank_state = "none";
    self.str_tank_tag = undefined;
    self.var_69140779 = undefined;
    self.tank_tag = undefined;
    self.b_on_tank = 0;
    self.tank_re_eval_time = undefined;
    self notify( #"change_goal" );
    
    if ( isdefined( self.zombie_move_speed_original ) )
    {
        self zombie_utility::set_zombie_run_cycle( self.zombie_move_speed_original );
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x9836ca53, Offset: 0x5368
// Size: 0x88
function choose_tag_and_chase()
{
    s_tag = self get_closest_valid_tank_tag();
    
    if ( isdefined( s_tag ) )
    {
        self.str_tank_tag = s_tag.str_tag;
        self.var_69140779 = s_tag.anim_base;
        self.tank_tag = s_tag;
        self.tank_state = "tag_chase";
        return;
    }
    
    wait 1;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xccc98fd7, Offset: 0x53f8
// Size: 0xf8
function choose_tag_and_jump_down()
{
    s_tag = self get_closest_valid_tank_tag( 1 );
    
    if ( isdefined( s_tag ) )
    {
        self.str_tank_tag = s_tag.str_tag;
        self.var_69140779 = s_tag.anim_base;
        self.tank_tag = struct::get( s_tag.str_tag + "_down_start", "targetname" );
        self.tank_state = "exit_tank";
        self zombie_utility::set_zombie_run_cycle( "walk" );
        assert( isdefined( self.tank_tag ) );
        return;
    }
    
    wait 1;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xa91d041d, Offset: 0x54f8
// Size: 0x204
function climb_tag()
{
    self endon( #"death" );
    self.tank_state = "climbing";
    self.b_on_tank = 1;
    str_tag = self.str_tank_tag;
    str_anim_base = self.var_69140779;
    self linkto( level.vh_tank, str_tag );
    v_tag_origin = level.vh_tank gettagorigin( str_tag );
    v_tag_angles = level.vh_tank gettagangles( str_tag );
    str_anim_alias = "_jump_up" + str_anim_base;
    
    if ( level.vh_tank flag::get( "tank_moving" ) && str_tag == "window_left_rear_jmp_jnt" )
    {
        str_anim_alias = "_jump_up_onto_markiv_rear";
    }
    
    if ( self.missinglegs )
    {
        str_anim_alias = "_crawl" + str_anim_alias;
    }
    
    self.b_climbing_tank = 1;
    self animscripted( "climb_up_tank_anim", v_tag_origin, v_tag_angles, "ai_zm_dlc5_zombie" + str_anim_alias );
    self zombie_shared::donotetracks( "climb_up_tank_anim" );
    self unlink();
    self.b_climbing_tank = 0;
    level.vh_tank tank_mark_tag_occupied( str_tag, self, 0 );
    self set_zombie_on_tank();
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x735fbcbc, Offset: 0x5708
// Size: 0x34
function set_zombie_on_tank()
{
    self setgoalpos( self.origin );
    self.tank_state = "on_tank";
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x156f5f48, Offset: 0x5748
// Size: 0x1dc
function jump_down_tag()
{
    self endon( #"death" );
    self.tank_state = "jumping_down";
    str_tag = self.str_tank_tag;
    str_anim_base = self.var_69140779;
    self linkto( level.vh_tank, str_tag );
    v_tag_origin = level.vh_tank gettagorigin( str_tag );
    v_tag_angles = level.vh_tank gettagangles( str_tag );
    self setgoalpos( v_tag_origin );
    str_anim_alias = "_jump_down" + str_anim_base;
    
    if ( self.missinglegs )
    {
        str_anim_alias = "_crawl" + str_anim_alias;
    }
    
    self.b_climbing_tank = 1;
    self animscripted( "climb_down_tank_anim", v_tag_origin, v_tag_angles, "ai_zm_dlc5_zombie" + str_anim_alias );
    self zombie_shared::donotetracks( "climb_down_tank_anim" );
    self unlink();
    self.b_climbing_tank = 0;
    level.vh_tank tank_mark_tag_occupied( str_tag, self, 0 );
    self.pursuing_tank_tag = 0;
    stop_chasing_tank();
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xb22019ab, Offset: 0x5930
// Size: 0xd8
function watch_zombie_fall_off_tank()
{
    self endon( #"death" );
    
    while ( true )
    {
        if ( self.tank_state == "on_tank" || self.tank_state == "exit_tank" )
        {
            if ( !self entity_on_tank() )
            {
                stop_chasing_tank();
            }
            
            wait 0.5;
        }
        else if ( self.tank_state == "none" )
        {
            if ( self entity_on_tank() )
            {
                self set_zombie_on_tank();
            }
            
            wait 5;
        }
        
        util::wait_network_frame();
    }
}

// Namespace zm_tomb_tank
// Params 4
// Checksum 0x193bac97, Offset: 0x5a10
// Size: 0x7e, Type: bool
function in_range_2d( v1, v2, range, vert_allowance )
{
    if ( abs( v1[ 2 ] - v2[ 2 ] ) > vert_allowance )
    {
        return false;
    }
    
    return distance2dsquared( v1, v2 ) < range * range;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x3cd77fcd, Offset: 0x5a98
// Size: 0x7f0
function tank_zombie_think()
{
    self endon( #"death" );
    self.tank_state = "none";
    self thread watch_zombie_fall_off_tank();
    think_time = 0.5;
    
    while ( true )
    {
        a_players_on_tank = get_players_on_tank( 1 );
        tag_range = 32;
        
        if ( level.vh_tank flag::get( "tank_moving" ) )
        {
            tag_range = 64;
        }
        
        switch ( self.tank_state )
        {
            case "none":
                if ( !isdefined( self.ai_state ) || self.ai_state != "find_flesh" )
                {
                    break;
                }
                
                if ( a_players_on_tank.size == 0 )
                {
                    break;
                }
                
                if ( zombie_utility::is_player_valid( self.favoriteenemy ) )
                {
                    if ( isdefined( self.favoriteenemy.b_already_on_tank ) && self.favoriteenemy.b_already_on_tank )
                    {
                        self start_chasing_tank();
                    }
                }
                else
                {
                    a_players = getplayers();
                    a_eligible_players = [];
                    
                    foreach ( e_player in a_players )
                    {
                        if ( !( isdefined( e_player.ignoreme ) && e_player.ignoreme ) && zombie_utility::is_player_valid( e_player ) )
                        {
                            a_eligible_players[ a_eligible_players.size ] = e_player;
                        }
                    }
                    
                    if ( a_eligible_players.size > 0 )
                    {
                        if ( a_players_on_tank.size == a_players.size )
                        {
                            self.favoriteenemy = array::random( a_eligible_players );
                        }
                        else if ( self.var_13ed8adf === level.time )
                        {
                            self.favoriteenemy = zm_tomb_utility::tomb_get_closest_player_using_paths( self.origin, a_eligible_players );
                        }
                        else
                        {
                            self.favoriteenemy = self.var_85a4d178;
                        }
                    }
                }
                
                break;
            default:
                if ( a_players_on_tank.size == 0 )
                {
                    self stop_chasing_tank();
                    break;
                }
                
                dist_sq_to_tank = distancesquared( self.origin, level.vh_tank.origin );
                
                if ( dist_sq_to_tank < 250000 )
                {
                    self choose_tag_and_chase();
                }
                
                if ( !self.missinglegs && self.zombie_move_speed != "super_sprint" && !( isdefined( self.is_traversing ) && self.is_traversing ) && self.ai_state == "find_flesh" )
                {
                    if ( level.vh_tank flag::get( "tank_moving" ) )
                    {
                        self zombie_utility::set_zombie_run_cycle( "super_sprint" );
                        self thread zombie_chasing_tank_turn_crawler();
                    }
                }
                
                break;
            case "tag_chase":
                if ( !isdefined( self.tank_re_eval_time ) )
                {
                    self.tank_re_eval_time = 6;
                }
                else if ( self.tank_re_eval_time <= 0 )
                {
                    if ( self entity_on_tank() )
                    {
                        self set_zombie_on_tank();
                    }
                    else
                    {
                        self stop_chasing_tank();
                    }
                    
                    break;
                }
                
                self notify( #"stop_path_to_tag" );
                
                if ( a_players_on_tank.size == 0 )
                {
                    self stop_chasing_tank();
                    break;
                }
                
                dist_sq_to_tank = distancesquared( self.origin, level.vh_tank.origin );
                
                if ( dist_sq_to_tank > 1000000 || a_players_on_tank.size == 0 )
                {
                    start_chasing_tank();
                    break;
                }
                
                v_tag = level.vh_tank gettagorigin( self.str_tank_tag );
                
                if ( self.str_tank_tag == "window_right_front_jmp_jnt" )
                {
                    v_tag = getstartorigin( v_tag, level.vh_tank gettagangles( self.str_tank_tag ), "ai_zm_dlc5_zombie_jump_up_markiv_front" );
                }
                
                if ( in_range_2d( v_tag, self.origin, tag_range, tag_range ) )
                {
                    tag_claimed = level.vh_tank tank_mark_tag_occupied( self.str_tank_tag, self, 1 );
                    
                    if ( tag_claimed )
                    {
                        self thread climb_tag();
                    }
                }
                else
                {
                    self.tank_re_eval_time -= think_time;
                }
                
                break;
            case "climbing":
                break;
            case "on_tank":
                if ( a_players_on_tank.size == 0 )
                {
                    choose_tag_and_jump_down();
                }
                else if ( !isdefined( self.favoriteenemy ) || !zombie_utility::is_player_valid( self.favoriteenemy, 1 ) )
                {
                    self.favoriteenemy = array::random( a_players_on_tank );
                }
                
                break;
            case "exit_tank":
                self notify( #"stop_exit_tank" );
                
                if ( a_players_on_tank.size > 0 )
                {
                    self set_zombie_on_tank();
                    break;
                }
                
                v_tag_pos = level.vh_tank tank_get_jump_down_offset( self.tank_tag );
                
                if ( in_range_2d( v_tag_pos, self.origin, tag_range, tag_range ) )
                {
                    tag_claimed = level.vh_tank tank_mark_tag_occupied( self.str_tank_tag, self, 1 );
                    
                    if ( tag_claimed )
                    {
                        self thread jump_down_tag();
                    }
                }
                else
                {
                    wait 1;
                }
                
                break;
            case "jumping_down":
                break;
        }
        
        wait think_time;
    }
}

// Namespace zm_tomb_tank
// Params 2
// Checksum 0xad068010, Offset: 0x6290
// Size: 0x178
function update_zombie_goal_pos( str_position, stop_notify )
{
    self notify( #"change_goal" );
    self endon( #"death" );
    self endon( #"goal" );
    self endon( #"near_goal" );
    self endon( #"change_goal" );
    
    if ( isdefined( stop_notify ) )
    {
        self endon( stop_notify );
    }
    
    s_script_origin = struct::get( str_position, "targetname" );
    
    while ( self.tank_state != "none" )
    {
        if ( isdefined( s_script_origin ) )
        {
            v_origin = level.vh_tank tank_get_jump_down_offset( s_script_origin );
            
            /#
                if ( getdvarstring( "<dev string:x66>" ) == "<dev string:xf1>" )
                {
                    line( self.origin + ( 0, 0, 30 ), v_origin );
                }
            #/
        }
        else
        {
            v_origin = level.vh_tank gettagorigin( str_position );
        }
        
        self setgoalpos( v_origin );
        wait 0.05;
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x1bb8d74f, Offset: 0x6410
// Size: 0x64
function zombie_chasing_tank_turn_crawler()
{
    self notify( #"tank_watch_turn_crawler" );
    self endon( #"tank_watch_turn_crawler" );
    self endon( #"death" );
    
    while ( !self.missinglegs )
    {
        wait 0.05;
    }
    
    self zombie_utility::set_zombie_run_cycle( self.zombie_move_speed_original );
}

// Namespace zm_tomb_tank
// Params 3
// Checksum 0xa97db503, Offset: 0x6480
// Size: 0x14e
function tank_mark_tag_occupied( str_tag, ai_occupier, set_occupied )
{
    current_occupier = self.tag_occupied[ str_tag ];
    min_dist_sq_to_tag = 1024;
    
    if ( set_occupied )
    {
        if ( !isdefined( current_occupier ) )
        {
            self.tag_occupied[ str_tag ] = ai_occupier;
            return 1;
        }
        else if ( ai_occupier == current_occupier || !isalive( current_occupier ) )
        {
            dist_sq_to_tag = distance2dsquared( ai_occupier.origin, self gettagorigin( str_tag ) );
            
            if ( dist_sq_to_tag < min_dist_sq_to_tag )
            {
                self.tag_occupied[ str_tag ] = ai_occupier;
                return 1;
            }
        }
        
        return 0;
    }
    
    if ( !isdefined( current_occupier ) )
    {
        return 1;
    }
    
    if ( current_occupier != ai_occupier )
    {
        return 0;
    }
    
    self.tag_occupied[ str_tag ] = undefined;
    return 1;
}

// Namespace zm_tomb_tank
// Params 1
// Checksum 0x464d48d9, Offset: 0x65d8
// Size: 0x1aa, Type: bool
function is_tag_crowded( str_tag )
{
    v_tag = self gettagorigin( str_tag );
    a_zombies = getaiteamarray( level.zombie_team );
    n_nearby_zombies = 0;
    
    foreach ( e_zombie in a_zombies )
    {
        dist_sq = distancesquared( v_tag, e_zombie.origin );
        
        if ( dist_sq < 4096 )
        {
            if ( isdefined( e_zombie.tank_state ) )
            {
                if ( e_zombie.tank_state != "tank_chase" && e_zombie.tank_state != "tag_chase" && e_zombie.tank_state != "none" )
                {
                    continue;
                }
            }
            
            n_nearby_zombies++;
            
            if ( n_nearby_zombies >= 4 )
            {
                return true;
            }
        }
    }
    
    return false;
}

// Namespace zm_tomb_tank
// Params 1
// Checksum 0x2a115e7b, Offset: 0x6790
// Size: 0x1cc
function get_closest_valid_tank_tag( jumping_down )
{
    if ( !isdefined( jumping_down ) )
    {
        jumping_down = 0;
    }
    
    closest_dist_sq = 100000000;
    closest_tag = undefined;
    disable_sides = 0;
    
    if ( jumping_down && level.vh_tank flag::get( "tank_moving" ) )
    {
        disable_sides = 1;
    }
    
    foreach ( s_tag in level.vh_tank.a_tank_tags )
    {
        if ( level.vh_tank tank_tag_is_valid( s_tag, disable_sides ) )
        {
            v_tag = level.vh_tank gettagorigin( s_tag.str_tag );
            dist_sq = distancesquared( self.origin, v_tag );
            
            if ( dist_sq < closest_dist_sq )
            {
                if ( !level.vh_tank is_tag_crowded( s_tag.str_tag ) )
                {
                    closest_tag = s_tag;
                    closest_dist_sq = dist_sq;
                }
            }
        }
    }
    
    return closest_tag;
}

// Namespace zm_tomb_tank
// Params 3
// Checksum 0x7d639831, Offset: 0x6968
// Size: 0x5a
function zombieanimnotetrackthink( str_anim_notetrack_notify, chunk, node )
{
    self endon( #"death" );
    
    while ( true )
    {
        self waittill( str_anim_notetrack_notify, str_notetrack );
        
        if ( str_notetrack == "end" )
        {
            return;
        }
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xe87fbd97, Offset: 0x69d0
// Size: 0x74
function tank_run_flamethrowers()
{
    self thread tank_flamethrower( "tag_flash", 1 );
    wait 0.25;
    self thread tank_flamethrower( "tag_flash_gunner1", 2 );
    wait 0.25;
    self thread tank_flamethrower( "tag_flash_gunner2", 3 );
}

// Namespace zm_tomb_tank
// Params 2
// Checksum 0xc49077d4, Offset: 0x6a50
// Size: 0x2cc
function tank_flamethrower_get_targets( str_tag, n_flamethrower_id )
{
    a_zombies = getaiteamarray( level.zombie_team );
    a_targets = [];
    v_tag_pos = self gettagorigin( str_tag );
    v_tag_angles = self gettagangles( str_tag );
    v_tag_fwd = anglestoforward( v_tag_angles );
    v_kill_pos = v_tag_pos + v_tag_fwd * 80;
    
    foreach ( ai_zombie in a_zombies )
    {
        dist_sq = distance2dsquared( ai_zombie.origin, v_kill_pos );
        
        if ( dist_sq > 80 * 80 )
        {
            continue;
        }
        
        if ( isdefined( ai_zombie.tank_state ) )
        {
            if ( ai_zombie.tank_state == "climbing" || ai_zombie.tank_state == "jumping_down" )
            {
                continue;
            }
        }
        
        v_to_zombie = vectornormalize( ai_zombie.origin - v_tag_pos );
        n_dot = vectordot( v_tag_fwd, ai_zombie.origin );
        
        if ( n_dot < 0.95 )
        {
            continue;
        }
        
        if ( !isdefined( a_targets ) )
        {
            a_targets = [];
        }
        else if ( !isarray( a_targets ) )
        {
            a_targets = array( a_targets );
        }
        
        a_targets[ a_targets.size ] = ai_zombie;
    }
    
    return a_targets;
}

// Namespace zm_tomb_tank
// Params 2
// Checksum 0x6932a37d, Offset: 0x6d28
// Size: 0x100
function tank_flamethrower_cycle_targets( str_tag, n_flamethrower_id )
{
    self endon( "flamethrower_stop_" + n_flamethrower_id );
    
    while ( true )
    {
        a_targets = tank_flamethrower_get_targets( str_tag, n_flamethrower_id );
        
        foreach ( ai in a_targets )
        {
            if ( isalive( ai ) )
            {
                self setturrettargetent( ai );
                wait 1;
            }
        }
        
        wait 1;
    }
}

// Namespace zm_tomb_tank
// Params 2
// Checksum 0x50742b8d, Offset: 0x6e30
// Size: 0x20e
function tank_flamethrower( str_tag, n_flamethrower_id )
{
    zombieless_waits = 0;
    time_between_flames = randomfloatrange( 3, 6 );
    
    while ( true )
    {
        wait 1;
        
        if ( n_flamethrower_id == 1 )
        {
            self setturrettargetvec( self.origin + anglestoforward( self.angles ) * 1000 );
        }
        
        self flag::wait_till( "tank_moving" );
        a_targets = tank_flamethrower_get_targets( str_tag, n_flamethrower_id );
        
        if ( a_targets.size > 0 || zombieless_waits > time_between_flames )
        {
            self clientfield::set( "tank_flamethrower_fx", n_flamethrower_id );
            self thread flamethrower_damage_zombies( n_flamethrower_id, str_tag );
            
            if ( n_flamethrower_id == 1 )
            {
                self thread tank_flamethrower_cycle_targets( str_tag, n_flamethrower_id );
            }
            
            if ( a_targets.size > 0 )
            {
                wait 6;
            }
            else
            {
                wait 3;
            }
            
            self clientfield::set( "tank_flamethrower_fx", 0 );
            self notify( "flamethrower_stop_" + n_flamethrower_id );
            zombieless_waits = 0;
            time_between_flames = randomfloatrange( 3, 6 );
            continue;
        }
        
        zombieless_waits++;
    }
}

// Namespace zm_tomb_tank
// Params 2
// Checksum 0xd3a6d7ef, Offset: 0x7048
// Size: 0x1c0
function flamethrower_damage_zombies( n_flamethrower_id, str_tag )
{
    self endon( "flamethrower_stop_" + n_flamethrower_id );
    
    while ( true )
    {
        a_targets = tank_flamethrower_get_targets( str_tag, n_flamethrower_id );
        
        foreach ( ai_zombie in a_targets )
        {
            if ( isalive( ai_zombie ) )
            {
                a_players = get_players_on_tank( 1 );
                
                if ( a_players.size > 0 )
                {
                    level notify( #"vo_tank_flame_zombie", array::random( a_players ) );
                }
                
                if ( str_tag == "tag_flash" )
                {
                    ai_zombie zm_tomb_utility::do_damage_network_safe( self, ai_zombie.health, self.w_flamethrower, "MOD_BURNED" );
                    ai_zombie thread zm_tomb_utility::zombie_gib_guts();
                }
                else
                {
                    ai_zombie thread zm_weap_staff_fire::flame_damage_fx( self.w_flamethrower, self );
                }
                
                wait 0.05;
            }
        }
        
        util::wait_network_frame();
    }
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0x8f92b7c0, Offset: 0x7210
// Size: 0x690
function enemy_location_override()
{
    enemy = self.favoriteenemy;
    location = enemy.origin;
    tank = level.vh_tank;
    
    if ( isdefined( self.is_mechz ) && self.is_mechz )
    {
        if ( isdefined( self.var_afe67307 ) )
        {
            return self.var_afe67307;
        }
        
        if ( isdefined( self.jump_pos ) )
        {
            return self.jump_pos.origin;
        }
        
        return undefined;
    }
    
    if ( isdefined( self.attackable ) )
    {
        return self.origin;
    }
    
    if ( isdefined( self.reroute ) && self.reroute )
    {
        if ( isdefined( self.reroute_origin ) )
        {
            location = self.reroute_origin;
        }
    }
    
    if ( isdefined( self.tank_state ) )
    {
        if ( self.tank_state == "tank_chase" )
        {
            self.goalradius = 128;
        }
        else if ( self.tank_state == "tag_chase" )
        {
            self.goalradius = 16;
        }
        else
        {
            self.goalradius = 32;
        }
        
        if ( isdefined( enemy.b_already_on_tank ) && self.tank_state == "none" && ( self.tank_state == "tank_chase" || enemy.b_already_on_tank ) )
        {
            tank_front = tank function_1db98f69( "window_right_front_jmp_jnt" );
            tank_back = tank function_1db98f69( "window_left_rear_jmp_jnt" );
            
            if ( tank flag::get( "tank_moving" ) )
            {
                self.ignoreall = 1;
                
                if ( !( isdefined( self.close_to_tank ) && self.close_to_tank ) )
                {
                    if ( gettime() != tank.chase_pos_time )
                    {
                        tank.chase_pos_time = gettime();
                        tank.chase_pos_index = 0;
                        tank_forward = vectornormalize( anglestoforward( level.vh_tank.angles ) );
                        tank_right = vectornormalize( anglestoright( level.vh_tank.angles ) );
                        tank.chase_pos = [];
                        tank.chase_pos[ 0 ] = level.vh_tank.origin + vectorscale( tank_forward, -164 );
                        tank.chase_pos[ 1 ] = tank_front;
                        tank.chase_pos[ 2 ] = tank_back;
                    }
                    
                    location = tank.chase_pos[ tank.chase_pos_index ];
                    tank.chase_pos_index++;
                    
                    if ( tank.chase_pos_index >= 3 )
                    {
                        tank.chase_pos_index = 0;
                    }
                    
                    dist_sq = distancesquared( self.origin, location );
                    
                    if ( dist_sq < 4096 )
                    {
                        self.close_to_tank = 1;
                    }
                }
            }
            else
            {
                self.close_to_tank = 0;
                tank_front = getstartorigin( tank_front, tank gettagangles( "window_right_front_jmp_jnt" ), "ai_zm_dlc5_zombie_jump_up_markiv_front" );
                front_dist = distance2dsquared( enemy.origin, tank_front );
                back_dist = distance2dsquared( enemy.origin, tank_back );
                
                if ( front_dist < back_dist )
                {
                    location = tank_front;
                }
                else
                {
                    location = tank_back;
                }
                
                self.ignoreall = 0;
            }
        }
        else if ( self.tank_state == "tag_chase" )
        {
            if ( self.str_tank_tag === "window_right_front_jmp_jnt" )
            {
                location = getstartorigin( tank gettagorigin( "window_right_front_jmp_jnt" ), tank gettagangles( "window_right_front_jmp_jnt" ), "ai_zm_dlc5_zombie_jump_up_markiv_front" );
            }
            else
            {
                location = level.vh_tank function_1db98f69( self.str_tank_tag );
            }
        }
        else if ( self.tank_state == "exit_tank" )
        {
            location = level.vh_tank tank_get_jump_down_offset( self.tank_tag );
        }
    }
    
    if ( self.var_13ed8adf === level.time && isdefined( location ) )
    {
        if ( isplayer( enemy ) && location == enemy.origin )
        {
            self zm_utility::approximate_path_dist( enemy );
        }
        else
        {
            pathdistance( self.origin, location, 1, self, level.pathdist_type );
        }
    }
    else if ( isplayer( enemy ) && isdefined( enemy.last_valid_position ) && location === enemy.origin )
    {
        location = enemy.last_valid_position;
    }
    
    return location;
}

// Namespace zm_tomb_tank
// Params 2
// Checksum 0x69b93968, Offset: 0x78a8
// Size: 0xa8
function closest_player_tank( origin, players )
{
    if ( isdefined( level.vh_tank ) && level.vh_tank.n_players_on > 0 || !( isdefined( level.calc_closest_player_using_paths ) && level.calc_closest_player_using_paths ) )
    {
        player = arraygetclosest( origin, players );
    }
    else
    {
        player = zm_tomb_utility::tomb_get_closest_player_using_paths( origin, players );
    }
    
    if ( isdefined( player ) )
    {
        return player;
    }
}

// Namespace zm_tomb_tank
// Params 15
// Checksum 0x270ac629, Offset: 0x7958
// Size: 0x114, Type: bool
function zombie_on_tank_death_animscript_callback( einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, modelindex, surfacetype, surfacenormal )
{
    if ( isdefined( self.exploding ) && self.exploding )
    {
        self notify( #"killanimscript" );
        self zombie_utility::reset_attack_spot();
        return true;
    }
    
    if ( isdefined( self ) )
    {
        level zm_spawner::zombie_death_points( self.origin, smeansofdeath, shitloc, eattacker, self );
        self notify( #"killanimscript" );
        self zombie_utility::reset_attack_spot();
        return true;
    }
    
    return false;
}

// Namespace zm_tomb_tank
// Params 0
// Checksum 0xd5f7b2e1, Offset: 0x7a78
// Size: 0x14a
function tomb_get_path_length_to_tank()
{
    tank_front = level.vh_tank function_1db98f69( "window_right_front_jmp_jnt" );
    tank_back = level.vh_tank function_1db98f69( "window_left_rear_jmp_jnt" );
    path_length_1 = pathdistance( self.origin, tank_front, 1, self, level.pathdist_type );
    path_length_2 = pathdistance( self.origin, tank_back, 1, self, level.pathdist_type );
    
    if ( !isdefined( path_length_1 ) && isdefined( path_length_2 ) )
    {
        return path_length_2;
    }
    else if ( isdefined( path_length_1 ) && !isdefined( path_length_2 ) )
    {
        return path_length_1;
    }
    else if ( !isdefined( path_length_1 ) && !isdefined( path_length_2 ) )
    {
        return undefined;
    }
    
    if ( path_length_1 < path_length_2 )
    {
        return path_length_1;
    }
    
    return path_length_2;
}

