#using scripts/codescripts/struct;
#using scripts/mp/_armor;
#using scripts/mp/_challenges;
#using scripts/mp/_util;
#using scripts/mp/gametypes/_dev;
#using scripts/mp/gametypes/_globallogic_score;
#using scripts/mp/gametypes/_globallogic_utils;
#using scripts/mp/gametypes/_weapons;
#using scripts/mp/killstreaks/_killstreak_weapons;
#using scripts/mp/killstreaks/_killstreaks;
#using scripts/mp/teams/_teams;
#using scripts/shared/abilities/_ability_util;
#using scripts/shared/abilities/gadgets/_gadget_roulette;
#using scripts/shared/callbacks_shared;
#using scripts/shared/challenges_shared;
#using scripts/shared/dev_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/flagsys_shared;
#using scripts/shared/killstreaks_shared;
#using scripts/shared/loadout_shared;
#using scripts/shared/system_shared;
#using scripts/shared/tweakables_shared;
#using scripts/shared/util_shared;
#using scripts/shared/weapons/_weapon_utils;

#namespace loadout;

// Namespace loadout
// Params 0, eflags: 0x2
// Checksum 0xa024a300, Offset: 0xe08
// Size: 0x34
function autoexec __init__sytem__()
{
    system::register( "loadout", &__init__, undefined, undefined );
}

// Namespace loadout
// Params 0
// Checksum 0x7a239e71, Offset: 0xe48
// Size: 0x44
function __init__()
{
    callback::on_start_gametype( &init );
    callback::on_connect( &on_connect );
}

// Namespace loadout
// Params 0
// Checksum 0x99ec1590, Offset: 0xe98
// Size: 0x4
function on_connect()
{
    
}

// Namespace loadout
// Params 0
// Checksum 0x5ffc14c0, Offset: 0xea8
// Size: 0x1554
function init()
{
    level.classmap[ "class_smg" ] = "CLASS_SMG";
    level.classmap[ "class_cqb" ] = "CLASS_CQB";
    level.classmap[ "class_assault" ] = "CLASS_ASSAULT";
    level.classmap[ "class_lmg" ] = "CLASS_LMG";
    level.classmap[ "class_sniper" ] = "CLASS_SNIPER";
    level.classmap[ "custom0" ] = "CLASS_CUSTOM1";
    level.classmap[ "custom1" ] = "CLASS_CUSTOM2";
    level.classmap[ "custom2" ] = "CLASS_CUSTOM3";
    level.classmap[ "custom3" ] = "CLASS_CUSTOM4";
    level.classmap[ "custom4" ] = "CLASS_CUSTOM5";
    level.classmap[ "custom5" ] = "CLASS_CUSTOM6";
    level.classmap[ "custom6" ] = "CLASS_CUSTOM7";
    level.classmap[ "custom7" ] = "CLASS_CUSTOM8";
    level.classmap[ "custom8" ] = "CLASS_CUSTOM9";
    level.classmap[ "custom9" ] = "CLASS_CUSTOM10";
    level.maxkillstreaks = 4;
    level.maxspecialties = 6;
    level.maxbonuscards = 3;
    level.maxallocation = getgametypesetting( "maxAllocation" );
    level.loadoutkillstreaksenabled = getgametypesetting( "loadoutKillstreaksEnabled" );
    
    if ( getdvarint( "teamOpsEnabled" ) == 1 )
    {
        level.loadoutkillstreaksenabled = 1;
    }
    
    level.weaponbasemeleeheld = getweapon( "bare_hands" );
    level.weaponknifeloadout = getweapon( "knife_loadout" );
    level.weaponmeleeknuckles = getweapon( "melee_knuckles" );
    level.weaponmeleebutterfly = getweapon( "melee_butterfly" );
    level.weaponmeleewrench = getweapon( "melee_wrench" );
    level.weaponmeleesword = getweapon( "melee_sword" );
    level.weaponmeleecrowbar = getweapon( "melee_crowbar" );
    level.weaponspecialcrossbow = getweapon( "special_crossbow" );
    level.weaponmeleedagger = getweapon( "melee_dagger" );
    level.weaponmeleebat = getweapon( "melee_bat" );
    level.weaponmeleebowie = getweapon( "melee_bowie" );
    level.weaponmeleemace = getweapon( "melee_mace" );
    level.weaponmeleefireaxe = getweapon( "melee_fireaxe" );
    level.weaponmeleeboneglass = getweapon( "melee_boneglass" );
    level.weaponmeleeimprovise = getweapon( "melee_improvise" );
    level.weaponshotgunenergy = getweapon( "shotgun_energy" );
    level.weaponpistolenergy = getweapon( "pistol_energy" );
    level.weaponmeleeshockbaton = getweapon( "melee_shockbaton" );
    level.weaponmeleenunchuks = getweapon( "melee_nunchuks" );
    level.weaponmeleeboxing = getweapon( "melee_boxing" );
    level.weaponmeleekatana = getweapon( "melee_katana" );
    level.weaponmeleeshovel = getweapon( "melee_shovel" );
    level.weaponmeleeprosthetic = getweapon( "melee_prosthetic" );
    level.weaponmeleechainsaw = getweapon( "melee_chainsaw" );
    level.weaponspecialdiscgun = getweapon( "special_discgun" );
    level.weaponsmgnailgun = getweapon( "smg_nailgun" );
    level.weaponlaunchermulti = getweapon( "launcher_multi" );
    level.weaponmeleecrescent = getweapon( "melee_crescent" );
    level.weaponlauncherex41 = getweapon( "launcher_ex41" );
    level.meleeweapons = [];
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponknifeloadout;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleeknuckles;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleebutterfly;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleewrench;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleesword;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleecrowbar;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleedagger;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleebat;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleebowie;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleemace;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleefireaxe;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleeboneglass;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleeimprovise;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleeshockbaton;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleenunchuks;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleeboxing;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleekatana;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleeshovel;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleeprosthetic;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleechainsaw;
    
    if ( !isdefined( level.meleeweapons ) )
    {
        level.meleeweapons = [];
    }
    else if ( !isarray( level.meleeweapons ) )
    {
        level.meleeweapons = array( level.meleeweapons );
    }
    
    level.meleeweapons[ level.meleeweapons.size ] = level.weaponmeleecrescent;
    level.weaponbouncingbetty = getweapon( "bouncingbetty" );
    level.prestigenumber = 5;
    level.defaultclass = "CLASS_ASSAULT";
    
    if ( tweakables::gettweakablevalue( "weapon", "allowfrag" ) )
    {
        level.weapons[ "frag" ] = getweapon( "frag_grenade" );
    }
    else
    {
        level.weapons[ "frag" ] = "";
    }
    
    if ( tweakables::gettweakablevalue( "weapon", "allowsmoke" ) )
    {
        level.weapons[ "smoke" ] = getweapon( "smoke_grenade" );
    }
    else
    {
        level.weapons[ "smoke" ] = "";
    }
    
    if ( tweakables::gettweakablevalue( "weapon", "allowflash" ) )
    {
        level.weapons[ "flash" ] = getweapon( "flash_grenade" );
    }
    else
    {
        level.weapons[ "flash" ] = "";
    }
    
    level.weapons[ "concussion" ] = getweapon( "concussion_grenade" );
    
    if ( tweakables::gettweakablevalue( "weapon", "allowsatchel" ) )
    {
        level.weapons[ "satchel_charge" ] = getweapon( "satchel_charge" );
    }
    else
    {
        level.weapons[ "satchel_charge" ] = "";
    }
    
    if ( tweakables::gettweakablevalue( "weapon", "allowbetty" ) )
    {
        level.weapons[ "betty" ] = getweapon( "mine_bouncing_betty" );
    }
    else
    {
        level.weapons[ "betty" ] = "";
    }
    
    if ( tweakables::gettweakablevalue( "weapon", "allowrpgs" ) )
    {
        level.weapons[ "rpg" ] = getweapon( "rpg" );
    }
    else
    {
        level.weapons[ "rpg" ] = "";
    }
    
    create_class_exclusion_list();
    cac_init();
    load_default_loadout( "CLASS_SMG", 10 );
    load_default_loadout( "CLASS_CQB", 11 );
    load_default_loadout( "CLASS_ASSAULT", 12 );
    load_default_loadout( "CLASS_LMG", 13 );
    load_default_loadout( "CLASS_SNIPER", 14 );
    level.primary_weapon_array = [];
    level.side_arm_array = [];
    level.grenade_array = [];
    level.inventory_array = [];
    max_weapon_num = 147;
    
    for ( i = 0; i < max_weapon_num ; i++ )
    {
        if ( !isdefined( level.tbl_weaponids[ i ] ) || level.tbl_weaponids[ i ][ "group" ] == "" )
        {
            continue;
        }
        
        if ( !isdefined( level.tbl_weaponids[ i ] ) || level.tbl_weaponids[ i ][ "reference" ] == "" )
        {
            continue;
        }
        
        weapon_type = level.tbl_weaponids[ i ][ "group" ];
        weapon = level.tbl_weaponids[ i ][ "reference" ];
        attachment = level.tbl_weaponids[ i ][ "attachment" ];
        weapon_class_register( weapon, weapon_type );
        
        if ( isdefined( attachment ) && attachment != "" )
        {
            attachment_tokens = strtok( attachment, " " );
            
            if ( isdefined( attachment_tokens ) )
            {
                if ( attachment_tokens.size == 0 )
                {
                    weapon_class_register( weapon + "_" + attachment, weapon_type );
                    continue;
                }
                
                for ( k = 0; k < attachment_tokens.size ; k++ )
                {
                    weapon_class_register( weapon + "_" + attachment_tokens[ k ], weapon_type );
                }
            }
        }
    }
    
    callback::on_connecting( &on_player_connecting );
    callback::add_weapon_damage( level.weaponspecialdiscgun, &on_damage_special_discgun );
}

