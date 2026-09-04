; ===========================================================================
; ---------------------------------------------------------------------------
; Unused Early Lives Counter routine
; ---------------------------------------------------------------------------

; sub_485C:
Lives_Window_Plane:
		moveq	#0,d0
		move.b	(v_lives).w,d1				; move lives counter to d1
		cmpi.b	#2,d1					; do you have less than 2 lives?
		blo.s	.lower					; if so, branch
		move.b	d1,d0					; move lives to d0
		subq.b	#1,d0					; subtract 1 from lives
		cmpi.b	#5,d0					; do you have less than 5 lives?
		blo.s	.lower					; if so, branch
		move.b	#4,d0					; force lives to be a maximum of 4

	.lower:
		lea	(vdp_data_port).l,a6			; load VDP data port into a6
		locVRAM vram_win+$CBE
		move.l	#(ArtTile_Early_Lives_Icon|Tile_Prio)<<16|ArtTile_Early_Lives_Icon+1|Tile_Prio,d2
		bsr.s	.draw_plane
		locVRAM vram_win+$D3E
		move.l	#(ArtTile_Early_Lives_Icon+2|Tile_Prio)<<16|ArtTile_Early_Lives_Icon+3|Tile_Prio,d2

	.draw_plane:
		moveq	#0,d3
		moveq	#4-1,d1
		sub.w	d0,d1
		blo.s	.draw_next

	.draw_loop:
		move.l	d3,(a6)					; write plane data to VDP data port
		dbf	d1,.draw_loop

	.draw_next:
		move.w	d0,d1
		subq.w	#1,d1
		blo.s	.return

	.draw_lives:
		move.l	d2,(a6)					; write plane data to VDP data port
		dbf	d1,.draw_lives

	.return:
		rts