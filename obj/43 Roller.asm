; ---------------------------------------------------------------------------

Roller:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_BFB8(pc,d0.w),d1
		jmp	off_BFB8(pc,d1.w)
; ---------------------------------------------------------------------------
off_BFB8:	dc.w loc_BFBE-off_BFB8
		dc.w loc_C00C-off_BFB8
		dc.w loc_C0B0-off_BFB8
; ---------------------------------------------------------------------------

loc_BFBE:
		move.b	#$E,obHeight(a0)
		move.b	#8,obWidth(a0)
		bsr.w	ObjectFall
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_C00A
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Roll,obMap(a0)
		move.w	#make_art_tile(ArtTile_Roller,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$10,obActWid(a0)
		move.b	#$8E,obColType(a0)

locret_C00A:
		rts
; ---------------------------------------------------------------------------

loc_C00C:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	off_C028(pc,d0.w),d1
		jsr	off_C028(pc,d1.w)
		lea	(Ani_Roll).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------
off_C028:	dc.w loc_C030-off_C028
		dc.w loc_C052-off_C028
		dc.w loc_C060-off_C028
		dc.w loc_C08E-off_C028
; ---------------------------------------------------------------------------

loc_C030:
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcs.s	locret_C050
		cmpi.w	#$20,d0
		bcc.s	locret_C050
		addq.b	#2,ob2ndRout(a0)
		move.b	#1,obAnim(a0)
		move.w	#$400,obVelX(a0)

locret_C050:
		rts
; ---------------------------------------------------------------------------

loc_C052:
		cmpi.b	#2,obAnim(a0)
		bne.s	locret_C05E
		addq.b	#2,ob2ndRout(a0)

locret_C05E:
		rts
; ---------------------------------------------------------------------------

loc_C060:
		bsr.w	SpeedToPos
		bsr.w	ObjFloorDist
		cmpi.w	#-8,d1
		blt.s	loc_C07A
		cmpi.w	#$C,d1
		bge.s	loc_C07A
		add.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_C07A:
		addq.b	#2,ob2ndRout(a0)
		bset	#0,objoff_32(a0)
		beq.s	locret_C08C
		move.w	#-$600,obVelY(a0)

locret_C08C:
		rts
; ---------------------------------------------------------------------------

loc_C08E:
		bsr.w	ObjectFall
		tst.w	obVelY(a0)
		bmi.s	locret_C0AE
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_C0AE
		add.w	d1,obY(a0)
		subq.b	#2,ob2ndRout(a0)

loc_C0A8:
		move.w	#0,obVelY(a0)

locret_C0AE:
		rts
; ---------------------------------------------------------------------------

loc_C0B0:
		bra.w	DeleteObject