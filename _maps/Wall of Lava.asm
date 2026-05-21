; ---------------------------------------------------------------------------
; Sprite mappings - advancing wall of lava (MZ)
; ---------------------------------------------------------------------------
Map_LWall_internal:	mappingsTable
	mappingsTableEntry.w	.lava0
	mappingsTableEntry.w	.lava1
	mappingsTableEntry.w	.lava2
	mappingsTableEntry.w	.lava3
	mappingsTableEntry.w	.lava_back

.lava0:	spriteHeader
	spritePiece	$20, -$20, 4, 4, $60, 0, 0, 0, 0
	spritePiece	$3C, 0, 4, 4, $70, 0, 0, 0, 0
	spritePiece	$20, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	0, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	0, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$20, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$20, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$40, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$40, 0, 4, 4, $72A, 1, 1, 3, 1
.lava0_End

.lava1:	spriteHeader
	spritePiece	$20, -$20, 4, 4, $70, 0, 0, 0, 0
	spritePiece	$3C, 0, 4, 4, $80, 0, 0, 0, 0
	spritePiece	$20, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	0, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	0, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$20, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$20, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$40, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$40, 0, 4, 4, $72A, 1, 1, 3, 1
.lava1_End

.lava2:	spriteHeader
	spritePiece	$20, -$20, 4, 4, $80, 0, 0, 0, 0
	spritePiece	$3C, 0, 4, 4, $70, 0, 0, 0, 0
	spritePiece	$20, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	0, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	0, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$20, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$20, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$40, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$40, 0, 4, 4, $72A, 1, 1, 3, 1
.lava2_End

.lava3:	spriteHeader
	spritePiece	$20, -$20, 4, 4, $70, 0, 0, 0, 0
	spritePiece	$3C, 0, 4, 4, $60, 0, 0, 0, 0
	spritePiece	$20, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	0, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	0, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$20, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$20, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$40, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$40, 0, 4, 4, $72A, 1, 1, 3, 1
.lava3_End

.lava_back:	spriteHeader
	spritePiece	$20, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	$20, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	0, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	0, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$20, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$20, 0, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$40, -$20, 4, 4, $72A, 1, 1, 3, 1
	spritePiece	-$40, 0, 4, 4, $72A, 1, 1, 3, 1
.lava_back_End

	even
