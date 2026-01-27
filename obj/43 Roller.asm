; ---------------------------------------------------------------------------
; Object 43 - Roller enemy (SZ)
; ---------------------------------------------------------------------------

Roller:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Roll_Index(pc,d0.w),d1
		jmp	Roll_Index(pc,d1.w)
; ===========================================================================
Roll_Index:	dc.w Roll_Main-Roll_Index
		dc.w Roll_Action-Roll_Index
		dc.w Roll_Delete-Roll_Index
; ===========================================================================

Roll_Main:	; Routine 0
		move.b	#$E,obHeight(a0)
		move.b	#8,obWidth(a0)
		bsr.w	ObjectFall
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_C00A
		add.w	d1,obY(a0)	; match roller's position with the floor
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Roll,obMap(a0)
		move.w	#make_art_tile(ArtTile_Roller,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$10,obActWid(a0)
		move.b	#$8E,obColType(a0) ; make Roller invincible

locret_C00A:
		rts
; ===========================================================================

Roll_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Roll_Index2(pc,d0.w),d1
		jsr	Roll_Index2(pc,d1.w)
		lea	(Ani_Roll).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
Roll_Index2:	dc.w Roll_RollChk-Roll_Index2
		dc.w Roll_RollNoChk-Roll_Index2
		dc.w Roll_ChkJump-Roll_Index2
		dc.w Roll_MatchFloor-Roll_Index2
; ===========================================================================

Roll_RollChk:
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		blo.s	locret_C050
		cmpi.w	#$20,d0
		bhs.s	locret_C050
		addq.b	#2,ob2ndRout(a0)
		move.b	#1,obAnim(a0)
		move.w	#$400,obVelX(a0) ; move Roller horizontally

locret_C050:
		rts
; ===========================================================================

Roll_RollNoChk:
		cmpi.b	#2,obAnim(a0)
		bne.s	locret_C05E
		addq.b	#2,ob2ndRout(a0)

locret_C05E:
		rts
; ===========================================================================

Roll_ChkJump:
		bsr.w	SpeedToPos
		bsr.w	ObjFloorDist
		cmpi.w	#-8,d1
		blt.s	Roll_Jump
		cmpi.w	#$C,d1
		bge.s	Roll_Jump
		add.w	d1,obY(a0)
		rts
; ===========================================================================

Roll_Jump:
		addq.b	#2,ob2ndRout(a0)
		bset	#0,objoff_32(a0)
		beq.s	locret_C08C
		move.w	#-$600,obVelY(a0)	; move Roller vertically

locret_C08C:
		rts
; ===========================================================================

Roll_MatchFloor:
		bsr.w	ObjectFall
		tst.w	obVelY(a0)
		bmi.s	locret_C0AE
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_C0AE
		add.w	d1,obY(a0)	; match Roller's position with the floor
		subq.b	#2,ob2ndRout(a0)
		move.w	#0,obVelY(a0)

locret_C0AE:
		rts
; ===========================================================================

Roll_Delete:	; Routine 4
		bra.w	DeleteObject