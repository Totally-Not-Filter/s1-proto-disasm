; ---------------------------------------------------------------------------
; Sprite mappings - SCORE, TIME, RINGS
; ---------------------------------------------------------------------------
Map_HUD_internal:	mappingsTable
	mappingsTableEntry.w	.allyellow

.allyellow:	spriteHeader
	spritePiece	0, -$80, 4, 2, 0, 0, 0, 0, 1		; "SCOR"
	spritePiece	$20, -$80, 4, 2, $18, 0, 0, 0, 1	; "E" and first three score digits
	spritePiece	$40, -$80, 4, 2, $20, 0, 0, 0, 1	; last four score digits
	
	spritePiece	0, -$70, 4, 2, $10, 0, 0, 0, 1		; "TIME"
	spritePiece	$28, -$70, 4, 2, $28, 0, 0, 0, 1	; time counter
	
	spritePiece	0, -$60, 4, 2, 8, 0, 0, 0, 1		; "RING"
	spritePiece	$28, -$60, 3, 2, $30, 0, 0, 0, 1	; rings counter
	
	spritePiece	0, $40, 2, 2, $10A, 0, 0, 0, 1		; lives counter (Sonic icon)
	spritePiece	$10, $40, 4, 2, $10E, 0, 0, 0, 1	; lives counter ("SONIC x N" text)
.allyellow_End
	even