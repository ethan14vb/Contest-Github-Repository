; // ==================================
; // wall_obstacle.asm
; // ----------------------------------
; // Wall obstacles push the player off the screen. The player
; // must avoid them to avoid losing the game.
; // ==================================

INCLUDE default_header.inc
INCLUDE engine_types.inc
INCLUDE game_object.inc
INCLUDE game_object_ids.inc
INCLUDE scene.inc
INCLUDE wall_obstacle.inc
INCLUDE neon_square_player.inc
INCLUDE heap_functions.inc
INCLUDE input_manager.inc
INCLUDE transform_component.inc
INCLUDE renderable_component.inc
INCLUDE rect_component.inc

.data
WALL_OBSTACLE_GAMEOBJECT_VTABLE GameObject_vtable <OFFSET wall_obstacle_start, OFFSET wall_obstacle_update, OFFSET game_object_exit, OFFSET free_game_object>

.code
; // ********************************************
; // Constructor Methods
; // ********************************************

; // ----------------------------------
; // init_wall_obstacle
; // Initializes memory with the contents of a WallObstacle
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
init_wall_obstacle PROC PUBLIC USES esi ebx edx, startX : DWORD, startY : DWORD, height : DWORD
	local pThis
	mov pThis, ecx

	; // Parent constructor
	INVOKE init_game_object, 2
	mov (GameObject PTR [ecx]).gameObjectType, WALL_OBSTACLE_GAME_OBJECT_ID
	mov (GameObject PTR [ecx]).pVt, OFFSET WALL_OBSTACLE_GAMEOBJECT_VTABLE

	; // My constructor
	mov (WallObstacle PTR [ecx]).pNeonPlayer, 0
		
	; // Add transform component
	INVOKE new_transform_component, startX, startY, 0
	INVOKE add_component, pThis, eax

	; // Add rect component
	INVOKE new_rect_component, height, 2, 0, 0, 255, 255
	INVOKE add_component, pThis, eax

	mov eax, pThis
		
	ret
init_wall_obstacle ENDP

; // ----------------------------------
; // new_wall_obstacle
; // Reserves heap space for the Object with parameters calls the initializer method
; // ----------------------------------
new_wall_obstacle PROC PUBLIC USES ecx, startX : DWORD, startY : DWORD, height : DWORD
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF WallObstacle
	mov ecx, eax ; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE init_wall_obstacle, startX, startY, height

	ret ; // Return with the address of the memory block in HeapAlloc
new_wall_obstacle ENDP

; // ********************************************
; // Instance methods
; // ********************************************

; // ----------------------------------
; // wall_obstacle_start
; // Initializes the wall obstacle once it is added to the scene
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
wall_obstacle_start PROC stdcall USES eax ebx edx
	local pThis : DWORD
	mov pThis, ecx

	; // Initialize pNeonPlayer with the player in the scene
	mov ecx, (GameObject PTR [ecx]).pParentScene
	INVOKE get_first_game_object_which_is_a, NEON_SQUARE_PLAYER_GAME_OBJECT_ID

	; // This operates by faith alone that there will be a NeonSquarePlayer in the scene before a WallObstacle is created.
	mov ecx, pThis
	mov (WallObstacle PTR [ecx]).pNeonPlayer, eax

	mov ecx, pThis ; // Restore the THIS pointer
	ret
wall_obstacle_start ENDP

; // ----------------------------------
; // wall_obstacle_update
; // Moves the wall to the left of the screen
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
wall_obstacle_update PROC stdcall USES eax ebx edx, deltaTime: REAL4
	local pThis : DWORD
	mov pThis, ecx
	mov eax, deltaTime ; // Use the deltaTime variable so MASM doesn't get angry and throw a compile time error

	; // Move the wall
	INVOKE get_first_component_which_is_a, TRANSFORM_COMPONENT_ID
	add (TransformComponent PTR [eax]).x, -1

	; // Check if I'm touching the player
	mov ebx, eax
	INVOKE get_first_component_which_is_a, RECT_COMPONENT_ID
	mov edx, eax

	mov ecx, (WallObstacle PTR [ecx]).pNeonPlayer
	INVOKE get_first_component_which_is_a, TRANSFORM_COMPONENT_ID
	mov esi, eax
	INVOKE get_first_component_which_is_a, RECT_COMPONENT_ID
	INVOKE check_rect_collision, edx, ebx, eax, esi

	.IF eax != 0
		; // Make the player invisible
		mov ecx, pThis
		mov ecx, (WallObstacle PTR [ecx]).pNeonPlayer
		INVOKE get_first_component_which_is_a, RECT_COMPONENT_ID
		mov (RenderableComponent PTR [eax]).visible, 0
	.ENDIF

	mov ecx, pThis
	INVOKE get_first_component_which_is_a, TRANSFORM_COMPONENT_ID
	; // If I'm past the edge of the screen, free me
	mov ebx, (TransformComponent PTR [eax]).x
	.IF ebx <= 1
		mov ebx, pThis
		mov ecx, (GameObject PTR [ebx]).pParentScene
		INVOKE queue_free_game_object, ebx
	.ENDIF
		
	mov ecx, pThis ; // Restore the THIS pointer
	ret
wall_obstacle_update ENDP

END 