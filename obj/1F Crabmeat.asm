; ---------------------------------------------------------------------------

ObjCrabmeat:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_75B8(pc,d0.w),d1
		jmp	off_75B8(pc,d1.w)
; ---------------------------------------------------------------------------

off_75B8:	dc.w loc_75C2-off_75B8, loc_7616-off_75B8, loc_7772-off_75B8, loc_7778-off_75B8, loc_77AE-off_75B8
; ---------------------------------------------------------------------------

loc_75C2:
		move.b	#$10,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Crab,obMap(a0)
		move.w	#make_art_tile(ArtTile_Crabmeat,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#6,obColType(a0)
		move.b	#$15,obActWid(a0)
		bsr.w	ObjectFall
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	locret_7614
		add.w	d1,obY(a0)
		move.b	d3,obAngle(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)

locret_7614:
		rts
; ---------------------------------------------------------------------------

loc_7616:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	off_7632(pc,d0.w),d1
		jsr	off_7632(pc,d1.w)
		lea	(Ani_Crab).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ---------------------------------------------------------------------------

off_7632:	dc.w loc_7636-off_7632, loc_76D4-off_7632
; ---------------------------------------------------------------------------

loc_7636:
		subq.w	#1,objoff_30(a0)
		bpl.s	locret_7670
		tst.b	obRender(a0)
		bpl.s	loc_764A
		bchg	#1,objoff_32(a0)
		bne.s	loc_7672

loc_764A:
		addq.b	#2,ob2ndRout(a0)
		move.w	#128-1,objoff_30(a0)
		move.w	#$80,obVelX(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,obAnim(a0)
		bchg	#0,obStatus(a0)
		bne.s	locret_7670
		neg.w	obVelX(a0)

locret_7670:
		rts
; ---------------------------------------------------------------------------

loc_7672:
		move.w	#60-1,objoff_30(a0)
		move.b	#6,obAnim(a0)
		bsr.w	FindFreeObj
		bne.s	loc_76A8
		_move.b	#id_Crabmeat,obID(a1)
		move.b	#6,obRoutine(a1)
		move.w	obX(a0),obX(a1)
		subi.w	#$10,obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#-$100,obVelX(a1)

loc_76A8:
		bsr.w	FindFreeObj
		bne.s	locret_76D2
		_move.b	#id_Crabmeat,obID(a1)
		move.b	#6,obRoutine(a1)
		move.w	obX(a0),obX(a1)
		addi.w	#$10,obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#$100,obVelX(a1)

locret_76D2:
		rts
; ---------------------------------------------------------------------------

loc_76D4:
		subq.w	#1,objoff_30(a0)
		bmi.s	loc_7728
		bsr.w	SpeedToPos
		bchg	#0,objoff_32(a0)
		bne.s	loc_770E
		move.w	obX(a0),d3
		addi.w	#$10,d3
		btst	#0,obStatus(a0)
		beq.s	loc_76FA
		subi.w	#$20,d3

loc_76FA:
		jsr	(ObjFloorDist2).l
		cmpi.w	#-8,d1
		blt.s	loc_7728
		cmpi.w	#$C,d1
		bge.s	loc_7728
		rts
; ---------------------------------------------------------------------------

loc_770E:
		jsr	(ObjFloorDist).l
		add.w	d1,obY(a0)
		move.b	d3,obAngle(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_7728:
		subq.b	#2,ob2ndRout(a0)
		move.w	#60-1,objoff_30(a0)

loc_7732:
		move.w	#0,obVelX(a0)
		bsr.w	sub_7742
		move.b	d0,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

sub_7742:
		moveq	#0,d0
		move.b	obAngle(a0),d3
		bmi.s	loc_775E
		cmpi.b	#6,d3
		bcs.s	locret_775C
		moveq	#1,d0
		btst	#0,obStatus(a0)
		bne.s	locret_775C
		moveq	#2,d0

locret_775C:
		rts
; ---------------------------------------------------------------------------

loc_775E:
		cmpi.b	#$FA,d3
		bhi.s	locret_7770
		moveq	#2,d0
		btst	#0,obStatus(a0)
		bne.s	locret_7770
		moveq	#1,d0

locret_7770:
		rts
; ---------------------------------------------------------------------------

loc_7772:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

loc_7778:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Crab,obMap(a0)
		move.w	#make_art_tile(ArtTile_Crabmeat,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#8,obActWid(a0)
		move.w	#-$400,obVelY(a0)
		move.b	#7,obAnim(a0)

loc_77AE:
		lea	(Ani_Crab).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectFall
	if FixBugs
		move.w	(v_limitbtm2).w,d0
		addi.w	#224,d0
		cmp.w	obY(a0),d0
		bcs.s	loc_77D0
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		move.w	(v_limitbtm2).w,d0
		addi.w	#224,d0
		cmp.w	obY(a0),d0
		bcs.s	loc_77D0
		rts
	endif
; ---------------------------------------------------------------------------

loc_77D0:
		bra.w	DeleteObject