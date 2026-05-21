; ---------------------------------------------------------------------------
; Sprite mappings - points that appear when you destroy something
; ---------------------------------------------------------------------------
Map_Poi_internal:	mappingsTable
	mappingsTableEntry.w	.points_100
	mappingsTableEntry.w	.points_200
	mappingsTableEntry.w	.points_500
	mappingsTableEntry.w	.points_1000

.points_100:	spriteHeader
	spritePiece	-8, -4, 2, 1, 0, 0, 0, 0, 0	; 100 points
.points_100_End

.points_200:	spriteHeader
	spritePiece	-8, -4, 2, 1, 2, 0, 0, 0, 0	; 200 points
.points_200_End

.points_500:	spriteHeader
	spritePiece	-8, -4, 2, 1, 4, 0, 0, 0, 0	; 500 points
.points_500_End

.points_1000:	spriteHeader
	spritePiece	-$C, -4, 3, 1, 6, 0, 0, 0, 0	; 1000 points
.points_1000_End

	even
