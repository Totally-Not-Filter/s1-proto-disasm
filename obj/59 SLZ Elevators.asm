; ---------------------------------------------------------------------------
; Object 59 - platforms	that move when you stand on them (SLZ)
; ---------------------------------------------------------------------------

elev_origX	= objoff_32				; original x-axis position
elev_origY	= objoff_30				; original y-axis position
elev_dist	= objoff_3C				; distance to move (2 bytes)

ObjSLZMovingPtfm:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_DF9A(pc,d0.w),d1
		jsr	off_DF9A(pc,d1.w)
		out_of_range.w	DeleteObject,elev_origX(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_DF9A:	dc.w loc_DFC2-off_DF9A
		dc.w loc_E03A-off_DF9A
		dc.w loc_E04A-off_DF9A
		dc.w loc_E194-off_DF9A

Elev_Var1:	dc.b $28, 0 ; act width, frame

Elev_Var2:	dc.b $10, 1 ; elev_dist, subtype
		dc.b $20, 1
		dc.b $34, 1
		dc.b $10, 3
		dc.b $20, 3
		dc.b $34, 3
		dc.b $14, 1
		dc.b $24, 1
		dc.b $2C, 1
		dc.b $14, 3
		dc.b $24, 3
		dc.b $2C, 3
		dc.b $20, 5
		dc.b $20, 7
		dc.b $30, 9
; ---------------------------------------------------------------------------

loc_DFC2:
		addq.b	#2,obRoutine(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		bpl.s	loc_DFE6
		addq.b	#4,obRoutine(a0)
		andi.w	#$7F,d0
		mulu.w	#6,d0
		move.w	d0,elev_dist(a0)
		move.w	d0,objoff_3E(a0)
		addq.l	#4,sp	; do not return to caller
		rts
; ---------------------------------------------------------------------------

loc_DFE6:
		lsr.w	#3,d0
	if FixBugs
		andi.w	#1,d0
	else
		; There is a bug in which Act 2 has 2 platforms, one with a subtype of $14, and another with a subtype of $7A.
		; This results in the objects reading code rather than data, which results in a garbled mess.
		; What causes this is that the table for Elev_Var1 reads beyond the entry list and reads what is in Elev_Var2.
		; The subtype $14 goes beyond both variable tables, reading the instructions at loc_DFC2 as if they were object variables.
		; The line below is the root cause of the issue, as it does not limit the table to be 1 entry.
		; What's the most strange part about this (in my opinion) is that this bug technically still persists in the
		; final game, but the issue never actually got fixed.
		; Perhaps they were planning on different types of platforms? Who knows!
		andi.w	#$1E,d0
	endif
		lea	Elev_Var1(pc,d0.w),a2
		move.b	(a2)+,obActWid(a0)
		move.b	(a2)+,obFrame(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
	if FixBugs
		andi.w	#$F,d0
	else
		; This is also just as bugged as the previous AND.
		andi.w	#$1E,d0
	endif
		lea	Elev_Var2(pc,d0.w),a2
		move.b	(a2)+,d0
		lsl.w	#2,d0
		move.w	d0,elev_dist(a0)
		move.b	(a2)+,obSubtype(a0)
		move.l	#Map_Elev,obMap(a0)
		move.w	#make_art_tile(ArtTile_SLZ_Platform,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.w	obX(a0),elev_origX(a0)
		move.w	obY(a0),elev_origY(a0)

loc_E03A:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(PlatformObject).l
		bra.w	sub_E06E
; ---------------------------------------------------------------------------

loc_E04A:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		jsr	(ExitPlatform).l
		move.w	obX(a0),-(sp)
		bsr.w	sub_E06E
		move.w	(sp)+,d2
		_tst.b	obID(a0)
		beq.s	locret_E06C
		jmp	(ptfmSurfaceNormal).l
; ---------------------------------------------------------------------------

locret_E06C:
		rts
; ---------------------------------------------------------------------------

sub_E06E:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_E082(pc,d0.w),d1
		jmp	off_E082(pc,d1.w)
; ---------------------------------------------------------------------------

off_E082:	dc.w locret_E096-off_E082
		dc.w loc_E098-off_E082
		dc.w loc_E0A6-off_E082
		dc.w loc_E098-off_E082
		dc.w loc_E0BA-off_E082
		dc.w loc_E098-off_E082
		dc.w loc_E0CC-off_E082
		dc.w loc_E098-off_E082
		dc.w loc_E0EE-off_E082
		dc.w loc_E110-off_E082
; ---------------------------------------------------------------------------

locret_E096:
		rts
; ---------------------------------------------------------------------------

loc_E098:
		cmpi.b	#4,obRoutine(a0)
		bne.s	locret_E0A4
		addq.b	#1,obSubtype(a0)

locret_E0A4:
		rts
; ---------------------------------------------------------------------------

loc_E0A6:
		bsr.w	sub_E14A
		move.w	objoff_34(a0),d0
		neg.w	d0
		add.w	elev_origY(a0),d0
		move.w	d0,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0BA:
		bsr.w	sub_E14A
		move.w	objoff_34(a0),d0
		add.w	elev_origY(a0),d0
		move.w	d0,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0CC:
		bsr.w	sub_E14A
		move.w	objoff_34(a0),d0
		asr.w	#1,d0
		neg.w	d0
		add.w	elev_origY(a0),d0
		move.w	d0,obY(a0)
		move.w	objoff_34(a0),d0
		add.w	elev_origX(a0),d0
		move.w	d0,obX(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0EE:
		bsr.w	sub_E14A
		move.w	objoff_34(a0),d0
		asr.w	#1,d0
		add.w	elev_origY(a0),d0
		move.w	d0,obY(a0)
		move.w	objoff_34(a0),d0
		neg.w	d0
		add.w	elev_origX(a0),d0
		move.w	d0,obX(a0)
		rts
; ---------------------------------------------------------------------------

loc_E110:
		bsr.w	sub_E14A
		move.w	objoff_34(a0),d0
		neg.w	d0
		add.w	elev_origY(a0),d0
		move.w	d0,obY(a0)
		tst.b	obSubtype(a0)
		beq.w	loc_E12C
		rts
; ---------------------------------------------------------------------------

loc_E12C:
		btst	#3,obStatus(a0)
		beq.s	loc_E146
		bset	#1,obStatus(a1)
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a1)

loc_E146:
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

sub_E14A:
		move.w	objoff_38(a0),d0
		tst.b	objoff_3A(a0)
		bne.s	loc_E160
		cmpi.w	#$800,d0
		bcc.s	loc_E168
		addi.w	#$10,d0
		bra.s	loc_E168
; ---------------------------------------------------------------------------

loc_E160:
		tst.w	d0
		beq.s	loc_E168
		subi.w	#$10,d0

loc_E168:
		move.w	d0,objoff_38(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	objoff_34(a0),d0
		move.l	d0,objoff_34(a0)
		swap	d0
		move.w	elev_dist(a0),d2
		cmp.w	d2,d0
		bls.s	loc_E188
		move.b	#1,objoff_3A(a0)

loc_E188:
		add.w	d2,d2
		cmp.w	d2,d0
		bne.s	locret_E192
		clr.b	obSubtype(a0)

locret_E192:
		rts
; ---------------------------------------------------------------------------

loc_E194:
		subq.w	#1,elev_dist(a0)
		bne.s	loc_E1BE
		move.w	objoff_3E(a0),elev_dist(a0)
		bsr.w	FindFreeObj
		bne.s	loc_E1BE
		_move.b	#id_Elevator,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#$E,obSubtype(a1)

loc_E1BE:
		addq.l	#4,sp	; do not return to caller
		out_of_range.w	DeleteObject
		rts