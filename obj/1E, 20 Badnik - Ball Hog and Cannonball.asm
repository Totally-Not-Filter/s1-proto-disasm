; ===========================================================================
; ---------------------------------------------------------------------------
; Object 1E - Ball Hog enemy
; ---------------------------------------------------------------------------

BallHog:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Hog_Index(pc,d0.w),d1
		jmp	Hog_Index(pc,d1.w)
; ===========================================================================
Hog_Index:
		dc.w	Hog_Main-Hog_Index			; 0
		dc.w	Hog_Action-Hog_Index			; 2
		dc.w	Hog_Display-Hog_Index			; 4 (unused)
		dc.w	Hog_Delete-Hog_Index			; 6 (unused)

hog_timedelay:	equ objoff_30
hog_launched:	equ objoff_32		; set if a cannonball has been launched this animation cycle
; ===========================================================================

Hog_Main:	; Routine 0
		move.b	#38/2,obHeight(a0)			; set height
		move.b	#16/2,obWidth(a0)			; set width
		move.l	#Map_Hog,obMap(a0)			; set mappings
		move.w	#ArtTile_Ball_Hog|Tile_Pal2,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#col_24x36|col_badnik,obColType(a0)	; set ReactToItem type ($5)
		move.b	#24/2,obActWid(a0)			; set sprite display width

		; Make the Ball Hog fall until it has collided with the floor (while invisible)
		bsr.w	ObjectFall				; increase gravity and update position
		jsr	(ObjFloorDist).l			; get distance between Ball Hog and floor
		tst.w	d1					; has Ball Hog hit the floor?
		bpl.s	.floornotfound				; if not, branch
		add.w	d1,obY(a0)				; match object's position with the floor
		move.w	#0,obVelY(a0)				; clear falling speed
		addq.b	#2,obRoutine(a0)			; advance to Hog_Action

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
Hog_ActIndex:
		dc.w	Hog_Action_TurnAround-Hog_ActIndex
		dc.w	Hog_Action_Move-Hog_ActIndex
; ===========================================================================

Hog_Action_TurnAround:
		subq.w	#1,hog_timedelay(a0)			; subtract 1 from pause time
		bpl.s	.chkflag				; if time remains, branch
		addq.b	#2,ob2ndRout(a0)			; advance to Hog_Action_Move
		move.w	#255,hog_timedelay(a0)			; set timer until automatic next action to just over 4 seconds
		move.w	#$40,obVelX(a0)				; move Ball Hog to the right
		move.b	#1,obAnim(a0)				; set to moving animation
		bchg	#0,obStatus(a0)				; change direction the Ball Hog is facing
		bne.s	.nochg					; if facing right now, branch
		neg.w	obVelX(a0)				; change direction

	.nochg:
		move.b	#0,hog_launched(a0)			; clear flag to launch another ball on next animation finish
		rts

	.chkflag:
		tst.b	hog_launched(a0)			; has a ball already been launched? (because it stays on frame ID 1 for 9 frames)
		bne.s	.return					; if so, branch
		cmpi.b	#2,obFrame(a0)				; is Ball Hog launching the ball?
		beq.s	.launchBall				; if so, branch

	.return:
		rts
; ---------------------------------------------------------------------------

.launchBall:
		move.b	#1,hog_launched(a0)			; set flag that cannonball has already been launched

		bsr.w	FindFreeObj				; find a free object slot
		bne.s	.return2				; if object RAM is full, branch
		_move.b	#id_Cannonball,obID(a1)			; load cannonball object ($20)
		move.w	obX(a0),obX(a1)				; copy X-position
		move.w	obY(a0),obY(a1)				; copy Y-position
		addi.w	#16,obY(a1)				; align vertically

	.return2:
		rts
; ---------------------------------------------------------------------------

