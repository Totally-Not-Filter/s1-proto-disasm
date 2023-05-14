; ---------------------------------------------------------------------------

ObjUnkSwitch:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	off_67C8(pc,d0.w),d1
		jmp	off_67C8(pc,d1.w)
; ---------------------------------------------------------------------------

off_67C8:	dc.w loc_67CE-off_67C8, loc_67F8-off_67C8, loc_6836-off_67C8
; ---------------------------------------------------------------------------

loc_67CE:
		addq.b	#2,$24(a0)
		move.l	#MapUnkSwitch,obMap(a0)
		move.w	#$4000,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	obY(a0),$30(a0)
		move.b	#$10,obActWid(a0)
		move.b	#5,obPriority(a0)

loc_67F8:
		move.w	$30(a0),obY(a0)
		move.w	#$10,d1
		bsr.w	sub_683C
		beq.s	loc_6812
		addq.w	#2,obY(a0)
		moveq	#1,d0
		move.w	d0,(unk_FFF7E0).w

loc_6812:
		bsr.w	DisplaySprite
		move.w	obX(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#640,d0
		bhi.w	loc_6836
		rts
; ---------------------------------------------------------------------------

loc_6836:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_683C:
		lea	(v_objspace).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_6874
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	loc_6874
		move.w	obY(a1),d2
		move.b	obHeight(a1),d1
		ext.w	d1
		add.w	d2,d1
		move.w	obY(a0),d0
		subi.w	#$10,d0
		sub.w	d1,d0
		bhi.s	loc_6874
		cmpi.w	#$FFF0,d0
		bcs.s	loc_6874
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_6874:
		moveq	#0,d0
		rts