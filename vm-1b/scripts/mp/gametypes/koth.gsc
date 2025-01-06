#using scripts/mp/_challenges;
#using scripts/mp/_util;
#using scripts/mp/gametypes/_battlechatter;
#using scripts/mp/gametypes/_globallogic;
#using scripts/mp/gametypes/_globallogic_audio;
#using scripts/mp/gametypes/_globallogic_score;
#using scripts/mp/gametypes/_globallogic_utils;
#using scripts/mp/gametypes/_hostmigration;
#using scripts/mp/gametypes/_spawning;
#using scripts/mp/gametypes/_spawnlogic;
#using scripts/shared/callbacks_shared;
#using scripts/shared/challenges_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/demo_shared;
#using scripts/shared/gameobjects_shared;
#using scripts/shared/hostmigration_shared;
#using scripts/shared/hud_util_shared;
#using scripts/shared/math_shared;
#using scripts/shared/medals_shared;
#using scripts/shared/popups_shared;
#using scripts/shared/scoreevents_shared;
#using scripts/shared/sound_shared;
#using scripts/shared/util_shared;

#namespace koth;

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xcacb83c0, Offset: 0x948
// Size: 0x349
function main() {
    globallogic::init();
    util::registertimelimit(0, 1440);
    util::registerscorelimit(0, 1000);
    util::registernumlives(0, 100);
    util::registerroundswitch(0, 9);
    util::registerroundwinlimit(0, 10);
    globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
    level.teambased = 1;
    level.doprematch = 1;
    level.overrideteamscore = 1;
    level.scoreroundwinbased = 1;
    level.kothstarttime = 0;
    level.onstartgametype = &onstartgametype;
    level.playerspawnedcb = &koth_playerspawnedcb;
    level.onroundswitch = &onroundswitch;
    level.onplayerkilled = &onplayerkilled;
    level.onendgame = &onendgame;
    clientfield::register("world", "hardpoint", 1, 5, "int");
    clientfield::register("world", "hardpointteam", 1, 5, "int");
    level.zoneautomovetime = getgametypesetting("autoDestroyTime");
    level.zonespawntime = getgametypesetting("objectiveSpawnTime");
    level.kothmode = getgametypesetting("kothMode");
    level.capturetime = getgametypesetting("captureTime");
    level.destroytime = getgametypesetting("destroyTime");
    level.delayplayer = getgametypesetting("delayPlayer");
    level.randomzonespawn = getgametypesetting("randomObjectiveLocations");
    level.scoreperplayer = getgametypesetting("scorePerPlayer");
    level.timepauseswheninzone = getgametypesetting("timePausesWhenInZone");
    level.iconoffset = (0, 0, 32);
    level.onrespawndelay = &getrespawndelay;
    gameobjects::register_allowed_gameobject(level.gametype);
    globallogic_audio::set_leader_gametype_dialog("startHardPoint", "hcStartHardPoint", "objCapture", "objCapture");
    InvalidOpCode(0xc8, "objective_gained_sound", "mpl_flagcapture_sting_friend");
    // Unknown operator (0xc8, t7_1b, PC)
}

