; ---------------------------------------------------------------------------
; Background layer deformation subroutines
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

DeformLayers:
		tst.b	(f_nobgscroll).w
		bne.s	loc_3E18
		tst.b	(f_rst_hscroll).w
		bne.w	loc_4258
		bsr.w	ScrollHoriz

loc_3E08:
		tst.b	(f_rst_vscroll).w
		bne.w	loc_4276
		bsr.w	ScrollVertical

loc_3E14:
		bsr.w	DynamicLevelEvents

loc_3E18:
		move.w	(v_scrposx).w,(v_scrposx_dup).w
		move.w	(v_scrposy).w,(v_scrposy_dup).w
		move.w	(v_bgscrposx).w,(v_bgscrposx_dup).w
		move.w	(v_bgscrposy).w,(v_bgscrposy_dup).w
		move.w	(v_bg3scrposx).w,(v_bg3scrposx_vdp).w
		move.w	(v_bg3scrposy).w,(v_bg3scrposy_vdp).w
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	Deform_Index(pc,d0.w),d0
		jmp	Deform_Index(pc,d0.w)
; ---------------------------------------------------------------------------

Deform_Index:	dc.w Deform_GHZ-Deform_Index, Deform_LZ-Deform_Index, Deform_MZ-Deform_Index
		dc.w Deform_SLZ-Deform_Index, Deform_SZ-Deform_Index, Deform_CWZ-Deform_Index
; ---------------------------------------------------------------------------

Deform_GHZ:
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d5
		bsr.w	sub_4298
		bsr.w	sub_4374
		lea	(v_hscrolltablebuffer).w,a1
		move.w	(v_scrposy).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$26,d0
		move.w	d0,(v_bg2scrposy).w
		move.w	d0,d4
		bsr.w	ScrollBlock3
		move.w	(v_bgscrposy).w,(v_bgscrposy_dup).w
		move.w	#112-1,d1
		sub.w	d4,d1
		move.w	(v_scrposx).w,d0
		cmpi.b	#id_Title,(v_gamemode).w
		bne.s	loc_3EA8
		moveq	#0,d0

loc_3EA8:
		neg.w	d0
		swap	d0
		move.w	(v_bgscrposx).w,d0
		neg.w	d0

loc_3EB2:
		move.l	d0,(a1)+
		dbf	d1,loc_3EB2
		move.w	#40-1,d1
		move.w	(v_bg2scrposx).w,d0
		neg.w	d0

loc_3EC2:
		move.l	d0,(a1)+
		dbf	d1,loc_3EC2
		move.w	(v_bg2scrposx).w,d0
		addi.w	#0,d0
		move.w	(v_scrposx).w,d2
		addi.w	#-$200,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#72-1,d1
		add.w	d4,d1

loc_3EF0:
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,loc_3EF0
		rts
; ---------------------------------------------------------------------------

Deform_LZ:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#224-1,d1
		move.w	(v_scrposx).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bgscrposx).w,d0
		move.w	#0,d0
		neg.w	d0

loc_3F1C:
		move.l	d0,(a1)+
		dbf	d1,loc_3F1C
		rts
; ---------------------------------------------------------------------------

Deform_MZ:
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#6,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d5
		bsr.w	sub_4298
		move.w	#$200,d0
		move.w	(v_scrposy).w,d1
		subi.w	#$1C8,d1
		bcs.s	loc_3F50
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0

loc_3F50:
		move.w	d0,(v_bg2scrposy).w
		bsr.w	ScrollBlock3
		move.w	(v_bgscrposy).w,(v_bgscrposy_dup).w
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#224-1,d1
		move.w	(v_scrposx).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bgscrposx).w,d0
		neg.w	d0

loc_3F74:
		move.l	d0,(a1)+
		dbf	d1,loc_3F74
		rts
; ---------------------------------------------------------------------------

Deform_SLZ:
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	(v_scrshifty).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	ScrollBlock2
		move.w	(v_bgscrposy).w,(v_bgscrposy_dup).w
		bsr.w	Deform_SLZ_2
		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bgscrposy).w,d0
		move.w	d0,d2
		subi.w	#$C0,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#224/16+1-1,d1
		move.w	(v_scrposx).w,d0
		neg.w	d0
		swap	d0
		andi.w	#$F,d2
		add.w	d2,d2
		move.w	(a2)+,d0
		jmp	loc_3FD0(pc,d2.w)
; ---------------------------------------------------------------------------

