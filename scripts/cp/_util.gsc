#using scripts/cp/_oed;
#using scripts/cp/_skipto;
#using scripts/cp/cybercom/_cybercom_util;
#using scripts/cp/gametypes/coop;
#using scripts/shared/ai_shared;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/flagsys_shared;
#using scripts/shared/gameobjects_shared;
#using scripts/shared/load_shared;
#using scripts/shared/lui_shared;
#using scripts/shared/math_shared;
#using scripts/shared/sound_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/string_shared;
#using scripts/shared/util_shared;

#namespace util;

// Namespace util
// Params 1
// Checksum 0xdf2c10b4, Offset: 0x580
// Size: 0xc
function add_gametype( gt )
{
    
}

/#

    // Namespace util
    // Params 1
    // Checksum 0x4ba8d9b0, Offset: 0x598
    // Size: 0x74, Type: dev
    function error( msg )
    {
        println( "<dev string:x28>", msg );
        wait 0.05;
        
        if ( getdvarstring( "<dev string:x33>" ) != "<dev string:x39>" )
        {
            assertmsg( "<dev string:x3b>" );
        }
    }

    // Namespace util
    // Params 1
    // Checksum 0x4fc3a6d6, Offset: 0x618
    // Size: 0x34, Type: dev
    function warning( msg )
    {
        println( "<dev string:x68>" + msg );
    }

#/

// Namespace util
// Params 4
// Checksum 0x5a5dd738, Offset: 0x658
// Size: 0xa2, Type: bool
function within_fov( start_origin, start_angles, end_origin, fov )
{
    normal = vectornormalize( end_origin - start_origin );
    forward = anglestoforward( start_angles );
    dot = vectordot( forward, normal );
    return dot >= fov;
}

// Namespace util
// Params 0
// Checksum 0xd017b532, Offset: 0x708
// Size: 0xa
function get_player_height()
{
    return 70;
}

// Namespace util
// Params 1
// Checksum 0xc661d7f, Offset: 0x720
// Size: 0x3c, Type: bool
function isbulletimpactmod( smeansofdeath )
{
    return issubstr( smeansofdeath, "BULLET" ) || smeansofdeath == "MOD_HEAD_SHOT";
}

