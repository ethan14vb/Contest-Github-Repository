; // ==================================
; // wall_obstacle.inc
; // ----------------------------------
; // Wall obstacles push the player off the screen. The player
; // must avoid them to avoid losing the game.
; // ==================================

IFNDEF WALL_OBSTACLE_INC
WALL_OBSTACLE_INC EQU 1

INCLUDE game_object.inc

WallObstacle STRUCT
	baseGameObject GameObject<>
WallObstacle ENDS

init_wall_obstacle	PROTO startX : DWORD, startY : DWORD, height : DWORD
new_wall_obstacle	PROTO startX : DWORD, startY : DWORD, height : DWORD

ENDIF