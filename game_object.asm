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
new_game_object PROC PUBLIC, numComponents: DWORD, pComponents: DWORD
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF GameObject

	mov esi, numComponents
	mov (GameObject PTR [eax]).numComponents, esi
	mov esi, pComponents
	mov (GameObject PTR [eax]).pComponents, esi

	ret ; // Return with the address of the memory block in HeapAlloc
new_game_object ENDP

free_game_object PROC PUBLIC, pGameObject: DWORD
	INVOKE HeapFree, hHeap, 0, pGameObject
	ret
free_game_object ENDP

END 