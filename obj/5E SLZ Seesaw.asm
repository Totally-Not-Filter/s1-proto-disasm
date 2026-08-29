; ---------------------------------------------------------------------------
; Object 5E - Seesaws (SLZ)
; ---------------------------------------------------------------------------

Seesaw:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	See_Index(pc,d0.w),d1
		jsr	See_Index(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
See_Index:
		dc.w	See_Main-See_Index			; 0
		dc.w	See_Seesaw_Platform-See_Index		; 2
		dc.w	See_Seesaw_StoodOn-See_Index		; 4
; ===========================================================================

See_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to See_Seesaw_Platform
		move.l	#Map_Seesaw,obMap(a0)			; set mappings
		move.w	#ArtTile_SLZ_Seesaw,obGfx(a0)		; set art tile
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#96/2,obActWid(a0)			; set sprite display width

See_Seesaw_Platform:	; Routine 2
		lea	(See_DataSlope).l,a2			; load sloped collision data
		btst	#0,obFrame(a0)				; is seesaw flat? (frame1 and 3)
		beq.s	.slopeObject				; if not, branch
		lea	(See_DataFlat).l,a2			; load flat collision data instead

	.slopeObject:
		lea	(v_player).w,a1				; load Sonic player object
		move.w	#96/2,d1				; width of seesaw for SlopeObject
		jsr	(SlopeObject).l				; handle platform (sets obRoutine to 4 = See_Seesaw_StoodOn if stood on)
		btst	#3,obID(a0)				; is bit 3 set in object ID? (seems to be an incomplete check to see if Sonic is standing on the seesaw, except it's not using obStatus)
		beq.s	.return					; if not, branch
		nop						; unknown code

	.return:
		rts
; ===========================================================================

See_Seesaw_StoodOn:	; Routine 4
		bsr.w	See_ChkSide				; update seesaw frame and state based on Sonic's X-position

		lea	(See_DataSlope).l,a2			; load sloped collision data
		btst	#0,obFrame(a0)				; is seesaw flat? (frame1 and 3)
		beq.s	.slopeObject				; if not, branch
		lea	(See_DataFlat).l,a2			; load flat collision data instead

	.slopeObject:
		move.w	#96/2,d1				; width of seesaw for ExitPlatform
		jsr	(ExitPlatform).l			; allow Sonic walking off (sets obRoutine 2 = See_Seesaw_Platform on exit)

		move.w	#96/2,d1				; width of seesaw for SlopeObject_AssumeStoodOn
		move.w	obX(a0),d2				; get platform X-position for SlopeObject_AssumeStoodOn input
		jsr	(SlopeObject_AssumeStoodOn).l		; (part of Object 1A - Collapsing GHZ Ledges)
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to set the seesaw tilt based on what side Sonic is on
; ---------------------------------------------------------------------------

See_ChkSide:
		moveq	#2,d1					; set ascending state
		lea	(v_player).w,a1				; load Sonic player object
		move.w	obX(a0),d0				; get Seesaw's X-position
		sub.w	obX(a1),d0				; calculate difference to seesaw center's X-position
		bhs.s	.checkCenter				; is Sonic on the left side of the seesaw? if yes, branch
		neg.w	d0					; make X-difference positive for check
		moveq	#0,d1					; set descending state

	.checkCenter:
		cmpi.w	#8,d0					; is Sonic within 8px of seesaw center?
		bhs.s	See_ChgFrame				; if not, branch
		moveq	#1,d1					; set flat state
		; continue to See_ChgFrame...
; ---------------------------------------------------------------------------

See_ChgFrame:
		move.b	d1,obFrame(a0)				; set new seesaw frame
		bclr	#sprite_xflip_bit,obRender(a0)		; make seesaw descending by default
		btst	#1,obFrame(a0)				; is Sonic standing on the left side of the seesaw?
		beq.s	.return					; if not, branch
		bset	#sprite_xflip_bit,obRender(a0)		; make seesaw ascending instead

	.return:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Collision data for seesaws (SLZ)
; ---------------------------------------------------------------------------

See_DataSlope:
		dcb.b	  2,$24		; flat
		range	$26,$2C,+2	; ascending
		range	$2A,$24,-2	; descending
		range	$23,$03,-1	; descending
		dcb.b	  5,$02		; flat
		even

See_DataFlat:
		dcb.b	 48,$15		; flat
		even

; ===========================================================================

Map_Seesaw:	include "_maps/Seesaw.asm"