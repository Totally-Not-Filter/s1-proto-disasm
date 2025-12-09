; ---------------------------------------------------------------------------

Bridge_PlayerPos:
		moveq	#0,d0
		move.b	objoff_3F(a0),d0
		move.b	objoff_29(a0,d0.w),d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a2
		lea	(v_objspace).w,a1
		move.w	obY(a2),d0
		subq.w	#8,d0
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		rts
; ---------------------------------------------------------------------------

Bridge_UpdateBend:
		move.b	objoff_3E(a0),d0
		bsr.w	CalcSine
		move.w	d0,d4
		lea	(byte_5306).l,a4
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.w	#4,d0
		moveq	#0,d3
		move.b	objoff_3F(a0),d3
		move.w	d3,d2
		add.w	d0,d3
		moveq	#0,d5
		lea	(byte_51F6).l,a5
		move.b	(a5,d3.w),d5
		andi.w	#$F,d3
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		lea	objoff_29(a0),a2

loc_5186:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		moveq	#0,d0
		move.b	(a3)+,d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	objoff_3C(a1),d0
		move.w	d0,obY(a1)
		dbf	d2,loc_5186
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		moveq	#0,d3
		move.b	objoff_3F(a0),d3
		addq.b	#1,d3
		sub.b	d0,d3
		neg.b	d3
		bmi.s	locret_51F4
		move.w	d3,d2
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		adda.w	d2,a3
		subq.w	#1,d2
		bcs.s	locret_51F4

loc_51CE:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		moveq	#0,d0
		move.b	-(a3),d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	objoff_3C(a1),d0
		move.w	d0,obY(a1)
		dbf	d2,loc_51CE

locret_51F4:
		rts
; ---------------------------------------------------------------------------

byte_51F6:	dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 6, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, 6, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, 8, 6, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, $A, 8, 6, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, $A, $A, 8, 6, 4
		dc.b 2, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, $A, $C, $A, 8, 6
		dc.b 4, 2, 0, 0, 0, 0, 0, 2, 4, 6, 8, $A, $C, $C, $A, 8
		dc.b 6, 4, 2, 0, 0, 0, 0, 2, 4, 6, 8, $A, $C, $E, $C, $A
		dc.b 8, 6, 4, 2, 0, 0, 0, 2, 4, 6, 8, $A, $C, $E, $E, $C
		dc.b $A, 8, 6, 4, 2, 0, 0, 2, 4, 6, 8, $A, $C, $E, $10
		dc.b $E, $C, $A, 8, 6, 4, 2, 0, 2, 4, 6, 8, $A, $C, $E
		dc.b $10, $10, $E, $C, $A, 8, 6, 4, 2
		even
byte_5306:	dc.b $FF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b $B5, $FF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b $7E, $DB, $FF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, $61, $B5, $EC, $FF, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, $4A, $93, $CD, $F3, $FF, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, $3E, $7E, $B0, $DB, $F6, $FF, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, $38, $6D, $9D, $C5, $E4, $F8
		dc.b $FF, 0, 0, 0, 0, 0, 0, 0, 0, 0, $31, $61, $8E, $B5
		dc.b $D4, $EC, $FB, $FF, 0, 0, 0, 0, 0, 0, 0, 0, $2B, $56
		dc.b $7E, $A2, $C1, $DB, $EE, $FB, $FF, 0, 0, 0, 0, 0
		dc.b 0, 0, $25, $4A, $73, $93, $B0, $CD, $E1, $F3, $FC
		dc.b $FF, 0, 0, 0, 0, 0, 0, $1F, $44, $67, $88, $A7, $BD
		dc.b $D4, $E7, $F4, $FD, $FF, 0, 0, 0, 0, 0, $1F, $3E
		dc.b $5C, $7E, $98, $B0, $C9, $DB, $EA, $F6, $FD, $FF
		dc.b 0, 0, 0, 0, $19, $38, $56, $73, $8E, $A7, $BD, $D1
		dc.b $E1, $EE, $F8, $FE, $FF, 0, 0, 0, $19, $38, $50, $6D
		dc.b $83, $9D, $B0, $C5, $D8, $E4, $F1, $F8, $FE, $FF
		dc.b 0, 0, $19, $31, $4A, $67, $7E, $93, $A7, $BD, $CD
		dc.b $DB, $E7, $F3, $F9, $FE, $FF, 0, $19, $31, $4A, $61
		dc.b $78, $8E, $A2, $B5, $C5, $D4, $E1, $EC, $F4, $FB
		dc.b $FE, $FF
		even
; ---------------------------------------------------------------------------

Bridge_ChkDelete:
		out_of_range.w	Bridge_DeleteAll
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ---------------------------------------------------------------------------

Bridge_DeleteAll:
		moveq	#0,d2
		lea	obSubtype(a0),a2
		move.b	(a2)+,d2
		subq.b	#1,d2
		bcs.s	Bridge_GoDelete

loc_5432:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		cmp.w	a0,d0
		beq.s	loc_5448
		bsr.w	DeleteChild

loc_5448:
		dbf	d2,loc_5432

Bridge_GoDelete:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

Bridge_Delete:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

Bridge_Display:
		bsr.w	DisplaySprite
		rts