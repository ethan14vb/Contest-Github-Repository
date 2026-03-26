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
init_vector PROC USES esi, pData: DWORD, capacity : DWORD
	; // Allocate space for the data
	mov eax, capacity
	shl eax, 2 ; // multiply capacity by 4, SIZEOF DWORD

	push ecx
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, eax
	pop ecx

	mov (Vector PTR [ecx]).pData, eax

	; // Initialize other member data
	mov (Vector PTR [ecx]).count, 0
	mov esi, capacity
	mov (Vector PTR [ecx]).capacity, esi

	mov eax, ecx ; // Return the this pointer
	ret
init_vector ENDP

new_vector PROC USES ecx, pData: DWORD, capacity: DWORD
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF Vector
	mov ecx, eax ; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE init_vector, pData, capacity

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