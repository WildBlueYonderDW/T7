#using scripts/codescripts/struct;
#using scripts/shared/array_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/math_shared;
#using scripts/shared/util_shared;
#using scripts/zm/zm_tomb_utility;
#using scripts/zm/zm_tomb_vo;

#namespace zm_tomb_quest_air;

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x8a90b643, Offset: 0x348
// Size: 0x1ec
function main()
{
    level flag::init( "air_puzzle_1_complete" );
    level flag::init( "air_puzzle_2_complete" );
    level flag::init( "air_upgrade_available" );
    air_puzzle_1_init();
    air_puzzle_2_init();
    zm_tomb_vo::add_puzzle_completion_line( 2, "vox_sam_wind_puz_solve_1" );
    zm_tomb_vo::add_puzzle_completion_line( 2, "vox_sam_wind_puz_solve_0" );
    zm_tomb_vo::add_puzzle_completion_line( 2, "vox_sam_wind_puz_solve_2" );
    level thread zm_tomb_vo::watch_one_shot_line( "puzzle", "try_puzzle", "vo_try_puzzle_air1" );
    level thread zm_tomb_vo::watch_one_shot_line( "puzzle", "try_puzzle", "vo_try_puzzle_air2" );
    level thread air_puzzle_1_run();
    level flag::wait_till( "air_puzzle_1_complete" );
    playsoundatposition( "zmb_squest_step1_finished", ( 0, 0, 0 ) );
    level thread air_puzzle_1_cleanup();
    level thread zm_tomb_utility::rumble_players_in_chamber( 5, 3 );
    level thread air_puzzle_2_run();
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x16f86a2e, Offset: 0x540
// Size: 0xb2
function air_puzzle_1_init()
{
    level.a_ceiling_rings = getentarray( "ceiling_ring", "script_noteworthy" );
    
    foreach ( e_ring in level.a_ceiling_rings )
    {
        e_ring ceiling_ring_init();
    }
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x9430c1cb, Offset: 0x600
// Size: 0x12e
function air_puzzle_1_cleanup()
{
    for ( i = 1; i <= 3 ; i++ )
    {
        n_move = ( 4 - i ) * 20;
        e_ring = getent( "ceiling_ring_0" + i, "targetname" );
        e_ring rotateyaw( 360, 1.5, 0.5, 0 );
        e_ring movez( n_move, 1.5, 0.5, 0 );
        e_ring playsound( "zmb_squest_wind_ring_turn" );
        e_ring waittill( #"movedone" );
        e_ring playsound( "zmb_squest_wind_ring_stop" );
    }
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x66d2ffe0, Offset: 0x738
// Size: 0x2c
function air_puzzle_1_run()
{
    array::thread_all( level.a_ceiling_rings, &ceiling_ring_run );
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x48475ed5, Offset: 0x770
// Size: 0xaa, Type: bool
function check_puzzle_solved()
{
    num_solved = 0;
    
    foreach ( e_ring in level.a_ceiling_rings )
    {
        if ( e_ring.script_int != e_ring.position )
        {
            return false;
        }
    }
    
    return true;
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x8a82fef7, Offset: 0x828
// Size: 0x84
function ceiling_ring_randomize()
{
    n_offset_from_final = randomintrange( 1, 4 );
    self.position = ( self.script_int + n_offset_from_final ) % 4;
    ceiling_ring_update_position();
    assert( self.position != self.script_int );
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x3d06eafb, Offset: 0x8b8
// Size: 0xcc
function ceiling_ring_update_position()
{
    new_angles = ( self.angles[ 0 ], self.position * 90, self.angles[ 2 ] );
    self rotateto( new_angles, 0.5, 0.2, 0.2 );
    exploder::exploder( "fxexp_600" );
    self playsound( "zmb_squest_wind_ring_turn" );
    self waittill( #"rotatedone" );
    self playsound( "zmb_squest_wind_ring_stop" );
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x172adbb6, Offset: 0x990
// Size: 0xec
function ceiling_ring_rotate()
{
    self.position = ( self.position + 1 ) % 4;
    
    /#
        if ( self.position == self.script_int )
        {
            iprintlnbold( "<dev string:x28>" );
        }
    #/
    
    self ceiling_ring_update_position();
    solved = check_puzzle_solved();
    
    if ( solved && !level flag::get( "air_puzzle_1_complete" ) )
    {
        self thread zm_tomb_vo::say_puzzle_completion_line( 2 );
        level flag::set( "air_puzzle_1_complete" );
    }
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x47058b13, Offset: 0xa88
// Size: 0x10
function ceiling_ring_init()
{
    self.position = 0;
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x6b48f217, Offset: 0xaa0
// Size: 0x346
function ceiling_ring_run()
{
    level endon( #"air_puzzle_1_complete" );
    self setcandamage( 1 );
    self.position = 0;
    ceiling_ring_randomize();
    n_rotations = 0;
    var_8218dfc8 = 120 * 120;
    var_ad195647 = 180 * 180;
    var_104a0542 = 240 * 240;
    var_9d64b269 = 300 * 300;
    
    while ( true )
    {
        self waittill( #"damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weaponname );
        
        if ( weaponname.name == "staff_air" )
        {
            var_a9ffa3fc = 0;
            var_234d771c = distance2dsquared( point, self.origin );
            
            if ( issubstr( self.targetname, "01" ) && var_234d771c <= var_8218dfc8 )
            {
                var_a9ffa3fc = 1;
            }
            else if ( issubstr( self.targetname, "02" ) && var_234d771c > var_8218dfc8 && var_234d771c <= var_ad195647 )
            {
                var_a9ffa3fc = 1;
            }
            else if ( issubstr( self.targetname, "03" ) && var_234d771c > var_ad195647 && var_234d771c <= var_104a0542 )
            {
                var_a9ffa3fc = 1;
            }
            else if ( issubstr( self.targetname, "04" ) && var_234d771c > var_104a0542 && var_234d771c <= var_9d64b269 )
            {
                var_a9ffa3fc = 1;
            }
            
            if ( var_a9ffa3fc )
            {
                level notify( #"vo_try_puzzle_air1", attacker );
                self ceiling_ring_rotate();
                zm_tomb_utility::rumble_nearby_players( self.origin, 1500, 2 );
                n_rotations++;
                
                if ( n_rotations % 4 == 0 )
                {
                    level notify( #"vo_puzzle_bad", attacker );
                }
            }
            
            continue;
        }
        
        level notify( #"vo_puzzle_confused", attacker );
    }
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x71d7637, Offset: 0xdf0
// Size: 0xea
function air_puzzle_2_init()
{
    a_smoke_pos = struct::get_array( "puzzle_smoke_origin", "targetname" );
    
    foreach ( s_smoke_pos in a_smoke_pos )
    {
        s_smoke_pos.detector_brush = getent( s_smoke_pos.target, "targetname" );
        s_smoke_pos.detector_brush ghost();
    }
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x361044c2, Offset: 0xee8
// Size: 0x294
function air_puzzle_2_run()
{
    a_smoke_pos = struct::get_array( "puzzle_smoke_origin", "targetname" );
    
    foreach ( s_smoke_pos in a_smoke_pos )
    {
        s_smoke_pos thread air_puzzle_smoke();
    }
    
    w_staff_air = level.a_elemental_staffs[ "staff_air" ].w_weapon;
    
    while ( true )
    {
        level waittill( #"air_puzzle_smoke_solved" );
        all_smoke_solved = 1;
        
        foreach ( s_smoke_pos in a_smoke_pos )
        {
            if ( !s_smoke_pos.solved )
            {
                all_smoke_solved = 0;
            }
        }
        
        if ( all_smoke_solved )
        {
            a_players = getplayers();
            
            foreach ( e_player in a_players )
            {
                if ( e_player hasweapon( w_staff_air ) )
                {
                    e_player thread zm_tomb_vo::say_puzzle_completion_line( 2 );
                    break;
                }
            }
            
            level flag::set( "air_puzzle_2_complete" );
            level thread zm_tomb_utility::play_puzzle_stinger_on_all_players();
            break;
        }
    }
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0x8f6acf75, Offset: 0x1188
// Size: 0x1ac
function air_puzzle_smoke()
{
    self.e_fx = spawn( "script_model", self.origin );
    self.e_fx.angles = self.angles;
    self.e_fx setmodel( "tag_origin" );
    self.e_fx playloopsound( "zmb_squest_wind_incense_loop", 2 );
    s_dest = struct::get( "puzzle_smoke_dest", "targetname" );
    playfxontag( level._effect[ "air_puzzle_smoke" ], self.e_fx, "tag_origin" );
    self thread air_puzzle_run_smoke_direction();
    level flag::wait_till( "air_puzzle_2_complete" );
    self.e_fx movez( -1000, 1, 0.1, 0.1 );
    self.e_fx waittill( #"movedone" );
    wait 5;
    self.e_fx delete();
    self.detector_brush delete();
}

// Namespace zm_tomb_quest_air
// Params 0
// Checksum 0xddb8c68, Offset: 0x1340
// Size: 0x2fa
function air_puzzle_run_smoke_direction()
{
    level endon( #"air_puzzle_2_complete" );
    self endon( #"death" );
    s_dest = struct::get( "puzzle_smoke_dest", "targetname" );
    v_to_dest = vectornormalize( s_dest.origin - self.origin );
    f_min_dot = cos( self.script_int );
    self.solved = 0;
    self.detector_brush setcandamage( 1 );
    direction_failures = 0;
    
    while ( true )
    {
        self.detector_brush waittill( #"damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weaponname );
        
        if ( weaponname.name == "staff_air" )
        {
            level notify( #"vo_try_puzzle_air2", attacker );
            new_yaw = math::vec_to_angles( direction_vec );
            new_orient = ( 0, new_yaw, 0 );
            self.e_fx rotateto( new_orient, 1, 0.3, 0.3 );
            self.e_fx waittill( #"rotatedone" );
            f_dot = vectordot( v_to_dest, direction_vec );
            self.solved = f_dot > f_min_dot;
            
            if ( !self.solved )
            {
                direction_failures++;
                
                if ( direction_failures > 4 )
                {
                    level notify( #"vo_puzzle_confused", attacker );
                }
            }
            else if ( randomint( 100 ) < 10 )
            {
                level notify( #"vo_puzzle_good", attacker );
            }
            
            level notify( #"air_puzzle_smoke_solved" );
            continue;
        }
        
        if ( issubstr( weaponname, "staff" ) )
        {
            level notify( #"vo_puzzle_bad", attacker );
        }
    }
}

