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

.code
; // ----------------------------------
; // init_game_object
; // Initializes memory with the contents of a GameObject
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
init_game_object PROC USES esi, numComponents : DWORD, pComponents : DWORD
	mov esi, numComponents
	mov (GameObject PTR [ecx]).numComponents, esi
	mov esi, pComponents
	mov (GameObject PTR [ecx]).pComponents, esi

	; // Initilaize the virtual function table
	; // TODO
init_game_object ENDP

new_game_object PROC PUBLIC USES ecx, numComponents : DWORD, pComponents : DWORD
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF GameObject
	mov ecx, eax ; // Move the memory address to eax so it can function as a "this" pointer
	INVOKE init_game_object, numComponents, pComponents

	ret ; // Return with the address of the memory block in HeapAlloc
new_game_object ENDP

free_game_object PROC PUBLIC, pGameObject: DWORD
	INVOKE HeapFree, hHeap, 0, pGameObject
	ret
free_game_object ENDP

END 