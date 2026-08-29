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
		dc.w	Obj1B_Main-Obj1B_Index			; 0
		dc.w	Obj1B_Platform-Obj1B_Index		; 2
		dc.w	Obj1B_StoodOn-Obj1B_Index		; 4
		dc.w	Obj1B_Display-Obj1B_Index		; 6
		dc.w	Obj1B_Delete-Obj1B_Index		; 8 (unused)
; ===========================================================================

Obj1B_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Obj1B_Platform
		move.l	#Map_1B,obMap(a0)			; set mappings
		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a0)	; set art tile and palette line
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.b	#64/2,obActWid(a0)			; set sprite display width
		move.b	#5,obPriority(a0)			; set sprite priority
		tst.b	obSubtype(a0)				; is subtype not zero?
		bne.s	Obj1B_Platform				; if so, branch
		move.b	#1,obPriority(a0)			; set sprite priority
		move.b	#6,obRoutine(a0)			; advance to Obj1B_Display
		rts
; ===========================================================================

Obj1B_Platform:	; Routine 2
		move.w	#64/2,d1				; set platform solidity width
		move.w	#-40/2,d3				; set platform solidity height as input
		bsr.w	PlatformObject_CustomHeight		; enable platform behavior (sets obRoutine = 4 (Obj1B_StoodOn) when stood on)
	if FixBugs=0
		bsr.w	DisplaySprite
	endif
		bra.w	Obj1B_ChkDel
; ===========================================================================

Obj1B_StoodOn:	; Routine 4
		move.w	#64/2,d1				; set platform solidity width
		bsr.w	ExitPlatform				; allow Sonic exiting platform (sets obRoutine = 2 (Obj1B_Platform) on exit)
		move.w	obX(a0),d2				; get object's X position
		move.w	#-40/2,d3				; set platform solidity height
		bsr.w	MvSonicOnPtfm				; move Sonic with platform
	if FixBugs=0
		bsr.w	DisplaySprite
	endif
		bra.w	Obj1B_ChkDel
		rts						; useless rts
; ===========================================================================

Obj1B_ChkDel:
		out_of_range.w	.delete				; has object gone out of range? if yes, delete it
	if FixBugs
		bra.w	DisplaySprite				; otherwise, display object
	else
		rts
	endif

.delete:
		bsr.w	DeleteObject
		rts
; ===========================================================================

Obj1B_Display:	; Routine 6
	if FixBugs=0
		bsr.w	DisplaySprite
	endif
		bra.w	Obj1B_ChkDel
; ===========================================================================

Obj1B_Delete:	; Routine 8 (unused)
		bsr.w	DeleteObject
		rts

; ===========================================================================

Map_1B:		include "_maps/1B.asm"