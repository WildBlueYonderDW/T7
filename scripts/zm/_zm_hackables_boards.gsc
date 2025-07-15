#using scripts/codescripts/struct;
#using scripts/shared/array_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_zm_blockers;
#using scripts/zm/_zm_equip_hacker;
#using scripts/zm/_zm_score;
#using scripts/zm/_zm_utility;

#namespace zm_hackables_boards;

// Namespace zm_hackables_boards
// Params 0
// Checksum 0x4fb0f4fe, Offset: 0x190
// Size: 0x296
function hack_boards()
{
    windows = struct::get_array( "exterior_goal", "targetname" );
    
    for ( i = 0; i < windows.size ; i++ )
    {
        window = windows[ i ];
        struct = spawnstruct();
        spot = window;
        
        if ( isdefined( window.trigger_location ) )
        {
            spot = window.trigger_location;
        }
        
        org = zm_utility::groundpos( spot.origin ) + ( 0, 0, 4 );
        r = 96;
        h = 96;
        
        if ( isdefined( spot.radius ) )
        {
            r = spot.radius;
        }
        
        if ( isdefined( spot.height ) )
        {
            h = spot.height;
        }
        
        struct.origin = org + ( 0, 0, 48 );
        struct.radius = r;
        struct.height = h;
        struct.script_float = 2;
        struct.script_int = 0;
        struct.window = window;
        struct.no_bullet_trace = 1;
        struct.no_sight_check = 1;
        struct.dot_limit = 0.7;
        struct.no_touch_check = 1;
        struct.last_hacked_round = 0;
        struct.num_hacks = 0;
        zm_equip_hacker::register_pooled_hackable_struct( struct, &board_hack, &board_qualifier );
    }
}

// Namespace zm_hackables_boards
// Params 1
// Checksum 0x1e06e7dd, Offset: 0x430
// Size: 0x364
function board_hack( hacker )
{
    zm_equip_hacker::deregister_hackable_struct( self );
    num_chunks_checked = 0;
    last_repaired_chunk = undefined;
    
    if ( self.last_hacked_round != level.round_number )
    {
        self.last_hacked_round = level.round_number;
        self.num_hacks = 0;
    }
    
    self.num_hacks++;
    
    if ( self.num_hacks < 3 )
    {
        hacker zm_score::add_to_player_score( 100 );
    }
    else
    {
        cost = int( min( 300, hacker.score ) );
        
        if ( cost )
        {
            hacker zm_score::minus_to_player_score( cost );
        }
    }
    
    while ( true )
    {
        if ( zm_utility::all_chunks_intact( self.window, self.window.barrier_chunks ) )
        {
            break;
        }
        
        chunk = zm_utility::get_random_destroyed_chunk( self.window, self.window.barrier_chunks );
        
        if ( !isdefined( chunk ) )
        {
            break;
        }
        
        self.window thread zm_blockers::replace_chunk( self.window, chunk, undefined, 0, 1 );
        last_repaired_chunk = chunk;
        
        if ( isdefined( self.clip ) )
        {
            self.window.clip triggerenable( 1 );
            self.window.clip disconnectpaths();
        }
        else
        {
            zm_blockers::blocker_disconnect_paths( self.window.neg_start, self.window.neg_end );
        }
        
        util::wait_network_frame();
        num_chunks_checked++;
        
        if ( num_chunks_checked >= 20 )
        {
            break;
        }
    }
    
    if ( isdefined( self.window.zbarrier ) )
    {
        if ( isdefined( last_repaired_chunk ) )
        {
            while ( self.window.zbarrier getzbarrierpiecestate( last_repaired_chunk ) == "closing" )
            {
                wait 0.05;
            }
        }
    }
    else
    {
        while ( isdefined( last_repaired_chunk ) && last_repaired_chunk.state == "mid_repair" )
        {
            wait 0.05;
        }
    }
    
    zm_equip_hacker::register_pooled_hackable_struct( self, &board_hack, &board_qualifier );
    self.window notify( #"blocker_hacked" );
    self.window notify( #"no valid boards" );
}

// Namespace zm_hackables_boards
// Params 1
// Checksum 0xde0c4af9, Offset: 0x7a0
// Size: 0x66, Type: bool
function board_qualifier( player )
{
    if ( zm_utility::all_chunks_intact( self.window, self.window.barrier_chunks ) || zm_utility::no_valid_repairable_boards( self.window, self.window.barrier_chunks ) )
    {
        return false;
    }
    
    return true;
}

