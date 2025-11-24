; ---------------------------------------------------------------------------

ObjMZPlatforms:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_8ECE(pc,d0.w),d1
		jmp	off_8ECE(pc,d1.w)
; ---------------------------------------------------------------------------

off_8ECE:	dc.w loc_8EDE-off_8ECE, loc_8F3C-off_8ECE

off_8ED2:	dc.w ObjMZPlatforms_Slope1-off_8ED2
		dc.b 0, $40
		dc.w ObjMZPlatforms_Slope3-off_8ED2
		dc.b 1, $40
		dc.w ObjMZPlatforms_Slope2-off_8ED2
		dc.b 2, $20
; ---------------------------------------------------------------------------

loc_8EDE:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_LGrass,obMap(a0)
		move.w	#make_art_tile(ArtTile_Level,2,1),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#5,obPriority(a0)
		move.w	obY(a0),objoff_2C(a0)
		move.w	obX(a0),objoff_2A(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#2,d0
		andi.w	#$1C,d0
		lea	off_8ED2(pc,d0.w),a1
		move.w	(a1)+,d0
		lea	off_8ED2(pc,d0.w),a2
		move.l	a2,objoff_30(a0)
		move.b	(a1)+,obFrame(a0)
		move.b	(a1),obActWid(a0)
		andi.b	#$F,obSubtype(a0)
		move.b	#$40,obHeight(a0)
		bset	#4,obRender(a0)

loc_8F3C:
		bsr.w	sub_8FA6
		tst.b	ob2ndRout(a0)
		beq.s	loc_8F7C
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		bsr.w	PtfmCheckExit
		btst	#3,obStatus(a1)
		bne.w	loc_8F64
		clr.b	ob2ndRout(a0)
		bra.s	loc_8F9E
; ---------------------------------------------------------------------------

loc_8F64:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		movea.l	objoff_30(a0),a2
		move.w	obX(a0),d2
		bsr.w	sub_61E0
		bra.s	loc_8F9E
; ---------------------------------------------------------------------------

loc_8F7C:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$20,d2
		cmpi.b	#2,obFrame(a0)
		bne.s	loc_8F96
		move.w	#$30,d2

loc_8F96:
		movea.l	objoff_30(a0),a2
		bsr.w	loc_A30C

loc_8F9E:
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	loc_90C2
; ---------------------------------------------------------------------------

sub_8FA6:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_8FBA(pc,d0.w),d1
		jmp	off_8FBA(pc,d1.w)
; ---------------------------------------------------------------------------

off_8FBA:	dc.w locret_8FC6-off_8FBA, loc_8FC8-off_8FBA, loc_8FD2-off_8FBA, loc_8FDC-off_8FBA, loc_8FE6-off_8FBA
		dc.w loc_9006-off_8FBA
; ---------------------------------------------------------------------------

locret_8FC6:
		rts
; ---------------------------------------------------------------------------

loc_8FC8:
		move.b	(v_oscillate+2).w,d0
		move.w	#$20,d1
		bra.s	loc_8FEE
; ---------------------------------------------------------------------------

loc_8FD2:
		move.b	(v_oscillate+6).w,d0
		move.w	#$30,d1
		bra.s	loc_8FEE
; ---------------------------------------------------------------------------

loc_8FDC:
		move.b	(v_oscillate+$A).w,d0
		move.w	#$40,d1
		bra.s	loc_8FEE
; ---------------------------------------------------------------------------

loc_8FE6:
		move.b	(v_oscillate+$E).w,d0
		move.w	#$60,d1

loc_8FEE:
		btst	#3,obSubtype(a0)
		beq.s	loc_8FFA
		neg.w	d0
		add.w	d1,d0

loc_8FFA:
		move.w	objoff_2C(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_9006:
		move.b	objoff_34(a0),d0
		tst.b	ob2ndRout(a0)
		bne.s	loc_9018
		subq.b	#2,d0
		bcc.s	loc_9024
		moveq	#0,d0
		bra.s	loc_9024
; ---------------------------------------------------------------------------

loc_9018:
		addq.b	#4,d0
		cmpi.b	#$40,d0
		bcs.s	loc_9024
		move.b	#$40,d0

loc_9024:
		move.b	d0,objoff_34(a0)
		jsr	(CalcSine).l
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	objoff_2C(a0),d0
		move.w	d0,obY(a0)
		cmpi.b	#$20,objoff_34(a0)
		bne.s	loc_9082
		tst.b	objoff_35(a0)
		bne.s	loc_9082
		move.b	#1,objoff_35(a0)
		bsr.w	FindNextFreeObj
		bne.s	loc_9082
		_move.b	#id_GrassFire,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	objoff_2C(a0),objoff_2C(a1)
		addq.w	#8,objoff_2C(a1)
		subq.w	#3,objoff_2C(a1)
		subi.w	#$40,obX(a1)
		move.l	objoff_30(a0),objoff_30(a1)
		move.l	a0,objoff_38(a1)
		movea.l	a0,a2
		bsr.s	sub_90A4

loc_9082:
		moveq	#0,d2
		lea	objoff_36(a0),a2
		move.b	(a2)+,d2
		subq.b	#1,d2
		bcs.s	locret_90A2

loc_908E:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.w	#v_objspace,d0
		movea.w	d0,a1
		move.w	d1,objoff_3C(a1)
		dbf	d2,loc_908E

locret_90A2:
		rts
; ---------------------------------------------------------------------------

sub_90A4:
		lea	objoff_36(a2),a2
		moveq	#0,d0
		move.b	(a2),d0
		addq.b	#1,(a2)
		lea	1(a2,d0.w),a2
		move.w	a1,d0
		subi.w	#v_objspace,d0
		lsr.w	#object_size_bits,d0
		andi.w	#$7F,d0
		move.b	d0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_90C2:
		tst.b	objoff_35(a0)
		beq.s	loc_90CE
		tst.b	obRender(a0)
		bpl.s	loc_90EE

loc_90CE:
		out_of_range.w	DeleteObject,objoff_2A(a0)
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ---------------------------------------------------------------------------

loc_90EE:
		moveq	#0,d2

loc_90F0:
		lea	objoff_36(a0),a2
		move.b	(a2),d2
		clr.b	(a2)+
		subq.b	#1,d2
		bcs.s	locret_911E

loc_90FC:
		moveq	#0,d0
		move.b	(a2),d0
		clr.b	(a2)+
		lsl.w	#object_size_bits,d0
		addi.w	#v_objspace,d0
		movea.w	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,loc_90FC
		move.b	#0,objoff_35(a0)
		move.b	#0,objoff_34(a0)

locret_911E:
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ---------------------------------------------------------------------------

ObjMZPlatforms_Slope1:dc.b $20, $20, $20, $20, $20
		dc.b $20, $20, $20, $20, $20
		dc.b $20, $20, $20, $20, $21
		dc.b $22, $23, $24, $25, $26
		dc.b $27, $28, $29, $2A, $2B
		dc.b $2C, $2D, $2E, $2F, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $2F, $2E, $2D
		dc.b $2C, $2B, $2A, $29, $28
		dc.b $27, $26, $25, $24, $23
		dc.b $22, $21, $20, $20, $20
		dc.b $20, $20, $20, $20, $20
		dc.b $20, $20, $20, $20, $20
		dc.b $20

ObjMZPlatforms_Slope2:dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30

ObjMZPlatforms_Slope3:dc.b $20, $20, $20, $20, $20
		dc.b $20, $21, $22, $23, $24
		dc.b $25, $26, $27, $28, $29
		dc.b $2A, $2B, $2C, $2D, $2E
		dc.b $2F, $30, $31, $32, $33
		dc.b $34, $35, $36, $37, $38
		dc.b $39, $3A, $3B, $3C, $3D
		dc.b $3E, $3F, $40, $40, $40
		dc.b $40, $40, $40, $40, $40
		dc.b $40, $40, $40, $40, $40
		dc.b $40, $40, $40, $40, $40
		dc.b $3F, $3E, $3D, $3C, $3B
		dc.b $3A, $39, $38, $37, $36
		dc.b $35, $34, $33, $32, $31
		dc.b $30, $30, $30, $30, $30
		dc.b $30