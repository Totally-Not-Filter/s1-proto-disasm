; ---------------------------------------------------------------------------

ObjMovingBlocks:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ObjMovingBlocks_Index(pc,d0.w),d1
		jmp	ObjMovingBlocks_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjMovingBlocks_Index:dc.w ObjMovingBlocks_Init-ObjMovingBlocks_Index
		dc.w ObjMovingBlocks_Action-ObjMovingBlocks_Index

ObjMovingBlocks_Variables:dc.b $10, $10
		dc.b $20, $20
		dc.b $10, $20
		dc.b $20, $1A
		dc.b $10, $27
		dc.b $10, $10
; ---------------------------------------------------------------------------

ObjMovingBlocks_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_FBlock,obMap(a0)
		move.w	#make_art_tile(ArtTile_Level,2,0),obGfx(a0)
		cmpi.b	#id_SLZ,(v_zone).w
		bne.s	loc_D912
		move.w	#make_art_tile(ArtTile_SLZ_Platform,2,0),obGfx(a0)

loc_D912:
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#3,d0
		andi.w	#$E,d0
		lea	ObjMovingBlocks_Variables(pc,d0.w),a2
		move.b	(a2)+,obActWid(a0)
		move.b	(a2),obHeight(a0)
		lsr.w	#1,d0
		move.b	d0,obFrame(a0)
		move.w	obX(a0),objoff_34(a0)
		move.w	obY(a0),objoff_30(a0)
		moveq	#0,d0
		move.b	(a2),d0
		add.w	d0,d0
		move.w	d0,objoff_3A(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		subq.w	#8,d0
		bcs.s	ObjMovingBlocks_IsGone
		lsl.w	#2,d0
		lea	(v_oscillate+$2C).w,a2
		lea	(a2,d0.w),a2
		tst.w	(a2)
		bpl.s	ObjMovingBlocks_IsGone
		bchg	#0,obStatus(a0)

ObjMovingBlocks_IsGone:
		move.b	obSubtype(a0),d0
		bpl.s	ObjMovingBlocks_Action
		andi.b	#$F,d0
		move.b	d0,objoff_3C(a0)
		move.b	#5,obSubtype(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	ObjMovingBlocks_Action
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	ObjMovingBlocks_Action
		move.b	#6,obSubtype(a0)
		clr.w	objoff_3A(a0)

ObjMovingBlocks_Action:
		move.w	obX(a0),-(sp)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	ObjMovingBlocks_TypeIndex(pc,d0.w),d1
		jsr	ObjMovingBlocks_TypeIndex(pc,d1.w)
		move.w	(sp)+,d4
		tst.b	obRender(a0)
		bpl.s	ObjMovingBlocks_ChkDelete
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	obHeight(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject

ObjMovingBlocks_ChkDelete:
	if FixBugs
		out_of_range.w	DeleteObject,objoff_34(a0)
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject,objoff_34(a0)
		rts
	endif
; ---------------------------------------------------------------------------

ObjMovingBlocks_TypeIndex:dc.w ObjMovingBlocks_Type00-ObjMovingBlocks_TypeIndex
		dc.w ObjMovingBlocks_Type01-ObjMovingBlocks_TypeIndex
		dc.w ObjMovingBlocks_Type02-ObjMovingBlocks_TypeIndex
		dc.w ObjMovingBlocks_Type03-ObjMovingBlocks_TypeIndex
		dc.w ObjMovingBlocks_Type04-ObjMovingBlocks_TypeIndex
		dc.w ObjMovingBlocks_Type05-ObjMovingBlocks_TypeIndex
		dc.w ObjMovingBlocks_Type06-ObjMovingBlocks_TypeIndex
		dc.w ObjMovingBlocks_Type07-ObjMovingBlocks_TypeIndex
		dc.w ObjMovingBlocks_Type08-ObjMovingBlocks_TypeIndex
		dc.w ObjMovingBlocks_Type09-ObjMovingBlocks_TypeIndex
		dc.w ObjMovingBlocks_Type0A-ObjMovingBlocks_TypeIndex
		dc.w ObjMovingBlocks_Type0B-ObjMovingBlocks_TypeIndex
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type00:
		rts
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type01:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(v_oscillate+$A).w,d0
		bra.s	loc_DA38
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type02:
		move.w	#$80,d1
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0

loc_DA38:
		btst	#0,obStatus(a0)
		beq.s	loc_DA44
		neg.w	d0
		add.w	d1,d0

loc_DA44:
		move.w	objoff_34(a0),d1
		sub.w	d0,d1
		move.w	d1,obX(a0)
		rts
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type03:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(v_oscillate+$A).w,d0
		bra.s	loc_DA62
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type04:
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0

loc_DA62:
		btst	#0,obStatus(a0)
		beq.s	loc_DA70
		neg.w	d0
		addi.w	#$80,d0

loc_DA70:
		move.w	objoff_30(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type05:
		tst.b	objoff_38(a0)
		bne.s	loc_DA9A
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	objoff_3C(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	loc_DAA4
		move.b	#1,objoff_38(a0)

loc_DA9A:
		tst.w	objoff_3A(a0)
		beq.s	loc_DAB4
		subq.w	#2,objoff_3A(a0)

loc_DAA4:
		move.w	objoff_3A(a0),d0
		move.w	objoff_30(a0),d1
		add.w	d0,d1
		move.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_DAB4:
		addq.b	#1,obSubtype(a0)
		clr.b	objoff_38(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	loc_DAA4
		bset	#0,2(a2,d0.w)
		bra.s	loc_DAA4
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type06:
		tst.b	objoff_38(a0)
		bne.s	loc_DAEC
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	objoff_3C(a0),d0
		tst.b	(a2,d0.w)
		bpl.s	loc_DAFE
		move.b	#1,objoff_38(a0)

loc_DAEC:
		moveq	#0,d0
		move.b	obHeight(a0),d0
		add.w	d0,d0
		cmp.w	objoff_3A(a0),d0
		beq.s	loc_DB0E
		addq.w	#2,objoff_3A(a0)

loc_DAFE:
		move.w	objoff_3A(a0),d0
		move.w	objoff_30(a0),d1
		add.w	d0,d1
		move.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_DB0E:
		subq.b	#1,obSubtype(a0)
		clr.b	objoff_38(a0)
		lea	(v_regbuffer).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	loc_DAFE
		bclr	#0,2(a2,d0.w)
		bra.s	loc_DAFE
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type07:
		tst.b	objoff_38(a0)
		bne.s	loc_DB40
		tst.b	(f_switch+$F).w
		beq.s	locret_DB5A
		move.b	#1,objoff_38(a0)
		clr.w	objoff_3A(a0)

loc_DB40:
		addq.w	#1,obX(a0)
		move.w	obX(a0),objoff_34(a0)
		addq.w	#1,objoff_3A(a0)
		cmpi.w	#$380,objoff_3A(a0)
		bne.s	locret_DB5A
		clr.b	obSubtype(a0)

locret_DB5A:
		rts
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type08:
		move.w	#$10,d1
		moveq	#0,d0
		move.b	(v_oscillate+$2A).w,d0
		lsr.w	#1,d0
		move.w	(v_oscillate+$2C).w,d3
		bra.s	ObjBasaran_MoveSquare
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type09:
		move.w	#$30,d1
		moveq	#0,d0
		move.b	(v_oscillate+$2E).w,d0
		move.w	(v_oscillate+$30).w,d3
		bra.s	ObjBasaran_MoveSquare
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type0A:
		move.w	#$50,d1
		moveq	#0,d0
		move.b	(v_oscillate+$32).w,d0
		move.w	(v_oscillate+$34).w,d3
		bra.s	ObjBasaran_MoveSquare
; ---------------------------------------------------------------------------

ObjMovingBlocks_Type0B:
		move.w	#$70,d1
		moveq	#0,d0
		move.b	(v_oscillate+$36).w,d0
		move.w	(v_oscillate+$38).w,d3

ObjBasaran_MoveSquare:
		tst.w	d3
		bne.s	loc_DBAA
		addq.b	#1,obStatus(a0)
		andi.b	#3,obStatus(a0)

loc_DBAA:
		move.b	obStatus(a0),d2
		andi.b	#3,d2
		bne.s	loc_DBCA
		sub.w	d1,d0
		add.w	objoff_34(a0),d0
		move.w	d0,obX(a0)
		neg.w	d1
		add.w	objoff_30(a0),d1
		move.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_DBCA:
		subq.b	#1,d2
		bne.s	loc_DBE8
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)
		addq.w	#1,d1
		add.w	objoff_34(a0),d1
		move.w	d1,obX(a0)
		rts
; ---------------------------------------------------------------------------

loc_DBE8:
		subq.b	#1,d2
		bne.s	loc_DC06
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	objoff_34(a0),d0
		move.w	d0,obX(a0)
		addq.w	#1,d1
		add.w	objoff_30(a0),d1
		move.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_DC06:
		sub.w	d1,d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)
		neg.w	d1
		add.w	objoff_34(a0),d1
		move.w	d1,obX(a0)
		rts