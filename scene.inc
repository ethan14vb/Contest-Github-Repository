; // ==================================
; // Scene
; // ----------------------------------
; // Scenes are classes that hold a single section of a game. A scene contains a
; // pointer to a list of GameObjects that is updated by the scene_update function.
; // The scene also updates simulations and any game logic that isn't handled directly
; // by GameObjects or their components. At the end of every update, the scene will
; // call the renderer module to render its contents.
; // ==================================

IFNDEF SCENE_INC
SCENE_INC EQU 1

Scene STRUCT
	; // The list of GameObjects in this Scene instance.
	pGameObjects		DWORD ?
	numGameObjects		DWORD ?
	maxGameObjects		DWORD ? ; // Maximum size of the game objects list. This array is dynamic and can be resized.
	
	; // The start queue is a list of GameObjects created by the add_gameobject method
	pStartQueue			DWORD ?
	numStartQueue		DWORD ?
	maxStartQueue		DWORD ?

	; // The free queue is a list of GameObjects to free at the end of the frame
	pFreeQueue			DWORD ?
	numFreeQueue		DWORD ?
	maxFreeQueue		DWORD ?

	; // The list of renderCommands that is built at the end of each frame
	pRenderCommands		DWORD ?
	numRenderCommands	DWORD ?
	maxRenderCommands	DWORD ?

Scene ENDS

init_scene PROTO maxGameObjects		: DWORD
new_scene PROTO maxGameObjects		: DWORD
free_scene PROTO

ENDIF
