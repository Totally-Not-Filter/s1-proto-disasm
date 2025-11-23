; ---------------------------------------------------------------------------

ObjChainPtfm:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_96C2(pc,d0.w),d1
		jmp	off_96C2(pc,d1.w)
; ---------------------------------------------------------------------------

off_96C2:	dc.w loc_96EA-off_96C2, loc_97D0-off_96C2, loc_9834-off_96C2, loc_9846-off_96C2, loc_9818-off_96C2

byte_96CC:	dc.b 0, 0
		dc.b 1, 0

byte_96D0:	dc.b 2, 0, 0
		dc.b 4, $1C, 1
		dc.b 8, $CC, 3
		dc.b 6, $F0, 2

word_96DC:	dc.w $7000, $A000
		dc.w $5000, $7800
		dc.w $3800, $5800
		dc.w $B800
; ---------------------------------------------------------------------------

loc_96EA:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		bpl.s	loc_9706
		andi.w	#$7F,d0
		add.w	d0,d0
		lea	byte_96CC(pc,d0.w),a2
		move.b	(a2)+,objoff_3A(a0)
		move.b	(a2)+,d0
		move.b	d0,obSubtype(a0)

loc_9706:
		andi.b	#$F,d0
		add.w	d0,d0
		move.w	word_96DC(pc,d0.w),d2
		tst.w	d0
		bne.s	loc_9718
		move.w	d2,objoff_32(a0)

loc_9718:
		lea	(byte_96D0).l,a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	loc_972C
; ---------------------------------------------------------------------------

loc_9724:
		bsr.w	FindNextFreeObj
		bne.w	loc_97B0

loc_972C:
		move.b	(a2)+,obRoutine(a1)
		_move.b	#id_ChainStomp,obID(a1)
		move.w	obX(a0),obX(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obY(a0),d0
		move.w	d0,obY(a1)
		move.l	#Map_CStom,obMap(a1)
		move.w	#make_art_tile(ArtTile_MZ_Spike_Stomper,0,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	obY(a1),objoff_30(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.b	#$10,obActWid(a1)
		move.w	d2,objoff_34(a1)
		move.b	#4,obPriority(a1)
		move.b	(a2)+,obFrame(a1)
		cmpi.b	#1,obFrame(a1)
		bne.s	loc_97A2
		subq.w	#1,d1
		move.b	obSubtype(a0),d0
		andi.w	#$F0,d0
		cmpi.w	#$20,d0
		beq.s	loc_972C
		move.b	#$38,obActWid(a1)
		move.b	#$90,obColType(a1)
		addq.w	#1,d1

loc_97A2:
		move.l	a0,objoff_3C(a1)
		dbf	d1,loc_9724
		move.b	#3,obPriority(a1)

loc_97B0:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#3,d0
		andi.b	#$E,d0
		lea	byte_97CA(pc,d0.w),a2
		move.b	(a2)+,obActWid(a0)
		move.b	(a2)+,obFrame(a0)
		bra.s	loc_97D0
; ---------------------------------------------------------------------------

byte_97CA:	dc.b $38, 0
		dc.b $30, 9
		dc.b $10, $A
; ---------------------------------------------------------------------------

loc_97D0:
		bsr.w	sub_986A
		move.w	obY(a0),(v_obj31ypos).w
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$C,d2
		move.w	#$D,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		btst	#3,obStatus(a0)
		beq.s	loc_9810
		cmpi.b	#$10,objoff_32(a0)
		bcc.s	loc_9810
		movea.l	a0,a2
		lea	(v_player).w,a0
		bsr.w	loc_FD78
		movea.l	a2,a0

loc_9810:
		bsr.w	DisplaySprite
		bra.w	loc_984A
; ---------------------------------------------------------------------------

loc_9818:
		move.b	#$80,obHeight(a0)
		bset	#4,obRender(a0)
		movea.l	objoff_3C(a0),a1
		move.b	objoff_32(a1),d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,obFrame(a0)

loc_9834:
		movea.l	objoff_3C(a0),a1
		moveq	#0,d0
		move.b	objoff_32(a1),d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)

