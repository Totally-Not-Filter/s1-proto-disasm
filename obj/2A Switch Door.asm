; ---------------------------------------------------------------------------

Obj2A:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_689E(pc,d0.w),d1
		jmp	off_689E(pc,d1.w)
; ---------------------------------------------------------------------------
off_689E:	dc.w loc_68A4-off_689E, loc_68F0-off_689E, loc_6912-off_689E
; ---------------------------------------------------------------------------

loc_68A4:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_2A,obMap(a0)
		move.w	#make_art_tile(ArtTile_Level,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	obY(a0),d0
		subi.w	#$20,d0
		move.w	d0,objoff_30(a0)
		move.b	#$B,obActWid(a0)
		move.b	#5,obPriority(a0)
		tst.b	obSubtype(a0)
		beq.s	loc_68F0
		move.b	#1,obFrame(a0)
		move.w	#make_art_tile(ArtTile_Level,2,0),obGfx(a0)
		move.b	#4,obPriority(a0)
		addq.b	#2,obRoutine(a0)

loc_68F0:
		tst.w	(f_switch).w
		beq.s	loc_6906
		subq.w	#1,obY(a0)
		move.w	objoff_30(a0),d0
		cmp.w	obY(a0),d0
		beq.w	DeleteObject

loc_6906:
		move.w	#$16,d1
		move.w	#$10,d2
		bsr.w	Obj44_SolidWall

loc_6912:
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif