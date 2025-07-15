#using scripts/codescripts/struct;
#using scripts/shared/animation_shared;
#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/scene_shared;
#using scripts/shared/system_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_load;
#using scripts/zm/_zm;
#using scripts/zm/_zm_utility;
#using scripts/zm/_zm_weapons;

#namespace zm_zod_traps;

// Namespace zm_zod_traps
// Params 0, eflags: 0x2
// Checksum 0xb7499ad7, Offset: 0x528
// Size: 0x34
function autoexec __init__sytem__()
{
    system::register( "zm_zod_traps", &__init__, undefined, undefined );
}

// Namespace zm_zod_traps
// Params 0
// Checksum 0x54cbfddc, Offset: 0x568
// Size: 0x94
function __init__()
{
    clientfield::register( "scriptmover", "trap_chain_state", 1, 2, "int", &update_chain_anims, 0, 0 );
    clientfield::register( "scriptmover", "trap_chain_location", 1, 2, "int", &location_func, 0, 0 );
}

// Namespace zm_zod_traps
// Params 7
// Checksum 0xf418ab20, Offset: 0x608
// Size: 0x17c
function update_chain_anims( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump )
{
    a_str_areaname = [];
    a_str_areaname[ 0 ] = "theater";
    a_str_areaname[ 1 ] = "slums";
    a_str_areaname[ 2 ] = "canals";
    a_str_areaname[ 3 ] = "pap";
    int_location = self clientfield::get( "trap_chain_location" );
    str_areaname = a_str_areaname[ int_location ];
    a_mdl_chain_active = getentarray( localclientnum, "fxanim_chain_trap", "targetname" );
    a_mdl_chain_active = array::filter( a_mdl_chain_active, 0, &filter_areaname, str_areaname );
    
    if ( a_mdl_chain_active.size > 0 )
    {
        array::thread_all( a_mdl_chain_active, &update_active_chain_anims, localclientnum, oldval, newval, bnewent, binitialsnap, fieldname );
    }
}

// Namespace zm_zod_traps
// Params 7
// Checksum 0x87806552, Offset: 0x790
// Size: 0x3c
function location_func( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump )
{
    
}

// Namespace zm_zod_traps
// Params 2
// Checksum 0x131b17f7, Offset: 0x7d8
// Size: 0x34, Type: bool
function filter_areaname( e_entity, str_areaname )
{
    if ( e_entity.script_noteworthy !== str_areaname )
    {
        return false;
    }
    
    return true;
}

// Namespace zm_zod_traps
// Params 7
// Checksum 0x632ce833, Offset: 0x818
// Size: 0x18e
function update_active_chain_anims( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump )
{
    self notify( #"update_active_chain_anims" );
    self endon( #"update_active_chain_anims" );
    mdl_chains_active = self;
    mdl_chains_active util::waittill_dobj( localclientnum );
    
    switch ( newval )
    {
        case 0:
            self thread scene_play( "p7_fxanim_zm_zod_chain_trap_symbol_off_bundle", self );
            break;
        case 1:
            mdl_chains_active show();
            scene::stop( "p7_fxanim_zm_zod_chain_trap_symbol_off_bundle" );
            self thread scene_play( "p7_fxanim_zm_zod_chain_trap_symbol_on_bundle", self );
            break;
        case 2:
            self scene::stop();
            mdl_chains_active thread function_a89bd6f9();
            break;
        case 3:
            while ( isdefined( self.trap_active ) )
            {
                wait 0.01;
            }
            
            self thread scene_play( "p7_fxanim_zm_zod_chain_trap_symbol_off_bundle", self );
            break;
    }
}

// Namespace zm_zod_traps
// Params 2
// Checksum 0xd7013c9d, Offset: 0x9b0
// Size: 0x7c
function scene_play( scene, mdl_pod )
{
    self notify( #"scene_play" );
    self endon( #"scene_play" );
    self scene::stop();
    self function_6221b6b9( scene, mdl_pod );
    self scene::stop();
}

// Namespace zm_zod_traps
// Params 2
// Checksum 0x532443a6, Offset: 0xa38
// Size: 0x3c
function function_6221b6b9( scene, mdl_pod )
{
    level endon( #"demo_jump" );
    self scene::play( scene, mdl_pod );
}

// Namespace zm_zod_traps
// Params 0
// Checksum 0x3ae9d485, Offset: 0xa80
// Size: 0x1ce
function function_a89bd6f9()
{
    self.trap_active = 1;
    self stopallloopsounds();
    self playsound( 0, "evt_chaintrap_start" );
    self playloopsound( "evt_chaintrap_loop", 0.5 );
    scene::stop( "p7_fxanim_zm_zod_chain_trap_symbol_on_bundle" );
    function_3f7430db();
    scene::play( self.var_b33065b0, self );
    self thread scene::play( self.var_68a0b25, self );
    n_start_time = getanimlength( self.var_b33065b0 );
    var_b13eaf00 = getanimlength( self.var_aec39a66 );
    n_time = 15;
    wait n_time;
    scene::stop( self.var_68a0b25 );
    scene::play( self.var_aec39a66, self );
    self thread scene::play( "p7_fxanim_zm_zod_chain_trap_symbol_off_bundle", self );
    self stopallloopsounds( 0.5 );
    self playloopsound( "evt_chaintrap_idle" );
    self.trap_active = undefined;
}

// Namespace zm_zod_traps
// Params 0
// Checksum 0xe7d8a97f, Offset: 0xc58
// Size: 0x112
function function_3f7430db()
{
    switch ( self.script_noteworthy )
    {
        case "pap":
            self.var_b33065b0 = "p7_fxanim_zm_zod_chain_trap_pap_start_bundle";
            self.var_68a0b25 = "p7_fxanim_zm_zod_chain_trap_pap_on_bundle";
            self.var_aec39a66 = "p7_fxanim_zm_zod_chain_trap_pap_end_bundle";
            break;
        case "canals":
            self.var_b33065b0 = "p7_fxanim_zm_zod_chain_trap_canal_start_bundle";
            self.var_68a0b25 = "p7_fxanim_zm_zod_chain_trap_canal_on_bundle";
            self.var_aec39a66 = "p7_fxanim_zm_zod_chain_trap_canal_end_bundle";
            break;
        case "slums":
            self.var_b33065b0 = "p7_fxanim_zm_zod_chain_trap_waterfront_start_bundle";
            self.var_68a0b25 = "p7_fxanim_zm_zod_chain_trap_waterfront_on_bundle";
            self.var_aec39a66 = "p7_fxanim_zm_zod_chain_trap_waterfront_end_bundle";
            break;
        case "theater":
        default:
            self.var_b33065b0 = "p7_fxanim_zm_zod_chain_trap_footlight_start_bundle";
            self.var_68a0b25 = "p7_fxanim_zm_zod_chain_trap_footlight_on_bundle";
            self.var_aec39a66 = "p7_fxanim_zm_zod_chain_trap_footlight_end_bundle";
            break;
    }
}

