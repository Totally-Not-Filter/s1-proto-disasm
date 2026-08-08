; ---------------------------------------------------------------------------
; Object 2A - Edge Door (Unused in GHZ)
; ---------------------------------------------------------------------------

Obj2A:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	.index(pc,d0.w),d1
		jmp	.index(pc,d1.w)
; ===========================================================================
.index:
		dc.w	.init-.index
		dc.w	.chkpress-.index
		dc.w	.display-.index
; ===========================================================================

.init:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Edge_Door,obMap(a0)
		move.w	#ArtTile_Level,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	obY(a0),d0
		subi.w	#32,d0
		move.w	d0,objoff_30(a0)
		move.b	#11,obActWid(a0)
		move.b	#5,obPriority(a0)
		tst.b	obSubtype(a0)
		beq.s	.chkpress
		move.b	#1,obFrame(a0)
		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a0)
		move.b	#4,obPriority(a0)
		addq.b	#2,obRoutine(a0)

.chkpress:	; Routine 2
		tst.w	(f_switch).w
		beq.s	.notpressed
		subq.w	#1,obY(a0)
		move.w	objoff_30(a0),d0
		cmp.w	obY(a0),d0
		beq.w	DeleteObject

.notpressed:
		move.w	#22,d1
		move.w	#16,d2
		bsr.w	Obj44_SolidWall

.display:	; Routine 4
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ===========================================================================

Obj44_SolidWall:
		tst.w	(v_debuguse).w
		bne.w	locret_69A6
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	locret_69A6
		bsr.w	Obj44_SolidWall2
		beq.s	loc_698C
		bmi.w	loc_69A8
		tst.w	d0
		beq.w	loc_6976
		bmi.s	loc_6960
		tst.w	obVelX(a1)
		bmi.s	loc_6976
		bra.s	loc_6966
; ===========================================================================

loc_6960:
		tst.w	obVelX(a1)
		bpl.s	loc_6976

loc_6966:
		sub.w	d0,obX(a1)
		move.w	#0,obInertia(a1)
		move.w	#0,obVelX(a1)

loc_6976:
		btst	#1,obStatus(a1)
		bne.s	loc_699A
		bset	#5,obStatus(a1)
		bset	#5,obStatus(a0)
		rts
; ===========================================================================

loc_698C:
		btst	#5,obStatus(a0)
		beq.s	locret_69A6
		move.w	#id_Run,obAnim(a1)	; and obNextAni

loc_699A:
		bclr	#5,obStatus(a0)
		bclr	#5,obStatus(a1)

locret_69A6:
		rts
; ===========================================================================

loc_69A8:
		tst.w	obVelY(a1)
		beq.s	loc_69C0
		bpl.s	locret_69BE
		tst.w	d3
		bpl.s	locret_69BE
		sub.w	d3,obY(a1)
		move.w	#0,obVelY(a1)

locret_69BE:
		rts
; ===========================================================================

loc_69C0:
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(KillSonic).l
		movea.l	(sp)+,a0
		rts
; ===========================================================================

Obj44_SolidWall2:
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_6A28
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_6A28
		move.b	obHeight(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	obY(a1),d3
		sub.w	obY(a0),d3
		add.w	d2,d3
		bmi.s	loc_6A28
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bhs.s	loc_6A28
		move.w	d0,d5
		cmp.w	d0,d1
		bhs.s	loc_6A10
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_6A10:
		move.w	d3,d1
		cmp.w	d3,d2
		bhs.s	loc_6A1C
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_6A1C:
		cmp.w	d1,d5
		bhi.s	loc_6A24
		moveq	#1,d4
		rts
; ===========================================================================

loc_6A24:
		moveq	#-1,d4
		rts
; ===========================================================================

loc_6A28:
		moveq	#0,d4
		rts