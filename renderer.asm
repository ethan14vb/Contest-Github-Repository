.386
.model flat, stdcall
option casemap : none
.stack 4096

include engine_types.inc

.data
screenBuffer Pixel SCREEN_WIDTH * SCREEN_HEIGHT dup(<0, 0, 0, 255>)

.code
; // ----------------------------------
; // displayBuffer
; // Renders an RGBA buffer to the screen using ASCII characters.
; // Intended to be used for frame by frame animation. 
; // This will render on top of the last contents of screenBuffer.
; // 
; // Parameters: 
; //	EAX - pointer to the new frame buffer to render. 
; //
; // Registers Clobbered: EAX
; // ----------------------------------

displayBuffer PROC

displayBuffer ENDP

main PROC
xor eax, eax
main ENDP
END main