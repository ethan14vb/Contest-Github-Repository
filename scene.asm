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
init_scene PROC PUBLIC USES esi, maxGameObjects : DWORD
	mov esi, ecx ; // Save off my THIS pointer in esi

	lea ecx, (Scene PTR [esi]).gameObjects
	INVOKE init_unordered_vector, maxGameObjects

	lea ecx, (Scene PTR [esi]).startQueue
	INVOKE init_unordered_vector, maxGameObjects

	lea ecx, (Scene PTR [esi]).freeQueue
	INVOKE init_unordered_vector, maxGameObjects
	
	lea ecx, (Scene PTR [esi]).renderCommands
	INVOKE init_unordered_vector, maxGameObjects

	mov ecx, esi ; // Restore my THIS pointer
		
	ret
init_scene ENDP

; // ----------------------------------
; // new_scene
; // Reserves heap space for the scene with parameters and calls the initializer method
; // ----------------------------------
new_scene PROC PUBLIC USES ecx, maxGameObjects : DWORD
	INVOKE HeapAlloc, hHeap, HEAP_GENERATE_EXCEPTIONS, SIZEOF Scene
	mov ecx, eax ; // Move the memory address to ecx so it can function as a "this" pointer
	INVOKE init_scene, maxGameObjects
	mov eax, ecx ; // Now return the THIS pointer

	ret ; // Return with the address of the memory block in HeapAlloc
new_scene ENDP

; // ----------------------------------
; // free_scene
; // Convenient method for freeing a Scene
; //
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
free_scene PROC PUBLIC
	INVOKE HeapFree, hHeap, 0, ecx
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
scene_update PROC, deltaTime: REAL4
	; // Take Input and set input flags

	; // Process start queue
	; // for (GameObject o : *pStartQueue):
	; //	pGameObjects->push_back(o)
	; //	o.Start()
	; //
	; // *pStartQueue->clear()

	; // Update time sensitive components (such as timers and tweens)
	; // for (GameObject o : *pGameObjects):
	; //	for (Component c : o->pComponents)
	; //		if (c.componentType == TIMER_COMPONENT_TYPE)
	; //			c.Update(deltaTime)

	; // Update Game Object logic
	; // for (GameObject o : *pGameObjects):
	; //	o.update(deltaTime)

	; // Update animator components
	; // for (GameObject o : *pGameObjects):
	; //	for (Component c : o->pComponents)
	; //		if (c.componentType == ANIMATOR_COMPONENT_TYPE)
	; //			c.Update(deltaTime)

	; // Free any GameObjects that were queued to be freed by gameplay logic
	; // for (GameObject o : *pQueueFreeGameObjects)
	; //	o.free()

	; // Build render list
	; // renderCommands.clear()
	; // for (GameObject o : *pGameObjects):
	; //	for (Component c : o->pComponents)
	; //		if (c.componentType == SPRITE_COMPONENT_TYPE || c.componentType == RECT_COMPONENT_TYPE)
	; //			renderCommands.push_back(new RenderCommand(r))

	; // Pass render list to renderer
	; // renderer.renderFrame(renderCommands)
	ret
scene_update ENDP

; // ----------------------------------
; // scene_exit
; // Clears the resources allocated during scene_start.
; //
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
scene_exit PROC
	ret
scene_exit ENDP

END
