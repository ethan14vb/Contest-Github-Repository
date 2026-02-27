.386
.model flat, stdcall
option casemap : none
.stack 4096

include engine_types.inc

.data
screenBuffer Pixel SCREEN_WIDTH * SCREEN_HEIGHT dup(<0, 0, 0, 255>)
outputTextBuffer db 100000 dup(0); // Used for the displayBuffer PROC

.code
; // ----------------------------------
; // displayBuffer
; // Renders an RGBA buffer to the screen using ASCII characters.
; // Intended to be used for frame by frame animation. 
; // This will render on top of the last contents of screenBuffer.
; // 
; // Parameters: 
; //	EAX - pointer to the new frame buffer to render. MUST BE SCREEN_WIDTH * SCREEN_HEIGHT!!!
; //
; // ----------------------------------
displayBuffer PROC USES esi edi ecx ebx
	mov esi, eax; // move source frame to esi
	mov edi, OFFSET outputTextBuffer ;// move destination text buffer to edi

	ret
displayBuffer ENDP

main PROC
	xor eax, eax
	mov eax, OFFSET screenBuffer
	call displayBuffer
	xor eax, eax
main ENDP
END main