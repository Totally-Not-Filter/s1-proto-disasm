; ---------------------------------------------------------------------------
; Unused Early Lives Counter routine
; ---------------------------------------------------------------------------

;sub_485C:
Lives_Window_Plane:
		moveq	#0,d0
		move.b	(v_lives).w,d1
		cmpi.b	#2,d1	; do you have less than 2 lives?
		blo.s	.lower	; if so, branch
		move.b	d1,d0	; move lives to d0
		subq.b	#1,d0	; subtract 1 from lives
		cmpi.b	#5,d0	; do you have less than 5 lives?
		blo.s	.lower	; if so, branch
		move.b	#4,d0	; force lives to be set to 4

.lower:
		lea	(vdp_data_port).l,a6
		locVRAM window_plane+$CBE
		move.l	#make_art_tile(ArtTile_Early_Lives_Icon,0,1)<<16|make_art_tile(ArtTile_Early_Lives_Icon+1,0,1),d2
		bsr.s	.drawplane
		locVRAM window_plane+$D3E
		move.l	#make_art_tile(ArtTile_Early_Lives_Icon+2,0,1)<<16|make_art_tile(ArtTile_Early_Lives_Icon+3,0,1),d2

.drawplane:
		moveq	#0,d3
		moveq	#4-1,d1
		sub.w	d0,d1
		blo.s	.drawnext

.drawloop:
		move.l	d3,(a6)
		dbf	d1,.drawloop

.drawnext:
		move.w	d0,d1
		subq.w	#1,d1
		blo.s	.return

.drawlives:
		move.l	d2,(a6)
		dbf	d1,.drawlives

.return:
		rts