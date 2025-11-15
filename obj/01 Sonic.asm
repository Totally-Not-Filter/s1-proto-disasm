; ---------------------------------------------------------------------------

SonicPlayer:
		tst.w	(v_debuguse).w
		bne.w	DebugMode
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_E826(pc,d0.w),d1
		jmp	off_E826(pc,d1.w)
; ---------------------------------------------------------------------------

off_E826:	dc.w loc_E830-off_E826
		dc.w loc_E872-off_E826
		dc.w Sonic_Hurt-off_E826
		dc.w Sonic_Death-off_E826
		dc.w Sonic_ResetLevel-off_E826
; ---------------------------------------------------------------------------

loc_E830:
		addq.b	#2,obRoutine(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#make_art_tile(ArtTile_Sonic,0,0),obGfx(a0)
		move.b	#2,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#4,obRender(a0)
		move.w	#$600,(v_sonspeedmax).w
		move.w	#$C,(v_sonspeedacc).w
		move.w	#$40,(v_sonspeeddec).w

loc_E872:
		andi.w	#$7FF,obY(a0)
		andi.w	#$7FF,(v_scrposy).w
		tst.w	(f_debugmode).w
		beq.s	loc_E892
		btst	#bitB,(v_jpadpress2).w
		beq.s	loc_E892
		move.w	#1,(v_debuguse).w

loc_E892:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		andi.w	#6,d0
		move.w	off_E8C8(pc,d0.w),d1
		jsr	off_E8C8(pc,d1.w)
		bsr.s	sub_E8D6
		bsr.w	sub_E952
		move.b	(v_anglebuffer).w,objoff_36(a0)
		move.b	(v_anglebuffer2).w,objoff_37(a0)
		bsr.w	Sonic_Animate
		bsr.w	TouchObjects
		bsr.w	Sonic_Loops
		bsr.w	Sonic_LoadGfx
		rts
; ---------------------------------------------------------------------------

off_E8C8:
		dc.w sub_E96C-off_E8C8
		dc.w sub_E98E-off_E8C8
		dc.w loc_E9A8-off_E8C8
		dc.w loc_E9C6-off_E8C8

MusicList2:	dc.b bgm_GHZ
		dc.b bgm_LZ
		dc.b bgm_MZ
		dc.b bgm_SLZ
		dc.b bgm_SZ
		dc.b bgm_CWZ
		even
; ---------------------------------------------------------------------------

sub_E8D6:
		move.w	flashtime(a0),d0
		beq.s	loc_E8E4
		subq.w	#1,flashtime(a0)
		lsr.w	#3,d0
		bcc.s	loc_E8E8

loc_E8E4:
		bsr.w	DisplaySprite

loc_E8E8:
		tst.b	(v_invinc).w
		beq.s	loc_E91C
		tst.w	invtime(a0)
		beq.s	loc_E91C
		subq.w	#1,invtime(a0)
		bne.s	loc_E91C
		tst.b	(f_lockscreen).w
		bne.s	loc_E916
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(MusicList2).l,a1
		move.b	(a1,d0.w),d0
		jsr	(PlaySound).l

loc_E916:
		move.b	#0,(v_invinc).w

loc_E91C:
		tst.b	(v_shoes).w
		beq.s	locret_E950
		tst.w	shoetime(a0)
		beq.s	locret_E950
		subq.w	#1,shoetime(a0)
		bne.s	locret_E950
		move.w	#$600,(v_sonspeedmax).w
		move.w	#$C,(v_sonspeedacc).w
		move.w	#$40,(v_sonspeeddec).w
		move.b	#0,(v_shoes).w
		move.w	#bgm_Slowdown,d0
		jmp	(PlaySound_Special).l
; ---------------------------------------------------------------------------

locret_E950:
		rts
; ---------------------------------------------------------------------------

sub_E952:
		move.w	(v_trackpos).w,d0
		lea	(v_tracksonic).w,a1
		lea	(a1,d0.w),a1
		move.w	obX(a0),(a1)+
		move.w	obY(a0),(a1)+
		addq.b	#4,(v_trackbyte).w
		rts
; ---------------------------------------------------------------------------

sub_E96C:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_SlopeResist
		bsr.w	Sonic_Move
		bsr.w	Sonic_Roll
		bsr.w	Sonic_LevelBound
		bsr.w	SpeedToPos
		bsr.w	Sonic_AnglePos
		bsr.w	Sonic_SlopeRepel
		rts
