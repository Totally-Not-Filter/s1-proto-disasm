; ===========================================================================
BldSpr_ScrPos:	dc.l 0						; blank
		dc.l v_scrposx&$FFFFFF				; main screen x-position
		dc.l v_bgscrposx&$FFFFFF			; background x-position 1
		dc.l v_bg3scrposx&$FFFFFF			; background x-position 2
; ---------------------------------------------------------------------------
; Subroutine to convert mappings (etc) to proper Megadrive sprites
; ---------------------------------------------------------------------------

BuildSprites:
		lea	(v_spritetablebuffer).w,a2		; set address for sprite table
		moveq	#0,d5
		lea	(v_spritequeue).w,a4
		moveq	#7,d7

.priorityloop:
		tst.w	(a4)					; are there objects left to draw?
		beq.w	.nextpriority				; if not, branch
		moveq	#2,d6

.objloop:
		movea.w	(a4,d6.w),a0				; load object ID
		tst.b	obID(a0)				; if null, branch
		beq.w	.skipobj
		bclr	#sprite_rendered_bit,obRender(a0)

		move.b	obRender(a0),d0
		move.b	d0,d4
		andi.w	#$C,d0					; get drawing coordinates
		beq.s	.scrcoords				; branch if 0 (screen coordinates)
		movea.l	BldSpr_ScrPos(pc,d0.w),a1
	; check object bounds
		moveq	#0,d0
		move.b	obActWid(a0),d0
		move.w	obX(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	.skipobj				; left edge out of bounds
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#320,d1
		bge.s	.skipobj				; right edge out of bounds
		addi.w	#128,d3					; VDP sprites start at 128px

		btst	#sprite_customheight_bit,d4		; is assume height flag on?
		beq.s	.assumeheight				; if yes, branch
		moveq	#0,d0
		move.b	obHeight(a0),d0
		move.w	obY(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	.skipobj				; top edge out of bounds
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#224,d1
		bge.s	.skipobj
		addi.w	#128,d2					; VDP sprites start at 128px
		bra.s	.drawobj
; ===========================================================================

.scrcoords:
		move.w	obScreenY(a0),d2			; special variable for screen Y
		move.w	obX(a0),d3
		bra.s	.drawobj
; ===========================================================================

.assumeheight:
		move.w	obY(a0),d2
		sub.w	4(a1),d2
		addi.w	#128,d2
		cmpi.w	#128-32,d2
		blo.s	.skipobj
		cmpi.w	#128+224+32,d2
		bhs.s	.skipobj

.drawobj:
		movea.l	obMap(a0),a1
		moveq	#0,d1
		btst	#sprite_rawmappings_bit,d4		; is static mappings flag on?
		bne.s	.drawframe				; if yes, branch
		move.b	obFrame(a0),d1
		add.b	d1,d1
		adda.w	(a1,d1.w),a1				; get mappings frame address
		move.b	(a1)+,d1				; number of sprite pieces
		subq.b	#1,d1
		bmi.s	.setvisible

.drawframe:
		bsr.w	BuildSpr_Draw				; write data from sprite pieces to buffer

.setvisible:
		bset	#sprite_rendered_bit,obRender(a0)	; set object as visible

.skipobj:
		addq.w	#2,d6
		subq.w	#2,(a4)					; number of objects left
		bne.w	.objloop

.nextpriority:
		lea	$80(a4),a4
		dbf	d7,.priorityloop
		move.b	d5,(v_spritecount).w
		cmpi.b	#80,d5
		beq.s	.spritelimit
		move.l	#0,(a2)
		rts
; ===========================================================================

.spritelimit:
		move.b	#0,-5(a2)				; set last sprite link
		rts
; End of function BuildSprites

; ===========================================================================

BuildSpr_Draw:
		movea.w	obGfx(a0),a3
		btst	#sprite_xflip_bit,d4
		bne.s	BuildSpr_FlipX
		btst	#sprite_yflip_bit,d4
		bne.w	BuildSpr_FlipY
; End of function BuildSpr_Draw

; ===========================================================================

BuildSpr_Normal:
		cmpi.b	#80,d5		; check sprite limit
		beq.s	.return
		move.b	(a1)+,d0	; get y-offset
		ext.w	d0
		add.w	d2,d0		; add y-position
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,(a2)+	; write sprite size
		addq.b	#1,d5		; increase sprite counter
		move.b	d5,(a2)+	; set as sprite link
		move.b	(a1)+,d0	; get art tile
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0		; add art tile offset
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,d0	; get x-offset
		ext.w	d0
		add.w	d3,d0		; add x-position
		andi.w	#$1FF,d0	; keep within 512px
		bne.s	.writeX
		addq.w	#1,d0

.writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,BuildSpr_Normal	; process next sprite piece

.return:
		rts
; End of function BuildSpr_Normal

; ===========================================================================

BuildSpr_FlipX:
		btst	#sprite_yflip_bit,d4		; is object also y-flipped?
		bne.w	BuildSpr_FlipXY	; if yes, branch

.loop:
		cmpi.b	#80,d5		; check sprite limit
		beq.s	.return
		move.b	(a1)+,d0	; y position
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4	; size
		move.b	d4,(a2)+	
		addq.b	#1,d5		; link
		move.b	d5,(a2)+
		move.b	(a1)+,d0	; art tile
		lsl.w	#8,d0
		move.b	(a1)+,d0	
		add.w	a3,d0
		eori.w	#$800,d0	; toggle flip-x in VDP
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,d0	; get x-offset
		ext.w	d0
		neg.w	d0			; negate it
		add.b	d4,d4		; calculate flipped position by size
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0	; keep within 512px
		bne.s	.writeX
		addq.w	#1,d0

.writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,.loop		; process next sprite piece

.return:
		rts
; ===========================================================================

BuildSpr_FlipY:
		cmpi.b	#80,d5		; check sprite limit
		beq.s	.return
		move.b	(a1)+,d0	; get y-offset
		move.b	(a1),d4		; get size
		ext.w	d0
		neg.w	d0		; negate y-offset
		lsl.b	#3,d4	; calculate flip offset
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0	; add y-position
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,(a2)+	; size
		addq.b	#1,d5
		move.b	d5,(a2)+	; link
		move.b	(a1)+,d0	; art tile
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0	; toggle flip-y in VDP
		move.w	d0,(a2)+
		move.b	(a1)+,d0	; x-position
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	.writeX
		addq.w	#1,d0

.writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,BuildSpr_FlipY	; process next sprite piece

.return:
		rts
; ===========================================================================

BuildSpr_FlipXY:
		cmpi.b	#80,d5		; check sprite limit
		beq.s	.return
		move.b	(a1)+,d0	; calculated flipped y
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+	; write to buffer
		move.b	(a1)+,d4	; size
		move.b	d4,(a2)+	; link
		addq.b	#1,d5
		move.b	d5,(a2)+	; art tile
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0	; toggle flip-x/y in VDP
		move.w	d0,(a2)+
		move.b	(a1)+,d0	; calculate flipped x
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	.writeX
		addq.w	#1,d0

.writeX:
		move.w	d0,(a2)+	; write to buffer
		dbf	d1,BuildSpr_FlipXY	; process next sprite piece

.return:
		rts