loc_9846:
		bsr.w	DisplaySprite

loc_984A:
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_986A:
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_987C(pc,d0.w),d1
		jmp	off_987C(pc,d1.w)
; ---------------------------------------------------------------------------

off_987C:	dc.w loc_988A-off_987C, loc_9926-off_987C, loc_9926-off_987C, loc_99B6-off_987C, loc_9926-off_987C
		dc.w loc_99B6-off_987C, loc_9926-off_987C
; ---------------------------------------------------------------------------

loc_988A:
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	objoff_3A(a0),d0
		tst.b	(a2,d0.w)
		beq.s	loc_98DE
		tst.w	(v_obj31ypos).w
		bpl.s	loc_98A8
		cmpi.b	#$10,objoff_32(a0)
		beq.s	loc_98D6

loc_98A8:
		tst.w	objoff_32(a0)
		beq.s	loc_98D6
		move.b	(v_vint_byte).w,d0
		andi.b	#$F,d0
		bne.s	loc_98C8
		tst.b	obRender(a0)
		bpl.s	loc_98C8
		move.w	#sfx_ChainRise,d0
		jsr	(QueueSound2).l

loc_98C8:
		subi.w	#$80,objoff_32(a0)
		bcc.s	loc_9916
		move.w	#0,objoff_32(a0)

loc_98D6:
		move.w	#0,obVelY(a0)
		bra.s	loc_9916
; ---------------------------------------------------------------------------

loc_98DE:
		move.w	objoff_34(a0),d1
		cmp.w	objoff_32(a0),d1
		beq.s	loc_9916
		move.w	obVelY(a0),d0
		addi.w	#$70,obVelY(a0)
		add.w	d0,objoff_32(a0)
		cmp.w	objoff_32(a0),d1
		bhi.s	loc_9916
		move.w	d1,objoff_32(a0)
		move.w	#0,obVelY(a0)
		tst.b	obRender(a0)
		bpl.s	loc_9916
		move.w	#sfx_ChainStomp,d0
		jsr	(QueueSound2).l

loc_9916:
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_9926:
		tst.w	objoff_36(a0)
		beq.s	loc_996E
		tst.w	objoff_38(a0)
		beq.s	loc_9938
		subq.w	#1,objoff_38(a0)
		bra.s	loc_99B2
; ---------------------------------------------------------------------------

loc_9938:
		move.b	(v_vint_byte).w,d0
		andi.b	#$F,d0
		bne.s	loc_9952
		tst.b	obRender(a0)
		bpl.s	loc_9952
		move.w	#sfx_ChainRise,d0
		jsr	(QueueSound2).l

loc_9952:
		subi.w	#$80,objoff_32(a0)
		bcc.s	loc_99B2
		move.w	#0,objoff_32(a0)
		move.w	#0,obVelY(a0)
		move.w	#0,objoff_36(a0)
		bra.s	loc_99B2
; ---------------------------------------------------------------------------

loc_996E:
		move.w	objoff_34(a0),d1
		cmp.w	objoff_32(a0),d1
		beq.s	loc_99B2
		move.w	obVelY(a0),d0
		addi.w	#$70,obVelY(a0)
		add.w	d0,objoff_32(a0)
		cmp.w	objoff_32(a0),d1
		bhi.s	loc_99B2
		move.w	d1,objoff_32(a0)
		move.w	#0,obVelY(a0)
		move.w	#1,objoff_36(a0)
		move.w	#$3C,objoff_38(a0)
		tst.b	obRender(a0)
		bpl.s	loc_99B2
		move.w	#sfx_ChainStomp,d0
		jsr	(QueueSound2).l

loc_99B2:
		bra.w	loc_9916
; ---------------------------------------------------------------------------

loc_99B6:
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	loc_99C2
		neg.w	d0

loc_99C2:
		cmpi.w	#$90,d0
		bcc.s	loc_99CC
		addq.b	#1,obSubtype(a0)

loc_99CC:
		bra.w	loc_9916