SCREEN_WIDTH EQU 80
SCREEN_HEIGHT EQU 50

Sprite STRUCT ; Sprite is used for anything that should be rendered 
	posX DWORD ?
	posY DWORD ?
	artPtr DWORD ?
	sprWidth DWORD ?
	sprHeight DWORD ?
Sprite ENDS

Pixel STRUCT
    r BYTE ?
    g BYTE ?
    b BYTE ?
    a BYTE ?
Pixel ENDS