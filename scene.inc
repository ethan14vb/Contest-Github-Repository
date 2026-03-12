; // ==================================
; // scene.inc
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
	pGameObjects DWORD ? ; // List containing game objects
Scene ENDS

ENDIF
