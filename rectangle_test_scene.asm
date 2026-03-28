; // ==================================
; // rectangle_test_scene.asm
; // ----------------------------------
; // Initializes a scene to have two rectangles to test the rendering
; // capabilities for RectComponents.
; // ==================================

INCLUDE default_header.inc
INCLUDE rectangle_test_scene.inc
INCLUDE transform_component.inc
INCLUDE rect_component.inc
INCLUDE game_object.inc
INCLUDE scene.inc

.code
; // ----------------------------------
; // populate_rectangle_test_scene
; // Call this method on an empty Scene to fill it
; // with the rectangle test scene contents.
; // ----------------------------------
populate_rectangle_test_scene PROC PUBLIC USES eax ebx edx esi edi, pScene: DWORD
	; // Red Rectangle
	INVOKE new_game_object, 2
	mov ecx, eax

	INVOKE new_transform_component, 10, 10, 0
	INVOKE add_component, ecx, eax

	INVOKE new_rect_component, 5, 6, 255, 0, 0, 255
	INVOKE add_component, ecx, eax

	mov esi, ecx
	mov ecx, pScene
	INVOKE instantiate_game_object, esi

	; // Blue Rectangle
	INVOKE new_game_object, 2
	mov ecx, eax

	INVOKE new_transform_component, 30, 10, 0
	INVOKE add_component, ecx, eax

	INVOKE new_rect_component, 6, 5, 0, 0, 255, 255
	INVOKE add_component, ecx, eax

	mov esi, ecx
	mov ecx, pScene
	INVOKE instantiate_game_object, esi

	ret
populate_rectangle_test_scene ENDP

END
