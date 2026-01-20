; ---------------------------------------------------------------------------
; Object 01 - Sonic
; ---------------------------------------------------------------------------

SonicPlayer:
		tst.w	(v_debuguse).w	; is debug mode being used?
		bne.w	DebugMode	; if so, branch
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Sonic_Index(pc,d0.w),d1
		jmp	Sonic_Index(pc,d1.w)
; ===========================================================================

Sonic_Index:	dc.w Sonic_Main-Sonic_Index
		dc.w Sonic_Control-Sonic_Index
		dc.w Sonic_Hurt-Sonic_Index
		dc.w Sonic_Death-Sonic_Index
		dc.w Sonic_ResetLevel-Sonic_Index
; ===========================================================================

; Obj01_Main:
Sonic_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#make_art_tile(ArtTile_Sonic,0,0),obGfx(a0)
		move.b	#2,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#4,obRender(a0)
		move.w	#$600,(v_sonspeedmax).w ; Sonic's top speed
		move.w	#$C,(v_sonspeedacc).w ; Sonic's acceleration
		move.w	#$40,(v_sonspeeddec).w ; Sonic's deceleration

; Obj01_Control:
Sonic_Control:	; Routine 2
		andi.w	#$7FF,obY(a0)
		andi.w	#$7FF,(v_scrposy).w
		tst.w	(f_debugmode).w	; is debug cheat enabled?
		beq.s	.nodebug	; if not, branch
		btst	#bitB,(v_jpadpress2).w ; is button B pressed?
		beq.s	.nodebug	; if not, branch
		move.w	#1,(v_debuguse).w ; change Sonic into a ring/item

.nodebug:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		andi.w	#6,d0
		move.w	Sonic_Modes(pc,d0.w),d1
		jsr	Sonic_Modes(pc,d1.w)
		bsr.s	Sonic_Display
		bsr.w	Sonic_RecordPosition
		move.b	(v_anglebuffer).w,objoff_36(a0)
		move.b	(v_anglebuffer2).w,objoff_37(a0)
		bsr.w	Sonic_Animate
		bsr.w	TouchObjects
		bsr.w	Sonic_Loops
		bsr.w	Sonic_LoadGfx
		rts
; ===========================================================================

Sonic_Modes:
		dc.w Sonic_MdNormal-Sonic_Modes
		dc.w Sonic_MdJump-Sonic_Modes
		dc.w Sonic_MdRoll-Sonic_Modes
		dc.w Sonic_MdJump2-Sonic_Modes
; ---------------------------------------------------------------------------
; Music to play after invincibility wears off
; ---------------------------------------------------------------------------
MusicList2:	dc.b bgm_GHZ
		dc.b bgm_LZ
		dc.b bgm_MZ
		dc.b bgm_SLZ
		dc.b bgm_SZ
		dc.b bgm_CWZ
		even

; ---------------------------------------------------------------------------
; Subroutine to display Sonic and set music
; ---------------------------------------------------------------------------

Sonic_Display:
		move.w	flashtime(a0),d0
		beq.s	.display
		subq.w	#1,flashtime(a0)
		lsr.w	#3,d0
		bcc.s	.chkinvincible

.display:
		bsr.w	DisplaySprite

.chkinvincible:
		tst.b	(v_invinc).w	; does Sonic have invincibility?
		beq.s	.chkshoes	; if not, branch
		tst.w	invtime(a0)	; check time remaining for invinciblity
		beq.s	.chkshoes	; if no time remains, branch
		subq.w	#1,invtime(a0)	; subtract 1 from time
		bne.s	.chkshoes
		tst.b	(f_lockscreen).w
		bne.s	.removeinvincible
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(MusicList2).l,a1
		move.b	(a1,d0.w),d0
		jsr	(QueueSound1).l

.removeinvincible:
		move.b	#0,(v_invinc).w ; cancel invincibility

.chkshoes:
		tst.b	(v_shoes).w	; does Sonic have speed shoes?
		beq.s	.exit		; if not, branch
		tst.w	shoetime(a0)	; check time remaining
		beq.s	.exit
		subq.w	#1,shoetime(a0)	; subtract 1 from time
		bne.s	.exit
		move.w	#$600,(v_sonspeedmax).w ; restore Sonic's speed
		move.w	#$C,(v_sonspeedacc).w ; restore Sonic's acceleration
		move.w	#$40,(v_sonspeeddec).w ; restore Sonic's deceleration
		move.b	#0,(v_shoes).w	; cancel speed shoes
		move.w	#bgm_Slowdown,d0
		jmp	(QueueSound2).l	; run music at normal speed

.exit:
		rts

; ---------------------------------------------------------------------------
; Subroutine to record Sonic's previous positions for invincibility stars
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Sonic_RecordPos:
Sonic_RecordPosition:
		move.w	(v_trackpos).w,d0
		lea	(v_tracksonic).w,a1
		lea	(a1,d0.w),a1
		move.w	obX(a0),(a1)+
		move.w	obY(a0),(a1)+
		addq.b	#4,(v_trackbyte).w
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Modes for controlling Sonic
; ---------------------------------------------------------------------------

