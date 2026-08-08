; ---------------------------------------------------------------------------
; Object 15 - swinging platforms (GHZ, MZ)
; ---------------------------------------------------------------------------

SwingingPlatform:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Swing_Index(pc,d0.w),d1
		jmp	Swing_Index(pc,d1.w)
; ===========================================================================
Swing_Index:
		dc.w	Swing_Main-Swing_Index
		dc.w	Swing_SetSolid-Swing_Index
		dc.w	Swing_Action2-Swing_Index
		dc.w	Swing_Delete-Swing_Index
		dc.w	Swing_Delete-Swing_Index
		dc.w	Swing_Display-Swing_Index

swing_origX:	equ objoff_3A		; original x-axis position
swing_origY:	equ objoff_38		; original y-axis position
; ===========================================================================

Swing_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Swing_GHZ,obMap(a0)
		move.w	#ArtTile_GHZ_MZ_Swing|Tile_Pal3,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#8,obHeight(a0)
		move.w	obY(a0),swing_origY(a0)
		move.w	obX(a0),swing_origX(a0)
		cmpi.b	#id_SLZ,(v_zone).w	; check if level is SLZ
		bne.s	.notSLZ

		move.l	#Map_Swing_SLZ,obMap(a0) ; SLZ specific code
		move.w	#ArtTile_SLZ_Swing|Tile_Pal3,obGfx(a0)
		move.b	#$20,obActWid(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$99,obColType(a0)

.notSLZ:
		_move.b	obID(a0),d4
		moveq	#0,d1
		lea	obSubtype(a0),a2 ; move chain length to a2
		move.b	(a2),d1		; move a2 to d1
		move.w	d1,-(sp)
		andi.w	#$F,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		addq.b	#8,d3
		move.b	d3,objoff_3C(a0)
		subq.b	#8,d3
		tst.b	obFrame(a0)
		beq.s	.makechain
		addq.b	#8,d3
		subq.w	#1,d1

.makechain:
	if FixBugs
		bsr.w	FindNextFreeObj
	else
		bsr.w	FindFreeObj
	endif
		bne.s	.fail
		addq.b	#1,obSubtype(a0)
		move.w	a1,d5
		subi.w	#v_objspace,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,obRoutine(a1) ; goto Swing_Display next
		_move.b	d4,obID(a1)	; load swinging object
		move.l	obMap(a0),obMap(a1)
		move.w	obGfx(a0),obGfx(a1)
		bclr	#6,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#4,obPriority(a1)
		move.b	#8,obActWid(a1)
		move.b	#1,obFrame(a1)
		move.b	d3,objoff_3C(a1)
		subi.b	#$10,d3
		bcc.s	.notanchor
		move.b	#2,obFrame(a1)
		bset	#6,obGfx(a1)

.notanchor:
		dbf	d1,.makechain ; repeat d1 times (chain length)

.fail:
		move.w	a0,d5
		subi.w	#v_objspace,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.w	#$4080,obAngle(a0)
		move.w	#-$200,objoff_3E(a0)
		move.w	(sp)+,d1
		btst	#4,d1		; is object type $1X?
		beq.s	Swing_SetSolid	; if not, branch
		move.l	#Map_GBall,obMap(a0) ; use GHZ ball mappings
		move.w	#ArtTile_GHZ_Giant_Ball|Tile_Pal3,obGfx(a0)
		move.b	#1,obFrame(a0)
		move.b	#2,obPriority(a0)
		move.b	#$81,obColType(a0) ; make object hurt when touched

Swing_SetSolid:	; Routine 2
		moveq	#0,d1
		move.b	obActWid(a0),d1
		moveq	#0,d3
		move.b	obHeight(a0),d3
		bsr.w	Swing_Solid
		bsr.w	Swing_Move
	if FixBugs=0
		bsr.w	DisplaySprite
	endif
		bra.w	Swing_ChkDel
; ===========================================================================

Swing_Action2:	; Routine 4
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
	if FixBugs=0
		bsr.w	DisplaySprite
	endif
		bra.w	Swing_ChkDel

		rts

; ---------------------------------------------------------------------------
; Subroutine to change Sonic's position with a platform
; ---------------------------------------------------------------------------

MvSonicOnPtfm:
		lea	(v_player).w,a1
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.s	MvSonic2
; End of function MvSonicOnPtfm

; ---------------------------------------------------------------------------
; Subroutine to change Sonic's position with a platform
; ---------------------------------------------------------------------------

MvSonicOnPtfm2:
		lea	(v_player).w,a1
		move.w	obY(a0),d0
		subi.w	#9,d0

MvSonic2:
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		sub.w	obX(a0),d2
		sub.w	d2,obX(a1)
		rts
; End of function MvSonicOnPtfm2

; ===========================================================================

Swing_Move:
		move.b	(v_oscillate+$1A).w,d0
		move.w	#$80,d1
		btst	#0,obStatus(a0)
		beq.s	loc_5650
		neg.w	d0
		add.w	d1,d0

loc_5650:
		bra.s	Swing_Move2
; End of function Swing_Move

; ===========================================================================

Obj48_Move:
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
; ===========================================================================

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
; End of function Obj48_Move

; ===========================================================================

Swing_Move2:
		bsr.w	CalcSine
		move.w	swing_origY(a0),d2
		move.w	swing_origX(a0),d3
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
; ===========================================================================

Swing_ChkDel:
		out_of_range.w	Swing_DelAll,swing_origX(a0)
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ===========================================================================

Swing_DelAll:
		moveq	#0,d2
		lea	obSubtype(a0),a2
		move.b	(a2)+,d2

Swing_DelLoop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	DeleteChild
		dbf	d2,Swing_DelLoop ; repeat for length of chain
		rts
; ===========================================================================

Swing_Delete:	; Routine 6, 8
		bsr.w	DeleteObject
		rts
; ===========================================================================

Swing_Display:	; Routine $A
		bra.w	DisplaySprite