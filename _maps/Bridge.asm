; ---------------------------------------------------------------------------
; Sprite mappings - GHZ bridge
; ---------------------------------------------------------------------------
Map_Bri_internal:	mappingsTable
	mappingsTableEntry.w	.bri_Log
	mappingsTableEntry.w	.bri_Stump
	mappingsTableEntry.w	.bri_Rope

.bri_Log:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0	; log
.bri_Log_End

.bri_Stump:	spriteHeader
	spritePiece	-$10, -8, 2, 1, 4, 0, 0, 0, 0	; stump & rope
	spritePiece	-$10, 0, 4, 1, 6, 0, 0, 0, 0
.bri_Stump_End

.bri_Rope:	spriteHeader
	spritePiece	-8, -4, 2, 1, 8, 0, 0, 0, 0	; rope only
.bri_Rope_End

	even
