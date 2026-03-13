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

.code
main PROC PUBLIC
INVOKE ExitProcess, 0
main ENDP

END main
