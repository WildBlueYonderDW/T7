#using scripts/mp/_util;
#using scripts/mp/gametypes/_spawnlogic;
#using scripts/mp/gametypes/_spawning;
#using scripts/mp/gametypes/_loadout;
#using scripts/mp/gametypes/_globallogic_utils;
#using scripts/mp/gametypes/_globallogic_score;
#using scripts/mp/gametypes/_globallogic_audio;
#using scripts/mp/gametypes/_globallogic;
#using scripts/shared/weapons/_weapon_utils;
#using scripts/shared/scoreevents_shared;
#using scripts/shared/rank_shared;
#using scripts/shared/persistence_shared;
#using scripts/shared/math_shared;
#using scripts/shared/gameobjects_shared;

#namespace gun;

// Namespace gun
// Params 0, eflags: 0x0
// Checksum 0x9d70ba5e, Offset: 0x7a8
// Size: 0x24c
function main() {
    globallogic::init();
    level.onstartgametype = &onstartgametype;
    level.onspawnplayer = &onspawnplayer;
    level.onplayerkilled = &onplayerkilled;
    level.onendgame = &onendgame;
    globallogic_audio::set_leader_gametype_dialog("startGunGame", "hcSstartGunGame", "", "");
    level.givecustomloadout = &givecustomloadout;
    level.setbacksperdemotion = getgametypesetting("setbacks");
    level.inactivitykick = 60;
    gameobjects::register_allowed_gameobject(level.gametype);
    level.var_a4fbd7a3 = getweapon("lmg_infinite");
    function_990f40f7();
    util::registertimelimit(0, 1440);
    util::registerroundlimit(0, 10);
    util::registerroundwinlimit(0, 10);
    util::registernumlives(0, 100);
    if (!sessionmodeissystemlink() && !sessionmodeisonlinegame() && issplitscreen()) {
        globallogic::setvisiblescoreboardcolumns("pointstowin", "kills", "stabs", "humiliated", "deaths");
        return;
    }
    globallogic::setvisiblescoreboardcolumns("pointstowin", "kills", "deaths", "stabs", "humiliated");
}

// Namespace gun
// Params 0, eflags: 0x0
// Checksum 0x90feccb9, Offset: 0xa00
// Size: 0x29c
function function_5ada47ea() {
    addguntoprogression("pistol_m1911");
    addguntoprogression("pistol_shotgun_dw");
    addguntoprogression("shotgun_olympia", "reddot");
    addguntoprogression("shotgun_energy", "reflex");
    addguntoprogression("smg_ak74u", "grip", "extbarrel");
    addguntoprogression("smg_ppsh", "reflex", "steadyaim");
    addguntoprogression("smg_msmc", "fastreload", "reddot");
    addguntoprogression("ar_an94", "rf", "fastreload");
    addguntoprogression("ar_m16", "reddot", "damage");
    addguntoprogression("ar_peacekeeper", "reddot", "quickdraw");
    addguntoprogression("ar_galil", "reflex", "extbarrel");
    addguntoprogression("ar_garand", "acog");
    addguntoprogression("ar_pulse", "fastreload", "steadyaim");
    addguntoprogression("lmg_infinite", "rf");
    addguntoprogression("sniper_quickscope", "swayreduc");
    addguntoprogression("sniper_double", "acog", "swayreduc");
    addguntoprogression("launcher_ex41");
    addguntoprogression("special_discgun");
    addguntoprogression("special_crossbow");
    addguntoprogression("knife_ballistic");
}

// Namespace gun
// Params 0, eflags: 0x0
// Checksum 0x9058d56f, Offset: 0xca8
// Size: 0x29c
function function_74c19bbc() {
    addguntoprogression("pistol_standard", "fastreload", "steadyaim");
    addguntoprogression("pistol_burst_dw");
    addguntoprogression("pistol_fullauto", "reflex");
    addguntoprogression("shotgun_pump", "extbarrel", "suppressed");
    addguntoprogression("shotgun_precision", "qucikdraw", "holo");
    addguntoprogression("shotgun_fullauto", "extclip");
    addguntoprogression("smg_versatile", "grip", "extbarrel");
    addguntoprogression("smg_burst", "suppressed");
    addguntoprogression("smg_longrange", "reflex");
    addguntoprogression("ar_cqb", "rf", "fastreload");
    addguntoprogression("ar_standard", "fmj", "damage");
    addguntoprogression("ar_longburst", "acog");
    addguntoprogression("ar_marksman", "ir");
    addguntoprogression("lmg_slowfire", "extclip");
    addguntoprogression("lmg_cqb", "quickdraw", "steadyaim");
    addguntoprogression("sniper_fastbolt", "swayreduc");
    addguntoprogression("sniper_powerbolt", "reddot");
    addguntoprogression("launcher_standard");
    addguntoprogression("knife_loadout");
    addguntoprogression("bare_hands");
}

