; ---------------------------------------------------------------------------
; Subroutine to load level boundaries and start locations
; ---------------------------------------------------------------------------

LevelSizeLoad:
		moveq	#0,d0
		move.b	d0,(f_rst_hscroll).w
		move.b	d0,(f_rst_vscroll).w
		move.b	d0,(v_unused9).w			; clear unused variables
		move.b	d0,(v_unused10).w			; ''
		move.b	d0,(v_dle_routine).w			; reset DynamicLevelEvents routine

		move.w	(v_zone_act).w,d0			; get current zone and act
		lsl.b	#6,d0					; align act ID bits next to zone ID
		lsr.w	#4,d0					; send zone and act all back together but keep at x4
		move.w	d0,d1					; copy
		add.w	d0,d0					; multiply by 2
		add.w	d1,d0					; multiply to x3 (d0 = index in LevelSizeArray for current zone and act)
		lea	LevelSizeArray(pc,d0.w),a0		; load level boundaries

		move.w	(a0)+,d0				; (unused) load first entry in level size array
		move.w	d0,(v_unused11).w			; write to unused variable (this is always $0004)

		move.l	(a0)+,d0				; load left and right level boundaries (two words, read as long)
		move.l	d0,(v_limitleft2).w			; set left and right boundaries (actual)
		move.l	d0,(v_limitleft1).w			; set left and right boundaries (target)

		cmp.w	(v_limitleft2).w,d0			; has left boundary been reached?
		bne.s	.notleft				; if not, branch
		move.b	#1,(f_rst_hscroll).w

.notleft:
		move.l	(a0)+,d0				; load top and bottom level boundaries (two words, read as long)
		move.l	d0,(v_limittop2).w			; set top and bottom boundaries (actual)
		move.l	d0,(v_limittop1).w			; set top and bottom boundaries (target)

		cmp.w	(v_limittop2).w,d0			; has top boundary been reached?
		bne.s	.nottop					; if not, branch
		move.b	#1,(f_rst_vscroll).w

.nottop:
		move.w	(v_limitleft2).w,d0			; get initial left boundary
		addi.w	#$240,d0				; add $240 (screen width + 256px)
		move.w	d0,(v_limitleft3).w			; (unused) write to unused variable

		move.w	(a0)+,d0				; load final entry in level size array
		move.w	d0,(v_lookshift).w			; write to vertical look shift (redundant, this is always $0060)

		bra.w	LevSz_InitScreenAndPlayerStart		; continue to remaining level setup for start location and camera position

; ===========================================================================
; ---------------------------------------------------------------------------
; Level size array
; ---------------------------------------------------------------------------
LevelSizeArray:
		include	"_include/LevelSizeArray.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Initialize Sonic's start location, initial screen position
; ---------------------------------------------------------------------------

LevSz_InitScreenAndPlayerStart:
		move.w	(v_zone_act).w,d0			; get current zone and act
		cmpi.b	#act4,d0				; is current act 4?
		bne.s	.notAct4				; if not, branch
		subq.b	#1,(v_act).w				; subtract 1 from the act number, effectively making act 4, act 3

	; loc_3C7C:
	.notAct4:
		lsl.b	#6,d0
		lsr.w	#4,d0					; d0 = index in StartLocArray for current zone and act
		lea	StartPosArray(pc,d0.w),a1		; load Sonic's start location

		moveq	#0,d1
		move.w	(a1)+,d1				; load starting X-position
		move.w	d1,(v_player+obX).w			; set Sonic's position on x-axis
		subi.w	#320/2,d1				; is Sonic more than 160px from left edge?
		bhs.s	SetScr_WithinLeft			; if yes, branch
		moveq	#0,d1

SetScr_WithinLeft:
		move.w	d1,(v_scrposx).w			; set horizontal screen position

		moveq	#0,d0
		move.w	(a1),d0					; load starting Y-position
		move.w	d0,(v_player+obY).w			; set Sonic's position on y-axis
		subi.w	#96,d0					; is Sonic within 96px of upper edge?
		bhs.s	SetScr_WithinTop			; if yes, branch
		moveq	#0,d0

SetScr_WithinTop:
		cmp.w	(v_limitbtm2).w,d0			; is Sonic above the bottom edge?
		blt.s	SetScr_WithinBottom			; if yes, branch
		move.w	(v_limitbtm2).w,d0

SetScr_WithinBottom:
		move.w	d0,(v_scrposy).w			; set vertical screen position

		bsr.w	BgScrollSpeed				; setup background scroll positions

		moveq	#0,d0
		move.b	(v_zone).w,d0				; get current zone ID
		lsl.b	#2,d0					; multiply by 4 bytes per loop chunk data entry
		move.l	LoopChunkNums(pc,d0.w),(v_256loop1).w	; set loop chunk data for current zone
		bra.w	LevSz_LoadScrollBlockSize		; setup scroll block sizes

; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic start location array
; ---------------------------------------------------------------------------
StartPosArray:	include "Start Location Array - Levels.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Which 256x256 tiles contain loops or roll-tunnels. Values above $80 are
; when the special chunks are active, and $7F is a blank placeholder value.
; ---------------------------------------------------------------------------

; LoopTileNums:
LoopChunkNums:	; 	loop	loop	tunnel	tunnel
		dc.b	$B5,	$7F,	$1F,	$20	; Green Hill
		dc.b	$7F,	$7F,	$7F,	$7F	; Labyrinth
		dc.b	$7F,	$7F,	$7F,	$7F	; Marble
		dc.b	$B5,	$A8,	$7F,	$7F	; Star Light
		dc.b	$7F,	$7F,	$7F,	$7F	; Sparkling
		dc.b	$7F,	$7F,	$7F,	$7F	; Clock Work
; ===========================================================================


; ---------------------------------------------------------------------------
; Old (and mostly unused) scroll block definition system used in REV00.
; Each word represents a scroll block size, for example GHZ has $70 pixels
; for the first scroll block (clouds/top mountains), followed by $100 pixels
; for the rest of the bottom mountains and water. The majority of this
; information is unused, since most of REV00's backgrounds are not scrolled
; in any special way, and GHZ is the only real zone that uses this system.
; This was deleted entirely for REV01 when each zone got unique deformation.
; ---------------------------------------------------------------------------

LevSz_LoadScrollBlockSize:
		moveq	#0,d0
		move.b	(v_zone).w,d0				; get current zone ID
		lsl.w	#3,d0					; multiply by 8 bytes per entry
		lea	BGScrollBlockSizes(pc,d0.w),a1		; load address of correct level
		lea	(v_scroll_block_1_size).w,a2		; load scroll size address
		move.l	(a1)+,(a2)+				; load A and B
		move.l	(a1)+,(a2)+				; load C and D
		rts
; End of function LevSz_LoadScrollBlockSize
; ---------------------------------------------------------------------------

BGScrollBlockSizes:
		dc.w	$70,	$100,	$100,	$100	; GHZ
		dc.w	$800,	$100,	$100,	0	; LZ
		dc.w	$800,	$100,	$100,	0	; MZ
		dc.w	$800,	$100,	$100,	0	; SLZ
		dc.w	$800,	$100,	$100,	0	; SYZ
		dc.w	$800,	$100,	$100,	0	; SBZ


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to setup scroll positions (mostly to set the backgrounds in the right place)
; 
; input:
;	d0 = initial FG camera Y-position
;	d1 = initial FG camera X-position
; ---------------------------------------------------------------------------

BgScrollSpeed:
		move.w	d0,(v_bgscrposy).w			; set background Y-position
		move.w	d0,(v_bg2scrposy).w			; ''
		swap	d1
		move.l	d1,(v_bgscrposx).w			; set background X-position
		move.l	d1,(v_bg2scrposx).w			; ''
		move.l	d1,(v_bg3scrposx).w			; ''

		moveq	#0,d2
		move.b	(v_zone).w,d2				; get zone ID
		add.w	d2,d2					; double for word-based indexing
		move.w	BgScroll_Index(pc,d2.w),d2		; find entry in offset table
		jmp	BgScroll_Index(pc,d2.w)			; jump to background setup logic for zone

; ===========================================================================
BgScroll_Index:
		dc.w	BgScroll_GHZ-BgScroll_Index
		dc.w	BgScroll_LZ-BgScroll_Index
		dc.w	BgScroll_MZ-BgScroll_Index
		dc.w	BgScroll_SLZ-BgScroll_Index
		dc.w	BgScroll_SZ-BgScroll_Index
		dc.w	BgScroll_CWZ-BgScroll_Index
; ===========================================================================

BgScroll_GHZ:
		bra.w	Deform_GHZ				; just let the normal scroll routine set it all up
; ===========================================================================

BgScroll_LZ:
		rts
; ===========================================================================

BgScroll_MZ:
		rts
; ===========================================================================

BgScroll_SLZ:
		asr.l	#1,d0					; divide Y-position by 2
		addi.w	#$C0,d0					; scroll it up by $C0px (manual adjustment)
		move.w	d0,(v_bgscrposy).w			; set BG Y position
		rts
; ===========================================================================

BgScroll_SZ:
		asl.l	#4,d0					; multiply Y-position by $10
		move.l	d0,d2					; backup
		asl.l	#1,d0					; double again
		add.l	d2,d0					; d0 = Y-position * $30
		asr.l	#8,d0					; divide by $100 ($30% the speed of FG)
		move.w	d0,(v_bgscrposy).w			; set BG Y-position
		move.w	d0,(v_bg2scrposy).w			; ''
		rts
; ===========================================================================

BgScroll_CWZ:
		rts