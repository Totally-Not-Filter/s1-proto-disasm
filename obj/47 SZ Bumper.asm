; ===========================================================================
; ---------------------------------------------------------------------------
; Object 47 - pinball bumper (SZ)
; ---------------------------------------------------------------------------

Bumper:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bump_Index(pc,d0.w),d1
		jmp	Bump_Index(pc,d1.w)
; ===========================================================================
Bump_Index:
		dc.w	Bump_Main-Bump_Index
		dc.w	Bump_Hit-Bump_Index
; ===========================================================================

Bump_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Bump_Hit
		move.l	#Map_Bump,obMap(a0)			; set mappings
		move.w	#ArtTile_SZ_Bumper,obGfx(a0)		; set art tile
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield positioning mode
		move.b	#32/2,obActWid(a0)			; set sprite display width
		move.b	#1,obPriority(a0)			; set sprite priority (above Sonic)
		move.b	#col_16x16_alt|col_special,obColType(a0) ; set collision type (handled through ReactToItem => D7orE1)

Bump_Hit:	; Routine 2
		tst.b	obColProp(a0)				; has Sonic touched the bumper? (set in ReactToItem)
		beq.s	Bump_Display				; if not, branch
		clr.b	obColProp(a0)				; reset bumper to not touched

		lea	(v_player).w,a1				; load Sonic object
		move.w	obX(a0),d1				; get Sonic's X-position
		move.w	obY(a0),d2				; get Sonic's Y-position
		sub.w	obX(a1),d1				; find difference to bumper's X-position
		sub.w	obY(a1),d2				; find difference to bumper'S Y-position
		jsr	(CalcAngle).l				; calculate angle Sonic hit the bumper at
		jsr	(CalcSine).l				; convert angle to sine and cosine
		muls.w	#-$700,d1				; multiply by bounce force
		asr.l	#8,d1					; shift result down a byte
		move.w	d1,obVelX(a1)				; bounce Sonic away horizontally
		muls.w	#-$700,d0				; multiply by bounce force
		asr.l	#8,d0					; shift result down a byte
		move.w	d0,obVelY(a1)				; bounce Sonic away vertically

		bset	#1,obStatus(a1)				; set Sonic to airborne
		clr.b	jumping(a1)				; clear jumping flag

		move.b	#1,obAnim(a0)				; use bumper "hit" animation
		move.w	#sfx_Bumper,d0				; set bumper sound
		jsr	(QueueSound2).l				; play it
; ---------------------------------------------------------------------------

Bump_Display:
		lea	(Ani_Bump).l,a1				; load bumper animation script
		bsr.w	AnimateSprite				; advance animation
	if FixBugs
		out_of_range.w	DeleteObject			; is bumper out of range? if yes, delete it
		bra.w	DisplaySprite				; otherwise, keep displaying sprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject			; is bumper out of range? if yes, delete it
		rts
	endif
; ===========================================================================

		include	"_anim/Bumper.asm"
Map_Bump:	include	"_maps/Bumper.asm"
