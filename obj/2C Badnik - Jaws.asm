; ===========================================================================
; ---------------------------------------------------------------------------
; Object 2C - Jaws enemy (LZ)
; ---------------------------------------------------------------------------

Jaws:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Jaws_Index(pc,d0.w),d1
		jsr	Jaws_Index(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
Jaws_Index:
		dc.w	Jaws_Main-Jaws_Index			; 0
		dc.w	Jaws_Swim-Jaws_Index			; 2
; ===========================================================================

Jaws_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Jaws_Swim
		move.l	#Map_Jaws,obMap(a0)			; set mappings
		move.w	#ArtTile_Jaws,obGfx(a0)			; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set playfield-positioned mode
		move.b	#col_32x24|col_badnik,obColType(a0)	; set collision type to badnik, 32x24
		move.b	#4,obPriority(a0)			; set sprite priority
	if FixBugs
		move.b	#48/2,obActWid(a0)			; set sprite display width (corrected)
	else
		; This is too small, object gets culled too early.
		move.b	#32/2,obActWid(a0)			; set sprite display width
	endif
		move.w	#-$40,obVelX(a0)			; move Jaws to the left

Jaws_Swim:	; Routine 2
		lea	(Ani_Jaws).l,a1				; load animation script
		bsr.w	AnimateSprite				; animate Jaws
		bra.w	SpeedToPos				; make Jaws swim
; ===========================================================================

		include	"_anim/Jaws.asm"
Map_Jaws:	include	"_maps/Jaws.asm"
