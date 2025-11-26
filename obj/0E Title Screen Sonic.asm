; ---------------------------------------------------------------------------

TitleSonic:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_6A64(pc,d0.w),d1
		jmp	off_6A64(pc,d1.w)
; ---------------------------------------------------------------------------

off_6A64:	dc.w loc_6A6C-off_6A64, loc_6AA0-off_6A64, loc_6AB0-off_6A64, loc_6AC6-off_6A64
; ---------------------------------------------------------------------------

loc_6A6C:
		addq.b	#2,obRoutine(a0)
		move.w	#$F0,obX(a0)
		move.w	#$DE,obScreenY(a0)
		move.l	#Map_TitleSonic,obMap(a0)
		move.w	#ArtTile_Title_Sonic+1<<13,obGfx(a0)
		move.b	#1,obPriority(a0)
		move.b	#30-1,obDelayAni(a0)
		lea	(Ani_TSon).l,a1
		bsr.w	AnimateSprite

loc_6AA0:
		subq.b	#1,obDelayAni(a0)
		bpl.s	locret_6AAE
		addq.b	#2,obRoutine(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

locret_6AAE:
		rts
; ---------------------------------------------------------------------------

loc_6AB0:
		subq.w	#8,obScreenY(a0)
		cmpi.w	#150,obScreenY(a0)
		bne.s	loc_6AC0
		addq.b	#2,obRoutine(a0)

loc_6AC0:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_6AC6:
		lea	(Ani_TSon).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		rts