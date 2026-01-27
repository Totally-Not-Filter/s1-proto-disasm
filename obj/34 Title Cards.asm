; ---------------------------------------------------------------------------
; Object 34 - zone title cards
; ---------------------------------------------------------------------------

TitleCard:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Card_Index(pc,d0.w),d1
		jmp	Card_Index(pc,d1.w)
; ===========================================================================
Card_Index:	dc.w Card_LoadConfig-Card_Index
		dc.w Card_ChkPos-Card_Index
		dc.w Card_Wait-Card_Index
		dc.w Card_Wait-Card_Index
; ===========================================================================

Card_LoadConfig:	; Routine 0
		movea.l	a0,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(Card_ConData).l,a3
		lsl.w	#4,d0
		adda.w	d0,a3
		lea	(Card_ItemData).l,a2
		moveq	#3,d1

Card_Loop:
		_move.b	#id_TitleCard,obID(a1)
		move.w	(a3),obX(a1)	; load start x-position
		move.w	(a3)+,card_finalX(a1) ; load finish x-position (same as start)
		move.w	(a3)+,card_mainX(a1) ; load main x-position
		move.w	(a2)+,obScreenY(a1)
		move.b	(a2)+,obRoutine(a1)
		move.b	(a2)+,d0
		bne.s	Card_ActNumber
		move.b	(v_zone).w,d0

Card_ActNumber:
		cmpi.b	#7,d0
		bne.s	Card_MakeSprite
		add.b	(v_act).w,d0

Card_MakeSprite:
		move.b	d0,obFrame(a1)	; display frame number d0
		move.l	#Map_TitleCard,obMap(a1)
		move.w	#make_art_tile(ArtTile_Title_Card,0,1),obGfx(a1)
		move.b	#$78,obActWid(a1)
		move.b	#0,obRender(a1)
		move.b	#0,obPriority(a1)
		move.w	#60,obTimeFrame(a1) ; set time delay to 1 second
		lea	object_size(a1),a1	; next object
		dbf	d1,Card_Loop	; repeat sequence another 3 times

Card_ChkPos:	; Routine 2
		moveq	#$10,d1		; set horizontal speed
		move.w	card_mainX(a0),d0
		cmp.w	obX(a0),d0	; has item reached the target position?
		beq.s	Card_NoMove	; if yes, branch
		bge.s	Card_Move
		neg.w	d1

Card_Move:
		add.w	d1,obX(a0)	; change item's position

Card_NoMove:
		move.w	obX(a0),d0
		bmi.s	locret_A57A
		cmpi.w	#$200,d0	; has item moved beyond $200 on x-axis?
		bhs.s	locret_A57A	; if yes, branch
		bra.w	DisplaySprite
; ===========================================================================

locret_A57A:
		rts
; ===========================================================================

Card_Wait:	; Routine 4/6
		tst.w	obTimeFrame(a0)	; is time remaining zero?
		beq.s	Card_ChkPos2	; if yes, branch
		subq.w	#1,obTimeFrame(a0) ; subtract 1 from time
		bra.w	DisplaySprite
; ===========================================================================

Card_ChkPos2:
		moveq	#$20,d1
		move.w	card_finalX(a0),d0
		cmp.w	obX(a0),d0	; has item reached the finish position?
		beq.s	Card_ChangeArt	; if yes, branch
		bge.s	Card_Move2
		neg.w	d1

Card_Move2:
		add.w	d1,obX(a0)	; change item's position
		move.w	obX(a0),d0
		bmi.s	locret_A5AE
		cmpi.w	#$200,d0	; has item moved beyond $200 on x-axis?
		bhs.s	locret_A5AE	; if yes, branch
		bra.w	DisplaySprite
; ===========================================================================

locret_A5AE:
		rts
; ===========================================================================

Card_ChangeArt:
		cmpi.b	#4,obRoutine(a0)
		bne.s	Card_Delete
		moveq	#plcid_Explode,d0
		jsr	(AddPLC).l	; load explosion patterns
		moveq	#0,d0
		move.b	(v_zone).w,d0
		addi.w	#plcid_GHZAnimals,d0
		jsr	(AddPLC).l	; load animal patterns

Card_Delete:
		bra.w	DeleteObject
; ===========================================================================
Card_ItemData:	dc.w $D0	; y-axis position
		dc.b 2, 0	; routine number, frame number (changes)
		dc.w $E4
		dc.b 2, 6
		dc.w $EA
		dc.b 2, 7
		dc.w $E0
		dc.b 2, $A
; ---------------------------------------------------------------------------
; Title card configuration data
; Format:
; 4 bytes per item (YYYY XXXX)
; 4 items per level (GREEN HILL, ZONE, ACT X, oval)
; ---------------------------------------------------------------------------
Card_ConData:	dc.w 0, $120, $FEFC, $13C, $414, $154, $214, $154 ; GHZ
		dc.w 0, $120, $FEF4, $134, $40C, $14C, $20C, $14C ; LZ
		dc.w 0, $120, $FEE0, $120, $3F8, $138, $1F8, $138 ; MZ
		dc.w 0, $120, $FEFC, $13C, $414, $154, $214, $154 ; SLZ
		dc.w 0, $120, $FEF4, $134, $40C, $14C, $20C, $14C ; SZ
		dc.w 0, $120, $FF00, $140, $418, $158, $218, $158 ; CWZ
; ===========================================================================