; ---------------------------------------------------------------------------

ObjFan:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_E56C(pc,d0.w),d1
		jmp	off_E56C(pc,d1.w)
; ---------------------------------------------------------------------------

off_E56C:	dc.w loc_E570-off_E56C
		dc.w loc_E594-off_E56C
; ---------------------------------------------------------------------------

loc_E570:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Fan,obMap(a0)
		move.w	#make_art_tile(ArtTile_SLZ_Fan,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#4,obPriority(a0)

loc_E594:
		btst	#1,obSubtype(a0)
		bne.s	loc_E5B6
		subq.w	#1,objoff_30(a0)
		bpl.s	loc_E5B6
		move.w	#120,objoff_30(a0)
		bchg	#0,objoff_32(a0)
		beq.s	loc_E5B6
		move.w	#180,objoff_30(a0)

loc_E5B6:
		tst.b	objoff_32(a0)
		bne.w	loc_E64E
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		btst	#0,obStatus(a0)
		bne.s	loc_E5D4
		neg.w	d0

loc_E5D4:
		addi.w	#$50,d0
		cmpi.w	#$F0,d0
		bcc.s	loc_E61C
		move.w	obY(a1),d1
		addi.w	#$60,d1
		sub.w	obY(a0),d1
		bcs.s	loc_E61C
		cmpi.w	#$70,d1
		bcc.s	loc_E61C
		subi.w	#$50,d0
		bcc.s	loc_E5FC
		not.w	d0
		add.w	d0,d0

loc_E5FC:
		addi.w	#$60,d0
		btst	#0,obStatus(a0)
		bne.s	loc_E60A
		neg.w	d0

loc_E60A:
		neg.b	d0
		asr.w	#4,d0
		btst	#0,obSubtype(a0)
		beq.s	loc_E618
		neg.w	d0

loc_E618:
		add.w	d0,obX(a1)

loc_E61C:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	loc_E64E
		move.b	#0,obTimeFrame(a0)
		addq.b	#1,obAniFrame(a0)
		cmpi.b	#3,obAniFrame(a0)
		bcs.s	loc_E63A
		move.b	#0,obAniFrame(a0)

loc_E63A:
		moveq	#0,d0
		btst	#0,obSubtype(a0)
		beq.s	loc_E646
		moveq	#2,d0

loc_E646:
		add.b	obAniFrame(a0),d0
		move.b	d0,obFrame(a0)

loc_E64E:
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif