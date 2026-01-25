; ---------------------------------------------------------------------------
; Object 54 - invisible lava tag (MZ)
; ---------------------------------------------------------------------------

LavaTag:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LTag_Index(pc,d0.w),d1
		jmp	LTag_Index(pc,d1.w)
; ===========================================================================
LTag_Index:	dc.w LTag_Main-LTag_Index
		dc.w LTag_ChkDel-LTag_Index

LTag_ColTypes:	dc.b $96, $94, $95
		even
; ===========================================================================

LTag_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		move.b	LTag_ColTypes(pc,d0.w),obColType(a0)
		move.l	#Map_LTag,obMap(a0)
		move.w	#make_art_tile(ArtTile_Monitor,0,1),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$80,obActWid(a0)
		move.b	#4,obPriority(a0)
		move.b	obSubtype(a0),obFrame(a0)

LTag_ChkDel:	; Routine 2
		tst.w	(v_debuguse).w	; is debug mode being used?
		beq.s	.debugoff	; if not, branch
		bsr.w	DisplaySprite

.debugoff:
		cmpi.b	#6,(v_player+obRoutine).w	; has sonic died?
		bhs.s	.playerdead			; if so, branch
		bset	#7,obRender(a0)

.playerdead:
		move.w	obX(a0),d0
		andi.w	#-$80,d0
		move.w	(v_scrposx).w,d1
		subi.w	#$80,d1
		andi.w	#-$80,d1
		sub.w	d1,d0
		bmi.w	DeleteObject
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts