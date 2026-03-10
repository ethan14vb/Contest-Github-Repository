INCLUDE default_header.inc

ExitProcess PROTO STDCALL : DWORD

.code
main PROC PUBLIC
invoke ExitProcess, 0
main ENDP

END main
