; // ==================================
; // TransformComponent
; // ----------------------------------
; // Defines where in space a GameObject should be
; // represented.
; // ==================================

IFNDEF TRANSFORM_COMPONENT_INC
TRANSFORM_COMPONENT_INC EQU 1

TransformComponent STRUCT
	x DWORD ?
	y DWORD ?

	; // Whether to ignore the camera offset when rendering.
	; // Used for drawing UI items
	ignoreCamera DWORD ?

	; // Out of scope for this project
	; // rotation DWORD ?
	; // scaleX DWORD ?
	; // scaleY DWORD ?
TransformComponent ENDS

ENDIF
