; ---------------------------------------------------------------------------
; Palette cycling routine loading subroutine
; ---------------------------------------------------------------------------

PaletteCycle:
		moveq	#0,d2
		moveq	#0,d0
		move.b	(v_zone).w,d0	; get level number
		add.w	d0,d0
		move.w	PalCycle_Index(pc,d0.w),d0
		jmp	PalCycle_Index(pc,d0.w) ; jump to relevant palette routine
; End of function PaletteCycle

; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routines
; ---------------------------------------------------------------------------
PalCycle_Index:	dc.w PalCycle_GHZ-PalCycle_Index
		dc.w PalCycle_LZ-PalCycle_Index
		dc.w PalCycle_MZ-PalCycle_Index
		dc.w PalCycle_SLZ-PalCycle_Index
		dc.w PalCycle_SZ-PalCycle_Index
		dc.w PalCycle_CWZ-PalCycle_Index
		dc.w PalCycle_06-PalCycle_Index

; ===========================================================================

PalCycle_Title:
		lea	(Pal_TitleCyc).l,a0
		bra.s	PCycGHZ_Go
; ===========================================================================

PalCycle_GHZ:
		lea	(Pal_GHZCyc).l,a0

PCycGHZ_Go:
		subq.w	#1,(v_pcyc_time).w ; decrement timer
		bpl.s	PCycGHZ_Skip	; if time remains, branch

		move.w	#5,(v_pcyc_time).w ; reset timer to 5 frames
		move.w	(v_pcyc_num).w,d0 ; get cycle number
		addq.w	#1,(v_pcyc_num).w ; increment cycle number
		andi.w	#3,d0		; if cycle > 3, reset to 0
		lsl.w	#3,d0
		lea	(v_palette_line_3+$10).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)	; copy palette data to RAM

PCycGHZ_Skip:
		rts
; End of function PalCycle_GHZ

; ===========================================================================

PalCycle_LZ:
		rts
; ===========================================================================

		subq.w	#1,(v_pcyc_time).w ; decrement timer
		bpl.s	PCycLZ_Skip	; if time remains, branch

		move.w	#5,(v_pcyc_time).w ; reset timer to 5 frames
		move.w	(v_pcyc_num).w,d0 ; get cycle number
		addq.w	#1,(v_pcyc_num).w ; increment cycle number
		andi.w	#3,d0		; if cycle > 3, reset to 0
		lsl.w	#3,d0
		lea	(Pal_LZCyc).l,a0
		adda.w	d0,a0
		lea	(v_palette_line_4+$E).w,a1
		move.w	(a0)+,(a1)+
		addq.w	#8,a1
		move.w	(a0)+,(a1)+
		move.l	(a0)+,(a1)+

PCycLZ_Skip:
		rts
; End of function PalCycle_LZ

; ===========================================================================

PalCycle_MZ:
		rts
; End of function PalCycle_MZ

; ===========================================================================

PalCycle_SLZ:
		subq.w	#1,(v_pcyc_time).w
		bpl.s	locret_17F6
		move.w	#15,(v_pcyc_time).w
		move.w	(v_pcyc_num).w,d0
		addq.w	#1,d0
		cmpi.w	#6,d0
		blo.s	loc_17D6
		moveq	#0,d0

loc_17D6:
		move.w	d0,(v_pcyc_num).w
		move.w	d0,d1
		add.w	d1,d1
		add.w	d1,d0
		add.w	d0,d0
		lea	(Pal_SLZCyc).l,a0
		lea	(v_palette_line_3+$16).w,a1
		move.w	(a0,d0.w),(a1)
		move.l	2(a0,d0.w),4(a1)

locret_17F6:
		rts
; End of function PalCycle_SLZ

; ===========================================================================

PalCycle_SZ:
		subq.w	#1,(v_pcyc_time).w
		bpl.s	locret_1846
		move.w	#5,(v_pcyc_time).w
		move.w	(v_pcyc_num).w,d0
		move.w	d0,d1
		addq.w	#1,(v_pcyc_num).w
		andi.w	#3,d0
		lsl.w	#3,d0
		lea	(Pal_SZ1Cyc).l,a0
		lea	(v_palette_line_4+$E).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)
		andi.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		add.w	d1,d1
		lea	(Pal_SZ2Cyc).l,a0
		lea	(v_palette_line_4+$16).w,a1
		move.l	(a0,d1.w),(a1)
		move.w	4(a0,d1.w),6(a1)

locret_1846:
		rts
; End of function PalCycle_SZ

; ===========================================================================

PalCycle_CWZ:
		rts
; End of function PalCycle_CWZ

; ===========================================================================

PalCycle_06:
		rts
; End of function PalCycle_06