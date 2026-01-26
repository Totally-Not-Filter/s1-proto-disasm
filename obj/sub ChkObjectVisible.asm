; ---------------------------------------------------------------------------
; Subroutine to check if an object is off screen

; output:
;	d0 = flag set if object is off screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

ChkObjectVisible:
		move.w	obX(a0),d0	; get object x-position
		sub.w	(v_scrposx).w,d0 ; subtract screen x-position
		bmi.s	.offscreen
		cmpi.w	#320,d0		; is object on the screen?
		bge.s	.offscreen	; if not, branch

		move.w	obY(a0),d1	; get object y-position
		sub.w	(v_scrposy).w,d1 ; subtract screen y-position
		bmi.s	.offscreen
		cmpi.w	#224,d1		; is object on the screen?
		bge.s	.offscreen	; if not, branch

		moveq	#0,d0		; set flag to 0
		rts

.offscreen:
		moveq	#1,d0		; set flag to 1
		rts
; End of function ChkObjectVisible