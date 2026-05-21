; ---------------------------------------------------------------------------
; Sprite mappings - "GAME OVER" and "TIME OVER"
; ---------------------------------------------------------------------------
Map_Over_internal:	mappingsTable
	mappingsTableEntry.w	.game
	mappingsTableEntry.w	.over

.game:	spriteHeader	; "GAME" text
	spritePiece	-$48, -8, 4, 2, 0, 0, 0, 0, 0	; "GA"
	spritePiece	-$28, -8, 4, 2, 8, 0, 0, 0, 0	; "ME"
.game_End

.over:	spriteHeader	; "OVER" text for game over
	spritePiece	8, -8, 4, 2, $14, 0, 0, 0, 0	; "OV"
	spritePiece	$28, -8, 4, 2, $C, 0, 0, 0, 0	; "ER"
.over_End

	even
