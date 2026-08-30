; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to show the special stage layout
; ---------------------------------------------------------------------------

SS_ShowLayout:
		bsr.w	SS_AnimateBlocks			; animate walls, rings, and other blocks
		bsr.w	SS_ExecuteAnimationQueue		; animate queued events for touched blocks
; ---------------------------------------------------------------------------

	; --- Calculate the rotated position of the layout grid ---
		move.w	d5,-(sp)				; backup sprites rendered in BuildSprites (which is called before SS_ShowLayout)

		lea	(v_ss_rotationmatrix).w,a1		; set start of rotation buffer (each entry is two words per cell, X/Y axis)
		move.b	(v_ssangle).w,d0			; get current angle of the special stage rotation
		andi.b	#$FC,d0					; snap to nearest multiple of 4 to match stage rotation
		jsr	(CalcSine).l				; get sine and cosine values based on angle
		move.w	d0,d4					; backup sine result
		move.w	d1,d5					; backup cosine result
		muls.w	#ss_blocksize,d4			; d4 = X-rotation delta after each cell
		muls.w	#ss_blocksize,d5			; d5 = Y-rotation delta after each cell

		moveq	#0,d2
		move.w	(v_screenposx).w,d2			; get current camera X-position
		divu.w	#ss_blocksize,d2			; divide camera X-position by block size
		swap	d2					; get remainder (modulo part)
		neg.w	d2					; make remainder negative
		addi.w	#-(ss_matrixsize-1)*ss_blocksize/2,d2	; d2 = base X-offset for all cells (-$B4)

		moveq	#0,d3
		move.w	(v_screenposy).w,d3			; get current camera Y-position
		divu.w	#ss_blocksize,d3			; divide camera X-position by block size
		swap	d3					; get remainder (modulo part)
		neg.w	d3					; make remainder negative
		addi.w	#-(ss_matrixsize-1)*ss_blocksize/2,d3	; d3 = base Y-offset for all cells (-$B4)

		move.w	#ss_matrixsize-1,d7			; calculate rotated positions for all rows
	.rotateRows:
		movem.w	d0-d2,-(sp)				; backup sine, cosine, and X offset per row

		movem.w	d0-d1,-(sp)				; backup sine and cosine
		neg.w	d0					; negate sine for X-rotation term
		muls.w	d2,d1					; X * cos
		muls.w	d3,d0					; Y * -sin
		move.l	d0,d6					; copy
		add.l	d1,d6					; d6 = rotated X-position
		movem.w	(sp)+,d0-d1				; restore sine and cosine
		muls.w	d2,d0					; X * sin
		muls.w	d3,d1					; Y * cos
		add.l	d0,d1					; d1 = rotated Y-position
		move.l	d6,d2					; d2 = rotated X-position

		move.w	#ss_matrixsize-1,d6			; calculate rotated positions for all cells in this row
	.rotateCellsInRow:
		move.l	d2,d0					; get X-position
		asr.l	#8,d0					; shift down a byte
		move.w	d0,(a1)+				; write rotated X-position for cell
		move.l	d1,d0					; get Y-position
		asr.l	#8,d0					; shift down a byte
		move.w	d0,(a1)+				; write rotated Y-position for cell
		add.l	d5,d2					; increase Y-position by cosine Y-delta for next cell
		add.l	d4,d1					; increase Y-position by sine X-delta for next cell
		dbf	d6,.rotateCellsInRow			; loop until all cells for this row have been calculated

		movem.w	(sp)+,d0-d2				; restore sine, cosine, and X offset for next row

		addi.w	#ss_blocksize,d3			; increase base Y-position by block height
		dbf	d7,.rotateRows				; loop until all rows have been calculated

		move.w	(sp)+,d5				; restore number of rendered sprites in BuildSprites

	; --- Insert block types into rotated grid and render them as sprites ---
		lea	(v_sslayout_base).l,a0			; get base pointer for stage layout

		moveq	#0,d0
		move.w	(v_screenposy).w,d0			; get current camera Y-position
		divu.w	#ss_blocksize,d0			; divide camera Y-position by block size
		mulu.w	#ss_layout_rowlength,d0			; multiply by length of rows
		adda.l	d0,a0					; a0 = first row to be rendered

		moveq	#0,d0
		move.w	(v_screenposx).w,d0			; get current camera X-position
		divu.w	#ss_blocksize,d0			; divide camera X-position by block size
		adda.w	d0,a0					; a0 = first row and cell to be rendered

		lea	(v_ss_rotationmatrix).w,a4		; get calculated results in rotation matrix
		move.w	#ss_matrixsize-1,d7			; render 16 rows
	.loopAllRows:
		move.w	#ss_matrixsize-1,d6			; render 16 blocks per row
	.loopRow:
		moveq	#0,d0
		move.b	(a0)+,d0				; get next block ID
		beq.s	.nextBlock				; if it's a blank block, branch

		move.w	(a4),d3					; get rotated X-position for this cell
		addi.w	#128+(320/2),d3				; d3 = sprite X-position
		cmpi.w	#128-16,d3				; is sprite offscreen to the left?
		blo.s	.nextBlock				; if yes, skip drawing
		cmpi.w	#128+320+16,d3				; is sprite offscreen to the right?
		bhs.s	.nextBlock				; if yes, skip drawing

		move.w	2(a4),d2				; get rotated Y-position for this cell
		addi.w	#128+(224/2),d2				; d2 = sprite Y-position
		cmpi.w	#128-16,d2				; is sprite offscreen to the top?
		blo.s	.nextBlock				; if yes, skip drawing
		cmpi.w	#128+224+16,d2				; is sprite offscreen to the bottom?
		bhs.s	.nextBlock				; if yes, skip drawing

		lea	(v_ss_spritesettings).l,a5		; load block definitions array
		lsl.w	#3,d0					; multiply by 8 bytes per entry
		lea	(a5,d0.w),a5				; get data for block ID
		movea.l	(a5)+,a1				; get mappings pointer
		move.w	(a5)+,d1				; get frame ID
		add.w	d1,d1					; double for word-based indexing
		adda.w	(a1,d1.w),a1				; get mappings for current frame
		movea.w	(a5)+,a3				; get art tile / VRAM settings
		moveq	#1-1,d1					; write 1 sprite piece by default
		move.b	(a1)+,d1				; get number of sprite pieces in frame
		subq.b	#1,d1					; subtract 1 for dbf
		bmi.s	.nextBlock				; if result underflowed, this is was blank frame mapping, branch
		jsr	(BuildSpr_Normal).l			; write data from sprite pieces to buffer (never flipped)

	.nextBlock:
		addq.w	#4,a4					; advance to next entry in rotation matrix
		dbf	d6,.loopRow				; loop until all blocks in row have been rendered
		lea	spritelayer_size-ss_matrixsize(a0),a0	; advance to next row ($80 bytes - 16 bytes that were already advanced)
		dbf	d7,.loopAllRows				; loop until all rows were rendered

		move.b	d5,(v_spritecount).w			; write total number of rendered sprites to debug value

		cmpi.b	#sprites_max,d5				; check sprite limit (Mega Drive can only handle 80 at a time)
		beq.s	.spriteLimit				; if all sprite slots are taken up, abort process

		move.l	#0,(a2)					; unlink last sprite
		rts
