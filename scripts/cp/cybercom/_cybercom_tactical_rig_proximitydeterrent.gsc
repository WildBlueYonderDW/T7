#using scripts/codescripts/struct;
#using scripts/cp/cybercom/_cybercom;
#using scripts/cp/cybercom/_cybercom_dev;
#using scripts/cp/cybercom/_cybercom_gadget_system_overload;
#using scripts/cp/cybercom/_cybercom_tactical_rig;
#using scripts/cp/cybercom/_cybercom_util;
#using scripts/cp/gametypes/_battlechatter;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flagsys_shared;
#using scripts/shared/hud_util_shared;
#using scripts/shared/math_shared;
#using scripts/shared/system_shared;
#using scripts/shared/util_shared;

#namespace cybercom_tacrig_proximitydeterrent;

// Namespace cybercom_tacrig_proximitydeterrent
// Params 0
// Checksum 0x99ec1590, Offset: 0x5c0
// Size: 0x4
function init()
{
    
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 0
// Checksum 0x27ad3e78, Offset: 0x5d0
// Size: 0xd4
function main()
{
    callback::on_connect( &on_player_connect );
    callback::on_spawned( &on_player_spawned );
    cybercom_tacrig::register_cybercom_rig_ability( "cybercom_proximitydeterrent", 2 );
    cybercom_tacrig::register_cybercom_rig_possession_callbacks( "cybercom_proximitydeterrent", &proximitydeterrentgive, &proximitydeterrenttake );
    cybercom_tacrig::register_cybercom_rig_activation_callbacks( "cybercom_proximitydeterrent", &proximitydeterrentactivate, &proximitydeterrentdeactivate );
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 0
// Checksum 0x99ec1590, Offset: 0x6b0
// Size: 0x4
function on_player_connect()
{
    
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 0
// Checksum 0x99ec1590, Offset: 0x6c0
// Size: 0x4
function on_player_spawned()
{
    
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 1
// Checksum 0x2d815f59, Offset: 0x6d0
// Size: 0x1dc
function proximitydeterrentgive( type )
{
    self.cybercom.var_a9774972 = getweapon( "gadget_proximity_det" );
    self.cybercom.var_f4b9137e = getweapon( "gadget_es_strike" );
    
    if ( !isdefined( self.cybercom.var_d7d9f704 ) )
    {
        self.cybercom.var_d7d9f704 = [];
        self.cybercom.var_d7d9f704[ 0 ] = spawnstruct();
        self.cybercom.var_d7d9f704[ 1 ] = spawnstruct();
        self.cybercom.var_d7d9f704[ 2 ] = spawnstruct();
        self.cybercom.var_d7d9f704[ 3 ] = spawnstruct();
        self.cybercom.var_d7d9f704[ 0 ].time = 0;
        self.cybercom.var_d7d9f704[ 1 ].time = 0;
        self.cybercom.var_d7d9f704[ 2 ].time = 0;
        self.cybercom.var_d7d9f704[ 3 ].time = 0;
    }
    
    self thread function_f5590749();
    self thread proximitydeterrentthink( type );
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 1
// Checksum 0xeb9da758, Offset: 0x8b8
// Size: 0x26
function proximitydeterrenttake( type )
{
    self.cybercom.var_a9774972 = undefined;
    self notify( #"proximitydeterrenttake" );
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 1
// Checksum 0xfdc5e041, Offset: 0x8e8
// Size: 0x138
function proximitydeterrentthink( type )
{
    self notify( #"proximitydeterrentthink" );
    self endon( #"proximitydeterrentthink" );
    self endon( #"disconnect" );
    self endon( "take_ability_" + type );
    
    while ( true )
    {
        self waittill( #"damage", n_damage, e_attacker, v_vector, v_point, str_means_of_death, str_string_1, str_string_2, str_string_3, w_weapon );
        
        if ( issubstr( str_means_of_death, "MOD_MELEE" ) && isdefined( e_attacker ) )
        {
            self.cybercom.proximity_deterrent_target = e_attacker;
            self cybercom_tacrig::turn_rig_ability_on( type );
            self thread function_ae8e24a7( e_attacker );
        }
    }
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 0
// Checksum 0x100bcf, Offset: 0xa28
// Size: 0x268
function function_f5590749()
{
    self endon( #"proximitydeterrenttake" );
    
    while ( true )
    {
        curtime = gettime();
        var_f9459f98 = undefined;
        var_2f0e78d0 = 0;
        
        for ( zone = 0; zone < 4 ; zone++ )
        {
            if ( self.cybercom.var_d7d9f704[ zone ].time > curtime )
            {
                attacker = self.cybercom.var_d7d9f704[ zone ].attacker;
                
                if ( isdefined( attacker ) )
                {
                    self.cybercom.var_d7d9f704[ zone ].yaw = self cybercom::getyawtospot( attacker.origin );
                }
                
                if ( self.cybercom.var_d7d9f704[ zone ].time > var_2f0e78d0 )
                {
                    var_2f0e78d0 = self.cybercom.var_d7d9f704[ zone ].time;
                    var_f9459f98 = zone;
                }
                
                continue;
            }
            
            if ( self.cybercom.var_d7d9f704[ zone ].time != 0 )
            {
                self.cybercom.var_d7d9f704[ zone ].time = 0;
                self.cybercom.var_d7d9f704[ zone ].attacker = undefined;
                self.cybercom.var_d7d9f704[ zone ].yaw = undefined;
            }
        }
        
        if ( isdefined( var_f9459f98 ) )
        {
            self clientfield::set_player_uimodel( "playerAbilities.proximityIndicatorIntensity", 1 );
            self clientfield::set_player_uimodel( "playerAbilities.proximityIndicatorDirection", var_f9459f98 );
        }
        else
        {
            self clientfield::set_player_uimodel( "playerAbilities.proximityIndicatorIntensity", 0 );
        }
        
        wait 0.05;
    }
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 1
// Checksum 0x8bac3fa0, Offset: 0xc98
// Size: 0x16c
function function_ae8e24a7( attacker )
{
    yaw = self cybercom::getyawtospot( attacker.origin );
    
    if ( yaw > -45 && yaw <= 45 )
    {
        zone = 0;
    }
    else if ( yaw > 45 && yaw <= 135 )
    {
        zone = 3;
    }
    else if ( yaw >= -180 && ( yaw > 135 && yaw <= 180 || yaw < -135 ) )
    {
        zone = 2;
    }
    else
    {
        zone = 1;
    }
    
    self.cybercom.var_d7d9f704[ zone ].time = gettime() + getdvarint( "scr_proximity_indicator_durationMSEC", 1500 );
    self.cybercom.var_d7d9f704[ zone ].attacker = attacker;
    self.cybercom.var_d7d9f704[ zone ].yaw = yaw;
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 1
// Checksum 0x4c837fbb, Offset: 0xe10
// Size: 0x5c
function proximitydeterrentactivate( type )
{
    if ( isdefined( self.cybercom.proximity_deterrent_target ) )
    {
        self.cybercom.proximity_deterrent_target thread proximitydeterrentonattacker( type, self );
    }
    
    self cybercom_tacrig::turn_rig_ability_off( type );
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 1
// Checksum 0xc7d536e8, Offset: 0xe78
// Size: 0xc
function proximitydeterrentdeactivate( type )
{
    
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 2
// Checksum 0xf4bab42f, Offset: 0xe90
// Size: 0xcc
function proximitydeterrentonattacker( type, player )
{
    if ( !isdefined( self ) )
    {
        return;
    }
    
    if ( isdefined( player.cybercom.tacrigs_disabled ) && player.cybercom.tacrigs_disabled )
    {
        return;
    }
    
    if ( isdefined( self.nocybercom ) && self.nocybercom )
    {
        return;
    }
    
    player playsound( "gdt_cybercore_rig_prox_activate" );
    level thread _stunassailant( player, self, player hascybercomrig( type ) == 2 );
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 3, eflags: 0x4
// Checksum 0x2fbd5d4e, Offset: 0xf68
// Size: 0x424
function private _stunassailant( player, attacker, upgraded )
{
    attacker endon( #"death" );
    
    if ( !isdefined( attacker.archetype ) )
    {
        return;
    }
    
    switch ( attacker.archetype )
    {
        case "human":
        case "human_riotshield":
        case "zombie":
            var_36a3e6ad = "J_Wrist_LE";
            fx = level._effect[ "es_effect_human" ];
            tag = "j_spine4";
            damage = attacker.health;
            weapon = player.cybercom.var_a9774972;
            
            if ( isdefined( attacker.voiceprefix ) && isdefined( attacker.bcvoicenumber ) )
            {
                attacker thread battlechatter::do_sound( attacker.voiceprefix + attacker.bcvoicenumber + "_exert_electrocution", 1 );
            }
            
            break;
        case "robot":
            var_36a3e6ad = "J_Wrist_LE";
            fx = level._effect[ "es_effect_robot" ];
            attacker playsound( "fly_bot_disable" );
            tag = "j_spine4";
            damage = attacker.health;
            weapon = player.cybercom.var_f4b9137e;
            break;
        case "warlord":
            var_36a3e6ad = "J_Wrist_LE";
            fx = level._effect[ "es_effect_warlord" ];
            tag = "j_spine4";
            damage = getdvarint( "scr_proximity_stun_damage_to_warlord", 60 );
            weapon = player.cybercom.var_a9774972;
            break;
        case "direwolf":
            var_36a3e6ad = "J_Wrist_LE";
            fx = level._effect[ "es_effect_generic" ];
            tag = "tag_origin";
            damage = attacker.health;
            weapon = player.cybercom.var_a9774972;
            break;
        default:
            var_36a3e6ad = "J_Wrist_LE";
            tag = "tag_origin";
            fx = level._effect[ "es_effect_generic" ];
            damage = attacker.health;
            weapon = player.cybercom.var_a9774972;
            break;
    }
    
    if ( isdefined( upgraded ) && upgraded )
    {
        level thread function_c0ba5acc( player, attacker );
    }
    
    playfxontag( level._effect[ "es_contact" ], player, var_36a3e6ad );
    playfxontag( fx, attacker, tag );
    attacker playsound( "gdt_cybercore_rig_prox_imp" );
    attacker dodamage( damage, player.origin, player, player, "none", "MOD_UNKNOWN", 0, weapon, -1, 1 );
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 3
// Checksum 0x898f8f73, Offset: 0x1398
// Size: 0x2e2
function function_c0ba5acc( player, attacker, radius )
{
    enemies = arraycombine( getaiteamarray( "axis" ), getaiteamarray( "team3" ), 0, 0 );
    
    if ( !isdefined( radius ) )
    {
        var_119472f5 = getdvarint( "scr_proximity_stun_discharge_radius", 144 ) * getdvarint( "scr_proximity_stun_discharge_radius", 144 );
    }
    else
    {
        var_119472f5 = radius * radius;
    }
    
    var_4c0d9ab5 = [];
    
    foreach ( guy in enemies )
    {
        if ( isdefined( attacker ) && guy == attacker )
        {
            continue;
        }
        
        if ( isvehicle( guy ) )
        {
            continue;
        }
        
        if ( !isdefined( guy.archetype ) )
        {
            continue;
        }
        
        if ( isdefined( guy.nocybercom ) && guy.nocybercom )
        {
            continue;
        }
        
        if ( guy.takedamage == 0 )
        {
            continue;
        }
        
        distsq = distancesquared( player.origin, guy.origin );
        
        if ( distsq > var_119472f5 )
        {
            continue;
        }
        
        var_4c0d9ab5[ var_4c0d9ab5.size ] = guy;
        
        if ( var_4c0d9ab5.size >= getdvarint( "scr_proximity_stun_max_secondary_hits", 6 ) )
        {
            break;
        }
    }
    
    foreach ( guy in var_4c0d9ab5 )
    {
        level thread function_a38f70a1( player, guy );
    }
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 2, eflags: 0x4
// Checksum 0x52c55769, Offset: 0x1688
// Size: 0x44
function private function_c8e11a8b( ent, note )
{
    ent endon( #"death" );
    self waittill( note );
    ent delete();
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 2, eflags: 0x4
// Checksum 0xc8657186, Offset: 0x16d8
// Size: 0x4c4
function private function_a38f70a1( player, target )
{
    target endon( #"death" );
    player endon( #"disconnect" );
    orb = spawn( "script_model", player.origin + ( 0, 0, 45 ) );
    orb setmodel( "tag_origin" );
    playfxontag( level._effect[ "es_arc" ], orb, "tag_origin" );
    orb endon( #"death" );
    target thread function_c8e11a8b( orb, "death" );
    player thread function_c8e11a8b( orb, "disconnect" );
    orb moveto( target.origin + ( 0, 0, 45 ), 0.3 );
    orb waittill( #"movedone" );
    target playsound( "gdt_cybercore_rig_prox_imp" );
    damage = getdvarint( "scr_proximity_stun_damage", 20 );
    
    switch ( target.archetype )
    {
        case "human":
        case "human_riotshield":
        case "zombie":
            fx = level._effect[ "es_effect_human" ];
            tag = "j_spine4";
            target dodamage( damage, player.origin, player, player, "none", "MOD_UNKNOWN", 0, player.cybercom.var_a9774972, -1, 1 );
            target notify( #"bhtn_action_notify", "electrocute" );
            break;
        case "robot":
            fx = level._effect[ "es_effect_robot" ];
            tag = "j_spine4";
            target thread cybercom_gadget_system_overload::system_overload( player );
            break;
        case "warlord":
            fx = level._effect[ "es_effect_warlord" ];
            tag = "j_spine4";
            target dodamage( damage, player.origin, player, player, "none", "MOD_UNKNOWN", 0, player.cybercom.var_a9774972, -1, 1 );
            break;
        case "direwolf":
            fx = level._effect[ "es_effect_generic" ];
            tag = "tag_origin";
            target dodamage( damage, player.origin, player, player, "none", "MOD_UNKNOWN", 0, player.cybercom.var_a9774972, -1, 1 );
            break;
        default:
            fx = level._effect[ "es_effect_generic" ];
            tag = "tag_body";
            target dodamage( damage, player.origin, player, player, "none", "MOD_GRENADE_SPLASH", 0, getweapon( "emp_grenade" ), -1, 1 );
            break;
    }
    
    playfx( level._effect[ "es_contact" ], orb.origin );
    playfxontag( fx, target, tag );
    orb delete();
}

// Namespace cybercom_tacrig_proximitydeterrent
// Params 2
// Checksum 0xe024942, Offset: 0x1ba8
// Size: 0xec
function function_327bda1e( idamage, damagemod )
{
    if ( !issubstr( damagemod, "_MELEE" ) )
    {
        return idamage;
    }
    
    status = self hascybercomrig( "cybercom_proximitydeterrent" );
    reducer = status == 2 ? getdvarfloat( "scr_proximity_damage_reducer_upg", 0.1 ) : getdvarfloat( "scr_proximity_damage_reducer", 0.2 );
    var_bc6c098a = int( idamage * reducer );
    return var_bc6c098a;
}

