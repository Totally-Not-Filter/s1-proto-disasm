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
		dc.w Obj05_Main-Obj05_Index
		dc.w Obj05_Display-Obj05_Index
		dc.w Obj05_Delete-Obj05_Index
		dc.w Obj05_Delete-Obj05_Index
; ===========================================================================

Obj05_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_05,obMap(a0)
		move.w	#make_art_tile($4F0,0,1),obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#7,obPriority(a0)

Obj05_Display:	; Routine 2
		bsr.w	DisplaySprite
		rts
; ===========================================================================

Obj05_Delete:	; Routine 4, 6
		bsr.w	DeleteObject
		rts