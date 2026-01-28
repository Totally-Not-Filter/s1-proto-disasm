; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

DynamicLevelEvents:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	DLE_Index(pc,d0.w),d0
		jsr	DLE_Index(pc,d0.w) ; run level-specific events
		tst.w	(v_debuguse).w
		beq.s	loc_4936
		move.w	#0,(v_limittop2).w
		move.w	#$720,(v_limitbtm1).w

loc_4936:
		moveq	#2,d1
		move.w	(v_limitbtm1).w,d0
		sub.w	(v_limitbtm2).w,d0 ; has lower level boundary changed recently?
		beq.s	DLE_NoChg	; if not, branch
		bcc.s	loc_4952
		move.w	(v_scrposy).w,(v_limitbtm2).w
		andi.w	#$FFFE,(v_limitbtm2).w
		neg.w	d1

loc_4952:
		add.w	d1,(v_limitbtm2).w
		move.b	#1,(f_bgscrollvert).w

DLE_NoChg:
		rts
; End of function DynamicLevelEvents

; ===========================================================================
; ---------------------------------------------------------------------------
; Offset index for dynamic level events
; ---------------------------------------------------------------------------
DLE_Index:	dc.w DLE_GHZ-DLE_Index, DLE_Null-DLE_Index
		dc.w DLE_MZ-DLE_Index, DLE_SLZ-DLE_Index
		dc.w DLE_Null-DLE_Index, DLE_Null-DLE_Index
; ===========================================================================

DLE_Null:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Green Hill Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_GHZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_GHZx(pc,d0.w),d0
		jmp	DLE_GHZx(pc,d0.w)
; ===========================================================================
DLE_GHZx:	dc.w DLE_GHZ1-DLE_GHZx
		dc.w DLE_GHZ2-DLE_GHZx
		dc.w DLE_GHZ3-DLE_GHZx
; ===========================================================================

DLE_GHZ1:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$1780,(v_scrposx).w
		blo.s	locret_4996
		move.w	#$400,(v_limitbtm1).w

locret_4996:
		rts
; ===========================================================================

DLE_GHZ2:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$ED0,(v_scrposx).w
		blo.s	locret_49C8
		move.w	#$200,(v_limitbtm1).w
		cmpi.w	#$1600,(v_scrposx).w
		blo.s	locret_49C8
		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1D60,(v_scrposx).w
		blo.s	locret_49C8
		move.w	#$300,(v_limitbtm1).w

locret_49C8:
		rts
; ===========================================================================

DLE_GHZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_49D8(pc,d0.w),d0
		jmp	off_49D8(pc,d0.w)
; ===========================================================================
off_49D8:	dc.w DLE_GHZ3main-off_49D8
		dc.w DLE_GHZ3boss-off_49D8
		dc.w DLE_GHZ3end-off_49D8
; ===========================================================================

DLE_GHZ3main:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$380,(v_scrposx).w
		blo.s	locret_4A24
		move.w	#$310,(v_limitbtm1).w
		cmpi.w	#$960,(v_scrposx).w
		blo.s	locret_4A24
		cmpi.w	#$280,(v_scrposy).w
		blo.s	loc_4A26
		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1380,(v_scrposx).w
		bhs.s	loc_4A1C
		move.w	#$4C0,(v_limitbtm1).w
		move.w	#$4C0,(v_limitbtm2).w

loc_4A1C:
		cmpi.w	#$1700,(v_scrposx).w
		bhs.s	loc_4A26

locret_4A24:
		rts
; ===========================================================================

loc_4A26:
		move.w	#$300,(v_limitbtm1).w
		addq.b	#2,(v_dle_routine).w
		rts
; ===========================================================================

DLE_GHZ3boss:
		cmpi.w	#$960,(v_scrposx).w
		bhs.s	loc_4A3E
		subq.b	#2,(v_dle_routine).w

loc_4A3E:
		cmpi.w	#$2960,(v_scrposx).w
		blo.s	locret_4A76
		bsr.w	FindFreeObj
		bne.s	loc_4A5E
		_move.b	#id_BossGreenHill,obID(a1) ; load GHZ boss object
		move.w	#$2A60,obX(a1)
		move.w	#$280,obY(a1)

