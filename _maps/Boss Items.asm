Map_BossItems_internal:	mappingsTable
	mappingsTableEntry.w	.chainanchor1
	mappingsTableEntry.w	.chainanchor2
	mappingsTableEntry.w	.cross
	mappingsTableEntry.w	.springentry
	mappingsTableEntry.w	.springcoil
	mappingsTableEntry.w	.springpiece
	mappingsTableEntry.w	.springcoil2
	mappingsTableEntry.w	.spike
	mappingsTableEntry.w	.legmask
	mappingsTableEntry.w	.legs

.chainanchor1:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
.chainanchor1_End

.chainanchor2:	spriteHeader
	spritePiece	-8, -4, 2, 1, 4, 0, 0, 0, 0
.chainanchor2_End

.cross:	spriteHeader
	spritePiece	-4, -4, 1, 1, 6, 0, 0, 0, 0
.cross_End

.springentry:	spriteHeader
	spritePiece	-8, -4, 2, 1, 7, 0, 0, 0, 0
.springentry_End

.springcoil:	spriteHeader
	spritePiece	-8, -8, 2, 2, 9, 0, 0, 0, 0
.springcoil_End

.springpiece:	spriteHeader
	spritePiece	-8, -4, 2, 1, $D, 0, 0, 0, 0
.springpiece_End

.springcoil2:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $F, 0, 0, 0, 0
.springcoil2_End

.spike:	spriteHeader
	spritePiece	-8, -$10, 2, 4, $15, 0, 0, 0, 0
.spike_End

.legmask:	spriteHeader
	spritePiece	-$C, -8, 3, 2, $1D, 0, 0, 0, 0
.legmask_End

.legs:	spriteHeader
	spritePiece	-4, -$10, 3, 4, $23, 0, 0, 0, 0
	spritePiece	-$14, 8, 2, 1, $2F, 0, 0, 0, 0
.legs_End

	even
