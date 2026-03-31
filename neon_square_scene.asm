; // ==================================
; // neon_square_scene.asm
; // ----------------------------------
; // The main scene of our demo game for our engine: Neon Square
; // ==================================

INCLUDE default_header.inc

.code
populate_neon_square_scene PROC PUBLIC USES eax ebx edx esi edi, pScene: DWORD
	local pThis : DWORD
	mov pThis, ecx
	; // Player Square
	mov eax, pScene

	ret
populate_neon_square_scene ENDP

END