loc_4A5E:
		move.w	#bgm_Boss,d0
		bsr.w	QueueSound1	; play boss music
		move.b	#1,(f_lockscreen).w ; lock screen
		addq.b	#2,(v_dle_routine).w
		moveq	#plcid_Boss,d0
		bra.w	AddPLC		; load boss patterns
; ===========================================================================

locret_4A76:
		rts
; ===========================================================================

DLE_GHZ3end:
		move.w	(v_scrposx).w,(v_limitleft2).w
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_MZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_MZx(pc,d0.w),d0
		jmp	DLE_MZx(pc,d0.w)
; ===========================================================================
DLE_MZx:	dc.w DLE_MZ1-DLE_MZx
		dc.w DLE_MZ2-DLE_MZx
		dc.w DLE_MZ3-DLE_MZx
; ===========================================================================

DLE_MZ1:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	off_4AA4(pc,d0.w),d0
		jmp	off_4AA4(pc,d0.w)
; ===========================================================================
off_4AA4:	dc.w loc_4AAC-off_4AA4
		dc.w sub_4ADC-off_4AA4
		dc.w loc_4B20-off_4AA4
		dc.w loc_4B42-off_4AA4
; ===========================================================================

loc_4AAC:
		move.w	#$1D0,(v_limitbtm1).w
		cmpi.w	#$700,(v_scrposx).w
		blo.s	locret_4ADA
		move.w	#$220,(v_limitbtm1).w
		cmpi.w	#$D00,(v_scrposx).w
		blo.s	locret_4ADA
		move.w	#$340,(v_limitbtm1).w
		cmpi.w	#$340,(v_scrposy).w
		blo.s	locret_4ADA
		addq.b	#2,(v_dle_routine).w

locret_4ADA:
		rts
; ===========================================================================

sub_4ADC:
		cmpi.w	#$340,(v_scrposy).w
		bhs.s	loc_4AEA
		subq.b	#2,(v_dle_routine).w
		rts
; ===========================================================================

loc_4AEA:
		move.w	#0,(v_limittop2).w
		cmpi.w	#$E00,(v_scrposx).w
		bhs.s	locret_4B1E
		move.w	#$340,(v_limittop2).w
		move.w	#$340,(v_limitbtm1).w
		cmpi.w	#$A90,(v_scrposx).w
		bhs.s	locret_4B1E
		move.w	#$500,(v_limitbtm1).w
		cmpi.w	#$370,(v_scrposy).w
		blo.s	locret_4B1E
		addq.b	#2,(v_dle_routine).w

locret_4B1E:
		rts
; ===========================================================================

loc_4B20:
		cmpi.w	#$370,(v_scrposy).w
		bhs.s	loc_4B2E
		subq.b	#2,(v_dle_routine).w
		rts
; ===========================================================================

loc_4B2E:
		cmpi.w	#$500,(v_scrposy).w
		blo.s	locret_4B40
		move.w	#$500,(v_limittop2).w
		addq.b	#2,(v_dle_routine).w

locret_4B40:
		rts
; ===========================================================================

loc_4B42:
		cmpi.w	#$E70,(v_scrposx).w
		blo.s	locret_4B50
		move.w	#0,(v_limittop2).w

locret_4B50:
		rts
; ===========================================================================

DLE_MZ2:
		move.w	#$520,(v_limitbtm1).w
		cmpi.w	#$1500,(v_scrposx).w
		blo.s	locret_4B66
		move.w	#$540,(v_limitbtm1).w

locret_4B66:
		rts
; ===========================================================================

DLE_MZ3:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Star Light Zone dynamic level events
; ---------------------------------------------------------------------------

DLE_SLZ:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DLE_SLZx(pc,d0.w),d0
		jmp	DLE_SLZx(pc,d0.w)
; ===========================================================================
DLE_SLZx:	dc.w DLE_SLZ123-DLE_SLZx
		dc.w DLE_SLZ123-DLE_SLZx
		dc.w DLE_SLZ123-DLE_SLZx
; ===========================================================================

DLE_SLZ123:
		rts