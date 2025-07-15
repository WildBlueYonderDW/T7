#using scripts/codescripts/struct;
#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/demo_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/math_shared;
#using scripts/shared/system_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_bb;
#using scripts/zm/_zm;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_bgb;
#using scripts/zm/_zm_equipment;
#using scripts/zm/_zm_magicbox;
#using scripts/zm/_zm_score;
#using scripts/zm/_zm_stats;
#using scripts/zm/_zm_unitrigger;
#using scripts/zm/_zm_utility;

#namespace bgb_machine;

// Namespace bgb_machine
// Params 0, eflags: 0x2
// Checksum 0x88e3f9c8, Offset: 0x540
// Size: 0x3c
function autoexec __init__sytem__()
{
    system::register( "bgb_machine", &__init__, &__main__, undefined );
}

// Namespace bgb_machine
// Params 0, eflags: 0x4
// Checksum 0xcf3111bf, Offset: 0x588
// Size: 0x17c
function private __init__()
{
    if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
    {
        return;
    }
    
    callback::on_connect( &on_player_connect );
    callback::on_disconnect( &on_player_disconnect );
    clientfield::register( "zbarrier", "zm_bgb_machine", 1, 1, "int" );
    clientfield::register( "zbarrier", "zm_bgb_machine_selection", 1, 8, "int" );
    clientfield::register( "zbarrier", "zm_bgb_machine_fx_state", 1, 3, "int" );
    clientfield::register( "zbarrier", "zm_bgb_machine_ghost_ball", 1, 1, "int" );
    clientfield::register( "toplayer", "zm_bgb_machine_round_buys", 10000, 3, "int" );
    level thread bgb_machine_host_migration();
    
    if ( !isdefined( level.var_42792b8b ) )
    {
        level.var_42792b8b = 0;
    }
}

// Namespace bgb_machine
// Params 0, eflags: 0x4
// Checksum 0x8a8d9f59, Offset: 0x710
// Size: 0x12c
function private __main__()
{
    if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
    {
        return;
    }
    
    if ( !isdefined( level.bgb_machine_max_uses_per_round ) )
    {
        level.bgb_machine_max_uses_per_round = 3;
    }
    
    if ( !isdefined( level.var_f02c5598 ) )
    {
        level.var_f02c5598 = 1000;
    }
    
    if ( !isdefined( level.var_e1dee7ba ) )
    {
        level.var_e1dee7ba = 10;
    }
    
    if ( !isdefined( level.var_a3e3127d ) )
    {
        level.var_a3e3127d = 2;
    }
    
    if ( !isdefined( level.var_8ef45dc2 ) )
    {
        level.var_8ef45dc2 = 10;
    }
    
    if ( !isdefined( level.var_1485dcdc ) )
    {
        level.var_1485dcdc = 2;
    }
    
    if ( !isdefined( level.bgb_machine_count ) )
    {
        level.bgb_machine_count = 1000;
    }
    
    if ( !isdefined( level.bgb_machine_never_move ) )
    {
        level.bgb_machine_never_move = 1;
    }
    
    if ( !isdefined( level.bgb_machine_state_func ) )
    {
        level.bgb_machine_state_func = &process_bgb_machine_state;
    }
    
    /#
        level thread setup_devgui();
    #/
    
    level thread setup_bgb_machines();
}

// Namespace bgb_machine
// Params 0, eflags: 0x4
// Checksum 0xad8b048a, Offset: 0x848
// Size: 0x34
function private on_player_connect()
{
    if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
    {
        return;
    }
    
    level thread bgb_machine_movement_frequency();
}

// Namespace bgb_machine
// Params 0, eflags: 0x4
// Checksum 0x6935e52b, Offset: 0x888
// Size: 0x34
function private on_player_disconnect()
{
    if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
    {
        return;
    }
    
    level thread bgb_machine_movement_frequency();
}

