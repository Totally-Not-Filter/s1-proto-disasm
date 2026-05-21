Map02:	mappingsTable
	mappingsTableEntry.w	byte_4BFA
	mappingsTableEntry.w	byte_4C00
	mappingsTableEntry.w	byte_4C06
	mappingsTableEntry.w	byte_4C30

byte_4BFA:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 0, 0, 0, 0, 1
byte_4BFA_End

byte_4C00:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, $10, 0, 0, 0, 1
byte_4C00_End

byte_4C06:	spriteHeader
	spritePiece	-$10, -$80, 4, 4, $10, 0, 0, 0, 1
	spritePiece	-$10, $60, 4, 4, $10, 0, 0, 0, 1
	spritePiece	-$10, $40, 4, 4, $10, 0, 0, 0, 1
	spritePiece	-$10, $20, 4, 4, $10, 0, 0, 0, 1
	spritePiece	-$10, 0, 4, 4, $10, 0, 0, 0, 1
	spritePiece	-$10, -$20, 4, 4, $10, 0, 0, 0, 1
	spritePiece	-$10, -$40, 4, 4, $10, 0, 0, 0, 1
	spritePiece	-$10, -$60, 4, 4, $10, 0, 0, 0, 1
byte_4C06_End

	even

byte_4C30:	spriteHeader
	spritePiece	-$10, -$80, 4, 4, 0, 0, 0, 0, 1
	spritePiece	-$10, $60, 4, 4, 0, 0, 0, 0, 1
	spritePiece	-$10, $40, 4, 4, 0, 0, 0, 0, 1
	spritePiece	-$10, $20, 4, 4, 0, 0, 0, 0, 1
	spritePiece	-$10, 0, 4, 4, 0, 0, 0, 0, 1
	spritePiece	-$10, -$20, 4, 4, 0, 0, 0, 0, 1
	spritePiece	-$10, -$40, 4, 4, 0, 0, 0, 0, 1
	spritePiece	-$10, -$60, 4, 4, 0, 0, 0, 0, 1
byte_4C30_End

	even
