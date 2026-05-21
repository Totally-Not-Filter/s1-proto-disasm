; ---------------------------------------------------------------------------
; Sprite mappings - "PRESS START BUTTON" from title screen
; ---------------------------------------------------------------------------
Map_PSB_internal:	mappingsTable
	mappingsTableEntry.w	.psb+1	; This is a nasty hack to render the sprite invisible by pointing at a random 00 byte.
	mappingsTableEntry.w	.psb
	mappingsTableEntry.w	.spritemask

.psb:	spriteHeader
	spritePiece	0, 0, 4, 1, $F0, 0, 0, 0, 0	; "PRESS START BUTTON"
	spritePiece	$20, 0, 1, 1, $F3, 0, 0, 0, 0
	spritePiece	$30, 0, 1, 1, $F3, 0, 0, 0, 0
	spritePiece	$38, 0, 4, 1, $F4, 0, 0, 0, 0
	spritePiece	$60, 0, 3, 1, $F8, 0, 0, 0, 0
	spritePiece	$78, 0, 3, 1, $FB, 0, 0, 0, 0
.psb_End

.spritemask:	spriteHeader
	spritePiece	-$80, -$48, 4, 4, 0, 0, 0, 0, 0	; sprite line limiter
	spritePiece	-$80, -$48, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$48, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$48, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$48, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$48, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$48, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$48, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$48, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$48, 4, 4, 0, 0, 0, 0, 0

	spritePiece	-$80, -$28, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$28, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$28, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$28, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$28, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$28, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$28, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$28, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$28, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -$28, 4, 4, 0, 0, 0, 0, 0

	spritePiece	-$80, -8, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -8, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -8, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -8, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -8, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -8, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -8, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -8, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -8, 4, 4, 0, 0, 0, 0, 0
	spritePiece	-$80, -8, 4, 4, 0, 0, 0, 0, 0
.spritemask_End

	even
