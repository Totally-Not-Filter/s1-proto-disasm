; ---------------------------------------------------------------------------
; Object 3E - prison capsule
; ---------------------------------------------------------------------------

Prison:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Pri_Index(pc,d0.w),d1
		jsr	Pri_Index(pc,d1.w)
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ===========================================================================
Pri_Index:	dc.w Pri_Main-Pri_Index
		dc.w Pri_BodyMain-Pri_Index
		dc.w Pri_Switched-Pri_Index
		dc.w Pri_Explosion-Pri_Index
		dc.w Pri_Explosion-Pri_Index
		dc.w Pri_Explosion-Pri_Index
		dc.w Pri_Animals-Pri_Index
		dc.w Pri_EndAct-Pri_Index

pri_origY = objoff_30		; original y-axis position

Pri_Var:	dc.b 2, $20, 4, 0	; routine, width, priority, frame
		dc.b 4, $C, 5, 1
		dc.b 6, $10, 4, 3
		dc.b 8, $10, 3, 5
; ===========================================================================

Pri_Main:	; Routine 0
		move.l	#Map_Pri,obMap(a0)
		move.w	#make_art_tile(ArtTile_Prison_Capsule,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	obY(a0),pri_origY(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.w	#2,d0
		lea	Pri_Var(pc,d0.w),a1
		move.b	(a1)+,obRoutine(a0)
		move.b	(a1)+,obActWid(a0)
		move.b	(a1)+,obPriority(a0)
		move.b	(a1)+,obFrame(a0)
		cmpi.w	#8,d0		; is object type number 02?
		bne.s	.not02		; if not, branch

		move.b	#6,obColType(a0)
		move.b	#8,obColProp(a0)

.not02:
		rts
; ===========================================================================

Pri_BodyMain:	; Routine 2
		cmpi.b	#2,(v_bossstatus).w
		beq.s	.chkopened
		move.w	#$2B,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	obX(a0),d4
		bra.w	SolidObject
; ===========================================================================

.chkopened:
		tst.b	ob2ndRout(a0)	; has the prison been opened?
		beq.s	.open		; if yes, branch
		clr.b	ob2ndRout(a0)
		bclr	#3,(v_player+obStatus).w
		bset	#1,(v_player+obStatus).w

.open:
		move.b	#2,obFrame(a0)	; use frame number 2 (destroyed prison)
		rts
; ===========================================================================

Pri_Switched:	; Routine 4
		move.w	#$17,d1
		move.w	#8,d2
		move.w	#8,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		lea	(Ani_Pri).l,a1
		bsr.w	AnimateSprite
		move.w	pri_origY(a0),obY(a0)
		tst.b	ob2ndRout(a0)	; has prison already been opened?
		beq.s	.open2		; if yes, branch

		addq.w	#8,obY(a0)
		move.b	#$A,obRoutine(a0)
		move.w	#60,obTimeFrame(a0) ; set time between animal spawns
		clr.b	(f_timecount).w	; stop time counter
		clr.b	ob2ndRout(a0)
		bclr	#3,(v_player+obStatus).w
		bset	#1,(v_player+obStatus).w

.open2:
		rts
; ===========================================================================

Pri_Explosion:	; Routine 6, 8, $A
		move.b	(v_vint_byte).w,d0
		andi.b	#7,d0
		bne.s	.noexplosion
		bsr.w	FindFreeObj
		bne.s	.noexplosion
		_move.b	#id_ExplosionBomb,obID(a1) ; load explosion object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,obX(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,obY(a1)

.noexplosion:
		subq.w	#1,obTimeFrame(a0)
		bne.s	.wait
		move.b	#2,(v_bossstatus).w
		move.b	#$C,obRoutine(a0)	; replace explosions with animals
		move.b	#9,obFrame(a0)
		move.w	#180,obTimeFrame(a0)
		addi.w	#$20,obY(a0)

.wait:
		rts
; ===========================================================================

Pri_Animals:	; Routine $C
		move.b	(v_vint_byte).w,d0
		andi.b	#7,d0
		bne.s	.noanimal
		bsr.w	FindFreeObj
		bne.s	.noanimal
		_move.b	#id_Animals,obID(a1) ; load animal object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

.noanimal:
		subq.w	#1,obTimeFrame(a0)
		bne.s	.wait
		addq.b	#2,obRoutine(a0)
		move.w	#60,obTimeFrame(a0)

.wait:
		rts
; ===========================================================================

Pri_EndAct:	; Routine $E
		subq.w	#1,obTimeFrame(a0)
		bne.s	.wait
		bsr.w	GotThroughAct
	if FixBugs
		addq.l	#4,sp	; do not return to caller
	endif
		bra.w	DeleteObject

.wait:
		rts