Map_MBlock_internal:	mappingsTable
	mappingsTableEntry.w	.mz1
	mappingsTableEntry.w	.mz2

.mz1:	spriteHeader
	spritePiece	-$10, -8, 4, 4, 8, 0, 0, 0, 0
.mz1_End

.mz2:	spriteHeader
	spritePiece	-$20, -8, 4, 4, 8, 0, 0, 0, 0
	spritePiece	0, -8, 4, 4, 8, 0, 0, 0, 0
.mz2_End

	even
