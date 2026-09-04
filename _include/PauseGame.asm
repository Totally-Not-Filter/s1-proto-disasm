; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to pause the game
; ---------------------------------------------------------------------------

PauseGame:
		nop						; useless nop (probably so an rts could easily be inserted here)
		tst.b	(v_lives).w				; do you have any lives left?
		beq.s	.unpauseGame				; if not, branch (prevents pausing during a game over)
		tst.w	(f_pause).w				; is game already paused?
		bne.s	.startPause				; if yes, branch
		btst	#bitStart,(v_jpadpress1).w		; has Start button been pressed?
		beq.s	.return					; if not, branch

	; Pause_StopGame:
	.startPause:
		move.w	#-1,(f_pause).w				; pause the game
; ---------------------------------------------------------------------------

; Pause_Loop:
.pauseLoop:
		move.b	#id_VBlank_10,(v_vblank_routine).w	; run routine $10 in VBlank
		bsr.w	WaitForVBlank				; wait until VBlank has finished

		btst	#bitA,(v_jpadpress1).w			; is button A pressed?
		beq.s	.checkSlowMotion			; if not, branch
		move.b	#id_Title,(v_gamemode).w		; return to title screen
		nop						; useless nop
		bra.s	.unpauseGame				; unpause the game
; ---------------------------------------------------------------------------

	; Pause_ChkBC:
	.checkSlowMotion:
		btst	#bitB,(v_jpadhold1).w			; is button B pressed?
		bne.s	.slowMotion				; if yes, branch
		btst	#bitC,(v_jpadpress1).w			; is button C pressed?
		bne.s	.slowMotion				; if yes, branch
		btst	#bitStart,(v_jpadpress1).w		; is Start button pressed?
		beq.s	.pauseLoop				; if not, branch
; ---------------------------------------------------------------------------

	; Unpause:
	.unpauseGame:
		move.w	#0,(f_pause).w				; unpause the game

	; Pause_DoNothing:
	.return:
		rts						; return to main level loop
; ===========================================================================

; Pause_SlowMo:
.slowMotion:
		move.w	#1,(f_pause).w				; keep flag set so pause is triggered on next frame again
		rts						; return to main level loop
; End of function PauseGame