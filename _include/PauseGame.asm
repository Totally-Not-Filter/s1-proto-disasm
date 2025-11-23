; ---------------------------------------------------------------------------

PauseGame:
		nop
		tst.b	(v_lives).w
		beq.s	loc_1206
		tst.w	(f_pause).w
		bne.s	loc_11CC
		btst	#bitStart,(v_jpadpress1).w
		beq.s	locret_120C

loc_11CC:
		move.w	#-1,(f_pause).w

loc_11D2:
		move.b	#id_VInt_10,(v_vint_routine).w
		bsr.w	WaitForVInt
		btst	#bitA,(v_jpadpress1).w
		beq.s	loc_11EE
		move.b	#id_Title,(v_gamemode).w
		nop
		bra.s	loc_1206
; ---------------------------------------------------------------------------

loc_11EE:
		btst	#bitB,(v_jpadhold1).w
		bne.s	loc_120E
		btst	#bitC,(v_jpadpress1).w
		bne.s	loc_120E
		btst	#bitStart,(v_jpadpress1).w
		beq.s	loc_11D2

loc_1206:
		move.w	#0,(f_pause).w

locret_120C:
		rts
; ---------------------------------------------------------------------------

loc_120E:
		move.w	#1,(f_pause).w
		rts