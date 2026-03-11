SpriteComponent STRUCT
	originX DWORD ?
	originY DWORD ?

	pTexture DWORD ?

	; // Info about where the sprite is in the source buffer. (If using spritesheet cell)
	cellX DWORD ?
	cellY DWORD ?
	cellW DWORD ?
	cellH DWORD ?

	; // *************************
	; // Booleans (Maybe later these can be compressed into flags to save space)
	; // *************************
	flipX DWORD ?
	flipY DWORD ? 

	; // Whether to ignore the camera offset when rendering.
	; // Used for drawing UI items
	ignoreCamera DWORD ?

	visible DWORD ?
SpriteComponent ENDS

END
