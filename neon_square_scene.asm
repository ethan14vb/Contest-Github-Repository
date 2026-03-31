
INCLUDE default_header.inc
.code
populate_neon_square_scene PROC PUBLIC USES eax ebx edx esi edi, pScene: DWORD
	mov eax, pScene
	ret
populate_neon_square_scene ENDP

END
