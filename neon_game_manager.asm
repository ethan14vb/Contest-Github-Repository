; // ==================================
; // neon_game_manager.asm
; // ----------------------------------
; // A GameObject with logic that controls the NeonSquare game.
; // It is responsible for the spawning of obstacles that the
; // player must avoid.
; //
; // If there is time to implement it, this can also
; // handle logic like counting up the player's score or 
; // adjusting the difficulty over time.
; // ==================================
INCLUDE default_header.inc
INCLUDE engine_types.inc
INCLUDE game_object.inc
INCLUDE game_object_ids.inc
INCLUDE scene.inc
INCLUDE wall_obstacle.inc
INCLUDE neon_square_player.inc
INCLUDE heap_functions.inc
END 