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
		dc.w Obj06_Main-Obj06_Index
		dc.w Obj06_Display-Obj06_Index
		dc.w Obj06_Delete-Obj06_Index
		dc.w Obj06_Delete-Obj06_Index
; ===========================================================================

Obj06_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$A0,obScreenY(a0)
		move.l	#Map_05,obMap(a0)
		move.w	#make_art_tile($470,0,1),obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#7,obPriority(a0)

Obj06_Display:	; Routine 2
		bsr.w	DisplaySprite
		rts
; ===========================================================================

Obj06_Delete:	; Routine 4, 6
		bsr.w	DeleteObject
		rts