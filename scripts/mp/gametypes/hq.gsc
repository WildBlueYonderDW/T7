#using scripts/mp/_challenges;
#using scripts/mp/_util;
#using scripts/mp/gametypes/_battlechatter;
#using scripts/mp/gametypes/_globallogic;
#using scripts/mp/gametypes/_globallogic_audio;
#using scripts/mp/gametypes/_globallogic_score;
#using scripts/mp/gametypes/_globallogic_utils;
#using scripts/mp/gametypes/_spawning;
#using scripts/mp/gametypes/_spawnlogic;
#using scripts/mp/killstreaks/_rcbomb;
#using scripts/mp/killstreaks/_supplydrop;
#using scripts/shared/callbacks_shared;
#using scripts/shared/challenges_shared;
#using scripts/shared/demo_shared;
#using scripts/shared/gameobjects_shared;
#using scripts/shared/hud_util_shared;
#using scripts/shared/math_shared;
#using scripts/shared/medals_shared;
#using scripts/shared/popups_shared;
#using scripts/shared/scoreevents_shared;
#using scripts/shared/sound_shared;
#using scripts/shared/util_shared;
#using scripts/shared/weapons/_weapons;

#namespace hq;

// Namespace hq
// Params 0
// Checksum 0xe9c6511d, Offset: 0x8c8
// Size: 0x3ec
function main()
{
    globallogic::init();
    util::registertimelimit( 0, 1440 );
    util::registerscorelimit( 0, 1000 );
    util::registernumlives( 0, 100 );
    util::registerroundswitch( 0, 9 );
    util::registerroundwinlimit( 0, 10 );
    globallogic::registerfriendlyfiredelay( level.gametype, 15, 0, 1440 );
    level.teambased = 1;
    level.doprematch = 1;
    level.overrideteamscore = 1;
    level.scoreroundwinbased = 1;
    level.onstartgametype = &onstartgametype;
    level.playerspawnedcb = &koth_playerspawnedcb;
    level.onroundswitch = &onroundswitch;
    level.onplayerkilled = &onplayerkilled;
    level.onendgame = &onendgame;
    level.hqautodestroytime = getgametypesetting( "autoDestroyTime" );
    level.hqspawntime = getgametypesetting( "objectiveSpawnTime" );
    level.kothmode = getgametypesetting( "kothMode" );
    level.capturetime = getgametypesetting( "captureTime" );
    level.destroytime = getgametypesetting( "destroyTime" );
    level.delayplayer = getgametypesetting( "delayPlayer" );
    level.randomhqspawn = getgametypesetting( "randomObjectiveLocations" );
    level.maxrespawndelay = getgametypesetting( "timeLimit" ) * 60;
    level.iconoffset = ( 0, 0, 32 );
    level.onrespawndelay = &getrespawndelay;
    gameobjects::register_allowed_gameobject( level.gametype );
    game[ "dialog" ][ "gametype" ] = "hq_start";
    game[ "dialog" ][ "gametype_hardcore" ] = "hchq_start";
    game[ "dialog" ][ "offense_obj" ] = "cap_start";
    game[ "dialog" ][ "defense_obj" ] = "cap_start";
    level.lastdialogtime = 0;
    level.radiospawnqueue = [];
    
    if ( !sessionmodeissystemlink() && !sessionmodeisonlinegame() && issplitscreen() )
    {
        globallogic::setvisiblescoreboardcolumns( "score", "kills", "captures", "defends", "deaths" );
        return;
    }
    
    globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "captures", "defends" );
}

// Namespace hq
// Params 3
// Checksum 0x85ae1a50, Offset: 0xcc0
// Size: 0xdc
function updateobjectivehintmessages( defenderteam, defendmessage, attackmessage )
{
    foreach ( team in level.teams )
    {
        if ( defenderteam == team )
        {
            game[ "strings" ][ "objective_hint_" + team ] = defendmessage;
            continue;
        }
        
        game[ "strings" ][ "objective_hint_" + team ] = attackmessage;
    }
}

// Namespace hq
// Params 1
// Checksum 0xd3b471cb, Offset: 0xda8
// Size: 0x9c
function updateobjectivehintmessage( message )
{
    foreach ( team in level.teams )
    {
        game[ "strings" ][ "objective_hint_" + team ] = message;
    }
}

// Namespace hq
// Params 0
// Checksum 0x3f98d34f, Offset: 0xe50
// Size: 0x124
function getrespawndelay()
{
    self.lowermessageoverride = undefined;
    
    if ( !isdefined( level.radio.gameobject ) )
    {
        return undefined;
    }
    
    hqowningteam = level.radio.gameobject gameobjects::get_owner_team();
    
    if ( self.pers[ "team" ] == hqowningteam )
    {
        if ( !isdefined( level.hqdestroytime ) )
        {
            timeremaining = level.maxrespawndelay;
        }
        else
        {
            timeremaining = ( level.hqdestroytime - gettime() ) / 1000;
        }
        
        if ( !level.playerobjectiveheldrespawndelay )
        {
            return undefined;
        }
        
        if ( level.playerobjectiveheldrespawndelay >= level.hqautodestroytime )
        {
            self.lowermessageoverride = &"MP_WAITING_FOR_HQ";
        }
        
        if ( level.delayplayer )
        {
            return min( level.spawndelay, timeremaining );
        }
        
        return ceil( timeremaining );
    }
}

