; ---------------------------------------------------------------------------
; Object 52 - moving platform blocks (MZ)
; ---------------------------------------------------------------------------

MovingBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	MBlock_Index(pc,d0.w),d1
		jsr	MBlock_Index(pc,d1.w)
		out_of_range.w	DeleteObject,mblock_origX(a0)
		bra.w	DisplaySprite
; ===========================================================================
MBlock_Index:	dc.w MBlock_Main-MBlock_Index
		dc.w MBlock_Platform-MBlock_Index
		dc.w MBlock_StandOn-MBlock_Index

mblock_origX = objoff_32
mblock_origY = objoff_30

MBlock_Var:	dc.b $10, 0		; object width, frame number
		dc.b $20, 1
; ===========================================================================

MBlock_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_MBlock,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Block,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	MBlock_Var(pc,d0.w),a2
		move.b	(a2)+,obActWid(a0)
		move.b	(a2)+,obFrame(a0)
		move.b	#4,obPriority(a0)
		move.w	obX(a0),mblock_origX(a0)
		move.w	obY(a0),mblock_origY(a0)

MBlock_Platform:	; Routine 2
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(PlatformObject).l
		bra.w	MBlock_Move
; ===========================================================================

MBlock_StandOn:	; Routine 4
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(ExitPlatform).l
	if FixBugs
		; MBlock_Move manipulates the stack pointer, potentially
		; resulting in a crash. To avoid this, don't store data on
		; the stack. We can use object scratch RAM instead.
		move.w	obX(a0),objoff_38(a0)
	else
		move.w	obX(a0),-(sp)
	endif
		bsr.w	MBlock_Move
	if FixBugs
		move.w	objoff_38(a0),d2
	else
		move.w	(sp)+,d2
	endif
		jmp	(MvSonicOnPtfm2).l
; ===========================================================================

MBlock_Move:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	MBlock_TypeIndex(pc,d0.w),d1
		jmp	MBlock_TypeIndex(pc,d1.w)
; ===========================================================================
MBlock_TypeIndex:	dc.w MBlock_Type00-MBlock_TypeIndex, MBlock_Type01-MBlock_TypeIndex
		dc.w MBlock_Type02-MBlock_TypeIndex, MBlock_Type03-MBlock_TypeIndex
; ===========================================================================

MBlock_Type00:
		rts
; ===========================================================================

MBlock_Type01:
		move.b	(v_oscillate+$E).w,d0
		subi.b	#$60,d1
		btst	#0,obStatus(a0)
		beq.s	loc_D6A6
		neg.w	d0
		add.w	d1,d0

loc_D6A6:
		move.w	mblock_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,obX(a0)
		rts
; ===========================================================================

MBlock_Type02:
		cmpi.b	#4,obRoutine(a0) ; is Sonic standing on the platform?
		bne.s	MBlock_02_Wait
		addq.b	#1,obSubtype(a0) ; if yes, add 1 to type

MBlock_02_Wait:
		rts
; ===========================================================================

MBlock_Type03:
		moveq	#0,d3
		move.b	obActWid(a0),d3
		bsr.w	ObjHitWallRight
		tst.w	d1		; has the platform hit a wall?
		bmi.s	MBlock_03_End	; if yes, branch
		addq.w	#1,obX(a0)	; move platform to the right
		move.w	obX(a0),mblock_origX(a0)
		rts
; ===========================================================================

MBlock_03_End:
		clr.b	obSubtype(a0)	; change to type 00 (non-moving type)
		rts