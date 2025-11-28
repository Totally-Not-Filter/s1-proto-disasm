; ---------------------------------------------------------------------------

ObjWall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_C10A(pc,d0.w),d1
		jmp	off_C10A(pc,d1.w)
; ---------------------------------------------------------------------------

off_C10A:	dc.w loc_C110-off_C10A, loc_C148-off_C10A, loc_C154-off_C10A
; ---------------------------------------------------------------------------

loc_C110:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Edge,obMap(a0)
		move.w	#make_art_tile(ArtTile_GHZ_Edge_Wall,2,0),obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#8,obActWid(a0)
		move.b	#6,obPriority(a0)
		move.b	obSubtype(a0),obFrame(a0)
		bclr	#4,obFrame(a0)
		beq.s	loc_C148
		addq.b	#2,obRoutine(a0)
		bra.s	loc_C154
; ---------------------------------------------------------------------------

loc_C148:
		move.w	#$13,d1
		move.w	#$28,d2
		bsr.w	Obj44_SolidWall

loc_C154:
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif