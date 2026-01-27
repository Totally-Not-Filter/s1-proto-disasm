; ---------------------------------------------------------------------------
; Object 19 - Ball obstacle in GHZ
; ---------------------------------------------------------------------------

GBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	.index(pc,d0.w),d1
		jmp	.index(pc,d1.w)
; ===========================================================================
.index:	dc.w .main-.index
		dc.w GBall_Roll-.index
		dc.w GBall_InAir-.index
		dc.w GBall_Delete-.index
		dc.w GBall_ChkPush-.index
; ===========================================================================

.main:	; Routine 0
		move.b	#$18,obHeight(a0)
		move.b	#$C,obWidth(a0)
		bsr.w	ObjectFall
		jsr	(ObjFloorDist).l	; find floor
		tst.w	d1
		bpl.s	.floornotfound
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		move.b	#8,obRoutine(a0)
		move.l	#Map_GBall,obMap(a0)
		move.w	#make_art_tile(ArtTile_GHZ_Giant_Ball,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#1,obDelayAni(a0)
		bsr.w	GBall_Animate

.floornotfound:
		rts
; ===========================================================================

GBall_ChkPush:	; Routine 8
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		btst	#5,obStatus(a0)	; is the ball being pushed?
		bne.s	.pushed	; if so, branch
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcs.s	.notouch

.pushed:
		move.b	#2,obRoutine(a0)
		move.w	#$80,obInertia(a0)

.notouch:
		bsr.w	GBall_Animate
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	GBall_ChkDel
; ===========================================================================

GBall_Roll:	; Routine 2
		btst	#1,obStatus(a0)	; is the ball in the air?
		bne.w	GBall_InAir	; if so, branch
		bsr.w	GBall_Animate
		bsr.w	sub_5E50
		bsr.w	SpeedToPos
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		jsr	(Sonic_AnglePos).l
		cmpi.w	#$20,obX(a0)
		bhs.s	.faster
		move.w	#$20,obX(a0)
		move.w	#$400,obInertia(a0)

.faster:
		btst	#1,obStatus(a0)	; is the ball in the air?
		beq.s	.notinair	; if not, branch
		move.w	#-$400,obVelY(a0)	; set ball to bounce upwards

.notinair:
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	GBall_ChkDel
; ===========================================================================

GBall_InAir:	; Routine 4
		bsr.w	GBall_Animate
		bsr.w	SpeedToPos
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		jsr	(Sonic_Floor).l
		btst	#1,obStatus(a0)	; is the ball in the air?
		beq.s	.notinair	; if not, branch
		move.w	obVelY(a0),d0
		addi.w	#$28,d0
		move.w	d0,obVelY(a0)
		bra.s	.display
; ===========================================================================

.notinair:
		nop

.display:
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	GBall_ChkDel
; ===========================================================================

GBall_Animate:
		tst.b	obFrame(a0)
		beq.s	.evenframes
		move.b	#0,obFrame(a0)	; every odd frame, set to frame 0
		rts
; ===========================================================================

.evenframes:
		move.b	obInertia(a0),d0	; get byte of inertia
		beq.s	loc_5E02	; if zero, branch
		bmi.s	loc_5E0A	; if negative, branch
		subq.b	#1,obTimeFrame(a0)
		bpl.s	loc_5E02
		neg.b	d0
		addq.b	#8,d0
		bcs.s	loc_5DEC
		moveq	#0,d0

loc_5DEC:
		move.b	d0,obTimeFrame(a0)
		move.b	obDelayAni(a0),d0
		addq.b	#1,d0
		cmpi.b	#4,d0
		bne.s	loc_5DFE
		moveq	#1,d0

loc_5DFE:
		move.b	d0,obDelayAni(a0)

loc_5E02:
		move.b	obDelayAni(a0),obFrame(a0)
		rts
; ===========================================================================

loc_5E0A:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	loc_5E02
		addq.b	#8,d0
		bcs.s	loc_5E16
		moveq	#0,d0

loc_5E16:
		move.b	d0,obTimeFrame(a0)
		move.b	obDelayAni(a0),d0
		subq.b	#1,d0
		bne.s	loc_5E24
		moveq	#3,d0

loc_5E24:
		move.b	d0,obDelayAni(a0)
		bra.s	loc_5E02
; ===========================================================================

GBall_ChkDel:
		out_of_range.w	DeleteObject
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ===========================================================================

GBall_Delete:	; Routine 6
		bsr.w	DeleteObject
		rts
; ===========================================================================

sub_5E50:
		move.b	obAngle(a0),d0
		bsr.w	CalcSine
		move.w	d0,d2
		muls.w	#56,d2
		asr.l	#8,d2
		add.w	d2,obInertia(a0)
		muls.w	obInertia(a0),d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	obInertia(a0),d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)
		rts