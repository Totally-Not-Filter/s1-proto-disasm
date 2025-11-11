; ---------------------------------------------------------------------------

Obj10:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj10_Table(pc,d0.w),d1
		jmp	Obj10_Table(pc,d1.w)
; ---------------------------------------------------------------------------

Obj10_Table:
		dc.w Obj10_Init-Obj10_Table
		dc.w Obj10_Main-Obj10_Table
		dc.w Obj10_Delete-Obj10_Table
		dc.w Obj10_Delete-Obj10_Table
; ---------------------------------------------------------------------------

Obj10_Init:
		addq.b	#2,obRoutine(a0)
		move.b	#$12,obHeight(a0)	; The height defined here is 1 pixel shorter than what the Sonic object actually uses.
		move.b	#9,obWidth(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#make_art_tile(ArtTile_Sonic,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#2,obPriority(a0)

Obj10_Main:
		bsr.w	.playerctrl
		bsr.w	Sonic_LoadGfx
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------

.playerctrl:
		move.b	(v_jpadhold2).w,d4
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#1,d1	; fixed speed value
		btst	#bitUp,d4	; is up pressed?
		beq.s	.notup	; if not, branch
		sub.w	d1,d2

.notup:
		btst	#bitDn,d4	; is down pressed?
		beq.s	.notdown	; if not, branch
		add.w	d1,d2

.notdown:
		btst	#bitL,d4	; is left pressed?
		beq.s	.notleft	; if not, branch
		sub.w	d1,d3

.notleft:
		btst	#bitR,d4	; is right pressed?
		beq.s	.notright	; if not, branch
		add.w	d1,d3

.notright:
		move.w	d2,obY(a0)
		move.w	d3,obX(a0)
		btst	#bitB,(v_jpadpress2).w	; is B pressed?
		beq.s	.notflip	; if not, branch
		move.b	obRender(a0),d0
		move.b	d0,d1
		addq.b	#1,d0
		andi.b	#3,d0
		andi.b	#$FC,d1
		or.b	d1,d0
		move.b	d0,obRender(a0)

.notflip:
		btst	#bitC,(v_jpadpress2).w	; is C pressed?
		beq.s	.notreset	; if not, branch
		addq.b	#1,obAnim(a0)	; increment animation ID
	if FixBugs
		cmpi.b	#id_Hurt,obAnim(a0)	; is animation ID the last one?
		ble.s	.notreset	; if lower than or equal, do not reset to the first animation ID
	else
		; Bug: This only does if lower than the last animation ID, when it would be better to do if lower than or equal to the last animation ID
		; This also does not account for the last animation ID, which is id_Hurt, so once it reaches the shrinking animation, it gets set back to the first animation
		cmpi.b	#id_Shrink,obAnim(a0)	; is animation ID the shrinking animation?
		blo.s	.notreset	; if lower than, do not reset to the first animation ID
	endif
		move.b	#id_Walk,obAnim(a0)	; set back to the first animation ID

.notreset:
		jsr	(Sonic_Animate).l
		rts
; ---------------------------------------------------------------------------

Obj10_Delete:
		jmp	(DeleteObject).l