; ---------------------------------------------------------------------------

	.spriteLimit:
		move.b	#0,-5(a2)				; unlink penultimate sprite
		rts
; End of function SS_ShowLayout


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate blocks (walls, rings, etc.) in the Special Stage
; ---------------------------------------------------------------------------

; SS_AniWallsRings:
SS_AnimateBlocks:
	; --- Rotate square walls ---
		lea	(v_ss_spritesettings+8+5-1).l,a1	; load sprite settings array, skip blank and target frame ID (word, +5-1)
		moveq	#0,d0
		move.b	(v_ssangle).w,d0			; get current rotation angle
		lsr.b	#2,d0					; divide by 4 (walls are snapped to multiples of 4 degrees)
		andi.w	#$F,d0					; limit to 16 rotations
		moveq	#id_SS_WallPink_4-1,d1			; rotate all wall blocks (id_SS_WallPink_4 = last one = $10)
	.rotateWalls:
		move.w	d0,(a1)					; set new frame ID to rotated one
		addq.w	#8,a1					; advance to next wall sprite setting
		dbf	d1,.rotateWalls				; loop until all walls have been rotated

	; --- Animate rings (8 frames) ---
		subq.b	#1,(v_ani1_time).w			; decrement delay until ring animation needs to update
		bpl.s	.updateRingFrame			; if time remains, branch
		move.b	#8-1,(v_ani1_time).w			; reset delay
		addq.b	#1,(v_ani1_frame).w			; advance frame ID
		andi.b	#3,(v_ani1_frame).w			; wrap around every 8 frames
	.updateRingFrame:
		move.b	(v_ani1_frame).w,1(a1)			; set new ring frame ID

		addq.w	#8,a1					; advance to bumper sprite
		addq.w	#8,a1					; advance to goal sprite

	; --- Animate various other blocks (2 frames) ---
		subq.b	#1,(v_ani2_time).w			; decrement delay until frames need to update
		bpl.s	.updateAlternatingFrames		; if time remains, branch
		move.b	#8-1,(v_ani2_time).w			; reset delay
		bra.s	.updateAlternatingFrames		; branch to skip the frame progression code below
		addq.b	#1,(v_ani2_frame).w			; advance frame ID
		andi.b	#1,(v_ani2_frame).w			; alternate between only two frames
	.updateAlternatingFrames:
		move.b	(v_ani2_frame).w,1(a1)			; animate goal blocks
		addq.w	#8,a1					; advance to red goal sprite
		move.b	(v_ani2_frame).w,1(a1)			; animate red goal blocks

	; ---  Animate wall palette cycle (unlike the other animations above, this affects VRAM settings instead of frame ID) ---
		subq.b	#1,(v_ani0_time).w			; decrement delay until wall palettes need to update
		bpl.s	.updateWallPalettes			; if time remains, branch
		move.b	#8-1,(v_ani0_time).w			; reset delay
		subq.b	#1,(v_ani0_frame).w			; advance frame ID (backwards)
		andi.b	#3,(v_ani0_frame).w			; wrap around every 4 frames
	.updateWallPalettes:
		lea	(v_ss_spritesettings+8+8+8+8+8+6).l,a1	; load sprite settings array, skip blank, first, second, third, and fouth wall and target VRAM settings (word, +6)
		lea	(SS_Wall_Palettes_VRAM).l,a0		; load wall VRAM settings, containing the palette line bits
		moveq	#0,d0
		move.b	(v_ani0_frame).w,d0			; get current frame
		add.w	d0,d0					; double for word-based indexing
		lea	(a0,d0.w),a0				; jump to current start in VRAM settings array

	rept 2	; Repeated two times to account for the four sets of walls (blue, yellow, green, pink)
		move.w	$0(a0),8*0(a1)				; update wall 1
		move.w	$2(a0),8*1(a1)				; update wall 2
		move.w	$4(a0),8*2(a1)				; update wall 3
		move.w	$6(a0),8*3(a1)				; update wall 4

		adda.w	#$10,a0					; advance to next set of VRAM settings for next wall set
		adda.w	#8*4,a1					; advance to next set of walls (0 walls are skipped, thus never changing palette)
	endr

		move.w	$0(a0),8*0(a1)				; update wall 1
		move.w	$2(a0),8*1(a1)				; update wall 2
		move.w	$4(a0),8*2(a1)				; update wall 3
		move.w	$6(a0),8*3(a1)				; update wall 4

		rts

