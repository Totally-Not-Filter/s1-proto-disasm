; ---------------------------------------------------------------------------

ObjMonitorItem:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_8242(pc,d0.w),d1
		jsr	off_8242(pc,d1.w)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

off_8242:	dc.w loc_8248-off_8242
		dc.w loc_8288-off_8242
		dc.w loc_83AA-off_8242
; ---------------------------------------------------------------------------

loc_8248:
		addq.b	#2,obRoutine(a0)
		move.w	#make_art_tile(ArtTile_Monitor,0,0),obGfx(a0)
		move.b	#$24,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.w	#-$300,obVelY(a0)
		moveq	#0,d0
		move.b	obAnim(a0),d0
		addq.b	#2,d0
		move.b	d0,obFrame(a0)
		movea.l	#Map_Monitor,a1
		add.b	d0,d0
		adda.w	(a1,d0.w),a1
		addq.w	#1,a1
		move.l	a1,obMap(a0)

loc_8288:
		tst.w	obVelY(a0)
		bpl.w	loc_829C
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_829C:
		addq.b	#2,obRoutine(a0)
		move.w	#29,obTimeFrame(a0)
		move.b	obAnim(a0),d0
		cmpi.b	#1,d0
		bne.s	loc_82B2
		rts
; ---------------------------------------------------------------------------

loc_82B2:
		cmpi.b	#2,d0
		bne.s	loc_82CA

loc_82B8:
		addq.b	#1,(v_lives).w
		addq.b	#1,(f_lifecount).w
		move.w	#bgm_ExtraLife,d0
		jmp	(QueueSound1).l
; ---------------------------------------------------------------------------

loc_82CA:
		cmpi.b	#3,d0
		bne.s	loc_82F8
		move.b	#1,(v_shoes).w
		move.w	#1200,(v_objspace+shoetime).w
		move.w	#$C00,(v_sonspeedmax).w
		move.w	#$18,(v_sonspeedacc).w
		move.w	#$80,(v_sonspeeddec).w
		move.w	#bgm_Speedup,d0
		jmp	(QueueSound1).l
; ---------------------------------------------------------------------------

loc_82F8:
		cmpi.b	#4,d0
		bne.s	loc_8314
		move.b	#1,(v_shield).w
		move.b	#id_ShieldItem,(v_objslot6).w
		move.w	#sfx_Shield,d0
		jmp	(QueueSound1).l
; ---------------------------------------------------------------------------

loc_8314:
		cmpi.b	#5,d0
		bne.s	loc_8360
		move.b	#1,(v_invinc).w
		move.w	#1200,(v_objspace+invtime).w
		move.b	#id_ShieldItem,(v_objslot8).w
		move.b	#1,(v_objslot8+obAnim).w
		move.b	#id_ShieldItem,(v_objslot9).w
		move.b	#2,(v_objslot9+obAnim).w
		move.b	#id_ShieldItem,(v_objslotA).w
		move.b	#3,(v_objslotA+obAnim).w
		move.b	#id_ShieldItem,(v_objslotB).w
		move.b	#4,(v_objslotB+obAnim).w
		move.w	#bgm_Invincible,d0
		jmp	(QueueSound1).l
; ---------------------------------------------------------------------------

loc_8360:
		cmpi.b	#6,d0
		bne.s	loc_83A0
		addi.w	#10,(v_rings).w
		ori.b	#1,(f_ringcount).w
		cmpi.w	#50,(v_rings).w
		bcs.s	loc_8396
		bset	#0,(v_lifecount).w
		beq.w	loc_82B8
		cmpi.w	#100,(v_rings).w
		bcs.s	loc_8396
		bset	#1,(v_lifecount).w
		beq.w	loc_82B8

loc_8396:
		move.w	#sfx_Ring,d0
		jmp	(QueueSound1).l
; ---------------------------------------------------------------------------

loc_83A0:
		cmpi.b	#7,d0
		bne.s	locret_83A8
		nop

locret_83A8:
		rts
; ---------------------------------------------------------------------------

loc_83AA:
		subq.w	#1,obTimeFrame(a0)
	if FixBugs
		bmi.s	.delete
		rts
.delete:
		addq.l	#4,sp	; do not return to caller
		bra.w	DeleteObject
	else
		bmi.w	DeleteObject
		rts
	endif