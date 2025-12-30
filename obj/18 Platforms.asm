; ---------------------------------------------------------------------------

ObjPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_5918(pc,d0.w),d1
		jmp	off_5918(pc,d1.w)
; ---------------------------------------------------------------------------

off_5918:	dc.w loc_5922-off_5918
		dc.w loc_59AE-off_5918
		dc.w loc_59D2-off_5918
		dc.w loc_5BCE-off_5918
		dc.w loc_59C2-off_5918
; ---------------------------------------------------------------------------

loc_5922:
		addq.b	#2,obRoutine(a0)
		move.w	#make_art_tile(ArtTile_Level,2,0),obGfx(a0)
		move.l	#Map_Plat_GHZ,obMap(a0)
		move.b	#$20,obActWid(a0)
		cmpi.b	#id_SZ,(v_zone).w
		bne.s	loc_5950
		move.l	#Map_Plat_SZ,obMap(a0)
		move.b	#$20,obActWid(a0)

loc_5950:
		cmpi.b	#id_SLZ,(v_zone).w
		bne.s	loc_5972
		move.l	#Map_Plat_SLZ,obMap(a0)
		move.b	#$20,obActWid(a0)
		move.w	#make_art_tile(ArtTile_SLZ_Platform,2,0),obGfx(a0)
		move.b	#3,obSubtype(a0)

loc_5972:
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.w	obY(a0),objoff_2C(a0)
		move.w	obY(a0),objoff_34(a0)
		move.w	obX(a0),objoff_32(a0)
		move.w	#$80,obAngle(a0)
		moveq	#0,d1
		move.b	obSubtype(a0),d0
		cmpi.b	#$A,d0
		bne.s	loc_59AA
		addq.b	#1,d1
		move.b	#$20,obActWid(a0)

loc_59AA:
		move.b	d1,obFrame(a0)

loc_59AE:
		tst.b	objoff_38(a0)
		beq.s	loc_59B8
		subq.b	#4,objoff_38(a0)

loc_59B8:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		bsr.w	PtfmNormal

loc_59C2:
		bsr.w	sub_5A1E
		bsr.w	sub_5A04
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	loc_5BB0
; ---------------------------------------------------------------------------

loc_59D2:
		cmpi.b	#$40,objoff_38(a0)
		beq.s	loc_59DE
		addq.b	#4,objoff_38(a0)

loc_59DE:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		bsr.w	PtfmCheckExit
		move.w	obX(a0),-(sp)
		bsr.w	sub_5A1E
		bsr.w	sub_5A04
		move.w	(sp)+,d2
		bsr.w	ptfmSurfaceNormal
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	loc_5BB0
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

sub_5A04:
		move.b	objoff_38(a0),d0
		bsr.w	CalcSine
		move.w	#$400,d1
		muls.w	d1,d0
		swap	d0
		add.w	objoff_2C(a0),d0
		move.w	d0,obY(a0)
		rts
; ---------------------------------------------------------------------------

sub_5A1E:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_5A32(pc,d0.w),d1
		jmp	off_5A32(pc,d1.w)
; ---------------------------------------------------------------------------

off_5A32:	dc.w locret_5A4C-off_5A32
		dc.w loc_5A5E-off_5A32
		dc.w loc_5AA4-off_5A32
		dc.w loc_5ABC-off_5A32
		dc.w loc_5AE4-off_5A32
		dc.w loc_5A4E-off_5A32
		dc.w loc_5A94-off_5A32
		dc.w loc_5B4E-off_5A32
		dc.w loc_5B7A-off_5A32
		dc.w locret_5A4C-off_5A32
		dc.w loc_5B92-off_5A32
		dc.w loc_5A86-off_5A32
		dc.w loc_5A76-off_5A32
; ---------------------------------------------------------------------------

locret_5A4C:
		rts
; ---------------------------------------------------------------------------

loc_5A4E:
		move.w	objoff_32(a0),d0
		move.b	obAngle(a0),d1
		neg.b	d1
		addi.b	#$40,d1
		bra.s	loc_5A6A
