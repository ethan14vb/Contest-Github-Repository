; // ==================================
; // neon_square_player.asm
; // ----------------------------------
; // The NeonSquarePlayer is a subclass of GameObject that functions
; // as the player in the NeonSquareScene.
; // ==================================

IFNDEF NEON_SQUARE_PLAYER_INC
NEON_SQUARE_PLAYER_INC EQU 1

INCLUDE game_object.inc

NeonSquarePlayer STRUCT
	baseGameObject GameObject<>
	isAlive DWORD ?
NeonSquarePlayer ENDS

init_neon_square_player PROTO
new_neon_square_player PROTO
neon_square_player_die PROTO

ENDIF