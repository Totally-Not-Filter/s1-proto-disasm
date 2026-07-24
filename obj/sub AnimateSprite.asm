; ===========================================================================

AnimateSprite:
		moveq	#0,d0
		move.b	obAnim(a0),d0
		cmp.b	obNextAni(a0),d0
		beq.s	loc_6B54
		move.b	d0,obNextAni(a0)
		move.b	#0,obAniFrame(a0)
		move.b	#0,obTimeFrame(a0)

loc_6B54:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		subq.b	#1,obTimeFrame(a0)
		bpl.s	locret_6B94
		move.b	(a1),obTimeFrame(a0)
		moveq	#0,d1
		move.b	obAniFrame(a0),d1
		move.b	1(a1,d1.w),d0
		bmi.s	loc_6B96

loc_6B70:
		move.b	d0,d1
		andi.b	#$1F,d0
		move.b	d0,obFrame(a0)
		move.b	obStatus(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,obRender(a0)
		lsr.b	#5,d1
		eor.b	d0,d1
		or.b	d1,obRender(a0)
		addq.b	#1,obAniFrame(a0)

locret_6B94:
		rts
; ===========================================================================

loc_6B96:
		addq.b	#1,d0
		bne.s	loc_6BA6
		move.b	#0,obAniFrame(a0)
		move.b	obRender(a1),d0
		bra.s	loc_6B70
; ===========================================================================

loc_6BA6:
		addq.b	#1,d0
		bne.s	loc_6BBA
		move.b	2(a1,d1.w),d0
		sub.b	d0,obAniFrame(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	loc_6B70
; ===========================================================================

loc_6BBA:
		addq.b	#1,d0
		bne.s	loc_6BC4
		move.b	2(a1,d1.w),obAnim(a0)

loc_6BC4:
		addq.b	#1,d0
		bne.s	loc_6BCC
		addq.b	#2,obRoutine(a0)

loc_6BCC:
		addq.b	#1,d0
		bne.s	locret_6BDA
		move.b	#0,obAniFrame(a0)
		clr.b	ob2ndRout(a0)

locret_6BDA:
		rts