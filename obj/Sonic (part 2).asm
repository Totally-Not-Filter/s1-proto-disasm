; ---------------------------------------------------------------------------

Sonic_Hurt:
		bsr.w	Sonic_HurtStop
		bsr.w	SpeedToPos
		addi.w	#$30,obVelY(a0)
		bsr.w	Sonic_LevelBound
		bsr.w	sub_E952
		bsr.w	Sonic_Animate
		bsr.w	Sonic_LoadGfx
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

Sonic_HurtStop:
		move.w	(v_limitbtm2).w,d0
		addi.w	#224,d0
		cmp.w	obY(a0),d0
		bcs.w	loc_FD78
		bsr.w	loc_F07C
		btst	#1,obStatus(a0)
		bne.s	locret_F318
		moveq	#0,d0
		move.w	d0,obVelY(a0)
		move.w	d0,obVelX(a0)
		move.w	d0,obInertia(a0)
		move.b	#id_Walk,obAnim(a0)
		subq.b	#2,obRoutine(a0)
		move.w	#120,flashtime(a0)		; set sonic to be invulnerable for 2 seconds

locret_F318:
		rts
; ---------------------------------------------------------------------------

Sonic_Death:
		bsr.w	Sonic_GameOver
		bsr.w	ObjectFall
		bsr.w	sub_E952
		bsr.w	Sonic_Animate
		bsr.w	Sonic_LoadGfx
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

Sonic_GameOver:
		move.w	(v_limitbtm2).w,d0
		addi.w	#256,d0
		cmp.w	obY(a0),d0
		bcc.w	locret_F3AE
		move.w	#-$38,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		addq.b	#1,(f_lifecount).w
		subq.b	#1,(v_lives).w
		bne.s	loc_F380
		move.w	#0,objoff_3A(a0)
		move.b	#id_GameOverCard,(v_objslot2).w
		move.b	#id_GameOverCard,(v_objslot3).w
		move.b	#1,(v_objslot3+obFrame).w
		move.w	#bgm_GameOver,d0
		jsr	(PlaySound_Special).l
		moveq	#plcid_GameOver,d0
		jmp	(AddPLC).l
; ---------------------------------------------------------------------------

loc_F380:
		move.w	#60,objoff_3A(a0)
		rts
; ---------------------------------------------------------------------------

;loc_F388:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		beq.s	locret_F3AE
		andi.b	#btnA,d0
		bne.s	loc_F3B0
		move.b	#id_Walk,obAnim(a0)		; Respawns you after a death
		subq.b	#4,obRoutine(a0)		; The lines above seem to make the code do nothing
		move.w	objoff_38(a0),obY(a0)
		move.w	#120,flashtime(a0)		; set sonic to be invulnerable for 2 seconds

locret_F3AE:
		rts
; ---------------------------------------------------------------------------

loc_F3B0:
		move.w	#1,(f_restart).w
		rts
; ---------------------------------------------------------------------------

Sonic_ResetLevel:
		tst.w	objoff_3A(a0)
		beq.s	locret_F3CA
		subq.w	#1,objoff_3A(a0)
		bne.s	locret_F3CA
		move.w	#1,(f_restart).w

locret_F3CA:
		rts