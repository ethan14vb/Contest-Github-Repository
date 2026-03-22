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
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF RectComponent

	; // Height & Width
	mov esi, h
	mov (RectComponent PTR [eax]).h, esi
	mov esi, w
	mov (RectComponent PTR [eax]).w, esi

	; // RGBA
	mov al, r
	mov (RectComponent PTR [eax]).r, al
	mov al, g
	mov (RectComponent PTR [eax]).g, al
	mov al, b
	mov (RectComponent PTR [eax]).b, al
	mov al, a
	mov (RectComponent PTR [eax]).a, al

	ret ; // Return with the address of the memory block in HeapAlloc
new_rect_component ENDP

free_rect_component PROC PUBLIC, pRect: DWORD
	INVOKE HeapFree, hHeap, 0, pRect
	ret
free_rect_component ENDP

END 
