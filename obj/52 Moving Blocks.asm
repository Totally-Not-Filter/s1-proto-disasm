; ===========================================================================
; ---------------------------------------------------------------------------
; Object 52 - moving platform blocks (MZ)
; ---------------------------------------------------------------------------

MovingBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	MBlock_Index(pc,d0.w),d1
		jsr	MBlock_Index(pc,d1.w)
		out_of_range.w	DeleteObject,mblock_origX(a0)	; has platform gone out of range? if yes, delete it
		bra.w	DisplaySprite				; display platform sprite
; ===========================================================================
MBlock_Index:
		dc.w	MBlock_Main-MBlock_Index
		dc.w	MBlock_Platform-MBlock_Index
		dc.w	MBlock_StandOn-MBlock_Index

mblock_origY:		equ objoff_30	; initial Y-position
mblock_origX:		equ objoff_32	; initial X-position

    if FixBugs
mblock_fix_storeX:	equ objoff_38	; (FixBugs only) stores X-position around MBlock_Move to avoid stack pointer corruption
    endif
; ===========================================================================

MBlock_Var:	; width, frame
		dc.b  32/2, 0	; $0x - MZ single block / LZ small raft
		dc.b  64/2, 1	; $1x - MZ double block (unused)
; ===========================================================================

MBlock_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to MBlock_Platform

		move.l	#Map_MBlock,obMap(a0)			; MZ-specific mappings
		move.w	#ArtTile_MZ_Block|Tile_Pal3,obGfx(a0)	; MZ-specific art tile
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield-positioned mode

		moveq	#0,d0
		move.b	obSubtype(a0),d0			; get platform subtype
		lsr.w	#3,d0					; read only lower digit, multiplied by 2 bytes per entry
		andi.w	#$1E,d0					; mask out upper subtype digit
		lea	MBlock_Var(pc,d0.w),a2			; load setup array
		move.b	(a2)+,obActWid(a0)			; set sprite display width and solidity width
		move.b	(a2)+,obFrame(a0)			; set frame ID

		move.b	#4,obPriority(a0)			; set sprite priority
		move.w	obX(a0),mblock_origX(a0)		; remember initial X-position
		move.w	obY(a0),mblock_origY(a0)		; remember initial Y-position
; ---------------------------------------------------------------------------

MBlock_Platform: ; Routine 2
		moveq	#0,d1
		move.b	obActWid(a0),d1				; use sprite display width as platform solidity width
		jsr	(PlatformObject).l			; enable platform behavior (can set obRoutine = 4, MBlock_StandOn)
		bra.w	MBlock_Move				; execute platform movement behavior
; ===========================================================================

MBlock_StandOn:	; Routine 4
		moveq	#0,d1
		move.b	obActWid(a0),d1				; use sprite display width as platform solidity width
		jsr	(ExitPlatform).l			; allow exiting platform (can set obRoutine = 2, MBlock_Platform)

	if FixBugs
		; MBlock_SecretLZ1Raft manipulates the stack pointer, potentially
		; resulting in a crash. To avoid this, don't store data on
		; the stack. We can use object scratch RAM instead.
		move.w	obX(a0),mblock_fix_storeX(a0)		; backup current X-position before calling MBlock_Move (scratch RAM)
		bsr.w	MBlock_Move				; execute platform movement behavior
		move.w	mblock_fix_storeX(a0),d2		; restore previous X-position as input for MvSonicOnPtfm2 (scratch RAM)
	else
		move.w	obX(a0),-(sp)				; backup current X-position before calling MBlock_Move (stack)
		bsr.w	MBlock_Move				; execute platform movement behavior
		move.w	(sp)+,d2				; restore previous X-position as input for MvSonicOnPtfm2 (stack)
	endif

		jmp	(MvSonicOnPtfm2).l			; move Sonic with platform as it moves

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to control platform behavior based on subtype
; ---------------------------------------------------------------------------

MBlock_Move:
		moveq	#0,d0
		move.b	obSubtype(a0),d0			; get platform subtype
		andi.w	#$F,d0					; limit to lower digit (redundant, it's already been cleared earlier)
		add.w	d0,d0					; double for word-based indexing
		move.w	MBlock_TypeIndex(pc,d0.w),d1		; find entry in jump table
		jmp	MBlock_TypeIndex(pc,d1.w)		; execute behavior for platform subtype
; ===========================================================================
MBlock_TypeIndex:
		dc.w	MBlock_Stationary-MBlock_TypeIndex	; 0
		dc.w	MBlock_LeftRight-MBlock_TypeIndex	; 1
		dc.w	MBlock_NextWhenStoodOn-MBlock_TypeIndex	; 2
		dc.w	MBlock_Right_StopOnWall-MBlock_TypeIndex	; 3
; ===========================================================================

; Type 0 - stationary
MBlock_Stationary:
		rts						; do nothing
; ===========================================================================

; Type 1 - moves left and right continuously
MBlock_LeftRight:
		move.b	(v_oscillate+$E).w,d0			; get oscillatory value (frequency 2, middle value $30)
		subi.b	#$60,d1					; adjustment offset for X-flipped platforms (oscillation range * 2)
		btst	#0,obStatus(a0)				; is platform X-flipped?
		beq.s	.setX					; if not, branch
		neg.w	d0					; reverse oscillated offset direction
		add.w	d1,d0					; keep flipped platforms in the same $60px range

	.setX:
		move.w	mblock_origX(a0),d1			; get initial X-position of platform
		sub.w	d0,d1					; adjust by oscillated offset
		move.w	d1,obX(a0)				; move platform horizontally
		rts
; ===========================================================================

; Type 2 - stationary, advances to next subtype when stood on (3)
MBlock_NextWhenStoodOn:
		cmpi.b	#4,obRoutine(a0)			; is Sonic standing on the platform?
		bne.s	.return					; if not, branch
		addq.b	#1,obSubtype(a0)			; if yes, go to next subtype in list

	.return:
		rts
; ===========================================================================

; Type 3 (set from Type 2) - moves right, advances to Type 0 on wall hit (stationary)
MBlock_Right_StopOnWall:
		moveq	#0,d3
		move.b	obActWid(a0),d3				; use platform half-width as pixels to look ahead
		bsr.w	ObjHitWallRight				; get distance to platform right edge and nearest wall
		tst.w	d1					; has the platform hit a wall?
		bmi.s	.stopPlatform				; if yes, branch
		addq.w	#1,obX(a0)				; move platform to the right at 1px/frame
		move.w	obX(a0),mblock_origX(a0)		; update initial X-position as platform moves
		rts
; ---------------------------------------------------------------------------

	.stopPlatform:
		clr.b	obSubtype(a0)				; change to type 00 (non-moving type)
		rts
; End of function MBlock_Move

; ===========================================================================

Map_MBlock:	include	"_maps/Moving Blocks (MZ).asm"
