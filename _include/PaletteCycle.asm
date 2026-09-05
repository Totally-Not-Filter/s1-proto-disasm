; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine execution subroutine
; ---------------------------------------------------------------------------

PaletteCycle:
	if FixBugs
		; Fix palettes getting corrupted during level transitions between different zones
		tst.w	(f_restart).w				; is level set to restart?
		beq.s	.doCycle				; if not, branch
		rts						; don't execute palette cycle
	endif

	.doCycle:
		moveq	#0,d2					; clear d2 (redundant, not used here)
		moveq	#0,d0
		move.b	(v_zone).w,d0				; get zone ID
		add.w	d0,d0					; double for word-based indexing
		move.w	PalCycle_Index(pc,d0.w),d0		; find palette routine for current zone
		jmp	PalCycle_Index(pc,d0.w)			; jump to relevant palette routine
; End of function PaletteCycle

; ---------------------------------------------------------------------------
; Palette cycling routines per Zone
; ---------------------------------------------------------------------------

PalCycle_Index:
		dc.w	PalCycle_GHZ-PalCycle_Index		; Green Hill Zone
		dc.w	PalCycle_LZ-PalCycle_Index		; Labyrinth Zone (empty)
		dc.w	PalCycle_MZ-PalCycle_Index		; Marble Zone (empty)
		dc.w	PalCycle_SLZ-PalCycle_Index		; Star Light Zone
		dc.w	PalCycle_SZ-PalCycle_Index		; Sparkling Zone
		dc.w	PalCycle_CWZ-PalCycle_Index		; Clock Work Zone (empty)
		dc.w	PalCycle_06-PalCycle_Index		; Zone 6 (empty)


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Green Hill Zone & Title Screen
; ---------------------------------------------------------------------------

PalCycle_Title:
		lea	(Pal_TitleCyc_Water).l,a0		; use special palette cycle for the title screen
		bra.s	PCycGHZ_Go
; ===========================================================================

PalCycle_GHZ:
		lea	(Pal_GHZCyc_Water).l,a0			; use regular GHZ palette cycle data

	PCycGHZ_Go:
		; Waterfalls and background water reflections
		subq.w	#1,(v_pcyc_time).w			; decrement timer
		bpl.s	.return					; if time remains, branch

		move.w	#6-1,(v_pcyc_time).w			; reset timer
		move.w	(v_pcyc_num).w,d0			; get cycle number
		addq.w	#1,(v_pcyc_num).w			; increment cycle number
		andi.w	#3,d0					; if cycle > 3, reset to 0
		lsl.w	#3,d0					; data is arranged in blocks of 8 bytes each

		lea	(v_palette_line_3+(8*2)).w,a1		; target palette line 3, colors 8-B
		move.l	(a0,d0.w),(a1)+				; write 2 colors
		move.l	4(a0,d0.w),(a1)				; write 2 colors

	.return:
		rts
; End of function PalCycle_GHZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Labyrinth Zone
; ---------------------------------------------------------------------------

PalCycle_LZ:
		rts

		; Waterfalls
		subq.w	#1,(v_pcyc_time).w			; decrement timer
		bpl.s	.return					; if time remains, branch

		move.w	#6-1,(v_pcyc_time).w			; reset timer
		move.w	(v_pcyc_num).w,d0			; get cycle number
		addq.w	#1,(v_pcyc_num).w			; increment cycle number
		andi.w	#3,d0					; if cycle > 3, reset to 0
		lsl.w	#3,d0					; multiply by 8

		lea	(Pal_LZCyc_Waterfall).l,a0		; load LZ palette cycle data
		adda.w	d0,a0
		lea	(v_palette_line_4+(7*2)).w,a1		; target palette line 4, colors 7, B-D
		move.w	(a0)+,(a1)+				; write 1 color
		addq.w	#4*2,a1					; skip 4 colors
		move.w	(a0)+,(a1)+				; write 1 color
		move.l	(a0)+,(a1)+				; write 2 colors

	.return:
		rts
; End of function PalCycle_LZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Marble Zone
; ---------------------------------------------------------------------------

