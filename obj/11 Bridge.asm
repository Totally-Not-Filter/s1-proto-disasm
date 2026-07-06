; ---------------------------------------------------------------------------
; Object 11 - GHZ bridge
; ---------------------------------------------------------------------------

Bridge:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Bri_Index(pc,d0.w),d1
		jmp	Bri_Index(pc,d1.w)
; ===========================================================================
Bri_Index:	dc.w Bri_Main-Bri_Index, Bri_Action-Bri_Index
		dc.w Bri_Platform-Bri_Index, Bri_Delete-Bri_Index
		dc.w Bri_Delete-Bri_Index, Bri_Display-Bri_Index
; ===========================================================================

Bri_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Bri,obMap(a0)
		move.w	#ArtTile_GHZ_Bridge|Tile_Pal3,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$80,obActWid(a0)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		_move.b	obID(a0),d4	; copy object number ($11) to d4
		lea	obSubtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1		; copy bridge length to d1
		move.b	#0,(a2)+	; clear bridge length
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3		; d3 is position of leftmost log
		subq.b	#2,d1
		bcs.s	Bri_Action	; don't make more if bridge has only 1 log

.buildloop:
	if FixBugs
		bsr.w	FindNextFreeObj
	else
		bsr.w	FindFreeObj
	endif
		bne.s	Bri_Action
		addq.b	#1,obSubtype(a0)
		cmp.w	obX(a0),d3	; is this log the leftmost one?
		bne.s	.notleftmost	; if not, branch

		addi.w	#$10,d3
		move.w	d2,obY(a0)
		move.w	d2,objoff_3C(a0)
		move.w	a0,d5
		subi.w	#v_objspace,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		addq.b	#1,obSubtype(a0)

.notleftmost:
		move.w	a1,d5
		subi.w	#v_objspace,d5
		lsr.w	#object_size_bits,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,obRoutine(a1)
		_move.b	d4,obID(a1)	; load bridge object (d4 = $11)
		move.w	d2,obY(a1)
		move.w	d2,objoff_3C(a1)
		move.w	d3,obX(a1)
		move.l	#Map_Bri,obMap(a1)
		move.w	#ArtTile_GHZ_Bridge|Tile_Pal3,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#3,obPriority(a1)
		move.b	#8,obActWid(a1)
		addi.w	#$10,d3
		dbf	d1,.buildloop ; repeat d1 times (length of bridge)

Bri_Action:	; Routine 2
		bsr.s	Bri_Solid
		tst.b	objoff_3E(a0)
		beq.s	.display
		subq.b	#4,objoff_3E(a0)
		bsr.w	Bri_Bend

.display:
	if FixBugs=0
		bsr.w	DisplaySprite
	endif
		bra.w	Bri_ChkDel
; ===========================================================================

Bri_Solid:
		moveq	#0,d1
		move.b	obSubtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	Plat_Exit
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit
		cmp.w	d2,d0
		bhs.w	Plat_Exit
		bra.s	Plat_NoXCheck
; End of function Bri_Solid

; ===========================================================================

PlatformObject:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)	; is Sonic moving up/jumping?
		bmi.w	Plat_Exit	; if yes, branch

;		perform x-axis range check
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	Plat_Exit

Plat_NoXCheck:
		move.w	obY(a0),d0
		subq.w	#8,d0

