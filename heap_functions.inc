; // ==================================
; // heap_functions.inc
; // ----------------------------------
; // Functions used for dynamic memory management. This file was
; // added before we learned about heap memory management in class
; // so we could have easy memory management. My resource for this 
; // was the windows API reference and the class ch11 slides.
; // ==================================

IFNDEF HEAP_FUNCTIONS_INC
HEAP_FUNCTIONS_INC EQU 1

INCLUDELIB kernel32.lib

HANDLE TYPEDEF DWORD
NULL   EQU 0

GetProcessHeap	PROTO
HeapAlloc		PROTO,	hHeap:DWORD, dwFlags:DWORD, dwBytes:DWORD
HeapFree		PROTO,	hHeap:DWORD, dwFlags:DWORD, lpMem:DWORD
HeapReAlloc		PROTO,	hHeap:DWORD, dwFlags:DWORD, lpMem:DWORD,	dwBytes:DWORD

ENDIF