loc_3FCE:
		move.w	(a2)+,d0

loc_3FD0:
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbf	d1,loc_3FCE
		rts
; ---------------------------------------------------------------------------

Deform_SLZ_2:
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_scrposx).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$1C,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#28-1,d1

loc_401C:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_401C
		move.w	d2,d0
		asr.w	#3,d0
		move.w	#5-1,d1

loc_4030:
		move.w	d0,(a1)+
		dbf	d1,loc_4030
		move.w	d2,d0
		asr.w	#2,d0
		move.w	#5-1,d1

loc_403E:
		move.w	d0,(a1)+
		dbf	d1,loc_403E
		move.w	d2,d0
		asr.w	#1,d0
		move.w	#30-1,d1

loc_404C:
		move.w	d0,(a1)+
		dbf	d1,loc_404C
		rts
; ---------------------------------------------------------------------------

Deform_SZ:
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#6,d4
		move.w	(v_scrshifty).w,d5
		ext.l	d5
		asl.l	#4,d5
		move.l	d5,d1
		asl.l	#1,d5
		add.l	d1,d5
		bsr.w	sub_4298
		move.w	(v_bgscrposy).w,(v_bgscrposy_dup).w
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#224-1,d1
		move.w	(v_scrposx).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bgscrposx).w,d0
		neg.w	d0

loc_408A:
		move.l	d0,(a1)+
		dbf	d1,loc_408A
		rts
; ---------------------------------------------------------------------------

Deform_CWZ:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#224-1,d1
		move.w	(v_scrposx).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bgscrposx).w,d0
		move.w	#0,d0
		neg.w	d0

loc_40AC:
		move.l	d0,(a1)+
		dbf	d1,loc_40AC
		rts
; ---------------------------------------------------------------------------

ScrollHoriz:
		move.w	(v_scrposx).w,d4
		bsr.s	sub_40E8
		move.w	(v_scrposx).w,d0
		andi.w	#16,d0
		move.b	(v_fg_xblock).w,d1
		eor.b	d1,d0
		bne.s	locret_40E6
		eori.b	#16,(v_fg_xblock).w
		move.w	(v_scrposx).w,d0
		sub.w	d4,d0
		bpl.s	loc_40E0
		bset	#2,(v_fg_scroll_flags).w
		rts
; ---------------------------------------------------------------------------

loc_40E0:
		bset	#3,(v_fg_scroll_flags).w

locret_40E6:
		rts
; ---------------------------------------------------------------------------

sub_40E8:
		move.w	(v_player+obX).w,d0
		sub.w	(v_scrposx).w,d0
		subi.w	#320/2-16,d0
		bcs.s	loc_412C
		subi.w	#16,d0
		bcc.s	loc_4102
		clr.w	(v_scrshiftx).w
		rts
; ---------------------------------------------------------------------------

loc_4102:
		cmpi.w	#16,d0
		bcs.s	loc_410C
		move.w	#16,d0

loc_410C:
		add.w	(v_scrposx).w,d0
		cmp.w	(v_limitright2).w,d0
		blt.s	loc_411A
		move.w	(v_limitright2).w,d0

loc_411A:
		move.w	d0,d1
		sub.w	(v_scrposx).w,d1
		asl.w	#8,d1
		move.w	d0,(v_scrposx).w
		move.w	d1,(v_scrshiftx).w
		rts
; ---------------------------------------------------------------------------

loc_412C:
		add.w	(v_scrposx).w,d0
		cmp.w	(v_limitleft2).w,d0
		bgt.s	loc_411A
		move.w	(v_limitleft2).w,d0
		bra.s	loc_411A
; ---------------------------------------------------------------------------
		tst.w	d0
		bpl.s	loc_4146
		move.w	#-2,d0
		bra.s	loc_412C
; ---------------------------------------------------------------------------

loc_4146:
		move.w	#2,d0
		bra.s	loc_4102
; ---------------------------------------------------------------------------

ScrollVertical:
		moveq	#0,d1
		move.w	(v_player+obY).w,d0
		sub.w	(v_scrposy).w,d0
		btst	#2,(v_player+obStatus).w
		beq.s	loc_4160
		subq.w	#5,d0

loc_4160:
		btst	#1,(v_player+obStatus).w
		beq.s	loc_4180
		addi.w	#32,d0
		sub.w	(v_lookshift).w,d0
		bcs.s	loc_41BE
		subi.w	#64,d0
		bcc.s	loc_41BE
		tst.b	(f_bgscrollvert).w
		bne.s	loc_41D0
		bra.s	loc_418C
