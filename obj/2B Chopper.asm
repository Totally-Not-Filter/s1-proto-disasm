; ---------------------------------------------------------------------------

ObjChopper:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_8BB6(pc,d0.w),d1
		jsr	off_8BB6(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_8BB6:	dc.w loc_8BBA-off_8BB6
		dc.w loc_8BF0-off_8BB6
; ---------------------------------------------------------------------------

loc_8BBA:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Chop,obMap(a0)
		move.w	#make_art_tile(ArtTile_Chopper,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#9,obColType(a0)
		move.b	#$10,obActWid(a0)
		move.w	#-$700,obVelY(a0)
		move.w	obY(a0),objoff_30(a0)

loc_8BF0:
		lea	(Ani_Chop).l,a1
		bsr.w	AnimateSprite
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		move.w	objoff_30(a0),d0
		cmp.w	obY(a0),d0
		bcc.s	loc_8C18
		move.w	d0,obY(a0)
		move.w	#-$700,obVelY(a0)

loc_8C18:
		move.b	#1,obAnim(a0)
		subi.w	#$C0,d0
		cmp.w	obY(a0),d0
		bcc.s	locret_8C3A
		move.b	#0,obAnim(a0)
		tst.w	obVelY(a0)
		bmi.s	locret_8C3A
		move.b	#2,obAnim(a0)

locret_8C3A:
		rts