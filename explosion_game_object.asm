; // ==================================
; // explosion_game_object.asm
; // ----------------------------------
; // Appears large and opaque at first before fading away.
; // ==================================

INCLUDE default_header.inc
INCLUDE heap_functions.inc
INCLUDE explosion_game_object.inc
INCLUDE transform_component.inc
INCLUDE rect_component.inc
INCLUDE renderable_component.inc

.data
EXPLOSION_GAMEOBJECT_VTABLE GameObject_vtable <OFFSET game_object_start, OFFSET explosion_update, OFFSET game_object_exit, OFFSET free_game_object>

.code
; // ********************************************
; // Constructor Methods
; // ********************************************

; // ----------------------------------
; // init_explosion_game_object
; // Initializes memory with the contents of an Explosion
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
init_explosion_game_object PROC PUBLIC USES esi ebx edx, x : DWORD, y : DWORD, radius : DWORD
	local pThis
	mov pThis, ecx

	; // Parent constructor
	INVOKE init_game_object, 2
	mov (GameObject PTR [ecx]).gameObjectType, EXPLOSION_GAME_OBJECT_ID
	mov (GameObject PTR [ecx]).pVt, OFFSET EXPLOSION_GAMEOBJECT_VTABLE

	; // Add transform component
	mov ebx, x
	mov eax, y
	sub ebx, 4
	sub eax, 4
	INVOKE new_transform_component, ebx, eax, 0
	INVOKE add_component, pThis, eax

	; // Add rect component
	mov ebx, radius
	INVOKE new_rect_component, radius, radius, 0, 255, 0, 255
	mov (RenderableComponent PTR [eax]).layer, 2
	INVOKE add_component, pThis, eax

	mov eax, pThis
		
	ret
init_explosion_game_object ENDP

; // ----------------------------------
; // new_explosion_game_object
; // Reserves heap space for the Object with parameters calls the initializer method
; // ----------------------------------
new_explosion_game_object PROC PUBLIC USES ecx, x: DWORD, y: DWORD, radius: DWORD
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF Explosion
	mov ecx, eax ; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE init_explosion_game_object, x, y, radius

	ret ; // Return with the address of the memory block in HeapAlloc
new_explosion_game_object ENDP


; // ********************************************
; // Instance methods
; // ********************************************

; // ----------------------------------
; // explosion_update
; // Moves the player up and down depending on keyboard input.
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
explosion_update PROC stdcall USES eax ebx edx, deltaTime: REAL4
	local pThis : DWORD
	mov pThis, ecx
	mov eax, deltaTime ; // Use the deltaTime variable so MASM doesn't get angry and throw a compile time error

	INVOKE get_first_component_which_is_a, RECT_COMPONENT_ID

	mov bl, (RectComponent PTR[eax]).a
	.IF bl > 20
		sub (RectComponent PTR [eax]).a, 20

	.ELSE
		mov (RectComponent PTR [eax]).a, 0
	.ENDIF

	mov ecx, pThis
	ret
explosion_update ENDP

END