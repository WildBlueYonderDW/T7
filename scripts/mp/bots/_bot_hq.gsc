#using scripts/mp/bots/_bot;
#using scripts/mp/bots/_bot_combat;
#using scripts/shared/array_shared;
#using scripts/shared/util_shared;

#namespace bot_hq;

// Namespace bot_hq
// Params 0
// Checksum 0xb2405ae5, Offset: 0x140
// Size: 0x1e4
function hq_think()
{
    time = gettime();
    
    if ( time < self.bot.update_objective )
    {
        return;
    }
    
    self.bot.update_objective = time + randomintrange( 500, 1500 );
    
    if ( should_patrol_hq() )
    {
        self patrol_hq();
    }
    else if ( !has_hq_goal() )
    {
        self move_to_hq();
    }
    
    if ( self is_capturing_hq() )
    {
        self capture_hq();
    }
    
    hq_tactical_insertion();
    hq_grenade();
    
    if ( !is_capturing_hq() && !self atgoal( "hq_patrol" ) )
    {
        mine = getnearestnode( self.origin );
        point = hq_nearest_point();
        
        if ( isdefined( mine ) && bot::navmesh_points_visible( mine.origin, point ) )
        {
            self lookat( level.radio.baseorigin + ( 0, 0, 30 ) );
        }
    }
}

// Namespace bot_hq
// Params 0
// Checksum 0x1f7b0318, Offset: 0x330
// Size: 0xe2, Type: bool
function has_hq_goal()
{
    origin = self getgoal( "hq_radio" );
    
    if ( isdefined( origin ) )
    {
        foreach ( point in level.radio.points )
        {
            if ( distancesquared( origin, point ) < 4096 )
            {
                return true;
            }
        }
    }
    
    return false;
}

// Namespace bot_hq
// Params 0
// Checksum 0x1f469e7e, Offset: 0x420
// Size: 0x22
function is_capturing_hq()
{
    return self atgoal( "hq_radio" );
}

// Namespace bot_hq
// Params 0
// Checksum 0x36f66449, Offset: 0x450
// Size: 0x6e, Type: bool
function should_patrol_hq()
{
    if ( level.radio.gameobject.ownerteam == "neutral" )
    {
        return false;
    }
    
    if ( level.radio.gameobject.ownerteam != self.team )
    {
        return false;
    }
    
    if ( hq_is_contested() )
    {
        return false;
    }
    
    return true;
}

// Namespace bot_hq
// Params 0
// Checksum 0x738a72e7, Offset: 0x4c8
// Size: 0x638
function patrol_hq()
{
    self cancelgoal( "hq_radio" );
    
    if ( self atgoal( "hq_patrol" ) )
    {
        node = getnearestnode( self.origin );
        
        if ( isdefined( node ) && node.type == "Path" )
        {
            self setstance( "crouch" );
        }
        else
        {
            self setstance( "stand" );
        }
        
        if ( gettime() > self.bot.update_lookat )
        {
            origin = self get_look_at();
            z = 20;
            
            if ( distancesquared( origin, self.origin ) > 262144 )
            {
                z = randomintrange( 16, 60 );
            }
            
            self lookat( origin + ( 0, 0, z ) );
            
            if ( distancesquared( origin, self.origin ) > 65536 )
            {
                dir = vectornormalize( self.origin - origin );
                dir = vectorscale( dir, 256 );
                origin += dir;
            }
            
            self bot_combat::combat_throw_proximity( origin );
            self.bot.update_lookat = gettime() + randomintrange( 1500, 3000 );
        }
        
        goal = self getgoal( "hq_patrol" );
        nearest = hq_nearest_point();
        mine = getnearestnode( goal );
        
        if ( isdefined( mine ) && !bot::navmesh_points_visible( mine.origin, nearest ) )
        {
            self clearlookat();
            self cancelgoal( "hq_patrol" );
        }
        
        if ( gettime() > self.bot.update_objective_patrol )
        {
            self clearlookat();
            self cancelgoal( "hq_patrol" );
        }
        
        return;
    }
    
    nearest = hq_nearest_point();
    
    if ( self hasgoal( "hq_patrol" ) )
    {
        goal = self getgoal( "hq_patrol" );
        
        if ( distancesquared( self.origin, goal ) < 65536 )
        {
            origin = self get_look_at();
            self lookat( origin );
        }
        
        if ( distancesquared( self.origin, goal ) < 16384 )
        {
            self.bot.update_objective_patrol = gettime() + randomintrange( 3000, 6000 );
        }
        
        mine = getnearestnode( goal );
        
        if ( isdefined( mine ) && !bot::navmesh_points_visible( mine.origin, nearest ) )
        {
            self clearlookat();
            self cancelgoal( "hq_patrol" );
        }
        
        return;
    }
    
    points = util::positionquery_pointarray( nearest, 0, 512, 70, 64 );
    points = navpointsightfilter( points, nearest );
    assert( points.size );
    
    for ( i = randomint( points.size ); i < points.size ; i++ )
    {
        if ( self bot::friend_goal_in_radius( "hq_radio", points[ i ], 128 ) == 0 )
        {
            if ( self bot::friend_goal_in_radius( "hq_patrol", points[ i ], 256 ) == 0 )
            {
                self addgoal( points[ i ], 24, 3, "hq_patrol" );
                return;
            }
        }
    }
}

