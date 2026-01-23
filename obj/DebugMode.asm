; ---------------------------------------------------------------------------

DebugMode:
		moveq	#0,d0
		move.b	(v_debuguse).w,d0
		move.w	off_11E74(pc,d0.w),d1
		jmp	off_11E74(pc,d1.w)
; ===========================================================================
off_11E74:	dc.w loc_11E78-off_11E74
		dc.w loc_11EB8-off_11E74
; ===========================================================================

loc_11E78:
		addq.b	#2,(v_debuguse).w
		move.b	#0,obFrame(a0)
		move.b	#0,obAnim(a0)
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(DebugLists).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		cmp.b	(v_debugitem).w,d6
		bhi.s	loc_11EA8
		move.b	#0,(v_debugitem).w

loc_11EA8:
		bsr.w	sub_11FCE
		move.b	#$C,(v_debugxspeed).w
		move.b	#1,(v_debugyspeed).w

loc_11EB8:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(DebugLists).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		bsr.w	sub_11ED6
		jmp	(DisplaySprite).l
; ===========================================================================

sub_11ED6:
		moveq	#0,d4
		move.w	#1,d1
		move.b	(v_jpadpress1).w,d4
		bne.s	loc_11F0E
		tst.b	(v_jpadhold1).w
		bne.s	loc_11EF6
		move.b	#$C,(v_debugxspeed).w
		move.b	#$F,(v_debugyspeed).w
		rts
; ===========================================================================

loc_11EF6:
		subq.b	#1,(v_debugxspeed).w
		bne.s	loc_11F12
		move.b	#1,(v_debugxspeed).w
		addq.b	#1,(v_debugyspeed).w
		bne.s	loc_11F0E
		move.b	#-1,(v_debugyspeed).w

loc_11F0E:
		move.b	(v_jpadhold1).w,d4

loc_11F12:
		moveq	#0,d1
		move.b	(v_debugyspeed).w,d1
		addq.w	#1,d1
		swap	d1
		asr.l	#4,d1
		move.l	obY(a0),d2
		move.l	obX(a0),d3
		btst	#bitUp,d4
		beq.s	loc_11F32
		sub.l	d1,d2
		bcc.s	loc_11F32
		moveq	#0,d2

loc_11F32:
		btst	#bitDn,d4
		beq.s	loc_11F48
		add.l	d1,d2
		cmpi.l	#$7FF0000,d2
		bcs.s	loc_11F48
		move.l	#$7FF0000,d2

loc_11F48:
		btst	#bitL,d4
		beq.s	loc_11F54
		sub.l	d1,d3
		bcc.s	loc_11F54
		moveq	#0,d3

loc_11F54:
		btst	#bitR,d4
		beq.s	loc_11F5C
		add.l	d1,d3

loc_11F5C:
		move.l	d2,obY(a0)
		move.l	d3,obX(a0)
		btst	#bitA,(v_jpadpress2).w
		beq.s	loc_11F80
		addq.b	#1,(v_debugitem).w
		cmp.b	(v_debugitem).w,d6
		bhi.s	loc_11F7C
		move.b	#0,(v_debugitem).w

loc_11F7C:
		bra.w	sub_11FCE
; ===========================================================================

loc_11F80:
		btst	#bitC,(v_jpadpress2).w
		beq.s	loc_11FA4
		jsr	(FindFreeObj).l
		bne.s	loc_11FA4
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		_move.b	obMap(a0),obID(a1)
		rts
; ===========================================================================

loc_11FA4:
		btst	#bitB,(v_jpadpress2).w
		beq.s	locret_11FCC
		moveq	#0,d0
		move.w	d0,(v_debuguse).w
		move.l	#Map_Sonic,(v_player+obMap).w
		move.w	#make_art_tile(ArtTile_Sonic,0,0),(v_player+obGfx).w
		move.b	d0,(v_player+obAnim).w
		move.w	d0,obX+2(a0)
		move.w	d0,obY+2(a0)

locret_11FCC:
		rts
; ===========================================================================

sub_11FCE:
		moveq	#0,d0
		move.b	(v_debugitem).w,d0
		lsl.w	#3,d0
		move.l	(a2,d0.w),obMap(a0)
		move.w	6(a2,d0.w),obGfx(a0)
		move.b	5(a2,d0.w),obFrame(a0)
		rts