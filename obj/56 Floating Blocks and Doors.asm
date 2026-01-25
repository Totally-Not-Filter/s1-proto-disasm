; ---------------------------------------------------------------------------
; Object 56 - floating blocks (SZ/SLZ), large doors
; ---------------------------------------------------------------------------

FloatingBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	FBlock_Index(pc,d0.w),d1
		jmp	FBlock_Index(pc,d1.w)
; ===========================================================================
FBlock_Index:	dc.w FBlock_Main-FBlock_Index
		dc.w FBlock_Action-FBlock_Index

fb_origX = objoff_34		; original x-axis position
fb_origY = objoff_30		; original y-axis position
fb_height = objoff_3A		; total object height
fb_type = objoff_3C		; subtype (2nd digit only)

FBlock_Var:	; width/2, height/2
		dc.b  $10, $10	; subtype 0x/8x
		dc.b  $20, $20	; subtype 1x/9x
		dc.b  $10, $20	; subtype 2x/Ax
		dc.b  $20, $1A	; subtype 3x/Bx
		dc.b  $10, $27	; subtype 4x/Cx
		dc.b  $10, $10	; subtype 5x/Dx
; ===========================================================================

FBlock_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_FBlock,obMap(a0)
		move.w	#make_art_tile(ArtTile_Level,2,0),obGfx(a0)
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	.notSLZ
		move.w	#make_art_tile(ArtTile_SLZ_Platform,2,0),obGfx(a0) ; SLZ specific code

.notSLZ:
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; get subtype
		lsr.w	#3,d0
		andi.w	#$E,d0		; read only the 1st digit
		lea	FBlock_Var(pc,d0.w),a2 ; get size data
		move.b	(a2)+,obActWid(a0)
		move.b	(a2),obHeight(a0)
		lsr.w	#1,d0
		move.b	d0,obFrame(a0)
		move.w	obX(a0),fb_origX(a0)
		move.w	obY(a0),fb_origY(a0)
		moveq	#0,d0
		move.b	(a2),d0
		add.w	d0,d0
		move.w	d0,fb_height(a0)
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
		bpl.s	FBlock_Action
		andi.b	#$F,d0
		move.b	d0,fb_type(a0)
		move.b	#5,obSubtype(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	FBlock_Action
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	FBlock_Action
		move.b	#6,obSubtype(a0)
		clr.w	fb_height(a0)

