; ---------------------------------------------------------------------------

Staircase:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_E358(pc,d0.w),d1
		jsr	off_E358(pc,d1.w)
		out_of_range.w	DeleteObject,objoff_30(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_E358:	dc.w loc_E35E-off_E358
		dc.w loc_E3DE-off_E358
		dc.w loc_E3F2-off_E358
; ---------------------------------------------------------------------------

loc_E35E:
		addq.b	#2,obRoutine(a0)
		moveq	#$38,d3
		moveq	#1,d4
		btst	#0,obStatus(a0)
		beq.s	loc_E372
		moveq	#$3B,d3
		moveq	#-1,d4

loc_E372:
		move.w	obX(a0),d2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	loc_E38A
; ---------------------------------------------------------------------------

loc_E37C:
		bsr.w	FindNextFreeObj
		bne.w	loc_E3DE
		move.b	#4,obRoutine(a1)

loc_E38A:
		_move.b	#id_Staircase,obID(a1)
		move.l	#Map_Stair,obMap(a1)
		move.w	#make_art_tile(ArtTile_SLZ_Platform,2,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#3,obPriority(a1)
		move.b	#$10,obActWid(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.w	d2,obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obX(a0),objoff_30(a1)
		move.w	obY(a1),objoff_32(a1)
		addi.w	#$20,d2
		move.b	d3,objoff_37(a1)
		move.l	a0,objoff_3C(a1)
		add.b	d4,d3
		dbf	d1,loc_E37C

loc_E3DE:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_E43A(pc,d0.w),d1
		jsr	off_E43A(pc,d1.w)

loc_E3F2:
		movea.l	objoff_3C(a0),a2
		moveq	#0,d0
		move.b	objoff_37(a0),d0
		move.b	(a2,d0.w),d0
		add.w	objoff_32(a0),d0
		move.w	d0,obY(a0)
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		tst.b	d4
		bpl.s	loc_E42A
		move.b	d4,objoff_36(a2)

loc_E42A:
		btst	#3,obStatus(a0)
		beq.s	locret_E438
		move.b	#1,objoff_36(a2)

locret_E438:
		rts
; ---------------------------------------------------------------------------

off_E43A:	dc.w loc_E442-off_E43A
		dc.w loc_E4A8-off_E43A
		dc.w loc_E464-off_E43A
		dc.w loc_E4A8-off_E43A
; ---------------------------------------------------------------------------

loc_E442:
		tst.w	objoff_34(a0)
		bne.s	loc_E458
		cmpi.b	#1,objoff_36(a0)
		bne.s	locret_E456
		move.w	#$1E,objoff_34(a0)

locret_E456:
		rts
; ---------------------------------------------------------------------------

loc_E458:
		subq.w	#1,objoff_34(a0)
		bne.s	locret_E456
		addq.b	#1,obSubtype(a0)
		rts
; ---------------------------------------------------------------------------

loc_E464:
		tst.w	objoff_34(a0)
		bne.s	loc_E478
		tst.b	objoff_36(a0)
		bpl.s	locret_E476
		move.w	#$3C,objoff_34(a0)

locret_E476:
		rts
; ---------------------------------------------------------------------------

loc_E478:
		subq.w	#1,objoff_34(a0)
		bne.s	loc_E484
		addq.b	#1,obSubtype(a0)
		rts
; ---------------------------------------------------------------------------

loc_E484:
		lea	objoff_38(a0),a1
		move.w	objoff_34(a0),d0
		lsr.b	#2,d0
		andi.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		rts
; ---------------------------------------------------------------------------

loc_E4A8:
		lea	objoff_38(a0),a1
		cmpi.b	#$80,(a1)
		beq.s	locret_E4D0
		addq.b	#1,(a1)
		moveq	#0,d1
		move.b	(a1)+,d1
		swap	d1
		lsr.l	#1,d1
		move.l	d1,d2
		lsr.l	#1,d1
		move.l	d1,d3
		add.l	d2,d3
		swap	d1
		swap	d2
		swap	d3
		move.b	d3,(a1)+
		move.b	d2,(a1)+
		move.b	d1,(a1)+

locret_E4D0:
		rts
		rts