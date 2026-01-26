; ---------------------------------------------------------------------------
; Subroutine to load level boundaries and start locations
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

LevelSizeLoad:
		moveq	#0,d0
		move.b	d0,(f_rst_hscroll).w
		move.b	d0,(f_rst_vscroll).w
		move.b	d0,(unk_FFF746).w
		move.b	d0,(unk_FFF748).w
		move.b	d0,(v_dle_routine).w
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	LevelBoundArray(pc,d0.w),a0 ; load level boundaries
		move.w	(a0)+,d0
		move.w	d0,(unk_FFF730).w
		move.l	(a0)+,d0
		move.l	d0,(v_limitleft2).w
		move.l	d0,(v_limitleft1).w
		cmp.w	(v_limitleft2).w,d0	; has left boundary been reached?
		bne.s	.notleft	; if not, branch
		move.b	#1,(f_rst_hscroll).w

.notleft:
		move.l	(a0)+,d0
		move.l	d0,(v_limittop2).w
		move.l	d0,(v_limittop1).w
		cmp.w	(v_limittop2).w,d0	; has top boundary been reached?
		bne.s	.nottop	; if not, branch
		move.b	#1,(f_rst_vscroll).w

.nottop:
		move.w	(v_limitleft2).w,d0
		addi.w	#$240,d0
		move.w	d0,(v_limitleft3).w
		move.w	(a0)+,d0
		move.w	d0,(v_lookshift).w
		bra.w	LevSz_StartLoc
; ===========================================================================
; ---------------------------------------------------------------------------
; Level size array
; ---------------------------------------------------------------------------
LevelBoundArray:
		;    |----------------------------------------Unused
		;    |      |---------------------------------Left boundary
		;    |      |      |--------------------------Right boundary
		;    |      |      |      |-------------------Top boundary
		;    |      |      |      |      |------------Bottom boundary
		; GHZ|      |      |      |      |      |-----Vertical screen shift (redundant)
		dc.w $0004, $0000, $24BF, $0000, $0300, $0060
		dc.w $0004, $0000, $1EBF, $0000, $0300, $0060
		dc.w $0004, $0000, $2960, $0000, $0300, $0060
		dc.w $0004, $0000, $2ABF, $0000, $0300, $0060
		; LZ
		dc.w $0004, $0000, $17BF, $0000, $0720, $0060
		dc.w $0004, $0000, $0EBF, $0000, $0720, $0060
		dc.w $0004, $0000, $1EBF, $0000, $0720, $0060
		dc.w $0004, $0000, $1EBF, $0000, $0720, $0060
		; MZ
		dc.w $0004, $0000, $17BF, $0000, $01D0, $0060
		dc.w $0004, $0000, $1BBF, $0000, $0520, $0060
		dc.w $0004, $0000, $163F, $0000, $0720, $0060
		dc.w $0004, $0000, $16BF, $0000, $0720, $0060
		; SLZ
		dc.w $0004, $0000, $1EBF, $0000, $0640, $0060
		dc.w $0004, $0000, $20BF, $0000, $0640, $0060
		dc.w $0004, $0000, $1EBF, $0000, $06C0, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		; SZ
		dc.w $0004, $0000, $22C0, $0000, $0420, $0060
		dc.w $0004, $0000, $28C0, $0000, $0520, $0060
		dc.w $0004, $0000, $2EC0, $0000, $0620, $0060
		dc.w $0004, $0000, $29C0, $0000, $0620, $0060
		; CWZ
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		; 06
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060
; ===========================================================================

LevSz_StartLoc:
		move.w	(v_zone).w,d0
		cmpi.b	#3,d0
		bne.s	loc_3C7C
		subq.b	#1,(v_act).w

loc_3C7C:
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	StartPosArray(pc,d0.w),a1 ; load Sonic's start location

		moveq	#0,d1
		move.w	(a1)+,d1
		move.w	d1,(v_player+obX).w ; set Sonic's position on x-axis
		subi.w	#160,d1		; is Sonic more than 160px from left edge?
		bcc.s	SetScr_WithinLeft ; if yes, branch
		moveq	#0,d1

