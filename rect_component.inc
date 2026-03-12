; // ==================================
; // RectComponent
; // ----------------------------------
; // Defines how a GameObject should appear using a rectangle.
; // Should be used with a transform for proper functionality.
; // The origin is defined by a transform.
; // ==================================

IFNDEF RECT_COMMAND_INC
RECT_COMMAND_INC EQU 1

RectComponent STRUCT
	h DWORD ? ; // Height
	w DWORD ? ; // Width

	; // Color (For future development, this should be an RGBA object)
	; // For simplicity reasons, it is 4 bytes for now. 
	r BYTE ?
	g BYTE ?
	b BYTE ?
	a BYTE ?

	visible DWORD ?
RectComponent ENDS

ENDIF
