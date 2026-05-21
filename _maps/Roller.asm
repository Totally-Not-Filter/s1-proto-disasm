; ---------------------------------------------------------------------------
; Sprite mappings - Roller enemy (SYZ)
; ---------------------------------------------------------------------------
Map_Roll_internal:	mappingsTable
	mappingsTableEntry.w	.roll_Stand
	mappingsTableEntry.w	.roll_Fold
	mappingsTableEntry.w	.roll_Roll1
	mappingsTableEntry.w	.roll_Roll2
	mappingsTableEntry.w	.roll_Roll3

.roll_Stand:	spriteHeader
	spritePiece	-$10, -$22, 4, 3, 0, 0, 0, 0, 0	; standing
	spritePiece	-$10, -$A, 4, 3, $C, 0, 0, 0, 0
.roll_Stand_End

.roll_Fold:	spriteHeader
	spritePiece	-$10, -$1A, 4, 3, 0, 0, 0, 0, 0	; folding
	spritePiece	-$10, -2, 4, 2, $18, 0, 0, 0, 0
.roll_Fold_End

.roll_Roll1:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $20, 0, 0, 0, 0 ; rolling
.roll_Roll1_End

.roll_Roll2:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $30, 0, 0, 0, 0 ; rolling
.roll_Roll2_End

.roll_Roll3:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $40, 0, 0, 0, 0 ; rolling
.roll_Roll3_End

	even