SetScr_WithinLeft:
		move.w	d1,(v_scrposx).w ; set horizontal screen position
		moveq	#0,d0
		move.w	(a1),d0
		move.w	d0,(v_player+obY).w ; set Sonic's position on y-axis
		subi.w	#96,d0		; is Sonic within 96px of upper edge?
		bcc.s	SetScr_WithinTop ; if yes, branch
		moveq	#0,d0

SetScr_WithinTop:
		cmp.w	(v_limitbtm2).w,d0 ; is Sonic above the bottom edge?
		blt.s	SetScr_WithinBottom ; if yes, branch
		move.w	(v_limitbtm2).w,d0

SetScr_WithinBottom:
		move.w	d0,(v_scrposy).w ; set vertical screen position
		bsr.w	BgScrollSpeed
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.b	#2,d0
		move.l	LoopTileNums(pc,d0.w),(v_256loop1).w
		bra.w	LevSz_LoadScrollBlockSize
; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic start location array
; ---------------------------------------------------------------------------
StartPosArray:	include "Start Location Array - Levels.asm"

; ---------------------------------------------------------------------------
; Which 256x256 tiles contain loops or roll-tunnels
; ---------------------------------------------------------------------------

LoopTileNums:

; 		loop	loop	tunnel	tunnel

	dc.b	$B5,	$7F,	$1F,	$20	; Green Hill
	dc.b	$7F,	$7F,	$7F,	$7F	; Labyrinth
	dc.b	$7F,	$7F,	$7F,	$7F	; Marble
	dc.b	$B5,	$A8,	$7F,	$7F	; Star Light
	dc.b	$7F,	$7F,	$7F,	$7F	; Sparkling
	dc.b	$7F,	$7F,	$7F,	$7F	; Clock Work

		even

; ===========================================================================

LevSz_LoadScrollBlockSize:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#3,d0
		lea	BGScrollBlockSizes(pc,d0.w),a1
		lea	(v_scroll_block_size).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		rts
; End of function LevelSizeLoad

; ===========================================================================

BGScrollBlockSizes:
		; GHZ
		dc.w $70
		dc.w $100	; I guess these used to be per act?
		dc.w $100	; Or maybe each scroll block got its own size?
		dc.w $100	; Either way, these are unused now.
		; LZ
		dc.w $800
		dc.w $100
		dc.w $100
		dc.w 0
		; MZ
		dc.w $800
		dc.w $100
		dc.w $100
		dc.w 0
		; SLZ
		dc.w $800
		dc.w $100
		dc.w $100
		dc.w 0
		; SZ
		dc.w $800
		dc.w $100
		dc.w $100
		dc.w 0
		; CWZ
		dc.w $800
		dc.w $100
		dc.w $100
		dc.w 0
; ---------------------------------------------------------------------------
; Subroutine to set scroll speed of some backgrounds
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

BgScrollSpeed:
		move.w	d0,(v_bgscrposy).w
		move.w	d0,(v_bg2scrposy).w
		swap	d1
		move.l	d1,(v_bgscrposx).w
		move.l	d1,(v_bg2scrposx).w
		move.l	d1,(v_bg3scrposx).w
		moveq	#0,d2
		move.b	(v_zone).w,d2
		add.w	d2,d2
		move.w	BgScroll_Index(pc,d2.w),d2
		jmp	BgScroll_Index(pc,d2.w)
; ===========================================================================
BgScroll_Index:	dc.w BgScroll_GHZ-BgScroll_Index, BgScroll_LZ-BgScroll_Index
		dc.w BgScroll_MZ-BgScroll_Index, BgScroll_SLZ-BgScroll_Index
		dc.w BgScroll_SZ-BgScroll_Index, BgScroll_CWZ-BgScroll_Index
; ===========================================================================

BgScroll_GHZ:
		bra.w	Deform_GHZ
; ===========================================================================

BgScroll_LZ:
		rts
; ===========================================================================

BgScroll_MZ:
		rts
; ===========================================================================

BgScroll_SLZ:
		asr.l	#1,d0
		addi.w	#$C0,d0
		move.w	d0,(v_bgscrposy).w
		rts
; ===========================================================================

BgScroll_SZ:
		asl.l	#4,d0
		move.l	d0,d2
		asl.l	#1,d0
		add.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(v_bgscrposy).w
		move.w	d0,(v_bg2scrposy).w
		rts
; ===========================================================================

BgScroll_CWZ:
		rts