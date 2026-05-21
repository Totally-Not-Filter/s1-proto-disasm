; ---------------------------------------------------------------------------
; Sprite mappings - springs
; ---------------------------------------------------------------------------
Map_Spring_internal:	mappingsTable
	mappingsTableEntry.w	.spg_Up
	mappingsTableEntry.w	.spg_UpFlat
	mappingsTableEntry.w	.spg_UpExt
	mappingsTableEntry.w	.spg_Left
	mappingsTableEntry.w	.spg_LeftFlat
	mappingsTableEntry.w	.spg_LeftExt

.spg_Up:	spriteHeader
	spritePiece	-$10, -8, 4, 1, 0, 0, 0, 0, 0	; facing up
	spritePiece	-$10, 0, 4, 1, 4, 0, 0, 0, 0
.spg_Up_End

.spg_UpFlat:	spriteHeader
	spritePiece	-$10, 0, 4, 1, 0, 0, 0, 0, 0	; facing up, flattened
.spg_UpFlat_End

.spg_UpExt:	spriteHeader
	spritePiece	-$10, -$18, 4, 1, 0, 0, 0, 0, 0	; facing up, extended
	spritePiece	-8, -$10, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 1, $C, 0, 0, 0, 0
.spg_UpExt_End

.spg_Left:	spriteHeader
	spritePiece	-8, -$10, 2, 4, 0, 0, 0, 0, 0	; facing left
.spg_Left_End

.spg_LeftFlat:	spriteHeader
	spritePiece	-8, -$10, 1, 4, 4, 0, 0, 0, 0	; facing left, flattened
.spg_LeftFlat_End

.spg_LeftExt:	spriteHeader
	spritePiece	$10, -$10, 1, 4, 4, 0, 0, 0, 0	; facing left, extended
	spritePiece	-8, -8, 3, 2, 8, 0, 0, 0, 0
	spritePiece	-8, -$10, 1, 1, 0, 0, 0, 0, 0
	spritePiece	-8, 8, 1, 1, 3, 0, 0, 0, 0
.spg_LeftExt_End

	even
