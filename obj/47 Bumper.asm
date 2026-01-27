; ---------------------------------------------------------------------------
; Object 47 - pinball bumper (SZ)
; ---------------------------------------------------------------------------

Bumper:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bump_Index(pc,d0.w),d1
		jmp	Bump_Index(pc,d1.w)
; ===========================================================================
Bump_Index:	dc.w Bump_Main-Bump_Index
		dc.w Bump_Hit-Bump_Index
; ===========================================================================

Bump_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Bump,obMap(a0)
		move.w	#make_art_tile(ArtTile_SZ_Bumper,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#1,obPriority(a0)
		move.b	#$D7,obColType(a0)

Bump_Hit:	; Routine 2
		tst.b	obColProp(a0)	; has Sonic touched the bumper?
		beq.s	.display	; if not, branch
		clr.b	obColProp(a0)
		lea	(v_player).w,a1
		move.w	obX(a0),d1
		move.w	obY(a0),d2
		sub.w	obX(a1),d1
		sub.w	obY(a1),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#-$700,d1
		asr.l	#8,d1
		move.w	d1,obVelX(a1)	; bounce Sonic away
		muls.w	#-$700,d0
		asr.l	#8,d0
		move.w	d0,obVelY(a1)	; bounce Sonic away
		bset	#1,obStatus(a1)
		clr.b	jumpflag(a1)
		move.b	#1,obAnim(a0)	; use "hit" animation
		move.w	#sfx_Bumper,d0
		jsr	(QueueSound2).l	; play bumper sound

.display:
		lea	(Ani_Bump).l,a1
		bsr.w	AnimateSprite
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif