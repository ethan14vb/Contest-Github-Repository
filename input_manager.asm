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
updateInput PROC
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

END
