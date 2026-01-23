; ---------------------------------------------------------------------------

Animals:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_732C(pc,d0.w),d1
		jmp	off_732C(pc,d1.w)
; ---------------------------------------------------------------------------
off_732C:	dc.w loc_7382-off_732C
		dc.w loc_7418-off_732C
		dc.w loc_7472-off_732C
		dc.w loc_74A8-off_732C
		dc.w loc_7472-off_732C
		dc.w loc_7472-off_732C
		dc.w loc_7472-off_732C
		dc.w loc_74A8-off_732C
		dc.w loc_7472-off_732C

byte_733E:	dc.b 0, 1, 2, 3, 4, 5, 6, 3, 4, 1, 0, 5

word_734A:	dc.w -$200, -$400
		dc.l Map_Animal1
		dc.w -$200, -$300
		dc.l Map_Animal2
		dc.w -$140, -$200
		dc.l Map_Animal1
		dc.w -$100, -$180
		dc.l Map_Animal2
		dc.w -$180, -$300
		dc.l Map_Animal3
		dc.w -$300, -$400
		dc.l Map_Animal2
		dc.w -$280, -$380
		dc.l Map_Animal3
; ---------------------------------------------------------------------------

loc_7382:
		addq.b	#2,obRoutine(a0)
		bsr.w	RandomNumber
		andi.w	#1,d0
		moveq	#0,d1
		move.b	(v_zone).w,d1
		add.w	d1,d1
		add.w	d0,d1
		move.b	byte_733E(pc,d1.w),d0
		move.b	d0,objoff_30(a0)
		lsl.w	#3,d0
		lea	word_734A(pc,d0.w),a1
		move.w	(a1)+,objoff_32(a0)
		move.w	(a1)+,objoff_34(a0)
		move.l	(a1)+,obMap(a0)
		move.w	#make_art_tile(ArtTile_Animal_1,0,0),obGfx(a0)
		btst	#0,objoff_30(a0)
		beq.s	loc_73C6
		move.w	#make_art_tile(ArtTile_Animal_2,0,0),obGfx(a0)

loc_73C6:
		move.b	#$C,obHeight(a0)
		move.b	#4,obRender(a0)
		bset	#0,obRender(a0)
		move.b	#6,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.b	#7,obTimeFrame(a0)
		move.b	#2,obFrame(a0)
		move.w	#-$400,obVelY(a0)
		tst.b	(v_bossstatus).w
		bne.s	loc_7438
		bsr.w	FindFreeObj
		bne.s	loc_7414
		_move.b	#id_Points,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

loc_7414:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7418:
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		bsr.w	ObjectFall
		tst.w	obVelY(a0)
		bmi.s	loc_746E
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_746E
		add.w	d1,obY(a0)

loc_7438:
		move.w	objoff_32(a0),obVelX(a0)
		move.w	objoff_34(a0),obVelY(a0)
		move.b	#1,obFrame(a0)
		move.b	objoff_30(a0),d0
		add.b	d0,d0
		addq.b	#4,d0
		move.b	d0,obRoutine(a0)
		tst.b	(v_bossstatus).w
		beq.s	loc_746E
		btst	#4,(v_vint_byte).w
		beq.s	loc_746E
		neg.w	obVelX(a0)
		bchg	#0,obRender(a0)

loc_746E:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_7472:
		bsr.w	ObjectFall
		move.b	#1,obFrame(a0)
		tst.w	obVelY(a0)
		bmi.s	loc_749C
		move.b	#0,obFrame(a0)
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_749C
		add.w	d1,obY(a0)
		move.w	objoff_34(a0),obVelY(a0)

loc_749C:
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_74A8:
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		tst.w	obVelY(a0)
		bmi.s	loc_74CC
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_74CC
		add.w	d1,obY(a0)
		move.w	objoff_34(a0),obVelY(a0)

loc_74CC:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	loc_74E2
		move.b	#1,obTimeFrame(a0)
		addq.b	#1,obFrame(a0)
		andi.b	#1,obFrame(a0)

loc_74E2:
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite