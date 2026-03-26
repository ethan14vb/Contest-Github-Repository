; // ==================================
; // vector.asm
; // ----------------------------------
; // Vectors are dynamic arrays meant to mimic 
; // C++'s std::vector lists. In this implementation, 
; // for simplicity, they can only hold DWORDs.
; // ==================================

IFNDEF VECTOR_INC
VECTOR_INC EQU 1

Vector STRUCT
	pData		DWORD ?
	count		DWORD ?
	capacity	DWORD ?
Vector ENDS

ENDIF