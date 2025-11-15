; ---------------------------------------------------------------------------

ObjLavaHurt:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_CD2E(pc,d0.w),d1
		jmp	off_CD2E(pc,d1.w)
; ---------------------------------------------------------------------------

off_CD2E:	dc.w loc_CD36-off_CD2E, loc_CD6C-off_CD2E

byte_CD32:	dc.b $96, $94, $95, 0
; ---------------------------------------------------------------------------

loc_CD36:
		addq.b	#2,obRoutine(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		move.b	byte_CD32(pc,d0.w),obColType(a0)
		move.l	#Map_LTag,obMap(a0)
		move.w	#make_art_tile(ArtTile_Monitor,0,1),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$80,obActWid(a0)
		move.b	#4,obPriority(a0)
		move.b	obSubtype(a0),obFrame(a0)

loc_CD6C:
		tst.w	(v_debuguse).w
		beq.s	loc_CD76
		bsr.w	DisplaySprite

loc_CD76:
		cmpi.b	#6,(v_player+obRoutine).w
		bcc.s	loc_CD84
		bset	#7,obRender(a0)

loc_CD84:
		move.w	obX(a0),d0
		andi.w	#-$80,d0
		move.w	(v_scrposx).w,d1
		subi.w	#$80,d1
		andi.w	#-$80,d1
		sub.w	d1,d0
		bmi.w	DeleteObject
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts