; ---------------------------------------------------------------------------
; Sprite mappings - helix of spikes on a pole (GHZ)
; ---------------------------------------------------------------------------
Map_Hel_internal:	mappingsTable
	mappingsTableEntry.w	.up
	mappingsTableEntry.w	.up45
	mappingsTableEntry.w	.up90
	mappingsTableEntry.w	.down45
	mappingsTableEntry.w	.down
	mappingsTableEntry.w	.down45bg
	mappingsTableEntry.w	.up45bg+2 ; This is a nasty hack to render the sprite invisible by pointing at a random 00 byte.
	mappingsTableEntry.w	.up45bg

.up:	spriteHeader
	spritePiece	-4, -$10, 1, 2, 0, 0, 0, 0, 0	; points straight up (harmful)
.up_End

.up45:	spriteHeader
	spritePiece	-8, -$B, 2, 2, 2, 0, 0, 0, 0	; 45 degree
.up45_End

.up90:	spriteHeader
	spritePiece	-8, -8, 2, 2, 6, 0, 0, 0, 0	; 90 degree
.up90_End

.down45:	spriteHeader
	spritePiece	-8, -5, 2, 2, $A, 0, 0, 0, 0	; 45 degree
.down45_End

.down:	spriteHeader
	spritePiece	-4, 0, 1, 2, $E, 0, 0, 0, 0	; straight down
.down_End

.down45bg:	spriteHeader
	spritePiece	-3, 4, 1, 1, $10, 0, 0, 0, 0	; 45 degree
.down45bg_End

.up45bg:	spriteHeader
	spritePiece	-3, -$C, 1, 1, $11, 0, 0, 0, 0 ; 45 degree
.up45bg_End

	even
