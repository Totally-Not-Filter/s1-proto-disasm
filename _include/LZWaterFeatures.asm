; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine that controls the line that certain HBlank effects take place on
; via UP and DOWN on the control pad. Called in the main game loop
; ---------------------------------------------------------------------------

LZWaterFeatures:
		btst	#bitUp,(v_jpadhold1).w			; is up button held?
		beq.s	.checkbtndown				; if not, check if we're holding down
		addq.w	#1,(v_bg3scrposy).w			; increase y position of bg3scrpos
		tst.b	(v_hblank_line).w
		beq.s	.checkbtndown
		subq.b	#1,(v_hblank_line).w			; decrease hblank line

.checkbtndown:
		btst	#bitDn,(v_jpadhold1).w			; is down button held?
		beq.s	.donothing				; if not, return
		subq.w	#1,(v_bg3scrposy).w			; decrease y position of bg3scrpos
		cmpi.b	#224-1,(v_hblank_line).w
		beq.s	.donothing
		addq.b	#1,(v_hblank_line).w			; increase hblank line

.donothing:	
		rts