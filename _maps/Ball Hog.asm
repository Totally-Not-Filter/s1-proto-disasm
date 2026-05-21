MapBallhog:	mappingsTable
	mappingsTableEntry.w	byte_7260
	mappingsTableEntry.w	byte_7275
	mappingsTableEntry.w	byte_7285

byte_7260:	spriteHeader
	spritePiece	-$10, -$13, 2, 4, 0, 0, 0, 0, 0
	spritePiece	0, -$13, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-$10, $D, 2, 1, 8, 0, 0, 0, 0
	spritePiece	0, $D, 2, 1, 8, 1, 0, 0, 0
byte_7260_End

byte_7275:	spriteHeader
	spritePiece	-$12, -$14, 2, 4, 0, 0, 0, 0, 0
	spritePiece	-2, -$14, 2, 4, 0, 1, 0, 0, 0
	spritePiece	-$12, $C, 4, 1, $A, 0, 0, 0, 0
byte_7275_End

byte_7285:	spriteHeader
	spritePiece	-$10, -$13, 2, 4, $E, 0, 0, 0, 0
	spritePiece	0, -$13, 2, 4, $E, 1, 0, 0, 0
	spritePiece	-$10, $D, 2, 1, $16, 0, 0, 0, 0
	spritePiece	0, $D, 2, 1, $16, 1, 0, 0, 0
byte_7285_End

	even
