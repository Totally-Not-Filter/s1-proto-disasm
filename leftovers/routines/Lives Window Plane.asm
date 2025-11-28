;sub_485C:
		moveq	#0,d0
		move.b	(v_lives).w,d1
		cmpi.b	#2,d1
		blo.s	loc_4876
		move.b	d1,d0
		subq.b	#1,d0
		cmpi.b	#5,d0
		blo.s	loc_4876
		move.b	#4,d0

loc_4876:
		lea	(vdp_data_port).l,a6
		locVRAM window_plane+$CBE
		move.l	#($8500+(window_plane_lives1>>9))<<16|$8500+(window_plane_lives2>>9),d2
		bsr.s	sub_489E
		locVRAM window_plane+$D3E
		move.l	#($8500+(window_plane_lives3>>9))<<16|$8500+(window_plane_lives4>>9),d2

sub_489E:
		moveq	#0,d3
		moveq	#4-1,d1
		sub.w	d0,d1
		blo.s	loc_48AC

loc_48A6:
		move.l	d3,(a6)
		dbf	d1,loc_48A6

loc_48AC:
		move.w	d0,d1
		subq.w	#1,d1
		blo.s	locret_48B8

loc_48B2:
		move.l	d2,(a6)
		dbf	d1,loc_48B2

locret_48B8:
		rts