; Obj01_MdNormal:
Sonic_MdNormal:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_SlopeResist
		bsr.w	Sonic_Move
		bsr.w	Sonic_Roll
		bsr.w	Sonic_LevelBound
		bsr.w	SpeedToPos
		bsr.w	Sonic_AnglePos
		bsr.w	Sonic_SlopeRepel
		rts
; ===========================================================================

; Obj01_MdJump:
Sonic_MdJump:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_JumpDirection
		bsr.w	Sonic_LevelBound
		bsr.w	ObjectFall
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
		rts
; ===========================================================================

; Obj01_MdRoll:
Sonic_MdRoll:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_RollRepel
		bsr.w	Sonic_RollSpeed
		bsr.w	Sonic_LevelBound
		bsr.w	SpeedToPos
		bsr.w	Sonic_AnglePos
		bsr.w	Sonic_SlopeRepel
		rts
; ===========================================================================

; Obj01_MdJump2:
Sonic_MdJump2:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_JumpDirection
		bsr.w	Sonic_LevelBound
		bsr.w	ObjectFall
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
		rts

; ---------------------------------------------------------------------------
; Subroutine to make Sonic walk/run
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

Sonic_Move:
		move.w	(v_sonspeedmax).w,d6
		move.w	(v_sonspeedacc).w,d5
		move.w	(v_sonspeeddec).w,d4
		tst.w	ctrllock(a0)
		bne.w	Sonic_LookUp
		btst	#bitL,(v_jpadhold2).w ; is left being pressed?
		beq.s	.notleft	; if not, branch
		bsr.w	Sonic_MoveLeft

.notleft:
		btst	#bitR,(v_jpadhold2).w ; is right being pressed?
		beq.s	.notright	; if not, branch
		bsr.w	Sonic_MoveRight

.notright:
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0		; is Sonic on a slope?
		bne.w	Sonic_ResetScr	; if yes, branch
		tst.w	obInertia(a0)	; is Sonic moving?
		bne.w	Sonic_ResetScr	; if yes, branch
		bclr	#5,obStatus(a0)
		move.b	#id_Wait,obAnim(a0) ; use "standing" animation
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
; ===========================================================================

Sonic_Balance:
		jsr	(ObjFloorDist).l
		cmpi.w	#$C,d1
		blt.s	Sonic_LookUp
		cmpi.b	#3,objoff_36(a0)
		bne.s	loc_EA8A

loc_EA82:
		bclr	#0,obStatus(a0)
		bra.s	loc_EA98
; ===========================================================================

loc_EA8A:
		cmpi.b	#3,objoff_37(a0)
		bne.s	Sonic_LookUp

loc_EA92:
		bset	#0,obStatus(a0)

loc_EA98:
		move.b	#id_Balance,obAnim(a0) ; use "balancing" animation
		bra.s	Sonic_ResetScr
; ===========================================================================

Sonic_LookUp:
		btst	#bitUp,(v_jpadhold2).w ; is up being pressed?
		beq.s	Sonic_Duck	; if not, branch
		move.b	#id_LookUp,obAnim(a0) ; use "looking up" animation
		cmpi.w	#200,(v_lookshift).w
		beq.s	loc_EAEA
		addq.w	#2,(v_lookshift).w
		bra.s	loc_EAEA
; ===========================================================================

Sonic_Duck:
		btst	#bitDn,(v_jpadhold2).w ; is down being pressed?
		beq.s	Sonic_ResetScr	; if not, branch
		move.b	#id_Duck,obAnim(a0) ; use "ducking" animation
		cmpi.w	#8,(v_lookshift).w
		beq.s	loc_EAEA
		subq.w	#2,(v_lookshift).w
		bra.s	loc_EAEA
; ===========================================================================

; Obj01_ResetScr
Sonic_ResetScr:
		cmpi.w	#96,(v_lookshift).w ; is screen in its default position?
		beq.s	loc_EAEA	; if yes, branch
		bcc.s	loc_EAE6
		addq.w	#4,(v_lookshift).w ; move screen back to default

loc_EAE6:
		subq.w	#2,(v_lookshift).w ; move screen back to default

loc_EAEA:
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnL+btnR,d0	; is left/right pressed?
		bne.s	loc_EB16	; if yes, branch
		move.w	obInertia(a0),d0
		beq.s	loc_EB16
		bmi.s	loc_EB0A
		sub.w	d5,d0
		bcc.s	loc_EB04
		move.w	#0,d0

loc_EB04:
		move.w	d0,obInertia(a0)
		bra.s	loc_EB16
; ===========================================================================

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
; ===========================================================================

loc_EB7E:
		sub.w	d1,obVelY(a0)
		rts
; ===========================================================================

loc_EB84:
		sub.w	d1,obVelX(a0)
		rts
; ===========================================================================

loc_EB8A:
		add.w	d1,obVelY(a0)

locret_EB8E:
		rts
; End of function Sonic_Move

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

Sonic_MoveLeft:
		move.w	obInertia(a0),d0
		beq.s	loc_EB98
		bpl.s	loc_EBC4

loc_EB98:
		bset	#0,obStatus(a0)
		bne.s	loc_EBAC
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obNextAni(a0) ; restart Sonic's animation

loc_EBAC:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_EBB8
		move.w	d1,d0

