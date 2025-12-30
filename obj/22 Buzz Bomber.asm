; ---------------------------------------------------------------------------

ObjBuzzbomber:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_78A6(pc,d0.w),d1
		jmp	off_78A6(pc,d1.w)
; ---------------------------------------------------------------------------

off_78A6:	dc.w loc_78AC-off_78A6
		dc.w loc_78D6-off_78A6
		dc.w loc_79E6-off_78A6
; ---------------------------------------------------------------------------

loc_78AC:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Buzz,obMap(a0)
		move.w	#make_art_tile(ArtTile_Buzz_Bomber,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#8,obColType(a0)
		move.b	#$18,obActWid(a0)

loc_78D6:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	off_78F2(pc,d0.w),d1
		jsr	off_78F2(pc,d1.w)
		lea	(Ani_Buzz).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_78F2:
		dc.w loc_78F6-off_78F2
		dc.w loc_798C-off_78F2
; ---------------------------------------------------------------------------

loc_78F6:
		subq.w	#1,objoff_32(a0)
		bpl.s	locret_7926
		btst	#1,objoff_34(a0)
		bne.s	loc_7928
		addq.b	#2,ob2ndRout(a0)
		move.w	#128-1,objoff_32(a0)
		move.w	#$400,obVelX(a0)
		move.b	#1,obAnim(a0)
		btst	#0,obStatus(a0)
		bne.s	locret_7926
		neg.w	obVelX(a0)

locret_7926:
		rts
; ---------------------------------------------------------------------------

loc_7928:
		bsr.w	FindFreeObj
		bne.s	locret_798A
		_move.b	#id_Missile,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		addi.w	#$1C,obY(a1)
		move.w	#$200,obVelY(a1)
		move.w	#$200,obVelX(a1)
	if FixBugs
		; Matches with Newtron's.
		move.w	#$14,d0
	else
		; Bug: This doesn't match with Newtron's setting, resulting in the x position being off by 4 pixels.
		move.w	#$18,d0
	endif
		btst	#0,obStatus(a0)
		bne.s	loc_7964
		neg.w	d0
		neg.w	obVelX(a1)

loc_7964:
		add.w	d0,obX(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.w	#15-1,objoff_32(a1)
		move.l	a0,objoff_3C(a1)
		move.b	#1,objoff_34(a0)
		move.w	#59,objoff_32(a0)
		move.b	#2,obAnim(a0)

locret_798A:
		rts
; ---------------------------------------------------------------------------

loc_798C:
		subq.w	#1,objoff_32(a0)
		bmi.s	loc_79C2
		bsr.w	SpeedToPos
		tst.b	objoff_34(a0)
		bne.s	locret_79E4
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bpl.s	loc_79A8
		neg.w	d0

loc_79A8:
		cmpi.w	#$60,d0
		bcc.s	locret_79E4
		tst.b	obRender(a0)
		bpl.s	locret_79E4
		move.b	#2,objoff_34(a0)
		move.w	#30-1,objoff_32(a0)
		bra.s	loc_79D4
; ---------------------------------------------------------------------------

loc_79C2:
		move.b	#0,objoff_34(a0)
		bchg	#0,obStatus(a0)
		move.w	#60-1,objoff_32(a0)

loc_79D4:
		subq.b	#2,ob2ndRout(a0)
		move.w	#0,obVelX(a0)
		move.b	#0,obAnim(a0)

locret_79E4:
		rts
; ---------------------------------------------------------------------------

loc_79E6:
		bsr.w	DeleteObject
		rts