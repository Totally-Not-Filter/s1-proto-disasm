; ===========================================================================
; ---------------------------------------------------------------------------
; Object 1C - scenery (GHZ bridge stump)
; ---------------------------------------------------------------------------

Scenery:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Scen_Index(pc,d0.w),d1
		jmp	Scen_Index(pc,d1.w)
; ===========================================================================
Scen_Index:
		dc.w	Scen_Main-Scen_Index			; 0
		dc.w	Scen_ChkDel-Scen_Index			; 2
		dc.w	Scen_Delete-Scen_Index			; 4
		dc.w	Scen_Delete-Scen_Index			; 6
; ===========================================================================

Scen_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Scen_ChkDel

		moveq	#0,d0
		move.b	obSubtype(a0),d0			; get subtype of scenery object
		mulu.w	#$A,d0					; multiply by $A (size per Scen_Values entry)
		lea	Scen_Values(pc,d0.w),a1			; load setup values for specified subtype
		move.l	(a1)+,obMap(a0)				; load mappings address
		move.w	(a1)+,obGfx(a0)				; load art tile and palette line
		ori.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	(a1)+,obFrame(a0)			; set frame ID
		move.b	(a1)+,obActWid(a0)			; set sprite display width
		move.b	(a1)+,obPriority(a0)			; set sprite priority
		move.b	(a1)+,obColType(a0)			; set collision type (always 0)
; ---------------------------------------------------------------------------

Scen_ChkDel:	; Routine 2
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject on
		; the same frame, or else cause a null-pointer dereference.
		out_of_range.w	Scen_Delete			; delete object if it has gone offscreen
		bra.w	DisplaySprite				; otherwise, keep displaying it
	else
		bsr.w	DisplaySprite
		out_of_range.w	Scen_Delete			; delete object if it has gone offscreen
		rts
	endif
; ===========================================================================

Scen_Delete:	; Routine 4, 6
		bsr.w	DeleteObject
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Setup values for scenery objects:
; - mappings address
; - VRAM setting
; - frame, width, priority, collision response
; ---------------------------------------------------------------------------
Scen_Values:
		; Unknown
		dc.l Map_Scen
		dc.w ArtTile_GHZ_Spike_Pole
		dc.b 0, 32/2, 4, col_24x40|col_hurt

		; Unknown
		dc.l Map_Scen
		dc.w ArtTile_GHZ_Spike_Pole
		dc.b 1, 40/2, 4, col_40x24|col_hurt

		; Unknown
		dc.l Map_Scen
		dc.w ArtTile_Level|Tile_Pal3
		dc.b 0, 64/2, 1, col_none

		; GHZ bridge stump
		dc.l Map_Bri
		dc.w ArtTile_GHZ_Bridge|Tile_Pal3
		dc.b 1, 32/2, 1, col_none

		even

; ===========================================================================

Map_Scen:	include	"_maps/Scenery.asm"
