; ===========================================================================
; ---------------------------------------------------------------------------
; Object 4B - giant ring for entry to special stage
; ---------------------------------------------------------------------------

GiantRing:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	GRing_Index(pc,d0.w),d1
		jmp	GRing_Index(pc,d1.w)
; ===========================================================================
GRing_Index:
		dc.w	GRing_Main-GRing_Index
		dc.w	GRing_Animate-GRing_Index
		dc.w	GRing_Collect-GRing_Index
		dc.w	GRing_Delete-GRing_Index
; ===========================================================================

GRing_Main:	; Routine 0
		lea	(v_objstate).w,a2			; load object respawn table
		moveq	#0,d0					; clear d0 for word-based addressing
		move.b	obRespawnNo(a0),d0			; get respawn table index
		lea	2(a2,d0.w),a2				; load respawn table data into a2
		bclr	#7,(a2)					; immediately clear respawn block flag
		addq.b	#2,obRoutine(a0)			; advance to GRing_Animate
		move.l	#Map_GRing,obMap(a0)			; set mappings
		move.w	#ArtTile_Giant_Ring|Tile_Pal2,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield positioned mode
		move.b	#2,obPriority(a0)			; set sprite priority
		move.b	#col_24x64|col_item,obColType(a0)	; set col type (ReactToItem will advance obRoutine on collection)
		move.b	#24/2,obActWid(a0)			; set sprite display width
; ---------------------------------------------------------------------------

GRing_Animate:	; Routine 2
		move.b	(v_ani1_frame).w,obFrame(a0)		; set frame (updated in SynchroAnimate => Sync2)
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject on
		; the same frame, or else cause a null-pointer dereference.
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ===========================================================================

GRing_Collect:	; Routine 4
		addq.b	#2,obRoutine(a0)			; advance to GRing_Delete
		move.b	#col_none,obColType(a0)			; disable further collision with ring
		move.b	#1,obPriority(a0)			; set sprite priority
; ---------------------------------------------------------------------------

GRing_Delete:	; Routine 6
		move.b	#id_VanishSonic,(v_vanishsonic).w
		moveq	#plcid_Warp,d0
		bsr.w	AddPLC
		bra.w	DeleteObject