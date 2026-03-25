; // ==================================
; // component.asm
; // ----------------------------------
; //	Components are utility helpers to GameObjects that
; // allow for easy adding of features and a composition
; // structure for them (HasA vs IsA). 
; //	Some examples of components are SpriteComponents
; // that describe what a GameObject should look like or
; // TransformComponents that describe where a GameObject
; // is located spatially. 
; //	These are the generic component methods that
; // all components inherit from.
; // ==================================

INCLUDE default_header.inc
INCLUDE heap_functions.inc

END