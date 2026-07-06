; ---------------------------------------------------------------------------
; Object 1A - GHZ collapsing ledge
; ---------------------------------------------------------------------------

CollapseLedge:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Ledge_Index(pc,d0.w),d1
		jmp	Ledge_Index(pc,d1.w)
; ===========================================================================
Ledge_Index:	dc.w Ledge_Main-Ledge_Index, Ledge_Touch-Ledge_Index
		dc.w Ledge_Collapse-Ledge_Index, Ledge_Display-Ledge_Index
		dc.w Ledge_Delete-Ledge_Index, Ledge_WalkOff-Ledge_Index

ledge_timedelay = objoff_38		; time between touching the ledge and it collapsing
ledge_collapse_flag = objoff_3A		; collapse flag
; ===========================================================================

Ledge_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Ledge,obMap(a0)
		move.w	#ArtTile_Level|Tile_Pal3,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#7,ledge_timedelay(a0) ; set time delay for collapse
		move.b	#$64,obActWid(a0)
		move.b	obSubtype(a0),obFrame(a0)

Ledge_Touch:	; Routine 2
		tst.b	ledge_collapse_flag(a0)	; is ledge collapsing?
		beq.s	.slope		; if not, branch
		tst.b	ledge_timedelay(a0)	; has time reached zero?
		beq.w	Ledge_Fragment	; if yes, branch
		subq.b	#1,ledge_timedelay(a0) ; subtract 1 from time

.slope:
		move.w	#$30,d1
		lea	(Ledge_SlopeData).l,a2
		bsr.w	SlopeObject
		bra.w	RememberState
; ===========================================================================

Ledge_Collapse:	; Routine 4
		tst.b	ledge_timedelay(a0)
		beq.w	loc_6130
		move.b	#1,ledge_collapse_flag(a0)
		subq.b	#1,ledge_timedelay(a0)

; ===========================================================================

Ledge_WalkOff:	; Routine $A
		move.w	#$30,d1
		bsr.w	ExitPlatform
		move.w	#$30,d1
		lea	(Ledge_SlopeData).l,a2
		move.w	obX(a0),d2
		bsr.w	SlopeObject2
		bra.w	RememberState
; End of function Ledge_WalkOff

; ===========================================================================

Ledge_Display:	; Routine 6
		tst.b	ledge_timedelay(a0)	; has time delay reached zero?
		beq.s	Ledge_TimeZero	; if yes, branch
		tst.b	ledge_collapse_flag(a0)	; is ledge collapsing?
		bne.w	loc_5F94	; if yes, branch
		subq.b	#1,ledge_timedelay(a0) ; subtract 1 from time
		bra.w	DisplaySprite
; ===========================================================================

loc_5F94:
		subq.b	#1,ledge_timedelay(a0)
		bsr.w	Ledge_WalkOff
		lea	(v_player).w,a1
		btst	#3,obStatus(a1)
		beq.s	loc_5FC0
		tst.b	ledge_timedelay(a0)
		bne.s	locret_5FCC
		bclr	#3,obStatus(a1)
		bclr	#5,obStatus(a1)
		move.b	#id_Run,obNextAni(a1) ; restart Sonic's animation

loc_5FC0:
		move.b	#0,ledge_collapse_flag(a0)
		move.b	#6,obRoutine(a0) ; run "Ledge_Display" routine

locret_5FCC:
		rts
; ===========================================================================

Ledge_TimeZero:
		bsr.w	ObjectFall
	if FixBugs
		tst.b	obRender(a0)
		bpl.s	Ledge_Delete
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		tst.b	obRender(a0)
		bpl.s	Ledge_Delete
		rts
	endif
; ===========================================================================

Ledge_Delete:	; Routine 8
		bsr.w	DeleteObject
		rts

; ---------------------------------------------------------------------------
; Object 53 - collapsing floors (MZ, SLZ)
; ---------------------------------------------------------------------------

CollapseFloor:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	CFlo_Index(pc,d0.w),d1
		jmp	CFlo_Index(pc,d1.w)
; ===========================================================================
CFlo_Index:	dc.w CFlo_Main-CFlo_Index, CFlo_Touch-CFlo_Index
		dc.w CFlo_Collapse-CFlo_Index, CFlo_Display-CFlo_Index
		dc.w CFlo_Delete-CFlo_Index, CFlo_WalkOff-CFlo_Index

cflo_timedelay = objoff_38
cflo_collapse_flag = objoff_3A
; ===========================================================================

CFlo_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_CFlo,obMap(a0)
		move.w	#ArtTile_MZ_Block|Tile_Pal3,obGfx(a0)
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	.notSLZ

		move.w	#ArtTile_SLZ_Smashable_Wall|Tile_Pal3,obGfx(a0) ; SLZ specific code
		addq.b	#2,obFrame(a0)

.notSLZ:
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#7,cflo_timedelay(a0)
		move.b	#$44,obActWid(a0)

CFlo_Touch:	; Routine 2
		tst.b	cflo_collapse_flag(a0)	; has Sonic touched the object?
		beq.s	.solid		; if not, branch
		tst.b	cflo_timedelay(a0)	; has time delay reached zero?
		beq.w	CFlo_Fragment	; if yes, branch
		subq.b	#1,cflo_timedelay(a0) ; subtract 1 from time

.solid:
		move.w	#$20,d1
		bsr.w	PlatformObject
		tst.b	obSubtype(a0)
		bpl.s	.remstate
		btst	#3,obStatus(a1)
		beq.s	.remstate
		bclr	#0,obRender(a0)
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		bcc.s	.remstate
		bset	#0,obRender(a0)

