; ---------------------------------------------------------------------------
; Subroutine calculate an angle

; input:
;	d1 = x-axis distance
;	d2 = y-axis distance

; output:
;	d0 = angle
; ---------------------------------------------------------------------------

CalcAngle:
		movem.l	d3-d4,-(sp)
		moveq	#0,d3
		moveq	#0,d4
		move.w	d1,d3
		move.w	d2,d4
		or.w	d3,d4
		beq.s	loc_2378
		move.w	d2,d4
		tst.w	d3
		bpl.w	loc_2336
		neg.w	d3

loc_2336:
		tst.w	d4
		bpl.w	loc_233E
		neg.w	d4

loc_233E:
		cmp.w	d3,d4
		bhs.w	loc_2350
		lsl.l	#8,d4
		divu.w	d3,d4
		moveq	#0,d0
		move.b	Angle_Data(pc,d4.w),d0
		bra.s	loc_235A
; ===========================================================================

loc_2350:
		lsl.l	#8,d3
		divu.w	d4,d3
		moveq	#$40,d0
		sub.b	Angle_Data(pc,d3.w),d0

loc_235A:
		tst.w	d1
		bpl.w	loc_2366
		neg.w	d0
		addi.w	#$80,d0

loc_2366:
		tst.w	d2
		bpl.w	loc_2372
		neg.w	d0
		addi.w	#$100,d0

loc_2372:
		movem.l	(sp)+,d3-d4
		rts
; ===========================================================================

loc_2378:
		move.w	#$40,d0
		movem.l	(sp)+,d3-d4
		rts
; End of function CalcAngle

; ===========================================================================

Angle_Data:	binclude	"misc/angles.bin"

; ===========================================================================