; ---------------------------------------------------------------------------

ObjLavafallMaker:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_C926(pc,d0.w),d1
		jsr	off_C926(pc,d1.w)
		bra.w	loc_CB28
; ---------------------------------------------------------------------------

off_C926:	dc.w loc_C932-off_C926, loc_C95C-off_C926, loc_C9CE-off_C926, loc_C982-off_C926, loc_C9DA-off_C926
		dc.w loc_C9EA-off_C926
; ---------------------------------------------------------------------------

loc_C932:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Geyser,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Lava,3,1),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obPriority(a0)
		move.b	#$38,obActWid(a0)
		move.w	#120,objoff_34(a0)

loc_C95C:
		subq.w	#1,objoff_32(a0)
		bpl.s	locret_C980
		move.w	objoff_34(a0),objoff_32(a0)
		move.w	(v_player+obY).w,d0
		move.w	obY(a0),d1
		cmp.w	d1,d0
		bcc.s	locret_C980
		subi.w	#$170,d1
		cmp.w	d1,d0
		bcs.s	locret_C980
		addq.b	#2,obRoutine(a0)

locret_C980:
		rts
; ---------------------------------------------------------------------------

loc_C982:
		addq.b	#2,obRoutine(a0)
		bsr.w	FindNextFreeObj
		bne.s	loc_C9A8
		_move.b	#id_LavaGeyser,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.l	a0,objoff_3C(a1)

loc_C9A8:
		move.b	#1,obAnim(a0)
		tst.b	obSubtype(a0)
		beq.s	loc_C9BC
		move.b	#4,obAnim(a0)
		bra.s	loc_C9DA
; ---------------------------------------------------------------------------

loc_C9BC:
		movea.l	objoff_3C(a0),a1
		bset	#1,obStatus(a1)
		move.w	#-$580,obVelY(a1)
		bra.s	loc_C9DA
; ---------------------------------------------------------------------------

loc_C9CE:
		tst.b	obSubtype(a0)
		beq.s	loc_C9DA
		addq.b	#2,obRoutine(a0)
		rts
; ---------------------------------------------------------------------------

loc_C9DA:
		lea	(Ani_Geyser).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

loc_C9EA:
		move.b	#0,obAnim(a0)
		move.b	#2,obRoutine(a0)
		tst.b	obSubtype(a0)
		beq.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

ObjLavafall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_CA12(pc,d0.w),d1
		jsr	off_CA12(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_CA12:	dc.w loc_CA1E-off_CA12, loc_CB0A-off_CA12, sub_CB8C-off_CA12, loc_CBEA-off_CA12

word_CA1A:	dc.w -$500
		dc.w 0
; ---------------------------------------------------------------------------

loc_CA1E:
		addq.b	#2,obRoutine(a0)
		move.w	obY(a0),objoff_30(a0)
		tst.b	obSubtype(a0)
		beq.s	loc_CA34
		subi.w	#$250,obY(a0)

loc_CA34:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	word_CA1A(pc,d0.w),obVelY(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bsr.s	sub_CA50
		bra.s	loc_CAA0
; ---------------------------------------------------------------------------

sub_CA4A:
		bsr.w	FindNextFreeObj
		bne.s	loc_CA9A
; ---------------------------------------------------------------------------

sub_CA50:
		_move.b	#id_LavaGeyser,obID(a1)
		move.l	#Map_Geyser,obMap(a1)
		move.w	#make_art_tile(ArtTile_MZ_Lava,3,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$20,obActWid(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.b	#1,obPriority(a1)
		move.b	#5,obAnim(a1)
		tst.b	obSubtype(a0)
		beq.s	loc_CA9A
		move.b	#2,obAnim(a1)

loc_CA9A:
		dbf	d1,sub_CA4A
		rts
; ---------------------------------------------------------------------------

loc_CAA0:
		addi.w	#$60,obY(a1)
		move.w	objoff_30(a0),objoff_30(a1)
		addi.w	#$60,objoff_30(a1)
		move.b	#$93,obColType(a1)
		move.b	#$80,obHeight(a1)
		bset	#4,obRender(a1)
		addq.b	#4,obRoutine(a1)
		move.l	a0,objoff_3C(a1)
		tst.b	obSubtype(a0)
		beq.s	loc_CB00
		moveq	#0,d1
		bsr.w	sub_CA4A
		addq.b	#2,obRoutine(a1)
		bset	#4,obGfx(a1)
		addi.w	#$100,obY(a1)
		move.b	#0,obPriority(a1)
		move.w	objoff_30(a0),objoff_30(a1)
		move.l	objoff_3C(a0),objoff_3C(a1)
		move.b	#0,obSubtype(a0)

loc_CB00:
		move.w	#sfx_Burning,d0
		jsr	(QueueSound2).l

loc_CB0A:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	off_CB48(pc,d0.w),d1
		jsr	off_CB48(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(Ani_Geyser).l,a1
		bsr.w	AnimateSprite

loc_CB28:
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_CB48:	dc.w loc_CB4C-off_CB48, loc_CB6C-off_CB48
; ---------------------------------------------------------------------------

loc_CB4C:
		addi.w	#$18,obVelY(a0)
		move.w	objoff_30(a0),d0
		cmp.w	obY(a0),d0
		bcc.s	locret_CB6A
		addq.b	#4,obRoutine(a0)
		movea.l	objoff_3C(a0),a1
		move.b	#3,obAnim(a1)

locret_CB6A:
		rts
; ---------------------------------------------------------------------------

loc_CB6C:
		addi.w	#$18,obVelY(a0)
		move.w	objoff_30(a0),d0
		cmp.w	obY(a0),d0
		bcc.s	locret_CB8A
		addq.b	#4,obRoutine(a0)
		movea.l	objoff_3C(a0),a1
		move.b	#1,obAnim(a1)

locret_CB8A:
		rts
; ---------------------------------------------------------------------------

sub_CB8C:
		movea.l	objoff_3C(a0),a1
		cmpi.b	#6,obRoutine(a1)
		beq.w	loc_CBEA
		move.w	obY(a1),d0
		addi.w	#$60,d0
		move.w	d0,obY(a0)
		sub.w	objoff_30(a0),d0
		neg.w	d0
		moveq	#8,d1
		cmpi.w	#$40,d0
		bge.s	loc_CBB6
		moveq	#$B,d1

loc_CBB6:
		cmpi.w	#$80,d0
		ble.s	loc_CBBE
		moveq	#$E,d1

loc_CBBE:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	loc_CBDC
		move.b	#7,obTimeFrame(a0)
		addq.b	#1,obAniFrame(a0)
		cmpi.b	#2,obAniFrame(a0)
		bcs.s	loc_CBDC
		move.b	#0,obAniFrame(a0)

loc_CBDC:
		move.b	obAniFrame(a0),d0
		add.b	d1,d0
		move.b	d0,obFrame(a0)
		bra.w	loc_CB28
; ---------------------------------------------------------------------------

loc_CBEA:
		bra.w	DeleteObject