.remstate:
		bra.w	RememberState
; ===========================================================================

CFlo_Collapse:	; Routine 4
		tst.b	cflo_timedelay(a0)
		beq.w	loc_610E
		move.b	#1,cflo_collapse_flag(a0)	; set object as "touched"
		subq.b	#1,cflo_timedelay(a0)

; ===========================================================================

CFlo_WalkOff:	; Routine $A
		move.w	#$20,d1
		bsr.w	ExitPlatform
		move.w	obX(a0),d2
		bsr.w	MvSonicOnPtfm2
		bra.w	RememberState
; End of function CFlo_WalkOff

; ===========================================================================

CFlo_Display:	; Routine 6
		tst.b	cflo_timedelay(a0)	; has time delay reached zero?
		beq.s	CFlo_TimeZero	; if yes, branch
		tst.b	cflo_collapse_flag(a0)	; has Sonic touched the object?
		bne.w	loc_60B8	; if yes, branch
		subq.b	#1,cflo_timedelay(a0)	; subtract 1 from time
		bra.w	DisplaySprite
; ===========================================================================

loc_60B8:
		subq.b	#1,cflo_timedelay(a0)
		bsr.w	CFlo_WalkOff
		lea	(v_player).w,a1
		btst	#3,obStatus(a1)
		beq.s	loc_60E4
		tst.b	cflo_timedelay(a0)
		bne.s	locret_60F0
		bclr	#3,obStatus(a1)
		bclr	#5,obStatus(a1)
		move.b	#id_Run,obNextAni(a1) ; restart Sonic's animation

loc_60E4:
		move.b	#0,cflo_collapse_flag(a0)
		move.b	#6,obRoutine(a0) ; run "CFlo_Display" routine

locret_60F0:
		rts
; ===========================================================================

CFlo_TimeZero:
		bsr.w	ObjectFall
	if FixBugs
		tst.b	obRender(a0)
		bpl.s	CFlo_Delete
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		tst.b	obRender(a0)
		bpl.s	CFlo_Delete
		rts
	endif
; ===========================================================================

CFlo_Delete:	; Routine 8
		bsr.w	DeleteObject
		rts
; ===========================================================================

CFlo_Fragment:
		move.b	#0,cflo_collapse_flag(a0)

loc_610E:
		lea	(CFlo_Data2).l,a4
		btst	#0,obSubtype(a0)
		beq.s	loc_6122
		lea	(CFlo_Data3).l,a4

loc_6122:
		moveq	#8-1,d1
		addq.b	#1,obFrame(a0)
		bra.s	loc_613C
; ===========================================================================

Ledge_Fragment:
		move.b	#0,ledge_collapse_flag(a0)

loc_6130:
		lea	(CFlo_Data1).l,a4
		moveq	#25-1,d1
		addq.b	#2,obFrame(a0)

loc_613C:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		add.w	d0,d0
		movea.l	obMap(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,obRender(a0)
		_move.b	obID(a0),d4
		move.b	obRender(a0),d5
		movea.l	a0,a1
		bra.s	loc_6168
; ===========================================================================

loc_6160:
		bsr.w	FindFreeObj
		bne.s	loc_61A8
		addq.w	#5,a3

loc_6168:
		move.b	#6,obRoutine(a1)
		_move.b	d4,obID(a1)
		move.l	a3,obMap(a1)
		move.b	d5,obRender(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.b	obPriority(a0),obPriority(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.b	(a4)+,ledge_timedelay(a1)
		cmpa.l	a0,a1
		bhs.s	loc_61A4
		bsr.w	DisplaySprite1

loc_61A4:
		dbf	d1,loc_6160

loc_61A8:
		bsr.w	DisplaySprite
		move.w	#sfx_Collapse,d0
		jmp	(QueueSound2).l
; ===========================================================================

CFlo_Data1:	dc.b $1C, $18, $14, $10, $1A, $16, $12, $E, $A, 6, $18
		dc.b $14, $10, $C, 8, 4, $16, $12, $E, $A, 6, 2, $14, $10
		dc.b $C
		even
CFlo_Data2:	dc.b $1E, $16, $E, 6, $1A, $12, $A, 2
		even
CFlo_Data3:	dc.b $16, $1E, $1A, $12, 6, $E, $A, 2
		even
; ===========================================================================

SlopeObject2:
		lea	(v_player).w,a1
		btst	#3,obStatus(a1)
		beq.s	locret_6224
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		lsr.w	#1,d0
		btst	#0,obRender(a0)
		beq.s	loc_6204
		not.w	d0
		add.w	d1,d0

loc_6204:
		moveq	#0,d1
		move.b	(a2,d0.w),d1
		move.w	obY(a0),d0
		sub.w	d1,d0
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		sub.w	obX(a0),d2
		sub.w	d2,obX(a1)

locret_6224:
		rts
; ===========================================================================

Ledge_SlopeData: dc.b $20, $20, $20, $20, $20, $20, $20, $20, $21, $21
		dc.b $22, $22, $23, $23, $24, $24, $25, $25, $26, $26
		dc.b $27, $27, $28, $28, $29, $29, $2A, $2A, $2B, $2B
		dc.b $2C, $2C, $2D, $2D, $2E, $2E, $2F, $2F, $30, $30
		dc.b $30, $30, $30, $30, $30, $30, $30, $30
		even