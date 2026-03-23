; // ==================================
; // renderer.asm
; // ----------------------------------
; // Responsible for determining how graphics should be displayed
; // and then displaying them to the terminal or other interface
; // that supports pixelated images.
; // ==================================

INCLUDE default_header.inc
INCLUDE engine_types.inc
INCLUDE renderer.inc
INCLUDE camera.inc
INCLUDE render_command.inc

; // ********************************************
; // Windows function prototypes
; // ********************************************
SetConsoleOutputCP PROTO STDCALL : DWORD ; // Used to change the output format to UTF-8

; // Used to enable virtual terminal processing for full RGB support
GetConsoleMode     PROTO STDCALL : DWORD, : DWORD
SetConsoleMode     PROTO STDCALL : DWORD, : DWORD

; // Windows functions for displaying the text buffer of RGB data.
; //	WriteConsoleA was chosen instead of the Irvine library functions because of its
; //	support for things like virtual terminal processing and greater flexibility.
GetStdHandle       PROTO STDCALL : DWORD
WriteConsoleA      PROTO STDCALL : DWORD, : DWORD, : DWORD, : DWORD, : DWORD

.data
; // Windows function data
STD_OUTPUT_HANDLE = -11
ENABLE_VIRTUAL_TERMINAL_PROCESSING = 4

ConsoleMode DD ?
hConsoleOutput DD ?
bytesWritten DD 0

; // Constants
CR = 13 ; // Carriage return
LF = 10 ; // Line feed
ESCP = 1Bh ; // ESC character

; // Renderer buffers
screenBuffer Pixel SCREEN_WIDTH * SCREEN_HEIGHT DUP(<0, 0, 0, 255>)
outputTextBuffer DB 100000 DUP(0); // Used for the displayBuffer PROC

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
; //	pBuffer DWORD - pointer to the new frame buffer to render. MUST BE SCREEN_WIDTH * SCREEN_HEIGHT!!!
; //
; // ----------------------------------
displayBuffer PROC PUBLIC USES esi edi ecx ebx, pBuffer:DWORD
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
	mov edx, pBuffer
	add edx, eax ; // edx is now the top pixel

	push edx

	; // Get bottom pixel
	; // (((y_index + 1) * SCREENWIDTH) + x_index) * 2
	mov eax, ebx
	inc eax 
	imul eax, SCREEN_WIDTH
	add eax, ecx
	shl eax, 2
	mov edx, pBuffer
	add edx, eax 

	mov eax, edx ; // eax is now the bottom pixel

	pop edx ; // restore the top pixel

	; // Write foreground ANSI prefix (ESC[38;2;RRR;GGG;BBB;m)
	mov BYTE PTR[edi], ESCP
	inc edi
	mov BYTE PTR[edi], '['
	inc edi
	mov BYTE PTR[edi], '3'
	inc edi
	mov BYTE PTR[edi], '8'
	inc edi
	mov BYTE PTR[edi], ';'
	inc edi
	mov BYTE PTR[edi], '2'
	inc edi
	mov BYTE PTR[edi], ';'
	inc edi

	push edx ; // push edx so we can use it
	mov edx, eax

	mov al, [edx]
	call writeByteInDecimal ; // Bottom RRR
	mov BYTE PTR[edi], ';'
	inc edi
	mov al, [edx + 1]
	call writeByteInDecimal ; // Bottom GGG
	mov BYTE PTR[edi], ';'
	inc edi
	mov al, [edx + 2]
	call writeByteInDecimal ; // Bottom BBB
	mov BYTE PTR[edi], 'm'
	inc edi

	pop edx ; // restore edx

	; // Write background ANSI prefix (ESC[48;2;RRR;GGG;BBB;m)
	mov BYTE PTR[edi], ESCP
	inc edi
	mov BYTE PTR[edi], '['
	inc edi
	mov BYTE PTR[edi], '4'
	inc edi
	mov BYTE PTR[edi], '8'
	inc edi
	mov BYTE PTR[edi], ';'
	inc edi
	mov BYTE PTR[edi], '2'
	inc edi
	mov BYTE PTR[edi], ';'
	inc edi
	mov al, [edx]
	call writeByteInDecimal; // Top RRR
	mov BYTE PTR[edi], ';'
	inc edi
	mov al, [edx + 1]
	call writeByteInDecimal; // Top GGG
	mov BYTE PTR[edi], ';'
	inc edi
	mov al, [edx + 2]
	call writeByteInDecimal; // Top BBB
	mov BYTE PTR[edi], 'm'
	inc edi

	; // Write half block
	mov BYTE PTR[edi], 0E2h
	inc edi
	mov BYTE PTR[edi], 096h
	inc edi
	mov BYTE PTR[edi], 084h
	inc edi

	inc ecx
	jmp x_loop

