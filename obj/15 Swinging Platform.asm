; ---------------------------------------------------------------------------

ObjSwingPtfm:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_548A(pc,d0.w),d1
		jmp	off_548A(pc,d1.w)
; ---------------------------------------------------------------------------
off_548A:	dc.w ObjSwingPtfm_Init-off_548A
		dc.w loc_55C8-off_548A
		dc.w loc_55E4-off_548A
		dc.w ObjSwingPtfm_Delete-off_548A
		dc.w ObjSwingPtfm_Delete-off_548A
		dc.w j_DisplaySprite-off_548A
; ---------------------------------------------------------------------------

ObjSwingPtfm_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Swing_GHZ,obMap(a0)
		move.w	#make_art_tile(ArtTile_GHZ_MZ_Swing,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#8,obHeight(a0)
		move.w	obY(a0),objoff_38(a0)
		move.w	obX(a0),objoff_3A(a0)
		cmpi.b	#id_SLZ,(v_zone).w		; are we on Star Light Zone?
		bne.s	ObjSwingPtfm_NotSLZ		; if not, branch
		move.l	#Map_Swing_SLZ,obMap(a0)
		move.w	#make_art_tile(ArtTile_SLZ_Swing,2,0),obGfx(a0)
		move.b	#$20,obActWid(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$99,obColType(a0)

ObjSwingPtfm_NotSLZ:
		_move.b	obID(a0),d4
		moveq	#0,d1
		lea	obSubtype(a0),a2
		move.b	(a2),d1
		move.w	d1,-(sp)
		andi.w	#$F,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		addq.b	#8,d3
		move.b	d3,objoff_3C(a0)
		subq.b	#8,d3
		tst.b	obFrame(a0)
		beq.s	ObjSwingPtfm_LoadLinks
		addq.b	#8,d3
		subq.w	#1,d1

ObjSwingPtfm_LoadLinks:
	if FixBugs
		bsr.w	FindNextFreeObj
	else
		bsr.w	FindFreeObj
	endif
		bne.s	loc_5586
		addq.b	#1,obSubtype(a0)
		move.w	a1,d5
		subi.w	#v_objspace,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,obRoutine(a1)
		_move.b	d4,obID(a1)
		move.l	obMap(a0),obMap(a1)
		move.w	obGfx(a0),obGfx(a1)
		bclr	#6,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#4,obPriority(a1)
		move.b	#8,obActWid(a1)
		move.b	#1,obFrame(a1)
		move.b	d3,objoff_3C(a1)
		subi.b	#$10,d3
		bcc.s	loc_5582
		move.b	#2,obFrame(a1)
		bset	#6,obGfx(a1)

loc_5582:
		dbf	d1,ObjSwingPtfm_LoadLinks

loc_5586:
		move.w	a0,d5
		subi.w	#v_objspace,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.w	#$4080,obAngle(a0)
		move.w	#-$200,objoff_3E(a0)
		move.w	(sp)+,d1
		btst	#4,d1
		beq.s	loc_55C8
		move.l	#Map_GBall,obMap(a0)
		move.w	#make_art_tile(ArtTile_GHZ_Giant_Ball,2,0),obGfx(a0)
		move.b	#1,obFrame(a0)
		move.b	#2,obPriority(a0)
		move.b	#$81,obColType(a0)

loc_55C8:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		moveq	#0,d3
		move.b	obHeight(a0),d3
		bsr.w	Swing_Solid
		bsr.w	sub_563C
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	ObjSwingPtfm_ChkDelete
; ---------------------------------------------------------------------------

loc_55E4:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		bsr.w	ExitPlatform
		move.w	obX(a0),-(sp)
		bsr.w	sub_563C
		move.w	(sp)+,d2
		moveq	#0,d3
		move.b	obHeight(a0),d3
		addq.b	#1,d3
		bsr.w	PtfmSurfaceHeight
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	ObjSwingPtfm_ChkDelete
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

PtfmSurfaceHeight:
		lea	(v_player).w,a1
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.s	loc_5626
; ---------------------------------------------------------------------------

ptfmSurfaceNormal:
		lea	(v_player).w,a1
		move.w	obY(a0),d0
		subi.w	#9,d0

loc_5626:
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		sub.w	obX(a0),d2
		sub.w	d2,obX(a1)
		rts
; ---------------------------------------------------------------------------

sub_563C:
		move.b	(v_oscillate+$1A).w,d0
		move.w	#$80,d1
		btst	#0,obStatus(a0)
		beq.s	loc_5650
		neg.w	d0
		add.w	d1,d0

loc_5650:
		bra.s	loc_5692
; ---------------------------------------------------------------------------

loc_5652:
		tst.b	objoff_3D(a0)
		bne.s	loc_5674
		move.w	objoff_3E(a0),d0
		addq.w	#8,d0
		move.w	d0,objoff_3E(a0)
		add.w	d0,obAngle(a0)
		cmpi.w	#$200,d0
		bne.s	loc_568E
		move.b	#1,objoff_3D(a0)
		bra.s	loc_568E
; ---------------------------------------------------------------------------

loc_5674:
		move.w	objoff_3E(a0),d0
		subq.w	#8,d0
		move.w	d0,objoff_3E(a0)
		add.w	d0,obAngle(a0)
		cmpi.w	#-$200,d0
		bne.s	loc_568E
		move.b	#0,objoff_3D(a0)

loc_568E:
		move.b	obAngle(a0),d0

loc_5692:
		bsr.w	CalcSine
		move.w	objoff_38(a0),d2
		move.w	objoff_3A(a0),d3
		lea	obSubtype(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_56A6:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#object_size_bits,d4
		addi.l	#v_objspace&$FFFFFF,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	objoff_3C(a1),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,obY(a1)
		move.w	d5,obX(a1)
		dbf	d6,loc_56A6
		rts
; ---------------------------------------------------------------------------

ObjSwingPtfm_ChkDelete:
		out_of_range.w	ObjSwingPtfm_DeleteAll,objoff_3A(a0)
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ---------------------------------------------------------------------------

ObjSwingPtfm_DeleteAll:
		moveq	#0,d2
		lea	obSubtype(a0),a2
		move.b	(a2)+,d2

loc_56FE:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	DeleteChild
		dbf	d2,loc_56FE
		rts
; ---------------------------------------------------------------------------

ObjSwingPtfm_Delete:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

j_DisplaySprite:
		bra.w	DisplaySprite