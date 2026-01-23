; ---------------------------------------------------------------------------
; Object 48 - ball on a chain that Eggman swings (GHZ)
; ---------------------------------------------------------------------------

BossBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	GBall_Index(pc,d0.w),d1
		jmp	GBall_Index(pc,d1.w)
; ===========================================================================
GBall_Index:	dc.w GBall_Main-GBall_Index
		dc.w GBall_Base-GBall_Index
		dc.w GBall_Display2-GBall_Index
		dc.w loc_B49E-GBall_Index
		dc.w GBall_ChkVanish-GBall_Index
; ===========================================================================

GBall_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$4080,obAngle(a0)
		move.w	#-$200,objoff_3E(a0)
		move.l	#Map_BossItems,obMap(a0)
		move.w	#make_art_tile(ArtTile_Eggman_Weapons,0,0),obGfx(a0)
		lea	obSubtype(a0),a2
		move.b	#0,(a2)+
		moveq	#5,d1
		movea.l	a0,a1
		bra.s	loc_B3AC
; ===========================================================================

GBall_MakeLinks:
		bsr.w	FindNextFreeObj
		bne.s	GBall_MakeBall
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		_move.b	#id_BossBall,obID(a1) ; load chain link object
		move.b	#6,obRoutine(a1)
		move.l	#Map_Swing_GHZ,obMap(a1)
		move.w	#make_art_tile(ArtTile_GHZ_MZ_Swing,0,0),obGfx(a1)
		move.b	#1,obFrame(a1)
		addq.b	#1,obSubtype(a0)

loc_B3AC:
		move.w	a1,d5
		subi.w	#v_objspace,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#4,obRender(a1)
		move.b	#8,obActWid(a1)
		move.b	#6,obPriority(a1)
		move.l	objoff_34(a0),objoff_34(a1)
		dbf	d1,GBall_MakeLinks ; repeat sequence 5 more times

GBall_MakeBall:
		move.b	#8,obRoutine(a1)
		move.l	#Map_GBall,obMap(a1) ; load different mappings for final link
		move.w	#make_art_tile(ArtTile_GHZ_Giant_Ball,2,0),obGfx(a1) ; use different graphics
		move.b	#1,obFrame(a1)
		move.b	#5,obPriority(a1)
		move.b	#$81,obColType(a1) ; make object hurt Sonic
		rts
; ===========================================================================

GBall_PosData:	dc.b 0, $10, $20, $30, $40, $60	; y-position data for links and giant ball

; ===========================================================================

GBall_Base:	; Routine 2
		lea	(GBall_PosData).l,a3
		lea	obSubtype(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_B412:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#object_size_bits,d4
		addi.l	#v_objspace&$FFFFFF,d4
		movea.l	d4,a1
		move.b	(a3)+,d0
		cmp.b	objoff_3C(a1),d0
		beq.s	loc_B42C
		addq.b	#1,objoff_3C(a1)

loc_B42C:
		dbf	d6,loc_B412

		cmp.b	objoff_3C(a1),d0
		bne.s	loc_B446
		movea.l	objoff_34(a0),a1
		cmpi.b	#6,ob2ndRout(a1)
		bne.s	loc_B446
		addq.b	#2,obRoutine(a0)

loc_B446:
		cmpi.w	#$20,objoff_32(a0)
		beq.s	GBall_Display
		addq.w	#1,objoff_32(a0)

GBall_Display:
		bsr.w	sub_B46E
		move.b	obAngle(a0),d0
		bsr.w	Swing_Move2
		bra.w	DisplaySprite
; ===========================================================================

GBall_Display2:	; Routine 4
		bsr.w	sub_B46E
		bsr.w	Obj48_Move
		bra.w	DisplaySprite
; ===========================================================================

sub_B46E:
		movea.l	objoff_34(a0),a1
		move.w	obX(a1),objoff_3A(a0)
		move.w	obY(a1),d0
		add.w	objoff_32(a0),d0
		move.w	d0,objoff_38(a0)
		move.b	obStatus(a1),obStatus(a0)
		tst.b	obStatus(a1)
		bpl.s	locret_B49C
		_move.b	#id_ExplosionBomb,obID(a0)
		move.b	#0,obRoutine(a0)

locret_B49C:
		rts
; ===========================================================================

loc_B49E:	; Routine 6
		movea.l	objoff_34(a0),a1
		tst.b	obStatus(a1)
		bpl.s	GBall_Display3
		_move.b	#id_ExplosionBomb,obID(a0)
		move.b	#0,obRoutine(a0)

GBall_Display3:
		bra.w	DisplaySprite
; ===========================================================================

GBall_ChkVanish:	; Routine 8
		moveq	#0,d0
		tst.b	obFrame(a0)
		bne.s	GBall_Vanish
		addq.b	#1,d0

GBall_Vanish:
		move.b	d0,obFrame(a0)
		movea.l	objoff_34(a0),a1
		tst.b	obStatus(a1)
		bpl.w	DisplaySprite
		move.b	#0,obColType(a0)
		bsr.w	BossDefeated
		subq.b	#1,objoff_3C(a0)
		bpl.s	GBall_Display4
		_move.b	#id_ExplosionBomb,obID(a0)
		move.b	#0,obRoutine(a0)

GBall_Display4:
		bra.w	DisplaySprite