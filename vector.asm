; // ==================================
; // vector.asm
; // ----------------------------------
; // Vectors are dynamic arrays meant to mimic 
; // C++'s std::vector lists. 
; // ==================================

INCLUDE default_header.inc
INCLUDE heap_functions.inc
INCLUDE vector.inc

.code
; // ********************************************
; // Constructor Methods
; // ********************************************
init_vector PROC
	ret
init_vector ENDP

new_vector PROC
	ret
new_vector ENDP

free_vector PROC USES esi
	; // Free the data list
	mov esi, (Vector PTR [ecx]).pData
	INVOKE HeapFree, hHeap, 0, esi

	; // Free myself
	INVOKE HeapFree, hHeap, 0, ecx
	ret
free_vector ENDP

; // ********************************************
; // Instance methods
; // ********************************************
push_back PROC
	ret
push_back ENDP

remove_element PROC
	ret
remove_element ENDP

END