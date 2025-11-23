; ---------------------------------------------------------------------------
; Subroutine to	animate	level graphics
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


AnimateLevelGfx:
		tst.w	(f_pause).w			; is the game paused?
		bmi.s	.ispaused			; if yes, branch
		lea	(vdp_data_port).l,a6
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	AniArt_Index(pc,d0.w),d0
		jmp	AniArt_Index(pc,d0.w)

.ispaused:
		rts

; ===========================================================================
AniArt_Index:	dc.w AniArt_GHZ-AniArt_Index, AniArt_none-AniArt_Index
		dc.w AniArt_MZ-AniArt_Index, AniArt_none-AniArt_Index
		dc.w AniArt_none-AniArt_Index, AniArt_none-AniArt_Index
		dc.w AniArt_none-AniArt_Index
; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - Green Hill
; ---------------------------------------------------------------------------

AniArt_GHZ:

AniArt_GHZ_Waterfall:
		subq.b	#1,(v_lani0_time).w
		bpl.s	AniArt_GHZ_Bigflower

		move.b	#6-1,(v_lani0_time).w
		lea	(Art_GhzWater).l,a1
		move.b	(v_lani0_frame).w,d0
		addq.b	#1,(v_lani0_frame).w
		andi.w	#1,d0
		beq.s	.isframe0
		lea	$100(a1),a1

.isframe0:
		locVRAM ArtTile_GHZ_Waterfall*tile_size
		move.w	#8-1,d1
		bra.w	LoadTiles
; ---------------------------------------------------------------------------

AniArt_GHZ_Bigflower:
		subq.b	#1,(v_lani1_time).w
		bpl.s	AniArt_GHZ_Smallflower

		move.b	#16-1,(v_lani1_time).w
		lea	(Art_GhzFlower1).l,a1
		move.b	(v_lani1_frame).w,d0
		addq.b	#1,(v_lani1_frame).w
		andi.w	#1,d0
		beq.s	.isframe0
		lea	$200(a1),a1

.isframe0:
		locVRAM ArtTile_GHZ_Big_Flower_1*tile_size
		move.w	#16-1,d1
		bra.w	LoadTiles
; ---------------------------------------------------------------------------

AniArt_GHZ_Smallflower:
		subq.b	#1,(v_lani2_time).w
		bpl.s	.end

		move.b	#8-1,(v_lani2_time).w
		move.b	(v_lani2_frame).w,d0
		addq.b	#1,(v_lani2_frame).w
		andi.w	#3,d0
		move.b	.sequence(pc,d0.w),d0
		btst	#0,d0
		bne.s	.isframe1
		move.b	#$7F,(v_lani2_time).w

.isframe1:
		lsl.w	#7,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		locVRAM ArtTile_GHZ_Small_Flower*tile_size
		lea	(Art_GhzFlower2).l,a1
		lea	(a1,d0.w),a1
		move.w	#12-1,d1
		bsr.w	LoadTiles

.end:
		rts
; ---------------------------------------------------------------------------

.sequence:	dc.b 0, 1, 2, 1
		even
; ---------------------------------------------------------------------------

AniArt_MZ:

AniArt_MZ_Lava:
		subq.b	#1,(v_lani0_time).w
		bpl.s	AniArt_MZ_Magma

		move.b	#20-1,(v_lani0_time).w
		lea	(Art_MzLava1).l,a1
		moveq	#0,d0
		move.b	(v_lani0_frame).w,d0
		addq.b	#1,d0
		cmpi.b	#3,d0
		bne.s	.frame01or2
		moveq	#0,d0

.frame01or2:
		move.b	d0,(v_lani0_frame).w
		mulu.w	#$100,d0
		adda.w	d0,a1
		locVRAM ArtTile_MZ_Animated_Lava*tile_size
		move.w	#8-1,d1
		bsr.w	LoadTiles

AniArt_MZ_Magma:
		subq.b	#1,(v_lani1_time).w
		bpl.s	AniArt_MZ_Saturns

		move.b	#2-1,(v_lani1_time).w
		moveq	#0,d0
		move.b	(v_lani0_frame).w,d0
		lea	(Art_MzLava2).l,a4
		ror.w	#7,d0
		adda.w	d0,a4
		locVRAM ArtTile_MZ_Animated_Magma*tile_size
		moveq	#0,d3
		move.b	(v_lani1_frame).w,d3
		addq.b	#1,(v_lani1_frame).w
		move.b	(v_oscillate+$A).w,d3
		move.w	#4-1,d2

.loop:
		move.w	d3,d0
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	(AniArt_MZextra).l,a3
		move.w	(a3,d0.w),d0
		lea	(a3,d0.w),a3
		movea.l	a4,a1
		move.w	#$20-1,d1
		jsr	(a3)
		addq.w	#4,d3
		dbf	d2,.loop
		rts
