; ===========================================================================
; ---------------------------------------------------------------------------
; Object 54 - invisible lava tag (MZ)
; ---------------------------------------------------------------------------

LavaTag:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	LTag_Index(pc,d0.w),d1
		jmp	LTag_Index(pc,d1.w)
; ===========================================================================
LTag_Index:
		dc.w	LTag_Main-LTag_Index
		dc.w	LTag_ChkDel-LTag_Index

LTag_ColTypes:	; collision types for ReactToItem
		dc.b	col_64x64|col_hurt 	; subtype 00 - damaging, 64x64  (small)
		dc.b	col_128x64|col_hurt	; subtype 01 - damaging, 128x64 (medium)
		dc.b	col_256x64|col_hurt	; subtype 02 - damaging, 256x64 (large)
		even
; ===========================================================================

LTag_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to LTag_ChkDel
		moveq	#0,d0
		move.b	obSubtype(a0),d0			; get size in subtype (0-2)
		move.b	LTag_ColTypes(pc,d0.w),obColType(a0)	; set collision response type/size based on subtype
		move.l	#Map_LTag,obMap(a0)			; set mappings
		move.w	#ArtTile_Monitor|Tile_Prio,obGfx(a0)	; set art tile and priority
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield positioning mode
		move.b	#256/2,obActWid(a0)			; set sprite display width (this only works as intended for subtype 02)
		move.b	#4,obPriority(a0)			; set sprite priority
		move.b	obSubtype(a0),obFrame(a0)		; set frame ID from subtype
; ---------------------------------------------------------------------------

LTag_ChkDel:	; Routine 2
	if FixBugs=0
		; Objects shouldn't call DisplaySprite and DeleteObject on
		; the same frame, or else cause a null-pointer dereference.
		tst.w	(v_debuguse).w				; is debug mode being used?
		beq.s	.debugoff				; if not, branch
		bsr.w	DisplaySprite

.debugoff:
		cmpi.b	#6,(v_player+obRoutine).w		; is sonic dead?
		bhs.s	.playerdead				; if so, branch
		bset	#sprite_rendered_bit,obRender(a0)	; set object visible flag ($80)

.playerdead:
	endif
		out_of_range.w	DeleteObject,obX(a0),1		; contains a (redundant) bmi check

	if FixBugs
		cmpi.b	#6,(v_player+obRoutine).w		; is sonic dead?
		bhs.s	.playerdead				; if so, branch
		bset	#sprite_rendered_bit,obRender(a0)	; set object visible flag ($80)

.playerdead:
		tst.w	(v_debuguse).w				; is debug mode being used?
		beq.s	.debugoff				; if not, branch
		bra.w	DisplaySprite

.debugoff:
	endif
		rts
; ===========================================================================

Map_LTag:	include	"_maps/Lava Tag.asm"
