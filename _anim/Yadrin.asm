; ---------------------------------------------------------------------------
; Animation script - Yadrin enemy
; ---------------------------------------------------------------------------
Ani_Yad_internal:	dc.w .stand-Ani_Yad_internal
		dc.w .walk-Ani_Yad_internal
.stand:		dc.b 7,	0, afEnd
		even
.walk:		dc.b 7,	0, 3, 1, 4, 0, 3, 2, 5,	afEnd
		even