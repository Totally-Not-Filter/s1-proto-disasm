; ---------------------------------------------------------------------------
; Sprite mappings - Newtron enemy (GHZ)
; ---------------------------------------------------------------------------
Map_Newt_internal:	mappingsTable
	mappingsTableEntry.w	.newt_Trans
	mappingsTableEntry.w	.newt_Norm
	mappingsTableEntry.w	.newt_Fires
	mappingsTableEntry.w	.newt_Drop1
	mappingsTableEntry.w	.newt_Drop2
	mappingsTableEntry.w	.newt_Drop3
	mappingsTableEntry.w	.newt_Fly1a
	mappingsTableEntry.w	.newt_Fly1b
	mappingsTableEntry.w	.newt_Fly2a
	mappingsTableEntry.w	.newt_Fly2b
	mappingsTableEntry.w	.newt_Blank

.newt_Trans:	spriteHeader
	spritePiece	-$14, -$14, 4, 2, 0, 0, 0, 0, 0	; partially visible
	spritePiece	$C, -$C, 1, 1, 8, 0, 0, 0, 0
	spritePiece	-$C, -4, 4, 3, 9, 0, 0, 0, 0
.newt_Trans_End

.newt_Norm:	spriteHeader
	spritePiece	-$14, -$14, 2, 3, $15, 0, 0, 0, 0 ; visible
	spritePiece	-4, -$14, 3, 2, $1B, 0, 0, 0, 0
	spritePiece	-4, -4, 3, 3, $21, 0, 0, 0, 0
.newt_Norm_End

.newt_Fires:	spriteHeader
	spritePiece	-$14, -$14, 2, 3, $2A, 0, 0, 0, 0 ; open mouth, firing
	spritePiece	-4, -$14, 3, 2, $1B, 0, 0, 0, 0
	spritePiece	-4, -4, 3, 3, $21, 0, 0, 0, 0
.newt_Fires_End

.newt_Drop1:	spriteHeader
	spritePiece	-$14, -$14, 2, 3, $30, 0, 0, 0, 0 ; dropping
	spritePiece	-4, -$14, 3, 2, $1B, 0, 0, 0, 0
	spritePiece	-4, -4, 3, 2, $36, 0, 0, 0, 0
	spritePiece	$C, $C, 1, 1, $3C, 0, 0, 0, 0
.newt_Drop1_End

.newt_Drop2:	spriteHeader
	spritePiece	-$14, -$C, 4, 2, $3D, 0, 0, 0, 0
	spritePiece	$C, -4, 1, 1, $20, 0, 0, 0, 0
	spritePiece	-4, 4, 3, 1, $45, 0, 0, 0, 0
.newt_Drop2_End

.newt_Drop3:	spriteHeader
	spritePiece	-$14, -8, 4, 2, $48, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $50, 0, 0, 0, 0
.newt_Drop3_End

.newt_Fly1a:	spriteHeader
	spritePiece	-$14, -8, 4, 2, $48, 0, 0, 0, 0 ; flying
	spritePiece	$C, -8, 1, 2, $50, 0, 0, 0, 0
	spritePiece	$14, -2, 1, 1, $52, 0, 0, 0, 0
.newt_Fly1a_End

.newt_Fly1b:	spriteHeader
	spritePiece	-$14, -8, 4, 2, $48, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $50, 0, 0, 0, 0
	spritePiece	$14, -2, 2, 1, $53, 0, 0, 0, 0
.newt_Fly1b_End

.newt_Fly2a:	spriteHeader
	spritePiece	-$14, -8, 4, 2, $48, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $50, 0, 0, 0, 0
	spritePiece	$14, -2, 1, 1, $52, 0, 0, 3, 1
.newt_Fly2a_End

.newt_Fly2b:	spriteHeader
	spritePiece	-$14, -8, 4, 2, $48, 0, 0, 0, 0
	spritePiece	$C, -8, 1, 2, $50, 0, 0, 0, 0
	spritePiece	$14, -2, 2, 1, $53, 0, 0, 3, 1
.newt_Fly2b_End

.newt_Blank:	spriteHeader
.newt_Blank_End

	even