// Namespace gun
// Params 0, eflags: 0x0
// Checksum 0x1a6eb9b7, Offset: 0xf50
// Size: 0x4c
function function_6b594b42() {
    if (getdvarint("black_market_gun_game", 0) > 0) {
        function_5ada47ea();
        return;
    }
    function_74c19bbc();
}

// Namespace gun
// Params 0, eflags: 0x0
// Checksum 0xc2e21efb, Offset: 0xfa8
// Size: 0x59e
function function_990f40f7() {
    level.gunprogression = [];
    gunlist = getgametypesetting("gunSelection");
    if (gunlist == 3) {
        gunlist = randomintrange(0, 3);
    }
    switch (gunlist) {
    case 0:
        function_6b594b42();
        break;
    case 1:
        addguntoprogression("pistol_standard", "reddot");
        addguntoprogression("pistol_fullauto_dw", "reflex");
        addguntoprogression("pistol_standard_dw");
        addguntoprogression("pistol_burst_dw");
        addguntoprogression("pistol_fullauto_dw");
        addguntoprogression("shotgun_semiauto", "steadyaim");
        addguntoprogression("shotgun_fullauto", "suppressed");
        addguntoprogression("shotgun_pump", "quickdraw");
        addguntoprogression("shotgun_precision", "reddot");
        addguntoprogression("smg_fastfire", "holo");
        addguntoprogression("smg_standard", "quickdraw");
        addguntoprogression("smg_versatile", "suppressed");
        addguntoprogression("smg_capacity", "stalker");
        addguntoprogression("smg_longrange", "rf");
        addguntoprogression("smg_burst", "reddot");
        addguntoprogression("lmg_cqb", "quickdraw");
        addguntoprogression("launcher_standard");
        addguntoprogression("sniper_powerbolt", "reddot");
        addguntoprogression("knife_loadout");
        addguntoprogression("bare_hands");
        break;
    case 2:
        addguntoprogression("smg_capacity", "holo", "quickdraw");
        addguntoprogression("smg_longrange", "acog", "extclip");
        addguntoprogression("smg_burst", "acog", "extbarrel");
        addguntoprogression("ar_cqb", "acog");
        addguntoprogression("ar_standard", "reflex");
        addguntoprogression("ar_longburst", "extbarrel");
        addguntoprogression("ar_fastburst", "holo");
        addguntoprogression("ar_marksman", "acog");
        addguntoprogression("ar_damage", "reddot");
        addguntoprogression("ar_accurate", "ir", "extbarrel");
        addguntoprogression("lmg_light", "ir");
        addguntoprogression("lmg_cqb", "reflex");
        addguntoprogression("lmg_heavy", "acog");
        addguntoprogression("lmg_slowfire", "ir", "extclip");
        addguntoprogression("sniper_fastsemi", "swayreduc", "stalker");
        addguntoprogression("sniper_fastbolt", "ir", "rf");
        addguntoprogression("sniper_powerbolt", "swayreduc");
        addguntoprogression("launcher_standard");
        addguntoprogression("knife_loadout");
        addguntoprogression("bare_hands");
        break;
    }
}

// Namespace gun
// Params 0, eflags: 0x0
// Checksum 0x7aad8e58, Offset: 0x1550
// Size: 0x218
function onstartgametype() {
    level.gungamekillscore = rank::getscoreinfovalue("kill_gun");
    util::registerscorelimit(level.gunprogression.size * level.gungamekillscore, level.gunprogression.size * level.gungamekillscore);
    setdvar("ui_weapon_tiers", level.gunprogression.size);
    setclientnamemode("auto_change");
    level.spawnmins = (0, 0, 0);
    level.spawnmaxs = (0, 0, 0);
    foreach (team in level.teams) {
        setupteam(team);
    }
    level.usestartspawns = 1;
    level.spawn_start = spawnlogic::get_spawnpoint_array("mp_dm_spawn_start");
    spawning::create_map_placed_influencers();
    spawning::updateallspawnpoints();
    level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
    setmapcenter(level.mapcenter);
    spawnpoint = spawnlogic::get_random_intermission_point();
    setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
    level.displayroundendtext = 0;
}