/#

    // Namespace bgb_machine
    // Params 0, eflags: 0x4
    // Checksum 0xcc01b82c, Offset: 0x8c8
    // Size: 0x254, Type: dev
    function private setup_devgui()
    {
        waittillframeend();
        setdvar( "<dev string:x28>", 0 );
        setdvar( "<dev string:x42>", 0 );
        setdvar( "<dev string:x5a>", "<dev string:x78>" );
        setdvar( "<dev string:x79>", 0 );
        setdvar( "<dev string:x99>", 0 );
        bgb_devgui_base = "<dev string:xbe>";
        adddebugcommand( bgb_devgui_base + "<dev string:xda>" + "<dev string:x5a>" + "<dev string:xf3>" );
        keys = getarraykeys( level.bgb );
        
        for ( i = 0; i < keys.size ; i++ )
        {
            adddebugcommand( bgb_devgui_base + "<dev string:xfd>" + keys[ i ] + "<dev string:x109>" + "<dev string:x5a>" + "<dev string:x111>" + keys[ i ] + "<dev string:x113>" );
        }
        
        adddebugcommand( bgb_devgui_base + "<dev string:x117>" + "<dev string:x28>" + "<dev string:x12e>" );
        adddebugcommand( bgb_devgui_base + "<dev string:x134>" + "<dev string:x42>" + "<dev string:x12e>" );
        adddebugcommand( bgb_devgui_base + "<dev string:x149>" + "<dev string:x79>" + "<dev string:x12e>" );
        adddebugcommand( bgb_devgui_base + "<dev string:x15d>" + "<dev string:x99>" + "<dev string:x12e>" );
        level thread bgb_machine_devgui_think();
    }

    // Namespace bgb_machine
    // Params 0, eflags: 0x4
    // Checksum 0x71fb99e9, Offset: 0xb28
    // Size: 0x3a8, Type: dev
    function private bgb_machine_devgui_think()
    {
        for ( ;; )
        {
            arrive = getdvarint( "<dev string:x28>" );
            move = getdvarint( "<dev string:x42>" );
            
            if ( move || arrive )
            {
                pos = level.players[ 0 ].origin;
                best_dist_sq = 999999999;
                best_index = -1;
                
                for ( i = 0; i < level.bgb_machines.size ; i++ )
                {
                    new_dist_sq = distancesquared( pos, level.bgb_machines[ i ].origin );
                    
                    if ( new_dist_sq < best_dist_sq )
                    {
                        best_index = i;
                        best_dist_sq = new_dist_sq;
                    }
                }
                
                if ( 0 <= best_index )
                {
                    if ( arrive )
                    {
                        if ( !level.bgb_machines[ best_index ].current_bgb_machine )
                        {
                            for ( i = 0; i < level.bgb_machines.size ; i++ )
                            {
                                if ( level.bgb_machines[ i ].current_bgb_machine )
                                {
                                    level.bgb_machines[ i ] thread hide_bgb_machine();
                                    break;
                                }
                            }
                            
                            level.bgb_machines[ best_index ].current_bgb_machine = 1;
                            level.bgb_machines[ best_index ] thread show_bgb_machine();
                        }
                    }
                    else
                    {
                        level.bgb_machines[ best_index ] thread bgb_machine_move();
                    }
                }
                
                setdvar( "<dev string:x28>", 0 );
                setdvar( "<dev string:x42>", 0 );
            }
            
            force_give = getdvarstring( "<dev string:x5a>" );
            
            if ( getdvarint( "<dev string:x79>" ) || "<dev string:x78>" != force_give )
            {
                for ( i = 0; i < level.players.size ; i++ )
                {
                    level.players[ i ].bgb_machine_uses_this_round = 0;
                    level.players[ i ] clientfield::set_to_player( "<dev string:x17f>", level.players[ i ].bgb_machine_uses_this_round );
                }
                
                setdvar( "<dev string:x79>", 0 );
            }
            
            if ( "<dev string:x78>" != force_give )
            {
                level.bgb_machine_force_give = force_give;
                setdvar( "<dev string:x5a>", "<dev string:x78>" );
            }
            
            wait 0.5;
        }
    }

#/

// Namespace bgb_machine
// Params 0, eflags: 0x4
// Checksum 0xa7b45725, Offset: 0xed8
// Size: 0x3c
function private setup_bgb_machines()
{
    waittillframeend();
    level.bgb_machines = getentarray( "bgb_machine_use", "targetname" );
    bgb_machine_init();
}

// Namespace bgb_machine
// Params 0, eflags: 0x4
// Checksum 0xe939dd37, Offset: 0xf20
// Size: 0x1f4
function private bgb_machine_init()
{
    if ( !level.bgb_machines.size )
    {
        return;
    }
    
    for ( i = 0; i < level.bgb_machines.size ; i++ )
    {
        if ( !isdefined( level.bgb_machines[ i ].base_cost ) )
        {
            level.bgb_machines[ i ].base_cost = 500;
        }
        
        level.bgb_machines[ i ].old_cost = level.bgb_machines[ i ].base_cost;
        level.bgb_machines[ i ].current_bgb_machine = 0;
        level.bgb_machines[ i ].uses_at_current_location = 0;
        level.bgb_machines[ i ] create_bgb_machine_unitrigger_stub();
    }
    
    if ( !level.enable_magic )
    {
        foreach ( bgb_machine in level.bgb_machines )
        {
            bgb_machine thread hide_bgb_machine();
        }
        
        return;
    }
    
    level.bgb_machines = array::randomize( level.bgb_machines );
    init_starting_bgb_machine_location();
    array::thread_all( level.bgb_machines, &bgb_machine_think );
}

