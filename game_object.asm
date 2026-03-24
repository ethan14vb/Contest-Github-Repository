; // ==================================
; // GameObject
; // ----------------------------------
; //	GameObjects are the core elements of a scene
; // that contain gameplay logic and anything the player
; // will see.
; //	The GameObject STRUCT is intended to be 'subclassed' by 
; // overriding the virtual function table.
; //	GameObjects contain a list of components that
; // define utility behavior such as sprites to render
; // or animation states. These componenets are updated
; // by the scene_update to keep their auxillary functionality
; // separate from main game logic.
; // ==================================

INCLUDE default_header.inc
INCLUDE game_object.inc
INCLUDE heap_functions.inc

.data
GAMEOBJECT_VTABLE GameObject_vtable <OFFSET game_object_start, OFFSET game_object_update, OFFSET game_object_exit>

.code
; // ********************************************
; // Static methods
; // ********************************************

; // ----------------------------------
; // add_component
; // Initializes memory with the contents of a GameObject
; // ----------------------------------
add_component PROC PUBLIC USES eax ebx esi edi, pGameObject: DWORD, pComponent: DWORD
	mov esi, pGameObject
	mov eax, (GameObject PTR [esi]).numComponents
	mov ebx, (GameObject PTR [esi]).maxComponents

	; // if (pGameObject->numComponents >= pGameObject->maxComponents) 
	.IF (eax >= ebx)
		; // Double the size of the list
		shl (GameObject PTR [esi]).maxComponents, 1

		mov eax, (GameObject PTR[esi]).maxComponents
		shl eax, 2 ; // maxComponents * 4 where 4 is SIZEOF DWORD 
		INVOKE HeapReAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, (GameObject PTR[esi]).pComponents, eax
		mov (GameObject PTR [esi]).pComponents, eax

		; // Append the pointer to the end of the list
		mov eax, (GameObject PTR [esi]).numComponents
		mov edi, (GameObject PTR [esi]).pComponents
		mov ebx, pComponent

		mov [edi + eax * 4], ebx 
		inc (GameObject PTR [esi]).numComponents
	.ELSE
		; // Append the pointer to the end of the list
		mov eax, (GameObject PTR [esi]).numComponents
		mov edi, (GameObject PTR [esi]).pComponents
		mov ebx, pComponent

		mov [edi + eax * 4], ebx 
		inc (GameObject PTR [esi]).numComponents
	.ENDIF

	ret
add_component ENDP

; // ********************************************
; // Constructor Methods
; // ********************************************

; // ----------------------------------
; // init_game_object
; // Initializes memory with the contents of a GameObject
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
init_game_object PROC PUBLIC USES esi ebx edx, maxComponents : DWORD
	; // Set up class members
	mov esi, maxComponents
	mov (GameObject PTR [ecx]).maxComponents, esi

	; // Set up vTable
	mov (GameObject PTR[ecx]).pVt, OFFSET GAMEOBJECT_VTABLE

	; // Now set up the component pointer table
	mov eax, maxComponents
	mov edx, SIZEOF DWORD
	mul edx

	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, eax
	mov (GameObject PTR[ecx]).pComponents, eax

	ret
init_game_object ENDP

; // ----------------------------------
; // new_game_object
; // Reserves heap space for the Object with parameters calls the initializer method
; // ----------------------------------
new_game_object PROC PUBLIC USES ecx, maxComponents : DWORD
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF GameObject
	mov ecx, eax ; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE init_game_object, maxComponents

	ret ; // Return with the address of the memory block in HeapAlloc
new_game_object ENDP

; // ----------------------------------
; // free_game_object
; // Convenient method for freeing a GameObject
; // ----------------------------------
free_game_object PROC PUBLIC, pGameObject: DWORD
	INVOKE HeapFree, hHeap, 0, pGameObject
	ret
free_game_object ENDP

; // ********************************************
; // Instance methods
; // ********************************************

; // ----------------------------------
; // game_object_start
; // Default blank start method for a GameObject
; // Can be left blank, or overriden by the virtual function table
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
game_object_start PROC
	ret
game_object_start ENDP

; // ----------------------------------
; // game_object_update
; // Default blank update method for a GameObject
; // Can be left blank, or overriden by the virtual function table
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
game_object_update PROC
	ret
game_object_update ENDP

; // ----------------------------------
; // game_object_exit
; // Default blank exit method for a GameObject
; // Can be left blank, or overriden by the virtual function table
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
game_object_exit PROC
	ret
game_object_exit ENDP

END 