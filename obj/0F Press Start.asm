; ---------------------------------------------------------------------------
; Object 0F - "PRESS START BUTTON" from title screen
; ---------------------------------------------------------------------------

PSB:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	PSB_Index(pc,d0.w),d1
		jsr	PSB_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
PSB_Index:	dc.w PSB_Main-PSB_Index
		dc.w PSB_PrsStart-PSB_Index
		dc.w PSB_Exit-PSB_Index
; ===========================================================================

PSB_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$D0,obX(a0)
		move.w	#$130,obScreenY(a0)
		move.l	#Map_PSB,obMap(a0)
		move.w	#make_art_tile(ArtTile_Title_Foreground,0,0),obGfx(a0)
		cmpi.b	#2,obFrame(a0)	; is object meant to hide sonic?
		bne.s	PSB_PrsStart	; if not, branch
		addq.b	#2,obRoutine(a0)

PSB_Exit:
		rts
; ===========================================================================

PSB_PrsStart:	; Routine 4
		lea	(Ani_PSB).l,a1
		bra.w	AnimateSprite	; "PRESS START" is animated