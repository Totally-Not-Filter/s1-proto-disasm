; ---------------------------------------------------------------------------
; Animation script - "PRESS START BUTTON" on the title screen
; ---------------------------------------------------------------------------
Ani_PSB:	dc.w .flash-Ani_PSB
.flash:		dc.b $1F, 0, 1,	afEnd
		even