Platform3:
;		perform y-axis range check
		move.w	obY(a1),d2
		move.b	obHeight(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.w	Plat_Exit
		cmpi.w	#-$10,d0
		blo.w	Plat_Exit

		cmpi.b	#6,obRoutine(a1)
		bhs.w	Plat_Exit
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,obY(a1)
		addq.b	#2,obRoutine(a0)

loc_4FD4:
		btst	#3,obStatus(a1)
		beq.s	loc_4FFC
		moveq	#0,d0
		move.b	standonobject(a1),d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a2
		cmpi.b	#4,obRoutine(a2)
		bne.s	loc_4FFC
		subq.b	#2,obRoutine(a2)
		clr.b	ob2ndRout(a2)

loc_4FFC:
		move.w	a0,d0
		subi.w	#v_objspace,d0
		lsr.w	#object_size_bits,d0
		andi.w	#$7F,d0
		move.b	d0,standonobject(a1)
		move.b	#0,obAngle(a1)
		move.w	#0,obVelY(a1)
		move.w	obVelX(a1),d0
		asr.w	#2,d0
		sub.w	d0,obVelX(a1)
		move.w	obVelX(a1),obInertia(a1)
		btst	#1,obStatus(a1)
		beq.s	loc_503C
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(Sonic_ResetOnFloor).l
		movea.l	(sp)+,a0

loc_503C:
		bset	#3,obStatus(a1)
		bset	#3,obStatus(a0)

Plat_Exit:
		rts
; End of function PlatformObject

; ---------------------------------------------------------------------------
; Sloped platform subroutine (GHZ collapsing ledges and SLZ seesaws)
; ---------------------------------------------------------------------------

SlopeObject:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	Plat_Exit
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	Plat_Exit
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.s	Plat_Exit
		btst	#0,obRender(a0)
		beq.s	loc_5074
		not.w	d0
		add.w	d1,d0

loc_5074:
		lsr.w	#1,d0
		moveq	#0,d3
		move.b	(a2,d0.w),d3
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	Platform3
; ===========================================================================

Swing_Solid:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	Plat_Exit
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	Plat_Exit
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	Platform3

Bri_Platform:	; Routine 4
		bsr.s	Bri_WalkOff
	if FixBugs=0
		bsr.w	DisplaySprite
	endif
		bra.w	Bri_ChkDel

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk off a bridge
; ---------------------------------------------------------------------------

Bri_WalkOff:
		moveq	#0,d1
		move.b	obSubtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		bsr.s	ExitPlatform2
		bcc.s	locret_50E8
		lsr.w	#4,d0
		move.b	d0,objoff_3F(a0)
		move.b	objoff_3E(a0),d0
		cmpi.b	#$40,d0
		beq.s	loc_50E0
		addq.b	#4,objoff_3E(a0)

loc_50E0:
		bsr.w	Bri_Bend
		bsr.w	Bri_MoveSonic

locret_50E8:
		rts
; End of function Bri_WalkOff

; ===========================================================================

ExitPlatform:
		move.w	d1,d2

ExitPlatform2:
		add.w	d2,d2
		lea	(v_player).w,a1
		btst	#1,obStatus(a1)
		bne.s	loc_510A
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_510A
		cmp.w	d2,d0
		blo.s	locret_511C

loc_510A:
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a0)
		bclr	#3,obStatus(a0)

locret_511C:
		rts

; ===========================================================================

Bri_MoveSonic:
		moveq	#0,d0
		move.b	objoff_3F(a0),d0
		move.b	objoff_29(a0,d0.w),d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a2
		lea	(v_player).w,a1
		move.w	obY(a2),d0
		subq.w	#8,d0
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)	; change Sonic's position on y-axis
		rts
; End of function Bri_MoveSonic

; ===========================================================================

Bri_Bend:
		move.b	objoff_3E(a0),d0
		bsr.w	CalcSine
		move.w	d0,d4
		lea	(Obj11_BendData2).l,a4
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.w	#4,d0
		moveq	#0,d3
		move.b	objoff_3F(a0),d3
		move.w	d3,d2
		add.w	d0,d3
		moveq	#0,d5
		lea	(Obj11_BendData).l,a5
		move.b	(a5,d3.w),d5
		andi.w	#$F,d3
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		lea	objoff_29(a0),a2

loc_5186:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		moveq	#0,d0
		move.b	(a3)+,d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	objoff_3C(a1),d0
		move.w	d0,obY(a1)
		dbf	d2,loc_5186
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		moveq	#0,d3
		move.b	objoff_3F(a0),d3
		addq.b	#1,d3
		sub.b	d0,d3
		neg.b	d3
		bmi.s	locret_51F4
		move.w	d3,d2
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		adda.w	d2,a3
		subq.w	#1,d2
		bcs.s	locret_51F4

loc_51CE:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		moveq	#0,d0
		move.b	-(a3),d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	objoff_3C(a1),d0
		move.w	d0,obY(a1)
		dbf	d2,loc_51CE

locret_51F4:
		rts
; End of function Bri_Bend

; ===========================================================================
; ---------------------------------------------------------------------------
; GHZ bridge-bending data
; (Defines how the bridge bends when Sonic walks across it)
; ---------------------------------------------------------------------------
Obj11_BendData:	binclude	"misc/ghzbend1.bin"
		even
Obj11_BendData2:binclude	"misc/ghzbend2.bin"
		even
; ===========================================================================

Bri_ChkDel:
		out_of_range.w	.deletebridge
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ===========================================================================

.deletebridge:
		moveq	#0,d2
		lea	obSubtype(a0),a2 ; load bridge length
		move.b	(a2)+,d2	; move bridge length to d2
		subq.b	#1,d2		; subtract 1
		bcs.s	.delparent

.loop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a1
		cmp.w	a0,d0
		beq.s	.skipdel
		bsr.w	DeleteChild

.skipdel:
		dbf	d2,.loop ; repeat d2 times (bridge length)

.delparent:
		bsr.w	DeleteObject
		rts
; ===========================================================================

Bri_Delete:	; Routine 6, 8
		bsr.w	DeleteObject
		rts
; ===========================================================================

Bri_Display:	; Routine $A
		bsr.w	DisplaySprite
		rts