; // ==================================
; // background_rect_game_object.inc
; // ----------------------------------
; // Rectangles that move in the background at different speeds
; // ==================================

INCLUDE default_header.inc
INCLUDE game_object.inc
INCLUDE game_object_ids.inc

.data
BACKGROUND_RECT_GAMEOBJECT_VTABLE GameObject_vtable <OFFSET game_object_start, OFFSET game_object_update, OFFSET game_object_exit, OFFSET free_game_object>

.code
; // ********************************************
; // Constructor Methods
; // ********************************************

init_background_rect_game_object PROC PUBLIC USES esi ebx edx
	local pThis
	mov pThis, ecx

	; // Parent constructor
	INVOKE init_game_object, 2
	mov (GameObject PTR [ecx]).gameObjectType, BACKGROUND_RECT_GAME_OBJECT_ID
	mov (GameObject PTR [ecx]).pVt, OFFSET BACKGROUND_RECT_GAMEOBJECT_VTABLE

	mov eax, pThis
		
	ret
init_background_rect_game_object ENDP

END 