// Namespace hq
// Params 0
// Checksum 0xbfedda14, Offset: 0xf80
// Size: 0x4c4
function onstartgametype()
{
    if ( !isdefined( game[ "switchedsides" ] ) )
    {
        game[ "switchedsides" ] = 0;
    }
    
    if ( game[ "switchedsides" ] )
    {
        oldattackers = game[ "attackers" ];
        olddefenders = game[ "defenders" ];
        game[ "attackers" ] = olddefenders;
        game[ "defenders" ] = oldattackers;
    }
    
    globallogic_score::resetteamscores();
    
    foreach ( team in level.teams )
    {
        util::setobjectivetext( team, &"OBJECTIVES_KOTH" );
        
        if ( level.splitscreen )
        {
            util::setobjectivescoretext( team, &"OBJECTIVES_HQ" );
            continue;
        }
        
        util::setobjectivescoretext( team, &"OBJECTIVES_HQ_SCORE" );
    }
    
    level.objectivehintpreparehq = &"MP_CONTROL_HQ";
    level.objectivehintcapturehq = &"MP_CAPTURE_HQ";
    level.objectivehintdestroyhq = &"MP_DESTROY_HQ";
    level.objectivehintdefendhq = &"MP_DEFEND_HQ";
    
    if ( level.kothmode )
    {
        level.objectivehintdestroyhq = level.objectivehintcapturehq;
    }
    
    if ( level.hqspawntime )
    {
        updateobjectivehintmessage( level.objectivehintpreparehq );
    }
    else
    {
        updateobjectivehintmessage( level.objectivehintcapturehq );
    }
    
    setclientnamemode( "auto_change" );
    spawning::create_map_placed_influencers();
    level.spawnmins = ( 0, 0, 0 );
    level.spawnmaxs = ( 0, 0, 0 );
    
    foreach ( team in level.teams )
    {
        spawnlogic::add_spawn_points( team, "mp_tdm_spawn" );
        spawnlogic::place_spawn_points( spawning::gettdmstartspawnname( team ) );
    }
    
    spawning::updateallspawnpoints();
    level.spawn_start = [];
    
    foreach ( team in level.teams )
    {
        level.spawn_start[ team ] = spawnlogic::get_spawnpoint_array( spawning::gettdmstartspawnname( team ) );
    }
    
    level.mapcenter = math::find_box_center( level.spawnmins, level.spawnmaxs );
    setmapcenter( level.mapcenter );
    spawnpoint = spawnlogic::get_random_intermission_point();
    setdemointermissionpoint( spawnpoint.origin, spawnpoint.angles );
    level.spawn_all = spawnlogic::get_spawnpoint_array( "mp_tdm_spawn" );
    
    if ( !level.spawn_all.size )
    {
        println( "<dev string:x28>" );
        callback::abort_level();
        return;
    }
    
    thread setupradios();
    thread hqmainloop();
}

// Namespace hq
// Params 1
// Checksum 0xae82881e, Offset: 0x1450
// Size: 0xf4
function spawn_first_radio( delay )
{
    if ( level.randomhqspawn == 1 )
    {
        level.radio = getnextradiofromqueue();
    }
    else
    {
        level.radio = getfirstradio();
    }
    
    /#
        print( "<dev string:x50>" + level.radio.trigorigin[ 0 ] + "<dev string:x61>" + level.radio.trigorigin[ 1 ] + "<dev string:x61>" + level.radio.trigorigin[ 2 ] + "<dev string:x63>" );
    #/
    
    level.radio spawning::enable_influencers( 1 );
}

// Namespace hq
// Params 0
// Checksum 0xe7f8a684, Offset: 0x1550
// Size: 0xec
function spawn_next_radio()
{
    if ( level.randomhqspawn != 0 )
    {
        level.radio = getnextradiofromqueue();
    }
    else
    {
        level.radio = getnextradio();
    }
    
    /#
        print( "<dev string:x50>" + level.radio.trigorigin[ 0 ] + "<dev string:x61>" + level.radio.trigorigin[ 1 ] + "<dev string:x61>" + level.radio.trigorigin[ 2 ] + "<dev string:x63>" );
    #/
    
    level.radio spawning::enable_influencers( 1 );
}

