#using scripts/codescripts/struct;
#using scripts/shared/array_shared;
#using scripts/shared/audio_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/music_shared;
#using scripts/shared/system_shared;
#using scripts/shared/trigger_shared;
#using scripts/shared/util_shared;

#namespace zm_island_amb;

// Namespace zm_island_amb
// Params 0
// Checksum 0x1374c0a9, Offset: 0x320
// Size: 0x34
function main()
{
    thread startzmbspawnersoundloops();
    thread function_d1abcaef();
    thread function_bab3ea62();
}

// Namespace zm_island_amb
// Params 0
// Checksum 0xfd1505ad, Offset: 0x360
// Size: 0x2c
function function_d1abcaef()
{
    audio::playloopat( "zmb_meteor_site_loop", ( 3222, 2237, -599 ) );
}

// Namespace zm_island_amb
// Params 0
// Checksum 0xbe775534, Offset: 0x398
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

// Namespace zm_island_amb
// Params 0
// Checksum 0xe949b689, Offset: 0x500
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

// Namespace zm_island_amb
// Params 0
// Checksum 0x5c8c598, Offset: 0x678
// Size: 0xfc
function function_bab3ea62()
{
    wait 3;
    level.var_65d981dd = "spider_lair_active";
    level.var_2d9f200e = "takeo_battle_inactive";
    level thread function_ab8dfbdf();
    level thread function_17e798e9();
    level thread function_7a83b09a();
    level thread function_610a705b();
    level thread function_53b9afad();
    var_29085ef = getentarray( 0, "sndMusicTrig", "targetname" );
    array::thread_all( var_29085ef, &sndmusictrig );
}

// Namespace zm_island_amb
// Params 0
// Checksum 0x51b0df74, Offset: 0x780
// Size: 0xf4
function sndmusictrig()
{
    while ( true )
    {
        self waittill( #"trigger", trigplayer );
        
        if ( trigplayer islocalplayer() )
        {
            if ( self.script_sound == "spider_lair" )
            {
                level notify( #"hash_51d7bc7c", level.var_65d981dd );
            }
            else if ( self.script_sound == "takeo" )
            {
                level notify( #"hash_51d7bc7c", level.var_2d9f200e );
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

// Namespace zm_island_amb
// Params 0
// Checksum 0x2c14fde8, Offset: 0x880
// Size: 0xf8
function function_53b9afad()
{
    level.var_b6342abd = "mus_island_underscore_outdoor";
    level.var_6d9d81aa = "mus_island_underscore_outdoor";
    level.var_eb526c90 = spawn( 0, ( 0, 0, 0 ), "script_origin" );
    level.var_9433cf5a = level.var_eb526c90 playloopsound( level.var_b6342abd, 2 );
    
    while ( true )
    {
        level waittill( #"hash_51d7bc7c", location );
        level.var_6d9d81aa = "mus_island_underscore_" + location;
        
        if ( level.var_6d9d81aa != level.var_b6342abd )
        {
            level thread function_51d7bc7c( level.var_6d9d81aa );
            level.var_b6342abd = level.var_6d9d81aa;
        }
    }
}

// Namespace zm_island_amb
// Params 1
// Checksum 0xfda86f04, Offset: 0x980
// Size: 0x64
function function_51d7bc7c( var_6d9d81aa )
{
    level endon( #"hash_51d7bc7c" );
    level.var_eb526c90 stopallloopsounds( 2 );
    wait 1;
    level.var_9433cf5a = level.var_eb526c90 playloopsound( var_6d9d81aa, 2 );
}

// Namespace zm_island_amb
// Params 0
// Checksum 0x3ae69385, Offset: 0x9f0
// Size: 0x4a
function function_ab8dfbdf()
{
    level waittill( #"sndlair" );
    level.var_65d981dd = "spider_lair_inactive";
    
    if ( level.var_b6342abd == "mus_island_underscore_spider_lair_active" )
    {
        level notify( #"hash_51d7bc7c", level.var_65d981dd );
    }
}

// Namespace zm_island_amb
// Params 0
// Checksum 0x59fc5b2, Offset: 0xa48
// Size: 0x56
function function_17e798e9()
{
    level endon( #"sndtakeoend" );
    level waittill( #"sndtakeo" );
    level.var_2d9f200e = "takeo_battle_active";
    
    if ( level.var_b6342abd == "mus_island_underscore_takeo_battle_inactive" )
    {
        level notify( #"hash_51d7bc7c", level.var_2d9f200e );
    }
}

// Namespace zm_island_amb
// Params 0
// Checksum 0x2a0f20f9, Offset: 0xaa8
// Size: 0x4a
function function_7a83b09a()
{
    level waittill( #"sndtakeoend" );
    level.var_2d9f200e = "takeo_battle_over";
    
    if ( level.var_b6342abd == "mus_island_underscore_takeo_battle_active" )
    {
        level notify( #"hash_51d7bc7c", level.var_2d9f200e );
    }
}

// Namespace zm_island_amb
// Params 0
// Checksum 0x34f13abb, Offset: 0xb00
// Size: 0x32
function function_610a705b()
{
    while ( true )
    {
        level waittill( #"sndfbm" );
        level notify( #"hash_51d7bc7c", level.var_2d9f200e );
    }
}

