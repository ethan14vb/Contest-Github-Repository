.386
.model flat, stdcall
option casemap : none
.stack 4096

GameObject STRUCT
	pComponents DWORD ?
GameObject ENDS

.code
game_object_start PROC
	ret
game_object_start ENDP

game_object_update PROC
	ret
game_object_update ENDP

game_object_exit PROC
	ret
game_object_exit ENDP

END