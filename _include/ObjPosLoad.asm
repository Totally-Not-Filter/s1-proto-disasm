; ---------------------------------------------------------------------------
; Subroutine to load a level's objects
; ---------------------------------------------------------------------------

ObjPosLoad:
		moveq	#0,d0
		move.b	(v_opl_routine).w,d0
		move.w	OPL_Index(pc,d0.w),d0
		jmp	OPL_Index(pc,d0.w)
; End of function ObjPosLoad

; ===========================================================================
OPL_Index:	dc.w OPL_Main-OPL_Index
		dc.w OPL_Next-OPL_Index
; ===========================================================================

OPL_Main:
		addq.b	#2,(v_opl_routine).w
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1
		adda.w	(a0,d0.w),a0
		move.l	a0,(v_opl_data).w
		move.l	a0,(v_opl_data+4).w
		adda.w	2(a1,d0.w),a1
		move.l	a1,(v_opl_data+8).w
		move.l	a1,(v_opl_data+$C).w
		lea	(v_objstate).w,a2
		move.w	#$101,(a2)+
	if FixBugs
		move.w	#bytesToLcnt(v_objstate_end-v_objstate-2),d0
	else
		; This clears longwords, but the loop counter is measured in words!
		; This causes $17C bytes to be cleared instead of $BE.
		move.w	#bytesToWcnt(v_objstate_end-v_objstate-2),d0
	endif

loc_8A38:
		clr.l	(a2)+
		dbf	d0,loc_8A38
	if FixBugs
		; Clear the last word, since the above loop only does longwords.
	if (v_objstate_end-v_objstate-2)&2
		clr.w	(a2)+
	endif
	endif
		move.w	#-1,(v_opl_screen).w

OPL_Next:
		lea	(v_objstate).w,a2
		moveq	#0,d2
		move.w	(v_scrposx).w,d6
		andi.w	#-$80,d6
		cmp.w	(v_opl_screen).w,d6
		beq.w	locret_8B20
		bge.s	loc_8ABA
		move.w	d6,(v_opl_screen).w
		movea.l	(v_opl_data+4).w,a0
		subi.w	#$80,d6
		blo.s	loc_8A96

loc_8A6A:
		cmp.w	-6(a0),d6
		bge.s	loc_8A96
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.s	loc_8A80
		subq.b	#1,1(a2)
		move.b	1(a2),d2

loc_8A80:
		bsr.w	sub_8B22
		bne.s	loc_8A8A
		subq.w	#6,a0
		bra.s	loc_8A6A
; ===========================================================================

loc_8A8A:
		tst.b	4(a0)
		bpl.s	loc_8A94
		addq.b	#1,1(a2)

loc_8A94:
		addq.w	#6,a0

loc_8A96:
		move.l	a0,(v_opl_data+4).w
		movea.l	(v_opl_data).w,a0
		addi.w	#$300,d6

loc_8AA2:
		cmp.w	-6(a0),d6
		bgt.s	loc_8AB4
		tst.b	-2(a0)
		bpl.s	loc_8AB0
		subq.b	#1,(a2)

loc_8AB0:
		subq.w	#6,a0
		bra.s	loc_8AA2
; ===========================================================================

loc_8AB4:
		move.l	a0,(v_opl_data).w
		rts
; ===========================================================================

loc_8ABA:
		move.w	d6,(v_opl_screen).w
		movea.l	(v_opl_data).w,a0
		addi.w	#$280,d6

loc_8AC6:
		cmp.w	(a0),d6
		bls.s	loc_8ADA
		tst.b	4(a0)
		bpl.s	loc_8AD4
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_8AD4:
		bsr.w	sub_8B22
		beq.s	loc_8AC6

loc_8ADA:
		move.l	a0,(v_opl_data).w
		movea.l	(v_opl_data+4).w,a0
		subi.w	#$300,d6
		blo.s	loc_8AFA

loc_8AE8:
		cmp.w	(a0),d6
		bls.s	loc_8AFA
		tst.b	4(a0)
		bpl.s	loc_8AF6
		addq.b	#1,1(a2)

loc_8AF6:
		addq.w	#6,a0
		bra.s	loc_8AE8
; ===========================================================================

loc_8AFA:
		move.l	a0,(v_opl_data+4).w
		rts
; ---------------------------------------------------------------------------
; Unused routine to load secondary index of object layout
; ---------------------------------------------------------------------------

loc_8B00:
		movea.l	(v_opl_data+8).w,a0
		move.w	(v_bg3scrposx).w,d0
		addi.w	#$200,d0
		andi.w	#-$80,d0
		cmp.w	(a0),d0
		blo.s	locret_8B20
		bsr.w	sub_8B22
		move.l	a0,(v_opl_data+8).w
		bra.w	loc_8B00

locret_8B20:
		rts
; ===========================================================================

sub_8B22:
		tst.b	4(a0)
		bpl.s	loc_8B36
		bset	#7,2(a2,d2.w)
		beq.s	loc_8B36
		addq.w	#6,a0
		moveq	#0,d0
		rts
; ===========================================================================

loc_8B36:
		bsr.w	FindFreeObj
		bne.s	locret_8B70
		move.w	(a0)+,obX(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		move.w	d0,obY(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,obRender(a1)
		move.b	d1,obStatus(a1)
		move.b	(a0)+,d0
		bpl.s	loc_8B66
		andi.b	#$7F,d0
		move.b	d2,obRespawnNo(a1)

loc_8B66:
		_move.b	d0,obID(a1)
		move.b	(a0)+,obSubtype(a1)
		moveq	#0,d0

locret_8B70:
		rts