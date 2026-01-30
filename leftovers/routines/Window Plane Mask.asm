; ---------------------------------------------------------------------------
; Unused, Speculated to have been for a window plane wavy masking effect
; involving writes during H_Int. It writes its tables in the Nemesis GFX
; buffer, only seemingly needing to be called once.
; Discovered by Filter, reconstructed by KatKuriN, Rivet, and ProjectFM
; ---------------------------------------------------------------------------
;sub_3018:
		lea	(v_ngfx_buffer).w,a0
		move.w	(f_water).w,d2
		move.w	#$9100,d3
		move.w	#bytesToWcnt($200),d7

loc_3028:
		move.w	d2,d0
		bsr.w	CalcSine
		asr.w	#4,d0
		bpl.s	loc_3034
		moveq	#0,d0

loc_3034:
		andi.w	#$1F,d0
		move.b	d0,d3
		move.w	d3,(a0)+
		addq.w	#2,d2
		dbf	d7,loc_3028

		addq.w	#2,(f_water).w
		rts