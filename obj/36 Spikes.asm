; ---------------------------------------------------------------------------

ObjSpikes:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_AB0A(pc,d0.w),d1
		jmp	off_AB0A(pc,d1.w)
; ---------------------------------------------------------------------------

off_AB0A:	dc.w loc_AB1A-off_AB0A
		dc.w loc_AB64-off_AB0A

spik_origX = objoff_30		; start X position
spik_origY = objoff_32		; start Y position

Spik_Var:	dc.b 0, $14		; frame number, object width
		dc.b 1, $10
		dc.b 2, 4
		dc.b 3, $1C
		dc.b 4, $40
		dc.b 5, $10
; ---------------------------------------------------------------------------

loc_AB1A:
		addq.b	#2,obRoutine(a0)
		move.l	#MapSpikes,obMap(a0)
		move.w	#make_art_tile(ArtTile_Spikes,0,0),obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	obSubtype(a0),d0
		andi.b	#$F,obSubtype(a0)
		andi.w	#$F0,d0
		lea	(Spik_Var).l,a1
		lsr.w	#3,d0
		adda.w	d0,a1
		move.b	(a1)+,obFrame(a0)
		move.b	(a1)+,obActWid(a0)
		move.w	obX(a0),spik_origX(a0)
		move.w	obY(a0),spik_origY(a0)

loc_AB64:
		bsr.w	sub_AC02
		move.w	#4,d2
		cmpi.b	#5,obFrame(a0)
		beq.s	loc_AB80
		cmpi.b	#1,obFrame(a0)
		bne.s	loc_AB9E
		move.w	#$14,d2

loc_AB80:
		move.w	#$1B,d1
		move.w	d2,d3
		subq.w	#2,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		tst.b	ob2ndRout(a0)
		bne.s	loc_ABDE
		cmpi.w	#1,d4
		beq.s	loc_ABBE
		bra.s	loc_ABDE
; ---------------------------------------------------------------------------

loc_AB9E:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		bsr.w	Obj44_SolidWall
		tst.w	d4
		bpl.s	loc_ABDE
		tst.w	obVelY(a1)
		beq.s	loc_ABDE
		tst.w	d3
		bmi.s	loc_ABDE

loc_ABBE:
		move.l	a0,-(sp)
		movea.l	a0,a2
		lea	(v_player).w,a0
		move.l	obY(a0),d3
		move.w	obVelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,obY(a0)
		bsr.w	HurtSonic
		movea.l	(sp)+,a0

loc_ABDE:
	if FixBugs
		out_of_range.w	DeleteObject,spik_origX(a0)
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject,spik_origX(a0)
		rts
	endif
; ---------------------------------------------------------------------------

sub_AC02:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	off_AC12(pc,d0.w),d1
		jmp	off_AC12(pc,d1.w)
; ---------------------------------------------------------------------------

off_AC12:	dc.w locret_AC18-off_AC12
		dc.w loc_AC1A-off_AC12
		dc.w loc_AC2E-off_AC12
; ---------------------------------------------------------------------------

locret_AC18:
		rts
; ---------------------------------------------------------------------------

loc_AC1A:
		bsr.w	sub_AC42
		moveq	#0,d0
		move.b	objoff_34(a0),d0
		add.w	spik_origY(a0),d0
		move.w	d0,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_AC2E:
		bsr.w	sub_AC42
		moveq	#0,d0
		move.b	objoff_34(a0),d0
		add.w	spik_origX(a0),d0
		move.w	d0,obX(a0)
		rts
; ---------------------------------------------------------------------------

sub_AC42:
		tst.w	objoff_38(a0)
		beq.s	loc_AC60
		subq.w	#1,objoff_38(a0)
		bne.s	locret_ACA2
		tst.b	obRender(a0)
		bpl.s	locret_ACA2
		move.w	#sfx_SpikesMove,d0
		jsr	(QueueSound2).l
		bra.s	locret_ACA2
; ---------------------------------------------------------------------------

loc_AC60:
		tst.w	objoff_36(a0)
		beq.s	loc_AC82
		subi.w	#$800,objoff_34(a0)
		bcc.s	locret_ACA2
		move.w	#0,objoff_34(a0)
		move.w	#0,objoff_36(a0)
		move.w	#$3C,objoff_38(a0)
		bra.s	locret_ACA2
; ---------------------------------------------------------------------------

loc_AC82:
		addi.w	#$800,objoff_34(a0)
		cmpi.w	#$2000,objoff_34(a0)
		bcs.s	locret_ACA2
		move.w	#$2000,objoff_34(a0)
		move.w	#1,objoff_36(a0)
		move.w	#$3C,objoff_38(a0)

locret_ACA2:
		rts