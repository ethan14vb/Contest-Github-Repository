; // ==================================
; // neon_square_scene.asm
; // ----------------------------------
; // The main scene of our demo game for our engine: Neon Square
; // ==================================

INCLUDE default_header.inc
INCLUDE engine_types.inc
INCLUDE scene.inc
INCLUDE neon_square_player.inc
INCLUDE wall_obstacle.inc

.code
populate_neon_square_scene PROC PUBLIC USES eax ebx edx esi edi, pScene: DWORD
	local pThis : DWORD
	mov pThis, ecx
	; // Player Square
	INVOKE new_neon_square_player
	mov esi, eax

	mov ecx, pScene
	INVOKE instantiate_game_object, esi

	; // Wall Obstacle
	INVOKE new_wall_obstacle, SCREEN_WIDTH, 20, 20
	mov esi, eax

	mov ecx, pScene
	INVOKE instantiate_game_object, esi

	ret
populate_neon_square_scene ENDP

END
