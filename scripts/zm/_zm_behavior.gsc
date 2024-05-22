#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_spawner;
#using scripts/zm/_zm_behavior_utility;
#using scripts/zm/_zm_attackables;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/ai/zombie;
#using scripts/shared/ai/systems/blackboard;
#using scripts/shared/ai/systems/behavior_tree_utility;
#using scripts/shared/ai/archetype_locomotion_utility;
#using scripts/shared/ai/archetype_utility;
#using scripts/shared/ai/systems/animation_state_machine_mocomp;
#using scripts/shared/ai/systems/animation_state_machine_notetracks;
#using scripts/shared/ai/systems/animation_state_machine_utility;
#using scripts/shared/ai_shared;
#using scripts/shared/math_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/util_shared;
#using scripts/shared/system_shared;
#using scripts/shared/clientfield_shared;

#namespace zm_behavior;

// Namespace zm_behavior
// Params 0, eflags: 0x2
// Checksum 0xb790ccae, Offset: 0xaf0
// Size: 0x50
function init() {
    initzmbehaviorsandasm();
    level.zigzag_activation_distance = -16;
    level.zigzag_distance_min = -16;
    level.zigzag_distance_max = 480;
    level.inner_zigzag_radius = 0;
    level.outer_zigzag_radius = 96;
}

