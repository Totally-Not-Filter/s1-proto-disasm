; ---------------------------------------------------------------------------

ObjSeeSaw:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_E6B0(pc,d0.w),d1
		jsr	off_E6B0(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_E6B0:	dc.w loc_E6B6-off_E6B0, loc_E6DA-off_E6B0, loc_E706-off_E6B0
; ---------------------------------------------------------------------------

loc_E6B6:
		addq.b	#2,$24(a0)
		move.l	#MapSeesaw,4(a0)
		move.w	#$374,obGfx(a0)
		ori.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$30,$18(a0)

loc_E6DA:
		lea	(ObjSeeSaw_SlopeTilt).l,a2
		btst	#0,$1A(a0)
		beq.s	loc_E6EE
		lea	(ObjSeeSaw_SlopeLine).l,a2

loc_E6EE:
		lea	(v_objspace).w,a1
		move.w	#$30,d1
		jsr	(PtfmSloped).l
		btst	#3,(a0)
		beq.s	locret_E704
		nop

locret_E704:
		rts
; ---------------------------------------------------------------------------

loc_E706:
		bsr.w	sub_E738
		lea	(ObjSeeSaw_SlopeTilt).l,a2
		btst	#0,$1A(a0)
		beq.s	loc_E71E
		lea	(ObjSeeSaw_SlopeLine).l,a2

loc_E71E:
		move.w	#$30,d1
		jsr	(PtfmCheckExit).l
		move.w	#$30,d1
		move.w	8(a0),d2
		jsr	(sub_61E0).l
		rts
; ---------------------------------------------------------------------------

sub_E738:
		moveq	#2,d1
		lea	(v_objspace).w,a1
		move.w	8(a0),d0
		sub.w	8(a1),d0
		bcc.s	loc_E74C
		neg.w	d0
		moveq	#0,d1

loc_E74C:
		cmpi.w	#8,d0
		bcc.s	loc_E754
		moveq	#1,d1

loc_E754:
		move.b	d1,$1A(a0)
		bclr	#0,1(a0)
		btst	#1,$1A(a0)
		beq.s	locret_E76C
		bset	#0,1(a0)

locret_E76C:
		rts
