.386
.model flat, stdcall
option casemap : none
.stack 4096

Camera STRUCT
	x DWORD ?
	y DWORD ?
	h DWORD ? ; // Height
	w DWORD ? ; // Width
Camera ENDS

END