// Namespace util
// Params 0
// Checksum 0xf9a05fb7, Offset: 0x768
// Size: 0x40
function waitrespawnbutton()
{
    self endon( #"disconnect" );
    self endon( #"end_respawn" );
    
    while ( self usebuttonpressed() != 1 )
    {
        wait 0.05;
    }
}

// Namespace util
// Params 3
// Checksum 0x8947017d, Offset: 0x7b0
// Size: 0x200
function setlowermessage( text, time, combinemessageandtimer )
{
    if ( !isdefined( self.lowermessage ) )
    {
        return;
    }
    
    if ( isdefined( self.lowermessageoverride ) && text != &"" )
    {
        text = self.lowermessageoverride;
        time = undefined;
    }
    
    self notify( #"lower_message_set" );
    self.lowermessage settext( text );
    
    if ( isdefined( time ) && time > 0 )
    {
        if ( !isdefined( combinemessageandtimer ) || !combinemessageandtimer )
        {
            self.lowertimer.label = &"";
        }
        else
        {
            self.lowermessage settext( "" );
            self.lowertimer.label = text;
        }
        
        self.lowertimer settimer( time );
    }
    else
    {
        self.lowertimer settext( "" );
        self.lowertimer.label = &"";
    }
    
    if ( self issplitscreen() )
    {
        self.lowermessage.fontscale = 1.4;
    }
    
    self.lowermessage fadeovertime( 0.05 );
    self.lowermessage.alpha = 1;
    self.lowertimer fadeovertime( 0.05 );
    self.lowertimer.alpha = 1;
}

// Namespace util
// Params 3
// Checksum 0x8fd7c138, Offset: 0x9b8
// Size: 0x228
function setlowermessagevalue( text, value, combinemessage )
{
    if ( !isdefined( self.lowermessage ) )
    {
        return;
    }
    
    if ( isdefined( self.lowermessageoverride ) && text != &"" )
    {
        text = self.lowermessageoverride;
        time = undefined;
    }
    
    self notify( #"lower_message_set" );
    
    if ( !isdefined( combinemessage ) || !combinemessage )
    {
        self.lowermessage settext( text );
    }
    else
    {
        self.lowermessage settext( "" );
    }
    
    if ( isdefined( value ) && value > 0 )
    {
        if ( !isdefined( combinemessage ) || !combinemessage )
        {
            self.lowertimer.label = &"";
        }
        else
        {
            self.lowertimer.label = text;
        }
        
        self.lowertimer setvalue( value );
    }
    else
    {
        self.lowertimer settext( "" );
        self.lowertimer.label = &"";
    }
    
    if ( self issplitscreen() )
    {
        self.lowermessage.fontscale = 1.4;
    }
    
    self.lowermessage fadeovertime( 0.05 );
    self.lowermessage.alpha = 1;
    self.lowertimer fadeovertime( 0.05 );
    self.lowertimer.alpha = 1;
}

// Namespace util
// Params 1
// Checksum 0x5394b20a, Offset: 0xbe8
// Size: 0xf4
function clearlowermessage( fadetime )
{
    if ( !isdefined( self.lowermessage ) )
    {
        return;
    }
    
    self notify( #"lower_message_set" );
    
    if ( !isdefined( fadetime ) || fadetime == 0 )
    {
        setlowermessage( &"" );
        return;
    }
    
    self endon( #"disconnect" );
    self endon( #"lower_message_set" );
    self.lowermessage fadeovertime( fadetime );
    self.lowermessage.alpha = 0;
    self.lowertimer fadeovertime( fadetime );
    self.lowertimer.alpha = 0;
    wait fadetime;
    self setlowermessage( "" );
}

// Namespace util
// Params 2
// Checksum 0xc07fc4ce, Offset: 0xce8
// Size: 0xd6
function printonteam( text, team )
{
    assert( isdefined( level.players ) );
    
    for ( i = 0; i < level.players.size ; i++ )
    {
        player = level.players[ i ];
        
        if ( isdefined( player.pers[ "team" ] ) && player.pers[ "team" ] == team )
        {
            player iprintln( text );
        }
    }
}

// Namespace util
// Params 2
// Checksum 0x2080cf4b, Offset: 0xdc8
// Size: 0xd6
function printboldonteam( text, team )
{
    assert( isdefined( level.players ) );
    
    for ( i = 0; i < level.players.size ; i++ )
    {
        player = level.players[ i ];
        
        if ( isdefined( player.pers[ "team" ] ) && player.pers[ "team" ] == team )
        {
            player iprintlnbold( text );
        }
    }
}

// Namespace util
// Params 3
// Checksum 0xc2375d9, Offset: 0xea8
// Size: 0xde
function printboldonteamarg( text, team, arg )
{
    assert( isdefined( level.players ) );
    
    for ( i = 0; i < level.players.size ; i++ )
    {
        player = level.players[ i ];
        
        if ( isdefined( player.pers[ "team" ] ) && player.pers[ "team" ] == team )
        {
            player iprintlnbold( text, arg );
        }
    }
}

// Namespace util
// Params 3
// Checksum 0x8f3f64b8, Offset: 0xf90
// Size: 0x1c
function printonteamarg( text, team, arg )
{
    
}

// Namespace util
// Params 2
// Checksum 0x6dd915af, Offset: 0xfb8
// Size: 0xee
function printonplayers( text, team )
{
    players = level.players;
    
    for ( i = 0; i < players.size ; i++ )
    {
        if ( isdefined( team ) )
        {
            if ( isdefined( players[ i ].pers[ "team" ] ) && players[ i ].pers[ "team" ] == team )
            {
                players[ i ] iprintln( text );
            }
            
            continue;
        }
        
        players[ i ] iprintln( text );
    }
}

// Namespace util
// Params 7
// Checksum 0xf4320b79, Offset: 0x10b0
// Size: 0x516
function printandsoundoneveryone( team, enemyteam, printfriendly, printenemy, soundfriendly, soundenemy, printarg )
{
    shoulddosounds = isdefined( soundfriendly );
    shoulddoenemysounds = 0;
    
    if ( isdefined( soundenemy ) )
    {
        assert( shoulddosounds );
        shoulddoenemysounds = 1;
    }
    
    if ( !isdefined( printarg ) )
    {
        printarg = "";
    }
    
    if ( level.splitscreen || !shoulddosounds )
    {
        for ( i = 0; i < level.players.size ; i++ )
        {
            player = level.players[ i ];
            playerteam = player.pers[ "team" ];
            
            if ( isdefined( playerteam ) )
            {
                if ( playerteam == team && isdefined( printfriendly ) && printfriendly != &"" )
                {
                    player iprintln( printfriendly, printarg );
                    continue;
                }
                
                if ( isdefined( printenemy ) && printenemy != &"" )
                {
                    if ( isdefined( enemyteam ) && playerteam == enemyteam )
                    {
                        player iprintln( printenemy, printarg );
                        continue;
                    }
                    
                    if ( !isdefined( enemyteam ) && playerteam != team )
                    {
                        player iprintln( printenemy, printarg );
                    }
                }
            }
        }
        
        if ( shoulddosounds )
        {
            assert( level.splitscreen );
            level.players[ 0 ] playlocalsound( soundfriendly );
        }
        
        return;
    }
    
    assert( shoulddosounds );
    
    if ( shoulddoenemysounds )
    {
        for ( i = 0; i < level.players.size ; i++ )
        {
            player = level.players[ i ];
            playerteam = player.pers[ "team" ];
            
            if ( isdefined( playerteam ) )
            {
                if ( playerteam == team )
                {
                    if ( isdefined( printfriendly ) && printfriendly != &"" )
                    {
                        player iprintln( printfriendly, printarg );
                    }
                    
                    player playlocalsound( soundfriendly );
                    continue;
                }
                
                if ( !isdefined( enemyteam ) && ( isdefined( enemyteam ) && playerteam == enemyteam || playerteam != team ) )
                {
                    if ( isdefined( printenemy ) && printenemy != &"" )
                    {
                        player iprintln( printenemy, printarg );
                    }
                    
                    player playlocalsound( soundenemy );
                }
            }
        }
        
        return;
    }
    
    for ( i = 0; i < level.players.size ; i++ )
    {
        player = level.players[ i ];
        playerteam = player.pers[ "team" ];
        
        if ( isdefined( playerteam ) )
        {
            if ( playerteam == team )
            {
                if ( isdefined( printfriendly ) && printfriendly != &"" )
                {
                    player iprintln( printfriendly, printarg );
                }
                
                player playlocalsound( soundfriendly );
                continue;
            }
            
            if ( isdefined( printenemy ) && printenemy != &"" )
            {
                if ( isdefined( enemyteam ) && playerteam == enemyteam )
                {
                    player iprintln( printenemy, printarg );
                    continue;
                }
                
                if ( !isdefined( enemyteam ) && playerteam != team )
                {
                    player iprintln( printenemy, printarg );
                }
            }
        }
    }
}

// Namespace util
// Params 1
// Checksum 0x44b504fa, Offset: 0x15d0
// Size: 0x4c
function _playlocalsound( soundalias )
{
    if ( level.splitscreen && !self ishost() )
    {
        return;
    }
    
    self playlocalsound( soundalias );
}

// Namespace util
// Params 1
// Checksum 0xe92f89da, Offset: 0x1628
// Size: 0x74
function getotherteam( team )
{
    if ( team == "allies" )
    {
        return "axis";
    }
    else if ( team == "axis" )
    {
        return "allies";
    }
    else
    {
        return "allies";
    }
    
    assertmsg( "<dev string:x74>" + team );
}

// Namespace util
// Params 1
// Checksum 0x5793426, Offset: 0x16a8
// Size: 0x64
function getteammask( team )
{
    if ( !level.teambased || !isdefined( team ) || !isdefined( level.spawnsystem.ispawn_teammask[ team ] ) )
    {
        return level.spawnsystem.ispawn_teammask_free;
    }
    
    return level.spawnsystem.ispawn_teammask[ team ];
}

// Namespace util
// Params 1
// Checksum 0x7e0a6428, Offset: 0x1718
// Size: 0xc4
function getotherteamsmask( skip_team )
{
    mask = 0;
    
    foreach ( team in level.teams )
    {
        if ( team == skip_team )
        {
            continue;
        }
        
        mask |= getteammask( team );
    }
    
    return mask;
}

// Namespace util
// Params 5
// Checksum 0x1be427e3, Offset: 0x17e8
// Size: 0x126
function plot_points( plotpoints, r, g, b, server_frames )
{
    if ( !isdefined( r ) )
    {
        r = 1;
    }
    
    if ( !isdefined( g ) )
    {
        g = 1;
    }
    
    if ( !isdefined( b ) )
    {
        b = 1;
    }
    
    if ( !isdefined( server_frames ) )
    {
        server_frames = 1;
    }
    
    /#
        lastpoint = plotpoints[ 0 ];
        server_frames = int( server_frames );
        
        for ( i = 1; i < plotpoints.size ; i++ )
        {
            line( lastpoint, plotpoints[ i ], ( r, g, b ), 1, server_frames );
            lastpoint = plotpoints[ i ];
        }
    #/
}

// Namespace util
// Params 1
// Checksum 0x740149df, Offset: 0x1918
// Size: 0x50
function getfx( fx )
{
    assert( isdefined( level._effect[ fx ] ), "<dev string:x90>" + fx + "<dev string:x94>" );
    return level._effect[ fx ];
}

// Namespace util
// Params 3
// Checksum 0x69002ad8, Offset: 0x1970
// Size: 0x92
function set_dvar_if_unset( dvar, value, reset )
{
    if ( !isdefined( reset ) )
    {
        reset = 0;
    }
    
    if ( reset || getdvarstring( dvar ) == "" )
    {
        setdvar( dvar, value );
        return value;
    }
    
    return getdvarstring( dvar );
}

// Namespace util
// Params 3
// Checksum 0x469f7bda, Offset: 0x1a10
// Size: 0x8a
function set_dvar_float_if_unset( dvar, value, reset )
{
    if ( !isdefined( reset ) )
    {
        reset = 0;
    }
    
    if ( reset || getdvarstring( dvar ) == "" )
    {
        setdvar( dvar, value );
    }
    
    return getdvarfloat( dvar );
}

// Namespace util
// Params 3
// Checksum 0x5cc43a58, Offset: 0x1aa8
// Size: 0xa2
function set_dvar_int_if_unset( dvar, value, reset )
{
    if ( !isdefined( reset ) )
    {
        reset = 0;
    }
    
    if ( reset || getdvarstring( dvar ) == "" )
    {
        setdvar( dvar, value );
        return int( value );
    }
    
    return getdvarint( dvar );
}

// Namespace util
// Params 1
// Checksum 0xd159a055, Offset: 0x1b58
// Size: 0x5a
function add_trigger_to_ent( ent )
{
    if ( !isdefined( ent._triggers ) )
    {
        ent._triggers = [];
    }
    
    ent._triggers[ self getentitynumber() ] = 1;
}

// Namespace util
// Params 1
// Checksum 0x3ab1df54, Offset: 0x1bc0
// Size: 0x7a
function remove_trigger_from_ent( ent )
{
    if ( !isdefined( ent ) )
    {
        return;
    }
    
    if ( !isdefined( ent._triggers ) )
    {
        return;
    }
    
    if ( !isdefined( ent._triggers[ self getentitynumber() ] ) )
    {
        return;
    }
    
    ent._triggers[ self getentitynumber() ] = 0;
}

// Namespace util
// Params 1
// Checksum 0x20d53b0f, Offset: 0x1c48
// Size: 0x70, Type: bool
function ent_already_in_trigger( trig )
{
    if ( !isdefined( self._triggers ) )
    {
        return false;
    }
    
    if ( !isdefined( self._triggers[ trig getentitynumber() ] ) )
    {
        return false;
    }
    
    if ( !self._triggers[ trig getentitynumber() ] )
    {
        return false;
    }
    
    return true;
}

// Namespace util
// Params 2
// Checksum 0x97f36f82, Offset: 0x1cc0
// Size: 0x44
function trigger_thread_death_monitor( ent, ender )
{
    ent waittill( #"death" );
    self endon( ender );
    self remove_trigger_from_ent( ent );
}

// Namespace util
// Params 3
// Checksum 0x7358cbdd, Offset: 0x1d10
// Size: 0x1a6
function trigger_thread( ent, on_enter_payload, on_exit_payload )
{
    ent endon( #"entityshutdown" );
    ent endon( #"death" );
    
    if ( ent ent_already_in_trigger( self ) )
    {
        return;
    }
    
    self add_trigger_to_ent( ent );
    ender = "end_trig_death_monitor" + self getentitynumber() + " " + ent getentitynumber();
    self thread trigger_thread_death_monitor( ent, ender );
    endon_condition = "leave_trigger_" + self getentitynumber();
    
    if ( isdefined( on_enter_payload ) )
    {
        self thread [[ on_enter_payload ]]( ent, endon_condition );
    }
    
    while ( isdefined( ent ) && ent istouching( self ) )
    {
        wait 0.01;
    }
    
    ent notify( endon_condition );
    
    if ( isdefined( ent ) && isdefined( on_exit_payload ) )
    {
        self thread [[ on_exit_payload ]]( ent );
    }
    
    if ( isdefined( ent ) )
    {
        self remove_trigger_from_ent( ent );
    }
    
    self notify( ender );
}

// Namespace util
// Params 2
// Checksum 0x73f82edd, Offset: 0x1ec0
// Size: 0x38, Type: bool
function isstrstart( string1, substr )
{
    return getsubstr( string1, 0, substr.size ) == substr;
}

// Namespace util
// Params 0
// Checksum 0xcb1c7a40, Offset: 0x1f00
// Size: 0x16, Type: bool
function iskillstreaksenabled()
{
    return isdefined( level.killstreaksenabled ) && level.killstreaksenabled;
}

// Namespace util
// Params 1
// Checksum 0x41b8c145, Offset: 0x1f20
// Size: 0x82
function setusingremote( remotename )
{
    if ( isdefined( self.carryicon ) )
    {
        self.carryicon.alpha = 0;
    }
    
    assert( !self isusingremote() );
    self.usingremote = remotename;
    self disableoffhandweapons();
    self notify( #"using_remote" );
}

// Namespace util
// Params 0
// Checksum 0x3b09e591, Offset: 0x1fb0
// Size: 0x32
function getremotename()
{
    assert( self isusingremote() );
    return self.usingremote;
}

// Namespace util
// Params 2
// Checksum 0x3eb3b383, Offset: 0x1ff0
// Size: 0x32
function setobjectivetext( team, text )
{
    game[ "strings" ][ "objective_" + team ] = text;
}

// Namespace util
// Params 2
// Checksum 0x8af14cec, Offset: 0x2030
// Size: 0x32
function setobjectivescoretext( team, text )
{
    game[ "strings" ][ "objective_score_" + team ] = text;
}

// Namespace util
// Params 2
// Checksum 0x721ec063, Offset: 0x2070
// Size: 0x32
function setobjectivehinttext( team, text )
{
    game[ "strings" ][ "objective_hint_" + team ] = text;
}

// Namespace util
// Params 1
// Checksum 0xbe40cbd0, Offset: 0x20b0
// Size: 0x24
function getobjectivetext( team )
{
    return game[ "strings" ][ "objective_" + team ];
}

// Namespace util
// Params 1
// Checksum 0x2bd94d9d, Offset: 0x20e0
// Size: 0x24
function getobjectivescoretext( team )
{
    return game[ "strings" ][ "objective_score_" + team ];
}

// Namespace util
// Params 1
// Checksum 0x4e56ea, Offset: 0x2110
// Size: 0x24
function getobjectivehinttext( team )
{
    return game[ "strings" ][ "objective_hint_" + team ];
}

// Namespace util
// Params 2
// Checksum 0x2fd99b1d, Offset: 0x2140
// Size: 0x64
function registerroundswitch( minvalue, maxvalue )
{
    level.roundswitch = math::clamp( getgametypesetting( "roundSwitch" ), minvalue, maxvalue );
    level.roundswitchmin = minvalue;
    level.roundswitchmax = maxvalue;
}

// Namespace util
// Params 2
// Checksum 0xfd035cb3, Offset: 0x21b0
// Size: 0x64
function registerroundlimit( minvalue, maxvalue )
{
    level.roundlimit = math::clamp( getgametypesetting( "roundLimit" ), minvalue, maxvalue );
    level.roundlimitmin = minvalue;
    level.roundlimitmax = maxvalue;
}

// Namespace util
// Params 2
// Checksum 0xb70797ad, Offset: 0x2220
// Size: 0x64
function registerroundwinlimit( minvalue, maxvalue )
{
    level.roundwinlimit = math::clamp( getgametypesetting( "roundWinLimit" ), minvalue, maxvalue );
    level.roundwinlimitmin = minvalue;
    level.roundwinlimitmax = maxvalue;
}

// Namespace util
// Params 2
// Checksum 0xc487f20, Offset: 0x2290
// Size: 0x84
function registerscorelimit( minvalue, maxvalue )
{
    level.scorelimit = math::clamp( getgametypesetting( "scoreLimit" ), minvalue, maxvalue );
    level.scorelimitmin = minvalue;
    level.scorelimitmax = maxvalue;
    setdvar( "ui_scorelimit", level.scorelimit );
}

// Namespace util
// Params 2
// Checksum 0x67b07d14, Offset: 0x2320
// Size: 0x84
function registertimelimit( minvalue, maxvalue )
{
    level.timelimit = math::clamp( getgametypesetting( "timeLimit" ), minvalue, maxvalue );
    level.timelimitmin = minvalue;
    level.timelimitmax = maxvalue;
    setdvar( "ui_timelimit", level.timelimit );
}

// Namespace util
// Params 2
// Checksum 0x70e37891, Offset: 0x23b0
// Size: 0x64
function registernumlives( minvalue, maxvalue )
{
    level.numlives = math::clamp( getgametypesetting( "playerNumLives" ), minvalue, maxvalue );
    level.numlivesmin = minvalue;
    level.numlivesmax = maxvalue;
}

// Namespace util
// Params 1
// Checksum 0x8f0ffc76, Offset: 0x2420
// Size: 0x7e
function getplayerfromclientnum( clientnum )
{
    if ( clientnum < 0 )
    {
        return undefined;
    }
    
    for ( i = 0; i < level.players.size ; i++ )
    {
        if ( level.players[ i ] getentitynumber() == clientnum )
        {
            return level.players[ i ];
        }
    }
    
    return undefined;
}

// Namespace util
// Params 0
// Checksum 0xecfc0627, Offset: 0x24a8
// Size: 0x4c, Type: bool
function ispressbuild()
{
    buildtype = getdvarstring( "buildType" );
    
    if ( isdefined( buildtype ) && buildtype == "press" )
    {
        return true;
    }
    
    return false;
}

// Namespace util
// Params 0
// Checksum 0xfd5bc1a0, Offset: 0x2500
// Size: 0x1c, Type: bool
function isflashbanged()
{
    return isdefined( self.flashendtime ) && gettime() < self.flashendtime;
}

// Namespace util
// Params 0
// Checksum 0x3460cf7e, Offset: 0x2528
// Size: 0xac, Type: bool
function isentstunned()
{
    time = gettime();
    
    if ( isdefined( self.stunned ) && self.stunned )
    {
        return true;
    }
    
    if ( self isflashbanged() )
    {
        return true;
    }
    
    if ( isdefined( self.stun_fx ) )
    {
        return true;
    }
    
    if ( isdefined( self.laststunnedtime ) && self.laststunnedtime + 5000 > time )
    {
        return true;
    }
    
    if ( isdefined( self.concussionendtime ) && self.concussionendtime > time )
    {
        return true;
    }
    
    return false;
}

// Namespace util
// Params 5
// Checksum 0x5f65e78a, Offset: 0x25e0
// Size: 0xbc
function domaxdamage( origin, attacker, inflictor, headshot, mod )
{
    if ( isdefined( self.damagedtodeath ) && self.damagedtodeath )
    {
        return;
    }
    
    if ( isdefined( self.maxhealth ) )
    {
        damage = self.maxhealth + 1;
    }
    else
    {
        damage = self.health + 1;
    }
    
    self.damagedtodeath = 1;
    self dodamage( damage, origin, attacker, inflictor, headshot, mod );
}

// Namespace util
// Params 0
// Checksum 0x9ee18fbf, Offset: 0x26a8
// Size: 0x24
function self_delete()
{
    if ( isdefined( self ) )
    {
        self delete();
    }
}

// Namespace util
// Params 5
// Checksum 0x4f7a454c, Offset: 0x26d8
// Size: 0x52c
function screen_message_create( string_message_1, string_message_2, string_message_3, n_offset_y, n_time )
{
    level notify( #"screen_message_create" );
    level endon( #"screen_message_create" );
    
    if ( isdefined( level.missionfailed ) && level.missionfailed )
    {
        return;
    }
    
    if ( getdvarint( "hud_missionFailed" ) == 1 )
    {
        return;
    }
    
    if ( !isdefined( n_offset_y ) )
    {
        n_offset_y = 0;
    }
    
    if ( !isdefined( level._screen_message_1 ) )
    {
        level._screen_message_1 = newhudelem();
        level._screen_message_1.elemtype = "font";
        level._screen_message_1.font = "objective";
        level._screen_message_1.fontscale = 1.8;
        level._screen_message_1.horzalign = "center";
        level._screen_message_1.vertalign = "middle";
        level._screen_message_1.alignx = "center";
        level._screen_message_1.aligny = "middle";
        level._screen_message_1.y = -60 + n_offset_y;
        level._screen_message_1.sort = 2;
        level._screen_message_1.color = ( 1, 1, 1 );
        level._screen_message_1.alpha = 1;
        level._screen_message_1.hidewheninmenu = 1;
    }
    
    level._screen_message_1 settext( string_message_1 );
    
    if ( isdefined( string_message_2 ) )
    {
        if ( !isdefined( level._screen_message_2 ) )
        {
            level._screen_message_2 = newhudelem();
            level._screen_message_2.elemtype = "font";
            level._screen_message_2.font = "objective";
            level._screen_message_2.fontscale = 1.8;
            level._screen_message_2.horzalign = "center";
            level._screen_message_2.vertalign = "middle";
            level._screen_message_2.alignx = "center";
            level._screen_message_2.aligny = "middle";
            level._screen_message_2.y = -33 + n_offset_y;
            level._screen_message_2.sort = 2;
            level._screen_message_2.color = ( 1, 1, 1 );
            level._screen_message_2.alpha = 1;
            level._screen_message_2.hidewheninmenu = 1;
        }
        
        level._screen_message_2 settext( string_message_2 );
    }
    else if ( isdefined( level._screen_message_2 ) )
    {
        level._screen_message_2 destroy();
    }
    
    if ( isdefined( string_message_3 ) )
    {
        if ( !isdefined( level._screen_message_3 ) )
        {
            level._screen_message_3 = newhudelem();
            level._screen_message_3.elemtype = "font";
            level._screen_message_3.font = "objective";
            level._screen_message_3.fontscale = 1.8;
            level._screen_message_3.horzalign = "center";
            level._screen_message_3.vertalign = "middle";
            level._screen_message_3.alignx = "center";
            level._screen_message_3.aligny = "middle";
            level._screen_message_3.y = -6 + n_offset_y;
            level._screen_message_3.sort = 2;
            level._screen_message_3.color = ( 1, 1, 1 );
            level._screen_message_3.alpha = 1;
            level._screen_message_3.hidewheninmenu = 1;
        }
        
        level._screen_message_3 settext( string_message_3 );
    }
    else if ( isdefined( level._screen_message_3 ) )
    {
        level._screen_message_3 destroy();
    }
    
    if ( isdefined( n_time ) && n_time > 0 )
    {
        wait n_time;
        screen_message_delete();
    }
}

// Namespace util
// Params 1
// Checksum 0x2397ab4d, Offset: 0x2c10
// Size: 0x94
function screen_message_delete( delay )
{
    if ( isdefined( delay ) )
    {
        wait delay;
    }
    
    if ( isdefined( level._screen_message_1 ) )
    {
        level._screen_message_1 destroy();
    }
    
    if ( isdefined( level._screen_message_2 ) )
    {
        level._screen_message_2 destroy();
    }
    
    if ( isdefined( level._screen_message_3 ) )
    {
        level._screen_message_3 destroy();
    }
}

// Namespace util
// Params 5
// Checksum 0xce784fe7, Offset: 0x2cb0
// Size: 0x54c
function screen_message_create_client( string_message_1, string_message_2, string_message_3, n_offset_y, n_time )
{
    self notify( #"screen_message_create" );
    self endon( #"screen_message_create" );
    self endon( #"death" );
    
    if ( isdefined( level.missionfailed ) && level.missionfailed )
    {
        return;
    }
    
    if ( getdvarint( "hud_missionFailed" ) == 1 )
    {
        return;
    }
    
    if ( !isdefined( n_offset_y ) )
    {
        n_offset_y = 0;
    }
    
    if ( !isdefined( self._screen_message_1 ) )
    {
        self._screen_message_1 = newclienthudelem( self );
        self._screen_message_1.elemtype = "font";
        self._screen_message_1.font = "objective";
        self._screen_message_1.fontscale = 1.8;
        self._screen_message_1.horzalign = "center";
        self._screen_message_1.vertalign = "middle";
        self._screen_message_1.alignx = "center";
        self._screen_message_1.aligny = "middle";
        self._screen_message_1.y = -60 + n_offset_y;
        self._screen_message_1.sort = 2;
        self._screen_message_1.color = ( 1, 1, 1 );
        self._screen_message_1.alpha = 1;
        self._screen_message_1.hidewheninmenu = 1;
    }
    
    self._screen_message_1 settext( string_message_1 );
    
    if ( isdefined( string_message_2 ) )
    {
        if ( !isdefined( self._screen_message_2 ) )
        {
            self._screen_message_2 = newclienthudelem( self );
            self._screen_message_2.elemtype = "font";
            self._screen_message_2.font = "objective";
            self._screen_message_2.fontscale = 1.8;
            self._screen_message_2.horzalign = "center";
            self._screen_message_2.vertalign = "middle";
            self._screen_message_2.alignx = "center";
            self._screen_message_2.aligny = "middle";
            self._screen_message_2.y = -33 + n_offset_y;
            self._screen_message_2.sort = 2;
            self._screen_message_2.color = ( 1, 1, 1 );
            self._screen_message_2.alpha = 1;
            self._screen_message_2.hidewheninmenu = 1;
        }
        
        self._screen_message_2 settext( string_message_2 );
    }
    else if ( isdefined( self._screen_message_2 ) )
    {
        self._screen_message_2 destroy();
    }
    
    if ( isdefined( string_message_3 ) )
    {
        if ( !isdefined( self._screen_message_3 ) )
        {
            self._screen_message_3 = newclienthudelem( self );
            self._screen_message_3.elemtype = "font";
            self._screen_message_3.font = "objective";
            self._screen_message_3.fontscale = 1.8;
            self._screen_message_3.horzalign = "center";
            self._screen_message_3.vertalign = "middle";
            self._screen_message_3.alignx = "center";
            self._screen_message_3.aligny = "middle";
            self._screen_message_3.y = -6 + n_offset_y;
            self._screen_message_3.sort = 2;
            self._screen_message_3.color = ( 1, 1, 1 );
            self._screen_message_3.alpha = 1;
            self._screen_message_3.hidewheninmenu = 1;
        }
        
        self._screen_message_3 settext( string_message_3 );
    }
    else if ( isdefined( self._screen_message_3 ) )
    {
        self._screen_message_3 destroy();
    }
    
    if ( isdefined( n_time ) && n_time > 0 )
    {
        wait n_time;
        self screen_message_delete_client();
    }
}

// Namespace util
// Params 1
// Checksum 0x2fa20bad, Offset: 0x3208
// Size: 0x9c
function screen_message_delete_client( delay )
{
    self endon( #"death" );
    
    if ( isdefined( delay ) )
    {
        wait delay;
    }
    
    if ( isdefined( self._screen_message_1 ) )
    {
        self._screen_message_1 destroy();
    }
    
    if ( isdefined( self._screen_message_2 ) )
    {
        self._screen_message_2 destroy();
    }
    
    if ( isdefined( self._screen_message_3 ) )
    {
        self._screen_message_3 destroy();
    }
}

// Namespace util
// Params 3
// Checksum 0xedf6a533, Offset: 0x32b0
// Size: 0x3c
function screen_fade_out( n_time, str_shader, str_menu_id )
{
    level lui::screen_fade_out( n_time, str_shader, str_menu_id );
}

// Namespace util
// Params 3
// Checksum 0x5ee4ee3b, Offset: 0x32f8
// Size: 0x3c
function screen_fade_in( n_time, str_shader, str_menu_id )
{
    level lui::screen_fade_in( n_time, str_shader, str_menu_id );
}

// Namespace util
// Params 4
// Checksum 0x9edb253f, Offset: 0x3340
// Size: 0x122
function screen_fade_to_alpha_with_blur( n_alpha, n_fade_time, n_blur, str_shader )
{
    assert( isdefined( n_alpha ), "<dev string:xb6>" );
    assert( isplayer( self ), "<dev string:xf6>" );
    level notify( #"_screen_fade" );
    level endon( #"_screen_fade" );
    hud_fade = get_fade_hud( str_shader );
    hud_fade fadeovertime( n_fade_time );
    hud_fade.alpha = n_alpha;
    
    if ( isdefined( n_blur ) && n_blur >= 0 )
    {
        self setblur( n_blur, n_fade_time );
    }
    
    wait n_fade_time;
}

// Namespace util
// Params 3
// Checksum 0xf4c007b7, Offset: 0x3470
// Size: 0x3c
function screen_fade_to_alpha( n_alpha, n_fade_time, str_shader )
{
    screen_fade_to_alpha_with_blur( n_alpha, n_fade_time, 0, str_shader );
}

// Namespace util
// Params 1
// Checksum 0x5a34ba90, Offset: 0x34b8
// Size: 0xfa
function get_fade_hud( str_shader )
{
    if ( !isdefined( str_shader ) )
    {
        str_shader = "black";
    }
    
    if ( !isdefined( level.fade_hud ) )
    {
        level.fade_hud = newhudelem();
        level.fade_hud.x = 0;
        level.fade_hud.y = 0;
        level.fade_hud.horzalign = "fullscreen";
        level.fade_hud.vertalign = "fullscreen";
        level.fade_hud.sort = 0;
        level.fade_hud.alpha = 0;
    }
    
    level.fade_hud setshader( str_shader, 640, 480 );
    return level.fade_hud;
}

// Namespace util
// Params 9
// Checksum 0x4a67e5cf, Offset: 0x35c0
// Size: 0x154
function missionfailedwrapper( fail_reason, fail_hint, shader, iwidth, iheight, fdelay, x, y, b_count_as_death )
{
    if ( !isdefined( b_count_as_death ) )
    {
        b_count_as_death = 1;
    }
    
    if ( level.missionfailed )
    {
        return;
    }
    
    if ( isdefined( level.nextmission ) )
    {
        return;
    }
    
    if ( getdvarstring( "failure_disabled" ) == "1" )
    {
        return;
    }
    
    screen_message_delete();
    
    if ( isdefined( fail_hint ) )
    {
        setdvar( "ui_deadquote", fail_hint );
    }
    
    if ( isdefined( shader ) )
    {
        getplayers()[ 0 ] thread load::special_death_indicator_hudelement( shader, iwidth, iheight, fdelay, x, y );
    }
    
    level.missionfailed = 1;
    
    if ( b_count_as_death )
    {
    }
    
    level thread coop::function_5ed5738a( fail_reason, fail_hint );
}

// Namespace util
// Params 8
// Checksum 0x5f9ced22, Offset: 0x3720
// Size: 0x7c
function missionfailedwrapper_nodeath( fail_reason, fail_hint, shader, iwidth, iheight, fdelay, x, y )
{
    missionfailedwrapper( fail_reason, fail_hint, shader, iwidth, iheight, fdelay, x, y, 0 );
}

// Namespace util
// Params 3
// Checksum 0x1ae7f975, Offset: 0x37a8
// Size: 0x13e
function helper_message( message, delay, str_abort_flag )
{
    level notify( #"kill_helper_message" );
    level endon( #"kill_helper_message" );
    helper_message_delete();
    level.helper_message = message;
    screen_message_create( message );
    
    if ( !isdefined( delay ) )
    {
        delay = 5;
    }
    
    start_time = gettime();
    
    while ( true )
    {
        time = gettime();
        dt = ( time - start_time ) / 1000;
        
        if ( dt >= delay )
        {
            break;
        }
        
        if ( isdefined( str_abort_flag ) && level flag::get( str_abort_flag ) == 1 )
        {
            break;
        }
        
        wait 0.01;
    }
    
    if ( isdefined( level.helper_message ) )
    {
        screen_message_delete();
    }
    
    level.helper_message = undefined;
}

// Namespace util
// Params 0
// Checksum 0x8dda742b, Offset: 0x38f0
// Size: 0x2e
function helper_message_delete()
{
    if ( isdefined( level.helper_message ) )
    {
        screen_message_delete();
    }
    
    level.helper_message = undefined;
}

// Namespace util
// Params 0
// Checksum 0xbb3ae274, Offset: 0x3928
// Size: 0x88
function show_hit_marker()
{
    if ( isdefined( self ) && isdefined( self.hud_damagefeedback ) )
    {
        self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
        self.hud_damagefeedback.alpha = 1;
        self.hud_damagefeedback fadeovertime( 1 );
        self.hud_damagefeedback.alpha = 0;
    }
}

// Namespace util
// Params 8
// Checksum 0x87cdf04c, Offset: 0x39b8
// Size: 0x2f8
function init_hero( name, func_init, arg1, arg2, arg3, arg4, arg5, b_show_in_ev )
{
    if ( !isdefined( b_show_in_ev ) )
    {
        b_show_in_ev = 1;
    }
    
    if ( !isdefined( level.heroes ) )
    {
        level.heroes = [];
    }
    
    name = tolower( name );
    ai_hero = getent( name + "_ai", "targetname", 1 );
    
    if ( !isalive( ai_hero ) )
    {
        ai_hero = getent( name, "targetname", 1 );
        
        if ( !isalive( ai_hero ) )
        {
            spawner = getent( name, "targetname" );
            
            if ( !( isdefined( spawner.spawning ) && spawner.spawning ) )
            {
                spawner.count++;
                ai_hero = spawner::simple_spawn_single( spawner );
                assert( isdefined( ai_hero ), "<dev string:x134>" + name + "<dev string:x14b>" );
                spawner notify( #"hero_spawned", ai_hero );
            }
            else
            {
                spawner waittill( #"hero_spawned", ai_hero );
            }
        }
    }
    
    level.heroes[ name ] = ai_hero;
    ai_hero.animname = name;
    ai_hero.is_hero = 1;
    ai_hero.enableterrainik = 1;
    ai_hero settmodeprovider( 1 );
    ai_hero magic_bullet_shield();
    ai_hero thread _hero_death( name );
    
    if ( isdefined( func_init ) )
    {
        single_thread( ai_hero, func_init, arg1, arg2, arg3, arg4, arg5 );
    }
    
    if ( isdefined( level.customherospawn ) )
    {
        ai_hero [[ level.customherospawn ]]();
    }
    
    if ( b_show_in_ev )
    {
        ai_hero thread oed::enable_thermal();
    }
    
    return ai_hero;
}

// Namespace util
// Params 7
// Checksum 0x47b4bc7d, Offset: 0x3cb8
// Size: 0x142
function init_heroes( a_hero_names, func, arg1, arg2, arg3, arg4, arg5 )
{
    a_heroes = [];
    
    foreach ( str_hero in a_hero_names )
    {
        if ( !isdefined( a_heroes ) )
        {
            a_heroes = [];
        }
        else if ( !isarray( a_heroes ) )
        {
            a_heroes = array( a_heroes );
        }
        
        a_heroes[ a_heroes.size ] = init_hero( str_hero, func, arg1, arg2, arg3, arg4, arg5 );
    }
    
    return a_heroes;
}

// Namespace util
// Params 1
// Checksum 0x53a669f, Offset: 0x3e08
// Size: 0x74
function _hero_death( str_name )
{
    self endon( #"unmake_hero" );
    self waittill( #"death" );
    
    if ( isdefined( self ) )
    {
        assertmsg( "<dev string:x14e>" + str_name + "<dev string:x155>" );
    }
    
    unmake_hero( str_name );
}

// Namespace util
// Params 1
// Checksum 0xe15be440, Offset: 0x3e88
// Size: 0xa4
function unmake_hero( str_name )
{
    ai_hero = level.heroes[ str_name ];
    level.heroes = array::remove_index( level.heroes, str_name, 1 );
    
    if ( isalive( ai_hero ) )
    {
        ai_hero settmodeprovider( 0 );
        ai_hero stop_magic_bullet_shield();
        ai_hero notify( #"unmake_hero" );
    }
}

// Namespace util
// Params 0
// Checksum 0x6d811c4b, Offset: 0x3f38
// Size: 0xa
function get_heroes()
{
    return level.heroes;
}

// Namespace util
// Params 1
// Checksum 0xf3970b5b, Offset: 0x3f50
// Size: 0x64
function get_hero( str_name )
{
    if ( !isdefined( level.heroes ) )
    {
        level.heroes = [];
    }
    
    if ( isdefined( level.heroes[ str_name ] ) )
    {
        return level.heroes[ str_name ];
    }
    
    return init_hero( str_name );
}

// Namespace util
// Params 0
// Checksum 0xb2268fb6, Offset: 0x3fc0
// Size: 0x16, Type: bool
function is_hero()
{
    return isdefined( self.is_hero ) && self.is_hero;
}

// Namespace util
// Params 1
// Checksum 0x21171010, Offset: 0x3fe0
// Size: 0x4c
function init_streamer_hints( number_of_zones )
{
    clientfield::register( "world", "force_streamer", 1, getminbitcountfornum( number_of_zones ), "int" );
}

// Namespace util
// Params 0
// Checksum 0xeebbd199, Offset: 0x4038
// Size: 0x44
function clear_streamer_hint()
{
    level flag::wait_till( "all_players_connected" );
    level clientfield::set( "force_streamer", 0 );
}

// Namespace util
// Params 2
// Checksum 0xb2b3e65a, Offset: 0x4088
// Size: 0x44
function set_streamer_hint( n_zone, b_clear_previous )
{
    if ( !isdefined( b_clear_previous ) )
    {
        b_clear_previous = 1;
    }
    
    level thread _set_streamer_hint( n_zone, b_clear_previous );
}

// Namespace util
// Params 2
// Checksum 0xbbf3a563, Offset: 0x40d8
// Size: 0x2bc
function _set_streamer_hint( n_zone, b_clear_previous )
{
    if ( !isdefined( b_clear_previous ) )
    {
        b_clear_previous = 1;
    }
    
    level notify( #"set_streamer_hint" );
    level endon( #"set_streamer_hint" );
    assert( n_zone > 0, "<dev string:x15d>" );
    level flagsys::set( "streamer_loading" );
    level flag::wait_till( "all_players_connected" );
    
    if ( b_clear_previous )
    {
        level clientfield::set( "force_streamer", 0 );
        wait_network_frame();
    }
    
    level clientfield::set( "force_streamer", n_zone );
    
    if ( !isdefined( level.b_wait_for_streamer_default ) )
    {
        level.b_wait_for_streamer_default = 1;
        
        /#
            level.b_wait_for_streamer_default = 0;
        #/
    }
    
    foreach ( player in level.players )
    {
        player thread _streamer_hint_wait( n_zone );
    }
    
    /#
        n_timeout = gettime() + 15000;
    #/
    
    array::wait_till( level.players, "streamer" + n_zone, 15 );
    level flagsys::clear( "streamer_loading" );
    level streamer_wait();
    
    /#
        if ( gettime() >= n_timeout )
        {
            printtoprightln( "<dev string:x184>" + string::rfill( gettime(), 6, "<dev string:x19e>" ), ( 1, 0, 0 ) );
            return;
        }
        
        printtoprightln( "<dev string:x1a0>" + string::rfill( gettime(), 6, "<dev string:x19e>" ), ( 1, 1, 1 ) );
    #/
}

// Namespace util
// Params 1
// Checksum 0xe0ce45fb, Offset: 0x43a0
// Size: 0x48
function _streamer_hint_wait( n_zone )
{
    self endon( #"disconnect" );
    level endon( #"set_streamer_hint" );
    self waittillmatch( #"streamer", n_zone );
    self notify( "streamer" + n_zone );
}

// Namespace util
// Params 2
// Checksum 0x39c5a6c9, Offset: 0x43f0
// Size: 0x15e
function teleport_players_igc( str_spots, coop_sort )
{
    if ( level.players.size <= 1 )
    {
        return;
    }
    
    a_spots = skipto::get_spots( str_spots, coop_sort );
    assert( a_spots.size >= level.players.size - 1, "<dev string:x1b7>" );
    
    for ( i = 0; i < level.players.size - 1 ; i++ )
    {
        level.players[ i + 1 ] setorigin( a_spots[ i ].origin );
        
        if ( isdefined( a_spots[ i ].angles ) )
        {
            level.players[ i + 1 ] delay_network_frames( 2, "disconnect", &setplayerangles, a_spots[ i ].angles );
        }
    }
}

// Namespace util
// Params 1
// Checksum 0x25258fbc, Offset: 0x4558
// Size: 0xf4
function set_low_ready( b_lowready )
{
    self setlowready( b_lowready );
    self setclientuivisibilityflag( "weapon_hud_visible", !b_lowready );
    self allowjump( !b_lowready );
    self allowsprint( !b_lowready );
    self allowdoublejump( !b_lowready );
    
    if ( b_lowready )
    {
        self disableoffhandweapons();
    }
    else
    {
        self enableoffhandweapons();
    }
    
    oed::enable_ev( !b_lowready );
    oed::enable_tac_mode( !b_lowready );
}

// Namespace util
// Params 0
// Checksum 0x93e62525, Offset: 0x4658
// Size: 0xaa
function cleanupactorcorpses()
{
    foreach ( corpse in getcorpsearray() )
    {
        if ( isactorcorpse( corpse ) )
        {
            corpse delete();
        }
    }
}

// Namespace util
// Params 1
// Checksum 0x476200ea, Offset: 0x4710
// Size: 0x4c
function set_level_start_flag( str_flag )
{
    level.str_level_start_flag = str_flag;
    
    if ( !flag::exists( str_flag ) )
    {
        level flag::init( level.str_level_start_flag );
    }
}

// Namespace util
// Params 1
// Checksum 0xfff86bed, Offset: 0x4768
// Size: 0x18
function set_player_start_flag( str_flag )
{
    level.str_player_start_flag = str_flag;
}

// Namespace util
// Params 1
// Checksum 0x4b7047f, Offset: 0x4788
// Size: 0xbe
function set_rogue_controlled( b_state )
{
    if ( !isdefined( b_state ) )
    {
        b_state = 1;
    }
    
    if ( b_state )
    {
        self cybercom::cybercom_aioptout( "cybercom_hijack" );
        self cybercom::cybercom_aioptout( "cybercom_iffoverride" );
        self.rogue_controlled = 1;
        return;
    }
    
    self cybercom::cybercom_aiclearoptout( "cybercom_hijack" );
    self cybercom::cybercom_aiclearoptout( "cybercom_iffoverride" );
    self.rogue_controlled = undefined;
}

// Namespace util
// Params 0
// Checksum 0x61ad5fc3, Offset: 0x4850
// Size: 0x64
function init_breath_fx()
{
    clientfield::register( "toplayer", "player_cold_breath", 1, 1, "int" );
    clientfield::register( "actor", "ai_cold_breath", 1, 1, "counter" );
}

// Namespace util
// Params 1
// Checksum 0xc90ea492, Offset: 0x48c0
// Size: 0x2c
function player_frost_breath( b_true )
{
    self clientfield::set_to_player( "player_cold_breath", b_true );
}

// Namespace util
// Params 0
// Checksum 0x30e700b1, Offset: 0x48f8
// Size: 0x5c
function ai_frost_breath()
{
    self endon( #"death" );
    
    if ( self.archetype === "human" )
    {
        wait randomfloatrange( 1, 3 );
        self clientfield::increment( "ai_cold_breath" );
    }
}

// Namespace util
// Params 4
// Checksum 0xd21c31, Offset: 0x4960
// Size: 0x184
function show_hint_text( str_text_to_show, b_should_blink, str_turn_off_notify, n_display_time )
{
    if ( !isdefined( b_should_blink ) )
    {
        b_should_blink = 0;
    }
    
    if ( !isdefined( str_turn_off_notify ) )
    {
        str_turn_off_notify = "notify_turn_off_hint_text";
    }
    
    if ( !isdefined( n_display_time ) )
    {
        n_display_time = 4;
    }
    
    self endon( #"notify_turn_off_hint_text" );
    self endon( #"hint_text_removed" );
    
    if ( isdefined( self.hint_menu_handle ) )
    {
        hide_hint_text( 0 );
    }
    
    self.hint_menu_handle = self openluimenu( "CPHintText" );
    self setluimenudata( self.hint_menu_handle, "hint_text_line", str_text_to_show );
    
    if ( b_should_blink )
    {
        lui::play_animation( self.hint_menu_handle, "blinking" );
    }
    else
    {
        lui::play_animation( self.hint_menu_handle, "display_noblink" );
    }
    
    if ( n_display_time != -1 )
    {
        self thread hide_hint_text_listener( n_display_time );
        self thread fade_hint_text_after_time( n_display_time, str_turn_off_notify );
    }
}

// Namespace util
// Params 1
// Checksum 0x90828d8f, Offset: 0x4af0
// Size: 0xc2
function hide_hint_text( b_fade_before_hiding )
{
    if ( !isdefined( b_fade_before_hiding ) )
    {
        b_fade_before_hiding = 1;
    }
    
    self endon( #"hint_text_removed" );
    
    if ( isdefined( self.hint_menu_handle ) )
    {
        if ( b_fade_before_hiding )
        {
            lui::play_animation( self.hint_menu_handle, "fadeout" );
            waittill_any_timeout( 0.75, "kill_hint_text", "death" );
        }
        
        self closeluimenu( self.hint_menu_handle );
        self.hint_menu_handle = undefined;
    }
    
    self notify( #"hint_text_removed" );
}

// Namespace util
// Params 2
// Checksum 0xd3da1a80, Offset: 0x4bc0
// Size: 0x74
function fade_hint_text_after_time( n_display_time, str_turn_off_notify )
{
    self endon( #"hint_text_removed" );
    self endon( #"death" );
    self endon( #"kill_hint_text" );
    waittill_any_timeout( n_display_time - 0.75, str_turn_off_notify );
    hide_hint_text( 1 );
}

// Namespace util
// Params 1
// Checksum 0x848b276d, Offset: 0x4c40
// Size: 0x5c
function hide_hint_text_listener( n_time )
{
    self endon( #"hint_text_removed" );
    self endon( #"disconnect" );
    waittill_any_timeout( n_time, "kill_hint_text", "death" );
    hide_hint_text( 0 );
}

// Namespace util
// Params 2
// Checksum 0x34ef5289, Offset: 0x4ca8
// Size: 0x3c
function show_event_message( player_handle, str_message )
{
    player_handle luinotifyevent( &"comms_event_message", 1, str_message );
}

// Namespace util
// Params 5
// Checksum 0xc7b9ede3, Offset: 0x4cf0
// Size: 0x264
function init_interactive_gameobject( trigger, str_objective, str_hint_text, func_on_use, a_keyline_objects )
{
    trigger sethintstring( str_hint_text );
    trigger setcursorhint( "HINT_INTERACTIVE_PROMPT" );
    
    if ( !isdefined( a_keyline_objects ) )
    {
        a_keyline_objects = [];
    }
    else
    {
        if ( !isdefined( a_keyline_objects ) )
        {
            a_keyline_objects = [];
        }
        else if ( !isarray( a_keyline_objects ) )
        {
            a_keyline_objects = array( a_keyline_objects );
        }
        
        foreach ( mdl in a_keyline_objects )
        {
            mdl oed::enable_keyline( 1 );
        }
    }
    
    game_object = gameobjects::create_use_object( "any", trigger, a_keyline_objects, ( 0, 0, 0 ), str_objective );
    game_object gameobjects::allow_use( "any" );
    game_object gameobjects::set_use_time( 0.35 );
    game_object gameobjects::set_owner_team( "allies" );
    game_object gameobjects::set_visible_team( "any" );
    game_object.single_use = 0;
    game_object.origin = game_object.origin;
    game_object.angles = game_object.angles;
    
    if ( isdefined( func_on_use ) )
    {
        game_object.onuse = func_on_use;
    }
    
    return game_object;
}

