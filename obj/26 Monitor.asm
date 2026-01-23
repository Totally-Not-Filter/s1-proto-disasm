; ---------------------------------------------------------------------------

Monitor:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_8054(pc,d0.w),d1
		jmp	off_8054(pc,d1.w)
; ---------------------------------------------------------------------------
off_8054:
		dc.w loc_805E-off_8054
		dc.w loc_80C0-off_8054
		dc.w sub_81D2-off_8054
		dc.w loc_81A4-off_8054
		dc.w loc_81AE-off_8054
; ---------------------------------------------------------------------------

loc_805E:
		addq.b	#2,obRoutine(a0)
		move.b	#$E,obHeight(a0)
		move.b	#$E,obWidth(a0)
		move.l	#Map_Monitor,obMap(a0)
		move.w	#make_art_tile(ArtTile_Monitor,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$F,obActWid(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	loc_80B4
		move.b	#8,obRoutine(a0)
		move.b	#$B,obFrame(a0)
		rts
; ---------------------------------------------------------------------------

loc_80B4:
		move.b	#$46,obColType(a0)
		move.b	obSubtype(a0),obAnim(a0)

loc_80C0:
		move.b	ob2ndRout(a0),d0
		beq.s	loc_811A
		subq.b	#2,d0
		bne.s	loc_80FA
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		bsr.w	ExitPlatform
		btst	#3,obStatus(a1)
		bne.w	loc_80EA
		clr.b	ob2ndRout(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80EA:
		move.w	#$10,d3
		move.w	obX(a0),d2
		bsr.w	PtfmSurfaceHeight
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80FA:
		bsr.w	ObjectFall
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.w	loc_81A4
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)
		clr.b	ob2ndRout(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_811A:
		move.w	#$1A,d1
		move.w	#$F,d2
		bsr.w	sub_83B4
		beq.w	loc_818A
		tst.w	obVelY(a1)
		bmi.s	loc_8138
		cmpi.b	#id_Roll,obAnim(a1)
		beq.s	loc_818A

loc_8138:
		tst.w	d1
		bpl.s	loc_814E
		sub.w	d3,obY(a1)
		bsr.w	loc_4FD4
		move.b	#2,ob2ndRout(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_814E:
		tst.w	d0
		beq.w	loc_8174
		bmi.s	loc_815E
		tst.w	obVelX(a1)
		bmi.s	loc_8174
		bra.s	loc_8164
; ---------------------------------------------------------------------------

loc_815E:
		tst.w	obVelX(a1)
		bpl.s	loc_8174

loc_8164:
		sub.w	d0,obX(a1)
		move.w	#0,obInertia(a1)
		move.w	#0,obVelX(a1)

loc_8174:
		btst	#1,obStatus(a1)
		bne.s	loc_8198
		bset	#5,obStatus(a1)
		bset	#5,obStatus(a0)
		bra.s	loc_81A4
; ---------------------------------------------------------------------------

loc_818A:
		btst	#5,obStatus(a0)
		beq.s	loc_81A4
		move.w	#id_Run,obAnim(a1)

loc_8198:
		bclr	#5,obStatus(a0)
		bclr	#5,obStatus(a1)

loc_81A4:
		lea	(Ani_Monitor).l,a1
		bsr.w	AnimateSprite

loc_81AE:
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ---------------------------------------------------------------------------

sub_81D2:
		addq.b	#2,obRoutine(a0)
		move.b	#0,obColType(a0)
		bsr.w	FindFreeObj
		bne.s	loc_81FA
		_move.b	#id_PowerUp,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obAnim(a0),obAnim(a1)

loc_81FA:
		bsr.w	FindFreeObj
		bne.s	loc_8216
		_move.b	#id_ExplosionItem,obID(a1)
		addq.b	#2,obRoutine(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

loc_8216:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#9,obAnim(a0)
		bra.w	DisplaySprite