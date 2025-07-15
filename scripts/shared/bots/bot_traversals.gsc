#using scripts/shared/array_shared;
#using scripts/shared/bots/_bot;
#using scripts/shared/bots/bot_buttons;
#using scripts/shared/callbacks_shared;
#using scripts/shared/math_shared;
#using scripts/shared/system_shared;
#using scripts/shared/util_shared;
#using scripts/shared/weapons/_weapons;
#using scripts/shared/weapons_shared;

#namespace bot;

// Namespace bot
// Params 2
// Checksum 0xc0fa4637, Offset: 0x1e8
// Size: 0x2e4
function callback_botentereduseredge( startnode, endnode )
{
    zdelta = endnode.origin[ 2 ] - startnode.origin[ 2 ];
    xydist = distance2d( startnode.origin, endnode.origin );
    standingviewheight = getdvarfloat( "player_standingViewHeight", 0 );
    swimwaterheight = standingviewheight * getdvarfloat( "player_swimHeightRatio", 0 );
    startwaterheight = getwaterheight( startnode.origin );
    startinwater = startwaterheight != 0 && startwaterheight > startnode.origin[ 2 ] + swimwaterheight;
    endwaterheight = getwaterheight( endnode.origin );
    endinwater = endwaterheight != 0 && endwaterheight > endnode.origin[ 2 ] + swimwaterheight;
    
    if ( iswallrunnode( endnode ) )
    {
        self thread wallrun_traversal( startnode, endnode );
        return;
    }
    
    if ( startinwater && !endinwater )
    {
        self thread leave_water_traversal( startnode, endnode );
        return;
    }
    
    if ( startinwater && endinwater )
    {
        self thread swim_traversal( startnode, endnode );
        return;
    }
    
    if ( zdelta >= 0 )
    {
        self thread jump_up_traversal( startnode, endnode );
        return;
    }
    
    if ( zdelta < 0 )
    {
        self thread jump_down_traversal( startnode, endnode );
        return;
    }
    
    self botreleasemanualcontrol();
    println( "<dev string:x28>", self.name, "<dev string:x2d>" );
}

// Namespace bot
// Params 0
// Checksum 0x68a36fc9, Offset: 0x4d8
// Size: 0x7a, Type: bool
function traversing()
{
    return !self isonground() || self iswallrunning() || self isdoublejumping() || self ismantling() || self issliding();
}

