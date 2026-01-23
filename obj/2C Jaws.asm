; ---------------------------------------------------------------------------
; Object 2C - Jaws enemy (LZ)
; ---------------------------------------------------------------------------

Jaws:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Jaws_Index(pc,d0.w),d1
		jsr	Jaws_Index(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
Jaws_Index:	dc.w Jaws_Main-Jaws_Index
		dc.w Jaws_Turn-Jaws_Index
; ===========================================================================

Jaws_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Jaws,obMap(a0)
		move.w	#make_art_tile(ArtTile_Jaws,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$A,obColType(a0)
		move.b	#4,obPriority(a0)
		move.b	#$10,obActWid(a0)
		move.w	#-$40,obVelX(a0) ; move Jaws to the left

Jaws_Turn:	; Routine 2
		lea	(Ani_Jaws).l,a1
		bsr.w	AnimateSprite
		bra.w	SpeedToPos