#using scripts/mp/_util;
#using scripts/mp/gametypes/_globallogic;
#using scripts/mp/gametypes/_globallogic_audio;
#using scripts/mp/gametypes/_globallogic_score;
#using scripts/mp/gametypes/_spawning;
#using scripts/mp/gametypes/_spawnlogic;
#using scripts/mp/killstreaks/_killstreaks;
#using scripts/shared/gameobjects_shared;
#using scripts/shared/math_shared;
#using scripts/shared/util_shared;

#namespace dm;

// Namespace dm
// Params 0
// Checksum 0xe488bce6, Offset: 0x300
// Size: 0x224
function main()
{
    globallogic::init();
    util::registertimelimit( 0, 1440 );
    util::registerscorelimit( 0, 50000 );
    util::registerroundlimit( 0, 10 );
    util::registerroundwinlimit( 0, 10 );
    util::registernumlives( 0, 100 );
    globallogic::registerfriendlyfiredelay( level.gametype, 0, 0, 1440 );
    level.scoreroundwinbased = getgametypesetting( "cumulativeRoundScores" ) == 0;
    level.teamscoreperkill = getgametypesetting( "teamScorePerKill" );
    level.teamscoreperdeath = getgametypesetting( "teamScorePerDeath" );
    level.teamscoreperheadshot = getgametypesetting( "teamScorePerHeadshot" );
    level.killstreaksgivegamescore = getgametypesetting( "killstreaksGiveGameScore" );
    level.onstartgametype = &onstartgametype;
    level.onplayerkilled = &onplayerkilled;
    level.onspawnplayer = &onspawnplayer;
    gameobjects::register_allowed_gameobject( level.gametype );
    globallogic_audio::set_leader_gametype_dialog( "startFreeForAll", "hcStartFreeForAll", "gameBoost", "gameBoost" );
    globallogic::setvisiblescoreboardcolumns( "pointstowin", "kills", "deaths", "kdratio", "score" );
}

// Namespace dm
// Params 1
// Checksum 0x3c3c8f71, Offset: 0x530
// Size: 0xec
function setupteam( team )
{
    util::setobjectivetext( team, &"OBJECTIVES_DM" );
    
    if ( level.splitscreen )
    {
        util::setobjectivescoretext( team, &"OBJECTIVES_DM" );
    }
    else
    {
        util::setobjectivescoretext( team, &"OBJECTIVES_DM_SCORE" );
    }
    
    util::setobjectivehinttext( team, &"OBJECTIVES_DM_HINT" );
    spawnlogic::add_spawn_points( team, "mp_dm_spawn" );
    spawnlogic::place_spawn_points( "mp_dm_spawn_start" );
    level.spawn_start = spawnlogic::get_spawnpoint_array( "mp_dm_spawn_start" );
}

// Namespace dm
// Params 0
// Checksum 0xa536d248, Offset: 0x628
// Size: 0x1a4
function onstartgametype()
{
    setclientnamemode( "auto_change" );
    spawning::create_map_placed_influencers();
    level.spawnmins = ( 0, 0, 0 );
    level.spawnmaxs = ( 0, 0, 0 );
    
    foreach ( team in level.teams )
    {
        setupteam( team );
    }
    
    spawning::updateallspawnpoints();
    level.mapcenter = math::find_box_center( level.spawnmins, level.spawnmaxs );
    setmapcenter( level.mapcenter );
    spawnpoint = spawnlogic::get_random_intermission_point();
    setdemointermissionpoint( spawnpoint.origin, spawnpoint.angles );
    level.displayroundendtext = 0;
    level thread onscoreclosemusic();
    
    if ( !util::isoneround() )
    {
        level.displayroundendtext = 1;
    }
}

// Namespace dm
// Params 1
// Checksum 0x9579e933, Offset: 0x7d8
// Size: 0x58
function onendgame( winningplayer )
{
    if ( isdefined( winningplayer ) && isplayer( winningplayer ) )
    {
        [[ level._setplayerscore ]]( winningplayer, winningplayer [[ level._getplayerscore ]]() + 1 );
    }
}

// Namespace dm
// Params 0
// Checksum 0xb41a34e5, Offset: 0x838
// Size: 0xb0
function onscoreclosemusic()
{
    while ( !level.gameended )
    {
        scorelimit = level.scorelimit;
        scorethreshold = scorelimit * 0.9;
        
        for ( i = 0; i < level.players.size ; i++ )
        {
            scorecheck = [[ level._getplayerscore ]]( level.players[ i ] );
            
            if ( scorecheck >= scorethreshold )
            {
                return;
            }
        }
        
        wait 0.5;
    }
}

// Namespace dm
// Params 1
// Checksum 0xcd63ba78, Offset: 0x8f0
// Size: 0x34
function onspawnplayer( predictedspawn )
{
    if ( !level.inprematchperiod )
    {
        level.usestartspawns = 0;
    }
    
    spawning::onspawnplayer( predictedspawn );
}

// Namespace dm
// Params 9
// Checksum 0x5e5eea6d, Offset: 0x930
// Size: 0x114
function onplayerkilled( einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration )
{
    if ( !isplayer( attacker ) || self == attacker )
    {
        return;
    }
    
    if ( isdefined( level.killstreaksgivegamescore ) && ( !isdefined( killstreaks::get_killstreak_for_weapon( weapon ) ) || level.killstreaksgivegamescore ) )
    {
        attacker globallogic_score::givepointstowin( level.teamscoreperkill );
        self globallogic_score::givepointstowin( level.teamscoreperdeath * -1 );
        
        if ( smeansofdeath == "MOD_HEAD_SHOT" )
        {
            attacker globallogic_score::givepointstowin( level.teamscoreperheadshot );
        }
    }
}

