.386
.model flat, stdcall
option casemap : none
.stack 4096

include engine_types.inc

.data
screenBuffer Pixel 80 * 25 dup(<0, 0, 0, 255>)

.code
main PROC
xor eax, eax
main ENDP
END main