// Namespace bgb_machine
// Params 0, eflags: 0x4
// Checksum 0xc5b5ebc5, Offset: 0x1120
// Size: 0x214
function private init_starting_bgb_machine_location()
{
    start_bgb_machine_found = 0;
    bgb_machines_to_hide = [];
    
    for ( i = 0; i < level.bgb_machines.size ; i++ )
    {
        level.bgb_machines[ i ] clientfield::set( "zm_bgb_machine", 1 );
        
        if ( start_bgb_machine_found >= level.bgb_machine_count || !isdefined( level.bgb_machines[ i ].script_noteworthy ) || !issubstr( level.bgb_machines[ i ].script_noteworthy, "start_bgb_machine" ) )
        {
            bgb_machines_to_hide[ bgb_machines_to_hide.size ] = level.bgb_machines[ i ];
            continue;
        }
        
        level.bgb_machines[ i ].hidden = 0;
        level.bgb_machines[ i ].current_bgb_machine = 1;
        level.bgb_machines[ i ] set_bgb_machine_state( "initial" );
        start_bgb_machine_found++;
    }
    
    for ( i = 0; i < bgb_machines_to_hide.size ; i++ )
    {
        if ( start_bgb_machine_found >= level.bgb_machine_count )
        {
            bgb_machines_to_hide[ i ] thread hide_bgb_machine();
            continue;
        }
        
        bgb_machines_to_hide[ i ].hidden = 0;
        bgb_machines_to_hide[ i ].current_bgb_machine = 1;
        bgb_machines_to_hide[ i ] set_bgb_machine_state( "initial" );
        start_bgb_machine_found++;
    }
}

// Namespace bgb_machine
// Params 0
// Checksum 0xd9b7226f, Offset: 0x1340
// Size: 0x144
function create_bgb_machine_unitrigger_stub()
{
    self.unitrigger_stub = spawnstruct();
    self.unitrigger_stub.script_width = 30;
    self.unitrigger_stub.script_height = 70;
    self.unitrigger_stub.script_length = 25;
    self.unitrigger_stub.origin = self.origin + anglestoright( self.angles ) * self.unitrigger_stub.script_length + anglestoup( self.angles ) * self.unitrigger_stub.script_height / 2;
    self.unitrigger_stub.angles = self.angles;
    self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
    self.unitrigger_stub.trigger_target = self;
    zm_unitrigger::unitrigger_force_per_player_triggers( self.unitrigger_stub, 1 );
    self.unitrigger_stub.prompt_and_visibility_func = &bgb_machine_trigger_update_prompt;
}

// Namespace bgb_machine
// Params 1
// Checksum 0x664aa04f, Offset: 0x1490
// Size: 0x90
function bgb_machine_trigger_update_prompt( player )
{
    can_use = self bgb_machine_stub_update_prompt( player );
    
    if ( isdefined( self.hint_string ) )
    {
        if ( isdefined( self.hint_parm1 ) )
        {
            self sethintstring( self.hint_string, self.hint_parm1 );
        }
        else
        {
            self sethintstring( self.hint_string );
        }
    }
    
    return can_use;
}

// Namespace bgb_machine
// Params 2
// Checksum 0xc25ea1f0, Offset: 0x1528
// Size: 0x1c8
function function_6c7a96b4( player, base_cost )
{
    if ( player.bgb_machine_uses_this_round < 1 && getdvarint( "scr_firstGumFree" ) === 1 )
    {
        return 0;
    }
    
    if ( !isdefined( level.var_f02c5598 ) )
    {
        level.var_f02c5598 = 1000;
    }
    
    if ( !isdefined( level.var_e1dee7ba ) )
    {
        level.var_e1dee7ba = 10;
    }
    
    if ( !isdefined( level.var_1485dcdc ) )
    {
        level.var_1485dcdc = 2;
    }
    
    cost = 500;
    
    if ( player.bgb_machine_uses_this_round >= 1 )
    {
        var_33ea806b = floor( level.round_number / level.var_e1dee7ba );
        var_33ea806b = math::clamp( var_33ea806b, 0, level.var_8ef45dc2 );
        var_39a90c5a = pow( level.var_a3e3127d, var_33ea806b );
        cost += level.var_f02c5598 * var_39a90c5a;
    }
    
    if ( player.bgb_machine_uses_this_round >= 2 )
    {
        cost *= level.var_1485dcdc;
    }
    
    cost = int( cost );
    
    if ( 500 != base_cost )
    {
        cost -= 500 - base_cost;
    }
    
    return cost;
}

// Namespace bgb_machine
// Params 1
// Checksum 0xbc9c007e, Offset: 0x16f8
// Size: 0x248
function bgb_machine_stub_update_prompt( player )
{
    b_result = 0;
    
    if ( !self trigger_visible_to_player( player ) )
    {
        return b_result;
    }
    
    self.hint_parm1 = undefined;
    
    if ( isdefined( self.stub.trigger_target.grab_bgb_hint ) && self.stub.trigger_target.grab_bgb_hint )
    {
        if ( !( isdefined( self.stub.trigger_target.b_bgb_is_available ) && self.stub.trigger_target.b_bgb_is_available ) )
        {
            str_hint = &"ZOMBIE_BGB_MACHINE_OUT_OF";
            b_result = 0;
        }
        else
        {
            str_hint = &"ZOMBIE_BGB_MACHINE_OFFERING";
            b_result = 1;
        }
        
        cursor_hint = "HINT_BGB";
        cursor_hint_bgb = level.bgb[ self.stub.trigger_target.selected_bgb ].item_index;
        self setcursorhint( cursor_hint, cursor_hint_bgb );
        self.hint_string = str_hint;
    }
    else
    {
        self setcursorhint( "HINT_NOICON" );
        
        if ( player.bgb_machine_uses_this_round < level.bgb_machine_max_uses_per_round )
        {
            if ( isdefined( level.var_42792b8b ) && level.var_42792b8b )
            {
                self.hint_string = &"ZOMBIE_BGB_MACHINE_AVAILABLE_CFILL";
            }
            else
            {
                self.hint_string = &"ZOMBIE_BGB_MACHINE_AVAILABLE";
                self.hint_parm1 = function_6c7a96b4( player, self.stub.trigger_target.base_cost );
            }
            
            b_result = 1;
        }
        else
        {
            self.hint_string = &"ZOMBIE_BGB_MACHINE_COMEBACK";
            b_result = 0;
        }
    }
    
    return b_result;
}

