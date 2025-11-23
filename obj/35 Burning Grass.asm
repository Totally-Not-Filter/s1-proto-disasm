; ---------------------------------------------------------------------------

ObjFloorLavaball:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_91F2(pc,d0.w),d1
		jmp	off_91F2(pc,d1.w)
; ---------------------------------------------------------------------------

off_91F2:	dc.w loc_91F8-off_91F2, loc_9240-off_91F2, loc_92BA-off_91F2
; ---------------------------------------------------------------------------

loc_91F8:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Fire,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Fireball,0,0),obGfx(a0)
		move.w	obX(a0),objoff_2A(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obPriority(a0)
		move.b	#$8B,obColType(a0)
		move.b	#8,obActWid(a0)
		move.w	#sfx_Burning,d0
		jsr	(QueueSound2).l
		tst.b	obSubtype(a0)
		beq.s	loc_9240
		addq.b	#2,obRoutine(a0)
		bra.w	loc_92BA
; ---------------------------------------------------------------------------

loc_9240:
		movea.l	objoff_30(a0),a1
		move.w	obX(a0),d1
		sub.w	objoff_2A(a0),d1
		addi.w	#$C,d1
		move.w	d1,d0
		lsr.w	#1,d0
		move.b	(a1,d0.w),d0
		neg.w	d0
		add.w	objoff_2C(a0),d0
		move.w	d0,d2
		add.w	objoff_3C(a0),d0
		move.w	d0,obY(a0)
		cmpi.w	#$84,d1
		bcc.s	loc_92B8
		addi.l	#$10000,obX(a0)
		cmpi.w	#$80,d1
		bcc.s	loc_92B8
		move.l	obX(a0),d0
		addi.l	#$80000,d0
		andi.l	#$FFFFF,d0
		bne.s	loc_92B8
		bsr.w	FindNextFreeObj
		bne.s	loc_92B8
		_move.b	#id_GrassFire,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	d2,objoff_2C(a1)
		move.w	objoff_3C(a0),objoff_3C(a1)
		move.b	#1,obSubtype(a1)
		movea.l	objoff_38(a0),a2
		bsr.w	sub_90A4

loc_92B8:
		bra.s	loc_92C6
; ---------------------------------------------------------------------------

loc_92BA:
		move.w	objoff_2C(a0),d0
		add.w	objoff_3C(a0),d0
		move.w	d0,obY(a0)

loc_92C6:
		lea	(Ani_GFire).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite