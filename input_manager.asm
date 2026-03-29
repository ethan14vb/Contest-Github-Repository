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

.data

; // Holds the data for all 256 virtual keys and whether they are currently pressed
curInputBuffer BYTE 256 DUP(0)

; // Holds the data for the previous input buffer for determining if a key was just pressed
prevInputBuffer BYTE 256 DUP(0)

.code
updateInput PROC
	; // Copy the current buffer to the previous
	cld
    mov esi, OFFSET curInputBuffer
    mov edi, OFFSET prevInputBuffer
    mov ecx, 256
    rep movsb
	ret
updateInput ENDP

END
