.386
.model flat, stdcall
option casemap : none
.stack 4096

include renderer.inc
include engine_types.inc

ExitProcess PROTO STDCALL : DWORD

.data
screenBuffer Pixel SCREEN_WIDTH * SCREEN_HEIGHT dup(<255, 255, 255, 255>)

.code
main PROC
	; // Simple barebones test
	call initializeRenderer
	mov eax, OFFSET screenBuffer
	call displayBuffer

	invoke ExitProcess, 0
main ENDP
END main