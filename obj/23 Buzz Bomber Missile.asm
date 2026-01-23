; ---------------------------------------------------------------------------

Missile:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_79FA(pc,d0.w),d1
		jmp	off_79FA(pc,d1.w)
; ---------------------------------------------------------------------------
off_79FA:	dc.w loc_7A04-off_79FA
		dc.w loc_7A4E-off_79FA
		dc.w loc_7A6C-off_79FA
		dc.w loc_7AB2-off_79FA
		dc.w loc_7AB8-off_79FA
; ---------------------------------------------------------------------------

loc_7A04:
		subq.w	#1,objoff_32(a0)
		bpl.s	sub_7A5E
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Missile,obMap(a0)
		move.w	#make_art_tile(ArtTile_Buzz_Bomber,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#8,obActWid(a0)
		andi.b	#3,obStatus(a0)
		tst.b	obSubtype(a0)
		beq.s	loc_7A4E
		move.b	#8,obRoutine(a0)
		move.b	#$87,obColType(a0)
		move.b	#1,obAnim(a0)
		bra.s	loc_7AC2
; ---------------------------------------------------------------------------

loc_7A4E:
		bsr.s	sub_7A5E
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

sub_7A5E:
		movea.l	objoff_3C(a0),a1
		_cmpi.b	#id_ExplosionItem,obID(a1)
		beq.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7A6C:
		btst	#7,obStatus(a0)
		bne.s	loc_7AA2
		move.b	#$87,obColType(a0)
		move.b	#1,obAnim(a0)
		bsr.w	SpeedToPos
	if FixBugs
		move.w	(v_limitbtm2).w,d0
		addi.w	#224,d0
		cmp.w	obY(a0),d0
		bcs.s	loc_7AB2
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
	else
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		move.w	(v_limitbtm2).w,d0
		addi.w	#224,d0
		cmp.w	obY(a0),d0
		bcs.s	loc_7AB2
		rts
	endif
; ---------------------------------------------------------------------------

loc_7AA2:
		_move.b	#id_MissileDissolve,obID(a0)
		move.b	#0,obRoutine(a0)
		bra.w	MissileDissolve
; ---------------------------------------------------------------------------

loc_7AB2:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7AB8:
		tst.b	obRender(a0)
		bpl.s	loc_7AB2
		bsr.w	SpeedToPos

loc_7AC2:
		lea	(Ani_Missile).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts