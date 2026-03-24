; // ==================================
; // component_ids_test.asm
; // ----------------------------------
; // For testing that the macros are defined correctly
; //
; // Usage: 
; //	Exclude main.asm from the project and instead include this file, then build,
; // run, and feel free to debug and test.
; // ==================================
INCLUDE default_header.inc
ExitProcess PROTO : DWORD
.code
main PROC PUBLIC
INVOKE ExitProcess, 0
main ENDP
END main