Scenes in this engine are initialized through a particular data format that you can see examples of in the 
.asm files in this filter. This format starts with:

```
amountOfGamesObjects: DWORD
```

which shows the amount of GameObjects in the scene. This is followed by data descriptions of the GameObjects.
When specifying a GameObject, you must write its type-ID, the data for its initializer methods, the amount of its 
components, and then descriptions of its component data.

So to define a GameObject:

```asm
gameObjectType: ENUM_GAME_OBJECT_ID
; // Optionally, initializer data for this type of game object goes here
; // The parser understands how much initializer data to expect based on gameObjectType
numberOfComponents: DWORD
; // Component descriptions go here
```

For the Components, first write the component type-ID and then follow it with the data for that Component. 

In more detail, that is:
```asm
componentType: ENUM_COMPONENT_ID
; // The initializer data for that component goes here
; // Once again, the parser understands how much initializer data to expect based on componentType
```

A limitation of this data format is that these objects cannot be initialized with data that references other GameObjects
or Components because the objects have not been created yet and do not exist in memory. Design your GameObjects, 
Components, and game logic with this limitation in mind.

Here is an example of the format in action for a specific example. 
The following scene_data describes a scene with two GameObjects:
-------------------------------------------------------------------
1. A default GameObject with a transform and rect component 
2. A fake user-created subclass of GameObject called processor that takes 1 DWORD initializer parameter

```asm
scene_data LABEL BYTE ; // The label is set to BYTE so the data can be BYTE addressable with MASM complaining
	DWORD 2 ; // Number of GameObjects

	; // GameObject 1: A default GameObject with a TransformComponent and a RectComponent
	DWORD DEFAULT_GAME_OBJECT_ID ; // The type of GameObject 
	; // By default, GameObjects have no initializer data, so nothing needs to go here.
	DWORD 2 ; // Number of components
		; // Component 1: TransformComponent
		DWORD TRANSFORM_COMPONENT_ID
		DWORD 5	; // x
		DWORD 10	; // y
		DWORD 0		; // ignoreCamera

		; // Component 2: RectComponent
		DWORD RECT_COMPONENT_ID
		DWORD 5		; // Height
		DWORD 6		; // Width
		BYTE 255	; // r
		BYTE 0		; // g
		BYTE 0		; // b
		BYTE 255	; // a

	; // GameObject 2: A user-created subclass of GameObject called Processor
	DWORD PROCESSOR_GAME_OBJECT_ID ; // The type of GameObject. 
	; // A PROCESSOR is not a real GameObject type for this engine, but for the purpose of this example, it will be 
	; // a user-created subclass of GameObject that takes the parameter architectureId: DWORD 

	; // Initializer data
	DWORD 12345 ; // architectureId

	DWORD 0 ; // Number of components
	; // Since there are no components and the 2 GameObjects have been described, the data is now finished being described.
```
