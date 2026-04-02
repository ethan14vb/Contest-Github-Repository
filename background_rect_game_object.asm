; // ==================================
; // background_rect_game_object.inc
; // ----------------------------------
; // Rectangles that move in the background at different speeds
; // ==================================

INCLUDE default_header.inc
INCLUDE game_object.inc
INCLUDE game_object_ids.inc
INCLUDE background_rect_game_object.inc
INCLUDE transform_component.inc
INCLUDE rect_component.inc
INCLUDE renderable_component.inc

.data
BACKGROUND_RECT_GAMEOBJECT_VTABLE GameObject_vtable <OFFSET game_object_start, OFFSET game_object_update, OFFSET game_object_exit, OFFSET free_game_object>

.code
; // ********************************************
; // Constructor Methods
; // ********************************************

init_background_rect_game_object PROC PUBLIC USES esi ebx edx, x : DWORD, y : DWORD, h : DWORD, w : DWORD, r : BYTE, g : BYTE, b : BYTE, a : BYTE, layer : DWORD, speed : DWORD
	local pThis
	mov pThis, ecx

	; // Parent constructor
	INVOKE init_game_object, 2
	mov (GameObject PTR [ecx]).gameObjectType, BACKGROUND_RECT_GAME_OBJECT_ID
	mov (GameObject PTR [ecx]).pVt, OFFSET BACKGROUND_RECT_GAMEOBJECT_VTABLE

	; // My constructor
	mov esi, speed
	mov (BackgroundRect PTR [ecx]).speed, esi
		
	; // Add transform component
	INVOKE new_transform_component, x, y, 0
	INVOKE add_component, pThis, eax

	; // Add rect component
	INVOKE new_rect_component, h, w, r, g, b, a
	mov esi, layer
	mov (RenderableComponent PTR [eax]).layer, esi
	INVOKE add_component, pThis, eax

	mov eax, pThis
		
	ret
init_background_rect_game_object ENDP

END 