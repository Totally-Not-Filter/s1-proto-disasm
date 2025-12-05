; ---------------------------------------------------------------------------
; Subroutine to	update the HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

UpdateHUD:
		tst.w	(f_debugmode).w
		bne.w	HudDebug
		tst.b	(f_scorecount).w
		beq.s	loc_1169A

		clr.b	(f_scorecount).w
		locVRAM (ArtTile_HUD+$1A)*tile_size,d0
		move.l	(v_score).w,d1
		bsr.w	Hud_Score

loc_1169A:
		tst.b	(f_ringcount).w
		beq.s	loc_116BA
		bpl.s	loc_116A6
		bsr.w	Hud_LoadZero

loc_116A6:
		clr.b	(f_ringcount).w
		locVRAM (ArtTile_HUD+$30)*tile_size,d0
		moveq	#0,d1
		move.w	(v_rings).w,d1
		bsr.w	Hud_Rings

loc_116BA:
		tst.b	(f_timecount).w
		beq.s	loc_1170E
		tst.w	(f_pause).w
		bmi.s	loc_1170E
		lea	(v_score).w,a1

		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		blo.s	loc_1170E
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		blo.s	loc_116EE
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#9,(a1)
		blo.s	loc_116EE
		move.b	#9,(a1)

loc_116EE:
		locVRAM (ArtTile_HUD+$28)*tile_size,d0
		moveq	#0,d1
		move.b	(v_timemin).w,d1
		bsr.w	Hud_Mins
		locVRAM (ArtTile_HUD+$2C)*tile_size,d0
		moveq	#0,d1
		move.b	(v_timesec).w,d1
		bsr.w	Hud_Secs

loc_1170E:
		tst.b	(f_lifecount).w
		beq.s	loc_1171C
		clr.b	(f_lifecount).w
		bsr.w	Hud_Lives

loc_1171C:
		tst.b	(f_endactbonus).w
		beq.s	locret_11744
		clr.b	(f_endactbonus).w
		locVRAM ArtTile_Bonuses*tile_size
		moveq	#0,d1
		move.w	(v_timebonus).w,d1
		bsr.w	Hud_TimeRingBonus
		moveq	#0,d1
		move.w	(v_ringbonus).w,d1
		bsr.w	Hud_TimeRingBonus

locret_11744:
		rts
; ---------------------------------------------------------------------------

HudDebug:
		bsr.w	HudDb_XY
		tst.b	(f_ringcount).w
		beq.s	loc_1176A
		bpl.s	loc_11756
		bsr.w	Hud_LoadZero

loc_11756:
		clr.b	(f_ringcount).w
		locVRAM (ArtTile_HUD+$30)*tile_size,d0
		moveq	#0,d1
		move.w	(v_rings).w,d1
		bsr.w	Hud_Rings

loc_1176A:
		locVRAM (ArtTile_HUD+$2C)*tile_size,d0
		moveq	#0,d1
		move.b	(v_spritecount).w,d1
		bsr.w	Hud_Secs
		tst.b	(f_lifecount).w
		beq.s	loc_11788
		clr.b	(f_lifecount).w
		bsr.w	Hud_Lives

loc_11788:
		tst.b	(f_endactbonus).w
		beq.s	locret_117B0
		clr.b	(f_endactbonus).w
		locVRAM ArtTile_Bonuses*tile_size
		moveq	#0,d1
		move.w	(v_timebonus).w,d1
		bsr.w	Hud_TimeRingBonus
		moveq	#0,d1
		move.w	(v_ringbonus).w,d1
		bsr.w	Hud_TimeRingBonus

locret_117B0:
		rts
; ---------------------------------------------------------------------------

Hud_LoadZero:
		locVRAM (ArtTile_HUD+$30)*tile_size
		lea	Hud_TilesRings(pc),a2
		move.w	#Hud_TilesBase_End-Hud_TilesRings-1,d2
		bra.s	loc_117E2
; ---------------------------------------------------------------------------

Hud_Base:
		lea	(vdp_data_port).l,a6
		bsr.w	Hud_Lives
		locVRAM (ArtTile_HUD+$18)*tile_size
		lea	Hud_TilesBase(pc),a2
		move.w	#Hud_TilesBase_End-Hud_TilesBase-1,d2

loc_117E2:
		lea	Art_Hud(pc),a1

loc_117E6:
		move.w	#16-1,d1
		move.b	(a2)+,d0
		bmi.s	loc_11802
		ext.w	d0
		lsl.w	#5,d0
		lea	(a1,d0.w),a3

loc_117F6:
		move.l	(a3)+,(a6)
		dbf	d1,loc_117F6

loc_117FC:
		dbf	d2,loc_117E6
		rts
; ---------------------------------------------------------------------------

loc_11802:
		move.l	#0,(a6)
		dbf	d1,loc_11802
		bra.s	loc_117FC
; ---------------------------------------------------------------------------
		charset	' ',$FF
		charset	'0',0
		charset	'1',2
		charset	'2',4
		charset	'3',6
		charset	'4',8
		charset	'5',$A
		charset	'6',$C
		charset	'7',$E
		charset	'8',$10
		charset	'9',$12
		charset	':',$14
		charset	'E',$16

