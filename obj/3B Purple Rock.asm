; ---------------------------------------------------------------------------

PurpleRock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_AD1A(pc,d0.w),d1
		jmp	off_AD1A(pc,d1.w)
; ===========================================================================
off_AD1A:	dc.w loc_AD1E-off_AD1A
		dc.w loc_AD42-off_AD1A
; ===========================================================================

loc_AD1E:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_PRock,obMap(a0)
		move.w	#make_art_tile(ArtTile_GHZ_Purple_Rock,3,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$13,obActWid(a0)
		move.b	#4,obPriority(a0)

loc_AD42:
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$10,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif