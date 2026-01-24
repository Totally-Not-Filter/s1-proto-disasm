; ---------------------------------------------------------------------------
; Object 21 - SCORE, TIME, RING
; ---------------------------------------------------------------------------

HUD:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	HUD_Index(pc,d0.w),d1
		jmp	HUD_Index(pc,d1.w)
; ===========================================================================
HUD_Index:	dc.w HUD_Main-HUD_Index
		dc.w HUD_Display-HUD_Index
; ===========================================================================

HUD_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$90,obX(a0)
		move.w	#$108,obScreenY(a0)
		move.l	#Map_HUD,obMap(a0)
		move.w	#make_art_tile(ArtTile_HUD,0,0),obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#0,obPriority(a0)

HUD_Display:	; Routine 2
		jmp	(DisplaySprite).l