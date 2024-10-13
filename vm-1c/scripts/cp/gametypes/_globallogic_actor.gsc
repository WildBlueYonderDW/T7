#using scripts/cp/_bb;
#using scripts/cp/_scoreevents;
#using scripts/cp/_friendlyfire;
#using scripts/cp/_challenges;
#using scripts/shared/_burnplayer;
#using scripts/cp/gametypes/_weapons;
#using scripts/cp/gametypes/_globallogic_utils;
#using scripts/cp/gametypes/_globallogic_score;
#using scripts/cp/gametypes/_globallogic_player;
#using scripts/cp/gametypes/_globallogic;
#using scripts/cp/gametypes/_battlechatter;
#using scripts/shared/ai/systems/gib;
#using scripts/shared/ai/systems/destructible_character;
#using scripts/shared/ai/systems/shared;
#using scripts/shared/ammo_shared;
#using scripts/shared/weapons/_weapon_utils;
#using scripts/shared/weapons_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/scoreevents_shared;
#using scripts/shared/damagefeedback_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/challenges_shared;
#using scripts/codescripts/struct;

#namespace globallogic_actor;

// Namespace globallogic_actor
// Params 1, eflags: 0x1 linked
// Checksum 0x438ffa1b, Offset: 0x4c0
// Size: 0x54
function callback_actorspawned(spawner) {
    self thread spawner::spawn_think(spawner);
    self globallogic_player::resetattackerlist();
    bb::logaispawn(self, spawner);
}

