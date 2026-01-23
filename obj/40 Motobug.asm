; ---------------------------------------------------------------------------

MotoBug:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_B890(pc,d0.w),d1
		jmp	off_B890(pc,d1.w)
; ---------------------------------------------------------------------------
off_B890:	dc.w loc_B898-off_B890
		dc.w loc_B8FA-off_B890
		dc.w loc_B9D8-off_B890
		dc.w loc_B9E6-off_B890
; ---------------------------------------------------------------------------

loc_B898:
		move.l	#Map_Moto,obMap(a0)
		move.w	#make_art_tile(ArtTile_Moto_Bug,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$14,obActWid(a0)
		tst.b	obAnim(a0)
		bne.s	loc_B8F2
		move.b	#$E,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.b	#$C,obColType(a0)
		bsr.w	ObjectFall
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_B8F0
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		bchg	#0,obStatus(a0)

locret_B8F0:
		rts
; ---------------------------------------------------------------------------

loc_B8F2:
		addq.b	#4,obRoutine(a0)
		bra.w	loc_B9D8
; ---------------------------------------------------------------------------

loc_B8FA:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	off_B94E(pc,d0.w),d1
		jsr	off_B94E(pc,d1.w)
		lea	(Ani_Moto).l,a1
		bsr.w	AnimateSprite

		include "sub RememberState.asm"
; ---------------------------------------------------------------------------
off_B94E:	dc.w loc_B952-off_B94E
		dc.w loc_B976-off_B94E
; ---------------------------------------------------------------------------

loc_B952:
		subq.w	#1,objoff_30(a0)
		bpl.s	locret_B974
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$100,obVelX(a0)
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)
		bne.s	locret_B974
		neg.w	obVelX(a0)

locret_B974:
		rts
; ---------------------------------------------------------------------------

loc_B976:
		bsr.w	SpeedToPos
		bsr.w	ObjFloorDist
		cmpi.w	#-8,d1
		blt.s	loc_B9C0
		cmpi.w	#$C,d1
		bge.s	loc_B9C0
		add.w	d1,obY(a0)
		subq.b	#1,objoff_33(a0)
		bpl.s	locret_B9BE
		move.b	#$F,objoff_33(a0)
		bsr.w	FindFreeObj
		bne.s	locret_B9BE
		_move.b	#id_MotoBug,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.b	#2,obAnim(a1)

locret_B9BE:
		rts
; ---------------------------------------------------------------------------

loc_B9C0:
		subq.b	#2,ob2ndRout(a0)
		move.w	#59,objoff_30(a0)
		move.w	#0,obVelX(a0)
		move.b	#0,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_B9D8:
		lea	(Ani_Moto).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_B9E6:
		bra.w	DeleteObject