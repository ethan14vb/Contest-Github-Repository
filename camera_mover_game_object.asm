; // ==================================
; // camera_mover_game_object.asm
; // ----------------------------------
; // The camera mover is a subclass of GameObject designed
; // to move the camera left and right depending on keyboard input.
; // ==================================

INCLUDE default_header.inc
INCLUDE camera_mover_game_object.inc
INCLUDE heap_functions.inc

.data
CAMERA_MOVER_GAMEOBJECT_VTABLE GameObject_vtable <OFFSET game_object_start, OFFSET camera_mover_update, OFFSET game_object_exit>

.code
; // ********************************************
; // Constructor Methods
; // ********************************************

; // ----------------------------------
; // init_camera_mover_game_object
; // Initializes memory with the contents of a CameraMoverGameObject
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
init_camera_mover_game_object PROC PUBLIC USES esi ebx edx
	; // Parent constructor
	INVOKE init_game_object, 0
	mov (GameObject PTR [ecx]).gameObjectType, CAMERA_MOVER_GAME_OBJECT_ID
	mov (GameObject PTR [ecx]).pVt, OFFSET CAMERA_MOVER_GAMEOBJECT_VTABLE

	mov (CameraMoverGameObject PTR [ecx]).moveSpeed, 1
		
	ret
init_camera_mover_game_object ENDP

; // ----------------------------------
; // init_camera_mover_game_object
; // Reserves heap space for the Object with parameters calls the initializer method
; // ----------------------------------
new_camera_mover_game_object PROC PUBLIC USES ecx
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF CameraMoverGameObject
	mov ecx, eax ; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE init_camera_mover_game_object

	ret ; // Return with the address of the memory block in HeapAlloc
new_camera_mover_game_object ENDP

; // ********************************************
; // Instance methods
; // ********************************************

; // ----------------------------------
; // camera_mover_update
; // Default blank update method for a GameObject
; // Can be left blank, or overriden by the virtual function table
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
camera_mover_update PROC stdcall, deltaTime: REAL4
	mov eax, deltaTime
	ret
camera_mover_update ENDP

END 