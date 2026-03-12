; // ==================================
; // RenderCommand
; // ----------------------------------
; // A render command is meant to be compiled into
; // a list of commands and passed to the renderer
; // which will decide how exactly to render all of
; // the commands passed to it.
; // ==================================

IFNDEF RENDERER_COMMAND_INC
RENDERER_COMMAND_INC EQU 1

INCLUDE transform_component.inc
INCLUDE rect_component.inc
INCLUDE sprite_component.inc

; // Enumerations
RC_ENUM TYPEDEF DWORD

RC_RECT = 0 ; // RenderCommand Rectangle
RC_SPRITE = 1 ; // RenderCommand Sprite NYI

RenderCommand STRUCT
	rcType RC_ENUM ? ; // Render command type

	transform TransformComponent <>

	; // This UNION was added before we had learned about them in class.
	; // It was added to this STRUCT to allow for C style memory usage.
	UNION
		rect RectComponent <>
		sprite SpriteComponent <>
	ENDS
RenderCommand ENDS

ENDIF
