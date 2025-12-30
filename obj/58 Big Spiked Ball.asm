; ---------------------------------------------------------------------------

ObjGiantSpikedBalls:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ObjGiantBalls_Index(pc,d0.w),d1
		jmp	ObjGiantBalls_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjGiantBalls_Index:dc.w ObjGiantBalls_Init-ObjGiantBalls_Index
		dc.w ObjGiantBalls_Move-ObjGiantBalls_Index
; ---------------------------------------------------------------------------

ObjGiantBalls_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_BBall,obMap(a0)
		move.w	#make_art_tile(ArtTile_SZ_Big_Spikeball,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.w	obX(a0),objoff_3A(a0)
		move.w	obY(a0),objoff_38(a0)
		move.b	#$86,obColType(a0)
		move.b	obSubtype(a0),d1
		andi.b	#$F0,d1
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,objoff_3E(a0)
		move.b	obStatus(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,obAngle(a0)
		move.b	#$50,objoff_3C(a0)

ObjGiantBalls_Move:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	ObjGiantBalls_TypeIndex(pc,d0.w),d1
		jsr	ObjGiantBalls_TypeIndex(pc,d1.w)
		out_of_range.w	DeleteObject,objoff_3A(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjGiantBalls_TypeIndex:
		dc.w ObjGiantBalls_Type00-ObjGiantBalls_TypeIndex
		dc.w ObjGiantBalls_Type01-ObjGiantBalls_TypeIndex
		dc.w ObjGiantBalls_Type02-ObjGiantBalls_TypeIndex
		dc.w ObjGiantBalls_Type03-ObjGiantBalls_TypeIndex
; ---------------------------------------------------------------------------

ObjGiantBalls_Type00:
		rts
; ---------------------------------------------------------------------------

ObjGiantBalls_Type01:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(v_oscillate+$E).w,d0
		btst	#0,obStatus(a0)
		beq.s	loc_DED6
		neg.w	d0
		add.w	d1,d0

loc_DED6:
		move.w	objoff_3A(a0),d1
		sub.w	d0,d1
		move.w	d1,obX(a0)
		rts
; ---------------------------------------------------------------------------

ObjGiantBalls_Type02:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(v_oscillate+$E).w,d0
		btst	#0,obStatus(a0)
		beq.s	loc_DEFA
		neg.w	d0
		addi.w	#$80,d0

loc_DEFA:
		move.w	objoff_38(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

ObjGiantBalls_Type03:
		move.w	objoff_3E(a0),d0
		add.w	d0,obAngle(a0)
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		move.w	objoff_38(a0),d2
		move.w	objoff_3A(a0),d3
		moveq	#0,d4
		move.b	objoff_3C(a0),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,obY(a0)
		move.w	d5,obX(a0)
		rts