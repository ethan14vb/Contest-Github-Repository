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


END