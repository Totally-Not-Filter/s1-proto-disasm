; ---------------------------------------------------------------------------
; Object 2A - Switch Door (Unused in GHZ)
; ---------------------------------------------------------------------------

Obj2A:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	.index(pc,d0.w),d1
		jmp	.index(pc,d1.w)
; ===========================================================================
.index:	dc.w .init-.index
		dc.w .chkpress-.index
		dc.w .display-.index
; ===========================================================================

.init:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_2A,obMap(a0)
		move.w	#make_art_tile(ArtTile_Level,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	obY(a0),d0
		subi.w	#32,d0
		move.w	d0,objoff_30(a0)
		move.b	#11,obActWid(a0)
		move.b	#5,obPriority(a0)
		tst.b	obSubtype(a0)
		beq.s	.chkpress
		move.b	#1,obFrame(a0)
		move.w	#make_art_tile(ArtTile_Level,2,0),obGfx(a0)
		move.b	#4,obPriority(a0)
		addq.b	#2,obRoutine(a0)

.chkpress:	; Routine 2
		tst.w	(f_switch).w
		beq.s	.notpressed
		subq.w	#1,obY(a0)
		move.w	objoff_30(a0),d0
		cmp.w	obY(a0),d0
		beq.w	DeleteObject

.notpressed:
		move.w	#22,d1
		move.w	#16,d2
		bsr.w	Obj44_SolidWall

.display:	; Routine 4
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif