; ---------------------------------------------------------------------------

ObjRollingBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_5C8E(pc,d0.w),d1
		jmp	off_5C8E(pc,d1.w)
; ---------------------------------------------------------------------------

off_5C8E:	dc.w loc_5C98-off_5C8E
		dc.w loc_5D2C-off_5C8E
		dc.w loc_5D86-off_5C8E
		dc.w loc_5E4A-off_5C8E
		dc.w loc_5CEE-off_5C8E
; ---------------------------------------------------------------------------

loc_5C98:
		move.b	#$18,obHeight(a0)
		move.b	#$C,obWidth(a0)
		bsr.w	ObjectFall
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	locret_5CEC
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		move.b	#8,obRoutine(a0)
		move.l	#Map_GBall,obMap(a0)
		move.w	#make_art_tile(ArtTile_GHZ_Giant_Ball,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#1,obDelayAni(a0)
		bsr.w	sub_5DC8

locret_5CEC:
		rts
; ---------------------------------------------------------------------------

loc_5CEE:
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		btst	#5,obStatus(a0)
		bne.s	loc_5D14
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcs.s	loc_5D20

loc_5D14:
		move.b	#2,obRoutine(a0)
		move.w	#$80,obInertia(a0)

loc_5D20:
		bsr.w	sub_5DC8
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

loc_5D2C:
		btst	#1,obStatus(a0)	; is object in the air?
		bne.w	loc_5D86	; if so, branch
		bsr.w	sub_5DC8
		bsr.w	sub_5E50
		bsr.w	SpeedToPos
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		jsr	(Sonic_AnglePos).l
		cmpi.w	#$20,obX(a0)
		bcc.s	loc_5D70
		move.w	#$20,obX(a0)
		move.w	#$400,obInertia(a0)

loc_5D70:
		btst	#1,obStatus(a0)
		beq.s	loc_5D7E
		move.w	#-$400,obVelY(a0)

loc_5D7E:
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

loc_5D86:
		bsr.w	sub_5DC8
		bsr.w	SpeedToPos
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		jsr	(Sonic_Floor).l
		btst	#1,obStatus(a0)	; is object in the air?
		beq.s	loc_5DBE	; if not, branch
		move.w	obVelY(a0),d0
		addi.w	#$28,d0
		move.w	d0,obVelY(a0)
		bra.s	loc_5DC0
; ---------------------------------------------------------------------------

loc_5DBE:
		nop

loc_5DC0:
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

sub_5DC8:
		tst.b	obFrame(a0)
		beq.s	loc_5DD6
		move.b	#0,obFrame(a0)
		rts
; ---------------------------------------------------------------------------

loc_5DD6:
		move.b	obInertia(a0),d0
		beq.s	loc_5E02
		bmi.s	loc_5E0A
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
; ---------------------------------------------------------------------------

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
; ---------------------------------------------------------------------------

loc_5E2A:
		out_of_range.w	DeleteObject
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ---------------------------------------------------------------------------

loc_5E4A:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

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