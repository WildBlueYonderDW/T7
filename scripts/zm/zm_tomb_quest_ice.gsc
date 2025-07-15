#using scripts/codescripts/struct;
#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/math_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_zm_utility;
#using scripts/zm/zm_tomb_chamber;
#using scripts/zm/zm_tomb_utility;
#using scripts/zm/zm_tomb_vo;

#namespace zm_tomb_quest_ice;

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0xac97beae, Offset: 0x460
// Size: 0x24c
function main()
{
    level flag::init( "ice_puzzle_1_complete" );
    level flag::init( "ice_puzzle_2_complete" );
    level flag::init( "ice_upgrade_available" );
    level flag::init( "ice_tile_flipping" );
    zm_tomb_vo::add_puzzle_completion_line( 4, "vox_sam_ice_puz_solve_0" );
    zm_tomb_vo::add_puzzle_completion_line( 4, "vox_sam_ice_puz_solve_1" );
    zm_tomb_vo::add_puzzle_completion_line( 4, "vox_sam_ice_puz_solve_2" );
    level thread zm_tomb_vo::watch_one_shot_line( "puzzle", "try_puzzle", "vo_try_puzzle_water1" );
    level thread zm_tomb_vo::watch_one_shot_line( "puzzle", "try_puzzle", "vo_try_puzzle_water2" );
    ice_puzzle_1_init();
    level thread ice_puzzle_2_init();
    level thread ice_puzzle_1_run();
    level flag::wait_till( "ice_puzzle_1_complete" );
    playsoundatposition( "zmb_squest_step1_finished", ( 0, 0, 0 ) );
    level thread zm_tomb_utility::rumble_players_in_chamber( 5, 3 );
    ice_puzzle_1_cleanup();
    level thread ice_puzzle_2_run();
    level flag::wait_till( "ice_puzzle_2_complete" );
    level flag::wait_till( "staff_water_upgrade_unlocked" );
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0x7e4eb168, Offset: 0x6b8
// Size: 0x414
function ice_puzzle_1_init()
{
    ice_tiles_randomize();
    a_ceiling_tile_brushes = getentarray( "ice_ceiling_tile", "script_noteworthy" );
    level.unsolved_tiles = a_ceiling_tile_brushes;
    
    foreach ( tile in a_ceiling_tile_brushes )
    {
        tile.showing_tile_side = 0;
        tile.value = int( tile.script_string );
        tile thread ceiling_tile_flip();
        tile thread ceiling_tile_process_damage();
    }
    
    a_ice_ternary_digit_brushes = getentarray( "ice_chamber_digit", "targetname" );
    
    foreach ( digit in a_ice_ternary_digit_brushes )
    {
        digit ghost();
        digit notsolid();
    }
    
    level.ternary_digits = [];
    level.ternary_digits[ 0 ] = array( -1, 0, -1 );
    level.ternary_digits[ 1 ] = array( -1, 1, -1 );
    level.ternary_digits[ 2 ] = array( -1, 2, -1 );
    level.ternary_digits[ 3 ] = array( 1, -1, 0 );
    level.ternary_digits[ 4 ] = array( 1, -1, 1 );
    level.ternary_digits[ 5 ] = array( 1, -1, 2 );
    level.ternary_digits[ 6 ] = array( 2, -1, 0 );
    level.ternary_digits[ 7 ] = array( 2, -1, 1 );
    level.ternary_digits[ 8 ] = array( 2, -1, 2 );
    level.ternary_digits[ 9 ] = array( 1, 0, 0 );
    level.ternary_digits[ 10 ] = array( 1, 0, 1 );
    level.ternary_digits[ 11 ] = array( 1, 0, 2 );
    level thread update_ternary_display();
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0x1dcec447, Offset: 0xad8
// Size: 0xfc
function ice_puzzle_1_cleanup()
{
    a_ceiling_tile_brushes = getentarray( "ice_ceiling_tile", "script_noteworthy" );
    
    foreach ( tile in a_ceiling_tile_brushes )
    {
        tile thread ceiling_tile_flip( 0 );
    }
    
    a_ice_ternary_digit_brushes = getentarray( "ice_chamber_digit", "targetname" );
    array::delete_all( a_ice_ternary_digit_brushes );
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0x75f73410, Offset: 0xbe0
// Size: 0x2bc
function ice_tiles_randomize()
{
    a_original_tiles = getentarray( "ice_tile_original", "targetname" );
    a_original_tiles = array::sort_by_script_int( a_original_tiles, 1 );
    a_original_positions = [];
    
    foreach ( e_tile in a_original_tiles )
    {
        a_original_positions[ a_original_positions.size ] = e_tile.origin;
    }
    
    a_unused_tiles = getentarray( "ice_ceiling_tile", "script_noteworthy" );
    n_total_tiles = a_unused_tiles.size;
    n_index = 0;
    
    foreach ( v_pos in a_original_positions )
    {
        e_tile = array::random( a_unused_tiles );
        arrayremovevalue( a_unused_tiles, e_tile, 0 );
        e_tile moveto( v_pos, 0.5 );
        e_tile waittill( #"movedone" );
        str_model_name = "ice_ceiling_tile_model_" + n_index;
        var_fa4117e3 = getent( str_model_name, "targetname" );
        var_fa4117e3 linkto( e_tile );
        n_index++;
    }
    
    assert( a_unused_tiles.size == n_total_tiles - a_original_positions.size );
    array::delete_all( a_unused_tiles );
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0xc8ca76da, Offset: 0xea8
// Size: 0xba
function reset_tiles()
{
    a_ceiling_tile_brushes = getentarray( "ice_ceiling_tile", "script_noteworthy" );
    
    foreach ( tile in a_ceiling_tile_brushes )
    {
        tile thread ceiling_tile_flip( 1 );
    }
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0xa468ee0b, Offset: 0xf70
// Size: 0x186
function update_ternary_display()
{
    a_ice_ternary_digit_brushes = getentarray( "ice_chamber_digit", "targetname" );
    level endon( #"ice_puzzle_1_complete" );
    
    while ( true )
    {
        level waittill( #"update_ice_chamber_digits", newval );
        
        foreach ( digit in a_ice_ternary_digit_brushes )
        {
            digit ghost();
            
            if ( isdefined( newval ) )
            {
                digit_slot = int( digit.script_noteworthy );
                shown_value = level.ternary_digits[ newval ][ digit_slot ];
                digit_value = int( digit.script_string );
                
                if ( shown_value == digit_value )
                {
                    digit show();
                }
            }
        }
    }
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0x14a9382d, Offset: 0x1100
// Size: 0xb2
function change_ice_gem_value()
{
    ice_gem = getent( "ice_chamber_gem", "targetname" );
    
    if ( level.unsolved_tiles.size != 0 )
    {
        correct_tile = array::random( level.unsolved_tiles );
        ice_gem.value = correct_tile.value;
        level notify( #"update_ice_chamber_digits", ice_gem.value );
        return;
    }
    
    level notify( #"update_ice_chamber_digits", -1 );
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0x685006d0, Offset: 0x11c0
// Size: 0x138
function process_gem_shooting()
{
    level endon( #"ice_puzzle_1_complete" );
    ice_gem = getent( "ice_chamber_gem", "targetname" );
    ice_gem.value = -1;
    ice_gem setcandamage( 1 );
    w_staff_water = level.a_elemental_staffs[ "staff_water" ].w_weapon;
    
    while ( true )
    {
        self waittill( #"damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weapon );
        
        if ( weapon.name == w_staff_water )
        {
            change_ice_gem_value();
        }
    }
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0xa027c18f, Offset: 0x1300
// Size: 0x2c
function ice_puzzle_1_run()
{
    level thread process_gem_shooting();
    change_ice_gem_value();
}

// Namespace zm_tomb_quest_ice
// Params 1
// Checksum 0x8224a24a, Offset: 0x1338
// Size: 0x150
function ceiling_tile_flip( b_flip_to_tile_side )
{
    if ( !isdefined( b_flip_to_tile_side ) )
    {
        b_flip_to_tile_side = !self.showing_tile_side;
    }
    
    if ( b_flip_to_tile_side == self.showing_tile_side )
    {
        return;
    }
    
    self.showing_tile_side = !self.showing_tile_side;
    self rotateroll( 180, 0.5 );
    self playsound( "zmb_squest_ice_tile_flip" );
    
    if ( !self.showing_tile_side )
    {
        arrayremovevalue( level.unsolved_tiles, self, 0 );
    }
    else
    {
        array::add( level.unsolved_tiles, self, 0 );
    }
    
    if ( level.unsolved_tiles.size == 0 && !level flag::get( "ice_puzzle_1_complete" ) )
    {
        self thread zm_tomb_vo::say_puzzle_completion_line( 4 );
        level flag::set( "ice_puzzle_1_complete" );
    }
    
    self waittill( #"rotatedone" );
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0xc24b8987, Offset: 0x1490
// Size: 0x2ae
function ceiling_tile_process_damage()
{
    level endon( #"ice_puzzle_1_complete" );
    ice_gem = getent( "ice_chamber_gem", "targetname" );
    self setcandamage( 1 );
    ice_gem setcandamage( 1 );
    
    while ( true )
    {
        self waittill( #"damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weaponname );
        var_f1415f17 = arraygetclosest( point, level.unsolved_tiles );
        
        if ( issubstr( weaponname.name, "water" ) && self.showing_tile_side && var_f1415f17 == self )
        {
            if ( !level flag::get( "ice_tile_flipping" ) )
            {
                level notify( #"vo_try_puzzle_water1", attacker );
                level flag::set( "ice_tile_flipping" );
                
                if ( ice_gem.value == self.value )
                {
                    level notify( #"vo_puzzle_good", attacker );
                    self ceiling_tile_flip( 0 );
                    zm_tomb_utility::rumble_nearby_players( self.origin, 1500, 2 );
                    wait 0.2;
                }
                else
                {
                    level notify( #"vo_puzzle_bad", attacker );
                    reset_tiles();
                    zm_tomb_utility::rumble_nearby_players( self.origin, 1500, 2 );
                    wait 2;
                }
                
                change_ice_gem_value();
                level flag::clear( "ice_tile_flipping" );
                continue;
            }
            
            level notify( #"vo_puzzle_confused", attacker );
        }
    }
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0x99ec1590, Offset: 0x1748
// Size: 0x4
function ice_puzzle_2_init()
{
    
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0x93150d93, Offset: 0x1758
// Size: 0xd2
function ice_puzzle_2_run()
{
    a_stone_positions = struct::get_array( "puzzle_stone_water", "targetname" );
    level.ice_stones_remaining = a_stone_positions.size;
    
    foreach ( s_stone in a_stone_positions )
    {
        s_stone thread ice_stone_run();
        util::wait_network_frame();
    }
}

// Namespace zm_tomb_quest_ice
// Params 0
// Checksum 0xfd2782c1, Offset: 0x1838
// Size: 0x642
function ice_stone_run()
{
    v_up = anglestoup( self.angles );
    v_spawn_pos = self.origin - 64 * v_up;
    self.e_model = spawn( "script_model", v_spawn_pos );
    self.e_model.angles = self.angles;
    self.e_model setmodel( "p7_zm_ori_note_rock_01_anim_water" );
    self.e_model moveto( self.origin, 1, 0.5, 0.5 );
    playfx( level._effect[ "digging" ], self.origin );
    self.e_model setcandamage( 1 );
    self.e_model playloopsound( "zmb_squest_ice_stone_flow", 2 );
    
    for ( has_tried = 0; !level flag::get( "ice_puzzle_2_complete" ) ; has_tried = 1 )
    {
        self.e_model waittill( #"damage", amount, inflictor, direction, point, type, tagname, modelname, partname, weaponname, idflags );
        level notify( #"vo_try_puzzle_water2", inflictor );
        
        if ( issubstr( weaponname.name, "water" ) )
        {
            level notify( #"vo_puzzle_good", inflictor );
            break;
        }
        
        if ( has_tried )
        {
            level notify( #"vo_puzzle_bad", inflictor );
        }
    }
    
    self.e_model setmodel( "p7_zm_ori_note_rock_01_anim" );
    self.e_model clientfield::set( "stone_frozen", 1 );
    playsoundatposition( "zmb_squest_ice_stone_freeze", self.origin );
    
    while ( !level flag::get( "ice_puzzle_2_complete" ) )
    {
        self.e_model waittill( #"damage", amount, inflictor, direction, point, type, tagname, modelname, partname, weaponname, idflags );
        
        if ( !issubstr( weaponname.name, "staff" ) && issubstr( type, "BULLET" ) )
        {
            level notify( #"vo_puzzle_good", inflictor );
            break;
        }
        
        level notify( #"vo_puzzle_confused", inflictor );
    }
    
    self.e_model delete();
    playfx( level._effect[ "ice_explode" ], self.origin, anglestoforward( self.angles ), anglestoup( self.angles ) );
    playsoundatposition( "zmb_squest_ice_stone_shatter", self.origin );
    level.ice_stones_remaining--;
    
    if ( level.ice_stones_remaining <= 0 && !level flag::get( "ice_puzzle_2_complete" ) )
    {
        level flag::set( "ice_puzzle_2_complete" );
        e_player = zm_utility::get_closest_player( self.origin );
        e_player thread zm_tomb_vo::say_puzzle_completion_line( 4 );
        level thread zm_tomb_utility::play_puzzle_stinger_on_all_players();
        level.weather_snow = 5;
        level.weather_rain = 0;
        
        foreach ( player in getplayers() )
        {
            player zm_tomb_utility::set_weather_to_player();
        }
        
        wait 5;
        level.weather_snow = 0;
        level.weather_rain = 0;
        
        foreach ( player in getplayers() )
        {
            player zm_tomb_utility::set_weather_to_player();
        }
    }
}

