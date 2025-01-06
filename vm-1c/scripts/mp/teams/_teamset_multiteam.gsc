#using scripts/codescripts/struct;
#using scripts/mp/teams/_teamset;
#using scripts/mp/teams/_teamset_allies;
#using scripts/mp/teams/_teamset_axis;

#namespace _teamset_multiteam;

// Namespace _teamset_multiteam
// Params 0, eflags: 0x0
// Checksum 0x4a4cca84, Offset: 0x460
// Size: 0xec
function main() {
    _teamset::init();
    toggle = 0;
    foreach (team in level.teams) {
        if (toggle % 2) {
            init_axis(team);
        } else {
            init_allies(team);
        }
        toggle++;
    }
    precache();
}

// Namespace _teamset_multiteam
// Params 0, eflags: 0x0
// Checksum 0x1d58e302, Offset: 0x558
// Size: 0x24
function precache() {
    _teamset_allies::precache();
    _teamset_axis::precache();
}

// Namespace _teamset_multiteam
// Params 1, eflags: 0x0
// Checksum 0xc91b41af, Offset: 0x588
// Size: 0x32a
function init_allies(team) {
    game[team] = "allies";
    game["attackers"] = team;
    game["entity_headicon_" + team] = "faction_allies";
    game["headicon_" + team] = "faction_allies";
    level.teamprefix[team] = "vox_st";
    level.teampostfix[team] = "st6";
    setdvar("g_TeamName_" + team, %MPUI_ALLIES_SHORT);
    setdvar("g_TeamColor_" + team, "0.6 0.64 0.69");
    setdvar("g_ScoresColor_" + team, "0.6 0.64 0.69");
    setdvar("g_FactionName_" + team, game[team]);
    game["strings"][team + "_win"] = %MP_SEALS_WIN_MATCH;
    game["strings"][team + "_win_round"] = %MP_SEALS_WIN_ROUND;
    game["strings"][team + "_mission_accomplished"] = %MP_SEALS_MISSION_ACCOMPLISHED;
    game["strings"][team + "_eliminated"] = %MP_SEALS_ELIMINATED;
    game["strings"][team + "_forfeited"] = %MP_SEALS_FORFEITED;
    game["strings"][team + "_name"] = %MP_SEALS_NAME;
    game["music"]["spawn_" + team] = "SPAWN_ST6";
    game["music"]["spawn_short" + team] = "SPAWN_SHORT_ST6";
    game["music"]["victory_" + team] = "VICTORY_ST6";
    game["icons"][team] = "faction_allies";
    game["voice"][team] = "vox_st6_";
    setdvar("scr_" + team, "marines");
    level.var_7fb68eed[team]["hit"] = "vox_ops_2_kls_attackheli_hit";
    game["flagmodels"][team] = "mp_flag_allies_1";
    game["carry_flagmodels"][team] = "mp_flag_allies_1_carry";
}

// Namespace _teamset_multiteam
// Params 1, eflags: 0x0
// Checksum 0x90a9fbf4, Offset: 0x8c0
// Size: 0x32a
function init_axis(team) {
    game[team] = "axis";
    game["defenders"] = team;
    game["entity_headicon_" + team] = "faction_axis";
    game["headicon_" + team] = "faction_axis";
    level.teamprefix[team] = "vox_pm";
    level.teampostfix[team] = "init_axis";
    setdvar("g_TeamName_" + team, %MPUI_AXIS_SHORT);
    setdvar("g_TeamColor_" + team, "0.65 0.57 0.41");
    setdvar("g_ScoresColor_" + team, "0.65 0.57 0.41");
    setdvar("g_FactionName_" + team, game[team]);
    game["strings"][team + "_win"] = %MP_PMC_WIN_MATCH;
    game["strings"][team + "_win_round"] = %MP_PMC_WIN_ROUND;
    game["strings"][team + "_mission_accomplished"] = %MP_PMC_MISSION_ACCOMPLISHED;
    game["strings"][team + "_eliminated"] = %MP_PMC_ELIMINATED;
    game["strings"][team + "_forfeited"] = %MP_PMC_FORFEITED;
    game["strings"][team + "_name"] = %MP_PMC_NAME;
    game["music"]["spawn_" + team] = "SPAWN_PMC";
    game["music"]["spawn_short" + team] = "SPAWN_SHORT_PMC";
    game["music"]["victory_" + team] = "VICTORY_PMC";
    game["icons"][team] = "faction_axis";
    game["voice"][team] = "vox_pmc_";
    setdvar("scr_" + team, "ussr");
    level.var_7fb68eed[team]["hit"] = "vox_rus_0_kls_attackheli_hit";
    game["flagmodels"][team] = "mp_flag_axis_1";
    game["carry_flagmodels"][team] = "mp_flag_axis_1_carry";
}