FBlock_Action:	; Routine 2
		move.w	obX(a0),-(sp)
		moveq	#0,d0
		move.b	obSubtype(a0),d0 ; get object subtype
		andi.w	#$F,d0		; read only the 2nd digit
		add.w	d0,d0
		move.w	.index(pc,d0.w),d1
		jsr	.index(pc,d1.w)	; move block subroutines
		move.w	(sp)+,d4
		tst.b	obRender(a0)
		bpl.s	.chkdel
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	obHeight(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject

.chkdel:
	if FixBugs
		out_of_range.w	DeleteObject,fb_origX(a0)
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject,fb_origX(a0)
		rts
	endif
; ===========================================================================
.index:	dc.w .type00-.index, .type01-.index
		dc.w .type02-.index, .type03-.index
		dc.w .type04-.index, .type05-.index
		dc.w .type06-.index, .type07-.index
		dc.w .type08-.index, .type09-.index
		dc.w .type0A-.index, .type0B-.index
; ===========================================================================

.type00:
		rts
; ===========================================================================

.type01:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(v_oscillate+$A).w,d0
		bra.s	.moveLR
; ===========================================================================

.type02:
		move.w	#$80,d1
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0

.moveLR:
		btst	#0,obStatus(a0)
		beq.s	.noflip
		neg.w	d0
		add.w	d1,d0

.noflip:
		move.w	fb_origX(a0),d1
		sub.w	d0,d1
		move.w	d1,obX(a0)
		rts
; ===========================================================================

.type03:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(v_oscillate+$A).w,d0
		bra.s	.moveUD
; ===========================================================================

.type04:
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0

.moveUD:
		btst	#0,obStatus(a0)
		beq.s	.noflip04
		neg.w	d0
		addi.w	#$80,d0

.noflip04:
		move.w	fb_origY(a0),d1
		sub.w	d0,d1
		move.w	d1,obY(a0)
		rts
; ===========================================================================

.type05:
		tst.b	objoff_38(a0)
		bne.s	.loc_DA9A
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	fb_type(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	.loc_DAA4
		move.b	#1,objoff_38(a0)

.loc_DA9A:
		tst.w	fb_height(a0)
		beq.s	.loc_DAB4
		subq.w	#2,fb_height(a0)

.loc_DAA4:
		move.w	fb_height(a0),d0
		move.w	fb_origY(a0),d1
		add.w	d0,d1
		move.w	d1,obY(a0)
		rts
; ===========================================================================

.loc_DAB4:
		addq.b	#1,obSubtype(a0)
		clr.b	objoff_38(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	.loc_DAA4
		bset	#0,2(a2,d0.w)
		bra.s	.loc_DAA4
; ===========================================================================

.type06:
		tst.b	objoff_38(a0)
		bne.s	.loc_DAEC
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	fb_type(a0),d0
		tst.b	(a2,d0.w)
		bpl.s	.loc_DAFE
		move.b	#1,objoff_38(a0)

.loc_DAEC:
		moveq	#0,d0
		move.b	obHeight(a0),d0
		add.w	d0,d0
		cmp.w	fb_height(a0),d0
		beq.s	.loc_DB0E
		addq.w	#2,fb_height(a0)

.loc_DAFE:
		move.w	fb_height(a0),d0
		move.w	fb_origY(a0),d1
		add.w	d0,d1
		move.w	d1,obY(a0)
		rts
; ===========================================================================

.loc_DB0E:
		subq.b	#1,obSubtype(a0)
		clr.b	objoff_38(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	.loc_DAFE
		bclr	#0,2(a2,d0.w)
		bra.s	.loc_DAFE
; ===========================================================================

.type07:
		tst.b	objoff_38(a0)
		bne.s	.loc_DB40
		tst.b	(f_switch+$F).w
		beq.s	.locret_DB5A
		move.b	#1,objoff_38(a0)
		clr.w	fb_height(a0)

.loc_DB40:
		addq.w	#1,obX(a0)
		move.w	obX(a0),fb_origX(a0)
		addq.w	#1,fb_height(a0)
		cmpi.w	#$380,fb_height(a0)
		bne.s	.locret_DB5A
		clr.b	obSubtype(a0)

.locret_DB5A:
		rts
; ===========================================================================

.type08:
		move.w	#$10,d1
		moveq	#0,d0
		move.b	(v_oscillate+$2A).w,d0
		lsr.w	#1,d0
		move.w	(v_oscillate+$2C).w,d3
		bra.s	.square
; ===========================================================================

.type09:
		move.w	#$30,d1
		moveq	#0,d0
		move.b	(v_oscillate+$2E).w,d0
		move.w	(v_oscillate+$30).w,d3
		bra.s	.square
; ===========================================================================

.type0A:
		move.w	#$50,d1
		moveq	#0,d0
		move.b	(v_oscillate+$32).w,d0
		move.w	(v_oscillate+$34).w,d3
		bra.s	.square
; ===========================================================================

.type0B:
		move.w	#$70,d1
		moveq	#0,d0
		move.b	(v_oscillate+$36).w,d0
		move.w	(v_oscillate+$38).w,d3

.square:
		tst.w	d3
		bne.s	.loc_DBAA
		addq.b	#1,obStatus(a0)
		andi.b	#3,obStatus(a0)

.loc_DBAA:
		move.b	obStatus(a0),d2
		andi.b	#3,d2
		bne.s	.loc_DBCA
		sub.w	d1,d0
		add.w	fb_origX(a0),d0
		move.w	d0,obX(a0)
		neg.w	d1
		add.w	fb_origY(a0),d1
		move.w	d1,obY(a0)
		rts
; ===========================================================================

.loc_DBCA:
		subq.b	#1,d2
		bne.s	.loc_DBE8
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	fb_origY(a0),d0
		move.w	d0,obY(a0)
		addq.w	#1,d1
		add.w	fb_origX(a0),d1
		move.w	d1,obX(a0)
		rts
; ===========================================================================

.loc_DBE8:
		subq.b	#1,d2
		bne.s	.loc_DC06
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	fb_origX(a0),d0
		move.w	d0,obX(a0)
		addq.w	#1,d1
		add.w	fb_origY(a0),d1
		move.w	d1,obY(a0)
		rts
; ===========================================================================

.loc_DC06:
		sub.w	d1,d0
		add.w	fb_origY(a0),d0
		move.w	d0,obY(a0)
		neg.w	d1
		add.w	fb_origX(a0),d1
		move.w	d1,obX(a0)
		rts