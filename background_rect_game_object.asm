; // ==================================
; // background_rect_game_object.inc
; // ----------------------------------
; // Rectangles that move in the background at different speeds
; // ==================================

INCLUDE default_header.inc
.code
init_background_rect_game_object PROC PUBLIC USES esi ebx edx
	local pThis
	mov pThis, ecx


	mov eax, pThis
		
	ret
init_background_rect_game_object ENDP

END 