// Namespace loadout
// Params 5
// Checksum 0x13235f1a, Offset: 0x2408
// Size: 0x5c
function on_damage_special_discgun( eattacker, einflictor, weapon, meansofdeath, damage )
{
    if ( weapon != level.weaponspecialdiscgun )
    {
        return;
    }
    
    playsoundatposition( "wpn_disc_bounce_fatal", self.origin );
}

// Namespace loadout
// Params 0
// Checksum 0x16100275, Offset: 0x2470
// Size: 0xfc
function create_class_exclusion_list()
{
    currentdvar = 0;
    level.itemexclusions = [];
    
    while ( getdvarint( "item_exclusion_" + currentdvar ) )
    {
        level.itemexclusions[ currentdvar ] = getdvarint( "item_exclusion_" + currentdvar );
        currentdvar++;
    }
    
    level.attachmentexclusions = [];
    
    for ( currentdvar = 0; getdvarstring( "attachment_exclusion_" + currentdvar ) != "" ; currentdvar++ )
    {
        level.attachmentexclusions[ currentdvar ] = getdvarstring( "attachment_exclusion_" + currentdvar );
    }
}

// Namespace loadout
// Params 1
// Checksum 0x56e26c26, Offset: 0x2578
// Size: 0x68, Type: bool
function is_attachment_excluded( attachment )
{
    numexclusions = level.attachmentexclusions.size;
    
    for ( exclusionindex = 0; exclusionindex < numexclusions ; exclusionindex++ )
    {
        if ( attachment == level.attachmentexclusions[ exclusionindex ] )
        {
            return true;
        }
    }
    
    return false;
}

// Namespace loadout
// Params 0
// Checksum 0x3ef66feb, Offset: 0x25e8
// Size: 0x4c
function set_statstable_id()
{
    if ( !isdefined( level.statstableid ) )
    {
        statstablename = util::getstatstablename();
        level.statstableid = tablelookupfindcoreasset( statstablename );
    }
}

// Namespace loadout
// Params 1
// Checksum 0x5b3e2a1, Offset: 0x2640
// Size: 0x7c
function get_item_count( itemreference )
{
    set_statstable_id();
    itemcount = int( tablelookup( level.statstableid, 4, itemreference, 5 ) );
    
    if ( itemcount < 1 )
    {
        itemcount = 1;
    }
    
    return itemcount;
}

// Namespace loadout
// Params 2
// Checksum 0x3ba676f5, Offset: 0x26c8
// Size: 0xcc
function getdefaultclassslotwithexclusions( classname, slotname )
{
    itemreference = getdefaultclassslot( classname, slotname );
    set_statstable_id();
    itemindex = int( tablelookup( level.statstableid, 4, itemreference, 0 ) );
    
    if ( is_item_excluded( itemindex ) )
    {
        itemreference = tablelookup( level.statstableid, 0, 0, 4 );
    }
    
    return itemreference;
}

// Namespace loadout
// Params 2
// Checksum 0xaa24fae2, Offset: 0x27a0
// Size: 0x26
function load_default_loadout( weaponclass, classnum )
{
    level.classtoclassnum[ weaponclass ] = classnum;
}

