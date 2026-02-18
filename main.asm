INCLUDE Irvine32.inc
.data
CR = 13; Carriage return
LF = 10; Line feed

myString BYTE "Test program", CR, LF, 0

.code
main PROC
	mov edx, offset myString
	call WriteString
	INVOKE ExitProcess, 0
main ENDP
END main
