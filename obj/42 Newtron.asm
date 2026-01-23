; ---------------------------------------------------------------------------

Newtron:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_BD26(pc,d0.w),d1
		jmp	off_BD26(pc,d1.w)
; ---------------------------------------------------------------------------
off_BD26:	dc.w loc_BD2C-off_BD26
		dc.w loc_BD5C-off_BD26
		dc.w loc_BEC6-off_BD26
; ---------------------------------------------------------------------------

loc_BD2C:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Newt,obMap(a0)
		move.w	#make_art_tile(ArtTile_Newtron,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$14,obActWid(a0)
		move.b	#$10,obHeight(a0)
		move.b	#8,obWidth(a0)

loc_BD5C:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	off_BD78(pc,d0.w),d1
		jsr	off_BD78(pc,d1.w)
		lea	(Ani_Newt).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------
off_BD78:	dc.w loc_BD82-off_BD78
		dc.w loc_BDC4-off_BD78
		dc.w loc_BE38-off_BD78
		dc.w loc_BE58-off_BD78
		dc.w loc_BE5E-off_BD78
; ---------------------------------------------------------------------------

loc_BD82:
		bset	#0,obStatus(a0)
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	loc_BD9A
		neg.w	d0
		bclr	#0,obStatus(a0)

loc_BD9A:
		cmpi.w	#$80,d0
		bcc.s	locret_BDC2
		addq.b	#2,ob2ndRout(a0)
		move.b	#1,obAnim(a0)
		tst.b	obSubtype(a0)
		beq.s	locret_BDC2
		move.w	#make_art_tile(ArtTile_Newtron,0,0),obGfx(a0)
		move.b	#8,ob2ndRout(a0)
		move.b	#4,obAnim(a0)

locret_BDC2:
		rts
; ---------------------------------------------------------------------------

loc_BDC4:
		cmpi.b	#4,obFrame(a0)
		bcc.s	loc_BDE4
		bset	#0,obStatus(a0)
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	locret_BDE2
		bclr	#0,obStatus(a0)

locret_BDE2:
		rts
; ---------------------------------------------------------------------------

loc_BDE4:
		cmpi.b	#1,obFrame(a0)
		bne.s	loc_BDF2
		move.b	#$C,obColType(a0)

loc_BDF2:
		bsr.w	ObjectFall
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_BE36
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,ob2ndRout(a0)
		move.b	#2,obAnim(a0)
		btst	#5,obGfx(a0)
		beq.s	loc_BE1E
		addq.b	#1,obAnim(a0)

loc_BE1E:
		move.b	#$D,obColType(a0)
		move.w	#$200,obVelX(a0)
		btst	#0,obStatus(a0)
		bne.s	locret_BE36
		neg.w	obVelX(a0)

locret_BE36:
		rts
; ---------------------------------------------------------------------------

loc_BE38:
		bsr.w	SpeedToPos

loc_BE3C:
		bsr.w	ObjFloorDist
		cmpi.w	#-8,d1
		blt.s	loc_BE52
		cmpi.w	#$C,d1
		bge.s	loc_BE52
		add.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_BE52:
		addq.b	#2,ob2ndRout(a0)
		rts
; ---------------------------------------------------------------------------

loc_BE58:
		bsr.w	SpeedToPos
		rts
; ---------------------------------------------------------------------------

loc_BE5E:
		cmpi.b	#1,obFrame(a0)
		bne.s	loc_BE6C
		move.b	#$C,obColType(a0)

loc_BE6C:
		cmpi.b	#2,obFrame(a0)
		bne.s	locret_BEC4
		tst.b	objoff_32(a0)
		bne.s	locret_BEC4
		move.b	#1,objoff_32(a0)
		bsr.w	FindFreeObj
		bne.s	locret_BEC4
		_move.b	#id_Missile,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		subq.w	#8,obY(a1)
		move.w	#$200,obVelX(a1)
		move.w	#$14,d0
		btst	#0,obStatus(a0)
		bne.s	loc_BEB4
		neg.w	d0
		neg.w	obVelX(a1)

loc_BEB4:
		add.w	d0,obX(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.b	#1,obSubtype(a1)

locret_BEC4:
		rts
; ---------------------------------------------------------------------------

loc_BEC6:
		bra.w	DeleteObject