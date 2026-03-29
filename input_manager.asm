; // ==================================
; // input_manager.asm
; // ----------------------------------
; // The input manager is responsible for determining
; // which keys are currently pressed and providing
; // a convenient method for other files to determine
; // the currently pressed keys. This should be
; // updated on a by-frame basis by a scene.
; // ==================================

INCLUDE default_header.inc
INCLUDE input_manager.inc

GetKeyboardState PROTO pBuffer : DWORD

.data
; // Holds the data for all 256 virtual keys and whether they are currently pressed
curInputBuffer BYTE 256 DUP(0)

; // Holds the data for the previous input buffer for determining if a key was just pressed
prevInputBuffer BYTE 256 DUP(0)

.code
; // ----------------------------------
; // updateInput
; // This should be called every frame by Scene. Updates the 
; // current and previous buffers.
; // ----------------------------------
updateInput PROC PUBLIC
	; // Copy the current buffer to the previous
	cld
    mov esi, OFFSET curInputBuffer
    mov edi, OFFSET prevInputBuffer
    mov ecx, 256
    rep movsb

	; // Get the current input state
	; // This is a Win32 API function that was added to the program before we learned about it
	; // during class. This function was used because it provided the greatest flexibility
	; // compared to the Irvine32 libraries for this engine.
	; // Documentation used: learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getkeyboardstate
	INVOKE GetKeyboardState, OFFSET curInputBuffer

	ret
updateInput ENDP

; // ----------------------------------
; // isKeyPressed
; // Returns 1 if a key is currently pressed and 0 if a key
; // is not currently pressed this frame.
; // ----------------------------------
isKeyPressed PROC PUBLIC, vkCode: DWORD
	mov al, [curInputBuffer + vkCode]
	test al, 80h ; // Test the high bit
	jz keyNotPressed

	; // Key is pressed, return 1
	mov eax, 1
	jmp exitIsKeyPressed

keyNotPressed:
	mov eax, 0

exitIsKeyPressed:
	ret
isKeyPressed ENDP

; // ----------------------------------
; // isKeyJustPressed
; // Returns 1 if a key is just pressed this frame and 0 if the key
; // was not just pressed this frame.
; // ----------------------------------
isKeyJustPressed PROC PUBLIC USES ebx, vkCode: DWORD
	mov al, [curInputBuffer + vkCode]
	mov bl, [prevInputBuffer + vkCode]

	test al, 80h ; // Test the high bit
	jz keyNotJustPressed
	
	; // Test if the key was also pressed last frame
	test bl, 80h
	jnz keyNotJustPressed

	; // Key was just pressed, return 1
	mov eax, 1
	jmp exitIsKeyJustPressed
		
keyNotJustPressed:
	mov eax, 0
exitIsKeyJustPressed:
	ret
isKeyJustPressed ENDP

END
