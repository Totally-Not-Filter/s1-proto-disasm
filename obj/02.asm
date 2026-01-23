; ---------------------------------------------------------------------------
; Object 02 - Object from February 1990.
; ---------------------------------------------------------------------------

Obj02:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj02_Index(pc,d0.w),d1
		jmp	Obj02_Index(pc,d1.w)
; ---------------------------------------------------------------------------

Obj02_Index:
		dc.w Obj02_Main-Obj02_Index
		dc.w Obj02_Display-Obj02_Index
		dc.w Obj02_Delete-Obj02_Index
		dc.w Obj02_Delete-Obj02_Index
; ---------------------------------------------------------------------------

Obj02_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$200,obX(a0)	; Fixed positions
		move.w	#$60,obY(a0)
		move.l	#Map_02,obMap(a0)
		move.w	#make_art_tile($4F0,3,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obColProp(a0)
		move.b	#3,obPriority(a0)

Obj02_Display:	; Routine 2
		bsr.w	DisplaySprite
		subq.b	#1,obTimeFrame(a0)	; Decrement delay timer
		bpl.s	.wait			; Branch if it's not 0
		move.b	#17-1,obTimeFrame(a0)	; Set delay
		move.b	obFrame(a0),d0	; Set frame to d0
		addq.b	#1,d0			; Increment d0
		cmpi.b	#2,d0
		bcs.s	.dontrevert
		moveq	#0,d0

.dontrevert:
		move.b	d0,obFrame(a0)	; Make the frame what d0 is

.wait:
		rts
; ---------------------------------------------------------------------------

Obj02_Delete:	; Routine 4, 6
		bsr.w	DeleteObject
		rts