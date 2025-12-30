; ---------------------------------------------------------------------------

ObjGHZBoss:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_B002(pc,d0.w),d1
		jmp	off_B002(pc,d1.w)
; ---------------------------------------------------------------------------

off_B002:	dc.w loc_B010-off_B002
		dc.w loc_B07C-off_B002
		dc.w loc_B2AE-off_B002
		dc.w loc_B2D6-off_B002

byte_B00A:	dc.b 2, 0
		dc.b 4, 1
		dc.b 6, 7
; ---------------------------------------------------------------------------

loc_B010:
		lea	(byte_B00A).l,a2
		movea.l	a0,a1
		moveq	#2,d1
		bra.s	loc_B022
; ---------------------------------------------------------------------------

loc_B01C:
		bsr.w	FindNextFreeObj
		bne.s	loc_B064

loc_B022:
		move.b	(a2)+,obRoutine(a1)
		_move.b	#id_BossGreenHill,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l	#Map_Eggman,obMap(a1)
		move.w	#make_art_tile(ArtTile_Eggman,0,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$20,obActWid(a1)
		move.b	#3,obPriority(a1)
		move.b	(a2)+,obAnim(a1)
		move.l	a0,objoff_34(a1)
		dbf	d1,loc_B01C

loc_B064:
		move.w	obX(a0),obBossX(a0)
		move.w	obY(a0),obBossY(a0)
		move.b	#$F,obColType(a0)
		move.b	#8,obColProp(a0)

loc_B07C:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	off_B0AA(pc,d0.w),d1
		jsr	off_B0AA(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		bsr.w	AnimateSprite
		move.b	obStatus(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,obRender(a0)
		or.b	d0,obRender(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_B0AA:	dc.w loc_B0B6-off_B0AA
		dc.w loc_B1AE-off_B0AA
		dc.w loc_B1FC-off_B0AA
		dc.w loc_B236-off_B0AA
		dc.w loc_B25C-off_B0AA
		dc.w loc_B290-off_B0AA
; ---------------------------------------------------------------------------

loc_B0B6:
		move.w	#$100,obVelY(a0)
		bsr.w	BossMove
		cmpi.w	#$338,obBossY(a0)
		bne.s	loc_B0D2
		move.w	#0,obVelY(a0)
		addq.b	#2,ob2ndRout(a0)

loc_B0D2:
		move.b	objoff_3F(a0),d0
		jsr	(CalcSine).l
		asr.w	#6,d0
		add.w	obBossY(a0),d0
		move.w	d0,obY(a0)
		move.w	obBossX(a0),obX(a0)
		addq.b	#2,objoff_3F(a0)
		cmpi.b	#8,ob2ndRout(a0)
		bcc.s	locret_B136
		tst.b	obStatus(a0)
		bmi.s	loc_B138
		tst.b	obColType(a0)
		bne.s	locret_B136
		tst.b	objoff_3E(a0)
		bne.s	loc_B11A
		move.b	#$20,objoff_3E(a0)
		move.w	#sfx_HitBoss,d0
		jsr	(QueueSound2).l

loc_B11A:
		lea	(v_palette+$22).w,a1
		moveq	#0,d0
		tst.w	(a1)
		bne.s	loc_B128
		move.w	#cWhite,d0

loc_B128:
		move.w	d0,(a1)
		subq.b	#1,objoff_3E(a0)
		bne.s	locret_B136
		move.b	#$F,obColType(a0)

locret_B136:
		rts
; ---------------------------------------------------------------------------

loc_B138:
		move.b	#8,ob2ndRout(a0)
		move.w	#179,objoff_3C(a0)
		rts