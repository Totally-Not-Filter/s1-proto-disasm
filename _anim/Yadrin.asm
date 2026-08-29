; ---------------------------------------------------------------------------
; Animation script - Yadrin enemy (MZ, SZ)
; ---------------------------------------------------------------------------

Ani_Yad:	dc.w .stand-Ani_Yad
		dc.w .walk-Ani_Yad

.stand:		dc.b 7
		dc.b 0
		dc.b afEnd
		even

.walk:		dc.b 7
		dc.b 0, 3, 1, 4, 0, 3, 2, 5
		dc.b afEnd
		even
