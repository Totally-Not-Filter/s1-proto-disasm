; ===========================================================================
; ---- Palette fading subroutines input format, shared by all variations ----
;
; v_pfade_start = Start position in palette. One word per color. Examples:
;                 $00: palette line 1, first color
;                 $20: palette line 2, first color
;                 $42: palette line 3, second color
; 
; v_pfade_size  = Number of colors to affect, minus 1. Examples:
;                 $0F: 16 colors (one palette line)
;                 $1F: 32 colors (two palette lines)
;                 $3F: is the entire palette (four palette lines)
; 
; v_pfade_start and v_pfade_size are back to back in RAM, so they usually
; get set together as a single word write to v_pfade_start. The most common
; setting is $003F for "the entire palette", which is why it has a shorthand.
; 
; One more note about RGB: the Mega Drive stores the color values backwards,
; meaning that one color word has the format BGR (blue-green-red).
; ===========================================================================


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to fade in from black
; ---------------------------------------------------------------------------

PaletteFadeIn:
		move.w	#$003F,(v_pfade_start).w		; set start position = 0; affect all $40 palette colors
; ---------------------------------------------------------------------------

PalFadeIn_Alt:	; start position and size are already set
		moveq	#0,d0					; clear d0
		lea	(v_palette).w,a0			; load palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance palette buffer to start position
		moveq	#cBlack,d1				; fill palette with black ($000)
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fillBlack:
		move.w	d1,(a0)+				; make color black
		dbf	d0,.fillBlack 				; loop until colors have been filled with black

		move.w	#21-1,d4				; fade in for 21 frames (d4 must not be used elsewhere!)
	.fadeMainLoop:
		move.b	#id_VInt_12,(v_vint_routine).w ; set VBlank routine to fade-in ($12)
		bsr.w	WaitForVInt				; wait for VBlank to transfer CRAM and sync screen
		bsr.s	FadeIn_FromBlack			; fade-in all affected colors from black a bit more
		bsr.w	RunPLC					; run any PLC, if necessary
		dbf	d4,.fadeMainLoop			; loop for 21 frames

		rts						; return
; End of function PaletteFadeIn
; ===========================================================================

FadeIn_FromBlack:
		moveq	#0,d0					; clear d0
		lea	(v_palette).w,a0			; load active palette buffer
		lea	(v_palette_fading).w,a1			; load fade-in palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance active palette buffer to start position
		adda.w	d0,a1					; advance fade-in palette buffer to start position
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fadeColors:
		bsr.s	FadeIn_AddColor				; fade-in current color a bit more
		dbf	d0,.fadeColors				; loop until all colors have been faded in more

		rts						; return
; End of function FadeIn_FromBlack
; ===========================================================================

; The fade-in logic increases one RGB value at a time until the target color
; has been reached. Sonic 1 fades blue first, then green, then red, resulting
; in the characteristic blue-tinted fade seen throughout the entire game.
; A simultaneous RGB fade would appear more natural, but would also complete
; much faster. This staggered approach may have been chosen to extend
; the fade duration while giving it a distinct visual style.

FadeIn_AddColor:
		move.w	(a1)+,d2				; get current target color (and advance index for next color)
		move.w	(a0),d3					; get current active color
		cmp.w	d2,d3					; has active color already reached its target level?
		beq.s	.nextColor				; if yes, fade is done for this color

	.addBlue:
		move.w	d3,d1					; get current active color
		addi.w	#$200,d1				; increase blue value by one step
		cmp.w	d2,d1					; has blue exceeded target level?
		bhi.s	.addGreen				; if yes, start fading in green
		move.w	d1,(a0)+				; update active color
		rts						; do not update green or red values until blue is done
; ---------------------------------------------------------------------------

	.addGreen:
		move.w	d3,d1					; get current active color
		addi.w	#$020,d1				; increase green value by one step
		cmp.w	d2,d1					; has green exceeded target level?
		bhi.s	.addRed					; if yes, start fading in red
		move.w	d1,(a0)+				; update active color
		rts						; do not update red value until green is done
; ---------------------------------------------------------------------------

	.addRed:
		addq.w	#$002,(a0)+				; increase red value by one step & update active color
		rts						; return
; ---------------------------------------------------------------------------

	.nextColor:
		addq.w	#2,a0					; advance active palette buffer to next color
		rts						; return
; End of function FadeIn_AddColor


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to fade out to black
; ---------------------------------------------------------------------------

PaletteFadeOut:
		move.w	#$003F,(v_pfade_start).w		; set start position = 0; affect all $40 palette colors

		move.w	#21-1,d4				; fade in for 21 frames (d4 must not be used elsewhere!)
	.fadeMainLoop:
		move.b	#id_VInt_12,(v_vint_routine).w ; set VBlank routine to fade-in ($12)
		bsr.w	WaitForVInt				; wait for VBlank to transfer CRAM and sync screen
		bsr.s	FadeOut_ToBlack				; fade-out all affected colors to black a bit more
		bsr.w	RunPLC					; run any PLC, if necessary
		dbf	d4,.fadeMainLoop			; loop for 21 frames

		rts						; return
; End of function PaletteFadeOut
; ===========================================================================

FadeOut_ToBlack:
		moveq	#0,d0					; clear d0
		lea	(v_palette).w,a0			; load active palette buffer
		move.b	(v_pfade_start).w,d0			; get specified start position offset
		adda.w	d0,a0					; advance active palette buffer to start position
		move.b	(v_pfade_size).w,d0			; get number of colors to affect (minus 1 for dbf)
	.fadeColors:
		bsr.s	FadeOut_DecColor			; fade-out current color a bit more
		dbf	d0,.fadeColors				; repeat for size of palette

		rts						; return
; End of function FadeOut_ToBlack
; ===========================================================================

FadeOut_DecColor:
		move.w	(a0),d2					; get current active color
		beq.s	.nextColor				; if it's already fully black ($000), fade-out is done for this color

	.decRed:
		move.w	d2,d1					; get current active color again
		andi.w	#$00E,d1				; only look at red channel
		beq.s	.decGreen				; if red channel is already at 0, start fading out green
		subq.w	#$002,(a0)+				; decrease red value
		rts						; do not update green or blues values until blue is done
; ---------------------------------------------------------------------------

	.decGreen:
		move.w	d2,d1					; get current active color again
		andi.w	#$0E0,d1				; only look at green channel
		beq.s	.decBlue				; if green channel is already at 0, start fading out blue
		subi.w	#$020,(a0)+				; decrease green value
		rts						; do not update blue value until green is done
; ---------------------------------------------------------------------------

	.decBlue:
		move.w	d2,d1					; get current active color again
		andi.w	#$E00,d1				; only look at blue channel
		beq.s	.nextColor				; if blue channel is already at 0, exit
		subi.w	#$200,(a0)+				; decrease blue value
		rts						; return
; ---------------------------------------------------------------------------

	.nextColor:
		addq.w	#2,a0					; advance active palette buffer to next color
		rts						; return
; End of function FadeOut_DecColor