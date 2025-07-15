#using scripts/codescripts/struct;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/animation_shared;
#using scripts/shared/array_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_sidequests;
#using scripts/zm/zm_temple_sq;
#using scripts/zm/zm_temple_sq_brock;
#using scripts/zm/zm_temple_sq_skits;

#namespace zm_temple_sq_bag;

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0x8c12cd1a, Offset: 0x400
// Size: 0xbc
function init()
{
    level flag::init( "given_dynamite" );
    level flag::init( "dynamite_chat" );
    zm_sidequests::declare_sidequest_stage( "sq", "BaG", &init_stage, &stage_logic, &exit_stage );
    zm_sidequests::set_stage_time_limit( "sq", "BaG", 300 );
}

/#

    // Namespace zm_temple_sq_bag
    // Params 0
    // Checksum 0xacedd3e1, Offset: 0x4c8
    // Size: 0x878, Type: dev
    function bag_debug()
    {
        if ( isdefined( level._debug_bag ) )
        {
            return;
        }
        
        if ( !isdefined( level._debug_bag ) )
        {
            level._debug_bag = 1;
            level._hud_gongs = newdebughudelem();
            level._hud_gongs.location = 0;
            level._hud_gongs.alignx = "<dev string:x28>";
            level._hud_gongs.aligny = "<dev string:x2d>";
            level._hud_gongs.foreground = 1;
            level._hud_gongs.fontscale = 1.3;
            level._hud_gongs.sort = 20;
            level._hud_gongs.x = 10;
            level._hud_gongs.y = 240;
            level._hud_gongs.og_scale = 1;
            level._hud_gongs.color = ( 255, 255, 255 );
            level._hud_gongs.alpha = 1;
            level._hud_gongs_label = newdebughudelem();
            level._hud_gongs_label.location = 0;
            level._hud_gongs_label.alignx = "<dev string:x34>";
            level._hud_gongs_label.aligny = "<dev string:x2d>";
            level._hud_gongs_label.foreground = 1;
            level._hud_gongs_label.fontscale = 1.3;
            level._hud_gongs_label.sort = 20;
            level._hud_gongs_label.x = 0;
            level._hud_gongs_label.y = 240;
            level._hud_gongs_label.og_scale = 1;
            level._hud_gongs_label.color = ( 255, 255, 255 );
            level._hud_gongs_label.alpha = 1;
            level._hud_gongs_label settext( "<dev string:x3a>" );
            level._ringing = newdebughudelem();
            level._ringing.location = 0;
            level._ringing.alignx = "<dev string:x28>";
            level._ringing.aligny = "<dev string:x2d>";
            level._ringing.foreground = 1;
            level._ringing.fontscale = 1.3;
            level._ringing.sort = 20;
            level._ringing.x = 10;
            level._ringing.y = 270;
            level._ringing.og_scale = 1;
            level._ringing.color = ( 255, 255, 255 );
            level._ringing.alpha = 1;
            level._ringing_label = newdebughudelem();
            level._ringing_label.location = 0;
            level._ringing_label.alignx = "<dev string:x34>";
            level._ringing_label.aligny = "<dev string:x2d>";
            level._ringing_label.foreground = 1;
            level._ringing_label.fontscale = 1.3;
            level._ringing_label.sort = 20;
            level._ringing_label.x = 0;
            level._ringing_label.y = 270;
            level._ringing_label.og_scale = 1;
            level._ringing_label.color = ( 255, 255, 255 );
            level._ringing_label.alpha = 1;
            level._ringing_label settext( "<dev string:x42>" );
            level._resonating = newdebughudelem();
            level._resonating.location = 0;
            level._resonating.alignx = "<dev string:x28>";
            level._resonating.aligny = "<dev string:x2d>";
            level._resonating.foreground = 1;
            level._resonating.fontscale = 1.3;
            level._resonating.sort = 20;
            level._resonating.x = 10;
            level._resonating.y = 300;
            level._resonating.og_scale = 1;
            level._resonating.color = ( 255, 255, 255 );
            level._resonating.alpha = 1;
            level._resonating_label = newdebughudelem();
            level._resonating_label.location = 0;
            level._resonating_label.alignx = "<dev string:x34>";
            level._resonating_label.aligny = "<dev string:x2d>";
            level._resonating_label.foreground = 1;
            level._resonating_label.fontscale = 1.3;
            level._resonating_label.sort = 20;
            level._resonating_label.x = 0;
            level._resonating_label.y = 300;
            level._resonating_label.og_scale = 1;
            level._resonating_label.color = ( 255, 255, 255 );
            level._resonating_label.alpha = 1;
            level._resonating_label settext( "<dev string:x4c>" );
        }
        
        gongs = getentarray( "<dev string:x59>", "<dev string:x61>" );
        
        while ( true )
        {
            if ( isdefined( level._num_gongs ) )
            {
                level._hud_gongs setvalue( level._num_gongs );
            }
            else
            {
                level.var_e38ebc06 setvalue( "<dev string:x6c>" );
            }
            
            gong_text = "<dev string:x6f>";
            
            for ( i = 0; i < gongs.size ; i++ )
            {
                if ( isdefined( gongs[ i ].ringing ) && gongs[ i ].ringing )
                {
                    gong_text += "<dev string:x70>";
                    continue;
                }
                
                gong_text += "<dev string:x72>";
            }
            
            level._ringing settext( gong_text );
            
            if ( level flag::get( "<dev string:x74>" ) )
            {
                level._resonating_label settext( "<dev string:x85>" );
            }
            else
            {
                level._resonating_label settext( "<dev string:x89>" );
            }
            
            wait 0.05;
        }
    }

