; ---------------------------------------------------------------------------

ObjMovingPtfm:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_D5FC(pc,d0.w),d1
		jsr	off_D5FC(pc,d1.w)
		out_of_range.w	DeleteObject,objoff_32(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_D5FC:	dc.w loc_D606-off_D5FC
		dc.w loc_D648-off_D5FC
		dc.w loc_D658-off_D5FC

byte_D602:	dc.b $10, 0
		dc.b $20, 1
; ---------------------------------------------------------------------------

loc_D606:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_MBlock,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Block,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	byte_D602(pc,d0.w),a2
		move.b	(a2)+,obActWid(a0)
		move.b	(a2)+,obFrame(a0)
		move.b	#4,obPriority(a0)
		move.w	obX(a0),objoff_32(a0)
		move.w	obY(a0),objoff_30(a0)

loc_D648:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(PlatformObject).l
		bra.w	sub_D674
; ---------------------------------------------------------------------------

loc_D658:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(ExitPlatform).l
		move.w	obX(a0),-(sp)
		bsr.w	sub_D674
		move.w	(sp)+,d2
		jmp	(ptfmSurfaceNormal).l
; ---------------------------------------------------------------------------

sub_D674:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_D688(pc,d0.w),d1
		jmp	off_D688(pc,d1.w)
; ---------------------------------------------------------------------------

off_D688:	dc.w locret_D690-off_D688
		dc.w loc_D692-off_D688
		dc.w loc_D6B2-off_D688
		dc.w loc_D6C0-off_D688
; ---------------------------------------------------------------------------

locret_D690:
		rts
; ---------------------------------------------------------------------------

loc_D692:
		move.b	(v_oscillate+$E).w,d0
		subi.b	#$60,d1
		btst	#0,obStatus(a0)
		beq.s	loc_D6A6
		neg.w	d0
		add.w	d1,d0

loc_D6A6:
		move.w	objoff_32(a0),d1
		sub.w	d0,d1
		move.w	d1,obX(a0)
		rts
; ---------------------------------------------------------------------------

loc_D6B2:
		cmpi.b	#4,obRoutine(a0)
		bne.s	locret_D6BE
		addq.b	#1,obSubtype(a0)

locret_D6BE:
		rts
; ---------------------------------------------------------------------------

loc_D6C0:
		moveq	#0,d3
		move.b	obActWid(a0),d3
		bsr.w	ObjHitWallRight
		tst.w	d1
		bmi.s	loc_D6DA
		addq.w	#1,obX(a0)
		move.w	obX(a0),objoff_32(a0)
		rts
; ---------------------------------------------------------------------------

loc_D6DA:
		clr.b	obSubtype(a0)
		rts