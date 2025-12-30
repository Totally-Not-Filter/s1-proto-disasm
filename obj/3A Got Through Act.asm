; ---------------------------------------------------------------------------
; Object 3A - "SONIC GOT THROUGH" title card
; ---------------------------------------------------------------------------

GotThroughCard:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Got_Index(pc,d0.w),d1
		jmp	Got_Index(pc,d1.w)
; ---------------------------------------------------------------------------

Got_Index:	dc.w Got_ChkPLC-Got_Index
		dc.w Got_Move-Got_Index
		dc.w Got_Wait-Got_Index
		dc.w Got_TimeBonus-Got_Index
		dc.w Got_Wait-Got_Index
		dc.w Got_NextLevel-Got_Index

got_mainX = objoff_30		; position for card to display on
; ---------------------------------------------------------------------------

Got_ChkPLC:
		tst.l	(v_plc_buffer).w
		beq.s	Got_Main
		rts
; ---------------------------------------------------------------------------

Got_Main:
		movea.l	a0,a1
		lea	(Got_Config).l,a2
		moveq	#6,d1

Got_Loop:
		_move.b	#id_GotThroughCard,obID(a1)
		move.w	(a2)+,obX(a1)
		move.w	(a2)+,got_mainX(a1)
		move.w	(a2)+,obScreenY(a1)
		move.b	(a2)+,obRoutine(a1)
		move.b	(a2)+,d0
		cmpi.b	#6,d0
		bne.s	loc_A72E
		add.b	(v_act).w,d0

loc_A72E:
		move.b	d0,obFrame(a1)
		move.l	#Map_Got,obMap(a1)
		move.w	#make_art_tile(ArtTile_Title_Card,0,1),obGfx(a1)
		move.b	#0,obRender(a1)
		lea	object_size(a1),a1
		dbf	d1,Got_Loop

Got_Move:
		moveq	#$10,d1
		move.w	got_mainX(a0),d0
		cmp.w	obX(a0),d0
		beq.s	loc_A774
		bge.s	Got_ChgPos
		neg.w	d1

Got_ChgPos:
		add.w	d1,obX(a0)

loc_A762:
		move.w	obX(a0),d0
		bmi.s	locret_A772
		cmpi.w	#$200,d0
		bcc.s	locret_A772
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

locret_A772:
		rts
; ---------------------------------------------------------------------------

loc_A774:
		cmpi.b	#4,obFrame(a0)
		bne.s	loc_A762
		addq.b	#2,obRoutine(a0)
		move.w	#180,obTimeFrame(a0)

Got_Wait:
		subq.w	#1,obTimeFrame(a0)
		bne.s	Got_Display
		addq.b	#2,obRoutine(a0)

Got_Display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

Got_TimeBonus:
		bsr.w	DisplaySprite
		move.b	#1,(f_endactbonus).w
		moveq	#0,d0
		tst.w	(v_timebonus).w
		beq.s	Got_RingBonus
		addi.w	#10,d0
		subi.w	#10,(v_timebonus).w

Got_RingBonus:
		tst.w	(v_ringbonus).w
		beq.s	Got_ChkBonus
		addi.w	#10,d0
		subi.w	#10,(v_ringbonus).w

Got_ChkBonus:
		tst.w	d0
		bne.s	Got_AddBonus
		move.w	#sfx_Cash,d0
		jsr	(QueueSound2).l
		addq.b	#2,obRoutine(a0)
		move.w	#180,obTimeFrame(a0)

locret_A7D8:
		rts
; ---------------------------------------------------------------------------

Got_AddBonus:
		bsr.w	AddPoints
		move.b	(v_vint_byte).w,d0
		andi.b	#3,d0
		bne.s	locret_A7D8
		move.w	#sfx_Switch,d0
		jmp	(QueueSound2).l
; ---------------------------------------------------------------------------

Got_NextLevel:
		move.b	(v_zone).w,d0
		andi.w	#7,d0
		lsl.w	#3,d0
		move.b	(v_act).w,d1
		andi.w	#3,d1
		add.w	d1,d1
		add.w	d1,d0
		move.w	LevelOrder(pc,d0.w),d0
		move.w	d0,(v_zone).w
		tst.w	d0
		bne.s	loc_A81C
		move.b	#id_Sega,(v_gamemode).w
		bra.s	Got_Display2
; ---------------------------------------------------------------------------

loc_A81C:
		move.w	#1,(f_restart).w

Got_Display2:
		bra.w	DisplaySprite
; ===========================================================================
; Level order array
; ===========================================================================
LevelOrder:
		dc.b id_GHZ,1	; GHZ1
		dc.b id_GHZ,2	; GHZ2
		dc.b id_MZ,0	; GHZ3
		dc.b 0,0
		dc.b id_LZ,1	; LZ1
		dc.b id_LZ,2	; LZ2
		dc.b id_MZ,0	; LZ3
		dc.b 0,0
		dc.b id_MZ,1	; MZ1
		dc.b id_MZ,2	; MZ2
		dc.b id_SZ,0	; MZ3
		dc.b 0,0
		dc.b 0,0
		dc.b id_SLZ,2	; SLZ2
		dc.b id_MZ,0	; SLZ3
		dc.b 0,0
		dc.b id_SLZ,0	; SZ1
		dc.b id_SZ,2	; SZ2
		dc.b id_CWZ,0	; SZ3
		dc.b 0,0
		dc.b id_CWZ,1	; CWZ1
		dc.b id_CWZ,2	; CWZ2
		dc.b 0,0
		dc.b 0,0
; ===========================================================================
		;    x-start, x-main, y-main,
		;    routine, frame number

Got_Config:	dc.w 4,		$124,	$BC			; "SONIC HAS"
		dc.b 				2,	0

		dc.w -$120,	$120,	$D0			; "PASSED"
		dc.b 				2,	1

		dc.w $40C,	$14C,	$D6			; "ACT" 1/2/3
		dc.b 				2,	6

		dc.w $520,	$120,	$EC			; score
		dc.b 				2,	2

		dc.w $540,	$120,	$FC			; time bonus
		dc.b 				2,	3

		dc.w $560,	$120,	$10C			; ring bonus
		dc.b 				2,	4

		dc.w $20C,	$14C,	$CC			; oval
		dc.b 				2,	5