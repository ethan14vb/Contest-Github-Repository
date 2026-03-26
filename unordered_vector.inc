; // ==================================
; // unordered_vector.inc
; // ----------------------------------
; // unordered_vector are dynamic arrays of DWORDs
; // whose contents are not guaranteed to be in the same
; // order after a removal. They are typically used for 
; // pools of GameObject pointers whose order doesn't matter.
; // ==================================

IFNDEF UNORDERED_VECTOR_INC
UNORDERED_VECTOR_INC EQU 1

UnorderedVector STRUCT
	pData		DWORD ?
	count		DWORD ?
	capacity	DWORD ?
UnorderedVector ENDS

ENDIF