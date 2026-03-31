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
	; // Parent constructor
	INVOKE init_game_object, 2
	mov (GameObject PTR [ecx]).gameObjectType, NEON_SQUARE_PLAYER_GAME_OBJECT_ID
	mov (GameObject PTR [ecx]).pVt, OFFSET NEON_SQUARE_PLAYER_GAMEOBJECT_VTABLE
		
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
	local pThis : DWORD
	mov pThis, ecx
	mov eax, deltaTime ; // Use the deltaTime variable so MASM doesn't get angry and throw a compile time error
	ret
neon_square_player_update ENDP

END 