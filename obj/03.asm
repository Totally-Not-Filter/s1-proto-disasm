; ---------------------------------------------------------------------------
; Object 03 - Object from February 1990.
; ---------------------------------------------------------------------------

Obj03:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj03_Index(pc,d0.w),d1
		jmp	Obj03_Index(pc,d1.w)
; ===========================================================================
Obj03_Index:
		dc.w Obj03_Main-Obj03_Index
		dc.w Obj03_Display-Obj03_Index
		dc.w Obj03_Delete-Obj03_Index
		dc.w Obj03_Delete-Obj03_Index
; ===========================================================================

Obj03_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$100,obX(a0)
		move.w	#$40,obY(a0)
		move.l	#Map_02,obMap(a0)
		move.w	#make_art_tile($4F0,3,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obColProp(a0)
		move.b	#3,obFrame(a0)
		move.b	#5,obPriority(a0)

Obj03_Display:	; Routine 2
		bsr.w	DisplaySprite
		subq.b	#1,obTimeFrame(a0)
		bpl.s	.dontset
		move.b	#17-1,obTimeFrame(a0)

.dontset:
		rts
; ===========================================================================

Obj03_Delete:	; Routine 4, 6
		bsr.w	DeleteObject
		rts