; ---------------------------------------------------------------------------
; Object 20 - cannonball that Ball Hog throws
; ---------------------------------------------------------------------------

Cannonball:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Cbal_Index(pc,d0.w),d1
		jmp	Cbal_Index(pc,d1.w)
; ===========================================================================
Cbal_Index:	dc.w Cbal_Main-Cbal_Index
		dc.w Cbal_ChkExplode-Cbal_Index
		dc.w Cbal_Delete-Cbal_Index

cbal_time = objoff_30		; time until the cannonball explodes (2 bytes)
; ===========================================================================

Cbal_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#MapCannonball,obMap(a0)
		move.w	#make_art_tile(ArtTile_Cannonball,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#8,obActWid(a0)
		move.w	#24,cbal_time(a0)

Cbal_ChkExplode:	; Routine 2
		btst	#7,obStatus(a0)
		bne.s	Cbal_Explode
		tst.w	cbal_time(a0)
		bne.s	Cbal_DecreaseTime
		jsr	(ObjFloorDist).l
		tst.w	d1		; has ball hit the floor?
		bpl.s	Cbal_Fall	; if not, branch
		add.w	d1,obY(a0)

Cbal_Explode:
		_move.b	#id_MissileDissolve,obID(a0)
		move.b	#0,obRoutine(a0)
		bra.w	MissileDissolve
; ===========================================================================

Cbal_DecreaseTime:
		subq.w	#1,cbal_time(a0) ; subtract 1 from explosion time

Cbal_Fall:
		bsr.w	ObjectFall
	if ~~FixBugs
		; Moved to prevent a display-and-delete bug.
		bsr.w	DisplaySprite
	endif
		move.w	(v_limitbtm2).w,d0
		addi.w	#224,d0
		cmp.w	obY(a0),d0	; has object fallen off the level?
		blo.s	Cbal_Delete	; if yes, branch
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ===========================================================================

Cbal_Delete:	; Routine 4
		bsr.w	DeleteObject
		rts