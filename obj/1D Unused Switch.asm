; ---------------------------------------------------------------------------

ObjUnkSwitch:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_67C8(pc,d0.w),d1
		jmp	off_67C8(pc,d1.w)
; ---------------------------------------------------------------------------

off_67C8:	dc.w loc_67CE-off_67C8
		dc.w loc_67F8-off_67C8
		dc.w loc_6836-off_67C8
; ---------------------------------------------------------------------------

loc_67CE:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_UnkSwitch,obMap(a0)
		move.w	#make_art_tile(ArtTile_Level,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	obY(a0),objoff_30(a0)
		move.b	#$10,obActWid(a0)
		move.b	#5,obPriority(a0)

loc_67F8:
		move.w	objoff_30(a0),obY(a0)
		move.w	#$10,d1
		bsr.w	sub_683C
		beq.s	loc_6812
		addq.w	#2,obY(a0)
		moveq	#1,d0
		move.w	d0,(f_switch).w

loc_6812:
	if FixBugs
		out_of_range.w	loc_6836
		bra.w	DisplaySprite
	else
		bsr.w	DisplaySprite
		out_of_range.w	loc_6836
		rts
	endif
; ---------------------------------------------------------------------------

loc_6836:
		bsr.w	DeleteObject
		rts
; ---------------------------------------------------------------------------

sub_683C:
		lea	(v_player).w,a1
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
		cmpi.w	#-$10,d0
		bcs.s	loc_6874
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_6874:
		moveq	#0,d0
		rts