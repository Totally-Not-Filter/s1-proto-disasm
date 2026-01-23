; ---------------------------------------------------------------------------

ObjMZBlocks:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_C3FC(pc,d0.w),d1
		jmp	off_C3FC(pc,d1.w)
; ---------------------------------------------------------------------------
off_C3FC:	dc.w loc_C400-off_C3FC
		dc.w loc_C43C-off_C3FC

brick_origY = objoff_30
; ---------------------------------------------------------------------------

loc_C400:
		addq.b	#2,obRoutine(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.l	#Map_Brick,obMap(a0)
		move.w	#make_art_tile(ArtTile_Level,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#16,obActWid(a0)
		move.w	obY(a0),brick_origY(a0)
		move.w	#$5C0,objoff_32(a0)

loc_C43C:
		tst.b	obRender(a0)
		bpl.s	loc_C46A
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_C48E(pc,d0.w),d1
		jsr	off_C48E(pc,d1.w)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject

loc_C46A:
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ---------------------------------------------------------------------------
off_C48E:
		dc.w locret_C498-off_C48E
		dc.w loc_C4B2-off_C48E
		dc.w loc_C49A-off_C48E
		dc.w loc_C4D2-off_C48E
		dc.w loc_C50E-off_C48E
; ---------------------------------------------------------------------------

locret_C498:
		rts
; ---------------------------------------------------------------------------

loc_C49A:
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	loc_C4A6
		neg.w	d0

loc_C4A6:
		cmpi.w	#$90,d0
		bcc.s	loc_C4B2
		move.b	#3,obSubtype(a0)

loc_C4B2:
		moveq	#0,d0
		move.b	(v_oscillate+$16).w,d0
		btst	#3,obSubtype(a0)
		beq.s	loc_C4C6
		neg.w	d0
		addi.w	#$10,d0

loc_C4C6:
		move.w	brick_origY(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_C4D2:
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.w	locret_C50C
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)
		move.w	obY(a0),brick_origY(a0)
		move.b	#4,obSubtype(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2E8,d0
		bcc.s	locret_C50C
		move.b	#0,obSubtype(a0)

locret_C50C:
		rts
; ---------------------------------------------------------------------------

loc_C50E:
		moveq	#0,d0
		move.b	(v_oscillate+$12).w,d0
		lsr.w	#3,d0
		move.w	brick_origY(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)
		rts