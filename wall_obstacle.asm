; // ==================================
; // wall_obstacle.asm
; // ----------------------------------
; // Wall obstacles push the player off the screen. The player
; // must avoid them to avoid losing the game.
; // ==================================

INCLUDE default_header.inc
INCLUDE game_object.inc
INCLUDE game_object_ids.inc
INCLUDE scene.inc
INCLUDE wall_obstacle.inc
INCLUDE neon_square_player.inc
INCLUDE heap_functions.inc
INCLUDE input_manager.inc
INCLUDE transform_component.inc
INCLUDE rect_component.inc

END 