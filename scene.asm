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
INCLUDE game_object.inc

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
; // add_game_object
; // Adds a game object to the scene's start queue
; //
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
instantiate_game_object PROC PUBLIC USES esi, pGameObject: DWORD
	mov esi, ecx ; // Store the THIS pointer in ecx

	lea ecx, (Scene PTR[ecx]).startQueue
	INVOKE push_back, pGameObject

	mov ecx, esi ; // Restore the THIS pointer
	ret
instantiate_game_object ENDP

; // ----------------------------------
; // scene_process_start_queue
; // Moves the GameObjects from the startQueue to the gameObjects vector 
; // and then calls their start() methods.
; //
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
scene_process_start_queue PROC PRIVATE USES eax ebx edx esi edi
	local pThis
	mov pThis, ecx ; // Save the THIS pointer just in case

	lea ecx, (Scene PTR [ecx]).startQueue
	mov ebx, (UnorderedVector PTR [ecx]).count
	mov eax, (UnorderedVector PTR [ecx]).pData
	mov edx, 0 ; // int i = 0
	
	; // Iterate through the Game Objects and add them to the gameObjects vector, then call their start methods
	.WHILE edx < ebx
		; // esi = startQueue[i]
		mov esi, [eax + edx * 4]
		
		; // push the game object startQueue[i] into GameObjects
		mov ecx, pThis
		lea ecx, (Scene PTR [ECX]).gameObjects
		INVOKE push_back, esi
	
		; // call the start() method in the GameObject startQueue[i]
		mov ecx, esi
		INVOKE game_object_start_virtual
	.ENDW

	; // Set the length of startQueue to be 0, effectively clearing it
	mov ecx, pThis
	lea ecx, (Scene PTR [ecx]).startQueue
	mov (UnorderedVector PTR [ecx]).count, 0

	mov ecx, pThis
	ret
scene_process_start_queue ENDP

; // ----------------------------------
; // scene_update
; // Responsible for updating the game objects and simulations every frame.
; //
; // Register Parameters: 
; //	ecx - THIS pointer
; // ----------------------------------
scene_update PROC PUBLIC USES eax ebx edx esi edi, deltaTime: REAL4
	local pThis
	mov pThis, ecx ; // Save the THIS pointer just in case

	; // Take Input and set input flags

	; // Process start queue
	INVOKE scene_process_start_queue

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

END
