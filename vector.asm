; // ==================================
; // vector.asm
; // ----------------------------------
; // Vectors are dynamic arrays meant to mimic 
; // C++'s std::vector lists. 
; // ==================================

INCLUDE default_header.inc
INCLUDE vector.inc

.code
push_back PROC
	ret
push_back ENDP

remove_element PROC
	ret
remove_element ENDP

END