; ---------------------------------------------------------------------------

sub_E98E:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDirection
		bsr.w	Sonic_LevelBound
		bsr.w	ObjectFall
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
		rts
; ---------------------------------------------------------------------------

loc_E9A8:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_RollRepel
		bsr.w	Sonic_RollSpeed
		bsr.w	Sonic_LevelBound
		bsr.w	SpeedToPos
		bsr.w	Sonic_AnglePos
		bsr.w	Sonic_SlopeRepel
		rts
; ---------------------------------------------------------------------------

loc_E9C6:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDirection
		bsr.w	Sonic_LevelBound
		bsr.w	ObjectFall
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
		rts
; ---------------------------------------------------------------------------

Sonic_Move:
		move.w	(v_sonspeedmax).w,d6
		move.w	(v_sonspeedacc).w,d5
		move.w	(v_sonspeeddec).w,d4
		tst.w	ctrllock(a0)
		bne.w	Sonic_LookUp
		btst	#bitL,(v_jpadhold2).w
		beq.s	Sonic_NoLeft
		bsr.w	Sonic_MoveLeft

Sonic_NoLeft:
		btst	#bitR,(v_jpadhold2).w
		beq.s	Sonic_NoRight
		bsr.w	Sonic_MoveRight

Sonic_NoRight:
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.w	Sonic_ResetScroll
		tst.w	obInertia(a0)
		bne.w	Sonic_ResetScroll
		bclr	#5,obStatus(a0)
		move.b	#id_Wait,obAnim(a0)
		btst	#3,obStatus(a0)
		beq.s	Sonic_Balance
		moveq	#0,d0
		move.b	standonobject(a0),d0
		lsl.w	#object_size_bits,d0
		lea	(v_player).w,a1
		lea	(a1,d0.w),a1
		tst.b	obStatus(a1)
		bmi.s	Sonic_LookUp
		moveq	#0,d1
		move.b	obActWid(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2
		add.w	obX(a0),d1
		sub.w	obX(a1),d1
		cmpi.w	#4,d1
		blt.s	loc_EA92
		cmp.w	d2,d1
		bge.s	loc_EA82
		bra.s	Sonic_LookUp
; ---------------------------------------------------------------------------

Sonic_Balance:
		jsr	(ObjFloorDist).l
		cmpi.w	#$C,d1
		blt.s	Sonic_LookUp
		cmpi.b	#3,objoff_36(a0)
		bne.s	loc_EA8A

loc_EA82:
		bclr	#0,obStatus(a0)
		bra.s	loc_EA98
; ---------------------------------------------------------------------------

loc_EA8A:
		cmpi.b	#3,objoff_37(a0)
		bne.s	Sonic_LookUp

loc_EA92:
		bset	#0,obStatus(a0)

loc_EA98:
		move.b	#id_Balance,obAnim(a0)
		bra.s	Sonic_ResetScroll
; ---------------------------------------------------------------------------

Sonic_LookUp:
		btst	#bitUp,(v_jpadhold2).w
		beq.s	Sonic_Duck
		move.b	#id_LookUp,obAnim(a0)
		cmpi.w	#200,(v_lookshift).w
		beq.s	loc_EAEA
		addq.w	#2,(v_lookshift).w
		bra.s	loc_EAEA
; ---------------------------------------------------------------------------

Sonic_Duck:
		btst	#bitDn,(v_jpadhold2).w
		beq.s	Sonic_ResetScroll
		move.b	#id_Duck,obAnim(a0)
		cmpi.w	#8,(v_lookshift).w
		beq.s	loc_EAEA
		subq.w	#2,(v_lookshift).w
		bra.s	loc_EAEA
; ---------------------------------------------------------------------------

Sonic_ResetScroll:
		cmpi.w	#96,(v_lookshift).w
		beq.s	loc_EAEA
		bcc.s	loc_EAE6
		addq.w	#4,(v_lookshift).w

loc_EAE6:
		subq.w	#2,(v_lookshift).w

loc_EAEA:
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnL+btnR,d0
		bne.s	loc_EB16
		move.w	obInertia(a0),d0
		beq.s	loc_EB16
		bmi.s	loc_EB0A
		sub.w	d5,d0
		bcc.s	loc_EB04
		move.w	#0,d0

loc_EB04:
		move.w	d0,obInertia(a0)
		bra.s	loc_EB16
; ---------------------------------------------------------------------------

loc_EB0A:
		add.w	d5,d0
		bcc.s	loc_EB12
		move.w	#0,d0

loc_EB12:
		move.w	d0,obInertia(a0)

loc_EB16:
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		muls.w	obInertia(a0),d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	obInertia(a0),d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)

