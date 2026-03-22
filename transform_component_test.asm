; // ==================================
; // transform_component_test.asm
; // ----------------------------------
; // Tests if transforms can be created and freed
; //
; // Usage: 
; //	Exclude main.asm from the project and instead include this file, then build,
; // run, and feel free to debug and test.
; // ==================================

INCLUDE default_header.inc
INCLUDE transform_component.inc
INCLUDE heap_functions.inc

ExitProcess PROTO STDCALL : DWORD

.code
main PROC PUBLIC
	local pTrans : DWORD

	INVOKE initialize_heap

	; // Create the transform
	INVOKE new_transform_component, 1, 2, 0
	mov pTrans, eax

	; // do stuff with the transform
	mov edi, pTrans
	mov (TransformComponent PTR [edi]).x, 5

	; // Free the transform
	INVOKE free_transform_component, pTrans

	INVOKE ExitProcess, 0
	ret
main ENDP

END main