; ---------------------------------------------------------------------------
; Palette cycle data for square blocks in Special Stages.
; - Four sets for the four wall types. Each set has same blinking pattern:
;   nBnnnnnB twice (n = normal palette, B = blinking palette)
; - Blinking palette line is the one before the normal one (i.e. -1)
; - All values are technically complete VRAM settings with the art tile,
;   but the only difference between each value is the palette line
; ---------------------------------------------------------------------------

sswallpal: macro paletteline,paletteline2
	set normal, ArtTile_SS_Wall|(paletteline<<13)
	set blink,  ArtTile_SS_Wall|(((paletteline2)&3)<<13)

	dc.w normal, normal, normal,  blink
	dc.w normal, normal, normal,  normal
	endm

; SS_WaRiVramSet:
SS_Wall_Palettes_VRAM:
		sswallpal 0,1	; blue walls
		sswallpal 1,0	; yellow walls
		sswallpal 2,1	; green walls
		sswallpal 3,1	; pink walls
		even
; End of function SS_AnimateBlocks


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	find a free slot in the Special Stage sprite update list,
; used to animate blocks collected/touched by Sonic.
; ---------------------------------------------------------------------------

; SS_RemoveCollectedItem: <-- old misnomer
SS_FindFreeAnimationSlot:
		lea	(v_ss_animations).l,a2			; address of sprite update list
		move.w	#(v_ss_animations_end-v_ss_animations)/8-1,d0 ; up to $20 slots

	.loop:
		tst.b	(a2)					; is slot free?
		beq.s	.return					; if yes, exit with it
		addq.w	#8,a2					; go to next slot
		dbf	d0,.loop				; try again

	.return:
		rts						; return with slot in a2
