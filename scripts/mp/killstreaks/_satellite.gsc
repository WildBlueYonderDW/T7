#using scripts/codescripts/struct;
#using scripts/mp/_util;
#using scripts/mp/gametypes/_battlechatter;
#using scripts/mp/gametypes/_globallogic_audio;
#using scripts/mp/killstreaks/_airsupport;
#using scripts/mp/killstreaks/_killstreak_bundles;
#using scripts/mp/killstreaks/_killstreak_hacking;
#using scripts/mp/killstreaks/_killstreakrules;
#using scripts/mp/killstreaks/_killstreaks;
#using scripts/mp/teams/_teams;
#using scripts/shared/callbacks_shared;
#using scripts/shared/challenges_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/damagefeedback_shared;
#using scripts/shared/hostmigration_shared;
#using scripts/shared/killstreaks_shared;
#using scripts/shared/math_shared;
#using scripts/shared/scoreevents_shared;
#using scripts/shared/system_shared;
#using scripts/shared/tweakables_shared;
#using scripts/shared/util_shared;
#using scripts/shared/weapons/_heatseekingmissile;
#using scripts/shared/weapons/_weaponobjects;

#namespace satellite;

// Namespace satellite
// Params 0
// Checksum 0x5038038d, Offset: 0x660
// Size: 0x1fc
function init()
{
    if ( level.teambased )
    {
        foreach ( team in level.teams )
        {
            level.activesatellites[ team ] = 0;
        }
    }
    else
    {
        level.activesatellites = [];
    }
    
    level.activeplayersatellites = [];
    
    if ( tweakables::gettweakablevalue( "killstreak", "allowradardirection" ) )
    {
        killstreaks::register( "satellite", "satellite", "killstreak_satellite", "uav_used", &activatesatellite );
        killstreaks::register_strings( "satellite", &"KILLSTREAK_EARNED_SATELLITE", &"KILLSTREAK_SATELLITE_NOT_AVAILABLE", &"KILLSTREAK_SATELLITE_INBOUND", undefined, &"KILLSTREAK_SATELLITE_HACKED" );
        killstreaks::register_dialog( "satellite", "mpl_killstreak_satellite", "satelliteDialogBundle", undefined, "friendlySatellite", "enemySatellite", "enemySatelliteMultiple", "friendlySatelliteHacked", "enemySatelliteHacked", "requestSatellite", "threatSatellite" );
    }
    
    callback::on_connect( &onplayerconnect );
    callback::on_spawned( &onplayerspawned );
    level thread satellitetracker();
}

// Namespace satellite
// Params 0
// Checksum 0x5cc4a00e, Offset: 0x868
// Size: 0x56
function onplayerconnect()
{
    self.entnum = self getentitynumber();
    
    if ( !level.teambased )
    {
        level.activesatellites[ self.entnum ] = 0;
    }
    
    level.activeplayersatellites[ self.entnum ] = 0;
}

// Namespace satellite
// Params 1
// Checksum 0x5207fbae, Offset: 0x8c8
// Size: 0x2c
function onplayerspawned( local_client_num )
{
    if ( !level.teambased )
    {
        updateplayersatellitefordm( self );
    }
}

