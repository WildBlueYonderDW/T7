#using scripts/codescripts/struct;
#using scripts/shared/array_shared;
#using scripts/shared/audio_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/music_shared;
#using scripts/shared/system_shared;
#using scripts/shared/trigger_shared;
#using scripts/shared/util_shared;

#namespace zm_stalingrad_amb;

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0xd0a1cd81, Offset: 0x348
// Size: 0xbc
function main()
{
    thread startzmbspawnersoundloops();
    level thread function_bab3ea62();
    level thread function_b21d9845();
    level thread function_d4a3f122();
    level thread function_daa9b420();
    level thread play_flux_whispers();
    level thread function_157aa38();
    level thread function_1e68a892();
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0x89d2d487, Offset: 0x410
// Size: 0x15c
function startzmbspawnersoundloops()
{
    loopers = struct::get_array( "exterior_goal", "targetname" );
    
    if ( isdefined( loopers ) && loopers.size > 0 )
    {
        delay = 0;
        
        /#
            if ( getdvarint( "<dev string:x28>" ) > 0 )
            {
                println( "<dev string:x34>" + loopers.size + "<dev string:x6c>" );
            }
        #/
        
        for ( i = 0; i < loopers.size ; i++ )
        {
            loopers[ i ] thread soundloopthink();
            delay += 1;
            
            if ( delay % 20 == 0 )
            {
                wait 0.016;
            }
        }
        
        return;
    }
    
    /#
        if ( getdvarint( "<dev string:x28>" ) > 0 )
        {
            println( "<dev string:x77>" );
        }
    #/
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0xc55634, Offset: 0x578
// Size: 0x16c
function soundloopthink()
{
    if ( !isdefined( self.origin ) )
    {
        return;
    }
    
    if ( !isdefined( self.script_sound ) )
    {
        self.script_sound = "zmb_spawn_walla";
    }
    
    notifyname = "";
    assert( isdefined( notifyname ) );
    
    if ( isdefined( self.script_string ) )
    {
        notifyname = self.script_string;
    }
    
    assert( isdefined( notifyname ) );
    started = 1;
    
    if ( isdefined( self.script_int ) )
    {
        started = self.script_int != 0;
    }
    
    if ( started )
    {
        soundloopemitter( self.script_sound, self.origin );
    }
    
    if ( notifyname != "" )
    {
        for ( ;; )
        {
            level waittill( notifyname );
            
            if ( started )
            {
                soundstoploopemitter( self.script_sound, self.origin );
            }
            else
            {
                soundloopemitter( self.script_sound, self.origin );
            }
            
            started = !started;
        }
    }
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0xc6172f94, Offset: 0x6f0
// Size: 0xa4
function function_bab3ea62()
{
    wait 3;
    level.var_98f2b64e = "pavlov";
    level thread function_8620d917();
    level thread function_53b9afad();
    var_29085ef = getentarray( 0, "sndMusicTrig", "targetname" );
    array::thread_all( var_29085ef, &sndmusictrig );
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0xed5900c3, Offset: 0x7a0
// Size: 0xc4
function sndmusictrig()
{
    while ( true )
    {
        self waittill( #"trigger", trigplayer );
        
        if ( trigplayer islocalplayer() )
        {
            if ( self.script_sound == "pavlov" )
            {
                level notify( #"hash_51d7bc7c", level.var_98f2b64e );
            }
            else
            {
                level notify( #"hash_51d7bc7c", self.script_sound );
            }
            
            while ( isdefined( trigplayer ) && trigplayer istouching( self ) )
            {
                wait 0.016;
            }
            
            continue;
        }
        
        wait 0.016;
    }
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0x7aa98ef6, Offset: 0x870
// Size: 0xf8
function function_53b9afad()
{
    level.var_b6342abd = "mus_stalingrad_underscore_outdoor";
    level.var_6d9d81aa = "mus_stalingrad_underscore_outdoor";
    level.var_eb526c90 = spawn( 0, ( 0, 0, 0 ), "script_origin" );
    level.var_9433cf5a = level.var_eb526c90 playloopsound( level.var_b6342abd, 2 );
    
    while ( true )
    {
        level waittill( #"hash_51d7bc7c", location );
        level.var_6d9d81aa = "mus_stalingrad_underscore_" + location;
        
        if ( level.var_6d9d81aa != level.var_b6342abd )
        {
            level thread function_51d7bc7c( level.var_6d9d81aa );
            level.var_b6342abd = level.var_6d9d81aa;
        }
    }
}

// Namespace zm_stalingrad_amb
// Params 1
// Checksum 0x72365af7, Offset: 0x970
// Size: 0x64
function function_51d7bc7c( var_6d9d81aa )
{
    level endon( #"hash_51d7bc7c" );
    level.var_eb526c90 stopallloopsounds( 2 );
    wait 1;
    level.var_9433cf5a = level.var_eb526c90 playloopsound( var_6d9d81aa, 2 );
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0x78556f5d, Offset: 0x9e0
// Size: 0x92
function function_8620d917()
{
    while ( true )
    {
        level waittill( #"sndpd" );
        
        if ( level.var_98f2b64e == "pavlov" )
        {
            level.var_98f2b64e = "pavlov_defend";
        }
        else
        {
            level.var_98f2b64e = "pavlov";
        }
        
        if ( level.var_b6342abd == "mus_stalingrad_underscore_pavlov" || level.var_b6342abd == "mus_stalingrad_underscore_pavlov_defend" )
        {
            level notify( #"hash_51d7bc7c", level.var_98f2b64e );
        }
    }
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0x97848ea6, Offset: 0xa80
// Size: 0x92
function function_a2a905a5()
{
    while ( true )
    {
        level waittill( #"sndeed" );
        
        if ( level.var_98f2b64e == "pavlov" || level.var_98f2b64e == "pavlov_defend" )
        {
            level.var_98f2b64e = "pavlov_ee_koth";
        }
        
        if ( level.var_b6342abd == "mus_stalingrad_underscore_pavlov" || level.var_b6342abd == "mus_stalingrad_underscore_pavlov_defend" )
        {
            level notify( #"hash_51d7bc7c", level.var_98f2b64e );
        }
    }
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0xae4659f4, Offset: 0xb20
// Size: 0x50
function function_b21d9845()
{
    while ( true )
    {
        wait randomintrange( 4, 10 );
        playsound( 0, "amb_comp_sweets", ( -3157, 21574, -85 ) );
    }
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0x71f66d34, Offset: 0xb78
// Size: 0x7c
function function_d4a3f122()
{
    audio::playloopat( "amb_creepy_machine_loops", ( -3271, 21733, -86 ) );
    audio::playloopat( "amb_creepy_machine_loops", ( -3078, 22000, -108 ) );
    audio::playloopat( "amb_creepy_machine_loops", ( -2765, 21978, -106 ) );
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0xf600dd06, Offset: 0xc00
// Size: 0x50
function function_daa9b420()
{
    while ( true )
    {
        wait randomintrange( 10, 40 );
        playsound( 0, "amb_banging", ( -3319, 21151, -103 ) );
    }
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0xdad07f90, Offset: 0xc58
// Size: 0xa0
function play_flux_whispers()
{
    while ( true )
    {
        wait randomintrange( 4, 10 );
        playsound( 0, "amb_whispers", ( -3414, 21402, 63 ) );
        playsound( 0, "amb_whispers", ( -2639, 21161, -90 ) );
        playsound( 0, "amb_whispers", ( -3004, 22547, 44 ) );
    }
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0x89a7976e, Offset: 0xd00
// Size: 0x94
function function_157aa38()
{
    level waittill( #"power_on_level" );
    playsound( 0, "amb_sophia_boot", ( 300, 4862, 296 ) );
    audio::playloopat( "amb_sophia_computer_screen_lp", ( -404, 4764, 223 ) );
    wait 8;
    audio::playloopat( "amb_sophia_loop", ( 300, 4862, 296 ) );
}

// Namespace zm_stalingrad_amb
// Params 0
// Checksum 0xaaf6b4f3, Offset: 0xda0
// Size: 0xa0
function function_1e68a892()
{
    while ( true )
    {
        wait randomintrange( 1, 2 );
        playsound( 0, "amb_light_flicker_flour", ( -2956, 21337, 125 ) );
        playsound( 0, "amb_light_flicker_flour", ( -3037, 21457, -39 ) );
        playsound( 0, "amb_light_flicker_flour", ( -3223, 21912, -47 ) );
    }
}

