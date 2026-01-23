; ---------------------------------------------------------------------------
; Object 0D - signpost at the end of a level
; ---------------------------------------------------------------------------

Signpost:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Sign_Index(pc,d0.w),d1
		jsr	Sign_Index(pc,d1.w)
		lea	(Ani_Sign).l,a1
		bsr.w	AnimateSprite
	if FixBugs
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts
	endif
; ===========================================================================
Sign_Index:	dc.w Sign_Main-Sign_Index
		dc.w Sign_Touch-Sign_Index
		dc.w Sign_Spin-Sign_Index
		dc.w Sign_GotThrough-Sign_Index

spintime = objoff_30		; time for signpost to spin
sparkletime = objoff_32		; time between sparkles
sparkle_id = objoff_34		; counter to keep track of sparkles
; ===========================================================================

Sign_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Sign,obMap(a0)
		move.w	#make_art_tile(ArtTile_Signpost,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#24,obActWid(a0)
		move.b	#4,obPriority(a0)

Sign_Touch:	; Routine 2
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcs.s	.notouch
		cmpi.w	#$20,d0		; is Sonic within $20 pixels of the signpost?
		bhs.s	.notouch	; if not, branch
		move.w	#sfx_Signpost,d0
		jsr	(QueueSound1).l	; play signpost sound
		clr.b	(f_timecount).w	; stop time counter
		move.w	(v_limitright2).w,(v_limitleft2).w ; lock screen position
		addq.b	#2,obRoutine(a0)

.notouch:
		rts
; ===========================================================================

Sign_Spin:	; Routine 4
		subq.w	#1,spintime(a0)	; subtract 1 from spin time
		bpl.s	.chksparkle	; if time remains, branch
		move.w	#60,spintime(a0) ; set spin cycle time to 1 second
		addq.b	#1,obAnim(a0)	; next spin cycle
		cmpi.b	#3,obAnim(a0)	; have 3 spin cycles completed?
		bne.s	.chksparkle	; if not, branch
		addq.b	#2,obRoutine(a0)

.chksparkle:
		subq.w	#1,sparkletime(a0) ; subtract 1 from time delay
		bpl.s	.fail		; if time remains, branch
		move.w	#12-1,sparkletime(a0) ; set time between sparkles to 12 frames
		moveq	#0,d0
		move.b	sparkle_id(a0),d0 ; get sparkle id
		addq.b	#2,sparkle_id(a0) ; increment sparkle counter
		andi.b	#$E,sparkle_id(a0)
		lea	Sign_SparkPos(pc,d0.w),a2 ; load sparkle position data
		bsr.w	FindFreeObj
		bne.s	.fail
		_move.b	#id_Rings,obID(a1)	; load rings object
		move.b	#6,obRoutine(a1) ; jump to ring sparkle subroutine
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obX(a0),d0
		move.w	d0,obX(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obY(a0),d0
		move.w	d0,obY(a1)
		move.l	#Map_Ring,obMap(a1)
		move.w	#make_art_tile(ArtTile_Ring,1,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#2,obPriority(a1)
		move.b	#8,obActWid(a1)

.fail:
		rts
; ===========================================================================
Sign_SparkPos:	dc.b -$18,-$10		; x-position, y-position
		dc.b	8,   8
		dc.b -$10,   0
		dc.b  $18,  -8
		dc.b	0,  -8
		dc.b  $10,   0
		dc.b -$18,   8
		dc.b  $18, $10
; ===========================================================================

Sign_GotThrough:	; Routine 6
		tst.w	(v_debuguse).w	; is debug mode on?
		bne.w	locret_C880	; if yes, branch

; ---------------------------------------------------------------------------
; Subroutine to set up bonuses at the end of an act
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

GotThroughAct:
		tst.b	(f_victory).w
		bne.s	locret_C880
		move.w	(v_limitright2).w,(v_limitleft2).w
		clr.b	(v_invinc).w	; disable invincibility
		clr.b	(f_timecount).w	; stop time counter
		move.b	#id_GotThroughCard,(v_objslot18).w
		moveq	#plcid_TitleCard,d0
		jsr	(NewPLC).l	; load title card patterns
		move.b	#1,(f_endactbonus).w
		moveq	#0,d0
		move.b	(v_timemin).w,d0
		mulu.w	#60,d0		; convert minutes to seconds
		moveq	#0,d1
		move.b	(v_timesec).w,d1
		add.w	d1,d0		; add up your time
		divu.w	#15,d0		; divide by 15
		moveq	#$14,d1
		cmp.w	d1,d0		; is time 5 minutes or higher?
		bcs.s	.hastimebonus	; if not, branch
		move.w	d1,d0		; use minimum time bonus (0)

.hastimebonus:
		add.w	d0,d0
		move.w	TimeBonuses(pc,d0.w),(v_timebonus).w ; set time bonus
		move.w	(v_rings).w,d0	; load number of rings
		mulu.w	#10,d0		; multiply by 10
		move.w	d0,(v_ringbonus).w ; set ring bonus
		move.w	#bgm_GotThrough,d0
		jsr	(QueueSound2).l	; play "Sonic got through" music

locret_C880:
		rts
; ===========================================================================
TimeBonuses:	dc.w 5000, 1000, 500, 400, 300, 300, 200, 200
		dc.w 100, 100, 100, 100, 50, 50, 50, 50, 10, 10, 10, 10, 0