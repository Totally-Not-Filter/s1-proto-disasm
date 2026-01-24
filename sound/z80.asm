		save
		!org	0	; set Z80 location to 0
		cpu z80	; use Z80 cpu
		listing purecode	; add to listing file

; function to decide whether an offset's full range won't fit in one byte
offsetover1byte function from,maxsize, ((from&0FFh)>(100h-maxsize))

; macro to make sure that ($ & 0FF00h) == (($+maxsize) & 0FF00h)
ensure1byteoffset macro maxsize
	if offsetover1byte($,maxsize)
startpad := $
		align 100h
		if MOMPASS=1
endpad := $
		if endpad-startpad>=1h
							; warn because otherwise you'd have no clue why you're running out of space so fast
			message "had to insert \{endpad-startpad}h   bytes of padding before improperly located data at 0\{startpad}h in Z80 code"
		endif
		endif
	endif
	endm

; =============== S U B R O U T I N E =======================================


StartOfZ80:
		di	; disable interrupts
		di
		di
		ld	sp,z80_stack
		xor	a
		ld	(zDAC_Status),a
		ld	a,(zBankStore+1)
		rlca
		ld	(zBankRegister),a
		ld	b,8
		ld	a,(zBankStore)

loc_16:
		ld	(zBankRegister),a
		rrca
		djnz	loc_16
		jr	loc_2E
; ===========================================================================
; JMan2050's DAC decode lookup table
; ===========================================================================
	ensure1byteoffset 10h
zDACDecodeTbl:
	db	   0,	 1,   2,   4,   8,  10h,  20h,  40h
	db	 80h,	-1,  -2,  -4,  -8, -10h, -20h, -40h
; ---------------------------------------------------------------------------

loc_2E:
		ld	hl,zDAC_Sample

loc_31:
		ld	a,(hl)
		or	a
		jp	p,loc_31
		push	af
		push	hl
		ld	a,80h
		ld	(zDAC_Status),a
		ld	hl,zYM2612_A0
		ld	(hl),2Bh
		inc	hl
		ld	(hl),80h
		xor	a
		ld	(zDAC_Status),a
		dec	hl
		ld	ix,zLoopDataStr
		ld	d,0
		exx
		pop	hl
		ld	(zDAC_Update),a
		pop	af
		ld	(zVoiceFlag),a
		sub	81h
		ld	(hl),a
		ld	de,0
		ld	iy,zPCM_Table
		cp	6	; Is the sample 87h or higher?
		jr	c,loc_73	; If not, branch
		ld	(zVoiceFlag),a
		ld	(zDAC_Update),a
		ld	iy,(zVoiceTblAdr)
		sub	7

loc_73:
		add	a,a	; Multiply by 12
		add	a,a
		ld	c,a
		add	a,a
		add	a,c
		ld	c,a
		ld	b,0
		add	iy,bc
		ld	e,(iy+0)
		ld	d,(iy+1)
		ld	a,(zVoiceFlag)
		or	a
		jp	m,loc_8F
		ld	hl,(zVoiceTblAdr)
		add	hl,de
		ex	de,hl

loc_8F:
		ld	c,(iy+2)
		ld	b,(iy+3)
		ld	a,(iy+4)
		ld	(zRepeatFlag),a
		exx
		ld	c,80h
		exx

zPlayPCMLoop:
		ld	hl,zDAC_Sample	; 10
		ld	a,(de)	; 7
		and	0F0h	; 7
		rrca	; 4
		rrca	; 4
		rrca	; 4
		rrca	; 4
		add	a,zDACDecodeTbl&0FFh	; 7
		exx	; 4
		ld	e,a	; 4
		ld	a,(de)	; 7
		add	a,c	; 4
		ld	c,a	; 4
		ld	a,80h	; 7
		ld	(zDAC_Status),a	; 13
		ld	b,(iy+0Bh)	; 19

