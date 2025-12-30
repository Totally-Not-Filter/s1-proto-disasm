; ---------------------------------------------------------------------------

ObjLavaChase:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_CBFC(pc,d0.w),d1
		jmp	off_CBFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_CBFC:	dc.w loc_CC06-off_CBFC
		dc.w loc_CC66-off_CBFC
		dc.w loc_CCA2-off_CBFC
		dc.w loc_CD00-off_CBFC
		dc.w loc_CD1C-off_CBFC
; ---------------------------------------------------------------------------

loc_CC06:
		addq.b	#2,obRoutine(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bra.s	loc_CC16
; ---------------------------------------------------------------------------

loc_CC10:
		bsr.w	FindNextFreeObj
		bne.s	loc_CC58

loc_CC16:
		_move.b	#id_LavaWall,obID(a1)
		move.l	#Map_LWall,obMap(a1)
		move.w	#make_art_tile(ArtTile_MZ_Lava,3,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$50,obActWid(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#1,obPriority(a1)
		move.b	#0,obAnim(a1)
		move.b	#$94,obColType(a1)
		move.l	a0,objoff_3C(a1)

loc_CC58:
		dbf	d1,loc_CC10
		addq.b	#6,obRoutine(a1)
		move.b	#4,obFrame(a1)

loc_CC66:
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	loc_CC72
		neg.w	d0

loc_CC72:
		cmpi.w	#$E0,d0
		bcc.s	loc_CC92
		move.w	(v_player+obY).w,d0
		sub.w	obY(a0),d0
		bcc.s	loc_CC84
		neg.w	d0

loc_CC84:
		cmpi.w	#$60,d0
		bcc.s	loc_CC92
		move.b	#1,objoff_36(a0)
		bra.s	loc_CCA2
; ---------------------------------------------------------------------------

loc_CC92:
		tst.b	objoff_36(a0)
		beq.s	loc_CCA2
		move.w	#$100,obVelX(a0)
		addq.b	#2,obRoutine(a0)

loc_CCA2:
		cmpi.w	#$6A0,obX(a0)
		bne.s	loc_CCB2
		clr.w	obVelX(a0)
		clr.b	objoff_36(a0)

loc_CCB2:
		lea	(Ani_LWall).l,a1
		bsr.w	AnimateSprite
		bsr.w	SpeedToPos
	if FixBugs
		tst.b	objoff_36(a0)
		bne.s	locret_CCE6
		out_of_range.s	loc_CCE8

locret_CCE6:
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		tst.b	objoff_36(a0)
		bne.s	locret_CCE6
		out_of_range.s	loc_CCE8

locret_CCE6:
		rts
	endif
; ---------------------------------------------------------------------------

loc_CCE8:
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		bclr	#7,2(a2,d0.w)
		move.b	#8,obRoutine(a0)
		rts
; ---------------------------------------------------------------------------

loc_CD00:
		movea.l	objoff_3C(a0),a1
		cmpi.b	#8,obRoutine(a1)
		beq.s	loc_CD1C
		move.w	obX(a1),obX(a0)
		subi.w	#$80,obX(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_CD1C:
		bra.w	DeleteObject