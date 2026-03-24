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
	DWORD 2 ; // Number of GameObjects

	; // GameObject 1: A red square
	DWORD 2 ; // Number of components
		; // Component 1: RectComponent
		DWORD RECT_COMPONENT_ID
		DWORD 5		; // Height
		DWORD 6		; // Width
		BYTE 255	; // r
		BYTE 0		; // g
		BYTE 0		; // b
		BYTE 255	; // a

		; // Component 2: TransformComponent
		DWORD TRANSFORM_COMPONENT_ID
		DWORD 10	; // x
		DWORD 10	; // y
		DWORD 0		; // ignoreCamera

	; // GameObject 2: A blue square
	DWORD 2 ; // Number of components
		; // Component 1: RectComponent
		DWORD RECT_COMPONENT_ID
		DWORD 6		; // Height
		DWORD 5		; // Width
		BYTE 0		; // r
		BYTE 0		; // g
		BYTE 255	; // b
		BYTE 255	; // a

		; // Component 2: TransformComponent
		DWORD TRANSFORM_COMPONENT_ID
		DWORD 40	; // x
		DWORD 10	; // y
		DWORD 0		; // ignoreCamera

END
