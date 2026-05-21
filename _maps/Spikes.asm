; ---------------------------------------------------------------------------
; Sprite mappings - spikes
; ---------------------------------------------------------------------------
Map_Spike_internal:	mappingsTable
	mappingsTableEntry.w	.upright_3
	mappingsTableEntry.w	.sideways_3
	mappingsTableEntry.w	.upright_1
	mappingsTableEntry.w	.upright_3_wide
	mappingsTableEntry.w	.upright_6
	mappingsTableEntry.w	.sideways_1

.upright_3:	spriteHeader
	spritePiece	-$14, -$10, 1, 4, 4, 0, 0, 0, 0	; 3 spikes
	spritePiece	-4, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	$C, -$10, 1, 4, 4, 0, 0, 0, 0
.upright_3_End

.sideways_3:	spriteHeader
	spritePiece	-$10, -$14, 4, 1, 0, 0, 0, 0, 0	; 3 spikes facing sideways
	spritePiece	-$10, -4, 4, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, 0, 0, 0, 0, 0
.sideways_3_End

.upright_1:	spriteHeader
	spritePiece	-4, -$10, 1, 4, 4, 0, 0, 0, 0	; 1 spike
.upright_1_End

.upright_3_wide:	spriteHeader
	spritePiece	-$1C, -$10, 1, 4, 4, 0, 0, 0, 0	; 3 spikes widely spaced
	spritePiece	-4, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	$14, -$10, 1, 4, 4, 0, 0, 0, 0
.upright_3_wide_End

.upright_6:	spriteHeader
	spritePiece	-$40, -$10, 1, 4, 4, 0, 0, 0, 0	; 6 spikes
	spritePiece	-$28, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	-$10, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	8, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	$20, -$10, 1, 4, 4, 0, 0, 0, 0
	spritePiece	$38, -$10, 1, 4, 4, 0, 0, 0, 0
.upright_6_End

.sideways_1:	spriteHeader
	spritePiece	-$10, -4, 4, 1, 0, 0, 0, 0, 0	; 1 spike facing sideways
.sideways_1_End

	even
