; // ==================================
; // rectangle_test_scene.asm
; // ----------------------------------
; // Initializes a scene to have two rectangles to test the rendering
; // capabilities for RectComponents.
; // ==================================

INCLUDE default_header.inc
INCLUDE rectangle_test_scene.inc

.code
; // ----------------------------------
; // populate_rectangle_test_scene
; // Call this method on an empty Scene to fill it
; // with the rectangle test scene contents.
; // ----------------------------------
populate_rectangle_test_scene PROC, pScene: DWORD
	mov eax, pScene ; // Dummy instruction to avoid MASM assemble time errors
	ret
populate_rectangle_test_scene ENDP

END
