; // ==================================
; // RectComponent
; // ----------------------------------
; // Defines how a GameObject should appear using a rectangle.
; // Should be used with a transform for proper functionality.
; // The origin is defined by a transform.
; // ==================================

INCLUDE default_header.inc
INCLUDE rect_component.inc
INCLUDE heap_functions.inc

.code
new_rect_component PROC PUBLIC, h: DWORD, w : DWORD, r : BYTE, g : BYTE, b : BYTE, a : BYTE
	mov eax, h
	mov eax, w
	mov al, r
	mov al, g
	mov al, b
	mov al, a
	ret
new_rect_component ENDP

free_rect_component PROC PUBLIC, pRect: DWORD
	mov eax, pRect
	ret
free_rect_component ENDP

END 
