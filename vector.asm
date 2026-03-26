; // ==================================
; // vector.asm
; // ----------------------------------
; // Vectors are dynamic arrays meant to mimic 
; // C++'s std::vector lists. 
; // ==================================

INCLUDE default_header.inc
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

free_vector PROC
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