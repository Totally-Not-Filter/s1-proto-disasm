; ---------------------------------------------------------------------------
; Object 31 - stomping metal blocks on chains (MZ)
; ---------------------------------------------------------------------------

ChainStomp:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CStom_Index(pc,d0.w),d1
		jmp	CStom_Index(pc,d1.w)
; ===========================================================================
CStom_Index:	dc.w CStom_Main-CStom_Index
		dc.w loc_97D0-CStom_Index
		dc.w loc_9834-CStom_Index
		dc.w CStom_Display2-CStom_Index
		dc.w loc_9818-CStom_Index

CStom_switch = objoff_3A			; switch number for the current stomper

CStom_SwchNums:	dc.b 0, 0		; switch number, obj number
		dc.b 1, 0

CStom_Var:	dc.b 2, 0, 0		; routine number, y-position, frame number
		dc.b 4, $1C, 1
		dc.b 8, $CC, 3
		dc.b 6, $F0, 2

word_96DC:	dc.w $7000, $A000
		dc.w $5000, $7800
		dc.w $3800, $5800
		dc.w $B800
; ===========================================================================

CStom_Main:	; Routine 0
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		bpl.s	loc_9706
		andi.w	#$7F,d0
		add.w	d0,d0
		lea	CStom_SwchNums(pc,d0.w),a2
		move.b	(a2)+,CStom_switch(a0)
		move.b	(a2)+,d0
		move.b	d0,obSubtype(a0)

loc_9706:
		andi.b	#$F,d0
		add.w	d0,d0
		move.w	word_96DC(pc,d0.w),d2
		tst.w	d0
		bne.s	loc_9718
		move.w	d2,objoff_32(a0)

loc_9718:
		lea	(CStom_Var).l,a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	CStom_MakeStomper
; ===========================================================================

CStom_Loop:
		bsr.w	FindNextFreeObj
		bne.w	CStom_SetSize

CStom_MakeStomper:
		move.b	(a2)+,obRoutine(a1)
		_move.b	#id_ChainStomp,obID(a1)
		move.w	obX(a0),obX(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obY(a0),d0
		move.w	d0,obY(a1)
		move.l	#Map_CStom,obMap(a1)
		move.w	#make_art_tile(ArtTile_MZ_Spike_Stomper,0,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	obY(a1),objoff_30(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.b	#$10,obActWid(a1)
		move.w	d2,objoff_34(a1)
		move.b	#4,obPriority(a1)
		move.b	(a2)+,obFrame(a1)
		cmpi.b	#1,obFrame(a1)
		bne.s	loc_97A2
		subq.w	#1,d1
		move.b	obSubtype(a0),d0
		andi.w	#$F0,d0
		cmpi.w	#$20,d0
		beq.s	CStom_MakeStomper
		move.b	#$38,obActWid(a1)
		move.b	#$90,obColType(a1)
		addq.w	#1,d1

loc_97A2:
		move.l	a0,objoff_3C(a1)
		dbf	d1,CStom_Loop

		move.b	#3,obPriority(a1)

CStom_SetSize:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsr.w	#3,d0
		andi.b	#$E,d0
		lea	CStom_Var2(pc,d0.w),a2
		move.b	(a2)+,obActWid(a0)
		move.b	(a2)+,obFrame(a0)
		bra.s	loc_97D0
; ===========================================================================
CStom_Var2:	dc.b $38, 0		; width, frame number
		dc.b $30, 9
		dc.b $10, $A
; ===========================================================================

loc_97D0:	; Routine 2
		bsr.w	CStom_Types
		move.w	obY(a0),(v_obj31ypos).w
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$C,d2
		move.w	#$D,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		btst	#3,obStatus(a0)
		beq.s	CStom_Display
		cmpi.b	#$10,objoff_32(a0)
		bhs.s	CStom_Display
		movea.l	a0,a2
		lea	(v_player).w,a0
		bsr.w	KillSonic
		movea.l	a2,a0

CStom_Display:
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif
		bra.w	CStom_ChkDel
; ===========================================================================

loc_9818:	; Routine 8
		move.b	#$80,obHeight(a0)
		bset	#4,obRender(a0)
		movea.l	objoff_3C(a0),a1
		move.b	objoff_32(a1),d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,obFrame(a0)

loc_9834:	; Routine 4
		movea.l	objoff_3C(a0),a1
		moveq	#0,d0
		move.b	objoff_32(a1),d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)

CStom_Display2:	; Routine 6
	if ~~FixBugs
		bsr.w	DisplaySprite
	endif

CStom_ChkDel:
		out_of_range.w	DeleteObject
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject on
		; the same frame or else cause a null-pointer dereference.
		bra.w	DisplaySprite
	else
		rts
	endif
