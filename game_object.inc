; // ==================================
; // GameObject
; // ----------------------------------
; //	GameObjects are the core elements of a scene
; // that contain gameplay logic and anything the player
; // will see.
; //	This STRUCT is intended to be 'subclassed' by 
; // overriding the virtual function table.
; //	GameObjects contain a list of components that
; // define utility behavior such as sprites to render
; // or animation states. These componenets are updated
; // by the scene_update to keep their auxillary functionality
; // separate from main game logic.
; // ==================================

GameObject_vtable STRUCT
	pStart DWORD ?
	pUpdate DWORD ?
	pExit DWORD ?
GameObject_vtable ENDS

GameObject STRUCT
	numComponents DWORD ?
	pComponents DWORD ? ; Pointer to a table of components
	pVt DWORD ? ; Pointer to a virtual function table
GameObject ENDS


END
