#using scripts/codescripts/struct;
#using scripts/mp/_load;
#using scripts/mp/_util;
#using scripts/shared/callbacks_shared;
#using scripts/shared/filter_shared;
#using scripts/shared/postfx_shared;
#using scripts/shared/trigger_shared;
#using scripts/shared/util_shared;
#using scripts/shared/water_surface;

#namespace waterfall;

// Namespace waterfall
// Params 1, eflags: 0x0
// Checksum 0xe893aaa0, Offset: 0x210
// Size: 0x93
function waterfalloverlay(localclientnum) {
    triggers = getentarray(localclientnum, "waterfall", "targetname");
    foreach (trigger in triggers) {
        trigger thread setupwaterfall(localclientnum);
    }
}

// Namespace waterfall
// Params 1, eflags: 0x0
// Checksum 0xaa980d76, Offset: 0x2b0
// Size: 0x93
function waterfallmistoverlay(localclientnum) {
    triggers = getentarray(localclientnum, "waterfall_mist", "targetname");
    foreach (trigger in triggers) {
        trigger thread setupwaterfallmist(localclientnum);
    }
}

// Namespace waterfall
// Params 1, eflags: 0x0
// Checksum 0xc0baeda8, Offset: 0x350
// Size: 0x32
function waterfallmistoverlayreset(localclientnum) {
    localplayer = getlocalplayer(localclientnum);
    localplayer.rainopacity = 0;
}

// Namespace waterfall
// Params 1, eflags: 0x0
// Checksum 0x15168490, Offset: 0x390
// Size: 0xd5
function setupwaterfallmist(localclientnum) {
    level notify("setupWaterfallmist_waterfall_csc" + localclientnum);
    level endon("setupWaterfallmist_waterfall_csc" + localclientnum);
    trigger = self;
    for (;;) {
        trigger waittill(#"trigger", trigplayer);
        if (!trigplayer islocalplayer()) {
            continue;
        }
        localclientnum = trigplayer getlocalclientnumber();
        if (isdefined(localclientnum)) {
            localplayer = getlocalplayer(localclientnum);
        } else {
            localplayer = trigplayer;
        }
        filter::init_filter_sprite_rain(localplayer);
        trigger thread trigger::function_thread(localplayer, &trig_enter_waterfall_mist, &trig_leave_waterfall_mist);
    }
}

// Namespace waterfall
// Params 2, eflags: 0x0
// Checksum 0xb23e2215, Offset: 0x470
// Size: 0xcd
function setupwaterfall(localclientnum, localowner) {
    level notify("setupWaterfall_waterfall_csc" + localclientnum);
    level endon("setupWaterfall_waterfall_csc" + localclientnum);
    trigger = self;
    for (;;) {
        trigger waittill(#"trigger", trigplayer);
        if (!trigplayer islocalplayer()) {
            continue;
        }
        localclientnum = trigplayer getlocalclientnumber();
        if (isdefined(localclientnum)) {
            localplayer = getlocalplayer(localclientnum);
        } else {
            localplayer = trigplayer;
        }
        trigger thread trigger::function_thread(localplayer, &trig_enter_waterfall, &trig_leave_waterfall);
    }
}

// Namespace waterfall
// Params 1, eflags: 0x0
// Checksum 0xe3215db7, Offset: 0x548
// Size: 0x95
function trig_enter_waterfall(localplayer) {
    trigger = self;
    localclientnum = localplayer.localclientnum;
    localplayer thread postfx::playpostfxbundle("pstfx_waterfall");
    playsound(0, "amb_waterfall_hit", (0, 0, 0));
    while (trigger istouching(localplayer)) {
        localplayer playrumbleonentity(localclientnum, "waterfall_rumble");
        wait 0.1;
    }
}

// Namespace waterfall
// Params 1, eflags: 0x0
// Checksum 0xd3348c77, Offset: 0x5e8
// Size: 0x62
function trig_leave_waterfall(localplayer) {
    trigger = self;
    localclientnum = localplayer.localclientnum;
    localplayer postfx::stoppostfxbundle();
    if (isunderwater(localclientnum) == 0) {
        localplayer thread water_surface::startwatersheeting();
    }
}

// Namespace waterfall
// Params 1, eflags: 0x0
// Checksum 0xed4f346b, Offset: 0x658
// Size: 0x165
function trig_enter_waterfall_mist(localplayer) {
    localplayer endon(#"entityshutdown");
    trigger = self;
    if (!isdefined(localplayer.rainopacity)) {
        localplayer.rainopacity = 0;
    }
    if (localplayer.rainopacity == 0) {
        filter::set_filter_sprite_rain_seed_offset(localplayer, 0, randomfloat(1));
    }
    filter::enable_filter_sprite_rain(localplayer, 0);
    while (trigger istouching(localplayer)) {
        localclientnum = trigger.localclientnum;
        if (!isdefined(localclientnum)) {
            localclientnum = localplayer getlocalclientnumber();
        }
        if (isunderwater(localclientnum)) {
            filter::disable_filter_sprite_rain(localplayer, 0);
            break;
        }
        localplayer.rainopacity += 0.003;
        if (localplayer.rainopacity > 1) {
            localplayer.rainopacity = 1;
        }
        filter::set_filter_sprite_rain_opacity(localplayer, 0, localplayer.rainopacity);
        filter::set_filter_sprite_rain_elapsed(localplayer, 0, localplayer getclienttime());
        wait 0.016;
    }
}

// Namespace waterfall
// Params 1, eflags: 0x0
// Checksum 0xdcb581c3, Offset: 0x7c8
// Size: 0x11a
function trig_leave_waterfall_mist(localplayer) {
    localplayer endon(#"entityshutdown");
    trigger = self;
    if (isdefined(localplayer.rainopacity)) {
        while (!trigger istouching(localplayer) && localplayer.rainopacity > 0) {
            localclientnum = trigger.localclientnum;
            if (isunderwater(localclientnum)) {
                filter::disable_filter_sprite_rain(localplayer, 0);
                break;
            }
            localplayer.rainopacity -= 0.005;
            filter::set_filter_sprite_rain_opacity(localplayer, 0, localplayer.rainopacity);
            filter::set_filter_sprite_rain_elapsed(localplayer, 0, localplayer getclienttime());
            wait 0.016;
        }
    }
    localplayer.rainopacity = 0;
    filter::disable_filter_sprite_rain(localplayer, 0);
}

