; ---------------------------------------------------------------------------

ObjJaws:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_8C70(pc,d0.w),d1
		jsr	off_8C70(pc,d1.w)
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_8C70:	dc.w loc_8C74-off_8C70
		dc.w loc_8CA4-off_8C70
; ---------------------------------------------------------------------------

loc_8C74:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Jaws,obMap(a0)
		move.w	#make_art_tile(ArtTile_Jaws,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$A,obColType(a0)
		move.b	#4,obPriority(a0)
		move.b	#$10,obActWid(a0)
		move.w	#-$40,obVelX(a0)

loc_8CA4:
		lea	(Ani_Jaws).l,a1
		bsr.w	AnimateSprite
		bra.w	SpeedToPos