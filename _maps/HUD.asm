; ---------------------------------------------------------------------------
; Sprite mappings - SCORE, TIME, RINGS
; ---------------------------------------------------------------------------
Map_HUD_internal:		
		dc.w byte_11620-Map_HUD_internal
byte_11620:	dc.b 9
		dc.b $80, $D, $80, 0, 0
		dc.b $80, $D, $80, $18, $20
		dc.b $80, $D, $80, $20, $40
		dc.b $90, $D, $80, $10, 0
		dc.b $90, $D, $80, $28, $28
		dc.b $A0, $D, $80, 8, 0
		dc.b $A0, 9, $80, $30, $28
		dc.b $40, 5, $81, $A, 0
		dc.b $40, $D, $81, $E, $10
		even