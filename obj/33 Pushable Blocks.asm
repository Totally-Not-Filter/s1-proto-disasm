; ---------------------------------------------------------------------------

PushBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_9F10(pc,d0.w),d1
		jmp	off_9F10(pc,d1.w)
; ---------------------------------------------------------------------------
off_9F10:	dc.w loc_9F1A-off_9F10
		dc.w loc_9F84-off_9F10
		dc.w loc_A00C-off_9F10

byte_9F16:	dc.b $10, 0
		dc.b $40, 1
; ---------------------------------------------------------------------------

loc_9F1A:
		addq.b	#2,obRoutine(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.l	#Map_Push,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Block,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		andi.w	#$E,d0
		lea	byte_9F16(pc,d0.w),a2
		move.b	(a2)+,obActWid(a0)
		move.b	(a2)+,obFrame(a0)
		tst.b	obSubtype(a0)
		beq.s	loc_9F68
		move.w	#make_art_tile(ArtTile_MZ_Block,2,1),obGfx(a0)

loc_9F68:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	loc_9F84
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		bne.w	DeleteObject

loc_9F84:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	obX(a0),d4
		bsr.w	sub_A14E
		cmpi.w	#id_MZ<<8+0,(v_zone).w
		bne.s	loc_9FD4
		bclr	#7,obSubtype(a0)
		move.w	obX(a0),d0
		cmpi.w	#$A20,d0
		bcs.s	loc_9FD4
		cmpi.w	#$AA1,d0
		bcc.s	loc_9FD4
		move.w	(v_obj31ypos).w,d0
		subi.w	#$1C,d0
		move.w	d0,obY(a0)
		bset	#7,(v_obj31ypos).w
		bset	#7,obSubtype(a0)

loc_9FD4:
	if FixBugs
		out_of_range.s	loc_9FF6
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.s	loc_9FF6
		rts
	endif
; ---------------------------------------------------------------------------

loc_9FF6:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	loc_A008
		bclr	#0,2(a2,d0.w)

loc_A008:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

loc_A00C:
		move.w	obX(a0),-(sp)
		cmpi.b	#4,ob2ndRout(a0)
		bcc.s	loc_A01C
		bsr.w	SpeedToPos

loc_A01C:
		btst	#1,obStatus(a0)
		beq.s	loc_A05E
		addi.w	#$18,obVelY(a0)
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.w	loc_A05C
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)
		bclr	#1,obStatus(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2D2,d0
		bcs.s	loc_A05C
		move.w	objoff_30(a0),d0
		asr.w	#3,d0
		move.w	d0,obVelX(a0)
		clr.w	obY+2(a0)

loc_A05C:
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A05E:
		tst.w	obVelX(a0)
		beq.w	loc_A090
		bmi.s	loc_A078
		moveq	#0,d3
		move.b	obActWid(a0),d3
		bsr.w	ObjHitWallRight
		tst.w	d1
		bmi.s	loc_A08A
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A078:
		moveq	#0,d3
		move.b	obActWid(a0),d3
		not.w	d3
		bsr.w	ObjHitWallLeft
		tst.w	d1
		bmi.s	loc_A08A
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A08A:
		clr.w	obVelX(a0)
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A090:
		addi.l	#$2001,obY(a0)
		cmpi.b	#$A0,obY+3(a0)
		bcc.s	loc_A0CC

loc_A0A0:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	(sp)+,d4
		bsr.w	sub_A14E
		cmpi.b	#4,obRoutine(a0)
		beq.s	loc_A0C6
		move.b	#4,obRoutine(a0)

loc_A0C6:
		bsr.s	sub_A0E2
		bra.w	loc_9FD4
; ---------------------------------------------------------------------------

loc_A0CC:
		move.w	(sp)+,d4
		lea	(v_player).w,a1
		bclr	#3,obStatus(a1)
		bclr	#3,obStatus(a0)
		bra.w	loc_9FF6
; ---------------------------------------------------------------------------

sub_A0E2:
		cmpi.w	#id_MZ<<8+1,(v_zone).w
		bne.s	loc_A108
		move.w	#-$20,d2
		cmpi.w	#$DD0,obX(a0)
		beq.s	loc_A126
		cmpi.w	#$CC0,obX(a0)
		beq.s	loc_A126
		cmpi.w	#$BA0,obX(a0)
		beq.s	loc_A126
		rts