// Namespace loadout
// Params 2
// Checksum 0x65673028, Offset: 0x27d0
// Size: 0x18c
function weapon_class_register( weaponname, weapon_type )
{
    if ( issubstr( "weapon_smg weapon_cqb weapon_assault weapon_lmg weapon_sniper weapon_shotgun weapon_launcher weapon_knife weapon_special", weapon_type ) )
    {
        level.primary_weapon_array[ getweapon( weaponname ) ] = 1;
        return;
    }
    
    if ( issubstr( "weapon_pistol", weapon_type ) )
    {
        level.side_arm_array[ getweapon( weaponname ) ] = 1;
        return;
    }
    
    if ( weapon_type == "weapon_grenade" )
    {
        level.grenade_array[ getweapon( weaponname ) ] = 1;
        return;
    }
    
    if ( weapon_type == "weapon_explosive" )
    {
        level.inventory_array[ getweapon( weaponname ) ] = 1;
        return;
    }
    
    if ( weapon_type == "weapon_rifle" )
    {
        level.inventory_array[ getweapon( weaponname ) ] = 1;
        return;
    }
    
    if ( weapon_type != "hero" )
    {
        assert( 0, "<dev string:x28>" + weapon_type );
    }
}

// Namespace loadout
// Params 1
// Checksum 0x99cf728f, Offset: 0x2968
// Size: 0x4a
function hero_register_dialog( weapon )
{
    readyvo = weapon.name + "_ready";
    game[ "dialog" ][ readyvo ] = readyvo;
}

// Namespace loadout
// Params 0
// Checksum 0x909a0343, Offset: 0x29c0
// Size: 0x5bc
function cac_init()
{
    level.tbl_weaponids = [];
    level.heroweaponstable = [];
    set_statstable_id();
    
    for ( i = 0; i < 256 ; i++ )
    {
        itemrow = tablelookuprownum( level.statstableid, 0, i );
        
        if ( itemrow > -1 )
        {
            group_s = tablelookupcolumnforrow( level.statstableid, itemrow, 2 );
            
            if ( issubstr( group_s, "weapon_" ) || group_s == "hero" )
            {
                reference_s = tablelookupcolumnforrow( level.statstableid, itemrow, 4 );
                
                if ( reference_s != "" )
                {
                    weapon = getweapon( reference_s );
                    
                    if ( weapon.inventorytype == "hero" )
                    {
                        level.heroweaponstable[ reference_s ] = [];
                        level.heroweaponstable[ reference_s ][ "index" ] = i;
                        hero_register_dialog( weapon );
                    }
                    
                    level.tbl_weaponids[ i ][ "reference" ] = reference_s;
                    level.tbl_weaponids[ i ][ "group" ] = group_s;
                    level.tbl_weaponids[ i ][ "count" ] = int( tablelookupcolumnforrow( level.statstableid, itemrow, 5 ) );
                    level.tbl_weaponids[ i ][ "attachment" ] = tablelookupcolumnforrow( level.statstableid, itemrow, 8 );
                }
            }
        }
    }
    
    level.perknames = [];
    level.perkicons = [];
    level.perkspecialties = [];
    
    for ( i = 0; i < 256 ; i++ )
    {
        itemrow = tablelookuprownum( level.statstableid, 0, i );
        
        if ( itemrow > -1 )
        {
            group_s = tablelookupcolumnforrow( level.statstableid, itemrow, 2 );
            
            if ( group_s == "specialty" )
            {
                reference_s = tablelookupcolumnforrow( level.statstableid, itemrow, 4 );
                
                if ( reference_s != "" )
                {
                    perkicon = tablelookupcolumnforrow( level.statstableid, itemrow, 6 );
                    perkname = tablelookupistring( level.statstableid, 0, i, 3 );
                    level.perknames[ perkicon ] = perkname;
                    perk_name = tablelookupcolumnforrow( level.statstableid, itemrow, 3 );
                    level.perkicons[ perk_name ] = perkicon;
                    level.perkspecialties[ perk_name ] = reference_s;
                    
                    /#
                        dev::add_perk_devgui( perkname, reference_s );
                    #/
                }
            }
        }
    }
    
    level.killstreaknames = [];
    level.killstreakicons = [];
    level.killstreakindices = [];
    
    for ( i = 0; i < 256 ; i++ )
    {
        itemrow = tablelookuprownum( level.statstableid, 0, i );
        
        if ( itemrow > -1 )
        {
            group_s = tablelookupcolumnforrow( level.statstableid, itemrow, 2 );
            
            if ( group_s == "killstreak" )
            {
                reference_s = tablelookupcolumnforrow( level.statstableid, itemrow, 4 );
                
                if ( reference_s != "" )
                {
                    level.tbl_killstreakdata[ i ] = reference_s;
                    level.killstreakindices[ reference_s ] = i;
                    icon = tablelookupcolumnforrow( level.statstableid, itemrow, 6 );
                    name = tablelookupistring( level.statstableid, 0, i, 3 );
                    level.killstreaknames[ reference_s ] = name;
                    level.killstreakicons[ reference_s ] = icon;
                    level.killstreakindices[ reference_s ] = i;
                }
            }
        }
    }
}

// Namespace loadout
// Params 1
// Checksum 0xa7b3dcbd, Offset: 0x2f88
// Size: 0x40
function getclasschoice( response )
{
    assert( isdefined( level.classmap[ response ] ) );
    return level.classmap[ response ];
}

// Namespace loadout
// Params 2
// Checksum 0x9fda5f30, Offset: 0x2fd0
// Size: 0x88
function getattachmentstring( weaponnum, attachmentnum )
{
    attachmentstring = getitemattachment( weaponnum, attachmentnum );
    
    if ( attachmentstring != "none" && !is_attachment_excluded( attachmentstring ) )
    {
        attachmentstring += "_";
    }
    else
    {
        attachmentstring = "";
    }
    
    return attachmentstring;
}

// Namespace loadout
// Params 0
// Checksum 0x382956c5, Offset: 0x3060
// Size: 0x1a
function getattachmentsdisabled()
{
    if ( !isdefined( level.attachmentsdisabled ) )
    {
        return 0;
    }
    
    return level.attachmentsdisabled;
}

// Namespace loadout
// Params 2
// Checksum 0xfde1aff8, Offset: 0x3088
// Size: 0x94
function getkillstreakindex( weaponclass, killstreaknum )
{
    killstreaknum++;
    killstreakstring = "killstreak" + killstreaknum;
    
    if ( getdvarint( "custom_killstreak_mode" ) == 2 )
    {
        return getdvarint( "custom_" + killstreakstring );
    }
    
    return self getloadoutitem( weaponclass, killstreakstring );
}

