; ---------------------------------------------------------------------------

SmashWall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_ADEA(pc,d0.w),d1
		jsr	off_ADEA(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
off_ADEA:	dc.w loc_ADF0-off_ADEA
		dc.w loc_AE1A-off_ADEA
		dc.w loc_AE92-off_ADEA
; ===========================================================================

loc_ADF0:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Smash,obMap(a0)
		move.w	#make_art_tile(ArtTile_GHZ_SLZ_Smashable_Wall,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#4,obPriority(a0)
		move.b	obSubtype(a0),obFrame(a0)

loc_AE1A:
		move.w	(v_player+obVelX).w,objoff_30(a0)
		move.w	#$1B,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		btst	#5,obStatus(a0)
		bne.s	loc_AE3E

locret_AE3C:
		rts
; ===========================================================================

loc_AE3E:
		cmpi.b	#id_Roll,obAnim(a1)
		bne.s	locret_AE3C
		move.w	objoff_30(a0),d0
		bpl.s	loc_AE4E
		neg.w	d0

loc_AE4E:
		cmpi.w	#$480,d0
		bcs.s	locret_AE3C
		move.w	objoff_30(a0),obVelX(a1)
		addq.w	#4,obX(a1)
		lea	(ObjSmashWall_FragRight).l,a4
		move.w	obX(a0),d0
		cmp.w	obX(a1),d0
		bcs.s	loc_AE78
		subq.w	#8,obX(a1)
		lea	(ObjSmashWall_FragLeft).l,a4

loc_AE78:
		move.w	obVelX(a1),obInertia(a1)
		bclr	#5,obStatus(a0)
		bclr	#5,obStatus(a1)
		moveq	#7,d1
		move.w	#$70,d2
		bsr.s	ObjectFragment

loc_AE92:
	if FixBugs
		addq.l	#4,sp	; do not return to caller
	endif
		bsr.w	SpeedToPos
		addi.w	#$70,obVelY(a0)
	if FixBugs
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		rts
	endif