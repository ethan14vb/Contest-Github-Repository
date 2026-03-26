; // ==================================
; // vector.inc
; // ----------------------------------
; // Vectors are dynamic arrays meant to mimic 
; // C++'s std::vector lists. 
; // ==================================

IFNDEF VECTOR_INC
VECTOR_INC EQU 1

Vector STRUCT
	pData		DWORD ?
	count		DWORD ?
	capacity	DWORD ?
Vector ENDS

ENDIF