loc_B8:
		bit	7,(hl)	; 12
		jr	nz,loc_B8	; 12
		ld	(hl),2Ah	; 10
		inc	hl	; 6
		xor	a	; 4
		ld	(hl),c	; 7
		ld	(zDAC_Status),a	; 13
		dec	hl	; 6

loc_C5:
		djnz	$	; 8
		exx	; 4
		ld	a,(de)	; 7
		and	0Fh	; 7
		add	a,zDACDecodeTbl&0FFh	; 7
		exx	; 4
		ld	e,a	; 4
		ld	a,(de)	; 7
		add	a,c	; 4
		ld	c,a	; 4
		ld	a,80h	; 7
		ld	(zDAC_Status),a	; 13
		ld	b,(iy+0Bh)	; 19

loc_DA:
		bit	7,(hl)	; 12
		jr	nz,loc_DA	; 12
		ld	(hl),2Ah	; 10
		inc	hl	; 6
		xor	a	; 4
		ld	(hl),c	; 7
		ld	(zDAC_Status),a	; 13
		dec	hl	; 6

loc_E7:
		djnz	$	; 8
		exx	; 4
		bit	7,(iy+5)	; 20
		jr	nz,loc_F5	; 12
		bit	7,(hl)	; 12
		jp	nz,loc_31	; 10

loc_F5:
		inc	de	; 6
		dec	bc	; 6
		ld	a,c	; 4
		or	b	; 4
		jp	nz,zPlayPCMLoop	; 10
							; 420 cycles in total
		ld	a,(zRepeatFlag)
		or	a
		jp	z,loc_153
		exx
		jp	p,loc_10C
		and	7Fh
		ld	(ix+0),c

loc_10C:
		dec	a
		ld	(zRepeatFlag),a
		jr	z,loc_133
		ld	c,(ix+0)
		exx
		ld	l,(iy+6)
		ld	h,(iy+7)
		ld	b,h
		ld	c,l
		ld	e,(iy+0)
		ld	d,(iy+1)
		ld	hl,(zVoiceTblAdr)
		add	hl,de
		ld	e,(iy+2)
		ld	d,(iy+3)
		add	hl,de
		ex	de,hl
		jp	zPlayPCMLoop
; ---------------------------------------------------------------------------

loc_133:
		ld	c,(ix+0)
		exx
		ld	c,(iy+8)
		ld	b,(iy+9)
		ld	l,(iy+2)
		ld	h,(iy+3)
		ld	e,(iy+0)
		ld	d,(iy+1)
		add	hl,de
		ld	de,(zVoiceTblAdr)
		add	hl,de
		ex	de,hl
		jp	zPlayPCMLoop
; ---------------------------------------------------------------------------

loc_153:
		ld	hl,zDAC_Update
		ld	a,(hl)
		or	a
		jp	m,loc_2E
		xor	a
		ld	(hl),a
		jp	loc_2E
; End of function StartOfZ80

; ---------------------------------------------------------------------------
zPCMMetadata macro label,sampleRate
	dw	label	; Start
	dw	label_End-label	; Length
	ds	7	; Padding
	db	dpcmLoopCounter(sampleRate)	; Pitch
	endm

; DPCM metadata
zPCM_Table:
	zPCMMetadata zDAC_Kick,7750
	zPCMMetadata zDAC_Snare,16500
zTimpani_Pitch = $+0Bh
	zPCMMetadata zDAC_Timpani,6500

; DPCM data
zDAC_Kick:
	binclude "dac/kick.dpcm"
zDAC_Kick_End:

zDAC_Snare:
	binclude "dac/snare.dpcm"
zDAC_Snare_End:

zDAC_Timpani:
	binclude "dac/timpani.dpcm"
zDAC_Timpani_End:

	if MOMPASS==2
		if $ > 2000h
			fatal "The driver is too big	; the maximum size it can take is 2000h. It currently takes \{$}h bytes. You won't be able to use this thing."
		else
			message "Driver size: \{$}h bytes."
		endif
	endif

		restore
		padding off
		!org (DACDriver+Size_of_DAC_driver_guess)