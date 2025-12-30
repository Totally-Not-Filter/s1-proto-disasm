; ---------------------------------------------------------------------------

ObjEntryRingBeta:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ObjEntryRingBeta_Index(pc,d0.w),d1
		jmp	ObjEntryRingBeta_Index(pc,d1.w)
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Index:dc.w ObjEntryRingBeta_Init-ObjEntryRingBeta_Index
		dc.w ObjEntryRingBeta_RmvSonic-ObjEntryRingBeta_Index
		dc.w ObjEntryRingBeta_LoadSonic-ObjEntryRingBeta_Index
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Init:
		tst.l	(v_plc_buffer).w
		beq.s	ObjEntryRingBeta_Init2
		rts
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Init2:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Vanish,obMap(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obPriority(a0)
		move.b	#$38,obActWid(a0)
		move.w	#make_art_tile(ArtTile_Warp,0,0),obGfx(a0)
		move.w	#120,objoff_30(a0)

ObjEntryRingBeta_RmvSonic:
		move.w	(v_player+obX).w,obX(a0)
		move.w	(v_player+obY).w,obY(a0)
		move.b	(v_player+obStatus).w,obStatus(a0)
		lea	(Ani_Vanish).l,a1
		jsr	(AnimateSprite).l
		cmpi.b	#2,obFrame(a0)
		bne.s	ObjEntryRingBeta_Display
		tst.b	(v_objspace).w
		beq.s	ObjEntryRingBeta_Display
		move.b	#0,(v_player).w
		move.w	#sfx_SSGoal,d0
		jsr	(QueueSound2).l

ObjEntryRingBeta_Display:
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

ObjEntryRingBeta_LoadSonic:
		subq.w	#1,objoff_30(a0)
		bne.s	ObjEntryRingBeta_Wait
		move.b	#id_SonicPlayer,(v_player).w
		bra.w	DeleteObject
; ---------------------------------------------------------------------------

ObjEntryRingBeta_Wait:
		rts