loc_EB34:
		move.b	#$40,d1
		tst.w	obInertia(a0)
		beq.s	locret_EB8E
		bmi.s	loc_EB42
		neg.w	d1

loc_EB42:
		move.b	obAngle(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	Sonic_WalkSpeed
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_EB8E
		move.w	#0,obInertia(a0)
		bset	#5,obStatus(a0)
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_EB8A
		cmpi.b	#$40,d0
		beq.s	loc_EB84
		cmpi.b	#$80,d0
		beq.s	loc_EB7E
		add.w	d1,obVelX(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB7E:
		sub.w	d1,obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB84:
		sub.w	d1,obVelX(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB8A:
		add.w	d1,obVelY(a0)

locret_EB8E:
		rts
; ---------------------------------------------------------------------------

Sonic_MoveLeft:
		move.w	obInertia(a0),d0
		beq.s	loc_EB98
		bpl.s	loc_EBC4

loc_EB98:
		bset	#0,obStatus(a0)
		bne.s	loc_EBAC
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obNextAni(a0)

loc_EBAC:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_EBB8
		move.w	d1,d0

loc_EBB8:
		move.w	d0,obInertia(a0)
		move.b	#id_Walk,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_EBC4:
		sub.w	d4,d0
		bcc.s	loc_EBCC
		move.w	#-$80,d0

loc_EBCC:
		move.w	d0,obInertia(a0)
	if FixBugs
		move.b	obAngle(a0),d1
		addi.b	#$20,d1
		andi.b	#$C0,d1
	else
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
	endif
		bne.s	locret_EBFA
		cmpi.w	#$400,d0
		blt.s	locret_EBFA
		move.b	#id_Stop,obAnim(a0)
		bclr	#0,obStatus(a0)
		move.w	#sfx_Skid,d0
		jsr	(PlaySound_Special).l

locret_EBFA:
		rts
; ---------------------------------------------------------------------------

Sonic_MoveRight:
		move.w	obInertia(a0),d0
		bmi.s	loc_EC2A
		bclr	#0,obStatus(a0)
		beq.s	loc_EC16
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obNextAni(a0)

loc_EC16:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_EC1E
		move.w	d6,d0

loc_EC1E:
		move.w	d0,obInertia(a0)
		move.b	#id_Walk,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_EC2A:
		add.w	d4,d0
		bcc.s	loc_EC32
		move.w	#$80,d0

loc_EC32:
		move.w	d0,obInertia(a0)
	if FixBugs
		move.b	obAngle(a0),d1
		addi.b	#$20,d1
		andi.b	#$C0,d1
	else
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
	endif
		bne.s	locret_EC60
		cmpi.w	#-$400,d0
		bgt.s	locret_EC60
		move.b	#id_Stop,obAnim(a0)
		bset	#0,obStatus(a0)
		move.w	#sfx_Skid,d0
		jsr	(PlaySound_Special).l

locret_EC60:
		rts
; ---------------------------------------------------------------------------

Sonic_RollSpeed:
		move.w	(v_sonspeedmax).w,d6
		asl.w	#1,d6
		move.w	(v_sonspeedacc).w,d5
		asr.w	#1,d5
		move.w	(v_sonspeeddec).w,d4
		asr.w	#2,d4
		tst.w	ctrllock(a0)
		bne.s	loc_EC92
		btst	#bitL,(v_jpadhold2).w
		beq.s	loc_EC86
		bsr.w	Sonic_RollLeft

loc_EC86:
		btst	#bitR,(v_jpadhold2).w
		beq.s	loc_EC92
		bsr.w	Sonic_RollRight

loc_EC92:
		move.w	obInertia(a0),d0
		beq.s	loc_ECB4
		bmi.s	loc_ECA8
		sub.w	d5,d0
		bcc.s	loc_ECA2
		move.w	#0,d0

loc_ECA2:
		move.w	d0,obInertia(a0)
		bra.s	loc_ECB4
; ---------------------------------------------------------------------------

loc_ECA8:
		add.w	d5,d0
		bcc.s	loc_ECB0
		move.w	#0,d0

loc_ECB0:
		move.w	d0,obInertia(a0)

loc_ECB4:
		tst.w	obInertia(a0)
		bne.s	loc_ECD6
		bclr	#2,obStatus(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.b	#id_Wait,obAnim(a0)
		subq.w	#5,obY(a0)

loc_ECD6:
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		muls.w	obInertia(a0),d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	obInertia(a0),d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)
		bra.w	loc_EB34
; ---------------------------------------------------------------------------

Sonic_RollLeft:
		move.w	obInertia(a0),d0
		beq.s	loc_ED00
		bpl.s	loc_ED0E

loc_ED00:
		bset	#0,obStatus(a0)
		move.b	#id_Roll,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_ED0E:
		sub.w	d4,d0
		bcc.s	loc_ED16
		move.w	#-$80,d0

loc_ED16:
		move.w	d0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_RollRight:
		move.w	obInertia(a0),d0
		bmi.s	loc_ED30
		bclr	#0,obStatus(a0)
		move.b	#id_Roll,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_ED30:
		add.w	d4,d0
		bcc.s	loc_ED38
		move.w	#$80,d0

loc_ED38:
		move.w	d0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_ChgJumpDirection:
		move.w	(v_sonspeedmax).w,d6
		move.w	(v_sonspeedacc).w,d5
		asl.w	#1,d5
		btst	#4,obStatus(a0)
		bne.s	Sonic_ResetScroll2
		move.w	obVelX(a0),d0
		btst	#bitL,(v_jpadhold1).w
		beq.s	loc_ED6E
		bset	#0,obStatus(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_ED6E
		move.w	d1,d0

loc_ED6E:
		btst	#bitR,(v_jpadhold1).w
		beq.s	Sonic_JumpMove
		bclr	#0,obStatus(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	Sonic_JumpMove
		move.w	d6,d0

Sonic_JumpMove:
		move.w	d0,obVelX(a0)

Sonic_ResetScroll2:
		cmpi.w	#96,(v_lookshift).w
		beq.s	loc_ED9A
		bcc.s	loc_ED96
		addq.w	#4,(v_lookshift).w

loc_ED96:
		subq.w	#2,(v_lookshift).w

loc_ED9A:
		cmpi.w	#-$400,obVelY(a0)
		bcs.s	locret_EDC8
		move.w	obVelX(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	locret_EDC8
		bmi.s	loc_EDBC
		sub.w	d1,d0
		bcc.s	loc_EDB6
		move.w	#0,d0

loc_EDB6:
		move.w	d0,obVelX(a0)
		rts
; ---------------------------------------------------------------------------

loc_EDBC:
		sub.w	d1,d0
		bcs.s	loc_EDC4
		move.w	#0,d0

loc_EDC4:
		move.w	d0,obVelX(a0)

locret_EDC8:
		rts
; ---------------------------------------------------------------------------
; unused
;Sonic_Squish:
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EDF8
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	locret_EDF8
		move.w	#0,obInertia(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		move.b	#id_Warp3,obAnim(a0)

locret_EDF8:
		rts
; ---------------------------------------------------------------------------

Sonic_LevelBound:
		move.l	obX(a0),d1
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(v_limitleft2).w,d0
		addi.w	#16,d0
		cmp.w	d1,d0
		bhi.s	Sonic_BoundSides
		move.w	(v_limitright2).w,d0
		addi.w	#320-24,d0
		cmp.w	d1,d0
		bls.s	Sonic_BoundSides
		move.w	(v_limitbtm2).w,d0
		addi.w	#224,d0
		cmp.w	obY(a0),d0
		bcs.w	loc_FD78
		rts
; ---------------------------------------------------------------------------

Sonic_BoundSides:
		move.w	d0,obX(a0)
		move.w	#0,obX+2(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_Roll:
		move.w	obInertia(a0),d0
		bpl.s	loc_EE54
		neg.w	d0

loc_EE54:
		cmpi.w	#$80,d0
		bcs.s	locret_EE6C
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnL+btnR,d0
		bne.s	locret_EE6C
		btst	#bitDn,(v_jpadhold2).w
		bne.s	Sonic_CheckRoll

locret_EE6C:
		rts
; ---------------------------------------------------------------------------

Sonic_CheckRoll:
		btst	#2,obStatus(a0)
		beq.s	Sonic_DoRoll
		rts
; ---------------------------------------------------------------------------

Sonic_DoRoll:
		bset	#2,obStatus(a0)
		move.b	#$E,obHeight(a0)
		move.b	#7,obWidth(a0)
		move.b	#id_Roll,obAnim(a0)
		addq.w	#5,obY(a0)
		move.w	#sfx_Roll,d0
		jsr	(PlaySound_Special).l
		tst.w	obInertia(a0)
		bne.s	locret_EEAA
		move.w	#$200,obInertia(a0)

locret_EEAA:
		rts
; ---------------------------------------------------------------------------

Sonic_Jump:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		beq.w	locret_EF46
		moveq	#0,d0
		move.b	obAngle(a0),d0
		addi.b	#$80,d0
		bsr.w	sub_10520
		cmpi.w	#6,d1
		blt.w	locret_EF46
		moveq	#0,d0
		move.b	obAngle(a0),d0
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	#$680,d1
		asr.l	#8,d1
		add.w	d1,obVelX(a0)
		muls.w	#$680,d0
		asr.l	#8,d0
		add.w	d0,obVelY(a0)
		bset	#status_in_air,obStatus(a0)	; set in air status
		bclr	#5,obStatus(a0)
		addq.l	#4,sp
		move.b	#1,jumpflag(a0)
		move.w	#sfx_Jump,d0
		jsr	(PlaySound_Special).l
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		tst.b	(f_victory).w			; has the victory animation flag been set?
		bne.s	loc_EF48				; if yes, branch
		btst	#2,obStatus(a0)
		bne.s	loc_EF50
		move.b	#$E,obHeight(a0)
		move.b	#7,obWidth(a0)
		move.b	#id_Roll,obAnim(a0)		; use "jumping" animation
		bset	#2,obStatus(a0)
		addq.w	#5,obY(a0)

locret_EF46:
		rts
; ---------------------------------------------------------------------------

loc_EF48:
		move.b	#id_Leap2,obAnim(a0)	; use the "victory leaping" animation
		rts
; ---------------------------------------------------------------------------

loc_EF50:
		bset	#4,obStatus(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_JumpHeight:
		tst.b	jumpflag(a0)
		beq.s	loc_EF78
		cmpi.w	#-$400,obVelY(a0)
		bge.s	locret_EF76
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnABC,d0
		bne.s	locret_EF76
		move.w	#-$400,obVelY(a0)

locret_EF76:
		rts
; ---------------------------------------------------------------------------

loc_EF78:
		cmpi.w	#-$FC0,obVelY(a0)
		bge.s	locret_EF86
		move.w	#-$FC0,obVelY(a0)

locret_EF86:
		rts
; ---------------------------------------------------------------------------

Sonic_SlopeResist:
		move.b	obAngle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_EFBC
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		muls.w	#32,d0
		asr.l	#8,d0
		tst.w	obInertia(a0)
		beq.s	locret_EFBC
		bmi.s	loc_EFB8
		tst.w	d0
		beq.s	locret_EFB6
		add.w	d0,obInertia(a0)

locret_EFB6:
		rts
; ---------------------------------------------------------------------------

loc_EFB8:
		add.w	d0,obInertia(a0)

locret_EFBC:
		rts
; ---------------------------------------------------------------------------

Sonic_RollRepel:
		move.b	obAngle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_EFF8
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		muls.w	#80,d0
		asr.l	#8,d0
		tst.w	obInertia(a0)
		bmi.s	loc_EFEE
		tst.w	d0
		bpl.s	loc_EFE8
		asr.l	#2,d0

loc_EFE8:
		add.w	d0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_EFEE:
		tst.w	d0
		bmi.s	loc_EFF4
		asr.l	#2,d0

loc_EFF4:
		add.w	d0,obInertia(a0)

locret_EFF8:
		rts
; ---------------------------------------------------------------------------

Sonic_SlopeRepel:
		nop
		tst.w	ctrllock(a0)
		bne.s	loc_F02C
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	locret_F02A
		move.w	obInertia(a0),d0
		bpl.s	loc_F018
		neg.w	d0

loc_F018:
		cmpi.w	#$280,d0
		bcc.s	locret_F02A
		bset	#status_in_air,obStatus(a0)	; set in air status
		move.w	#$1E,ctrllock(a0)

locret_F02A:
		rts
; ---------------------------------------------------------------------------

loc_F02C:
		subq.w	#1,ctrllock(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_JumpAngle:
		move.b	obAngle(a0),d0
		beq.s	locret_F04C
		bpl.s	loc_F042
		addq.b	#2,d0
		bcc.s	loc_F040
		moveq	#0,d0

loc_F040:
		bra.s	loc_F048
; ---------------------------------------------------------------------------

loc_F042:
		subq.b	#2,d0
		bcc.s	loc_F048
		moveq	#0,d0

loc_F048:
		move.b	d0,obAngle(a0)

locret_F04C:
		rts
; ---------------------------------------------------------------------------

Sonic_Floor:
		move.w	obVelX(a0),d1
		move.w	obVelY(a0),d2
		jsr	(CalcAngle).l
		subi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_F104
		cmpi.b	#$80,d0
		beq.w	loc_F160
		cmpi.b	#$C0,d0
		beq.w	loc_F1BC

loc_F07C:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F08E
		sub.w	d1,obX(a0)
		move.w	#0,obVelX(a0)

loc_F08E:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F0A0
		add.w	d1,obX(a0)
		move.w	#0,obVelX(a0)

loc_F0A0:
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F102
		move.b	obVelY(a0),d0
		addq.b	#8,d0
		neg.b	d0
		cmp.b	d0,d1
		blt.s	locret_F102
		add.w	d1,obY(a0)
		move.b	d3,obAngle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#id_Walk,obAnim(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_F0E0
		move.w	#0,obVelY(a0)
		move.w	obVelX(a0),obInertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_F0E0:
		move.w	#0,obVelX(a0)
		cmpi.w	#$FC0,obVelY(a0)
		ble.s	loc_F0F4
		move.w	#$FC0,obVelY(a0)

loc_F0F4:
		move.w	obVelY(a0),obInertia(a0)
		tst.b	d3
		bpl.s	locret_F102
		neg.w	obInertia(a0)

locret_F102:
		rts
; ---------------------------------------------------------------------------

loc_F104:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F11E
		sub.w	d1,obX(a0)
		move.w	#0,obVelX(a0)
		move.w	obVelY(a0),obInertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_F11E:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	loc_F132
		sub.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_F132:
		tst.w	obVelY(a0)
		bmi.s	locret_F15E
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F15E
		add.w	d1,obY(a0)
		move.b	d3,obAngle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#id_Walk,obAnim(a0)
		move.w	#0,obVelY(a0)
		move.w	obVelX(a0),obInertia(a0)

locret_F15E:
		rts
; ---------------------------------------------------------------------------

loc_F160:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F172
		sub.w	d1,obX(a0)
		move.w	#0,obVelX(a0)

loc_F172:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F184
		add.w	d1,obX(a0)
		move.w	#0,obVelX(a0)

loc_F184:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	locret_F1BA
		sub.w	d1,obY(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_F1A4
		move.w	#0,obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1A4:
		move.b	d3,obAngle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.w	obVelY(a0),obInertia(a0)
		tst.b	d3
		bpl.s	locret_F1BA
		neg.w	obInertia(a0)

locret_F1BA:
		rts
; ---------------------------------------------------------------------------

loc_F1BC:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F1D6
		add.w	d1,obX(a0)
		move.w	#0,obVelX(a0)
		move.w	obVelY(a0),obInertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1D6:
		bsr.w	Sonic_NoRunningOnWalls
		tst.w	d1
		bpl.s	loc_F1EA
		sub.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1EA:
		tst.w	obVelY(a0)
		bmi.s	locret_F216
		bsr.w	Sonic_HitFloor
		tst.w	d1
		bpl.s	locret_F216
		add.w	d1,obY(a0)
		move.b	d3,obAngle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#id_Walk,obAnim(a0)
		move.w	#0,obVelY(a0)
		move.w	obVelX(a0),obInertia(a0)

locret_F216:
		rts
; ---------------------------------------------------------------------------

Sonic_ResetOnFloor:
		btst	#4,obStatus(a0)
		beq.s	loc_F226
		nop
		nop
		nop

loc_F226:
		bclr	#5,obStatus(a0)
		bclr	#status_in_air,obStatus(a0)	; clear in air status
		bclr	#4,obStatus(a0)
		btst	#2,obStatus(a0)
		beq.s	loc_F25C
		bclr	#2,obStatus(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.b	#id_Walk,obAnim(a0)
		subq.w	#5,obY(a0)

loc_F25C:
		move.w	#0,ctrllock(a0)
		move.b	#0,jumpflag(a0)
		rts
; ---------------------------------------------------------------------------
; unused
;loc_F26A:
		lea	(v_objslot10).w,a1
		move.w	obX(a0),d0
		bsr.w	sub_F290
		lea	(v_objslot14).w,a1
		move.w	obY(a0),d0
		bsr.w	sub_F290
		lea	(v_objslot18).w,a1
		move.w	obInertia(a0),d0
		bsr.w	sub_F290
		rts
; ---------------------------------------------------------------------------

sub_F290:
		swap	d0
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,obFrame(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,object_size+obFrame(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,object_size*2+obFrame(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,object_size*3+obFrame(a1)
		rts

		include "obj/Sonic (part 2).asm"
; ---------------------------------------------------------------------------
		; unused
		dc.b $12
		dc.b 9
		dc.b $A
		dc.b $12
		dc.b 9
		dc.b $A
		dc.b $12
		dc.b 9
		dc.b $A
		dc.b $12
		dc.b 9
		dc.b $A
		dc.b $12
		dc.b 9
		dc.b $A
		dc.b $12
		dc.b 9
		dc.b $12
		dc.b $E
		dc.b 7
		dc.b $A
		dc.b $E
		dc.b 7
		dc.b $A
		even
; ---------------------------------------------------------------------------

Sonic_Loops:
		cmpi.b	#id_SLZ,(v_zone).w
		beq.s	.isSLZ
		tst.b	(v_zone).w
		bne.w	locret_F490

.isSLZ:
		move.w	obY(a0),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	obX(a0),d1
		move.w	d1,d2
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0
		lea	(v_lvllayout).w,a1
		move.b	(a1,d0.w),d1
		cmp.b	(v_256roll1).w,d1
		beq.w	Sonic_CheckRoll
		cmp.b	(v_256roll2).w,d1
		beq.w	Sonic_CheckRoll
		cmp.b	(v_256loop1).w,d1
		beq.s	loc_F448
		cmp.b	(v_256loop2).w,d1
		beq.s	loc_F438
		bclr	#6,obRender(a0)
		rts
; ---------------------------------------------------------------------------

loc_F438:
		btst	#status_in_air,obStatus(a0)	; is sonic in the air?
		beq.s	loc_F448	; if not, branch
		bclr	#6,obRender(a0)
		rts
; ---------------------------------------------------------------------------

loc_F448:
		cmpi.b	#$2C,d2
		bcc.s	loc_F456
		bclr	#6,obRender(a0)
		rts
; ---------------------------------------------------------------------------

loc_F456:
		cmpi.b	#$E0,d2
		bcs.s	loc_F464
		bset	#6,obRender(a0)
		rts
; ---------------------------------------------------------------------------

loc_F464:
		btst	#6,obRender(a0)
		bne.s	loc_F480
		move.b	obAngle(a0),d1
		beq.s	locret_F490
		cmpi.b	#$80,d1
		bhi.s	locret_F490
		bset	#6,obRender(a0)
		rts
; ---------------------------------------------------------------------------

loc_F480:
		move.b	obAngle(a0),d1
		cmpi.b	#$80,d1
		bls.s	locret_F490
		bclr	#6,obRender(a0)

locret_F490:
		rts
; ---------------------------------------------------------------------------

Sonic_Animate:
		lea	(Ani_Sonic).l,a1
		moveq	#0,d0
		move.b	obAnim(a0),d0
		cmp.b	obNextAni(a0),d0
		beq.s	Sonic_AnimDo
		move.b	d0,obNextAni(a0)
		move.b	#0,obAniFrame(a0)
		move.b	#0,obTimeFrame(a0)

Sonic_AnimDo:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.s	Sonic_AnimateCmd
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		subq.b	#1,obTimeFrame(a0)
		bpl.s	Sonic_AnimDelay
		move.b	d0,obTimeFrame(a0)

Sonic_AnimDo2:
		moveq	#0,d1
		move.b	obAniFrame(a0),d1
		move.b	1(a1,d1.w),d0
		bmi.s	Sonic_AnimEndFF

Sonic_AnimNext:
		move.b	d0,obFrame(a0)
		addq.b	#1,obAniFrame(a0)

Sonic_AnimDelay:
		rts
; ---------------------------------------------------------------------------

Sonic_AnimEndFF:
		addq.b	#1,d0
		bne.s	Sonic_AnimFE
		move.b	#0,obAniFrame(a0)
		move.b	1(a1),d0
		bra.s	Sonic_AnimNext
; ---------------------------------------------------------------------------

Sonic_AnimFE:
		addq.b	#1,d0
		bne.s	Sonic_AnimFD
		move.b	2(a1,d1.w),d0
		sub.b	d0,obAniFrame(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	Sonic_AnimNext
; ---------------------------------------------------------------------------

Sonic_AnimFD:
		addq.b	#1,d0
		bne.s	Sonic_AnimEnd
		move.b	2(a1,d1.w),obAnim(a0)

Sonic_AnimEnd:
		rts
; ---------------------------------------------------------------------------

Sonic_AnimateCmd:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	Sonic_AnimDelay
		addq.b	#1,d0
		bne.w	Sonic_AnimRollJump
		moveq	#0,d1
		move.b	obAngle(a0),d0
		move.b	obStatus(a0),d2
		andi.b	#1,d2
		bne.s	loc_F53E
		not.b	d0

loc_F53E:
		addi.b	#$10,d0
		bpl.s	loc_F546
		moveq	#3,d1

loc_F546:
		andi.b	#$FC,obRender(a0)
		eor.b	d1,d2
		or.b	d2,obRender(a0)
		btst	#5,obStatus(a0)
		bne.w	Sonic_AnimPush
		lsr.b	#4,d0
		andi.b	#6,d0
		move.w	obInertia(a0),d2
		bpl.s	loc_F56A
		neg.w	d2

loc_F56A:
		lea	(byte_F654).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_F582
		lea	(byte_F64C).l,a1
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0

loc_F582:
		add.b	d0,d0
		move.b	d0,d3
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	loc_F590
		moveq	#0,d2

loc_F590:
		lsr.w	#8,d2
		move.b	d2,obTimeFrame(a0)
		bsr.w	Sonic_AnimDo2
		add.b	d3,obFrame(a0)
		rts
; ---------------------------------------------------------------------------

Sonic_AnimRollJump:
		addq.b	#1,d0
		bne.s	Sonic_AnimPush
		move.w	obInertia(a0),d2
		bpl.s	loc_F5AC
		neg.w	d2

loc_F5AC:
		lea	(byte_F664).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_F5BE
		lea	(byte_F65C).l,a1

loc_F5BE:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	loc_F5C8
		moveq	#0,d2

loc_F5C8:
		lsr.w	#8,d2
		move.b	d2,obTimeFrame(a0)
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		bra.w	Sonic_AnimDo2
; ---------------------------------------------------------------------------

Sonic_AnimPush:
		move.w	obInertia(a0),d2
		bmi.s	loc_F5EC
		neg.w	d2

loc_F5EC:
		addi.w	#$800,d2
		bpl.s	loc_F5F4
		moveq	#0,d2

loc_F5F4:
		lsr.w	#6,d2
		move.b	d2,obTimeFrame(a0)

loc_F5FA:
		lea	(byte_F66C).l,a1
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		bra.w	Sonic_AnimDo2
; ---------------------------------------------------------------------------
Ani_Sonic:	include "_anim/Sonic.asm"
; ---------------------------------------------------------------------------

Sonic_LoadGfx:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		cmp.b	(v_sonframenum).w,d0
		beq.s	locret_F744
		move.b	d0,(v_sonframenum).w
		lea	(SonicDynPLC).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.b	#1,d1
		bmi.s	locret_F744
		lea	(v_sgfx_buffer).w,a3
		move.b	#1,(f_sonframechg).w

Sonic_DynReadEntry:
		moveq	#0,d2
		move.b	(a2)+,d2
		move.w	d2,d0
		lsr.b	#4,d0
		lsl.w	#8,d2
		move.b	(a2)+,d2
		lsl.w	#5,d2
		lea	(Art_Sonic).l,a1
		adda.l	d2,a1

loc_F730:
		movem.l	(a1)+,d2-d6/a4-a6
		movem.l	d2-d6/a4-a6,(a3)
		lea	tile_size(a3),a3
		dbf	d0,loc_F730

loc_F740:
		dbf	d1,Sonic_DynReadEntry

locret_F744:
		rts