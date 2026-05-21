Map_FBlock_internal:	mappingsTable
	mappingsTableEntry.w	.sz1x1
	mappingsTableEntry.w	.sz2x2
	mappingsTableEntry.w	.sz1x2
	mappingsTableEntry.w	.szrect2x2
	mappingsTableEntry.w	.szrect1x3
	mappingsTableEntry.w	.slz

.sz1x1:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $61, 0, 0, 0, 0
.sz1x1_End

.sz2x2:	spriteHeader
	spritePiece	-$20, -$20, 4, 4, $61, 0, 0, 0, 0
	spritePiece	0, -$20, 4, 4, $61, 0, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $61, 0, 0, 0, 0
	spritePiece	0, 0, 4, 4, $61, 0, 0, 0, 0
.sz2x2_End

.sz1x2:	spriteHeader
	spritePiece	-$10, -$20, 4, 4, $61, 0, 0, 0, 0
	spritePiece	-$10, 0, 4, 4, $61, 0, 0, 0, 0
.sz1x2_End

.szrect2x2:	spriteHeader
	spritePiece	-$20, -$1A, 4, 4, $81, 0, 0, 0, 0
	spritePiece	0, -$1A, 4, 4, $81, 0, 0, 0, 0
	spritePiece	-$20, 0, 4, 4, $81, 0, 0, 0, 0
	spritePiece	0, 0, 4, 4, $81, 0, 0, 0, 0
.szrect2x2_End

.szrect1x3:	spriteHeader
	spritePiece	-$10, -$27, 4, 4, $81, 0, 0, 0, 0
	spritePiece	-$10, -$D, 4, 4, $81, 0, 0, 0, 0
	spritePiece	-$10, $D, 4, 4, $81, 0, 0, 0, 0
.szrect1x3_End

.slz:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $21, 0, 0, 0, 0
.slz_End

	even