// Namespace satellite
// Params 0
// Checksum 0x65f060b6, Offset: 0x900
// Size: 0x5d0, Type: bool
function activatesatellite()
{
    if ( self killstreakrules::iskillstreakallowed( "satellite", self.team ) == 0 )
    {
        return false;
    }
    
    killstreak_id = self killstreakrules::killstreakstart( "satellite", self.team );
    
    if ( killstreak_id == -1 )
    {
        return false;
    }
    
    minflyheight = int( airsupport::getminimumflyheight() );
    zoffset = minflyheight + 5500;
    travelangle = randomfloatrange( isdefined( level.satellite_spawn_from_angle_min ) ? level.satellite_spawn_from_angle_min : 90, isdefined( level.satellite_spawn_from_angle_max ) ? level.satellite_spawn_from_angle_max : 180 );
    travelradius = airsupport::getmaxmapwidth() * 1.5;
    xoffset = sin( travelangle ) * travelradius;
    yoffset = cos( travelangle ) * travelradius;
    satellite = spawn( "script_model", airsupport::getmapcenter() + ( xoffset, yoffset, zoffset ) );
    satellite setmodel( "veh_t7_drone_srv_blimp" );
    satellite setscale( 1 );
    satellite.killstreak_id = killstreak_id;
    satellite.owner = self;
    satellite.ownerentnum = self getentitynumber();
    satellite.team = self.team;
    satellite setteam( self.team );
    satellite setowner( self );
    satellite killstreaks::configure_team( "satellite", killstreak_id, self, undefined, undefined, &configureteampost );
    satellite killstreak_hacking::enable_hacking( "satellite", &hackedprefunction, undefined );
    satellite.targetname = "satellite";
    satellite.maxhealth = 700;
    satellite.lowhealth = 700 * 0.5;
    satellite.health = 99999;
    satellite.leaving = 0;
    satellite setcandamage( 1 );
    satellite thread killstreaks::monitordamage( "satellite", satellite.maxhealth, &destroysatellite, satellite.lowhealth, &onlowhealth, 0, undefined, 0 );
    satellite thread killstreaks::waittillemp( &destroysatellitebyemp );
    satellite.killstreakdamagemodifier = &killstreakdamagemodifier;
    satellite.rocketdamage = satellite.maxhealth / 3 + 1;
    
    /#
    #/
    
    satellite moveto( airsupport::getmapcenter() + ( xoffset * -1, yoffset * -1, zoffset ), 40000 * 0.001 );
    target_set( satellite );
    satellite clientfield::set( "enemyvehicle", 1 );
    satellite thread killstreaks::waitfortimeout( "satellite", 40000, &ontimeout, "death", "crashing" );
    satellite thread heatseekingmissile::missiletarget_proximitydetonateincomingmissile( "death", undefined, 1 );
    satellite thread rotate( 10 );
    self killstreaks::play_killstreak_start_dialog( "satellite", self.team, killstreak_id );
    satellite thread killstreaks::player_killstreak_threat_tracking( "satellite" );
    self addweaponstat( getweapon( "satellite" ), "used", 1 );
    return true;
}

// Namespace satellite
// Params 1
// Checksum 0xae48f69, Offset: 0xed8
// Size: 0x34
function hackedprefunction( hacker )
{
    satellite = self;
    satellite resetactivesatellite();
}

// Namespace satellite
// Params 2
// Checksum 0x2b51bf9b, Offset: 0xf18
// Size: 0xc4
function configureteampost( owner, ishacked )
{
    satellite = self;
    satellite thread teams::waituntilteamchangesingleton( owner, "Satellite_watch_team_change", &onteamchange, self.entnum, "delete", "death", "leaving" );
    
    if ( ishacked == 0 )
    {
        satellite teams::hidetosameteam();
    }
    else
    {
        satellite setvisibletoall();
    }
    
    satellite addactivesatellite();
}

