; // ==================================
; // TransformComponent
; // ----------------------------------
; // Defines where in space a GameObject should be
; // represented.
; // ==================================

INCLUDE default_header.inc
INCLUDE transform_component.inc
INCLUDE heap_functions.inc

.code
; // ----------------------------------
; // init_transform_component
; // Initializes memory with the contents of a TransformComponent
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
init_transform_component PROC PUBLIC USES esi, x: DWORD, y : DWORD, ignoreCamera : DWORD
	mov esi, x
	mov (TransformComponent PTR [ecx]).x, esi
	mov esi, y
	mov (TransformComponent PTR [ecx]).y, esi
	mov esi, ignoreCamera
	mov (TransformComponent PTR [ecx]).ignoreCamera, esi
	ret
init_transform_component ENDP

new_transform_component PROC PUBLIC USES ecx, x: DWORD, y: DWORD, ignoreCamera: DWORD
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF TransformComponent
	mov ecx, eax ; // Move the memory address to eax so it can function as a "this" pointer
	INVOKE init_transform_component, x, y, ignoreCamera

	ret ; // Return with the address of the memory block in HeapAlloc
new_transform_component ENDP

free_transform_component PROC PUBLIC, pTransform: DWORD
	INVOKE HeapFree, hHeap, 0, pTransform
	ret
free_transform_component ENDP

END 
