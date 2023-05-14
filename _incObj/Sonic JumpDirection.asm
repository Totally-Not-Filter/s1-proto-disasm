; ---------------------------------------------------------------------------

Sonic_ChgJumpDirection:
		move.w	(unk_FFF760).w,d6
		move.w	(unk_FFF762).w,d5
		asl.w	#1,d5
		btst	#4,$22(a0)
		bne.s	Sonic_ResetScroll2
		move.w	$10(a0),d0
		btst	#2,(v_jpadhold1).w
		beq.s	loc_ED6E
		bset	#0,$22(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_ED6E
		move.w	d1,d0

loc_ED6E:
		btst	#3,(v_jpadhold1).w
		beq.s	Sonic_JumpMove
		bclr	#0,$22(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	Sonic_JumpMove
		move.w	d6,d0

Sonic_JumpMove:
		move.w	d0,$10(a0)

Sonic_ResetScroll2:
		cmpi.w	#$60,(unk_FFF73E).w
		beq.s	loc_ED9A
		bcc.s	loc_ED96
		addq.w	#4,(unk_FFF73E).w

loc_ED96:
		subq.w	#2,(unk_FFF73E).w

loc_ED9A:
		cmpi.w	#$FC00,$12(a0)
		bcs.s	locret_EDC8
		move.w	$10(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	locret_EDC8
		bmi.s	loc_EDBC
		sub.w	d1,d0
		bcc.s	loc_EDB6
		move.w	#0,d0

loc_EDB6:
		move.w	d0,$10(a0)
		rts
; ---------------------------------------------------------------------------

loc_EDBC:
		sub.w	d1,d0
		bcs.s	loc_EDC4
		move.w	#0,d0

loc_EDC4:
		move.w	d0,$10(a0)

locret_EDC8:
		rts