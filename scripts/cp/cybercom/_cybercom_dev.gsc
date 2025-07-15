#using scripts/cp/cybercom/_cybercom_gadget;
#using scripts/cp/cybercom/_cybercom_tactical_rig;
#using scripts/cp/cybercom/_cybercom_util;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/flagsys_shared;
#using scripts/shared/system_shared;

#namespace cybercom_dev;

// Namespace cybercom_dev
// Params 4
// Checksum 0xc5b65aea, Offset: 0x318
// Size: 0x1c0
function function_a0e51d80( point, timesec, size, color )
{
    end = gettime() + timesec * 1000;
    halfwidth = int( size / 2 );
    l1 = point + ( halfwidth * -1, 0, 0 );
    l2 = point + ( halfwidth, 0, 0 );
    w1 = point + ( 0, halfwidth * -1, 0 );
    w2 = point + ( 0, halfwidth, 0 );
    h1 = point + ( 0, 0, halfwidth * -1 );
    h2 = point + ( 0, 0, halfwidth );
    
    while ( end > gettime() )
    {
        /#
            line( l1, l2, color, 1, 0, 1 );
            line( w1, w2, color, 1, 0, 1 );
            line( h1, h2, color, 1, 0, 1 );
        #/
        
        wait 0.05;
    }
}

/#

    // Namespace cybercom_dev
    // Params 0
    // Checksum 0xfdd5b616, Offset: 0x4e0
    // Size: 0x3c, Type: dev
    function cybercom_setupdevgui()
    {
        execdevgui( "<dev string:x28>" );
        level thread cybercom_devguithink();
    }

#/

// Namespace cybercom_dev
// Params 0
// Checksum 0x85bbaa5, Offset: 0x528
// Size: 0x108
function constantjuice()
{
    self notify( #"constantjuice" );
    self endon( #"constantjuice" );
    self endon( #"disconnect" );
    self endon( #"spawned" );
    
    while ( true )
    {
        wait 1;
        
        if ( isdefined( self.cybercom.var_ebeecfd5 ) && self.cybercom.var_ebeecfd5 )
        {
            continue;
        }
        
        if ( isdefined( self.cybercom.activecybercomweapon ) )
        {
            slot = self gadgetgetslot( self.cybercom.activecybercomweapon );
            var_d921672c = self gadgetcharging( slot );
            
            if ( var_d921672c )
            {
                self gadgetpowerchange( slot, 100 );
            }
        }
    }
}

// Namespace cybercom_dev
// Params 0
// Checksum 0x38569580, Offset: 0x638
// Size: 0x710
function cybercom_devguithink()
{
    setdvar( "devgui_cybercore", "" );
    setdvar( "devgui_cybercore_upgrade", "" );
    
    while ( true )
    {
        cmd = getdvarstring( "devgui_cybercore" );
        
        if ( cmd == "" )
        {
            wait 0.5;
            continue;
        }
        
        playernum = getdvarint( "scr_player_number" ) - 1;
        players = getplayers();
        
        if ( playernum >= players.size )
        {
            setdvar( "devgui_cybercore", "" );
            setdvar( "devgui_cybercore_upgrade", "" );
            iprintlnbold( "Invalid Player specified. Use SET PLAYER NUMBER in Cybercom DEVGUI to set valid player" );
            continue;
        }
        
        if ( cmd == "juiceme" )
        {
            setdvar( "devgui_cybercore", "" );
            setdvar( "devgui_cybercore_upgrade", "" );
            iprintlnbold( "Giving Constant Juice to all players" );
            
            foreach ( player in players )
            {
                player thread constantjuice();
            }
            
            continue;
        }
        
        if ( cmd == "clearAll" )
        {
            iprintlnbold( "Clearing all abilities on all players" );
            
            foreach ( player in players )
            {
                player cybercom_tacrig::takeallrigabilities();
                player cybercom_gadget::takeallabilities();
            }
            
            setdvar( "devgui_cybercore", "" );
            setdvar( "devgui_cybercore_upgrade", "" );
            continue;
        }
        
        if ( cmd == "giveAll" )
        {
            iprintlnbold( "Giving all abilities on all players" );
            
            foreach ( player in players )
            {
                player cybercom_gadget::function_edff667f();
            }
            
            setdvar( "devgui_cybercore", "" );
            setdvar( "devgui_cybercore_upgrade", "" );
            continue;
        }
        
        player = players[ playernum ];
        playernum++;
        upgrade = getdvarint( "devgui_cybercore_upgrade" );
        
        if ( cmd == "clearPlayer" )
        {
            iprintlnbold( "Clearing abilities on player: " + playernum );
            player cybercom_tacrig::takeallrigabilities();
            player cybercom_gadget::takeallabilities();
            setdvar( "devgui_cybercore", "" );
            setdvar( "devgui_cybercore_upgrade", "" );
            continue;
        }
        else if ( cmd == "control" )
        {
            setdvar( "devgui_cybercore", "" );
            setdvar( "devgui_cybercore_upgrade", "" );
            continue;
        }
        else if ( cmd == "martial" )
        {
            setdvar( "devgui_cybercore", "" );
            setdvar( "devgui_cybercore_upgrade", "" );
            continue;
        }
        else if ( cmd == "chaos" )
        {
            setdvar( "devgui_cybercore", "" );
            setdvar( "devgui_cybercore_upgrade", "" );
            continue;
        }
        
        if ( isdefined( level._cybercom_rig_ability[ cmd ] ) )
        {
            player cybercom_tacrig::giverigability( cmd, upgrade );
        }
        else
        {
            player cybercom_gadget::giveability( cmd, upgrade );
        }
        
        iprintlnbold( "Adding ability on player: " + playernum + " --> " + cmd + "  Upgraded:" + ( upgrade ? "TRUE" : "FALSE" ) );
        setdvar( "devgui_cybercore", "" );
        setdvar( "devgui_cybercore_upgrade", "" );
    }
}

