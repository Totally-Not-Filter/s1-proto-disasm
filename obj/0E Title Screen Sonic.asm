; ---------------------------------------------------------------------------

TitleSonic:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	TSon_Index(pc,d0.w),d1
		jmp	TSon_Index(pc,d1.w)
; ---------------------------------------------------------------------------
TSon_Index:	dc.w TSon_Main-TSon_Index
		dc.w TSon_Delay-TSon_Index
		dc.w TSon_Move-TSon_Index
		dc.w TSon_Animate-TSon_Index
; ---------------------------------------------------------------------------

TSon_Main:
		addq.b	#2,obRoutine(a0)
		move.w	#$F0,obX(a0)
		move.w	#$DE,obScreenY(a0)
		move.l	#Map_TitleSonic,obMap(a0)
		move.w	#make_art_tile(ArtTile_Title_Sonic,1,0),obGfx(a0)
		move.b	#1,obPriority(a0)
		move.b	#30-1,obDelayAni(a0)
		lea	(Ani_TSon).l,a1
		bsr.w	AnimateSprite

TSon_Delay:
		subq.b	#1,obDelayAni(a0)
		bpl.s	.wait
		addq.b	#2,obRoutine(a0)
		bra.w	DisplaySprite

.wait:
		rts
; ---------------------------------------------------------------------------

TSon_Move:
		subq.w	#8,obScreenY(a0)
		cmpi.w	#150,obScreenY(a0)
		bne.s	.display
		addq.b	#2,obRoutine(a0)

.display:
		bra.w	DisplaySprite

		rts
; ---------------------------------------------------------------------------

TSon_Animate:
		lea	(Ani_TSon).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite

		rts