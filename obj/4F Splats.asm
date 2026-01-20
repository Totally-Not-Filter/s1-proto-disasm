; ---------------------------------------------------------------------------
; Object 4F - Splats (scrapped Marble Zone badnik)
; ---------------------------------------------------------------------------
 
Obj4F:
Splats:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	.index(pc,d0.w),d1
		jmp .index(pc,d1.w)
; ---------------------------------------------------------------------------
.index:		dc.w .init-.index			; 0 - object init
		dc.w .waitforsonic-.index		; 2 - wait for Sonic to enter a certain trigger zone (bounce in place until then)
		dc.w .chkbounce-.index			; 4 - trigger zone entered, apply movement and check for floor to bounce
		dc.w .fallthroughfloor-.index		; 6 - special case after hitting lava: phase through floor and despawn on screen exit
; ---------------------------------------------------------------------------
 
.init:
		addq.b	#2,obRoutine(a0)		; set to WaitForSonic
		move.l	#Map_Splats,obMap(a0)		; set maps
		move.w	#make_art_tile(ArtTile_Splats,1,0),obGfx(a0) ; set art tile
		move.b	#4,obRender(a0)			; set render flags
		move.b	#4,obPriority(a0)		; set sprite priority
		move.b	#$C,obActWid(a0)		; set width
		move.b	#$14,obHeight(a0)		; set height
		move.b	#2,obColType(a0)		; set coltype to badnik
		tst.b	obSubtype(a0)			; is subtype anything but zero?
		beq.s	.waitforsonic			; if not, branch
		move.w	#$300,d2			; set trigger zone to start moving to be significantly larger
		bra.s	.triggerzoneset			; skip
; ---------------------------------------------------------------------------
 
.waitforsonic:
		move.w	#$E0,d2				; set default (small) trigger zone
 
.triggerzoneset:
		move.w	#$100,d1			; prepare X velocity to be $100
		bset	#0,obRender(a0)			; make object face to the right
		move.w	(v_player+obX).w,d0		; get Sonic's X position
		sub.w	obX(a0),d0			; subtract object's X position
		bcc.s	.chktriggerzonehit		; if object is to the right of Sonic, branch
		neg.w	d0				; negate distance
		neg.w	d1				; negate prepared X velocity
		bclr	#0,obRender(a0)			; make object face to the left
 
.chktriggerzonehit:
		cmp.w	d2,d0				; is Sonic within the trigger zone?
		bcc.s	.chkbounce			; if not, bounce in place
		move.w	d1,obVelX(a0)			; begin moving horizontally
		addq.b	#2,obRoutine(a0)		; set to .chkbounce
 
.chkbounce:
		bsr.w	ObjectFall			; apply gravity
		move.b	#1,obFrame(a0)			; set frame to 1 (bouncy, flappy ears)
		tst.w	obVelY(a0)			; is object moving upwards?
		bmi.s	.chkwall			; if yes, branch
		move.b	#0,obFrame(a0)			; set frame to 0 (standard, long ears)
		bsr.w	ObjFloorDist			; get object distance to floor
		tst.w	d1				; is object above floor?
		bpl.s	.chkwall			; if yes, branch
		move.w	(a1),d0				; get floor block object is standing on
		andi.w	#$3FF,d0			; ignore solid/orientation bits (i.e. only look at the actual block ID)
		cmpi.w	#$2D2,d0			; is the touched block ID a lava tile? (technically, this should be $2FB, but most of the tiles before are blank/background)
		bcs.s	.bounce				; if not, branch
		addq.b	#2,obRoutine(a0)		; set to .fallthroughfloor (makes object fall into lava upon contact)
		bra.s	.chkwall			; skip
; ---------------------------------------------------------------------------
 
.bounce:
		add.w	d1,obY(a0)			; fix to floor (add floor difference to Y pos)
		move.w	#-$400,obVelY(a0)		; bounce up
 
.chkwall:
		bsr.w	ChkHitLeftRightWall		; check if object hit a wall to the left or right
		beq.s	.display			; if not, branch
		neg.w	obVelX(a0)			; invert X movement direction
		bchg	#0,obRender(a0)			; invert sprite flip (render flags)
		bchg	#0,obStatus(a0)			; invert sprite flip (status flags)
 
.display:
		bra.w	RememberState			; display
; ---------------------------------------------------------------------------
 
.fallthroughfloor:
		bsr.w	ObjectFall			; apply gravity
	if FixBugs					; BUGFIX: objects should never be deleted after they have already been queued for display
		tst.b	obRender(a0)			; is object still on screen?
		bpl.w	DeleteObject			; if not, delete
		bra.w	DisplaySprite			; display
	else
		bsr.w	DisplaySprite			; display
		tst.b	obRender(a0)			; is object still on screen?
		bpl.w	DeleteObject			; if not, delete
		rts					; return
	endif
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
 
sub_D2DA:	; this routine is shared with Yadrin
ChkHitLeftRightWall:
		move.w	(v_framecount).w,d0		; get frame counter
		add.w	d7,d0				; add object object enumerator from RAM
		andi.w	#3,d0				; and by 3 (effectively makes it so it's only checked every 4 frames, presumably for performance reasons)
		bne.s	.nowallhit			; if outside a 4th frame, branch
		moveq	#0,d3				; clear d3
		move.b	obActWid(a0),d3			; load object width to d3 (input param for wall col detection subroutines)
		tst.w	obVelX(a0)			; is object moving to the left?
		bmi.s	.chkleftwall			; if yes, branch
		bsr.w	ObjHitWallRight			; get distance to nearest right wall
		tst.w	d1				; did object hit wall?
		bpl.s	.nowallhit			; if not, branch
 
.wallhit:
		moveq	#1,d0				; set Z-flag (wall touched)
		rts
; ---------------------------------------------------------------------------
 
.chkleftwall:
		not.w	d3				; invert object width to make it work for left wall col
		bsr.w	ObjHitWallLeft			; get distance to nearest left wall
		tst.w	d1				; did object hit wall?
		bmi.s	.wallhit			; if yes, branch
 
.nowallhit:
		moveq	#0,d0				; clear Z-flag (wall not touched)
		rts					; return