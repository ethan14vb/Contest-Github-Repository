; // ==================================
; // camera_mover_game_object.asm
; // ----------------------------------
; // The camera mover is a subclass of GameObject designed
; // to move the camera left and right depending on keyboard input.
; // ==================================

INCLUDE default_header.inc
INCLUDE game_object.inc
INCLUDE game_object_ids.inc
INCLUDE component.inc
INCLUDE component_ids.inc
INCLUDE heap_functions.inc

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
	ret
init_camera_mover_game_object ENDP

camera_mover_update PROC stdcall, deltaTime: REAL4
	mov eax, deltaTime
	ret
camera_mover_update ENDP

END 