; ---------------------------------------------------------------------------

ObjBallhog:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_6F3E(pc,d0.w),d1
		jmp	off_6F3E(pc,d1.w)
; ---------------------------------------------------------------------------

off_6F3E:	dc.w loc_6F46-off_6F3E
		dc.w loc_6F96-off_6F3E
		dc.w loc_7056-off_6F3E
		dc.w loc_705C-off_6F3E
; ---------------------------------------------------------------------------

loc_6F46:
		move.b	#$13,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Hog,obMap(a0)
		move.w	#make_art_tile(ArtTile_Ball_Hog,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#5,obColType(a0)
		move.b	#$C,obActWid(a0)
		bsr.w	ObjectFall
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	locret_6F94
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)

locret_6F94:
		rts
; ---------------------------------------------------------------------------

loc_6F96:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	off_6FB2(pc,d0.w),d1
		jsr	off_6FB2(pc,d1.w)
		lea	(Ani_Hog).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_6FB2:	dc.w loc_6FB6-off_6FB2
		dc.w loc_701C-off_6FB2
; ---------------------------------------------------------------------------

loc_6FB6:
		subq.w	#1,objoff_30(a0)
		bpl.s	loc_6FE6
		addq.b	#2,ob2ndRout(a0)
		move.w	#256-1,objoff_30(a0)
		move.w	#$40,obVelX(a0)
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)
		bne.s	loc_6FDE
		neg.w	obVelX(a0)

loc_6FDE:
		move.b	#0,objoff_32(a0)
		rts
; ---------------------------------------------------------------------------

loc_6FE6:
		tst.b	objoff_32(a0)
		bne.s	locret_6FF4
		cmpi.b	#2,obFrame(a0)
		beq.s	loc_6FF6

locret_6FF4:
		rts
; ---------------------------------------------------------------------------

loc_6FF6:
		move.b	#1,objoff_32(a0)
		bsr.w	FindFreeObj
		bne.s	locret_701A
		_move.b	#id_Cannonball,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		addi.w	#$10,obY(a1)

locret_701A:
		rts
; ---------------------------------------------------------------------------

loc_701C:
		subq.w	#1,objoff_30(a0)
		bmi.s	loc_7032
		bsr.w	SpeedToPos
		jsr	(ObjFloorDist).l
		add.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_7032:
		subq.b	#2,ob2ndRout(a0)
		move.w	#60-1,objoff_30(a0)
		move.w	#0,obVelX(a0)
		move.b	#0,obAnim(a0)
		tst.b	obRender(a0)
		bpl.s	locret_7054
		move.b	#2,obAnim(a0)

locret_7054:
		rts
; ---------------------------------------------------------------------------

loc_7056:
		bsr.w	DisplaySprite
		rts
; ---------------------------------------------------------------------------

loc_705C:
		bsr.w	DeleteObject
		rts