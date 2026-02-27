INCLUDE Irvine32.inc

.data
include kgdata.inc

CR = 13; Carriage return
LF = 10; Line feed

unconventionalCharacters BYTE 0C9h, 0CDh, CR, LF, 0

introString1 BYTE "Rock paper scissors rules:", CR, LF, 0
introString2 BYTE "Both players input their move at the same time", CR, LF, 0
introString3 BYTE "Player 1 uses ASD and Player 2 uses JKL for rock, paper, then scissors", CR, LF, 0
introString4 BYTE "Best of 3 wins", CR, LF, 0

readyString BYTE "Ready? Go!", CR, LF, 0
matchVictoryString BYTE "Player _ wins!", CR, LF, 0
gameVictoryString BYTE "Player _ has won the game!", CR, LF, 0

playAgainString BYTE "Would you like to play again? (Y \ N)", CR, LF, 0

.code
main PROC
	GameStart:
	mov edx, offset introString1
	call WriteString
	mov edx, offset introString2
	call WriteString
	mov edx, offset introString3
	call WriteString
	mov edx, offset introString4
	call WriteString

	mov edx, offset unconventionalCharacters
	call WriteString

	Quit :
	INVOKE ExitProcess, 0
main ENDP

END main
