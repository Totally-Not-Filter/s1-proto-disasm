Map_LTag_internal:	mappingsTable
	mappingsTableEntry.w	byte_CDAE
	mappingsTableEntry.w	byte_CDC3
	mappingsTableEntry.w	byte_CDD8

byte_CDAE:	spriteHeader
	spritePiece	-$20, -$20, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$10, -$20, 2, 2, $18, 0, 0, 0, 0
	spritePiece	-$20, $10, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$10, $10, 2, 2, $18, 0, 0, 0, 0
byte_CDAE_End

byte_CDC3:	spriteHeader
	spritePiece	-$40, -$20, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$30, -$20, 2, 2, $18, 0, 0, 0, 0
	spritePiece	-$40, $10, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$30, $10, 2, 2, $18, 0, 0, 0, 0
byte_CDC3_End

byte_CDD8:	spriteHeader
	spritePiece	-$80, -$20, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$70, -$20, 2, 2, $18, 0, 0, 0, 0
	spritePiece	-$80, $10, 2, 2, $18, 0, 0, 0, 0
	spritePiece	$70, $10, 2, 2, $18, 0, 0, 0, 0
byte_CDD8_End

	even
