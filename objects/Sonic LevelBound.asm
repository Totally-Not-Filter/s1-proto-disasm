; ---------------------------------------------------------------------------

Sonic_LevelBound:
		move.l	obX(a0),d1
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(v_limitleft2).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0
		bhi.s	Sonic_BoundSides
		move.w	(v_limitright2).w,d0
		addi.w	#$128,d0
		cmp.w	d1,d0
		bls.s	Sonic_BoundSides
		move.w	(v_limitbtm2).w,d0
		addi.w	#224,d0
		cmp.w	obY(a0),d0
		bcs.w	loc_FD78
		rts
; ---------------------------------------------------------------------------

Sonic_BoundSides:
		move.w	d0,obX(a0)
		move.w	#0,obX+2(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,obInertia(a0)
		rts