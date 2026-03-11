SpriteComponent STRUCT
	; // Sprite position within scene
	x DWORD ?
	y DWORD ?

	originX DWORD ?
	originY DWORD ?

	; // Whether to ignore the camera offset when rendering.
	; // Used for drawing UI items
	ignoreCamera DWORD ? ; // Boolean

	pImage DWORD ? ; // The buffer with the sprite data

	; // Info about where the sprite is in the source buffer. (If using spritesheet cell)
	cellX DWORD ?
	cellY DWORD ?
	cellW DWORD ?
	cellH DWORD ?

	; // Boolean values about whether the sprite should be drawn flipped
	flipX DWORD ?
	flipY DWORD ? 

	visible DWORD ?

	; // Possible Futher updates (Not in scope for this project):
	; //	Rotation Support
	; //	Transparency Support
	; //	Stretch Support
SpriteComponent ENDS

END
