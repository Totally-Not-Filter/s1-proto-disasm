; ===========================================================================
; ---------------------------------------------------------------------------
; Object 43 - Roller enemy (SZ)
; ---------------------------------------------------------------------------

Roller:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Roll_Index(pc,d0.w),d1
		jmp	Roll_Index(pc,d1.w)
; ===========================================================================
Roll_Index:
		dc.w	Roll_Main-Roll_Index
		dc.w	Roll_Action-Roll_Index
		dc.w	Roll_Delete-Roll_Index

roll_stateflags:	equ objoff_32	; flags (bit 0 set if hit a ledge before // bit 7 set if Roller has unfolded before)
; ===========================================================================

Roll_Main:	; Routine 0
		move.b	#28/2,obHeight(a0)			; set height
		move.b	#16/2,obWidth(a0)			; set width

		; Make the Roller fall until it has collided with the floor (while invisible)
		bsr.w	ObjectFall				; increase gravity and update position
		bsr.w	ObjFloorDist				; get distance between Roller and floor
		tst.w	d1					; has Roller hit the floor?
		bpl.s	.hide					; if not, branch
		add.w	d1,obY(a0)				; match object's position with the floor
		move.w	#0,obVelY(a0)				; clear falling speed
		addq.b	#2,obRoutine(a0)			; advance to Moto_Action
		move.l	#Map_Roll,obMap(a0)			; set mappings
		move.w	#ArtTile_Roller|Tile_Pal2,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	#32/2,obActWid(a0)			; set sprite display width
		move.b	#col_28x28|col_hurt,obColType(a0)	; make Roller invincible and damaging ($8E)
	.hide:

	if FixBugs
		; Fix badnik invisibly falling forever if it doesn't have a floor beneath it
		cmpi.w	#$7FF,obY(a0)				; has object fallen below max level height?
		bhi.w	DeleteObject				; if yes, delete it
	endif
		rts						; return (and do NOT display sprite yet)
; ===========================================================================

Roll_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0			; get secondary routine counter
		move.w	Roll_ActIndex(pc,d0.w),d1		; find current secondary index
		jsr	Roll_ActIndex(pc,d1.w)			; jump there and return here

		lea	(Ani_Roll).l,a1				; load animation script
		bsr.w	AnimateSprite				; animate Roller
		bra.w	RememberState				; display or handle offscreen deletion
; ===========================================================================
Roll_ActIndex:
		dc.w	Roll_Action_FromLeft-Roll_ActIndex
		dc.w	Roll_Action_Unfolded-Roll_ActIndex
		dc.w	Roll_Action_Rolling-Roll_ActIndex
		dc.w	Roll_Action_Jumping-Roll_ActIndex
; ===========================================================================

Roll_Action_FromLeft:
		move.w	(v_player+obX).w,d0			; get Sonic's X-position
		sub.w	obX(a0),d0				; check distance between Roller and Sonic
		blo.s	.return
		cmpi.w	#32,d0
		bhs.s	.return
		addq.b	#2,ob2ndRout(a0)			; advance to Roll_Action_Unfolded
		move.b	#1,obAnim(a0)				; set to rolling animation
		move.w	#$400,obVelX(a0)			; move Roller horizontally to the right

	.return:
		rts
; ===========================================================================

Roll_Action_Unfolded:
		cmpi.b	#2,obAnim(a0)				; has Roller advanced to rolling animation again? (handled in animation script)
		bne.s	.return					; if not, branch
		addq.b	#2,ob2ndRout(a0)			; advance to Roll_Action_Rolling

	.return:
		rts
; ===========================================================================

Roll_Action_Rolling:
		bsr.w	SpeedToPos				; update Roller's position

		bsr.w	ObjFloorDist				; find Roller's distance to floor
		cmpi.w	#-8,d1					; is there a steep upward slope ahead?
		blt.s	.ledgeHit				; if yes, branch
		cmpi.w	#$C,d1					; is there a large drop ahead?
		bge.s	.ledgeHit				; if yes, branch
		add.w	d1,obY(a0)				; match Roller's position with the floor
		rts
; ---------------------------------------------------------------------------

	.ledgeHit:
		addq.b	#2,ob2ndRout(a0)			; advance to Roll_Action_Jumping
		bset	#0,roll_stateflags(a0)			; set flag that Roller hit a ledge before
		beq.s	.return					; if this is the first ledge hit, branch
		move.w	#-$600,obVelY(a0)			; launch Roller upwards

	.return:
		rts
; ===========================================================================

Roll_Action_Jumping:
		bsr.w	ObjectFall				; make Roller fall and update positions

		tst.w	obVelY(a0)				; is Roller still going upwards?
		bmi.s	.return					; if yes, branch
		bsr.w	ObjFloorDist				; get distance to floor
		tst.w	d1					; has Roller hit the floor again?
		bpl.s	.return					; if not, branch

		add.w	d1,obY(a0)				; match Roller's position with the floor
		subq.b	#2,ob2ndRout(a0)			; go back to Roll_Action_Rolling
		move.w	#0,obVelY(a0)				; stop Roller falling

	.return:
		rts
; ===========================================================================

Roll_Delete:	; Routine 4
		bra.w	DeleteObject
; ===========================================================================

		include "_anim/Roller.asm"
Map_Roll:	include "_maps/Roller.asm"