loc_EBB8:
		move.w	d0,obInertia(a0)
		move.b	#id_Walk,obAnim(a0) ; use walking animation
		rts
; ===========================================================================

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
		move.b	#id_Stop,obAnim(a0) ; use "stopping" animation
		bclr	#0,obStatus(a0)
		move.w	#sfx_Skid,d0
		jsr	(QueueSound2).l	; play stopping sound

locret_EBFA:
		rts
; End of function Sonic_MoveLeft


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

Sonic_MoveRight:
		move.w	obInertia(a0),d0
		bmi.s	loc_EC2A
		bclr	#0,obStatus(a0)
		beq.s	loc_EC16
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obNextAni(a0) ; restart Sonic's animation

loc_EC16:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_EC1E
		move.w	d6,d0

loc_EC1E:
		move.w	d0,obInertia(a0)
		move.b	#id_Walk,obAnim(a0) ; use walking animation
		rts
; ===========================================================================

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
		move.b	#id_Stop,obAnim(a0) ; use "stopping" animation
		bset	#0,obStatus(a0)
		move.w	#sfx_Skid,d0
		jsr	(QueueSound2).l	; play stopping sound

locret_EC60:
		rts
; End of function Sonic_MoveRight

; ---------------------------------------------------------------------------
; Subroutine to change Sonic's speed as he rolls
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollSpeed:
		move.w	(v_sonspeedmax).w,d6
		asl.w	#1,d6
		move.w	(v_sonspeedacc).w,d5
		asr.w	#1,d5
		move.w	(v_sonspeeddec).w,d4
		asr.w	#2,d4
		tst.w	ctrllock(a0)
		bne.s	.notright
		btst	#bitL,(v_jpadhold2).w ; is left being pressed?
		beq.s	.notleft	; if not, branch
		bsr.w	Sonic_RollLeft

.notleft:
		btst	#bitR,(v_jpadhold2).w ; is right being pressed?
		beq.s	.notright	; if not, branch
		bsr.w	Sonic_RollRight

.notright:
		move.w	obInertia(a0),d0
		beq.s	loc_ECB4
		bmi.s	loc_ECA8
		sub.w	d5,d0
		bcc.s	loc_ECA2
		move.w	#0,d0

loc_ECA2:
		move.w	d0,obInertia(a0)
		bra.s	loc_ECB4
; ===========================================================================

loc_ECA8:
		add.w	d5,d0
		bcc.s	loc_ECB0
		move.w	#0,d0

loc_ECB0:
		move.w	d0,obInertia(a0)

loc_ECB4:
		tst.w	obInertia(a0)	; is Sonic moving?
		bne.s	loc_ECD6	; if yes, branch
		bclr	#2,obStatus(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.b	#id_Wait,obAnim(a0) ; use "standing" animation
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
; End of function Sonic_RollSpeed


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

Sonic_RollLeft:
		move.w	obInertia(a0),d0
		beq.s	loc_ED00
		bpl.s	loc_ED0E

loc_ED00:
		bset	#0,obStatus(a0)
		move.b	#id_Roll,obAnim(a0) ; use "rolling" animation
		rts
; ===========================================================================

loc_ED0E:
		sub.w	d4,d0
		bcc.s	loc_ED16
		move.w	#-$80,d0

loc_ED16:
		move.w	d0,obInertia(a0)
		rts
; End of function Sonic_RollLeft


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

Sonic_RollRight:
		move.w	obInertia(a0),d0
		bmi.s	loc_ED30
		bclr	#0,obStatus(a0)
		move.b	#id_Roll,obAnim(a0) ; use "rolling" animation
		rts
; ===========================================================================

loc_ED30:
		add.w	d4,d0
		bcc.s	loc_ED38
		move.w	#$80,d0

loc_ED38:
		move.w	d0,obInertia(a0)
		rts
; End of function Sonic_RollRight

; ---------------------------------------------------------------------------
; Subroutine to change Sonic's direction while jumping
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Sonic_ChgJumpDir
Sonic_JumpDirection:
		move.w	(v_sonspeedmax).w,d6
		move.w	(v_sonspeedacc).w,d5
		asl.w	#1,d5
		btst	#4,obStatus(a0)
		bne.s	Obj01_ResetScr2
		move.w	obVelX(a0),d0
		btst	#bitL,(v_jpadhold1).w ; is left being pressed?
		beq.s	loc_ED6E	; if not, branch
		bset	#0,obStatus(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_ED6E
		move.w	d1,d0

loc_ED6E:
		btst	#bitR,(v_jpadhold1).w ; is right being pressed?
		beq.s	Obj01_JumpMove	; if not, branch
		bclr	#0,obStatus(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	Obj01_JumpMove
		move.w	d6,d0

Obj01_JumpMove:
		move.w	d0,obVelX(a0)	; change Sonic's horizontal speed

Obj01_ResetScr2:
		cmpi.w	#96,(v_lookshift).w ; is the screen in its default position?
		beq.s	loc_ED9A	; if yes, branch
		bcc.s	loc_ED96
		addq.w	#4,(v_lookshift).w

loc_ED96:
		subq.w	#2,(v_lookshift).w

loc_ED9A:
		cmpi.w	#-$400,obVelY(a0) ; is Sonic moving faster than -$400 upwards?
		blo.s	locret_EDC8	; if yes, branch
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
; ===========================================================================