Hog_Action_Move:
		subq.w	#1,hog_timedelay(a0)			; decrement timer until automatic next action
		bmi.s	Hog_Action_Move_NextAction		; if timer expired, branch

		bsr.w	SpeedToPos				; move Ball Hog horizontally

		jsr	(ObjFloorDist).l			; get distance to floor
		add.w	d1,obY(a0)				; align Ball Hog with floor
		rts
; ---------------------------------------------------------------------------

Hog_Action_Move_NextAction:
		subq.b	#2,ob2ndRout(a0)			; advance to Hog_Action_TurnAround
		move.w	#60-1,hog_timedelay(a0)			; set delay before turning around to 1 second
		move.w	#0,obVelX(a0)				; stop Ball Hog moving
		move.b	#0,obAnim(a0)				; set to still animation
		tst.b	obRender(a0)				; has Ball Hog gone offscreen?
		bpl.s	.return					; if yes, branch
		move.b	#2,obAnim(a0)				; set to launching animation

	.return:
		rts
; ===========================================================================

Hog_Display:	; Routine 4 (unused)
		bsr.w	DisplaySprite
		rts
; ===========================================================================

Hog_Delete:	; Routine 6 (unused)
		bsr.w	DeleteObject
		rts


; ===========================================================================
; ---------------------------------------------------------------------------
; Object 20 - cannonball that Ball Hog throws
; ---------------------------------------------------------------------------

Cannonball:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CBal_Index(pc,d0.w),d1
		jmp	CBal_Index(pc,d1.w)
; ===========================================================================
CBal_Index:
		dc.w	CBal_Main-CBal_Index			; 0
		dc.w	CBal_ChkExplode-CBal_Index		; 2
		dc.w	CBal_Delete-CBal_Index			; 4

CBal_time:	equ objoff_30	; frames until the cannonball explodes
; ===========================================================================

CBal_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to CBal_ChkExplode
		move.l	#Map_Cannonball,obMap(a0)		; set mappings
		move.w	#ArtTile_Cannonball|Tile_Pal2,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#3,obPriority(a0)			; set sprite priority (above Ball Hog)
		move.b	#col_12x12|col_hurt,obColType(a0)	; set ReactToItem type ($87)
		move.b	#16/2,obActWid(a0)			; set sprite display width
		move.w	#24,CBal_time(a0)			; set explosion time to 24 frames

CBal_ChkExplode:	; Routine 2
		btst	#7,obStatus(a0)				; is bit 7 of object status set?
		bne.s	CBal_Explode				; if yes, branch
		tst.w	CBal_time(a0)				; has explosion time expired?
		bne.s	CBal_DecreaseTime			; if not, branch
		jsr	(ObjFloorDist).l			; get distance to floor
		tst.w	d1					; has cannonball hit the floor?
		bpl.s	CBal_Fall				; if not, branch
		add.w	d1,obY(a0)				; align cannonball to floor

CBal_Explode:
		_move.b	#id_UnusedExplosion,obID(a0)		; change cannonball into to small explosion ($24)
		move.b	#0,obRoutine(a0)			; reset routine counter
		bra.w	UnusedExplosion				; jump to explosion code
; ===========================================================================

CBal_DecreaseTime:
		subq.w	#1,CBal_time(a0)			; subtract 1 from explosion time

CBal_Fall:
		bsr.w	ObjectFall				; make cannonball fall and update position
	if FixBugs
		move.w	(v_limitbtm2).w,d0			; get current lower level boundary
		addi.w	#224,d0					; add screen height
		cmp.w	obY(a0),d0				; has cannonball fallen off the level?
		blo.s	CBal_Delete				; if yes, delete it
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		move.w	(v_limitbtm2).w,d0			; get current lower level boundary
		addi.w	#224,d0					; add screen height
		cmp.w	obY(a0),d0				; has cannonball fallen off the level?
		blo.s	CBal_Delete				; if yes, delete it
		rts
	endif
; ===========================================================================

CBal_Delete:	; Routine 4
		bsr.w	DeleteObject
		rts