; // ==================================
; // vector.asm
; // ----------------------------------
; // Vectors are dynamic arrays meant to mimic 
; // C++'s std::vector lists. In this implementation, 
; // for simplicity, they can only hold DWORDs.
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
push_back PROC USES eax ebx edx edi, element: DWORD
	mov eax, (Vector PTR [ecx]).pData
	mov ebx, (Vector PTR [ecx]).count
	mov edx, (Vector PTR [ecx]).capacity

	; // Check if the vector needs to be resized first
	.IF ebx == edx
		; // Double the capacity
		shl edx, 1 
		mov (Vector PTR [ecx]).capacity, edx

		; // ReAlloc the data
		push ecx
		INVOKE HeapReAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, (Vector PTR [ecx]).pData, edx
		pop ecx

		mov (Vector PTR [ecx]).pData, eax

	.ENDIF

	; // Insert the data
	mov edi, (Vector PTR [ecx]).pData
	mov eax, (Vector PTR [ecx]).count
	mov ebx, element

	mov [edi + eax * 4], ebx 
	inc (Vector PTR [ecx]).count

	ret
push_back ENDP

remove_element PROC
	ret
remove_element ENDP

END