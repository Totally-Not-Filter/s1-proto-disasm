; ---------------------------------------------------------------------------

ObjSceneryLamp:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_C538(pc,d0.w),d1
		jmp	off_C538(pc,d1.w)
; ---------------------------------------------------------------------------

off_C538:	dc.w loc_C53C-off_C538
		dc.w loc_C560-off_C538
; ---------------------------------------------------------------------------

loc_C53C:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Light,obMap(a0)
		move.w	#make_art_tile(ArtTile_Level,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#6,obPriority(a0)

loc_C560:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	loc_C57E
		move.b	#7,obTimeFrame(a0)
		addq.b	#1,obFrame(a0)
		cmpi.b	#6,obFrame(a0)
		bcs.s	loc_C57E
		move.b	#0,obFrame(a0)

loc_C57E:
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif