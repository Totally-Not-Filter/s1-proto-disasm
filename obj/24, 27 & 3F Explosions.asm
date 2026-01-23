; ---------------------------------------------------------------------------

MissileDissolve:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_7102(pc,d0.w),d1
		jmp	off_7102(pc,d1.w)
; ---------------------------------------------------------------------------
off_7102:	dc.w ObjCannonballExplode_Init-off_7102
		dc.w ObjCannonballExplode_Act-off_7102
; ---------------------------------------------------------------------------

ObjCannonballExplode_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#MapCannonballExplode,obMap(a0)
		move.w	#make_art_tile(ArtTile_Missile_Disolve,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#2,obPriority(a0)
		move.b	#0,obColType(a0)
		move.b	#$C,obActWid(a0)
		move.b	#9,obTimeFrame(a0)
		move.b	#0,obFrame(a0)
		move.w	#sfx_A5,d0
		jsr	(QueueSound2).l

ObjCannonballExplode_Act:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	.display
		move.b	#10-1,obTimeFrame(a0)
		addq.b	#1,obFrame(a0)
		cmpi.b	#4,obFrame(a0)
		beq.w	DeleteObject

.display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjExplode:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_7172(pc,d0.w),d1
		jmp	off_7172(pc,d1.w)
; ---------------------------------------------------------------------------
off_7172:	dc.w ObjExplode_Load-off_7172
		dc.w ObjExplode_Init-off_7172
		dc.w ObjExplode_Act-off_7172
; ---------------------------------------------------------------------------

ObjExplode_Load:
		addq.b	#2,obRoutine(a0)
		bsr.w	FindFreeObj
		bne.s	ObjExplode_Init
		_move.b	#id_Animals,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

ObjExplode_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_ExplodeItem,obMap(a0)
		move.w	#make_art_tile(ArtTile_Explosion,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#2,obPriority(a0)
		move.b	#0,obColType(a0)
		move.b	#12,obActWid(a0)
		move.b	#7,obTimeFrame(a0)
		move.b	#0,obFrame(a0)
		move.w	#sfx_BreakItem,d0
		jsr	(QueueSound2).l

ObjExplode_Act:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	.display
		move.b	#8-1,obTimeFrame(a0)
		addq.b	#1,obFrame(a0)
		cmpi.b	#5,obFrame(a0)
		beq.w	DeleteObject

.display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
ObjBombExplode:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_7200(pc,d0.w),d1
		jmp	off_7200(pc,d1.w)
; ---------------------------------------------------------------------------

off_7200:	dc.w ObjBomb_Init-off_7200
		dc.w ObjExplode_Act-off_7200
; ---------------------------------------------------------------------------

ObjBomb_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_ExplodeBomb,obMap(a0)
		move.w	#make_art_tile(ArtTile_Explosion,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#2,obPriority(a0)
		move.b	#0,obColType(a0)
		move.b	#$C,obActWid(a0)
		move.b	#7,obTimeFrame(a0)
		move.b	#0,obFrame(a0)
		move.w	#sfx_Bomb,d0
		jmp	(QueueSound2).l