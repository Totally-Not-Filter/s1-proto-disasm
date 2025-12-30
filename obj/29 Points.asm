; ---------------------------------------------------------------------------

ObjPoints:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_7500(pc,d0.w),d1
	if FixBugs
		jmp	off_7500(pc,d1.w)
	else
		jsr	off_7500(pc,d1.w)
		bra.w	DisplaySprite
	endif
; ---------------------------------------------------------------------------

off_7500:	dc.w ObjPoints_Init-off_7500
		dc.w ObjPoints_Act-off_7500
; ---------------------------------------------------------------------------

ObjPoints_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Poi,obMap(a0)
		move.w	#make_art_tile(ArtTile_Points,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.w	#-$300,obVelY(a0)

ObjPoints_Act:
		tst.w	obVelY(a0)
		bpl.w	DeleteObject
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif