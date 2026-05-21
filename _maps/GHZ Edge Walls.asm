; ---------------------------------------------------------------------------
; Sprite mappings - walls (GHZ)
; ---------------------------------------------------------------------------
Map_Edge_internal:	mappingsTable
	mappingsTableEntry.w	.edge_Shadow
	mappingsTableEntry.w	.edge_Light
	mappingsTableEntry.w	.edge_Dark

.edge_Shadow:	spriteHeader
	spritePiece	-8, -$20, 2, 2, 4, 0, 0, 0, 0	; light with shadow
	spritePiece	-8, -$10, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 2, 8, 0, 0, 0, 0
.edge_Shadow_End

.edge_Light:	spriteHeader
	spritePiece	-8, -$20, 2, 2, 8, 0, 0, 0, 0	; light with no shadow
	spritePiece	-8, -$10, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 2, 8, 0, 0, 0, 0
.edge_Light_End

.edge_Dark:	spriteHeader
	spritePiece	-8, -$20, 2, 2, 0, 0, 0, 0, 0	; all shadow
	spritePiece	-8, -$10, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 2, 0, 0, 0, 0, 0
	spritePiece	-8, $10, 2, 2, 0, 0, 0, 0, 0
.edge_Dark_End

	even
