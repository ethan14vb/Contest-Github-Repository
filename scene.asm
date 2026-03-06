.386
.model flat, stdcall
option casemap : none
.stack 4096

Scene STRUCT
	pGameObjects DWORD ? ; // Linked list containing game objects
Scene ENDS

.code
scene_start PROC
	ret
scene_start ENDP

scene_update PROC
	ret
scene_update ENDP

scene_exit PROC
	ret
scene_exit ENDP

END
