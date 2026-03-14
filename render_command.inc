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

	; // Pointer to the transform that describes where the object should be rendered
	pTransform DWORD ?

	; // Pointer to the renderable object. Could be a RectComponent, or a SpriteComponent 
	; // depending on the value of rcType
	pRenderable DWORD ?
RenderCommand ENDS

ENDIF
