; ---------------------------------------------------------------------------

ObjCapsule:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_B66C(pc,d0.w),d1
		jsr	off_B66C(pc,d1.w)
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ===========================================================================
off_B66C:	dc.w loc_B68C-off_B66C
		dc.w loc_B6D6-off_B66C
		dc.w loc_B710-off_B66C
		dc.w loc_B760-off_B66C
		dc.w loc_B760-off_B66C
		dc.w loc_B760-off_B66C
		dc.w loc_B7C6-off_B66C
		dc.w loc_B7FA-off_B66C

byte_B67C:	;    routine, actwid, priority, frame
		dc.b 2, $20, 4, 0
		dc.b 4, $C, 5, 1
		dc.b 6, $10, 4, 3
		dc.b 8, $10, 3, 5
; ===========================================================================

loc_B68C:
		move.l	#Map_Pri,obMap(a0)
		move.w	#make_art_tile(ArtTile_Prison_Capsule,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	obY(a0),objoff_30(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.w	#2,d0
		lea	byte_B67C(pc,d0.w),a1
		move.b	(a1)+,obRoutine(a0)
		move.b	(a1)+,obActWid(a0)
		move.b	(a1)+,obPriority(a0)
		move.b	(a1)+,obFrame(a0)
		cmpi.w	#8,d0
		bne.s	locret_B6D4
		move.b	#6,obColType(a0)
		move.b	#8,obColProp(a0)

locret_B6D4:
		rts
; ===========================================================================

loc_B6D6:
		cmpi.b	#2,(v_bossstatus).w
		beq.s	loc_B6F2
		move.w	#$2B,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	obX(a0),d4
		bra.w	SolidObject
; ===========================================================================

loc_B6F2:
		tst.b	ob2ndRout(a0)
		beq.s	loc_B708
		clr.b	ob2ndRout(a0)
		bclr	#3,(v_player+obStatus).w
		bset	#1,(v_player+obStatus).w

loc_B708:
		move.b	#2,obFrame(a0)
		rts
; ===========================================================================

loc_B710:
		move.w	#$17,d1
		move.w	#8,d2
		move.w	#8,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		lea	(Ani_Pri).l,a1
		bsr.w	AnimateSprite
		move.w	objoff_30(a0),obY(a0)
		tst.b	ob2ndRout(a0)
		beq.s	locret_B75E
		addq.w	#8,obY(a0)
		move.b	#$A,obRoutine(a0)
		move.w	#60,obTimeFrame(a0)
		clr.b	(f_timecount).w
		clr.b	ob2ndRout(a0)
		bclr	#3,(v_player+obStatus).w
		bset	#1,(v_player+obStatus).w

locret_B75E:
		rts
; ===========================================================================

loc_B760:
		move.b	(v_vint_byte).w,d0
		andi.b	#7,d0
		bne.s	loc_B7A0
		bsr.w	FindFreeObj
		bne.s	loc_B7A0
		_move.b	#id_ExplosionBomb,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,obX(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,obY(a1)

loc_B7A0:
		subq.w	#1,obTimeFrame(a0)
		bne.s	locret_B7C4
		move.b	#2,(v_bossstatus).w
		move.b	#$C,obRoutine(a0)
		move.b	#9,obFrame(a0)
		move.w	#180,obTimeFrame(a0)
		addi.w	#$20,obY(a0)

locret_B7C4:
		rts
; ===========================================================================

loc_B7C6:
		move.b	(v_vint_byte).w,d0
		andi.b	#7,d0
		bne.s	loc_B7E8
		bsr.w	FindFreeObj
		bne.s	loc_B7E8
		_move.b	#id_Animals,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

loc_B7E8:
		subq.w	#1,obTimeFrame(a0)
		bne.s	locret_B7F8
		addq.b	#2,obRoutine(a0)
		move.w	#60,obTimeFrame(a0)

locret_B7F8:
		rts
; ===========================================================================

loc_B7FA:
		subq.w	#1,obTimeFrame(a0)
		bne.s	locret_B808
		bsr.w	GotThroughAct
	if FixBugs
		addq.l	#4,sp	; do not return to caller
	endif
		bra.w	DeleteObject
; ===========================================================================

locret_B808:
		rts