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

; // State enums
GAME_MANAGER_STATE_ENUM typedef DWORD

DEFAULT_STATE_ENUM		= 0
TUNNEL_STATE_ENUM		= 1
STAIRCASE_STATE_ENUM	= 2
BARRIER_STATE_ENUM		= 3
PAUSE_STATE_ENUM		= 4


NeonGameManager STRUCT
	baseGameObject GameObject<>

	timer REAL4 ?

	state GAME_MANAGER_STATE_ENUM ?

	stateObjectCounter DWORD ?
NeonGameManager ENDS

; // Protos
init_neon_game_manager PROTO
new_neon_game_manager PROTO

ENDIF