// Namespace globallogic_actor
// Params 15, eflags: 0x1 linked
// Checksum 0xd82bb613, Offset: 0x520
// Size: 0xb24
function callback_actordamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, modelindex, surfacetype, surfacenormal) {
    self endon(#"death");
    params = spawnstruct();
    params.einflictor = einflictor;
    params.eattacker = eattacker;
    params.idamage = idamage;
    params.idflags = idflags;
    params.smeansofdeath = smeansofdeath;
    params.weapon = weapon;
    params.vpoint = vpoint;
    params.vdir = vdir;
    params.shitloc = shitloc;
    params.vdamageorigin = vdamageorigin;
    params.psoffsettime = psoffsettime;
    self.idflags = idflags;
    self.idflagstime = gettime();
    eattacker = globallogic_player::figureoutattacker(eattacker);
    if (self.health == self.maxhealth || !isdefined(self.attackers)) {
        self.attackers = [];
        self.attackerdata = [];
        self.attackerdamage = [];
    }
    if (isdefined(level.friendlyfiredisabled) && !level.friendlyfiredisabled) {
        if (isdefined(level.var_8300d543)) {
            if (isplayer(eattacker) && self.team == eattacker.team) {
                idamage = int(idamage * level.var_8300d543);
                if (idamage < 1) {
                    idamage = 1;
                }
            }
        }
    }
    if (isdefined(self.overrideactordamage)) {
        idamage = self [[ self.overrideactordamage ]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex);
    } else if (isdefined(level.overrideactordamage)) {
        idamage = self [[ level.overrideactordamage ]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex);
    }
    if (isdefined(level.cybercom) && isdefined(isdefined(level.cybercom.overrideactordamage))) {
        idamage = self [[ level.cybercom.overrideactordamage ]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex);
    }
    if (isdefined(self.aioverridedamage)) {
        for (index = 0; index < self.aioverridedamage.size; index++) {
            damagecallback = self.aioverridedamage[index];
            idamage = self [[ damagecallback ]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex);
        }
    }
    assert(isdefined(idamage), "<dev string:x28>");
    if (!isdefined(vdir)) {
        idflags |= 4;
    }
    if (isdefined(eattacker)) {
        if (isplayer(eattacker)) {
            level thread friendlyfire::function_36510feb(self, idamage, eattacker, smeansofdeath);
            if (isdefined(self.var_769ad13b)) {
                self thread [[ self.var_769ad13b ]]();
            }
            self thread challenges::actordamaged(eattacker, eattacker, idamage, weapon, shitloc);
            if (!isdefined(smeansofdeath) || (eattacker === einflictor || isdefined(einflictor) && !isvehicle(einflictor)) && smeansofdeath != "MOD_MELEE_WEAPON_BUTT") {
                eattacker.hits++;
            }
        } else if (isai(eattacker)) {
            if (self.team == eattacker.team && smeansofdeath == "MOD_MELEE") {
                return;
            }
        }
    }
    self callback::callback(#"hash_eb4a4369", params);
    self callback::callback(#"hash_7b543e98", params);
    actorkilled = 0;
    self thread globallogic_player::trackattackerdamage(eattacker, idamage, smeansofdeath, weapon);
    if (self.health > 0 && self.health - idamage <= 0) {
        if (isdefined(eattacker) && isplayer(eattacker.driver)) {
            eattacker = eattacker.driver;
        }
        if (isplayer(eattacker)) {
            println("<dev string:x61>" + weapon.name + "<dev string:x7b>" + smeansofdeath);
            if (self.team != eattacker.team) {
                if (smeansofdeath == "MOD_MELEE") {
                    eattacker notify(#"melee_kill");
                }
            }
        }
        actorkilled = 1;
    }
    if (weapon_utils::isflashorstundamage(weapon, smeansofdeath)) {
        if (isdefined(self.type)) {
            if (weapon.isflash && self.type == "human") {
                self.var_b3b49b95 = self.idflagstime;
            } else if (weapon.isstun && self.type == "human") {
                self.var_63fb6c7d = self.idflagstime;
            }
        }
        self.laststunnedby = eattacker;
        self.laststunnedtime = self.idflagstime;
    }
    if (weapon.isemp && isdefined(self.type) && self.type == "robot") {
        if (weapon.name == "emp_grenade") {
            self.var_4d6fef21 = self.idflagstime;
        } else if (weapon.name == "ravage_core_emp_grenade" || weapon.name == "ravage_core_emp_grenade_upg") {
            self.var_7097b5af = self.idflagstime;
        }
    }
    if (!(idflags & 2048)) {
        if (level.teambased && isdefined(eattacker) && eattacker != self && self.team == eattacker.team && !isplayer(eattacker)) {
            if (level.friendlyfire == 0) {
                return;
            } else if (level.friendlyfire == 1) {
                if (idamage < 1) {
                    idamage = 1;
                }
                self.lastdamagewasfromenemy = 0;
            } else if (level.friendlyfire == 2) {
                return;
            } else if (level.friendlyfire == 3) {
                idamage = int(idamage * 0.5);
                if (idamage < 1) {
                    idamage = 1;
                }
                self.lastdamagewasfromenemy = 0;
            }
        }
        if (isdefined(eattacker) && eattacker != self) {
            if (isvehicle(einflictor) && (!isdefined(einflictor) || !isai(einflictor) || einflictor getseatoccupant(0) === eattacker)) {
                if (idamage > 0 && self.team != eattacker.team && self.team != "neutral" && shitloc !== "riotshield") {
                    eattacker thread damagefeedback::update(smeansofdeath, einflictor, undefined, weapon);
                }
            }
        }
    }
    bb::logdamage(eattacker, self, weapon, idamage, smeansofdeath, shitloc, actorkilled, actorkilled);
    self globallogic_player::giveattackerandinflictorownerassist(eattacker, einflictor, idamage, smeansofdeath, weapon);
    self finishactordamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, surfacetype, surfacenormal);
}

// Namespace globallogic_actor
// Params 8, eflags: 0x1 linked
// Checksum 0x6e40b69d, Offset: 0x1050
// Size: 0x5dc
function callback_actorkilled(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime) {
    params = spawnstruct();
    params.einflictor = einflictor;
    params.eattacker = eattacker;
    params.idamage = idamage;
    params.smeansofdeath = smeansofdeath;
    params.weapon = weapon;
    params.vdir = vdir;
    params.shitloc = shitloc;
    params.psoffsettime = psoffsettime;
    if (game["state"] == "postgame") {
        return;
    }
    eattacker = globallogic_player::figureoutattacker(eattacker);
    if (globallogic_utils::isheadshot(weapon, shitloc, smeansofdeath, einflictor)) {
        smeansofdeath = "MOD_HEAD_SHOT";
    }
    if (isdefined(eattacker) && isplayer(eattacker)) {
        eattacker notify(#"hash_c56ba9f7", self, smeansofdeath, weapon);
        globallogic_score::inctotalkills(eattacker.team);
        eattacker thread globallogic_score::givekillstats(smeansofdeath, weapon, self);
        if (smeansofdeath == "MOD_MELEE" || smeansofdeath == "MOD_MELEE_ASSASSINATE" || smeansofdeath == "MOD_MELEE_WEAPON_BUTT") {
            eattacker.var_247e0696++;
        }
    }
    if (isai(eattacker) && isdefined(eattacker.script_owner)) {
        if (eattacker.script_owner.team != self.team) {
            eattacker = eattacker.script_owner;
        }
    }
    if (isdefined(eattacker) && isdefined(eattacker.onkill)) {
        eattacker [[ eattacker.onkill ]](self);
    }
    if (isdefined(einflictor)) {
        self.damageinflictor = einflictor;
    }
    self callback::callback(#"hash_fc2ec5ff", params);
    self callback::callback(#"hash_8c38c12e", params);
    if (isdefined(self.aioverridekilled)) {
        for (index = 0; index < self.aioverridekilled.size; index++) {
            killedcallback = self.aioverridekilled[index];
            self [[ killedcallback ]](einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
        }
    }
    if (isdefined(level.var_173c585e) && level.var_173c585e && (isdefined(level.var_b36f7a2e) && level.var_b36f7a2e && self.team == "allies" || self.team == "team3") || isplayer(eattacker) && self.team == "axis") {
        self thread ammo::dropaiammo();
    }
    player = eattacker;
    if (eattacker.classname == "script_vehicle" && isdefined(eattacker.owner)) {
        player = eattacker.owner;
    }
    if (isdefined(player) && isplayer(player) && !(isdefined(self.disable_score_events) && self.disable_score_events)) {
        if (!level.teambased || self.team != player.pers["team"]) {
            if (smeansofdeath == "MOD_MELEE" || smeansofdeath == "MOD_MELEE_ASSASSINATE") {
                scoreevents::processscoreevent("melee_kill" + self.scoretype, player, self, weapon);
            } else {
                scoreevents::processscoreevent("kill" + self.scoretype, player, self, weapon);
            }
            self thread challenges::actorkilled(einflictor, player, idamage, smeansofdeath, weapon, shitloc);
            self function_64fed33(einflictor, player, weapon, player.team);
        }
    }
}

// Namespace globallogic_actor
// Params 1, eflags: 0x1 linked
// Checksum 0x3000d06e, Offset: 0x1638
// Size: 0x3c
function callback_actorcloned(original) {
    destructserverutils::copydestructstate(original, self);
    gibserverutils::copygibstate(original, self);
}

// Namespace globallogic_actor
// Params 4, eflags: 0x1 linked
// Checksum 0xafc071f5, Offset: 0x1680
// Size: 0x164
function function_64fed33(einflictor, eattacker, weapon, lpattackteam) {
    pixbeginevent("ActorKilled assists");
    if (isdefined(self.attackers)) {
        for (j = 0; j < self.attackers.size; j++) {
            player = self.attackers[j];
            if (!isdefined(player)) {
                continue;
            }
            if (player == eattacker) {
                continue;
            }
            if (player.team != lpattackteam) {
                continue;
            }
            damage_done = self.attackerdamage[player.clientid].damage;
            player thread globallogic_score::processassist(self, damage_done, self.attackerdamage[player.clientid].weapon, "assist" + self.scoretype);
        }
    }
    pixendevent();
}

