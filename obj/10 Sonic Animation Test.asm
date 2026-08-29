; ---------------------------------------------------------------------------
; Object 10 - Sonic animation test object
; (Referred to as "play02" in source code)
; ---------------------------------------------------------------------------

Obj10:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj10_Index(pc,d0.w),d1
		jmp	Obj10_Index(pc,d1.w)
; ===========================================================================
Obj10_Index:
		dc.w	Obj10_Init-Obj10_Index			; 0
		dc.w	Obj10_Main-Obj10_Index			; 2
		dc.w	Obj10_Delete-Obj10_Index		; 4 (unused)
		dc.w	Obj10_Delete-Obj10_Index		; 6 (unused)
; ===========================================================================

Obj10_Init:	; Routine 0
		addq.b	#2,obRoutine(a0)			; advance to Obj10_Main
		move.b	#sonic_height-1,obHeight(a0)		; The height defined here is 1 pixel shorter than what the Sonic object actually uses
		move.b	#sonic_width,obWidth(a0)		; set default width
		move.l	#Map_Sonic,obMap(a0)			; set mappings
		move.w	#ArtTile_Sonic,obGfx(a0)		; set VRAM location
		move.b	#sprite_cam_field,obRender(a0)		; set to playfield positioning mode
		move.b	#2,obPriority(a0)			; set sprite priority

Obj10_Main:	; Routine 2
		bsr.w	.playctrl
		bsr.w	Sonic_LoadGfx				; update Sonic's graphics if necessary
		jmp	(DisplaySprite).l
; ===========================================================================

.playctrl:
		move.b	(v_jpadhold2).w,d4
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#1,d1					; fixed speed value
		btst	#bitUp,d4				; is up pressed?
		beq.s	.notup					; if not, branch
		sub.w	d1,d2					; move up

.notup:
		btst	#bitDn,d4				; is down pressed?
		beq.s	.notdown				; if not, branch
		add.w	d1,d2					; move down

.notdown:
		btst	#bitL,d4				; is left pressed?
		beq.s	.notleft				; if not, branch
		sub.w	d1,d3					; move left

.notleft:
		btst	#bitR,d4				; is right pressed?
		beq.s	.notright				; if not, branch
		add.w	d1,d3					; move right

.notright:
		move.w	d2,obY(a0)
		move.w	d3,obX(a0)
		btst	#bitB,(v_jpadpress2).w			; is B pressed?
		beq.s	.notflip				; if not, branch
		move.b	obRender(a0),d0				; get Sonic's status bitfield
		move.b	d0,d1
		addq.b	#1,d0
		andi.b	#sprite_xflip|sprite_yflip,d0		; mask out everything but the X-flip and Y-flip flags
		andi.b	#~(sprite_xflip|sprite_yflip),d1	; clear X-flip and Y-flip flags in Sonic's render flags
		or.b	d1,d0
		move.b	d0,obRender(a0)				; set new X-flip flag state

.notflip:
		btst	#bitC,(v_jpadpress2).w			; is C pressed?
		beq.s	.notreset				; if not, branch
		addq.b	#1,obAnim(a0)				; increment animation ID
	if FixBugs
		cmpi.b	#id_Hurt,obAnim(a0)			; is animation ID the last one?
		ble.s	.notreset				; if lower than or equal, do not reset to the first animation ID
	else
		; Bug: This only does if lower than the last animation ID, when it would be better to do if lower than or equal to the last animation ID
		; This also does not account for the last animation ID, which is id_Hurt, so once it reaches the shrinking animation, it gets set back to the first animation
		cmpi.b	#id_Shrink,obAnim(a0)			; is animation ID the shrinking animation?
		blo.s	.notreset				; if lower than, do not reset to the first animation ID
	endif
		move.b	#id_Walk,obAnim(a0)			; set back to the first animation ID

.notreset:
		jsr	(Sonic_Animate).l			; run Sonic's animation scripts
		rts
; ===========================================================================

Obj10_Delete:	; Routine 4, 6 (unused)
		jmp	(DeleteObject).l