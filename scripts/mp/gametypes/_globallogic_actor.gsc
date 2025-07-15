#using scripts/codescripts/struct;
#using scripts/mp/_challenges;
#using scripts/mp/gametypes/_globallogic;
#using scripts/mp/gametypes/_globallogic_player;
#using scripts/mp/gametypes/_globallogic_utils;
#using scripts/shared/_burnplayer;
#using scripts/shared/abilities/gadgets/_gadget_clone;
#using scripts/shared/ai/systems/destructible_character;
#using scripts/shared/ai/systems/gib;
#using scripts/shared/challenges_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/damagefeedback_shared;
#using scripts/shared/scoreevents_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/weapons/_weapon_utils;

#namespace globallogic_actor;

// Namespace globallogic_actor
// Params 0, eflags: 0x2
// Checksum 0x99ec1590, Offset: 0x390
// Size: 0x4
function autoexec init()
{
    
}

// Namespace globallogic_actor
// Params 1
// Checksum 0xaf0bb128, Offset: 0x3a0
// Size: 0x24
function callback_actorspawned( spawner )
{
    self thread spawner::spawn_think( spawner );
}

// Namespace globallogic_actor
// Params 15
// Checksum 0xbb7d9b4c, Offset: 0x3d0
// Size: 0xc44
function callback_actordamage( einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, modelindex, surfacetype, vsurfacenormal )
{
    if ( game[ "state" ] == "postgame" )
    {
        return;
    }
    
    if ( self.team == "spectator" )
    {
        return;
    }
    
    if ( isdefined( eattacker ) && isplayer( eattacker ) && isdefined( eattacker.candocombat ) && !eattacker.candocombat )
    {
        return;
    }
    
    self.idflags = idflags;
    self.idflagstime = gettime();
    eattacker = globallogic_player::figure_out_attacker( eattacker );
    
    if ( !isdefined( vdir ) )
    {
        idflags |= 4;
    }
    
    friendly = 0;
    
    if ( self.health == self.maxhealth || !isdefined( self.attackers ) )
    {
        self.attackers = [];
        self.attackerdata = [];
        self.attackerdamage = [];
        self.attackersthisspawn = [];
    }
    
    if ( globallogic_utils::isheadshot( weapon, shitloc, smeansofdeath, einflictor ) && !weapon_utils::ismeleemod( smeansofdeath ) )
    {
        smeansofdeath = "MOD_HEAD_SHOT";
    }
    
    if ( level.onlyheadshots )
    {
        if ( smeansofdeath == "MOD_PISTOL_BULLET" || smeansofdeath == "MOD_RIFLE_BULLET" )
        {
            return;
        }
        else if ( smeansofdeath == "MOD_HEAD_SHOT" )
        {
            idamage = 150;
        }
    }
    
    if ( isdefined( self.overrideactordamage ) )
    {
        idamage = self [[ self.overrideactordamage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex );
    }
    
    friendlyfire = [[ level.figure_out_friendly_fire ]]( self );
    
    if ( friendlyfire == 0 && self.archetype === "robot" && isdefined( eattacker ) && eattacker.team === self.team )
    {
        return;
    }
    
    if ( isdefined( self.aioverridedamage ) )
    {
        for ( index = 0; index < self.aioverridedamage.size ; index++ )
        {
            damagecallback = self.aioverridedamage[ index ];
            idamage = self [[ damagecallback ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex );
        }
        
        if ( idamage < 1 )
        {
            return;
        }
        
        idamage = int( idamage + 0.5 );
    }
    
    if ( weapon == level.weaponnone && isdefined( einflictor ) )
    {
        if ( isdefined( einflictor.targetname ) && einflictor.targetname == "explodable_barrel" )
        {
            weapon = getweapon( "explodable_barrel" );
        }
        else if ( isdefined( einflictor.destructible_type ) && issubstr( einflictor.destructible_type, "vehicle_" ) )
        {
            weapon = getweapon( "destructible_car" );
        }
    }
    
    if ( !( idflags & 2048 ) )
    {
        if ( isplayer( eattacker ) )
        {
            eattacker.pers[ "participation" ]++;
        }
        
        prevhealthratio = self.health / self.maxhealth;
        isshootingownclone = 0;
        
        if ( isdefined( self.isaiclone ) && self.isaiclone && isplayer( eattacker ) && self.owner == eattacker )
        {
            isshootingownclone = 1;
        }
        
        if ( level.teambased && isplayer( eattacker ) && self != eattacker && self.team == eattacker.pers[ "team" ] && !isshootingownclone )
        {
            friendlyfire = [[ level.figure_out_friendly_fire ]]( self );
            
            if ( friendlyfire == 0 )
            {
                return;
            }
            else if ( friendlyfire == 1 )
            {
                if ( idamage < 1 )
                {
                    idamage = 1;
                }
                
                self.lastdamagewasfromenemy = 0;
                self globallogic_player::giveattackerandinflictorownerassist( eattacker, einflictor, idamage, smeansofdeath, weapon );
                self finishactordamage( einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, surfacetype, vsurfacenormal );
            }
            else if ( friendlyfire == 2 )
            {
                return;
            }
            else if ( friendlyfire == 3 )
            {
                idamage = int( idamage * 0.5 );
                
                if ( idamage < 1 )
                {
                    idamage = 1;
                }
                
                self.lastdamagewasfromenemy = 0;
                self globallogic_player::giveattackerandinflictorownerassist( eattacker, einflictor, idamage, smeansofdeath, weapon );
                self finishactordamage( einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, surfacetype, vsurfacenormal );
            }
            
            friendly = 1;
        }
        else
        {
            if ( isdefined( eattacker ) && isdefined( self.script_owner ) && eattacker == self.script_owner && !level.hardcoremode && !isshootingownclone )
            {
                return;
            }
            
            if ( isdefined( eattacker ) && isdefined( self.script_owner ) && isdefined( eattacker.script_owner ) && eattacker.script_owner == self.script_owner )
            {
                return;
            }
            
            if ( idamage < 1 )
            {
                idamage = 1;
            }
            
            if ( issubstr( smeansofdeath, "MOD_GRENADE" ) && isdefined( einflictor ) && isdefined( einflictor.iscooked ) )
            {
                self.wascooked = gettime();
            }
            else
            {
                self.wascooked = undefined;
            }
            
            self.lastdamagewasfromenemy = isdefined( eattacker ) && eattacker != self;
            self globallogic_player::giveattackerandinflictorownerassist( eattacker, einflictor, idamage, smeansofdeath, weapon );
            self finishactordamage( einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, surfacetype, vsurfacenormal );
        }
        
        if ( isdefined( eattacker ) && eattacker != self )
        {
            if ( !isdefined( einflictor ) || !isai( einflictor ) || !isdefined( einflictor.controlled ) || weapon.name != "artillery" && einflictor.controlled )
            {
                if ( idamage > 0 && shitloc !== "riotshield" )
                {
                    eattacker thread damagefeedback::update( smeansofdeath, einflictor, undefined, weapon, self );
                }
            }
        }
    }
    
    /#
        if ( getdvarint( "<dev string:x28>" ) )
        {
            println( "<dev string:x36>" + self getentitynumber() + "<dev string:x3d>" + self.health + "<dev string:x46>" + eattacker.clientid + "<dev string:x51>" + isplayer( einflictor ) + "<dev string:x67>" + idamage + "<dev string:x70>" + shitloc );
        }
    #/
    
    if ( true )
    {
        lpselfnum = self getentitynumber();
        lpselfteam = self.team;
        lpattackerteam = "";
        
        if ( isplayer( eattacker ) )
        {
            lpattacknum = eattacker getentitynumber();
            lpattackguid = eattacker getguid();
            lpattackname = eattacker.name;
            lpattackerteam = eattacker.pers[ "team" ];
        }
        else
        {
            lpattacknum = -1;
            lpattackguid = "";
            lpattackname = "";
            lpattackerteam = "world";
        }
        
        /#
            logprint( "<dev string:x79>" + lpselfnum + "<dev string:x7d>" + lpselfteam + "<dev string:x7d>" + lpattackguid + "<dev string:x7d>" + lpattacknum + "<dev string:x7d>" + lpattackerteam + "<dev string:x7d>" + lpattackname + "<dev string:x7d>" + weapon.name + "<dev string:x7d>" + idamage + "<dev string:x7d>" + smeansofdeath + "<dev string:x7d>" + shitloc + "<dev string:x7d>" + boneindex + "<dev string:x7f>" );
        #/
    }
}

// Namespace globallogic_actor
// Params 8
// Checksum 0x9c5bd188, Offset: 0x1020
// Size: 0x18c
function callback_actorkilled( einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime )
{
    if ( game[ "state" ] == "postgame" )
    {
        return;
    }
    
    if ( isai( attacker ) && isdefined( attacker.script_owner ) )
    {
        if ( attacker.script_owner.team != self.team )
        {
            attacker = attacker.script_owner;
        }
    }
    
    if ( attacker.classname == "script_vehicle" && isdefined( attacker.owner ) )
    {
        attacker = attacker.owner;
    }
    
    _gadget_clone::processclonescoreevent( self, attacker, weapon );
    globallogic::doweaponspecifickilleffects( einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime );
    globallogic::doweaponspecificcorpseeffects( self, einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime );
}

// Namespace globallogic_actor
// Params 1
// Checksum 0x506a1b49, Offset: 0x11b8
// Size: 0x3c
function callback_actorcloned( original )
{
    destructserverutils::copydestructstate( original, self );
    gibserverutils::copygibstate( original, self );
}

