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
new_transform_component PROC PUBLIC, x: DWORD, y: DWORD, ignoreCamera: DWORD
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF TransformComponent

	mov esi, x
	mov (TransformComponent PTR [eax]).x, esi
	mov esi, y
	mov (TransformComponent PTR [eax]).y, esi
	mov esi, ignoreCamera
	mov (TransformComponent PTR [eax]).ignoreCamera, esi

	ret ; // Return with the address of the memory block in HeapAlloc
new_transform_component ENDP

free_transform_component PROC PUBLIC, pTransform: DWORD
	INVOKE HeapFree, hHeap, 0, pTransform
	ret
free_transform_component ENDP

END 