; ---------------------------------------------------------------------------

loc_5A5E:
		move.w	objoff_32(a0),d0
		move.b	obAngle(a0),d1
		subi.b	#$40,d1

loc_5A6A:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,obX(a0)
		bra.w	loc_5BA8
; ---------------------------------------------------------------------------

loc_5A76:
		move.w	objoff_34(a0),d0
		move.b	(v_oscillate+$E).w,d1
		neg.b	d1
		addi.b	#$30,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5A86:
		move.w	objoff_34(a0),d0
		move.b	(v_oscillate+$E).w,d1
		subi.b	#$30,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5A94:
		move.w	objoff_34(a0),d0
		move.b	obAngle(a0),d1
		neg.b	d1
		addi.b	#$40,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5AA4:
		move.w	objoff_34(a0),d0
		move.b	obAngle(a0),d1
		subi.b	#$40,d1

loc_5AB0:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,objoff_2C(a0)
		bra.w	loc_5BA8
; ---------------------------------------------------------------------------

loc_5ABC:
		tst.w	objoff_3A(a0)
		bne.s	loc_5AD2
		btst	#3,obStatus(a0)
		beq.s	locret_5AD0
		move.w	#$1E,objoff_3A(a0)

locret_5AD0:
		rts
; ---------------------------------------------------------------------------

loc_5AD2:
		subq.w	#1,objoff_3A(a0)
		bne.s	locret_5AD0
		move.w	#$20,objoff_3A(a0)
		addq.b	#1,obSubtype(a0)
		rts
; ---------------------------------------------------------------------------

loc_5AE4:
		tst.w	objoff_3A(a0)
		beq.s	loc_5B20
		subq.w	#1,objoff_3A(a0)
		bne.s	loc_5B20
		btst	#3,obStatus(a0)
		beq.s	loc_5B1A
		bset	#status_in_air,obStatus(a1)
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a1)
		bclr	#3,obStatus(a0)
		clr.b	obSolid(a0)
		move.w	obVelY(a0),obVelY(a1)

loc_5B1A:
		move.b	#8,obRoutine(a0)

loc_5B20:
		move.l	objoff_2C(a0),d3
		move.w	obVelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d3,objoff_2C(a0)
		addi.w	#$38,obVelY(a0)
		move.w	(v_limitbtm2).w,d0
		addi.w	#224,d0
		cmp.w	objoff_2C(a0),d0
		bcc.s	locret_5B4C
		move.b	#6,obRoutine(a0)

locret_5B4C:
		rts
; ---------------------------------------------------------------------------

loc_5B4E:
		tst.w	objoff_3A(a0)
		bne.s	loc_5B6E
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#4,d0
		tst.b	(a2,d0.w)
		beq.s	locret_5B6C
		move.w	#$3C,objoff_3A(a0)

locret_5B6C:
		rts
; ---------------------------------------------------------------------------

loc_5B6E:
		subq.w	#1,objoff_3A(a0)
		bne.s	locret_5B6C
		addq.b	#1,obSubtype(a0)
		rts
; ---------------------------------------------------------------------------

loc_5B7A:
		subq.w	#2,objoff_2C(a0)
		move.w	objoff_34(a0),d0
		subi.w	#$200,d0
		cmp.w	objoff_2C(a0),d0
		bne.s	locret_5B90
		clr.b	obSubtype(a0)

locret_5B90:
		rts
; ---------------------------------------------------------------------------

loc_5B92:
		move.w	objoff_34(a0),d0
		move.b	obAngle(a0),d1
		subi.b	#$40,d1
		ext.w	d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	d0,objoff_2C(a0)

loc_5BA8:
		move.b	(v_oscillate+$1A).w,obAngle(a0)
		rts
; ---------------------------------------------------------------------------

loc_5BB0:
		out_of_range.s	loc_5BCE,objoff_32(a0)
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ---------------------------------------------------------------------------

loc_5BCE:
		bra.w	DeleteObject