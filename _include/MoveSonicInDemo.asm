; ---------------------------------------------------------------------------
; Subroutine to move Sonic in demo mode
; ---------------------------------------------------------------------------

MoveSonicInDemo:
		tst.w	(f_demo).w	; is demo mode on?
		bne.s	MDemo_On	; if yes, branch
		rts
; ===========================================================================

; This is an unused subroutine for recording a demo

DemoRecorder:
		; This was likely intended for a deveveloper cartridge that used RAM instead of ROM.
		lea	(EndOfROM).l,a1 ; Write past the end of the ROM.
		move.w	(v_btnpushtime1).w,d0
		adda.w	d0,a1
		move.b	(v_jpadhold1).w,d0
		cmp.b	(a1),d0
		bne.s	.next
		addq.b	#1,1(a1)
		cmpi.b	#$FF,1(a1)
		beq.s	.next
		rts

.next:
		move.b	d0,2(a1)
		move.b	#0,3(a1)
		addq.w	#2,(v_btnpushtime1).w
		andi.w	#$3FF,(v_btnpushtime1).w
		rts
; ===========================================================================

MDemo_On:
		tst.b	(v_jpadhold1).w	; is start button pressed?
		bpl.s	.dontquit	; if not, branch
		move.b	#id_Title,(v_gamemode).w ; go to title screen

.dontquit:
		lea	(DemoDataPtr).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1	; fetch address for demo data
		move.w	(v_btnpushtime1).w,d0
		adda.w	d0,a1
		move.b	(a1),d0
		lea	(v_jpadhold1).w,a0
		move.b	d0,d1

	if FixBugs
		; Fix demo playback
		; https://info.sonicretro.org/SCHG_How-to:Fix_demo_playback
		move.b	v_jpadhold2-v_jpadhold1(a0),d2
	else
		move.b	(a0),d2
	endif

		eor.b	d2,d0
		move.b	d1,(a0)+
		and.b	d1,d0
		move.b	d0,(a0)+
		subq.b	#1,(v_btnpushtime2).w
		bhs.s	.end
		move.b	3(a1),(v_btnpushtime2).w
		addq.w	#2,(v_btnpushtime1).w

.end:
		rts
; End of function MoveSonicInDemo

; ===========================================================================
; ---------------------------------------------------------------------------
; Demo sequence pointers
; ---------------------------------------------------------------------------
DemoDataPtr:	dc.l Demo_MZ		; demos run after the title screen
		dc.l Demo_MZ
		dc.l Demo_MZ
		dc.l Demo_GHZ
		dc.l Demo_SZ
		dc.l Demo_SZ
		dc.l Demo_SS

; Stray demo data is present here. It involves Sonic slowly running
; right, jumping once, then running at full speed for a few seconds.
; Interestingly, this lines up with our knowledge of the fabled
; Tokyo Game Show prototype.
; See it in action: https://youtu.be/S8_IAfQbUu0
Demo_Unused:	include	"demodata/Unused Demo.asm"