; ---------------------------------------------------------------------------
; Subroutine to make the sides of a monitor solid
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

Mon_SolidSides:
		tst.w	(v_debuguse).w
		bne.w	loc_8400
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_8400
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_8400
		move.b	obHeight(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	obY(a1),d3
		sub.w	obY(a0),d3
		add.w	d2,d3
		bmi.s	loc_8400
		add.w	d2,d2
		cmp.w	d2,d3
		bhs.s	loc_8400
		cmp.w	d0,d1
		bhs.s	loc_83F6
		add.w	d1,d1
		sub.w	d1,d0

loc_83F6:
		cmpi.w	#$10,d3
		blo.s	loc_8404

loc_83FC:
		moveq	#1,d1
		rts
; ===========================================================================

loc_8400:
		moveq	#0,d1
		rts
; ===========================================================================

loc_8404:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	obX(a1),d1
		sub.w	obX(a0),d1
		bmi.s	loc_83FC
		cmp.w	d2,d1
		bhs.s	loc_83FC
		moveq	#-1,d1
		rts
; End of function Mon_SolidSides