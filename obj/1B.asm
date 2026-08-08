; ---------------------------------------------------------------------------
; Object 1B - Platform object
; ---------------------------------------------------------------------------

Obj1B:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj1B_Index(pc,d0.w),d1
		jmp	Obj1B_Index(pc,d1.w)
; ===========================================================================
Obj1B_Index:
		dc.w	loc_663E-Obj1B_Index
		dc.w	loc_6676-Obj1B_Index
		dc.w	loc_668A-Obj1B_Index
		dc.w	loc_66CE-Obj1B_Index
		dc.w	loc_66D6-Obj1B_Index
; ===========================================================================

loc_663E:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_1B,obMap(a0)
		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#32,obActWid(a0)
		move.b	#5,obPriority(a0)
		tst.b	obSubtype(a0)
		bne.s	loc_6676
		move.b	#1,obPriority(a0)
		move.b	#6,obRoutine(a0)
		rts
; ===========================================================================

loc_6676:
		move.w	#$20,d1
		move.w	#-$14,d3
		bsr.w	Swing_Solid
	if FixBugs=0
		bsr.w	DisplaySprite
	endif
		bra.w	loc_66A8
; ===========================================================================

loc_668A:
		move.w	#$20,d1
		bsr.w	ExitPlatform
		move.w	obX(a0),d2
		move.w	#-$14,d3
		bsr.w	MvSonicOnPtfm
	if FixBugs=0
		bsr.w	DisplaySprite
	endif
		bra.w	loc_66A8

		rts
; ===========================================================================

loc_66A8:
		out_of_range.w	loc_66C8
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ===========================================================================

loc_66C8:
		bsr.w	DeleteObject
		rts
; ===========================================================================

loc_66CE:
	if FixBugs=0
		bsr.w	DisplaySprite
	endif
		bra.w	loc_66A8
; ===========================================================================

loc_66D6:
		bsr.w	DeleteObject
		rts