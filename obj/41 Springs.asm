; ---------------------------------------------------------------------------

Springs:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_BAA0(pc,d0.w),d1
		jsr	off_BAA0(pc,d1.w)
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ---------------------------------------------------------------------------
off_BAA0:	dc.w loc_BAB8-off_BAA0
		dc.w sub_BB2E-off_BAA0
		dc.w loc_BB84-off_BAA0
		dc.w sub_BB8E-off_BAA0
		dc.w sub_BB9A-off_BAA0
		dc.w loc_BC1C-off_BAA0
		dc.w sub_BC26-off_BAA0
		dc.w loc_BC32-off_BAA0
		dc.w loc_BC98-off_BAA0
		dc.w loc_BCA2-off_BAA0

word_BAB4:	dc.w -$1000, -$A00
; ---------------------------------------------------------------------------

loc_BAB8:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Spring,obMap(a0)
		move.w	#make_art_tile(ArtTile_Spring_Horizontal,0,0),obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#4,obPriority(a0)
		move.b	obSubtype(a0),d0
		btst	#4,d0
		beq.s	loc_BB04
		move.b	#8,obRoutine(a0)
		move.b	#1,obAnim(a0)
		move.b	#3,obFrame(a0)
		move.w	#make_art_tile(ArtTile_Spring_Vertical,0,0),obGfx(a0)
		move.b	#8,obActWid(a0)

loc_BB04:
		btst	#5,d0
		beq.s	loc_BB16
		move.b	#$E,obRoutine(a0)
		bset	#1,obStatus(a0)

loc_BB16:
		btst	#1,d0
		beq.s	loc_BB22
		bset	#5,obGfx(a0)

loc_BB22:
		andi.w	#$F,d0
		move.w	word_BAB4(pc,d0.w),objoff_30(a0)
		rts
; ---------------------------------------------------------------------------

sub_BB2E:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		tst.b	obSolid(a0)
		bne.s	loc_BB4A
		rts
; ---------------------------------------------------------------------------

loc_BB4A:
		addq.b	#2,obRoutine(a0)
		addq.w	#8,obY(a1)
		move.w	objoff_30(a0),obVelY(a1)
		bset	#1,obStatus(a1)
		bclr	#3,obStatus(a1)
		move.b	#$10,obAnim(a1)
		move.b	#2,obRoutine(a1)
		bclr	#3,obStatus(a0)
		clr.b	obSolid(a0)
		move.w	#sfx_Spring,d0
		jsr	(QueueSound2).l

loc_BB84:
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

sub_BB8E:
		move.b	#1,obNextAni(a0)
		subq.b	#4,obRoutine(a0)
		rts
; ---------------------------------------------------------------------------

sub_BB9A:
		move.w	#$13,d1
		move.w	#$E,d2
		move.w	#$F,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		cmpi.b	#2,obRoutine(a0)
		bne.s	loc_BBBC
		move.b	#8,obRoutine(a0)

loc_BBBC:
		btst	#5,obStatus(a0)
		bne.s	loc_BBC6
		rts
; ---------------------------------------------------------------------------

loc_BBC6:
		addq.b	#2,obRoutine(a0)
		move.w	objoff_30(a0),obVelX(a1)
		addq.w	#8,obX(a1)
		btst	#0,obStatus(a0)
		bne.s	loc_BBE6
		subi.w	#$10,obX(a1)
		neg.w	obVelX(a1)

loc_BBE6:
		move.w	#$F,objoff_3E(a1)
		move.w	obVelX(a1),obInertia(a1)
		bchg	#0,obStatus(a1)
		btst	#2,obStatus(a1)
		bne.s	loc_BC06
		move.b	#0,obAnim(a1)

loc_BC06:
		bclr	#5,obStatus(a0)
		bclr	#5,obStatus(a1)
		move.w	#sfx_Spring,d0
		jsr	(QueueSound2).l

loc_BC1C:
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

sub_BC26:
		move.b	#2,obNextAni(a0)
		subq.b	#4,obRoutine(a0)
		rts
; ---------------------------------------------------------------------------

loc_BC32:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		cmpi.b	#2,obRoutine(a0)
		bne.s	loc_BC54
		move.b	#$E,obRoutine(a0)

loc_BC54:
		tst.b	obSolid(a0)
		bne.s	locret_BC5E
		tst.w	d4
		bmi.s	loc_BC60

locret_BC5E:
		rts
; ---------------------------------------------------------------------------

loc_BC60:
		addq.b	#2,obRoutine(a0)
		subq.w	#8,obY(a1)
		move.w	objoff_30(a0),obVelY(a1)
		neg.w	obVelY(a1)
		bset	#1,obStatus(a1)
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a1)
		bclr	#3,obStatus(a0)
		clr.b	obSolid(a0)
		move.w	#sfx_Spring,d0
		jsr	(QueueSound2).l

loc_BC98:
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

loc_BCA2:
		move.b	#1,obNextAni(a0)
		subq.b	#4,obRoutine(a0)
		rts