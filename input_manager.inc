; // ==================================
; // input_manager.inc
; // ----------------------------------
; // The input manager is responsible for determining
; // which keys are currently pressed and providing
; // a convenient method for other files to determine
; // the currently pressed keys. This should be
; // updated on a by-frame basis by a scene.
; // ==================================

IFNDEF INPUT_MANAGER_INC
INPUT_MANAGER_INC EQU 1

updateInput PROTO
isKeyPressed PROTO vkCode: DWORD
isKeyJustPressed PROTO vkCode: DWORD

ENDIF
