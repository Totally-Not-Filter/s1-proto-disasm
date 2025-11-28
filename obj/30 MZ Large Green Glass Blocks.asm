; ---------------------------------------------------------------------------

ObjGlassBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_93DE(pc,d0.w),d1
		jsr	off_93DE(pc,d1.w)
	if FixBugs
		out_of_range.w	.delete
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	.delete
		rts
	endif
; ---------------------------------------------------------------------------

.delete:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

off_93DE:	dc.w loc_93FA-off_93DE, loc_9498-off_93DE, loc_94B0-off_93DE, loc_94CA-off_93DE, loc_94D8-off_93DE
		dc.w loc_9500-off_93DE

byte_93EA:	dc.b 2, 4, 0
		dc.b 4, $48, 1
		dc.b 6, 4, 2
		even

byte_93F4:	dc.b 8, 0, 3
		dc.b $A, 0, 2
; ---------------------------------------------------------------------------

loc_93FA:
		lea	(byte_93EA).l,a2
		moveq	#2,d1
		cmpi.b	#3,obSubtype(a0)
		bcs.s	loc_9412
		lea	(byte_93F4).l,a2
		moveq	#1,d1

loc_9412:
		movea.l	a0,a1
		bra.s	loc_941C
; ---------------------------------------------------------------------------

loc_9416:
		bsr.w	FindNextFreeObj
		bne.s	loc_9486

loc_941C:
		move.b	(a2)+,obRoutine(a1)
		_move.b	#id_GlassBlock,obID(a1)
		move.w	obX(a0),obX(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obY(a0),d0
		move.w	d0,obY(a1)
		move.l	#Map_Glass,obMap(a1)
		move.w	#make_art_tile(ArtTile_MZ_Glass_Pillar,2,1),obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	obY(a1),objoff_30(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.b	#$20,obActWid(a1)
		move.b	#4,obPriority(a1)
		move.b	(a2)+,obFrame(a1)
		move.l	a0,objoff_3C(a1)
		dbf	d1,loc_9416
		move.b	#$10,obActWid(a1)
		move.b	#3,obPriority(a1)
		addq.b	#8,obSubtype(a1)
		andi.b	#$F,obSubtype(a1)

loc_9486:
		move.w	#$90,objoff_32(a0)
		move.b	#$38,obHeight(a0)
		bset	#4,obRender(a0)

loc_9498:
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$24,d2
		move.w	#$24,d3
		move.w	obX(a0),d4
		bra.w	SolidObject
; ---------------------------------------------------------------------------

loc_94B0:
		movea.l	objoff_3C(a0),a1
		move.w	objoff_32(a1),objoff_32(a0)
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$24,d2
		bra.w	Obj44_SolidWall
; ---------------------------------------------------------------------------

loc_94CA:
		movea.l	objoff_3C(a0),a1
		move.w	objoff_32(a1),objoff_32(a0)
		bra.w	sub_9514
; ---------------------------------------------------------------------------

loc_94D8:
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$38,d2
		move.w	#$38,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		cmpi.b	#8,obRoutine(a0)
		beq.s	locret_94FE
		move.b	#8,obRoutine(a0)

locret_94FE:
		rts
; ---------------------------------------------------------------------------

loc_9500:
		movea.l	objoff_3C(a0),a1
		move.w	objoff_32(a1),objoff_32(a0)
		move.w	obY(a1),objoff_30(a0)
		bra.w	sub_9514
; ---------------------------------------------------------------------------

sub_9514:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_9528(pc,d0.w),d1
		jmp	off_9528(pc,d1.w)
; ---------------------------------------------------------------------------

off_9528:	dc.w locret_9532-off_9528, loc_9534-off_9528, loc_9540-off_9528
		dc.w loc_9550-off_9528, loc_95D6-off_9528
; ---------------------------------------------------------------------------

locret_9532:
		rts
; ---------------------------------------------------------------------------

loc_9534:
		move.b	(v_oscillate+$12).w,d0
		move.w	#$40,d1
		bra.w	loc_9616
; ---------------------------------------------------------------------------

loc_9540:
		move.b	(v_oscillate+$12).w,d0
		move.w	#$40,d1
		neg.w	d0
		add.w	d1,d0
		bra.w	loc_9616
; ---------------------------------------------------------------------------

loc_9550:
		btst	#3,obSubtype(a0)
		beq.s	loc_9564
		move.b	(v_oscillate+$12).w,d0
		subi.w	#$10,d0
		bra.w	loc_9624
; ---------------------------------------------------------------------------

loc_9564:
		btst	#3,obStatus(a0)
		bne.s	loc_9574
		bclr	#0,objoff_34(a0)
		bra.s	loc_95A8
; ---------------------------------------------------------------------------

loc_9574:
		tst.b	objoff_34(a0)
		bne.s	loc_95A8
		move.b	#1,objoff_34(a0)
		bset	#0,objoff_35(a0)
		beq.s	loc_95A8
		bset	#7,objoff_34(a0)
		move.w	#$10,objoff_36(a0)
		move.b	#$A,objoff_38(a0)
		cmpi.w	#$40,objoff_32(a0)
		bne.s	loc_95A8
		move.w	#$40,objoff_36(a0)

loc_95A8:
		tst.b	objoff_34(a0)
		bpl.s	loc_95D0
		tst.b	objoff_38(a0)
		beq.s	loc_95BA
		subq.b	#1,objoff_38(a0)
		bne.s	loc_95D0

loc_95BA:
		tst.w	objoff_32(a0)
		beq.s	loc_95CA
		subq.w	#1,objoff_32(a0)
		subq.w	#1,objoff_36(a0)
		bne.s	loc_95D0

loc_95CA:
		bclr	#7,objoff_34(a0)

loc_95D0:
		move.w	objoff_32(a0),d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_95D6:
		btst	#3,obSubtype(a0)
		beq.s	loc_95E8
		move.b	(v_oscillate+$12).w,d0
		subi.w	#$10,d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_95E8:
		tst.b	objoff_34(a0)
		bne.s	loc_9606
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#4,d0
		tst.b	(a2,d0.w)
		beq.s	loc_9610
		move.b	#1,objoff_34(a0)

loc_9606:
		tst.w	objoff_32(a0)
		beq.s	loc_9610
		subq.w	#2,objoff_32(a0)

loc_9610:
		move.w	objoff_32(a0),d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_9616:
		btst	#3,obSubtype(a0)
		beq.s	loc_9624
		neg.w	d0
		add.w	d1,d0
		lsr.b	#1,d0

loc_9624:
		move.w	objoff_30(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)
		rts