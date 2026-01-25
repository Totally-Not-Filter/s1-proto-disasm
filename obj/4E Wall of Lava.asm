; ---------------------------------------------------------------------------
; Object 4E - advancing wall of lava (MZ)
; ---------------------------------------------------------------------------

LavaWall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LWall_Index(pc,d0.w),d1
		jmp	LWall_Index(pc,d1.w)
; ===========================================================================
LWall_Index:	dc.w LWall_Main-LWall_Index
		dc.w LWall_Action-LWall_Index
		dc.w LWall_Solid-LWall_Index
		dc.w LWall_Move-LWall_Index
		dc.w LWall_Delete-LWall_Index

lwall_flag = objoff_36		; flag to start wall moving
; ===========================================================================

LWall_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bra.s	.make
; ===========================================================================

.loop:
		bsr.w	FindNextFreeObj
		bne.s	.fail

.make:
		_move.b	#id_LavaWall,obID(a1)	; load object
		move.l	#Map_LWall,obMap(a1)
		move.w	#make_art_tile(ArtTile_MZ_Lava,3,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$50,obActWid(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#1,obPriority(a1)
		move.b	#0,obAnim(a1)
		move.b	#$94,obColType(a1)
		move.l	a0,objoff_3C(a1)

.fail:
		dbf	d1,.loop	; repeat sequence once

		addq.b	#6,obRoutine(a1)
		move.b	#4,obFrame(a1)

LWall_Action:	; Routine 2
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	.rangechk
		neg.w	d0

.rangechk:
		cmpi.w	#$E0,d0		; is Sonic within $E0 pixels (x-axis)?
		bhs.s	.movewall	; if not, branch
		move.w	(v_player+obY).w,d0
		sub.w	obY(a0),d0
		bcc.s	.rangechk2
		neg.w	d0

.rangechk2:
		cmpi.w	#$60,d0		; is Sonic within $60 pixels (y-axis)?
		bhs.s	.movewall	; if not, branch
		move.b	#1,lwall_flag(a0) ; set object to move
		bra.s	LWall_Solid
; ===========================================================================

.movewall:
		tst.b	lwall_flag(a0)	; is object set to move?
		beq.s	LWall_Solid	; if not, branch
		move.w	#$100,obVelX(a0) ; set object speed
		addq.b	#2,obRoutine(a0)

LWall_Solid:	; Routine 4
		cmpi.w	#$6A0,obX(a0)	; has object reached $6A0 on the x-axis?
		bne.s	.animate	; if not, branch
		clr.w	obVelX(a0)	; stop object moving
		clr.b	lwall_flag(a0)

.animate:
		lea	(Ani_LWall).l,a1
		bsr.w	AnimateSprite
		bsr.w	SpeedToPos
	if FixBugs
		tst.b	lwall_flag(a0)	; is wall already moving?
		bne.s	.moving		; if yes, branch
		out_of_range.s	.chkgone

.moving:
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		tst.b	lwall_flag(a0)	; is wall already moving?
		bne.s	.moving		; if yes, branch
		out_of_range.s	.chkgone

.moving:
		rts
	endif
; ===========================================================================

.chkgone:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		bclr	#7,2(a2,d0.w)
		move.b	#8,obRoutine(a0)
		rts
; ===========================================================================

LWall_Move:	; Routine 6
		movea.l	objoff_3C(a0),a1
		cmpi.b	#8,obRoutine(a1)
		beq.s	LWall_Delete
		move.w	obX(a1),obX(a0)	; move rest of lava wall
		subi.w	#$80,obX(a0)
		bra.w	DisplaySprite
; ===========================================================================

LWall_Delete:	; Routine 8
		bra.w	DeleteObject