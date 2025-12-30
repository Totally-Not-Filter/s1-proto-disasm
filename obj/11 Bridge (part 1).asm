; ---------------------------------------------------------------------------

Bridge:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_4E64(pc,d0.w),d1
		jmp	off_4E64(pc,d1.w)
; ---------------------------------------------------------------------------

off_4E64:	dc.w Bridge_Init-off_4E64
		dc.w loc_4F32-off_4E64
		dc.w loc_50B2-off_4E64
		dc.w Bridge_Delete-off_4E64
		dc.w Bridge_Delete-off_4E64
		dc.w Bridge_Display-off_4E64
; ---------------------------------------------------------------------------

Bridge_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#MapBridge,obMap(a0)
		move.w	#make_art_tile(ArtTile_GHZ_Bridge,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$80,obActWid(a0)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		_move.b	obID(a0),d4
		lea	obSubtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1
		move.b	#0,(a2)+
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3
		subq.b	#2,d1
		bcs.s	loc_4F32

Bridge_MakeLog:
	if FixBugs
		bsr.w	FindNextFreeObj
	else
		bsr.w	FindFreeObj
	endif
		bne.s	loc_4F32
		addq.b	#1,obSubtype(a0)
		cmp.w	obX(a0),d3
		bne.s	loc_4EE6
		addi.w	#$10,d3
		move.w	d2,obY(a0)
		move.w	d2,objoff_3C(a0)
		move.w	a0,d5
		subi.w	#v_objspace,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		addq.b	#1,obSubtype(a0)

loc_4EE6:
		move.w	a1,d5
		subi.w	#v_objspace,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,obRoutine(a1)
		_move.b	d4,obID(a1)
		move.w	d2,obY(a1)
		move.w	d2,objoff_3C(a1)
		move.w	d3,obX(a1)
		move.l	#MapBridge,obMap(a1)
		move.w	#make_art_tile(ArtTile_GHZ_Bridge,2,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#3,obPriority(a1)
		move.b	#8,obActWid(a1)
		addi.w	#$10,d3
		dbf	d1,Bridge_MakeLog

loc_4F32:
		bsr.s	PtfmBridge
		tst.b	objoff_3E(a0)
		beq.s	loc_4F42
		subq.b	#4,objoff_3E(a0)
		bsr.w	Bridge_UpdateBend

loc_4F42:
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	Bridge_ChkDelete