; End of function SS_FindFreeAnimationSlot


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate special stage items when you touch them.
; This system uses a buffer of animation events that are added through the
; above SS_FindFreeAnimationSlot subroutine.
; 
; Each slot is 8 bytes in size, broken down like so:
;	0   - animation ID (1-based; zero implies empty slot)
;	1   - (unused)
;	2   - frame delay between animation advancements
;	3   - current index ID in animation script
;	4-7 - RAM location of target block in stage layout
; ---------------------------------------------------------------------------
ss_ani_id:	equ 0
ss_ani_delay:	equ 2
ss_ani_frame:	equ 3
ss_ani_block:	equ 4
; ---------------------------------------------------------------------------

; SS_AniItems:
SS_ExecuteAnimationQueue:
		lea	(v_ss_animations).l,a0			; load start address of animation event buffer
		move.w	#(v_ss_animations_end-v_ss_animations)/8-1,d7 ; set to iterate through all slots

	.loop:
		moveq	#0,d0
		move.b	ss_ani_id(a0),d0			; get potential animation event
		beq.s	.nextslot				; if slot has none, branch
		lsl.w	#2,d0					; multiply ID by 4 for long-based indexing
		movea.l	SS_AniIndex-4(pc,d0.w),a1		; get animation entry in jump table (-4 because these IDs are 1-based)
		jsr	(a1)					; execute animation and return

	.nextslot:
		addq.w	#8,a0					; go to next animation event slot
		dbf	d7,.loop				; loop until all event slots were checked
		rts

; ===========================================================================
SS_AniIndex:
		dc.l	SS_AniRingSparks			; animation ID 1
		dc.l	SS_AniBumper				; animation ID 2
; ===========================================================================

SS_AniRingSparks:
		subq.b	#1,ss_ani_delay(a0)			; decrement delay until next animation advancement
		bpl.s	.return					; if time remains, branch
		move.b	#5,ss_ani_delay(a0)			; reset delay

		moveq	#0,d0
		move.b	ss_ani_frame(a0),d0			; get current frame index in animation script
		addq.b	#1,ss_ani_frame(a0)			; advance to next frame index
		movea.l	ss_ani_block(a0),a1			; get location of block in RAM
		move.b	SS_AniRingData(pc,d0.w),d0		; retrieve new block ID from animation script
		move.b	d0,(a1)					; update block in layout
		bne.s	.return					; if animation isn't finished, branch

		clr.l	(a0)					; clear animation event slot
		clr.l	ss_ani_block(a0)			; ''

	.return:
		rts
