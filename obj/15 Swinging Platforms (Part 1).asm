; ---------------------------------------------------------------------------
; Object 15 - swinging platforms (GHZ, MZ)
; ---------------------------------------------------------------------------

SwingingPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Swing_Index(pc,d0.w),d1
		jmp	Swing_Index(pc,d1.w)
; ===========================================================================
Swing_Index:	dc.w Swing_Main-Swing_Index, Swing_SetSolid-Swing_Index
		dc.w Swing_Action2-Swing_Index, Swing_Delete-Swing_Index
		dc.w Swing_Delete-Swing_Index, Swing_Display-Swing_Index

swing_origX = objoff_3A		; original x-axis position
swing_origY = objoff_38		; original y-axis position
; ===========================================================================

Swing_Main:
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
		beq.s	Swing_SetSolid
		move.l	#Map_GBall,obMap(a0)
		move.w	#make_art_tile(ArtTile_GHZ_Giant_Ball,2,0),obGfx(a0)
		move.b	#1,obFrame(a0)
		move.b	#2,obPriority(a0)
		move.b	#$81,obColType(a0)

Swing_SetSolid:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		moveq	#0,d3
		move.b	obHeight(a0),d3
		bsr.w	Swing_Solid
		bsr.w	Swing_Move
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	Swing_ChkDel
; ===========================================================================

Swing_Action2:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		bsr.w	ExitPlatform
		move.w	obX(a0),-(sp)
		bsr.w	Swing_Move
		move.w	(sp)+,d2
		moveq	#0,d3
		move.b	obHeight(a0),d3
		addq.b	#1,d3
		bsr.w	MvSonicOnPtfm
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	Swing_ChkDel

		rts