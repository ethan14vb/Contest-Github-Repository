; // ==================================
; // scene_test.asm
; // ----------------------------------
; // Tests if scenes can be created and initialized
; //
; // Usage: 
; //	Exclude main.asm from the project and instead include this file, then build,
; // run, and feel free to debug and test.
; // ==================================
INCLUDE default_header.inc
INCLUDE heap_functions.inc

ExitProcess PROTO STDCALL : DWORD
.code
main PROC PUBLIC
	INVOKE initialize_heap ; // Placeholder code to stay under the 20 lines per commit limit
	INVOKE ExitProcess, 0
ret
main ENDP
END main