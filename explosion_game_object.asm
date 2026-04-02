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

; // ----------------------------------
; // new_explosion_game_object
; // Reserves heap space for the Object with parameters calls the initializer method
; // ----------------------------------
new_explosion_game_object PROC PUBLIC USES ecx
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF Explosion
	mov ecx, eax ; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE init_explosion_game_object

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
	ret
explosion_update ENDP

END