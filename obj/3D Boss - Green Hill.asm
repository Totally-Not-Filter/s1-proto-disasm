; ---------------------------------------------------------------------------
; Object 3D - Eggman (GHZ)
; ---------------------------------------------------------------------------

BossGreenHill:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	BGHZ_Index(pc,d0.w),d1
		jmp	BGHZ_Index(pc,d1.w)
; ===========================================================================
BGHZ_Index:	dc.w BGHZ_Main-BGHZ_Index
		dc.w BGHZ_ShipMain-BGHZ_Index
		dc.w BGHZ_FaceMain-BGHZ_Index
		dc.w BGHZ_FlameMain-BGHZ_Index

BGHZ_ObjData:	dc.b 2, 0		; routine counter, animation
		dc.b 4, 1
		dc.b 6, 7
; ===========================================================================

BGHZ_Main:	; Routine 0
		lea	(BGHZ_ObjData).l,a2
		movea.l	a0,a1
		moveq	#2,d1
		bra.s	BGHZ_LoadBoss
; ===========================================================================

BGHZ_Loop:
		bsr.w	FindNextFreeObj
		bne.s	loc_B064

BGHZ_LoadBoss:
		move.b	(a2)+,obRoutine(a1)
		_move.b	#id_BossGreenHill,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l	#Map_Eggman,obMap(a1)
		move.w	#ArtTile_Eggman,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$20,obActWid(a1)
		move.b	#3,obPriority(a1)
		move.b	(a2)+,obAnim(a1)
		move.l	a0,objoff_34(a1)
		dbf	d1,BGHZ_Loop	; repeat sequence 2 more times

loc_B064:
		move.w	obX(a0),obBossX(a0)
		move.w	obY(a0),obBossY(a0)
		move.b	#$F,obColType(a0)
		move.b	#8,obColProp(a0) ; set number of hits to 8

