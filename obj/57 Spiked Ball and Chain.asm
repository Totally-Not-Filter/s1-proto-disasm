; ---------------------------------------------------------------------------

SpikeBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ObjSpikedBalls_Index(pc,d0.w),d1
		jmp	ObjSpikedBalls_Index(pc,d1.w)
; ---------------------------------------------------------------------------
ObjSpikedBalls_Index:dc.w ObjSpikedBalls_Init-ObjSpikedBalls_Index
		dc.w ObjSpikedBalls_Move-ObjSpikedBalls_Index
		dc.w ObjSpikedBalls_Display-ObjSpikedBalls_Index
; ---------------------------------------------------------------------------

ObjSpikedBalls_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_SBall,obMap(a0)
		move.w	#make_art_tile(ArtTile_SZ_Spikeball_Chain,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.w	obX(a0),objoff_3A(a0)
		move.w	obY(a0),objoff_38(a0)
		move.b	#$98,obColType(a0)
		move.b	obSubtype(a0),d1
		andi.b	#$F0,d1
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,objoff_3E(a0)
		move.b	obStatus(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,obAngle(a0)
		lea	objoff_29(a0),a2
		move.b	obSubtype(a0),d1
		andi.w	#7,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		move.b	d3,objoff_3C(a0)
		subq.w	#1,d1
		bcs.s	loc_DD5E
		btst	#3,obSubtype(a0)
		beq.s	ObjSpikedBalls_MakeChain
		subq.w	#1,d1
		bcs.s	loc_DD5E

ObjSpikedBalls_MakeChain:
	if FixBugs
		bsr.w	FindNextFreeObj
	else
		bsr.w	FindFreeObj
	endif
		bne.s	loc_DD5E
		addq.b	#1,objoff_29(a0)
		move.w	a1,d5
		subi.w	#v_objspace,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#4,obRoutine(a1)
		_move.b	obID(a0),obID(a1)
		move.l	obMap(a0),obMap(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.b	obRender(a0),obRender(a1)
		move.b	obPriority(a0),obPriority(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.b	obColType(a0),obColType(a1)
		subi.b	#$10,d3
		move.b	d3,objoff_3C(a1)
		dbf	d1,ObjSpikedBalls_MakeChain

loc_DD5E:
		move.w	a0,d5
		subi.w	#v_objspace,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+

ObjSpikedBalls_Move:
		bsr.w	ObjSpikedBalls_MoveStub
		bra.w	ObjSpikedBalls_ChkDelete
; ---------------------------------------------------------------------------

ObjSpikedBalls_MoveStub:
		move.w	objoff_3E(a0),d0
		add.w	d0,obAngle(a0)
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		move.w	objoff_38(a0),d2
		move.w	objoff_3A(a0),d3
		lea	objoff_29(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

ObjSpikedBalls_MoveLoop:
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
		dbf	d6,ObjSpikedBalls_MoveLoop
		rts
; ---------------------------------------------------------------------------

ObjSpikedBalls_ChkDelete:
		out_of_range.w	ObjSpikedBalls_Delete,objoff_3A(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjSpikedBalls_Delete:
		moveq	#0,d2
		lea	objoff_29(a0),a2
		move.b	(a2)+,d2

ObjSpikedBalls_DeleteLoop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	DeleteChild
		dbf	d2,ObjSpikedBalls_DeleteLoop
		rts
; ---------------------------------------------------------------------------

ObjSpikedBalls_Display:
		bra.w	DisplaySprite