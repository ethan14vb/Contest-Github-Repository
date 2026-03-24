; // ==================================
; // game_object_ids.inc
; // ----------------------------------
; // A set of "enum" style macros that identify GameObject types 
; // for the data definition and parsing of a scene's data.
; //
; // This is necessary because GameObjects are designed to be
; // subclassed into new unique types of GameObjects defined
; // by the user of this engine.
; // ==================================

IFNDEF GAME_OBJECT_IDS_INC
GAME_OBJECT_IDS_INC EQU 1

; // List of GameObject identifiers
DEFAULT_GAME_OBJECT_ID = 0

ENDIF