row_end:
	; // Add newline
	mov BYTE PTR[edi], CR
	inc edi
	mov BYTE PTR[edi], LF
	inc edi

	add ebx, 2 ; // y += 2

	jmp y_loop


done: 
	; // Clear RGB formatting
	mov BYTE PTR[edi], ESCP
	inc edi
	mov BYTE PTR[edi], '['
	inc edi
	mov BYTE PTR[edi], '0'
	inc edi
	mov BYTE PTR[edi], 'm'
	inc edi

	; // Call WriteConsoleA to display the frame here
	mov ebx, edi
	sub ebx, OFFSET outputTextBuffer

	INVOKE WriteConsoleA,
		hConsoleOutput,
		OFFSET outputTextBuffer,
		ebx, ; // msgLen
		OFFSET bytesWritten,
		0

	ret

displayBuffer ENDP

; // ----------------------------------
; // initializeRenderer
; // Initializes the console for rendering by switching to UTF-8 format and 
; // enabling virtual terminal processing for full RGB support.
; // 
; // ----------------------------------
initializeRenderer PROC PUBLIC USES eax
	; // Force output to be UTF-8
	INVOKE SetConsoleOutputCP, 65001

	; // Enable virutal terminal processing (Required for RGB functionality)
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov hConsoleOutput, eax

	; // Get the current terminal mode and OR it with ENABLE_VIRTUAL_TERMINAL_PROCESSING
	INVOKE GetConsoleMode, hConsoleOutput, OFFSET ConsoleMode
	or ConsoleMode, ENABLE_VIRTUAL_TERMINAL_PROCESSING
	INVOKE SetConsoleMode, hConsoleOutput, ConsoleMode

	ret
initializeRenderer ENDP

; // ----------------------------------
; // drawRect
; // Private helper. Draws a filled rectangle to the buffer.
; // Position is relative to camera (unless ignoreCamera set).
; // No clipping.
; // ----------------------------------
drawRect PROC PRIVATE USES esi edi ebx ecx edx, pTrans:DWORD, pRect:DWORD, pCamera:DWORD, pBuffer:DWORD
	local sx:DWORD, sy:DWORD, rw:DWORD, rh:DWORD, color:DWORD

	; // skip if not visible
	mov eax, (RectComponent PTR [pRect]).visible
	test eax, eax
	jz drawRect_done

	; // screen position
	mov ebx, pTrans
	mov eax, (TransformComponent PTR [ebx]).x
	mov edx, (TransformComponent PTR [ebx]).y

	mov ebx, pTrans
	.IF [ebx].TransformComponent.ignoreCamera == 0
		sub eax, (Camera PTR [pCamera]).x
		sub edx, (Camera PTR [pCamera]).y
	.ENDIF

	mov sx, eax
	mov sy, edx

	; // size
	mov eax, (RectComponent PTR [pRect]).w
	mov rw, eax
	mov eax, (RectComponent PTR [pRect]).h
	mov rh, eax

	; // build pixel dword (r g b a)
	movzx eax, (RectComponent PTR [pRect]).r
	movzx ebx, (RectComponent PTR [pRect]).g
	shl ebx, 8
	or eax, ebx
	movzx ebx, (RectComponent PTR [pRect]).b
	shl ebx, 16
	or eax, ebx
	movzx ebx, (RectComponent PTR [pRect]).a
	shl ebx, 24
	or eax, ebx
	mov color, eax

	; // draw loops
	mov esi, sy
	mov edx, sy
	add edx, rh
yloop_rect:
	cmp esi, edx
	jge drawRect_done
	mov eax, esi
	imul eax, SCREEN_WIDTH
	add eax, sx
	shl eax, 2
	add eax, pBuffer
	mov edi, eax
	mov ecx, rw
