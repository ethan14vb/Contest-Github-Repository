; // ==================================
; // game_objects_test.asm
; // ----------------------------------
; // Tests if GameObjects can be created and freed
; //
; // Usage: 
; //	Exclude main.asm from the project and instead include this file, then build,
; // run, and feel free to debug and test.
; // ==================================

INCLUDE default_header.inc
INCLUDE heap_functions.inc
INCLUDE transform_component.inc
INCLUDE rect_component.inc
INCLUDE game_object.inc

ExitProcess PROTO STDCALL : DWORD

.code
main PROC PUBLIC
	INVOKE initialize_heap
	INVOKE ExitProcess, 0
	ret
main ENDP

END main