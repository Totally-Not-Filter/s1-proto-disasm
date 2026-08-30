; ---------------------------------------------------------------------------
; Unused Special Stage layout loading routine
;
; The format of this routine has a much larger limit compared to what's used
; in-game. The special stage size is also much larger, coming in at 4096
; bytes comparatively to the one in-game that is 510 bytes.
;
; Width: 64 bytes per row
; Height: 64 bytes
; Format: 64x64
; Size of Special Stage: 4096 bytes (4KB)
; ---------------------------------------------------------------------------

SS_1_size_prev:	equ ss_layout_rowlength_prev*ss_layout_rows_prev

SS_Load_Prev:
		lea	(v_sslayout_prev).l,a1
		lea	(SS_1).l,a0
		moveq	#(SS_1_size_prev)/ss_layout_rowlength_prev-1,d1

loc_10CA6:
		moveq	#(ss_layout_rows_prev)/4-1,d2

loc_10CA8:
		move.l	(a0)+,(a1)+
		dbf	d2,loc_10CA8
		lea	ss_layout_rows_prev(a1),a1
		dbf	d1,loc_10CA6
		rts