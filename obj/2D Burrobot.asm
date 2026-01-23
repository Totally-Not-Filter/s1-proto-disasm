; ---------------------------------------------------------------------------
; Object 2D - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------

Burrobot:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Burro_Index(pc,d0.w),d1
		jmp	Burro_Index(pc,d1.w)
; ===========================================================================
Burro_Index:	dc.w Burro_Main-Burro_Index
		dc.w Burro_Action-Burro_Index
		dc.w Burro_Delete-Burro_Index

burro_timedelay = objoff_30		; time between direction changes
; ===========================================================================

Burro_Main:
		move.b	#$13,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Burro,obMap(a0)
		move.w	#make_art_tile(ArtTile_Burrobot,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#5,obColType(a0)
		move.b	#$C,obActWid(a0)
		bset	#0,obStatus(a0)
		bsr.w	ObjectFall
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_8D54
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)

locret_8D54:
		rts
; ===========================================================================

Burro_Action:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	.index(pc,d0.w),d1
		jsr	.index(pc,d1.w)
		lea	(Ani_Burro).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
.index:	dc.w .changedir-.index
		dc.w Burro_Move-.index
		dc.w Burro_Jump-.index
; ===========================================================================

.changedir:
		subq.w	#1,burro_timedelay(a0)
		bpl.s	.nochg
		addq.b	#2,ob2ndRout(a0)
		move.w	#256-1,burro_timedelay(a0)
		move.w	#$80,obVelX(a0)
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)	; change direction the Burrobot is facing
		beq.s	.nochg
		neg.w	obVelX(a0)	; change direction the Burrobot is moving

.nochg:
		rts
; ===========================================================================

Burro_Move:
		subq.w	#1,burro_timedelay(a0)
		bmi.s	loc_8DDE
		bsr.w	SpeedToPos
		bchg	#0,objoff_32(a0)
		bne.s	loc_8DD4
		move.w	obX(a0),d3
		addi.w	#$C,d3
		btst	#0,obStatus(a0)
		bne.s	loc_8DC8
		subi.w	#$18,d3

loc_8DC8:
		bsr.w	ObjFloorDist2
		cmpi.w	#$C,d1
		bge.s	loc_8DDE
		rts
; ===========================================================================

loc_8DD4:
		bsr.w	ObjFloorDist
		add.w	d1,obY(a0)
		rts
; ===========================================================================

loc_8DDE:
		btst	#2,(v_vint_byte).w
		beq.s	loc_8DFE
		subq.b	#2,ob2ndRout(a0)
		move.w	#60-1,burro_timedelay(a0)
		move.w	#0,obVelX(a0)
		move.b	#0,obAnim(a0)
		rts
; ===========================================================================

loc_8DFE:
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$400,obVelY(a0)
		move.b	#2,obAnim(a0)
		rts
; ===========================================================================

Burro_Jump:
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		bmi.s	locret_8E44
		move.b	#3,obAnim(a0)
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_8E44
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		move.b	#1,obAnim(a0)
		move.w	#256-1,burro_timedelay(a0)
		subq.b	#2,ob2ndRout(a0)

locret_8E44:
		rts
; ===========================================================================

Burro_Delete:
		bsr.w	DeleteObject
		rts