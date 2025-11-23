; ---------------------------------------------------------------------------

ObjBurrobot:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_8CFC(pc,d0.w),d1
		jmp	off_8CFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_8CFC:	dc.w loc_8D02-off_8CFC, loc_8D56-off_8CFC, loc_8E46-off_8CFC
; ---------------------------------------------------------------------------

loc_8D02:
		move.b	#$13,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Burro,obMap(a0)
		move.w	#make_art_tile(ArtTile_Burrobot,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#5,obColType(a0)
		move.b	#$C,obActWid(a0)
		bset	#0,obStatus(a0)
		bsr.w	ObjectFall
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_8D54
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)

locret_8D54:
		rts
; ---------------------------------------------------------------------------

loc_8D56:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	off_8D72(pc,d0.w),d1
		jsr	off_8D72(pc,d1.w)
		lea	(Ani_Burro).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_8D72:	dc.w loc_8D78-off_8D72, loc_8DA2-off_8D72, loc_8E10-off_8D72
; ---------------------------------------------------------------------------

loc_8D78:
		subq.w	#1,objoff_30(a0)
		bpl.s	locret_8DA0
		addq.b	#2,ob2ndRout(a0)
		move.w	#256-1,objoff_30(a0)
		move.w	#$80,obVelX(a0)
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)
		beq.s	locret_8DA0
		neg.w	obVelX(a0)

locret_8DA0:
		rts
; ---------------------------------------------------------------------------

loc_8DA2:
		subq.w	#1,objoff_30(a0)
		bmi.s	loc_8DDE
		bsr.w	SpeedToPos
		bchg	#0,objoff_32(a0)
		bne.s	loc_8DD4
		move.w	obX(a0),d3
		addi.w	#$C,d3
		btst	#0,obStatus(a0)
		bne.s	loc_8DC8
		subi.w	#$18,d3

loc_8DC8:
		bsr.w	ObjFloorDist2
		cmpi.w	#$C,d1
		bge.s	loc_8DDE
		rts
; ---------------------------------------------------------------------------

loc_8DD4:
		bsr.w	ObjFloorDist
		add.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_8DDE:
		btst	#2,(v_vint_byte).w
		beq.s	loc_8DFE
		subq.b	#2,ob2ndRout(a0)
		move.w	#60-1,objoff_30(a0)
		move.w	#0,obVelX(a0)
		move.b	#0,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_8DFE:
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$400,obVelY(a0)
		move.b	#2,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_8E10:
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		bmi.s	locret_8E44
		move.b	#3,obAnim(a0)
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_8E44
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		move.b	#1,obAnim(a0)
		move.w	#256-1,objoff_30(a0)
		subq.b	#2,ob2ndRout(a0)

locret_8E44:
		rts
; ---------------------------------------------------------------------------

loc_8E46:
		bsr.w	DeleteObject
		rts