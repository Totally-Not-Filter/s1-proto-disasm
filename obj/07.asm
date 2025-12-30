; ---------------------------------------------------------------------------

Obj07:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj07_Index(pc,d0.w),d1
		jmp	Obj07_Index(pc,d1.w)
; ---------------------------------------------------------------------------

Obj07_Index:
		dc.w Obj07_Init-Obj07_Index
		dc.w Obj07_Main-Obj07_Index
		dc.w Obj07_Delete-Obj07_Index
		dc.w Obj07_Delete-Obj07_Index
; ---------------------------------------------------------------------------

Obj07_Init:
		addq.b	#2,obRoutine(a0)	; this increments the routine value by 1, but does nothing

Obj07_Main:
		rts
; ---------------------------------------------------------------------------

Obj07_Delete:
		bsr.w	DeleteObject
		rts