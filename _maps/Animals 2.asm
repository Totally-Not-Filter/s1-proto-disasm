; ---------------------------------------------------------------------------
; Sprite mappings - animals
; ---------------------------------------------------------------------------
Map_Animal2_internal:	mappingsTable
	mappingsTableEntry.w	.flap1
	mappingsTableEntry.w	.flap2
	mappingsTableEntry.w	.drop

.drop:	spriteHeader
	spritePiece	-8, -$C, 2, 3, 0, 0, 0, 0, 0
.drop_End

.flap1:	spriteHeader
	spritePiece	-8, -4, 2, 2, 6, 0, 0, 0, 0
.flap1_End

.flap2:	spriteHeader
	spritePiece	-8, -4, 2, 2, $A, 0, 0, 0, 0
.flap2_End

	even
