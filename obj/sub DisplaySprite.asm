; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

DisplaySprite:
		lea	(v_spritequeue).w,a1
		move.b	obPriority(a0),d0 ; get sprite priority
		andi.w	#7,d0
		lsl.w	#7,d0
		adda.w	d0,a1		; jump to position in queue
		cmpi.w	#$7E,(a1)	; is this part of the queue full?
		bhs.s	DSpr_Full	; if yes, branch
		addq.w	#2,(a1)		; increment sprite count
		adda.w	(a1),a1		; jump to empty position
		move.w	a0,(a1)		; insert RAM address for object

DSpr_Full:
		rts
; End of function DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to display a 2nd sprite/object, when a1 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

DisplaySprite1:
		lea	(v_spritequeue).w,a2
		move.b	obPriority(a1),d0
		andi.w	#7,d0
		lsl.w	#7,d0
		adda.w	d0,a2
		cmpi.w	#$7E,(a2)
		bhs.s	DSpr1_Full
		addq.w	#2,(a2)
		adda.w	(a2),a2
		move.w	a1,(a2)

DSpr1_Full:
		rts
; End of function DisplaySprite1