;byte_1180E:
Hud_TilesBase:
		dc.b "E      0"
		dc.b "0:00"
;byte_1181A:
Hud_TilesRings:
		dc.b "  0"
Hud_TilesBase_End
		even

		charset
; ---------------------------------------------------------------------------

HudDb_XY:
		locVRAM (ArtTile_HUD+$18)*tile_size
		move.w	(v_scrposx).w,d1
		swap	d1
		move.w	(v_player+obX).w,d1
		bsr.s	sub_1183E
		move.w	(v_scrposy).w,d1
		swap	d1
		move.w	(v_player+obY).w,d1

sub_1183E:
		moveq	#8-1,d6
		lea	(Art_Text).l,a1

loc_11846:
		rol.w	#4,d1
		move.w	d1,d2
		andi.w	#$F,d2
		cmpi.w	#$A,d2
		bcs.s	loc_11856
		addq.w	#7,d2

loc_11856:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		swap	d1
		dbf	d6,loc_11846
		rts
; ---------------------------------------------------------------------------

Hud_Rings:
		lea	(Hud_100).l,a2
		moveq	#3-1,d6
		bra.s	loc_11886
; ---------------------------------------------------------------------------

Hud_Score:
		lea	(Hud_100000).l,a2
		moveq	#6-1,d6

loc_11886:
		moveq	#0,d4
		lea	Art_Hud(pc),a1

loc_1188C:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_11890:
		sub.l	d3,d1
		bcs.s	loc_11898
		addq.w	#1,d2
		bra.s	loc_11890
; ---------------------------------------------------------------------------

loc_11898:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_118A2
		move.w	#1,d4

loc_118A2:
		tst.w	d4
		beq.s	loc_118D0
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_118D0:
		addi.l	#$400000,d0
		dbf	d6,loc_1188C
		rts
; ---------------------------------------------------------------------------
Hud_100000:	dc.l 100000
Hud_10000:	dc.l 10000
Hud_1000:	dc.l 1000
Hud_100:	dc.l 100
Hud_10:		dc.l 10
Hud_1:		dc.l 1
; ---------------------------------------------------------------------------

Hud_Mins:
		lea	(Hud_1).l,a2
		moveq	#1-1,d6
		bra.s	loc_11906
; ---------------------------------------------------------------------------

Hud_Secs:
		lea	(Hud_10).l,a2
		moveq	#2-1,d6

loc_11906:
		moveq	#0,d4
		lea	Art_Hud(pc),a1

loc_1190C:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_11910:
		sub.l	d3,d1
		bcs.s	loc_11918
		addq.w	#1,d2
		bra.s	loc_11910
; ---------------------------------------------------------------------------

loc_11918:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_11922
		move.w	#1,d4

loc_11922:
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		addi.l	#$400000,d0
		dbf	d6,loc_1190C
		rts
; ---------------------------------------------------------------------------

Hud_TimeRingBonus:
		lea	(Hud_1000).l,a2
		moveq	#4-1,d6
		moveq	#0,d4
		lea	Art_Hud(pc),a1

loc_11966:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1196A:
		sub.l	d3,d1
		bcs.s	loc_11972
		addq.w	#1,d2
		bra.s	loc_1196A
; ---------------------------------------------------------------------------

loc_11972:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1197C
		move.w	#1,d4

loc_1197C:
		tst.w	d4
		beq.s	loc_119AC
		lsl.w	#6,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_119A6:
		dbf	d6,loc_11966
		rts
; ---------------------------------------------------------------------------

loc_119AC:
		moveq	#16-1,d5

loc_119AE:
		move.l	#0,(a6)
		dbf	d5,loc_119AE
		bra.s	loc_119A6
; ---------------------------------------------------------------------------

Hud_Lives:
		locVRAM (ArtTile_Lives_Counter+9)*tile_size,d0
		moveq	#0,d1
		move.b	(v_lives).w,d1
		lea	(Hud_10).l,a2
		moveq	#2-1,d6
		moveq	#0,d4
		lea	Art_LivesNums(pc),a1

loc_119D4:
		move.l	d0,4(a6)
		moveq	#0,d2
		move.l	(a2)+,d3

loc_119DC:
		sub.l	d3,d1
		bcs.s	loc_119E4
		addq.w	#1,d2
		bra.s	loc_119DC
; ---------------------------------------------------------------------------

loc_119E4:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_119EE
		move.w	#1,d4

loc_119EE:
		tst.w	d4
		beq.s	loc_11A14

loc_119F2:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_11A08:
		addi.l	#$400000,d0
		dbf	d6,loc_119D4
		rts
; ---------------------------------------------------------------------------

loc_11A14:
		tst.w	d6
		beq.s	loc_119F2
		moveq	#8-1,d5

loc_11A1A:
		move.l	#0,(a6)
		dbf	d5,loc_11A1A
		bra.s	loc_11A08