; ===========================================================================

CStom_Types:
		move.b	obSubtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	CStom_TypeIndex(pc,d0.w),d1
		jmp	CStom_TypeIndex(pc,d1.w)
; ===========================================================================
CStom_TypeIndex:	dc.w CStom_Type00-CStom_TypeIndex
		dc.w CStom_Type01-CStom_TypeIndex
		dc.w CStom_Type01-CStom_TypeIndex
		dc.w CStom_Type03-CStom_TypeIndex
		dc.w CStom_Type01-CStom_TypeIndex
		dc.w CStom_Type03-CStom_TypeIndex
		dc.w CStom_Type01-CStom_TypeIndex
; ===========================================================================

CStom_Type00:
		lea	(f_switch).w,a2	; load switch statuses
		moveq	#0,d0
		move.b	CStom_switch(a0),d0 ; move number 0 or 1 to d0
		tst.b	(a2,d0.w)	; has switch (d0) been pressed?
		beq.s	loc_98DE	; if not, branch
		tst.w	(v_obj31ypos).w
		bpl.s	loc_98A8
		cmpi.b	#$10,objoff_32(a0)
		beq.s	loc_98D6

loc_98A8:
		tst.w	objoff_32(a0)
		beq.s	loc_98D6
		move.b	(v_vint_byte).w,d0
		andi.b	#$F,d0
		bne.s	loc_98C8
		tst.b	obRender(a0)
		bpl.s	loc_98C8
		move.w	#sfx_ChainRise,d0
		jsr	(QueueSound2).l	; play rising chain sound

loc_98C8:
		subi.w	#$80,objoff_32(a0)
		bcc.s	CStom_Restart
		move.w	#0,objoff_32(a0)

loc_98D6:
		move.w	#0,obVelY(a0)
		bra.s	CStom_Restart
; ===========================================================================

loc_98DE:
		move.w	objoff_34(a0),d1
		cmp.w	objoff_32(a0),d1
		beq.s	CStom_Restart
		move.w	obVelY(a0),d0
		addi.w	#$70,obVelY(a0)	; make object fall
		add.w	d0,objoff_32(a0)
		cmp.w	objoff_32(a0),d1
		bhi.s	CStom_Restart
		move.w	d1,objoff_32(a0)
		move.w	#0,obVelY(a0)	; stop object falling
		tst.b	obRender(a0)
		bpl.s	CStom_Restart
		move.w	#sfx_ChainStomp,d0
		jsr	(QueueSound2).l	; play stomping sound

CStom_Restart:
		moveq	#0,d0
		move.b	objoff_32(a0),d0
		add.w	objoff_30(a0),d0
		move.w	d0,obY(a0)
		rts
; ===========================================================================

CStom_Type01:
		tst.w	objoff_36(a0)
		beq.s	loc_996E
		tst.w	objoff_38(a0)
		beq.s	loc_9938
		subq.w	#1,objoff_38(a0)
		bra.s	loc_99B2
; ===========================================================================

loc_9938:
		move.b	(v_vint_byte).w,d0
		andi.b	#$F,d0
		bne.s	loc_9952
		tst.b	obRender(a0)
		bpl.s	loc_9952
		move.w	#sfx_ChainRise,d0
		jsr	(QueueSound2).l	; play rising chain sound

loc_9952:
		subi.w	#$80,objoff_32(a0)
		bcc.s	loc_99B2
		move.w	#0,objoff_32(a0)
		move.w	#0,obVelY(a0)
		move.w	#0,objoff_36(a0)
		bra.s	loc_99B2
; ===========================================================================

loc_996E:
		move.w	objoff_34(a0),d1
		cmp.w	objoff_32(a0),d1
		beq.s	loc_99B2
		move.w	obVelY(a0),d0
		addi.w	#$70,obVelY(a0)	; make object fall
		add.w	d0,objoff_32(a0)
		cmp.w	objoff_32(a0),d1
		bhi.s	loc_99B2
		move.w	d1,objoff_32(a0)
		move.w	#0,obVelY(a0)	; stop object falling
		move.w	#1,objoff_36(a0)
		move.w	#$3C,objoff_38(a0)
		tst.b	obRender(a0)
		bpl.s	loc_99B2
		move.w	#sfx_ChainStomp,d0
		jsr	(QueueSound2).l	; play stomping sound

loc_99B2:
		bra.w	CStom_Restart
; ===========================================================================

CStom_Type03:
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	loc_99C2
		neg.w	d0

loc_99C2:
		cmpi.w	#$90,d0
		bhs.s	loc_99CC
		addq.b	#1,obSubtype(a0)

loc_99CC:
		bra.w	CStom_Restart