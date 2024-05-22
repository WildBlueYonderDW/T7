#using scripts/cp/teams/_teams;
#using scripts/cp/_util;
#using scripts/cp/_rat;
#using scripts/cp/_load;
#using scripts/cp/_laststand;
#using scripts/cp/_gamerep;
#using scripts/cp/_gameadvertisement;
#using scripts/cp/_decoy;
#using scripts/cp/_challenges;
#using scripts/shared/_burnplayer;
#using scripts/cp/_bb;
#using scripts/cp/gametypes/_weapons;
#using scripts/cp/gametypes/_weapon_utils;
#using scripts/cp/gametypes/_wager;
#using scripts/cp/gametypes/_spectating;
#using scripts/cp/gametypes/_spawnlogic;
#using scripts/cp/gametypes/_shellshock;
#using scripts/cp/gametypes/_serversettings;
#using scripts/cp/gametypes/_scoreboard;
#using scripts/cp/gametypes/_save;
#using scripts/cp/gametypes/_menus;
#using scripts/cp/gametypes/_healthoverlay;
#using scripts/cp/gametypes/_globallogic_utils;
#using scripts/cp/gametypes/_globallogic_ui;
#using scripts/cp/gametypes/_globallogic_spawn;
#using scripts/cp/gametypes/_globallogic_score;
#using scripts/cp/gametypes/_globallogic_player;
#using scripts/cp/gametypes/_globallogic_defaults;
#using scripts/cp/gametypes/_friendicons;
#using scripts/cp/gametypes/_dev;
#using scripts/cp/gametypes/_deathicons;
#using scripts/cp/gametypes/_loadout;
#using scripts/cp/gametypes/_battlechatter;
#using scripts/shared/bb_shared;
#using scripts/shared/player_shared;
#using scripts/shared/lui_shared;
#using scripts/shared/weapons/_weapons;
#using scripts/shared/weapons_shared;
#using scripts/shared/tweakables_shared;
#using scripts/shared/simple_hostmigration;
#using scripts/shared/util_shared;
#using scripts/shared/persistence_shared;
#using scripts/shared/objpoints_shared;
#using scripts/shared/music_shared;
#using scripts/shared/math_shared;
#using scripts/shared/laststand_shared;
#using scripts/shared/hud_util_shared;
#using scripts/shared/hud_message_shared;
#using scripts/shared/hud_shared;
#using scripts/shared/hostmigration_shared;
#using scripts/shared/gameobjects_shared;
#using scripts/shared/demo_shared;
#using scripts/shared/damagefeedback_shared;
#using scripts/shared/challenges_shared;
#using scripts/shared/callbacks_shared;

