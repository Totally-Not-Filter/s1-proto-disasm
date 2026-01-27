; ---------------------------------------------------------------------------
; Object 1E - Ball Hog enemy
; ---------------------------------------------------------------------------

BallHog:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Hog_Index(pc,d0.w),d1
		jmp	Hog_Index(pc,d1.w)
; ===========================================================================
Hog_Index:	dc.w Hog_Main-Hog_Index
		dc.w Hog_Action-Hog_Index
		dc.w Hog_Display-Hog_Index
		dc.w Hog_Delete-Hog_Index
; ===========================================================================

Hog_Main:	; Routine 0
		move.b	#$13,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Hog,obMap(a0)
		move.w	#make_art_tile(ArtTile_Ball_Hog,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#5,obColType(a0)
		move.b	#$C,obActWid(a0)
		bsr.w	ObjectFall
		jsr	(ObjFloorDist).l	; find floor
		tst.w	d1
		bpl.s	.floornotfound
		add.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,obRoutine(a0)

.floornotfound:
		rts
; ===========================================================================

Hog_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Hog_ActIndex(pc,d0.w),d1
		jsr	Hog_ActIndex(pc,d1.w)
		lea	(Ani_Hog).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
Hog_ActIndex:	dc.w loc_6FB6-Hog_ActIndex
		dc.w loc_701C-Hog_ActIndex

hog_time = objoff_30
hog_launchflag = objoff_32		; 0 to launch a cannonball
; ===========================================================================

loc_6FB6:
		subq.w	#1,hog_time(a0)	; subtract 1 from pause time
		bpl.s	loc_6FE6		; if time remains, branch
		addq.b	#2,ob2ndRout(a0)
		move.w	#255,hog_time(a0)
		move.w	#$40,obVelX(a0) ; move object to the right
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)
		bne.s	loc_6FDE
		neg.w	obVelX(a0)	; change direction

loc_6FDE:
		move.b	#0,hog_launchflag(a0)
		rts
; ===========================================================================

loc_6FE6:
		tst.b	hog_launchflag(a0)
		bne.s	locret_6FF4
		cmpi.b	#2,obFrame(a0)
		beq.s	loc_6FF6

locret_6FF4:
		rts
; ===========================================================================

loc_6FF6:
		move.b	#1,hog_launchflag(a0)
		bsr.w	FindFreeObj
		bne.s	locret_701A
		_move.b	#id_Cannonball,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		addi.w	#$10,obY(a1)

locret_701A:
		rts
; ===========================================================================

loc_701C:
		subq.w	#1,hog_time(a0)
		bmi.s	loc_7032
		bsr.w	SpeedToPos
		jsr	(ObjFloorDist).l
		add.w	d1,obY(a0)
		rts
; ===========================================================================

loc_7032:
		subq.b	#2,ob2ndRout(a0)
		move.w	#59,hog_time(a0)
		move.w	#0,obVelX(a0)
		move.b	#0,obAnim(a0)
		tst.b	obRender(a0)
		bpl.s	locret_7054
		move.b	#2,obAnim(a0)

locret_7054:
		rts
; ===========================================================================

Hog_Display:	; Routine 4
		bsr.w	DisplaySprite
		rts
; ===========================================================================

Hog_Delete:	; Routine 6
		bsr.w	DeleteObject
		rts