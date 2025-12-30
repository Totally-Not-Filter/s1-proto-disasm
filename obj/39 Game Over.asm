; ---------------------------------------------------------------------------

ObjGameOver:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_A652(pc,d0.w),d1
		jmp	off_A652(pc,d1.w)
; ---------------------------------------------------------------------------

off_A652:	dc.w loc_A658-off_A652
		dc.w loc_A696-off_A652
		dc.w loc_A6B8-off_A652
; ---------------------------------------------------------------------------

loc_A658:
		tst.l	(v_plc_buffer).w
		beq.s	loc_A660
		rts
; ---------------------------------------------------------------------------

loc_A660:
		addq.b	#2,obRoutine(a0)
		move.w	#$50,obX(a0)
		tst.b	obFrame(a0)
		beq.s	loc_A676
		move.w	#$1F0,obX(a0)

loc_A676:
		move.w	#$F0,obScreenY(a0)
		move.l	#Map_Over,obMap(a0)
		move.w	#make_art_tile(ArtTile_Game_Over,0,1),obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#0,obPriority(a0)

loc_A696:
		moveq	#$10,d1
		cmpi.w	#$120,obX(a0)
		beq.s	loc_A6AC
		bcs.s	loc_A6A4
		neg.w	d1

loc_A6A4:
		add.w	d1,obX(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_A6AC:
		move.w	#60*10,obTimeFrame(a0)	; wait 10 seconds
		addq.b	#2,obRoutine(a0)
	if FixBugs
		bra.w	DisplaySprite
	else
		rts
	endif
; ---------------------------------------------------------------------------

loc_A6B8:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		bne.s	loc_A6D6
		tst.b	obFrame(a0)
		bne.s	loc_A6DC
		tst.w	obTimeFrame(a0)
		beq.s	loc_A6D6
		subq.w	#1,obTimeFrame(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_A6D6:
		move.b	#id_Sega,(v_gamemode).w

loc_A6DC:
		bra.w	DisplaySprite