#namespace globallogic;

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x294c0bab, Offset: 0x17b0
// Size: 0x804
function init() {
    level.splitscreen = issplitscreen();
    level.xenon = getdvarstring("xenonGame") == "true";
    level.ps3 = getdvarstring("ps3Game") == "true";
    level.wiiu = getdvarstring("wiiuGame") == "true";
    level.orbis = getdvarstring("orbisGame") == "true";
    level.durango = getdvarstring("durangoGame") == "true";
    level.onlinegame = sessionmodeisonlinegame();
    level.systemlink = sessionmodeissystemlink();
    level.console = level.xenon || level.ps3 || level.wiiu || level.orbis || level.durango;
    level.rankedmatch = gamemodeisusingxp();
    level.leaguematch = 0;
    level.arenamatch = 0;
    level.contractsenabled = !getgametypesetting("disableContracts");
    level.contractsenabled = 0;
    /#
        if (getdvarint("g_gametype") == 1) {
            level.rankedmatch = 1;
        }
    #/
    level.script = tolower(getdvarstring("mapname"));
    level.gametype = tolower(getdvarstring("g_gametype"));
    level.teambased = 0;
    level.teamcount = getgametypesetting("teamCount");
    level.multiteam = level.teamcount > 2;
    level.var_71739519 = level.teamcount + 1;
    if (2 == level.var_71739519) {
        level.var_73ce26f0 = "axis";
    } else {
        level.var_73ce26f0 = "team" + level.var_71739519;
    }
    level.teams = [];
    level.teamindex = [];
    level.playerteams = [];
    teamcount = level.teamcount;
    level.playerteams["allies"] = "allies";
    level.teams["allies"] = "allies";
    level.teams["axis"] = "axis";
    level.teamindex["neutral"] = 0;
    level.teamindex["allies"] = 1;
    level.teamindex["axis"] = 2;
    for (teamindex = 3; teamindex <= teamcount; teamindex++) {
        level.teams["team" + teamindex] = "team" + teamindex;
        level.teamindex["team" + teamindex] = teamindex;
    }
    level.overrideteamscore = 0;
    level.overrideplayerscore = 0;
    level.displayhalftimetext = 0;
    level.displayroundendtext = 1;
    level.endgameonscorelimit = 1;
    level.endgameontimelimit = 1;
    level.cumulativeroundscores = 1;
    level.scoreroundwinbased = 0;
    level.resetplayerscoreeveryround = 0;
    level.gameforfeited = 0;
    level.forceautoassign = 0;
    level.halftimetype = "halftime";
    level.halftimesubcaption = %MP_SWITCHING_SIDES_CAPS;
    level.laststatustime = 0;
    level.waswinning = [];
    level.lastslowprocessframe = 0;
    level.placement = [];
    foreach (team in level.teams) {
        level.placement[team] = [];
    }
    level.placement["all"] = [];
    level.postroundtime = 7;
    level.inovertime = 0;
    level.var_d59daf8 = 1;
    level.defaultoffenseradius = 560;
    level.dropteam = getdvarint("sv_maxclients");
    globallogic_ui::init();
    registerdvars();
    loadout::initperkdvars();
    level.oldschool = getdvarint("scr_oldschool") == 1;
    if (level.oldschool) {
        /#
            print("g_gametype");
        #/
        setdvar("jump_height", 64);
        setdvar("jump_slowdownEnable", 0);
        setdvar("bg_fallDamageMinHeight", 256);
        setdvar("bg_fallDamageMaxHeight", 512);
        setdvar("player_clipSizeMultiplier", 2);
    }
    precache_mp_leaderboards();
    if (!isdefined(game["tiebreaker"])) {
        game["tiebreaker"] = 0;
    }
    thread gameadvertisement::init();
    thread gamerep::init();
    level.disablechallenges = 0;
    if (level.leaguematch || getdvarint("scr_disableChallenges") > 0) {
        level.disablechallenges = 1;
    }
    level.disablestattracking = getdvarint("scr_disableStatTracking") > 0;
    level thread setupcallbacks();
    level.var_ff266e7 = 1;
    level.figure_out_attacker = &globallogic_player::figureoutattacker;
    level.figure_out_friendly_fire = &globallogic_player::figureoutfriendlyfire;
    level.var_2453cf4a = &weapon_utils::function_23be4e6b;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x88871ccb, Offset: 0x1fc0
// Size: 0x2a4
function registerdvars() {
    if (getdvarstring("scr_oldschool") == "") {
        setdvar("scr_oldschool", "0");
    }
    if (getdvarstring("ui_guncycle") == "") {
        setdvar("ui_guncycle", 0);
    }
    if (getdvarstring("ui_weapon_tiers") == "") {
        setdvar("ui_weapon_tiers", 0);
    }
    setdvar("ui_text_endreason", "");
    setmatchflag("bomb_timer", 0);
    if (getdvarstring("scr_vehicle_damage_scalar") == "") {
        setdvar("scr_vehicle_damage_scalar", "1");
    }
    level.vehicledamagescalar = getdvarfloat("scr_vehicle_damage_scalar");
    level.fire_audio_repeat_duration = getdvarint("fire_audio_repeat_duration");
    level.fire_audio_random_max_duration = getdvarint("fire_audio_random_max_duration");
    teamname = function_7998dac8(level.teamindex["allies"]);
    if (isdefined(teamname)) {
        setdvar("g_customTeamName_Allies", teamname);
    } else {
        setdvar("g_customTeamName_Allies", "");
    }
    teamname = function_7998dac8(level.teamindex["axis"]);
    if (isdefined(teamname)) {
        setdvar("g_customTeamName_Axis", teamname);
        return;
    }
    setdvar("g_customTeamName_Axis", "");
}

// Namespace globallogic
// Params 10, eflags: 0x1 linked
// Checksum 0xc89b9eff, Offset: 0x2270
// Size: 0x54
function blank(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) {
    
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x34ee0813, Offset: 0x22d0
// Size: 0x424
function setupcallbacks() {
    level.spawnplayer = &globallogic_spawn::spawnplayer;
    level.spawnplayerprediction = &blank;
    level.spawnclient = &globallogic_spawn::spawnclient;
    level.spawnspectator = &globallogic_spawn::spawnspectator;
    level.spawnintermission = &globallogic_spawn::spawnintermission;
    level.scoreongiveplayerscore = &globallogic_score::giveplayerscore;
    level.onplayerscore = &globallogic_score::default_onplayerscore;
    level.onteamscore = &globallogic_score::default_onteamscore;
    level.wavespawntimer = &wavespawntimer;
    level.spawnmessage = &globallogic_spawn::default_spawnmessage;
    level.onspawnplayer = &blank;
    level.onspawnplayerunified = &blank;
    level.onspawnspectator = &globallogic_defaults::default_onspawnspectator;
    level.onspawnintermission = &globallogic_defaults::default_onspawnintermission;
    level.onrespawndelay = &blank;
    level.onforfeit = &globallogic_defaults::default_onforfeit;
    level.ontimelimit = &globallogic_defaults::default_ontimelimit;
    level.onscorelimit = &globallogic_defaults::default_onscorelimit;
    level.onalivecountchange = &globallogic_defaults::default_onalivecountchange;
    level.ondeadevent = &globallogic_defaults::default_ondeadevent;
    level.ononeleftevent = &globallogic_defaults::default_ononeleftevent;
    level.giveteamscore = &globallogic_score::giveteamscore;
    level.onlastteamaliveevent = &globallogic_defaults::function_45c10f52;
    level.var_f8e2a6ea = &globallogic_defaults::function_e4443d68;
    level.gettimepassed = &globallogic_utils::gettimepassed;
    level.gettimelimit = &globallogic_defaults::default_gettimelimit;
    level.getteamkillpenalty = &globallogic_defaults::default_getteamkillpenalty;
    level.getteamkillscore = &globallogic_defaults::default_getteamkillscore;
    level.iskillboosting = &globallogic_score::default_iskillboosting;
    level._setteamscore = &globallogic_score::_setteamscore;
    level._setplayerscore = &globallogic_score::_setplayerscore;
    level._getteamscore = &globallogic_score::_getteamscore;
    level._getplayerscore = &globallogic_score::_getplayerscore;
    level.onprecachegametype = &blank;
    level.onstartgametype = &blank;
    level.onplayerconnect = &blank;
    level.onplayerdisconnect = &blank;
    level.onplayerdamage = &blank;
    level.onplayerkilled = &blank;
    level.onplayerkilledextraunthreadedcbs = [];
    level.var_d6911678 = &hud_message::function_d6911678;
    level.onendgame = &blank;
    level.onroundendgame = &globallogic_defaults::default_onroundendgame;
    level.onmedalawarded = &blank;
    globallogic_ui::setupcallbacks();
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x5918f82a, Offset: 0x2700
// Size: 0x21c
function precache_mp_leaderboards() {
    if (sessionmodeiszombiesgame()) {
        return;
    }
    if (!level.rankedmatch) {
        return;
    }
    if (isdefined(level.isdoa) && level.isdoa) {
        return;
    }
    mapname = getdvarstring("mapname");
    globalleaderboards = "LB_MP_GB_XPPRESTIGE LB_MP_GB_SCORE LB_MP_GB_KDRATIO LB_MP_GB_KILLS LB_MP_GB_WINS LB_MP_GB_DEATHS LB_MP_GB_XPMAXPERGAME LB_MP_GB_TACTICALINSERTS LB_MP_GB_TACTICALINSERTSKILLS LB_MP_GB_PRESTIGEXP LB_MP_GB_HEADSHOTS LB_MP_GB_WEAPONS_PRIMARY LB_MP_GB_WEAPONS_SECONDARY";
    careerleaderboard = "";
    switch (level.gametype) {
    case 41:
    case 42:
    case 43:
    case 44:
        break;
    default:
        careerleaderboard = " LB_MP_GB_SCOREPERMINUTE";
        break;
    }
    gamemodeleaderboard = " LB_MP_GM_" + level.gametype;
    var_bdf3824c = " LB_MP_GM_" + level.gametype + "_EXT";
    var_58eaf806 = "";
    var_49e2032b = "";
    hardcoremode = getgametypesetting("hardcoreMode");
    if (isdefined(hardcoremode) && hardcoremode) {
        var_58eaf806 = gamemodeleaderboard + "_HC";
        var_49e2032b = var_bdf3824c + "_HC";
    }
    mapleaderboard = " LB_MP_MAP_" + getsubstr(mapname, 3, mapname.size);
    precacheleaderboards(globalleaderboards + careerleaderboard + gamemodeleaderboard + var_bdf3824c + var_58eaf806 + var_49e2032b + mapleaderboard);
}

// Namespace globallogic
// Params 4, eflags: 0x1 linked
// Checksum 0xbe5be4f, Offset: 0x2928
// Size: 0xe6
function compareteambygamestat(gamestat, teama, teamb, previous_winner_score) {
    winner = undefined;
    if (teama == "tie") {
        winner = "tie";
        if (previous_winner_score < game[gamestat][teamb]) {
            winner = teamb;
        }
    } else if (game[gamestat][teama] == game[gamestat][teamb]) {
        winner = "tie";
    } else if (game[gamestat][teamb] > game[gamestat][teama]) {
        winner = teamb;
    } else {
        winner = teama;
    }
    return winner;
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0xa97d1d27, Offset: 0x2a18
// Size: 0xe2
function determineteamwinnerbygamestat(gamestat) {
    teamkeys = getarraykeys(level.teams);
    winner = teamkeys[0];
    previous_winner_score = game[gamestat][winner];
    for (teamindex = 1; teamindex < teamkeys.size; teamindex++) {
        winner = compareteambygamestat(gamestat, winner, teamkeys[teamindex], previous_winner_score);
        if (winner != "tie") {
            previous_winner_score = game[gamestat][winner];
        }
    }
    return winner;
}

// Namespace globallogic
// Params 3, eflags: 0x1 linked
// Checksum 0xef7daae8, Offset: 0x2b08
// Size: 0xee
function compareteambyteamscore(teama, teamb, previous_winner_score) {
    winner = undefined;
    teambscore = [[ level._getteamscore ]](teamb);
    if (teama == "tie") {
        winner = "tie";
        if (previous_winner_score < teambscore) {
            winner = teamb;
        }
        return winner;
    }
    teamascore = [[ level._getteamscore ]](teama);
    if (teambscore == teamascore) {
        winner = "tie";
    } else if (teambscore > teamascore) {
        winner = teamb;
    } else {
        winner = teama;
    }
    return winner;
}

// Namespace globallogic
// Params 0, eflags: 0x0
// Checksum 0x69648bc9, Offset: 0x2c00
// Size: 0xde
function determineteamwinnerbyteamscore() {
    teamkeys = getarraykeys(level.teams);
    winner = teamkeys[0];
    previous_winner_score = [[ level._getteamscore ]](winner);
    for (teamindex = 1; teamindex < teamkeys.size; teamindex++) {
        winner = compareteambyteamscore(winner, teamkeys[teamindex], previous_winner_score);
        if (winner != "tie") {
            previous_winner_score = [[ level._getteamscore ]](winner);
        }
    }
    return winner;
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0x173eca5c, Offset: 0x2ce8
// Size: 0x1cc
function forceend(hostsucks) {
    level.var_9260e896 = undefined;
    level.var_a07e59c6 = undefined;
    level.var_1a145538 = undefined;
    if (!isdefined(hostsucks)) {
        hostsucks = 0;
    }
    if (level.hostforcedend || level.forcedend) {
        return;
    }
    winner = undefined;
    if (level.teambased) {
        winner = determineteamwinnerbygamestat("teamScores");
        globallogic_utils::logteamwinstring("host ended game", winner);
    } else {
        winner = globallogic_score::gethighestscoringplayer();
        /#
            if (isdefined(winner)) {
                print("g_gametype" + winner.name);
            } else {
                print("g_gametype");
            }
        #/
    }
    level.forcedend = 1;
    level.hostforcedend = 1;
    if (hostsucks) {
        endstring = %MP_HOST_SUCKS;
    } else if (level.splitscreen) {
        endstring = %MP_ENDED_GAME;
    } else {
        endstring = %MP_HOST_ENDED_GAME;
    }
    setmatchflag("disableIngameMenu", 1);
    setdvar("ui_text_endreason", endstring);
    thread endgame(winner, endstring);
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xb84d1779, Offset: 0x2ec0
// Size: 0x14c
function killserverpc() {
    if (level.hostforcedend || level.forcedend) {
        return;
    }
    winner = undefined;
    if (level.teambased) {
        winner = determineteamwinnerbygamestat("teamScores");
        globallogic_utils::logteamwinstring("host ended game", winner);
    } else {
        winner = globallogic_score::gethighestscoringplayer();
        /#
            if (isdefined(winner)) {
                print("g_gametype" + winner.name);
            } else {
                print("g_gametype");
            }
        #/
    }
    level.forcedend = 1;
    level.hostforcedend = 1;
    level.killserver = 1;
    endstring = %MP_HOST_ENDED_GAME;
    /#
        println("g_gametype");
    #/
    thread endgame(winner, endstring);
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xf279230b, Offset: 0x3018
// Size: 0xb6
function atleasttwoteams() {
    valid_count = 0;
    foreach (team in level.teams) {
        if (level.playercount[team] != 0) {
            valid_count++;
        }
    }
    if (valid_count < 2) {
        return false;
    }
    return true;
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0x84ec4bef, Offset: 0x30d8
// Size: 0x5a
function checkifteamforfeits(team) {
    if (!game["everExisted"][team]) {
        return false;
    }
    if (level.playercount[team] < 1 && util::totalplayercount() > 0) {
        return true;
    }
    return false;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x31cc68ac, Offset: 0x3140
// Size: 0x124
function function_c64c7a91() {
    var_4dfb2196 = 0;
    var_9c3f07a7 = undefined;
    foreach (team in level.teams) {
        if (checkifteamforfeits(team)) {
            var_4dfb2196++;
            if (!level.multiteam) {
                thread [[ level.onforfeit ]](team);
                return true;
            }
            continue;
        }
        var_9c3f07a7 = team;
    }
    if (level.multiteam && var_4dfb2196 == level.teams.size - 1) {
        thread [[ level.onforfeit ]](var_9c3f07a7);
        return true;
    }
    return false;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x11e627ee, Offset: 0x3270
// Size: 0x9a
function dospawnqueueupdates() {
    foreach (team in level.teams) {
        if (level.spawnqueuemodified[team]) {
            [[ level.onalivecountchange ]](team);
        }
    }
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0x31d17981, Offset: 0x3318
// Size: 0x3e
function isteamalldead(team) {
    return level.everexisted[team] && !level.alivecount[team] && !level.playerlives[team];
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x4ead2525, Offset: 0x3360
// Size: 0x94
function areallteamsdead() {
    foreach (team in level.teams) {
        if (!isteamalldead(team)) {
            return false;
        }
    }
    return true;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xf2c56cff, Offset: 0x3400
// Size: 0x106
function function_4f9a4c7f() {
    count = 0;
    var_42bbdeba = 0;
    aliveteam = undefined;
    foreach (team in level.teams) {
        if (level.everexisted[team]) {
            if (!isteamalldead(team)) {
                aliveteam = team;
                count++;
            }
            var_42bbdeba++;
        }
    }
    if (var_42bbdeba > 1 && count == 1) {
        return aliveteam;
    }
    return undefined;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xfe3e7a7e, Offset: 0x3510
// Size: 0x1a4
function dodeadeventupdates() {
    if (level.teambased) {
        if (areallteamsdead()) {
            [[ level.ondeadevent ]]("all");
            return true;
        }
        if (!isdefined(level.ondeadevent)) {
            var_718021e5 = function_4f9a4c7f();
            if (isdefined(var_718021e5)) {
                [[ level.onlastteamaliveevent ]](var_718021e5);
                return true;
            }
        } else {
            foreach (team in level.teams) {
                if (isteamalldead(team)) {
                    [[ level.ondeadevent ]](team);
                    return true;
                }
            }
        }
    } else if (totalalivecount() == 0 && totalplayerlives() == 0 && level.maxplayercount > 1) {
        [[ level.ondeadevent ]]("all");
        return true;
    }
    return false;
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0x97dadfb5, Offset: 0x36c0
// Size: 0x4e
function isonlyoneleftaliveonteam(team) {
    return level.lastalivecount[team] > 1 && level.alivecount[team] == 1 && level.playerlives[team] == 1;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x629e97dd, Offset: 0x3718
// Size: 0x11c
function doonelefteventupdates() {
    if (level.teambased) {
        foreach (team in level.teams) {
            if (isonlyoneleftaliveonteam(team)) {
                [[ level.ononeleftevent ]](team);
                return true;
            }
        }
    } else if (totalalivecount() == 1 && totalplayerlives() == 1 && level.maxplayercount > 1) {
        [[ level.ononeleftevent ]]("all");
        return true;
    }
    return false;
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0x3735117b, Offset: 0x3840
// Size: 0x36
function function_3e0aac29(team) {
    return level.everexisted[team] && level.alivecount[team] == level.laststandcount[team];
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x338ad468, Offset: 0x3880
// Size: 0x94
function function_c1a6930() {
    foreach (team in level.teams) {
        if (!function_3e0aac29(team)) {
            return false;
        }
    }
    return true;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x3758906b, Offset: 0x3920
// Size: 0x16c
function function_3eec45b4() {
    if (!isdefined(level.var_f8e2a6ea)) {
        return;
    }
    if (level.teambased) {
        if (function_c1a6930()) {
            [[ level.var_f8e2a6ea ]]("all");
            return 1;
        }
        foreach (team in level.teams) {
            if (function_3e0aac29(team)) {
                [[ level.var_f8e2a6ea ]](team);
                return 1;
            }
        }
    } else {
        var_2ebe0111 = function_5eacd238();
        if (var_2ebe0111 > 0 && totalalivecount() == var_2ebe0111 && level.maxplayercount > 1) {
            [[ level.var_f8e2a6ea ]]("all");
            return 1;
        }
    }
    return 0;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x64426af, Offset: 0x3a98
// Size: 0x1f8
function updategameevents() {
    /#
        if (getdvarint("g_gametype") == 1) {
            return;
        }
    #/
    if ((level.rankedmatch || level.wagermatch || level.leaguematch) && !level.ingraceperiod) {
        if (level.teambased) {
            if (!level.gameforfeited) {
                if (game["state"] == "playing" && function_c64c7a91()) {
                    return;
                }
            } else if (atleasttwoteams()) {
                level.gameforfeited = 0;
                level notify(#"hash_577494dc");
            }
        } else if (!level.gameforfeited) {
            if (util::totalplayercount() == 1 && level.maxplayercount > 1) {
                thread [[ level.onforfeit ]]();
                return;
            }
        } else if (util::totalplayercount() > 1) {
            level.gameforfeited = 0;
            level notify(#"hash_577494dc");
        }
    }
    if (!level.playerqueuedrespawn && !level.numlives && !level.inovertime) {
        return;
    }
    if (level.ingraceperiod) {
        return;
    }
    if (level.playerqueuedrespawn) {
        dospawnqueueupdates();
    }
    if (dodeadeventupdates()) {
        return;
    }
    if (doonelefteventupdates()) {
        return;
    }
    if (function_3eec45b4()) {
        return;
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xec424636, Offset: 0x3c98
// Size: 0x384
function matchstarttimer() {
    var_a2ceaf69 = hud::createserverfontstring("objective", 1.5);
    var_a2ceaf69 hud::setpoint("CENTER", "CENTER", 0, -40);
    var_a2ceaf69.sort = 1001;
    var_a2ceaf69 settext(game["strings"]["waiting_for_teams"]);
    var_a2ceaf69.foreground = 0;
    var_a2ceaf69.hidewheninmenu = 1;
    waitforplayers();
    var_a2ceaf69 settext(game["strings"]["match_starting_in"]);
    matchstarttimer = hud::createserverfontstring("big", 2.2);
    matchstarttimer hud::setpoint("CENTER", "CENTER", 0, 0);
    matchstarttimer.sort = 1001;
    matchstarttimer.color = (1, 1, 0);
    matchstarttimer.foreground = 0;
    matchstarttimer.hidewheninmenu = 1;
    matchstarttimer hud::function_1ad5c13d();
    counttime = int(level.prematchperiod);
    if (counttime >= 2) {
        while (counttime > 0 && !level.gameended) {
            matchstarttimer setvalue(counttime);
            matchstarttimer thread hud::function_5e2578bc(level);
            if (counttime == 2) {
                visionsetnaked(getdvarstring("mapname"), 3);
            }
            counttime--;
            foreach (player in level.players) {
                player playlocalsound("uin_start_count_down");
            }
            wait(1);
        }
    } else {
        visionsetnaked(getdvarstring("mapname"), 1);
    }
    matchstarttimer hud::destroyelem();
    var_a2ceaf69 hud::destroyelem();
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xdaa84ba5, Offset: 0x4028
// Size: 0x34
function matchstarttimerskip() {
    visionsetnaked(getdvarstring("mapname"), 0);
}

// Namespace globallogic
// Params 2, eflags: 0x1 linked
// Checksum 0x7bdd2d09, Offset: 0x4068
// Size: 0x76
function notifyteamwavespawn(team, time) {
    if (time - level.lastwave[team] > level.wavedelay[team] * 1000) {
        level notify("wave_respawn_" + team);
        level.lastwave[team] = time;
        level.waveplayerspawnindex[team] = 0;
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x642e5475, Offset: 0x40e8
// Size: 0xd0
function wavespawntimer() {
    level endon(#"game_ended");
    while (game["state"] == "playing") {
        time = gettime();
        foreach (team in level.teams) {
            notifyteamwavespawn(team, time);
        }
        wait(0.05);
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x656a7c3b, Offset: 0x41c0
// Size: 0xa2
function hostidledout() {
    hostplayer = util::gethostplayer();
    /#
        if (getdvarint("g_gametype") == 1 || getdvarint("g_gametype") == 1) {
            return false;
        }
    #/
    if (isdefined(hostplayer) && !hostplayer.hasspawned && !isdefined(hostplayer.selectedclass)) {
        return true;
    }
    return false;
}

// Namespace globallogic
// Params 3, eflags: 0x1 linked
// Checksum 0x87179dd4, Offset: 0x4270
// Size: 0x54
function incrementmatchcompletionstat(gamemode, playedorhosted, stat) {
    self adddstat("gameHistory", gamemode, "modeHistory", playedorhosted, stat, 1);
}

// Namespace globallogic
// Params 3, eflags: 0x0
// Checksum 0xd86bc911, Offset: 0x42d0
// Size: 0x54
function setmatchcompletionstat(gamemode, playedorhosted, stat) {
    self setdstat("gameHistory", gamemode, "modeHistory", playedorhosted, stat, 1);
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x75c899c6, Offset: 0x4330
// Size: 0x16a
function getteamscoreratio() {
    playerteam = self.pers["team"];
    score = getteamscore(playerteam);
    otherteamscore = 0;
    foreach (team in level.teams) {
        if (team == playerteam) {
            continue;
        }
        otherteamscore += getteamscore(team);
    }
    if (level.teams.size > 1) {
        otherteamscore /= level.teams.size - 1;
    }
    if (otherteamscore != 0) {
        return (float(score) / float(otherteamscore));
    }
    return score;
}

// Namespace globallogic
// Params 0, eflags: 0x0
// Checksum 0x599e2635, Offset: 0x44a8
// Size: 0x8e
function gethighestscore() {
    highestscore = -999999999;
    for (index = 0; index < level.players.size; index++) {
        player = level.players[index];
        if (player.score > highestscore) {
            highestscore = player.score;
        }
    }
    return highestscore;
}

// Namespace globallogic
// Params 1, eflags: 0x0
// Checksum 0xa7489011, Offset: 0x4540
// Size: 0xb2
function getnexthighestscore(score) {
    highestscore = -999999999;
    for (index = 0; index < level.players.size; index++) {
        player = level.players[index];
        if (player.score >= score) {
            continue;
        }
        if (player.score > highestscore) {
            highestscore = player.score;
        }
    }
    return highestscore;
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0xef8f83cf, Offset: 0x4600
// Size: 0x8b6
function sendafteractionreport(winner) {
    /#
        if (getdvarint("g_gametype") == 1) {
            return;
        }
    #/
    for (index = 0; index < level.players.size; index++) {
        player = level.players[index];
        spread = player.kills - player.deaths;
        if (player.pers["cur_kill_streak"] > player.pers["best_kill_streak"]) {
            player.pers["best_kill_streak"] = player.pers["cur_kill_streak"];
        }
        if (level.rankedmatch) {
            player persistence::function_2eb5e93("privateMatch", 0);
        } else {
            player persistence::function_2eb5e93("privateMatch", 1);
        }
        player persistence::function_2eb5e93("demoFileID", getdemofileid());
        if (isdefined(winner) && winner == player.pers["team"]) {
            player persistence::function_2eb5e93("matchWon", 1);
        } else {
            player persistence::function_2eb5e93("matchWon", 0);
        }
        var_a4ad5434 = 0;
        var_1e9fcf9e = 0;
        var_94d83f9f = 0;
        for (index = 0; index < level.players.size; index++) {
            player persistence::function_3ec1e50f(index, "isActive", 1);
            player persistence::function_3ec1e50f(index, "name", level.players[index].name);
            player persistence::function_3ec1e50f(index, "xuid", level.players[index] getxuid());
            player persistence::function_3ec1e50f(index, "prvRank", int(level.players[index].pers["rank"]));
            player persistence::function_3ec1e50f(index, "curRank", level.players[index] getdstat("playerstatslist", "rank", "StatValue"));
            player persistence::function_3ec1e50f(index, "prvXP", int(level.players[index].pers["rankxp"]));
            player persistence::function_3ec1e50f(index, "curXP", int(level.players[index] getdstat("playerstatslist", "rankxp", "StatValue")));
            player persistence::function_3ec1e50f(index, "deaths", level.players[index].deaths);
            player persistence::function_3ec1e50f(index, "kills", level.players[index].kills);
            if (level.players[index].kills > level.players[var_94d83f9f].kills) {
                var_94d83f9f = index;
            }
            player persistence::function_3ec1e50f(index, "assists", level.players[index].assists);
            if (level.players[index].assists > level.players[var_1e9fcf9e].assists) {
                var_1e9fcf9e = index;
            }
            player persistence::function_3ec1e50f(index, "revives", level.players[index].revives);
            if (level.players[index].revives > level.players[var_a4ad5434].revives) {
                var_a4ad5434 = index;
            }
        }
        for (index = 0; index < level.players.size; index++) {
            player persistence::function_ae338cde(index, 0, var_94d83f9f);
            player persistence::function_ae338cde(index, 1, var_1e9fcf9e);
            player persistence::function_ae338cde(index, 2, var_a4ad5434);
        }
        teamscoreratio = player getteamscoreratio();
        scoreboardposition = getplacementforplayer(player);
        if (scoreboardposition < 0) {
            scoreboardposition = level.players.size;
        }
        player gamehistoryfinishmatch(4, player.kills, player.deaths, player.score, scoreboardposition, teamscoreratio);
        placement = level.placement["all"];
        for (otherplayerindex = 0; otherplayerindex < placement.size; otherplayerindex++) {
            if (level.placement["all"][otherplayerindex] == player) {
                recordplayerstats(player, "position", otherplayerindex);
            }
        }
        player persistence::function_2eb5e93("valid", 1);
        player persistence::function_2eb5e93("viewed", 0);
        if (isdefined(player.pers["matchesPlayedStatsTracked"])) {
            gamemode = util::getcurrentgamemode();
            player incrementmatchcompletionstat(gamemode, "played", "completed");
            if (isdefined(player.pers["matchesHostedStatsTracked"])) {
                player incrementmatchcompletionstat(gamemode, "hosted", "completed");
                player.pers["matchesHostedStatsTracked"] = undefined;
            }
            player.pers["matchesPlayedStatsTracked"] = undefined;
        }
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x1a2df35c, Offset: 0x4ec0
// Size: 0x1ca
function gamehistoryplayerkicked() {
    teamscoreratio = self getteamscoreratio();
    scoreboardposition = getplacementforplayer(self);
    if (scoreboardposition < 0) {
        scoreboardposition = level.players.size;
    }
    /#
        /#
            assert(isdefined(self.kills));
        #/
        /#
            assert(isdefined(self.deaths));
        #/
        /#
            assert(isdefined(self.score));
        #/
        /#
            assert(isdefined(scoreboardposition));
        #/
        /#
            assert(isdefined(teamscoreratio));
        #/
    #/
    self gamehistoryfinishmatch(2, self.kills, self.deaths, self.score, scoreboardposition, teamscoreratio);
    if (isdefined(self.pers["matchesPlayedStatsTracked"])) {
        gamemode = util::getcurrentgamemode();
        self incrementmatchcompletionstat(gamemode, "played", "kicked");
        self.pers["matchesPlayedStatsTracked"] = undefined;
    }
    uploadstats(self);
    wait(1);
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x53d11759, Offset: 0x5098
// Size: 0x194
function gamehistoryplayerquit() {
    teamscoreratio = self getteamscoreratio();
    scoreboardposition = getplacementforplayer(self);
    if (scoreboardposition < 0) {
        scoreboardposition = level.players.size;
    }
    self gamehistoryfinishmatch(3, self.kills, self.deaths, self.score, scoreboardposition, teamscoreratio);
    if (isdefined(self.pers["matchesPlayedStatsTracked"])) {
        gamemode = util::getcurrentgamemode();
        self incrementmatchcompletionstat(gamemode, "played", "quit");
        if (isdefined(self.pers["matchesHostedStatsTracked"])) {
            self incrementmatchcompletionstat(gamemode, "hosted", "quit");
            self.pers["matchesHostedStatsTracked"] = undefined;
        }
        self.pers["matchesPlayedStatsTracked"] = undefined;
    }
    uploadstats(self);
    if (!self ishost()) {
        wait(1);
    }
}

// Namespace globallogic
// Params 2, eflags: 0x1 linked
// Checksum 0x313257f9, Offset: 0x5238
// Size: 0x2a4
function displayroundend(winner, endreasontext) {
    if (level.displayroundendtext) {
        if (level.teambased) {
            if (winner == "tie") {
                demo::function_e2be394("round_result", level.teamindex["neutral"], level.teamindex["neutral"]);
            } else {
                demo::function_e2be394("round_result", level.teamindex[winner], level.teamindex["neutral"]);
            }
        }
        setmatchflag("cg_drawSpectatorMessages", 0);
        players = level.players;
        for (index = 0; index < players.size; index++) {
            player = players[index];
            if (!util::waslastround()) {
                player notify(#"round_ended");
            }
            if (!isdefined(player.pers["team"])) {
                player [[ level.spawnintermission ]](1);
                continue;
            }
            if (level.wagermatch) {
                if (level.teambased) {
                    player thread [[ level.var_efea8a44 ]](winner, 1, endreasontext);
                } else {
                    player thread [[ level.var_b60ac87b ]](winner, endreasontext);
                }
            } else if (level.teambased) {
                player thread [[ level.onteamoutcomenotify ]](winner, 1, endreasontext);
            } else {
                player thread [[ level.onoutcomenotify ]](winner, 1, endreasontext);
            }
            player util::show_hud(0);
            player setclientuivisibilityflag("g_compassShowEnemies", 0);
        }
    }
    if (util::waslastround()) {
        roundendwait(level.roundenddelay, 0);
        return;
    }
    roundendwait(level.roundenddelay, 1);
}

// Namespace globallogic
// Params 2, eflags: 0x1 linked
// Checksum 0x5783e69d, Offset: 0x54e8
// Size: 0x22c
function displayroundswitch(winner, endreasontext) {
    switchtype = level.halftimetype;
    if (switchtype == "halftime") {
        if (isdefined(level.nextroundisovertime) && level.nextroundisovertime) {
            switchtype = "overtime";
        } else if (level.roundlimit) {
            if (game["roundsplayed"] * 2 == level.roundlimit) {
                switchtype = "halftime";
            } else {
                switchtype = "intermission";
            }
        } else if (level.scorelimit) {
            if (game["roundsplayed"] == level.scorelimit - 1) {
                switchtype = "halftime";
            } else {
                switchtype = "intermission";
            }
        } else {
            switchtype = "intermission";
        }
    }
    setmatchtalkflag("EveryoneHearsEveryone", 1);
    players = level.players;
    for (index = 0; index < players.size; index++) {
        player = players[index];
        if (!isdefined(player.pers["team"])) {
            player [[ level.spawnintermission ]](1);
            continue;
        }
        if (level.wagermatch) {
            player thread [[ level.var_efea8a44 ]](switchtype, 1, level.halftimesubcaption);
        } else {
            player thread [[ level.onteamoutcomenotify ]](switchtype, 0, level.halftimesubcaption);
        }
        player util::show_hud(0);
    }
    roundendwait(level.halftimeroundenddelay, 0);
}

// Namespace globallogic
// Params 3, eflags: 0x1 linked
// Checksum 0x1b7544ac, Offset: 0x5720
// Size: 0x2e4
function displaygameend(winner, endreasontext, var_b091fbbb) {
    setmatchtalkflag("EveryoneHearsEveryone", 1);
    setmatchflag("cg_drawSpectatorMessages", 0);
    if (level.teambased) {
        if (winner == "tie") {
            demo::function_e2be394("game_result", level.teamindex["neutral"], level.teamindex["neutral"]);
        } else {
            demo::function_e2be394("game_result", level.teamindex[winner], level.teamindex["neutral"]);
        }
    }
    players = level.players;
    for (index = 0; index < players.size; index++) {
        player = players[index];
        if (!isdefined(player.pers["team"])) {
            player [[ level.spawnintermission ]](1);
            continue;
        }
        if (level.teambased) {
            if (isdefined(level.onteamoutcomenotify)) {
                player thread [[ level.onteamoutcomenotify ]](winner, 0, endreasontext);
            }
        } else if (isdefined(level.onoutcomenotify)) {
            player thread [[ level.onoutcomenotify ]](winner, 0, endreasontext);
        }
        player util::show_hud(0);
        player setclientuivisibilityflag("g_compassShowEnemies", 0);
    }
    if (level.teambased) {
        players = level.players;
        for (index = 0; index < players.size; index++) {
            player = players[index];
            team = player.pers["team"];
        }
    }
    if (isdefined(level.var_78a27045)) {
        level thread [[ level.var_78a27045 ]](winner, endreasontext, var_b091fbbb);
    }
    bbprint("global_session_epilogs", "reason %s", endreasontext);
    roundendwait(level.postroundtime, 1);
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x5fd324f5, Offset: 0x5a10
// Size: 0xd0
function getendreasontext() {
    if (isdefined(level.endreasontext)) {
        return level.endreasontext;
    }
    if (util::hitroundlimit() || util::hitroundwinlimit()) {
        return game["strings"]["round_limit_reached"];
    } else if (util::hitscorelimit()) {
        return game["strings"]["score_limit_reached"];
    }
    if (level.forcedend) {
        if (level.hostforcedend) {
            return %MP_HOST_ENDED_GAME;
        } else {
            return %MP_ENDED_GAME;
        }
    }
    return game["strings"]["time_limit_reached"];
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xa0bbfdb8, Offset: 0x5ae8
// Size: 0x6a
function resetoutcomeforallplayers() {
    players = level.players;
    for (index = 0; index < players.size; index++) {
        player = players[index];
        player notify(#"reset_outcome");
    }
}

// Namespace globallogic
// Params 2, eflags: 0x1 linked
// Checksum 0x5d81e6ba, Offset: 0x5b60
// Size: 0x25c
function function_26850b50(winner, endreasontext) {
    if (!util::isoneround()) {
        displayroundend(winner, endreasontext);
        globallogic_utils::executepostroundevents();
        if (!util::waslastround()) {
            if (checkroundswitch()) {
                displayroundswitch(winner, endreasontext);
            }
            if (isdefined(level.nextroundisovertime) && level.nextroundisovertime) {
                if (!isdefined(game["overtime_round"])) {
                    game["overtime_round"] = 1;
                } else {
                    game["overtime_round"]++;
                }
            }
            setmatchtalkflag("DeadChatWithDead", level.voip.deadchatwithdead);
            setmatchtalkflag("DeadChatWithTeam", level.voip.deadchatwithteam);
            setmatchtalkflag("DeadHearTeamLiving", level.voip.deadhearteamliving);
            setmatchtalkflag("DeadHearAllLiving", level.voip.deadhearallliving);
            setmatchtalkflag("EveryoneHearsEveryone", level.voip.everyonehearseveryone);
            setmatchtalkflag("DeadHearKiller", level.voip.deadhearkiller);
            setmatchtalkflag("KillersHearVictim", level.voip.killershearvictim);
            game["state"] = "playing";
            level.allowbattlechatter["bc"] = getgametypesetting("allowBattleChatter");
            map_restart(1);
            return true;
        }
    }
    return false;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xdb32b331, Offset: 0x5dc8
// Size: 0x342
function function_fe2db310() {
    if (level.rankedmatch || level.wagermatch) {
        placement = level.placement["all"];
        topthreeplayers = min(3, placement.size);
        for (index = 0; index < topthreeplayers; index++) {
            if (level.placement["all"][index].score) {
                if (!index) {
                    level.placement["all"][index] addplayerstatwithgametype("TOPPLAYER", 1);
                    level.placement["all"][index] notify(#"topplayer");
                } else {
                    level.placement["all"][index] notify(#"hash_654bc6be");
                }
                level.placement["all"][index] addplayerstatwithgametype("TOP3", 1);
                level.placement["all"][index] addplayerstat("TOP3ANY", 1);
                if (level.hardcoremode) {
                    level.placement["all"][index] addplayerstat("TOP3ANY_HC", 1);
                }
                if (level.multiteam) {
                    level.placement["all"][index] addplayerstat("TOP3ANY_MULTITEAM", 1);
                }
                level.placement["all"][index] notify(#"hash_e3f895a5");
            }
        }
        for (index = 3; index < placement.size; index++) {
            level.placement["all"][index] notify(#"hash_1fc5ff08");
            level.placement["all"][index] notify(#"hash_654bc6be");
        }
        if (level.teambased) {
            foreach (team in level.teams) {
                function_cc3ae2fc(team);
            }
        }
    }
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0xc4b6bd4f, Offset: 0x6118
// Size: 0x176
function function_cc3ae2fc(team) {
    var_f43a8455 = level.placement[team];
    var_d73408dd = min(3, var_f43a8455.size);
    if (var_f43a8455.size < 5) {
        return;
    }
    for (index = 0; index < var_d73408dd; index++) {
        if (var_f43a8455[index].score) {
            var_f43a8455[index] addplayerstat("TOP3TEAM", 1);
            var_f43a8455[index] addplayerstat("TOP3ANY", 1);
            if (level.hardcoremode) {
                var_f43a8455[index] addplayerstat("TOP3ANY_HC", 1);
            }
            if (level.multiteam) {
                var_f43a8455[index] addplayerstat("TOP3ANY_MULTITEAM", 1);
            }
            var_f43a8455[index] addplayerstatwithgametype("TOP3TEAM", 1);
        }
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x83ea325b, Offset: 0x6298
// Size: 0x7a
function getgamelength() {
    if (!level.timelimit || level.forcedend) {
        gamelength = globallogic_utils::gettimepassed() / 1000;
        gamelength = min(gamelength, 1200);
    } else {
        gamelength = level.timelimit * 60;
    }
    return gamelength;
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0x93534fec, Offset: 0x6320
// Size: 0x6e
function function_f8e35b5(winner) {
    players = level.players;
    for (index = 0; index < players.size; index++) {
        globallogic_player::function_be51e5e1(players[index], winner);
    }
}

// Namespace globallogic
// Params 3, eflags: 0x1 linked
// Checksum 0x7987ef4e, Offset: 0x6398
// Size: 0x9a4
function endgame(winner, endreasontext, var_b091fbbb) {
    if (game["state"] == "postgame" || level.gameended) {
        return;
    }
    if (isdefined(level.onendgame)) {
        [[ level.onendgame ]](winner);
    }
    if (!isdefined(level.disableoutrovisionset) || level.disableoutrovisionset == 0) {
        visionsetnaked("mpOutro", 2);
    }
    setmatchflag("cg_drawSpectatorMessages", 0);
    setmatchflag("game_ended", 1);
    game["state"] = "postgame";
    level.gameendtime = gettime();
    level.gameended = 1;
    setdvar("g_gameEnded", 1);
    level.ingraceperiod = 0;
    level notify(#"game_ended");
    level.allowbattlechatter = [];
    foreach (team in level.teams) {
        game["lastroundscore"][team] = getteamscore(team);
    }
    if (!isdefined(game["overtime_round"]) || util::waslastround()) {
        game["roundsplayed"]++;
        game["roundwinner"][game["roundsplayed"]] = winner;
        if (level.teambased) {
            game["roundswon"][winner]++;
        }
    }
    setgameendtime(0);
    updateplacement();
    updaterankedmatch(winner);
    players = level.players;
    newtime = gettime();
    gamelength = getgamelength();
    setmatchtalkflag("EveryoneHearsEveryone", 1);
    bbgameover = 0;
    if (util::isoneround() || util::waslastround()) {
        bbgameover = 1;
    }
    for (index = 0; index < players.size; index++) {
        player = players[index];
        player globallogic_player::freezeplayerforroundend();
        player thread roundenddof(4);
        player clearallnoncheckpointdata();
        player globallogic_ui::freegameplayhudelems();
        player weapons::update_timings(newtime);
        player bbplayermatchend(gamelength, endreasontext, bbgameover);
        if ((level.rankedmatch || level.wagermatch || level.leaguematch) && !player issplitscreen()) {
            if (level.leaguematch) {
                player setdstat("AfterActionReportStats", "lobbyPopup", "leaguesummary");
                continue;
            }
            if (isdefined(player.setpromotion)) {
                player setdstat("AfterActionReportStats", "lobbyPopup", "promotion");
                continue;
            }
            player setdstat("AfterActionReportStats", "lobbyPopup", "summary");
        }
    }
    music::setmusicstate("silent");
    gamerep::gamerepupdateinformationforround();
    thread challenges::roundend(winner);
    matchrecordsetleveldifficultyforindex(1, level.gameskill);
    function_f8e35b5(winner);
    recordgameresult("draw");
    globallogic_player::recordactiveplayersendgamematchrecordstats();
    finalizematchrecord();
    if (function_26850b50(winner, endreasontext)) {
        return;
    }
    if (!util::isoneround()) {
        if (isdefined(level.onroundendgame)) {
            winner = [[ level.onroundendgame ]](winner);
        }
        endreasontext = getendreasontext();
    }
    skillupdate(winner, level.teambased);
    function_c00dcb58(winner);
    function_fe2db310();
    thread challenges::gameend(winner);
    level lui::screen_fade_out(1);
    wait(0.3);
    if (!isdefined(level.skipgameend) || !level.skipgameend) {
        displaygameend(winner, endreasontext, var_b091fbbb);
    }
    if (util::isoneround()) {
        globallogic_utils::executepostroundevents();
    }
    level.intermission = 1;
    gamerep::gamerepanalyzeandreport();
    thread sendafteractionreport(winner);
    setmatchflag("disableIngameMenu", 1);
    foreach (player in players) {
        player closeingamemenu();
    }
    setmatchtalkflag("EveryoneHearsEveryone", 1);
    players = level.players;
    for (index = 0; index < players.size; index++) {
        player = players[index];
        recordplayerstats(player, "presentAtEnd", 1);
        player notify(#"reset_outcome");
    }
    if (isdefined(level.var_a59e087e)) {
        level thread [[ level.var_a59e087e ]]();
    }
    players = getplayers();
    for (i = 0; i < players.size; i++) {
        players[i] setclientuivisibilityflag("weapon_hud_visible", 0);
        players[i] setclientminiscoreboardhide(1);
    }
    level notify(#"sfade");
    /#
        print("g_gametype");
    #/
    if (isdefined(level.var_4c3d1a55)) {
        [[ level.var_4c3d1a55 ]]();
        level.var_4c3d1a55 = undefined;
    }
    players = getplayers();
    for (i = 0; i < players.size; i++) {
        players[i] cameraactivate(0);
    }
    exitlevel(0);
}

// Namespace globallogic
// Params 3, eflags: 0x1 linked
// Checksum 0xa339347e, Offset: 0x6d48
// Size: 0xc0
function bbplayermatchend(gamelength, endreasonstring, gameover) {
    playerrank = getplacementforplayer(self);
    totaltimeplayed = 0;
    if (isdefined(self.timeplayed) && isdefined(self.timeplayed["total"])) {
        totaltimeplayed = self.timeplayed["total"];
        if (totaltimeplayed > gamelength) {
            totaltimeplayed = gamelength;
        }
    }
    xuid = self getxuid();
}

// Namespace globallogic
// Params 2, eflags: 0x1 linked
// Checksum 0x85d70cd0, Offset: 0x6e10
// Size: 0x14
function roundendwait(defaultdelay, matchbonus) {
    
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0xb39336d5, Offset: 0x6e30
// Size: 0x3c
function roundenddof(time) {
    self setdepthoffield(0, -128, 512, 4000, 6, 1.8);
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xe19c1de, Offset: 0x6e78
// Size: 0x130
function checktimelimit() {
    if (isdefined(level.timelimitoverride) && level.timelimitoverride) {
        return;
    }
    if (game["state"] != "playing") {
        setgameendtime(0);
        return;
    }
    if (level.timelimit <= 0) {
        setgameendtime(0);
        return;
    }
    if (level.inprematchperiod) {
        setgameendtime(0);
        return;
    }
    if (level.timerstopped) {
        setgameendtime(0);
        return;
    }
    if (!isdefined(level.starttime)) {
        return;
    }
    timeleft = globallogic_utils::gettimeremaining();
    setgameendtime(gettime() + int(timeleft));
    if (timeleft > 0) {
        return;
    }
    [[ level.ontimelimit ]]();
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xd2d1a752, Offset: 0x6fb0
// Size: 0x9a
function allteamsunderscorelimit() {
    foreach (team in level.teams) {
        if (game["teamScores"][team] >= level.scorelimit) {
            return false;
        }
    }
    return true;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x2fed31, Offset: 0x7058
// Size: 0xa4
function checkscorelimit() {
    if (game["state"] != "playing") {
        return 0;
    }
    if (level.scorelimit <= 0) {
        return 0;
    }
    if (level.teambased) {
        if (allteamsunderscorelimit()) {
            return 0;
        }
    } else {
        if (!isplayer(self)) {
            return 0;
        }
        if (self.pointstowin < level.scorelimit) {
            return 0;
        }
    }
    [[ level.onscorelimit ]]();
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x1078e133, Offset: 0x7108
// Size: 0x20e
function updategametypedvars() {
    level endon(#"game_ended");
    while (game["state"] == "playing") {
        roundlimit = math::clamp(getgametypesetting("roundLimit"), level.roundlimitmin, level.roundlimitmax);
        if (roundlimit != level.roundlimit) {
            level.roundlimit = roundlimit;
            level notify(#"update_roundlimit");
        }
        timelimit = [[ level.gettimelimit ]]();
        if (timelimit != level.timelimit) {
            level.timelimit = timelimit;
            setdvar("ui_timelimit", level.timelimit);
            level notify(#"update_timelimit");
        }
        thread checktimelimit();
        scorelimit = math::clamp(getgametypesetting("scoreLimit"), level.scorelimitmin, level.scorelimitmax);
        if (scorelimit != level.scorelimit) {
            level.scorelimit = scorelimit;
            setdvar("ui_scorelimit", level.scorelimit);
            level notify(#"update_scorelimit");
        }
        thread checkscorelimit();
        if (isdefined(level.starttime)) {
            remaining_time = globallogic_utils::gettimeremaining();
            if (isdefined(remaining_time) && remaining_time < 3000) {
                wait(0.1);
                continue;
            }
        }
        wait(1);
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x1ad228a6, Offset: 0x7320
// Size: 0x1d6
function removedisconnectedplayerfromplacement() {
    offset = 0;
    numplayers = level.placement["all"].size;
    found = 0;
    for (i = 0; i < numplayers; i++) {
        if (level.placement["all"][i] == self) {
            found = 1;
        }
        if (found) {
            level.placement["all"][i] = level.placement["all"][i + 1];
        }
    }
    if (!found) {
        return;
    }
    level.placement["all"][numplayers - 1] = undefined;
    /#
        assert(level.placement["g_gametype"].size == numplayers - 1);
    #/
    /#
        globallogic_utils::assertproperplacement();
    #/
    updateteamplacement();
    if (level.teambased) {
        return;
    }
    numplayers = level.placement["all"].size;
    for (i = 0; i < numplayers; i++) {
        player = level.placement["all"][i];
        player notify(#"update_outcome");
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xbd7f336c, Offset: 0x7500
// Size: 0x37c
function updateplacement() {
    if (!level.players.size) {
        return;
    }
    level.placement["all"] = [];
    foreach (player in level.players) {
        if (!level.teambased || isdefined(level.teams[player.team])) {
            level.placement["all"][level.placement["all"].size] = player;
        }
    }
    placementall = level.placement["all"];
    if (level.teambased) {
        for (i = 1; i < placementall.size; i++) {
            player = placementall[i];
            playerscore = player.score;
            for (j = i - 1; playerscore == placementall[j].score && (playerscore > placementall[j].score || j >= 0 && player.deaths < placementall[j].deaths); j--) {
                placementall[j + 1] = placementall[j];
            }
            placementall[j + 1] = player;
        }
    } else {
        for (i = 1; i < placementall.size; i++) {
            player = placementall[i];
            playerscore = player.pointstowin;
            for (j = i - 1; playerscore == placementall[j].pointstowin && (playerscore > placementall[j].pointstowin || j >= 0 && player.deaths < placementall[j].deaths); j--) {
                placementall[j + 1] = placementall[j];
            }
            placementall[j + 1] = player;
        }
    }
    level.placement["all"] = placementall;
    /#
        globallogic_utils::assertproperplacement();
    #/
    updateteamplacement();
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x87375b97, Offset: 0x7888
// Size: 0x1d4
function updateteamplacement() {
    foreach (team in level.teams) {
        placement[team] = [];
    }
    placement["spectator"] = [];
    if (!level.teambased) {
        return;
    }
    placementall = level.placement["all"];
    placementallsize = placementall.size;
    for (i = 0; i < placementallsize; i++) {
        player = placementall[i];
        team = player.pers["team"];
        placement[team][placement[team].size] = player;
    }
    foreach (team in level.teams) {
        level.placement[team] = placement[team];
    }
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0x186dcfb6, Offset: 0x7a68
// Size: 0xb2
function getplacementforplayer(player) {
    updateplacement();
    playerrank = -1;
    placement = level.placement["all"];
    for (placementindex = 0; placementindex < placement.size; placementindex++) {
        if (level.placement["all"][placementindex] == player) {
            playerrank = placementindex + 1;
            break;
        }
    }
    return playerrank;
}

// Namespace globallogic
// Params 1, eflags: 0x0
// Checksum 0x26af8efc, Offset: 0x7b28
// Size: 0x254
function istopscoringplayer(player) {
    topplayer = 0;
    updateplacement();
    /#
        assert(level.placement["g_gametype"].size > 0);
    #/
    if (level.placement["all"].size == 0) {
        return 0;
    }
    if (level.teambased) {
        topscore = level.placement["all"][0].score;
        for (index = 0; index < level.placement["all"].size; index++) {
            if (level.placement["all"][index].score == 0) {
                break;
            }
            if (topscore > level.placement["all"][index].score) {
                break;
            }
            if (self == level.placement["all"][index]) {
                topscoringplayer = 1;
                break;
            }
        }
    } else {
        topscore = level.placement["all"][0].pointstowin;
        for (index = 0; index < level.placement["all"].size; index++) {
            if (level.placement["all"][index].pointstowin == 0) {
                break;
            }
            if (topscore > level.placement["all"][index].pointstowin) {
                break;
            }
            if (self == level.placement["all"][index]) {
                topplayer = 1;
                break;
            }
        }
    }
    return topplayer;
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0xc7d7eaab, Offset: 0x7d88
// Size: 0x19a
function sortdeadplayers(team) {
    if (!level.playerqueuedrespawn) {
        return;
    }
    for (i = 1; i < level.deadplayers[team].size; i++) {
        player = level.deadplayers[team][i];
        for (j = i - 1; j >= 0 && player.deathtime < level.deadplayers[team][j].deathtime; j--) {
            level.deadplayers[team][j + 1] = level.deadplayers[team][j];
        }
        level.deadplayers[team][j + 1] = player;
    }
    for (i = 0; i < level.deadplayers[team].size; i++) {
        if (level.deadplayers[team][i].spawnqueueindex != i) {
            level.spawnqueuemodified[team] = 1;
        }
        level.deadplayers[team][i].spawnqueueindex = i;
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x744f8469, Offset: 0x7f30
// Size: 0xa2
function totalalivecount() {
    count = 0;
    foreach (team in level.teams) {
        count += level.alivecount[team];
    }
    return count;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x9cfbb13c, Offset: 0x7fe0
// Size: 0xa2
function totalplayerlives() {
    count = 0;
    foreach (team in level.teams) {
        count += level.playerlives[team];
    }
    return count;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x712b71a6, Offset: 0x8090
// Size: 0xa2
function function_5eacd238() {
    count = 0;
    foreach (team in level.teams) {
        count += level.laststandcount[team];
    }
    return count;
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0xc4cd44d, Offset: 0x8140
// Size: 0x114
function initteamvariables(team) {
    if (!isdefined(level.alivecount)) {
        level.alivecount = [];
    }
    if (!isdefined(level.laststandcount)) {
        level.laststandcount = [];
    }
    level.alivecount[team] = 0;
    level.lastalivecount[team] = 0;
    level.laststandcount[team] = 0;
    if (!isdefined(game["everExisted"])) {
        game["everExisted"] = [];
    }
    if (!isdefined(game["everExisted"][team])) {
        game["everExisted"][team] = 0;
    }
    level.everexisted[team] = 0;
    level.wavedelay[team] = 0;
    level.lastwave[team] = 0;
    level.waveplayerspawnindex[team] = 0;
    resetteamvariables(team);
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0x7d5be72c, Offset: 0x8260
// Size: 0xaa
function resetteamvariables(team) {
    level.playercount[team] = 0;
    level.lastalivecount[team] = level.alivecount[team];
    level.alivecount[team] = 0;
    level.laststandcount[team] = 0;
    level.playerlives[team] = 0;
    level.aliveplayers[team] = [];
    level.deadplayers[team] = [];
    level.squads[team] = [];
    level.spawnqueuemodified[team] = 0;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x80fa82d2, Offset: 0x8318
// Size: 0x3f4
function updateteamstatus() {
    if (game["state"] == "postgame") {
        return;
    }
    resettimeout();
    foreach (team in level.teams) {
        resetteamvariables(team);
    }
    level.activeplayers = [];
    players = level.players;
    for (i = 0; i < players.size; i++) {
        player = players[i];
        if (!isdefined(player) && level.splitscreen) {
            continue;
        }
        team = player.team;
        playerclass = player.curclass;
        if (isdefined(playerclass) && team != "spectator" && playerclass != "") {
            level.playercount[team]++;
            if (player.sessionstate == "playing") {
                level.alivecount[team]++;
                level.playerlives[team]++;
                player.spawnqueueindex = -1;
                if (isalive(player)) {
                    level.aliveplayers[team][level.aliveplayers[team].size] = player;
                    level.activeplayers[level.activeplayers.size] = player;
                    if (isdefined(player.laststand) && player.laststand) {
                        level.laststandcount[team]++;
                    }
                } else {
                    level.deadplayers[team][level.deadplayers[team].size] = player;
                }
                continue;
            }
            level.deadplayers[team][level.deadplayers[team].size] = player;
            if (player globallogic_spawn::mayspawn()) {
                level.playerlives[team]++;
            }
        }
    }
    totalalive = totalalivecount();
    if (totalalive > level.maxplayercount) {
        level.maxplayercount = totalalive;
    }
    foreach (team in level.teams) {
        if (level.alivecount[team]) {
            game["everExisted"][team] = 1;
            level.everexisted[team] = 1;
        }
        sortdeadplayers(team);
    }
    level updategameevents();
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0x7a5ec269, Offset: 0x8718
// Size: 0xb2
function checkteamscorelimitsoon(team) {
    /#
        assert(isdefined(team));
    #/
    if (level.scorelimit <= 0) {
        return;
    }
    if (!level.teambased) {
        return;
    }
    if (globallogic_utils::gettimepassed() < 60000) {
        return;
    }
    timeleft = globallogic_utils::getestimatedtimeuntilscorelimit(team);
    if (timeleft < 1) {
        level notify(#"match_ending_soon", "score");
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x85c4deb6, Offset: 0x87d8
// Size: 0xaa
function checkplayerscorelimitsoon() {
    /#
        assert(isplayer(self));
    #/
    if (level.scorelimit <= 0) {
        return;
    }
    if (level.teambased) {
        return;
    }
    if (globallogic_utils::gettimepassed() < 60000) {
        return;
    }
    timeleft = globallogic_utils::getestimatedtimeuntilscorelimit(undefined);
    if (timeleft < 1) {
        level notify(#"match_ending_soon", "score");
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xbd358753, Offset: 0x8890
// Size: 0x29c
function timelimitclock() {
    level endon(#"game_ended");
    wait(0.05);
    clockobject = spawn("script_origin", (0, 0, 0));
    while (game["state"] == "playing") {
        if (!level.timerstopped && level.timelimit) {
            timeleft = globallogic_utils::gettimeremaining() / 1000;
            timeleftint = int(timeleft + 0.5);
            if (timeleftint == 601) {
                util::clientnotify("notify_10");
            }
            if (timeleftint == 301) {
                util::clientnotify("notify_5");
            }
            if (timeleftint == 60) {
                util::clientnotify("notify_1");
            }
            if (timeleftint == 12) {
                util::clientnotify("notify_count");
            }
            if (timeleftint >= 40 && timeleftint <= 60) {
                level notify(#"match_ending_soon", "time");
            }
            if (timeleftint >= 30 && timeleftint <= 40) {
                level notify(#"match_ending_pretty_soon", "time");
            }
            if (timeleftint <= 32) {
                level notify(#"match_ending_vox");
            }
            if (timeleftint <= 30 && (timeleftint <= 10 || timeleftint % 2 == 0)) {
                level notify(#"match_ending_very_soon", "time");
                if (timeleftint == 0) {
                    break;
                }
                clockobject playsound("mpl_ui_timer_countdown");
            }
            if (timeleft - floor(timeleft) >= 0.05) {
                wait(timeleft - floor(timeleft));
            }
        }
        wait(1);
    }
}

// Namespace globallogic
// Params 1, eflags: 0x0
// Checksum 0xf8e8c6b3, Offset: 0x8b38
// Size: 0xb0
function timelimitclock_intermission(waittime) {
    setgameendtime(gettime() + int(waittime * 1000));
    clockobject = spawn("script_origin", (0, 0, 0));
    if (waittime >= 10) {
        wait(waittime - 10);
    }
    for (;;) {
        clockobject playsound("mpl_ui_timer_countdown");
        wait(1);
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x18e2a8e4, Offset: 0x8bf0
// Size: 0x9c
function function_59b8efe0() {
    level endon(#"game_ended");
    while (true) {
        for (i = 0; i < level.players.size; i++) {
            player = level.players[i];
            if (isalive(player)) {
                recordbreadcrumbdataforplayer(player, undefined);
            }
        }
        wait(15);
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x2514e735, Offset: 0x8c98
// Size: 0x1fc
function startgame() {
    thread globallogic_utils::gametimer();
    level.timerstopped = 0;
    setmatchtalkflag("DeadChatWithDead", level.voip.deadchatwithdead);
    setmatchtalkflag("DeadChatWithTeam", level.voip.deadchatwithteam);
    setmatchtalkflag("DeadHearTeamLiving", level.voip.deadhearteamliving);
    setmatchtalkflag("DeadHearAllLiving", level.voip.deadhearallliving);
    setmatchtalkflag("EveryoneHearsEveryone", level.voip.everyonehearseveryone);
    setmatchtalkflag("DeadHearKiller", level.voip.deadhearkiller);
    setmatchtalkflag("KillersHearVictim", level.voip.killershearvictim);
    if (isdefined(level.custom_prematch_period)) {
        [[ level.custom_prematch_period ]]();
    } else {
        prematchperiod();
    }
    level notify(#"prematch_over");
    thread timelimitclock();
    thread graceperiod();
    thread watchmatchendingsoon();
    recordmatchbegin();
    if (!(isdefined(level.is_safehouse) && level.is_safehouse)) {
        thread function_59b8efe0();
        thread bb::function_543e7299("cpbreadcrumb");
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xda0fc671, Offset: 0x8ea0
// Size: 0x60
function waitforplayers() {
    starttime = gettime();
    while (getnumconnectedplayers() < 1) {
        wait(0.05);
        if (gettime() - starttime > 120000) {
            exitlevel(0);
        }
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x589b1795, Offset: 0x8f08
// Size: 0x136
function prematchperiod() {
    setmatchflag("hud_hardcore", level.hardcoremode);
    level endon(#"game_ended");
    if (level.prematchperiod > 0) {
        thread matchstarttimer();
        waitforplayers();
        wait(level.prematchperiod);
    } else {
        matchstarttimerskip();
        wait(0.05);
    }
    level.inprematchperiod = 0;
    for (index = 0; index < level.players.size; index++) {
        level.players[index] util::freeze_player_controls(0);
        level.players[index] enableweapons();
    }
    namespace_93432369::prematch_period();
    if (game["state"] != "playing") {
        return;
    }
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xa7736049, Offset: 0x9048
// Size: 0x14c
function graceperiod() {
    level endon(#"game_ended");
    if (isdefined(level.graceperiodfunc)) {
        [[ level.graceperiodfunc ]]();
    } else {
        wait(level.graceperiod);
    }
    level notify(#"grace_period_ending");
    wait(0.05);
    level.ingraceperiod = 0;
    if (game["state"] != "playing") {
        return;
    }
    if (level.numlives) {
        players = level.players;
        for (i = 0; i < players.size; i++) {
            player = players[i];
            if (!player.hasspawned && player.sessionteam != "spectator" && !isalive(player)) {
                player.statusicon = "hud_status_dead";
            }
        }
    }
    updateteamstatus();
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x32d8ba44, Offset: 0x91a0
// Size: 0x54
function watchmatchendingsoon() {
    setdvar("xblive_matchEndingSoon", 0);
    reason = level waittill(#"match_ending_soon");
    setdvar("xblive_matchEndingSoon", 1);
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x9d336d38, Offset: 0x9200
// Size: 0x8e
function anyteamhaswavedelay() {
    foreach (team in level.teams) {
        if (level.wavedelay[team]) {
            return true;
        }
    }
    return false;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0xfb4e82e5, Offset: 0x9298
// Size: 0x150c
function callback_startgametype() {
    level.prematchperiod = 0;
    level.intermission = 0;
    setmatchflag("cg_drawSpectatorMessages", 1);
    setmatchflag("game_ended", 0);
    if (!isdefined(game["gamestarted"])) {
        if (!isdefined(game["allies"])) {
            game["allies"] = "seals";
        }
        if (!isdefined(game["axis"])) {
            game["axis"] = "pmc";
        }
        if (!isdefined(game["attackers"])) {
            game["attackers"] = "allies";
        }
        if (!isdefined(game["defenders"])) {
            game["defenders"] = "axis";
        }
        /#
            assert(game["g_gametype"] != game["g_gametype"]);
        #/
        foreach (team in level.teams) {
            if (!isdefined(game[team])) {
                game[team] = "pmc";
            }
        }
        if (!isdefined(game["state"])) {
            game["state"] = "playing";
        }
        setdvar("cg_thirdPersonAngle", 354);
        game["strings"]["press_to_spawn"] = %PLATFORM_PRESS_TO_SPAWN;
        if (level.teambased) {
            game["strings"]["waiting_for_teams"] = %MP_WAITING_FOR_TEAMS;
            game["strings"]["opponent_forfeiting_in"] = %MP_OPPONENT_FORFEITING_IN;
        } else {
            game["strings"]["waiting_for_teams"] = %MP_WAITING_FOR_PLAYERS;
            game["strings"]["opponent_forfeiting_in"] = %MP_OPPONENT_FORFEITING_IN;
        }
        game["strings"]["match_starting_in"] = %MP_MATCH_STARTING_IN;
        game["strings"]["spawn_next_round"] = %COOP_SPAWN_NEXT_ROUND;
        game["strings"]["waiting_to_spawn"] = %MP_WAITING_TO_SPAWN;
        game["strings"]["waiting_to_spawn_ss"] = %MP_WAITING_TO_SPAWN_SS;
        game["strings"]["you_will_spawn"] = %MP_YOU_WILL_RESPAWN;
        game["strings"]["match_starting"] = %MP_MATCH_STARTING;
        game["strings"]["change_class"] = %MP_CHANGE_CLASS_NEXT_SPAWN;
        game["strings"]["last_stand"] = %MPUI_LAST_STAND;
        game["strings"]["cowards_way"] = %PLATFORM_COWARDS_WAY_OUT;
        game["strings"]["tie"] = %MP_MATCH_TIE;
        game["strings"]["round_draw"] = %MP_ROUND_DRAW;
        game["strings"]["enemies_eliminated"] = %MP_ENEMIES_ELIMINATED;
        game["strings"]["score_limit_reached"] = %MP_SCORE_LIMIT_REACHED;
        game["strings"]["round_limit_reached"] = %MP_ROUND_LIMIT_REACHED;
        game["strings"]["time_limit_reached"] = %MP_TIME_LIMIT_REACHED;
        game["strings"]["players_forfeited"] = %MP_PLAYERS_FORFEITED;
        game["strings"]["other_teams_forfeited"] = %MP_OTHER_TEAMS_FORFEITED;
        [[ level.onprecachegametype ]]();
        game["gamestarted"] = 1;
        game["totalKills"] = 0;
        foreach (team in level.teams) {
            game["teamScores"][team] = 0;
            game["totalKillsTeam"][team] = 0;
        }
        level.prematchperiod = getgametypesetting("prematchperiod");
        if (getdvarint("xblive_clanmatch") != 0) {
            foreach (team in level.teams) {
                game["icons"][team] = "composite_emblem_team_axis";
            }
            game["icons"]["allies"] = "composite_emblem_team_allies";
            game["icons"]["axis"] = "composite_emblem_team_axis";
        }
    } else if (!level.splitscreen) {
        level.prematchperiod = getgametypesetting("preroundperiod");
    }
    if (!isdefined(game["timepassed"])) {
        game["timepassed"] = 0;
    }
    if (!isdefined(game["roundsplayed"])) {
        game["roundsplayed"] = 0;
    }
    setroundsplayed(game["roundsplayed"]);
    if (isdefined(game["overtime_round"])) {
        setmatchflag("overtime", 1);
    } else {
        setmatchflag("overtime", 0);
    }
    if (!isdefined(game["roundwinner"])) {
        game["roundwinner"] = [];
    }
    if (!isdefined(game["lastroundscore"])) {
        game["lastroundscore"] = [];
    }
    if (!isdefined(game["roundswon"])) {
        game["roundswon"] = [];
    }
    if (!isdefined(game["roundswon"]["tie"])) {
        game["roundswon"]["tie"] = 0;
    }
    foreach (team in level.teams) {
        if (!isdefined(game["roundswon"][team])) {
            game["roundswon"][team] = 0;
        }
        level.teamspawnpoints[team] = [];
        level.spawn_point_team_class_names[team] = [];
    }
    level.skipvote = 0;
    level.gameended = 0;
    setdvar("g_gameEnded", 0);
    level.objidstart = 0;
    level.forcedend = 0;
    level.hostforcedend = 0;
    level.hardcoremode = getgametypesetting("hardcoreMode");
    if (level.hardcoremode) {
        /#
            print("g_gametype");
        #/
        if (!isdefined(level.friendlyfiredelaytime)) {
            level.friendlyfiredelaytime = 0;
        }
    }
    if (getdvarstring("scr_max_rank") == "") {
        setdvar("scr_max_rank", "0");
    }
    level.rankcap = getdvarint("scr_max_rank");
    if (getdvarstring("scr_min_prestige") == "") {
        setdvar("scr_min_prestige", "0");
    }
    level.minprestige = getdvarint("scr_min_prestige");
    level.usestartspawns = 1;
    level.cumulativeroundscores = getgametypesetting("cumulativeRoundScores");
    level.allowhitmarkers = getgametypesetting("allowhitmarkers");
    level.playerqueuedrespawn = getgametypesetting("playerQueuedRespawn");
    level.playerforcerespawn = getgametypesetting("playerForceRespawn");
    level.roundstartexplosivedelay = getgametypesetting("roundStartExplosiveDelay");
    level.roundstartkillstreakdelay = getgametypesetting("roundStartKillstreakDelay");
    level.perksenabled = getgametypesetting("perksEnabled");
    level.disableattachments = getgametypesetting("disableAttachments");
    level.disabletacinsert = getgametypesetting("disableTacInsert");
    level.disablecac = getgametypesetting("disableCAC");
    if (!isdefined(level.disableclassselection)) {
        level.disableclassselection = getgametypesetting("disableClassSelection");
    }
    level.disableweapondrop = getgametypesetting("disableweapondrop");
    level.onlyheadshots = getgametypesetting("onlyHeadshots");
    level.minimumallowedteamkills = getgametypesetting("teamKillPunishCount") - 1;
    level.teamkillreducedpenalty = getgametypesetting("teamKillReducedPenalty");
    level.teamkillpointloss = getgametypesetting("teamKillPointLoss");
    level.teamkillspawndelay = getgametypesetting("teamKillSpawnDelay");
    level.deathpointloss = getgametypesetting("deathPointLoss");
    level.leaderbonus = getgametypesetting("leaderBonus");
    level.forceradar = getgametypesetting("forceRadar");
    level.playersprinttime = getgametypesetting("playerSprintTime");
    level.bulletdamagescalar = getgametypesetting("bulletDamageScalar");
    level.playermaxhealth = getgametypesetting("playerMaxHealth");
    level.playerhealthregentime = getgametypesetting("playerHealthRegenTime");
    level.playerrespawndelay = getgametypesetting("playerRespawnDelay");
    level.playerobjectiveheldrespawndelay = getgametypesetting("playerObjectiveHeldRespawnDelay");
    level.waverespawndelay = getgametypesetting("waveRespawnDelay");
    level.suicidespawndelay = getgametypesetting("spawnsuicidepenalty");
    level.teamkilledspawndelay = getgametypesetting("spawnteamkilledpenalty");
    level.maxsuicidesbeforekick = getgametypesetting("maxsuicidesbeforekick");
    level.spectatetype = getgametypesetting("spectateType");
    level.voip = spawnstruct();
    level.voip.deadchatwithdead = getgametypesetting("voipDeadChatWithDead");
    level.voip.deadchatwithteam = getgametypesetting("voipDeadChatWithTeam");
    level.voip.deadhearallliving = getgametypesetting("voipDeadHearAllLiving");
    level.voip.deadhearteamliving = getgametypesetting("voipDeadHearTeamLiving");
    level.voip.everyonehearseveryone = getgametypesetting("voipEveryoneHearsEveryone");
    level.voip.deadhearkiller = getgametypesetting("voipDeadHearKiller");
    level.voip.killershearvictim = getgametypesetting("voipKillersHearVictim");
    gameobjects::main();
    callback::callback(#"hash_cc62acca");
    foreach (team in level.teams) {
        initteamvariables(team);
    }
    level.maxplayercount = 0;
    level.activeplayers = [];
    level.allowannouncer = getgametypesetting("allowAnnouncer");
    if (!isdefined(level.timelimit)) {
        util::registertimelimit(1, 1440);
    }
    if (!isdefined(level.scorelimit)) {
        util::registerscorelimit(1, 500);
    }
    if (!isdefined(level.roundlimit)) {
        util::registerroundlimit(0, 10);
    }
    if (!isdefined(level.roundwinlimit)) {
        util::registerroundwinlimit(0, 10);
    }
    globallogic_utils::registerpostroundevent(&namespace_93432369::function_fdf4c650);
    wavedelay = level.waverespawndelay;
    if (wavedelay) {
        foreach (team in level.teams) {
            level.wavedelay[team] = wavedelay;
            level.lastwave[team] = 0;
        }
        level thread [[ level.wavespawntimer ]]();
    }
    level.inprematchperiod = 1;
    if (level.prematchperiod > 2) {
        level.prematchperiod += randomfloat(4) - 2;
    }
    if (level.numlives || anyteamhaswavedelay() || level.playerqueuedrespawn) {
        level.graceperiod = 1500;
    } else {
        level.graceperiod = 1500;
    }
    level.ingraceperiod = 1;
    level.roundenddelay = 5;
    level.halftimeroundenddelay = 3;
    globallogic_score::updateallteamscores();
    level.killstreaksenabled = 1;
    if (getdvarstring("scr_game_rankenabled") == "") {
        setdvar("scr_game_rankenabled", 1);
    }
    level.rankenabled = getdvarint("scr_game_rankenabled");
    if (getdvarstring("scr_game_medalsenabled") == "") {
        setdvar("scr_game_medalsenabled", 1);
    }
    level.medalsenabled = getdvarint("scr_game_medalsenabled");
    if (level.hardcoremode && level.rankedmatch && getdvarstring("scr_game_friendlyFireDelay") == "") {
        setdvar("scr_game_friendlyFireDelay", 1);
    }
    level.friendlyfiredelay = getdvarint("scr_game_friendlyFireDelay");
    [[ level.onstartgametype ]]();
    if (getdvarint("custom_killstreak_mode") == 1) {
        level.killstreaksenabled = 0;
    }
    if (isdefined(level.gameskill)) {
        matchrecordsetleveldifficultyforindex(0, level.gameskill);
    }
    thread startgame();
    level thread updategametypedvars();
    level thread simple_hostmigration::updatehostmigrationdata();
    /#
        if (getdvarint("g_gametype") == 1) {
            level.skipgameend = 1;
            level.roundlimit = 1;
            wait(1);
            thread forceend(0);
        }
        if (getdvarint("g_gametype") == 1) {
            thread forcedebughostmigration();
        }
    #/
}

/#

    // Namespace globallogic
    // Params 0, eflags: 0x1 linked
    // Checksum 0x6dac059c, Offset: 0xa7b0
    // Size: 0x50
    function forcedebughostmigration() {
        while (true) {
            hostmigration::waittillhostmigrationdone();
            wait(60);
            starthostmigration();
            hostmigration::waittillhostmigrationdone();
        }
    }

#/

// Namespace globallogic
// Params 4, eflags: 0x1 linked
// Checksum 0x634d1bda, Offset: 0xa808
// Size: 0x10c
function registerfriendlyfiredelay(dvarstring, defaultvalue, minvalue, maxvalue) {
    dvarstring = "scr_" + dvarstring + "_friendlyFireDelayTime";
    if (getdvarstring(dvarstring) == "") {
        setdvar(dvarstring, defaultvalue);
    }
    if (getdvarint(dvarstring) > maxvalue) {
        setdvar(dvarstring, maxvalue);
    } else if (getdvarint(dvarstring) < minvalue) {
        setdvar(dvarstring, minvalue);
    }
    level.friendlyfiredelaytime = getdvarint(dvarstring);
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x5a5e1360, Offset: 0xa920
// Size: 0x90
function checkroundswitch() {
    if (!isdefined(level.roundswitch) || !level.roundswitch) {
        return false;
    }
    if (!isdefined(level.onroundswitch)) {
        return false;
    }
    /#
        assert(game["g_gametype"] > 0);
    #/
    if (game["roundsplayed"] % level.roundswitch == 0) {
        [[ level.onroundswitch ]]();
        return true;
    }
    return false;
}

// Namespace globallogic
// Params 0, eflags: 0x1 linked
// Checksum 0x39069411, Offset: 0xa9b8
// Size: 0x4c
function listenforgameend() {
    self endon(#"hash_ae13f274");
    self waittill(#"host_sucks_end_game");
    level.skipvote = 1;
    if (!level.gameended) {
        level thread forceend(1);
    }
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0x6e9c3be6, Offset: 0xaa10
// Size: 0x10c
function getkillstreaks(player) {
    for (killstreaknum = 0; killstreaknum < level.maxkillstreaks; killstreaknum++) {
        killstreak[killstreaknum] = "killstreak_null";
    }
    if (isplayer(player) && !level.oldschool && level.disableclassselection != 1 && isdefined(player.killstreak)) {
        currentkillstreak = 0;
        for (killstreaknum = 0; killstreaknum < level.maxkillstreaks; killstreaknum++) {
            if (isdefined(player.killstreak[killstreaknum])) {
                killstreak[currentkillstreak] = player.killstreak[killstreaknum];
                currentkillstreak++;
            }
        }
    }
    return killstreak;
}

// Namespace globallogic
// Params 1, eflags: 0x1 linked
// Checksum 0x43d67cdf, Offset: 0xab28
// Size: 0xbc
function updaterankedmatch(winner) {
    if (level.rankedmatch) {
        if (hostidledout()) {
            level.hostforcedend = 1;
            /#
                print("g_gametype");
            #/
            endlobby();
        }
    }
    if (!level.wagermatch && !sessionmodeiszombiesgame() && !(isdefined(level.var_f0ca204d) && level.var_f0ca204d)) {
        globallogic_score::updatematchbonusscores(winner);
    }
}

