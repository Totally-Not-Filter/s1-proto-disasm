; ---------------------------------------------------------------------------
; Animation script - Ball Hog enemy
; ---------------------------------------------------------------------------

Ani_Hog:
		dc.w	.still-Ani_Hog
		dc.w	.walk-Ani_Hog
		dc.w	.fire-Ani_Hog

.still:		dc.b 15
		dc.b 0
		dc.b afEnd
		even

.walk:		dc.b 11
		dc.b 1, 0, 1|aniXFlip, 0
		dc.b afEnd
		even

.fire:		dc.b 20
		dc.b 0, 2
		dc.b 0, afBack, 1
		even