BGHZ_ShipMain:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	BGHZ_ShipIndex(pc,d0.w),d1
		jsr	BGHZ_ShipIndex(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		bsr.w	AnimateSprite
		move.b	obStatus(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,obRender(a0)
		or.b	d0,obRender(a0)
		bra.w	DisplaySprite
; ===========================================================================
BGHZ_ShipIndex:	dc.w BGHZ_ShipStart-BGHZ_ShipIndex
		dc.w BGHZ_MakeBall-BGHZ_ShipIndex
		dc.w BGHZ_ShipMove-BGHZ_ShipIndex
		dc.w loc_B236-BGHZ_ShipIndex
		dc.w loc_B25C-BGHZ_ShipIndex
		dc.w loc_B290-BGHZ_ShipIndex
; ===========================================================================

BGHZ_ShipStart:
		move.w	#$100,obVelY(a0) ; move ship down
		bsr.w	BossMove
		cmpi.w	#boss_ghz_y+$38,obBossY(a0)
		bne.s	loc_B0D2
		move.w	#0,obVelY(a0)	; stop ship
		addq.b	#2,ob2ndRout(a0) ; goto next routine

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
		bne.s	BGHZ_ShipFlash
		move.b	#$20,objoff_3E(a0)	; set number of times for ship to flash
		move.w	#sfx_HitBoss,d0
		jsr	(QueueSound2).l	; play boss damage sound

BGHZ_ShipFlash:
		lea	(v_palette_line_2+2).w,a1 ; load 2nd palette, 2nd entry
		moveq	#0,d0		; move 0 (black) to d0
		tst.w	(a1)
		bne.s	loc_B128
		move.w	#cWhite,d0	; move 0EEE (white) to d0

loc_B128:
		move.w	d0,(a1)		; load colour stored in d0
		subq.b	#1,objoff_3E(a0)
		bne.s	locret_B136
		move.b	#$F,obColType(a0)

locret_B136:
		rts
; ===========================================================================

loc_B138:
		move.b	#8,ob2ndRout(a0)
		move.w	#179,objoff_3C(a0)
		rts

BossDefeated:
		move.b	(v_vint_byte).w,d0
		andi.b	#7,d0
		bne.s	locret_B186
		bsr.w	FindFreeObj
		bne.s	locret_B186
		_move.b	#id_ExplosionBomb,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,obX(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,obY(a1)

locret_B186:
		rts
; ===========================================================================

BossMove:
		move.l	obBossX(a0),d2
		move.l	obBossY(a0),d3
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	obVelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,obBossX(a0)
		move.l	d3,obBossY(a0)
		rts

BGHZ_MakeBall:
		move.w	#-$100,obVelX(a0)
		move.w	#-$40,obVelY(a0)
		bsr.w	BossMove
		cmpi.w	#$2A00,obBossX(a0)
		bne.s	loc_B1F8
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,ob2ndRout(a0)
		bsr.w	FindNextFreeObj
		bne.s	loc_B1F2
		_move.b	#id_BossBall,obID(a1) ; load swinging ball object
		move.w	obBossX(a0),obX(a1)
		move.w	obBossY(a0),obY(a1)
		move.l	a0,objoff_34(a1)

loc_B1F2:
		move.w	#$77,objoff_3C(a0)

loc_B1F8:
		bra.w	loc_B0D2
; ===========================================================================

BGHZ_ShipMove:
		subq.w	#1,objoff_3C(a0)
		bpl.s	BGHZ_Reverse
		addq.b	#2,ob2ndRout(a0)
		move.w	#$40-1,objoff_3C(a0)
		move.w	#$100,obVelX(a0) ; move the ship sideways
		cmpi.w	#$2A00,obBossX(a0)
		bne.s	BGHZ_Reverse
		move.w	#($40*2)-1,objoff_3C(a0)
		move.w	#$40,obVelX(a0)

BGHZ_Reverse:
		btst	#0,obStatus(a0)
		bne.s	loc_B232
		neg.w	obVelX(a0)	; reverse direction of the ship

loc_B232:
		bra.w	loc_B0D2
; ===========================================================================

loc_B236:
		subq.w	#1,objoff_3C(a0)
		bmi.s	loc_B242
		bsr.w	BossMove
		bra.s	loc_B258
; ===========================================================================

loc_B242:
		bchg	#0,obStatus(a0)
		move.w	#$40-1,objoff_3C(a0)
		subq.b	#2,ob2ndRout(a0)
		move.w	#0,obVelX(a0)

loc_B258:
		bra.w	loc_B0D2
; ===========================================================================

loc_B25C:
		subq.w	#1,objoff_3C(a0)
		bmi.s	loc_B266
		bra.w	BossDefeated
; ===========================================================================

loc_B266:
		bset	#0,obStatus(a0)
		bclr	#7,obStatus(a0)
		move.w	#$400,obVelX(a0)
		move.w	#-$40,obVelY(a0)
		addq.b	#2,ob2ndRout(a0)
		tst.b	(v_bossstatus).w
		bne.s	locret_B28E
		move.b	#1,(v_bossstatus).w

locret_B28E:
		rts
; ===========================================================================

loc_B290:
		cmpi.w	#$2AC0,(v_limitright2).w
		beq.s	loc_B29E
		addq.w	#2,(v_limitright2).w
		bra.s	loc_B2A6
; ===========================================================================

loc_B29E:
		tst.b	obRender(a0)
	if FixBugs
		bpl.s	BGHZ_ShipDel
	else
		bpl.w	DeleteObject
	endif

loc_B2A6:
		bsr.w	BossMove
		bra.w	loc_B0D2
	if FixBugs
; ===========================================================================
BGHZ_ShipDel:
		; We do not want to return to BGHZ_ShipMain, as objects
		; should not queue themselves for display while also being
		; deleted.
		addq.l	#4,sp
		bra.w	DeleteObject
	endif
; ===========================================================================

BGHZ_FaceMain:	; Routine 4
		movea.l	objoff_34(a0),a1
		cmpi.b	#$A,ob2ndRout(a1)
		bne.s	loc_B2C2
		tst.b	obRender(a0)
		bpl.w	DeleteObject

loc_B2C2:
		move.b	#1,obAnim(a0)
		tst.b	obColType(a1)
		bne.s	BGHZ_FaceDisp
		move.b	#5,obAnim(a0)

BGHZ_FaceDisp:
		bra.s	BGHZ_Display
; ===========================================================================

BGHZ_FlameMain:	; Routine 6
		movea.l	objoff_34(a0),a1
		cmpi.b	#$A,ob2ndRout(a1)
		bne.s	loc_B2EA
		tst.b	obRender(a0)
		bpl.w	DeleteObject

loc_B2EA:
		move.b	#7,obAnim(a0)
		move.w	obVelX(a1),d0
		beq.s	BGHZ_Display
		move.b	#8,obAnim(a0)

BGHZ_Display:
		movea.l	objoff_34(a0),a1
		move.w	obX(a1),obX(a0)
		move.w	obY(a1),obY(a0)
		move.b	obStatus(a1),obStatus(a0)
		lea	(Ani_Eggman).l,a1
		bsr.w	AnimateSprite
		move.b	obStatus(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,obRender(a0)
		or.b	d0,obRender(a0)
		bra.w	DisplaySprite