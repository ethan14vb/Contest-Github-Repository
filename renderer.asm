.386
.model flat, stdcall
option casemap : none
.stack 4096

include engine_types.inc
SetConsoleOutputCP PROTO STDCALL : DWORD
SetConsoleMode     PROTO STDCALL : DWORD, : DWORD
GetStdHandle       PROTO STDCALL : DWORD

.data
STD_OUTPUT_HANDLE EQU -11
ENABLE_VIRTUAL_TERMINAL_PROCESSING EQU 4

CR = 13 ; // Carriage return
LF = 10 ; // Line feed
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
	mov edi, OFFSET outputTextBuffer ; // move destination text buffer to edi

	xor ebx, ebx ; // y_index = 0

y_loop:
	cmp ebx, SCREEN_HEIGHT
	jge done

	xor ecx, ecx ; // x_index = 0
x_loop:
	cmp ecx, SCREEN_WIDTH
	jge row_end

	; // Get top pixel
	; // ((y_index * SCREENWIDTH) + x_index) * 2
	mov eax, ebx
	imul eax, SCREEN_WIDTH
	add eax, ecx 
	shl eax, 2
	mov edx, [esi + eax] ; // edx is now the top pixel

	; // Get bottom pixel
	; // (((y_index + 1) * SCREENWIDTH) + x_index) * 2
	mov eax, ebx
	inc eax 
	imul eax, SCREEN_WIDTH
	add eax, ecx
	shl eax, 2
	mov eax, [esi + eax] ; // eax is now the bottom pixel

	; // Write character
	; // Write ESC[38;2;RRR;GGG;BBBm
	; // Write ESC[48;2;RRR;GGG;BBBm
	; // Write half block

	inc ecx
	jmp x_loop

row_end:
	; // Add newline
	mov byte PTR[edi], CR
	inc edi
	mov byte PTR[edi], LF
	inc edi

	add ebx, 2 ; // y += 2

	jmp y_loop


done: 
	ret
displayBuffer ENDP

; // This main method is for testing the renderer
main PROC
	; // Force output to be UTF-8
	invoke SetConsoleOutputCP, 65001 

	; // Enable virutal terminal processing (Required for RGB functionality)
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	invoke SetConsoleMode, eax, ENABLE_VIRTUAL_TERMINAL_PROCESSING

	xor eax, eax
	mov eax, OFFSET screenBuffer
	call displayBuffer
	xor eax, eax
main ENDP
END main