; ---------------------------------------------------------------------------

AniArt_MZ_Saturns:
		subq.b	#1,(v_lani2_time).w
		bpl.w	locret_11480
		move.b	#8-1,(v_lani2_time).w
		lea	(Art_MzSaturns).l,a1
		moveq	#0,d0
		move.b	(v_lani2_frame).w,d0
		addq.b	#1,d0
	if FixBugs
		cmpi.b	#6,d0				; are we on frame 6?
	else
		; Bug: This misses the last frame of animation
		cmpi.b	#5,d0				; are we on frame 5?
	endif
		bne.s	.notframe5			; if not, then set back to frame 0
		moveq	#0,d0

.notframe5:
		move.b	d0,(v_lani2_frame).w
		mulu.w	#$100,d0
		adda.w	d0,a1
		locVRAM ArtTile_MZ_Saturns*tile_size
		move.w	#8-1,d1
		bsr.w	LoadTiles
		
;AniArt_MZ_Torch:
		lea	(Art_MzTorch).l,a1
		moveq	#0,d0
		move.b	(v_lani3_frame).w,d0
		addq.b	#1,(v_lani3_frame).w
		andi.b	#3,(v_lani3_frame).w
		mulu.w	#$C0,d0
		adda.w	d0,a1
		locVRAM ArtTile_MZ_Torch*tile_size
		move.w	#6-1,d1
		bra.w	LoadTiles
; ---------------------------------------------------------------------------

locret_11480:
		rts
; ---------------------------------------------------------------------------

AniArt_none:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	transfer graphics to VRAM

; input:
;	a1 = source address
;	a6 = vdp_data_port ($C00000)
;	d1 = number of tiles to load (minus one)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadTiles:
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		dbf	d1,LoadTiles
		rts
; End of function LoadTiles

; ===========================================================================
; ---------------------------------------------------------------------------
; Animated pattern routine - more Marble Zone
; ---------------------------------------------------------------------------
AniArt_MZextra:	dc.w loc_114BA-AniArt_MZextra, loc_114C6-AniArt_MZextra
		dc.w loc_114DC-AniArt_MZextra, loc_114EA-AniArt_MZextra
		dc.w loc_11500-AniArt_MZextra, loc_1150E-AniArt_MZextra
		dc.w loc_11524-AniArt_MZextra, loc_11532-AniArt_MZextra
		dc.w loc_11548-AniArt_MZextra, loc_11556-AniArt_MZextra
		dc.w loc_1156C-AniArt_MZextra, loc_1157A-AniArt_MZextra
		dc.w loc_11590-AniArt_MZextra, loc_1159E-AniArt_MZextra
		dc.w loc_115B4-AniArt_MZextra, loc_115C6-AniArt_MZextra
; ---------------------------------------------------------------------------

loc_114BA:
		move.l	(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_114BA
		rts
; ---------------------------------------------------------------------------

loc_114C6:
		move.l	2(a1),d0
		move.b	1(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_114C6
		rts
; ---------------------------------------------------------------------------

loc_114DC:
		move.l	2(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_114DC
		rts
; ---------------------------------------------------------------------------

loc_114EA:
		move.l	4(a1),d0
		move.b	3(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_114EA
		rts
; ---------------------------------------------------------------------------

loc_11500:
		move.l	4(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11500
		rts
; ---------------------------------------------------------------------------

loc_1150E:
		move.l	6(a1),d0
		move.b	5(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_1150E
		rts
; ---------------------------------------------------------------------------

loc_11524:
		move.l	6(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11524
		rts
; ---------------------------------------------------------------------------

loc_11532:
		move.l	8(a1),d0
		move.b	7(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11532
		rts
; ---------------------------------------------------------------------------

loc_11548:
		move.l	8(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11548
		rts
; ---------------------------------------------------------------------------

loc_11556:
		move.l	$A(a1),d0
		move.b	9(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11556
		rts
; ---------------------------------------------------------------------------

loc_1156C:
		move.l	$A(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_1156C
		rts
; ---------------------------------------------------------------------------

loc_1157A:
		move.l	$C(a1),d0
		move.b	$B(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_1157A
		rts
; ---------------------------------------------------------------------------

loc_11590:
		move.l	$C(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11590
		rts
; ---------------------------------------------------------------------------

loc_1159E:
		move.l	$C(a1),d0
		rol.l	#8,d0
		_move.b	0(a1),d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_1159E
		rts
; ---------------------------------------------------------------------------

loc_115B4:
		move.w	$E(a1),(a6)
		_move.w	0(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_115B4
		rts
; ---------------------------------------------------------------------------

loc_115C6:
		_move.l	0(a1),d0
		move.b	$F(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_115C6
		rts