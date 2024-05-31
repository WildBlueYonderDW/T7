#using scripts/mp/mp_nuketown_x_sound;
#using scripts/mp/mp_nuketown_x_fx;
#using scripts/mp/_util;
#using scripts/mp/_load;
#using scripts/shared/util_shared;
#using scripts/shared/clientfield_shared;
#using scripts/codescripts/struct;

#namespace namespace_e592ae9f;

// Namespace namespace_e592ae9f
// Params 0, eflags: 0x1 linked
// namespace_e592ae9f<file_0>::function_d290ebfa
// Checksum 0x9d9744a4, Offset: 0x250
// Size: 0x164
function main() {
    clientfield::register("scriptmover", "nuketown_population_ones", 1, 4, "int", &function_a3fc1001, 0, 0);
    clientfield::register("scriptmover", "nuketown_population_tens", 1, 4, "int", &function_a3fc1001, 0, 0);
    clientfield::register("world", "nuketown_endgame", 1, 1, "int", &function_db2629eb, 0, 0);
    namespace_6044bb60::main();
    namespace_4cda09f7::main();
    load::main();
    level.domflagbasefxoverride = &dom_flag_base_fx_override;
    level.domflagcapfxoverride = &dom_flag_cap_fx_override;
    util::waitforclient(0);
    level.endgamexcamname = "ui_cam_endgame_mp_nuketown";
}

// Namespace namespace_e592ae9f
// Params 7, eflags: 0x1 linked
// namespace_e592ae9f<file_0>::function_db2629eb
// Checksum 0x81ece742, Offset: 0x3c0
// Size: 0xa4
function function_db2629eb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump) {
    /#
        if (newval) {
            setdvar("neutral", 0);
            setdvar("neutral", 10.64);
            return;
        }
        setdvar("neutral", 1);
    #/
}

// Namespace namespace_e592ae9f
// Params 7, eflags: 0x1 linked
// namespace_e592ae9f<file_0>::function_a3fc1001
// Checksum 0x1198db0d, Offset: 0x470
// Size: 0x64
function function_a3fc1001(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump) {
    self mapshaderconstant(localclientnum, 0, "scriptVector0", newval, 0, 0, 0);
}

// Namespace namespace_e592ae9f
// Params 2, eflags: 0x1 linked
// namespace_e592ae9f<file_0>::function_b6d6bffc
// Checksum 0x332a9c1, Offset: 0x4e0
// Size: 0xc2
function dom_flag_base_fx_override(flag, team) {
    switch (flag.name) {
    case 11:
        if (team == "neutral") {
            return "ui/fx_dom_marker_neutral_r120";
        } else {
            return "ui/fx_dom_marker_team_r120";
        }
        break;
    case 12:
        if (team == "neutral") {
            return "ui/fx_dom_marker_neutral_r120";
        } else {
            return "ui/fx_dom_marker_team_r120";
        }
        break;
    case 13:
        if (team == "neutral") {
            return "ui/fx_dom_marker_neutral_r120";
        } else {
            return "ui/fx_dom_marker_team_r120";
        }
        break;
    }
}

// Namespace namespace_e592ae9f
// Params 2, eflags: 0x1 linked
// namespace_e592ae9f<file_0>::function_628641cd
// Checksum 0xb4b45f83, Offset: 0x5b0
// Size: 0xc2
function dom_flag_cap_fx_override(flag, team) {
    switch (flag.name) {
    case 11:
        if (team == "neutral") {
            return "ui/fx_dom_cap_indicator_neutral_r120";
        } else {
            return "ui/fx_dom_cap_indicator_team_r120";
        }
        break;
    case 12:
        if (team == "neutral") {
            return "ui/fx_dom_cap_indicator_neutral_r120";
        } else {
            return "ui/fx_dom_cap_indicator_team_r120";
        }
        break;
    case 13:
        if (team == "neutral") {
            return "ui/fx_dom_cap_indicator_neutral_r120";
        } else {
            return "ui/fx_dom_cap_indicator_team_r120";
        }
        break;
    }
}