; ===========================================================================
SS_AniRingData:	dc.b id_SS_Ring_Ani1, id_SS_Ring_Ani2, id_SS_Ring_Ani3, id_SS_Ring_Ani4, 0
		even
; ===========================================================================

SS_AniBumper:
		subq.b	#1,ss_ani_delay(a0)			; decrement delay until next animation advancement
		bpl.s	.return					; if time remains, branch
		move.b	#7,ss_ani_delay(a0)			; reset delay

		moveq	#0,d0
		move.b	ss_ani_frame(a0),d0			; get current frame index in animation script
		addq.b	#1,ss_ani_frame(a0)			; advance to next frame index
		movea.l	ss_ani_block(a0),a1			; get location of block in RAM
		move.b	SS_AniBumpData(pc,d0.w),d0		; retrieve new block ID from animation script
		bne.s	.animating				; if animation isn't finished, branch

		clr.l	(a0)					; clear animation event slot
		clr.l	ss_ani_block(a0)			; ''

		move.b	#id_SS_Bumper,(a1)			; reset bumper block to default idle one
		rts
; ---------------------------------------------------------------------------

	.animating:
		move.b	d0,(a1)					; update block in layout

	.return:
		rts
; ===========================================================================
SS_AniBumpData:	dc.b id_SS_Bumper_Ani1, id_SS_Bumper_Ani2, id_SS_Bumper_Ani1, id_SS_Bumper_Ani2, 0
		even
; ===========================================================================

; End of function SS_AniItems


; ---------------------------------------------------------------------------
; Subroutine to load special stage layout
; ---------------------------------------------------------------------------

SS_Load:
	; --- Fully clear target layout buffer ---
		lea	(v_sslayout_base).l,a1			; set start address of layout RAM
		move.w	#(v_ss_spritesettings-v_sslayout_base)/4-1,d0 ; clear the entire layout buffer
	.clearLayoutBuffer:
		clr.l	(a1)+					; clear four bytes
		dbf	d0,.clearLayoutBuffer			; loop until buffer has been cleared

	; --- Copy layout to the final buffer, inserting $40 bytes of padding per row ---
		lea	(v_sslayout_actual).l,a1		; set target layout destination after padding
		lea	(SS_1).l,a0				; load layout data
		moveq	#(v_sslayout_end-v_sslayout_actual)/ss_layout_rowlength-1,d1 ; transfer the full layout
	.copyAllRows:
		moveq	#(ss_layout_rows)/4-1,d2		; set to transfer one row ($40 bytes of actual data)
	.copyRow:
		move.l	(a0)+,(a1)+				; transfer one cell to final layout buffer
		dbf	d2,.copyRow				; loop until row has been transferred
		lea	ss_layout_rowlength-ss_layout_rows(a1),a1 ; advance to next row ($40 bytes of padding)
		dbf	d1,.copyAllRows				; loop until all rows have been transferred

	; --- Load all sprite settings from SS_MapIndex into v_ss_spritesettings ---
		lea	(v_ss_spritesettings+8).l,a1		; skip first entry (for block $00 / blank)
		lea	(SS_MapIndex).l,a0			; load block sprite info definitions
		moveq	#(SS_MapIndex_End-SS_MapIndex)/6-1,d1	; load all entries in definitions list
	.loadSpriteSettings:
		move.l	(a0)+,(a1)+				; copy frame ID and mappings pointer
		move.w	#0,(a1)+				; prepare two empty bytes (upper one remains unused)
		move.b	-4(a0),-1(a1)				; copy frame ID to lower byte
		move.w	(a0)+,(a1)+				; load VRAM settings (palette and art tile)
		dbf	d1,.loadSpriteSettings			; loop until all sprite settings have been loaded

	; --- Fully clear animations processing queue ---
		lea	(v_ss_animations).l,a1			; set start address of animations queue
		move.w	#(v_ss_animations_end-v_ss_animations)/4-1,d1 ; clear the entire queue
	.clearAnimationQueue:
		clr.l	(a1)+					; clear four bytes
		dbf	d1,.clearAnimationQueue			; loop until queue has been cleared

		rts
; End of function SS_Load
