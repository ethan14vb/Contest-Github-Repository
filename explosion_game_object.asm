; // ==================================
; // explosion_game_object.asm
; // ----------------------------------
; // Appears large and opaque at first before fading away.
; // ==================================

INCLUDE default_header.inc
INCLUDE explosion_game_object.inc
INCLUDE transform_component.inc
INCLUDE rect_component.inc

.data
EXPLOSION_GAMEOBJECT_VTABLE GameObject_vtable <OFFSET game_object_start, OFFSET game_object_update, OFFSET game_object_exit, OFFSET free_game_object>

.code
; // ********************************************
; // Constructor Methods
; // ********************************************

; // ----------------------------------
; // init_neon_square_player
; // Initializes memory with the contents of a NeonSquarePlayer
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
init_explosion_game_object PROC PUBLIC USES esi ebx edx
	local pThis
	mov pThis, ecx

	; // Parent constructor
	INVOKE init_game_object, 2
	mov (GameObject PTR [ecx]).gameObjectType, EXPLOSION_GAME_OBJECT_ID
	mov (GameObject PTR [ecx]).pVt, OFFSET EXPLOSION_GAMEOBJECT_VTABLE

	; // Add transform component
	INVOKE new_transform_component, 20, 25, 0
	INVOKE add_component, pThis, eax

	; // Add rect component
	INVOKE new_rect_component, 2, 2, 0, 255, 0, 255
	INVOKE add_component, pThis, eax

	mov eax, pThis
		
	ret
init_explosion_game_object ENDP

END