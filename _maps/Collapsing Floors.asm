; ---------------------------------------------------------------------------
; Sprite mappings - collapsing floors (MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------
Map_CFlo_internal:	mappingsTable
	mappingsTableEntry.w	.leftfacing
	mappingsTableEntry.w	.rightfacing
	mappingsTableEntry.w	.leftsmash
	mappingsTableEntry.w	.rightsmash

.leftfacing:	spriteHeader
	spritePiece	-$20, -8, 4, 2, 0, 0, 0, 0, 0	; MZ and SBZ blocks
	spritePiece	-$20, 8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, 8, 4, 2, 0, 0, 0, 0, 0
.leftfacing_End

.rightfacing:	spriteHeader
	spritePiece	-$20, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$20, 8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, 8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, 8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$10, 8, 2, 2, 0, 0, 0, 0, 0
.rightfacing_End

.leftsmash:	spriteHeader
	spritePiece	-$20, -8, 4, 2, 0, 0, 0, 0, 0	; SLZ blocks
	spritePiece	-$20, 8, 4, 2, 8, 0, 0, 0, 0
	spritePiece	0, -8, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, 8, 4, 2, 8, 0, 0, 0, 0
.leftsmash_End

.rightsmash:	spriteHeader
	spritePiece	-$20, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-$10, -8, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -8, 2, 2, 0, 0, 0, 0, 0
	spritePiece	$10, -8, 2, 2, 4, 0, 0, 0, 0
	spritePiece	-$20, 8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$10, 8, 2, 2, $C, 0, 0, 0, 0
	spritePiece	0, 8, 2, 2, 8, 0, 0, 0, 0
	spritePiece	$10, 8, 2, 2, $C, 0, 0, 0, 0
.rightsmash_End

	even
