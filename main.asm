; // ==================================
; // main.asm
; // ----------------------------------
; // The entry point of the program. Right now it is nonfunctional, but main.asm
; // will be responsible for updating the currently running scene and the inialization
; // of the engine.
; // ==================================

INCLUDE default_header.inc

ExitProcess PROTO STDCALL : DWORD

.code
main PROC PUBLIC
	; // Eventually, this is where the main loop and heart of the engine will be.
	invoke ExitProcess, 0
main ENDP

END main
