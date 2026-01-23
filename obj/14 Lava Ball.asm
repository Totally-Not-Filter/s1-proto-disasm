; ---------------------------------------------------------------------------

LavaBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_C23E(pc,d0.w),d1
		jsr	off_C23E(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
off_C23E:	dc.w loc_C254-off_C23E
		dc.w loc_C2C8-off_C23E
		dc.w j_DeleteObject-off_C23E

word_C244:	dc.w -$400, -$500, -$600, -$700, -$200, $200, -$200, $200
; ---------------------------------------------------------------------------

loc_C254:
		addq.b	#2,obRoutine(a0)
		move.b	#8,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Fire,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Fireball,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$8B,obColType(a0)
		move.w	obY(a0),objoff_30(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	word_C244(pc,d0.w),obVelY(a0)
		move.b	#8,obActWid(a0)
		cmpi.b	#6,obSubtype(a0)
		bcs.s	loc_C2BE
		move.b	#$10,obActWid(a0)
		move.b	#2,obAnim(a0)
		move.w	obVelY(a0),obVelX(a0)
		move.w	#0,obVelY(a0)

loc_C2BE:
		move.w	#sfx_Fireball,d0
		jsr	(QueueSound2).l

loc_C2C8:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	off_C306(pc,d0.w),d1
		jsr	off_C306(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(Ani_Fire).l,a1
		bsr.w	AnimateSprite

loc_C2E6:
		out_of_range.w	DeleteObject
		rts
; ---------------------------------------------------------------------------
off_C306:	dc.w loc_C318-off_C306
		dc.w loc_C318-off_C306
		dc.w loc_C318-off_C306
		dc.w loc_C318-off_C306
		dc.w loc_C340-off_C306
		dc.w loc_C362-off_C306
		dc.w loc_C384-off_C306
		dc.w loc_C3A8-off_C306
		dc.w locret_C3CC-off_C306
; ---------------------------------------------------------------------------

loc_C318:
		addi.w	#$18,obVelY(a0)
		move.w	objoff_30(a0),d0
		cmp.w	obY(a0),d0
		bcc.s	loc_C32C
		addq.b	#2,obRoutine(a0)

loc_C32C:
		bclr	#1,obStatus(a0)
		tst.w	obVelY(a0)
		bpl.s	locret_C33E
		bset	#1,obStatus(a0)

locret_C33E:
		rts
; ---------------------------------------------------------------------------

loc_C340:
		bset	#1,obStatus(a0)
		bsr.w	ObjHitCeiling
		tst.w	d1
		bpl.s	locret_C360
		move.b	#8,obSubtype(a0)
		move.b	#1,obAnim(a0)
		move.w	#0,obVelY(a0)

locret_C360:
		rts
; ---------------------------------------------------------------------------

loc_C362:
		bclr	#1,obStatus(a0)
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_C382
		move.b	#8,obSubtype(a0)
		move.b	#1,obAnim(a0)
		move.w	#0,obVelY(a0)

locret_C382:
		rts
; ---------------------------------------------------------------------------

loc_C384:
		bset	#0,obStatus(a0)
		moveq	#-8,d3
		bsr.w	ObjHitWallLeft
		tst.w	d1
		bpl.s	locret_C3A6
		move.b	#8,obSubtype(a0)
		move.b	#3,obAnim(a0)
		move.w	#0,obVelX(a0)

locret_C3A6:
		rts
; ---------------------------------------------------------------------------

loc_C3A8:
		bclr	#0,obStatus(a0)
		moveq	#8,d3
		bsr.w	ObjHitWallRight
		tst.w	d1
		bpl.s	locret_C3CA
		move.b	#8,obSubtype(a0)
		move.b	#3,obAnim(a0)
		move.w	#0,obVelX(a0)

locret_C3CA:
		rts
; ---------------------------------------------------------------------------

locret_C3CC:
		rts
; ---------------------------------------------------------------------------

j_DeleteObject:
		bra.w	DeleteObject