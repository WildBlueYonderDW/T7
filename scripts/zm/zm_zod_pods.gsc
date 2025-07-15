#using scripts/codescripts/struct;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/math_shared;
#using scripts/shared/scene_shared;
#using scripts/shared/system_shared;
#using scripts/shared/table_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_zm_ai_wasp;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_bgb;
#using scripts/zm/_zm_equipment;
#using scripts/zm/_zm_laststand;
#using scripts/zm/_zm_magicbox;
#using scripts/zm/_zm_powerups;
#using scripts/zm/_zm_score;
#using scripts/zm/_zm_unitrigger;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_weap_rocketshield;
#using scripts/zm/_zm_weapons;
#using scripts/zm/_zm_zonemgr;
#using scripts/zm/craftables/_zm_craft_shield;
#using scripts/zm/craftables/_zm_craftables;
#using scripts/zm/zm_zod_idgun_quest;
#using scripts/zm/zm_zod_quest;
#using scripts/zm/zm_zod_shadowman;
#using scripts/zm/zm_zod_util;
#using scripts/zm/zm_zod_vo;

#namespace zm_zod_pods;

// Namespace zm_zod_pods
// Params 0, eflags: 0x2
// Checksum 0xedef4cc, Offset: 0x8c0
// Size: 0x3c
function autoexec __init__sytem__()
{
    system::register( "zm_zod_pods", &__init__, &__main__, undefined );
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0x827a14be, Offset: 0x908
// Size: 0x67c
function __init__()
{
    clientfield::register( "toplayer", "ZM_ZOD_UI_POD_SPRAYER_PICKUP", 1, 1, "int" );
    clientfield::register( "scriptmover", "update_fungus_pod_level", 1, 3, "int" );
    clientfield::register( "scriptmover", "pod_sprayer_glint", 1, 1, "int" );
    clientfield::register( "scriptmover", "pod_miasma", 1, 1, "counter" );
    clientfield::register( "scriptmover", "pod_harvest", 1, 1, "counter" );
    clientfield::register( "scriptmover", "pod_self_destruct", 1, 1, "counter" );
    clientfield::register( "toplayer", "pod_sprayer_held", 1, 1, "int" );
    clientfield::register( "toplayer", "pod_sprayer_hint_range", 1, 1, "int" );
    level.fungus_pods = spawnstruct();
    level.fungus_pods.upgrade_odds = array( 0, 0, 0, 0.25, 0.25, 0.5, 0.5, 1 );
    a_table = table::load( "gamedata/tables/zm/zm_zod_pods.csv", "ScriptID" );
    level.fungus_pods.rewards = [];
    level.fungus_pods.rewards[ 1 ] = [];
    level.fungus_pods.rewards[ 2 ] = [];
    level.fungus_pods.rewards[ 3 ] = [];
    level.fungus_pods.bonus_points_amount = 100;
    level.bonus_points_powerup_override = &fungus_pod_bonus_points_override;
    
    /#
        level.fungus_pods.debug_reward_list = [];
    #/
    
    wpn_none = getweapon( "none" );
    a_keys = getarraykeys( a_table );
    
    for ( i = 0; i < a_keys.size ; i++ )
    {
        str_key = a_keys[ i ];
        s_reward = spawnstruct();
        s_reward.reward_level = a_table[ str_key ][ "Level" ];
        s_reward.type = a_table[ str_key ][ "Type" ];
        
        if ( s_reward.type == "weapon" )
        {
            s_reward.item = getweapon( a_table[ str_key ][ "Item" ] );
            
            if ( s_reward.item == wpn_none )
            {
                assertmsg( "<dev string:x28>" + a_table[ str_key ][ "<dev string:x39>" ] + "<dev string:x3e>" );
                continue;
            }
        }
        else
        {
            s_reward.item = a_table[ str_key ][ "Item" ];
        }
        
        s_reward.count = a_table[ str_key ][ "Count" ];
        s_reward.chance = a_table[ str_key ][ "Weight" ];
        
        if ( !isdefined( level.fungus_pods.rewards[ s_reward.reward_level ] ) )
        {
            level.fungus_pods.rewards[ s_reward.reward_level ] = [];
        }
        else if ( !isarray( level.fungus_pods.rewards[ s_reward.reward_level ] ) )
        {
            level.fungus_pods.rewards[ s_reward.reward_level ] = array( level.fungus_pods.rewards[ s_reward.reward_level ] );
        }
        
        level.fungus_pods.rewards[ s_reward.reward_level ][ level.fungus_pods.rewards[ s_reward.reward_level ].size ] = s_reward;
        
        /#
            level.fungus_pods.debug_reward_list[ str_key ] = s_reward;
        #/
    }
    
    function_bcc1a076();
    thread function_77d7e068();
    normalize_reward_chances();
    level flag::init( "any_player_has_pod_sprayer" );
    level flag::init( "hide_pods_for_trailer" );
    
    /#
        level thread fungus_pods_devgui();
    #/
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0x5c3c873d, Offset: 0xf90
// Size: 0x374
function __main__()
{
    level flag::wait_till( "start_zombie_round_logic" );
    
    if ( getdvarint( "splitscreen_playerCount" ) > 2 )
    {
        return;
    }
    
    level.fungus_pods.a_e_unspawned = struct::get_array( "fungus_pod", "targetname" );
    level.fungus_pods.a_e_spawned = [];
    
    foreach ( e_fungus_pod in level.fungus_pods.a_e_unspawned )
    {
        e_fungus_pod.model = util::spawn_model( "tag_origin", e_fungus_pod.origin, e_fungus_pod.angles );
        
        if ( isdefined( e_fungus_pod.script_noteworthy ) && e_fungus_pod.script_noteworthy == "active" )
        {
            e_fungus_pod.n_pod_level = 1;
        }
        else
        {
            e_fungus_pod.n_pod_level = 0;
        }
        
        e_fungus_pod.model clientfield::set( "update_fungus_pod_level", 4 );
    }
    
    level.fungus_pods.sprayers = [];
    a_sprayers = struct::get_array( "pod_sprayer_location", "targetname" );
    a_sprayers = array::randomize( a_sprayers );
    a_chosen = [];
    
    foreach ( s_sprayer in a_sprayers )
    {
        if ( isdefined( a_chosen[ s_sprayer.script_int ] ) )
        {
            continue;
        }
        
        a_chosen[ s_sprayer.script_int ] = s_sprayer;
    }
    
    foreach ( s_sprayer in a_chosen )
    {
        s_sprayer thread pod_sprayer_think();
    }
    
    thread fungus_pod_clip_init();
    level thread respawn_fungus_pods();
}

/#

    // Namespace zm_zod_pods
    // Params 0
    // Checksum 0x70f9f283, Offset: 0x1310
    // Size: 0x240, Type: dev
    function fungus_pods_devgui()
    {
        setdvar( "<dev string:x54>", "<dev string:x67>" );
        setdvar( "<dev string:x68>", "<dev string:x67>" );
        adddebugcommand( "<dev string:x78>" );
        adddebugcommand( "<dev string:xc1>" );
        a_keys = getarraykeys( level.fungus_pods.debug_reward_list );
        
        for ( i = 0; i < a_keys.size ; i++ )
        {
            str_id = a_keys[ i ];
            adddebugcommand( "<dev string:x10d>" + str_id + "<dev string:x132>" + str_id + "<dev string:x146>" );
        }
        
        s_sword_rock = struct::get( "<dev string:x149>", "<dev string:x15c>" );
        
        while ( true )
        {
            cmd = getdvarstring( "<dev string:x54>" );
            
            if ( cmd != "<dev string:x67>" )
            {
                switch ( cmd )
                {
                    case "<dev string:x16e>":
                        level notify( #"debug_pod_spawn" );
                        break;
                    case "<dev string:x179>":
                        level.debug_pod_spawn_all = 1;
                        level notify( #"debug_pod_spawn" );
                        util::wait_network_frame();
                        level.debug_pod_spawn_all = 0;
                        break;
                    default:
                        break;
                }
                
                setdvar( "<dev string:x54>", "<dev string:x67>" );
            }
            
            util::wait_network_frame();
        }
    }

#/

// Namespace zm_zod_pods
// Params 0
// Checksum 0x5cdca32, Offset: 0x1558
// Size: 0x118
function function_bcc1a076()
{
    foreach ( var_3c1def9d in level.fungus_pods.rewards )
    {
        foreach ( s_reward in var_3c1def9d )
        {
            if ( s_reward.type == "shield_recharge" )
            {
                s_reward.do_not_consider = 1;
            }
        }
    }
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0xb9f25afc, Offset: 0x1678
// Size: 0x120
function function_77d7e068()
{
    level waittill( #"shield_built" );
    
    foreach ( var_3c1def9d in level.fungus_pods.rewards )
    {
        foreach ( s_reward in var_3c1def9d )
        {
            if ( s_reward.type == "shield_recharge" )
            {
                s_reward.do_not_consider = 0;
            }
        }
    }
}

// Namespace zm_zod_pods
// Params 1, eflags: 0x4
// Checksum 0x9d2f7099, Offset: 0x17a0
// Size: 0x44
function private pod_sprayer_pickup_msg( e_player )
{
    if ( e_player clientfield::get_to_player( "pod_sprayer_held" ) )
    {
        return &"";
    }
    
    return &"ZM_ZOD_PICKUP_SPRAYER";
}

// Namespace zm_zod_pods
// Params 0, eflags: 0x4
// Checksum 0x695e38b5, Offset: 0x17f0
// Size: 0x21e
function private pod_sprayer_think()
{
    while ( true )
    {
        self.model = util::spawn_model( "p7_zm_zod_bug_sprayer", self.origin, self.angles );
        self.model clientfield::set( "pod_sprayer_glint", 1 );
        self.trigger = zm_zod_util::spawn_trigger_radius( self.origin, 50, 1, &pod_sprayer_pickup_msg );
        
        while ( true )
        {
            self.trigger waittill( #"trigger", e_who );
            
            if ( e_who clientfield::get_to_player( "pod_sprayer_held" ) )
            {
                continue;
            }
            
            e_who thread zm_audio::create_and_play_dialog( "sprayer", "pickup" );
            e_who clientfield::set_to_player( "pod_sprayer_held", 1 );
            e_who thread zm_zod_util::function_55f114f9( "zmInventory.widget_sprayer", 3.5 );
            e_who thread zm_zod_util::show_infotext_for_duration( "ZM_ZOD_UI_POD_SPRAYER_PICKUP", 3.5 );
            e_who.var_abe77dc0 = 1;
            self.model delete();
            playsoundatposition( "zmb_zod_sprayer_pickup", self.origin );
            zm_unitrigger::unregister_unitrigger( self.trigger );
            self.trigger = undefined;
            level flag::set( "any_player_has_pod_sprayer" );
            break;
        }
        
        e_who waittill( #"disconnect" );
    }
}

// Namespace zm_zod_pods
// Params 0, eflags: 0x4
// Checksum 0x641c8bfa, Offset: 0x1a18
// Size: 0x13a
function private fungus_pod_think()
{
    self waittill( #"hash_e446a51c" );
    self thread fungus_pod_upgrade_think();
    self thread function_42bd572d();
    
    while ( true )
    {
        self.trigger waittill( #"trigger", e_who );
        assert( self.n_pod_level > 0 );
        
        if ( isdefined( level.bzm_worldpaused ) && level.bzm_worldpaused )
        {
            continue;
        }
        
        if ( e_who clientfield::get_to_player( "pod_sprayer_held" ) == 0 )
        {
            e_who thread function_8d53a342( 0 );
            continue;
        }
        
        playsoundatposition( "zmb_zod_sprayer_use", self.origin );
        e_who thread function_8d53a342( 1 );
        self harvest_fungus_pod( e_who );
        return;
    }
}

// Namespace zm_zod_pods
// Params 1, eflags: 0x4
// Checksum 0x24c8822e, Offset: 0x1b60
// Size: 0xac
function private function_8d53a342( b_success )
{
    self notify( #"hash_8d53a342" );
    self endon( #"hash_8d53a342" );
    self thread clientfield::set_player_uimodel( "zmInventory.player_using_sprayer", b_success );
    self thread clientfield::set_player_uimodel( "zmInventory.widget_sprayer", 1 );
    wait 2;
    self thread clientfield::set_player_uimodel( "zmInventory.widget_sprayer", 0 );
    self thread clientfield::set_player_uimodel( "zmInventory.player_using_sprayer", 0 );
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0x40180597, Offset: 0x1c18
// Size: 0xea
function fungus_pod_clip_init()
{
    var_15c80043 = getentarray( "fungus_pod_clip", "targetname" );
    level.fungus_pods.a_e_fungus_pod_clips = array::sort_by_script_int( var_15c80043, 1 );
    
    foreach ( e_clip in level.fungus_pods.a_e_fungus_pod_clips )
    {
        e_clip thread fungus_pod_clip_think();
    }
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0x3f503035, Offset: 0x1d10
// Size: 0x9a
function fungus_pod_clip_think()
{
    level endon( #"_zombie_game_over" );
    
    while ( true )
    {
        self.origin -= ( 0, 0, 5000 );
        level waittill( "pod_" + self.script_int + "_hatched" );
        self.origin += ( 0, 0, 5000 );
        level waittill( "pod_" + self.script_int + "_harvested" );
    }
}

// Namespace zm_zod_pods
// Params 1, eflags: 0x4
// Checksum 0x7fba9d4, Offset: 0x1db8
// Size: 0x7c
function private fungus_pod_upgrade( n_pod_level )
{
    if ( !isdefined( n_pod_level ) )
    {
        n_pod_level = undefined;
    }
    
    if ( self.n_pod_level < 3 )
    {
        if ( isdefined( n_pod_level ) )
        {
            self.n_pod_level = n_pod_level;
        }
        else
        {
            self.n_pod_level++;
        }
        
        self.model clientfield::set( "update_fungus_pod_level", self.n_pod_level );
    }
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0x1efd0efe, Offset: 0x1e40
// Size: 0x9a
function function_be2abe()
{
    foreach ( s_pod in level.fungus_pods.a_e_spawned )
    {
        s_pod fungus_pod_upgrade( 3 );
    }
}

// Namespace zm_zod_pods
// Params 0, eflags: 0x4
// Checksum 0x9dde99f0, Offset: 0x1ee8
// Size: 0x182
function private fungus_pod_upgrade_think()
{
    self endon( #"harvested" );
    rounds_since_upgrade = 0;
    
    if ( isdefined( self.zone ) )
    {
        zm_zonemgr::zone_wait_till_enabled( self.zone );
    }
    
    if ( level clientfield::get( "bm_superbeast" ) )
    {
        self fungus_pod_upgrade( 3 );
    }
    
    while ( true )
    {
        level util::waittill_any( "between_round_over", "debug_pod_spawn" );
        rounds_since_upgrade++;
        n_upgrade_odds = level.fungus_pods.upgrade_odds[ rounds_since_upgrade ];
        
        if ( !isdefined( n_upgrade_odds ) )
        {
            n_upgrade_odds = 1;
        }
        else if ( isdefined( level.debug_pod_spawn_all ) && level.debug_pod_spawn_all )
        {
            n_upgrade_odds = 1;
        }
        else if ( n_upgrade_odds == 0 )
        {
            continue;
        }
        
        if ( randomfloat( 1 ) <= n_upgrade_odds )
        {
            self fungus_pod_upgrade();
            rounds_since_upgrade = 0;
            
            if ( self.n_pod_level >= 3 )
            {
                return;
            }
        }
    }
}

// Namespace zm_zod_pods
// Params 0, eflags: 0x4
// Checksum 0x38ba8a37, Offset: 0x2078
// Size: 0x188
function private function_42bd572d()
{
    self endon( #"harvested" );
    level flag::wait_till( "all_players_spawned" );
    
    while ( true )
    {
        level waittill( #"kill_round" );
        
        if ( self.n_pod_level == 3 )
        {
            self.model clientfield::increment( "pod_harvest" );
            wait 0.05;
            zm_unitrigger::unregister_unitrigger( self.trigger );
            arrayremovevalue( level.fungus_pods.a_e_spawned, self );
            
            if ( !isdefined( level.fungus_pods.a_e_unspawned ) )
            {
                level.fungus_pods.a_e_unspawned = [];
            }
            else if ( !isarray( level.fungus_pods.a_e_unspawned ) )
            {
                level.fungus_pods.a_e_unspawned = array( level.fungus_pods.a_e_unspawned );
            }
            
            level.fungus_pods.a_e_unspawned[ level.fungus_pods.a_e_unspawned.size ] = self;
            self notify( #"harvested" );
            level notify( "pod_" + self.script_int + "_harvested" );
        }
    }
}

// Namespace zm_zod_pods
// Params 0, eflags: 0x4
// Checksum 0x1fa4a4a5, Offset: 0x2208
// Size: 0x260
function private respawn_fungus_pods()
{
    level flag::wait_till( "start_zombie_round_logic" );
    
    for ( i = 0; i < level.fungus_pods.a_e_unspawned.size ; i++ )
    {
        e_pod = level.fungus_pods.a_e_unspawned[ i ];
        e_pod.zone = zm_zonemgr::get_zone_from_position( e_pod.origin + ( 0, 0, 20 ), 1 );
        
        if ( !isdefined( e_pod.zone ) )
        {
            println( "<dev string:x183>" + zm_zod_util::vec_to_string( e_pod.origin ) + "<dev string:x194>" );
            arrayremovevalue( level.fungus_pods.a_e_unspawned, e_pod );
        }
    }
    
    n_pods = int( 0.4 * level.fungus_pods.a_e_unspawned.size );
    spawn_fungus_pods( n_pods );
    
    while ( true )
    {
        level util::waittill_any( "between_round_over", "debug_pod_spawn" );
        
        if ( level.round_number < 4 && !level flag::get( "any_player_has_pod_sprayer" ) && !( isdefined( level.debug_pod_spawn_all ) && level.debug_pod_spawn_all ) )
        {
            continue;
        }
        
        n_pods = randomintrange( 3, 6 );
        
        if ( isdefined( level.debug_pod_spawn_all ) && level.debug_pod_spawn_all )
        {
            n_pods = 1000;
        }
        
        spawn_fungus_pods( n_pods );
    }
}

// Namespace zm_zod_pods
// Params 1
// Checksum 0x30955c65, Offset: 0x2470
// Size: 0xac2
function harvest_fungus_pod( e_harvester )
{
    self.model clientfield::increment( "pod_harvest" );
    e_harvester thread zm_audio::create_and_play_dialog( "sprayer", "use" );
    wait 0.1;
    self.harvested_in_round = level.round_number;
    zm_unitrigger::unregister_unitrigger( self.trigger );
    self.trigger = undefined;
    self notify( #"harvested", e_harvester );
    var_785a5f87 = self.n_pod_level;
    self.n_pod_level = 0;
    self.model clientfield::set( "update_fungus_pod_level", self.n_pod_level );
    wait getanimlength( "p7_fxanim_zm_zod_fungus_pod_stage" + var_785a5f87 + "_death_bundle" ) - 0.5;
    e_harvester recordmapevent( 24, gettime(), self.origin, level.round_number, var_785a5f87 );
    level notify( "pod_" + self.script_int + "_harvested" );
    n_roll = randomint( 100 );
    n_cumulation = 0;
    var_68a89987 = 0;
    
    foreach ( s_reward in level.fungus_pods.rewards[ var_785a5f87 ] )
    {
        /#
            str_forced = getdvarstring( "<dev string:x68>" );
            
            if ( isdefined( str_forced ) && str_forced != "<dev string:x67>" )
            {
                s_reward_forced = 1;
                s_reward = level.fungus_pods.debug_reward_list[ str_forced ];
                setdvar( "<dev string:x68>", "<dev string:x67>" );
            }
        #/
        
        if ( s_reward.type == "weapon" )
        {
            s_reward.do_not_consider = function_b0138b1( s_reward.item );
        }
        
        if ( isdefined( s_reward.do_not_consider ) && s_reward.do_not_consider )
        {
            continue;
        }
        
        n_cumulation += s_reward.chance;
        
        if ( isdefined( s_reward_forced ) && ( n_cumulation >= n_roll || s_reward_forced ) )
        {
            var_68a89987 = 1;
            
            switch ( s_reward.type )
            {
                case "craftable":
                    s_reward.do_not_consider = 1;
                    normalize_reward_chances();
                    playsoundatposition( "evt_zod_pod_open_craftable", self.origin );
                    drop_point = self.origin + ( 0, 0, 36 );
                    zm_zod_idgun_quest::special_craftable_spawn( drop_point, "part_skeleton" );
                    
                    if ( level flag::get( "part_skeleton" + "_found" ) )
                    {
                        break;
                    }
                    else
                    {
                        mdl_part = level zm_craftables::get_craftable_piece_model( "idgun", "part_skeleton" );
                        var_55d0f940 = struct::get( "safe_place_for_items", "targetname" );
                        mdl_part.origin = var_55d0f940.origin;
                        s_reward.do_not_consider = 0;
                        normalize_reward_chances();
                    }
                    
                    break;
                case "grenade":
                    v_spawnpt = self.origin;
                    grenade = getweapon( "frag_grenade" );
                    n_rand = randomintrange( 0, 4 );
                    e_harvester magicgrenadetype( grenade, v_spawnpt, ( 0, 0, 300 ), 3 );
                    playsoundatposition( "evt_zod_pod_open_grenade", self.origin );
                    
                    if ( n_rand )
                    {
                        wait 0.3;
                        
                        if ( math::cointoss() )
                        {
                            e_harvester magicgrenadetype( grenade, v_spawnpt, ( 0, 0, 300 ), 3 );
                        }
                    }
                    
                    break;
                case "parasite":
                    if ( isdefined( e_harvester ) )
                    {
                        array::add( level.a_wasp_priority_targets, e_harvester );
                    }
                    
                    s_temp = spawnstruct();
                    s_temp.origin = self.origin + ( 0, 0, 30 );
                    var_b20468d0 = zm_ai_wasp::special_wasp_spawn( 1, s_temp, 32, 32, 1, 1, 1 );
                    
                    if ( !ispointinnavvolume( var_b20468d0.origin, "navvolume_small" ) )
                    {
                        v_nearest_navmesh_point = var_b20468d0 getclosestpointonnavvolume( s_temp.origin, 100 );
                        
                        if ( isdefined( v_nearest_navmesh_point ) )
                        {
                            var_b20468d0.origin = v_nearest_navmesh_point;
                        }
                    }
                    
                    break;
                case "powerup":
                    for ( str_item = s_reward.item; str_item === "full_ammo" && ( !isdefined( str_item ) || var_785a5f87 != 3 ) ; str_item = zm_powerups::get_valid_powerup() )
                    {
                    }
                    
                    if ( isdefined( s_reward.count ) && str_item == "bonus_points_team" )
                    {
                        level.fungus_pods.bonus_points_amount = s_reward.count;
                    }
                    
                    zm_powerups::specific_powerup_drop( str_item, self.origin, undefined, undefined, 1 );
                    break;
                case "weapon":
                    playsoundatposition( "evt_zod_pod_open_weapon", self.origin );
                    self thread dig_up_weapon( e_harvester, s_reward.item );
                    break;
                case "zombie":
                    s_temp = spawnstruct();
                    s_temp.origin = function_c9466e61( self.origin, 20 );
                    
                    if ( !isdefined( s_temp.origin ) )
                    {
                        s_temp.origin = self.origin;
                    }
                    
                    s_temp.script_noteworthy = "riser_location";
                    s_temp.script_string = "find_flesh";
                    zombie_utility::spawn_zombie( level.zombie_spawners[ 0 ], "aether_zombie", s_temp );
                    break;
                case "shield_recharge":
                    v_origin = function_c9466e61( self.origin, 20 );
                    var_7905adb2 = rocketshield::create_bottle_unitrigger( v_origin, ( 0, 0, 0 ) );
                    var_7905adb2 thread function_92f587b4();
                    break;
                default:
                    break;
            }
            
            break;
        }
    }
    
    if ( !var_68a89987 )
    {
        str_item = zm_powerups::get_valid_powerup();
        zm_powerups::specific_powerup_drop( str_item, self.origin, undefined, undefined, 1 );
    }
    
    arrayremovevalue( level.fungus_pods.a_e_spawned, self );
    
    if ( !isdefined( level.fungus_pods.a_e_unspawned ) )
    {
        level.fungus_pods.a_e_unspawned = [];
    }
    else if ( !isarray( level.fungus_pods.a_e_unspawned ) )
    {
        level.fungus_pods.a_e_unspawned = array( level.fungus_pods.a_e_unspawned );
    }
    
    level.fungus_pods.a_e_unspawned[ level.fungus_pods.a_e_unspawned.size ] = self;
}

// Namespace zm_zod_pods
// Params 2
// Checksum 0xd0f3167, Offset: 0x2f40
// Size: 0xa8
function function_c9466e61( v_pos, radius )
{
    v_origin = getclosestpointonnavmesh( v_pos, radius );
    
    if ( !isdefined( v_origin ) )
    {
        e_player = zm_utility::get_closest_player( v_pos );
        v_origin = getclosestpointonnavmesh( e_player.origin, radius );
    }
    
    if ( !isdefined( v_origin ) )
    {
        v_origin = v_pos;
    }
    
    return v_origin;
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0x8b5e488d, Offset: 0x2ff0
// Size: 0xf4
function function_92f587b4()
{
    self endon( #"bottle_collected" );
    wait 15;
    
    for ( i = 0; i < 40 ; i++ )
    {
        if ( i % 2 )
        {
            self.mdl_shield_recharge ghost();
        }
        else
        {
            self.mdl_shield_recharge show();
        }
        
        if ( i < 15 )
        {
            wait 0.5;
            continue;
        }
        
        if ( i < 25 )
        {
            wait 0.25;
            continue;
        }
        
        wait 0.1;
    }
    
    self.mdl_shield_recharge delete();
    zm_unitrigger::unregister_unitrigger( self );
}

// Namespace zm_zod_pods
// Params 1
// Checksum 0xd191ef97, Offset: 0x30f0
// Size: 0x84
function pod_player_msg( e_player )
{
    if ( e_player clientfield::get_to_player( "pod_sprayer_held" ) )
    {
        return &"ZM_ZOD_POD_HARVEST";
    }
    
    if ( e_player clientfield::get_to_player( "pod_sprayer_hint_range" ) == 0 )
    {
        e_player thread function_3f5779c4();
    }
    
    return &"";
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0x6afb123, Offset: 0x3180
// Size: 0x54
function function_3f5779c4()
{
    self endon( #"disconnect" );
    self clientfield::set_to_player( "pod_sprayer_hint_range", 1 );
    wait 1;
    self clientfield::set_to_player( "pod_sprayer_hint_range", 0 );
}

// Namespace zm_zod_pods
// Params 1
// Checksum 0xefbae72f, Offset: 0x31e0
// Size: 0x508
function spawn_fungus_pods( n_pods )
{
    if ( level flag::get( "hide_pods_for_trailer" ) )
    {
        return;
    }
    
    a_available = [];
    
    foreach ( e_pod in level.fungus_pods.a_e_unspawned )
    {
        if ( isdefined( e_pod.harvested_in_round ) )
        {
            n_rounds_since_spawn = level.round_number - e_pod.harvested_in_round;
            
            if ( n_rounds_since_spawn < 2 && !( isdefined( level.debug_pod_spawn_all ) && level.debug_pod_spawn_all ) )
            {
                continue;
            }
        }
        
        b_skip_pod = 0;
        a_players = getplayers();
        
        foreach ( player in a_players )
        {
            if ( distance( player.origin, e_pod.origin ) < 200 )
            {
                b_skip_pod = 1;
                break;
            }
        }
        
        if ( b_skip_pod )
        {
            continue;
        }
        
        if ( !isdefined( a_available ) )
        {
            a_available = [];
        }
        else if ( !isarray( a_available ) )
        {
            a_available = array( a_available );
        }
        
        a_available[ a_available.size ] = e_pod;
    }
    
    a_available = array::randomize( a_available );
    a_spawned_zones = [];
    
    for ( i = 0; i < n_pods && a_available.size > 0 ; i++ )
    {
        n_index = a_available.size - 1;
        s_pod = a_available[ n_index ];
        
        if ( n_pods <= 5 && isdefined( s_pod.zone ) && isdefined( a_spawned_zones[ s_pod.zone ] ) )
        {
            continue;
        }
        
        arrayremovevalue( level.fungus_pods.a_e_unspawned, s_pod );
        arrayremoveindex( a_available, n_index );
        
        if ( !isdefined( level.fungus_pods.a_e_spawned ) )
        {
            level.fungus_pods.a_e_spawned = [];
        }
        else if ( !isarray( level.fungus_pods.a_e_spawned ) )
        {
            level.fungus_pods.a_e_spawned = array( level.fungus_pods.a_e_spawned );
        }
        
        level.fungus_pods.a_e_spawned[ level.fungus_pods.a_e_spawned.size ] = s_pod;
        s_pod.n_pod_level = 1;
        level notify( "pod_" + s_pod.script_int + "_hatched" );
        s_pod.model clientfield::set( "update_fungus_pod_level", s_pod.n_pod_level );
        s_pod thread function_e1065706();
        s_pod thread fungus_pod_think();
        
        if ( isdefined( s_pod.zone ) )
        {
            if ( !isdefined( a_spawned_zones[ s_pod.zone ] ) )
            {
                a_spawned_zones[ s_pod.zone ] = 0;
            }
            
            a_spawned_zones[ s_pod.zone ]++;
        }
    }
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0xcbe7deec, Offset: 0x36f0
// Size: 0x82
function function_e1065706()
{
    wait getanimlength( "p7_fxanim_zm_zod_fungus_pod_base_birth_anim" );
    self.trigger = zm_zod_util::spawn_trigger_radius( self.origin + anglestoup( self.angles ) * 8, 50, 1, &pod_player_msg );
    self notify( #"hash_e446a51c" );
}

// Namespace zm_zod_pods
// Params 1
// Checksum 0xb5d1fb0a, Offset: 0x3780
// Size: 0xe8, Type: bool
function weapon_trigger_update_prompt( player )
{
    if ( !zm_utility::is_player_valid( player ) || player.is_drinking > 0 || !player zm_magicbox::can_buy_weapon() || player bgb::is_enabled( "zm_bgb_disorderly_combat" ) )
    {
        self sethintstring( &"" );
        return false;
    }
    
    self setcursorhint( "HINT_WEAPON", self.stub.wpn );
    self sethintstring( &"ZOMBIE_TRADE_WEAPON_FILL" );
    return true;
}

// Namespace zm_zod_pods
// Params 1
// Checksum 0x4aa6dbcc, Offset: 0x3870
// Size: 0x10c, Type: bool
function function_b0138b1( w_weapon )
{
    w_base_weapon = zm_weapons::get_base_weapon( w_weapon );
    players = getplayers();
    
    foreach ( player in players )
    {
        if ( !isdefined( player ) || !isalive( player ) )
        {
            continue;
        }
        
        if ( player zm_weapons::has_weapon_or_upgrade( w_base_weapon ) )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace zm_zod_pods
// Params 2
// Checksum 0x7e0e5b06, Offset: 0x3988
// Size: 0x250
function dig_up_weapon( e_digger, wpn_to_spawn )
{
    v_spawnpt = self.origin + ( 0, 0, 40 );
    v_spawnang = ( 0, 0, 0 );
    v_angles = e_digger getplayerangles();
    v_angles = ( 0, v_angles[ 1 ], 0 ) + ( 0, 90, 0 ) + v_spawnang;
    m_weapon = zm_utility::spawn_buildkit_weapon_model( e_digger, wpn_to_spawn, undefined, v_spawnpt, v_angles );
    m_weapon.angles = v_angles;
    m_weapon thread timer_til_despawn( v_spawnpt, 40 * -1 );
    m_weapon endon( #"dig_up_weapon_timed_out" );
    m_weapon.trigger = zm_zod_util::spawn_trigger_radius( v_spawnpt, 100, 1 );
    m_weapon.trigger.wpn = wpn_to_spawn;
    m_weapon.trigger.prompt_and_visibility_func = &weapon_trigger_update_prompt;
    m_weapon.trigger waittill( #"trigger", player );
    m_weapon.trigger notify( #"weapon_grabbed" );
    m_weapon.trigger thread swap_weapon( wpn_to_spawn, player );
    
    if ( isdefined( m_weapon.trigger ) )
    {
        zm_unitrigger::unregister_unitrigger( m_weapon.trigger );
        m_weapon.trigger = undefined;
    }
    
    if ( isdefined( m_weapon ) )
    {
        m_weapon delete();
    }
    
    if ( player != e_digger )
    {
        e_digger notify( #"dig_up_weapon_shared" );
    }
}

// Namespace zm_zod_pods
// Params 2
// Checksum 0x6b29bdba, Offset: 0x3be0
// Size: 0x114
function swap_weapon( wpn_new, e_player )
{
    wpn_current = e_player getcurrentweapon();
    
    if ( !zm_utility::is_player_valid( e_player ) )
    {
        return;
    }
    
    if ( e_player.is_drinking > 0 )
    {
        return;
    }
    
    if ( zm_utility::is_placeable_mine( wpn_current ) || zm_equipment::is_equipment( wpn_current ) || wpn_current == level.weaponnone )
    {
        return;
    }
    
    if ( !e_player hasweapon( wpn_new.rootweapon, 1 ) )
    {
        e_player take_old_weapon_and_give_new( wpn_current, wpn_new );
        return;
    }
    
    e_player givemaxammo( wpn_new );
}

// Namespace zm_zod_pods
// Params 2
// Checksum 0x1f5a90c4, Offset: 0x3d00
// Size: 0xd4
function take_old_weapon_and_give_new( current_weapon, weapon )
{
    a_weapons = self getweaponslistprimaries();
    
    if ( isdefined( a_weapons ) && a_weapons.size >= zm_utility::get_player_weapon_limit( self ) )
    {
        self takeweapon( current_weapon );
    }
    
    var_7b9ca68 = self zm_weapons::give_build_kit_weapon( weapon );
    self giveweapon( var_7b9ca68 );
    self switchtoweapon( var_7b9ca68 );
}

// Namespace zm_zod_pods
// Params 2
// Checksum 0x42f99c7c, Offset: 0x3de0
// Size: 0xc4
function timer_til_despawn( v_float, n_dist )
{
    self endon( #"weapon_grabbed" );
    putbacktime = 12;
    self movez( n_dist, putbacktime, putbacktime * 0.5 );
    self waittill( #"movedone" );
    self notify( #"dig_up_weapon_timed_out" );
    
    if ( isdefined( self.trigger ) )
    {
        zm_unitrigger::unregister_unitrigger( self.trigger );
        self.trigger = undefined;
    }
    
    if ( isdefined( self ) )
    {
        self delete();
    }
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0x7821053a, Offset: 0x3eb0
// Size: 0x12
function fungus_pod_bonus_points_override()
{
    return level.fungus_pods.bonus_points_amount;
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0xed998e9f, Offset: 0x3ed0
// Size: 0x1f8
function normalize_reward_chances()
{
    for ( i = 1; i <= 3 ; i++ )
    {
        n_total = 0;
        
        foreach ( reward in level.fungus_pods.rewards[ i ] )
        {
            if ( !( isdefined( reward.do_not_consider ) && reward.do_not_consider ) )
            {
                n_total += float( reward.chance );
            }
        }
        
        assert( reward.chance > 0 );
        
        foreach ( reward in level.fungus_pods.rewards[ i ] )
        {
            if ( !( isdefined( reward.do_not_consider ) && reward.do_not_consider ) )
            {
                reward.chance = reward.chance / n_total * 100;
            }
        }
    }
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0x4c5a526d, Offset: 0x40d0
// Size: 0x122
function function_2947f395()
{
    level flag::set( "hide_pods_for_trailer" );
    
    foreach ( pod in level.fungus_pods.spawned )
    {
        pod.buff = 0;
        pod.var_70ac16f8 = 0;
        zm_unitrigger::unregister_unitrigger( pod.trigger );
        
        if ( isdefined( self.e_fx_origin ) )
        {
            pod.e_fx_origin delete();
        }
        
        arrayremovevalue( level.fungus_pods.spawned, self );
    }
}

// Namespace zm_zod_pods
// Params 0
// Checksum 0x993e3bfb, Offset: 0x4200
// Size: 0xea
function function_3f95af32()
{
    foreach ( player in level.activeplayers )
    {
        player clientfield::set_to_player( "pod_sprayer_held", 1 );
        player thread zm_zod_util::function_55f114f9( "zmInventory.widget_sprayer", 3.5 );
        player.var_abe77dc0 = 1;
        level flag::set( "any_player_has_pod_sprayer" );
    }
}

