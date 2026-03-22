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
	mov eax, x
	mov eax, y
	mov eax, ignoreCamera

	ret 
new_transform_component ENDP

free_transform_component PROC PUBLIC, pTransform: DWORD
	mov eax, pTransform

	ret 
free_transform_component ENDP

END 
