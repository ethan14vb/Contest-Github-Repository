; // ==================================
; // rectangle_test_scene.asm
; // ----------------------------------
; // Data defining a scene to test the rendering of RectComponents.
; // ==================================

INCLUDE default_header.inc
INCLUDE rectangle_test_scene.inc
INCLUDE component_ids.inc

.data
RectTestScene_Data LABEL BYTE ; // The label is set to BYTE so the data can be traversed with flexibility
	DWORD 1 ; // Just some test values
	DWORD 2
	DWORD 3

END
