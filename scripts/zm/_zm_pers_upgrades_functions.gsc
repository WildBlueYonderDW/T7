#using scripts/codescripts/struct;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/util_shared;
#using scripts/shared/visionset_mgr_shared;
#using scripts/zm/_util;
#using scripts/zm/_zm_magicbox;
#using scripts/zm/_zm_pack_a_punch_util;
#using scripts/zm/_zm_perks;
#using scripts/zm/_zm_pers_upgrades;
#using scripts/zm/_zm_powerups;
#using scripts/zm/_zm_score;
#using scripts/zm/_zm_stats;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_weapons;
#using scripts/zm/gametypes/_globallogic_score;

#namespace zm_pers_upgrades_functions;

// Namespace zm_pers_upgrades_functions
// Params 1
// Checksum 0x3d20a2f7, Offset: 0x5b8
// Size: 0xd0
function pers_boards_updated( zbarrier )
{
    if ( isdefined( level.pers_upgrade_boards ) && level.pers_upgrade_boards )
    {
        if ( zm_pers_upgrades::is_pers_system_active() )
        {
            if ( !( isdefined( self.pers_upgrades_awarded[ "board" ] ) && self.pers_upgrades_awarded[ "board" ] ) )
            {
                if ( level.round_number >= level.pers_boarding_round_start )
                {
                    self zm_stats::increment_client_stat( "pers_boarding", 0 );
                    
                    if ( self.pers[ "pers_boarding" ] >= level.pers_boarding_number_of_boards_required )
                    {
                        if ( isdefined( zbarrier ) )
                        {
                            self.upgrade_fx_origin = zbarrier.origin;
                        }
                    }
                }
            }
        }
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x941cb0d9, Offset: 0x690
// Size: 0x4c, Type: bool
function pers_revive_active()
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( isdefined( self.pers_upgrades_awarded[ "revive" ] ) && self.pers_upgrades_awarded[ "revive" ] )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace zm_pers_upgrades_functions
// Params 1
// Checksum 0x196263cd, Offset: 0x6e8
// Size: 0x3c
function pers_increment_revive_stat( reviver )
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        reviver zm_stats::increment_client_stat( "pers_revivenoperk", 0 );
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x73181d76, Offset: 0x730
// Size: 0x58, Type: bool
function pers_mulit_kill_headshot_active()
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( isdefined( self.pers_upgrades_awarded[ "multikill_headshots" ] ) && isdefined( self.pers_upgrades_awarded ) && self.pers_upgrades_awarded[ "multikill_headshots" ] )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace zm_pers_upgrades_functions
// Params 2
// Checksum 0xa80023f8, Offset: 0x790
// Size: 0xf0
function pers_check_for_pers_headshot( time_of_death, zombie )
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( self.pers[ "last_headshot_kill_time" ] == time_of_death )
        {
            self.pers[ "zombies_multikilled" ]++;
        }
        else
        {
            self.pers[ "zombies_multikilled" ] = 1;
        }
        
        self.pers[ "last_headshot_kill_time" ] = time_of_death;
        
        if ( self.pers[ "zombies_multikilled" ] == 2 )
        {
            if ( isdefined( zombie ) )
            {
                self.upgrade_fx_origin = zombie.origin;
            }
            
            self zm_stats::increment_client_stat( "pers_multikill_headshots", 0 );
            self.non_headshot_kill_counter = 0;
        }
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x38695c70, Offset: 0x888
// Size: 0xe4
function cash_back_player_drinks_perk()
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( isdefined( level.pers_upgrade_cash_back ) && level.pers_upgrade_cash_back )
        {
            if ( isdefined( self.pers_upgrades_awarded[ "cash_back" ] ) && self.pers_upgrades_awarded[ "cash_back" ] )
            {
                self thread cash_back_money_reward();
                self thread cash_back_player_prone_check( 1 );
                return;
            }
            
            if ( self.pers[ "pers_cash_back_bought" ] < level.pers_cash_back_num_perks_required )
            {
                self zm_stats::increment_client_stat( "pers_cash_back_bought", 0 );
                return;
            }
            
            self thread cash_back_player_prone_check( 0 );
        }
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x2450f522, Offset: 0x978
// Size: 0x96
function cash_back_money_reward()
{
    self endon( #"death" );
    step = 5;
    amount_per_step = int( level.pers_cash_back_money_reward / step );
    
    for ( i = 0; i < step ; i++ )
    {
        self zm_score::add_to_player_score( amount_per_step );
        wait 0.2;
    }
}

// Namespace zm_pers_upgrades_functions
// Params 1
// Checksum 0xbc04b666, Offset: 0xa18
// Size: 0xfa
function cash_back_player_prone_check( got_ability )
{
    self endon( #"death" );
    prone_time = 2.5;
    start_time = gettime();
    
    while ( true )
    {
        time = gettime();
        dt = ( time - start_time ) / 1000;
        
        if ( dt > prone_time )
        {
            break;
        }
        
        if ( self getstance() == "prone" )
        {
            if ( !got_ability )
            {
                self zm_stats::increment_client_stat( "pers_cash_back_prone", 0 );
                wait 0.8;
            }
            
            return;
        }
        
        wait 0.01;
    }
    
    if ( got_ability )
    {
        self notify( #"cash_back_failed_prone" );
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0xd4785b08, Offset: 0xb20
// Size: 0x1ec
function pers_upgrade_insta_kill_upgrade_check()
{
    if ( isdefined( level.pers_upgrade_insta_kill ) && level.pers_upgrade_insta_kill )
    {
        self endon( #"death" );
        
        if ( !zm_pers_upgrades::is_pers_system_active() )
        {
            return;
        }
        
        players = getplayers();
        
        for ( i = 0; i < players.size ; i++ )
        {
            e_player = players[ i ];
            
            if ( isdefined( e_player.pers_upgrades_awarded[ "insta_kill" ] ) && e_player.pers_upgrades_awarded[ "insta_kill" ] )
            {
                e_player thread insta_kill_upgraded_player_kill_func( level.pers_insta_kill_upgrade_active_time );
            }
        }
        
        if ( !( isdefined( self.pers_upgrades_awarded[ "insta_kill" ] ) && self.pers_upgrades_awarded[ "insta_kill" ] ) )
        {
            kills_start = self globallogic_score::getpersstat( "kills" );
            self waittill( #"insta_kill_over" );
            kills_end = self globallogic_score::getpersstat( "kills" );
            num_killed = kills_end - kills_start;
            
            if ( num_killed > 0 )
            {
                self zm_stats::zero_client_stat( "pers_insta_kill", 0 );
                return;
            }
            
            self zm_stats::increment_client_stat( "pers_insta_kill", 0 );
        }
    }
}

// Namespace zm_pers_upgrades_functions
// Params 1
// Checksum 0x9fba5898, Offset: 0xd18
// Size: 0x290
function insta_kill_upgraded_player_kill_func( active_time )
{
    self endon( #"death" );
    wait 0.25;
    
    if ( zm_pers_upgrades::is_pers_system_disabled() )
    {
        return;
    }
    
    self thread zm_pers_upgrades::insta_kill_pers_upgrade_icon();
    start_time = gettime();
    zombie_collide_radius = 50;
    zombie_player_height_test = 100;
    
    while ( true )
    {
        time = gettime();
        dt = ( time - start_time ) / 1000;
        
        if ( dt > active_time )
        {
            break;
        }
        
        if ( !zm_powerups::is_insta_kill_active() )
        {
            break;
        }
        
        a_zombies = getaiteamarray( level.zombie_team );
        e_closest = undefined;
        
        for ( i = 0; i < a_zombies.size ; i++ )
        {
            e_zombie = a_zombies[ i ];
            
            if ( isdefined( e_zombie.marked_for_insta_upgraded_death ) )
            {
                continue;
            }
            
            height_diff = abs( self.origin[ 2 ] - e_zombie.origin[ 2 ] );
            
            if ( height_diff < zombie_player_height_test )
            {
                dist = distance2d( self.origin, e_zombie.origin );
                
                if ( dist < zombie_collide_radius )
                {
                    dist_max = dist;
                    e_closest = e_zombie;
                }
            }
        }
        
        if ( isdefined( e_closest ) )
        {
            e_closest.marked_for_insta_upgraded_death = 1;
            e_closest dodamage( e_closest.health + 666, e_closest.origin, self, self, "none", "MOD_PISTOL_BULLET", 0 );
        }
        
        wait 0.01;
    }
}

// Namespace zm_pers_upgrades_functions
// Params 2
// Checksum 0xc0cd28c1, Offset: 0xfb0
// Size: 0x88
function pers_insta_kill_melee_swipe( smeansofdeath, eattacker )
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( isdefined( smeansofdeath ) && smeansofdeath == "MOD_MELEE" )
        {
            if ( isplayer( self ) && zm_pers_upgrades::is_insta_kill_upgraded_and_active() )
            {
                self notify( #"pers_melee_swipe" );
                level.pers_melee_swipe_zombie_swiper = eattacker;
            }
        }
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x70ea2180, Offset: 0x1040
// Size: 0x90
function pers_upgrade_jugg_player_death_stat()
{
    if ( isdefined( level.pers_upgrade_jugg ) && level.pers_upgrade_jugg )
    {
        if ( zm_pers_upgrades::is_pers_system_active() )
        {
            if ( !( isdefined( self.pers_upgrades_awarded[ "jugg" ] ) && self.pers_upgrades_awarded[ "jugg" ] ) )
            {
                if ( level.round_number <= level.pers_jugg_hit_and_die_round_limit )
                {
                    self zm_stats::increment_client_stat( "pers_jugg", 0 );
                    
                    /#
                    #/
                }
            }
        }
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x1b6cc39a, Offset: 0x10d8
// Size: 0x58, Type: bool
function pers_jugg_active()
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( isdefined( self.pers_upgrades_awarded[ "jugg" ] ) && isdefined( self.pers_upgrades_awarded ) && self.pers_upgrades_awarded[ "jugg" ] )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0xbea5d2eb, Offset: 0x1138
// Size: 0xf6
function pers_upgrade_pistol_points_kill()
{
    if ( !zm_pers_upgrades::is_pers_system_active() )
    {
        return;
    }
    
    if ( !isdefined( self.pers_num_zombies_killed_in_game ) )
    {
        self.pers_num_zombies_killed_in_game = 0;
    }
    
    self.pers_num_zombies_killed_in_game++;
    
    if ( !( isdefined( self.pers_upgrades_awarded[ "pistol_points" ] ) && self.pers_upgrades_awarded[ "pistol_points" ] ) )
    {
        if ( self.pers_num_zombies_killed_in_game >= level.pers_pistol_points_num_kills_in_game )
        {
            accuracy = self pers_get_player_accuracy();
            
            if ( accuracy <= level.pers_pistol_points_accuracy )
            {
                self zm_stats::increment_client_stat( "pers_pistol_points_counter", 0 );
                
                /#
                    iprintlnbold( "<dev string:x28>" );
                #/
            }
        }
        
        return;
    }
    
    self notify( #"pers_pistol_points_kill" );
}

// Namespace zm_pers_upgrades_functions
// Params 4
// Checksum 0xb7fdd81, Offset: 0x1238
// Size: 0x10c
function pers_upgrade_pistol_points_set_score( score, event, mod, damage_weapon )
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( isdefined( self.pers_upgrades_awarded[ "pistol_points" ] ) && self.pers_upgrades_awarded[ "pistol_points" ] )
        {
            if ( isdefined( event ) )
            {
                if ( event == "rebuild_board" )
                {
                    return score;
                }
                
                if ( isdefined( damage_weapon ) )
                {
                    weapon_class = zm_utility::getweaponclasszm( damage_weapon );
                    
                    if ( weapon_class != "weapon_pistol" )
                    {
                        return score;
                    }
                }
                
                if ( isdefined( mod ) && isstring( mod ) && mod == "MOD_PISTOL_BULLET" )
                {
                    score *= 2;
                }
            }
        }
    }
    
    return score;
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x9317941b, Offset: 0x1350
// Size: 0x2e6
function pers_upgrade_double_points_pickup_start()
{
    self endon( #"death" );
    self endon( #"disconnect" );
    
    if ( !zm_pers_upgrades::is_pers_system_active() )
    {
        return;
    }
    
    if ( isdefined( self.double_points_ability_check_active ) && self.double_points_ability_check_active )
    {
        self.double_points_ability_start_time = gettime();
        return;
    }
    
    self.double_points_ability_check_active = 1;
    level.pers_double_points_active = 1;
    start_points = self.score;
    
    if ( isdefined( self.account_value ) )
    {
        bank_account_value_start = self.account_value;
    }
    else
    {
        bank_account_value_start = 0;
    }
    
    self.double_points_ability_start_time = gettime();
    last_score = self.score;
    ability_lost = 0;
    
    while ( true )
    {
        if ( self.score > last_score )
        {
            ability_lost = 1;
        }
        
        last_score = self.score;
        time = gettime();
        dt = ( time - self.double_points_ability_start_time ) / 1000;
        
        if ( dt >= 30 )
        {
            break;
        }
        
        wait 0.1;
    }
    
    level.pers_double_points_active = undefined;
    
    if ( isdefined( self.account_value ) )
    {
        bank_account_value_end = self.account_value;
    }
    else
    {
        bank_account_value_end = 0;
    }
    
    if ( bank_account_value_end < bank_account_value_start )
    {
        withdrawal_number = bank_account_value_start - bank_account_value_end;
        withdrawal_fees = level.ta_vaultfee * withdrawal_number;
        withdrawal_amount = level.bank_deposit_ddl_increment_amount * withdrawal_number;
        bank_withdrawal_total = withdrawal_amount - withdrawal_fees;
    }
    else
    {
        bank_withdrawal_total = 0;
    }
    
    if ( isdefined( self.pers_upgrades_awarded[ "double_points" ] ) && self.pers_upgrades_awarded[ "double_points" ] )
    {
        if ( ability_lost == 1 )
        {
            self notify( #"double_points_lost" );
        }
    }
    else
    {
        total_points = self.score - start_points;
        total_points -= bank_withdrawal_total;
        
        if ( total_points >= level.pers_double_points_score )
        {
            self zm_stats::increment_client_stat( "pers_double_points_counter", 0 );
            
            /#
                iprintlnbold( "<dev string:x28>" );
            #/
        }
    }
    
    self.double_points_ability_check_active = undefined;
}

// Namespace zm_pers_upgrades_functions
// Params 1
// Checksum 0x28858f3b, Offset: 0x1640
// Size: 0x8c
function pers_upgrade_double_points_set_score( score )
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( isdefined( self.pers_upgrades_awarded[ "double_points" ] ) && self.pers_upgrades_awarded[ "double_points" ] )
        {
            if ( isdefined( level.pers_double_points_active ) && level.pers_double_points_active )
            {
                /#
                #/
                
                score = int( score * 0.5 );
            }
        }
    }
    
    return score;
}

// Namespace zm_pers_upgrades_functions
// Params 1
// Checksum 0x322e48d9, Offset: 0x16d8
// Size: 0x74
function pers_upgrade_double_points_cost( current_cost )
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( isdefined( self.pers_upgrades_awarded[ "double_points" ] ) && self.pers_upgrades_awarded[ "double_points" ] )
        {
            current_cost = int( current_cost / 2 );
        }
    }
    
    return current_cost;
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0xa047c3e2, Offset: 0x1758
// Size: 0x4e, Type: bool
function is_pers_double_points_active()
{
    if ( isdefined( self.pers_upgrades_awarded[ "double_points" ] ) && self.pers_upgrades_awarded[ "double_points" ] )
    {
        if ( isdefined( level.pers_double_points_active ) && level.pers_double_points_active )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x2dcc7969, Offset: 0x17b0
// Size: 0x13a
function pers_upgrade_perk_lose_bought()
{
    if ( !zm_pers_upgrades::is_pers_system_active() )
    {
        return;
    }
    
    wait 1;
    
    if ( !( isdefined( self.pers_upgrades_awarded[ "perk_lose" ] ) && self.pers_upgrades_awarded[ "perk_lose" ] ) )
    {
        if ( level.round_number <= level.pers_perk_round_reached_max )
        {
            if ( !isdefined( self.bought_all_perks ) )
            {
                a_perks = self zm_perks::get_perk_array();
                
                if ( isdefined( a_perks ) && a_perks.size == 4 )
                {
                    self zm_stats::increment_client_stat( "pers_perk_lose_counter", 0 );
                    
                    /#
                        iprintlnbold( "<dev string:x48>" );
                    #/
                    
                    self.bought_all_perks = 1;
                }
            }
        }
        
        return;
    }
    
    if ( isdefined( self.pers_perk_lose_start_round ) )
    {
        if ( level.round_number > 1 && self.pers_perk_lose_start_round == level.round_number )
        {
            self notify( #"pers_perk_lose_lost" );
        }
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x882863b, Offset: 0x18f8
// Size: 0x14e
function pers_upgrade_perk_lose_save()
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( isdefined( self.perks_active ) )
        {
            self.a_saved_perks = [];
            self.a_saved_perks = arraycopy( self.perks_active );
        }
        else
        {
            self.a_saved_perks = self zm_perks::get_perk_array();
        }
        
        self.a_saved_primaries = self getweaponslistprimaries();
        self.a_saved_primaries_weapons = [];
        index = 0;
        
        foreach ( weapon in self.a_saved_primaries )
        {
            self.a_saved_primaries_weapons[ index ] = zm_weapons::get_player_weapondata( self, weapon );
            index++;
        }
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x9378c49d, Offset: 0x1a50
// Size: 0x302
function pers_upgrade_perk_lose_restore()
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        player_has_mule_kick = 0;
        discard_quickrevive = 0;
        
        if ( isdefined( self.a_saved_perks ) && self.a_saved_perks.size >= 2 )
        {
            for ( i = 0; i < self.a_saved_perks.size ; i++ )
            {
                perk = self.a_saved_perks[ i ];
                
                if ( perk == "specialty_quickrevive" )
                {
                    discard_quickrevive = 1;
                }
            }
            
            if ( discard_quickrevive == 1 )
            {
                size = self.a_saved_perks.size;
            }
            else
            {
                size = self.a_saved_perks.size - 1;
            }
            
            for ( i = 0; i < size ; i++ )
            {
                perk = self.a_saved_perks[ i ];
                
                if ( discard_quickrevive == 1 && perk == "specialty_quickrevive" )
                {
                    continue;
                }
                
                if ( perk == "specialty_additionalprimaryweapon" )
                {
                    player_has_mule_kick = 1;
                }
                
                if ( self hasperk( perk ) )
                {
                    continue;
                }
                
                self zm_perks::give_perk( perk );
                util::wait_network_frame();
            }
        }
        
        if ( player_has_mule_kick )
        {
            a_current_weapons = self getweaponslistprimaries();
            
            for ( i = 0; i < self.a_saved_primaries_weapons.size ; i++ )
            {
                saved_weapon = self.a_saved_primaries_weapons[ i ];
                found = 0;
                
                for ( j = 0; j < a_current_weapons.size ; j++ )
                {
                    current_weapon = a_current_weapons[ j ];
                    
                    if ( current_weapon == saved_weapon[ "weapon" ] )
                    {
                        found = 1;
                        break;
                    }
                }
                
                if ( found == 0 )
                {
                    self zm_weapons::weapondata_give( self.a_saved_primaries_weapons[ i ] );
                    self switchtoweapon( a_current_weapons[ 0 ] );
                    break;
                }
            }
        }
        
        self.a_saved_perks = undefined;
        self.a_saved_primaries = undefined;
        self.a_saved_primaries_weapons = undefined;
    }
}

// Namespace zm_pers_upgrades_functions
// Params 2
// Checksum 0xeff16f5, Offset: 0x1d60
// Size: 0x1fc
function pers_upgrade_sniper_kill_check( zombie, attacker )
{
    if ( !zm_pers_upgrades::is_pers_system_active() )
    {
        return;
    }
    
    if ( !isdefined( zombie ) || !isdefined( attacker ) )
    {
        return;
    }
    
    if ( isdefined( zombie.marked_for_insta_upgraded_death ) && zombie.marked_for_insta_upgraded_death )
    {
        return;
    }
    
    weapon = zombie.damageweapon;
    
    if ( weapon.issniperweapon )
    {
        return;
    }
    
    if ( isdefined( self.pers_upgrades_awarded[ "sniper" ] ) && self.pers_upgrades_awarded[ "sniper" ] )
    {
        self thread pers_sniper_score_reward();
        return;
    }
    
    dist = distance( zombie.origin, attacker.origin );
    
    if ( dist < level.pers_sniper_kill_distance )
    {
        return;
    }
    
    if ( !isdefined( self.pers_sniper_round ) )
    {
        self.pers_sniper_round = level.round_number;
        self.pers_sniper_kills = 0;
    }
    else if ( self.pers_sniper_round != level.round_number )
    {
        self.pers_sniper_round = level.round_number;
        self.pers_sniper_kills = 0;
    }
    
    self.pers_sniper_kills++;
    
    /#
        iprintlnbold( "<dev string:x64>" );
    #/
    
    if ( self.pers_sniper_kills >= level.pers_sniper_round_kills_counter )
    {
        self zm_stats::increment_client_stat( "pers_sniper_counter", 0 );
        
        /#
            iprintlnbold( "<dev string:x81>" );
        #/
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x4773f872, Offset: 0x1f68
// Size: 0xbe
function pers_sniper_score_reward()
{
    self endon( #"disconnect" );
    self endon( #"death" );
    
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        total_score = 300;
        steps = 10;
        score_inc = int( total_score / steps );
        
        for ( i = 0; i < steps ; i++ )
        {
            self zm_score::add_to_player_score( score_inc );
            wait 0.25;
        }
    }
}

// Namespace zm_pers_upgrades_functions
// Params 2
// Checksum 0xadfc444a, Offset: 0x2030
// Size: 0xe0
function pers_sniper_player_fires( weapon, hit )
{
    if ( !zm_pers_upgrades::is_pers_system_active() )
    {
        return;
    }
    
    if ( isdefined( weapon ) && isdefined( hit ) )
    {
        if ( isdefined( self.pers_upgrades_awarded[ "sniper" ] ) && self.pers_upgrades_awarded[ "sniper" ] )
        {
            if ( weapon.issniperweapon )
            {
                if ( !isdefined( self.num_sniper_misses ) )
                {
                    self.num_sniper_misses = 0;
                }
                
                if ( hit )
                {
                    self.num_sniper_misses = 0;
                    return;
                }
                
                self.num_sniper_misses++;
                
                if ( self.num_sniper_misses >= level.pers_sniper_misses )
                {
                    self notify( #"pers_sniper_lost" );
                    self.num_sniper_misses = 0;
                }
            }
        }
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x35ee9c67, Offset: 0x2118
// Size: 0x88
function pers_get_player_accuracy()
{
    accuracy = 1;
    total_shots = self globallogic_score::getpersstat( "total_shots" );
    total_hits = self globallogic_score::getpersstat( "hits" );
    
    if ( total_shots > 0 )
    {
        accuracy = total_hits / total_shots;
    }
    
    return accuracy;
}

// Namespace zm_pers_upgrades_functions
// Params 2
// Checksum 0xd361310f, Offset: 0x21a8
// Size: 0x160
function pers_upgrade_box_weapon_used( e_user, e_grabber )
{
    if ( !zm_pers_upgrades::is_pers_system_active() )
    {
        return;
    }
    
    if ( level.round_number >= level.pers_box_weapon_lose_round )
    {
        return;
    }
    
    if ( isdefined( e_grabber ) && isplayer( e_grabber ) )
    {
        if ( isdefined( e_grabber.pers_box_weapon_awarded ) && e_grabber.pers_box_weapon_awarded )
        {
            return;
        }
        
        if ( isdefined( e_grabber.pers_upgrades_awarded[ "box_weapon" ] ) && e_grabber.pers_upgrades_awarded[ "box_weapon" ] )
        {
            return;
        }
        
        e_grabber zm_stats::increment_client_stat( "pers_box_weapon_counter", 0 );
        
        /#
        #/
        
        return;
    }
    
    if ( isdefined( e_user ) && isplayer( e_user ) )
    {
        if ( isdefined( e_user.pers_upgrades_awarded[ "box_weapon" ] ) && e_user.pers_upgrades_awarded[ "box_weapon" ] )
        {
            return;
        }
        
        e_user zm_stats::zero_client_stat( "pers_box_weapon_counter", 0 );
        
        /#
        #/
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x823a6610, Offset: 0x2310
// Size: 0x384
function pers_magic_box_teddy_bear()
{
    self endon( #"disconnect" );
    
    if ( isdefined( level.pers_magic_box_firesale ) && level.pers_magic_box_firesale )
    {
        self thread pers_magic_box_firesale();
    }
    
    m_bear = spawn( "script_model", self.origin );
    m_bear setmodel( level.chest_joker_model );
    m_bear pers_magic_box_set_teddy_location( level.chest_index );
    self.pers_magix_box_teddy_bear = m_bear;
    m_bear setinvisibletoall();
    wait 0.1;
    m_bear setvisibletoplayer( self );
    
    while ( true )
    {
        box = level.chests[ level.chest_index ];
        
        if ( level.round_number >= level.pers_box_weapon_lose_round )
        {
            break;
        }
        
        if ( zm_pers_upgrades::is_pers_system_disabled() )
        {
            m_bear setinvisibletoall();
            
            while ( true )
            {
                if ( !zm_pers_upgrades::is_pers_system_disabled() )
                {
                    break;
                }
                
                wait 0.01;
            }
            
            m_bear setvisibletoplayer( self );
        }
        
        if ( level flag::get( "moving_chest_now" ) )
        {
            m_bear setinvisibletoall();
            
            while ( level flag::get( "moving_chest_now" ) )
            {
                wait 0.1;
            }
            
            m_bear pers_magic_box_set_teddy_location( level.chest_index );
            wait 0.1;
            m_bear setvisibletoplayer( self );
        }
        
        if ( isdefined( level.sloth_moving_box ) && level.sloth_moving_box )
        {
            m_bear setinvisibletoall();
            
            while ( isdefined( level.sloth_moving_box ) && level.sloth_moving_box )
            {
                wait 0.1;
            }
            
            m_bear pers_magic_box_set_teddy_location( level.chest_index );
            wait 0.1;
            m_bear setvisibletoplayer( self );
        }
        
        if ( isdefined( box._box_open ) && box._box_open )
        {
            m_bear setinvisibletoall();
            
            while ( true )
            {
                if ( !( isdefined( box._box_open ) && box._box_open ) )
                {
                    break;
                }
                
                wait 0.01;
            }
            
            m_bear setvisibletoplayer( self );
        }
        
        wait 0.01;
    }
    
    m_bear delete();
}

// Namespace zm_pers_upgrades_functions
// Params 1
// Checksum 0x5be8f21e, Offset: 0x26a0
// Size: 0x170
function pers_magic_box_set_teddy_location( box_index )
{
    box = level.chests[ box_index ];
    
    if ( isdefined( box.zbarrier ) )
    {
        v_origin = box.zbarrier.origin;
        v_angles = box.zbarrier.angles;
    }
    else
    {
        v_origin = box.origin;
        v_angles = box.angles;
    }
    
    v_up = anglestoup( v_angles );
    height_offset = 22;
    self.origin = v_origin + v_up * height_offset;
    dp = vectordot( v_up, ( 0, 0, 1 ) );
    
    if ( dp > 0 )
    {
        v_angles_offset = ( 0, 90, 0 );
    }
    else
    {
        v_angles_offset = ( 0, -90, -10 );
    }
    
    self.angles = v_angles + v_angles_offset;
}

// Namespace zm_pers_upgrades_functions
// Params 1
// Checksum 0x68bdf7f3, Offset: 0x2818
// Size: 0x256
function pers_treasure_chest_choosespecialweapon( player )
{
    rval = randomfloat( 1 );
    
    if ( !isdefined( player.pers_magic_box_weapon_count ) )
    {
        player.pers_magic_box_weapon_count = 0;
    }
    
    if ( player.pers_magic_box_weapon_count == 0 || player.pers_magic_box_weapon_count < 2 && rval < 0.6 )
    {
        /#
        #/
        
        player.pers_magic_box_weapon_count++;
        
        if ( isdefined( level.pers_treasure_chest_get_weapons_array_func ) )
        {
            [[ level.pers_treasure_chest_get_weapons_array_func ]]();
        }
        else
        {
            pers_treasure_chest_get_weapons_array();
        }
        
        keys = array::randomize( level.pers_box_weapons );
        
        /#
            forced_weapon_name = getdvarstring( "<dev string:x9a>" );
            forced_weapon = getweapon( forced_weapon_name );
            
            if ( forced_weapon_name != "<dev string:xab>" && isdefined( level.zombie_weapons[ getweapon( forced_weapon ) ] ) )
            {
                arrayinsert( keys, forced_weapon, 0 );
            }
        #/
        
        pap_triggers = zm_pap_util::get_triggers();
        
        for ( i = 0; i < keys.size ; i++ )
        {
            if ( zm_magicbox::treasure_chest_canplayerreceiveweapon( player, keys[ i ], pap_triggers ) )
            {
                return keys[ i ];
            }
        }
        
        return keys[ 0 ];
    }
    
    /#
    #/
    
    player.pers_magic_box_weapon_count = 0;
    weapon = zm_magicbox::treasure_chest_chooseweightedrandomweapon( player );
    return weapon;
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0xee7bd16f, Offset: 0x2a78
// Size: 0x10e
function pers_treasure_chest_get_weapons_array()
{
    if ( !isdefined( level.pers_box_weapons ) )
    {
        level.pers_box_weapons = [];
        level.pers_box_weapons[ level.pers_box_weapons.size ] = getweapon( "ray_gun" );
        level.pers_box_weapons[ level.pers_box_weapons.size ] = getweapon( "knife_ballistic" );
        level.pers_box_weapons[ level.pers_box_weapons.size ] = getweapon( "srm1216" );
        level.pers_box_weapons[ level.pers_box_weapons.size ] = getweapon( "hamr" );
        level.pers_box_weapons[ level.pers_box_weapons.size ] = getweapon( "tar21" );
        level.pers_box_weapons[ level.pers_box_weapons.size ] = getweapon( "raygun_mark2" );
    }
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x12118b3a, Offset: 0x2b90
// Size: 0x10c
function pers_magic_box_firesale()
{
    self endon( #"disconnect" );
    wait 1;
    
    while ( true )
    {
        if ( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] == 1 )
        {
            wait 5;
            
            for ( i = 0; i < level.chests.size ; i++ )
            {
                if ( i == level.chest_index )
                {
                    continue;
                }
                
                box = level.chests[ i ];
                self thread box_firesale_teddy_bear( box, i );
            }
            
            while ( true )
            {
                if ( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] == 0 )
                {
                    break;
                }
                
                wait 0.01;
            }
        }
        
        if ( level.round_number >= level.pers_box_weapon_lose_round )
        {
            return;
        }
        
        wait 0.5;
    }
}

// Namespace zm_pers_upgrades_functions
// Params 2
// Checksum 0x76d6dbe7, Offset: 0x2ca8
// Size: 0x194
function box_firesale_teddy_bear( box, box_index )
{
    self endon( #"disconnect" );
    m_bear = spawn( "script_model", self.origin );
    m_bear setmodel( level.chest_joker_model );
    m_bear pers_magic_box_set_teddy_location( box_index );
    m_bear setinvisibletoall();
    wait 0.1;
    m_bear setvisibletoplayer( self );
    
    while ( true )
    {
        if ( isdefined( box._box_open ) && box._box_open )
        {
            m_bear setinvisibletoall();
            
            while ( true )
            {
                if ( !( isdefined( box._box_open ) && box._box_open ) )
                {
                    break;
                }
                
                wait 0.01;
            }
            
            m_bear setvisibletoplayer( self );
        }
        
        if ( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] == 0 )
        {
            break;
        }
        
        wait 0.01;
    }
    
    m_bear delete();
}

// Namespace zm_pers_upgrades_functions
// Params 0
// Checksum 0x5e63d1dc, Offset: 0x2e48
// Size: 0x1aa
function pers_nube_unlock_watcher()
{
    self endon( #"disconnect" );
    
    if ( !zm_pers_upgrades::is_pers_system_active() )
    {
        return;
    }
    
    self.pers_num_nube_kills = 0;
    
    if ( self.pers[ "pers_max_round_reached" ] >= level.pers_nube_lose_round )
    {
        return;
    }
    
    num_melee_kills = self.pers[ "melee_kills" ];
    num_headshot_kills = self.pers[ "headshots" ];
    
    for ( num_boards = self.pers[ "boards" ]; true ; num_boards = self.pers[ "boards" ] )
    {
        self waittill( #"pers_player_zombie_kill" );
        
        if ( self.pers[ "pers_max_round_reached" ] >= level.pers_nube_lose_round )
        {
            self.pers_num_nube_kills = 0;
            return;
        }
        
        if ( num_melee_kills == self.pers[ "melee_kills" ] && num_headshot_kills == self.pers[ "headshots" ] && num_boards == self.pers[ "boards" ] )
        {
            self.pers_num_nube_kills++;
            continue;
        }
        
        self.pers_num_nube_kills = 0;
        num_melee_kills = self.pers[ "melee_kills" ];
        num_headshot_kills = self.pers[ "headshots" ];
    }
}

// Namespace zm_pers_upgrades_functions
// Params 1
// Checksum 0x97492683, Offset: 0x3000
// Size: 0x30, Type: bool
function pers_nube_player_ranked_as_nube( player )
{
    if ( player.pers_num_nube_kills >= level.pers_numb_num_kills_unlock )
    {
        return true;
    }
    
    return false;
}

// Namespace zm_pers_upgrades_functions
// Params 2
// Checksum 0x1adfc5cc, Offset: 0x3038
// Size: 0x1ac
function pers_nube_weapon_upgrade_check( player, weapon )
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( weapon.name == "rottweil72" )
        {
            if ( !( isdefined( player.pers_upgrades_awarded[ "nube" ] ) && player.pers_upgrades_awarded[ "nube" ] ) )
            {
                if ( pers_nube_player_ranked_as_nube( player ) )
                {
                    player zm_stats::increment_client_stat( "pers_nube_counter", 0 );
                    weapon = getweapon( "ray_gun" );
                    fx_org = player.origin;
                    v_dir = anglestoforward( player getplayerangles() );
                    v_up = anglestoup( player getplayerangles() );
                    fx_org = fx_org + v_dir * 5 + v_up * 12;
                    player.upgrade_fx_origin = fx_org;
                }
            }
            else
            {
                weapon = getweapon( "ray_gun" );
            }
        }
    }
    
    return weapon;
}

// Namespace zm_pers_upgrades_functions
// Params 2
// Checksum 0xb072dd19, Offset: 0x31f0
// Size: 0x134
function pers_nube_weapon_ammo_check( player, weapon )
{
    if ( zm_pers_upgrades::is_pers_system_active() )
    {
        if ( weapon.name == "rottweil72" )
        {
            if ( isdefined( player.pers_upgrades_awarded[ "nube" ] ) && player.pers_upgrades_awarded[ "nube" ] )
            {
                ray_gun_weapon = getweapon( "ray_gun" );
                
                if ( player hasweapon( ray_gun_weapon ) )
                {
                    weapon = getweapon( ray_gun_weapon );
                }
                
                ray_gun_upgraded_weapon = getweapon( "ray_gun_upgraded" );
                
                if ( player hasweapon( ray_gun_upgraded_weapon ) )
                {
                    weapon = getweapon( ray_gun_upgraded_weapon );
                }
            }
        }
    }
    
    return weapon;
}

// Namespace zm_pers_upgrades_functions
// Params 3
// Checksum 0xf703b58e, Offset: 0x3330
// Size: 0x212
function pers_nube_should_we_give_raygun( player_has_weapon, player, weapon_buy )
{
    if ( !zm_pers_upgrades::is_pers_system_active() )
    {
        return player_has_weapon;
    }
    
    if ( player.pers[ "pers_max_round_reached" ] >= level.pers_nube_lose_round )
    {
        return player_has_weapon;
    }
    
    if ( !pers_nube_player_ranked_as_nube( player ) )
    {
        return player_has_weapon;
    }
    
    rottweil_weapon = getweapon( "rottweil72" );
    
    if ( weapon_buy != rottweil_weapon )
    {
        return player_has_weapon;
    }
    
    player_has_olympia = player hasweapon( rottweil_weapon ) || player hasweapon( getweapon( "rottweil72_upgraded" ) );
    player_has_raygun = player hasweapon( getweapon( "ray_gun" ) ) || player hasweapon( getweapon( "ray_gun_upgraded" ) );
    
    if ( player_has_olympia && player_has_raygun )
    {
        player_has_weapon = 1;
    }
    else if ( pers_nube_player_ranked_as_nube( player ) && player_has_olympia && player_has_raygun == 0 )
    {
        player_has_weapon = 0;
    }
    else if ( isdefined( player.pers_upgrades_awarded[ "nube" ] ) && player.pers_upgrades_awarded[ "nube" ] && player_has_raygun )
    {
        player_has_weapon = 1;
    }
    
    return player_has_weapon;
}

// Namespace zm_pers_upgrades_functions
// Params 2
// Checksum 0x8eb67f56, Offset: 0x3550
// Size: 0xc0, Type: bool
function pers_nube_ammo_hint_string( player, weapon )
{
    ammo_cost = 0;
    
    if ( !zm_pers_upgrades::is_pers_system_active() )
    {
        return false;
    }
    
    if ( weapon.name == "rottweil72" )
    {
        ammo_cost = pers_nube_ammo_cost( player, ammo_cost );
    }
    
    if ( !ammo_cost )
    {
        return false;
    }
    
    self.stub.hint_string = &"ZOMBIE_WEAPONAMMOONLY";
    self sethintstring( self.stub.hint_string, ammo_cost );
    return true;
}

// Namespace zm_pers_upgrades_functions
// Params 2
// Checksum 0x4db33991, Offset: 0x3618
// Size: 0x84
function pers_nube_ammo_cost( player, ammo_cost )
{
    if ( player hasweapon( getweapon( "ray_gun" ) ) )
    {
        ammo_cost = 250;
    }
    
    if ( player hasweapon( getweapon( "ray_gun_upgraded" ) ) )
    {
        ammo_cost = 4500;
    }
    
    return ammo_cost;
}

// Namespace zm_pers_upgrades_functions
// Params 3
// Checksum 0xedb0966e, Offset: 0x36a8
// Size: 0x74
function pers_nube_override_ammo_cost( player, weapon, ammo_cost )
{
    if ( !zm_pers_upgrades::is_pers_system_active() )
    {
        return ammo_cost;
    }
    
    if ( weapon.name == "rottweil72" )
    {
        ammo_cost = pers_nube_ammo_cost( player, ammo_cost );
    }
    
    return ammo_cost;
}