// Namespace bgb_machine
// Params 1
// Checksum 0x189f1957, Offset: 0x1948
// Size: 0xc0, Type: bool
function trigger_visible_to_player( player )
{
    self setinvisibletoplayer( player );
    visible = 1;
    
    if ( !player zm_magicbox::can_buy_weapon() )
    {
        visible = 0;
    }
    
    if ( !visible )
    {
        return false;
    }
    
    if ( isdefined( self.stub.trigger_target.bgb_machine_user ) && player !== self.stub.trigger_target.bgb_machine_user )
    {
        return false;
    }
    
    self setvisibletoplayer( player );
    return true;
}

// Namespace bgb_machine
// Params 0
// Checksum 0x346ba220, Offset: 0x1a10
// Size: 0x54
function bgb_machine_unitrigger_think()
{
    self endon( #"kill_trigger" );
    
    while ( true )
    {
        self waittill( #"trigger", player );
        self.stub.trigger_target notify( #"trigger", player );
    }
}

// Namespace bgb_machine
// Params 0
// Checksum 0xa993ba4c, Offset: 0x1a70
// Size: 0x3c
function show_bgb_machine()
{
    self set_bgb_machine_state( "arriving" );
    self waittill( #"arrived" );
    self.hidden = 0;
}

// Namespace bgb_machine
// Params 1
// Checksum 0xa81c74fe, Offset: 0x1ab8
// Size: 0x9c
function hide_bgb_machine( do_bgb_machine_leave )
{
    self thread zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
    self.hidden = 1;
    self.uses_at_current_location = 0;
    self.current_bgb_machine = 0;
    
    if ( isdefined( do_bgb_machine_leave ) && do_bgb_machine_leave )
    {
        self thread set_bgb_machine_state( "leaving" );
        return;
    }
    
    self thread set_bgb_machine_state( "away" );
}

// Namespace bgb_machine
// Params 1, eflags: 0x4
// Checksum 0xbccb4055, Offset: 0x1b60
// Size: 0x1ca, Type: bool
function private bgb_machine_select_bgb( player )
{
    if ( !player.bgb_pack_randomized.size )
    {
        player.bgb_pack_randomized = array::randomize( player.bgb_pack );
    }
    
    self.selected_bgb = array::pop_front( player.bgb_pack_randomized );
    
    /#
        if ( isdefined( level.bgb_machine_force_give ) )
        {
            self.selected_bgb = level.bgb_machine_force_give;
            level.bgb_machine_force_give = undefined;
            
            if ( "<dev string:x199>" == self.selected_bgb )
            {
                keys = array::randomize( getarraykeys( level.bgb ) );
                
                for ( i = 0; i < keys.size ; i++ )
                {
                    if ( level.bgb[ keys[ i ] ].consumable )
                    {
                        self.selected_bgb = keys[ i ];
                        break;
                    }
                }
                
                clientfield::set( "<dev string:x19f>", level.bgb[ self.selected_bgb ].item_index );
                return false;
            }
        }
    #/
    
    clientfield::set( "zm_bgb_machine_selection", level.bgb[ self.selected_bgb ].item_index );
    return player bgb::get_bgb_available( self.selected_bgb );
}

// Namespace bgb_machine
// Params 0
// Checksum 0x29f0cc66, Offset: 0x1d38
// Size: 0xa1c
function bgb_machine_think()
{
    var_9bbdff4d = -1;
    
    while ( true )
    {
        var_5e7af4df = undefined;
        self waittill( #"trigger", user );
        var_9bbdff4d = -1;
        
        if ( isdefined( user.bgb ) && isdefined( level.bgb[ user.bgb ] ) )
        {
            var_9bbdff4d = level.bgb[ user.bgb ].item_index;
        }
        
        var_5e7af4df = gettime();
        
        if ( user == level )
        {
            continue;
        }
        
        if ( user zm_utility::in_revive_trigger() )
        {
            wait 0.1;
            continue;
        }
        
        if ( user.is_drinking > 0 )
        {
            wait 0.1;
            continue;
        }
        
        if ( isdefined( self.disabled ) && self.disabled )
        {
            wait 0.1;
            continue;
        }
        
        if ( user getcurrentweapon() == level.weaponnone )
        {
            wait 0.1;
            continue;
        }
        
        var_625e97d1 = 0;
        cost = function_6c7a96b4( user, self.base_cost );
        
        if ( zm_utility::is_player_valid( user ) && user zm_score::can_player_purchase( cost ) )
        {
            user zm_score::minus_to_player_score( cost );
            self.bgb_machine_user = user;
            self.current_cost = cost;
            
            if ( user bgb::is_enabled( "zm_bgb_shopping_free" ) )
            {
                var_625e97d1 = 1;
            }
            
            break;
        }
        else
        {
            zm_utility::play_sound_at_pos( "no_purchase", self.origin );
            user zm_audio::create_and_play_dialog( "general", "outofmoney" );
            continue;
        }
        
        wait 0.05;
    }
    
    if ( isdefined( level.bgb_machine_used_vo ) )
    {
        user thread [[ level.bgb_machine_used_vo ]]();
    }
    
    user.bgb_machine_uses_this_round++;
    user clientfield::set_to_player( "zm_bgb_machine_round_buys", user.bgb_machine_uses_this_round );
    self.bgb_machine_user = user;
    self.bgb_machine_open = 1;
    self.bgb_machine_opened_by_fire_sale = 0;
    
    if ( isdefined( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] ) && level.zombie_vars[ "zombie_powerup_fire_sale_on" ] )
    {
        self.bgb_machine_opened_by_fire_sale = 1;
    }
    else
    {
        self.uses_at_current_location++;
    }
    
    self.b_bgb_is_available = self thread bgb_machine_select_bgb( user );
    self thread zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
    self set_bgb_machine_state( "open" );
    self waittill( #"gumball_available" );
    self.grab_bgb_hint = 1;
    self thread zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, &bgb_machine_unitrigger_think );
    gumballtaken = 0;
    gumballoffered = 0;
    var_8a2037cd = 0;
    
    if ( self.b_bgb_is_available )
    {
        bb::logpurchaseevent( user, self, self.current_cost, self.selected_bgb, 0, "_bgb", "_offered" );
        
        if ( isdefined( level.bgb[ self.selected_bgb ] ) )
        {
            gumballoffered = level.bgb[ self.selected_bgb ].item_index;
        }
        
        while ( true )
        {
            self waittill( #"trigger", grabber );
            
            if ( isdefined( grabber.is_drinking ) && grabber.is_drinking > 0 )
            {
                wait 0.1;
                continue;
            }
            
            if ( grabber == user && user getcurrentweapon() == level.weaponnone )
            {
                wait 0.1;
                continue;
            }
            
            if ( grabber == user || grabber == level )
            {
                current_weapon = level.weaponnone;
                
                if ( zm_utility::is_player_valid( user ) )
                {
                    current_weapon = user getcurrentweapon();
                }
                
                if ( grabber == user && zm_utility::is_player_valid( user ) && !( user.is_drinking > 0 ) && !zm_utility::is_placeable_mine( current_weapon ) && !zm_equipment::is_equipment( current_weapon ) && !user zm_utility::is_player_revive_tool( current_weapon ) && !current_weapon.isheroweapon && !current_weapon.isgadget )
                {
                    self notify( #"user_grabbed_bgb" );
                    user notify( #"user_grabbed_bgb" );
                    bb::logpurchaseevent( user, self, self.current_cost, self.selected_bgb, 0, "_bgb", "_grabbed" );
                    user recordmapevent( 3, gettime(), user.origin, level.round_number, var_9bbdff4d, gumballoffered );
                    user __protected__notelootconsume( self.selected_bgb, 1 );
                    user bgb::sub_consumable_bgb( self.selected_bgb );
                    gumballtaken = 1;
                    __protected__setbgbunlocked( 1 );
                    user thread bgb::bgb_gumball_anim( self.selected_bgb, 0 );
                    __protected__setbgbunlocked( 0 );
                    
                    if ( isdefined( level.var_361ee139 ) )
                    {
                        user thread [[ level.var_361ee139 ]]( self );
                    }
                    else
                    {
                        user thread function_acf1c4da( self );
                    }
                    
                    user zm_stats::increment_challenge_stat( "ZM_DAILY_EAT_GOBBLEGUM" );
                    break;
                }
                else if ( grabber == level )
                {
                    bb::logpurchaseevent( user, self, self.current_cost, self.selected_bgb, 0, "_bgb", "_returned" );
                    break;
                }
            }
            
            wait 0.05;
        }
        
        if ( grabber == user )
        {
            self set_bgb_machine_state( "close" );
            self waittill( #"closed" );
        }
    }
    else
    {
        self waittill( #"trigger" );
        bb::logpurchaseevent( user, self, self.current_cost, self.selected_bgb, 0, "_bgb", "_ghostball" );
        
        if ( !var_625e97d1 )
        {
            user zm_score::add_to_player_score( self.current_cost, 0, "bgb_machine_ghost_ball" );
        }
        
        var_8a2037cd = 1;
    }
    
    user recordzombiegumballevent( var_5e7af4df, self.origin, gumballoffered, var_9bbdff4d, gumballtaken, var_8a2037cd, self.bgb_machine_opened_by_fire_sale );
    self thread zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
    self.grab_bgb_hint = 0;
    wait 1;
    
    if ( bgb_machine_should_move() )
    {
        self thread bgb_machine_move();
    }
    else if ( isdefined( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] ) && level.zombie_vars[ "zombie_powerup_fire_sale_on" ] || self.current_bgb_machine )
    {
        self thread set_bgb_machine_state( "initial" );
    }
    
    self.bgb_machine_open = 0;
    self.bgb_machine_opened_by_fire_sale = 0;
    self.bgb_machine_user = undefined;
    self notify( #"bgb_machine_accessed" );
    self thread bgb_machine_think();
}

// Namespace bgb_machine
// Params 0, eflags: 0x4
// Checksum 0x1913383e, Offset: 0x2760
// Size: 0xa4, Type: bool
function private bgb_machine_should_move()
{
    /#
        if ( getdvarint( "<dev string:x99>" ) )
        {
            return false;
        }
    #/
    
    if ( isdefined( level.bgb_machine_never_move ) && level.bgb_machine_never_move )
    {
        return false;
    }
    
    if ( self.uses_at_current_location >= level.bgb_machine_max_uses_before_move )
    {
        return true;
    }
    
    if ( self.uses_at_current_location < level.bgb_machine_min_uses_before_move )
    {
        return false;
    }
    
    if ( randomint( 100 ) < 30 )
    {
        return true;
    }
    
    return false;
}

// Namespace bgb_machine
// Params 0, eflags: 0x4
// Checksum 0x7584fcb8, Offset: 0x2810
// Size: 0xca
function private bgb_machine_movement_frequency()
{
    if ( isdefined( level.bgb_machine_movement_frequency_override_func ) )
    {
        [[ level.bgb_machine_movement_frequency_override_func ]]();
        return;
    }
    
    switch ( level.players.size )
    {
        case 1:
            level.bgb_machine_min_uses_before_move = 1;
            level.bgb_machine_max_uses_before_move = 3;
            break;
        case 2:
            level.bgb_machine_min_uses_before_move = 1;
            level.bgb_machine_max_uses_before_move = 4;
            break;
        case 3:
            level.bgb_machine_min_uses_before_move = 3;
            level.bgb_machine_max_uses_before_move = 5;
            break;
        case 4:
            level.bgb_machine_min_uses_before_move = 3;
            level.bgb_machine_max_uses_before_move = 6;
            break;
    }
}

// Namespace bgb_machine
// Params 0
// Checksum 0x2e12bc0b, Offset: 0x28e8
// Size: 0xd6
function turn_on_fire_sale()
{
    for ( i = 0; i < level.bgb_machines.size ; i++ )
    {
        level.bgb_machines[ i ].old_cost = level.bgb_machines[ i ].base_cost;
        level.bgb_machines[ i ].base_cost = 10;
        
        if ( !level.bgb_machines[ i ].current_bgb_machine )
        {
            level.bgb_machines[ i ].was_fire_sale_temp = 1;
            level.bgb_machines[ i ] thread show_bgb_machine();
        }
    }
}

// Namespace bgb_machine
// Params 0
// Checksum 0xdd5b9175, Offset: 0x29c8
// Size: 0xee
function turn_off_fire_sale()
{
    for ( i = 0; i < level.bgb_machines.size ; i++ )
    {
        level.bgb_machines[ i ].base_cost = level.bgb_machines[ i ].old_cost;
        
        if ( isdefined( level.bgb_machines[ i ].was_fire_sale_temp ) && !level.bgb_machines[ i ].current_bgb_machine && level.bgb_machines[ i ].was_fire_sale_temp )
        {
            level.bgb_machines[ i ].was_fire_sale_temp = undefined;
            level.bgb_machines[ i ] thread remove_temp_machine();
        }
    }
}

// Namespace bgb_machine
// Params 0, eflags: 0x4
// Checksum 0xf0dcde0f, Offset: 0x2ac0
// Size: 0x84
function private remove_temp_machine()
{
    while ( isdefined( self.bgb_machine_open ) && ( isdefined( self.bgb_machine_user ) || self.bgb_machine_open ) )
    {
        util::wait_network_frame();
    }
    
    if ( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] )
    {
        self.was_fire_sale_temp = 1;
        self.base_cost = 10;
        return;
    }
    
    self thread hide_bgb_machine( 1 );
}

// Namespace bgb_machine
// Params 0
// Checksum 0xaeed0965, Offset: 0x2b50
// Size: 0x1f2
function bgb_machine_move()
{
    self hide_bgb_machine( 1 );
    wait 0.1;
    post_selection_wait_duration = 7;
    
    if ( isdefined( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] ) && level.zombie_vars[ "zombie_powerup_fire_sale_on" ] )
    {
        current_sale_time = level.zombie_vars[ "zombie_powerup_fire_sale_time" ];
        util::wait_network_frame();
        self thread fire_sale_fix();
        level.zombie_vars[ "zombie_powerup_fire_sale_time" ] = current_sale_time;
        
        while ( level.zombie_vars[ "zombie_powerup_fire_sale_time" ] > 0 )
        {
            wait 0.1;
        }
    }
    else
    {
        post_selection_wait_duration += 5;
    }
    
    wait post_selection_wait_duration;
    keys = getarraykeys( level.bgb_machines );
    keys = array::randomize( keys );
    
    for ( i = 0; i < keys.size ; i++ )
    {
        if ( self == level.bgb_machines[ keys[ i ] ] || level.bgb_machines[ keys[ i ] ].current_bgb_machine )
        {
            continue;
        }
        
        level.bgb_machines[ keys[ i ] ].current_bgb_machine = 1;
        level.bgb_machines[ keys[ i ] ] show_bgb_machine();
        break;
    }
}

// Namespace bgb_machine
// Params 0
// Checksum 0x47b2b5ce, Offset: 0x2d50
// Size: 0xbc
function fire_sale_fix()
{
    if ( !isdefined( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] ) )
    {
        return;
    }
    
    self.old_cost = self.base_cost;
    self thread show_bgb_machine();
    self.base_cost = 10;
    util::wait_network_frame();
    level waittill( #"fire_sale_off" );
    
    while ( isdefined( self.bgb_machine_open ) && self.bgb_machine_open )
    {
        wait 0.1;
    }
    
    self thread hide_bgb_machine( 1 );
    self.base_cost = self.old_cost;
}

// Namespace bgb_machine
// Params 0
// Checksum 0xdec16793, Offset: 0x2e18
// Size: 0xe8
function bgb_machine_lion_twitches()
{
    self endon( #"zbarrier_state_change" );
    clientfield::set( "zm_bgb_machine_fx_state", 1 );
    self setzbarrierpiecestate( 0, "closed" );
    self setzbarrierpiecestate( 5, "closed" );
    
    while ( true )
    {
        wait randomfloatrange( 180, 1800 );
        self setzbarrierpiecestate( 0, "opening" );
        wait randomfloatrange( 180, 1800 );
        self setzbarrierpiecestate( 0, "closing" );
    }
}

// Namespace bgb_machine
// Params 0
// Checksum 0x34a4d46a, Offset: 0x2f08
// Size: 0x84
function bgb_machine_initial()
{
    clientfield::set( "zm_bgb_machine_fx_state", 4 );
    self setzbarrierpiecestate( 2, "open" );
    self setzbarrierpiecestate( 3, "open" );
    self setzbarrierpiecestate( 5, "closed" );
}

// Namespace bgb_machine
// Params 0
// Checksum 0xff4549d8, Offset: 0x2f98
// Size: 0x134
function bgb_machine_arrives()
{
    self endon( #"zbarrier_state_change" );
    self setzbarrierpiecestate( 3, "closed" );
    clientfield::set( "zm_bgb_machine_fx_state", 2 );
    self setzbarrierpiecestate( 1, "opening" );
    
    while ( self getzbarrierpiecestate( 1 ) == "opening" )
    {
        wait 0.05;
    }
    
    self setzbarrierpiecestate( 1, "closing" );
    self setzbarrierpiecestate( 3, "opening" );
    
    while ( self getzbarrierpiecestate( 1 ) == "closing" )
    {
        wait 0.05;
    }
    
    self notify( #"arrived" );
    self thread set_bgb_machine_state( "initial" );
}

// Namespace bgb_machine
// Params 0
// Checksum 0x66b60aeb, Offset: 0x30d8
// Size: 0x134
function bgb_machine_leaves()
{
    self endon( #"zbarrier_state_change" );
    self setzbarrierpiecestate( 3, "open" );
    clientfield::set( "zm_bgb_machine_fx_state", 2 );
    self setzbarrierpiecestate( 1, "opening" );
    
    while ( self getzbarrierpiecestate( 1 ) == "opening" )
    {
        wait 0.05;
    }
    
    self setzbarrierpiecestate( 1, "closing" );
    self setzbarrierpiecestate( 3, "closing" );
    
    while ( self getzbarrierpiecestate( 1 ) == "closing" )
    {
        wait 0.05;
    }
    
    self notify( #"left" );
    self thread set_bgb_machine_state( "away" );
}

// Namespace bgb_machine
// Params 0
// Checksum 0x5d71ba03, Offset: 0x3218
// Size: 0x1ca
function bgb_machine_opens()
{
    self endon( #"zbarrier_state_change" );
    self setzbarrierpiecestate( 3, "open" );
    self setzbarrierpiecestate( 5, "closed" );
    clientfield::set( "zm_bgb_machine_ghost_ball", !self.b_bgb_is_available );
    state = "opening";
    
    if ( math::cointoss() )
    {
        state = "closing";
    }
    
    self setzbarrierpiecestate( 4, state );
    
    while ( self getzbarrierpiecestate( 4 ) == state )
    {
        wait 0.05;
    }
    
    self setzbarrierpiecestate( 2, "opening" );
    wait 1;
    clientfield::set( "zm_bgb_machine_fx_state", 3 );
    self notify( #"gumball_available" );
    wait 5.5;
    clientfield::set( "zm_bgb_machine_fx_state", 4 );
    self thread zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
    
    while ( self getzbarrierpiecestate( 2 ) == "opening" )
    {
        wait 0.05;
    }
    
    self notify( #"trigger", level );
}

// Namespace bgb_machine
// Params 0
// Checksum 0xa3177c7, Offset: 0x33f0
// Size: 0xca
function bgb_machine_closes()
{
    self endon( #"zbarrier_state_change" );
    self setzbarrierpiecestate( 3, "open" );
    self setzbarrierpiecestate( 5, "closed" );
    clientfield::set( "zm_bgb_machine_fx_state", 4 );
    self setzbarrierpiecestate( 2, "closing" );
    
    while ( self getzbarrierpiecestate( 2 ) == "closing" )
    {
        wait 0.05;
    }
    
    self notify( #"closed" );
}

// Namespace bgb_machine
// Params 0
// Checksum 0x33cc9153, Offset: 0x34c8
// Size: 0x50, Type: bool
function is_bgb_machine_active()
{
    curr_state = self get_bgb_machine_state();
    
    if ( curr_state == "open" || curr_state == "close" )
    {
        return true;
    }
    
    return false;
}

// Namespace bgb_machine
// Params 0
// Checksum 0x87e5fa36, Offset: 0x3520
// Size: 0xa
function get_bgb_machine_state()
{
    return self.state;
}

// Namespace bgb_machine
// Params 1
// Checksum 0xa4f5d29a, Offset: 0x3538
// Size: 0x80
function set_bgb_machine_state( state )
{
    for ( i = 0; i < self getnumzbarrierpieces() ; i++ )
    {
        self hidezbarrierpiece( i );
    }
    
    self notify( #"zbarrier_state_change" );
    self [[ level.bgb_machine_state_func ]]( state );
}

// Namespace bgb_machine
// Params 1
// Checksum 0x73daf883, Offset: 0x35c0
// Size: 0x33a
function process_bgb_machine_state( state )
{
    switch ( state )
    {
        case "away":
            self showzbarrierpiece( 0 );
            self showzbarrierpiece( 5 );
            self thread bgb_machine_lion_twitches();
            self.state = "away";
            break;
        case "arriving":
            self showzbarrierpiece( 1 );
            self showzbarrierpiece( 3 );
            self thread bgb_machine_arrives();
            self.state = "arriving";
            break;
        case "initial":
            self showzbarrierpiece( 2 );
            self showzbarrierpiece( 3 );
            self showzbarrierpiece( 5 );
            self thread bgb_machine_initial();
            self thread zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, &bgb_machine_unitrigger_think );
            self.state = "initial";
            break;
        case "open":
            self showzbarrierpiece( 2 );
            self showzbarrierpiece( 3 );
            self showzbarrierpiece( 4 );
            self showzbarrierpiece( 5 );
            self thread bgb_machine_opens();
            self.state = "open";
            break;
        case "close":
            self showzbarrierpiece( 2 );
            self showzbarrierpiece( 3 );
            self showzbarrierpiece( 5 );
            self thread bgb_machine_closes();
            self.state = "close";
            break;
        case "leaving":
            self showzbarrierpiece( 1 );
            self showzbarrierpiece( 3 );
            self thread bgb_machine_leaves();
            self.state = "leaving";
            break;
        default:
            if ( isdefined( level.custom_bgb_machine_state_handler ) )
            {
                self [[ level.custom_bgb_machine_state_handler ]]( state );
            }
            
            break;
    }
}

// Namespace bgb_machine
// Params 0
// Checksum 0xb0454634, Offset: 0x3908
// Size: 0xf6
function bgb_machine_host_migration()
{
    level endon( #"end_game" );
    level notify( #"bgb_machine_host_migration" );
    level endon( #"bgb_machine_host_migration" );
    
    while ( true )
    {
        level waittill( #"host_migration_end" );
        
        if ( !isdefined( level.bgb_machines ) )
        {
            continue;
        }
        
        foreach ( bgb_machine in level.bgb_machines )
        {
            if ( isdefined( bgb_machine.hidden ) && bgb_machine.hidden )
            {
            }
            
            util::wait_network_frame();
        }
    }
}

// Namespace bgb_machine
// Params 1
// Checksum 0xbe0ed8cb, Offset: 0x3a08
// Size: 0xa4
function function_acf1c4da( machine )
{
    if ( isdefined( level.bgb[ machine.selected_bgb ] ) && level.bgb[ machine.selected_bgb ].limit_type == "activated" )
    {
        self zm_audio::create_and_play_dialog( "bgb", "buy" );
        return;
    }
    
    self zm_audio::create_and_play_dialog( "bgb", "eat" );
}

