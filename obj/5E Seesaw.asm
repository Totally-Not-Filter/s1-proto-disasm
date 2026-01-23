; ---------------------------------------------------------------------------
; Object 5E - Seesaws (SLZ)
; ---------------------------------------------------------------------------

Seesaw:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	See_Index(pc,d0.w),d1
		jsr	See_Index(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
See_Index:	dc.w See_Main-See_Index
		dc.w See_Slope-See_Index
		dc.w See_Slope2-See_Index
; ===========================================================================

See_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Seesaw,obMap(a0)
		move.w	#make_art_tile(ArtTile_SLZ_Seesaw,0,0),obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#48,obActWid(a0)

See_Slope:	; Routine 2
		lea	(See_DataSlope).l,a2
		btst	#0,obFrame(a0)	; is seesaw flat?
		beq.s	.noflip		; if not, branch
		lea	(See_DataFlat).l,a2

.noflip:
		lea	(v_player).w,a1
		move.w	#$30,d1
		jsr	(SlopeObject).l
		btst	#3,obID(a0)	; is bit 3 set in object ID?
		beq.s	locret_E704	; if not, exit
		nop

locret_E704:
		rts
; ===========================================================================

See_Slope2:	; Routine 4
		bsr.w	See_ChkSide
		lea	(See_DataSlope).l,a2
		btst	#0,obFrame(a0)	; is seesaw flat?
		beq.s	.notflat	; if not, branch
		lea	(See_DataFlat).l,a2

.notflat:
		move.w	#$30,d1
		jsr	(ExitPlatform).l
		move.w	#$30,d1
		move.w	obX(a0),d2
		jsr	(SlopeObject2).l
		rts
; ===========================================================================

See_ChkSide:
		moveq	#2,d1
		lea	(v_player).w,a1
		move.w	obX(a0),d0
		sub.w	obX(a1),d0	; is Sonic on the left side of the seesaw?
		bcc.s	.leftside	; if yes, branch
		neg.w	d0
		moveq	#0,d1

.leftside:
		cmpi.w	#8,d0
		bcc.s	See_ChgFrame
		moveq	#1,d1

See_ChgFrame:
		move.b	d1,obFrame(a0)
		bclr	#0,obRender(a0)
		btst	#1,obFrame(a0)
		beq.s	.noflip
		bset	#0,obRender(a0)

.noflip:
		rts