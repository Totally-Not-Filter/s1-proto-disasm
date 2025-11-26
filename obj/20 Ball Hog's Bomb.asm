; ---------------------------------------------------------------------------

ObjCannonball:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_7070(pc,d0.w),d1
		jmp	off_7070(pc,d1.w)
; ---------------------------------------------------------------------------

off_7070:	dc.w ObjCannonball_Init-off_7070, ObjCannonball_Act-off_7070, ObjCannonball_Delete-off_7070
; ---------------------------------------------------------------------------

ObjCannonball_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#MapCannonball,obMap(a0)
		move.w	#make_art_tile(ArtTile_Cannon_Ball,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#8,obActWid(a0)
		move.w	#$18,objoff_30(a0)

ObjCannonball_Act:
		btst	#7,obStatus(a0)
		bne.s	loc_70C2
		tst.w	objoff_30(a0)
		bne.s	loc_70D2
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_70D6
		add.w	d1,obY(a0)

loc_70C2:
		_move.b	#id_MissileDissolve,obID(a0)
		move.b	#0,obRoutine(a0)
		bra.w	ObjCannonballExplode
; ---------------------------------------------------------------------------

loc_70D2:
		subq.w	#1,objoff_30(a0)

loc_70D6:
		bsr.w	ObjectFall
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		move.w	(v_limitbtm2).w,d0
		addi.w	#224,d0
		cmp.w	obY(a0),d0
		bcs.s	ObjCannonball_Delete
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ---------------------------------------------------------------------------

ObjCannonball_Delete:
		bsr.w	DeleteObject
		rts