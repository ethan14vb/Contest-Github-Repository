; // ==================================
; // background_rect_game_object.inc
; // ----------------------------------
; // Rectangles that move in the background at different speeds
; // ==================================

INCLUDE default_header.inc
INCLUDE game_object.inc
INCLUDE game_object_ids.inc
INCLUDE background_rect_game_object.inc
INCLUDE heap_functions.inc
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

; // ----------------------------------
; // new_background_rect_game_object
; // Reserves heap space for the Object with parameters calls the initializer method
; // ----------------------------------
new_background_rect_game_object PROC PUBLIC USES ecx, x: DWORD, y: DWORD, h: DWORD, w: DWORD, r: BYTE, g: BYTE, b: BYTE, a: BYTE, layer: DWORD, speed: DWORD
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF BackgroundRect
	mov ecx, eax ; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE init_background_rect_game_object, x, y, h, w, r, g, b, a, layer, speed

	ret ; // Return with the address of the memory block in HeapAlloc
new_background_rect_game_object ENDP

; // ********************************************
; // Instance methods
; // ********************************************

; // ----------------------------------
; // background_rect_update
; // Moves the rect to the left of the screen
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
background_rect_update PROC stdcall USES eax ebx edx esi, deltaTime: REAL4
	local pThis : DWORD
	mov pThis, ecx
	mov eax, deltaTime ; // Use the deltaTime variable so MASM doesn't get angry and throw a compile time error

	mov esi, (BackgroundRect PTR [ecx]).speed
	neg esi

	; // Move myself
	INVOKE get_first_component_which_is_a, TRANSFORM_COMPONENT_ID
	add (TransformComponent PTR [eax]).x, esi
		
	mov ecx, pThis ; // Restore the THIS pointer
	ret
background_rect_update ENDP

END 