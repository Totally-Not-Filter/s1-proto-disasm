; ---------------------------------------------------------------------------
; Subroutine to load basic level data
; ---------------------------------------------------------------------------

LevelDataLoad:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		addq.l	#4,a2
		movea.l	(a2)+,a0
		lea	(v_16x16).w,a4
		move.w	#(v_16x16_end-v_16x16)/4-1,d0

.loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,.loadblocks
		movea.l	(a2)+,a0
		lea	(v_256x256).l,a1
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad
		move.w	(a2)+,d0
		move.w	(a2),d0
		andi.w	#$FF,d0
		bsr.w	PalLoad1
		movea.l	(sp)+,a2
		addq.w	#4,a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	.skipPLC
		bsr.w	AddPLC

.skipPLC:
		rts
; End of function LevelDataLoad

		include	"leftovers/routines/Lives Window Plane.asm"

; ---------------------------------------------------------------------------
; Level layout loading subroutine
; ---------------------------------------------------------------------------

LevelLayoutLoad:
		lea	(v_lvllayout).w,a3
	if FixBugs
		move.w	#(v_lvllayout_end-v_lvllayout)/4-1,d1
	else
		; v_lvllayout is only $400 bytes, but this clears $800...
		; In Sonic 2, this function was corrected to only clear the
		; layout buffer.
		move.w	#(v_lvllayout_end-v_lvllayout)/2-1,d1
	endif
		moveq	#0,d0

.clear:
		move.l	d0,(a3)+
		dbf	d1,.clear ; clear the RAM ($A400-A7FF)

		lea	(v_lvllayout_fg).w,a3 ; RAM address for level layout
		moveq	#0,d1
		bsr.w	LevelLayoutLoad2 ; load level layout into RAM
		lea	(v_lvllayout_bg).w,a3 ; RAM address for background layout
		moveq	#2,d1
; End of function LevelLayoutLoad

; "LevelLayoutLoad2" is run twice - for the level and the background

LevelLayoutLoad2:
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0
		add.w	d1,d0
		lea	(Level_Index).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1	; load level width (in tiles)
		move.b	(a1)+,d2	; load level height (in tiles)

LevLoad_NumRows:
		move.w	d1,d0
		movea.l	a3,a0

LevLoad_Row:
		move.b	(a1)+,(a0)+
		dbf	d0,LevLoad_Row	; load 1 row
		lea	layout_row(a3),a3	; do next row
		dbf	d2,LevLoad_NumRows
		rts
; End of function LevelLayoutLoad2