loc_EDBC:
		sub.w	d1,d0
		bcs.s	loc_EDC4
		move.w	#0,d0

loc_EDC4:
		move.w	d0,obVelX(a0)

locret_EDC8:
		rts
; End of function Sonic_JumpDirection

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine to squash Sonic
; ---------------------------------------------------------------------------

Sonic_SquashUnused:
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	.return
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	.return
		move.w	#0,obInertia(a0) ; stop Sonic moving
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		move.b	#id_Warp3,obAnim(a0) ; use "warping" animation

.return:
		rts

; ---------------------------------------------------------------------------
; Subroutine to prevent Sonic leaving the boundaries of a level
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_LevelBound:
		move.l	obX(a0),d1
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(v_limitleft2).w,d0
		addi.w	#16,d0
		cmp.w	d1,d0		; has Sonic touched the side boundary?
		bhi.s	.sides		; if yes, branch
		move.w	(v_limitright2).w,d0
		addi.w	#320-24,d0
		cmp.w	d1,d0		; has Sonic touched the side boundary?
		bls.s	.sides		; if yes, branch
		move.w	(v_limitbtm2).w,d0
	if FixBugs
		; The original code does not consider that the camera boundary
		; may be in the middle of lowering itself, which is why going
		; down the S-tunnel in Green Hill Zone Act 1 fast enough can
		; kill Sonic.
		move.w	(v_limitbtm1).w,d1
		cmp.w	d0,d1
		blo.s	.skip
		move.w	d1,d0
.skip:
	endif
		addi.w	#224,d0
		cmp.w	obY(a0),d0	; has Sonic touched the bottom boundary?
		bcs.w	KillSonic	; if yes, branch
		rts
; ===========================================================================

; Boundary_Sides
.sides:
		move.w	d0,obX(a0)
		move.w	#0,obX+2(a0)
		move.w	#0,obVelX(a0)	; stop Sonic moving
		move.w	#0,obInertia(a0)
		rts
; End of function Sonic_LevelBound

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to roll when he's moving
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Roll:
		move.w	obInertia(a0),d0
		bpl.s	.ispositive
		neg.w	d0

.ispositive:
		cmpi.w	#$80,d0		; is Sonic moving at $80 speed or faster?
		bcs.s	.noroll		; if not, branch
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnL+btnR,d0	; is left/right being pressed?
		bne.s	.noroll		; if yes, branch
		btst	#bitDn,(v_jpadhold2).w ; is down being pressed?
		bne.s	Sonic_ChkRoll		; if yes, branch

; Obj01_NoRoll
.noroll:
		rts
; ===========================================================================

; Obj01_ChkRoll
Sonic_ChkRoll:
		btst	#2,obStatus(a0)	; is Sonic already rolling?
		beq.s	.roll		; if not, branch
		rts
; ===========================================================================

; Obj01_DoRoll
.roll:
		bset	#2,obStatus(a0)
		move.b	#$E,obHeight(a0)
		move.b	#7,obWidth(a0)
		move.b	#id_Roll,obAnim(a0) ; use "rolling" animation
		addq.w	#5,obY(a0)
		move.w	#sfx_Roll,d0
		jsr	(QueueSound2).l	; play rolling sound
		tst.w	obInertia(a0)
		bne.s	.ismoving
		move.w	#$200,obInertia(a0) ; set inertia if 0

.ismoving:
		rts
; End of function Sonic_Roll

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to jump
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Jump:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0	; is A, B or C pressed?
		beq.w	.return	; if not, branch
		moveq	#0,d0
		move.b	obAngle(a0),d0
		addi.b	#$80,d0
		bsr.w	sub_10520
		cmpi.w	#6,d1
		blt.w	.return
		moveq	#0,d0
		move.b	obAngle(a0),d0
		subi.b	#$40,d0
		jsr	(CalcSine).l	; find the direction Sonic should jump.
		muls.w	#$680,d1	; apply jump force to the cosine angle.
		asr.l	#8,d1
		add.w	d1,obVelX(a0)	; apply to X speed.
		muls.w	#$680,d0	; apply jump force to the sine angle.
		asr.l	#8,d0
		add.w	d0,obVelY(a0)	; apply to Y speed.
		bset	#status_in_air,obStatus(a0)	; set in-air flag.
		bclr	#5,obStatus(a0)	; clear pushing flag.
		addq.l	#4,sp	; Run in-air subroutines when we return.
		move.b	#1,jumpflag(a0)	; set jump flag.
		move.w	#sfx_Jump,d0
		jsr	(QueueSound2).l	; play jumping sound
		move.b	#$13,obHeight(a0)	; set Sonic's hitbox to standing size.
		move.b	#9,obWidth(a0)
		tst.b	(f_victory).w	; has the victory animation flag been set?
		bne.s	.leapanim	; if so, branch
		btst	#2,obStatus(a0)	; is Sonic already in a ball state?
		bne.s	.rolljump	; if so, branch.
		move.b	#$E,obHeight(a0)	; set Sonic's hitbox to ball size.
		move.b	#7,obWidth(a0)
		move.b	#id_Roll,obAnim(a0)	; use "jumping" animation
		bset	#2,obStatus(a0)
		addq.w	#5,obY(a0)

