; // ==================================
; // neon_game_manager.asm
; // ----------------------------------
; // A GameObject with logic that controls the NeonSquare game.
; // It is responsible for the spawning of obstacles that the
; // player must avoid.
; //
; // If there is time to implement it, this can also
; // handle logic like counting up the player's score or 
; // adjusting the difficulty over time.
; // ==================================

INCLUDE default_header.inc
INCLUDE engine_types.inc
INCLUDE game_object.inc
INCLUDE game_object_ids.inc
INCLUDE scene.inc
INCLUDE wall_obstacle.inc
INCLUDE neon_square_player.inc
INCLUDE neon_game_manager.inc
INCLUDE heap_functions.inc

.data
NEON_GAME_MANAGER_GAMEOBJECT_VTABLE GameObject_vtable <OFFSET game_object_start, OFFSET game_object_update, OFFSET game_object_exit, OFFSET free_game_object>

.code
; // ********************************************
; // Constructor Methods
; // ********************************************

; // ----------------------------------
; // init_neon_game_manager
; // Initializes memory with the contents of a NeonGameManager
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
init_neon_game_manager PROC PUBLIC USES esi ebx edx
	local pThis
	mov pThis, ecx

	; // Parent constructor
	INVOKE init_game_object, 2
	mov (GameObject PTR [ecx]).gameObjectType, NEON_GAME_MANAGER_GAME_OBJECT_ID
	mov (GameObject PTR [ecx]).pVt, OFFSET NEON_GAME_MANAGER_GAMEOBJECT_VTABLE

	mov eax, pThis
		
	ret
init_neon_game_manager ENDP

; // ----------------------------------
; // new_neon_game_manager
; // Reserves heap space for the Object with parameters calls the initializer method
; // ----------------------------------
new_neon_game_manager PROC PUBLIC USES ecx
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF NeonGameManager
	mov ecx, eax ; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE new_neon_game_manager

	ret ; // Return with the address of the memory block in HeapAlloc
new_neon_game_manager ENDP

END 