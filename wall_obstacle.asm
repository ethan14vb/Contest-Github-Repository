; // ==================================
; // wall_obstacle.asm
; // ----------------------------------
; // Wall obstacles push the player off the screen. The player
; // must avoid them to avoid losing the game.
; // ==================================

INCLUDE default_header.inc
INCLUDE game_object.inc
INCLUDE game_object_ids.inc
INCLUDE scene.inc
INCLUDE wall_obstacle.inc
INCLUDE neon_square_player.inc
INCLUDE heap_functions.inc
INCLUDE input_manager.inc
INCLUDE transform_component.inc
INCLUDE rect_component.inc

.data
WALL_OBSTACLE_GAMEOBJECT_VTABLE GameObject_vtable <OFFSET game_object_start, OFFSET game_object_update, OFFSET game_object_exit>

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
init_wall_obstacle PROC PUBLIC USES esi ebx edx
	local pThis
	mov pThis, ecx

	; // Parent constructor
	INVOKE init_game_object, 2
	mov (GameObject PTR [ecx]).gameObjectType, WALL_OBSTACLE_GAME_OBJECT_ID
	mov (GameObject PTR [ecx]).pVt, OFFSET WALL_OBSTACLE_GAMEOBJECT_VTABLE
		
	; // Add transform component
	INVOKE new_transform_component, 40, 25, 0
	INVOKE add_component, pThis, eax

	; // Add rect component
	INVOKE new_rect_component, 2, 2, 0, 0, 255, 255
	INVOKE add_component, pThis, eax

	mov eax, pThis
		
	ret
init_wall_obstacle ENDP

; // ----------------------------------
; // new_wall_obstacle
; // Reserves heap space for the Object with parameters calls the initializer method
; // ----------------------------------
new_wall_obstacle PROC PUBLIC USES ecx
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF WallObstacle
	mov ecx, eax ; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE init_wall_obstacle

	ret ; // Return with the address of the memory block in HeapAlloc
new_wall_obstacle ENDP

END 