// Namespace gun
// Params 0, eflags: 0x0
// Checksum 0xa15fe160, Offset: 0x1770
// Size: 0x154
function inactivitykick() {
    self endon(#"disconnect");
    self endon(#"death");
    if (sessionmodeisprivate()) {
        return;
    }
    if (level.inactivitykick == 0) {
        return;
    }
    while (level.inactivitykick > self.timeplayed["total"]) {
        wait(1);
    }
    if (self.pers["participation"] == 0 && self.pers["time_played_moving"] < 1) {
        globallogic::gamehistoryplayerkicked();
        kick(self getentitynumber(), "GAME_DROPPEDFORINACTIVITY");
    }
    if (self.pers["participation"] == 0 && self.timeplayed["total"] > 60) {
        globallogic::gamehistoryplayerkicked();
        kick(self getentitynumber(), "GAME_DROPPEDFORINACTIVITY");
    }
}

// Namespace gun
// Params 1, eflags: 0x0
// Checksum 0x18751c98, Offset: 0x18d0
// Size: 0x64
function onspawnplayer(predictedspawn) {
    if (!level.inprematchperiod) {
        level.usestartspawns = 0;
    }
    spawning::onspawnplayer(predictedspawn);
    self thread infiniteammo();
    self thread inactivitykick();
}

// Namespace gun
// Params 9, eflags: 0x0
// Checksum 0x819251cf, Offset: 0x1940
// Size: 0x214
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration) {
    level.usestartspawns = 0;
    if (smeansofdeath == "MOD_SUICIDE" || smeansofdeath == "MOD_TRIGGER_HURT") {
        self thread demoteplayer();
        return;
    }
    if (isdefined(attacker) && isplayer(attacker)) {
        if (attacker == self) {
            self thread demoteplayer(attacker);
            return;
        }
        if (isdefined(attacker.lastpromotiontime) && attacker.lastpromotiontime + 3000 > gettime()) {
            scoreevents::processscoreevent("kill_in_3_seconds_gun", attacker, self, weapon);
        }
        if (weapon_utils::ismeleemod(smeansofdeath)) {
            scoreevents::processscoreevent("humiliation_gun", attacker, self, weapon);
            if (globallogic_score::gethighestscoringplayer() === self) {
                scoreevents::processscoreevent("melee_leader_gun", attacker, self, weapon);
            }
            self thread demoteplayer(attacker);
        }
        if (weapon.isballisticknife && (!weapon.isballisticknife && smeansofdeath != "MOD_MELEE_WEAPON_BUTT" || smeansofdeath != "MOD_MELEE")) {
            attacker thread promoteplayer(weapon);
        }
    }
}

// Namespace gun
// Params 1, eflags: 0x0
// Checksum 0x4c326bde, Offset: 0x1b60
// Size: 0x5c
function onendgame(winningplayer) {
    if (isdefined(winningplayer) && isplayer(winningplayer)) {
        [[ level._setplayerscore ]](winningplayer, [[ level._getplayerscore ]](winningplayer) + level.gungamekillscore);
    }
}

// Namespace gun
// Params 9, eflags: 0x0
// Checksum 0xd6bed09e, Offset: 0x1bc8
// Size: 0x176
function addguntoprogression(weaponname, attachment1, attachment2, attachment3, attachment4, attachment5, attachment6, attachment7, attachment8) {
    attachments = [];
    if (isdefined(attachment1)) {
        attachments[attachments.size] = attachment1;
    }
    if (isdefined(attachment2)) {
        attachments[attachments.size] = attachment2;
    }
    if (isdefined(attachment3)) {
        attachments[attachments.size] = attachment3;
    }
    if (isdefined(attachment4)) {
        attachments[attachments.size] = attachment4;
    }
    if (isdefined(attachment5)) {
        attachments[attachments.size] = attachment5;
    }
    if (isdefined(attachment6)) {
        attachments[attachments.size] = attachment6;
    }
    if (isdefined(attachment7)) {
        attachments[attachments.size] = attachment7;
    }
    if (isdefined(attachment8)) {
        attachments[attachments.size] = attachment8;
    }
    weapon = getweapon(weaponname, attachments);
    level.gunprogression[level.gunprogression.size] = weapon;
}

// Namespace gun
// Params 1, eflags: 0x0
// Checksum 0x9814568b, Offset: 0x1d48
// Size: 0xcc
function setupteam(team) {
    util::setobjectivetext(team, %OBJECTIVES_GUN);
    if (level.splitscreen) {
        util::setobjectivescoretext(team, %OBJECTIVES_GUN);
    } else {
        util::setobjectivescoretext(team, %OBJECTIVES_GUN_SCORE);
    }
    util::setobjectivehinttext(team, %OBJECTIVES_GUN_HINT);
    spawnlogic::add_spawn_points(team, "mp_dm_spawn");
    spawnlogic::place_spawn_points("mp_dm_spawn_start");
}

// Namespace gun
// Params 1, eflags: 0x0
// Checksum 0x5895ee75, Offset: 0x1e20
// Size: 0x44
function takeoldweapon(oldweapon) {
    self endon(#"death");
    self endon(#"disconnect");
    wait(1);
    self takeweapon(oldweapon);
}

// Namespace gun
// Params 1, eflags: 0x0
// Checksum 0x68fa108, Offset: 0x1e70
// Size: 0x200
function givecustomloadout(takeoldweapon) {
    if (!isdefined(takeoldweapon)) {
        takeoldweapon = 0;
    }
    self loadout::function_79d05183(!takeoldweapon);
    self loadout::function_1d84af77("CLASS_ASSAULT");
    if (takeoldweapon) {
        oldweapon = self getcurrentweapon();
        weapons = self getweaponslist();
        foreach (weapon in weapons) {
            if (weapon != oldweapon) {
                self takeweapon(weapon);
            }
        }
        self thread takeoldweapon(oldweapon);
    }
    if (!isdefined(self.gunprogress)) {
        self.gunprogress = 0;
    }
    currentweapon = level.gunprogression[self.gunprogress];
    self giveweapon(currentweapon);
    self switchtoweapon(currentweapon);
    self disableweaponcycling();
    if (self.firstspawn !== 0) {
        self setspawnweapon(currentweapon);
    }
    return currentweapon;
}

// Namespace gun
// Params 1, eflags: 0x0
// Checksum 0xa3c30f80, Offset: 0x2078
// Size: 0x180
function promoteplayer(weaponused) {
    self endon(#"disconnect");
    self endon(#"cancel_promotion");
    level endon(#"game_ended");
    wait(0.05);
    if (isdefined(level.gunprogression[self.gunprogress].dualwieldweapon) && (weaponused.rootweapon == level.gunprogression[self.gunprogress].rootweapon || level.gunprogression[self.gunprogress].dualwieldweapon.rootweapon == weaponused.rootweapon)) {
        if (self.gunprogress < level.gunprogression.size - 1) {
            self.gunprogress++;
            if (isalive(self)) {
                self thread givecustomloadout(1);
            }
        }
        pointstowin = self.pers["pointstowin"];
        if (pointstowin < level.scorelimit) {
            self globallogic_score::givepointstowin(level.gungamekillscore);
            scoreevents::processscoreevent("kill_gun", self);
        }
        self.lastpromotiontime = gettime();
    }
}

// Namespace gun
// Params 1, eflags: 0x0
// Checksum 0x47fb69dc, Offset: 0x2200
// Size: 0x1cc
function demoteplayer(attacker) {
    self endon(#"disconnect");
    self notify(#"cancel_promotion");
    currentgunprogress = self.gunprogress;
    for (i = 0; i < level.setbacksperdemotion; i++) {
        if (self.gunprogress <= 0) {
            break;
        }
        self globallogic_score::givepointstowin(level.gungamekillscore * -1);
        self.gunprogress--;
    }
    if (currentgunprogress != self.gunprogress && isalive(self)) {
        self thread givecustomloadout(1);
    }
    if (isdefined(attacker)) {
        self addplayerstatwithgametype("HUMILIATE_ATTACKER", 1);
        attacker recordgameevent("capture");
    }
    self addplayerstatwithgametype("HUMILIATE_VICTIM", 1);
    self.pers["humiliated"]++;
    self.humiliated = self.pers["humiliated"];
    self recordgameevent("return");
    self playlocalsound("mpl_wager_humiliate");
    self globallogic_audio::leader_dialog_on_player("humiliated");
}

// Namespace gun
// Params 0, eflags: 0x0
// Checksum 0xcb1fda5c, Offset: 0x23d8
// Size: 0x90
function infiniteammo() {
    self endon(#"death");
    self endon(#"disconnect");
    while (true) {
        wait(0.1);
        weapon = self getcurrentweapon();
        if (weapon.rootweapon == level.var_a4fbd7a3) {
            continue;
        }
        self givemaxammo(weapon);
    }
}

