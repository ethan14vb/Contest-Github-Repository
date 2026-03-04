.386
.model flat, stdcall
option casemap : none
.stack 4096

ExitProcess PROTO STDCALL : DWORD

.code
main PROC
invoke ExitProcess, 0
main ENDP

END main
