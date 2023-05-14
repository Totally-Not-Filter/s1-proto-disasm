; ---------------------------------------------------------------------------

Sonic_SpecialChunk:
		cmpi.b	#id_SLZ,(v_zone).w
		beq.s	loc_F3F4
		tst.b	(v_zone).w
		bne.w	locret_F490

loc_F3F4:
		move.w	$C(a0),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	8(a0),d1
		move.w	d1,d2
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0
		lea	(v_lvllayout).w,a1
		move.b	(a1,d0.w),d1
		cmp.b	(unk_FFF7AE).w,d1
		beq.w	Sonic_CheckRoll
		cmp.b	(unk_FFF7AF).w,d1
		beq.w	Sonic_CheckRoll
		cmp.b	(unk_FFF7AC).w,d1
		beq.s	loc_F448
		cmp.b	(unk_FFF7AD).w,d1
		beq.s	loc_F438
		bclr	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F438:
		btst	#1,$22(a0)
		beq.s	loc_F448
		bclr	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F448:
		cmpi.b	#$2C,d2
		bcc.s	loc_F456
		bclr	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F456:
		cmpi.b	#$E0,d2
		bcs.s	loc_F464
		bset	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F464:
		btst	#6,1(a0)
		bne.s	loc_F480
		move.b	$26(a0),d1
		beq.s	locret_F490
		cmpi.b	#$80,d1
		bhi.s	locret_F490
		bset	#6,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_F480:
		move.b	$26(a0),d1
		cmpi.b	#$80,d1
		bls.s	locret_F490
		bclr	#6,1(a0)

locret_F490:
		rts