; // ==================================
; // scene.asm
; // ----------------------------------
; // Scenes are classes that hold a single section of a game. A scene contains a
; // pointer to a list of GameObjects that is updated by the scene_update function.
; // The scene also updates simulations and any game logic that isn't handled directly
; // by GameObjects or their components. At the end of every update, the scene will
; // call the renderer module to render its contents.
; // ==================================

INCLUDE default_header.inc
INCLUDE heap_functions.inc
INCLUDE scene.inc

.code
; // ********************************************
; // Constructor Methods
; // ********************************************

; // ----------------------------------
; // init_scene
; // Initializes memory with the contents of a Scene
; // 
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
init_scene PROC PUBLIC USES esi, numGameObjects : DWORD, maxGameObjects : DWORD, pGameObjects : DWORD
	INVOKE init_scene, numGameObjects, maxGameObjects, pGameObjects ; // placeholder just to avoid MASM bugs
	ret
init_scene ENDP

; // ----------------------------------
; // new_scene
; // Reserves heap space for the scene with parameters and calls the initializer method
; // ----------------------------------
new_scene PROC PUBLIC USES ecx, numGameObjects : DWORD, maxGameObjects : DWORD, pGameObjects : DWORD
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF Scene
	mov ecx, eax; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE init_scene, numGameObjects, maxGameObjects, pGameObjects

	ret; // Return with the address of the memory block in HeapAlloc
new_scene ENDP

; // ----------------------------------
; // free_scene
; // Convenient method for freeing a Scene
; // ----------------------------------
free_scene PROC PUBLIC, pGameObjects: DWORD
	INVOKE HeapFree, hHeap, 0, pGameObjects
	ret
free_scene ENDP


; // ********************************************
; // Class methods
; // ********************************************

; // ----------------------------------
; // scene_start
; // Initializes the scene and allocates resources that will be used such as spritesheets,
; // SFX, or other external files needed in the scene. 
; // ----------------------------------
scene_start PROC
	ret
scene_start ENDP

; // ----------------------------------
; // scene_update
; // Responsible for updating the game objects and simulations every frame.
; // ----------------------------------
scene_update PROC
	; // Take Input

	; // Update Game Objects
	; // for (GameObject o : *pGameObjects):
	; //	o.update()

	; // Update components

	; // Build render list

	; // Pass render list to renderer
	ret
scene_update ENDP

; // ----------------------------------
; // scene_exit
; // A destructor that clears the scene and the resources allocated during scene_start.
; // ----------------------------------
scene_exit PROC
	ret
scene_exit ENDP

END