// Namespace koth
// Params 3, eflags: 0x0
// Checksum 0x37ee987d, Offset: 0xdd0
// Size: 0x9d
function updateobjectivehintmessages(defenderteam, defendmessage, attackmessage) {
    var_4ea232a9 = level.teams;
    var_cc48158f = firstarray(var_4ea232a9);
    if (isdefined(var_cc48158f)) {
        team = var_4ea232a9[var_cc48158f];
        var_e8be53f4 = nextarray(var_4ea232a9, var_cc48158f);
        if (defenderteam == team) {
            InvalidOpCode(0xc8, "strings", "objective_hint_" + team, defendmessage);
            // Unknown operator (0xc8, t7_1b, PC)
        }
        InvalidOpCode(0xc8, "strings", "objective_hint_" + team, attackmessage);
        // Unknown operator (0xc8, t7_1b, PC)
    }
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0x38d34a93, Offset: 0xe78
// Size: 0x6d
function updateobjectivehintmessage(message) {
    var_1e52aa63 = level.teams;
    var_da6c0ba9 = firstarray(var_1e52aa63);
    if (isdefined(var_da6c0ba9)) {
        team = var_1e52aa63[var_da6c0ba9];
        var_a9495612 = nextarray(var_1e52aa63, var_da6c0ba9);
        InvalidOpCode(0xc8, "strings", "objective_hint_" + team, message);
        // Unknown operator (0xc8, t7_1b, PC)
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xfc7b9ddd, Offset: 0xef0
// Size: 0xea
function getrespawndelay() {
    self.var_fc558bd1 = undefined;
    if (!isdefined(level.zone.gameobject)) {
        return undefined;
    }
    zoneowningteam = level.zone.gameobject gameobjects::get_owner_team();
    if (self.pers["team"] == zoneowningteam) {
        if (!isdefined(level.zonemovetime)) {
            return undefined;
        }
        timeremaining = (level.zonemovetime - gettime()) / 1000;
        if (!level.playerobjectiveheldrespawndelay) {
            return undefined;
        }
        if (level.playerobjectiveheldrespawndelay >= level.zoneautomovetime) {
            self.var_fc558bd1 = %MP_WAITING_FOR_HQ;
        }
        if (level.delayplayer) {
            return min(level.spawndelay, timeremaining);
        }
        return ceil(timeremaining);
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x4c5e9e29, Offset: 0xfe8
// Size: 0x71
function onstartgametype() {
    InvalidOpCode(0x54, "switchedsides");
    // Unknown operator (0x54, t7_1b, PC)
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x7dad8b6f, Offset: 0x13d0
// Size: 0x22
function pause_time() {
    if (level.timepauseswheninzone) {
        globallogic_utils::pausetimer();
        level.timerpaused = 1;
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x15fffcfc, Offset: 0x1400
// Size: 0x32
function resume_time() {
    if (level.timepauseswheninzone) {
        globallogic_utils::resumetimerdiscardoverride(level.kothtotalsecondsinzone * 1000);
        level.timerpaused = 0;
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x1ef24eba, Offset: 0x1440
// Size: 0x42
function updategametypedvars() {
    level.playercapturelpm = getgametypesetting("maxPlayerEventsPerMinute");
    level.timepauseswheninzone = getgametypesetting("timePausesWhenInZone");
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0x5018e58, Offset: 0x1490
// Size: 0xfa
function spawn_first_zone(delay) {
    if (level.randomzonespawn == 1) {
        level.zone = getnextzonefromqueue();
    } else {
        level.zone = getfirstzone();
    }
    if (isdefined(level.zone)) {
        /#
            print("<dev string:x68>" + level.zone.trigorigin[0] + "<dev string:x78>" + level.zone.trigorigin[1] + "<dev string:x78>" + level.zone.trigorigin[2] + "<dev string:x7a>");
        #/
        level.zone spawning::enable_influencers(1);
    }
    level.zone.gameobject.trigger allowtacticalinsertion(0);
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xb6da0752, Offset: 0x1598
// Size: 0x11a
function spawn_next_zone() {
    level.zone.gameobject.trigger allowtacticalinsertion(1);
    if (level.randomzonespawn != 0) {
        level.zone = getnextzonefromqueue();
    } else {
        level.zone = getnextzone();
    }
    if (isdefined(level.zone)) {
        /#
            print("<dev string:x68>" + level.zone.trigorigin[0] + "<dev string:x78>" + level.zone.trigorigin[1] + "<dev string:x78>" + level.zone.trigorigin[2] + "<dev string:x7a>");
        #/
        level.zone spawning::enable_influencers(1);
    }
    level.zone.gameobject.trigger allowtacticalinsertion(0);
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xe627a4cf, Offset: 0x16c0
// Size: 0x71
function getnumtouching() {
    numtouching = 0;
    foreach (team in level.teams) {
        numtouching += self.numtouching[team];
    }
    return numtouching;
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0xd7de2784, Offset: 0x1740
// Size: 0x52
function togglezoneeffects(enabled) {
    index = 0;
    if (enabled) {
        index = self.script_index;
    }
    level clientfield::set("hardpoint", index);
    level clientfield::set("hardpointteam", 0);
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x67f7c58, Offset: 0x17a0
// Size: 0x3ed
function kothcaptureloop() {
    level endon(#"game_ended");
    level endon(#"zone_moved");
    level.kothstarttime = gettime();
    while (true) {
        level.zone.gameobject gameobjects::allow_use("any");
        level.zone.gameobject gameobjects::set_use_time(level.capturetime);
        level.zone.gameobject gameobjects::set_use_text(%MP_CAPTURING_OBJECTIVE);
        numtouching = level.zone.gameobject getnumtouching();
        level.zone.gameobject gameobjects::set_visible_team("any");
        level.zone.gameobject gameobjects::set_model_visibility(1);
        level.zone.gameobject gameobjects::must_maintain_claim(0);
        level.zone.gameobject gameobjects::can_contest_claim(1);
        level.zone.gameobject.onuse = &onzonecapture;
        level.zone.gameobject.onbeginuse = &onbeginuse;
        level.zone.gameobject.onenduse = &onenduse;
        level.zone togglezoneeffects(1);
        msg = level util::waittill_any_return("zone_captured", "zone_destroyed");
        if (msg == "zone_destroyed") {
            continue;
        }
        ownerteam = level.zone.gameobject gameobjects::get_owner_team();
        foreach (team in level.teams) {
            updateobjectivehintmessages(ownerteam, level.objectivehintdefendhq, level.objectivehintcapturezone);
        }
        level.zone.gameobject gameobjects::allow_use("none");
        level.zone.gameobject.onuse = undefined;
        level.zone.gameobject.onunoccupied = &onzoneunoccupied;
        level.zone.gameobject.oncontested = &onzonecontested;
        level.zone.gameobject.onuncontested = &onzoneuncontested;
        level waittill(#"zone_destroyed", destroy_team);
        if (!level.kothmode || level.zonedestroyedbytimer) {
            break;
        }
        thread forcespawnteam(ownerteam);
        if (isdefined(destroy_team)) {
            level.zone.gameobject gameobjects::set_owner_team(destroy_team);
            continue;
        }
        level.zone.gameobject gameobjects::set_owner_team("none");
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xc643fe51, Offset: 0x1b98
// Size: 0x5a5
function kothmainloop() {
    level endon(#"game_ended");
    level.var_cf270203 = -100000;
    var_2507fea = %MP_KOTH_AVAILABLE_IN;
    if (level.kothmode) {
        var_fc77e3fd = %MP_HQ_DESPAWN_IN;
        var_4f2352a4 = %MP_KOTH_MOVING_IN;
    } else {
        var_fc77e3fd = %MP_HQ_REINFORCEMENTS_IN;
        var_4f2352a4 = %MP_HQ_DESPAWN_IN;
    }
    spawn_first_zone();
    while (level.inprematchperiod) {
        wait 0.05;
    }
    pause_time();
    wait 5;
    setbombtimer("A", 0);
    setmatchflag("bomb_timer_a", 0);
    thread hidetimerdisplayongameend();
    while (true) {
        resume_time();
        sound::play_on_players("mp_suitcase_pickup");
        globallogic_audio::leader_dialog("kothLocated", undefined, undefined, "gamemode_objective", undefined, "kothActiveDialogBuffer");
        level.zone.gameobject gameobjects::set_model_visibility(1);
        level.var_cf270203 = gettime();
        if (level.zonespawntime) {
            level.zone.gameobject gameobjects::set_visible_team("any");
            level.zone.gameobject gameobjects::set_flags(1);
            updateobjectivehintmessage(level.objectivehintpreparezone);
            setmatchflag("bomb_timer_a", 1);
            setbombtimer("A", int(gettime() + 1000 + level.zonespawntime * 1000));
            wait level.zonespawntime;
            level.zone.gameobject gameobjects::set_flags(0);
            globallogic_audio::leader_dialog("kothOnline", undefined, undefined, "gamemode_objective", undefined, "kothActiveDialogBuffer");
        }
        setmatchflag("bomb_timer_a", 0);
        waittillframeend();
        updateobjectivehintmessage(level.objectivehintcapturezone);
        sound::play_on_players("mpl_hq_cap_us");
        level.zone.gameobject gameobjects::enable_object();
        level.zone.gameobject.capturecount = 0;
        if (level.zoneautomovetime) {
            thread movezoneaftertime(level.zoneautomovetime);
            setmatchflag("bomb_timer_a", 1);
            setbombtimer("A", int(gettime() + 1000 + level.zoneautomovetime * 1000));
        } else {
            level.zonedestroyedbytimer = 0;
        }
        kothcaptureloop();
        ownerteam = level.zone.gameobject gameobjects::get_owner_team();
        if (level.zone.gameobject.capturecount == 1) {
            touchlist = [];
            touchkeys = getarraykeys(level.zone.gameobject.touchlist[ownerteam]);
            for (i = 0; i < touchkeys.size; i++) {
                touchlist[touchkeys[i]] = level.zone.gameobject.touchlist[ownerteam][touchkeys[i]];
            }
            thread give_held_credit(touchlist);
        }
        pause_time();
        level.zone spawning::enable_influencers(0);
        level.zone.gameobject.lastcaptureteam = undefined;
        level.zone.gameobject gameobjects::disable_object();
        level.zone.gameobject gameobjects::allow_use("none");
        level.zone.gameobject gameobjects::set_owner_team("neutral");
        level.zone.gameobject gameobjects::set_model_visibility(0);
        level.zone.gameobject gameobjects::must_maintain_claim(0);
        level.zone togglezoneeffects(0);
        level notify(#"zone_reset");
        setmatchflag("bomb_timer_a", 0);
        spawn_next_zone();
        wait 0.5;
        thread forcespawnteam(ownerteam);
        wait 0.5;
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x380c3657, Offset: 0x2148
// Size: 0x22
function hidetimerdisplayongameend() {
    level waittill(#"game_ended");
    setmatchflag("bomb_timer_a", 0);
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0x4d1f45fd, Offset: 0x2178
// Size: 0x79
function forcespawnteam(team) {
    players = level.players;
    for (i = 0; i < players.size; i++) {
        player = players[i];
        if (!isdefined(player)) {
            continue;
        }
        if (player.pers["team"] == team) {
            player notify(#"force_spawn");
            wait 0.1;
        }
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xb14675c6, Offset: 0x2200
// Size: 0xb2
function updateteamclientfield() {
    ownerteam = self gameobjects::get_owner_team();
    if (isdefined(self.iscontested) && self.iscontested) {
        level clientfield::set("hardpointteam", 3);
        return;
    }
    if (ownerteam == "neutral") {
        level clientfield::set("hardpointteam", 0);
        return;
    }
    if (ownerteam == "allies") {
        level clientfield::set("hardpointteam", 1);
        return;
    }
    level clientfield::set("hardpointteam", 2);
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0x81f3ef9f, Offset: 0x22c0
// Size: 0x82
function onbeginuse(player) {
    ownerteam = self gameobjects::get_owner_team();
    if (ownerteam == "neutral") {
        player thread battlechatter::gametype_specific_battle_chatter("hq_protect", player.pers["team"]);
        return;
    }
    player thread battlechatter::gametype_specific_battle_chatter("hq_attack", player.pers["team"]);
}

// Namespace koth
// Params 3, eflags: 0x0
// Checksum 0x98ab1f15, Offset: 0x2350
// Size: 0x24
function onenduse(team, player, success) {
    player notify(#"event_ended");
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0xb495e1c7, Offset: 0x2380
// Size: 0x360
function onzonecapture(player) {
    capture_team = player.pers["team"];
    capturetime = gettime();
    /#
        print("<dev string:x7c>");
    #/
    pause_time();
    string = %MP_KOTH_CAPTURED_BY;
    level.zone.gameobject.iscontested = 0;
    level.usestartspawns = 0;
    if (!isdefined(self.lastcaptureteam) || self.lastcaptureteam != capture_team) {
        touchlist = [];
        touchkeys = getarraykeys(self.touchlist[capture_team]);
        for (i = 0; i < touchkeys.size; i++) {
            touchlist[touchkeys[i]] = self.touchlist[capture_team][touchkeys[i]];
        }
        thread give_capture_credit(touchlist, string, capturetime, capture_team, self.lastcaptureteam);
    }
    level.kothcapteam = capture_team;
    self gameobjects::set_owner_team(capture_team);
    if (!level.kothmode) {
        self gameobjects::set_use_time(level.destroytime);
    }
    var_2a66bed0 = level.teams;
    var_3138b682 = firstarray(var_2a66bed0);
    if (isdefined(var_3138b682)) {
        team = var_2a66bed0[var_3138b682];
        var_9a15b409 = nextarray(var_2a66bed0, var_3138b682);
        if (team == capture_team) {
            if (!isdefined(self.lastcaptureteam) || self.lastcaptureteam != team) {
                globallogic_audio::leader_dialog("kothSecured", team, undefined, "gamemode_objective", undefined, "kothActiveDialogBuffer");
                for (index = 0; index < level.players.size; index++) {
                    player = level.players[index];
                    if (player.pers["team"] == team) {
                        if (player.lastkilltime + 500 > gettime()) {
                            player challenges::killedlastcontester();
                        }
                    }
                }
            }
            InvalidOpCode(0x54, "objective_gained_sound", team);
            // Unknown operator (0x54, t7_1b, PC)
        }
        if (!isdefined(self.lastcaptureteam)) {
            globallogic_audio::leader_dialog("kothCaptured", team, undefined, "gamemode_objective", undefined, "kothActiveDialogBuffer");
        } else if (self.lastcaptureteam == team) {
            globallogic_audio::leader_dialog("kothLost", team, undefined, "gamemode_objective", undefined, "kothActiveDialogBuffer");
        }
        InvalidOpCode(0x54, "objective_lost_sound", team);
        // Unknown operator (0x54, t7_1b, PC)
    }
    self thread awardcapturepoints(capture_team, self.lastcaptureteam);
    self.capturecount++;
    self.lastcaptureteam = capture_team;
    self gameobjects::must_maintain_claim(1);
    self updateteamclientfield();
    level notify(#"zone_captured");
    level notify("zone_captured" + capture_team);
    player notify(#"event_ended");
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xe9c07cd6, Offset: 0x26e8
// Size: 0x2
function track_capture_time() {
    
}

// Namespace koth
// Params 5, eflags: 0x0
// Checksum 0x5c79ae5a, Offset: 0x26f8
// Size: 0x209
function give_capture_credit(touchlist, string, capturetime, capture_team, lastcaptureteam) {
    wait 0.05;
    util::waittillslowprocessallowed();
    players = getarraykeys(touchlist);
    for (i = 0; i < players.size; i++) {
        player = touchlist[players[i]].player;
        player updatecapsperminute(lastcaptureteam);
        if (!isscoreboosting(player)) {
            player challenges::capturedobjective(capturetime);
            if (level.kothstarttime + 3000 > capturetime && level.kothcapteam == capture_team) {
                scoreevents::processscoreevent("quickly_secure_point", player);
            }
            scoreevents::processscoreevent("koth_secure", player);
            player recordgameevent("capture");
            level thread popups::displayteammessagetoall(string, player);
            if (isdefined(player.pers["captures"])) {
                player.pers["captures"]++;
                player.captures = player.pers["captures"];
            }
            if (level.kothstarttime + 500 > capturetime) {
                player challenges::immediatecapture();
            }
            demo::bookmark("event", gettime(), player);
            player addplayerstatwithgametype("CAPTURES", 1);
            continue;
        }
        /#
            player iprintlnbold("<dev string:x8a>");
        #/
    }
}

// Namespace koth
// Params 2, eflags: 0x0
// Checksum 0x603a650b, Offset: 0x2910
// Size: 0x7b
function give_held_credit(touchlist, team) {
    wait 0.05;
    util::waittillslowprocessallowed();
    players = getarraykeys(touchlist);
    for (i = 0; i < players.size; i++) {
        player = touchlist[players[i]].player;
    }
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0xe1e378b1, Offset: 0x2998
// Size: 0x1e4
function function_b016b8f2(player) {
    var_9394096e = player.pers["team"];
    /#
        print("<dev string:xcf>");
    #/
    scoreevents::processscoreevent("zone_destroyed", player);
    player recordgameevent("destroy");
    player addplayerstatwithgametype("DESTRUCTIONS", 1);
    if (isdefined(player.pers["destructions"])) {
        player.pers["destructions"]++;
        player.destructions = player.pers["destructions"];
    }
    var_523758a7 = %MP_HQ_DESTROYED_BY;
    var_2952248b = %MP_HQ_DESTROYED_BY_ENEMY;
    if (level.kothmode) {
        var_523758a7 = %MP_KOTH_CAPTURED_BY;
        var_2952248b = %MP_KOTH_CAPTURED_BY_ENEMY;
    }
    level thread popups::displayteammessagetoall(var_523758a7, player);
    foreach (team in level.teams) {
        if (team == var_9394096e) {
            globallogic_audio::leader_dialog("koth_secured", team, undefined, "gamemode_objective");
            continue;
        }
        globallogic_audio::leader_dialog("koth_destroyed", team, undefined, "gamemode_objective");
    }
    level notify(#"zone_destroyed", var_9394096e);
    if (level.kothmode) {
        level thread awardcapturepoints(var_9394096e);
    }
    player notify(#"event_ended");
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x71f6fc99, Offset: 0x2b88
// Size: 0x6a
function onzoneunoccupied() {
    level notify(#"zone_destroyed");
    level.kothcapteam = "neutral";
    level.zone.gameobject.wasleftunoccupied = 1;
    level.zone.gameobject.iscontested = 0;
    resume_time();
    self updateteamclientfield();
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x929d09aa, Offset: 0x2c00
// Size: 0xeb
function onzonecontested() {
    zoneowningteam = self gameobjects::get_owner_team();
    self.wascontested = 1;
    self.iscontested = 1;
    self updateteamclientfield();
    resume_time();
    foreach (team in level.teams) {
        if (team == zoneowningteam) {
            InvalidOpCode(0x54, "objective_contested_sound", team);
            // Unknown operator (0x54, t7_1b, PC)
        }
    }
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0xc9949298, Offset: 0x2cf8
// Size: 0x7a
function onzoneuncontested(lastclaimteam) {
    assert(lastclaimteam == level.zone.gameobject gameobjects::get_owner_team());
    self.iscontested = 0;
    pause_time();
    self gameobjects::set_claim_team(lastclaimteam);
    self updateteamclientfield();
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0x4abb6af4, Offset: 0x2d80
// Size: 0xeb
function movezoneaftertime(time) {
    level endon(#"game_ended");
    level endon(#"zone_reset");
    level.zonemovetime = gettime() + time * 1000;
    level.zonedestroyedbytimer = 0;
    wait time;
    if (!isdefined(level.zone.gameobject.wascontested) || level.zone.gameobject.wascontested == 0) {
        if (!isdefined(level.zone.gameobject.wasleftunoccupied) || level.zone.gameobject.wasleftunoccupied == 0) {
            zoneowningteam = level.zone.gameobject gameobjects::get_owner_team();
            challenges::controlzoneentirely(zoneowningteam);
        }
    }
    level.zonedestroyedbytimer = 1;
    level notify(#"zone_moved");
}

// Namespace koth
// Params 2, eflags: 0x0
// Checksum 0xd17f1c62, Offset: 0x2e78
// Size: 0x187
function awardcapturepoints(team, lastcaptureteam) {
    level endon(#"game_ended");
    level endon(#"zone_destroyed");
    level endon(#"zone_reset");
    level endon(#"zone_moved");
    level notify(#"awardcapturepointsrunning");
    level endon(#"awardcapturepointsrunning");
    seconds = 1;
    score = 1;
    while (!level.gameended) {
        wait seconds;
        hostmigration::waittillhostmigrationdone();
        if (!level.zone.gameobject.iscontested) {
            if (level.scoreperplayer) {
                score = level.zone.gameobject.numtouching[team];
            }
            globallogic_score::giveteamscoreforobjective(team, score);
            level.kothtotalsecondsinzone++;
            foreach (player in level.aliveplayers[team]) {
                if (!isdefined(player.touchtriggers[self.entnum])) {
                    continue;
                }
                if (isdefined(player.pers["objtime"])) {
                    player.pers["objtime"]++;
                    player.objtime = player.pers["objtime"];
                }
            }
        }
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x2bfcfb15, Offset: 0x3008
// Size: 0x9
function koth_playerspawnedcb() {
    self.var_fc558bd1 = undefined;
}

// Namespace koth
// Params 2, eflags: 0x0
// Checksum 0xdc835214, Offset: 0x3020
// Size: 0xb9
function comparezoneindexes(zone_a, zone_b) {
    script_index_a = zone_a.script_index;
    script_index_b = zone_b.script_index;
    if (!isdefined(script_index_a) && !isdefined(script_index_b)) {
        return false;
    }
    if (!isdefined(script_index_a) && isdefined(script_index_b)) {
        println("<dev string:xde>" + zone_a.origin);
        return true;
    }
    if (isdefined(script_index_a) && !isdefined(script_index_b)) {
        println("<dev string:xde>" + zone_b.origin);
        return false;
    }
    if (script_index_a > script_index_b) {
        return true;
    }
    return false;
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xcc36ac87, Offset: 0x30e8
// Size: 0xc9
function getzonearray() {
    zones = getentarray("koth_zone_center", "targetname");
    if (!isdefined(zones)) {
        return undefined;
    }
    swapped = 1;
    for (n = zones.size; swapped; n--) {
        swapped = 0;
        for (i = 0; i < n - 1; i++) {
            if (comparezoneindexes(zones[i], zones[i + 1])) {
                temp = zones[i];
                zones[i] = zones[i + 1];
                zones[i + 1] = temp;
                swapped = 1;
            }
        }
    }
    return zones;
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x2be2b7f2, Offset: 0x31c0
// Size: 0x34c
function setupzones() {
    maperrors = [];
    zones = getzonearray();
    trigs = getentarray("koth_zone_trigger", "targetname");
    for (i = 0; i < zones.size; i++) {
        errored = 0;
        zone = zones[i];
        zone.trig = undefined;
        for (j = 0; j < trigs.size; j++) {
            if (zone istouching(trigs[j])) {
                if (isdefined(zone.trig)) {
                    maperrors[maperrors.size] = "Zone at " + zone.origin + " is touching more than one \"zonetrigger\" trigger";
                    errored = 1;
                    break;
                }
                zone.trig = trigs[j];
                break;
            }
        }
        if (!isdefined(zone.trig)) {
            if (!errored) {
                maperrors[maperrors.size] = "Zone at " + zone.origin + " is not inside any \"zonetrigger\" trigger";
                continue;
            }
        }
        assert(!errored);
        zone.trigorigin = zone.trig.origin;
        visuals = [];
        visuals[0] = zone;
        if (isdefined(zone.target)) {
            othervisuals = getentarray(zone.target, "targetname");
            for (j = 0; j < othervisuals.size; j++) {
                visuals[visuals.size] = othervisuals[j];
            }
        }
        objective_name = istring("hardpoint");
        zone.gameobject = gameobjects::create_use_object("neutral", zone.trig, visuals, (0, 0, 0), objective_name);
        zone.gameobject gameobjects::disable_object();
        zone.gameobject gameobjects::set_model_visibility(0);
        zone.trig.useobj = zone.gameobject;
        zone function_daeec435();
        zone createzonespawninfluencer();
    }
    if (maperrors.size > 0) {
        /#
            println("<dev string:x105>");
            for (i = 0; i < maperrors.size; i++) {
                println(maperrors[i]);
            }
            println("<dev string:x12c>");
            util::error("<dev string:x153>");
        #/
        callback::abort_level();
        return;
    }
    level.zones = zones;
    level.prevzone = undefined;
    level.prevzone2 = undefined;
    setupzoneexclusions();
    return 1;
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x888d94a9, Offset: 0x3518
// Size: 0x15f
function setupzoneexclusions() {
    if (!isdefined(level.levelkothdisable)) {
        return;
    }
    foreach (nullzone in level.levelkothdisable) {
        mindist = 1410065408;
        foundzone = undefined;
        foreach (zone in level.zones) {
            distance = distancesquared(nullzone.origin, zone.origin);
            if (distance < mindist) {
                foundzone = zone;
                mindist = distance;
            }
        }
        if (isdefined(foundzone)) {
            if (!isdefined(foundzone.gameobject.exclusions)) {
                foundzone.gameobject.exclusions = [];
            }
            foundzone.gameobject.exclusions[foundzone.gameobject.exclusions.size] = nullzone;
        }
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xaa3cceac, Offset: 0x3680
// Size: 0x1ba
function function_daeec435() {
    spawns = level.spawn_all;
    for (i = 0; i < spawns.size; i++) {
        spawns[i].distsq = distancesquared(spawns[i].origin, self.origin);
    }
    for (i = 1; i < spawns.size; i++) {
        var_f0f4e5a3 = spawns[i];
        for (j = i - 1; j >= 0 && var_f0f4e5a3.distsq < spawns[j].distsq; j--) {
            spawns[j + 1] = spawns[j];
        }
        spawns[j + 1] = var_f0f4e5a3;
    }
    first = [];
    second = [];
    var_d9ac65f8 = [];
    outer = [];
    var_771d29fb = spawns.size / 3;
    for (i = 0; i <= var_771d29fb; i++) {
        first[first.size] = spawns[i];
    }
    while (i < spawns.size) {
        outer[outer.size] = spawns[i];
        if (i <= var_771d29fb * 2) {
            second[second.size] = spawns[i];
        } else {
            var_d9ac65f8[var_d9ac65f8.size] = spawns[i];
        }
        i++;
    }
    self.gameobject.nearspawns = first;
    self.gameobject.var_aa86e9f5 = second;
    self.gameobject.var_a5948bc8 = var_d9ac65f8;
    self.gameobject.outerspawns = outer;
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x5007808d, Offset: 0x3848
// Size: 0x5c
function getfirstzone() {
    zone = level.zones[0];
    level.prevzone2 = level.prevzone;
    level.prevzone = zone;
    level.prevzoneindex = 0;
    shufflezones();
    arrayremovevalue(level.zonespawnqueue, zone);
    return zone;
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xacc87613, Offset: 0x38b0
// Size: 0x54
function getnextzone() {
    nextzoneindex = (level.prevzoneindex + 1) % level.zones.size;
    zone = level.zones[nextzoneindex];
    level.prevzone2 = level.prevzone;
    level.prevzone = zone;
    level.prevzoneindex = nextzoneindex;
    return zone;
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x574ac1fc, Offset: 0x3910
// Size: 0x58
function pickrandomzonetospawn() {
    level.prevzoneindex = randomint(level.zones.size);
    zone = level.zones[level.prevzoneindex];
    level.prevzone2 = level.prevzone;
    level.prevzone = zone;
    return zone;
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x4b03ebbe, Offset: 0x3970
// Size: 0xf3
function shufflezones() {
    level.zonespawnqueue = [];
    spawnqueue = arraycopy(level.zones);
    for (total_left = spawnqueue.size; total_left > 0; total_left--) {
        index = randomint(total_left);
        valid_zones = 0;
        for (zone = 0; zone < level.zones.size; zone++) {
            if (!isdefined(spawnqueue[zone])) {
                continue;
            }
            if (valid_zones == index) {
                if (level.zonespawnqueue.size == 0 && isdefined(level.zone) && level.zone == spawnqueue[zone]) {
                    continue;
                }
                level.zonespawnqueue[level.zonespawnqueue.size] = spawnqueue[zone];
                spawnqueue[zone] = undefined;
                break;
            }
            valid_zones++;
        }
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x737fe63, Offset: 0x3a70
// Size: 0x6c
function getnextzonefromqueue() {
    if (level.zonespawnqueue.size == 0) {
        shufflezones();
    }
    assert(level.zonespawnqueue.size > 0);
    next_zone = level.zonespawnqueue[0];
    arrayremoveindex(level.zonespawnqueue, 0);
    return next_zone;
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0xccd1a393, Offset: 0x3ae8
// Size: 0x75
function function_6ac858b3(num) {
    var_24475dac = 0;
    foreach (team in level.teams) {
        if (num[team] > 0) {
            var_24475dac++;
        }
    }
    return var_24475dac;
}

// Namespace koth
// Params 2, eflags: 0x0
// Checksum 0x42a60926, Offset: 0x3b68
// Size: 0x105
function function_d35e7a8(avgpos, origin) {
    var_b6c3798b = 0;
    var_adf3423a = 0;
    distances = [];
    foreach (team, position in avgpos) {
        distances[team] = distance(origin, avgpos[team]);
        var_b6c3798b += distances[team];
    }
    var_b6c3798b /= distances.size;
    foreach (team, dist in distances) {
        err = distances[team] - var_b6c3798b;
        var_adf3423a += err * err;
    }
    return var_adf3423a;
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x206105ea, Offset: 0x3c78
// Size: 0x304
function function_24389478() {
    foreach (team in level.teams) {
        avgpos[team] = (0, 0, 0);
        num[team] = 0;
    }
    for (i = 0; i < level.players.size; i++) {
        player = level.players[i];
        if (isalive(player)) {
            avgpos[player.pers["team"]] = avgpos[player.pers["team"]] + player.origin;
            num[player.pers["team"]]++;
        }
    }
    if (function_6ac858b3(num) <= 1) {
        for (zone = level.zones[randomint(level.zones.size)]; isdefined(level.prevzone) && zone == level.prevzone; zone = level.zones[randomint(level.zones.size)]) {
        }
        level.prevzone2 = level.prevzone;
        level.prevzone = zone;
        return zone;
    }
    foreach (team in level.teams) {
        if (num[team] == 0) {
            avgpos[team] = undefined;
            continue;
        }
        avgpos[team] = avgpos[team] / num[team];
    }
    bestzone = undefined;
    var_83e35114 = undefined;
    for (i = 0; i < level.zones.size; i++) {
        zone = level.zones[i];
        cost = function_d35e7a8(avgpos, zone.origin);
        if (isdefined(level.prevzone) && zone == level.prevzone) {
            continue;
        }
        if (isdefined(level.prevzone2) && zone == level.prevzone2) {
            if (level.zones.size > 2) {
                continue;
            } else {
                cost += 262144;
            }
        }
        if (!isdefined(var_83e35114) || cost < var_83e35114) {
            var_83e35114 = cost;
            bestzone = zone;
        }
    }
    assert(isdefined(bestzone));
    level.prevzone2 = level.prevzone;
    level.prevzone = bestzone;
    return bestzone;
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xaed36c1b, Offset: 0x3f88
// Size: 0x9
function onroundswitch() {
    InvalidOpCode(0x54, "switchedsides");
    // Unknown operator (0x54, t7_1b, PC)
}

// Namespace koth
// Params 9, eflags: 0x0
// Checksum 0x4ddd7938, Offset: 0x3fa8
// Size: 0x542
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration) {
    if (level.capturetime && !self.touchtriggers.size && (!isplayer(attacker) || !attacker.touchtriggers.size) || attacker.pers["team"] == self.pers["team"]) {
        return;
    }
    medalgiven = 0;
    scoreeventprocessed = 0;
    ownerteam = undefined;
    if (level.capturetime == 0) {
        if (!isdefined(level.zone)) {
            return;
        }
        ownerteam = level.zone.gameobject.ownerteam;
        if (!isdefined(ownerteam) || ownerteam == "neutral") {
            return;
        }
    }
    if (level.capturetime == 0 && (self.touchtriggers.size || self istouching(level.zone.trig))) {
        if (level.capturetime > 0) {
            triggerids = getarraykeys(self.touchtriggers);
            ownerteam = self.touchtriggers[triggerids[0]].useobj.ownerteam;
        }
        if (ownerteam != "neutral") {
            attacker.lastkilltime = gettime();
            team = self.pers["team"];
            if (team == ownerteam) {
                if (!medalgiven) {
                    attacker medals::offenseglobalcount();
                    attacker addplayerstatwithgametype("OFFENDS", 1);
                    medalgiven = 1;
                }
                scoreevents::processscoreevent("hardpoint_kill", attacker, undefined, weapon);
                self recordkillmodifier("defending");
                scoreeventprocessed = 1;
            } else {
                if (!medalgiven) {
                    if (isdefined(attacker.pers["defends"])) {
                        attacker.pers["defends"]++;
                        attacker.defends = attacker.pers["defends"];
                    }
                    attacker medals::defenseglobalcount();
                    medalgiven = 1;
                    attacker addplayerstatwithgametype("DEFENDS", 1);
                    attacker recordgameevent("defending");
                }
                attacker challenges::killedzoneattacker(weapon);
                scoreevents::processscoreevent("hardpoint_kill", attacker, undefined, weapon);
                self recordkillmodifier("assaulting");
                scoreeventprocessed = 1;
            }
        }
    }
    if (level.capturetime == 0 && (attacker.touchtriggers.size || attacker istouching(level.zone.trig))) {
        if (level.capturetime > 0) {
            triggerids = getarraykeys(attacker.touchtriggers);
            ownerteam = attacker.touchtriggers[triggerids[0]].useobj.ownerteam;
        }
        if (ownerteam != "neutral") {
            team = attacker.pers["team"];
            if (team == ownerteam) {
                if (!medalgiven) {
                    if (isdefined(attacker.pers["defends"])) {
                        attacker.pers["defends"]++;
                        attacker.defends = attacker.pers["defends"];
                    }
                    attacker medals::defenseglobalcount();
                    medalgiven = 1;
                    attacker addplayerstatwithgametype("DEFENDS", 1);
                    attacker recordgameevent("defending");
                }
                if (scoreeventprocessed == 0) {
                    attacker challenges::killedzoneattacker(weapon);
                    scoreevents::processscoreevent("hardpoint_kill", attacker, undefined, weapon);
                    self recordkillmodifier("assaulting");
                }
            } else {
                if (!medalgiven) {
                    attacker medals::offenseglobalcount();
                    medalgiven = 1;
                    attacker addplayerstatwithgametype("OFFENDS", 1);
                }
                if (scoreeventprocessed == 0) {
                    scoreevents::processscoreevent("hardpoint_kill", attacker, undefined, weapon);
                    self recordkillmodifier("defending");
                }
            }
        }
    }
    if (medalgiven == 1) {
        if (level.zone.gameobject.iscontested == 1) {
            attacker thread killwhilecontesting();
        }
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0x9449d4b, Offset: 0x44f8
// Size: 0xfa
function killwhilecontesting() {
    self notify(#"killwhilecontesting");
    self endon(#"killwhilecontesting");
    self endon(#"disconnect");
    killtime = gettime();
    playerteam = self.pers["team"];
    if (!isdefined(self.clearenemycount)) {
        self.clearenemycount = 0;
    }
    self.clearenemycount++;
    var_b34f24c5 = level util::waittill_any_return("zone_captured" + playerteam, "zone_destroyed", "zone_captured", "death");
    if (var_b34f24c5 == "death" || playerteam != self.pers["team"]) {
        self.clearenemycount = 0;
        return;
    }
    if (self.clearenemycount >= 2 && killtime + -56 > gettime()) {
        scoreevents::processscoreevent("clear_2_attackers", self);
    }
    self.clearenemycount = 0;
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0xb6df9d66, Offset: 0x4600
// Size: 0x51
function onendgame(winningteam) {
    for (i = 0; i < level.zones.size; i++) {
        level.zones[i].gameobject gameobjects::allow_use("none");
    }
}

// Namespace koth
// Params 0, eflags: 0x0
// Checksum 0xd12a7a4d, Offset: 0x4660
// Size: 0x62
function createzonespawninfluencer() {
    self spawning::create_influencer("koth_large", self.gameobject.curorigin, 0);
    self spawning::create_influencer("koth_small", self.gameobject.curorigin, 0);
    self spawning::enable_influencers(0);
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0x7e5003d7, Offset: 0x46d0
// Size: 0xd2
function updatecapsperminute(lastownerteam) {
    if (!isdefined(self.capsperminute)) {
        self.numcaps = 0;
        self.capsperminute = 0;
    }
    if (!isdefined(lastownerteam) || lastownerteam == "neutral") {
        return;
    }
    self.numcaps++;
    minutespassed = globallogic_utils::gettimepassed() / 60000;
    if (isplayer(self) && isdefined(self.timeplayed["total"])) {
        minutespassed = self.timeplayed["total"] / 60;
    }
    self.capsperminute = self.numcaps / minutespassed;
    if (self.capsperminute > self.numcaps) {
        self.capsperminute = self.numcaps;
    }
}

// Namespace koth
// Params 1, eflags: 0x0
// Checksum 0x6253d72d, Offset: 0x47b0
// Size: 0x31
function isscoreboosting(player) {
    if (!level.rankedmatch) {
        return false;
    }
    if (player.capsperminute > level.playercapturelpm) {
        return true;
    }
    return false;
}