xloop_rect:
	mov eax, color
	mov [edi], eax
	add edi, 4
	dec ecx
	jnz xloop_rect
	inc esi
	jmp yloop_rect

drawRect_done:
	ret
drawRect ENDP

; // ----------------------------------
; // drawSprite
; // Private helper. Blits sprite to the buffer.
; // Position is relative to camera (unless ignoreCamera set).
; // Anchor point (originX/originY) is placed at transform position.
; // pTexture must point to a cellW*cellH Pixel buffer.
; // No flipping, no spritesheet stride, no clipping.
; // ----------------------------------
drawSprite PROC PRIVATE USES esi edi ebx ecx edx, pTrans:DWORD, pSprite:DWORD, pCamera:DWORD, pBuffer:DWORD
	local sx:DWORD, sy:DWORD, sw:DWORD, sh:DWORD, pTex:DWORD

	; // skip if not visible
	mov eax, (SpriteComponent PTR [pSprite]).visible
	test eax, eax
	jz drawSprite_done

	; // screen position
	mov ebx, pTrans
	mov eax, (TransformComponent PTR [ebx]).x
	mov edx, (TransformComponent PTR [ebx]).y

	.IF [ebx].TransformComponent.ignoreCamera == 0
		sub eax, (Camera PTR [pCamera]).x
		sub edx, (Camera PTR [pCamera]).y
	.ENDIF
	; // anchor at transform
	sub eax, (SpriteComponent PTR [pSprite]).originX
	sub edx, (SpriteComponent PTR [pSprite]).originY
	mov sx, eax
	mov sy, edx

	; // cell size
	mov eax, (SpriteComponent PTR [pSprite]).cellW
	mov sw, eax
	mov eax, (SpriteComponent PTR [pSprite]).cellH
	mov sh, eax

	; // texture pointer
	mov eax, (SpriteComponent PTR [pSprite]).pTexture
	mov pTex, eax

	; // draw loops
	mov esi, sy
	mov edx, sy
	add edx, sh
yloop_sprite:
	cmp esi, edx
	jge drawSprite_done
	mov eax, esi
	imul eax, SCREEN_WIDTH
	add eax, sx
	shl eax, 2
	add eax, pBuffer
	mov edi, eax
	; // source row in texture
	mov ebx, esi
	sub ebx, sy
	mov eax, sw
	imul ebx, eax
	shl ebx, 2
	add ebx, pTex
	mov ecx, sw
xloop_sprite:
	mov eax, [ebx]
	mov [edi], eax
	add ebx, 4
	add edi, 4
	dec ecx
	jnz xloop_sprite
	inc esi
	jmp yloop_sprite

drawSprite_done:
	ret
drawSprite ENDP

; // ----------------------------------
; // renderCommands
; // Takes the render commands list and camera position,
; // clears the RGB buffer to black, then draws every
; // sprite (and rect) to create the frame.
; // ----------------------------------
renderCommands PROC PUBLIC USES esi ecx edx, pRenderCommands:DWORD, numCommands:DWORD, pCamera:DWORD, pBuffer:DWORD
	; // clear buffer to black (r=0,g=0,b=0,a=255)
	mov ecx, SCREEN_WIDTH * SCREEN_HEIGHT
	mov edi, pBuffer
	mov eax, 0FF000000h
	rep stosd

	; // process each command
	mov esi, pRenderCommands
	mov ecx, numCommands
cmd_loop:
	cmp ecx, 0
	je render_done
	dec ecx
	mov edx, (RenderCommand PTR [esi]).rcType
	.IF edx == RC_RECT
		INVOKE drawRect, (RenderCommand PTR [esi]).pTransform, (RenderCommand PTR [esi]).pRenderable, pCamera, pBuffer
	.ELSEIF edx == RC_SPRITE
		INVOKE drawSprite, (RenderCommand PTR [esi]).pTransform, (RenderCommand PTR [esi]).pRenderable, pCamera, pBuffer
	.ENDIF
	add esi, SIZEOF RenderCommand
	jmp cmd_loop
render_done:
	ret
renderCommands ENDP

END