; ---------------------------------------------------------------------------

loc_4180:
		sub.w	(v_lookshift).w,d0
		bne.s	loc_4192
		tst.b	(f_bgscrollvert).w
		bne.s	loc_41D0

loc_418C:
		clr.w	(v_scrshifty).w
		rts
; ---------------------------------------------------------------------------

loc_4192:
		cmpi.w	#$60,(v_lookshift).w
		bne.s	loc_41AC
	if ~~FixBugs
		; Bug: The camera delays when rolling down or up a slope very quickly
		; Uncomment the lines below to apply the final's fix
	else
		move.w	(v_player+obInertia).w,d1
		bpl.s	loc_666C
		neg.w	d1

loc_666C:
		cmpi.w	#$800,d1
		bhs.s	loc_41BE
	endif
		move.w	#$600,d1
		cmpi.w	#6,d0
		bgt.s	loc_4200
		cmpi.w	#-6,d0
		blt.s	loc_41E8
		bra.s	loc_41D6
; ---------------------------------------------------------------------------

loc_41AC:
		move.w	#$200,d1
		cmpi.w	#2,d0
		bgt.s	loc_4200
		cmpi.w	#-2,d0
		blt.s	loc_41E8
		bra.s	loc_41D6
; ---------------------------------------------------------------------------

loc_41BE:
		move.w	#$1000,d1
		cmpi.w	#16,d0
		bgt.s	loc_4200
		cmpi.w	#-16,d0
		blt.s	loc_41E8
		bra.s	loc_41D6
; ---------------------------------------------------------------------------

loc_41D0:
		moveq	#0,d0
		move.b	d0,(f_bgscrollvert).w

loc_41D6:
		moveq	#0,d1
		move.w	d0,d1
		add.w	(v_scrposy).w,d1
		tst.w	d0
		bpl.w	loc_420A
		bra.w	loc_41F4
; ---------------------------------------------------------------------------

loc_41E8:
		neg.w	d1
		ext.l	d1
		asl.l	#8,d1
		add.l	(v_scrposy).w,d1
		swap	d1

loc_41F4:
		cmp.w	(v_limittop2).w,d1
		bgt.s	loc_4214
	if ~~FixBugs
		; Bug: If the player is going too fast vertically, they can die due to the camera's slowness.
	else
		cmpi.w	#-$100,d1
		bgt.s	loc_66F0
		andi.w	#$7FF,d1
		andi.w	#$7FF,(v_player+obY).w
		andi.w	#$7FF,(v_scrposy).w
		andi.w	#$3FF,(v_bgscrposy).w
		bra.s	loc_4214

loc_66F0:
	endif
		move.w	(v_limittop2).w,d1
		bra.s	loc_4214
; ---------------------------------------------------------------------------

loc_4200:
		ext.l	d1
		asl.l	#8,d1
		add.l	(v_scrposy).w,d1
		swap	d1

loc_420A:
		cmp.w	(v_limitbtm2).w,d1
		blt.s	loc_4214
	if ~~FixBugs
		; Bug: If the player is going too fast vertically, they can die due to the camera's slowness.
	else
		subi.w	#$800,d1
		bcs.s	loc_6720
		andi.w	#$7FF,(v_player+obY).w
		andi.w	#$7FF,(v_scrposy).w
		andi.w	#$3FF,(v_bgscrposy).w
		bra.s	loc_4214

loc_6720:
	endif
		move.w	(v_limitbtm2).w,d1

loc_4214:
		move.w	(v_scrposy).w,d4
		swap	d1
		move.l	d1,d3
		sub.l	(v_scrposy).w,d3
		ror.l	#8,d3
		move.w	d3,(v_scrshifty).w
		move.l	d1,(v_scrposy).w
		move.w	(v_scrposy).w,d0
		andi.w	#16,d0
		move.b	(v_fg_yblock).w,d1
		eor.b	d1,d0
		bne.s	locret_4256
		eori.b	#16,(v_fg_yblock).w
		move.w	(v_scrposy).w,d0
		sub.w	d4,d0
		bpl.s	loc_4250
		bset	#0,(v_fg_scroll_flags).w
		rts
; ---------------------------------------------------------------------------

loc_4250:
		bset	#1,(v_fg_scroll_flags).w

locret_4256:
		rts
; ---------------------------------------------------------------------------

