; // ==================================
; // explosion_game_object.inc.asm
; // ----------------------------------
; // Appears large and opaque at first before fading away.
; // ==================================

IFNDEF EXPLOSION_GAME_OBJECT_INC
EXPLOSION_GAME_OBJECT_INC EQU 1

INCLUDE game_object.inc

Explosion STRUCT
	baseGameObject GameObject<>
Explosion ENDS

init_explosion_game_object PROTO x: DWORD, y: DWORD, radius: DWORD
new_explosion_game_object PROTO x: DWORD, y: DWORD, radius: DWORD

ENDIF