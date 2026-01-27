; ---------------------------------------------------------------------------
; Object 30 - large green glass blocks (MZ)
; ---------------------------------------------------------------------------

GlassBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Glass_Index(pc,d0.w),d1
		jsr	Glass_Index(pc,d1.w)
	if FixBugs
		out_of_range.w	Glass_Delete
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	Glass_Delete
		rts
	endif
; ===========================================================================

Glass_Delete:
		bsr.w	DeleteObject
		rts
; ===========================================================================
Glass_Index:	dc.w Glass_Main-Glass_Index
		dc.w Glass_Block012-Glass_Index
		dc.w loc_94B0-Glass_Index
		dc.w Glass_Reflect012-Glass_Index
		dc.w Glass_Block34-Glass_Index
		dc.w Glass_Reflect34-Glass_Index

glass_dist = objoff_32		; distance block moves when switch is pressed
glass_parent = objoff_3C		; address of parent object

Glass_Vars1:	dc.b 2, 4, 0	; routine num, y-axis dist from origin, frame num
		dc.b 4, $48, 1
		dc.b 6, 4, 2
		even
Glass_Vars2:	dc.b 8, 0, 3
		dc.b $A, 0, 2
; ===========================================================================

Glass_Main:
		lea	(Glass_Vars1).l,a2
		moveq	#2,d1
		cmpi.b	#3,obSubtype(a0) ; is object type 0/1/2?
		blo.s	.IsType012	; if yes, branch
		lea	(Glass_Vars2).l,a2
		moveq	#1,d1

.IsType012:
		movea.l	a0,a1
		bra.s	.Load		; load main object
; ===========================================================================

.Repeat:
		bsr.w	FindNextFreeObj
		bne.s	.Fail

.Load:
		move.b	(a2)+,obRoutine(a1)
		_move.b	#id_GlassBlock,obID(a1)
		move.w	obX(a0),obX(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obY(a0),d0
		move.w	d0,obY(a1)
		move.l	#Map_Glass,obMap(a1)
		move.w	#make_art_tile(ArtTile_MZ_Glass_Pillar,2,1),obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	obY(a1),objoff_30(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.b	#$20,obActWid(a1)
		move.b	#4,obPriority(a1)
		move.b	(a2)+,obFrame(a1)
		move.l	a0,glass_parent(a1)
		dbf	d1,.Repeat	; repeat once to load "reflection object"

		move.b	#$10,obActWid(a1)
		move.b	#3,obPriority(a1)
		addq.b	#8,obSubtype(a1)
		andi.b	#$F,obSubtype(a1)

.Fail:
		move.w	#$90,glass_dist(a0)
		move.b	#$38,obHeight(a0)
		bset	#4,obRender(a0)

Glass_Block012:
		bsr.w	Glass_Types
		move.w	#$2B,d1
		move.w	#$24,d2
		move.w	#$24,d3
		move.w	obX(a0),d4
		bra.w	SolidObject
; ===========================================================================

loc_94B0:
		movea.l	glass_parent(a0),a1
		move.w	glass_dist(a1),glass_dist(a0)
		bsr.w	Glass_Types
		move.w	#$2B,d1
		move.w	#$24,d2
		bra.w	Obj44_SolidWall
; ===========================================================================

Glass_Reflect012:
		movea.l	glass_parent(a0),a1
		move.w	glass_dist(a1),glass_dist(a0)
		bra.w	Glass_Types
; ===========================================================================

Glass_Block34:
		bsr.w	Glass_Types
		move.w	#$2B,d1
		move.w	#$38,d2
		move.w	#$38,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		cmpi.b	#8,obRoutine(a0)
		beq.s	locret_94FE
		move.b	#8,obRoutine(a0)

locret_94FE:
		rts
; ===========================================================================

Glass_Reflect34:
		movea.l	glass_parent(a0),a1
		move.w	glass_dist(a1),glass_dist(a0)
		move.w	obY(a1),objoff_30(a0)
		bra.w	Glass_Types

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

Glass_Types:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	Glass_TypeIndex(pc,d0.w),d1
		jmp	Glass_TypeIndex(pc,d1.w)
; End of function Glass_Types

; ===========================================================================
Glass_TypeIndex:	dc.w Glass_Type00-Glass_TypeIndex
		dc.w Glass_Type01-Glass_TypeIndex
		dc.w Glass_Type02-Glass_TypeIndex
		dc.w Glass_Type03-Glass_TypeIndex
		dc.w Glass_Type04-Glass_TypeIndex
; ===========================================================================

Glass_Type00:
		rts
; ===========================================================================

Glass_Type01:
		move.b	(v_oscillate+$12).w,d0
		move.w	#$40,d1
		bra.w	loc_9616
; ===========================================================================

Glass_Type02:
		move.b	(v_oscillate+$12).w,d0
		move.w	#$40,d1
		neg.w	d0
		add.w	d1,d0
		bra.w	loc_9616
; ===========================================================================

Glass_Type03:
		btst	#3,obSubtype(a0)
		beq.s	loc_9564
		move.b	(v_oscillate+$12).w,d0
		subi.w	#$10,d0
		bra.w	loc_9624
; ===========================================================================

loc_9564:
		btst	#3,obStatus(a0)
		bne.s	loc_9574
		bclr	#0,objoff_34(a0)
		bra.s	loc_95A8
; ===========================================================================

loc_9574:
		tst.b	objoff_34(a0)
		bne.s	loc_95A8
		move.b	#1,objoff_34(a0)
		bset	#0,objoff_35(a0)
		beq.s	loc_95A8
		bset	#7,objoff_34(a0)
		move.w	#$10,objoff_36(a0)
		move.b	#$A,objoff_38(a0)
		cmpi.w	#$40,glass_dist(a0)
		bne.s	loc_95A8
		move.w	#$40,objoff_36(a0)

loc_95A8:
		tst.b	objoff_34(a0)
		bpl.s	loc_95D0
		tst.b	objoff_38(a0)
		beq.s	loc_95BA
		subq.b	#1,objoff_38(a0)
		bne.s	loc_95D0

loc_95BA:
		tst.w	glass_dist(a0)
		beq.s	loc_95CA
		subq.w	#1,glass_dist(a0)
		subq.w	#1,objoff_36(a0)
		bne.s	loc_95D0

loc_95CA:
		bclr	#7,objoff_34(a0)

loc_95D0:
		move.w	glass_dist(a0),d0
		bra.s	loc_9624
; ===========================================================================

Glass_Type04:
		btst	#3,obSubtype(a0)
		beq.s	Glass_ChkSwitch
		move.b	(v_oscillate+$12).w,d0
		subi.w	#$10,d0
		bra.s	loc_9624
; ===========================================================================

Glass_ChkSwitch:
		tst.b	objoff_34(a0)
		bne.s	loc_9606
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; load object type number
		lsr.w	#4,d0		; read only the first nybble
		tst.b	(a2,d0.w)	; has switch number d0 been pressed?
		beq.s	loc_9610	; if not, branch
		move.b	#1,objoff_34(a0)

loc_9606:
		tst.w	glass_dist(a0)
		beq.s	loc_9610
		subq.w	#2,glass_dist(a0)

loc_9610:
		move.w	glass_dist(a0),d0
		bra.s	loc_9624
; ===========================================================================

loc_9616:
		btst	#3,obSubtype(a0)
		beq.s	loc_9624
		neg.w	d0
		add.w	d1,d0
		lsr.b	#1,d0

loc_9624:
		move.w	objoff_30(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)
		rts