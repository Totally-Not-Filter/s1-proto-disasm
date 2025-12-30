; ---------------------------------------------------------------------------

ObjBumper:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_C5FE(pc,d0.w),d1
		jmp	off_C5FE(pc,d1.w)
; ---------------------------------------------------------------------------

off_C5FE:	dc.w loc_C602-off_C5FE
		dc.w loc_C62C-off_C5FE
; ---------------------------------------------------------------------------

loc_C602:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Bump,obMap(a0)
		move.w	#make_art_tile(ArtTile_SZ_Bumper,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#1,obPriority(a0)
		move.b	#$D7,obColType(a0)

loc_C62C:
		tst.b	obColProp(a0)
		beq.s	loc_C684
		clr.b	obColProp(a0)
		lea	(v_player).w,a1
		move.w	obX(a0),d1
		move.w	obY(a0),d2
		sub.w	obX(a1),d1
		sub.w	obY(a1),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#-$700,d1
		asr.l	#8,d1
		move.w	d1,obVelX(a1)
		muls.w	#-$700,d0
		asr.l	#8,d0
		move.w	d0,obVelY(a1)
		bset	#1,obStatus(a1)
		clr.b	objoff_3C(a1)
		move.b	#1,obAnim(a0)
		move.w	#sfx_Bumper,d0
		jsr	(QueueSound2).l

loc_C684:
		lea	(Ani_Bump).l,a1
		bsr.w	AnimateSprite
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif