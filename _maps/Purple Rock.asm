; ---------------------------------------------------------------------------
; Sprite mappings - purple rock (GHZ)
; ---------------------------------------------------------------------------
Map_PRock_internal:	mappingsTable
	mappingsTableEntry.w	.rock

.rock:	spriteHeader
	spritePiece	-$18, -$10, 3, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$10, 3, 4, $C, 0, 0, 0, 0
.rock_End

	even
