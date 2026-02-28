.386
.model flat, stdcall
option casemap : none
.stack 4096

include renderer.inc

.code
main PROC
	; // Simple barebones test
	call initializeRenderer
main ENDP
END main