// Namespace zm_behavior
// Params 0, eflags: 0x5 linked
// Checksum 0xcfa1274f, Offset: 0xb48
// Size: 0xa1c
function initzmbehaviorsandasm() {
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieFindFleshService", &zombiefindflesh);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieEnteredPlayableService", &zombieenteredplayable);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldMove", &shouldmovecondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldTear", &zombieshouldtearcondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldAttackThroughBoards", &zombieshouldattackthroughboardscondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldTaunt", &zombieshouldtauntcondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieGotToEntrance", &zombiegottoentrancecondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieGotToAttackSpot", &zombiegottoattackspotcondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieHasAttackSpotAlready", &zombiehasattackspotalreadycondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldEnterPlayable", &zombieshouldenterplayablecondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("isChunkValid", &ischunkvalidcondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("inPlayableArea", &inplayablearea);
    behaviortreenetworkutility::registerbehaviortreescriptapi("shouldSkipTeardown", &shouldskipteardown);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIsThinkDone", &zombieisthinkdone);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIsAtGoal", &zombieisatgoal);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIsAtEntrance", &zombieisatentrance);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldMoveAway", &zombieshouldmoveawaycondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("wasKilledByTesla", &waskilledbyteslacondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldStun", &zombieshouldstun);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIsBeingGrappled", &zombieisbeinggrappled);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldKnockdown", &zombieshouldknockdown);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIsPushed", &zombieispushed);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieKilledWhileGettingPulled", &zombiekilledwhilegettingpulled);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieKilledByBlackHoleBombCondition", &zombiekilledbyblackholebombcondition);
    behaviortreenetworkutility::registerbehaviortreescriptapi("disablePowerups", &disablepowerups);
    behaviortreenetworkutility::registerbehaviortreescriptapi("enablePowerups", &enablepowerups);
    behaviortreenetworkutility::registerbehaviortreeaction("zombieMoveToEntranceAction", &zombiemovetoentranceaction, undefined, &zombiemovetoentranceactionterminate);
    behaviortreenetworkutility::registerbehaviortreeaction("zombieMoveToAttackSpotAction", &zombiemovetoattackspotaction, undefined, &zombiemovetoattackspotactionterminate);
    behaviortreenetworkutility::registerbehaviortreeaction("zombieIdleAction", undefined, undefined, undefined);
    behaviortreenetworkutility::registerbehaviortreeaction("zombieMoveAway", &zombiemoveaway, undefined, undefined);
    behaviortreenetworkutility::registerbehaviortreeaction("zombieTraverseAction", &zombietraverseaction, undefined, &zombietraverseactionterminate);
    behaviortreenetworkutility::registerbehaviortreeaction("holdBoardAction", &zombieholdboardaction, undefined, &zombieholdboardactionterminate);
    behaviortreenetworkutility::registerbehaviortreeaction("grabBoardAction", &zombiegrabboardaction, undefined, &zombiegrabboardactionterminate);
    behaviortreenetworkutility::registerbehaviortreeaction("pullBoardAction", &zombiepullboardaction, undefined, &zombiepullboardactionterminate);
    behaviortreenetworkutility::registerbehaviortreeaction("zombieAttackThroughBoardsAction", &zombieattackthroughboardsaction, undefined, &zombieattackthroughboardsactionterminate);
    behaviortreenetworkutility::registerbehaviortreeaction("zombieTauntAction", &zombietauntaction, undefined, &zombietauntactionterminate);
    behaviortreenetworkutility::registerbehaviortreeaction("zombieMantleAction", &zombiemantleaction, undefined, &zombiemantleactionterminate);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieStunActionStart", &zombiestunactionstart);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieStunActionEnd", &zombiestunactionend);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieGrappleActionStart", &zombiegrappleactionstart);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieKnockdownActionStart", &zombieknockdownactionstart);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieGetupActionTerminate", &zombiegetupactionterminate);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombiePushedActionStart", &zombiepushedactionstart);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombiePushedActionTerminate", &zombiepushedactionterminate);
    behaviortreenetworkutility::registerbehaviortreeaction("zombieBlackHoleBombPullAction", &zombieblackholebombpullstart, &zombieblackholebombpullupdate, &zombieblackholebombpullend);
    behaviortreenetworkutility::registerbehaviortreeaction("zombieBlackHoleBombDeathAction", &zombiekilledbyblackholebombstart, undefined, &zombiekilledbyblackholebombend);
    behaviortreenetworkutility::registerbehaviortreescriptapi("getChunkService", &getchunkservice);
    behaviortreenetworkutility::registerbehaviortreescriptapi("updateChunkService", &updatechunkservice);
    behaviortreenetworkutility::registerbehaviortreescriptapi("updateAttackSpotService", &updateattackspotservice);
    behaviortreenetworkutility::registerbehaviortreescriptapi("findNodesService", &findnodesservice);
    behaviortreenetworkutility::registerbehaviortreescriptapi("zombieAttackableObjectService", &zombieattackableobjectservice);
    animationstatenetwork::registeranimationmocomp("mocomp_board_tear@zombie", &boardtearmocompstart, &boardtearmocompupdate, undefined);
    animationstatenetwork::registeranimationmocomp("mocomp_barricade_enter@zombie", &barricadeentermocompstart, &barricadeentermocompupdate, &barricadeentermocompterminate);
    animationstatenetwork::registeranimationmocomp("mocomp_barricade_enter_no_z@zombie", &barricadeentermocompnozstart, &barricadeentermocompnozupdate, &barricadeentermocompnozterminate);
    animationstatenetwork::registernotetrackhandlerfunction("destroy_piece", &notetrackboardtear);
    animationstatenetwork::registernotetrackhandlerfunction("zombie_window_melee", &notetrackboardmelee);
    animationstatenetwork::registernotetrackhandlerfunction("bhb_burst", &zombiebhbburst);
    setdvar("scr_zm_use_code_enemy_selection", 1);
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x5a6b6ca9, Offset: 0x1570
// Size: 0x9f6
function zombiefindflesh(behaviortreeentity) {
    if (isdefined(behaviortreeentity.enablepushtime)) {
        if (gettime() >= behaviortreeentity.enablepushtime) {
            behaviortreeentity function_1762804b(1);
            behaviortreeentity.enablepushtime = undefined;
        }
    }
    if (getdvarint("scr_zm_use_code_enemy_selection", 0)) {
        zombiefindfleshcode(behaviortreeentity);
        return;
    }
    if (level.intermission) {
        return;
    }
    if (behaviortreeentity getpathmode() == "dont move") {
        return;
    }
    behaviortreeentity.ignoreme = 0;
    behaviortreeentity.ignore_player = [];
    behaviortreeentity.goalradius = 30;
    if (isdefined(behaviortreeentity.ignore_find_flesh) && behaviortreeentity.ignore_find_flesh) {
        return;
    }
    if (behaviortreeentity.team == "allies") {
        behaviortreeentity findzombieenemy();
        return;
    }
    if (zombieshouldmoveawaycondition(behaviortreeentity)) {
        return;
    }
    zombie_poi = behaviortreeentity zm_utility::get_zombie_point_of_interest(behaviortreeentity.origin);
    behaviortreeentity.zombie_poi = zombie_poi;
    players = getplayers();
    if (!isdefined(behaviortreeentity.ignore_player) || players.size == 1) {
        behaviortreeentity.ignore_player = [];
    } else if (!isdefined(level._should_skip_ignore_player_logic) || ![[ level._should_skip_ignore_player_logic ]]()) {
        for (i = 0; i < behaviortreeentity.ignore_player.size; i++) {
            if (isdefined(behaviortreeentity.ignore_player[i]) && isdefined(behaviortreeentity.ignore_player[i].ignore_counter) && behaviortreeentity.ignore_player[i].ignore_counter > 3) {
                behaviortreeentity.ignore_player[i].ignore_counter = 0;
                behaviortreeentity.ignore_player = arrayremovevalue(behaviortreeentity.ignore_player, behaviortreeentity.ignore_player[i]);
                if (!isdefined(behaviortreeentity.ignore_player)) {
                    behaviortreeentity.ignore_player = [];
                }
                i = 0;
                continue;
            }
        }
    }
    behaviortreeentity zombie_utility::run_ignore_player_handler();
    player = zm_utility::get_closest_valid_player(behaviortreeentity.origin, behaviortreeentity.ignore_player);
    designated_target = 0;
    if (isdefined(player.b_is_designated_target) && isdefined(player) && player.b_is_designated_target) {
        designated_target = 1;
    }
    if (!isdefined(player) && !isdefined(zombie_poi) && !isdefined(behaviortreeentity.attackable)) {
        if (isdefined(behaviortreeentity.ignore_player)) {
            if (isdefined(level._should_skip_ignore_player_logic) && [[ level._should_skip_ignore_player_logic ]]()) {
                return;
            }
            behaviortreeentity.ignore_player = [];
        }
        /#
            if (isdefined(behaviortreeentity.ispuppet) && behaviortreeentity.ispuppet) {
                return;
            }
        #/
        if (isdefined(level.no_target_override)) {
            [[ level.no_target_override ]](behaviortreeentity);
            return;
        }
        behaviortreeentity setgoal(behaviortreeentity.origin);
        return;
    }
    if (!isdefined(level.var_4cc24155) || ![[ level.var_4cc24155 ]]()) {
        behaviortreeentity.enemyoverride = zombie_poi;
        behaviortreeentity.favoriteenemy = player;
    }
    if (isdefined(behaviortreeentity.v_zombie_custom_goal_pos)) {
        goalpos = behaviortreeentity.v_zombie_custom_goal_pos;
        if (isdefined(behaviortreeentity.n_zombie_custom_goal_radius)) {
            behaviortreeentity.goalradius = behaviortreeentity.n_zombie_custom_goal_radius;
        }
        behaviortreeentity setgoal(goalpos);
    } else if (isdefined(behaviortreeentity.enemyoverride) && isdefined(behaviortreeentity.enemyoverride[1])) {
        behaviortreeentity.has_exit_point = undefined;
        goalpos = behaviortreeentity.enemyoverride[0];
        if (!isdefined(zombie_poi)) {
            aiprofile_beginentry("zombiefindflesh-enemyoverride");
            queryresult = positionquery_source_navigation(goalpos, 0, 48, 36, 4);
            aiprofile_endentry();
            foreach (point in queryresult.data) {
                goalpos = point.origin;
                break;
            }
        }
        behaviortreeentity setgoal(goalpos);
    } else if (isdefined(behaviortreeentity.attackable) && !designated_target) {
        if (isdefined(behaviortreeentity.attackable_slot)) {
            if (isdefined(behaviortreeentity.attackable_goal_radius)) {
                behaviortreeentity.goalradius = behaviortreeentity.attackable_goal_radius;
            }
            nav_mesh = getclosestpointonnavmesh(behaviortreeentity.attackable_slot.origin, 64);
            if (isdefined(nav_mesh)) {
                behaviortreeentity setgoal(nav_mesh);
            } else {
                behaviortreeentity setgoal(behaviortreeentity.attackable_slot.origin);
            }
        }
    } else if (isdefined(behaviortreeentity.favoriteenemy)) {
        behaviortreeentity.has_exit_point = undefined;
        behaviortreeentity.ignoreall = 0;
        if (isdefined(level.enemy_location_override_func)) {
            goalpos = [[ level.enemy_location_override_func ]](behaviortreeentity, behaviortreeentity.favoriteenemy);
            if (isdefined(goalpos)) {
                behaviortreeentity setgoal(goalpos);
            } else {
                behaviortreeentity zombieupdategoal();
            }
        } else if (isdefined(behaviortreeentity.is_rat_test) && behaviortreeentity.is_rat_test) {
        } else if (zombieshouldmoveawaycondition(behaviortreeentity)) {
        } else if (isdefined(behaviortreeentity.favoriteenemy.last_valid_position)) {
            behaviortreeentity zombieupdategoal();
        }
    }
    if (players.size > 1) {
        for (i = 0; i < behaviortreeentity.ignore_player.size; i++) {
            if (isdefined(behaviortreeentity.ignore_player[i])) {
                if (!isdefined(behaviortreeentity.ignore_player[i].ignore_counter)) {
                    behaviortreeentity.ignore_player[i].ignore_counter = 0;
                    continue;
                }
                behaviortreeentity.ignore_player[i].ignore_counter = behaviortreeentity.ignore_player[i].ignore_counter + 1;
            }
        }
    }
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xa24fd650, Offset: 0x1f70
// Size: 0x46c
function zombiefindfleshcode(behaviortreeentity) {
    aiprofile_beginentry("zombieFindFleshCode");
    if (level.intermission) {
        aiprofile_endentry();
        return;
    }
    behaviortreeentity.ignore_player = [];
    behaviortreeentity.goalradius = 30;
    if (behaviortreeentity.team == "allies") {
        behaviortreeentity findzombieenemy();
        aiprofile_endentry();
        return;
    }
    if (level.wait_and_revive) {
        aiprofile_endentry();
        return;
    }
    if (level.zombie_poi_array.size > 0) {
        zombie_poi = behaviortreeentity zm_utility::get_zombie_point_of_interest(behaviortreeentity.origin);
    }
    behaviortreeentity zombie_utility::run_ignore_player_handler();
    zm_utility::update_valid_players(behaviortreeentity.origin, behaviortreeentity.ignore_player);
    if (!isdefined(behaviortreeentity.enemy) && !isdefined(zombie_poi)) {
        /#
            if (isdefined(behaviortreeentity.ispuppet) && behaviortreeentity.ispuppet) {
                aiprofile_endentry();
                return;
            }
        #/
        if (isdefined(level.no_target_override)) {
            [[ level.no_target_override ]](behaviortreeentity);
        } else {
            behaviortreeentity setgoal(behaviortreeentity.origin);
        }
        aiprofile_endentry();
        return;
    }
    behaviortreeentity.enemyoverride = zombie_poi;
    if (isdefined(behaviortreeentity.enemyoverride) && isdefined(behaviortreeentity.enemyoverride[1])) {
        behaviortreeentity.has_exit_point = undefined;
        goalpos = behaviortreeentity.enemyoverride[0];
        queryresult = positionquery_source_navigation(goalpos, 0, 48, 36, 4);
        foreach (point in queryresult.data) {
            goalpos = point.origin;
            break;
        }
        behaviortreeentity setgoal(goalpos);
    } else if (isdefined(behaviortreeentity.enemy)) {
        behaviortreeentity.has_exit_point = undefined;
        /#
            if (isdefined(behaviortreeentity.is_rat_test) && behaviortreeentity.is_rat_test) {
                aiprofile_endentry();
                return;
            }
        #/
        if (isdefined(level.enemy_location_override_func)) {
            goalpos = [[ level.enemy_location_override_func ]](behaviortreeentity, behaviortreeentity.enemy);
            if (isdefined(goalpos)) {
                behaviortreeentity setgoal(goalpos);
            } else {
                behaviortreeentity zombieupdategoalcode();
            }
        } else if (isdefined(behaviortreeentity.enemy.last_valid_position)) {
            behaviortreeentity zombieupdategoalcode();
        }
    }
    aiprofile_endentry();
}

// Namespace zm_behavior
// Params 0, eflags: 0x1 linked
// Checksum 0x601e002a, Offset: 0x23e8
// Size: 0x604
function zombieupdategoal() {
    aiprofile_beginentry("zombieUpdateGoal");
    shouldrepath = 0;
    if (!shouldrepath && isdefined(self.favoriteenemy)) {
        if (!isdefined(self.nextgoalupdate) || self.nextgoalupdate <= gettime()) {
            shouldrepath = 1;
        } else if (distancesquared(self.origin, self.favoriteenemy.origin) <= level.zigzag_activation_distance * level.zigzag_activation_distance) {
            shouldrepath = 1;
        } else if (isdefined(self.pathgoalpos)) {
            distancetogoalsqr = distancesquared(self.origin, self.pathgoalpos);
            shouldrepath = distancetogoalsqr < 72 * 72;
        }
    }
    if (isdefined(level.validate_on_navmesh) && level.validate_on_navmesh) {
        if (!ispointonnavmesh(self.origin, self)) {
            shouldrepath = 0;
        }
    }
    if (isdefined(self.keep_moving) && self.keep_moving) {
        if (gettime() > self.keep_moving_time) {
            self.keep_moving = 0;
        }
    }
    if (shouldrepath) {
        goalpos = self.favoriteenemy.origin;
        if (isdefined(self.favoriteenemy.last_valid_position)) {
            goalpos = self.favoriteenemy.last_valid_position;
        }
        self setgoal(goalpos);
        should_zigzag = 1;
        if (isdefined(level.should_zigzag)) {
            should_zigzag = self [[ level.should_zigzag ]]();
        }
        if (isdefined(level.do_randomized_zigzag_path) && level.do_randomized_zigzag_path && should_zigzag) {
            if (distancesquared(self.origin, goalpos) > level.zigzag_activation_distance * level.zigzag_activation_distance) {
                self.keep_moving = 1;
                self.keep_moving_time = gettime() + -6;
                path = self calcapproximatepathtoposition(goalpos, 0);
                /#
                    if (getdvarint("zombieHasAttackSpotAlready")) {
                        for (index = 1; index < path.size; index++) {
                            recordline(path[index - 1], path[index], (1, 0.5, 0), "zombieHasAttackSpotAlready", self);
                        }
                    }
                #/
                deviationdistance = randomintrange(level.zigzag_distance_min, level.zigzag_distance_max);
                if (isdefined(self.zigzag_distance_min) && isdefined(self.zigzag_distance_max)) {
                    deviationdistance = randomintrange(self.zigzag_distance_min, self.zigzag_distance_max);
                }
                segmentlength = 0;
                for (index = 1; index < path.size; index++) {
                    currentseglength = distance(path[index - 1], path[index]);
                    if (segmentlength + currentseglength > deviationdistance) {
                        remaininglength = deviationdistance - segmentlength;
                        seedposition = path[index - 1] + vectornormalize(path[index] - path[index - 1]) * remaininglength;
                        /#
                            recordcircle(seedposition, 2, (1, 0.5, 0), "zombieHasAttackSpotAlready", self);
                        #/
                        innerzigzagradius = level.inner_zigzag_radius;
                        outerzigzagradius = level.outer_zigzag_radius;
                        queryresult = positionquery_source_navigation(seedposition, innerzigzagradius, outerzigzagradius, 36, 16, self, 16);
                        positionquery_filter_inclaimedlocation(queryresult, self);
                        if (queryresult.data.size > 0) {
                            point = queryresult.data[randomint(queryresult.data.size)];
                            self setgoal(point.origin);
                        }
                        break;
                    }
                    segmentlength += currentseglength;
                }
            }
        }
        self.nextgoalupdate = gettime() + randomintrange(500, 1000);
    }
    aiprofile_endentry();
}

// Namespace zm_behavior
// Params 0, eflags: 0x1 linked
// Checksum 0x3f20b860, Offset: 0x29f8
// Size: 0x54c
function zombieupdategoalcode() {
    aiprofile_beginentry("zombieUpdateGoalCode");
    shouldrepath = 0;
    if (!shouldrepath && isdefined(self.enemy)) {
        if (!isdefined(self.nextgoalupdate) || self.nextgoalupdate <= gettime()) {
            shouldrepath = 1;
        } else if (distancesquared(self.origin, self.enemy.origin) <= -56 * -56) {
            shouldrepath = 1;
        } else if (isdefined(self.pathgoalpos)) {
            distancetogoalsqr = distancesquared(self.origin, self.pathgoalpos);
            shouldrepath = distancetogoalsqr < 72 * 72;
        }
    }
    if (isdefined(self.keep_moving) && self.keep_moving) {
        if (gettime() > self.keep_moving_time) {
            self.keep_moving = 0;
        }
    }
    if (shouldrepath) {
        goalpos = self.enemy.origin;
        if (isdefined(self.enemy.last_valid_position)) {
            goalpos = self.enemy.last_valid_position;
        }
        if (isdefined(level.do_randomized_zigzag_path) && level.do_randomized_zigzag_path) {
            if (distancesquared(self.origin, goalpos) > -16 * -16) {
                self.keep_moving = 1;
                self.keep_moving_time = gettime() + -6;
                path = self calcapproximatepathtoposition(goalpos, 0);
                /#
                    if (getdvarint("zombieHasAttackSpotAlready")) {
                        for (index = 1; index < path.size; index++) {
                            recordline(path[index - 1], path[index], (1, 0.5, 0), "zombieHasAttackSpotAlready", self);
                        }
                    }
                #/
                deviationdistance = randomintrange(-16, 480);
                segmentlength = 0;
                for (index = 1; index < path.size; index++) {
                    currentseglength = distance(path[index - 1], path[index]);
                    if (segmentlength + currentseglength > deviationdistance) {
                        remaininglength = deviationdistance - segmentlength;
                        seedposition = path[index - 1] + vectornormalize(path[index] - path[index - 1]) * remaininglength;
                        /#
                            recordcircle(seedposition, 2, (1, 0.5, 0), "zombieHasAttackSpotAlready", self);
                        #/
                        innerzigzagradius = level.inner_zigzag_radius;
                        outerzigzagradius = level.outer_zigzag_radius;
                        queryresult = positionquery_source_navigation(seedposition, innerzigzagradius, outerzigzagradius, 36, 16, self, 16);
                        positionquery_filter_inclaimedlocation(queryresult, self);
                        if (queryresult.data.size > 0) {
                            point = queryresult.data[randomint(queryresult.data.size)];
                            if (tracepassedonnavmesh(seedposition, point.origin, 16)) {
                                goalpos = point.origin;
                            }
                        }
                        break;
                    }
                    segmentlength += currentseglength;
                }
            }
        }
        self setgoal(goalpos);
        self.nextgoalupdate = gettime() + randomintrange(500, 1000);
    }
    aiprofile_endentry();
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x7f76bced, Offset: 0x2f50
// Size: 0xf2
function zombieenteredplayable(behaviortreeentity) {
    if (!isdefined(level.playable_areas)) {
        level.playable_areas = getentarray("player_volume", "script_noteworthy");
    }
    foreach (area in level.playable_areas) {
        if (behaviortreeentity istouching(area)) {
            behaviortreeentity zm_spawner::zombie_complete_emerging_into_playable_area();
            return true;
        }
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xf2629051, Offset: 0x3050
// Size: 0x5a
function shouldmovecondition(behaviortreeentity) {
    if (behaviortreeentity haspath()) {
        return true;
    }
    if (isdefined(behaviortreeentity.keep_moving) && behaviortreeentity.keep_moving) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xa201b4f1, Offset: 0x30b8
// Size: 0x12
function zombieshouldmoveawaycondition(behaviortreeentity) {
    return level.wait_and_revive;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xbe9fe714, Offset: 0x30d8
// Size: 0x3a
function waskilledbyteslacondition(behaviortreeentity) {
    if (isdefined(behaviortreeentity.tesla_death) && behaviortreeentity.tesla_death) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x74a0f634, Offset: 0x3120
// Size: 0x20
function disablepowerups(behaviortreeentity) {
    behaviortreeentity.no_powerups = 1;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x178f55f4, Offset: 0x3148
// Size: 0x1c
function enablepowerups(behaviortreeentity) {
    behaviortreeentity.no_powerups = 0;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x650b76c7, Offset: 0x3170
// Size: 0x316
function zombiemoveaway(behaviortreeentity, asmstatename) {
    player = util::gethostplayer();
    queryresult = level.move_away_points;
    animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
    if (!isdefined(queryresult)) {
        return 5;
    }
    for (i = 0; i < queryresult.data.size; i++) {
        if (!zm_utility::check_point_in_playable_area(queryresult.data[i].origin)) {
            continue;
        }
        isbehind = vectordot(player.origin - behaviortreeentity.origin, queryresult.data[i].origin - behaviortreeentity.origin);
        if (isbehind < 0) {
            behaviortreeentity setgoal(queryresult.data[i].origin);
            arrayremoveindex(level.move_away_points.data, i, 0);
            i--;
            return 5;
        }
    }
    for (i = 0; i < queryresult.data.size; i++) {
        if (!zm_utility::check_point_in_playable_area(queryresult.data[i].origin)) {
            continue;
        }
        dist_zombie = distancesquared(queryresult.data[i].origin, behaviortreeentity.origin);
        dist_player = distancesquared(queryresult.data[i].origin, player.origin);
        if (dist_zombie < dist_player) {
            behaviortreeentity setgoal(queryresult.data[i].origin);
            arrayremoveindex(level.move_away_points.data, i, 0);
            i--;
            return 5;
        }
    }
    return 5;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x192b5bca, Offset: 0x3490
// Size: 0x3a
function zombieisbeinggrappled(behaviortreeentity) {
    if (isdefined(behaviortreeentity.grapple_is_fatal) && behaviortreeentity.grapple_is_fatal) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x644e3673, Offset: 0x34d8
// Size: 0x3a
function zombieshouldknockdown(behaviortreeentity) {
    if (isdefined(behaviortreeentity.knockdown) && behaviortreeentity.knockdown) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xc1d32458, Offset: 0x3520
// Size: 0x3a
function zombieispushed(behaviortreeentity) {
    if (isdefined(behaviortreeentity.pushed) && behaviortreeentity.pushed) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x4b9473d4, Offset: 0x3568
// Size: 0x34
function zombiegrappleactionstart(behaviortreeentity) {
    blackboard::setblackboardattribute(behaviortreeentity, "_grapple_direction", self.grapple_direction);
}

// Namespace zm_behavior
// Params 1, eflags: 0x5 linked
// Checksum 0x7e7ccf1b, Offset: 0x35a8
// Size: 0x84
function zombieknockdownactionstart(behaviortreeentity) {
    blackboard::setblackboardattribute(behaviortreeentity, "_knockdown_direction", behaviortreeentity.knockdown_direction);
    blackboard::setblackboardattribute(behaviortreeentity, "_knockdown_type", behaviortreeentity.knockdown_type);
    blackboard::setblackboardattribute(behaviortreeentity, "_getup_direction", behaviortreeentity.getup_direction);
}

// Namespace zm_behavior
// Params 1, eflags: 0x5 linked
// Checksum 0xa8d5d019, Offset: 0x3638
// Size: 0x1c
function zombiegetupactionterminate(behaviortreeentity) {
    behaviortreeentity.knockdown = 0;
}

// Namespace zm_behavior
// Params 1, eflags: 0x5 linked
// Checksum 0x5be79c35, Offset: 0x3660
// Size: 0x34
function zombiepushedactionstart(behaviortreeentity) {
    blackboard::setblackboardattribute(behaviortreeentity, "_push_direction", behaviortreeentity.push_direction);
}

// Namespace zm_behavior
// Params 1, eflags: 0x5 linked
// Checksum 0x73dd2705, Offset: 0x36a0
// Size: 0x1c
function zombiepushedactionterminate(behaviortreeentity) {
    behaviortreeentity.pushed = 0;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x91982099, Offset: 0x36c8
// Size: 0x60
function zombieshouldstun(behaviortreeentity) {
    if (isdefined(behaviortreeentity.var_128cd975) && behaviortreeentity.var_128cd975 && !(isdefined(behaviortreeentity.tesla_death) && behaviortreeentity.tesla_death)) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x39bb1468, Offset: 0x3730
// Size: 0xc
function zombiestunactionstart(behaviortreeentity) {
    
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x15f20e20, Offset: 0x3748
// Size: 0x1c
function zombiestunactionend(behaviortreeentity) {
    behaviortreeentity.var_128cd975 = 0;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0xc396708f, Offset: 0x3770
// Size: 0x60
function zombietraverseaction(behaviortreeentity, asmstatename) {
    aiutility::traverseactionstart(behaviortreeentity, asmstatename);
    behaviortreeentity.old_powerups = behaviortreeentity.no_powerups;
    disablepowerups(behaviortreeentity);
    return 5;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0xfa7f2ef4, Offset: 0x37d8
// Size: 0xb0
function zombietraverseactionterminate(behaviortreeentity, asmstatename) {
    if (behaviortreeentity asmgetstatus() == "asm_status_complete") {
        behaviortreeentity.no_powerups = behaviortreeentity.old_powerups;
        if (!(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs)) {
            behaviortreeentity function_1762804b(0);
            behaviortreeentity.enablepushtime = gettime() + 1000;
        }
    }
    return 4;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x467618b7, Offset: 0x3890
// Size: 0x3a
function zombiegottoentrancecondition(behaviortreeentity) {
    if (isdefined(behaviortreeentity.got_to_entrance) && behaviortreeentity.got_to_entrance) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x82a00, Offset: 0x38d8
// Size: 0x3a
function zombiegottoattackspotcondition(behaviortreeentity) {
    if (isdefined(behaviortreeentity.at_entrance_tear_spot) && behaviortreeentity.at_entrance_tear_spot) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x9f0b1708, Offset: 0x3920
// Size: 0x3e
function zombiehasattackspotalreadycondition(behaviortreeentity) {
    if (isdefined(behaviortreeentity.attacking_spot_index) && behaviortreeentity.attacking_spot_index >= 0) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xd55d1d5a, Offset: 0x3968
// Size: 0x76
function zombieshouldtearcondition(behaviortreeentity) {
    if (isdefined(behaviortreeentity.first_node) && isdefined(behaviortreeentity.first_node.barrier_chunks)) {
        if (!zm_utility::all_chunks_destroyed(behaviortreeentity.first_node, behaviortreeentity.first_node.barrier_chunks)) {
            return true;
        }
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x91d34010, Offset: 0x39e8
// Size: 0x318
function zombieshouldattackthroughboardscondition(behaviortreeentity) {
    if (isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs) {
        return false;
    }
    if (isdefined(behaviortreeentity.first_node.zbarrier)) {
        if (!behaviortreeentity.first_node.zbarrier zbarriersupportszombiereachthroughattacks()) {
            chunks = undefined;
            if (isdefined(behaviortreeentity.first_node)) {
                chunks = zm_utility::get_non_destroyed_chunks(behaviortreeentity.first_node, behaviortreeentity.first_node.barrier_chunks);
            }
            if (isdefined(chunks) && chunks.size > 0) {
                return false;
            }
        }
    }
    if (getdvarstring("zombie_reachin_freq") == "") {
        setdvar("zombie_reachin_freq", "50");
    }
    freq = getdvarint("zombie_reachin_freq");
    players = getplayers();
    attack = 0;
    behaviortreeentity.player_targets = [];
    for (i = 0; i < players.size; i++) {
        if (isalive(players[i]) && !isdefined(players[i].revivetrigger) && distance2d(behaviortreeentity.origin, players[i].origin) <= 109.8 && !(isdefined(players[i].zombie_vars["zombie_powerup_zombie_blood_on"]) && players[i].zombie_vars["zombie_powerup_zombie_blood_on"]) && !(isdefined(players[i].ignoreme) && players[i].ignoreme)) {
            behaviortreeentity.player_targets[behaviortreeentity.player_targets.size] = players[i];
            attack = 1;
        }
    }
    if (!attack || freq < randomint(100)) {
        return false;
    }
    return true;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xbb73bdd6, Offset: 0x3d08
// Size: 0x118
function zombieshouldtauntcondition(behaviortreeentity) {
    if (isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs) {
        return false;
    }
    if (!isdefined(behaviortreeentity.first_node.zbarrier)) {
        return false;
    }
    if (!behaviortreeentity.first_node.zbarrier zbarriersupportszombietaunts()) {
        return false;
    }
    if (getdvarstring("zombie_taunt_freq") == "") {
        setdvar("zombie_taunt_freq", "5");
    }
    freq = getdvarint("zombie_taunt_freq");
    if (freq >= randomint(100)) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xaa7c11fa, Offset: 0x3e28
// Size: 0xc0
function zombieshouldenterplayablecondition(behaviortreeentity) {
    if (isdefined(behaviortreeentity.first_node) && isdefined(behaviortreeentity.first_node.barrier_chunks)) {
        if (zm_utility::all_chunks_destroyed(behaviortreeentity.first_node, behaviortreeentity.first_node.barrier_chunks)) {
            if (isdefined(behaviortreeentity.at_entrance_tear_spot) && behaviortreeentity.at_entrance_tear_spot && !(isdefined(behaviortreeentity.completed_emerging_into_playable_area) && behaviortreeentity.completed_emerging_into_playable_area)) {
                return true;
            }
        }
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xf0a95612, Offset: 0x3ef0
// Size: 0x28
function ischunkvalidcondition(behaviortreeentity) {
    if (isdefined(behaviortreeentity.chunk)) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xd6a5567, Offset: 0x3f20
// Size: 0x3a
function inplayablearea(behaviortreeentity) {
    if (isdefined(behaviortreeentity.completed_emerging_into_playable_area) && behaviortreeentity.completed_emerging_into_playable_area) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x708ac40b, Offset: 0x3f68
// Size: 0x36
function shouldskipteardown(behaviortreeentity) {
    if (behaviortreeentity zm_spawner::should_skip_teardown(behaviortreeentity.find_flesh_struct_string)) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xaf3ca78c, Offset: 0x3fa8
// Size: 0x66
function zombieisthinkdone(behaviortreeentity) {
    /#
        if (isdefined(behaviortreeentity.is_rat_test) && behaviortreeentity.is_rat_test) {
            return false;
        }
    #/
    if (isdefined(behaviortreeentity.zombie_think_done) && behaviortreeentity.zombie_think_done) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xfd7edcc0, Offset: 0x4018
// Size: 0x34
function zombieisatgoal(behaviortreeentity) {
    isatscriptgoal = behaviortreeentity isatgoal();
    return isatscriptgoal;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xba1d2bcb, Offset: 0x4058
// Size: 0x5a
function zombieisatentrance(behaviortreeentity) {
    isatscriptgoal = behaviortreeentity isatgoal();
    isatentrance = isdefined(behaviortreeentity.first_node) && isatscriptgoal;
    return isatentrance;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xcde610fc, Offset: 0x40c0
// Size: 0xe4
function getchunkservice(behaviortreeentity) {
    behaviortreeentity.chunk = zm_utility::get_closest_non_destroyed_chunk(behaviortreeentity.origin, behaviortreeentity.first_node, behaviortreeentity.first_node.barrier_chunks);
    if (isdefined(behaviortreeentity.chunk)) {
        behaviortreeentity.first_node.zbarrier setzbarrierpiecestate(behaviortreeentity.chunk, "targetted_by_zombie");
        behaviortreeentity.first_node thread zm_spawner::check_zbarrier_piece_for_zombie_death(behaviortreeentity.chunk, behaviortreeentity.first_node.zbarrier, behaviortreeentity);
    }
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xe5f528bc, Offset: 0x41b0
// Size: 0x80
function updatechunkservice(behaviortreeentity) {
    while (0 < behaviortreeentity.first_node.zbarrier.chunk_health[behaviortreeentity.chunk]) {
        behaviortreeentity.first_node.zbarrier.chunk_health[behaviortreeentity.chunk]--;
    }
    behaviortreeentity.lastchunk_destroy_time = gettime();
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x783c6d47, Offset: 0x4238
// Size: 0x100
function updateattackspotservice(behaviortreeentity) {
    if (isdefined(behaviortreeentity.marked_for_death) && behaviortreeentity.marked_for_death || behaviortreeentity.health < 0) {
        return false;
    }
    if (!isdefined(behaviortreeentity.attacking_spot)) {
        if (!behaviortreeentity zm_spawner::get_attack_spot(behaviortreeentity.first_node)) {
            return false;
        }
    }
    if (isdefined(behaviortreeentity.attacking_spot)) {
        behaviortreeentity.goalradius = 8;
        behaviortreeentity setgoal(behaviortreeentity.attacking_spot);
        if (behaviortreeentity isatgoal()) {
            behaviortreeentity.at_entrance_tear_spot = 1;
        }
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x778f4413, Offset: 0x4340
// Size: 0x1be
function findnodesservice(behaviortreeentity) {
    node = undefined;
    behaviortreeentity.entrance_nodes = [];
    if (isdefined(behaviortreeentity.find_flesh_struct_string)) {
        if (behaviortreeentity.find_flesh_struct_string == "find_flesh") {
            return 0;
        }
        for (i = 0; i < level.exterior_goals.size; i++) {
            if (isdefined(level.exterior_goals[i].script_string) && level.exterior_goals[i].script_string == behaviortreeentity.find_flesh_struct_string) {
                node = level.exterior_goals[i];
                break;
            }
        }
        behaviortreeentity.entrance_nodes[behaviortreeentity.entrance_nodes.size] = node;
        /#
            assert(isdefined(node), "zombieHasAttackSpotAlready" + behaviortreeentity.find_flesh_struct_string + "zombieHasAttackSpotAlready");
        #/
        behaviortreeentity.first_node = node;
        behaviortreeentity.goalradius = -128;
        behaviortreeentity setgoal(node.origin);
        if (zombieisatentrance(behaviortreeentity)) {
            behaviortreeentity.got_to_entrance = 1;
        }
        return 1;
    }
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x9f8f4be6, Offset: 0x4508
// Size: 0x13e
function zombieattackableobjectservice(behaviortreeentity) {
    if (!behaviortreeentity ai::has_behavior_attribute("use_attackable") || !behaviortreeentity ai::get_behavior_attribute("use_attackable")) {
        behaviortreeentity.attackable = undefined;
        return 0;
    }
    if (isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs) {
        behaviortreeentity.attackable = undefined;
        return 0;
    }
    if (isdefined(behaviortreeentity.aat_turned) && behaviortreeentity.aat_turned) {
        behaviortreeentity.attackable = undefined;
        return 0;
    }
    if (!isdefined(behaviortreeentity.attackable)) {
        behaviortreeentity.attackable = zm_attackables::get_attackable();
        return;
    }
    if (!(isdefined(behaviortreeentity.attackable.is_active) && behaviortreeentity.attackable.is_active)) {
        behaviortreeentity.attackable = undefined;
    }
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x8afc9819, Offset: 0x4650
// Size: 0x40
function zombiemovetoentranceaction(behaviortreeentity, asmstatename) {
    behaviortreeentity.got_to_entrance = 0;
    animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
    return 5;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x75b055a5, Offset: 0x4698
// Size: 0x44
function zombiemovetoentranceactionterminate(behaviortreeentity, asmstatename) {
    if (zombieisatentrance(behaviortreeentity)) {
        behaviortreeentity.got_to_entrance = 1;
    }
    return 4;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x1f82e0b4, Offset: 0x46e8
// Size: 0x40
function zombiemovetoattackspotaction(behaviortreeentity, asmstatename) {
    behaviortreeentity.at_entrance_tear_spot = 0;
    animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
    return 5;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0xf92a0a96, Offset: 0x4730
// Size: 0x2c
function zombiemovetoattackspotactionterminate(behaviortreeentity, asmstatename) {
    behaviortreeentity.at_entrance_tear_spot = 1;
    return 4;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x41bb5012, Offset: 0x4768
// Size: 0x120
function zombieholdboardaction(behaviortreeentity, asmstatename) {
    behaviortreeentity.keepclaimednode = 1;
    blackboard::setblackboardattribute(behaviortreeentity, "_which_board_pull", int(behaviortreeentity.chunk));
    blackboard::setblackboardattribute(behaviortreeentity, "_board_attack_spot", float(behaviortreeentity.attacking_spot_index));
    boardactionast = behaviortreeentity astsearch(istring(asmstatename));
    boardactionanimation = animationstatenetworkutility::searchanimationmap(behaviortreeentity, boardactionast["animation"]);
    animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
    return 5;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0xab24cb44, Offset: 0x4890
// Size: 0x28
function zombieholdboardactionterminate(behaviortreeentity, asmstatename) {
    behaviortreeentity.keepclaimednode = 0;
    return 4;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x923d69e9, Offset: 0x48c0
// Size: 0x120
function zombiegrabboardaction(behaviortreeentity, asmstatename) {
    behaviortreeentity.keepclaimednode = 1;
    blackboard::setblackboardattribute(behaviortreeentity, "_which_board_pull", int(behaviortreeentity.chunk));
    blackboard::setblackboardattribute(behaviortreeentity, "_board_attack_spot", float(behaviortreeentity.attacking_spot_index));
    boardactionast = behaviortreeentity astsearch(istring(asmstatename));
    boardactionanimation = animationstatenetworkutility::searchanimationmap(behaviortreeentity, boardactionast["animation"]);
    animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
    return 5;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x64e7b453, Offset: 0x49e8
// Size: 0x28
function zombiegrabboardactionterminate(behaviortreeentity, asmstatename) {
    behaviortreeentity.keepclaimednode = 0;
    return 4;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0xfbf18931, Offset: 0x4a18
// Size: 0x120
function zombiepullboardaction(behaviortreeentity, asmstatename) {
    behaviortreeentity.keepclaimednode = 1;
    blackboard::setblackboardattribute(behaviortreeentity, "_which_board_pull", int(behaviortreeentity.chunk));
    blackboard::setblackboardattribute(behaviortreeentity, "_board_attack_spot", float(behaviortreeentity.attacking_spot_index));
    boardactionast = behaviortreeentity astsearch(istring(asmstatename));
    boardactionanimation = animationstatenetworkutility::searchanimationmap(behaviortreeentity, boardactionast["animation"]);
    animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
    return 5;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x736701, Offset: 0x4b40
// Size: 0x34
function zombiepullboardactionterminate(behaviortreeentity, asmstatename) {
    behaviortreeentity.keepclaimednode = 0;
    self.lastchunk_destroy_time = gettime();
    return 4;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x58e79f43, Offset: 0x4b80
// Size: 0x58
function zombieattackthroughboardsaction(behaviortreeentity, asmstatename) {
    behaviortreeentity.keepclaimednode = 1;
    behaviortreeentity.boardattack = 1;
    animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
    return 5;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x8a6207e6, Offset: 0x4be0
// Size: 0x38
function zombieattackthroughboardsactionterminate(behaviortreeentity, asmstatename) {
    behaviortreeentity.keepclaimednode = 0;
    behaviortreeentity.boardattack = 0;
    return 4;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x3abc6f11, Offset: 0x4c20
// Size: 0x48
function zombietauntaction(behaviortreeentity, asmstatename) {
    behaviortreeentity.keepclaimednode = 1;
    animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
    return 5;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x59d094b0, Offset: 0x4c70
// Size: 0x28
function zombietauntactionterminate(behaviortreeentity, asmstatename) {
    behaviortreeentity.keepclaimednode = 0;
    return 4;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0xbe001776, Offset: 0x4ca0
// Size: 0xd0
function zombiemantleaction(behaviortreeentity, asmstatename) {
    behaviortreeentity.clamptonavmesh = 0;
    if (isdefined(behaviortreeentity.attacking_spot_index)) {
        behaviortreeentity.saved_attacking_spot_index = behaviortreeentity.attacking_spot_index;
        blackboard::setblackboardattribute(behaviortreeentity, "_board_attack_spot", float(behaviortreeentity.attacking_spot_index));
    }
    behaviortreeentity.isinmantleaction = 1;
    behaviortreeentity zombie_utility::reset_attack_spot();
    animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
    return 5;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0xb1760ff1, Offset: 0x4d78
// Size: 0x50
function zombiemantleactionterminate(behaviortreeentity, asmstatename) {
    behaviortreeentity.clamptonavmesh = 1;
    behaviortreeentity.isinmantleaction = undefined;
    behaviortreeentity zm_behavior_utility::enteredplayablearea();
    return 4;
}

// Namespace zm_behavior
// Params 5, eflags: 0x1 linked
// Checksum 0x8711e137, Offset: 0x4dd0
// Size: 0x174
function boardtearmocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration) {
    origin = getstartorigin(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompanim);
    angles = getstartangles(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompanim);
    entity forceteleport(origin, angles, 1);
    entity.pushable = 0;
    entity.blockingpain = 1;
    entity animmode("noclip", 1);
    entity orientmode("face angle", angles[1]);
}

// Namespace zm_behavior
// Params 5, eflags: 0x1 linked
// Checksum 0x612ab632, Offset: 0x4f50
// Size: 0x70
function boardtearmocompupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration) {
    entity animmode("noclip", 0);
    entity.pushable = 0;
    entity.blockingpain = 1;
}

// Namespace zm_behavior
// Params 5, eflags: 0x1 linked
// Checksum 0xd25cffe7, Offset: 0x4fc8
// Size: 0x1e0
function barricadeentermocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration) {
    origin = getstartorigin(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompanim);
    angles = getstartangles(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompanim);
    if (isdefined(entity.mocomp_barricade_offset)) {
        origin += anglestoforward(angles) * entity.mocomp_barricade_offset;
    }
    entity forceteleport(origin, angles, 1);
    entity animmode("noclip", 0);
    entity orientmode("face angle", angles[1]);
    entity.pushable = 0;
    entity.blockingpain = 1;
    entity pathmode("dont move");
    entity.usegoalanimweight = 1;
}

// Namespace zm_behavior
// Params 5, eflags: 0x1 linked
// Checksum 0x10bf7c6c, Offset: 0x51b0
// Size: 0x5c
function barricadeentermocompupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration) {
    entity animmode("noclip", 0);
    entity.pushable = 0;
}

// Namespace zm_behavior
// Params 5, eflags: 0x1 linked
// Checksum 0x381e8f52, Offset: 0x5218
// Size: 0xbc
function barricadeentermocompterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration) {
    entity.pushable = 1;
    entity.blockingpain = 0;
    entity pathmode("move allowed");
    entity.usegoalanimweight = 0;
    entity animmode("normal", 0);
    entity orientmode("face motion");
}

// Namespace zm_behavior
// Params 5, eflags: 0x1 linked
// Checksum 0xbb5320a, Offset: 0x52e0
// Size: 0x218
function barricadeentermocompnozstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration) {
    zbarrier_origin = (entity.first_node.zbarrier.origin[0], entity.first_node.zbarrier.origin[1], entity.origin[2]);
    origin = getstartorigin(zbarrier_origin, entity.first_node.zbarrier.angles, mocompanim);
    angles = getstartangles(zbarrier_origin, entity.first_node.zbarrier.angles, mocompanim);
    if (isdefined(entity.mocomp_barricade_offset)) {
        origin += anglestoforward(angles) * entity.mocomp_barricade_offset;
    }
    entity forceteleport(origin, angles, 1);
    entity animmode("noclip", 0);
    entity orientmode("face angle", angles[1]);
    entity.pushable = 0;
    entity.blockingpain = 1;
    entity pathmode("dont move");
    entity.usegoalanimweight = 1;
}

// Namespace zm_behavior
// Params 5, eflags: 0x1 linked
// Checksum 0xdcc5821c, Offset: 0x5500
// Size: 0x5c
function barricadeentermocompnozupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration) {
    entity animmode("noclip", 0);
    entity.pushable = 0;
}

// Namespace zm_behavior
// Params 5, eflags: 0x1 linked
// Checksum 0x1b7d2016, Offset: 0x5568
// Size: 0xbc
function barricadeentermocompnozterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration) {
    entity.pushable = 1;
    entity.blockingpain = 0;
    entity pathmode("move allowed");
    entity.usegoalanimweight = 0;
    entity animmode("normal", 0);
    entity orientmode("face motion");
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x361f1351, Offset: 0x5630
// Size: 0x5c
function notetrackboardtear(animationentity) {
    if (isdefined(animationentity.chunk)) {
        animationentity.first_node.zbarrier setzbarrierpiecestate(animationentity.chunk, "opening");
    }
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xe96dd3c0, Offset: 0x5698
// Size: 0x2e4
function notetrackboardmelee(animationentity) {
    /#
        assert(animationentity.meleeweapon != level.weaponnone, "zombieHasAttackSpotAlready");
    #/
    if (isdefined(animationentity.first_node)) {
        meleedistsq = 8100;
        if (isdefined(level.attack_player_thru_boards_range)) {
            meleedistsq = level.attack_player_thru_boards_range * level.attack_player_thru_boards_range;
        }
        triggerdistsq = 2601;
        for (i = 0; i < animationentity.player_targets.size; i++) {
            playerdistsq = distance2dsquared(animationentity.player_targets[i].origin, animationentity.origin);
            heightdiff = abs(animationentity.player_targets[i].origin[2] - animationentity.origin[2]);
            if (playerdistsq < meleedistsq && heightdiff * heightdiff < meleedistsq) {
                playertriggerdistsq = distance2dsquared(animationentity.player_targets[i].origin, animationentity.first_node.trigger_location.origin);
                heightdiff = abs(animationentity.player_targets[i].origin[2] - animationentity.first_node.trigger_location.origin[2]);
                if (playertriggerdistsq < triggerdistsq && heightdiff * heightdiff < triggerdistsq) {
                    animationentity.player_targets[i] dodamage(animationentity.meleeweapon.meleedamage, animationentity.origin, self, self, "none", "MOD_MELEE");
                    break;
                }
            }
        }
        return;
    }
    animationentity melee();
}

// Namespace zm_behavior
// Params 0, eflags: 0x1 linked
// Checksum 0xb18b4352, Offset: 0x5988
// Size: 0x21c
function findzombieenemy() {
    zombies = getaispeciesarray(level.zombie_team, "all");
    zombie_enemy = undefined;
    closest_dist = undefined;
    foreach (zombie in zombies) {
        if (isdefined(zombie.canbetargetedbyturnedzombies) && (zombie.archetype == "zombie" || isdefined(zombie.completed_emerging_into_playable_area) && isalive(zombie) && zombie.completed_emerging_into_playable_area && !zm_utility::is_magic_bullet_shield_enabled(zombie) && zombie.canbetargetedbyturnedzombies)) {
            dist = distancesquared(self.origin, zombie.origin);
            if (!isdefined(closest_dist) || dist < closest_dist) {
                closest_dist = dist;
                zombie_enemy = zombie;
            }
        }
    }
    self.favoriteenemy = zombie_enemy;
    if (isdefined(self.favoriteenemy)) {
        self setgoal(self.favoriteenemy.origin);
        return;
    }
    self setgoal(self.origin);
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0xeb2f342b, Offset: 0x5bb0
// Size: 0xbc
function zombieblackholebombpullstart(entity, asmstatename) {
    entity.pulltime = gettime();
    entity.pullorigin = entity.origin;
    animationstatenetworkutility::requeststate(entity, asmstatename);
    zombieupdateblackholebombpullstate(entity);
    if (isdefined(entity.damageorigin)) {
        entity.n_zombie_custom_goal_radius = 8;
        entity.v_zombie_custom_goal_pos = entity.damageorigin;
    }
    return 5;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x996ad1d3, Offset: 0x5c78
// Size: 0xd4
function zombieupdateblackholebombpullstate(entity) {
    dist_to_bomb = distancesquared(entity.origin, entity.damageorigin);
    if (dist_to_bomb < 16384) {
        entity._black_hole_bomb_collapse_death = 1;
        return;
    }
    if (dist_to_bomb < 1048576) {
        blackboard::setblackboardattribute(entity, "_zombie_blackholebomb_pull_state", "bhb_pull_fast");
        return;
    }
    if (dist_to_bomb < 4227136) {
        blackboard::setblackboardattribute(entity, "_zombie_blackholebomb_pull_state", "bhb_pull_slow");
    }
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x2d538b78, Offset: 0x5d58
// Size: 0x254
function zombieblackholebombpullupdate(entity, asmstatename) {
    if (!isdefined(entity.interdimensional_gun_kill)) {
        return 4;
    }
    zombieupdateblackholebombpullstate(entity);
    if (isdefined(entity._black_hole_bomb_collapse_death) && entity._black_hole_bomb_collapse_death) {
        entity.skipautoragdoll = 1;
        entity dodamage(entity.health + 666, entity.origin + (0, 0, 50), entity.interdimensional_gun_attacker, undefined, undefined, "MOD_CRUSH");
        return 4;
    }
    if (isdefined(entity.damageorigin)) {
        entity.v_zombie_custom_goal_pos = entity.damageorigin;
    }
    if (!(isdefined(entity.missinglegs) && entity.missinglegs) && gettime() - entity.pulltime > 1000) {
        distsq = distance2dsquared(entity.origin, entity.pullorigin);
        if (distsq < -112) {
            entity setavoidancemask("avoid all");
            entity.cant_move = 1;
            if (isdefined(entity.cant_move_cb)) {
                entity [[ entity.cant_move_cb ]]();
            }
        } else {
            entity setavoidancemask("avoid none");
            entity.cant_move = 0;
        }
        entity.pulltime = gettime();
        entity.pullorigin = entity.origin;
    }
    return 5;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x8d024d9c, Offset: 0x5fb8
// Size: 0x4a
function zombieblackholebombpullend(entity, asmstatename) {
    entity.v_zombie_custom_goal_pos = undefined;
    entity.n_zombie_custom_goal_radius = undefined;
    entity.pulltime = undefined;
    entity.pullorigin = undefined;
    return 4;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xef6e5ccd, Offset: 0x6010
// Size: 0x78
function zombiekilledwhilegettingpulled(entity) {
    if (isdefined(entity.interdimensional_gun_kill) && !(isdefined(self.missinglegs) && self.missinglegs) && entity.interdimensional_gun_kill && !(isdefined(entity._black_hole_bomb_collapse_death) && entity._black_hole_bomb_collapse_death)) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0x2d8d7f2e, Offset: 0x6090
// Size: 0x3a
function zombiekilledbyblackholebombcondition(entity) {
    if (isdefined(entity._black_hole_bomb_collapse_death) && entity._black_hole_bomb_collapse_death) {
        return true;
    }
    return false;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0x52260eff, Offset: 0x60d8
// Size: 0x68
function zombiekilledbyblackholebombstart(entity, asmstatename) {
    animationstatenetworkutility::requeststate(entity, asmstatename);
    if (isdefined(level.black_hole_bomb_death_start_func)) {
        entity thread [[ level.black_hole_bomb_death_start_func ]](entity.damageorigin, entity.interdimensional_gun_projectile);
    }
    return 5;
}

// Namespace zm_behavior
// Params 2, eflags: 0x1 linked
// Checksum 0xd775c87c, Offset: 0x6148
// Size: 0xd8
function zombiekilledbyblackholebombend(entity, asmstatename) {
    if (isdefined(level._effect) && isdefined(level._effect["black_hole_bomb_zombie_gib"])) {
        fxorigin = entity gettagorigin("tag_origin");
        forward = anglestoforward(entity.angles);
        playfx(level._effect["black_hole_bomb_zombie_gib"], fxorigin, forward, (0, 0, 1));
    }
    entity hide();
    return 4;
}

// Namespace zm_behavior
// Params 1, eflags: 0x1 linked
// Checksum 0xba70f331, Offset: 0x6228
// Size: 0xb0
function zombiebhbburst(entity) {
    if (isdefined(level._effect) && isdefined(level._effect["black_hole_bomb_zombie_destroy"])) {
        fxorigin = entity gettagorigin("tag_origin");
        playfx(level._effect["black_hole_bomb_zombie_destroy"], fxorigin);
    }
    if (isdefined(entity.interdimensional_gun_projectile)) {
        entity.interdimensional_gun_projectile notify(#"black_hole_bomb_kill");
    }
}

