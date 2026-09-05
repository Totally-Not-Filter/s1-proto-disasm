; ===========================================================================
; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

DynamicLevelEvents:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	DLE_Index(pc,d0.w),d0
		jsr	DLE_Index(pc,d0.w)			; run level-specific events
		tst.w	(v_debuguse).w				; is debug mode being used?
		beq.s	.notdebug				; if not, branch
		move.w	#0,(v_limittop2).w			; hardcode top boundary to 0
		move.w	#$720,(v_limitbtm1).w			; hardcode bottom boundary to $720

	; loc_4936:
	.notdebug:
		moveq	#2,d1
		move.w	(v_limitbtm1).w,d0			; new boundary y pos is written here
		sub.w	(v_limitbtm2).w,d0
		beq.s	.keep_boundary				; branch if boundary is where it should be
		bhs.s	.move_boundary_down			; branch if new boundary is below current one
		move.w	(v_scrposy).w,(v_limitbtm2).w		; match boundary to camera
		andi.w	#$FFFE,(v_limitbtm2).w			; round down to nearest 2px
		neg.w	d1

	; loc_4952:
	.move_boundary_down:
		add.w	d1,(v_limitbtm2).w			; move boundary up 2px
		move.b	#1,(f_bgscrollvert).w

	; DLE_NoChg:
	.keep_boundary:
		rts
; End of function DynamicLevelEvents

; ===========================================================================
; ---------------------------------------------------------------------------
; Offset index for dynamic level events
; ---------------------------------------------------------------------------
DLE_Index:
		dc.w	DLE_GHZ-DLE_Index
		dc.w	DLE_Null-DLE_Index
		dc.w	DLE_MZ-DLE_Index
		dc.w	DLE_SLZ-DLE_Index
		dc.w	DLE_Null-DLE_Index
		dc.w	DLE_Null-DLE_Index

; ===========================================================================
; ---------------------------------------------------------------------------
; Labyrinth Zone, Sparkling Zone, and Clock Work Zone dynamic level events (empty)
; ---------------------------------------------------------------------------

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
DLE_GHZx:
		dc.w	DLE_GHZ1-DLE_GHZx
		dc.w	DLE_GHZ2-DLE_GHZx
		dc.w	DLE_GHZ3-DLE_GHZx
; ===========================================================================
; ---------------------------------------------------------------------------
; Green Hill Zone - Act 1

DLE_GHZ1:
	if FixBugs
		; Prevent the title screen from using GHZ1's DLE logic
		cmpi.b	#id_Title,(v_gamemode).w
		beq.s	.exit
	endif

		move.w	#$300,(v_limitbtm1).w			; initial boundary
		cmpi.w	#$1780,(v_scrposx).w
		blo.s	.exit					; branch if camera is left of $1780

		move.w	#$400,(v_limitbtm1).w			; set lower y-boundary

	.exit:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Green Hill Zone - Act 2

DLE_GHZ2:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$ED0,(v_scrposx).w
		blo.s	.exit

		move.w	#$200,(v_limitbtm1).w
		cmpi.w	#$1600,(v_scrposx).w
		blo.s	.exit

		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1D60,(v_scrposx).w
		blo.s	.exit

		move.w	#$300,(v_limitbtm1).w

	.exit:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Green Hill Zone - Act 3

DLE_GHZ3:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_GHZ3_Index(pc,d0.w),d0
		jmp	DLE_GHZ3_Index(pc,d0.w)
; ===========================================================================
DLE_GHZ3_Index:
		dc.w	DLE_GHZ3_Main-DLE_GHZ3_Index
		dc.w	DLE_GHZ3_Boss-DLE_GHZ3_Index
		dc.w	DLE_GHZ3_End-DLE_GHZ3_Index
; ===========================================================================

DLE_GHZ3_Main:
		move.w	#$300,(v_limitbtm1).w
		cmpi.w	#$380,(v_scrposx).w
		blo.s	.exit					; branch if camera is left of $380

		move.w	#$310,(v_limitbtm1).w
		cmpi.w	#$960,(v_scrposx).w
		blo.s	.exit					; branch if camera is left of $960

		cmpi.w	#$280,(v_scrposy).w
		blo.s	.final_section				; branch if camera is above $280

		move.w	#$400,(v_limitbtm1).w
		cmpi.w	#$1380,(v_scrposx).w
		bhs.s	.skip_underground			; branch if camera is right of $1380

		move.w	#$4C0,(v_limitbtm1).w
		move.w	#$4C0,(v_limitbtm2).w

	.skip_underground:
		cmpi.w	#$1700,(v_scrposx).w
		bhs.s	.final_section				; branch if camera is right of $1700

	.exit:
		rts
; ===========================================================================

