; ---------------------------------------------------------------------------

ObjSwitch:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_9D72(pc,d0.w),d1
		jmp	off_9D72(pc,d1.w)
; ---------------------------------------------------------------------------

off_9D72:	dc.w loc_9D76-off_9D72
		dc.w loc_9DAC-off_9D72
; ---------------------------------------------------------------------------

loc_9D76:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_But,obMap(a0)
		move.w	#make_art_tile(ArtTile_Button+4,2,0),obGfx(a0)
		cmpi.b	#id_MZ,(v_zone).w
		beq.s	loc_9D96
		move.w	#make_art_tile(ArtTile_Button+4,0,0),obGfx(a0)

loc_9D96:
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#4,obPriority(a0)
		addq.w	#3,obY(a0)

loc_9DAC:
		tst.b	obRender(a0)
		bpl.s	loc_9E2E
		move.w	#$1B,d1
		move.w	#5,d2
		move.w	#5,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		bclr	#0,obFrame(a0)
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		lea	(f_switch).w,a3
		lea	(a3,d0.w),a3
		tst.b	obSubtype(a0)
		bpl.s	loc_9DE8
		bsr.w	sub_9E58
		bne.s	loc_9DFE

loc_9DE8:
		moveq	#0,d3
		btst	#6,obSubtype(a0)
		beq.s	loc_9DF4
		moveq	#7,d3

loc_9DF4:
		tst.b	ob2ndRout(a0)
		bne.s	loc_9DFE
		bclr	d3,(a3)
		bra.s	loc_9E14
; ---------------------------------------------------------------------------

loc_9DFE:
		tst.b	(a3)
		bne.s	loc_9E0C
		move.w	#sfx_Switch,d0
		jsr	(QueueSound2).l

loc_9E0C:
		bset	#0,obFrame(a0)
		bset	d3,(a3)

loc_9E14:
		btst	#5,obSubtype(a0)
		beq.s	loc_9E2E
		subq.b	#1,obTimeFrame(a0)
		bpl.s	loc_9E2E
		move.b	#7,obTimeFrame(a0)
		bchg	#1,obFrame(a0)

loc_9E2E:
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

sub_9E58:
		move.w	obX(a0),d2
		move.w	obY(a0),d3
		subi.w	#$10,d2
		subq.w	#8,d3
		move.w	#$20,d4
		move.w	#$10,d5
		lea	(v_lvlobjspace).w,a1
		move.w	#(v_lvlobjend-v_lvlobjspace)/object_size-1,d6

loc_9E76:
		tst.b	obRender(a1)
		bpl.s	loc_9E82
		cmpi.b	#id_PushBlock,obID(a1)
		beq.s	loc_9E90

loc_9E82:
		lea	object_size(a1),a1
		dbf	d6,loc_9E76
		moveq	#0,d0

locret_9E8C:
		rts
; ---------------------------------------------------------------------------
But_MZData:	dc.b $10, $10
; ---------------------------------------------------------------------------

loc_9E90:
		moveq	#1,d0
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	But_MZData-2(pc,d0.w),a2
		move.b	(a2)+,d1
		ext.w	d1
		move.w	obX(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_9EB2
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_9EB6
		bra.s	loc_9E82
; ---------------------------------------------------------------------------

loc_9EB2:
		cmp.w	d4,d0
		bhi.s	loc_9E82

loc_9EB6:
		move.b	(a2)+,d1
		ext.w	d1
		move.w	obY(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_9ECC
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_9ED0
		bra.s	loc_9E82
; ---------------------------------------------------------------------------

loc_9ECC:
		cmp.w	d5,d0
		bhi.s	loc_9E82

loc_9ED0:
		moveq	#1,d0
		rts