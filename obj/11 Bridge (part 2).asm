
Bri_Platform:	; Routine 4
		bsr.s	Bri_WalkOff
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	Bri_ChkDel

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk off a bridge
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

Bri_WalkOff:
		moveq	#0,d1
		move.b	obSubtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		bsr.s	ExitPlatform2
		bcc.s	locret_50E8
		lsr.w	#4,d0
		move.b	d0,objoff_3F(a0)
		move.b	objoff_3E(a0),d0
		cmpi.b	#$40,d0
		beq.s	loc_50E0
		addq.b	#4,objoff_3E(a0)

loc_50E0:
		bsr.w	Bri_Bend
		bsr.w	Bri_MoveSonic

locret_50E8:
		rts
; End of function Bri_WalkOff