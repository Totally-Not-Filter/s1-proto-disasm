; ---------------------------------------------------------------------------

TitleText:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_6AE8(pc,d0.w),d1
		jsr	off_6AE8(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_6AE8:	dc.w loc_6AEE-off_6AE8
		dc.w loc_6B1A-off_6AE8
		dc.w locret_6B18-off_6AE8
; ---------------------------------------------------------------------------

loc_6AEE:
		addq.b	#2,obRoutine(a0)
		move.w	#$D0,obX(a0)
		move.w	#$130,obScreenY(a0)
		move.l	#Map_TitleText,obMap(a0)
		move.w	#make_art_tile(ArtTile_Title_Foreground,0,0),obGfx(a0)
		cmpi.b	#2,obFrame(a0)
		bne.s	loc_6B1A
		addq.b	#2,obRoutine(a0)

locret_6B18:
		rts
; ---------------------------------------------------------------------------

loc_6B1A:
		lea	(Ani_PSBTM).l,a1
		bra.w	AnimateSprite