// Namespace bot
// Params 2
// Checksum 0x78d7d076, Offset: 0x560
// Size: 0xd0
function leave_water_traversal( startnode, endnode )
{
    self endon( #"death" );
    self endon( #"traversal_end" );
    level endon( #"game_ended" );
    self thread watch_traversal_end();
    self botsetmoveanglefrompoint( endnode.origin );
    
    while ( self isplayerunderwater() )
    {
        self press_swim_up();
        wait 0.05;
    }
    
    while ( true )
    {
        self press_doublejump_button();
        wait 0.05;
    }
}

// Namespace bot
// Params 2
// Checksum 0x402f9fdf, Offset: 0x638
// Size: 0x7c
function swim_traversal( startnode, endnode )
{
    self endon( #"death" );
    level endon( #"game_ended" );
    self endon( #"traversal_end" );
    self botsetmoveanglefrompoint( endnode.origin );
    wait 0.5;
    self traversal_end();
}

// Namespace bot
// Params 2
// Checksum 0x9934ed08, Offset: 0x6c0
// Size: 0x2f4
function jump_up_traversal( startnode, endnode )
{
    self endon( #"death" );
    level endon( #"game_ended" );
    self endon( #"traversal_end" );
    self thread watch_traversal_end();
    ledgetop = checknavmeshdirection( endnode.origin, self.origin - endnode.origin, 128, 1 );
    height = ledgetop[ 2 ] - self.origin[ 2 ];
    
    if ( height <= 72 )
    {
        self thread jump_to( ledgetop );
        return;
    }
    
    /#
    #/
    
    dist = distance2d( self.origin, ledgetop );
    ledgebottom = checknavmeshdirection( self.origin, ledgetop - self.origin, dist + 15, 1 );
    bottomdist = distance2d( self.origin, ledgebottom );
    
    if ( bottomdist <= dist )
    {
        self thread jump_to( ledgetop );
        return;
    }
    
    dist -= 15;
    height -= 72;
    t = height / 80;
    speed2d = self bot_speed2d();
    speed = self getplayerspeed();
    movedist = t * speed2d;
    
    if ( !movedist || dist > movedist )
    {
        self thread jump_to( ledgetop );
        return;
    }
    
    self botsetmovemagnitude( dist / movedist );
    wait 0.05;
    self thread jump_to( ledgetop );
    wait 0.05;
    
    while ( self.origin[ 2 ] + 72 < ledgetop[ 2 ] )
    {
        wait 0.05;
    }
    
    self botsetmovemagnitude( 1 );
}

// Namespace bot
// Params 2
// Checksum 0x83c67b84, Offset: 0x9c0
// Size: 0x3f4
function jump_down_traversal( startnode, endnode )
{
    self endon( #"death" );
    self endon( #"traversal_end" );
    level endon( #"game_ended" );
    self thread watch_traversal_end();
    fwd = ( endnode.origin[ 0 ] - startnode.origin[ 0 ], endnode.origin[ 1 ] - startnode.origin[ 1 ], 0 );
    fwd = vectornormalize( fwd ) * 128;
    start = startnode.origin + ( 0, 0, 16 );
    end = startnode.origin + fwd + ( 0, 0, 16 );
    result = bullettrace( start, end, 0, self );
    
    if ( result[ "surfacetype" ] != "none" )
    {
        self botsetmoveanglefrompoint( endnode.origin );
        wait 0.05;
        self tap_jump_button();
        return;
    }
    
    dist = distance2d( startnode.origin, endnode.origin );
    height = startnode.origin[ 2 ] - endnode.origin[ 2 ];
    gravity = self getplayergravity();
    t = sqrt( 2 * height / gravity );
    speed2d = self bot_speed2d();
    
    if ( t * speed2d < dist )
    {
        ledgetop = checknavmeshdirection( startnode.origin, endnode.origin - startnode.origin, 128, 1 );
        bottomdist = dist - distance2d( startnode.origin, ledgetop );
        ledgebottom = checknavmeshdirection( endnode.origin, startnode.origin - endnode.origin, bottomdist, 1 );
        meshdist = distance2d( ledgetop, ledgebottom );
        
        if ( meshdist > 30 )
        {
            self thread jump_to( endnode.origin );
            return;
        }
    }
    
    self botsetmoveanglefrompoint( endnode.origin );
}

// Namespace bot
// Params 3
// Checksum 0xd9f82b86, Offset: 0xdc0
// Size: 0x1cc
function wallrun_traversal( startnode, endnode, vector )
{
    self endon( #"death" );
    self endon( #"traversal_end" );
    level endon( #"game_ended" );
    self thread watch_traversal_end();
    wallnormal = getnavmeshfacenormal( endnode.origin, 30 );
    wallnormal = vectornormalize( ( wallnormal[ 0 ], wallnormal[ 1 ], 0 ) );
    traversaldir = ( startnode.origin[ 0 ] - endnode.origin[ 0 ], startnode.origin[ 1 ] - endnode.origin[ 1 ], 0 );
    cross = vectorcross( wallnormal, traversaldir );
    rundir = vectorcross( wallnormal, cross );
    self botsetlookangles( rundir );
    self thread jump_to( endnode.origin, vector );
    self thread wait_wallrun_begin( startnode, endnode, wallnormal, rundir );
}

// Namespace bot
// Params 4
// Checksum 0x6fb6c82c, Offset: 0xf98
// Size: 0x174
function wait_wallrun_begin( startnode, endnode, wallnormal, rundir )
{
    self endon( #"death" );
    self endon( #"traversal_end" );
    level endon( #"game_ended" );
    self waittill( #"wallrun_begin" );
    self thread watch_traversal_end();
    self botlooknone();
    self botsetmoveangle( rundir );
    self release_doublejump_button();
    index = self getnodeindexonpath( startnode );
    index++;
    exitstartnode = self getnexttraversalnodeonpath( index );
    
    if ( isdefined( exitstartnode ) )
    {
        exitendnode = getothernodeinnegotiationpair( exitstartnode );
        
        if ( isdefined( exitendnode ) )
        {
            self thread exit_wallrun( exitstartnode, exitendnode, wallnormal, vectornormalize( rundir ) );
        }
    }
}

// Namespace bot
// Params 4
// Checksum 0xce6e2cbd, Offset: 0x1118
// Size: 0x3b2
function exit_wallrun( startnode, endnode, wallnormal, runnormal )
{
    self endon( #"death" );
    self endon( #"traversal_end" );
    level endon( #"game_ended" );
    self thread watch_traversal_end();
    gravity = self getplayergravity();
    vup = sqrt( 80 * gravity );
    tpeak = vup / gravity;
    hpeak = self.origin[ 2 ] + 40;
    falldist = hpeak - endnode.origin[ 2 ];
    
    if ( falldist > 0 )
    {
        tfall = sqrt( falldist / 0.5 * gravity );
    }
    else
    {
        tfall = 0;
    }
    
    t = tpeak + tfall;
    exitdir = endnode.origin - startnode.origin;
    dnormal = vectordot( exitdir, wallnormal );
    vnormal = dnormal / t;
    
    if ( vnormal <= 200 )
    {
        dot = sqrt( vnormal / 200 );
        vforward = sqrt( 40000 * dot * dot - vnormal * vnormal );
    }
    else
    {
        vforward = 0;
    }
    
    while ( true )
    {
        wait 0.05;
        enddir = endnode.origin - self.origin;
        enddist = vectordot( enddir, runnormal );
        vrun = self bot_speed2d();
        dforward = ( vrun + vforward ) * t;
        
        if ( enddist <= dforward )
        {
            jumpangle = wallnormal * vnormal + runnormal * vforward;
            
            if ( iswallrunnode( endnode ) )
            {
                self thread wallrun_traversal( startnode, endnode, jumpangle );
                return;
            }
            
            self botsetlookanglesfrompoint( endnode.origin );
            self thread jump_to( endnode.origin, jumpangle );
            return;
        }
    }
}

// Namespace bot
// Params 2
// Checksum 0x803d52f2, Offset: 0x14d8
// Size: 0x254
function jump_to( target, vector )
{
    self endon( #"death" );
    self endon( #"traversal_end" );
    level endon( #"game_ended" );
    
    if ( isdefined( vector ) )
    {
        self botsetmoveangle( vector );
        movedir = vectornormalize( ( vector[ 0 ], vector[ 1 ], 0 ) );
    }
    else
    {
        self botsetmoveanglefrompoint( target );
        targetdelta = target - self.origin;
        movedir = vectornormalize( ( targetdelta[ 0 ], targetdelta[ 1 ], 0 ) );
    }
    
    velocity = self getvelocity();
    velocitydir = vectornormalize( ( velocity[ 0 ], velocity[ 1 ], 0 ) );
    
    if ( vectordot( movedir, velocitydir ) < 0.94 )
    {
        wait 0.05;
    }
    
    self tap_jump_button();
    wait 0.05;
    
    while ( !self isonground() && !self ismantling() && !self iswallrunning() && !self bot_hit_target( target ) )
    {
        press_doublejump_button();
        
        if ( !isdefined( vector ) )
        {
            self botsetmoveanglefrompoint( target );
        }
        
        wait 0.05;
    }
    
    release_doublejump_button();
}

// Namespace bot
// Params 1
// Checksum 0x90aeb63a, Offset: 0x1738
// Size: 0x68
function bot_update_move_angle( target )
{
    self endon( #"death" );
    self endon( #"traversal_end" );
    level endon( #"game_ended" );
    
    while ( !self ismantling() )
    {
        self botsetmoveanglefrompoint( target );
        wait 0.05;
    }
}

// Namespace bot
// Params 1
// Checksum 0x9dc7c993, Offset: 0x17a8
// Size: 0x192, Type: bool
function bot_hit_target( target )
{
    velocity = self getvelocity();
    targetdir = target - self.origin;
    targetdir = ( targetdir[ 0 ], targetdir[ 1 ], 0 );
    
    if ( self.origin[ 2 ] > target[ 2 ] && vectordot( velocity, targetdir ) <= 0 )
    {
        return true;
    }
    
    targetdist = length( targetdir );
    targetspeed = length( velocity );
    
    if ( targetspeed == 0 )
    {
        return false;
    }
    
    t = targetdist / targetspeed;
    gravity = self getplayergravity();
    height = self.origin[ 2 ] + velocity[ 2 ] * t - gravity * t * t * 0.5;
    
    /#
    #/
    
    return height >= target[ 2 ] + 32;
}

// Namespace bot
// Params 0
// Checksum 0x6d967e2d, Offset: 0x1948
// Size: 0x54
function bot_speed2d()
{
    velocity = self getvelocity();
    speed2d = distance2d( velocity, ( 0, 0, 0 ) );
    return speed2d;
}

// Namespace bot
// Params 0
// Checksum 0x177dd094, Offset: 0x19a8
// Size: 0x8c
function watch_traversal_end()
{
    self notify( #"watch_travesal_end" );
    self endon( #"death" );
    self endon( #"traversal_end" );
    self endon( #"watch_travesal_end" );
    level endon( #"game_ended" );
    self thread wait_traversal_timeout();
    self thread watch_start_swimming();
    self waittill( #"acrobatics_end" );
    self thread traversal_end();
}

// Namespace bot
// Params 0
// Checksum 0x4b194b02, Offset: 0x1a40
// Size: 0x9c
function watch_start_swimming()
{
    self endon( #"death" );
    self endon( #"traversal_end" );
    self endon( #"watch_travesal_end" );
    level endon( #"game_ended" );
    
    while ( self isplayerswimming() )
    {
        wait 0.05;
    }
    
    wait 0.05;
    
    while ( !self isplayerswimming() )
    {
        wait 0.05;
    }
    
    self thread traversal_end();
}

// Namespace bot
// Params 0
// Checksum 0xe44b6d65, Offset: 0x1ae8
// Size: 0x64
function wait_traversal_timeout()
{
    self endon( #"death" );
    self endon( #"traversal_end" );
    self endon( #"watch_travesal_end" );
    level endon( #"game_ended" );
    wait 8;
    self thread traversal_end();
    self botrequestpath();
}

// Namespace bot
// Params 0
// Checksum 0x2cd6aef7, Offset: 0x1b58
// Size: 0x6c
function traversal_end()
{
    self notify( #"traversal_end" );
    self release_doublejump_button();
    self botlookforward();
    self botsetmovemagnitude( 1 );
    self botreleasemanualcontrol();
}

