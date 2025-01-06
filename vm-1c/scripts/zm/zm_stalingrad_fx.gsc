#using scripts/codescripts/struct;
#using scripts/shared/flag_shared;
#using scripts/shared/util_shared;

#namespace zm_stalingrad_fx;

// Namespace zm_stalingrad_fx
// Params 0, eflags: 0x0
// Checksum 0xddd33384, Offset: 0x628
// Size: 0x24
function init() {
    function_f45953c();
    function_e6258024();
}

// Namespace zm_stalingrad_fx
// Params 0, eflags: 0x0
// Checksum 0x3e0c4437, Offset: 0x658
// Size: 0x1fa
function function_f45953c() {
    level._effect["drop_pod_marker"] = "dlc3/stalingrad/fx_drop_pod_ground_marker";
    level._effect["drop_pod_charge_kill"] = "dlc3/stalingrad/fx_drop_pod_zombie_soul";
    level._effect["drop_pod_smoke"] = "dlc3/stalingrad/fx_drop_pod_smk_ground";
    level._effect["drop_pod_115_bomb"] = "dlc3/stalingrad/fx_drop_pod_exp_success";
    level._effect["drop_pod_go_boom"] = "dlc3/stalingrad/fx_drop_pod_exp_fail";
    level._effect["drop_pod_reward_glow"] = "dlc3/stalingrad/fx_drop_pod_glow_pick_up";
    level._effect["current_effect"] = "debris/fx_debris_underwater_current_sgen_os";
    level._effect["drop_pod_hp_light_green"] = "dlc3/stalingrad/fx_drop_pod_health_light_green";
    level._effect["drop_pod_hp_light_yellow"] = "dlc3/stalingrad/fx_drop_pod_health_light_yellow";
    level._effect["drop_pod_hp_light_red"] = "dlc3/stalingrad/fx_drop_pod_health_light_red";
    level._effect["powerup_on_red"] = "zombie/fx_powerup_on_red_zmb";
    level._effect["powerup_grabbed_red"] = "zombie/fx_powerup_grab_red_zmb";
    level._effect["lockbox_unlock_light"] = "dlc3/stalingrad/fx_dragon_strike_lock_box";
    level._effect["elec_md"] = "zombie/fx_elec_player_md_zmb";
    level._effect["elec_sm"] = "zombie/fx_elec_player_sm_zmb";
    level._effect["elec_torso"] = "zombie/fx_elec_player_torso_zmb";
    level._effect["dragon_weakpoint_destroyed"] = "dlc3/stalingrad/fx_dragon_weak_point_bleeding";
    level._effect["meatball_impact"] = "zombie/fx_meatball_impact_ground_tell_zod_zmb";
}

// Namespace zm_stalingrad_fx
// Params 0, eflags: 0x0
// Checksum 0x99ec1590, Offset: 0x860
// Size: 0x4
function function_e6258024() {
    
}

// Namespace zm_stalingrad_fx
// Params 0, eflags: 0x0
// Checksum 0xd5ad6fbd, Offset: 0x870
// Size: 0xaa
function function_f205a5f1() {
    level._effect["jugger_light"] = "dlc3/stalingrad/fx_perk_juggernaut_sta";
    level._effect["doubletap2_light"] = "dlc3/stalingrad/fx_perk_doubletap_sta";
    level._effect["additionalprimaryweapon_light"] = "dlc3/stalingrad/fx_perk_mule_kick_sta";
    level._effect["revive_light"] = "dlc3/stalingrad/fx_perk_quick_revive_sta";
    level._effect["sleight_light"] = "dlc3/stalingrad/fx_perk_sleight_of_hand_sta";
    level._effect["marathon_light"] = "dlc3/stalingrad/fx_perk_stamin_up_sta";
}

