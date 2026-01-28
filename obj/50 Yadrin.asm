; ---------------------------------------------------------------------------
; Object 50 - Yadrin enemy (SZ)
; ---------------------------------------------------------------------------

Yadrin:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Yad_Index(pc,d0.w),d1
		jmp	Yad_Index(pc,d1.w)
; ===========================================================================
Yad_Index:	dc.w Yad_Main-Yad_Index
		dc.w Yad_Action-Yad_Index

yad_timedelay = objoff_30
; ===========================================================================

Yad_Main:	; Routine 0
		move.l	#Map_Yad,obMap(a0)
		move.w	#make_art_tile(ArtTile_Yadrin,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$14,obActWid(a0)
		move.b	#$11,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.b	#$CC,obColType(a0)
		bsr.w	ObjectFall
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_D38A
		add.w	d1,obY(a0)	; match object's position with the floor
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		bchg	#0,obStatus(a0)

locret_D38A:
		rts
; ===========================================================================

Yad_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Yad_Index2(pc,d0.w),d1
		jsr	Yad_Index2(pc,d1.w)
		lea	(Ani_Yad).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
Yad_Index2:	dc.w Yad_Move-Yad_Index2
		dc.w Yad_FixToFloor-Yad_Index2
; ===========================================================================

Yad_Move:
		subq.w	#1,yad_timedelay(a0) ; subtract 1 from pause time
		bpl.s	locret_D3CE	; if time remains, branch
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$100,obVelX(a0) ; move object
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)
		bne.s	locret_D3CE
		neg.w	obVelX(a0)	; change direction

locret_D3CE:
		rts
; ===========================================================================

Yad_FixToFloor:
		bsr.w	SpeedToPos
		bsr.w	ObjFloorDist
		cmpi.w	#-8,d1
		blt.s	Yad_Pause
		cmpi.w	#$C,d1
		bge.s	Yad_Pause
		add.w	d1,obY(a0)	; match object's position to the floor
		bsr.w	ChkHitLeftRightWall
		bne.s	Yad_Pause
		rts
; ===========================================================================

Yad_Pause:
		subq.b	#2,ob2ndRout(a0)
		move.w	#59,yad_timedelay(a0) ; set pause time to 1 second
		move.w	#0,obVelX(a0)
		move.b	#0,obAnim(a0)
		rts