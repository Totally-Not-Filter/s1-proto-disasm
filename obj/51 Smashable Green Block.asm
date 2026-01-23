; ---------------------------------------------------------------------------

SmashBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_D4D4(pc,d0.w),d1
		jsr	off_D4D4(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------
off_D4D4:	dc.w loc_D4DA-off_D4D4
		dc.w loc_D504-off_D4D4
		dc.w loc_D580-off_D4D4
; ---------------------------------------------------------------------------

loc_D4DA:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Smab,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Block,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#4,obPriority(a0)
		move.b	obSubtype(a0),obFrame(a0)

loc_D504:
		move.b	(v_player+obAnim).w,objoff_32(a0)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		btst	#3,obStatus(a0)
		bne.s	loc_D528

locret_D526:
		rts
; ---------------------------------------------------------------------------

loc_D528:
		cmpi.b	#2,objoff_32(a0)
		bne.s	locret_D526
		bset	#2,obStatus(a1)
		move.b	#$E,obHeight(a1)
		move.b	#7,obWidth(a1)
		move.b	#2,obAnim(a1)
		move.w	#-$300,obVelY(a1)
		bset	#1,obStatus(a1)
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a1)
		bclr	#3,obStatus(a0)
		clr.b	ob2ndRout(a0)
		move.b	#1,obFrame(a0)
		lea	(ObjSmashBlock_Frag).l,a4
		moveq	#4-1,d1
		move.w	#$38,d2
		bsr.w	ObjectFragment

loc_D580:
	if FixBugs
		addq.l	#4,sp	; do not return to caller
	endif
		bsr.w	SpeedToPos
		addi.w	#$38,obVelY(a0)
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