.return:
		rts

.leapanim:
		move.b	#id_Leap2,obAnim(a0)	; use the "leaping" animation
		rts

.rolljump:
		bset	#4,obStatus(a0)	; set roll-jump flag.
		rts
; End of function Sonic_Jump

; ---------------------------------------------------------------------------
; Subroutine controlling Sonic's jump height/duration
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_JumpHeight:
		tst.b	jumpflag(a0)	; has Sonic jumped?
		beq.s	.capyvel		; if not, just cap Y speed normally.
		cmpi.w	#-$400,obVelY(a0)	; is Sonic at maximum y speed?
		bge.s	.return		; if not, branch
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnABC,d0	; is A, B or C pressed?
		bne.s	.return	; if yes, branch
		move.w	#-$400,obVelY(a0)

.return:
		rts

.capyvel:
		cmpi.w	#-$FC0,obVelY(a0)
		bge.s	.return2
		move.w	#-$FC0,obVelY(a0)

.return2:
		rts
; End of function Sonic_JumpHeight

; ---------------------------------------------------------------------------
; Subroutine to slow Sonic walking up a slope
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


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
		add.w	d0,obInertia(a0) ; change Sonic's inertia

locret_EFB6:
		rts
; ===========================================================================

loc_EFB8:
		add.w	d0,obInertia(a0)

locret_EFBC:
		rts
; End of function Sonic_SlopeResist

; ---------------------------------------------------------------------------
; Subroutine to push Sonic down a slope while he's rolling
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


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
; ===========================================================================

loc_EFEE:
		tst.w	d0
		bmi.s	loc_EFF4
		asr.l	#2,d0

loc_EFF4:
		add.w	d0,obInertia(a0)

locret_EFF8:
		rts
; End of function Sonic_RollRepel

; ---------------------------------------------------------------------------
; Subroutine to push Sonic down a slope
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


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
		bhs.s	locret_F02A
		bset	#status_in_air,obStatus(a0)	; set in air status
		move.w	#30,ctrllock(a0)

locret_F02A:
		rts
; ===========================================================================

loc_F02C:
		subq.w	#1,ctrllock(a0)
		rts
; End of function Sonic_SlopeRepel

; ---------------------------------------------------------------------------
; Subroutine to return Sonic's angle to 0 as he jumps
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_JumpAngle:
		move.b	obAngle(a0),d0	; get Sonic's angle
		beq.s	.return	; if already 0, branch
		bpl.s	.decrease	; if higher than 0, branch
		addq.b	#2,d0		; increase angle
		bcc.s	.dontclear	; if the angle's still below 0, dont clear the angle.
		moveq	#0,d0

.dontclear:
		bra.s	.applyangle

.decrease:
		subq.b	#2,d0		; decrease angle
		bcc.s	.applyangle	; if the angle's still above 0, don't clear the angle.
		moveq	#0,d0

.applyangle:
		move.b	d0,obAngle(a0)

.return:
		rts
; End of function Sonic_JumpAngle

; ---------------------------------------------------------------------------
; Subroutine for Sonic to interact with the floor after jumping/falling
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


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
; ===========================================================================

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
; ===========================================================================

loc_F104:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_F11E
		sub.w	d1,obX(a0)
		move.w	#0,obVelX(a0)
		move.w	obVelY(a0),obInertia(a0)
		rts
; ===========================================================================

loc_F11E:
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	loc_F132
		sub.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		rts
