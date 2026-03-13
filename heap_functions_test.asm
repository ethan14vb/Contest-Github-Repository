; // ==================================
; // heap_functions_test.asm
; // ----------------------------------
; // For testing heap functionality
; //
; // Usage: 
; //	Exclude main.asm from the project and instead include this file, then build,
; // run, and feel free to debug and test.
; // ==================================

INCLUDE default_header.inc
INCLUDE heap_functions.inc

ExitProcess PROTO : DWORD

.data
hHeap HANDLE ?
pMemory DWORD ?

.code
main PROC PUBLIC
	INVOKE GetProcessHeap
	
	.IF eax == NULL
		jmp quit
	.ELSE 
		mov hHeap, eax
	.ENDIF

	quit:
	INVOKE ExitProcess, 0
main ENDP

END main
