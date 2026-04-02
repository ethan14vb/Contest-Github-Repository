; // ==================================
; // background_rect_game_object.inc
; // ----------------------------------
; // Rectangles that move in the background at different speeds
; // ==================================

IFNDEF BACKGROUND_RECT_GAME_OBJECT_INC
BACKGROUND_RECT_GAME_OBJECT_INC EQU 1

INCLUDE game_object.inc

BackgroundRect STRUCT
	baseGameObject GameObject<>
	speed DWORD ?
BackgroundRect ENDS

init_background_rect_game_object	PROTO x: DWORD, y: DWORD, h: DWORD, w: DWORD, r: BYTE, g: BYTE, b: BYTE, a: BYTE, layer: DWORD, speed: DWORD
new_background_rect_game_object		PROTO x: DWORD, y: DWORD, h: DWORD, w: DWORD, r: BYTE, g: BYTE, b: BYTE, a: BYTE, layer: DWORD, speed: DWORD

ENDIF