// Namespace loadout
// Params 0
// Checksum 0xa13713bc, Offset: 0x3128
// Size: 0x546
function givekillstreaks()
{
    self.killstreak = [];
    
    if ( !level.loadoutkillstreaksenabled )
    {
        return;
    }
    
    classnum = self.class_num_for_global_weapons;
    sortedkillstreaks = [];
    currentkillstreak = 0;
    
    for ( killstreaknum = 0; killstreaknum < level.maxkillstreaks ; killstreaknum++ )
    {
        killstreakindex = getkillstreakindex( classnum, killstreaknum );
        
        if ( isdefined( killstreakindex ) && killstreakindex > 0 )
        {
            assert( isdefined( level.tbl_killstreakdata[ killstreakindex ] ), "<dev string:x5b>" + killstreakindex + "<dev string:x69>" );
            
            if ( isdefined( level.tbl_killstreakdata[ killstreakindex ] ) )
            {
                self.killstreak[ currentkillstreak ] = level.tbl_killstreakdata[ killstreakindex ];
                
                if ( isdefined( level.usingmomentum ) && level.usingmomentum )
                {
                    killstreaktype = killstreaks::get_by_menu_name( self.killstreak[ currentkillstreak ] );
                    
                    if ( isdefined( killstreaktype ) )
                    {
                        weapon = killstreaks::get_killstreak_weapon( killstreaktype );
                        self giveweapon( weapon );
                        
                        if ( isdefined( level.usingscorestreaks ) && level.usingscorestreaks )
                        {
                            if ( weapon.iscarriedkillstreak )
                            {
                                if ( !isdefined( self.pers[ "held_killstreak_ammo_count" ][ weapon ] ) )
                                {
                                    self.pers[ "held_killstreak_ammo_count" ][ weapon ] = 0;
                                }
                                
                                if ( !isdefined( self.pers[ "held_killstreak_clip_count" ][ weapon ] ) )
                                {
                                    self.pers[ "held_killstreak_clip_count" ][ weapon ] = 0;
                                }
                                
                                if ( self.pers[ "held_killstreak_ammo_count" ][ weapon ] > 0 )
                                {
                                    self setweaponammoclip( weapon, self.pers[ "held_killstreak_clip_count" ][ weapon ] );
                                    self setweaponammostock( weapon, self.pers[ "held_killstreak_ammo_count" ][ weapon ] - self.pers[ "held_killstreak_clip_count" ][ weapon ] );
                                }
                                else
                                {
                                    self setweaponammooverall( weapon, 0 );
                                }
                            }
                            else
                            {
                                quantity = self.pers[ "killstreak_quantity" ][ weapon ];
                                
                                if ( !isdefined( quantity ) )
                                {
                                    quantity = 0;
                                }
                                
                                self setweaponammoclip( weapon, quantity );
                            }
                        }
                        
                        sortdata = spawnstruct();
                        sortdata.cost = level.killstreaks[ killstreaktype ].momentumcost;
                        sortdata.weapon = weapon;
                        sortindex = 0;
                        
                        for ( sortindex = 0; sortindex < sortedkillstreaks.size ; sortindex++ )
                        {
                            if ( sortedkillstreaks[ sortindex ].cost > sortdata.cost )
                            {
                                break;
                            }
                        }
                        
                        for ( i = sortedkillstreaks.size; i > sortindex ; i-- )
                        {
                            sortedkillstreaks[ i ] = sortedkillstreaks[ i - 1 ];
                        }
                        
                        sortedkillstreaks[ sortindex ] = sortdata;
                    }
                }
                
                currentkillstreak++;
            }
        }
    }
    
    actionslotorder = [];
    actionslotorder[ 0 ] = 4;
    actionslotorder[ 1 ] = 2;
    actionslotorder[ 2 ] = 1;
    
    if ( isdefined( level.usingmomentum ) && level.usingmomentum )
    {
        for ( sortindex = 0; sortindex < sortedkillstreaks.size && sortindex < actionslotorder.size ; sortindex++ )
        {
            if ( sortedkillstreaks[ sortindex ].weapon != level.weaponnone )
            {
                self setactionslot( actionslotorder[ sortindex ], "weapon", sortedkillstreaks[ sortindex ].weapon );
            }
        }
    }
}

// Namespace loadout
// Params 1
// Checksum 0xe75c382d, Offset: 0x3678
// Size: 0x2a, Type: bool
function isperkgroup( perkname )
{
    return isdefined( perkname ) && isstring( perkname );
}

// Namespace loadout
// Params 1
// Checksum 0x533e9206, Offset: 0x36b0
// Size: 0x18
function reset_specialty_slots( class_num )
{
    self.specialty = [];
}

// Namespace loadout
// Params 0
// Checksum 0x876a0fa9, Offset: 0x36d0
// Size: 0x10
function initstaticweaponstime()
{
    self.staticweaponsstarttime = gettime();
}

// Namespace loadout
// Params 1
// Checksum 0xafb972, Offset: 0x36e8
// Size: 0x36, Type: bool
function isequipmentallowed( equipment_name )
{
    if ( equipment_name == level.weapontacticalinsertion.name && level.disabletacinsert )
    {
        return false;
    }
    
    return true;
}

// Namespace loadout
// Params 1
// Checksum 0xa3d98562, Offset: 0x3728
// Size: 0x2e
function isleagueitemrestricted( item )
{
    if ( level.leaguematch )
    {
        return isitemrestricted( item );
    }
    
    return 0;
}

// Namespace loadout
// Params 2
// Checksum 0xb01c2b0e, Offset: 0x3760
// Size: 0x74
function giveloadoutlevelspecific( team, weaponclass )
{
    pixbeginevent( "giveLoadoutLevelSpecific" );
    
    if ( isdefined( level.givecustomcharacters ) )
    {
        self [[ level.givecustomcharacters ]]();
    }
    
    if ( isdefined( level.givecustomloadout ) )
    {
        self [[ level.givecustomloadout ]]();
    }
    
    pixendevent();
}

