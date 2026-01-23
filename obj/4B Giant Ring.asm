; ---------------------------------------------------------------------------
; Object 4B - giant ring for entry to special stage
; ---------------------------------------------------------------------------

GiantRing:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	GRing_Index(pc,d0.w),d1
		jmp	GRing_Index(pc,d1.w)
; ===========================================================================
GRing_Index:	dc.w GRing_Main-GRing_Index
		dc.w GRing_Animate-GRing_Index
		dc.w GRing_Collect-GRing_Index
		dc.w GRing_Delete-GRing_Index
; ===========================================================================

GRing_Main:	; Routine 0
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		lea	2(a2,d0.w),a2
		bclr	#7,(a2)
		addq.b	#2,obRoutine(a0)
		move.l	#Map_GRing,obMap(a0)
		move.w	#make_art_tile(ArtTile_Giant_Ring,1,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#2,obPriority(a0)
		move.b	#$52,obColType(a0)
		move.b	#12,obActWid(a0)

GRing_Animate:	; Routine 2
		move.b	(v_ani1_frame).w,obFrame(a0)
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ===========================================================================

GRing_Collect:	; Routine 4
		addq.b	#2,obRoutine(a0)
		move.b	#0,obColType(a0)
		move.b	#1,obPriority(a0)

GRing_Delete:	; Routine 6
		move.b	#id_VanishSonic,(v_objslot7).w
		moveq	#plcid_Warp,d0
		bsr.w	AddPLC
		bra.w	DeleteObject