; ---------------------------------------------------------------------------
; Object code execution subroutine
; ---------------------------------------------------------------------------

ExecuteObjects:
		lea	(v_objspace).w,a0 ; set address for object RAM
		moveq	#bytesToXcnt(v_objspace_end-v_objspace,object_size),d7
		moveq	#0,d0
		cmpi.b	#6,(v_player+obRoutine).w	; has sonic died?
		bhs.s	loc_8560			; if so, branch

loc_8546:
		move.b	obID(a0),d0		; load object number from RAM
		beq.s	loc_8556
		add.w	d0,d0
		add.w	d0,d0
		movea.l	Obj_Index-4(pc,d0.w),a1
		jsr	(a1)		; run the object's code
		moveq	#0,d0

loc_8556:
		lea	object_size(a0),a0	; next object
		dbf	d7,loc_8546
		rts
; ===========================================================================

loc_8560:
		moveq	#bytesToXcnt(v_lvlobjspace-v_objspace,object_size),d7
		bsr.s	loc_8546
		moveq	#bytesToXcnt(v_lvlobjend-v_lvlobjspace,object_size),d7

loc_8566:
		moveq	#0,d0
		move.b	obID(a0),d0
		beq.s	loc_8576
		tst.b	obRender(a0)
		bpl.s	loc_8576
		bsr.w	DisplaySprite

loc_8576:
		lea	object_size(a0),a0
		dbf	d7,loc_8566
		rts
; End of function ExecuteObjects