.final_section:
		move.w	#boss_ghz_y,(v_limitbtm1).w
		addq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_Boss next
		rts
; ===========================================================================

DLE_GHZ3_Boss:
		cmpi.w	#$960,(v_scrposx).w
		bhs.s	.dont_return				; branch if camera is right of $960
		subq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_Main next

	.dont_return:
		cmpi.w	#boss_ghz_x,(v_scrposx).w
		blo.s	.exit					; branch if camera is left of $2960
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		_move.b	#id_BossGreenHill,obID(a1)		; load GHZ boss object
		move.w	#boss_ghz_x+$100,obX(a1)
		move.w	#boss_ghz_y-$80,obY(a1)

	.fail:
		move.w	#bgm_Boss,d0
		bsr.w	QueueSound1				; play boss music
		move.b	#1,(f_lockscreen).w			; lock screen
		addq.b	#2,(v_dle_routine).w			; goto DLE_GHZ3_End next
		moveq	#plcid_Boss,d0
		bra.w	AddPLC					; load boss gfx
; ===========================================================================

.exit:
		rts
; ===========================================================================

DLE_GHZ3_End:
		move.w	(v_scrposx).w,(v_limitleft2).w	; set boundary to current position
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
; ---------------------------------------------------------------------------
; Marble Zone - Act 1

DLE_MZ1:
		moveq	#0,d0
		move.b	(v_dle_routine).w,d0
		move.w	DLE_MZ1_Index(pc,d0.w),d0
		jmp	DLE_MZ1_Index(pc,d0.w)
; ===========================================================================
DLE_MZ1_Index:
		dc.w	DLE_MZ1_0-DLE_MZ1_Index
		dc.w	DLE_MZ1_2-DLE_MZ1_Index
		dc.w	DLE_MZ1_4-DLE_MZ1_Index
		dc.w	DLE_MZ1_6-DLE_MZ1_Index
; ===========================================================================

DLE_MZ1_0:
		move.w	#$1D0,(v_limitbtm1).w
		cmpi.w	#$700,(v_scrposx).w
		blo.s	.exit					; branch if camera is left of $700

		move.w	#$220,(v_limitbtm1).w
		cmpi.w	#$D00,(v_scrposx).w
		blo.s	.exit					; branch if camera is left of $D00

		move.w	#$340,(v_limitbtm1).w
		cmpi.w	#$340,(v_scrposy).w
		blo.s	.exit					; branch if camera is above $340

		addq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_2 next

	.exit:
		rts
; ===========================================================================

DLE_MZ1_2:
		cmpi.w	#$340,(v_scrposy).w
		bhs.s	.next					; branch if camera is below $340

		subq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_0 next
		rts
; ===========================================================================

.next:
		move.w	#0,(v_limittop2).w
		cmpi.w	#$E00,(v_scrposx).w
		bhs.s	.exit					; branch if camera is right of $E00

		move.w	#$340,(v_limittop2).w
		move.w	#$340,(v_limitbtm1).w
		cmpi.w	#$A90,(v_scrposx).w
		bhs.s	.exit					; branch if camera is right of $A90

		move.w	#$500,(v_limitbtm1).w
		cmpi.w	#$370,(v_scrposy).w
		blo.s	.exit					; branch if camera is above $370

		addq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_4 next

	.exit:
		rts
; ===========================================================================

DLE_MZ1_4:
		cmpi.w	#$370,(v_scrposy).w
		bhs.s	.next					; branch if camera is below $370

		subq.b	#2,(v_dle_routine).w
		rts
; ===========================================================================

.next:
		cmpi.w	#$500,(v_scrposy).w
		blo.s	.exit					; branch if camera is above $500

		move.w	#$500,(v_limittop2).w
		addq.b	#2,(v_dle_routine).w			; goto DLE_MZ1_6 next

	.exit:
		rts
; ===========================================================================

DLE_MZ1_6:
		cmpi.w	#$E70,(v_scrposx).w
		blo.s	.exit					; branch if camera is left of $E70

		move.w	#0,(v_limittop2).w

	.exit:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone - Act 2

DLE_MZ2:
		move.w	#$520,(v_limitbtm1).w
		cmpi.w	#$1500,(v_scrposx).w
		blo.s	.exit					; branch if camera is left of $1500

		move.w	#$540,(v_limitbtm1).w

	.exit:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Marble Zone - Act 3

DLE_MZ3:
		rts						; no events for act 3

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
DLE_SLZx:
		dc.w	DLE_SLZ123-DLE_SLZx
		dc.w	DLE_SLZ123-DLE_SLZx
		dc.w	DLE_SLZ123-DLE_SLZx
; ===========================================================================
; ---------------------------------------------------------------------------
; Star Light Zone - Act 1, 2 & 3

DLE_SLZ123:
		rts						; no events for any of the acts