; ---------------------------------------------------------------------------
; Sprite mappings - switches (MZ, SYZ, LZ, SBZ)
; ---------------------------------------------------------------------------
Map_But_internal:	mappingsTable
	mappingsTableEntry.w	.up
	mappingsTableEntry.w	.down
	mappingsTableEntry.w	.unused
	mappingsTableEntry.w	.down

.up:	spriteHeader
	spritePiece	-$10, -$B, 2, 2, 0, 0, 0, 0, 0
	spritePiece	0, -$B, 2, 2, 0, 1, 0, 0, 0
.up_End

.down:	spriteHeader
	spritePiece	-$10, -$B, 2, 2, 4, 0, 0, 0, 0
	spritePiece	0, -$B, 2, 2, 4, 1, 0, 0, 0
.down_End

.unused:	spriteHeader
	spritePiece	-$10, -$B, 2, 2, $7FC, 1, 1, 3, 1
	spritePiece	0, -$B, 2, 2, $7FC, 0, 0, 0, 0
.unused_End
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0

	even
