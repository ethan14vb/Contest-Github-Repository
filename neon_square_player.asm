; // ==================================
; // neon_square_player.asm
; // ----------------------------------
; // The NeonSquarePlayer is a subclass of GameObject that functions
; // as the player in the NeonSquareScene.
; // ==================================

INCLUDE default_header.inc
INCLUDE game_object.inc
INCLUDE game_object_ids.inc
INCLUDE engine_types.inc
INCLUDE scene.inc
INCLUDE neon_square_player.inc
INCLUDE heap_functions.inc
INCLUDE input_manager.inc
INCLUDE transform_component.inc
INCLUDE rect_component.inc

.data
NEON_SQUARE_PLAYER_GAMEOBJECT_VTABLE GameObject_vtable <OFFSET game_object_start, OFFSET neon_square_player_update, OFFSET game_object_exit, OFFSET free_game_object>

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

	; // My class members
	mov (NeonSquarePlayer PTR [ecx]).isAlive, 0FFFFFFFFh

	; // Add transform component
	INVOKE new_transform_component, 20, 25, 0
	INVOKE add_component, pThis, eax

	; // Add rect component
	INVOKE new_rect_component, 2, 2, 0, 255, 0, 255
	INVOKE add_component, pThis, eax

	mov eax, pThis
		
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
neon_square_player_update PROC stdcall USES eax ebx edx, deltaTime: REAL4
	local pThis : DWORD, yMov : SDWORD, pTransform : DWORD, pRect : DWORD
	mov pThis, ecx
	mov eax, deltaTime ; // Use the deltaTime variable so MASM doesn't get angry and throw a compile time error

	mov yMov, 0

	; // Check if any of the keys are pressed
	INVOKE isKeyPressed, VK_GAMEPAD_LEFT_THUMBSTICK_UP
	mov ebx, eax
	INVOKE isKeyPressed, VK_GAMEPAD_DPAD_UP
	or ebx, eax
	INVOKE isKeyPressed, VK_UP
	or ebx, eax
	neg ebx
	shl ebx, 1 ; // Multiply the movement by 2 to speed things up
	add yMov, ebx
		 
	INVOKE isKeyPressed, VK_GAMEPAD_LEFT_THUMBSTICK_DOWN
	mov ebx, eax
	INVOKE isKeyPressed, VK_DOWN
	or ebx, eax
	INVOKE isKeyPressed, VK_GAMEPAD_DPAD_DOWN
	or ebx, eax
	shl ebx, 1 ; // Multiply the movement by 2 to speed things up
	add yMov, ebx

	; // Now move the player
	mov ecx, pThis
	INVOKE get_first_component_which_is_a, TRANSFORM_COMPONENT_ID
	mov pTransform, eax

	mov ebx, yMov
	add (TransformComponent PTR [eax]).y, ebx

	; // If I'm above the top of the screen, reset me to the top
	mov ebx, (TransformComponent PTR [eax]).y
	cmp ebx, 0
	jge neon_square_player_update_not_above_screen
	mov (TransformComponent PTR [eax]).y, 0
neon_square_player_update_not_above_screen:

	
	; // If I'm below the bottom of the screen, reset me to the bottom
	mov edx, eax
	mov ecx, pThis
	INVOKE get_first_component_which_is_a, RECT_COMPONENT_ID
	mov pRect, eax

	mov ebx, (TransformComponent PTR [edx]).y
	mov ecx, SCREEN_HEIGHT
	sub ecx, (RectComponent PTR [eax]).h
	.IF ebx > ecx
		mov (TransformComponent PTR [edx]).y, ecx
	.ENDIF

	mov ecx, pThis ; // Restore the THIS pointer
	mov eax, deltaTime
	ret
neon_square_player_update ENDP

END 