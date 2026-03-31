; // ==================================
; // neon_square_player.asm
; // ----------------------------------
; // The NeonSquarePlayer is a subclass of GameObject that functions
; // as the player in the NeonSquareScene.
; // ==================================

INCLUDE default_header.inc
INCLUDE game_object.inc
INCLUDE game_object_ids.inc
INCLUDE scene.inc
INCLUDE neon_square_player.inc
INCLUDE heap_functions.inc
INCLUDE input_manager.inc
INCLUDE transform_component.inc
INCLUDE rect_component.inc

.data
NEON_SQUARE_PLAYER_GAMEOBJECT_VTABLE GameObject_vtable <OFFSET game_object_start, OFFSET neon_square_player_update, OFFSET game_object_exit>

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
init_neon_square_player PROC PUBLIC USES esi ebx edx
	local pThis
	mov pThis, ecx

	; // Parent constructor
	INVOKE init_game_object, 2
	mov (GameObject PTR [ecx]).gameObjectType, NEON_SQUARE_PLAYER_GAME_OBJECT_ID
	mov (GameObject PTR [ecx]).pVt, OFFSET NEON_SQUARE_PLAYER_GAMEOBJECT_VTABLE

	; // Add transform component
	INVOKE new_transform_component, 20, 40, 0
	INVOKE add_component, pThis, eax

	; // Add rect component
	INVOKE new_rect_component, 2, 2, 0, 255, 0, 255
	INVOKE add_component, pThis, eax
		
	ret
init_neon_square_player ENDP

; // ----------------------------------
; // new_neon_square_player
; // Reserves heap space for the Object with parameters calls the initializer method
; // ----------------------------------
new_neon_square_player PROC PUBLIC USES ecx
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF NeonSquarePlayer
	mov ecx, eax ; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE init_neon_square_player

	ret ; // Return with the address of the memory block in HeapAlloc
new_neon_square_player ENDP

; // ********************************************
; // Instance methods
; // ********************************************

; // ----------------------------------
; // neon_square_player_update
; // Moves the player up and down depending on keyboard input.
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
neon_square_player_update PROC stdcall USES eax, deltaTime: REAL4
	local pThis : DWORD, yMov : SDWORD
	mov pThis, ecx
	mov eax, deltaTime ; // Use the deltaTime variable so MASM doesn't get angry and throw a compile time error

	mov yMov, 0

	; // Check if any of the keys are pressed
	INVOKE isKeyPressed, VK_UP
	neg eax
	add yMov, eax

	INVOKE isKeyPressed, VK_DOWN
	add yMov, eax

	; // Now move the camera
	mov ecx, (GameObject PTR [ecx]).pParentScene
	lea ecx, (Scene PTR [ecx]).camera

	mov eax, yMov
	add (Camera PTR [ecx]).y, eax

	mov ecx, pThis ; // Restore the THIS pointer
	ret
neon_square_player_update ENDP

END 