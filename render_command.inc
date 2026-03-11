; // ==================================
; // RenderCommand
; // ----------------------------------
; // A render command is meant to be compiled into
; // a list of commands and passed to the renderer
; // which will decide how exactly to render all of
; // the commands passed to it.
; // ==================================

; // Enumerations
RC_ENUM TYPEDEF DWORD

RC_RECT = 0 ; // RenderCommand Rectangle
RC_SPRITE = 1 ; // RenderCommand Sprite

RenderCommand STRUCT
	rcType RC_ENUM ? ; // Render command type

	; // More contents here
RenderCommand ENDS

END
