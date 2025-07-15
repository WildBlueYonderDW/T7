#using scripts/codescripts/struct;
#using scripts/shared/ai/zombie_utility;
#using scripts/shared/array_shared;
#using scripts/shared/callbacks_shared;
#using scripts/shared/clientfield_shared;
#using scripts/shared/flag_shared;
#using scripts/shared/spawner_shared;
#using scripts/shared/system_shared;
#using scripts/shared/util_shared;
#using scripts/zm/_zm;
#using scripts/zm/_zm_utility;

#namespace zm_cosmodrome_ffotd;

// Namespace zm_cosmodrome_ffotd
// Params 0
// Checksum 0x99ec1590, Offset: 0x2b0
// Size: 0x4
function main_start()
{
    
}

// Namespace zm_cosmodrome_ffotd
// Params 0
// Checksum 0x16df7916, Offset: 0x2c0
// Size: 0x5e4
function main_end()
{
    spawncollision( "collision_player_64x64x256", "collider", ( 189.68, 666.753, -208 ), ( 0, 45.4, 0 ) );
    spawncollision( "collision_player_wall_64x64x10", "collider", ( -48, 1135, -454 ), ( 0, 270, 0 ) );
    spawncollision( "collision_player_wall_64x64x10", "collider", ( -48, 1135, -390 ), ( 0, 270, 0 ) );
    spawncollision( "collision_player_wall_64x64x10", "collider", ( -48, 1135, -334 ), ( 0, 270, 0 ) );
    spawncollision( "collision_player_wall_64x64x10", "collider", ( -104, 1135, -454 ), ( 0, 270, 0 ) );
    spawncollision( "collision_player_wall_64x64x10", "collider", ( -104, 1135, -390 ), ( 0, 270, 0 ) );
    spawncollision( "collision_player_wall_64x64x10", "collider", ( -104, 1135, -334 ), ( 0, 270, 0 ) );
    spawncollision( "collision_player_wall_512x512x10", "collider", ( -1803.5, 1895, 333 ), ( 0, 0, 0 ) );
    spawncollision( "collision_player_wall_512x512x10", "collider", ( -1815.5, 1743, 333 ), ( 0, 0, 0 ) );
    spawncollision( "collision_player_wall_512x512x10", "collider", ( -1822.5, 1881, 333 ), ( 0, 0, 0 ) );
    spawncollision( "collision_player_wall_512x512x10", "collider", ( -1822.5, 1755, 333 ), ( 0, 0, 0 ) );
    spawncollision( "collision_player_wedge_32x256", "collider", ( -1541, 1648, 156 ), ( 0, 180, 0 ) );
    spawncollision( "collision_player_wall_512x512x10", "collider", ( -1303.83, 1560.5, 353 ), ( 0, 111.398, 0 ) );
    spawncollision( "collision_player_wall_512x512x10", "collider", ( -1254, 1717.5, 353 ), ( 0, 0, 0 ) );
    spawncollision( "collision_player_wall_512x512x10", "collider", ( -883, 2232, 5 ), ( 0, 0, 0 ) );
    spawncollision( "collision_player_wall_256x256x10", "collider", ( -883, 1728, -44 ), ( 0, 0, 0 ) );
    spawncollision( "collision_player_wall_512x512x10", "collider", ( 158, 2172, 5 ), ( 0, 0, 0 ) );
    spawncollision( "collision_player_ramp_256x24", "collider", ( 151, 1768, -40 ), ( 270, 82.546, 97.454 ) );
    spawncollision( "collision_player_ramp_256x24", "collider", ( 151, 1738, -40 ), ( 270, 82.546, 97.454 ) );
    spawncollision( "collision_player_64x64x256", "collider", ( -742.002, 866.631, 348 ), ( 0, 334.8, 0 ) );
    spawncollision( "collision_player_64x64x256", "collider", ( -760.949, 1008.22, 460.75 ), ( 0, 334.2, 0 ) );
    spawncollision( "collision_player_wall_256x256x10", "collider", ( 84, -173.5, -44 ), ( 0, 270, 0 ) );
    e_temp = spawncollision( "collision_clip_wall_128x128x10", "collider", ( -72, 1136, -421.5 ), ( 0, 270, 0 ) );
    e_temp disconnectpaths();
    spawncollision( "collision_clip_wall_128x128x10", "collider", ( -72, 1136, -373.5 ), ( 0, 270, 0 ) );
}