// Namespace satellite
// Params 1
// Checksum 0x73d307ac, Offset: 0xfe8
// Size: 0x46
function rotate( duration )
{
    self endon( #"death" );
    
    while ( true )
    {
        self rotateyaw( -360, duration );
        wait duration;
    }
}

// Namespace satellite
// Params 2
// Checksum 0xc671d950, Offset: 0x1038
// Size: 0x14
function onlowhealth( attacker, weapon )
{
    
}

// Namespace satellite
// Params 2
// Checksum 0x48980dbe, Offset: 0x1058
// Size: 0x2c
function onteamchange( entnum, event )
{
    destroysatellite( undefined, undefined );
}

// Namespace satellite
// Params 0
// Checksum 0xf4d283a7, Offset: 0x1090
// Size: 0xac
function ontimeout()
{
    self killstreaks::play_pilot_dialog_on_owner( "timeout", "satellite" );
    self.leaving = 1;
    self removeactivesatellite();
    airsupport::leave( 10 );
    wait 10;
    
    if ( target_istarget( self ) )
    {
        target_remove( self );
    }
    
    self delete();
}

// Namespace satellite
// Params 2
// Checksum 0xaf65671a, Offset: 0x1148
// Size: 0x3c
function destroysatellitebyemp( attacker, arg )
{
    destroysatellite( attacker, getweapon( "emp" ) );
}

// Namespace satellite
// Params 2
// Checksum 0xd78f71ef, Offset: 0x1190
// Size: 0x244
function destroysatellite( attacker, weapon )
{
    if ( !isdefined( attacker ) )
    {
        attacker = undefined;
    }
    
    if ( !isdefined( weapon ) )
    {
        weapon = undefined;
    }
    
    attacker = self [[ level.figure_out_attacker ]]( attacker );
    
    if ( !isdefined( self.owner ) || isdefined( attacker ) && self.owner util::isenemyplayer( attacker ) )
    {
        challenges::destroyedaircraft( attacker, weapon, 0 );
        scoreevents::processscoreevent( "destroyed_satellite", attacker, self.owner, weapon );
        attacker challenges::addflyswatterstat( weapon, self );
        luinotifyevent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_SATELLITE", attacker.entnum );
        
        if ( !self.leaving )
        {
            self killstreaks::play_destroyed_dialog_on_owner( "satellite", self.killstreak_id );
        }
    }
    
    self notify( #"crashing" );
    params = level.killstreakbundle[ "satellite" ];
    
    if ( isdefined( params.ksexplosionfx ) )
    {
        playfxontag( params.ksexplosionfx, self, "tag_origin" );
    }
    
    self setmodel( "tag_origin" );
    
    if ( target_istarget( self ) )
    {
        target_remove( self );
    }
    
    wait 0.5;
    
    if ( !self.leaving )
    {
        self removeactivesatellite();
    }
    
    self delete();
}

// Namespace satellite
// Params 1
// Checksum 0xc3aa1a61, Offset: 0x13e0
// Size: 0x1c, Type: bool
function hassatellite( team_or_entnum )
{
    return level.activesatellites[ team_or_entnum ] > 0;
}

// Namespace satellite
// Params 0
// Checksum 0x9e878859, Offset: 0x1408
// Size: 0x5a
function addactivesatellite()
{
    if ( level.teambased )
    {
        level.activesatellites[ self.team ]++;
    }
    else
    {
        level.activesatellites[ self.ownerentnum ]++;
    }
    
    level.activeplayersatellites[ self.ownerentnum ]++;
    level notify( #"satellite_update" );
}

// Namespace satellite
// Params 0
// Checksum 0xdcc394b2, Offset: 0x1470
// Size: 0x44
function removeactivesatellite()
{
    self resetactivesatellite();
    killstreakrules::killstreakstop( "satellite", self.originalteam, self.killstreak_id );
}

// Namespace satellite
// Params 0
// Checksum 0xad92d74, Offset: 0x14c0
// Size: 0x16a
function resetactivesatellite()
{
    if ( level.teambased )
    {
        level.activesatellites[ self.team ]--;
        assert( level.activesatellites[ self.team ] >= 0 );
        
        if ( level.activesatellites[ self.team ] < 0 )
        {
            level.activesatellites[ self.team ] = 0;
        }
    }
    else if ( isdefined( self.ownerentnum ) )
    {
        level.activesatellites[ self.ownerentnum ]--;
        assert( level.activesatellites[ self.ownerentnum ] >= 0 );
        
        if ( level.activesatellites[ self.ownerentnum ] < 0 )
        {
            level.activesatellites[ self.ownerentnum ] = 0;
        }
    }
    
    assert( isdefined( self.ownerentnum ) );
    level.activeplayersatellites[ self.ownerentnum ]--;
    assert( level.activeplayersatellites[ self.ownerentnum ] >= 0 );
    level notify( #"satellite_update" );
}

// Namespace satellite
// Params 0
// Checksum 0x18ad5962, Offset: 0x1638
// Size: 0x18a
function satellitetracker()
{
    level endon( #"game_ended" );
    
    while ( true )
    {
        level waittill( #"satellite_update" );
        
        if ( level.teambased )
        {
            foreach ( team in level.teams )
            {
                activesatellites = level.activesatellites[ team ];
                activesatellitesanduavs = activesatellites + ( isdefined( level.activeuavs ) ? level.activeuavs[ team ] : 0 );
                setteamsatellite( team, activesatellites > 0 );
                util::set_team_radar( team, activesatellitesanduavs > 0 );
            }
            
            continue;
        }
        
        for ( i = 0; i < level.players.size ; i++ )
        {
            updateplayersatellitefordm( level.players[ i ] );
        }
    }
}

// Namespace satellite
// Params 1
// Checksum 0xf45c8ceb, Offset: 0x17d0
// Size: 0xe4
function updateplayersatellitefordm( player )
{
    if ( !isdefined( player.entnum ) )
    {
        player.entnum = player getentitynumber();
    }
    
    activesatellites = level.activesatellites[ player.entnum ];
    activesatellitesanduavs = activesatellites + ( isdefined( level.activeuavs ) ? level.activeuavs[ player.entnum ] : 0 );
    player setclientuivisibilityflag( "radar_client", activesatellitesanduavs > 0 );
    player.hassatellite = activesatellites > 0;
}

// Namespace satellite
// Params 12
// Checksum 0x7ebaf75d, Offset: 0x18c0
// Size: 0xa0
function killstreakdamagemodifier( damage, attacker, direction, point, smeansofdeath, tagname, modelname, partname, weapon, flags, inflictor, chargelevel )
{
    if ( smeansofdeath == "MOD_PISTOL_BULLET" || smeansofdeath == "MOD_RIFLE_BULLET" )
    {
        return 0;
    }
    
    if ( smeansofdeath == "MOD_PROJECTILE_SPLASH" )
    {
        return 0;
    }
    
    return damage;
}