// Namespace hq
// Params 0
// Checksum 0x659ed1e5, Offset: 0x1648
// Size: 0xc78
function hqmainloop()
{
    level endon( #"game_ended" );
    level.hqrevealtime = -100000;
    hqspawninginstr = &"MP_HQ_AVAILABLE_IN";
    
    if ( level.kothmode )
    {
        hqdestroyedinfriendlystr = &"MP_HQ_DESPAWN_IN";
        hqdestroyedinenemystr = &"MP_HQ_DESPAWN_IN";
    }
    else
    {
        hqdestroyedinfriendlystr = &"MP_HQ_REINFORCEMENTS_IN";
        hqdestroyedinenemystr = &"MP_HQ_DESPAWN_IN";
    }
    
    spawn_first_radio();
    objective_name = istring( "objective" );
    
    while ( level.inprematchperiod )
    {
        wait 0.05;
    }
    
    wait 5;
    timerdisplay = [];
    
    foreach ( team in level.teams )
    {
        timerdisplay[ team ] = hud::createservertimer( "objective", 1.4, team );
        timerdisplay[ team ] hud::setgamemodeinfopoint();
        timerdisplay[ team ].label = hqspawninginstr;
        timerdisplay[ team ].font = "small";
        timerdisplay[ team ].alpha = 0;
        timerdisplay[ team ].archived = 0;
        timerdisplay[ team ].hidewheninmenu = 1;
        timerdisplay[ team ].hidewheninkillcam = 1;
        timerdisplay[ team ].showplayerteamhudelemtospectator = 1;
        thread hidetimerdisplayongameend( timerdisplay[ team ] );
    }
    
    while ( true )
    {
        iprintln( &"MP_HQ_REVEALED" );
        sound::play_on_players( "mp_suitcase_pickup" );
        globallogic_audio::leader_dialog( "hq_located" );
        level.radio.gameobject gameobjects::set_model_visibility( 1 );
        level.hqrevealtime = gettime();
        rcbombs = getentarray( "rcbomb", "targetname" );
        radius = 75;
        
        for ( index = 0; index < rcbombs.size ; index++ )
        {
            if ( distancesquared( rcbombs[ index ], level.radio.origin ) < radius * radius )
            {
                rcbombs[ index ] notify( #"rcbomb_shutdown" );
            }
        }
        
        if ( level.hqspawntime )
        {
            level.radio.gameobject gameobjects::set_visible_team( "any" );
            level.radio.gameobject gameobjects::set_flags( 1 );
            updateobjectivehintmessage( level.objectivehintpreparehq );
            
            foreach ( team in level.teams )
            {
                timerdisplay[ team ].label = hqspawninginstr;
                timerdisplay[ team ] settimer( level.hqspawntime );
                timerdisplay[ team ].alpha = 1;
            }
            
            wait level.hqspawntime;
            level.radio.gameobject gameobjects::set_flags( 0 );
            globallogic_audio::leader_dialog( "hq_online" );
        }
        
        foreach ( team in level.teams )
        {
            timerdisplay[ team ].alpha = 0;
        }
        
        waittillframeend();
        globallogic_audio::leader_dialog( "obj_capture" );
        updateobjectivehintmessage( level.objectivehintcapturehq );
        sound::play_on_players( "mpl_hq_cap_us" );
        level.radio.gameobject gameobjects::enable_object();
        level.radio.gameobject.onupdateuserate = &onupdateuserate;
        level.radio.gameobject gameobjects::allow_use( "any" );
        level.radio.gameobject gameobjects::set_use_time( level.capturetime );
        level.radio.gameobject gameobjects::set_use_text( &"MP_CAPTURING_HQ" );
        level.radio.gameobject gameobjects::set_visible_team( "any" );
        level.radio.gameobject gameobjects::set_model_visibility( 1 );
        level.radio.gameobject.onuse = &onradiocapture;
        level.radio.gameobject.onbeginuse = &onbeginuse;
        level.radio.gameobject.onenduse = &onenduse;
        level waittill( #"hq_captured" );
        ownerteam = level.radio.gameobject gameobjects::get_owner_team();
        
        if ( level.hqautodestroytime )
        {
            thread destroyhqaftertime( level.hqautodestroytime, ownerteam );
            
            foreach ( team in level.teams )
            {
                timerdisplay[ team ] settimer( level.hqautodestroytime );
            }
        }
        else
        {
            level.hqdestroyedbytimer = 0;
        }
        
        while ( true )
        {
            ownerteam = level.radio.gameobject gameobjects::get_owner_team();
            
            foreach ( team in level.teams )
            {
                updateobjectivehintmessages( ownerteam, level.objectivehintdefendhq, level.objectivehintdestroyhq );
            }
            
            level.radio.gameobject gameobjects::allow_use( "enemy" );
            
            if ( !level.kothmode )
            {
                level.radio.gameobject gameobjects::set_use_text( &"MP_DESTROYING_HQ" );
            }
            
            level.radio.gameobject.onuse = &onradiodestroy;
            
            if ( level.hqautodestroytime )
            {
                foreach ( team in level.teams )
                {
                    if ( team == ownerteam )
                    {
                        timerdisplay[ team ].label = hqdestroyedinfriendlystr;
                    }
                    else
                    {
                        timerdisplay[ team ].label = hqdestroyedinenemystr;
                    }
                    
                    timerdisplay[ team ].alpha = 1;
                }
            }
            
            level thread dropallaroundhq();
            level waittill( #"hq_destroyed", destroy_team );
            level.radio spawning::enable_influencers( 0 );
            
            if ( !level.kothmode || level.hqdestroyedbytimer )
            {
                break;
            }
            
            thread forcespawnteam( ownerteam );
            
            if ( isdefined( destroy_team ) )
            {
                level.radio.gameobject gameobjects::set_owner_team( destroy_team );
            }
        }
        
        level.radio.gameobject gameobjects::disable_object();
        level.radio.gameobject gameobjects::allow_use( "none" );
        level.radio.gameobject gameobjects::set_owner_team( "neutral" );
        level.radio.gameobject gameobjects::set_model_visibility( 0 );
        level notify( #"hq_reset" );
        
        foreach ( team in level.teams )
        {
            timerdisplay[ team ].alpha = 0;
        }
        
        spawn_next_radio();
        wait 0.05;
        thread forcespawnteam( ownerteam );
        wait 3;
    }
}

// Namespace hq
// Params 1
// Checksum 0x3b17ea2e, Offset: 0x22c8
// Size: 0x28
function hidetimerdisplayongameend( timerdisplay )
{
    level waittill( #"game_ended" );
    timerdisplay.alpha = 0;
}

// Namespace hq
// Params 1
// Checksum 0xafa69286, Offset: 0x22f8
// Size: 0xa6
function forcespawnteam( team )
{
    players = level.players;
    
    for ( i = 0; i < players.size ; i++ )
    {
        player = players[ i ];
        
        if ( !isdefined( player ) )
        {
            continue;
        }
        
        if ( player.pers[ "team" ] == team )
        {
            player notify( #"force_spawn" );
            wait 0.1;
        }
    }
}

// Namespace hq
// Params 1
// Checksum 0x2730f0d1, Offset: 0x23a8
// Size: 0xac
function onbeginuse( player )
{
    ownerteam = self gameobjects::get_owner_team();
    
    if ( ownerteam == "neutral" )
    {
        player thread battlechatter::gametype_specific_battle_chatter( "hq_protect", player.pers[ "team" ] );
        return;
    }
    
    player thread battlechatter::gametype_specific_battle_chatter( "hq_attack", player.pers[ "team" ] );
}

// Namespace hq
// Params 3
// Checksum 0x7b2d2017, Offset: 0x2460
// Size: 0x2c
function onenduse( team, player, success )
{
    player notify( #"event_ended" );
}

// Namespace hq
// Params 1
// Checksum 0xb2e8b4e, Offset: 0x2498
// Size: 0x268
function onradiocapture( player )
{
    capture_team = player.pers[ "team" ];
    
    /#
        print( "<dev string:x65>" );
    #/
    
    string = &"MP_HQ_CAPTURED_BY";
    level.usestartspawns = 0;
    thread give_capture_credit( self.touchlist[ capture_team ], string );
    oldteam = gameobjects::get_owner_team();
    self gameobjects::set_owner_team( capture_team );
    
    if ( !level.kothmode )
    {
        self gameobjects::set_use_time( level.destroytime );
    }
    
    foreach ( team in level.teams )
    {
        if ( team == capture_team )
        {
            thread util::printonteamarg( &"MP_HQ_CAPTURED_BY", team, player );
            globallogic_audio::leader_dialog( "hq_secured", team );
            thread sound::play_on_players( "mp_war_objective_taken", team );
            continue;
        }
        
        thread util::printonteam( &"MP_HQ_CAPTURED_BY_ENEMY", team );
        globallogic_audio::leader_dialog( "hq_enemy_captured", team );
        thread sound::play_on_players( "mp_war_objective_lost", team );
    }
    
    level thread awardhqpoints( capture_team );
    level notify( #"hq_captured" );
    player notify( #"event_ended" );
}

// Namespace hq
// Params 2
// Checksum 0xeac50805, Offset: 0x2708
// Size: 0x1c6
function give_capture_credit( touchlist, string )
{
    time = gettime();
    wait 0.05;
    util::waittillslowprocessallowed();
    players = getarraykeys( touchlist );
    
    for ( i = 0; i < players.size ; i++ )
    {
        player_from_touchlist = touchlist[ players[ i ] ].player;
        player_from_touchlist challenges::capturedobjective( time, self );
        scoreevents::processscoreevent( "hq_secure", player_from_touchlist );
        player_from_touchlist recordgameevent( "capture" );
        level thread popups::displayteammessagetoall( string, player_from_touchlist );
        
        if ( isdefined( player_from_touchlist.pers[ "captures" ] ) )
        {
            player_from_touchlist.pers[ "captures" ]++;
            player_from_touchlist.captures = player_from_touchlist.pers[ "captures" ];
        }
        
        demo::bookmark( "event", gettime(), player_from_touchlist );
        player_from_touchlist addplayerstatwithgametype( "CAPTURES", 1 );
    }
}

// Namespace hq
// Params 3
// Checksum 0x572f48d2, Offset: 0x28d8
// Size: 0x8a
function dropalltoground( origin, radius, stickyobjectradius )
{
    physicsexplosionsphere( origin, radius, radius, 0 );
    wait 0.05;
    weapons::drop_all_to_ground( origin, radius );
    supplydrop::dropcratestoground( origin, radius );
    level notify( #"drop_objects_to_ground", origin, stickyobjectradius );
}

// Namespace hq
// Params 1
// Checksum 0x9d896af9, Offset: 0x2970
// Size: 0x54
function dropallaroundhq( radio )
{
    origin = level.radio.origin;
    level waittill( #"hq_reset" );
    dropalltoground( origin, 100, 50 );
}

// Namespace hq
// Params 1
// Checksum 0xfa3b4e3, Offset: 0x29d0
// Size: 0x37c
function onradiodestroy( firstplayer )
{
    destroyed_team = firstplayer.pers[ "team" ];
    touchlist = self.touchlist[ destroyed_team ];
    touchlistkeys = getarraykeys( touchlist );
    
    foreach ( index in touchlistkeys )
    {
        player = touchlist[ index ].player;
        
        /#
            print( "<dev string:x74>" );
        #/
        
        scoreevents::processscoreevent( "hq_destroyed", player );
        player recordgameevent( "destroy" );
        player addplayerstatwithgametype( "DESTRUCTIONS", 1 );
        
        if ( isdefined( player.pers[ "destructions" ] ) )
        {
            player.pers[ "destructions" ]++;
            player.destructions = player.pers[ "destructions" ];
        }
    }
    
    destroyteammessage = &"MP_HQ_DESTROYED_BY";
    otherteammessage = &"MP_HQ_DESTROYED_BY_ENEMY";
    
    if ( level.kothmode )
    {
        destroyteammessage = &"MP_HQ_CAPTURED_BY";
        otherteammessage = &"MP_HQ_CAPTURED_BY_ENEMY";
    }
    
    level thread popups::displayteammessagetoall( destroyteammessage, player );
    
    foreach ( team in level.teams )
    {
        if ( team == destroyed_team )
        {
            thread util::printonteamarg( destroyteammessage, team, player );
            globallogic_audio::leader_dialog( "hq_secured", team );
            continue;
        }
        
        thread util::printonteam( otherteammessage, team );
        globallogic_audio::leader_dialog( "hq_enemy_destroyed", team );
    }
    
    level notify( #"hq_destroyed", destroyed_team );
    
    if ( level.kothmode )
    {
        level thread awardhqpoints( destroyed_team );
    }
    
    player notify( #"event_ended" );
}

// Namespace hq
// Params 2
// Checksum 0x9769dab, Offset: 0x2d58
// Size: 0x9a
function destroyhqaftertime( time, ownerteam )
{
    level endon( #"game_ended" );
    level endon( #"hq_reset" );
    level.hqdestroytime = gettime() + time * 1000;
    level.hqdestroyedbytimer = 0;
    wait time;
    globallogic_audio::leader_dialog( "hq_offline" );
    level.hqdestroyedbytimer = 1;
    checkplayercount( ownerteam );
    level notify( #"hq_destroyed" );
}

// Namespace hq
// Params 1
// Checksum 0x369e59d2, Offset: 0x2e00
// Size: 0xdc
function checkplayercount( ownerteam )
{
    lastplayeralive = undefined;
    players = level.players;
    
    for ( i = 0; i < players.size ; i++ )
    {
        if ( players[ i ].team != ownerteam )
        {
            continue;
        }
        
        if ( isalive( players[ i ] ) )
        {
            if ( isdefined( lastplayeralive ) )
            {
                return;
            }
            
            lastplayeralive = players[ i ];
        }
    }
    
    if ( isdefined( lastplayeralive ) )
    {
        scoreevents::processscoreevent( "defend_hq_last_man_alive", lastplayeralive );
    }
}

// Namespace hq
// Params 1
// Checksum 0x2ab2cfb4, Offset: 0x2ee8
// Size: 0xe6
function awardhqpoints( team )
{
    level endon( #"game_ended" );
    level endon( #"hq_destroyed" );
    level notify( #"awardhqpointsrunning" );
    level endon( #"awardhqpointsrunning" );
    seconds = 5;
    
    while ( !level.gameended )
    {
        globallogic_score::giveteamscoreforobjective( team, seconds );
        
        for ( index = 0; index < level.players.size ; index++ )
        {
            player = level.players[ index ];
            
            if ( player.pers[ "team" ] == team )
            {
            }
        }
        
        wait seconds;
    }
}

// Namespace hq
// Params 0
// Checksum 0x7543901f, Offset: 0x2fd8
// Size: 0xe
function koth_playerspawnedcb()
{
    self.lowermessageoverride = undefined;
}

// Namespace hq
// Params 2
// Checksum 0x3ba938af, Offset: 0x2ff0
// Size: 0x10e, Type: bool
function compareradioindexes( radio_a, radio_b )
{
    script_index_a = radio_a.script_index;
    script_index_b = radio_b.script_index;
    
    if ( !isdefined( script_index_a ) && !isdefined( script_index_b ) )
    {
        return false;
    }
    
    if ( !isdefined( script_index_a ) && isdefined( script_index_b ) )
    {
        println( "<dev string:x84>" + radio_a.origin );
        return true;
    }
    
    if ( isdefined( script_index_a ) && !isdefined( script_index_b ) )
    {
        println( "<dev string:x84>" + radio_b.origin );
        return false;
    }
    
    if ( script_index_a > script_index_b )
    {
        return true;
    }
    
    return false;
}

// Namespace hq
// Params 0
// Checksum 0x49265be3, Offset: 0x3108
// Size: 0x132
function getradioarray()
{
    radios = getentarray( "hq_hardpoint", "targetname" );
    
    if ( !isdefined( radios ) )
    {
        return undefined;
    }
    
    swapped = 1;
    
    for ( n = radios.size; swapped ; n-- )
    {
        swapped = 0;
        
        for ( i = 0; i < n - 1 ; i++ )
        {
            if ( compareradioindexes( radios[ i ], radios[ i + 1 ] ) )
            {
                temp = radios[ i ];
                radios[ i ] = radios[ i + 1 ];
                radios[ i + 1 ] = temp;
                swapped = 1;
            }
        }
    }
    
    return radios;
}

// Namespace hq
// Params 0
// Checksum 0xbd3bf250, Offset: 0x3248
// Size: 0x492
function setupradios()
{
    maperrors = [];
    radios = getradioarray();
    
    if ( radios.size < 2 )
    {
        maperrors[ maperrors.size ] = "There are not at least 2 entities with targetname \"radio\"";
    }
    
    trigs = getentarray( "radiotrigger", "targetname" );
    
    for ( i = 0; i < radios.size ; i++ )
    {
        errored = 0;
        radio = radios[ i ];
        radio.trig = undefined;
        
        for ( j = 0; j < trigs.size ; j++ )
        {
            if ( radio istouching( trigs[ j ] ) )
            {
                if ( isdefined( radio.trig ) )
                {
                    maperrors[ maperrors.size ] = "Radio at " + radio.origin + " is touching more than one \"radiotrigger\" trigger";
                    errored = 1;
                    break;
                }
                
                radio.trig = trigs[ j ];
                break;
            }
        }
        
        if ( !isdefined( radio.trig ) )
        {
            if ( !errored )
            {
                maperrors[ maperrors.size ] = "Radio at " + radio.origin + " is not inside any \"radiotrigger\" trigger";
                continue;
            }
        }
        
        assert( !errored );
        radio.trigorigin = radio.trig.origin;
        visuals = [];
        visuals[ 0 ] = radio;
        othervisuals = getentarray( radio.target, "targetname" );
        
        for ( j = 0; j < othervisuals.size ; j++ )
        {
            visuals[ visuals.size ] = othervisuals[ j ];
        }
        
        objective_name = istring( "objective" );
        radio setupnodes();
        radio.gameobject = gameobjects::create_use_object( "neutral", radio.trig, visuals, radio.origin - radio.trigorigin, objective_name );
        radio.gameobject gameobjects::disable_object();
        radio.gameobject gameobjects::set_model_visibility( 0 );
        radio.trig.useobj = radio.gameobject;
        radio setupnearbyspawns();
        radio createradiospawninfluencer();
    }
    
    if ( maperrors.size > 0 )
    {
        /#
            println( "<dev string:xac>" );
            
            for ( i = 0; i < maperrors.size ; i++ )
            {
                println( maperrors[ i ] );
            }
            
            println( "<dev string:xd3>" );
            util::error( "<dev string:xfa>" );
        #/
        
        callback::abort_level();
        return;
    }
    
    level.radios = radios;
    level.prevradio = undefined;
    level.prevradio2 = undefined;
    return 1;
}

// Namespace hq
// Params 0
// Checksum 0x45ca9d27, Offset: 0x36e8
// Size: 0x2a4
function setupnearbyspawns()
{
    spawns = level.spawn_all;
    
    for ( i = 0; i < spawns.size ; i++ )
    {
        spawns[ i ].distsq = distancesquared( spawns[ i ].origin, self.origin );
    }
    
    for ( i = 1; i < spawns.size ; i++ )
    {
        thespawn = spawns[ i ];
        
        for ( j = i - 1; j >= 0 && thespawn.distsq < spawns[ j ].distsq ; j-- )
        {
            spawns[ j + 1 ] = spawns[ j ];
        }
        
        spawns[ j + 1 ] = thespawn;
    }
    
    first = [];
    second = [];
    var_d9ac65f8 = [];
    outer = [];
    thirdsize = spawns.size / 3;
    
    for ( i = 0; i <= thirdsize ; i++ )
    {
        first[ first.size ] = spawns[ i ];
    }
    
    while ( i < spawns.size )
    {
        outer[ outer.size ] = spawns[ i ];
        
        if ( i <= thirdsize * 2 )
        {
            second[ second.size ] = spawns[ i ];
        }
        else
        {
            var_d9ac65f8[ var_d9ac65f8.size ] = spawns[ i ];
        }
        
        i++;
    }
    
    self.gameobject.nearspawns = first;
    self.gameobject.midspawns = second;
    self.gameobject.farspawns = var_d9ac65f8;
    self.gameobject.outerspawns = outer;
}

// Namespace hq
// Params 0
// Checksum 0xae40abc4, Offset: 0x3998
// Size: 0x1c4
function setupnodes()
{
    self.points = [];
    temp = spawn( "script_model", ( 0, 0, 0 ) );
    maxs = self.trig getpointinbounds( 1, 1, 1 );
    self.node_radius = distance( self.trig.origin, maxs );
    points = util::positionquery_pointarray( self.trig.origin, 0, self.node_radius, 70, 128 );
    
    foreach ( point in points )
    {
        temp.origin = point;
        
        if ( temp istouching( self.trig ) )
        {
            self.points[ self.points.size ] = point;
        }
    }
    
    assert( self.points.size );
    temp delete();
}

// Namespace hq
// Params 0
// Checksum 0xe0a66b2d, Offset: 0x3b68
// Size: 0x80
function getfirstradio()
{
    radio = level.radios[ 0 ];
    level.prevradio2 = level.prevradio;
    level.prevradio = radio;
    level.prevradioindex = 0;
    shuffleradios();
    arrayremovevalue( level.radiospawnqueue, radio );
    return radio;
}

// Namespace hq
// Params 0
// Checksum 0x8a5cbe28, Offset: 0x3bf0
// Size: 0x70
function getnextradio()
{
    nextradioindex = ( level.prevradioindex + 1 ) % level.radios.size;
    radio = level.radios[ nextradioindex ];
    level.prevradio2 = level.prevradio;
    level.prevradio = radio;
    level.prevradioindex = nextradioindex;
    return radio;
}

// Namespace hq
// Params 0
// Checksum 0xd30d966e, Offset: 0x3c68
// Size: 0x6c
function pickrandomradiotospawn()
{
    level.prevradioindex = randomint( level.radios.size );
    radio = level.radios[ level.prevradioindex ];
    level.prevradio2 = level.prevradio;
    level.prevradio = radio;
    return radio;
}

// Namespace hq
// Params 0
// Checksum 0xa2625c11, Offset: 0x3ce0
// Size: 0x146
function shuffleradios()
{
    level.radiospawnqueue = [];
    spawnqueue = arraycopy( level.radios );
    
    for ( total_left = spawnqueue.size; total_left > 0 ; total_left-- )
    {
        index = randomint( total_left );
        valid_radios = 0;
        
        for ( radio = 0; radio < level.radios.size ; radio++ )
        {
            if ( !isdefined( spawnqueue[ radio ] ) )
            {
                continue;
            }
            
            if ( valid_radios == index )
            {
                if ( level.radiospawnqueue.size == 0 && isdefined( level.radio ) && level.radio == spawnqueue[ radio ] )
                {
                    continue;
                }
                
                level.radiospawnqueue[ level.radiospawnqueue.size ] = spawnqueue[ radio ];
                spawnqueue[ radio ] = undefined;
                break;
            }
            
            valid_radios++;
        }
    }
}

// Namespace hq
// Params 0
// Checksum 0x78f9f265, Offset: 0x3e30
// Size: 0x88
function getnextradiofromqueue()
{
    if ( level.radiospawnqueue.size == 0 )
    {
        shuffleradios();
    }
    
    assert( level.radiospawnqueue.size > 0 );
    next_radio = level.radiospawnqueue[ 0 ];
    arrayremoveindex( level.radiospawnqueue, 0 );
    return next_radio;
}

// Namespace hq
// Params 1
// Checksum 0x4a3b6322, Offset: 0x3ec0
// Size: 0xa8
function getcountofteamswithplayers( num )
{
    has_players = 0;
    
    foreach ( team in level.teams )
    {
        if ( num[ team ] > 0 )
        {
            has_players++;
        }
    }
    
    return has_players;
}

// Namespace hq
// Params 2
// Checksum 0x931d5089, Offset: 0x3f70
// Size: 0x19a
function getpointcost( avgpos, origin )
{
    avg_distance = 0;
    total_error = 0;
    distances = [];
    
    foreach ( team, position in avgpos )
    {
        distances[ team ] = distance( origin, avgpos[ team ] );
        avg_distance += distances[ team ];
    }
    
    avg_distance /= distances.size;
    
    foreach ( team, dist in distances )
    {
        err = distances[ team ] - avg_distance;
        total_error += err * err;
    }
    
    return total_error;
}

// Namespace hq
// Params 0
// Checksum 0xb30d7168, Offset: 0x4118
// Size: 0x43c
function pickradiotospawn()
{
    foreach ( team in level.teams )
    {
        avgpos[ team ] = ( 0, 0, 0 );
        num[ team ] = 0;
    }
    
    for ( i = 0; i < level.players.size ; i++ )
    {
        player = level.players[ i ];
        
        if ( isalive( player ) )
        {
            avgpos[ player.pers[ "team" ] ] = avgpos[ player.pers[ "team" ] ] + player.origin;
            num[ player.pers[ "team" ] ]++;
        }
    }
    
    if ( getcountofteamswithplayers( num ) <= 1 )
    {
        for ( radio = level.radios[ randomint( level.radios.size ) ]; isdefined( level.prevradio ) && radio == level.prevradio ; radio = level.radios[ randomint( level.radios.size ) ] )
        {
        }
        
        level.prevradio2 = level.prevradio;
        level.prevradio = radio;
        return radio;
    }
    
    foreach ( team in level.teams )
    {
        if ( num[ team ] == 0 )
        {
            avgpos[ team ] = undefined;
            continue;
        }
        
        avgpos[ team ] /= num[ team ];
    }
    
    bestradio = undefined;
    lowestcost = undefined;
    
    for ( i = 0; i < level.radios.size ; i++ )
    {
        radio = level.radios[ i ];
        cost = getpointcost( avgpos, radio.origin );
        
        if ( isdefined( level.prevradio ) && radio == level.prevradio )
        {
            continue;
        }
        
        if ( isdefined( level.prevradio2 ) && radio == level.prevradio2 )
        {
            if ( level.radios.size > 2 )
            {
                continue;
            }
            else
            {
                cost += 262144;
            }
        }
        
        if ( !isdefined( lowestcost ) || cost < lowestcost )
        {
            lowestcost = cost;
            bestradio = radio;
        }
    }
    
    assert( isdefined( bestradio ) );
    level.prevradio2 = level.prevradio;
    level.prevradio = bestradio;
    return bestradio;
}

// Namespace hq
// Params 0
// Checksum 0xbe96ae82, Offset: 0x4560
// Size: 0x1c
function onroundswitch()
{
    game[ "switchedsides" ] = !game[ "switchedsides" ];
}

// Namespace hq
// Params 9
// Checksum 0xe31a118f, Offset: 0x4588
// Size: 0x644
function onplayerkilled( einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration )
{
    if ( !self.touchtriggers.size && ( !isplayer( attacker ) || !attacker.touchtriggers.size ) || attacker.pers[ "team" ] == self.pers[ "team" ] )
    {
        return;
    }
    
    medalgiven = 0;
    scoreeventprocessed = 0;
    
    if ( attacker.touchtriggers.size )
    {
        triggerids = getarraykeys( attacker.touchtriggers );
        ownerteam = attacker.touchtriggers[ triggerids[ 0 ] ].useobj.ownerteam;
        team = attacker.pers[ "team" ];
        
        if ( team == ownerteam || ownerteam == "neutral" )
        {
            if ( !medalgiven )
            {
                if ( isdefined( attacker.pers[ "defends" ] ) )
                {
                    attacker.pers[ "defends" ]++;
                    attacker.defends = attacker.pers[ "defends" ];
                }
                
                attacker medals::defenseglobalcount();
                medalgiven = 1;
                attacker thread challenges::killedbasedefender( attacker.touchtriggers[ triggerids[ 0 ] ] );
                attacker recordgameevent( "return" );
            }
            
            attacker challenges::killedzoneattacker( weapon );
            
            if ( team != ownerteam )
            {
                scoreevents::processscoreevent( "kill_enemy_while_capping_hq", attacker, undefined, weapon );
            }
            else
            {
                scoreevents::processscoreevent( "killed_attacker", attacker, undefined, weapon );
            }
            
            self recordkillmodifier( "assaulting" );
            scoreeventprocessed = 1;
        }
        else
        {
            if ( !medalgiven )
            {
                attacker medals::offenseglobalcount();
                medalgiven = 1;
                attacker thread challenges::killedbaseoffender( attacker.touchtriggers[ triggerids[ 0 ] ], weapon );
            }
            
            scoreevents::processscoreevent( "kill_enemy_while_capping_hq", attacker, undefined, weapon );
            self recordkillmodifier( "defending" );
            scoreeventprocessed = 1;
        }
    }
    
    if ( self.touchtriggers.size )
    {
        triggerids = getarraykeys( self.touchtriggers );
        ownerteam = self.touchtriggers[ triggerids[ 0 ] ].useobj.ownerteam;
        team = self.pers[ "team" ];
        
        if ( team == ownerteam )
        {
            if ( !medalgiven )
            {
                attacker medals::offenseglobalcount();
                attacker thread challenges::killedbaseoffender( self.touchtriggers[ triggerids[ 0 ] ], weapon );
                medalgiven = 1;
            }
            
            if ( !scoreeventprocessed )
            {
                scoreevents::processscoreevent( "killed_defender", attacker, undefined, weapon );
                self recordkillmodifier( "defending" );
                scoreeventprocessed = 1;
            }
        }
        else
        {
            if ( !medalgiven )
            {
                if ( isdefined( attacker.pers[ "defends" ] ) )
                {
                    attacker.pers[ "defends" ]++;
                    attacker.defends = attacker.pers[ "defends" ];
                }
                
                attacker medals::defenseglobalcount();
                medalgiven = 1;
                attacker thread challenges::killedbasedefender( self.touchtriggers[ triggerids[ 0 ] ] );
                attacker recordgameevent( "return" );
            }
            
            if ( !scoreeventprocessed )
            {
                attacker challenges::killedzoneattacker( weapon );
                scoreevents::processscoreevent( "killed_attacker", attacker, undefined, weapon );
                self recordkillmodifier( "assaulting" );
                scoreeventprocessed = 1;
            }
        }
        
        if ( scoreeventprocessed == 1 )
        {
            attacker killwhilecontesting( self.touchtriggers[ triggerids[ 0 ] ].useobj );
        }
    }
}

// Namespace hq
// Params 1
// Checksum 0x70680f64, Offset: 0x4bd8
// Size: 0x168
function killwhilecontesting( radio )
{
    self notify( #"killwhilecontesting" );
    self endon( #"killwhilecontesting" );
    self endon( #"disconnect" );
    killtime = gettime();
    playerteam = self.pers[ "team" ];
    
    if ( !isdefined( self.clearenemycount ) )
    {
        self.clearenemycount = 0;
    }
    
    self.clearenemycount++;
    radio waittill( #"state_change" );
    
    if ( isdefined( self.spawntime ) && ( playerteam != self.pers[ "team" ] || killtime < self.spawntime ) )
    {
        self.clearenemycount = 0;
        return;
    }
    
    if ( radio.ownerteam != playerteam && radio.ownerteam != "neutral" )
    {
        self.clearenemycount = 0;
        return;
    }
    
    if ( self.clearenemycount >= 2 && killtime + 200 > gettime() )
    {
        scoreevents::processscoreevent( "clear_2_attackers", self );
    }
    
    self.clearenemycount = 0;
}

// Namespace hq
// Params 1
// Checksum 0x782e23a5, Offset: 0x4d48
// Size: 0x66
function onendgame( winningteam )
{
    for ( i = 0; i < level.radios.size ; i++ )
    {
        level.radios[ i ].gameobject gameobjects::allow_use( "none" );
    }
}

// Namespace hq
// Params 0
// Checksum 0x8b1c3f6c, Offset: 0x4db8
// Size: 0x7c
function createradiospawninfluencer()
{
    self spawning::create_influencer( "hq_large", self.gameobject.curorigin, 0 );
    self spawning::create_influencer( "hq_small", self.gameobject.curorigin, 0 );
    self spawning::enable_influencers( 0 );
}

// Namespace hq
// Params 0
// Checksum 0xe77a9500, Offset: 0x4e40
// Size: 0x14a
function onupdateuserate()
{
    if ( !isdefined( self.currentcontendercount ) )
    {
        self.currentcontendercount = 0;
    }
    
    numothers = gameobjects::get_num_touching_except_team( self.ownerteam );
    numowners = self.numtouching[ self.ownerteam ];
    previousstate = self.currentcontendercount;
    
    if ( numothers == 0 && numowners == 0 )
    {
        self.currentcontendercount = 0;
    }
    else if ( self.ownerteam == "neutral" )
    {
        numotherclaim = gameobjects::get_num_touching_except_team( self.claimteam );
        
        if ( numotherclaim > 0 )
        {
            self.currentcontendercount = 2;
        }
        else
        {
            self.currentcontendercount = 1;
        }
    }
    else if ( numothers > 0 )
    {
        self.currentcontendercount = 1;
    }
    else
    {
        self.currentcontendercount = 0;
    }
    
    if ( self.currentcontendercount != previousstate )
    {
        self notify( #"state_change" );
    }
}

