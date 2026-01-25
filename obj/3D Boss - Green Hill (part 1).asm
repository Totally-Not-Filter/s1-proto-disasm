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
		move.w	#make_art_tile(ArtTile_Eggman,0,0),obGfx(a1)
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
		cmpi.w	#$338,obBossY(a0)
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
		lea	(v_palette+$22).w,a1 ; load 2nd palette, 2nd entry
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