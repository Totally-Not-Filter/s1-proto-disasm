LoadLevelBounds:
		moveq	#0,d0
		move.b	d0,(f_rst_hscroll).w
		move.b	d0,(f_rst_vscroll).w
		move.b	d0,(unk_FFF746).w
		move.b	d0,(unk_FFF748).w
		move.b	d0,(v_dle_routine).w
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	LevelBoundArray(pc,d0.w),a0
		move.w	(a0)+,d0
		move.w	d0,(unk_FFF730).w
		move.l	(a0)+,d0
		move.l	d0,(v_limitleft2).w
		move.l	d0,(v_limitleft1).w
		cmp.w	(v_limitleft2).w,d0
		bne.s	loc_3AF2
		move.b	#1,(f_rst_hscroll).w

loc_3AF2:
		move.l	(a0)+,d0
		move.l	d0,(v_limittop2).w
		move.l	d0,(v_limittop1).w
		cmp.w	(v_limittop2).w,d0
		bne.s	loc_3B08
		move.b	#1,(f_rst_vscroll).w

loc_3B08:
		move.w	(v_limitleft2).w,d0
		addi.w	#$240,d0
		move.w	d0,(v_limitleft3).w
		move.w	(a0)+,d0
		move.w	d0,(v_lookshift).w
		bra.w	loc_3C6E
; ---------------------------------------------------------------------------

LevelBoundArray:
		dc.w $0004, $0000, $24BF, $0000, $0300, $0060
		dc.w $0004, $0000, $1EBF, $0000, $0300, $0060
		dc.w $0004, $0000, $2960, $0000, $0300, $0060
		dc.w $0004, $0000, $2ABF, $0000, $0300, $0060

		dc.w $0004, $0000, $17BF, $0000, $0720, $0060
		dc.w $0004, $0000, $0EBF, $0000, $0720, $0060
		dc.w $0004, $0000, $1EBF, $0000, $0720, $0060
		dc.w $0004, $0000, $1EBF, $0000, $0720, $0060

		dc.w $0004, $0000, $17BF, $0000, $01D0, $0060
		dc.w $0004, $0000, $1BBF, $0000, $0520, $0060
		dc.w $0004, $0000, $163F, $0000, $0720, $0060
		dc.w $0004, $0000, $16BF, $0000, $0720, $0060

		dc.w $0004, $0000, $1EBF, $0000, $0640, $0060
		dc.w $0004, $0000, $20BF, $0000, $0640, $0060
		dc.w $0004, $0000, $1EBF, $0000, $06C0, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060

		dc.w $0004, $0000, $22C0, $0000, $0420, $0060
		dc.w $0004, $0000, $28C0, $0000, $0520, $0060
		dc.w $0004, $0000, $2EC0, $0000, $0620, $0060
		dc.w $0004, $0000, $29C0, $0000, $0620, $0060

		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060

		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060
; ---------------------------------------------------------------------------

loc_3C6E:
		move.w	(v_zone).w,d0
		cmpi.b	#3,d0
		bne.s	loc_3C7C
		subq.b	#1,(v_act).w

loc_3C7C:
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	StartPosArray(pc,d0.w),a1
		moveq	#0,d1
		move.w	(a1)+,d1
		move.w	d1,(v_player+obX).w
		subi.w	#$A0,d1
		bcc.s	loc_3C94
		moveq	#0,d1

loc_3C94:
		move.w	d1,(v_scrposx).w
		moveq	#0,d0
		move.w	(a1),d0
		move.w	d0,(v_player+obY).w
		subi.w	#$60,d0
		bcc.s	loc_3CA8
		moveq	#0,d0

loc_3CA8:
		cmp.w	(v_limitbtm2).w,d0
		blt.s	loc_3CB2
		move.w	(v_limitbtm2).w,d0

loc_3CB2:
		move.w	d0,(v_scrposy).w
		bsr.w	InitLevelBG
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.b	#2,d0
		move.l	SpecialChunkArray(pc,d0.w),(v_256loop1).w
		bra.w	LoadLevelUnk
; ---------------------------------------------------------------------------
StartPosArray:	include "Start Location Array - Levels.asm"

SpecialChunkArray:
		dc.b $B5, $7F, $1F, $20
		dc.b $7F, $7F, $7F, $7F
		dc.b $7F, $7F, $7F, $7F
		dc.b $B5, $A8, $7F, $7F
		dc.b $7F, $7F, $7F, $7F
		dc.b $7F, $7F, $7F, $7F
		even
; ---------------------------------------------------------------------------

LoadLevelUnk:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#3,d0
		lea	dword_3D6A(pc,d0.w),a1
		lea	(v_scroll_block_size).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		rts
; ---------------------------------------------------------------------------

dword_3D6A:	dc.l $700100, $1000100
		dc.l $8000100, $1000000
		dc.l $8000100, $1000000
		dc.l $8000100, $1000000
		dc.l $8000100, $1000000
		dc.l $8000100, $1000000
		even
; ---------------------------------------------------------------------------

InitLevelBG:
		move.w	d0,(v_bgscrposy).w
		move.w	d0,(v_bg2scrposy).w
		swap	d1
		move.l	d1,(v_bgscrposx).w
		move.l	d1,(v_bg2scrposx).w
		move.l	d1,(v_bg3scrposx).w
		moveq	#0,d2
		move.b	(v_zone).w,d2
		add.w	d2,d2
		move.w	off_3DC0(pc,d2.w),d2
		jmp	off_3DC0(pc,d2.w)
; ---------------------------------------------------------------------------

off_3DC0:	dc.w InitBGHZ-off_3DC0, initLevelLZ-off_3DC0, initLevelMZ-off_3DC0, initLevelSLZ-off_3DC0
		dc.w initLevelSZ-off_3DC0, initLevelCWZ-off_3DC0
; ---------------------------------------------------------------------------

InitBGHZ:
		bra.w	Deform_GHZ
; ---------------------------------------------------------------------------

initLevelLZ:
		rts
; ---------------------------------------------------------------------------

initLevelMZ:
		rts
; ---------------------------------------------------------------------------

initLevelSLZ:
		asr.l	#1,d0
		addi.w	#$C0,d0
		move.w	d0,(v_bgscrposy).w
		rts
; ---------------------------------------------------------------------------

initLevelSZ:
		asl.l	#4,d0
		move.l	d0,d2
		asl.l	#1,d0
		add.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(v_bgscrposy).w
		move.w	d0,(v_bg2scrposy).w
		rts
; ---------------------------------------------------------------------------

initLevelCWZ:
		rts