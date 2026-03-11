; // ==================================
; // GameObject
; // ----------------------------------
; // A STRUCT meant to define the size of a GameObject.
; // This STRUCT is intended to be 'subclassed' by 
; // overriding the virtual function table.
; // ==================================

GameObject_vtable STRUCT
	pStart DWORD ?
	pUpdate DWORD ?
	pExit DWORD ?
GameObject_vtable ENDS

GameObject STRUCT
	pComponents DWORD ?
	pVt DWORD ? ; Pointer to a virtual function table
GameObject ENDS


END
