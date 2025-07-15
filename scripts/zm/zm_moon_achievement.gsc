#using scripts/codescripts/struct;
#using scripts/shared/array_shared;
#using scripts/shared/audio_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/exploder_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_zm;
#using scripts/zm/_zm_audio;
#using scripts/zm/_zm_stats;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_weapons;

#namespace zm_moon_achievement;

// Namespace zm_moon_achievement
// Params 0
// Checksum 0xa2d7d7cb, Offset: 0x318
// Size: 0x54
function init()
{
    level thread achievement_moon_sidequest();
    level thread achievement_ground_control();
    callback::on_connect( &onplayerconnect );
}

// Namespace zm_moon_achievement
// Params 0
// Checksum 0x493b2ea8, Offset: 0x378
// Size: 0x64
function onplayerconnect()
{
    self thread achievement_one_small_hack();
    self thread achievement_one_giant_leap();
    self thread achievement_perks_in_space();
    self thread achievement_fully_armed();
}

// Namespace zm_moon_achievement
// Params 1
// Checksum 0x358a2d20, Offset: 0x3e8
// Size: 0xb6
function achievement_set_interim_sidequest_stat_for_all_players( stat_name )
{
    if ( level.systemlink )
    {
        return;
    }
    
    if ( getdvarint( "splitscreen_playerCount" ) == getplayers().size )
    {
        return;
    }
    
    players = getplayers();
    
    for ( i = 0; i < players.size ; i++ )
    {
        players[ i ] zm_stats::add_global_stat( stat_name, 1 );
    }
}

// Namespace zm_moon_achievement
// Params 0
// Checksum 0x6da61b3d, Offset: 0x4a8
// Size: 0xbc
function achievement_moon_sidequest()
{
    level endon( #"end_game" );
    level waittill( #"moon_sidequest_reveal_achieved" );
    level achievement_set_interim_sidequest_stat_for_all_players( "ZOMBIE_MOON_SIDEQUEST" );
    level zm_utility::giveachievement_wrapper( "DLC5_ZOM_CRYOGENIC_PARTY", 1 );
    level waittill( #"moon_sidequest_swap_achieved" );
    level waittill( #"moon_sidequest_big_bang_achieved" );
    level thread zm::set_sidequest_completed( "MOON" );
    
    if ( level.xenon )
    {
        level zm_utility::giveachievement_wrapper( "DLC5_ZOM_BIG_BANG_THEORY", 1 );
    }
}

// Namespace zm_moon_achievement
// Params 0
// Checksum 0xa10f1c60, Offset: 0x570
// Size: 0x94
function achievement_ground_control()
{
    level endon( #"end_game" );
    level flag::wait_till( "teleporter_digger_hacked_before_breached" );
    level flag::wait_till( "hangar_digger_hacked_before_breached" );
    level flag::wait_till( "biodome_digger_hacked_before_breached" );
    
    /#
    #/
    
    level zm_utility::giveachievement_wrapper( "DLC5_ZOM_GROUND_CONTROL", 1 );
}

// Namespace zm_moon_achievement
// Params 0
// Checksum 0x325f264d, Offset: 0x610
// Size: 0x2c
function achievement_one_small_hack()
{
    level endon( #"end_game" );
    self endon( #"disconnect" );
    self waittill( #"successful_hack" );
    
    /#
    #/
}

// Namespace zm_moon_achievement
// Params 0
// Checksum 0x3b2a44d8, Offset: 0x648
// Size: 0x68
function achievement_one_giant_leap()
{
    level endon( #"end_game" );
    self endon( #"disconnect" );
    self waittill( #"one_giant_leap" );
    
    /#
    #/
    
    if ( !( isdefined( level.played_extra_song_a7x ) && level.played_extra_song_a7x ) )
    {
        level thread zm_audio::sndmusicsystem_playstate( "nightmare" );
        level.played_extra_song_a7x = 1;
    }
}

// Namespace zm_moon_achievement
// Params 0
// Checksum 0xd60cb6, Offset: 0x6b8
// Size: 0x15c
function achievement_perks_in_space()
{
    level endon( #"end_game" );
    self endon( #"disconnect" );
    self.perks_in_space_list = [];
    vending_triggers = getentarray( "zombie_vending", "targetname" );
    
    for ( i = 0; i < vending_triggers.size ; i++ )
    {
        self.perks_in_space_purchased_list[ vending_triggers[ i ].script_noteworthy + "_purchased" ] = 0;
    }
    
    while ( true )
    {
        self waittill( #"perk_bought", perk );
        self.perks_in_space_purchased_list[ perk + "_purchased" ] = 1;
        keys = getarraykeys( self.perks_in_space_purchased_list );
        
        for ( i = 0; i < keys.size ; i++ )
        {
            if ( !self.perks_in_space_purchased_list[ keys[ i ] ] )
            {
                break;
            }
        }
        
        if ( i == self.perks_in_space_purchased_list.size )
        {
            /#
            #/
            
            return;
        }
    }
}

// Namespace zm_moon_achievement
// Params 0
// Checksum 0x97b8f5c3, Offset: 0x820
// Size: 0xf6
function achievement_fully_armed()
{
    level endon( #"end_game" );
    self endon( #"disconnect" );
    
    while ( true )
    {
        self waittill( #"pap_taken" );
        
        if ( !self hasperk( "specialty_additionalprimaryweapon" ) )
        {
            continue;
        }
        
        primaries = self getweaponslistprimaries();
        
        if ( !isdefined( primaries ) || primaries.size != 3 )
        {
            continue;
        }
        
        for ( i = 0; i < primaries.size ; i++ )
        {
            if ( !zm_weapons::is_weapon_upgraded( primaries[ i ] ) )
            {
                break;
            }
        }
        
        if ( i == primaries.size )
        {
            /#
            #/
            
            return;
        }
    }
}