; ---------------------------------------------------------------------------

loc_A108:
		cmpi.w	#id_MZ<<8+2,(v_zone).w
		bne.s	locret_A124
		move.w	#$20,d2
		cmpi.w	#$560,obX(a0)
		beq.s	loc_A126
		cmpi.w	#$5C0,obX(a0)
		beq.s	loc_A126

locret_A124:
		rts
; ---------------------------------------------------------------------------

loc_A126:
		bsr.w	FindFreeObj
		bne.s	locret_A14C
		_move.b	#id_GeyserMaker,obID(a1)
		move.w	obX(a0),obX(a1)
		add.w	d2,obX(a1)
		move.w	obY(a0),obY(a1)
		addi.w	#$10,obY(a1)
		move.l	a0,objoff_3C(a1)

locret_A14C:
		rts
; ---------------------------------------------------------------------------

sub_A14E:
		move.b	ob2ndRout(a0),d0
		beq.w	loc_A1DE
		subq.b	#2,d0
		bne.s	loc_A172
		bsr.w	ExitPlatform
		btst	#3,obStatus(a1)
		bne.s	loc_A16C
		clr.b	ob2ndRout(a0)
		rts
; ---------------------------------------------------------------------------

loc_A16C:
		move.w	d4,d2
		bra.w	PtfmSurfaceHeight
; ---------------------------------------------------------------------------

loc_A172:
		subq.b	#2,d0
		bne.s	loc_A1B8
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.w	locret_A1B6
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)
		clr.b	ob2ndRout(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2D2,d0
		bcs.s	locret_A1B6
		move.w	objoff_30(a0),d0
		asr.w	#3,d0
		move.w	d0,obVelX(a0)
		move.b	#4,obRoutine(a0)
		clr.w	obY+2(a0)

locret_A1B6:
		rts
; ---------------------------------------------------------------------------

loc_A1B8:
		bsr.w	SpeedToPos
		move.w	obX(a0),d0
		andi.w	#$C,d0
		bne.w	locret_A29A
		andi.w	#$FFF0,obX(a0)
		move.w	obVelX(a0),objoff_30(a0)
		clr.w	obVelX(a0)
		subq.b	#2,ob2ndRout(a0)
		rts
; ---------------------------------------------------------------------------

loc_A1DE:
		bsr.w	loc_A37C
		tst.w	d4
		beq.w	locret_A29A
		bmi.w	locret_A29A
		tst.w	d0
		beq.w	locret_A29A
		bmi.s	loc_A222
		btst	#0,obStatus(a1)
		bne.w	locret_A29A
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	obActWid(a0),d3
		bsr.w	ObjHitWallRight
		move.w	(sp)+,d0
		tst.w	d1
		bmi.w	locret_A29A
		addi.l	#$10000,obX(a0)
		moveq	#1,d0
		move.w	#$40,d1
		bra.s	loc_A24C
; ---------------------------------------------------------------------------

loc_A222:
		btst	#0,obStatus(a1)
		beq.s	locret_A29A
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	obActWid(a0),d3
		not.w	d3
		bsr.w	ObjHitWallLeft
		move.w	(sp)+,d0
		tst.w	d1
		bmi.s	locret_A29A
		subi.l	#$10000,obX(a0)
		moveq	#-1,d0
		move.w	#-$40,d1

loc_A24C:
		lea	(v_player).w,a1
		add.w	d0,obX(a1)
		move.w	d1,obInertia(a1)
		move.w	#0,obVelX(a1)
		move.w	d0,-(sp)
		move.w	#sfx_Push,d0
		jsr	(QueueSound2).l
		move.w	(sp)+,d0
		tst.b	obSubtype(a0)
		bmi.s	locret_A29A
		move.w	d0,-(sp)
		bsr.w	ObjFloorDist
		move.w	(sp)+,d0
		cmpi.w	#4,d1
		ble.s	loc_A296
		move.w	#$400,obVelX(a0)
		tst.w	d0
		bpl.s	loc_A28E
		neg.w	obVelX(a0)

loc_A28E:
		move.b	#6,ob2ndRout(a0)
		bra.s	locret_A29A
; ---------------------------------------------------------------------------

loc_A296:
		add.w	d1,obY(a0)

locret_A29A:
		rts