#/

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0xdfef6274, Offset: 0xd48
// Size: 0x1ac
function init_stage()
{
    zm_temple_sq_brock::delete_radio();
    level notify( #"bag_start" );
    
    /#
        if ( getplayers().size == 1 || getdvarint( "<dev string:x8c>" ) == 2 )
        {
            getplayers()[ 0 ] giveweapon( level.w_shrink_ray_upgraded );
            level notify( #"raise_crystal_1" );
            level notify( #"raise_crystal_2" );
            level notify( #"raise_crystal_3" );
            level notify( #"raise_crystal_4" );
            level notify( #"raise_crystal_5" );
            level notify( #"raise_crystal_6" );
        }
    #/
    
    level flag::clear( "given_dynamite" );
    level flag::clear( "dynamite_chat" );
    gongs = getentarray( "sq_gong", "targetname" );
    array::thread_all( gongs, &gong_handler );
    level thread give_me_the_boom_stick();
    zm_temple_sq::reset_dynamite();
    level thread delayed_start_skit();
}

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0x11d11e7f, Offset: 0xf00
// Size: 0x2c
function delayed_start_skit()
{
    wait 0.5;
    level thread zm_temple_sq_skits::start_skit( "tt8" );
}

/#

    // Namespace zm_temple_sq_bag
    // Params 0
    // Checksum 0x96e64ba5, Offset: 0xf38
    // Size: 0x68, Type: dev
    function dynamite_debug()
    {
        self endon( #"caught" );
        
        while ( !( isdefined( level.disable_print3d_ent ) && level.disable_print3d_ent ) )
        {
            print3d( self.origin, "<dev string:x99>", ( 0, 255, 0 ), 2 );
            wait 0.1;
        }
    }

#/

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0xfeeb9a85, Offset: 0xfa8
// Size: 0x24c
function fire_in_the_hole()
{
    self endon( #"caught" );
    self.dropped = 1;
    self unlink();
    dest = struct::get( self.target, "targetname" );
    level.catch_trig = spawn( "trigger_radius", self.origin, 0, 24, 10 );
    level.catch_trig enablelinkto();
    level.catch_trig linkto( self );
    level.catch_trig.owner_ent = self;
    level.catch_trig thread butter_fingers();
    
    /#
        self thread dynamite_debug();
    #/
    
    self notsolid();
    self moveto( dest.origin, 1.4, 0.2, 0 );
    self waittill( #"movedone" );
    players = getplayers();
    players[ randomintrange( 0, players.size ) ] thread zm_audio::create_and_play_dialog( "eggs", "quest8", 5 );
    playsoundatposition( "evt_sq_bag_dynamite_explosion", dest.origin );
    level.catch_trig notify( #"boom" );
    level.catch_trig delete();
    level.catch_trig = undefined;
    zm_sidequests::stage_failed( "sq", "BaG" );
}

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0x18dfc7ea, Offset: 0x1200
// Size: 0x12c
function butter_fingers()
{
    self endon( #"boom" );
    self endon( #"death" );
    
    while ( true )
    {
        self waittill( #"trigger", who );
        
        if ( isdefined( who ) && zombie_utility::is_player_valid( who ) )
        {
            who thread zm_audio::create_and_play_dialog( "eggs", "quest8", 6 );
            who playsound( "evt_sq_bag_dynamite_catch" );
            who._has_dynamite = 1;
            self.owner_ent notify( #"caught" );
            self.owner_ent ghost();
            who zm_sidequests::add_sidequest_icon( "sq", "dynamite" );
            self delete();
            break;
        }
    }
}

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0x1e5f3989, Offset: 0x1338
// Size: 0x40c
function give_me_the_boom_stick()
{
    level endon( #"sq_bag_over" );
    wall = getent( "sq_wall", "targetname" );
    wall solid();
    level flag::wait_till( "meteorite_shrunk" );
    player_close = 0;
    player = undefined;
    
    while ( !player_close )
    {
        players = getplayers();
        
        for ( i = 0; i < players.size ; i++ )
        {
            if ( distance2dsquared( players[ i ].origin, wall.origin ) < 57600 )
            {
                player_close = 1;
                player = players[ i ];
                break;
            }
        }
        
        wait 0.1;
    }
    
    level function_43e26f4d( player );
    level flag::set( "dynamite_chat" );
    level._give_trig = spawn( "trigger_radius_use", wall.origin, 0, 56, 72 );
    level._give_trig triggerignoreteam();
    level._give_trig setcursorhint( "HINT_NOICON" );
    level._give_trig.radius = 48;
    level._give_trig.height = 72;
    
    for ( not_given = 1; not_given ; not_given = 0 )
    {
        level._give_trig waittill( #"trigger", who );
        
        if ( isplayer( who ) && zombie_utility::is_player_valid( who ) && isdefined( who._has_dynamite ) && who._has_dynamite )
        {
            who._has_dynamite = undefined;
            who zm_sidequests::remove_sidequest_icon( "sq", "dynamite" );
        }
    }
    
    level notify( #"suspend_timer" );
    level._give_trig delete();
    level._give_trig = undefined;
    level function_69e4e9b6();
    players_far = 0;
    
    for ( players = getplayers(); players_far < players.size ; players = getplayers() )
    {
        players_far = 0;
        
        for ( i = 0; i < players.size ; i++ )
        {
            if ( distance2dsquared( players[ i ].origin, wall.origin ) > 129600 )
            {
                players_far++;
            }
        }
        
        wait 0.1;
    }
    
    level flag::set( "given_dynamite" );
}

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0xcb9e0df2, Offset: 0x1750
// Size: 0xac
function stage_logic()
{
    level flag::wait_till( "meteorite_shrunk" );
    level flag::set( "pap_override" );
    level flag::wait_till( "dynamite_chat" );
    level flag::wait_till( "given_dynamite" );
    wait 5;
    zm_sidequests::stage_completed( "sq", "BaG" );
}

// Namespace zm_temple_sq_bag
// Params 1
// Checksum 0x89180fce, Offset: 0x1808
// Size: 0x2c8
function exit_stage( success )
{
    if ( success )
    {
        zm_temple_sq_brock::create_radio( 9, &zm_temple_sq_brock::radio9_override );
        level._buttons_can_reset = 0;
    }
    else
    {
        zm_temple_sq_brock::create_radio( 8 );
        level flag::clear( "meteorite_shrunk" );
        ent = getent( "sq_meteorite", "targetname" );
        ent.origin = ent.original_origin;
        ent.angles = ent.original_angles;
        ent setmodel( "p7_zm_sha_meteorite" );
        zm_temple_sq::reset_dynamite();
        level flag::clear( "pap_override" );
        level thread zm_temple_sq_skits::fail_skit();
    }
    
    if ( isdefined( level.catch_trig ) )
    {
        level.catch_trig delete();
        level.catch_trig = undefined;
    }
    
    players = getplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        if ( isdefined( players[ i ]._has_dynamite ) )
        {
            players[ i ]._has_dynamite = undefined;
            players[ i ] zm_sidequests::remove_sidequest_icon( "sq", "dynamite" );
        }
    }
    
    if ( isdefined( level._give_trig ) )
    {
        level._give_trig delete();
    }
    
    gongs = getentarray( "sq_gong", "targetname" );
    array::thread_all( gongs, &dud_gong_handler );
    
    if ( isdefined( level._bag_sound_ent ) )
    {
        level._bag_sound_ent delete();
        level._bag_sound_ent = undefined;
    }
    
    level.skit_vox_override = 0;
}

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0x52e9654a, Offset: 0x1ad8
// Size: 0xb4
function resonate_runner()
{
    if ( !isdefined( level._resonate_time ) || level._resonate_time == 0 )
    {
        level._resonate_time = 60;
    }
    else
    {
        level._resonate_time += 60;
        return;
    }
    
    level endon( #"wrong_gong" );
    level flag::set( "gongs_resonating" );
    
    while ( level._resonate_time )
    {
        level._resonate_time--;
        wait 1;
    }
    
    level flag::clear( "gongs_resonating" );
}

// Namespace zm_temple_sq_bag
// Params 1
// Checksum 0xd9acb58, Offset: 0x1b98
// Size: 0x2fc
function gong_resonate( player )
{
    level endon( #"kill_resonate" );
    self.ringing = 1;
    
    if ( isdefined( self.right_gong ) && self.right_gong )
    {
        self playloopsound( "mus_sq_bag_gong_correct_loop_" + level._num_gongs, 5 );
    }
    else
    {
        self playsound( "evt_sq_bag_gong_incorrect" );
    }
    
    if ( level._num_gongs == 4 )
    {
        level thread resonate_runner();
    }
    
    if ( isdefined( player ) && isplayer( player ) )
    {
        if ( self.right_gong && level._num_gongs == 1 )
        {
            player thread zm_audio::create_and_play_dialog( "eggs", "quest8", 1 );
        }
        else if ( self.right_gong && level flag::get( "gongs_resonating" ) )
        {
            player thread zm_audio::create_and_play_dialog( "eggs", "quest8", 2 );
        }
        else if ( !self.right_gong )
        {
            player thread zm_audio::create_and_play_dialog( "eggs", "quest8", 0 );
        }
    }
    
    if ( self.right_gong == 0 )
    {
        level notify( #"wrong_gong" );
        level._resonate_time = 0;
        gongs = getentarray( "sq_gong", "targetname" );
        
        for ( i = 0; i < gongs.size ; i++ )
        {
            if ( gongs[ i ].right_gong )
            {
                if ( gongs[ i ].ringing )
                {
                    if ( level._num_gongs >= 0 )
                    {
                        level._num_gongs--;
                    }
                    
                    gongs[ i ] stoploopsound( 5 );
                }
            }
            
            gongs[ i ].ringing = 0;
        }
        
        level notify( #"kill_resonate" );
    }
    
    wait 60;
    
    if ( self.right_gong && level._num_gongs >= 0 )
    {
        level._num_gongs--;
    }
    
    self.ringing = 0;
    self stoploopsound( 5 );
}

// Namespace zm_temple_sq_bag
// Params 2
// Checksum 0x1bc2e94e, Offset: 0x1ea0
// Size: 0x54
function gong_goes_bong( in_stage, player )
{
    if ( self.right_gong && level._num_gongs < 4 )
    {
        level._num_gongs++;
    }
    
    self thread gong_resonate( player );
}

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0x5bead011, Offset: 0x1f00
// Size: 0x88
function gong_handler()
{
    level endon( #"sq_bag_over" );
    
    if ( !isdefined( self.ringing ) )
    {
        self.ringing = 0;
    }
    
    self thread debug_gong();
    
    while ( true )
    {
        self waittill( #"triggered", who );
        
        if ( !self.ringing )
        {
            self gong_goes_bong( 1, who );
        }
    }
}

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0x550969fe, Offset: 0x1f90
// Size: 0x98
function debug_gong()
{
    /#
        level endon( #"bag_start" );
        level endon( #"sq_bag_over" );
        
        while ( !( isdefined( level.disable_print3d_ent ) && level.disable_print3d_ent ) )
        {
            if ( !self.ringing && self.right_gong )
            {
                print3d( self.origin + ( 0, 0, 64 ), "<dev string:x99>", ( 0, 255, 0 ), 1 );
            }
            
            wait 0.1;
        }
    #/
}

#using_animtree( "generic" );

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0xfb366661, Offset: 0x2030
// Size: 0x98
function gong_wobble()
{
    if ( isdefined( self.wobble_threaded ) )
    {
        return;
    }
    
    self.wobble_threaded = 1;
    self useanimtree( #animtree );
    
    while ( true )
    {
        self waittill( #"triggered" );
        self animation::stop();
        self thread animation::play( "p7_fxanim_zm_sha_gong_anim", self.origin, self.angles );
    }
}

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0xc9333940, Offset: 0x20d0
// Size: 0x90
function dud_gong_handler()
{
    level endon( #"bag_start" );
    self thread gong_wobble();
    
    if ( !isdefined( self.ringing ) )
    {
        self.ringing = 0;
    }
    
    self thread debug_gong();
    
    while ( true )
    {
        self waittill( #"triggered" );
        
        if ( !self.ringing )
        {
            self gong_goes_bong( 0 );
        }
    }
}

// Namespace zm_temple_sq_bag
// Params 1
// Checksum 0xb0ee2d33, Offset: 0x2168
// Size: 0x22e
function function_43e26f4d( player )
{
    level endon( #"sq_std_over" );
    struct = struct::get( "sq_location_bag", "targetname" );
    
    if ( !isdefined( struct ) )
    {
        return;
    }
    
    level._bag_sound_ent = spawn( "script_origin", struct.origin );
    level._bag_sound_ent playsoundwithnotify( "vox_egg_story_5_0", "sounddone" );
    level._bag_sound_ent waittill( #"sounddone" );
    level._bag_sound_ent playsoundwithnotify( "vox_egg_story_5_1", "sounddone" );
    level._bag_sound_ent waittill( #"sounddone" );
    level._bag_sound_ent playsoundwithnotify( "vox_egg_story_5_2", "sounddone" );
    level._bag_sound_ent waittill( #"sounddone" );
    
    if ( isdefined( player ) )
    {
        level.skit_vox_override = 1;
        player playsoundwithnotify( "vox_egg_story_5_3" + zm_temple_sq::function_26186755( player.characterindex ), "vox_egg_sounddone" );
        player waittill( #"vox_egg_sounddone" );
        level.skit_vox_override = 0;
    }
    
    level._bag_sound_ent playsoundwithnotify( "vox_egg_story_5_4", "sounddone" );
    level._bag_sound_ent waittill( #"sounddone" );
    level._bag_sound_ent playsoundwithnotify( "vox_egg_story_5_5", "sounddone" );
    level._bag_sound_ent waittill( #"sounddone" );
    level._bag_sound_ent delete();
    level._bag_sound_ent = undefined;
}

// Namespace zm_temple_sq_bag
// Params 0
// Checksum 0x98ffb7e, Offset: 0x23a0
// Size: 0x106
function function_69e4e9b6()
{
    level endon( #"sq_std_over" );
    struct = struct::get( "sq_location_bag", "targetname" );
    
    if ( !isdefined( struct ) )
    {
        return;
    }
    
    level._bag_sound_ent = spawn( "script_origin", struct.origin );
    level._bag_sound_ent playsoundwithnotify( "vox_egg_story_5_7", "sounddone" );
    level._bag_sound_ent waittill( #"sounddone" );
    level._bag_sound_ent playsoundwithnotify( "vox_egg_story_5_8", "sounddone" );
    level._bag_sound_ent waittill( #"sounddone" );
    level._bag_sound_ent delete();
    level._bag_sound_ent = undefined;
}

