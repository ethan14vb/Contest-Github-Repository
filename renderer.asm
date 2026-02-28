.386
.model flat, stdcall
option casemap : none
.stack 4096

include engine_types.inc

SetConsoleOutputCP PROTO STDCALL : DWORD
SetConsoleMode     PROTO STDCALL : DWORD, : DWORD
GetStdHandle       PROTO STDCALL : DWORD
WriteConsoleA      PROTO STDCALL : DWORD, : DWORD, : DWORD, : DWORD, : DWORD

.data
; // Windows function data
STD_OUTPUT_HANDLE EQU -11
ENABLE_VIRTUAL_TERMINAL_PROCESSING EQU 4

hConsoleOutput dd ?
bytesWritten dd 0

; // Constants
CR = 13 ; // Carriage return
LF = 10 ; // Line feed
ESCP = 1Bh ; // ESC character

; // Renderer buffers
screenBuffer Pixel SCREEN_WIDTH * SCREEN_HEIGHT dup(<0, 0, 0, 255>)
outputTextBuffer db 100000 dup(0); // Used for the displayBuffer PROC

.code
; // ----------------------------------
; // writeByteInDecimal
; // Writes a single byte's decimal representation using ASCII characters into a buffer. 
; // 
; // Parameters: 
; //	AL - byte to print
; //    EDI - pointer to the buffer to write text to
; //
; // Registers changed:
; //	EDI - will be adjusted after prints. Does not add null terminator.
; // ----------------------------------
writeByteInDecimal PROC USES ebx
	; // divide by 100
	xor ah, ah
	mov bl, 100
	div bl

	cmp al, 0
	je print_tens

	; // print result (100s place)
	add al, '0' ; // Add 0x30 to display correct ASCII number representation
	mov [edi], al
	inc edi

print_tens:
	mov al, ah
	xor ah, ah

	mov bl, 10
	div bl

	cmp al, 0
	je print_ones

	; // print result (10s place)
	add al, '0'
	mov [edi], al
	inc edi

print_ones:
	; // print remainder (1s place)
	add ah, '0'
	mov[edi], ah	
	inc edi
	ret
writeByteInDecimal ENDP

; // ----------------------------------
; // displayBuffer
; // Renders an RGBA buffer to the screen using ASCII characters.
; // Intended to be used for frame by frame animation. 
; // 
; // Parameters: 
; //	EAX - pointer to the new frame buffer to render. MUST BE SCREEN_WIDTH * SCREEN_HEIGHT!!!
; //
; // ----------------------------------
PUBLIC displayBuffer
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

	; // Write foreground ANSI prefix (ESC[38;2;RRR;GGG;BBB;m)
	mov byte ptr[edi], ESCP
	inc edi
	mov byte ptr[edi], '['
	inc edi
	mov byte ptr[edi], '3'
	inc edi
	mov byte ptr[edi], '8'
	inc edi
	mov byte ptr[edi], ';'
	inc edi
	mov byte ptr[edi], '2'
	inc edi
	mov byte ptr[edi], ';'
	inc edi
	mov al, [eax]
	call writeByteInDecimal ; // Bottom RRR
	mov byte ptr[edi], ';'
	inc edi
	mov al, [eax + 1]
	call writeByteInDecimal ; // Bottom GGG
	mov byte ptr[edi], ';'
	inc edi
	mov al, [eax + 2]
	call writeByteInDecimal ; // Bottom BBB
	mov byte ptr[edi], 'm'
	inc edi

	; // Write background ANSI prefix (ESC[48;2;RRR;GGG;BBB;m)
	mov byte ptr[edi], ESCP
	inc edi
	mov byte ptr[edi], '['
	inc edi
	mov byte ptr[edi], '4'
	inc edi
	mov byte ptr[edi], '8'
	inc edi
	mov byte ptr[edi], ';'
	inc edi
	mov byte ptr[edi], '2'
	inc edi
	mov byte ptr[edi], ';'
	inc edi
	mov al, [edx]
	call writeByteInDecimal; // Top RRR
	mov byte ptr[edi], ';'
	inc edi
	mov al, [edx + 1]
	call writeByteInDecimal; // Top GGG
	mov byte ptr[edi], ';'
	inc edi
	mov al, [edx + 2]
	call writeByteInDecimal; // Top BBB
	mov byte ptr[edi], 'm'
	inc edi

	; // Write half block
	mov byte ptr[edi], 0E2h
	inc edi
	mov byte ptr[edi], 096h
	inc edi
	mov byte ptr[edi], 084h
	inc edi

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
	; // Call WriteConsoleA to display the frame here
	mov ebx, OFFSET outputTextBuffer
	sub ebx, edi

	invoke WriteConsoleA,
		hConsoleOutput,
		OFFSET outputTextBuffer,
		ebx, ; // msgLen
		OFFSET bytesWritten,
		0
	ret

displayBuffer ENDP

; // ----------------------------------
; // initializeRenderer
; // Initializes the console for rendering
; // Intended to be used for frame by frame animation. 
; // 
; // ----------------------------------
PUBLIC initializeRenderer
initializeRenderer PROC USES eax
	; // Force output to be UTF-8
	invoke SetConsoleOutputCP, 65001

	; // Enable virutal terminal processing (Required for RGB functionality)
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov hConsoleOutput, eax
	invoke SetConsoleMode, hConsoleOutput, ENABLE_VIRTUAL_TERMINAL_PROCESSING

	ret
initializeRenderer ENDP

END