; ===========================================================================

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
; ===========================================================================

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
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	locret_F1BA
		sub.w	d1,obY(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_F1A4
		move.w	#0,obVelY(a0)
		rts
; ===========================================================================

loc_F1A4:
		move.b	d3,obAngle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.w	obVelY(a0),obInertia(a0)
		tst.b	d3
		bpl.s	locret_F1BA
		neg.w	obInertia(a0)

locret_F1BA:
		rts
; ===========================================================================

loc_F1BC:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F1D6
		add.w	d1,obX(a0)
		move.w	#0,obVelX(a0)
		move.w	obVelY(a0),obInertia(a0)
		rts
; ===========================================================================

loc_F1D6:
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	loc_F1EA
		sub.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		rts
; ===========================================================================

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
; End of function Sonic_Floor

; ---------------------------------------------------------------------------
; Subroutine to reset Sonic's mode when he lands on the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_ResetOnFloor:
		btst	#4,obStatus(a0)	; is Sonic roll-jumping?
		beq.s	loc_F226	; if not, skip.
		nop	; Unknown removed code.
		nop
		nop

loc_F226:
		bclr	#5,obStatus(a0)	; clear push flag.
		bclr	#status_in_air,obStatus(a0)	; clear in-air flag.
		bclr	#4,obStatus(a0)	; clear roll-jump flag.
		btst	#2,obStatus(a0)	; check if Sonic is in a ball state.
		beq.s	loc_F25C	; if not, skip.
		bclr	#2,obStatus(a0)	; clear ball flag.
		move.b	#$13,obHeight(a0)	; set Sonic's hitbox to standing.
		move.b	#9,obWidth(a0)
		move.b	#id_Walk,obAnim(a0) ; use running/walking animation
		subq.w	#5,obY(a0)	; raise Sonic up 5 pixels so he's not inside the ground.

loc_F25C:
		move.w	#0,ctrllock(a0)
		move.b	#0,jumpflag(a0)	; clear jump flag.
		rts
; End of function Sonic_ResetOnFloor

; ---------------------------------------------------------------------------
; Unused subroutine to read Sonic's x position, y position, and inertia.
; And then write it in hexadecimal to the Debug Coordinate Sprites.
; ---------------------------------------------------------------------------

loc_F26A:
		lea	(v_objslot10).w,a1
		move.w	obX(a0),d0	; get Sonic's x position.
		bsr.w	.writehex
		lea	(v_objslot14).w,a1
		move.w	obY(a0),d0	; get Sonic's y position.
		bsr.w	.writehex
		lea	(v_objslot18).w,a1
		move.w	obInertia(a0),d0	; get Sonic's inertia.
		bsr.w	.writehex
		rts

.writehex:
		swap	d0		; swap high word with low word.
		rol.l	#4,d0	; circular left shift 4 times in longword.
		andi.b	#$F,d0	; bitwise and so we only get 0 to F.
		move.b	d0,obFrame(a1)	; write it to the Debug Coordinate's number.
		rol.l	#4,d0	; circular left shift 4 times in longword.
		andi.b	#$F,d0	; bitwise and so we only get 0 to F.
		move.b	d0,object_size+obFrame(a1)	; write it to the next Debug Coordinate's number.
		rol.l	#4,d0	; circular left shift 4 times in longword.
		andi.b	#$F,d0	; bitwise and so we only get 0 to F.
		move.b	d0,object_size*2+obFrame(a1)	; write it to the next Debug Coordinate's number.
		rol.l	#4,d0	; circular left shift 4 times in longword.
		andi.b	#$F,d0	; bitwise and so we only get 0 to F.
		move.b	d0,object_size*3+obFrame(a1)	; write it to the next Debug Coordinate's number.
		rts

; ---------------------------------------------------------------------------
; Sonic when he gets hurt
; ---------------------------------------------------------------------------

; Obj01_Hurt:
Sonic_Hurt:	; Routine 4
		bsr.w	Sonic_HurtStop
		bsr.w	SpeedToPos
		addi.w	#$30,obVelY(a0)
		bsr.w	Sonic_LevelBound
		bsr.w	Sonic_RecordPosition
		bsr.w	Sonic_Animate
		bsr.w	Sonic_LoadGfx
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to stop Sonic falling after he's been hurt
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_HurtStop:
		move.w	(v_limitbtm2).w,d0
	if FixBugs
		; The original code does not consider that the camera boundary
		; may be in the middle of lowering itself, which is why going
		; down the S-tunnel in Green Hill Zone Act 1 fast enough can
		; kill Sonic.
		move.w	(v_limitbtm1).w,d1
		cmp.w	d0,d1
		blo.s	.skip
		move.w	d1,d0
.skip:
	endif
		addi.w	#224,d0
		cmp.w	obY(a0),d0
		bcs.w	KillSonic
		bsr.w	loc_F07C
		btst	#1,obStatus(a0)
		bne.s	locret_F318
		moveq	#0,d0
		move.w	d0,obVelY(a0)
		move.w	d0,obVelX(a0)
		move.w	d0,obInertia(a0)
		move.b	#id_Walk,obAnim(a0)
		subq.b	#2,obRoutine(a0)
		move.w	#120,flashtime(a0)		; set sonic to be invulnerable for 2 seconds

locret_F318:
		rts
; End of function Sonic_HurtStop

; ---------------------------------------------------------------------------
; Sonic when he dies
; ---------------------------------------------------------------------------

; Obj01_Death:
Sonic_Death:
		bsr.w	Sonic_GameOver
		bsr.w	ObjectFall
		bsr.w	Sonic_RecordPosition
		bsr.w	Sonic_Animate
		bsr.w	Sonic_LoadGfx
		bra.w	DisplaySprite

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_GameOver:
		move.w	(v_limitbtm2).w,d0
		addi.w	#256,d0
		cmp.w	obY(a0),d0
		bhs.w	locret_F3AE
		move.w	#-$38,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		addq.b	#1,(f_lifecount).w ; update lives counter
		subq.b	#1,(v_lives).w	; subtract 1 from number of lives
		bne.s	loc_F380
		move.w	#0,objoff_3A(a0)
		move.b	#id_GameOverCard,(v_objslot2).w ; load GAME object
		move.b	#id_GameOverCard,(v_objslot3).w ; load OVER object
		move.b	#1,(v_objslot3+obFrame).w ; set OVER object to correct frame
		move.w	#bgm_GameOver,d0
		jsr	(QueueSound2).l	; play game over music
		moveq	#plcid_GameOver,d0
		jmp	(AddPLC).l	; load game over patterns
; ===========================================================================

loc_F380:
		move.w	#60,objoff_3A(a0)	; set time delay to 1 second
		rts
; ===========================================================================

loc_F388:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		beq.s	locret_F3AE
		andi.b	#btnA,d0
		bne.s	loc_F3B0
		move.b	#id_Walk,obAnim(a0)		; Respawns you after a death
		subq.b	#4,obRoutine(a0)		; The lines above seem to make the code do nothing
		move.w	objoff_38(a0),obY(a0)
		move.w	#120,flashtime(a0)		; set sonic to be invulnerable for 2 seconds

locret_F3AE:
		rts
; ===========================================================================

loc_F3B0:
		move.w	#1,(f_restart).w ; restart the level
		rts
; End of function GameOver

; ---------------------------------------------------------------------------
; Sonic when the level is restarted
; ---------------------------------------------------------------------------

; Obj01_ResetLevel:
Sonic_ResetLevel:; Routine 8
		tst.w	objoff_3A(a0)
		beq.s	.return
		subq.w	#1,objoff_3A(a0)	; subtract 1 from time delay
		bne.s	.return
		move.w	#1,(f_restart).w ; restart the level

.return:
		rts
; ===========================================================================
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
; Subroutine to make Sonic run around loops (GHZ/SLZ)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Loops:
		cmpi.b	#id_SLZ,(v_zone).w ; is level SLZ?
		beq.s	.isstarlight	; if yes, branch
		tst.b	(v_zone).w	; is level GHZ?
		bne.w	.noloops	; if not, branch

.isstarlight:
		move.w	obY(a0),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	obX(a0),d1
		move.w	d1,d2
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0
		lea	(v_lvllayout).w,a1
		move.b	(a1,d0.w),d1	; d1 is the 256x256 tile Sonic is currently on

		cmp.b	(v_256roll1).w,d1 ; is Sonic on a "roll tunnel" tile?
		beq.w	Sonic_ChkRoll	; if yes, branch
		cmp.b	(v_256roll2).w,d1
		beq.w	Sonic_ChkRoll

		cmp.b	(v_256loop1).w,d1 ; is Sonic on a loop tile?
		beq.s	.chkifleft	; if yes, branch
		cmp.b	(v_256loop2).w,d1
		beq.s	.chkifinair
		bclr	#6,obRender(a0) ; return Sonic to high plane
		rts
; ===========================================================================

.chkifinair:
		btst	#status_in_air,obStatus(a0)	; is sonic in the air?
		beq.s	.chkifleft	; if not, branch

		bclr	#6,obRender(a0) ; return Sonic to high plane
		rts
; ===========================================================================

.chkifleft:
		cmpi.b	#$2C,d2
		bhs.s	.chkifright

		bclr	#6,obRender(a0) ; return Sonic to high plane
		rts
; ===========================================================================

.chkifright:
		cmpi.b	#$E0,d2
		blo.s	.chkangle1

		bset	#6,obRender(a0)	; send Sonic to low plane
		rts
; ===========================================================================

.chkangle1:
		btst	#6,obRender(a0) ; is Sonic on low plane?
		bne.s	.chkangle2	; if yes, branch

		move.b	obAngle(a0),d1
		beq.s	.done
		cmpi.b	#$80,d1		; is Sonic upside-down?
		bhi.s	.done		; if yes, branch
		bset	#6,obRender(a0)	; send Sonic to low plane
		rts
; ===========================================================================

.chkangle2:
		move.b	obAngle(a0),d1
		cmpi.b	#$80,d1		; is Sonic upright?
		bls.s	.done		; if yes, branch
		bclr	#6,obRender(a0) ; send Sonic to high plane

.noloops:
.done:
		rts
; End of function Sonic_Loops

; ---------------------------------------------------------------------------
; Subroutine to animate Sonic's sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Animate:
		lea	(Ani_Sonic).l,a1
		moveq	#0,d0
		move.b	obAnim(a0),d0
		cmp.b	obNextAni(a0),d0 ; has animation changed?
		beq.s	.do		; if not, branch
		move.b	d0,obNextAni(a0)
		move.b	#0,obAniFrame(a0)
		move.b	#0,obTimeFrame(a0)

; SAnim_Do:
.do:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1	; jump to appropriate animation script
		move.b	(a1),d0
		bmi.s	.walkrunroll	; if animation is walk/run/roll/jump, branch
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		subq.b	#1,obTimeFrame(a0) ; subtract 1 from frame duration
		bpl.s	.delay		; if time remains, branch
		move.b	d0,obTimeFrame(a0) ; load frame duration

; SAnim_Do2:
.loadframe:
		moveq	#0,d1
		move.b	obAniFrame(a0),d1 ; load current frame number
		move.b	1(a1,d1.w),d0	; read sprite number from script
		bmi.s	.end_FF		; if animation is complete, branch

; SAnim_Next:
.next:
		move.b	d0,obFrame(a0)	; load sprite number
		addq.b	#1,obAniFrame(a0) ; next frame number

; SAnim_Delay:
.delay:
		rts
; ===========================================================================

; SAnim_End_FF:
.end_FF:
		addq.b	#1,d0		; is the end flag = $FF ?
		bne.s	.end_FE		; if not, branch
		move.b	#0,obAniFrame(a0) ; restart the animation
		move.b	1(a1),d0	; read sprite number
		bra.s	.next
; ===========================================================================

; SAnim_End_FE
.end_FE:
		addq.b	#1,d0		; is the end flag = $FE ?
		bne.s	.end_FD		; if not, branch
		move.b	2(a1,d1.w),d0	; read the next byte in the script
		sub.b	d0,obAniFrame(a0) ; jump back d0 bytes in the script
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0	; read sprite number
		bra.s	.next
; ===========================================================================

; SAnim_End_FD:
.end_FD:
		addq.b	#1,d0		; is the end flag = $FD ?
		bne.s	.end		; if not, branch
		move.b	2(a1,d1.w),obAnim(a0) ; read next byte, run that animation

; SAnim_End:
.end:
		rts
; ===========================================================================

; SAnim_WalkRun:
.walkrunroll:
		subq.b	#1,obTimeFrame(a0) ; subtract 1 from frame duration
		bpl.s	.delay		; if time remains, branch
		addq.b	#1,d0		; is animation walking/running?
		bne.w	.rolljump	; if not, branch
		moveq	#0,d1
		move.b	obAngle(a0),d0	; get Sonic's angle
		move.b	obStatus(a0),d2
		andi.b	#1,d2		; is Sonic mirrored horizontally?
		bne.s	.flip		; if yes, branch
		not.b	d0		; reverse angle

.flip:
		addi.b	#$10,d0		; add $10 to angle
		bpl.s	.noinvert	; if angle is $0-$7F, branch
		moveq	#3,d1

.noinvert:
		andi.b	#$FC,obRender(a0)
		eor.b	d1,d2
		or.b	d2,obRender(a0)
		btst	#5,obStatus(a0)	; is Sonic pushing something?
		bne.w	.push		; if yes, branch

		lsr.b	#4,d0		; divide angle by $10
		andi.b	#6,d0		; angle must be 0, 2, 4 or 6
		move.w	obInertia(a0),d2 ; get Sonic's speed
		bpl.s	.nomodspeed
		neg.w	d2		; modulus speed

.nomodspeed:
		lea	(SonAni_Run).l,a1 ; use running animation
		cmpi.w	#$600,d2	; is Sonic at running speed?
		bhs.s	.running	; if yes, branch

		lea	(SonAni_Walk).l,a1 ; use walking animation
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0

.running:
		add.b	d0,d0
		move.b	d0,d3
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	.belowmax
		moveq	#0,d2		; max animation speed

.belowmax:
		lsr.w	#8,d2
		move.b	d2,obTimeFrame(a0) ; modify frame duration
		bsr.w	.loadframe
		add.b	d3,obFrame(a0)	; modify frame number
		rts
; ===========================================================================

; SAnim_RollJump:
.rolljump:
		addq.b	#1,d0		; is animation rolling/jumping?
		bne.s	.push		; if not, branch
		move.w	obInertia(a0),d2 ; get Sonic's speed
		bpl.s	.nomodspeed2
		neg.w	d2

.nomodspeed2:
		lea	(SonAni_Roll2).l,a1 ; use fast animation
		cmpi.w	#$600,d2	; is Sonic moving fast?
		bhs.s	.rollfast	; if yes, branch
		lea	(SonAni_Roll).l,a1 ; use slower animation

.rollfast:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	.belowmax2
		moveq	#0,d2

.belowmax2:
		lsr.w	#8,d2
		move.b	d2,obTimeFrame(a0) ; modify frame duration
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		bra.w	.loadframe
; ===========================================================================

; SAnim_Push:
.push:
		move.w	obInertia(a0),d2 ; get Sonic's speed
		bmi.s	.negspeed
		neg.w	d2

.negspeed:
		addi.w	#$800,d2
		bpl.s	.belowmax3	
		moveq	#0,d2

.belowmax3:
		lsr.w	#6,d2
		move.b	d2,obTimeFrame(a0) ; modify frame duration
		lea	(SonAni_Push).l,a1
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		bra.w	.loadframe

; End of function Sonic_Animate

Ani_Sonic:	include "_anim/Sonic.asm"

; ---------------------------------------------------------------------------
; Sonic graphics loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; LoadSonicDynPLC:
Sonic_LoadGfx:
		moveq	#0,d0
		move.b	obFrame(a0),d0	; load frame number
		cmp.b	(v_sonframenum).w,d0 ; has frame changed?
		beq.s	.nochange	; if not, branch

		move.b	d0,(v_sonframenum).w
		lea	(SonicDynPLC).l,a2 ; load PLC script
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1	; read "number of entries" value
		subq.b	#1,d1
		bmi.s	.nochange	; if zero, branch
		lea	(v_sgfx_buffer).w,a3
		move.b	#1,(f_sonframechg).w ; set flag for Sonic graphics DMA

; SPLC_ReadEntry:
.readentry:
		moveq	#0,d2
		move.b	(a2)+,d2
		move.w	d2,d0
		lsr.b	#4,d0
		lsl.w	#8,d2
		move.b	(a2)+,d2
		lsl.w	#5,d2
		lea	(Art_Sonic).l,a1
		adda.l	d2,a1

; SPLC_LoadTile:
.loadtile:
		movem.l	(a1)+,d2-d6/a4-a6
		movem.l	d2-d6/a4-a6,(a3)
		lea	tile_size(a3),a3	; next tile
		dbf	d0,.loadtile	; repeat for number of tiles

		dbf	d1,.readentry	; repeat for number of entries

.nochange:
		rts

; End of function Sonic_LoadGfx