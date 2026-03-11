; // ********************************************
; // Enumerations
; // ********************************************
RC_ENUM TYPEDEF DWORD

RC_RECT = 0 ; // RenderCommand Rectangle
RC_SPRITE = 1 ; // RenderCommand Sprite

RenderCommand STRUCT
	rcType RC_ENUM ? ; // Render command type

	; // More contents here
RenderCommand ENDS

END