// Namespace loadout
// Params 1
// Checksum 0xc9a9bd06, Offset: 0x37e0
// Size: 0xa2
function giveloadout_init( takeallweapons )
{
    if ( takeallweapons )
    {
        self takeallweapons();
    }
    
    self.specialty = [];
    self.killstreak = [];
    self.primaryweaponkill = 0;
    self.secondaryweaponkill = 0;
    self.grenadetypeprimary = level.weaponnone;
    self.grenadetypeprimarycount = 0;
    self.grenadetypesecondary = level.weaponnone;
    self.grenadetypesecondarycount = 0;
    self notify( #"give_map" );
}

// Namespace loadout
// Params 0
// Checksum 0x457ea9b8, Offset: 0x3890
// Size: 0x22c
function giveperks()
{
    pixbeginevent( "givePerks" );
    self.specialty = self getloadoutperks( self.class_num );
    self setplayerstateloadoutbonuscards( self.class_num );
    self setplayerstateloadoutweapons( self.class_num );
    
    if ( level.leaguematch )
    {
        for ( i = 0; i < self.specialty.size ; i++ )
        {
            if ( isleagueitemrestricted( self.specialty[ i ] ) )
            {
                arrayremoveindex( self.specialty, i );
                i--;
            }
        }
    }
    
    self register_perks();
    anteup_bonus = getdvarint( "perk_killstreakAnteUpResetValue" );
    momentum_at_spawn_or_game_end = isdefined( self.pers[ "momentum_at_spawn_or_game_end" ] ) ? self.pers[ "momentum_at_spawn_or_game_end" ] : 0;
    hasnotdonecombat = !( self.hasdonecombat === 1 );
    
    if ( level.ingraceperiod && ( level.inprematchperiod || hasnotdonecombat ) && momentum_at_spawn_or_game_end < anteup_bonus )
    {
        new_momentum = self hasperk( "specialty_anteup" ) ? anteup_bonus : momentum_at_spawn_or_game_end;
        globallogic_score::_setplayermomentum( self, new_momentum, 0 );
    }
    
    pixendevent();
}

// Namespace loadout
// Params 1
// Checksum 0xd5f38cce, Offset: 0x3ac8
// Size: 0x1d4
function setclassnum( weaponclass )
{
    if ( issubstr( weaponclass, "CLASS_CUSTOM" ) )
    {
        pixbeginevent( "custom class" );
        self.class_num = int( weaponclass[ weaponclass.size - 1 ] ) - 1;
        
        if ( -1 == self.class_num )
        {
            self.class_num = 9;
        }
        
        self.class_num_for_global_weapons = self.class_num;
        self reset_specialty_slots( self.class_num );
        playerrenderoptions = self calcplayeroptions( self.class_num );
        self setplayerrenderoptions( playerrenderoptions );
        pixendevent();
    }
    else
    {
        pixbeginevent( "default class" );
        assert( isdefined( self.pers[ "<dev string:x7e>" ] ), "<dev string:x84>" );
        self.class_num = level.classtoclassnum[ weaponclass ];
        self.class_num_for_global_weapons = 0;
        self setplayerrenderoptions( 0 );
        pixendevent();
    }
    
    self recordloadoutindex( self.class_num );
}

// Namespace loadout
// Params 0
// Checksum 0x27ef5f50, Offset: 0x3ca8
// Size: 0xc0
function givebaseweapon()
{
    self.spawnweapon = level.weaponbasemeleeheld;
    knifeweaponoptions = self calcweaponoptions( self.class_num, 2 );
    self giveweapon( level.weaponbasemeleeheld, knifeweaponoptions );
    self.pers[ "spawnWeapon" ] = self.spawnweapon;
    switchimmediate = isdefined( self.alreadysetspawnweapononce );
    self setspawnweapon( self.spawnweapon, switchimmediate );
    self.alreadysetspawnweapononce = 1;
}

// Namespace loadout
// Params 0
// Checksum 0xab1880c1, Offset: 0x3d70
// Size: 0x60c
function giveweapons()
{
    pixbeginevent( "giveWeapons" );
    spawnweapon = level.weaponnull;
    initialweaponcount = 0;
    
    if ( isdefined( self.pers[ "weapon" ] ) && self.pers[ "weapon" ] != level.weaponnone && !self.pers[ "weapon" ].iscarriedkillstreak )
    {
        primaryweapon = self.pers[ "weapon" ];
    }
    else
    {
        primaryweapon = self getloadoutweapon( self.class_num, "primary" );
    }
    
    if ( primaryweapon.iscarriedkillstreak )
    {
        primaryweapon = level.weaponnull;
    }
    
    self.pers[ "primaryWeapon" ] = primaryweapon;
    
    if ( primaryweapon != level.weaponnull )
    {
        primaryweaponoptions = self calcweaponoptions( self.class_num, 0 );
        acvi = self getattachmentcosmeticvariantforweapon( self.class_num, "primary" );
        self giveweapon( primaryweapon, primaryweaponoptions, acvi );
        self weapons::bestweapon_spawn( primaryweapon, primaryweaponoptions, acvi );
        self.primaryloadoutweapon = primaryweapon;
        self.primaryloadoutaltweapon = primaryweapon.altweapon;
        self.primaryloadoutgunsmithvariantindex = self getloadoutgunsmithvariantindex( self.class_num, 0 );
        
        if ( self hasperk( "specialty_extraammo" ) )
        {
            self givemaxammo( primaryweapon );
        }
        
        spawnweapon = primaryweapon;
        initialweaponcount++;
    }
    
    sidearm = self getloadoutweapon( self.class_num, "secondary" );
    
    if ( sidearm.iscarriedkillstreak )
    {
        sidearm = level.weaponnull;
    }
    
    if ( sidearm.name == "bowie_knife" )
    {
        sidearm = level.weaponnull;
    }
    
    if ( sidearm != level.weaponnull )
    {
        secondaryweaponoptions = self calcweaponoptions( self.class_num, 1 );
        acvi = self getattachmentcosmeticvariantforweapon( self.class_num, "secondary" );
        self giveweapon( sidearm, secondaryweaponoptions, acvi );
        self.secondaryloadoutweapon = sidearm;
        self.secondaryloadoutaltweapon = sidearm.altweapon;
        self.secondaryloadoutgunsmithvariantindex = self getloadoutgunsmithvariantindex( self.class_num, 1 );
        
        if ( self hasperk( "specialty_extraammo" ) )
        {
            self givemaxammo( sidearm );
        }
        
        if ( spawnweapon == level.weaponnull )
        {
            spawnweapon = sidearm;
        }
        
        initialweaponcount++;
    }
    
    if ( !self hasmaxprimaryweapons() )
    {
        if ( !isusingt7melee() )
        {
            knifeweaponoptions = self calcweaponoptions( self.class_num, 2 );
            self giveweapon( level.weaponbasemeleeheld, knifeweaponoptions );
        }
        
        if ( initialweaponcount == 0 )
        {
            spawnweapon = level.weaponbasemeleeheld;
        }
    }
    
    if ( !isdefined( self.spawnweapon ) && isdefined( self.pers[ "spawnWeapon" ] ) )
    {
        self.spawnweapon = self.pers[ "spawnWeapon" ];
    }
    
    if ( isdefined( self.spawnweapon ) && doesweaponreplacespawnweapon( self.spawnweapon, spawnweapon ) && !self.pers[ "changed_class" ] )
    {
        spawnweapon = self.spawnweapon;
    }
    
    self thread initweaponattachments( spawnweapon );
    self.pers[ "changed_class" ] = 0;
    self.spawnweapon = spawnweapon;
    self.pers[ "spawnWeapon" ] = self.spawnweapon;
    switchimmediate = isdefined( self.alreadysetspawnweapononce );
    self setspawnweapon( spawnweapon, switchimmediate );
    self.alreadysetspawnweapononce = 1;
    self initstaticweaponstime();
    self bbclasschoice( self.class_num, primaryweapon, sidearm );
    pixendevent();
}

// Namespace loadout
// Params 0
// Checksum 0x6881a1e8, Offset: 0x4388
// Size: 0x2ec
function giveprimaryoffhand()
{
    pixbeginevent( "givePrimaryOffhand" );
    changedclass = self.pers[ "changed_class" ];
    roundbased = !util::isoneround();
    firstround = util::isfirstround();
    primaryoffhand = level.weaponnone;
    primaryoffhandcount = 0;
    
    if ( getdvarint( "gadgetEnabled" ) == 1 || getdvarint( "equipmentAsGadgets" ) == 1 )
    {
        primaryoffhand = self getloadoutweapon( self.class_num, "primaryGadget" );
        primaryoffhandcount = primaryoffhand.startammo;
    }
    else
    {
        primaryoffhandname = self getloadoutitemref( self.class_num, "primarygrenade" );
        
        if ( primaryoffhandname != "" && primaryoffhandname != "weapon_null" )
        {
            primaryoffhand = getweapon( primaryoffhand );
            primaryoffhandcount = self getloadoutitem( self.class_num, "primarygrenadecount" );
        }
    }
    
    if ( isleagueitemrestricted( primaryoffhand.name ) || !isequipmentallowed( primaryoffhand.name ) )
    {
        primaryoffhand = level.weaponnone;
        primaryoffhandcount = 0;
    }
    
    if ( primaryoffhand == level.weaponnone )
    {
        primaryoffhand = getweapon( "null_offhand_primary" );
        primaryoffhandcount = 0;
    }
    
    if ( primaryoffhand != level.weaponnull )
    {
        self giveweapon( primaryoffhand );
        self setweaponammoclip( primaryoffhand, primaryoffhandcount );
        self switchtooffhand( primaryoffhand );
        self.grenadetypeprimary = primaryoffhand;
        self.grenadetypeprimarycount = primaryoffhandcount;
        self ability_util::gadget_reset( primaryoffhand, changedclass, roundbased, firstround );
    }
    
    pixendevent();
}

// Namespace loadout
// Params 0
// Checksum 0xdd23e178, Offset: 0x4680
// Size: 0x2ec
function givesecondaryoffhand()
{
    pixbeginevent( "giveSecondaryOffhand" );
    changedclass = self.pers[ "changed_class" ];
    roundbased = !util::isoneround();
    firstround = util::isfirstround();
    secondaryoffhand = level.weaponnone;
    secondaryoffhandcount = 0;
    
    if ( getdvarint( "gadgetEnabled" ) == 1 || getdvarint( "equipmentAsGadgets" ) == 1 )
    {
        secondaryoffhand = self getloadoutweapon( self.class_num, "secondaryGadget" );
        secondaryoffhandcount = secondaryoffhand.startammo;
    }
    else
    {
        secondaryoffhandname = self getloadoutitemref( self.class_num, "specialgrenade" );
        
        if ( secondaryoffhandname != "" && secondaryoffhandname != "weapon_null" )
        {
            secondaryoffhand = getweapon( secondaryoffhand );
            secondaryoffhandcount = self getloadoutitem( self.class_num, "specialgrenadecount" );
        }
    }
    
    if ( isleagueitemrestricted( secondaryoffhand.name ) || !isequipmentallowed( secondaryoffhand.name ) )
    {
        secondaryoffhand = level.weaponnone;
        secondaryoffhandcount = 0;
    }
    
    if ( secondaryoffhand == level.weaponnone )
    {
        secondaryoffhand = getweapon( "null_offhand_secondary" );
        secondaryoffhandcount = 0;
    }
    
    if ( secondaryoffhand != level.weaponnull )
    {
        self giveweapon( secondaryoffhand );
        self setweaponammoclip( secondaryoffhand, secondaryoffhandcount );
        self switchtooffhand( secondaryoffhand );
        self.grenadetypesecondary = secondaryoffhand;
        self.grenadetypesecondarycount = secondaryoffhandcount;
        self ability_util::gadget_reset( secondaryoffhand, changedclass, roundbased, firstround );
    }
    
    pixendevent();
}

// Namespace loadout
// Params 0
// Checksum 0xfcd5d577, Offset: 0x4978
// Size: 0x31c
function givespecialoffhand()
{
    pixbeginevent( "giveSpecialOffhand" );
    changedclass = self.pers[ "changed_class" ];
    roundbased = !util::isoneround();
    firstround = util::isfirstround();
    classnum = self.class_num_for_global_weapons;
    specialoffhand = level.weaponnone;
    specialoffhandcount = 0;
    specialoffhand = self getloadoutweapon( self.class_num_for_global_weapons, "herogadget" );
    specialoffhandcount = specialoffhand.startammo;
    
    /#
        if ( getdvarstring( "<dev string:xb2>" ) != "<dev string:xcb>" )
        {
            herogagdetname = getdvarstring( "<dev string:xb2>" );
            specialoffhand = level.weaponnone;
            
            if ( herogagdetname != "<dev string:xcc>" )
            {
                specialoffhand = getweapon( herogagdetname );
            }
        }
    #/
    
    if ( isdefined( self.pers[ #"hash_65987563" ] ) )
    {
        assert( specialoffhand.name == "<dev string:xd8>" );
        specialoffhand = self.pers[ #"hash_65987563" ];
        roulette::gadget_roulette_give_earned_specialist( specialoffhand, 0 );
    }
    
    if ( isleagueitemrestricted( specialoffhand.name ) || !isequipmentallowed( specialoffhand.name ) )
    {
        specialoffhand = level.weaponnone;
        specialoffhandcount = 0;
    }
    
    if ( specialoffhand == level.weaponnone )
    {
        specialoffhand = level.weaponnull;
        specialoffhandcount = 0;
    }
    
    if ( specialoffhand != level.weaponnull )
    {
        self giveweapon( specialoffhand );
        self setweaponammoclip( specialoffhand, specialoffhandcount );
        self switchtooffhand( specialoffhand );
        self.grenadetypespecial = specialoffhand;
        self.grenadetypespecialcount = specialoffhandcount;
        self ability_util::gadget_reset( specialoffhand, changedclass, roundbased, firstround );
    }
    
    pixendevent();
}

// Namespace loadout
// Params 0
// Checksum 0x27818157, Offset: 0x4ca0
// Size: 0x224
function giveheroweapon()
{
    pixbeginevent( "giveHeroWeapon" );
    changedclass = self.pers[ "changed_class" ];
    roundbased = !util::isoneround();
    firstround = util::isfirstround();
    classnum = self.class_num_for_global_weapons;
    heroweapon = level.weaponnone;
    heroweaponname = self getloadoutitemref( self.class_num_for_global_weapons, "heroWeapon" );
    
    /#
        if ( getdvarstring( "<dev string:xe8>" ) != "<dev string:xcb>" )
        {
            heroweaponname = getdvarstring( "<dev string:xe8>" );
        }
    #/
    
    if ( heroweaponname != "" && heroweaponname != "weapon_null" )
    {
        if ( heroweaponname == "hero_minigun" )
        {
            model = self getcharacterbodymodel();
            
            if ( isdefined( model ) && issubstr( model, "body3" ) )
            {
                heroweaponname = "hero_minigun_body3";
            }
        }
        
        heroweapon = getweapon( heroweaponname );
    }
    
    if ( heroweapon != level.weaponnone )
    {
        self.heroweapon = heroweapon;
        self giveweapon( heroweapon );
        self ability_util::gadget_reset( heroweapon, changedclass, roundbased, firstround );
    }
    
    pixendevent();
}

// Namespace loadout
// Params 2
// Checksum 0x9fb6effa, Offset: 0x4ed0
// Size: 0x294
function giveloadout( team, weaponclass )
{
    pixbeginevent( "giveLoadout" );
    
    if ( isdefined( level.givecustomloadout ) )
    {
        spawnweapon = self [[ level.givecustomloadout ]]();
        
        if ( isdefined( spawnweapon ) )
        {
            self thread initweaponattachments( spawnweapon );
        }
        
        self.spawnweapon = spawnweapon;
    }
    else
    {
        self giveloadout_init( 1 );
        setclassnum( weaponclass );
        self setactionslot( 3, "altMode" );
        self setactionslot( 4, "" );
        allocationspent = self getloadoutallocation( self.class_num );
        overallocation = allocationspent > level.maxallocation;
        
        if ( !overallocation )
        {
            giveperks();
            giveweapons();
            giveprimaryoffhand();
        }
        else
        {
            givebaseweapon();
        }
        
        givesecondaryoffhand();
        
        if ( getdvarint( "tu11_enableClassicMode" ) == 0 )
        {
            givespecialoffhand();
            giveheroweapon();
        }
        
        givekillstreaks();
    }
    
    self teams::set_player_model( undefined, undefined );
    
    if ( isdefined( self.movementspeedmodifier ) )
    {
        self setmovespeedscale( self.movementspeedmodifier * self getmovespeedscale() );
    }
    
    self cac_selector();
    self giveloadout_finalize( self.spawnweapon, self.pers[ "primaryWeapon" ] );
    pixendevent();
}

// Namespace loadout
// Params 2
// Checksum 0x408b0f04, Offset: 0x5170
// Size: 0xbc
function giveloadout_finalize( spawnweapon, primaryweapon )
{
    if ( !isdefined( self.firstspawn ) )
    {
        if ( isdefined( spawnweapon ) )
        {
            self initialweaponraise( spawnweapon );
        }
        else
        {
            self initialweaponraise( primaryweapon );
        }
    }
    else
    {
        self seteverhadweaponall( 1 );
    }
    
    self.firstspawn = 0;
    self.switchedteamsresetgadgets = 0;
    self flagsys::set( "loadout_given" );
}

// Namespace loadout
// Params 2
// Checksum 0x262d3dda, Offset: 0x5238
// Size: 0xd4
function setweaponammooverall( weapon, amount )
{
    if ( weapon.iscliponly )
    {
        self setweaponammoclip( weapon, amount );
        return;
    }
    
    self setweaponammoclip( weapon, amount );
    diff = amount - self getweaponammoclip( weapon );
    assert( diff >= 0 );
    self setweaponammostock( weapon, diff );
}

// Namespace loadout
// Params 0
// Checksum 0x66f725dc, Offset: 0x5318
// Size: 0x9c
function on_player_connecting()
{
    if ( !isdefined( self.pers[ "class" ] ) )
    {
        self.pers[ "class" ] = "";
    }
    
    self.curclass = self.pers[ "class" ];
    self.lastclass = "";
    self.detectexplosives = 0;
    self.bombsquadicons = [];
    self.bombsquadids = [];
    self.reviveicons = [];
    self.reviveids = [];
}

// Namespace loadout
// Params 2
// Checksum 0x516a7b5e, Offset: 0x53c0
// Size: 0x40
function fadeaway( waitdelay, fadedelay )
{
    wait waitdelay;
    self fadeovertime( fadedelay );
    self.alpha = 0;
}

// Namespace loadout
// Params 1
// Checksum 0xeca5592d, Offset: 0x5408
// Size: 0x18
function setclass( newclass )
{
    self.curclass = newclass;
}

// Namespace loadout
// Params 0
// Checksum 0x7296d380, Offset: 0x5428
// Size: 0xf4
function initperkdvars()
{
    level.cac_armorpiercing_data = getdvarint( "perk_armorpiercing", 40 ) / 100;
    level.cac_bulletdamage_data = getdvarint( "perk_bulletDamage", 35 );
    level.cac_fireproof_data = getdvarint( "perk_fireproof", 20 );
    level.cac_armorvest_data = getdvarint( "perk_armorVest", 80 );
    level.cac_flakjacket_data = getdvarint( "perk_flakJacket", 35 );
    level.cac_flakjacket_hardcore_data = getdvarint( "perk_flakJacket_hardcore", 9 );
}

// Namespace loadout
// Params 0
// Checksum 0x9eeac2c2, Offset: 0x5528
// Size: 0x8e
function cac_selector()
{
    self.detectexplosives = 0;
    
    if ( isdefined( self.specialty ) )
    {
        perks = self.specialty;
        
        for ( i = 0; i < perks.size ; i++ )
        {
            perk = perks[ i ];
            
            if ( perk == "specialty_detectexplosive" )
            {
                self.detectexplosives = 1;
            }
        }
    }
}

// Namespace loadout
// Params 0
// Checksum 0xcb5b5876, Offset: 0x55c0
// Size: 0xf4
function register_perks()
{
    perks = self.specialty;
    self clearperks();
    
    for ( i = 0; i < perks.size ; i++ )
    {
        perk = perks[ i ];
        
        if ( perk == "specialty_null" || issubstr( perk, "specialty_weapon_" ) || perk == "weapon_null" )
        {
            continue;
        }
        
        if ( !level.perksenabled )
        {
            continue;
        }
        
        self setperk( perk );
    }
    
    /#
        dev::giveextraperks();
    #/
}

// Namespace loadout
// Params 6
// Checksum 0x1b5520eb, Offset: 0x56c0
// Size: 0x1ea
function cac_modified_vehicle_damage( victim, attacker, damage, meansofdeath, weapon, inflictor )
{
    if ( !isdefined( victim ) || !isdefined( attacker ) || !isplayer( attacker ) )
    {
        return damage;
    }
    
    if ( !isdefined( damage ) || !isdefined( meansofdeath ) || !isdefined( weapon ) )
    {
        return damage;
    }
    
    old_damage = damage;
    final_damage = damage;
    
    if ( attacker hasperk( "specialty_bulletdamage" ) && isprimarydamage( meansofdeath ) )
    {
        final_damage = damage * ( 100 + level.cac_bulletdamage_data ) / 100;
        
        /#
            if ( getdvarint( "<dev string:x101>" ) )
            {
                println( "<dev string:x10f>" + attacker.name + "<dev string:x117>" );
            }
        #/
    }
    else
    {
        final_damage = old_damage;
    }
    
    /#
        if ( getdvarint( "<dev string:x101>" ) )
        {
            println( "<dev string:x144>" + final_damage / old_damage + "<dev string:x15b>" + old_damage + "<dev string:x16b>" + final_damage );
        }
    #/
    
    return int( final_damage );
}

// Namespace loadout
// Params 7
// Checksum 0x7aa99c79, Offset: 0x58b8
// Size: 0x70c
function cac_modified_damage( victim, attacker, damage, mod, weapon, inflictor, hitloc )
{
    assert( isdefined( victim ) );
    assert( isdefined( attacker ) );
    assert( isplayer( victim ) );
    attacker_is_player = isplayer( attacker );
    
    if ( damage <= 0 )
    {
        return damage;
    }
    
    /#
        debug = 0;
        
        if ( getdvarint( "<dev string:x101>" ) )
        {
            debug = 1;
            
            if ( !isdefined( attacker.name ) )
            {
                attacker.name = "<dev string:x17c>";
            }
        }
    #/
    
    final_damage = damage;
    
    if ( victim != attacker )
    {
        if ( attacker_is_player && attacker hasperk( "specialty_bulletdamage" ) && isprimarydamage( mod ) )
        {
            if ( victim hasperk( "specialty_armorvest" ) && !isheaddamage( hitloc ) )
            {
                /#
                    if ( debug )
                    {
                        println( "<dev string:x10f>" + victim.name + "<dev string:x184>" + attacker.name + "<dev string:x198>" );
                    }
                #/
            }
            else
            {
                final_damage = damage * ( 100 + level.cac_bulletdamage_data ) / 100;
                
                /#
                    if ( debug )
                    {
                        println( "<dev string:x10f>" + attacker.name + "<dev string:x1b3>" + victim.name );
                    }
                #/
            }
        }
        else if ( victim hasperk( "specialty_armorvest" ) && isprimarydamage( mod ) && !isheaddamage( hitloc ) )
        {
            final_damage = damage * level.cac_armorvest_data * 0.01;
            
            /#
                if ( debug )
                {
                    println( "<dev string:x10f>" + attacker.name + "<dev string:x1d9>" + victim.name );
                }
            #/
        }
        else if ( victim hasperk( "specialty_fireproof" ) && isfiredamage( weapon, mod ) )
        {
            final_damage = damage * level.cac_fireproof_data * 0.01;
            
            /#
                if ( debug )
                {
                    println( "<dev string:x10f>" + attacker.name + "<dev string:x1fe>" + victim.name );
                }
            #/
        }
        else if ( victim hasperk( "specialty_flakjacket" ) && isexplosivedamage( mod ) && !weapon.ignoresflakjacket && !victim grenadestuck( inflictor ) )
        {
            cac_data = level.hardcoremode ? level.cac_flakjacket_hardcore_data : level.cac_flakjacket_data;
            
            if ( victim util::has_flak_jacket_perk_purchased_and_equipped() )
            {
                if ( level.teambased && attacker.team != victim.team )
                {
                    victim thread challenges::flakjacketprotectedmp( weapon, attacker );
                }
                else if ( attacker != victim )
                {
                    victim thread challenges::flakjacketprotectedmp( weapon, attacker );
                }
            }
            
            final_damage = int( damage * cac_data / 100 );
            
            /#
                if ( debug )
                {
                    println( "<dev string:x10f>" + victim.name + "<dev string:x21c>" + attacker.name + "<dev string:x236>" );
                }
            #/
        }
    }
    
    /#
        victim.cac_debug_damage_type = tolower( mod );
        victim.cac_debug_original_damage = damage;
        victim.cac_debug_final_damage = final_damage;
        victim.cac_debug_location = tolower( hitloc );
        victim.cac_debug_weapon = tolower( weapon.name );
        victim.cac_debug_range = int( distance( attacker.origin, victim.origin ) );
        
        if ( debug )
        {
            println( "<dev string:x144>" + final_damage / damage + "<dev string:x15b>" + damage + "<dev string:x16b>" + final_damage );
        }
    #/
    
    final_damage = int( final_damage );
    
    if ( final_damage < 1 )
    {
        final_damage = 1;
    }
    
    return final_damage;
}

// Namespace loadout
// Params 1
// Checksum 0xf4d9f7dc, Offset: 0x5fd0
// Size: 0x1a, Type: bool
function isexplosivedamage( meansofdeath )
{
    switch ( meansofdeath )
    {
        case "MOD_EXPLOSIVE":
        case "MOD_GRENADE":
        case "MOD_GRENADE_SPLASH":
        case "MOD_PROJECTILE":
        default:
            return true;
    }
}

// Namespace loadout
// Params 1
// Checksum 0x8c35470, Offset: 0x6028
// Size: 0x6a, Type: bool
function hastacticalmask( player )
{
    return player hasperk( "specialty_stunprotection" ) || player hasperk( "specialty_flashprotection" ) || player hasperk( "specialty_proximityprotection" );
}

// Namespace loadout
// Params 1
// Checksum 0x1e56d988, Offset: 0x60a0
// Size: 0x28, Type: bool
function isprimarydamage( meansofdeath )
{
    return meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET";
}

// Namespace loadout
// Params 1
// Checksum 0x3d3df362, Offset: 0x60d0
// Size: 0x38, Type: bool
function isbulletdamage( meansofdeath )
{
    return meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET" || meansofdeath == "MOD_HEAD_SHOT";
}

// Namespace loadout
// Params 3
// Checksum 0xc611d287, Offset: 0x6110
// Size: 0x7a, Type: bool
function isfmjdamage( sweapon, smeansofdeath, attacker )
{
    return isdefined( attacker ) && isplayer( attacker ) && attacker hasperk( "specialty_armorpiercing" ) && isdefined( smeansofdeath ) && isbulletdamage( smeansofdeath );
}

// Namespace loadout
// Params 2
// Checksum 0x76b21971, Offset: 0x6198
// Size: 0x60, Type: bool
function isfiredamage( weapon, meansofdeath )
{
    if ( meansofdeath == "MOD_BURNED" || meansofdeath == "MOD_GRENADE" || weapon.doesfiredamage && meansofdeath == "MOD_GRENADE_SPLASH" )
    {
        return true;
    }
    
    return false;
}

// Namespace loadout
// Params 1
// Checksum 0x78284d8e, Offset: 0x6200
// Size: 0x38, Type: bool
function isheaddamage( hitloc )
{
    return hitloc == "helmet" || hitloc == "head" || hitloc == "neck";
}

// Namespace loadout
// Params 1
// Checksum 0xa616eda, Offset: 0x6240
// Size: 0x3a, Type: bool
function grenadestuck( inflictor )
{
    return isdefined( inflictor ) && isdefined( inflictor.stucktoplayer ) && inflictor.stucktoplayer == self;
}

