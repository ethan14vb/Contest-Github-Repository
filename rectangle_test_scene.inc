; // ==================================
; // rectangle_test_scene.inc
; // ----------------------------------
; // Exposes the data pointer to the scene data described
; // in rectangle_test_scene.asm
; // ==================================

IFNDEF RECTANGLE_TEST_SCENE
RECTANGLE_TEST_SCENE EQU 1

EXTERNDEF RectTestScene_Data : BYTE 

ENDIF