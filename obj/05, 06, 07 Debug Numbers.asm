; ===========================================================================
; ---------------------------------------------------------------------------
; Object 05 - Debug Numbers
; ---------------------------------------------------------------------------

Obj05:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj05_Index(pc,d0.w),d1
		jmp	Obj05_Index(pc,d1.w)
; ===========================================================================
Obj05_Index:
		dc.w	Obj05_Main-Obj05_Index			; 0
		dc.w	Obj05_Display-Obj05_Index		; 2
		dc.w	Obj05_Delete-Obj05_Index		; 4 (unused)
		dc.w	Obj05_Delete-Obj05_Index		; 6 (unused)
; ===========================================================================

Obj05_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Obj05_Display
		move.l	#Map_05,obMap(a0)			; set mappings
		move.w	#ArtTile_Debug_Numbers|Tile_Prio,obGfx(a0) ; set art tile and priority
		move.b	#sprite_cam_screen,obRender(a0)		; set to screen-positioned mode
		move.b	#7,obPriority(a0)			; set sprite priority

Obj05_Display:	; Routine 2
		bsr.w	DisplaySprite
		rts
; ===========================================================================

Obj05_Delete:	; Routine 4, 6 (unused)
		bsr.w	DeleteObject
		rts

; ===========================================================================

Map_05:		include "_maps/05.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 06 - Debug Numbers
; ---------------------------------------------------------------------------

Obj06:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj06_Index(pc,d0.w),d1
		jmp	Obj06_Index(pc,d1.w)
; ===========================================================================
Obj06_Index:
		dc.w	Obj06_Main-Obj06_Index			; 0
		dc.w	Obj06_Display-Obj06_Index		; 2
		dc.w	Obj06_Delete-Obj06_Index		; 4 (unused)
		dc.w	Obj06_Delete-Obj06_Index		; 6 (unused)
; ===========================================================================

Obj06_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Obj06_Display
		move.w	#$A0,obScreenY(a0)			; set Y-position
		move.l	#Map_05,obMap(a0)			; set mappings
		move.w	#ArtTile_Obj06|Tile_Prio,obGfx(a0)	; set art tile and priority
		move.b	#sprite_cam_screen,obRender(a0)		; set to screen-positioned mode
		move.b	#7,obPriority(a0)			; set sprite priority

Obj06_Display:	; Routine 2
		bsr.w	DisplaySprite
		rts
; ===========================================================================

Obj06_Delete:	; Routine 4, 6 (unused)
		bsr.w	DeleteObject
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 07 - Unknown object
; ---------------------------------------------------------------------------

Obj07:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj07_Index(pc,d0.w),d1
		jmp	Obj07_Index(pc,d1.w)
; ===========================================================================
Obj07_Index:
		dc.w	Obj07_Init-Obj07_Index			; 0
		dc.w	Obj07_Main-Obj07_Index			; 2
		dc.w	Obj07_Delete-Obj07_Index		; 4 (unused)
		dc.w	Obj07_Delete-Obj07_Index		; 6 (unused)
; ===========================================================================

Obj07_Init:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Obj07_Main

Obj07_Main:	; Routine 2
		rts
; ===========================================================================

Obj07_Delete:	; Routine 4, 6 (unused)
		bsr.w	DeleteObject
		rts