// Namespace bot_hq
// Params 0
// Checksum 0x47c2e6cb, Offset: 0xb08
// Size: 0x214
function move_to_hq()
{
    self clearlookat();
    self cancelgoal( "hq_radio" );
    self cancelgoal( "hq_patrol" );
    
    if ( self getstance() == "prone" )
    {
        self setstance( "crouch" );
        wait 0.25;
    }
    
    if ( self getstance() == "crouch" )
    {
        self setstance( "stand" );
        wait 0.25;
    }
    
    points = array::randomize( level.radio.points );
    
    foreach ( point in points )
    {
        if ( self bot::friend_goal_in_radius( "hq_radio", point, 64 ) == 0 )
        {
            self addgoal( point, 24, 3, "hq_radio" );
            return;
        }
    }
    
    self addgoal( array::random( points ), 24, 3, "hq_radio" );
}

// Namespace bot_hq
// Params 0
// Checksum 0x33777d41, Offset: 0xd28
// Size: 0x232
function get_look_at()
{
    enemy = self bot::get_closest_enemy( self.origin, 1 );
    
    if ( isdefined( enemy ) )
    {
        node = getvisiblenode( self.origin, enemy.origin );
        
        if ( isdefined( node ) && distancesquared( self.origin, node.origin ) > 16384 )
        {
            return node.origin;
        }
    }
    
    enemies = self bot::get_enemies( 0 );
    
    if ( enemies.size )
    {
        enemy = array::random( enemies );
    }
    
    if ( isdefined( enemy ) )
    {
        node = getvisiblenode( self.origin, enemy.origin );
        
        if ( isdefined( node ) && distancesquared( self.origin, node.origin ) > 16384 )
        {
            return node.origin;
        }
    }
    
    spawn = array::random( level.spawnpoints );
    node = getvisiblenode( self.origin, spawn.origin );
    
    if ( isdefined( node ) && distancesquared( self.origin, node.origin ) > 16384 )
    {
        return node.origin;
    }
    
    return level.radio.baseorigin;
}

// Namespace bot_hq
// Params 0
// Checksum 0xc77fad24, Offset: 0xf68
// Size: 0x1d4
function capture_hq()
{
    self addgoal( self.origin, 24, 3, "hq_radio" );
    self setstance( "crouch" );
    
    if ( gettime() > self.bot.update_lookat )
    {
        origin = self get_look_at();
        z = 20;
        
        if ( distancesquared( origin, self.origin ) > 262144 )
        {
            z = randomintrange( 16, 60 );
        }
        
        self lookat( origin + ( 0, 0, z ) );
        
        if ( distancesquared( origin, self.origin ) > 65536 )
        {
            dir = vectornormalize( self.origin - origin );
            dir = vectorscale( dir, 256 );
            origin += dir;
        }
        
        self bot_combat::combat_throw_proximity( origin );
        self.bot.update_lookat = gettime() + randomintrange( 1500, 3000 );
    }
}

