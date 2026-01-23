; ---------------------------------------------------------------------------

WaterSound:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	.act(pc,d0.w),d1
		jmp	.act(pc,d1.w)
; ---------------------------------------------------------------------------
.act:		dc.w ObjWaterfallSnd_Init-.act
		dc.w ObjWaterfallSnd_Act-.act
; ---------------------------------------------------------------------------

ObjWaterfallSnd_Init:
		addq.b	#2,obRoutine(a0)
		move.b	#4,obRender(a0)

ObjWaterfallSnd_Act:
		move.b	(v_vint_byte).w,d0
		andi.b	#$3F,d0
		bne.s	.nosound
		move.w	#sfx_Waterfall,d0
		jsr	(QueueSound2).l

.nosound:
		out_of_range.w	DeleteObject
		rts