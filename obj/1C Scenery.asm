; ---------------------------------------------------------------------------
; Object 1C - scenery (GHZ bridge stump)
; ---------------------------------------------------------------------------

Scenery:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Scen_Index(pc,d0.w),d1
		jmp	Scen_Index(pc,d1.w)
; ===========================================================================
Scen_Index:	dc.w Scen_Main-Scen_Index
		dc.w Scen_ChkDel-Scen_Index
		dc.w Scen_Delete-Scen_Index
		dc.w Scen_Delete-Scen_Index
; ===========================================================================

Scen_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		mulu.w	#10,d0
		lea	Scen_Values(pc,d0.w),a1
		move.l	(a1)+,obMap(a0)
		move.w	(a1)+,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	(a1)+,obFrame(a0)
		move.b	(a1)+,obActWid(a0)
		move.b	(a1)+,obPriority(a0)
		move.b	(a1)+,obColType(a0)

Scen_ChkDel:	; Routine 2
		bsr.w	DisplaySprite
		out_of_range.w	Scen_Delete
		rts
; ===========================================================================

Scen_Delete:	; Routine 4, 6
		bsr.w	DeleteObject
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Variables for object $1C are stored in an array
; ---------------------------------------------------------------------------
Scen_Values:
		dc.l Map_Scen
		dc.w make_art_tile(ArtTile_GHZ_Spike_Pole,0,0)
		dc.b 0, $10, 4, $82
		dc.l Map_Scen
		dc.w make_art_tile(ArtTile_GHZ_Spike_Pole,0,0)
		dc.b 1, $14, 4, $83
		dc.l Map_Scen
		dc.w make_art_tile(ArtTile_Level,2,0)
		dc.b 0, $20, 1, 0
		dc.l Map_Bri
		dc.w make_art_tile(ArtTile_GHZ_Bridge,2,0)
		dc.b 1, $10, 1, 0