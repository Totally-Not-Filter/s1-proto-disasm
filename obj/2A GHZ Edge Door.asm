; ---------------------------------------------------------------------------
; Object 2A - Edge Door (Unused in GHZ)
; ---------------------------------------------------------------------------

Obj2A:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj2A_Index(pc,d0.w),d1
		jmp	Obj2A_Index(pc,d1.w)
; ===========================================================================
Obj2A_Index:
		dc.w	Obj2A_Main-Obj2A_Index
		dc.w	Obj2A_Press-Obj2A_Index
		dc.w	Obj2A_Display-Obj2A_Index

edgedoor_finaly:	equ objoff_30	; copy of the Y-position, subtracted by 32 (2 bytes)
; ===========================================================================

Obj2A_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Obj2A_Press
		move.l	#Map_Edge_Door,obMap(a0)		; set mappings
		move.w	#ArtTile_Level,obGfx(a0)		; set art tile
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode
		move.w	obY(a0),d0				; get object's Y-position
		subi.w	#32,d0					; subtract 32 pixels from it
		move.w	d0,edgedoor_finaly(a0)			; set it into height register
		move.b	#22/2,obActWid(a0)			; set sprite display width
		move.b	#5,obPriority(a0)			; set sprite priority
		tst.b	obSubtype(a0)				; is subtype 0?
		beq.s	Obj2A_Press				; if so, branch
		move.b	#1,obFrame(a0)				; set sprite frame
		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a0)	; set art tile and palette line
		move.b	#4,obPriority(a0)			; set sprite priority
		addq.b	#2,obRoutine(a0)			; advance to Obj2A_Display

Obj2A_Press:	; Routine 2
		tst.w	(f_switch).w				; has switch been pressed?
		beq.s	.notpressed				; if not, branch
		subq.w	#1,obY(a0)				; lower door by 1 pixel per frame
		move.w	edgedoor_finaly(a0),d0			; get final lowered Y-position
		cmp.w	obY(a0),d0				; does Edge Door's Y-position match with final Y-position?
		beq.w	DeleteObject				; if so, delete the Edge Door

.notpressed:
		move.w	#44/2,d1				; set collision detection width
		move.w	#32/2,d2				; set collision detection height
		bsr.w	EdgeWall_SolidWall			; check if Sonic has collided with the wall and stop him if so

Obj2A_Display:	; Routine 4
	if FixBugs
		; Objects shouldn't call DisplaySprite and DeleteObject on
		; the same frame, or else cause a null-pointer dereference.
		out_of_range.w	DeleteObject			; has object gone out of range? if yes, delete it
		bra.w	DisplaySprite				; otherwise, display object
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject			; has object gone out of range? if yes, delete it
		rts
	endif
; ===========================================================================

		include	"obj/sub SolidWall.asm"

Map_Edge_Door:	include "_maps/GHZ Edge Door.asm"