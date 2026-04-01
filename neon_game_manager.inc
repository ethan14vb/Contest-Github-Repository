; // ==================================
; // neon_game_manager.inc
; // ----------------------------------
; // A GameObject with logic that controls the NeonSquare game.
; // It is responsible for the spawning of obstacles that the
; // player must avoid.
; //
; // If there is time to implement it, this can also
; // handle logic like counting up the player's score or 
; // adjusting the difficulty over time.
; // ==================================

IFNDEF NEON_GAME_MANAGER_INC
NEON_GAME_MANAGER_INC EQU 1

INCLUDE game_object.inc

NeonGameManager STRUCT
	baseGameObject GameObject<>
NeonGameManager ENDS

ENDIF