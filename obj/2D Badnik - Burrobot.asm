; ===========================================================================
; ---------------------------------------------------------------------------
; Object 2D - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------

Burrobot:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Burro_Index(pc,d0.w),d1
		jmp	Burro_Index(pc,d1.w)
; ===========================================================================
Burro_Index:
		dc.w	Burro_Main-Burro_Index
		dc.w	Burro_Action-Burro_Index
		dc.w	Burro_Delete-Burro_Index

burro_timedelay: equ objoff_30	; timer used for waiting before turning around, or automatic action changes
burro_checktype: equ objoff_32	; (while moving) flag to alternate between checking ledges ahead or aligning to floor
; ===========================================================================

Burro_Main:	; Routine 0
		move.b	#38/2,obHeight(a0)			; set height
		move.b	#16/2,obWidth(a0)			; set width
		move.l	#Map_Burro,obMap(a0)			; set mappings
		move.w	#ArtTile_Burrobot|Tile_Pal2,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#col_24x36|col_badnik,obColType(a0)	; set ReactToItem type
		move.b	#24/2,obActWid(a0)			; set sprite display width
		bset	#0,obStatus(a0)				; set Burrobot to face right

		; Make the Burrobot fall until it has collided with the floor (while invisible)
		bsr.w	ObjectFall				; increase gravity and update position
		bsr.w	ObjFloorDist				; get distance between Burrobot and floor
		tst.w	d1					; has Burrobot hit the floor?
		bpl.s	.hide					; if not, branch
		add.w	d1,obY(a0)				; match object's position with the floor
		move.w	#0,obVelY(a0)				; clear falling speed
		addq.b	#2,obRoutine(a0)			; advance to Burro_Action

	.hide:

	if FixBugs
		; Fix badnik invisibly falling forever if it doesn't have a floor beneath it
		cmpi.w	#$7FF,obY(a0)				; has object fallen below max level height?
		bhi.w	DeleteObject				; if yes, delete it
	endif
		rts
; ===========================================================================

Burro_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Burro_ActIndex(pc,d0.w),d1
		jsr	Burro_ActIndex(pc,d1.w)

		lea	(Ani_Burro).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
Burro_ActIndex:
		dc.w	Burro_Action_TurnAround-Burro_ActIndex
		dc.w	Burro_Action_Move-Burro_ActIndex
		dc.w	Burro_Action_Jump-Burro_ActIndex
; ===========================================================================

Burro_Action_TurnAround:
		subq.w	#1,burro_timedelay(a0)			; decrement timer to wait before turning around
		bpl.s	.return					; if time remains, branch

		addq.b	#2,ob2ndRout(a0)			; advance to Burro_Action_Move
		move.w	#255,burro_timedelay(a0)		; set timer until automatic next action to just over 4 seconds
		move.w	#$80,obVelX(a0)				; move Burrobot to the right
		move.b	#1,obAnim(a0)				; set to moving animation
		bchg	#0,obStatus(a0)				; change direction the Burrobot is facing
		beq.s	.return					; if facing right now, branch
		neg.w	obVelX(a0)				; move to the left if facing left now

	.return:
		rts
; ===========================================================================

Burro_Action_Move:
		subq.w	#1,burro_timedelay(a0)			; decrement timer until automatic next action
		bmi.s	Burro_Action_Move_NextAction		; if timer expired, branch

		bsr.w	SpeedToPos				; move Burrobot horizontally

		bchg	#0,burro_checktype(a0)			; alternate between floor align and ledge check every frame
		bne.s	.alignToFloor				; branch if floor align should be done (maybe for performance reasons?)

	.checkLedgeAhead:
		move.w	obX(a0),d3				; get Burrobot's current X-position
		addi.w	#12,d3					; look 12px ahead to the right
		btst	#0,obStatus(a0)				; is Burrobot currently facing to the left?
		bne.s	.doLedgeCheck				; if not, branch
		subi.w	#12*2,d3				; look 12px ahead to the left instead
	.doLedgeCheck:
		bsr.w	ObjFloorDist2				; get floor distance 16px ahead (left or right)
		cmpi.w	#$C,d1					; is there a large drop ahead?
		bge.s	Burro_Action_Move_NextAction		; if yes, branch
		rts
; ---------------------------------------------------------------------------

	.alignToFloor:
		bsr.w	ObjFloorDist				; get distance to floor
		add.w	d1,obY(a0)				; align Burrobot with floor
		rts
; ---------------------------------------------------------------------------

Burro_Action_Move_NextAction:
		; This acts as a 50/50 chance to either jump again or turn around,
		; based on what the current VBlank frame counter value happens to be.
		btst	#2,(v_vblank_byte).w			; are we on frame 0-3 in an 8-frame window?
		beq.s	.jumpAgain				; if yes, branch

	.turnAround:
		subq.b	#2,ob2ndRout(a0)			; go back to Burro_Action_TurnAround
		move.w	#60-1,burro_timedelay(a0)		; set delay before turning around to 1 second
		move.w	#0,obVelX(a0)				; stop Burrobot moving
		move.b	#0,obAnim(a0)				; set to still animation
		rts
; ---------------------------------------------------------------------------

	.jumpAgain:
		addq.b	#2,ob2ndRout(a0)			; advance to Burro_Action_Jump
		move.w	#-$400,obVelY(a0)			; launch Burrobot upwards
		move.b	#2,obAnim(a0)				; set to drilling animation
		rts
; ===========================================================================

Burro_Action_Jump:
		bsr.w	SpeedToPos				; update Burrobot's position
		addi.w	#$18,obVelY(a0)				; make Burrobot fall faster
		bmi.s	.return					; if still moving upwards, branch
		move.b	#3,obAnim(a0)				; set to fall animation

		bsr.w	ObjFloorDist				; get distance to floor
		tst.w	d1					; has Burrobot landed on floor?
		bpl.s	.return					; if not, branch
		add.w	d1,obY(a0)				; align Burrobot to floor

		move.w	#0,obVelY(a0)				; stop Burrobot falling
		move.b	#1,obAnim(a0)				; set to moving animation
		move.w	#255,burro_timedelay(a0)		; set timer until automatic next action to just over 4 seconds
		subq.b	#2,ob2ndRout(a0)			; go back to Burro_Action_Move

	.return:
		rts
; ===========================================================================

Burro_Delete:	; Routine 4 (unused)
		bsr.w	DeleteObject
		rts
; ===========================================================================

		include	"_anim/Burrobot.asm"
Map_Burro:	include	"_maps/Burrobot.asm"