PalCycle_MZ:
		rts
; End of function PalCycle_MZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Star Light Zone
; ---------------------------------------------------------------------------

PalCycle_SLZ:
		; Lanterns, red lights, cyan lights
		subq.w	#1,(v_pcyc_time).w			; decrement timer
		bpl.s	.return

		move.w	#16-1,(v_pcyc_time).w			; reset timer
		move.w	(v_pcyc_num).w,d0			; get lights palette offset
		addq.w	#1,d0					; increment cycle number
		cmpi.w	#6,d0					; has cycle reached 6?
		blo.s	.writeCycle				; if not, branch
		moveq	#0,d0					; if cycle > 5, reset to 0
	.writeCycle:
		move.w	d0,(v_pcyc_num).w			; write new lights palette offset

		move.w	d0,d1					; copy offset
		add.w	d1,d1					; double copy
		add.w	d1,d0					; add copy to original
		add.w	d0,d0					; d0 = multiplied by 3

		lea	(Pal_SLZCyc_Lights).l,a0		; cyan, red, yellow lights
		lea	(v_palette_line_3+($B*2)).w,a1		; target palette line 3, colors B-D
		move.w	(a0,d0.w),(a1)				; write 1 color
		move.l	2(a0,d0.w),4(a1)			; write 2 colors

	.return:
		rts
; End of function PalCycle_SLZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Sparkling Zone
; ---------------------------------------------------------------------------

PalCycle_SZ:
		; Flashy scenery lights
		subq.w	#1,(v_pcyc_time).w			; decrement timer
		bpl.s	.return					; if time remains, branch

		move.w	#6-1,(v_pcyc_time).w			; reset timer
		move.w	(v_pcyc_num).w,d0			; get cycle number
		move.w	d0,d1					; cycle number = d1
		addq.w	#1,(v_pcyc_num).w			; increment cycle number
		andi.w	#3,d0					; if cycle > 3, reset to 0
		lsl.w	#3,d0					; multiply by 8

		lea	(Pal_SZCyc_BlackYellow).l,a0		; rotating black/yellow
		lea	(v_palette_line_4+(7*2)).w,a1		; target palette line 4, colors 7-A
		move.l	(a0,d0.w),(a1)+				; write 2 colors
		move.l	4(a0,d0.w),(a1)				; write 2 colors

		andi.w	#3,d1					; if cycle > 3, reset to 0
		move.w	d1,d0					; copy offset
		add.w	d1,d1					; double original
		add.w	d0,d1					; add copy to original
		add.w	d1,d1					; d1 = multiplied by 6

		lea	(Pal_SZCyc_RedWhite).l,a0		; pulsating red/white
		lea	(v_palette_line_4+($B*2)).w,a1		; target palette line 4, colors B-C
		move.l	(a0,d1.w),(a1)				; write 2 colors
		move.w	4(a0,d1.w),6(a1)			; write 1 color

	.return:
		rts
; End of function PalCycle_SZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Clock Work Zone
; ---------------------------------------------------------------------------

PalCycle_CWZ:
		rts
; End of function PalCycle_CWZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycling routine - Zone 6
; ---------------------------------------------------------------------------

PalCycle_06:
		rts
; End of function PalCycle_06


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette cycle data bincludes
; ---------------------------------------------------------------------------

Pal_TitleCyc_Water:	binclude	"palette/Cycle - Title Screen Water.bin"
Pal_GHZCyc_Water:	binclude	"palette/Cycle - GHZ.bin"
Pal_LZCyc_Waterfall:	binclude	"palette/Cycle - LZ Waterfall (Unused).bin"
Pal_MZCyc_Unused:	binclude	"palette/Cycle - MZ (Unused).bin"
Pal_SLZCyc_Lights:	binclude	"palette/Cycle - SLZ.bin"
Pal_SZCyc_BlackYellow:	binclude	"palette/Cycle - SZ1.bin"
Pal_SZCyc_RedWhite:	binclude	"palette/Cycle - SZ2.bin"