loc_4258:
		move.w	(v_limitleft2).w,d0
		moveq	#1,d1
		sub.w	(v_scrposx).w,d0
		beq.s	loc_426E
		bpl.s	loc_4268
		moveq	#-1,d1

loc_4268:
		add.w	d1,(v_scrposx).w
		move.w	d1,d0

loc_426E:
		move.w	d0,(v_scrshiftx).w
		bra.w	loc_3E08
; ---------------------------------------------------------------------------

loc_4276:
		move.w	(v_limittop2).w,d0
		addi.w	#32,d0
		moveq	#1,d1
		sub.w	(v_scrposy).w,d0
		beq.s	loc_4290
		bpl.s	loc_428A
		moveq	#-1,d1

loc_428A:
		add.w	d1,(v_scrposy).w
		move.w	d1,d0

loc_4290:
		move.w	d0,(v_scrshifty).w
		bra.w	loc_3E14
; ---------------------------------------------------------------------------

sub_4298:
		move.l	(v_bgscrposx).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bgscrposx).w
		move.l	d0,d1
		swap	d1
		andi.w	#16,d1
		move.b	(v_bg1_xblock).w,d3
		eor.b	d3,d1
		bne.s	loc_42CC
		eori.b	#16,(v_bg1_xblock).w
		sub.l	d2,d0
		bpl.s	loc_42C6
		bset	#2,(v_bg1_scroll_flags).w
		bra.s	loc_42CC
; ---------------------------------------------------------------------------

loc_42C6:
		bset	#3,(v_bg1_scroll_flags).w

loc_42CC:
		move.l	(v_bgscrposy).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bgscrposy).w
		move.l	d0,d1
		swap	d1
		andi.w	#16,d1
		move.b	(v_bg1_yblock).w,d2
		eor.b	d2,d1
		bne.s	locret_4300
		eori.b	#16,(v_bg1_yblock).w
		sub.l	d3,d0
		bpl.s	loc_42FA
		bset	#0,(v_bg1_scroll_flags).w
		rts
; ---------------------------------------------------------------------------

loc_42FA:
		bset	#1,(v_bg1_scroll_flags).w

locret_4300:
		rts
; ---------------------------------------------------------------------------

ScrollBlock2:
		move.l	(v_bgscrposx).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bgscrposx).w
		move.l	(v_bgscrposy).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bgscrposy).w
		move.l	d0,d1
		swap	d1
		andi.w	#16,d1
		move.b	(v_bg1_yblock).w,d2
		eor.b	d2,d1
		bne.s	locret_4342
		eori.b	#16,(v_bg1_yblock).w
		sub.l	d3,d0
		bpl.s	loc_433C
		bset	#0,(v_bg1_scroll_flags).w
		rts
; ---------------------------------------------------------------------------

loc_433C:
		bset	#1,(v_bg1_scroll_flags).w

locret_4342:
		rts
; ---------------------------------------------------------------------------

ScrollBlock3:
		move.w	(v_bgscrposy).w,d3
		move.w	d0,(v_bgscrposy).w
		move.w	d0,d1
		andi.w	#16,d1
		move.b	(v_bg1_yblock).w,d2
		eor.b	d2,d1
		bne.s	locret_4372
		eori.b	#16,(v_bg1_yblock).w
		sub.w	d3,d0
		bpl.s	loc_436C
		bset	#0,(v_bg1_scroll_flags).w
		rts
; ---------------------------------------------------------------------------

loc_436C:
		bset	#1,(v_bg1_scroll_flags).w

locret_4372:
		rts
; ---------------------------------------------------------------------------

sub_4374:
		move.w	(v_bg2scrposx).w,d2
		move.w	(v_bg2scrposy).w,d3
		move.w	(v_scrshiftx).w,d0
		ext.l	d0
		asl.l	#7,d0
		add.l	d0,(v_bg2scrposx).w
		move.w	(v_bg2scrposx).w,d0
		andi.w	#16,d0
		move.b	(v_bg2_xblock).w,d1
		eor.b	d1,d0
		bne.s	locret_43B4
		eori.b	#16,(v_bg2_xblock).w
		move.w	(v_bg2scrposx).w,d0
		sub.w	d2,d0
		bpl.s	loc_43AE
		bset	#2,(v_bg2_scroll_flags).w
		bra.s	locret_43B4
; ---------------------------------------------------------------------------

loc_43AE:
		bset	#3,(v_bg2_scroll_flags).w

locret_43B4:
		rts