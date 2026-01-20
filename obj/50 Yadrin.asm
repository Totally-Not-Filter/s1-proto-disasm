; ---------------------------------------------------------------------------

ObjYadrin:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_D334(pc,d0.w),d1
		jmp	off_D334(pc,d1.w)
; ---------------------------------------------------------------------------
off_D334:	dc.w loc_D338-off_D334
		dc.w loc_D38C-off_D334
; ---------------------------------------------------------------------------

loc_D338:
		move.l	#Map_Yadrin,obMap(a0)
		move.w	#make_art_tile(ArtTile_Yadrin,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$14,obActWid(a0)
		move.b	#$11,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.b	#$CC,obColType(a0)
		bsr.w	ObjectFall
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_D38A
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		bchg	#0,obStatus(a0)

locret_D38A:
		rts
; ---------------------------------------------------------------------------

loc_D38C:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	off_D3A8(pc,d0.w),d1
		jsr	off_D3A8(pc,d1.w)
		lea	(Ani_Yadrin).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------
off_D3A8:	dc.w loc_D3AC-off_D3A8
		dc.w loc_D3D0-off_D3A8
; ---------------------------------------------------------------------------

loc_D3AC:
		subq.w	#1,objoff_30(a0)
		bpl.s	locret_D3CE
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$100,obVelX(a0)
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)
		bne.s	locret_D3CE
		neg.w	obVelX(a0)

locret_D3CE:
		rts
; ---------------------------------------------------------------------------

loc_D3D0:
		bsr.w	SpeedToPos
		bsr.w	ObjFloorDist
		cmpi.w	#-8,d1
		blt.s	loc_D3F0
		cmpi.w	#$C,d1
		bge.s	loc_D3F0
		add.w	d1,obY(a0)
		bsr.w	ChkHitLeftRightWall
		bne.s	loc_D3F0
		rts
; ---------------------------------------------------------------------------

loc_D3F0:
		subq.b	#2,ob2ndRout(a0)
		move.w	#60-1,objoff_30(a0)
		move.w	#0,obVelX(a0)
		move.b	#0,obAnim(a0)
		rts