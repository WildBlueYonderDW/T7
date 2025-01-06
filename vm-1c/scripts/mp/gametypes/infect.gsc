#using scripts/mp/_teamops;
#using scripts/mp/_util;
#using scripts/mp/bots/_bot;
#using scripts/mp/gametypes/_globallogic;
#using scripts/mp/gametypes/_globallogic_audio;
#using scripts/mp/gametypes/_globallogic_score;
#using scripts/mp/gametypes/_globallogic_spawn;
#using scripts/mp/gametypes/_globallogic_ui;
#using scripts/mp/gametypes/_loadout;
#using scripts/mp/gametypes/_spawning;
#using scripts/mp/gametypes/_spawnlogic;
#using scripts/mp/gametypes/_spectating;
#using scripts/mp/gametypes/_wager;
#using scripts/mp/teams/_teams;
#using scripts/shared/abilities/_ability_util;
#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/gameobjects_shared;
#using scripts/shared/hostmigration_shared;
#using scripts/shared/hud_util_shared;
#using scripts/shared/math_shared;
#using scripts/shared/scoreevents_shared;
#using scripts/shared/sound_shared;
#using scripts/shared/util_shared;

#namespace infect;

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xafd82ede, Offset: 0xa18
// Size: 0xb58
function main() {
    globallogic::init();
    level.var_f817b02b = 1;
    level.var_b7bd625 = getweapon("pistol_standard");
    level.var_55c74d4a = getweapon("melee_boneglass");
    level.var_6fd3f827 = getweapon("hatchet");
    util::registerroundswitch(0, 9);
    util::registertimelimit(0, 1440);
    util::registerscorelimit(0, 50000);
    util::registerroundlimit(0, 10);
    util::registerroundwinlimit(0, 10);
    util::registernumlives(0, 100);
    globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
    level.scoreroundwinbased = getgametypesetting("cumulativeRoundScores") == 0;
    level.teamscoreperkill = getgametypesetting("teamScorePerKill");
    level.teamscoreperdeath = getgametypesetting("teamScorePerDeath");
    level.teamscoreperheadshot = getgametypesetting("teamScorePerHeadshot");
    level.teambased = 1;
    level.overrideteamscore = 1;
    level.onstartgametype = &onstartgametype;
    level.onendgame = &onendgame;
    level.onspawnplayer = &onspawnplayer;
    level.onroundendgame = &onroundendgame;
    level.onroundswitch = &onroundswitch;
    level.onplayerkilled = &onplayerkilled;
    level.var_859df572 = &function_859df572;
    level.gettimelimit = &gettimelimit;
    level.var_ad0ac054 = &function_e7129db9;
    callback::on_connect(&onplayerconnect);
    callback::on_disconnect(&onplayerdisconnect);
    callback::on_joined_team(&onplayerjoinedteam);
    callback::on_joined_spectate(&function_27abe9eb);
    gameobjects::register_allowed_gameobject(level.gametype);
    if (!sessionmodeissystemlink() && !sessionmodeisonlinegame() && issplitscreen()) {
        globallogic::setvisiblescoreboardcolumns("score", "kills", "infects", "deaths", "assists");
    } else {
        globallogic::setvisiblescoreboardcolumns("score", "kills", "deaths", "infects", "assists");
    }
    level.givecustomloadout = &givecustomloadout;
    level.var_485556b = &function_485556b;
    level.ontimelimit = &ontimelimit;
    level.var_355e787 = &function_355e787;
    var_ad774848 = [];
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_longersprint";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_quieter";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_loudenemies";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_movefaster";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_jetnoradar";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_jetquiet";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_fallheight";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_fastladderclimb";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_fastmantle";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_fastreload";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_detectexplosive";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_bulletaccuracy";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_stalker";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_jetcharger";
    if (!isdefined(var_ad774848)) {
        var_ad774848 = [];
    } else if (!isarray(var_ad774848)) {
        var_ad774848 = array(var_ad774848);
    }
    var_ad774848[var_ad774848.size] = "specialty_overcharge";
    level.var_ad774848 = var_ad774848;
    var_206b5e08 = [];
    if (!isdefined(var_206b5e08)) {
        var_206b5e08 = [];
    } else if (!isarray(var_206b5e08)) {
        var_206b5e08 = array(var_206b5e08);
    }
    var_206b5e08[var_206b5e08.size] = "gadget_camo";
    if (!isdefined(var_206b5e08)) {
        var_206b5e08 = [];
    } else if (!isarray(var_206b5e08)) {
        var_206b5e08 = array(var_206b5e08);
    }
    var_206b5e08[var_206b5e08.size] = "gadget_clone";
    if (!isdefined(var_206b5e08)) {
        var_206b5e08 = [];
    } else if (!isarray(var_206b5e08)) {
        var_206b5e08 = array(var_206b5e08);
    }
    var_206b5e08[var_206b5e08.size] = "gadget_armor";
    level.var_206b5e08 = var_206b5e08;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x5b2e1f9e, Offset: 0x1578
// Size: 0x474
function onstartgametype() {
    setclientnamemode("auto_change");
    game["defenders"] = "allies";
    game["attackers"] = "axis";
    if (!isdefined(game["switchedsides"])) {
        game["switchedsides"] = 0;
    }
    if (game["switchedsides"]) {
        oldattackers = game["attackers"];
        olddefenders = game["defenders"];
        game["attackers"] = olddefenders;
        game["defenders"] = oldattackers;
    }
    level.displayroundendtext = 0;
    spawning::create_map_placed_influencers();
    level.spawnmins = (0, 0, 0);
    level.spawnmaxs = (0, 0, 0);
    foreach (team in level.teams) {
        util::setobjectivetext(team, %OBJECTIVES_INFECT);
        util::setobjectivehinttext(team, %OBJECTIVES_INFECT_HINT);
        util::setobjectivescoretext(team, %OBJECTIVES_INFECT);
        spawnlogic::add_spawn_points(team, "mp_tdm_spawn");
        spawnlogic::place_spawn_points(spawning::gettdmstartspawnname(team));
    }
    spawning::updateallspawnpoints();
    level.spawn_start = [];
    foreach (team in level.teams) {
        level.spawn_start[team] = spawnlogic::get_spawnpoint_array(spawning::gettdmstartspawnname(team));
    }
    level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
    setmapcenter(level.mapcenter);
    spawnpoint = spawnlogic::get_random_intermission_point();
    setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
    if (!util::isoneround()) {
        level.displayroundendtext = 1;
        if (level.scoreroundwinbased) {
            globallogic_score::resetteamscores();
        }
    }
    level.infect_chosefirstinfected = 0;
    level.infect_choosingfirstinfected = 0;
    level.infect_allowsuicide = 0;
    level.infect_awardedfinalsurvivor = 0;
    level.infect_players = [];
    inithud();
    /#
        level thread function_897ac191();
    #/
    maxfree = getdvarint("bot_maxFree", 0);
    level thread bot::monitor_bot_population(maxfree);
    level thread function_d07961fd();
    level thread function_938d075f();
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x4247367c, Offset: 0x19f8
// Size: 0x54
function function_8dde4d1f() {
    function_f72d8c1c(game["attackers"], "MPUI_INFECTED");
    function_f72d8c1c(game["defenders"], "MPUI_SURVIVORS");
}

// Namespace infect
// Params 2, eflags: 0x0
// Checksum 0x28d5139e, Offset: 0x1a58
// Size: 0x6c
function function_f72d8c1c(team, name) {
    var_19719540 = "g_customTeamName_" + team;
    if (getdvarstring(var_19719540) == "") {
        setdvar(var_19719540, name);
    }
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0x92b36a79, Offset: 0x1ad0
// Size: 0x4c
function onendgame(winningteam) {
    if (!util::isoneround() && !util::islastround()) {
        function_22765af9(winningteam);
    }
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0xbd470088, Offset: 0x1b28
// Size: 0x1b6
function function_22765af9(winningteam) {
    players = level.players;
    for (i = 0; i < players.size; i++) {
        if (!isdefined(players[i].pers["team"])) {
            continue;
        }
        if (level.hostforcedend && players[i] ishost()) {
            continue;
        }
        if (winningteam == "tie") {
            globallogic_score::updatetiestats(players[i]);
            continue;
        }
        if (players[i].pers["team"] == winningteam) {
            globallogic_score::updatewinstats(players[i]);
            continue;
        }
        if (level.rankedmatch && !level.leaguematch && players[i].pers["lateJoin"] === 1) {
            globallogic_score::updatelosslatejoinstats(players[i]);
        }
        if (!level.disablestattracking) {
            players[i] setdstat("playerstatslist", "cur_win_streak", "StatValue", 0);
        }
    }
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xb4704ece, Offset: 0x1ce8
// Size: 0x150
function inithud() {
    level.var_796fada2 = hud::createservertimer("objective", 1.5);
    level.var_796fada2 hud::setpoint("CENTER", undefined, 0, 50);
    level.var_796fada2.label = %MP_DRAFT_STARTS_IN;
    level.var_796fada2.alpha = 0;
    level.var_796fada2.archived = 0;
    level.var_796fada2.hidewheninmenu = 1;
    level.var_a3c7456d = hud::createserverfontstring("objective", 1.5);
    level.var_a3c7456d hud::setpoint("CENTER", undefined, 0, 50);
    level.var_a3c7456d.label = %MP_INFECTED_TIME_EXTENDED;
    level.var_a3c7456d.alpha = 0;
    level.var_a3c7456d.archived = 0;
    level.var_a3c7456d.hidewheninmenu = 1;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xa6262f55, Offset: 0x1e40
// Size: 0x94
function onplayerconnect() {
    self.var_e8432f46 = 1;
    self.var_10054897 = level.inprematchperiod;
    if (self.sessionteam != "spectator") {
        self.pers["needteam"] = 1;
    }
    playerxuid = self getxuid();
    if (isdefined(level.infect_players[playerxuid])) {
        self.var_1df9e01d = 1;
    }
    self.var_d1d70226 = 1;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x38aaf0da, Offset: 0x1ee0
// Size: 0x36
function onplayerjoinedteam() {
    if (self.team == game["attackers"]) {
        self.disableclassselection = 1;
        return;
    }
    self.disableclassselection = undefined;
}

// Namespace infect
// Params 2, eflags: 0x0
// Checksum 0x9622193c, Offset: 0x1f20
// Size: 0x100
function function_485556b(player, comingfrommenu) {
    if (!comingfrommenu && player.sessionteam == "spectator") {
        teamname = "spectator";
    } else if (isdefined(level.var_8d48cf10) && level.var_8d48cf10) {
        level.var_8d48cf10 = undefined;
        teamname = game["defenders"];
        level thread function_93f386c5();
    } else if (isdefined(level.infect_chosefirstinfected) && (isdefined(player.var_1df9e01d) && player.var_1df9e01d || level.infect_chosefirstinfected)) {
        teamname = game["attackers"];
    } else {
        teamname = game["defenders"];
    }
    return teamname;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x2f36875e, Offset: 0x2028
// Size: 0x58
function function_dc5fbf33() {
    started_waiting = gettime();
    while (!self isstreamerready(-1, 1) && started_waiting + 90000 > gettime()) {
        wait 0.05;
    }
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0x60cf97d9, Offset: 0x2088
// Size: 0xbc
function onspawnplayer(predictedspawn) {
    if (level.usestartspawns && !level.ingraceperiod && !level.playerqueuedrespawn) {
        level.usestartspawns = 0;
    }
    updateteamscores();
    if (self.team == game["attackers"]) {
        function_e834578f();
    }
    if (!level.infect_choosingfirstinfected) {
        level.infect_choosingfirstinfected = 1;
        level thread choosefirstinfected();
    }
    spawning::onspawnplayer(predictedspawn);
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xc2f18977, Offset: 0x2150
// Size: 0x1c
function onroundswitch() {
    game["switchedsides"] = !game["switchedsides"];
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0xa2162bff, Offset: 0x2178
// Size: 0xb6
function onroundendgame(roundwinner) {
    if (level.scoreroundwinbased) {
        foreach (team in level.teams) {
            [[ level._setteamscore ]](team, game["roundswon"][team]);
        }
    }
    return [[ level.determinewinner ]]();
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x7e3c9270, Offset: 0x2238
// Size: 0x18
function function_b3349c22() {
    return self.pers["time_played_moving"] > 0;
}

// Namespace infect
// Params 3, eflags: 0x0
// Checksum 0x51dd4a1e, Offset: 0x2258
// Size: 0xda
function function_40cc7792(team, var_eb4caf58, calloutplayer) {
    players = function_dd68b18b(team);
    foreach (player in players) {
        player luinotifyevent(%player_callout, 2, var_eb4caf58, calloutplayer);
    }
}

// Namespace infect
// Params 9, eflags: 0x0
// Checksum 0x785dda9d, Offset: 0x2340
// Size: 0x234
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration) {
    processkill = 0;
    wassuicide = 0;
    if (self.team == game["defenders"] && isdefined(attacker)) {
        if (level.friendlyfire > 0 && isdefined(attacker.team) && attacker.team == self.team) {
            processkill = 0;
        } else if (isplayer(attacker) && attacker != self) {
            processkill = 1;
        } else if (attacker == self || level.infect_allowsuicide && !isplayer(attacker)) {
            processkill = 1;
            wassuicide = 1;
        }
    }
    if (!processkill) {
        return;
    }
    if (!wassuicide) {
        scoreevents::processscoreevent("infected_survivor", attacker, self, weapon);
        if (isdefined(attacker.pers["infects"])) {
            attacker.pers["infects"] = attacker.pers["infects"] + 1;
            attacker.infects = attacker.pers["infects"];
        }
        attacker addplayerstatwithgametype("INFECTS", 1);
    }
    level thread function_e523aca(self, wassuicide);
}

// Namespace infect
// Params 2, eflags: 0x0
// Checksum 0x827f4a8d, Offset: 0x2580
// Size: 0x2d4
function function_e523aca(victim, wassuicide) {
    level endon(#"game_ended");
    waittillframeend();
    if (isdefined(victim.laststand)) {
        result = victim function_a27aff1a();
        if (result === "player_input_revive") {
            return;
        }
    }
    wait 0.05;
    if (isdefined(victim)) {
        level thread function_34c8bd01();
        function_f65059ce(victim);
        function_e834578f();
    }
    var_7dc99dab = [[ level._getteamscore ]](game["defenders"]);
    if (var_7dc99dab > 1 && isdefined(victim)) {
        sound::play_on_players("mpl_flagget_sting_enemy", game["defenders"]);
        sound::play_on_players("mpl_flagget_sting_friend", game["attackers"]);
        function_40cc7792(game["defenders"], %MP_GOT_INFECTED, victim.entnum);
        if (!wassuicide) {
            function_40cc7792(game["attackers"], %SCORE_INFECTED_SURVIVOR, victim.entnum);
            survivors = function_dd68b18b(game["defenders"]);
            foreach (survivor in survivors) {
                if (survivor != victim && survivor function_b3349c22()) {
                    survivor scoreevents::processscoreevent("survivor_still_alive", survivor);
                }
            }
        }
        return;
    }
    if (var_7dc99dab == 1) {
        onfinalsurvivor();
        return;
    }
    if (var_7dc99dab == 0) {
        onsurvivorseliminated();
    }
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xc9a10a9e, Offset: 0x2860
// Size: 0x3a
function function_a27aff1a() {
    level endon(#"game_ended");
    self endon(#"disconnect");
    return self util::waittill_any_return("player_input_revive", "death");
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xe4dcdbd, Offset: 0x28a8
// Size: 0x160
function onfinalsurvivor() {
    if (isdefined(level.var_c1bb459e) && level.var_c1bb459e) {
        return;
    }
    sound::play_on_players("mpl_ballreturn_sting");
    finalsurvivor = function_dd68b18b(game["defenders"])[0];
    if (!level.infect_awardedfinalsurvivor) {
        finalsurvivor function_d24c1b2e();
        if (finalsurvivor.var_10054897 && finalsurvivor function_b3349c22()) {
            finalsurvivor scoreevents::processscoreevent("final_survivor", finalsurvivor);
        }
        level.infect_awardedfinalsurvivor = 1;
    }
    luinotifyevent(%player_callout, 2, %SCORE_FINAL_SURVIVOR, finalsurvivor.entnum);
    var_e8414f44 = getdvarint("scr_infect_finaluav");
    if (var_e8414f44) {
        level thread finalsurvivoruav(finalsurvivor);
    }
    level.var_c1bb459e = 1;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x8dbf3628, Offset: 0x2a10
// Size: 0x7c
function function_d24c1b2e() {
    if (!isdefined(self.heroweapon)) {
        return;
    }
    var_16c7dd95 = self gadgetgetslot(self.heroweapon);
    if (self gadgetisready(var_16c7dd95)) {
        return;
    }
    self gadgetpowerset(var_16c7dd95, 100);
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0x6e62328f, Offset: 0x2a98
// Size: 0x22e
function finalsurvivoruav(finalsurvivor) {
    level endon(#"game_ended");
    finalsurvivor endon(#"disconnect");
    finalsurvivor endon(#"death");
    level endon(#"hash_be948b8c");
    level thread enduavonlatejoiner(finalsurvivor);
    setteamspyplane(game["attackers"], 1);
    util::set_team_radar(game["attackers"], 1);
    removeuav = 0;
    while (true) {
        prevpos = finalsurvivor.origin;
        wait 4;
        if (removeuav) {
            setteamspyplane(game["attackers"], 0);
            util::set_team_radar(game["attackers"], 0);
            removeuav = 0;
        }
        wait 6;
        if (distancesquared(prevpos, finalsurvivor.origin) < -56 * -56) {
            setteamspyplane(game["attackers"], 1);
            util::set_team_radar(game["attackers"], 1);
            removeuav = 1;
            foreach (player in level.players) {
                sound::play_on_players("fly_hunter_raise_plr");
            }
        }
    }
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0xd6d39d3c, Offset: 0x2cd0
// Size: 0xd4
function enduavonlatejoiner(finalsurvivor) {
    level endon(#"game_ended");
    finalsurvivor endon(#"disconnect");
    finalsurvivor endon(#"death");
    while (true) {
        var_7dc99dab = [[ level._getteamscore ]](game["defenders"]);
        if (var_7dc99dab > 1) {
            level notify(#"hash_be948b8c");
            wait 0.05;
            setteamspyplane(game["attackers"], 1);
            util::set_team_radar(game["attackers"], 1);
            break;
        }
        wait 0.05;
    }
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x6e8ba4ac, Offset: 0x2db0
// Size: 0x4c
function ontimelimit() {
    winner = game["defenders"];
    level thread endgame(winner, game["strings"]["time_limit_reached"]);
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x82168c2f, Offset: 0x2e08
// Size: 0x84
function onsurvivorseliminated() {
    updateteamscores();
    winner = game["attackers"];
    loser = util::getotherteam(winner);
    level thread endgame(winner, game["strings"][loser + "_eliminated"]);
}

// Namespace infect
// Params 2, eflags: 0x0
// Checksum 0xab8716dd, Offset: 0x2e98
// Size: 0x64
function endgame(winner, endreasontext) {
    if (isdefined(level.var_15e262e5) && level.var_15e262e5) {
        return;
    }
    level.var_15e262e5 = 1;
    util::wait_network_frame();
    globallogic::endgame(winner, endreasontext);
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x2f2415ff, Offset: 0x2f08
// Size: 0x14
function function_27abe9eb() {
    function_ca9945d6();
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x30fc095b, Offset: 0x2f28
// Size: 0x14
function onplayerdisconnect() {
    function_ca9945d6();
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x98a0f3c7, Offset: 0x2f48
// Size: 0x1f6
function function_ca9945d6() {
    if (isdefined(level.gameended) && level.gameended) {
        return;
    }
    updateteamscores();
    var_9cc4807f = [[ level._getteamscore ]](game["attackers"]);
    var_7dc99dab = [[ level._getteamscore ]](game["defenders"]);
    if (isdefined(self.infect_isbeingchosen) || level.infect_chosefirstinfected) {
        if (var_9cc4807f > 0 && var_7dc99dab > 0) {
            if (var_7dc99dab == 1) {
                onfinalsurvivor();
            }
        } else if (var_7dc99dab == 0) {
            onsurvivorseliminated();
        } else if (var_9cc4807f == 0) {
            if (var_7dc99dab == 1) {
                winner = game["defenders"];
                loser = util::getotherteam(winner);
                level thread endgame(winner, game["strings"][loser + "_eliminated"]);
            } else if (var_7dc99dab > 1) {
                level.infect_chosefirstinfected = 0;
                level thread choosefirstinfected();
            }
        }
        return;
    }
    var_c2df8eb5 = function_d418a8fd(game["defenders"]);
    if (var_c2df8eb5.size < 1) {
        level notify(#"infect_stopCountdown");
    }
}

// Namespace infect
// Params 2, eflags: 0x0
// Checksum 0x5b98eadb, Offset: 0x3148
// Size: 0x96
function givecustomloadout(takeallweapons, alreadyspawned) {
    if (self.team == game["attackers"]) {
        self function_4fe19a2e();
        self.movementspeedmodifier = 1.2;
    } else if (self.team == game["defenders"]) {
        self function_bce75136();
        self.movementspeedmodifier = undefined;
    }
    return self.spawnweapon;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xb5817080, Offset: 0x31e8
// Size: 0x16c
function function_bce75136() {
    loadout::function_79d05183(1);
    loadout::function_1d84af77(self.curclass);
    self setactionslot(3, "altMode");
    self setactionslot(4, "");
    allocationspent = self getloadoutallocation(self.class_num);
    overallocation = allocationspent > level.maxallocation;
    if (!overallocation) {
        giveperks();
        loadout::giveWeapons();
        loadout::givePrimaryOffhand();
    } else {
        loadout::function_a6ea9349();
    }
    loadout::giveSecondaryOffhand();
    if (getdvarint("tu11_enableClassicMode") == 0) {
        loadout::giveSpecialOffhand();
        loadout::giveHeroWeapon();
    }
    loadout::function_66234473();
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x3d1ff8ab, Offset: 0x3360
// Size: 0x1c4
function giveperks() {
    self.specialty = self getloadoutperks(self.class_num);
    if (level.leaguematch) {
        for (i = 0; i < self.specialty.size; i++) {
            if (loadout::function_9afb7ce8(self.specialty[i])) {
                arrayremoveindex(self.specialty, i);
                i--;
            }
        }
    }
    self loadout::register_perks();
    anteup_bonus = getdvarint("perk_killstreakAnteUpResetValue");
    momentum_at_spawn_or_game_end = isdefined(self.pers["momentum_at_spawn_or_game_end"]) ? self.pers["momentum_at_spawn_or_game_end"] : 0;
    var_c95a3982 = !(self.hasdonecombat === 1);
    if (level.ingraceperiod && (level.inprematchperiod || var_c95a3982) && momentum_at_spawn_or_game_end < anteup_bonus) {
        new_momentum = self hasperk("specialty_anteup") ? anteup_bonus : momentum_at_spawn_or_game_end;
        globallogic_score::_setplayermomentum(self, new_momentum, 0);
    }
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x79008762, Offset: 0x3530
// Size: 0x2fe
function function_4fe19a2e() {
    self loadout::function_79d05183(1);
    loadout::function_1d84af77(self.curclass);
    self clearperks();
    foreach (perkname in level.var_ad774848) {
        if (!self hasperk(perkname)) {
            self setperk(perkname);
        }
    }
    var_9cc4807f = [[ level._getteamscore ]](game["attackers"]);
    if (var_9cc4807f == 1) {
        defaultweapon = level.var_b7bd625;
    } else {
        defaultweapon = level.var_55c74d4a;
    }
    self function_84503315(defaultweapon);
    self switchtoweapon(defaultweapon);
    self setspawnweapon(defaultweapon);
    self.spawnweapon = defaultweapon;
    primaryoffhand = level.var_6fd3f827;
    primaryoffhandcount = 1;
    self giveweapon(primaryoffhand);
    self setweaponammostock(primaryoffhand, primaryoffhandcount);
    self switchtooffhand(primaryoffhand);
    self.grenadetypeprimary = primaryoffhand;
    self.grenadetypeprimarycount = primaryoffhandcount;
    secondaryoffhand = getweapon("null_offhand_secondary");
    secondaryoffhandcount = 0;
    self giveweapon(secondaryoffhand);
    self setweaponammoclip(secondaryoffhand, secondaryoffhandcount);
    self switchtooffhand(secondaryoffhand);
    self.grenadetypesecondary = secondaryoffhand;
    self.grenadetypesecondarycount = secondaryoffhandcount;
    self giveweapon(level.weaponbasemelee);
    function_39be730b();
    self.heroweapon = undefined;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xfee6e2d, Offset: 0x3838
// Size: 0x158
function function_39be730b() {
    specialoffhand = self.var_55849a30;
    var_a664ae9a = 0;
    if (!isdefined(specialoffhand)) {
        var_9a4ea9ec = array::random(level.var_206b5e08);
        specialoffhand = getweapon(var_9a4ea9ec);
        var_a664ae9a = 1;
    }
    specialoffhandcount = specialoffhand.startammo;
    self giveweapon(specialoffhand);
    self setweaponammoclip(specialoffhand, specialoffhandcount);
    self switchtooffhand(specialoffhand);
    self.var_66cb8722 = specialoffhand;
    self.var_877b90bf = specialoffhandcount;
    if (isdefined(var_a664ae9a) && var_a664ae9a) {
        slot = self gadgetgetslot(specialoffhand);
        self gadgetpowerreset(slot);
    }
    self.var_55849a30 = specialoffhand;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x44fe2986, Offset: 0x3998
// Size: 0x164
function choosefirstinfected() {
    level endon(#"game_ended");
    level endon(#"infect_stopCountdown");
    level.infect_allowsuicide = 0;
    level.var_93e2155b = undefined;
    if (level.inprematchperiod) {
        level waittill(#"prematch_over");
    }
    level.var_796fada2.label = %MP_DRAFT_STARTS_IN;
    level.var_796fada2 settimer(8);
    level.var_796fada2.alpha = 1;
    hostmigration::waitlongdurationwithhostmigrationpause(8);
    level.var_796fada2.alpha = 0;
    var_c2df8eb5 = function_d418a8fd(game["defenders"]);
    if (var_c2df8eb5.size > 0) {
        var_c2df8eb5[getarraykeys(var_c2df8eb5)[randomint(getarraykeys(var_c2df8eb5).size)]] setfirstinfected();
        return;
    }
    level.infect_choosingfirstinfected = 0;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xe68ff6c5, Offset: 0x3b08
// Size: 0x80
function function_d07961fd() {
    while (true) {
        event = level util::waittill_any_return("game_ended", "infect_stopCountdown");
        if (isdefined(level.var_796fada2)) {
            level.var_796fada2.alpha = 0;
        }
        if (event == "game_ended") {
            return;
        }
        level.infect_choosingfirstinfected = 0;
    }
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x545a5d88, Offset: 0x3b90
// Size: 0x100
function function_34c8bd01() {
    level notify(#"timeextended");
    level endon(#"game_ended");
    level endon(#"infect_stopTimeExtended");
    level endon(#"timeextended");
    timeout = 0;
    while (isdefined(level.var_796fada2) && level.var_796fada2.alpha > 0) {
        hostmigration::waitlongdurationwithhostmigrationpause(0.5);
        timeout++;
        if (timeout == 20) {
            return;
        }
    }
    level.var_a3c7456d.alpha = 1;
    hostmigration::waitlongdurationwithhostmigrationpause(1);
    level.var_a3c7456d fadeovertime(2);
    level.var_a3c7456d.alpha = 0;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x3c583135, Offset: 0x3c98
// Size: 0x76
function function_938d075f() {
    while (true) {
        event = level util::waittill_any_return("game_ended", "infect_stopTimeExtended");
        if (isdefined(level.var_a3c7456d)) {
            level.var_a3c7456d.alpha = 0;
        }
        if (event == "game_ended") {
            return;
        }
    }
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0xedbd6df9, Offset: 0x3d18
// Size: 0x12c
function function_d418a8fd(team) {
    activeplayers = [];
    teamplayers = function_dd68b18b(team);
    foreach (player in teamplayers) {
        if (player.sessionstate == "spectator") {
            continue;
        }
        if (!isdefined(activeplayers)) {
            activeplayers = [];
        } else if (!isarray(activeplayers)) {
            activeplayers = array(activeplayers);
        }
        activeplayers[activeplayers.size] = player;
    }
    return activeplayers;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x56e9d288, Offset: 0x3e50
// Size: 0x276
function setfirstinfected() {
    self endon(#"disconnect");
    self.infect_isbeingchosen = 1;
    while (!isalive(self) || self util::isusingremote()) {
        wait 0.05;
    }
    if (isdefined(self.iscarrying) && self.iscarrying) {
        self notify(#"hash_ba19385f");
        wait 0.05;
    }
    while (self ismantling()) {
        wait 0.05;
    }
    while (!self isonground() && !self isonladder()) {
        wait 0.05;
    }
    function_f65059ce(self);
    self.switching_teams = undefined;
    if (self isusingoffhand()) {
        self forceoffhandend();
    }
    self disableoffhandspecial();
    self thread function_4c6fd26d();
    loadout::giveloadout(self.team, self.curclass);
    var_7dc99dab = [[ level._getteamscore ]](game["defenders"]);
    if (var_7dc99dab < 1) {
        level.var_8d48cf10 = 1;
    } else {
        forcespawnteam(game["defenders"]);
    }
    luinotifyevent(%player_callout, 2, %SCORE_FIRST_INFECTED, self.entnum);
    scoreevents::processscoreevent("first_infected", self);
    sound::play_on_players("mpl_flagget_sting_enemy");
    level.infect_allowsuicide = 1;
    level.infect_chosefirstinfected = 1;
    self.infect_isbeingchosen = undefined;
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0xa7bb3a49, Offset: 0x40d0
// Size: 0xb2
function forcespawnteam(team) {
    players = function_dd68b18b(team);
    foreach (player in players) {
        player thread playerforcespawn();
    }
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x1c031324, Offset: 0x4190
// Size: 0xe4
function playerforcespawn() {
    level endon(#"game_ended");
    self endon(#"death");
    self endon(#"disconnect");
    self endon(#"spawned");
    if (self.hasspawned) {
        return;
    }
    if (self.pers["team"] == "spectator") {
        return;
    }
    self function_dc5fbf33();
    self.pers["class"] = level.defaultclass;
    self.curclass = level.defaultclass;
    self globallogic_ui::closemenus();
    self closemenu("ChooseClass_InGame");
    self thread [[ level.spawnclient ]]();
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0xf686c2bc, Offset: 0x4280
// Size: 0x7c
function function_f65059ce(player) {
    function_e90123d3(player);
    function_fb693482(player);
    player changeteam(game["attackers"]);
    updateteamscores();
    function_c30d35d6();
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xff19746d, Offset: 0x4308
// Size: 0x4c
function function_4c6fd26d() {
    level endon(#"game_ended");
    self endon(#"disconnect");
    self endon(#"death");
    self waittill(#"weapon_change");
    self enableoffhandspecial();
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0x2f05f359, Offset: 0x4360
// Size: 0x42
function function_e90123d3(player) {
    playerxuid = player getxuid();
    level.infect_players[playerxuid] = 1;
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0x8eee1fc, Offset: 0x43b0
// Size: 0x112
function changeteam(team) {
    if (self.sessionstate != "dead") {
        self.switching_teams = 1;
        self.switchedteamsresetgadgets = 1;
        self.joining_team = team;
        self.leaving_team = self.pers["team"];
    }
    self.pers["team"] = team;
    self.team = team;
    self.pers["weapon"] = undefined;
    self.pers["spawnweapon"] = undefined;
    self.pers["savedmodel"] = undefined;
    self.pers["teamTime"] = undefined;
    self.sessionteam = self.pers["team"];
    self globallogic_ui::updateobjectivetext();
    self spectating::set_permissions();
    self notify(#"end_respawn");
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0x2c0745a1, Offset: 0x44d0
// Size: 0x144
function function_dd68b18b(team) {
    playersonteam = [];
    foreach (player in level.players) {
        if (!isdefined(player)) {
            continue;
        }
        playerteam = player.pers["team"];
        if (isdefined(playerteam) && isdefined(level.teams[playerteam]) && playerteam == team) {
            if (!isdefined(playersonteam)) {
                playersonteam = [];
            } else if (!isarray(playersonteam)) {
                playersonteam = array(playersonteam);
            }
            playersonteam[playersonteam.size] = player;
        }
    }
    return playersonteam;
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0x9b4c05ac, Offset: 0x4620
// Size: 0x36
function function_bf7761ac(team) {
    playersonteam = function_dd68b18b(team);
    return playersonteam.size;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x4e9657e2, Offset: 0x4660
// Size: 0x44
function updateteamscores() {
    updateteamscore(game["attackers"]);
    updateteamscore(game["defenders"]);
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0xe66a1aaa, Offset: 0x46b0
// Size: 0x5c
function updateteamscore(team) {
    score = function_bf7761ac(team);
    game["teamScores"][team] = score;
    globallogic_score::updateteamscores(team);
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0xb03655b9, Offset: 0x4718
// Size: 0x2c
function function_355e787(weapon) {
    if (self.team === game["attackers"]) {
        return false;
    }
    return true;
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0xbc017bd2, Offset: 0x4750
// Size: 0x68
function function_84503315(weapon) {
    self giveweapon(weapon);
    self givestartammo(weapon);
    self setblockweaponpickup(weapon, 1);
    self.var_9ac00079 = weapon;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x3d851ff3, Offset: 0x47c0
// Size: 0x16a
function function_e834578f() {
    attackers = function_dd68b18b(game["attackers"]);
    if (attackers.size < 2) {
        return;
    }
    foreach (player in attackers) {
        if (!isalive(player)) {
            continue;
        }
        if (player.var_9ac00079 !== level.var_55c74d4a) {
            if (isdefined(player.var_9ac00079)) {
                player takeweapon(player.var_9ac00079);
            }
            newweapon = level.var_55c74d4a;
            player function_84503315(newweapon);
            player switchtoweapon(newweapon);
        }
    }
}

// Namespace infect
// Params 2, eflags: 0x0
// Checksum 0x8a2eb012, Offset: 0x4938
// Size: 0x3c
function function_859df572(weapon, var_a76a1b22) {
    if (weapon == self.grenadetypeprimary || weapon == self.grenadetypesecondary) {
        return 0;
    }
    return var_a76a1b22;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xa14eeba0, Offset: 0x4980
// Size: 0x10
function function_c30d35d6() {
    level.var_93e2155b = gettime();
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0x15e45848, Offset: 0x4998
// Size: 0x92
function gettimelimit() {
    defaulttimelimit = getgametypesetting("timeLimit");
    if (defaulttimelimit == 0) {
        return 0;
    }
    if (!isdefined(level.var_93e2155b)) {
        return 0;
    }
    var_22ff0aac = (level.var_93e2155b - level.starttime + 1000) / 60000;
    timelimit = var_22ff0aac + defaulttimelimit;
    return timelimit;
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0xc1f76bed, Offset: 0x4a38
// Size: 0xde
function function_fb693482(player) {
    for (i = 0; i < level.missileentities.size; i++) {
        item = level.missileentities[i];
        if (!isdefined(item)) {
            continue;
        }
        if (!isdefined(item.weapon)) {
            continue;
        }
        if (item.owner !== player && item.originalowner !== player) {
            continue;
        }
        item notify(#"detonating");
        if (isdefined(item)) {
            item delete();
        }
    }
}

// Namespace infect
// Params 8, eflags: 0x0
// Checksum 0xad940572, Offset: 0x4b20
// Size: 0x284
function function_c17c938d(winner, endtype, endreasontext, outcometext, team, winnerenum, notifyroundendtoui, matchbonus) {
    if (endtype == "roundend") {
        if (winner == "tie") {
            outcometext = game["strings"]["draw"];
        } else if (isdefined(self.pers["team"]) && winner == team) {
            outcometext = game["strings"]["victory"];
            overridespectator = 1;
        } else {
            outcometext = game["strings"]["defeat"];
            if ((level.rankedmatch || level.leaguematch) && self.pers["lateJoin"] === 1) {
                endreasontext = game["strings"]["join_in_progress_loss"];
            }
            overridespectator = 1;
        }
        notifyroundendtoui = 0;
        if (team == "spectator" && overridespectator) {
            foreach (team in level.teams) {
                if (endreasontext == game["strings"][team + "_eliminated"]) {
                    endreasontext = game["strings"]["cod_caster_team_eliminated"];
                    break;
                }
            }
            outcometext = game["strings"]["cod_caster_team_wins"];
        }
        self luinotifyevent(%show_outcome, 5, outcometext, endreasontext, int(matchbonus), winnerenum, notifyroundendtoui);
        return true;
    }
    return false;
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0x5f6d2f58, Offset: 0x4db0
// Size: 0x6c
function function_7ce7fbed(player) {
    if (player.team === game["attackers"]) {
        playerweapon = player getcurrentweapon();
        if (isdefined(playerweapon.worldmodel)) {
            return playerweapon;
        }
    }
    return undefined;
}

// Namespace infect
// Params 0, eflags: 0x0
// Checksum 0xe6f397bf, Offset: 0x4e28
// Size: 0x4c
function function_93f386c5() {
    level endon(#"game_ended");
    level notify(#"hash_10030d46");
    level endon(#"hash_10030d46");
    wait 30;
    forcespawnteam(game["defenders"]);
}

// Namespace infect
// Params 1, eflags: 0x0
// Checksum 0x53e2b0fa, Offset: 0x4e80
// Size: 0x2c
function function_e7129db9(weaponitem) {
    weaponitem hidefromteam(game["attackers"]);
}

/#

    // Namespace infect
    // Params 2, eflags: 0x0
    // Checksum 0xabd69782, Offset: 0x4eb8
    // Size: 0x134
    function function_fb550fe9(dvarname, var_c0c93d2) {
        setdvar(dvarname, "<dev string:x28>");
        while (true) {
            wait 0.05;
            dvarvalue = getdvarstring(dvarname);
            if (dvarvalue == "<dev string:x28>") {
                continue;
            }
            setdvar(dvarname, "<dev string:x28>");
            tokens = strtok(dvarvalue, "<dev string:x29>");
            if (!isdefined(tokens) || tokens.size < 1) {
                continue;
            }
            command = tokens[0];
            arrayremoveindex(tokens, 1);
            [[ var_c0c93d2 ]](command, tokens);
        }
    }

    // Namespace infect
    // Params 2, eflags: 0x0
    // Checksum 0x603c7c15, Offset: 0x4ff8
    // Size: 0xe2
    function function_27ccd53(command, args) {
        switch (command) {
        case "<dev string:x2b>":
            foreach (player in level.players) {
                if (player util::is_bot()) {
                    player kill();
                }
            }
            break;
        default:
            break;
        }
    }

    // Namespace infect
    // Params 0, eflags: 0x0
    // Checksum 0x90f50a9, Offset: 0x50e8
    // Size: 0xa4
    function function_897ac191() {
        level thread function_fb550fe9("<dev string:x38>", &function_27ccd53);
        level flag::wait_till("<dev string:x4a>");
        var_126022b3 = "<dev string:x5e>";
        adddebugcommand(var_126022b3 + "<dev string:x74>" + "<dev string:x82>" + "<dev string:x38>" + "<dev string:x8a>");
    }

#/