// Namespace bot_hq
// Params 1
// Checksum 0xe0e45d34, Offset: 0x1148
// Size: 0xb6, Type: bool
function any_other_team_touching( skip_team )
{
    foreach ( team in level.teams )
    {
        if ( team == skip_team )
        {
            continue;
        }
        
        if ( level.radio.gameobject.numtouching[ team ] )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace bot_hq
// Params 1
// Checksum 0x1546a980, Offset: 0x1208
// Size: 0xa8, Type: bool
function is_hq_contested( skip_team )
{
    if ( any_other_team_touching( skip_team ) )
    {
        return true;
    }
    
    enemy = self bot::get_closest_enemy( level.radio.baseorigin, 1 );
    
    if ( isdefined( enemy ) && distancesquared( enemy.origin, level.radio.baseorigin ) < 262144 )
    {
        return true;
    }
    
    return false;
}

// Namespace bot_hq
// Params 0
// Checksum 0x7389c65c, Offset: 0x12b8
// Size: 0x214
function hq_grenade()
{
    enemies = bot::get_enemies();
    
    if ( !enemies.size )
    {
        return;
    }
    
    if ( self atgoal( "hq_patrol" ) || self atgoal( "hq_radio" ) )
    {
        if ( self getweaponammostock( getweapon( "proximity_grenade" ) ) > 0 )
        {
            origin = get_look_at();
            
            if ( self bot_combat::combat_throw_proximity( origin ) )
            {
                return;
            }
        }
    }
    
    if ( !is_hq_contested( self.team ) )
    {
        self bot_combat::combat_throw_smoke( level.radio.baseorigin );
        return;
    }
    
    enemy = self bot::get_closest_enemy( level.radio.baseorigin, 0 );
    
    if ( isdefined( enemy ) )
    {
        origin = enemy.origin;
    }
    else
    {
        origin = level.radio.baseorigin;
    }
    
    dir = vectornormalize( self.origin - origin );
    dir = ( 0, dir[ 1 ], 0 );
    origin += vectorscale( dir, 128 );
    
    if ( !self bot_combat::combat_throw_lethal( origin ) )
    {
        self bot_combat::combat_throw_tactical( origin );
    }
}

// Namespace bot_hq
// Params 0
// Checksum 0x686161e, Offset: 0x14d8
// Size: 0x184
function hq_tactical_insertion()
{
    if ( !self hasweapon( getweapon( "tactical_insertion" ) ) )
    {
        return;
    }
    
    dist = self getlookaheaddist();
    dir = self getlookaheaddir();
    
    if ( !isdefined( dist ) || !isdefined( dir ) )
    {
        return;
    }
    
    point = hq_nearest_point();
    mine = getnearestnode( self.origin );
    
    if ( isdefined( mine ) && !bot::navmesh_points_visible( mine.origin, point ) )
    {
        origin = self.origin + vectorscale( dir, dist );
        next = getnearestnode( origin );
        
        if ( isdefined( next ) && bot::navmesh_points_visible( next.origin, point ) )
        {
            bot_combat::combat_tactical_insertion( self.origin );
        }
    }
}

// Namespace bot_hq
// Params 0
// Checksum 0xe24f241, Offset: 0x1668
// Size: 0x22
function hq_nearest_point()
{
    return array::random( level.radio.points );
}

// Namespace bot_hq
// Params 0
// Checksum 0xa3c46d17, Offset: 0x1698
// Size: 0x8e, Type: bool
function hq_is_contested()
{
    enemy = self bot::get_closest_enemy( level.radio.baseorigin, 0 );
    return isdefined( enemy ) && distancesquared( enemy.origin, level.radio.baseorigin ) < level.radio.node_radius * level.radio.node_radius;
}

