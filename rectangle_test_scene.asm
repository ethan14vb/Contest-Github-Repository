; // ==================================
; // rectangle_test_scene.asm
; // ----------------------------------
; // Data defining a scene to test the rendering of RectComponents.
; // ==================================

INCLUDE default_header.inc
INCLUDE rectangle_test_scene.inc

.data
RectTestScene_Data LABEL BYTE
	DWORD 1 ; // Just some test values
	DWORD 2
	DWORD 3

END
