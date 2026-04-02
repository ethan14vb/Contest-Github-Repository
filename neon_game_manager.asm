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

; // Irvine32 functions
RandomRange PROTO
Random32 PROTO

.data
NEON_GAME_MANAGER_GAMEOBJECT_VTABLE GameObject_vtable <OFFSET game_object_start, OFFSET neon_game_manager_update, OFFSET game_object_exit, OFFSET free_game_object>

; // Default state values
defaultSpawnTime REAL4 0.25
defaultStateObjectMin = 15
defaultStateObjectMax = 30

; // Tunnel state values
tunnelSpawnTime REAL4 0.25
tunnelStateObjectMin = 15
tunnelStateObjectMax = 30

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

	; // My constructor
	mov (NeonGameManager PTR [ecx]).timer, 0
	mov (NeonGameManager PTR [ecx]).state, DEFAULT_STATE_ENUM
	mov (NeonGameManager PTR [ecx]).stateObjectCounter, defaultStateObjectMin
		
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
	INVOKE init_neon_game_manager

	ret ; // Return with the address of the memory block in HeapAlloc
new_neon_game_manager ENDP

; // ********************************************
; // Instance methods
; // ********************************************

; // ----------------------------------
; // transition_state
; // Randomly decides what the next state will be
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
transition_state PROC USES eax ebx edx esi edi
	mov eax, 1
	INVOKE RandomRange

	.IF eax == DEFAULT_STATE_ENUM
		mov (NeonGameManager PTR [ecx]).state, DEFAULT_STATE_ENUM
		mov (NeonGameManager PTR [ecx]).timer, 0
		
		; // Get a random number of objects in this scene
		mov eax, defaultStateObjectMax
		sub eax, defaultStateObjectMin
		
		INVOKE RandomRange
		add eax, defaultStateObjectMin

		mov (NeonGameManager PTR [ecx]).stateObjectCounter, eax
	.ELSEIF eax == TUNNEL_STATE_ENUM
		mov (NeonGameManager PTR [ecx]).state, TUNNEL_STATE_ENUM
		mov (NeonGameManager PTR [ecx]).timer, 0
		
		; // Get a random number of objects in this scene
		mov eax, tunnelStateObjectMax
		sub eax, tunnelStateObjectMin
		
		INVOKE RandomRange
		add eax, tunnelStateObjectMin
			
		mov (NeonGameManager PTR [ecx]).stateObjectCounter, eax
	.ENDIF

	ret
transition_state ENDP

; // ----------------------------------
; // default_state_update
; // Spawns walls in random positions
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
default_state_update PROC stdcall USES eax ebx edx esi edi, deltaTime: REAL4
	local pThis : DWORD
	mov pThis, ecx

	; // Update timer
	fld (NeonGameManager PTR [ecx]).timer
    fadd deltaTime
    fst (NeonGameManager PTR [ecx]).timer

	; // Determine if the timer is greater than or equal to spawnTime
	fcomp defaultSpawnTime

	; // Get flags
	fnstsw ax
	sahf

	jb default_state_update_skip_spawn
   
	; // Set the timer to 0
    mov (NeonGameManager PTR [ecx]).timer, 0
    
	; // Spawn the obstacle
	mov ecx, pThis
	mov ecx, (GameObject PTR [ecx]).pParentScene

	mov eax, SCREEN_HEIGHT
	sub eax, 20

	INVOKE RandomRange

	INVOKE new_wall_obstacle, SCREEN_WIDTH, eax, 20
	
	mov ecx, pThis
	mov ecx, (GameObject PTR [ecx]).pParentScene

	INVOKE instantiate_game_object, eax

	mov ecx, pThis
	dec (NeonGameManager PTR [ecx]).stateObjectCounter

	mov ebx, (NeonGameManager PTR[ecx]).stateObjectCounter
	.IF ebx == 0
		INVOKE transition_state
	.ENDIF
    
default_state_update_skip_spawn:
	ret
default_state_update ENDP

; // ----------------------------------
; // tunnel_state_update
; // Spawns walls in tunnels
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
tunnel_state_update PROC stdcall USES eax ebx edx esi edi, deltaTime: REAL4
	local pThis : DWORD
	mov pThis, ecx

	; // Update timer
	fld (NeonGameManager PTR [ecx]).timer
    fadd deltaTime
    fst (NeonGameManager PTR [ecx]).timer

	; // Determine if the timer is greater than or equal to spawnTime
	fcomp tunnelSpawnTime

	; // Get flags
	fnstsw ax
	sahf

	jb tunnel_state_update_skip_spawn
   
	; // Set the timer to 0
    mov (NeonGameManager PTR [ecx]).timer, 0
    
	; // Spawn the obstacle
	mov ecx, pThis
	mov ecx, (GameObject PTR [ecx]).pParentScene

	mov eax, SCREEN_HEIGHT
	sub eax, 18

	INVOKE RandomRange
	add eax, 1

	mov ebx, eax ; // Store the random number in ebx

	; // Spawn the top wall
	INVOKE new_wall_obstacle, SCREEN_WIDTH, 0, ebx
	
	mov ecx, pThis
	mov ecx, (GameObject PTR [ecx]).pParentScene

	INVOKE instantiate_game_object, eax

	; // Now spawn the bottom wall
	add ebx, 17
	mov edx, SCREEN_WIDTH
	sub edx, ebx
	INVOKE new_wall_obstacle, SCREEN_WIDTH, ebx, edx

	mov ecx, pThis
	mov ecx, (GameObject PTR [ecx]).pParentScene

	INVOKE instantiate_game_object, eax

	; // Decrement the amount of objects left to spawn in this state
	mov ecx, pThis
	dec (NeonGameManager PTR [ecx]).stateObjectCounter

	mov ebx, (NeonGameManager PTR[ecx]).stateObjectCounter
	.IF ebx == 0
		INVOKE transition_state
	.ENDIF
    
	tunnel_state_update_skip_spawn:
	

	ret
tunnel_state_update ENDP

; // ----------------------------------
; // neon_game_manager_update
; // Moves the wall to the left of the screen. This function uses FPU instructions
; // that were not learned in class. These were added to accommodate for deltaTime
; // being a REAL4.
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
neon_game_manager_update PROC stdcall USES eax ebx edx esi edi, deltaTime: REAL4
	local pThis : DWORD
	mov pThis, ecx

	mov ebx, (NeonGameManager PTR[ecx]).state
	.IF ebx == DEFAULT_STATE_ENUM
		INVOKE default_state_update, deltaTime
	.ELSEIF ebx == TUNNEL_STATE_ENUM
		INVOKE tunnel_state_update, deltaTime
	.ENDIF
	
	ret
neon_game_manager_update ENDP

END 