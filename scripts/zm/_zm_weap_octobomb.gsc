#using scripts/codescripts/struct;
#using scripts/shared/ai/systems/debug;
#using scripts/shared/ai/systems/gib;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/ai_shared;
#using scripts/shared/animation_shared;
#using scripts/shared/array_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/laststand_shared;
#using scripts/shared/math_shared;
#using scripts/shared/scene_shared;
#using scripts/shared/system_shared;
#using scripts/shared/util_shared;
#using scripts/shared/vehicle_ai_shared;
#using scripts/zm/_zm_clone;
#using scripts/zm/_zm_laststand;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_weapons;
#using scripts/zm/_zm_zonemgr;

#namespace _zm_weap_octobomb;

// Namespace _zm_weap_octobomb
// Params 0, eflags: 0x2
// Checksum 0x51ace1ea, Offset: 0x628
// Size: 0x3c
function autoexec __init__sytem__()
{
    system::register( "zm_weap_octobomb", &__init__, &__main__, undefined );
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0x4dfb5d0, Offset: 0x670
// Size: 0x13c
function __init__()
{
    clientfield::register( "scriptmover", "octobomb_fx", 1, 2, "int" );
    clientfield::register( "actor", "octobomb_spores_fx", 1, 2, "int" );
    clientfield::register( "actor", "octobomb_tentacle_hit_fx", 1, 1, "int" );
    clientfield::register( "actor", "octobomb_zombie_explode_fx", 8000, 1, "counter" );
    clientfield::register( "toplayer", "octobomb_state", 1, 3, "int" );
    clientfield::register( "missile", "octobomb_spit_fx", 1, 2, "int" );
    
    /#
        level thread octobomb_devgui();
    #/
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0xf33bb175, Offset: 0x7b8
// Size: 0xe0
function __main__()
{
    level.w_octobomb = getweapon( "octobomb" );
    level.w_octobomb_upgraded = getweapon( "octobomb_upgraded" );
    level.mdl_octobomb = "p7_fxanim_zm_zod_octobomb_mod";
    
    if ( !octobomb_exists() )
    {
        return;
    }
    
    level._effect[ "grenade_samantha_steal" ] = "zombie/fx_monkey_lightning_zmb";
    zm_weapons::register_zombie_weapon_callback( level.w_octobomb, &player_give_octobomb );
    zm_weapons::register_zombie_weapon_callback( level.w_octobomb_upgraded, &player_give_octobomb_upgraded );
    level.octobombs = [];
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0x66860b28, Offset: 0x8a0
// Size: 0x24
function player_give_octobomb_upgraded()
{
    self player_give_octobomb( "octobomb_upgraded" );
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0x6bbe70ae, Offset: 0x8d0
// Size: 0xdc
function player_give_octobomb( str_weapon )
{
    if ( !isdefined( str_weapon ) )
    {
        str_weapon = "octobomb";
    }
    
    w_tactical = self zm_utility::get_player_tactical_grenade();
    
    if ( isdefined( w_tactical ) )
    {
        self takeweapon( w_tactical );
    }
    
    w_weapon = getweapon( str_weapon );
    self giveweapon( w_weapon );
    self zm_utility::set_player_tactical_grenade( w_weapon );
    self thread player_handle_octobomb();
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0xbc22068e, Offset: 0x9b8
// Size: 0xf8
function player_handle_octobomb()
{
    self notify( #"starting_octobomb_watch" );
    self endon( #"death" );
    self endon( #"starting_octobomb_watch" );
    attract_dist_custom = level.octobomb_attract_dist_custom;
    
    if ( !isdefined( attract_dist_custom ) )
    {
        attract_dist_custom = 10;
    }
    
    num_attractors = level.num_octobomb_attractors;
    
    if ( !isdefined( num_attractors ) )
    {
        num_attractors = 64;
    }
    
    max_attract_dist = level.octobomb_attract_dist;
    
    if ( !isdefined( max_attract_dist ) )
    {
        max_attract_dist = 1024;
    }
    
    while ( true )
    {
        e_grenade = get_thrown_octobomb();
        
        if ( isdefined( e_grenade ) )
        {
            self thread player_throw_octobomb( e_grenade, num_attractors, max_attract_dist, attract_dist_custom );
        }
    }
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0x1dc08bc5, Offset: 0xab8
// Size: 0xae
function show_briefly( showtime )
{
    self endon( #"show_owner" );
    
    if ( isdefined( self.show_for_time ) )
    {
        self.show_for_time = showtime;
        return;
    }
    
    self.show_for_time = showtime;
    self setvisibletoall();
    
    while ( self.show_for_time > 0 )
    {
        self.show_for_time -= 0.05;
        wait 0.05;
    }
    
    self setvisibletoallexceptteam( level.zombie_team );
    self.show_for_time = undefined;
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0x6eb61a86, Offset: 0xb70
// Size: 0x80
function show_owner_on_attack( owner )
{
    owner endon( #"hide_owner" );
    owner endon( #"show_owner" );
    self endon( #"explode" );
    self endon( #"death" );
    self endon( #"grenade_dud" );
    owner.show_for_time = undefined;
    
    for ( ;; )
    {
        owner waittill( #"weapon_fired" );
        owner thread show_briefly( 0.5 );
    }
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0x3f16585c, Offset: 0xbf8
// Size: 0x22c
function hide_owner( owner )
{
    owner notify( #"hide_owner" );
    owner endon( #"hide_owner" );
    owner setperk( "specialty_immunemms" );
    owner.no_burning_sfx = 1;
    owner notify( #"stop_flame_sounds" );
    owner setvisibletoallexceptteam( level.zombie_team );
    owner.hide_owner = 1;
    
    if ( isdefined( level._effect[ "human_disappears" ] ) )
    {
        playfx( level._effect[ "human_disappears" ], owner.origin );
    }
    
    self thread show_owner_on_attack( owner );
    evt = self util::waittill_any_ex( "explode", "death", "grenade_dud", owner, "hide_owner" );
    println( "<dev string:x28>" + evt );
    owner notify( #"show_owner" );
    owner unsetperk( "specialty_immunemms" );
    
    if ( isdefined( level._effect[ "human_disappears" ] ) )
    {
        playfx( level._effect[ "human_disappears" ], owner.origin );
    }
    
    owner.no_burning_sfx = undefined;
    owner setvisibletoall();
    owner.hide_owner = undefined;
    owner show();
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0xcad41153, Offset: 0xe30
// Size: 0x80
function fakelinkto( linkee )
{
    self notify( #"fakelinkto" );
    self endon( #"fakelinkto" );
    self.backlinked = 1;
    
    while ( isdefined( self ) && isdefined( linkee ) )
    {
        self.origin = linkee.origin;
        self.angles = linkee.angles;
        wait 0.05;
    }
}

// Namespace _zm_weap_octobomb
// Params 2
// Checksum 0xf1b25d27, Offset: 0xeb8
// Size: 0x184
function grenade_planted( grenade, model )
{
    ride_vehicle = undefined;
    grenade.ground_ent = grenade getgroundent();
    
    if ( isdefined( grenade.ground_ent ) )
    {
        if ( isvehicle( grenade.ground_ent ) && !( level.zombie_team === grenade.ground_ent ) )
        {
            ride_vehicle = grenade.ground_ent;
        }
    }
    
    if ( isdefined( ride_vehicle ) )
    {
        if ( isdefined( grenade ) )
        {
            grenade setmovingplatformenabled( 1 );
            grenade.equipment_can_move = 1;
            grenade.isonvehicle = 1;
            grenade.move_parent = ride_vehicle;
            
            if ( isdefined( model ) )
            {
                model setmovingplatformenabled( 1 );
                model linkto( ride_vehicle );
                model.isonvehicle = 1;
                grenade fakelinkto( model );
            }
        }
    }
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0xacd4817c, Offset: 0x1048
// Size: 0x74
function check_octobomb_on_train()
{
    self endon( #"death" );
    
    if ( self zm_zonemgr::entity_in_zone( "zone_train_rail" ) )
    {
        while ( !level.o_zod_train flag::get( "moving" ) )
        {
            wait 0.05;
            continue;
        }
        
        self detonate();
    }
}

// Namespace _zm_weap_octobomb
// Params 4
// Checksum 0xe43c1baf, Offset: 0x10c8
// Size: 0x61c
function player_throw_octobomb( e_grenade, num_attractors, max_attract_dist, attract_dist_custom )
{
    self endon( #"starting_octobomb_watch" );
    e_grenade endon( #"death" );
    
    if ( self laststand::player_is_in_laststand() )
    {
        if ( isdefined( e_grenade.damagearea ) )
        {
            e_grenade.damagearea delete();
        }
        
        e_grenade delete();
        return;
    }
    
    v_angles_clone_model = self.angles + ( 90, 0, 90 );
    v_angles_anim_model = self.angles - ( 0, 90, 0 );
    is_upgraded = e_grenade.weapon == level.w_octobomb_upgraded;
    
    if ( is_upgraded )
    {
        n_cf_val = 2;
    }
    else
    {
        n_cf_val = 1;
    }
    
    e_grenade ghost();
    e_grenade.angles = v_angles_clone_model;
    e_grenade.clone_model = util::spawn_model( e_grenade.model, e_grenade.origin, e_grenade.angles );
    e_grenade.clone_model linkto( e_grenade );
    e_grenade thread octobomb_cleanup();
    e_grenade waittill( #"stationary", v_position, v_normal );
    e_grenade thread check_octobomb_on_train();
    self thread grenade_planted( e_grenade, e_grenade.clone_model );
    e_grenade resetmissiledetonationtime();
    e_grenade is_on_navmesh();
    b_valid_poi = zm_utility::check_point_in_enabled_zone( e_grenade.origin, undefined, undefined );
    
    if ( isdefined( level.check_b_valid_poi ) )
    {
        b_valid_poi = e_grenade [[ level.check_b_valid_poi ]]( b_valid_poi );
    }
    
    if ( b_valid_poi && e_grenade.navmesh_check )
    {
        if ( isdefined( level.octobomb_attack_callback ) && isfunctionptr( level.octobomb_attack_callback ) )
        {
            [[ level.octobomb_attack_callback ]]( e_grenade );
        }
        
        e_grenade move_away_from_edges();
        e_grenade zm_utility::create_zombie_point_of_interest( max_attract_dist, num_attractors, 10000 );
        e_grenade thread zm_utility::create_zombie_point_of_interest_attractor_positions( 4, attract_dist_custom );
        e_grenade thread zm_utility::wait_for_attractor_positions_complete();
        
        if ( !( isdefined( e_grenade.b_special_octobomb ) && e_grenade.b_special_octobomb ) )
        {
            e_grenade.clone_model zm_utility::self_delete();
            e_grenade.angles = v_angles_anim_model;
            e_grenade.anim_model = util::spawn_model( level.mdl_octobomb, e_grenade.origin, e_grenade.angles );
            
            if ( isdefined( e_grenade.isonvehicle ) && e_grenade.isonvehicle )
            {
                e_grenade.anim_model setmovingplatformenabled( 1 );
                e_grenade.anim_model linkto( e_grenade.ground_ent );
                e_grenade.anim_model.isonvehicle = 1;
                e_grenade thread fakelinkto( e_grenade.anim_model );
            }
            
            e_grenade.anim_model clientfield::set( "octobomb_fx", 3 );
            wait 0.05;
            e_grenade.anim_model clientfield::set( "octobomb_fx", n_cf_val );
            e_grenade thread animate_octobomb( is_upgraded );
            e_grenade thread do_octobomb_sound();
        }
        
        e_grenade thread do_tentacle_burst( self, is_upgraded );
        e_grenade thread do_tentacle_grab( self, is_upgraded );
        e_grenade thread sndattackvox();
        e_grenade thread special_attractor_spawn( self, max_attract_dist );
        level.octobombs[ level.octobombs.size ] = e_grenade;
        return;
    }
    
    e_grenade.script_noteworthy = undefined;
    level thread grenade_stolen_by_sam( e_grenade );
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0x215730c8, Offset: 0x16f0
// Size: 0xf4
function is_on_navmesh()
{
    self endon( #"death" );
    
    if ( ispointonnavmesh( self.origin, 60 ) == 1 )
    {
        self.navmesh_check = 1;
        return;
    }
    
    v_valid_point = getclosestpointonnavmesh( self.origin, 100 );
    
    if ( isdefined( v_valid_point ) )
    {
        n_z_correct = 0;
        
        if ( self.origin[ 2 ] > v_valid_point[ 2 ] )
        {
            n_z_correct = self.origin[ 2 ] - v_valid_point[ 2 ];
        }
        
        self.origin = v_valid_point + ( 0, 0, n_z_correct );
        self.navmesh_check = 1;
        return;
    }
    
    self.navmesh_check = 0;
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0x4e4583a9, Offset: 0x17f0
// Size: 0x1b4
function animate_octobomb( is_upgraded )
{
    self endon( #"death" );
    self playsound( "wpn_octobomb_explode" );
    self scene::play( "p7_fxanim_zm_zod_octobomb_start_bundle", self.anim_model );
    self thread scene::play( "p7_fxanim_zm_zod_octobomb_loop_bundle", self.anim_model );
    n_start_anim_length = getanimlength( "p7_fxanim_zm_zod_octobomb_start_anim" );
    n_end_anim_length = getanimlength( "p7_fxanim_zm_zod_octobomb_end_anim" );
    n_life_time = ( self.weapon.fusetime - n_end_anim_length * 1000 - n_start_anim_length * 1000 ) / 1000;
    wait n_life_time * 0.75;
    
    if ( is_upgraded )
    {
        n_fx = 2;
    }
    else
    {
        n_fx = 1;
    }
    
    self thread clientfield::set( "octobomb_spit_fx", n_fx );
    wait n_life_time * 0.25;
    self scene::play( "p7_fxanim_zm_zod_octobomb_end_bundle", self.anim_model );
    self playsound( "wpn_octobomb_end" );
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0xa4b302b0, Offset: 0x19b0
// Size: 0x1da
function move_away_from_edges()
{
    v_orig = self.origin;
    n_angles = self.angles;
    n_z_correct = 0;
    queryresult = positionquery_source_navigation( self.origin, 0, 200, 100, 2, 20 );
    
    if ( queryresult.data.size )
    {
        foreach ( point in queryresult.data )
        {
            if ( bullettracepassed( point.origin + ( 0, 0, 20 ), v_orig + ( 0, 0, 20 ), 0, self, undefined, 0, 0 ) )
            {
                if ( self.origin[ 2 ] > queryresult.origin[ 2 ] )
                {
                    n_z_correct = self.origin[ 2 ] - queryresult.origin[ 2 ];
                }
                
                self.origin = point.origin + ( 0, 0, n_z_correct );
                self.angles = n_angles;
                break;
            }
        }
    }
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0x2b271fdb, Offset: 0x1b98
// Size: 0x2fc
function grenade_stolen_by_sam( e_grenade )
{
    if ( !isdefined( e_grenade ) )
    {
        return;
    }
    
    direction = e_grenade.origin;
    direction = ( direction[ 1 ], direction[ 0 ], 0 );
    
    if ( direction[ 0 ] > 0 && ( direction[ 1 ] < 0 || direction[ 1 ] > 0 ) )
    {
        direction = ( direction[ 0 ], direction[ 1 ] * -1, 0 );
    }
    else if ( direction[ 0 ] < 0 )
    {
        direction = ( direction[ 0 ] * -1, direction[ 1 ], 0 );
    }
    
    if ( !( isdefined( e_grenade.sndnosamlaugh ) && e_grenade.sndnosamlaugh ) )
    {
        players = getplayers();
        
        for ( i = 0; i < players.size ; i++ )
        {
            if ( isalive( players[ i ] ) )
            {
                players[ i ] playlocalsound( level.zmb_laugh_alias );
            }
        }
    }
    
    playfxontag( level._effect[ "grenade_samantha_steal" ], e_grenade, "tag_origin" );
    e_grenade.clone_model unlink();
    e_grenade.clone_model movez( 60, 1, 0.25, 0.25 );
    e_grenade.clone_model vibrate( direction, 1.5, 2.5, 1 );
    e_grenade.clone_model waittill( #"movedone" );
    
    if ( isdefined( self.damagearea ) )
    {
        self.damagearea delete();
    }
    
    e_grenade.clone_model delete();
    
    if ( isdefined( e_grenade ) )
    {
        if ( isdefined( e_grenade.damagearea ) )
        {
            e_grenade.damagearea delete();
        }
        
        e_grenade delete();
    }
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0xd9072a32, Offset: 0x1ea0
// Size: 0xcc
function octobomb_cleanup()
{
    while ( true )
    {
        if ( !isdefined( self ) )
        {
            if ( isdefined( self.clone_model ) )
            {
                self.clone_model delete();
            }
            
            if ( isdefined( self.anim_model ) )
            {
                self.anim_model delete();
            }
            
            if ( isdefined( self.dud ) && isdefined( self ) && self.dud )
            {
                wait 6;
            }
            
            if ( isdefined( self.simulacrum ) )
            {
                self.simulacrum delete();
            }
            
            zm_utility::self_delete();
            return;
        }
        
        wait 0.05;
    }
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0x1469fe2f, Offset: 0x1f78
// Size: 0xc4
function do_octobomb_sound()
{
    self waittill( #"explode", position );
    level notify( #"grenade_exploded", position, 100, 5000, 450 );
    octobomb_index = -1;
    
    for ( i = 0; i < level.octobombs.size ; i++ )
    {
        if ( !isdefined( level.octobombs[ i ] ) )
        {
            octobomb_index = i;
            break;
        }
    }
    
    if ( octobomb_index >= 0 )
    {
        arrayremoveindex( level.octobombs, octobomb_index );
    }
}

// Namespace _zm_weap_octobomb
// Params 2
// Checksum 0x321c0a6c, Offset: 0x2048
// Size: 0x288
function do_tentacle_burst( e_player, is_upgraded )
{
    self endon( #"explode" );
    n_time_started = gettime() / 1000;
    
    while ( true )
    {
        n_time_current = gettime() / 1000;
        n_time_elapsed = n_time_current - n_time_started;
        
        if ( n_time_elapsed < 1 )
        {
            n_radius = lerpfloat( 0, 100, n_time_elapsed / 1 );
        }
        else if ( n_time_elapsed == 1 )
        {
            n_radius = 100;
        }
        
        a_ai_potential_targets = zombie_utility::get_zombie_array();
        
        if ( isdefined( level.octobomb_targets ) )
        {
            a_ai_potential_targets = [[ level.octobomb_targets ]]( a_ai_potential_targets );
        }
        
        a_ai_targets = arraysortclosest( a_ai_potential_targets, self.origin, a_ai_potential_targets.size, 0, 100 );
        
        foreach ( ai_target in a_ai_targets )
        {
            if ( isalive( ai_target ) )
            {
                ai_target thread clientfield::set( "octobomb_tentacle_hit_fx", 1 );
                
                if ( ai_target.b_octobomb_infected !== 1 )
                {
                    self notify( #"sndkillvox" );
                    ai_target playsound( "wpn_octobomb_zombie_imp" );
                    ai_target thread zombie_explodes();
                    ai_target thread zombie_spore_infect( e_player, self, is_upgraded );
                }
                
                wait 0.05;
                ai_target thread clientfield::set( "octobomb_tentacle_hit_fx", 0 );
            }
        }
        
        wait 0.5;
    }
}

// Namespace _zm_weap_octobomb
// Params 3
// Checksum 0x605d82e8, Offset: 0x22d8
// Size: 0x14c
function zombie_spore_infect( e_player, e_grenade, is_upgraded )
{
    self endon( #"death" );
    self.octobomb_infected = 1;
    n_infection_time = 0;
    n_infection_half_time = 3.5;
    n_burst_damage = 3;
    
    if ( is_upgraded )
    {
        n_damage = 1200;
        n_spore_val = 2;
    }
    else
    {
        n_damage = 600;
        n_spore_val = 1;
    }
    
    self clientfield::set( "octobomb_spores_fx", n_spore_val );
    
    while ( n_infection_time < 7 )
    {
        wait 0.5;
        n_infection_time++;
        self dodamage( n_damage * n_burst_damage, self.origin, e_player, e_grenade );
        n_burst_damage = 1;
    }
    
    self.octobomb_infected = 0;
    self clientfield::set( "octobomb_spores_fx", 0 );
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0xd42bfe1c, Offset: 0x2430
// Size: 0x64
function zombie_explodes()
{
    self waittill( #"death" );
    
    if ( isdefined( self ) )
    {
        if ( self.octobomb_infected == 1 )
        {
            self clientfield::increment( "octobomb_zombie_explode_fx", 1 );
            self octo_gib();
        }
    }
}

// Namespace _zm_weap_octobomb
// Params 2
// Checksum 0x8c57e552, Offset: 0x24a0
// Size: 0x380
function do_tentacle_grab( e_player, is_upgraded )
{
    self endon( #"death" );
    b_fast_grab = 1;
    n_grabs = 0;
    
    if ( is_upgraded )
    {
        n_spore_val = 2;
        n_time_min = 0.5;
        n_time_max = 1.5;
    }
    else
    {
        n_spore_val = 1;
        n_time_min = 1.5;
        n_time_max = 2.5;
    }
    
    while ( true )
    {
        if ( b_fast_grab == 0 )
        {
            n_wait_grab = randomfloatrange( n_time_min, n_time_max );
        }
        else
        {
            n_wait_grab = 0.1;
        }
        
        wait n_wait_grab;
        a_ai_potential_targets = zombie_utility::get_zombie_array();
        
        if ( isdefined( level.octobomb_targets ) )
        {
            a_ai_potential_targets = [[ level.octobomb_targets ]]( a_ai_potential_targets );
        }
        
        a_ai_targets = arraysort( a_ai_potential_targets, self.origin, 1, a_ai_potential_targets.size, 112 );
        n_random_x = randomfloatrange( -5, 5 );
        n_random_y = randomfloatrange( -5, 5 );
        
        if ( a_ai_targets.size > 0 )
        {
            ai_target = array::random( a_ai_targets );
            
            if ( isalive( ai_target ) )
            {
                ai_target clientfield::set( "octobomb_spores_fx", n_spore_val );
                self.octobomb_infected = 1;
                self notify( #"sndkillvox" );
                ai_target playsound( "wpn_octobomb_zombie_imp" );
                ai_target octo_gib();
                ai_target dodamage( ai_target.health, ai_target.origin, e_player, self );
                ai_target startragdoll();
                ai_target launchragdoll( 105 * vectornormalize( ai_target.origin - self.origin + ( n_random_x, n_random_y, 200 ) ) );
            }
            
            if ( randomint( 6 ) > n_grabs + 3 )
            {
                b_fast_grab = 1;
                n_grabs++;
            }
            else
            {
                b_fast_grab = 0;
                n_grabs = 0;
            }
            
            continue;
        }
        
        b_fast_grab = 1;
    }
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0xd03fc6fb, Offset: 0x2828
// Size: 0x74
function octo_gib()
{
    gibserverutils::gibhead( self );
    
    if ( math::cointoss() )
    {
        gibserverutils::gibleftarm( self );
    }
    else
    {
        gibserverutils::gibrightarm( self );
    }
    
    gibserverutils::giblegs( self );
}

// Namespace _zm_weap_octobomb
// Params 2
// Checksum 0xcd367f35, Offset: 0x28a8
// Size: 0x350
function special_attractor_spawn( e_player, max_attract_dist )
{
    self endon( #"death" );
    self makesentient();
    self setmaxhealth( 1000 );
    self setnormalhealth( 1 );
    self thread parasite_attractor_grab( self );
    
    while ( true )
    {
        a_ai_zombies = array::get_all_closest( self.origin, getaiteamarray( level.zombie_team ), undefined, undefined, max_attract_dist * 1.5 );
        
        foreach ( ai_zombie in a_ai_zombies )
        {
            if ( isvehicle( ai_zombie ) )
            {
                if ( ai_zombie.archetype == "parasite" && ai_zombie.ignoreme !== 1 && ai_zombie vehicle_ai::get_current_state() != "scripted" )
                {
                    if ( !isdefined( self.v_parasite_attractor_center ) )
                    {
                        self parasite_attractor_init();
                    }
                    
                    ai_zombie thread parasite_variables( self );
                    ai_zombie thread parasite_attractor( self );
                    continue;
                }
                
                if ( ai_zombie.archetype == "raps" && ai_zombie.b_attracted_to_octobomb !== 1 )
                {
                    ai_zombie thread vehicle_attractor( self );
                }
                
                if ( ai_zombie.archetype == "raps" && ai_zombie.octobomb_infected !== 1 && distance( self.origin, ai_zombie.origin ) <= 100 )
                {
                    ai_zombie thread vehicle_attractor_damage( e_player );
                }
                
                if ( ai_zombie.archetype == "spider" && ai_zombie.octobomb_infected !== 1 && distance( self.origin, ai_zombie.origin ) <= 100 )
                {
                    ai_zombie thread vehicle_attractor_damage( e_player );
                }
            }
        }
        
        wait 0.05;
    }
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0x4ac33718, Offset: 0x2c00
// Size: 0x60
function vehicle_attractor( e_grenade )
{
    self endon( #"death" );
    self.favoriteenemy = e_grenade;
    self.b_attracted_to_octobomb = 1;
    self.ignoreme = 1;
    e_grenade waittill( #"death" );
    self.b_attracted_to_octobomb = 0;
    self.ignoreme = 0;
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0xbf318b1a, Offset: 0x2c68
// Size: 0x7c
function vehicle_attractor_damage( e_player )
{
    self endon( #"death" );
    self.octobomb_infected = 1;
    n_infection_time = 0;
    
    while ( n_infection_time < 7 )
    {
        self dodamage( 600, self.origin, e_player );
        wait 0.5;
    }
    
    self.octobomb_infected = 0;
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0x66612a2e, Offset: 0x2cf0
// Size: 0x22e
function parasite_attractor_init()
{
    self.v_parasite_attractor_center = self.origin + ( 0, 0, 80 );
    self.a_v_parasite_attractors = [];
    
    if ( !isdefined( self.a_v_parasite_attractors ) )
    {
        self.a_v_parasite_attractors = [];
    }
    else if ( !isarray( self.a_v_parasite_attractors ) )
    {
        self.a_v_parasite_attractors = array( self.a_v_parasite_attractors );
    }
    
    self.a_v_parasite_attractors[ self.a_v_parasite_attractors.size ] = self.v_parasite_attractor_center + ( 80, 0, 0 );
    
    if ( !isdefined( self.a_v_parasite_attractors ) )
    {
        self.a_v_parasite_attractors = [];
    }
    else if ( !isarray( self.a_v_parasite_attractors ) )
    {
        self.a_v_parasite_attractors = array( self.a_v_parasite_attractors );
    }
    
    self.a_v_parasite_attractors[ self.a_v_parasite_attractors.size ] = self.v_parasite_attractor_center + ( 0, 80, 0 );
    
    if ( !isdefined( self.a_v_parasite_attractors ) )
    {
        self.a_v_parasite_attractors = [];
    }
    else if ( !isarray( self.a_v_parasite_attractors ) )
    {
        self.a_v_parasite_attractors = array( self.a_v_parasite_attractors );
    }
    
    self.a_v_parasite_attractors[ self.a_v_parasite_attractors.size ] = self.v_parasite_attractor_center + ( -80, 0, 0 );
    
    if ( !isdefined( self.a_v_parasite_attractors ) )
    {
        self.a_v_parasite_attractors = [];
    }
    else if ( !isarray( self.a_v_parasite_attractors ) )
    {
        self.a_v_parasite_attractors = array( self.a_v_parasite_attractors );
    }
    
    self.a_v_parasite_attractors[ self.a_v_parasite_attractors.size ] = self.v_parasite_attractor_center + ( 0, -80, 0 );
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0xd738a365, Offset: 0x2f28
// Size: 0xf4
function parasite_variables( e_grenade )
{
    self endon( #"death" );
    self.favoriteenemy = e_grenade;
    self vehicle_ai::set_state( "scripted" );
    self.b_parasite_attracted = 1;
    self.ignoreme = 1;
    self.parasiteenemy = e_grenade;
    self ai::set_ignoreall( 1 );
    e_grenade waittill( #"death" );
    self resumespeed();
    self vehicle_ai::set_state( "combat" );
    self.b_parasite_attracted = 0;
    self.ignoreme = 0;
    self ai::set_ignoreall( 0 );
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0xa3e24b1f, Offset: 0x3028
// Size: 0x1d0
function parasite_attractor( e_grenade )
{
    self endon( #"death" );
    e_grenade endon( #"death" );
    f_speed = 10;
    
    if ( distance( e_grenade.v_parasite_attractor_center, self.origin ) > 80 )
    {
        self setspeed( 10 );
        self setvehgoalpos( e_grenade.v_parasite_attractor_center, 0, 1 );
        
        while ( distance( e_grenade.v_parasite_attractor_center, self.origin ) > 80 )
        {
            wait 0.05;
        }
        
        self clearvehgoalpos();
    }
    
    i = 0;
    
    while ( self.b_parasite_attracted )
    {
        if ( i == 4 )
        {
            i = 0;
        }
        
        self setvehgoalpos( e_grenade.a_v_parasite_attractors[ i ], 0, 1 );
        
        while ( distance( e_grenade.a_v_parasite_attractors[ i ], self.origin ) > 10 )
        {
            if ( !self.b_parasite_attracted )
            {
                break;
            }
            
            wait 0.05;
        }
        
        self clearvehgoalpos();
        i++;
        wait 0.05;
    }
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0x61a6c658, Offset: 0x3200
// Size: 0x260
function parasite_attractor_grab( e_grenade )
{
    e_grenade endon( #"death" );
    self endon( #"death" );
    b_fast_grab = 1;
    n_grabs = 0;
    
    while ( true )
    {
        if ( b_fast_grab == 0 )
        {
            n_wait_grab = randomfloatrange( 1.5, 2.5 );
        }
        else
        {
            n_wait_grab = 0.1;
        }
        
        wait n_wait_grab;
        a_ai_parasites = array::get_all_closest( self.origin, getaiteamarray( level.zombie_team ), undefined, undefined, 150 );
        
        for ( i = 0; i < a_ai_parasites.size ; i++ )
        {
            if ( isdefined( a_ai_parasites[ i ] ) && a_ai_parasites[ i ].archetype != "parasite" )
            {
                arrayremovevalue( a_ai_parasites, a_ai_parasites[ i ] );
                i = 0;
                continue;
            }
        }
        
        if ( a_ai_parasites.size > 0 )
        {
            ai_parasite = array::random( a_ai_parasites );
            v_fling = vectornormalize( ai_parasite.origin - e_grenade.origin );
            ai_parasite dodamage( ai_parasite.maxhealth, self.origin );
            
            if ( randomint( 6 ) > n_grabs + 3 )
            {
                b_fast_grab = 1;
                n_grabs++;
            }
            else
            {
                b_fast_grab = 0;
                n_grabs = 0;
            }
            
            continue;
        }
        
        b_fast_grab = 1;
    }
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0x1a76b328, Offset: 0x3468
// Size: 0x58
function sndattackvox()
{
    self endon( #"explode" );
    
    while ( true )
    {
        self waittill( #"sndkillvox" );
        wait 0.25;
        self playsound( "wpn_octobomb_attack_vox" );
        wait 2.5;
    }
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0xa00e9117, Offset: 0x34c8
// Size: 0xb8
function get_thrown_octobomb()
{
    self endon( #"death" );
    self endon( #"starting_octobomb_watch" );
    
    while ( true )
    {
        self waittill( #"grenade_fire", e_grenade, w_weapon );
        
        if ( w_weapon == level.w_octobomb || w_weapon == level.w_octobomb_upgraded )
        {
            e_grenade.use_grenade_special_long_bookmark = 1;
            e_grenade.grenade_multiattack_bookmark_count = 1;
            e_grenade.weapon = w_weapon;
            return e_grenade;
        }
        
        wait 0.05;
    }
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0x188abbd, Offset: 0x3588
// Size: 0x1a, Type: bool
function octobomb_exists()
{
    return zm_weapons::is_weapon_included( level.w_octobomb );
}

// Namespace _zm_weap_octobomb
// Params 0
// Checksum 0xfaa6a6a7, Offset: 0x35b0
// Size: 0x9c
function octobomb_devgui()
{
    for ( i = 0; i < 4 ; i++ )
    {
        level thread setup_devgui_func( "ZM/Weapons/Offhand/Octobomb/Give" + i, "zod_give_octobomb", i, &devgui_octobomb_give );
    }
    
    level thread setup_devgui_func( "ZM/Weapons/Offhand/Octobomb/Give to All", "zod_give_octobomb", 4, &devgui_octobomb_give );
}

// Namespace _zm_weap_octobomb
// Params 5, eflags: 0x4
// Checksum 0xe4fd05db, Offset: 0x3658
// Size: 0x120
function private setup_devgui_func( str_devgui_path, str_dvar, n_value, func, n_base_value )
{
    if ( !isdefined( n_base_value ) )
    {
        n_base_value = -1;
    }
    
    setdvar( str_dvar, n_base_value );
    adddebugcommand( "devgui_cmd \"" + str_devgui_path + "\" \"" + str_dvar + " " + n_value + "\"\n" );
    
    while ( true )
    {
        n_dvar = getdvarint( str_dvar );
        
        if ( n_dvar > n_base_value )
        {
            [[ func ]]( n_dvar );
            setdvar( str_dvar, n_base_value );
        }
        
        util::wait_network_frame();
    }
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0x35598070, Offset: 0x3780
// Size: 0xf2
function devgui_octobomb_give( n_player_index )
{
    players = getplayers();
    player = players[ n_player_index ];
    
    if ( isdefined( player ) )
    {
        octobomb_give( player );
        return;
    }
    
    if ( n_player_index === 4 )
    {
        foreach ( player in players )
        {
            octobomb_give( player );
        }
    }
}

// Namespace _zm_weap_octobomb
// Params 1
// Checksum 0x6b955389, Offset: 0x3880
// Size: 0x8c
function octobomb_give( player )
{
    player clientfield::set_to_player( "octobomb_state", 3 );
    weapon = getweapon( "octobomb" );
    player takeweapon( weapon );
    player zm_weapons::weapon_give( weapon, undefined, undefined, 1 );
}

