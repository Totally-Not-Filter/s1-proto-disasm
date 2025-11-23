; ---------------------------------------------------------------------------
; Modified SMPS 68k Type 1b sound driver
; ---------------------------------------------------------------------------
; Constants
SMPS_TRACK_COUNT = (SMPS_RAM.v_track_ram_end-SMPS_RAM.v_track_ram)/SMPS_Track.len
SMPS_MUSIC_TRACK_COUNT = (SMPS_RAM.v_music_track_ram_end-SMPS_RAM.v_music_track_ram)/SMPS_Track.len
SMPS_MUSIC_FM_DAC_TRACK_COUNT = (SMPS_RAM.v_music_fmdac_tracks_end-SMPS_RAM.v_music_fmdac_tracks)/SMPS_Track.len
SMPS_MUSIC_FM_TRACK_COUNT = (SMPS_RAM.v_music_fm_tracks_end-SMPS_RAM.v_music_fm_tracks)/SMPS_Track.len
SMPS_MUSIC_PSG_TRACK_COUNT = (SMPS_RAM.v_music_psg_tracks_end-SMPS_RAM.v_music_psg_tracks)/SMPS_Track.len
SMPS_SFX_TRACK_COUNT = (SMPS_RAM.v_sfx_track_ram_end-SMPS_RAM.v_sfx_track_ram)/SMPS_Track.len
SMPS_SFX_FM_TRACK_COUNT = (SMPS_RAM.v_sfx_fm_tracks_end-SMPS_RAM.v_sfx_fm_tracks)/SMPS_Track.len
SMPS_SFX_PSG_TRACK_COUNT = (SMPS_RAM.v_sfx_psg_tracks_end-SMPS_RAM.v_sfx_psg_tracks)/SMPS_Track.len
SMPS_SPECIAL_SFX_TRACK_COUNT = (SMPS_RAM.v_spcsfx_track_ram_end-SMPS_RAM.v_spcsfx_track_ram)/SMPS_Track.len
SMPS_SPECIAL_SFX_FM_TRACK_COUNT = (SMPS_RAM.v_spcsfx_fm_tracks_end-SMPS_RAM.v_spcsfx_fm_tracks)/SMPS_Track.len
; ---------------------------------------------------------------------------
; Go_SoundTypes:
Go_SoundPriorities:	dc.l SoundPriorities
; Go_SoundD0:
Go_SpecSoundIndex:	dc.l SpecSoundIndex
Go_MusicIndex:		dc.l MusicIndex
Go_SoundIndex:		dc.l SoundIndex
Go_Modulation:		dc.l ModulationIndex
Go_PSGIndex:		dc.l PSG_Index
		dc.l $A0
		dc.l UpdateMusic
Go_SpeedUpIndex:	dc.l SpeedUpIndex

; ---------------------------------------------------------------------------
; PSG instruments used in music
; ---------------------------------------------------------------------------
PSG_Index:
		dc.l PSG1, PSG2, PSG3
		dc.l PSG4, PSG6, PSG5
		dc.l PSG7, PSG8, PSG9
PSG1:	binclude "sound/psg/psg1.bin"
PSG2:	binclude "sound/psg/psg2.bin"
PSG3:	binclude "sound/psg/psg3.bin"
PSG4:	binclude "sound/psg/psg4.bin"
PSG5:	binclude "sound/psg/psg5.bin"
PSG6:	binclude "sound/psg/psg6.bin"
PSG7:	binclude "sound/psg/psg7.bin"
PSG8:	binclude "sound/psg/psg8.bin"
PSG9:	binclude "sound/psg/psg9.bin"

ModulationIndex:
		dc.b $D, 1, 7, 4	; 1
		dc.b 1, 1, 1, 4	; 2
		dc.b 2, 1, 2, 4	; 3
		dc.b 8, 1, 6, 4	; 4
; ---------------------------------------------------------------------------
; New tempos for songs during speed shoes
; ---------------------------------------------------------------------------
SpeedUpIndex:
		dc.b 7		; GHZ
		dc.b $72	; LZ
		dc.b $73	; MZ
		dc.b $26	; SLZ
		dc.b $15	; SYZ
		dc.b 8		; SBZ
		dc.b $FF	; Invincibility
		dc.b 5		; Extra Life
		even
		; All songs after will use their music index pointer instead

; ---------------------------------------------------------------------------
; Music	Pointers
; ---------------------------------------------------------------------------
MusicIndex:
ptr_mus81:	dc.l Music81
ptr_mus82:	dc.l Music82
ptr_mus83:	dc.l Music83
ptr_mus84:	dc.l Music84
ptr_mus85:	dc.l Music85
ptr_mus86:	dc.l Music86
ptr_mus87:	dc.l Music87
ptr_mus88:	dc.l Music88
ptr_mus89:	dc.l Music89
ptr_mus8A:	dc.l Music8A
ptr_mus8B:	dc.l Music8B
ptr_mus8C:	dc.l Music8C
ptr_mus8D:	dc.l Music8D
ptr_mus8E:	dc.l Music8E
ptr_mus8F:	dc.l Music8F
ptr_mus90:	dc.l Music90
ptr_mus91:	dc.l Music91	; Note the lack of a pointer for music $92
ptr_musend:
; ---------------------------------------------------------------------------
; Priority of sound. New music or SFX must have a priority higher than or equal
; to what is stored in v_sndprio or it won't play. If bit 7 of new priority is
; set ($80 and up), the new music or SFX will not set its priority -- meaning
; any music or SFX can override it (as long as it can override whatever was
; playing before). Usually, SFX will only override SFX, special SFX ($D0-$DF)
; will only override special SFX and music will only override music.
; ---------------------------------------------------------------------------
; SoundTypes:
SoundPriorities:
		dc.b $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80 ; $81
		dc.b $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$70 ; $90
		dc.b $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70 ; $A0
		dc.b $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70 ; $B0
		dc.b $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$80 ; $C0
		dc.b $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80 ; $D0
		dc.b $80,$80,$80,$80,$80		; $E0
		even
; ---------------------------------------------------------------------------
; Updates SMPS
; ---------------------------------------------------------------------------
UpdateMusic:
		stopZ80
		waitZ80
		btst	#7,(z80_dac_status).l
		beq.s	.driverinput
		startZ80
		nop
		nop
		nop
		nop
		nop
		bra.s	UpdateMusic
; ---------------------------------------------------------------------------

.driverinput:
		lea	(v_snddriver_ram&$FFFFFF).l,a6
		clr.b	SMPS_RAM.f_voice_selector(a6)
		tst.b	SMPS_RAM.f_pausemusic(a6)
		bne.w	PauseMusic
		subq.b	#1,SMPS_RAM.v_main_tempo_timeout(a6)
		bne.s	.skipdelay
		jsr	TempoWait(pc)

.skipdelay:
		move.b	SMPS_RAM.v_fadeout_counter(a6),d0
		beq.s	.skipfadeout
		jsr	DoFadeOut(pc)

.skipfadeout:
		tst.b	SMPS_RAM.f_fadein_flag(a6)
		beq.s	.nofadein
		jsr	DoFadeIn(pc)

.nofadein:
		tst.w	SMPS_RAM.v_soundqueue0(a6)
		beq.s	.noqueue
		jsr	CycleSoundQueue(pc)

.noqueue:
		lea	SMPS_RAM.v_music_dac_track(a6),a5
		tst.b	SMPS_Track.PlaybackControl(a5)
		bpl.s	.nodac
		jsr	DACUpdateTrack(pc)

.nodac:
		clr.b	SMPS_RAM.f_updating_dac(a6)
		moveq	#SMPS_MUSIC_FM_TRACK_COUNT-1,d7 ; 6 FM tracks

.loopfm1:
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)
		bpl.s	.nofm1
		jsr	FMUpdateTrack(pc)

.nofm1:
		dbf	d7,.loopfm1
		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d7 ; 3 PSG tracks

.looppsg1:
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)
		bpl.s	.nopsg1
		jsr	PSGUpdateTrack(pc)

.nopsg1:
		dbf	d7,.looppsg1
		move.b	#$80,SMPS_RAM.f_voice_selector(a6)
		moveq	#SMPS_SFX_FM_TRACK_COUNT-1,d7 ; 3 FM tracks (SFX)

.loopfm2:
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)
		bpl.s	.nofm2
		jsr	FMUpdateTrack(pc)

.nofm2:
		dbf	d7,.loopfm2
		moveq	#SMPS_SFX_PSG_TRACK_COUNT-1,d7 ; 3 PSG tracks (SFX)

.looppsg2:
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)
		bpl.s	.nopsg2
		jsr	PSGUpdateTrack(pc)

.nopsg2:
		dbf	d7,.looppsg2
		move.b	#$40,SMPS_RAM.f_voice_selector(a6)
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)
		bpl.s	.nofm3
		jsr	FMUpdateTrack(pc)

.nofm3:
		adda.w	#SMPS_Track.len,a5
		tst.b	SMPS_Track.PlaybackControl(a5)
		bpl.s	DoStartZ80
		jsr	PSGUpdateTrack(pc)

DoStartZ80:
		startZ80
		rts
; ---------------------------------------------------------------------------

DACUpdateTrack:
		subq.b	#1,SMPS_Track.DurationTimeout(a5)
		bne.s	.nodelay
		move.b	#$80,SMPS_RAM.f_updating_dac(a6)
		movea.l	SMPS_Track.DataPointer(a5),a4

.command:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	.notcommand
		jsr	CoordFlag(pc)
		bra.s	.command
; ---------------------------------------------------------------------------

.notcommand:
		tst.b	d5
		bpl.s	.duration
		move.b	d5,SMPS_Track.SavedDAC(a5)
		move.b	(a4)+,d5
		bpl.s	.duration
		subq.w	#1,a4
		move.b	SMPS_Track.SavedDuration(a5),SMPS_Track.DurationTimeout(a5)
		bra.s	.checknote
; ---------------------------------------------------------------------------

.duration:
		jsr	SetDuration(pc)

.checknote:
		move.l	a4,SMPS_Track.DataPointer(a5)
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.s	.nodelay
		moveq	#0,d0
		move.b	SMPS_Track.SavedDAC(a5),d0
		cmpi.b	#$80,d0
		beq.s	.nodelay
		btst	#3,d0
		bne.s	.timpani
		tst.b	(z80_dac_update).l	; is the dac update flag set?
		bne.s	.nodelay	; if not, branch
		move.b	d0,(z80_dac_sample).l

.nodelay:
		rts
; ---------------------------------------------------------------------------

.timpani:
		subi.b	#$88,d0
		move.b	.timpanipitch(pc,d0.w),d0
		tst.b	(z80_dac_update).l	; is the dac update flag set?
		bne.s	.noupdate		; if not, branch
		move.b	d0,(z80_dac3_pitch).l
		move.b	#$83,(z80_dac_sample).l	; use timpani sample

.noupdate:
		rts
; ---------------------------------------------------------------------------
.timpanipitch:	dc.b dpcmLoopCounter(8250)
		dc.b dpcmLoopCounter(7600)
		dc.b dpcmLoopCounter(6400)
		dc.b dpcmLoopCounter(6250)
		; the values below are invalid and will play at a very slow rate
		dc.b $FF, $FF, $FF, $FF
; ---------------------------------------------------------------------------

FMUpdateTrack:
		subq.b	#1,SMPS_Track.DurationTimeout(a5)
		bne.s	.notegoing
		bclr	#4,SMPS_Track.PlaybackControl(a5)
		jsr	FMDoNext(pc)
		jsr	FMPrepareNote(pc)
		jsr	FMPan_Set(pc)
		bra.w	FMNoteOn
; ---------------------------------------------------------------------------

.notegoing:
		jsr	NoteTimeoutUpdate(pc)
		jsr	DoModulation(pc)
		bra.w	FMUpdateFreq
; ---------------------------------------------------------------------------

FMDoNext:
		movea.l	SMPS_Track.DataPointer(a5),a4
		bclr	#1,SMPS_Track.PlaybackControl(a5)

.command:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	.notcommand
		jsr	CoordFlag(pc)
		bra.s	.command
; ---------------------------------------------------------------------------

.notcommand:
		jsr	FMNoteOff(pc)
		tst.b	d5
		bpl.s	.duration
		jsr	FMSetFreq(pc)
		move.b	(a4)+,d5
		bpl.s	.duration
		subq.w	#1,a4
		bra.w	FinishTrackUpdate
; ---------------------------------------------------------------------------

.duration:
		jsr	SetDuration(pc)
		bra.w	FinishTrackUpdate
; ---------------------------------------------------------------------------

FMSetFreq:
		subi.b	#$80,d5
		beq.s	TrackSetRest
		add.b	SMPS_Track.Transpose(a5),d5
		andi.w	#$7F,d5
		lsl.w	#1,d5
		lea	FMFrequencies(pc),a0
		move.w	(a0,d5.w),d6
		move.w	d6,SMPS_Track.Freq(a5)
		rts
; ---------------------------------------------------------------------------

SetDuration:
		move.b	d5,d0
		move.b	SMPS_Track.TempoDivider(a5),d1

.loop:
		subq.b	#1,d1
		beq.s	.save
		add.b	d5,d0
		bra.s	.loop
; ---------------------------------------------------------------------------

.save:
		move.b	d0,SMPS_Track.SavedDuration(a5)	; Save duration
		move.b	d0,SMPS_Track.DurationTimeout(a5)	; Save duration timeout
		rts
; ---------------------------------------------------------------------------

TrackSetRest:
		bset	#1,SMPS_Track.PlaybackControl(a5)
		clr.w	SMPS_Track.Freq(a5)

FinishTrackUpdate:
		move.l	a4,SMPS_Track.DataPointer(a5)	; Store new track position
		move.b	SMPS_Track.SavedDuration(a5),SMPS_Track.DurationTimeout(a5) ; Reset note timeout
		btst	#4,SMPS_Track.PlaybackControl(a5)	; Is track set to not attack note?
		bne.s	.locret				; If so, branch
		move.b	SMPS_Track.NoteTimeoutMaster(a5),SMPS_Track.NoteTimeout(a5) ; Reset note fill timeout
		clr.b	SMPS_Track.VolEnvIndex(a5)	; Reset PSG volume envelope index (even on FM tracks...)
		btst	#3,SMPS_Track.PlaybackControl(a5)	; Is modulation on?
		beq.s	.locret				; If not, return
		movea.l	SMPS_Track.ModulationPtr(a5),a0	; Modulation data pointer
		move.b	(a0)+,SMPS_Track.ModulationWait(a5)	; Reset wait
		move.b	(a0)+,SMPS_Track.ModulationSpeed(a5)	; Reset speed
		move.b	(a0)+,SMPS_Track.ModulationDelta(a5)	; Reset delta
		move.b	(a0)+,d0			; Get steps
		lsr.b	#1,d0				; Halve them
		move.b	d0,SMPS_Track.ModulationSteps(a5)	; Then store
		clr.w	SMPS_Track.ModulationVal(a5)	; Reset frequency change

.locret:
		rts
; ---------------------------------------------------------------------------

NoteTimeoutUpdate:
		tst.b	SMPS_Track.NoteTimeout(a5)
		beq.s	.locret
		subq.b	#1,SMPS_Track.NoteTimeout(a5)
		bne.s	.locret
		bset	#1,SMPS_Track.PlaybackControl(a5)
		tst.b	SMPS_Track.VoiceControl(a5)
		bmi.w	.psg
		jsr	FMNoteOff(pc)
		addq.w	#4,sp
		rts
; ---------------------------------------------------------------------------

.psg:
		jsr	PSGNoteOff(pc)
		addq.w	#4,sp

.locret:
		rts
; ---------------------------------------------------------------------------

DoModulation:
	if ~~FixBugs
		addq.w	#4,sp
	endif
		btst	#3,SMPS_Track.PlaybackControl(a5)
	if FixBugs
		beq.s	.nomodnoreturn
	else
		beq.s	.nomod
	endif
		tst.b	SMPS_Track.ModulationWait(a5)
		beq.s	.waitdone
		subq.b	#1,SMPS_Track.ModulationWait(a5)

	if FixBugs
.nomodnoreturn:
		addq.w	#4,sp
	endif
		rts
; ---------------------------------------------------------------------------

.waitdone:
		subq.b	#1,SMPS_Track.ModulationSpeed(a5)
		beq.s	.nextstep
	if FixBugs
		addq.w	#4,sp
	endif
		rts
; ---------------------------------------------------------------------------

.nextstep:
		movea.l	SMPS_Track.ModulationPtr(a5),a0
		move.b	1(a0),SMPS_Track.ModulationSpeed(a5)
		tst.b	SMPS_Track.ModulationSteps(a5)
		bne.s	.noflip
		move.b	3(a0),SMPS_Track.ModulationSteps(a5)
		neg.b	SMPS_Track.ModulationDelta(a5)
	if FixBugs
		addq.w	#4,sp
	endif
		rts
; ---------------------------------------------------------------------------

.noflip:
		subq.b	#1,SMPS_Track.ModulationSteps(a5)
		move.b	SMPS_Track.ModulationDelta(a5),d6
		ext.w	d6
		add.w	SMPS_Track.ModulationVal(a5),d6
		move.w	d6,SMPS_Track.ModulationVal(a5)
		add.w	SMPS_Track.Freq(a5),d6
	if ~~FixBugs
		subq.w	#4,sp
	endif

.nomod:
		rts
; ---------------------------------------------------------------------------

FMPrepareNote:
		btst	#1,SMPS_Track.PlaybackControl(a5)
		bne.s	locret_744E0
		move.w	SMPS_Track.Freq(a5),d6
		beq.s	FMSetRest

FMUpdateFreq:
		move.b	SMPS_Track.Detune(a5),d0
		ext.w	d0
		add.w	d0,d6
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.s	locret_744E0
		tst.b	SMPS_RAM.v_se_mode_flag(a6)
		beq.s	.nofm3sm
		cmpi.b	#2,SMPS_Track.VoiceControl(a5)
		beq.s	FM3SpcUpdateFreq

.nofm3sm:
		move.w	d6,d1
		lsr.w	#8,d1
		move.b	#$A4,d0
		jsr	WriteFMIorII(pc)
		move.b	d6,d1
		move.b	#$A0,d0
		jsr	WriteFMIorII(pc)

locret_744E0:
		rts
; ---------------------------------------------------------------------------

FMSetRest:
		bset	#1,SMPS_Track.PlaybackControl(a5)
		rts
; ---------------------------------------------------------------------------

FM3SpcUpdateFreq:
		lea	.fm3freqs(pc),a1
		lea	SMPS_RAM.v_detune_start(a6),a2
		moveq	#bytesToWcnt(.fm3freqs_end-.fm3freqs),d7

.loopfm3:
		move.w	d6,d1
		move.w	(a2)+,d0
		add.w	d0,d1
		move.w	d1,d3
		lsr.w	#8,d1
		move.b	(a1)+,d0
		jsr	WriteFMI(pc)
		move.b	d3,d1
		move.b	(a1)+,d0
		jsr	WriteFMI(pc)
		dbf	d7,.loopfm3
		rts
; ---------------------------------------------------------------------------

.fm3freqs:
		dc.b $AD, $A9
		dc.b $AC, $A8
		dc.b $AE, $AA
		dc.b $A6, $A2
.fm3freqs_end
; ---------------------------------------------------------------------------

FMPan_Set:
		btst	#1,SMPS_Track.PlaybackControl(a5)
		bne.s	.tables
		moveq	#0,d0
		move.b	SMPS_Track.PanNumber(a5),d0
		lsl.w	#1,d0
		jmp	.tables(pc,d0.w)
; ---------------------------------------------------------------------------

.tables:
		rts
; ---------------------------------------------------------------------------
		bra.s	FMPan_Cont
; ---------------------------------------------------------------------------
		bra.s	FMPan_Reset
; ---------------------------------------------------------------------------
		bra.s	FMPan_Reset
; ---------------------------------------------------------------------------

FMPan_Chk:
		btst	#1,SMPS_Track.PlaybackControl(a5)
		bne.s	.table
		moveq	#0,d0
		move.b	SMPS_Track.PanNumber(a5),d0
		lsl.w	#1,d0
		jmp	.table(pc,d0.w)
; ---------------------------------------------------------------------------

.table:
		rts
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------
		bra.s	FMPan_Cont
; ---------------------------------------------------------------------------
		bra.s	FMPan_Cont
; ---------------------------------------------------------------------------

FMPan_Reset:
		move.b	SMPS_Track.PanLength(a5),SMPS_Track.PanContinue(a5)
		clr.b	SMPS_Track.PanStart(a5)

FMPan_Cont:
		move.b	SMPS_Track.PanContinue(a5),d0
		cmp.b	SMPS_Track.PanLength(a5),d0
		bne.s	loc_7457E
		move.b	SMPS_Track.PanLimit(a5),d3
		cmp.b	SMPS_Track.PanStart(a5),d3
		bpl.s	loc_74576
		cmpi.b	#2,SMPS_Track.PanNumber(a5)
		beq.s	locret_745AE
		clr.b	SMPS_Track.PanStart(a5)

loc_74576:
		clr.b	SMPS_Track.PanContinue(a5)
		addq.b	#1,SMPS_Track.PanStart(a5)

loc_7457E:
		moveq	#0,d0
		move.b	SMPS_Track.PanTable(a5),d0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	FMPan_Table(pc,d0.w),a0
		moveq	#0,d0
		move.b	SMPS_Track.PanStart(a5),d0
		subq.w	#1,d0
		move.b	(a0,d0.w),d1
		move.b	SMPS_Track.AMSFMSPan(a5),d0
		andi.b	#$37,d0
		or.b	d0,d1
		move.b	#$B4,d0
		jsr	WriteFMIorIIMain(pc)
		addq.b	#1,SMPS_Track.PanContinue(a5)

locret_745AE:
		rts
; ---------------------------------------------------------------------------
FMPan_Table:
		dc.l FMPan_1_Data
		dc.l FMPan_2_Data
		dc.l FMPan_3_Data
FMPan_1_Data:
		dc.b $40, $80
FMPan_2_Data:
		dc.b $40, $C0, $80
FMPan_3_Data:
		dc.b $C0, $80, $C0, $40
		even
; ---------------------------------------------------------------------------

PauseMusic:
		bmi.s	.unpausemusic
		cmpi.b	#2,SMPS_RAM.f_pausemusic(a6)
		beq.w	.unpausedallfm
		move.b	#2,SMPS_RAM.f_pausemusic(a6)
		moveq	#2,d2
		move.b	#$B4,d0
		moveq	#0,d1

.killpanloop:
		jsr	WriteFMI(pc)
		jsr	WriteFMII(pc)
		addq.b	#1,d0
		dbf	d2,.killpanloop

		moveq	#2,d2
		moveq	#$28,d0

.noteoffloop:
		move.b	d2,d1
		jsr	WriteFMI(pc)
		addq.b	#4,d1
		jsr	WriteFMI(pc)
		dbf	d2,.noteoffloop

		jsr	PSGSilenceAll(pc)
		bra.w	DoStartZ80
; ---------------------------------------------------------------------------

.unpausemusic:
		clr.b	SMPS_RAM.f_pausemusic(a6)
		moveq	#SMPS_Track.len,d3
		lea	SMPS_RAM.v_music_fmdac_tracks(a6),a5
		moveq	#SMPS_MUSIC_FM_DAC_TRACK_COUNT-1,d4 ; 6 FM + 1 DAC tracks

.bgmfmloop:
		btst	#7,SMPS_Track.PlaybackControl(a5)	; Is track playing?
		beq.s	.bgmfmnext			; Branch if not
		btst	#2,SMPS_Track.PlaybackControl(a5)	; Is track being overridden?
		bne.s	.bgmfmnext			; Branch if yes
		move.b	#$B4,d0				; Command to set AMS/FMS/panning
		move.b	SMPS_Track.AMSFMSPan(a5),d1		; Get value from track RAM
		jsr	WriteFMIorII(pc)

.bgmfmnext:
		adda.w	d3,a5
		dbf	d4,.bgmfmloop

		lea	SMPS_RAM.v_sfx_fm_tracks(a6),a5
		moveq	#SMPS_SFX_FM_TRACK_COUNT-1,d4 ; 3 FM tracks (SFX)

.sfxfmloop:
		btst	#7,SMPS_Track.PlaybackControl(a5)	; Is track playing?
		beq.s	.sfxfmnext			; Branch if not
		btst	#2,SMPS_Track.PlaybackControl(a5)	; Is track being overridden?
		bne.s	.sfxfmnext			; Branch if yes
		move.b	#$B4,d0				; Command to set AMS/FMS/panning
		move.b	SMPS_Track.AMSFMSPan(a5),d1		; Get value from track RAM
		jsr	WriteFMIorII(pc)

.sfxfmnext:
		adda.w	d3,a5
		dbf	d4,.sfxfmloop

		lea	SMPS_RAM.v_spcsfx_track_ram(a6),a5
		btst	#7,SMPS_Track.PlaybackControl(a5)	; Is track playing?
		beq.s	.unpausedallfm			; Branch if not
		btst	#2,SMPS_Track.PlaybackControl(a5)	; Is track being overridden?
		bne.s	.unpausedallfm			; Branch if yes
		move.b	#$B4,d0				; Command to set AMS/FMS/panning
		move.b	SMPS_Track.AMSFMSPan(a5),d1		; Get value from track RAM
		jsr	WriteFMIorII(pc)

.unpausedallfm:
		bra.w	DoStartZ80
; ---------------------------------------------------------------------------

CycleSoundQueue:
		movea.l	(Go_SoundPriorities).l,a0
		lea	SMPS_RAM.v_soundqueue0(a6),a1	; load music track number
		_move.b	SMPS_RAM.v_sndprio(a6),d3	; Get priority of currently playing SFX
		moveq	#SMPS_RAM.v_soundqueue_end-SMPS_RAM.v_soundqueue_start-1,d4 ; number of soundqueues

.inputloop:
		move.b	(a1),d0				; move track number to d0
		move.b	d0,d1
		clr.b	(a1)+				; Clear entry
		subi.b	#bgm__First,d0			; Make it into 0-based index
		bcs.s	.nextinput			; If negative (i.e., it was $80 or lower), branch
		andi.w	#$7F,d0				; Clear high byte and sign bit
		move.b	(a0,d0.w),d2			; Get sound type
		cmp.b	d3,d2				; Is it a lower priority sound?
		bcs.s	.nextinput
		move.b	d2,d3				; Store new priority
		move.b	d1,SMPS_RAM.v_sound_id(a6)	; Queue sound for playing

.nextinput:
		dbf	d4,.inputloop

		tst.b	d3				; We don't want to change sound priority if it is negative
		bmi.s	PlaySoundID
		_move.b	d3,SMPS_RAM.v_sndprio(a6)	; Set new sound priority

PlaySoundID:
		moveq	#0,d7
		move.b	SMPS_RAM.v_sound_id(a6),d7
		move.b	#$80,SMPS_RAM.v_sound_id(a6)
		cmpi.b	#$80,d7	; is sound id negative?
		beq.s	.nosound	; if equal to negative, branch
		bcs.w	StopAllSound	; if lower than negative, stop all sound
	if FixBugs
		cmpi.b	#bgm__Last,d7	; is this music?
	else
		; Bug: Should not include +$E, all entries after $91 up to $9F will try to be played even though the slots aren't occupied by any music
		; Luckily, there is a workaround for this bug in LevelSelect, but even there it's bugged.
		cmpi.b	#bgm__Last+$E,d7	; is this music?
	endif
		bls.w	PlaySnd_Music	; if so, branch
		cmpi.b	#sfx__First,d7	; is this between music and sfx?
		bcs.w	.nosound	; if so, branch
		cmpi.b	#sfx__Last,d7	; is this sfx?
		bls.w	PlaySnd_SFX	; if so, branch
		cmpi.b	#spec__First,d7	; is this between sfx and special sfx?
		bcs.w	.nosound	; if so, branch
	if FixBugs
		cmpi.b	#spec__Last,d7	; is this special sfx?
	else
		; Bug: Should not include +5
		cmpi.b	#spec__Last+5,d7	; is this special sfx?
	endif
		bcs.w	PlaySnd_SpecSFX	; if so, branch
		cmpi.b	#flg__First,d7	; is this between special sfx and sound commands?
		bcs.s	PlaySnd_DAC	; if so, branch
	if FixBugs
		cmpi.b	#flg__Last,d7	; is this sound commands?
	else
		; Bug: Should not include +1
		cmpi.b	#flg__Last+1,d7	; is this sound commands?
	endif
		bls.s	PlaySnd_Cmd	; if so, branch

.nosound:
		rts
; ---------------------------------------------------------------------------

PlaySnd_Cmd:
		subi.b	#flg__First,d7
		lsl.w	#2,d7
		jmp	Sound_ExIndex(pc,d7.w)
; ---------------------------------------------------------------------------
Sound_ExIndex:
ptr_flgE0:	bra.w	PlaySnd_FadeOut
ptr_flgE1:	bra.w	StopSFX
ptr_flgE2:	bra.w	PlaySnd_ShoesOn
ptr_flgE3:	bra.w	PlaySnd_ShoesOff
ptr_flgE4:	bra.w	StopSpecialSFX
ptr_flgend:
; ---------------------------------------------------------------------------

PlaySnd_DAC:
		addi.b	#$B1,d7
		move.b	d7,(z80_dac_sample).l
		nop
		nop
		nop
		clr.b	(a0)+
		rts
; ---------------------------------------------------------------------------

PlaySnd_Music:
		cmpi.b	#bgm_ExtraLife,d7
		bne.s	.bgmnot1up
		tst.b	SMPS_RAM.f_1up_playing(a6)
		bne.w	.exit
		lea	SMPS_RAM.v_music_track_ram(a6),a5
		moveq	#SMPS_MUSIC_TRACK_COUNT-1,d0 ; 1 DAC + 6 FM + 3 PSG tracks

.noint:
		bclr	#2,SMPS_Track.PlaybackControl(a5)
		adda.w	#SMPS_Track.len,a5
		dbf	d0,.noint

		lea	SMPS_RAM.v_sfx_track_ram(a6),a5
		moveq	#SMPS_SFX_TRACK_COUNT-1,d0 ; 3 FM + 3 PSG tracks (SFX)

.loop:
		bclr	#7,SMPS_Track.PlaybackControl(a5)
		adda.w	#SMPS_Track.len,a5
		dbf	d0,.loop

		movea.l	a6,a0
		lea	SMPS_RAM.v_1up_ram_copy(a6),a1
		move.w	#bytesToLcnt(SMPS_RAM.v_1up_ram_end-SMPS_RAM.v_1up_ram),d0 ; Backup $220 bytes: all variables and music track data

.memcopy:
		move.l	(a0)+,(a1)+
		dbf	d0,.memcopy
		move.b	#$80,SMPS_RAM.f_1up_playing(a6)
		_clr.b	SMPS_RAM.v_sndprio(a6)
		bra.s	.initmusic
; ---------------------------------------------------------------------------

.bgmnot1up:
		clr.b	SMPS_RAM.f_1up_playing(a6)
		clr.b	SMPS_RAM.v_fadein_counter(a6)

.initmusic:
		jsr	InitMusicPlayback(pc)
		movea.l	(Go_SpeedUpIndex).l,a4
		subi.b	#bgm__First,d7
		move.b	(a4,d7.w),SMPS_RAM.v_speeduptempo(a6)
		movea.l	(Go_MusicIndex).l,a4
		lsl.w	#2,d7
		movea.l	(a4,d7.w),a4
		moveq	#0,d0
		move.w	(a4),d0
		add.l	a4,d0
		move.l	d0,SMPS_RAM.v_voice_ptr(a6)
		move.b	5(a4),d0
		move.b	d0,SMPS_RAM.v_tempo_mod(a6)
		tst.b	SMPS_RAM.f_speedup(a6)
		beq.s	.nospeedshoes
		move.b	SMPS_RAM.v_speeduptempo(a6),d0

.nospeedshoes:
		move.b	d0,SMPS_RAM.v_main_tempo(a6)
		move.b	d0,SMPS_RAM.v_main_tempo_timeout(a6)
		moveq	#0,d1
		movea.l	a4,a3
		addq.w	#6,a4
		moveq	#0,d7
		move.b	2(a3),d7
		beq.w	.bgm_fmdone
		subq.b	#1,d7
		move.b	#$C0,d1
		move.b	4(a3),d4
		moveq	#SMPS_Track.len,d6
		move.b	#1,d5
		lea	SMPS_RAM.v_music_fmdac_tracks(a6),a1
		lea	FMDACInitBytes(pc),a2

.bgm_fmloadloop:
		bset	#7,SMPS_Track.PlaybackControl(a1)
		move.b	(a2)+,SMPS_Track.VoiceControl(a1)
		move.b	d4,SMPS_Track.TempoDivider(a1)
		move.b	d6,SMPS_Track.StackPointer(a1)
		move.b	d1,SMPS_Track.AMSFMSPan(a1)
		move.b	d5,SMPS_Track.DurationTimeout(a1)
		moveq	#0,d0
		move.w	(a4)+,d0
		add.l	a3,d0
		move.l	d0,SMPS_Track.DataPointer(a1)
		move.w	(a4)+,SMPS_Track.Transpose(a1)
		adda.w	d6,a1
		dbf	d7,.bgm_fmloadloop

		cmpi.b	#7,2(a3)
		bne.s	.silencefm6
		moveq	#$2B,d0
		moveq	#0,d1
		jsr	WriteFMI(pc)
		bra.w	.bgm_fmdone
; ---------------------------------------------------------------------------

.silencefm6:
		moveq	#$28,d0
		moveq	#6,d1
		jsr	WriteFMI(pc)
		move.b	#$42,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$4A,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$46,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$4E,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$B6,d0
		move.b	#$C0,d1
		jsr	WriteFMII(pc)

.bgm_fmdone:
		moveq	#0,d7
		move.b	3(a3),d7
		beq.s	.bgm_psgdone
		subq.b	#1,d7
		lea	SMPS_RAM.v_music_psg_tracks(a6),a1
		lea	PSGInitBytes(pc),a2

.bgm_psgloadloop:
		bset	#7,SMPS_Track.PlaybackControl(a1)
		move.b	(a2)+,SMPS_Track.VoiceControl(a1)
		move.b	d4,SMPS_Track.TempoDivider(a1)
		move.b	d6,SMPS_Track.StackPointer(a1)
		move.b	d5,SMPS_Track.DurationTimeout(a1)
		moveq	#0,d0
		move.w	(a4)+,d0
		add.l	a3,d0
		move.l	d0,SMPS_Track.DataPointer(a1)
		move.w	(a4)+,SMPS_Track.Transpose(a1)
		move.b	(a4)+,d0
		move.b	(a4)+,SMPS_Track.VoiceIndex(a1)
		adda.w	d6,a1
		dbf	d7,.bgm_psgloadloop

.bgm_psgdone:
		lea	SMPS_RAM.v_sfx_track_ram(a6),a1
		moveq	#SMPS_SFX_TRACK_COUNT-1,d7

.sfxloop:
		tst.b	SMPS_Track.PlaybackControl(a1)
		bpl.w	.nextsfx
		moveq	#0,d0
		move.b	SMPS_Track.VoiceControl(a1),d0
		bmi.s	.psgsfx
		subq.b	#2,d0
		lsl.b	#2,d0
		bra.s	.getch
; ---------------------------------------------------------------------------

.psgsfx:
		lsr.b	#3,d0

.getch:
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	(a0,d0.w),a0
		bset	#2,SMPS_Track.PlaybackControl(a0)

.nextsfx:
		adda.w	d6,a1
		dbf	d7,.sfxloop

		tst.w	SMPS_RAM.v_spcsfx_fm4_track+SMPS_Track.PlaybackControl(a6)
		bpl.s	.checkspecialpsg
		bset	#2,SMPS_RAM.v_music_fm4_track+SMPS_Track.PlaybackControl(a6)

.checkspecialpsg:
		tst.w	SMPS_RAM.v_spcsfx_psg3_track+SMPS_Track.PlaybackControl(a6)
		bpl.s	.sendfmnoteoff
		bset	#2,SMPS_RAM.v_music_psg3_track+SMPS_Track.PlaybackControl(a6)

.sendfmnoteoff:
		lea	SMPS_RAM.v_music_fm_tracks(a6),a5
		moveq	#SMPS_MUSIC_FM_TRACK_COUNT-1,d4

.fmnoteoffloop:
		jsr	FMNoteOff(pc)
		adda.w	d6,a5
		dbf	d4,.fmnoteoffloop
		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d4

.psgnoteoffloop:
		jsr	PSGNoteOff(pc)
		adda.w	d6,a5
		dbf	d4,.psgnoteoffloop

.exit:
		addq.w	#4,sp
		rts
; ---------------------------------------------------------------------------
FMDACInitBytes:
		dc.b 6, 0, 1, 2, 4, 5, 6
		even
PSGInitBytes:
		dc.b $80, $A0, $C0
		even
; ---------------------------------------------------------------------------

PlaySnd_SFX:
		tst.b	SMPS_RAM.f_1up_playing(a6)
		bne.w	.exit
		cmpi.b	#sfx_Ring,d7
		bne.s	.notring
		tst.b	SMPS_RAM.v_ring_speaker(a6)
		bne.s	.noswap
		move.b	#sfx_RingLeft,d7

.noswap:
		bchg	#0,SMPS_RAM.v_ring_speaker(a6)

.notring:
		cmpi.b	#sfx_Push,d7
		bne.s	.notpush
		tst.b	SMPS_RAM.f_push_playing(a6)
		bne.w	.exit
		move.b	#$80,SMPS_RAM.f_push_playing(a6)

.notpush:
		movea.l	(Go_SoundIndex).l,a0
		subi.b	#sfx__First,d7
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,SMPS_RAM.v_lfo_voice_ptr(a6)
		move.b	(a1)+,d5
	if FixBugs
		moveq	#0,d7
	else
		; Bug: There is a missing 'moveq	#0,d7' here, without which SFXes whose
		; index entry is above $3F will cause a crash. This was fixed in Ristar's driver.
	endif
		move.b	(a1)+,d7
		subq.b	#1,d7
		moveq	#SMPS_Track.len,d6

.chanloop:
		moveq	#0,d3
		move.b	SMPS_Track.VoiceControl(a1),d3
		move.b	d3,d4
		bmi.s	.psg
		subq.w	#2,d3
		lsl.w	#2,d3
		lea	SFX_BGMChannelRAM(pc),a5
		movea.l	(a5,d3.w),a5
		bset	#2,SMPS_Track.PlaybackControl(a5)
		bra.s	.continue
; ---------------------------------------------------------------------------

.psg:
		lsr.w	#3,d3
		movea.l	SFX_BGMChannelRAM(pc,d3.w),a5
		bset	#2,SMPS_Track.PlaybackControl(a5)
		cmpi.b	#$C0,d4
		bne.s	.continue
		move.b	d4,d0
		ori.b	#$1F,d0
		move.b	d0,(psg_input).l
		bchg	#5,d0
		move.b	d0,(psg_input).l

.continue:
		movea.l	SFX_SFXChannelRAM(pc,d3.w),a5
		movea.l	a5,a2
		moveq	#bytesToLcnt(SMPS_Track.len),d0

.clear:
		clr.l	(a2)+
		dbf	d0,.clear
		move.w	(a1)+,SMPS_Track.PlaybackControl(a5)
		move.b	d5,SMPS_Track.TempoDivider(a5)
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,SMPS_Track.DataPointer(a5)
		move.w	(a1)+,SMPS_Track.Transpose(a5)
		move.b	#1,SMPS_Track.DurationTimeout(a5)
		move.b	d6,SMPS_Track.StackPointer(a5)
		tst.b	d4
		bmi.s	.notpsg
		move.b	#$C0,SMPS_Track.AMSFMSPan(a5)

.notpsg:
		dbf	d7,.chanloop
		tst.b	SMPS_RAM.v_sfx_fm4_track+SMPS_Track.PlaybackControl(a6)
		bpl.s	.nospec
		bset	#2,SMPS_RAM.v_spcsfx_fm4_track+SMPS_Track.PlaybackControl(a6)

.nospec:
		tst.b	SMPS_RAM.v_sfx_psg3_track+SMPS_Track.PlaybackControl(a6)
		bpl.s	.exit
		bset	#2,SMPS_RAM.v_spcsfx_psg3_track+SMPS_Track.PlaybackControl(a6)

.exit:
		rts
; ---------------------------------------------------------------------------

SFX_BGMChannelRAM:
		dc.l (v_snddriver_ram.v_music_fm3_track)&$FFFFFF
		dc.l 0
		dc.l (v_snddriver_ram.v_music_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_music_fm5_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_music_psg1_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_music_psg2_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_music_psg3_track)&$FFFFFF ; Plain PSG3
		dc.l (v_snddriver_ram.v_music_psg3_track)&$FFFFFF ; Noise

SFX_SFXChannelRAM:
		dc.l (v_snddriver_ram.v_sfx_fm3_track)&$FFFFFF
		dc.l 0
		dc.l (v_snddriver_ram.v_sfx_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_sfx_fm5_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_sfx_psg1_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_sfx_psg2_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_sfx_psg3_track)&$FFFFFF ; Plain PSG3
		dc.l (v_snddriver_ram.v_sfx_psg3_track)&$FFFFFF ; Noise
; ---------------------------------------------------------------------------

PlaySnd_SpecSFX:
		tst.b	SMPS_RAM.f_1up_playing(a6)	; Is 1-up playing?
		bne.w	.locret				; Return if so
		movea.l	(Go_SpecSoundIndex).l,a0
		subi.b	#spec__First,d7			; Make it 0-based
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d0
		move.w	(a1)+,d0			; Voice pointer
		add.l	a3,d0				; Relative pointer
		move.l	d0,SMPS_RAM.v_special_voice_ptr(a6)	; Store voice pointer
		move.b	(a1)+,d5			; Dividing timing
	if FixBugs
		moveq	#0,d7
	else
		; Bug: There is a missing 'moveq	#0,d7' here, without which special SFXes whose
		; index entry is above $3F will cause a crash. This instance was not fixed in Ristar's driver.
	endif
		move.b	(a1)+,d7			; Number of tracks (FM + PSG)
		subq.b	#1,d7
		moveq	#SMPS_Track.len,d6

.sfxloadloop:
		move.b	SMPS_Track.VoiceControl(a1),d4	; Voice control bits
		bmi.s	.sfxoverridepsg			; Branch if PSG
		bset	#2,SMPS_RAM.v_music_fm4_track+SMPS_Track.PlaybackControl(a6) ; Set 'SFX is overriding' bit
		lea	SMPS_RAM.v_spcsfx_fm4_track(a6),a5
		bra.s	.sfxinitpsg
; ===========================================================================

.sfxoverridepsg:
		bset	#2,SMPS_RAM.v_music_psg3_track+SMPS_Track.PlaybackControl(a6) ; Set 'SFX is overriding' bit
		lea	SMPS_RAM.v_spcsfx_psg3_track(a6),a5

.sfxinitpsg:
		movea.l	a5,a2
		moveq	#bytesToLcnt(SMPS_Track.len),d0	; $30 bytes

.clearsfxtrackram:
		clr.l	(a2)+
		dbf	d0,.clearsfxtrackram

		move.w	(a1)+,SMPS_Track.PlaybackControl(a5)			; Initial playback control bits & voice control bits (TrackPlaybackControl)
		move.b	d5,SMPS_Track.TempoDivider(a5)
		moveq	#0,d0
		move.w	(a1)+,d0			; Track data pointer
		add.l	a3,d0				; Relative pointer
		move.l	d0,SMPS_Track.DataPointer(a5)		; Store track pointer
		move.w	(a1)+,SMPS_Track.Transpose(a5)	; load FM/PSG channel modifier
		move.b	#1,SMPS_Track.DurationTimeout(a5)	; Set duration of first "note"
		move.b	d6,SMPS_Track.StackPointer(a5)	; set "gosub" (coord flag $F8) stack init value
		tst.b	d4				; Is this a PSG channel?
		bmi.s	.sfxpsginitdone			; Branch if yes
		move.b	#$C0,SMPS_Track.AMSFMSPan(a5)		; AMS/FMS/Panning

.sfxpsginitdone:
		dbf	d7,.sfxloadloop

		tst.b	SMPS_RAM.v_sfx_fm4_track+SMPS_Track.PlaybackControl(a6) ; Is track playing?
		bpl.s	.doneoverride			; Branch if not
		bset	#2,SMPS_RAM.v_spcsfx_fm4_track+SMPS_Track.PlaybackControl(a6) ; Set 'SFX is overriding' bit

.doneoverride:
		tst.b	SMPS_RAM.v_sfx_psg3_track+SMPS_Track.PlaybackControl(a6) ; Is track playing?
		bpl.s	.locret				; Branch if not
		bset	#2,SMPS_RAM.v_spcsfx_psg3_track+SMPS_Track.PlaybackControl(a6) ; Set 'SFX is overriding' bit
		ori.b	#$1F,d4				; Command to silence channel
		move.b	d4,(psg_input).l
		bchg	#5,d4				; Command to silence noise channel
		move.b	d4,(psg_input).l

.locret:
		rts
; ---------------------------------------------------------------------------
; Unused RAM addresses for FM and PSG channel variables used by the Special SFX
; ---------------------------------------------------------------------------
; The first block would have been used for overriding the music tracks
; as they have a lower priority, just as they are in Sound_PlaySFX
; The third block would be used to set up the Special SFX
; The second block, however, is for the SFX tracks, which have a higher priority
; and would be checked for if they're currently playing
; If they are, then the third block would be used again, this time to mark
; the new tracks as 'currently playing'

; These were actually used in Moonwalker's driver (and other SMPS 68k Type 1a drivers)

; BGMFM4PSG3RAM:
;SpecSFX_BGMChannelRAM:
		dc.l (v_snddriver_ram.v_music_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_music_psg3_track)&$FFFFFF
; SFXFM4PSG3RAM:
;SpecSFX_SFXChannelRAM:
		dc.l (v_snddriver_ram.v_sfx_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_sfx_psg3_track)&$FFFFFF
; SpecialSFXFM4PSG3RAM:
;SpecSFX_SpecSFXChannelRAM:
		dc.l (v_snddriver_ram.v_spcsfx_fm4_track)&$FFFFFF
		dc.l (v_snddriver_ram.v_spcsfx_psg3_track)&$FFFFFF
; ---------------------------------------------------------------------------

StopSFX:
		_clr.b	SMPS_RAM.v_sndprio(a6)
		moveq	#$27,d0
		moveq	#0,d1
		jsr	WriteFMI(pc)
		lea	SMPS_RAM.v_sfx_track_ram(a6),a5
		moveq	#SMPS_SFX_TRACK_COUNT-1,d7 ; 3 FM + 3 PSG tracks (SFX)

.trackloop:
		tst.b	SMPS_Track.PlaybackControl(a5)	; Is track playing?
		bpl.w	.nexttrack			; Branch if not
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; Stop track
		moveq	#0,d3
		move.b	SMPS_Track.VoiceControl(a5),d3	; Get voice control bits
		bmi.s	.trackpsg			; Branch if PSG
		jsr	FMNoteOff(pc)
		cmpi.b	#4,d3				; Is this FM4?
		bne.s	.getfmpointer			; Branch if not
		tst.b	SMPS_RAM.v_spcsfx_fm4_track+SMPS_Track.PlaybackControl(a6) ; Is special SFX playing?
		bpl.s	.getfmpointer			; Branch if not
	if FixBugs
		movea.l	a5,a3
	else
		; Bug: There is a missing 'movea.l	a5,a3' here, without which the
		; code is broken. It is dangerous to do a fade out when a GHZ waterfall
		; is playing its sound
	endif
		lea	SMPS_RAM.v_spcsfx_fm4_track(a6),a5
		movea.l	SMPS_RAM.v_special_voice_ptr(a6),a1	; Get special voice pointer
		bra.s	.gotfmpointer
; ===========================================================================
; loc_72416:
.getfmpointer:
		subq.b	#2,d3				; SFX only has FM3 and up
		lsl.b	#2,d3
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	a5,a3
		movea.l	(a0,d3.w),a5
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; Get music voice pointer
; loc_72428:
.gotfmpointer:
		bclr	#2,SMPS_Track.PlaybackControl(a5)	; Clear 'SFX is overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a5)	; Set 'track at rest' bit
	if FixBugs
		moveq	#0,d0
	else
		; Bug: The low bit is not cleared here
	endif
		move.b	SMPS_Track.VoiceIndex(a5),d0		; Current voice
		jsr	SetVoice(pc)
		movea.l	a3,a5
		bra.s	.nexttrack
; ===========================================================================
; loc_7243C:
.trackpsg:
		jsr	PSGNoteOff(pc)
		lea	SMPS_RAM.v_spcsfx_psg3_track(a6),a0
	if FixBugs
		; cfStopTrack does this check but this function oddly lacks it.
		tst.b	SMPS_Track.PlaybackControl(a0)	; Is track playing?
		bpl.s	.gotpsgpointer			; Branch if not
	endif
		cmpi.b	#$E0,d3				; Is this a noise channel?
		beq.s	.gotpsgpointer			; Branch if yes
		cmpi.b	#$C0,d3				; Is this PSG 3?
		beq.s	.gotpsgpointer			; Branch if yes
		lsr.b	#3,d3
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	(a0,d3.w),a0
; loc_7245A:
.gotpsgpointer:
		bclr	#2,SMPS_Track.PlaybackControl(a0)	; Clear 'SFX is overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a0)	; Set 'track at rest' bit
		cmpi.b	#$E0,SMPS_Track.VoiceControl(a0)	; Is this a noise channel?
		bne.s	.nexttrack			; Branch if not
		move.b	SMPS_Track.PSGNoise(a0),(psg_input).l	; Set noise type
; loc_72472:
.nexttrack:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.trackloop

		rts
; ---------------------------------------------------------------------------

StopSpecialSFX:
		lea	SMPS_RAM.v_spcsfx_fm4_track(a6),a5
		tst.b	SMPS_Track.PlaybackControl(a5)	; Is track playing?
		bpl.s	.fadedfm			; Branch if not
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; Stop track
		btst	#2,SMPS_Track.PlaybackControl(a5)	; Is SFX overriding?
		bne.s	.fadedfm			; Branch if not
		jsr	SendFMNoteOff(pc)
		lea	SMPS_RAM.v_music_fm4_track(a6),a5
		bclr	#2,SMPS_Track.PlaybackControl(a5)	; Clear 'SFX is overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a5)	; Set 'track at rest' bit
		tst.b	SMPS_Track.PlaybackControl(a5)	; Is track playing?
		bpl.s	.fadedfm			; Branch if not
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; Voice pointer
	if FixBugs
		moveq	#0,d0
	else
		; Bug: The low bit is not cleared here
	endif
		move.b	SMPS_Track.VoiceIndex(a5),d0		; Current voice
		jsr	SetVoice(pc)

.fadedfm:
		lea	SMPS_RAM.v_spcsfx_psg3_track(a6),a5
		tst.b	SMPS_Track.PlaybackControl(a5)	; Is track playing?
		bpl.s	.fadedpsg			; Branch if not
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; Stop track
		btst	#2,SMPS_Track.PlaybackControl(a5)	; Is SFX overriding?
		bne.s	.fadedpsg			; Return if not
		jsr	SendPSGNoteOff(pc)
		lea	SMPS_RAM.v_music_psg3_track(a6),a5
		bclr	#2,SMPS_Track.PlaybackControl(a5)	; Clear 'SFX is overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a5)	; Set 'track at rest' bit
		tst.b	SMPS_Track.PlaybackControl(a5)	; Is track playing?
		bpl.s	.fadedpsg			; Return if not
		cmpi.b	#$E0,SMPS_Track.VoiceControl(a5)	; Is this a noise channel?
		bne.s	.fadedpsg			; Return if not
		move.b	SMPS_Track.PSGNoise(a5),(psg_input).l	; Set noise type

.fadedpsg:
		rts
; ---------------------------------------------------------------------------

PlaySnd_FadeOut:
		jsr	StopSFX(pc)
		jsr	StopSpecialSFX(pc)
		move.b	#3,SMPS_RAM.v_fadeout_delay(a6)		; Set fadeout delay to 3
		move.b	#$28,SMPS_RAM.v_fadeout_counter(a6)	; Set fadeout counter
		clr.b	SMPS_RAM.v_music_dac_track+SMPS_Track.PlaybackControl(a6) ; Stop DAC track
		clr.b	SMPS_RAM.f_speedup(a6)			; Disable speed shoes tempo
		rts
; ---------------------------------------------------------------------------

DoFadeOut:
		move.b	SMPS_RAM.v_fadeout_delay(a6),d0		; Has fadeout delay expired?
		beq.s	.continuefade			; Branch if yes
		subq.b	#1,SMPS_RAM.v_fadeout_delay(a6)
		rts
; ---------------------------------------------------------------------------

.continuefade:
		subq.b	#1,SMPS_RAM.v_fadeout_counter(a6)	; Update fade counter
		beq.w	StopAllSound			; Branch if fade is done
		move.b	#3,SMPS_RAM.v_fadeout_delay(a6)		; Reset fade delay
		lea	SMPS_RAM.v_music_fm_tracks(a6),a5
		moveq	#SMPS_MUSIC_FM_TRACK_COUNT-1,d7 ; 6 FM tracks

.fmloop:
		tst.b	SMPS_Track.PlaybackControl(a5)	; Is track playing?
		bpl.s	.nextfm				; Branch if not
		addq.b	#1,SMPS_Track.Volume(a5)		; Increase volume attenuation
		bpl.s	.sendfmtl			; Branch if still positive
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; Stop track
		bra.s	.nextfm
; ---------------------------------------------------------------------------

.sendfmtl:
		jsr	SendVoiceTL(pc)

.nextfm:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.fmloop

		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d7 ; 3 PSG tracks

.psgloop:
		tst.b	SMPS_Track.PlaybackControl(a5)	; Is track playing?
		bpl.s	.nextpsg			; branch if not
		addq.b	#1,SMPS_Track.Volume(a5)		; Increase volume attenuation
		cmpi.b	#$10,SMPS_Track.Volume(a5)		; Is it greater than $F?
		blo.s	.sendpsgvol			; Branch if not
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; Stop track
		bra.s	.nextpsg
; ---------------------------------------------------------------------------

.sendpsgvol:
		move.b	SMPS_Track.Volume(a5),d6		; Store new volume attenuation
		jsr	SetPSGVolume(pc)

.nextpsg:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.psgloop
		rts
; ---------------------------------------------------------------------------

FMSilenceAll_Special:
		moveq	#3,d4
		moveq	#$40,d3
		moveq	#$7F,d1

.tlloop:
		move.b	d3,d0
		jsr	WriteFMIorII(pc)
		addq.b	#4,d3
		dbf	d4,.tlloop
		moveq	#3,d4
		move.b	#$80,d3
		moveq	#$F,d1

.rrloop:
		move.b	d3,d0
		jsr	WriteFMIorII(pc)
		addq.b	#4,d3
		dbf	d4,.rrloop
		rts
; ---------------------------------------------------------------------------

FMSilenceAll:
		moveq	#2,d2
		moveq	#$28,d0

.keyoff:
		move.b	d2,d1
		jsr	WriteFMI(pc)
		addq.b	#4,d1
		jsr	WriteFMI(pc)
		dbf	d2,.keyoff
		moveq	#$40,d0
		moveq	#$7F,d1
		moveq	#2,d3

.fmloop:
		moveq	#3,d2

.oploop:
		jsr	WriteFMI(pc)
		jsr	WriteFMII(pc)
		addq.w	#4,d0
		dbf	d2,.oploop
		subi.b	#$F,d0
		dbf	d3,.fmloop
		rts
; ---------------------------------------------------------------------------

StopAllSound:
		moveq	#$2B,d0
		move.b	#$80,d1
		jsr	WriteFMI(pc)
		moveq	#$27,d0
		moveq	#0,d1
		jsr	WriteFMI(pc)
		movea.l	a6,a0
	if FixBugs
		move.w	#bytesToLcnt(SMPS_RAM.v_1up_ram_copy),d0 ; Clear $3A0 bytes: all variables and all track data
	else
		; Bug: This should be clearing all variables and track data, but misses the last $10 bytes of v_spcsfx_psg3_Track.
		move.w	#bytesToLcnt(SMPS_RAM.v_1up_ram_copy-$10),d0 ; Clear $390 bytes: all variables and most track data
	endif

.clearramloop:
		clr.l	(a0)+
		dbf	d0,.clearramloop
		move.b	#$80,SMPS_RAM.v_sound_id(a6)
		jsr	FMSilenceAll(pc)
		bra.w	PSGSilenceAll
; ---------------------------------------------------------------------------

InitMusicPlayback:
		movea.l	a6,a0
		; Save several values
	if ~~FixBugs
		; Bug: v_soundqueue0 and the other queues are not saved
	endif
		_move.b	SMPS_RAM.v_sndprio(a6),d1
		move.b	SMPS_RAM.f_1up_playing(a6),d2
		move.b	SMPS_RAM.f_speedup(a6),d3
		move.b	SMPS_RAM.v_fadein_counter(a6),d4
	if FixBugs
		move.l	SMPS_RAM.v_soundqueue0(a6),d5
	endif
		move.w	#bytesToLcnt(SMPS_RAM.v_1up_ram_end-SMPS_RAM.v_1up_ram),d0

.clearramloop:
		clr.l	(a0)+
		dbf	d0,.clearramloop

		; Restore the values saved above
	if ~~FixBugs
		; Bug: Like above, v_soundqueue0 and the other queues are not restored either
	endif
		_move.b	d1,SMPS_RAM.v_sndprio(a6)
		move.b	d2,SMPS_RAM.f_1up_playing(a6)
		move.b	d3,SMPS_RAM.f_speedup(a6)
		move.b	d4,SMPS_RAM.v_fadein_counter(a6)
	if FixBugs
		move.l	d5,SMPS_RAM.v_soundqueue0(a6)
	endif
		move.b	#$80,SMPS_RAM.v_sound_id(a6)
	if FixBugs
		lea	SMPS_RAM.v_music_dac_track.VoiceControl(a6),a1
		lea	FMDACInitBytes(pc),a2
		moveq	#SMPS_MUSIC_FM_DAC_TRACK_COUNT-1,d1	; 7 DAC/FM tracks
		bsr.s	.writeloop
		lea	PSGInitBytes(pc),a2
		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d1	; 3 PSG tracks

.writeloop:
		move.b	(a2)+,(a1)		; Write track's channel byte
		lea	SMPS_Track.len(a1),a1	; Next track
		dbf	d1,.writeloop		; Loop for all DAC/FM/PSG tracks

		rts
	else
		; Bug: This is missing the FM channels
		bra.w	PSGSilenceAll
	endif
; ---------------------------------------------------------------------------

TempoWait:
		move.b	SMPS_RAM.v_main_tempo(a6),SMPS_RAM.v_main_tempo_timeout(a6)
		addq.b	#1,SMPS_RAM.v_music_dac_track+SMPS_Track.DurationTimeout(a6)
		addq.b	#1,SMPS_RAM.v_music_fm1_track+SMPS_Track.DurationTimeout(a6)
		addq.b	#1,SMPS_RAM.v_music_fm2_track+SMPS_Track.DurationTimeout(a6)
		addq.b	#1,SMPS_RAM.v_music_fm3_track+SMPS_Track.DurationTimeout(a6)
		addq.b	#1,SMPS_RAM.v_music_fm4_track+SMPS_Track.DurationTimeout(a6)
		addq.b	#1,SMPS_RAM.v_music_fm5_track+SMPS_Track.DurationTimeout(a6)
		addq.b	#1,SMPS_RAM.v_music_fm6_track+SMPS_Track.DurationTimeout(a6)
		addq.b	#1,SMPS_RAM.v_music_psg1_track+SMPS_Track.DurationTimeout(a6)
		addq.b	#1,SMPS_RAM.v_music_psg2_track+SMPS_Track.DurationTimeout(a6)
		addq.b	#1,SMPS_RAM.v_music_psg3_track+SMPS_Track.DurationTimeout(a6)
		rts
; ---------------------------------------------------------------------------

PlaySnd_ShoesOn:
		move.b	SMPS_RAM.v_speeduptempo(a6),SMPS_RAM.v_main_tempo(a6)
		move.b	SMPS_RAM.v_speeduptempo(a6),SMPS_RAM.v_main_tempo_timeout(a6)
		move.b	#$80,SMPS_RAM.f_speedup(a6)
		rts
; ---------------------------------------------------------------------------

PlaySnd_ShoesOff:
		move.b	SMPS_RAM.v_tempo_mod(a6),SMPS_RAM.v_main_tempo(a6)
		move.b	SMPS_RAM.v_tempo_mod(a6),SMPS_RAM.v_main_tempo_timeout(a6)
		clr.b	SMPS_RAM.f_speedup(a6)
		rts
; ---------------------------------------------------------------------------

DoFadeIn:
		tst.b	SMPS_RAM.v_fadein_delay(a6)	; Has fadein delay expired?
		beq.s	.continuefade			; Branch if yes
		subq.b	#1,SMPS_RAM.v_fadein_delay(a6)
		rts
; ---------------------------------------------------------------------------

.continuefade:
		tst.b	SMPS_RAM.v_fadein_counter(a6)		; Is fade done?
		beq.s	.fadedone			; Branch if yes
		subq.b	#1,SMPS_RAM.v_fadein_counter(a6)	; Update fade counter
		move.b	#2,SMPS_RAM.v_fadein_delay(a6)		; Reset fade delay
		lea	SMPS_RAM.v_music_fm_tracks(a6),a5
		moveq	#SMPS_MUSIC_FM_TRACK_COUNT-1,d7 ; 6 FM tracks

.fmloop:
		tst.b	SMPS_Track.PlaybackControl(a5)	; Is track playing?
		bpl.s	.nextfm				; Branch if not
		subq.b	#1,SMPS_Track.Volume(a5)	; Reduce volume attenuation
		jsr	SendVoiceTL(pc)

.nextfm:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.fmloop
		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d7 ; 3 PSG tracks

.psgloop:
		tst.b	SMPS_Track.PlaybackControl(a5)	; Is track playing?
		bpl.s	.nextpsg			; Branch if not
		subq.b	#1,SMPS_Track.Volume(a5)	; Reduce volume attenuation
	if FixBugs
		move.b	SMPS_Track.Volume(a5),d6
		cmpi.b	#$10,d6				; Is it is < $10?
		blo.s	.sendpsgvol			; Branch if yes
		moveq	#$F,d6				; Limit to $F (maximum attenuation)

.sendpsgvol:
	else
		; Bug: SMPS_Track.Volume is not moved to d6 here, resulting in crackling and loud sounds when fading in
	endif
		jsr	SetPSGVolume(pc)

.nextpsg:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,.psgloop
		rts
; ---------------------------------------------------------------------------

.fadedone:
		bclr	#2,SMPS_RAM.v_music_dac_track+SMPS_Track.PlaybackControl(a6) ; Clear 'SFX overriding' bit
		clr.b	SMPS_RAM.f_fadein_flag(a6)	; Stop fadein
		rts
; ---------------------------------------------------------------------------

FMNoteOn:
		btst	#1,SMPS_Track.PlaybackControl(a5)
		bne.s	.locret
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.s	.locret
		moveq	#$28,d0
		move.b	SMPS_Track.VoiceControl(a5),d1
		ori.b	#$F0,d1
		bra.w	WriteFMI
; ---------------------------------------------------------------------------

.locret:
		rts
; ---------------------------------------------------------------------------

FMNoteOff:
		btst	#4,SMPS_Track.PlaybackControl(a5)
		bne.s	locret_74E42
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.s	locret_74E42

SendFMNoteOff:
		moveq	#$28,d0
		move.b	SMPS_Track.VoiceControl(a5),d1
		bra.w	WriteFMI
; ---------------------------------------------------------------------------

locret_74E42:
		rts
; ---------------------------------------------------------------------------

WriteFMIorIIMain:
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.s	locret_74E4E
		bra.w	WriteFMIorII
; ---------------------------------------------------------------------------

locret_74E4E:
		rts
; ---------------------------------------------------------------------------

WriteFMIorII:
		btst	#2,SMPS_Track.VoiceControl(a5)
		bne.s	WriteFMIIPart
		add.b	SMPS_Track.VoiceControl(a5),d0

; ---------------------------------------------------------------------------
; these are what are in the default smps 68k type 1b driver
; why the final chose the ones from the type 1a driver is a mystery
; ---------------------------------------------------------------------------

WriteFMI:
		lea	(ym2612_a0).l,a0

.waitym1:
		btst	#7,(a0)
		bne.s	.waitym1
		move.b	d0,(a0)

.waitym2:
		btst	#7,(a0)
		bne.s	.waitym2
		move.b	d1,ym2612_d0-ym2612_a0(a0)
		rts
; ---------------------------------------------------------------------------

WriteFMIIPart:
		move.b	SMPS_Track.VoiceControl(a5),d2
		bclr	#2,d2
		add.b	d2,d0
; ---------------------------------------------------------------------------

WriteFMII:
		lea	(ym2612_a0).l,a0

.waitym1:
		btst	#7,(a0)
		bne.s	.waitym1
		move.b	d0,ym2612_a1-ym2612_a0(a0)

.waitym2:
		btst	#7,(a0)
		bne.s	.waitym2
		move.b	d1,ym2612_d1-ym2612_a0(a0)
		rts
; ---------------------------------------------------------------------------
; FM Note Values: b-0 to a#8
;
; Each row is an octave, starting with B and ending with A-sharp/B-flat.
; Notably, this differs from the PSG frequency table, which starts with C and
; ends with B. This is caused by 'FMSetFreq' subtracting $80 from the note
; instead of $81, meaning that the first frequency in the table ironically
; corresponds to the 'rest' note. The only way to use this frequency in a
; real note is to transpose the channel to a lower semitone.
;
; Rather than use a complete lookup table, other SMPS drivers such as
; Sonic 3's compute the octave, and only store a single octave's worth of
; notes in the table.
;
; Invalid transposition values will cause this table to be overflowed,
; resulting in garbage data being used as frequency values. In drivers that
; compute the octave instead, invalid transposition values merely cause the
; notes to wrap-around (the note below the lowest note will be the highest
; note). It's important to keep this in mind when porting buggy songs.
; ---------------------------------------------------------------------------
; word_72790: FM_Notes:
FMFrequencies:
		dc.w $025E,$0284,$02AB,$02D3,$02FE,$032D,$035C,$038F,$03C5,$03FF,$043C,$047C
		dc.w $0A5E,$0A84,$0AAB,$0AD3,$0AFE,$0B2D,$0B5C,$0B8F,$0BC5,$0BFF,$0C3C,$0C7C
		dc.w $125E,$1284,$12AB,$12D3,$12FE,$132D,$135C,$138F,$13C5,$13FF,$143C,$147C
		dc.w $1A5E,$1A84,$1AAB,$1AD3,$1AFE,$1B2D,$1B5C,$1B8F,$1BC5,$1BFF,$1C3C,$1C7C
		dc.w $225E,$2284,$22AB,$22D3,$22FE,$232D,$235C,$238F,$23C5,$23FF,$243C,$247C
		dc.w $2A5E,$2A84,$2AAB,$2AD3,$2AFE,$2B2D,$2B5C,$2B8F,$2BC5,$2BFF,$2C3C,$2C7C
		dc.w $325E,$3284,$32AB,$32D3,$32FE,$332D,$335C,$338F,$33C5,$33FF,$343C,$347C
		dc.w $3A5E,$3A84,$3AAB,$3AD3,$3AFE,$3B2D,$3B5C,$3B8F,$3BC5,$3BFF,$3C3C,$3C7C
; ---------------------------------------------------------------------------

PSGUpdateTrack:
		subq.b	#1,SMPS_Track.DurationTimeout(a5)
		bne.s	.noupdate
		bclr	#4,SMPS_Track.PlaybackControl(a5)
		jsr	PSGDoNext(pc)
		jsr	PSGDoNoteOn(pc)
		bra.w	PSGDoVolFX
; ---------------------------------------------------------------------------

.noupdate:
		jsr	NoteTimeoutUpdate(pc)
		jsr	PSGUpdateVolFX(pc)
		jsr	DoModulation(pc)
		jsr	PSGUpdateFreq(pc)
		rts
; ---------------------------------------------------------------------------

PSGDoNext:
		bclr	#1,SMPS_Track.PlaybackControl(a5)
		movea.l	SMPS_Track.DataPointer(a5),a4

.command:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	.notcommand
		jsr	CoordFlag(pc)
		bra.s	.command
; ---------------------------------------------------------------------------

.notcommand:
		tst.b	d5
		bpl.s	.duration
		jsr	LoadFreqPSG(pc)
		move.b	(a4)+,d5
		tst.b	d5
		bpl.s	.duration
		subq.w	#1,a4
		bra.w	FinishTrackUpdate
; ---------------------------------------------------------------------------

.duration:
		jsr	SetDuration(pc)
		bra.w	FinishTrackUpdate
; ---------------------------------------------------------------------------

LoadFreqPSG:
		subi.b	#$81,d5
		bcs.s	.duration
		add.b	SMPS_Track.Transpose(a5),d5
		andi.w	#$7F,d5
		lsl.w	#1,d5
		lea	PSGFrequencies(pc),a0
		move.w	(a0,d5.w),SMPS_Track.Freq(a5)
		bra.w	FinishTrackUpdate
; ---------------------------------------------------------------------------

.duration:
		bset	#1,SMPS_Track.PlaybackControl(a5)
		move.w	#-1,SMPS_Track.Freq(a5)
		jsr	FinishTrackUpdate(pc)
		bra.w	PSGNoteOff
; ---------------------------------------------------------------------------

PSGDoNoteOn:
		move.w	SMPS_Track.Freq(a5),d6
		bmi.s	dRestPSG

PSGUpdateFreq:
		move.b	SMPS_Track.Detune(a5),d0
		ext.w	d0
		add.w	d0,d6
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.s	.locret
		btst	#1,SMPS_Track.PlaybackControl(a5)
		bne.s	.locret
		move.b	SMPS_Track.VoiceControl(a5),d0
		cmpi.b	#$E0,d0
		bne.s	.nopsg4
		move.b	#$C0,d0

.nopsg4:
		move.w	d6,d1
		andi.b	#$F,d1
		or.b	d1,d0
		lsr.w	#4,d6
		andi.b	#$3F,d6
		move.b	d0,(psg_input).l
		move.b	d6,(psg_input).l

.locret:
		rts
; ---------------------------------------------------------------------------

dRestPSG:
		bset	#1,SMPS_Track.PlaybackControl(a5)
		rts
; ---------------------------------------------------------------------------

PSGUpdateVolFX:
		tst.b	SMPS_Track.VoiceIndex(a5)
		beq.w	SetPSGVolume.return

PSGDoVolFX:
		move.b	SMPS_Track.Volume(a5),d6
		moveq	#0,d0
		move.b	SMPS_Track.VoiceIndex(a5),d0
		beq.s	SetPSGVolume
		movea.l	(Go_PSGIndex).l,a0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a0,d0.w),a0
		move.b	SMPS_Track.VolEnvIndex(a5),d0
		move.b	(a0,d0.w),d0
		addq.b	#1,SMPS_Track.VolEnvIndex(a5)
		btst	#7,d0
		beq.s	.volume
		cmpi.b	#$83,d0
		beq.s	VolEnvCmd_Hold
		cmpi.b	#$85,d0
		beq.s	VolEnvCmd_Loop
		cmpi.b	#$80,d0
		beq.s	VolEnvCmd_Reset

.volume:
		add.w	d0,d6
		cmpi.b	#$10,d6
		bcs.s	SetPSGVolume
		moveq	#$F,d6

SetPSGVolume:
		btst	#1,SMPS_Track.PlaybackControl(a5)
		bne.s	.return
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.s	.return
		btst	#4,SMPS_Track.PlaybackControl(a5)
		bne.s	SetPSGVolume_ChkGate

.doit:
		or.b	SMPS_Track.VoiceControl(a5),d6
		addi.b	#$10,d6
		move.b	d6,(psg_input).l

.return:
		rts
; ---------------------------------------------------------------------------

SetPSGVolume_ChkGate:
		tst.b	SMPS_Track.NoteTimeoutMaster(a5)
		beq.s	SetPSGVolume.doit
		tst.b	SMPS_Track.NoteTimeout(a5)
		bne.s	SetPSGVolume.doit
		rts
; ---------------------------------------------------------------------------

VolEnvCmd_Hold:
		subq.b	#1,SMPS_Track.VolEnvIndex(a5)
		rts
; ---------------------------------------------------------------------------

VolEnvCmd_Loop:
		move.b	SMPS_Track.VoiceControl(a0,d0.w),SMPS_Track.VolEnvIndex(a5)
		bra.w	PSGDoVolFX
; ---------------------------------------------------------------------------

VolEnvCmd_Reset:
		clr.b	SMPS_Track.VolEnvIndex(a5)
		bra.w	PSGDoVolFX
; ---------------------------------------------------------------------------

PSGNoteOff:
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.s	locret_750DE

SendPSGNoteOff:
		move.b	SMPS_Track.VoiceControl(a5),d0
		ori.b	#$1F,d0
		move.b	d0,(psg_input).l
	if FixBugs
		; This is the same fix that S&K's driver uses:
		cmpi.b	#$DF,d0				; Are stopping PSG3?
		bne.s	locret_750DE
		move.b	#$FF,(psg_input).l		; If so, stop noise channel while we're at it
	else
		; DANGER! If InitMusicPlayback doesn't silence all channels, there's the
		; risk of music accidentally playing noise because it can't detect if
		; the PSG4/noise channel needs muting on track initialisation.
	endif

locret_750DE:
		rts
; ---------------------------------------------------------------------------

PSGSilenceAll:
		lea	(psg_input).l,a0
		move.b	#$9F,(a0)
		move.b	#$BF,(a0)
		move.b	#$DF,(a0)
		move.b	#$FF,(a0)
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; PSG Note Values: c-1 to a-6
;
; Each row is an octave, starting with C and ending with B. Sonic 3's driver
; adds another octave at the start, as well as two more notes and the end to
; complete the last octave. Notably, a-6 is changed from 0 to $10. These
; changes need to be applied here in order for ports of songs from Sonic 3
; and later to sound correct.
;
; Here is what Sonic 3's version of this table looks like:
;	dc.w $3FF, $3FF, $3FF, $3FF, $3FF, $3FF, $3FF, $3FF, $3FF, $3F7, $3BE, $388
;	dc.w $356, $326, $2F9, $2CE, $2A5, $280, $25C, $23A, $21A, $1FB, $1DF, $1C4
;	dc.w $1AB, $193, $17D, $167, $153, $140, $12E, $11D, $10D,	$FE,  $EF,	$E2
;	dc.w  $D6,	$C9,  $BE,	$B4,  $A9,	$A0,  $97,	$8F,  $87,	$7F,  $78,	$71
;	dc.w  $6B,	$65,  $5F,	$5A,  $55,	$50,  $4B,	$47,  $43,	$40,  $3C,	$39
;	dc.w  $36,	$33,  $30,	$2D,  $2B,	$28,  $26,	$24,  $22,	$20,  $1F,	$1D
;	dc.w  $1B,	$1A,  $18,	$17,  $16,	$15,  $13,	$12,  $11,	$10,	0,    0
; ---------------------------------------------------------------------------
PSGFrequencies:
		dc.w $356, $326, $2F9, $2CE, $2A5, $280, $25C, $23A, $21A, $1FB, $1DF, $1C4
		dc.w $1AB, $193, $17D, $167, $153, $140, $12E, $11D, $10D,	$FE,  $EF,	$E2
		dc.w  $D6,	$C9,  $BE,	$B4,  $A9,	$A0,  $97,	$8F,  $87,	$7F,  $78,	$71
		dc.w  $6B,	$65,  $5F,	$5A,  $55,	$50,  $4B,	$47,  $43,	$40,  $3C,	$39
		dc.w  $36,	$33,  $30,	$2D,  $2B,	$28,  $26,	$24,  $22,	$20,  $1F,	$1D
		dc.w  $1B,	$1A,  $18,	$17,  $16,	$15,  $13,	$12,  $11,	0
; ---------------------------------------------------------------------------

CoordFlag:
		subi.w	#$E0,d5
		lsl.w	#2,d5
		jmp	.commands(pc,d5.w)
; ---------------------------------------------------------------------------

.commands:
		bra.w	cfE0_Pan			; E0
; ---------------------------------------------------------------------------
		bra.w	cfE1_Detune			; E1
; ---------------------------------------------------------------------------
		bra.w	cfE2_SetComm		; E2
; ---------------------------------------------------------------------------
		bra.w	cfE3_GlobalMod		; E3
; ---------------------------------------------------------------------------
		bra.w	cfFadeInToPrevious	; E4
; ---------------------------------------------------------------------------
		bra.w	cfChangePFMVolume	; E5
; ---------------------------------------------------------------------------
		bra.w	cfChangeFMVolume	; E6
; ---------------------------------------------------------------------------
		bra.w	cfHoldNote			; E7
; ---------------------------------------------------------------------------
		bra.w	cfNoteTimeout		; E8
; ---------------------------------------------------------------------------
		bra.w	cfSetLFO			; E9
; ---------------------------------------------------------------------------
		bra.w	cfSetTempo			; EA
; ---------------------------------------------------------------------------
		bra.w	cfSetSoundqueue		; EB
; ---------------------------------------------------------------------------
		bra.w	cfChangePSGVolume	; EC
; ---------------------------------------------------------------------------
		bra.w	cfClearPush			; ED
; ---------------------------------------------------------------------------
		bra.w	dcYM1				; EE
; ---------------------------------------------------------------------------
		bra.w	cfSetVoice			; EF
; ---------------------------------------------------------------------------
		bra.w	cfModulation		; F0
; ---------------------------------------------------------------------------
		bra.w	cfEnableModulation	; F1
; ---------------------------------------------------------------------------
		bra.w	cfStopTrack			; F2
; ---------------------------------------------------------------------------
		bra.w	cfSetPSGNoise		; F3
; ---------------------------------------------------------------------------
		bra.w	cfDisableModulation	; F4
; ---------------------------------------------------------------------------
		bra.w	cfSetPSGTone		; F5
; ---------------------------------------------------------------------------
		bra.w	cfJumpTo			; F6
; ---------------------------------------------------------------------------
		bra.w	cfRepeatAtPos		; F7
; ---------------------------------------------------------------------------
		bra.w	cfJumpToGosub		; F8
; ---------------------------------------------------------------------------
		bra.w	cfJumpReturn		; F9
; ---------------------------------------------------------------------------
		bra.w	cfSetTempoDivider	; FA
; ---------------------------------------------------------------------------
		bra.w	cfChangeTransposition	; FB
; ---------------------------------------------------------------------------
		bra.w	cfSetTempoDividerAll	; FC
; ---------------------------------------------------------------------------
		bra.w	cfStopSpecialFM4	; FD
; ---------------------------------------------------------------------------
		bra.w	cfFE_SpcFM3Mode		; FE
; ---------------------------------------------------------------------------
		moveq	#0,d0				; FF
		move.b	(a4)+,d0
		lsl.w	#2,d0
		jmp	cfMetaJumpTable(pc,d0.w)
; ---------------------------------------------------------------------------

cfMetaJumpTable:
		bra.w	cfSSG_Reg			; 00
; ---------------------------------------------------------------------------
		bra.w	cfSSG_Reg			; 01
; ---------------------------------------------------------------------------

cfE0_Pan:
		move.b	(a4)+,d1
		tst.b	SMPS_Track.VoiceControl(a5)
		bmi.s	.locret
		move.b	SMPS_Track.AMSFMSPan(a5),d0
		andi.b	#$37,d0
		or.b	d0,d1
		move.b	d1,SMPS_Track.AMSFMSPan(a5)
		move.b	#$B4,d0
		bra.w	WriteFMIorIIMain
; ---------------------------------------------------------------------------

.locret:
		rts
; ---------------------------------------------------------------------------

cfE1_Detune:
		move.b	(a4)+,SMPS_Track.Detune(a5)
		rts
; ---------------------------------------------------------------------------

cfE2_SetComm:
		move.b	(a4)+,SMPS_RAM.v_communication_byte(a6)
		rts
; ---------------------------------------------------------------------------

cfE3_GlobalMod:
		movea.l	(Go_Modulation).l,a0	; Get global modulation index
		moveq	#0,d0	; Clear high bit of d0
		move.b	(a4)+,d0	; Move first byte into d0
		subq.b	#1,d0	; Subtract 1 from d0
		lsl.w	#2,d0	; Multiply by 4
		adda.w	d0,a0	; Add d0 to the modulation index
		bset	#3,SMPS_Track.PlaybackControl(a5)	; Enable modulation
		move.l	a0,SMPS_Track.ModulationPtr(a5)	; Save pointer to modulation data
		move.b	(a0)+,SMPS_Track.ModulationWait(a5)	; Modulation delay
		move.b	(a0)+,SMPS_Track.ModulationSpeed(a5)	; Modulation speed
		move.b	(a0)+,SMPS_Track.ModulationDelta(a5)	; Modulation delta
		move.b	(a0)+,d0	; Modulation steps...
		lsr.b	#1,d0	; ... divided by 2...
		move.b	d0,SMPS_Track.ModulationSteps(a5)	; ... before being stored
		clr.w	SMPS_Track.ModulationVal(a5)	; Total accumulated modulation frequency change
		rts
; ---------------------------------------------------------------------------

; loc_7527A:
cfFadeInToPrevious:
		movea.l	a6,a0
		lea	SMPS_RAM.v_1up_ram_copy(a6),a1
		move.w	#bytesToLcnt(SMPS_RAM.v_1up_ram_end-SMPS_RAM.v_1up_ram),d0 ; $220 bytes to restore: all variables and music track data
; loc_75284:
.restoreramloop:
		move.l	(a1)+,(a0)+
		dbf	d0,.restoreramloop

		bset	#2,SMPS_RAM.v_music_dac_track+SMPS_Track.PlaybackControl(a6)
		movea.l	a5,a3
		move.b	#$28,d6
		sub.b	SMPS_RAM.v_fadein_counter(a6),d6		; If fade already in progress, this adjusts track volume accordingly
		moveq	#SMPS_MUSIC_FM_TRACK_COUNT-1,d7 ; 6 FM tracks
		lea	SMPS_RAM.v_music_fm_tracks(a6),a5

loc_752A0:
		btst	#7,SMPS_Track.PlaybackControl(a5)
		beq.s	loc_752C2
		bset	#1,SMPS_Track.PlaybackControl(a5)
		add.b	d6,SMPS_Track.Volume(a5)
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.s	loc_752C2
		moveq	#0,d0
		move.b	SMPS_Track.VoiceIndex(a5),d0		; Get voice
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; Voice pointer
		jsr	SetVoice(pc)

loc_752C2:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,loc_752A0

		moveq	#SMPS_MUSIC_PSG_TRACK_COUNT-1,d7 ; 3 PSG tracks

loc_752CC:
		btst	#7,SMPS_Track.PlaybackControl(a5)
		beq.s	loc_752DE
		bset	#1,SMPS_Track.PlaybackControl(a5)
		jsr	PSGNoteOff(pc)
		add.b	d6,SMPS_Track.Volume(a5)		; Apply current volume fade-in

loc_752DE:
		adda.w	#SMPS_Track.len,a5
		dbf	d7,loc_752CC

		movea.l	a3,a5
		move.b	#$80,SMPS_RAM.f_fadein_flag(a6)		; Trigger fade-in
		move.b	#$28,SMPS_RAM.v_fadein_counter(a6)	; Fade-in delay
		clr.b	SMPS_RAM.f_1up_playing(a6)
		addq.w	#8,sp				; Tamper return value so we don't return to caller
		rts
; ---------------------------------------------------------------------------

dcSilence:
		jsr	FMSilenceAll_Special(pc)
		bra.w	cfStopTrack
; ---------------------------------------------------------------------------

dcPanAni:
		move.b	(a4)+,SMPS_Track.PanNumber(a5)
		beq.s	.disable
		move.b	(a4)+,SMPS_Track.PanTable(a5)
		move.b	(a4)+,SMPS_Track.PanStart(a5)
		move.b	(a4)+,SMPS_Track.PanLimit(a5)
		move.b	(a4),SMPS_Track.PanLength(a5)
		move.b	(a4)+,SMPS_Track.PanContinue(a5)
		rts
; ---------------------------------------------------------------------------

.disable:
		move.b	#$B4,d0
		move.b	SMPS_Track.AMSFMSPan(a5),d1
		bra.w	WriteFMIorIIMain
; ---------------------------------------------------------------------------

cfChangePFMVolume:
		move.b	(a4)+,d0
		tst.b	SMPS_Track.VoiceControl(a5)
		bpl.s	cfChangeFMVolume
		add.b	d0,SMPS_Track.Volume(a5)
		addq.w	#1,a4
		rts
; ---------------------------------------------------------------------------

cfChangeFMVolume:
		move.b	(a4)+,d0
		add.b	d0,SMPS_Track.Volume(a5)
		bra.w	SendVoiceTL
; ---------------------------------------------------------------------------

cfHoldNote:
		bset	#4,SMPS_Track.PlaybackControl(a5)
		rts
; ---------------------------------------------------------------------------

cfNoteTimeout:
		move.b	(a4),SMPS_Track.NoteTimeout(a5)
		move.b	(a4)+,SMPS_Track.NoteTimeoutMaster(a5)
		rts
; ---------------------------------------------------------------------------

cfSetLFO:
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1
		beq.s	.lfo_ss
		movea.l	SMPS_RAM.v_lfo_voice_ptr(a6),a1

.lfo_ss:
		move.b	(a4),d3				; d3 = slot data
		adda.w	#9,a0				; a0 = DR1 addr
		lea	LFO_Reg_Table(pc),a2
		moveq	#LFO_Reg_Table_End-LFO_Reg_Table-1,d6 ; loop time

.lfo_loop:
		move.b	(a1)+,d1			; d1 = DR data
		move.b	(a2)+,d0			; d0 = DR reg.
		btst	#7,d3				; if slot bit data = 0
		beq.s	.lfo_not			; then not write
		bset	#7,d1				; AMON on
		jsr	WriteFMIorIIMain(pc)		; DR write

.lfo_not:
		lsl.w	#1,d3
		dbf	d6,.lfo_loop
		move.b	(a4)+,d1			; lfo data get
		moveq	#$22,d0				; FM reg
		jsr	WriteFMI(pc)
		move.b	(a4)+,d1			; d1 = ams,pms data
		move.b	SMPS_Track.AMSFMSPan(a5),d0	; d0 = pan data
		andi.b	#$C0,d0				; lr data get
		or.b	d0,d1				; d1 = lr,ams,pms data
		move.b	d1,SMPS_Track.AMSFMSPan(a5)	; pan data store
		move.b	#$B4,d0				; d0 = pan registor
		bra.w	WriteFMIorIIMain
; ---------------------------------------------------------------------------

LFO_Reg_Table:	dc.b $60, $68, $64, $6C
LFO_Reg_Table_End
; ---------------------------------------------------------------------------

cfSetTempo:
		move.b	(a4),SMPS_RAM.v_main_tempo(a6)
		move.b	(a4)+,SMPS_RAM.v_main_tempo_timeout(a6)
		rts
; ---------------------------------------------------------------------------

cfSetSoundqueue:
		move.b	(a4)+,SMPS_RAM.v_soundqueue0(a6)
		rts
; ---------------------------------------------------------------------------

cfChangePSGVolume:
		move.b	(a4)+,d0
		add.b	d0,SMPS_Track.Volume(a5)
		rts
; ---------------------------------------------------------------------------

cfClearPush:
		move.b	#0,SMPS_RAM.f_push_playing(a6)
		rts
; ---------------------------------------------------------------------------

dcYM1:
		move.b	(a4)+,d0
		move.b	(a4)+,d1
		bra.w	WriteFMI
; ---------------------------------------------------------------------------

cfSetVoice:
		moveq	#0,d0
		move.b	(a4)+,d0
		move.b	d0,SMPS_Track.VoiceIndex(a5)
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.w	locret_75454
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1
		tst.b	SMPS_RAM.f_voice_selector(a6)
		beq.s	SetVoice
		movea.l	SMPS_RAM.v_lfo_voice_ptr(a6),a1
		tst.b	SMPS_RAM.f_voice_selector(a6)
		bmi.s	SetVoice
		movea.l	SMPS_RAM.v_special_voice_ptr(a6),a1

SetVoice:
		subq.w	#1,d0
		bmi.s	.havevoiceptr
		move.w	#25,d1

.voicemultiply:
		adda.w	d1,a1
		dbf	d0,.voicemultiply

.havevoiceptr:
		move.b	(a1)+,d1			; feedback/algorithm
		move.b	d1,SMPS_Track.FeedbackAlgo(a5)	; Save it to track RAM
		move.b	d1,d4
		move.b	#$B0,d0				; Command to write feedback/algorithm
		jsr	WriteFMIorII(pc)
		lea	FMInstrumentOperatorTable(pc),a2
		moveq	#FMInstrumentOperatorTable_End-FMInstrumentOperatorTable-1,d3 ; Don't want to send TL yet

.sendvoiceloop:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		jsr	WriteFMIorII(pc)
		dbf	d3,.sendvoiceloop

		moveq	#FMInstrumentTLTable_End-FMInstrumentTLTable-1,d5
		andi.w	#FMSlotMask_End-FMSlotMask-1,d4	; Get algorithm
		move.b	FMSlotMask(pc,d4.w),d4		; Get slot mask for algorithm
		move.b	SMPS_Track.Volume(a5),d3		; Track volume attenuation

.sendtlloop:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4				; Is bit set for this operator in the mask?
		bcc.s	.sendtl				; Branch if not
		add.b	d3,d1				; Include additional attenuation

.sendtl:
		jsr	WriteFMIorII(pc)
		dbf	d5,.sendtlloop

		move.b	#$B4,d0				; Register for AMS/FMS/Panning
		move.b	SMPS_Track.AMSFMSPan(a5),d1		; Value to send
		jsr	WriteFMIorII(pc)

locret_75454:
		rts
; ---------------------------------------------------------------------------

FMSlotMask:	dc.b 8,	8, 8, 8, $A, $E, $E, $F
FMSlotMask_End
; ---------------------------------------------------------------------------

SendVoiceTL:
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.s	.locret
		moveq	#0,d0
		move.b	SMPS_Track.VoiceIndex(a5),d0		; Current voice
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; Voice pointer
		tst.b	SMPS_RAM.f_voice_selector(a6)
		beq.s	.gotvoiceptr
		movea.l	SMPS_RAM.v_lfo_voice_ptr(a6),a1
		tst.b	SMPS_RAM.f_voice_selector(a6)
		bmi.s	.gotvoiceptr
		movea.l	SMPS_RAM.v_special_voice_ptr(a6),a1

.gotvoiceptr:
		subq.w	#1,d0
		bmi.s	.gotvoice
		move.w	#25,d1

.voicemultiply:
		adda.w	d1,a1
		dbf	d0,.voicemultiply

.gotvoice:
		adda.w	#21,a1				; Want TL
		lea	FMInstrumentTLTable(pc),a2
		move.b	SMPS_Track.FeedbackAlgo(a5),d0	; Get feedback/algorithm
		andi.w	#FMSlotMask_End-FMSlotMask-1,d0	; Want only algorithm
		move.b	FMSlotMask(pc,d0.w),d4		; Get slot mask
		move.b	SMPS_Track.Volume(a5),d3		; Get track volume attenuation
		bmi.s	.locret				; If negative, stop
		moveq	#FMInstrumentTLTable_End-FMInstrumentTLTable-1,d5

.sendtlloop:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4				; Is bit set for this operator in the mask?
		bcc.s	.senttl				; Branch if not
		add.b	d3,d1				; Include additional attenuation
		bcs.s	.senttl				; Branch on overflow
		jsr	WriteFMIorII(pc)

.senttl:
		dbf	d5,.sendtlloop

.locret:
		rts
; ---------------------------------------------------------------------------

FMInstrumentOperatorTable:
		dc.b  $30				; Detune/multiple operator 1
		dc.b  $38				; Detune/multiple operator 3
		dc.b  $34				; Detune/multiple operator 2
		dc.b  $3C				; Detune/multiple operator 4
		dc.b  $50				; Rate scalling/attack rate operator 1
		dc.b  $58				; Rate scalling/attack rate operator 3
		dc.b  $54				; Rate scalling/attack rate operator 2
		dc.b  $5C				; Rate scalling/attack rate operator 4
		dc.b  $60				; Amplitude modulation/first decay rate operator 1
		dc.b  $68				; Amplitude modulation/first decay rate operator 3
		dc.b  $64				; Amplitude modulation/first decay rate operator 2
		dc.b  $6C				; Amplitude modulation/first decay rate operator 4
		dc.b  $70				; Secondary decay rate operator 1
		dc.b  $78				; Secondary decay rate operator 3
		dc.b  $74				; Secondary decay rate operator 2
		dc.b  $7C				; Secondary decay rate operator 4
		dc.b  $80				; Secondary amplitude/release rate operator 1
		dc.b  $88				; Secondary amplitude/release rate operator 3
		dc.b  $84				; Secondary amplitude/release rate operator 2
		dc.b  $8C				; Secondary amplitude/release rate operator 4
FMInstrumentOperatorTable_End

FMInstrumentTLTable:
		dc.b  $40				; Total level operator 1
		dc.b  $48				; Total level operator 3
		dc.b  $44				; Total level operator 2
		dc.b  $4C				; Total level operator 4
FMInstrumentTLTable_End
; ---------------------------------------------------------------------------

cfModulation:
		bset	#3,SMPS_Track.PlaybackControl(a5)	; Turn on modulation
		move.l	a4,SMPS_Track.ModulationPtr(a5)	; Save pointer to modulation data
		move.b	(a4)+,SMPS_Track.ModulationWait(a5)	; Modulation delay
		move.b	(a4)+,SMPS_Track.ModulationSpeed(a5)	; Modulation speed
		move.b	(a4)+,SMPS_Track.ModulationDelta(a5)	; Modulation delta
		move.b	(a4)+,d0			; Modulation steps...
		lsr.b	#1,d0				; ... divided by 2...
		move.b	d0,SMPS_Track.ModulationSteps(a5)	; ... before being stored
		clr.w	SMPS_Track.ModulationVal(a5)		; Total accumulated modulation frequency change
		rts
; ---------------------------------------------------------------------------

cfEnableModulation:
		bset	#3,SMPS_Track.PlaybackControl(a5)	; Turn on modulation
		rts
; ---------------------------------------------------------------------------

cfStopTrack:
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; Stop track
		bclr	#4,SMPS_Track.PlaybackControl(a5)	; Clear 'do not attack next note' bit
		tst.b	SMPS_Track.VoiceControl(a5)
		bmi.s	.psg
		tst.b	SMPS_RAM.f_updating_dac(a6)
		bmi.w	.exit
		jsr	FMNoteOff(pc)
		bra.s	.checksfx
; ---------------------------------------------------------------------------

.psg:
		jsr	PSGNoteOff(pc)

.checksfx:
		tst.b	SMPS_RAM.f_voice_selector(a6)
		bpl.w	.exit
		_clr.b	SMPS_RAM.v_sndprio(a6)
		moveq	#0,d0
		move.b	SMPS_Track.VoiceControl(a5),d0
		bmi.s	.getpsg
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	a5,a3
		cmpi.b	#4,d0
		bne.s	.getfm
		tst.b	SMPS_RAM.v_spcsfx_fm4_track+SMPS_Track.PlaybackControl(a6)
		bpl.s	.getfm
		lea	SMPS_RAM.v_spcsfx_fm4_track(a6),a5
		movea.l	SMPS_RAM.v_special_voice_ptr(a6),a1
		bra.s	.voice
; ---------------------------------------------------------------------------

.getfm:
		subq.b	#2,d0
		lsl.b	#2,d0
		movea.l	(a0,d0.w),a5
		tst.b	SMPS_Track.PlaybackControl(a5)
		bpl.s	.checkfm3
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1

.voice:
		bclr	#2,SMPS_Track.PlaybackControl(a5)
		bset	#1,SMPS_Track.PlaybackControl(a5)
	if FixBugs
		moveq	#0,d0
	else
		; Bug: The low bit is not cleared here
	endif
		move.b	SMPS_Track.VoiceIndex(a5),d0
		jsr	SetVoice(pc)

.checkfm3:
		movea.l	a3,a5
		cmpi.b	#2,SMPS_Track.VoiceControl(a5)
		bne.s	.exit
		clr.b	SMPS_RAM.v_se_mode_flag(a6)
		moveq	#0,d1
		moveq	#$27,d0
		jsr	WriteFMI(pc)
		bra.s	.exit
; ---------------------------------------------------------------------------

.getpsg:
		lea	SMPS_RAM.v_spcsfx_psg3_track(a6),a0
		tst.b	SMPS_Track.PlaybackControl(a0)
		bpl.s	.normalpsg
		cmpi.b	#$E0,d0
		beq.s	.unint
		cmpi.b	#$C0,d0
		beq.s	.unint

.normalpsg:
		lea	SFX_BGMChannelRAM(pc),a0
		lsr.b	#3,d0
		movea.l	(a0,d0.w),a0

.unint:
		bclr	#2,SMPS_Track.PlaybackControl(a0)
		bset	#1,SMPS_Track.PlaybackControl(a0)
		cmpi.b	#$E0,SMPS_Track.VoiceControl(a0)
		bne.s	.exit
		move.b	SMPS_Track.PSGNoise(a0),(psg_input).l

.exit:
		addq.w	#8,sp
		rts
; ---------------------------------------------------------------------------

cfSetPSGNoise:
		move.b	#$E0,SMPS_Track.VoiceControl(a5)
		move.b	(a4)+,SMPS_Track.PSGNoise(a5)
		btst	#2,SMPS_Track.PlaybackControl(a5)
		bne.s	.locret
		move.b	-1(a4),(psg_input).l

.locret:
		rts
; ---------------------------------------------------------------------------

cfDisableModulation:
		bclr	#3,SMPS_Track.PlaybackControl(a5)	; Disable modulation
		rts
; ---------------------------------------------------------------------------

cfSetPSGTone:
		move.b	(a4)+,SMPS_Track.VoiceIndex(a5)	; Set current PSG tone
		rts
; ---------------------------------------------------------------------------

cfJumpTo:
		move.b	(a4)+,d0			; High byte of offset
		lsl.w	#8,d0				; Shift it into place
		move.b	(a4)+,d0			; Low byte of offset
		adda.w	d0,a4				; Add to current position
		subq.w	#1,a4				; Put back one byte
		rts
; ---------------------------------------------------------------------------

cfRepeatAtPos:
		moveq	#0,d0
		move.b	(a4)+,d0
		move.b	(a4)+,d1
		tst.b	SMPS_Track.LoopCounters(a5,d0.w)
		bne.s	.noreset
		move.b	d1,SMPS_Track.LoopCounters(a5,d0.w)

.noreset:
		subq.b	#1,SMPS_Track.LoopCounters(a5,d0.w)
		bne.s	cfJumpTo
		addq.w	#2,a4
		rts
; ---------------------------------------------------------------------------

cfJumpToGosub:
		moveq	#0,d0
		move.b	SMPS_Track.StackPointer(a5),d0
		subq.b	#4,d0
		move.l	a4,(a5,d0.w)
		move.b	d0,SMPS_Track.StackPointer(a5)
		bra.s	cfJumpTo
; ---------------------------------------------------------------------------

cfJumpReturn:
		moveq	#0,d0
		move.b	SMPS_Track.StackPointer(a5),d0	; Track stack pointer
		movea.l	(a5,d0.w),a4			; Set track return address
		addq.w	#2,a4				; Skip jump target address from gosub flag
		addq.b	#4,d0				; Actually 'pop' value
		move.b	d0,SMPS_Track.StackPointer(a5)	; Set new stack pointer
		rts
; ---------------------------------------------------------------------------

cfSetTempoDivider:
		move.b	(a4)+,SMPS_Track.TempoDivider(a5)
		rts
; ---------------------------------------------------------------------------

cfChangeTransposition:
		move.b	(a4)+,d0
		add.b	d0,SMPS_Track.Transpose(a5)
		rts
; ---------------------------------------------------------------------------

cfSetTempoDividerAll:
		lea	SMPS_RAM.v_music_track_ram(a6),a0
		move.b	(a4)+,d0			; Get new tempo divider
		moveq	#SMPS_Track.len,d1
		moveq	#SMPS_MUSIC_TRACK_COUNT-1,d2 ; 1 DAC + 6 FM + 3 PSG tracks

.trackloop:
		move.b	d0,SMPS_Track.TempoDivider(a0)	; Set track's tempo divider
		adda.w	d1,a0
		dbf	d2,.trackloop
		rts
; ---------------------------------------------------------------------------

cfStopSpecialFM4:
		bclr	#7,SMPS_Track.PlaybackControl(a5)	; Stop track
		bclr	#4,SMPS_Track.PlaybackControl(a5)	; Clear 'do not attack next note' bit
		jsr	FMNoteOff(pc)
		tst.b	SMPS_RAM.v_sfx_fm4_track+SMPS_Track.PlaybackControl(a6) ; Is SFX using FM4?
		bmi.s	.locexit			; Branch if yes
		movea.l	a5,a3
		lea	SMPS_RAM.v_music_fm4_track(a6),a5
		movea.l	SMPS_RAM.v_voice_ptr(a6),a1		; Voice pointer
		bclr	#2,SMPS_Track.PlaybackControl(a5)	; Clear 'SFX is overriding' bit
		bset	#1,SMPS_Track.PlaybackControl(a5)	; Set 'track at rest' bit
	if FixBugs
		moveq	#0,d0
	else
		; Bug: The low bit is not cleared here
	endif
		move.b	SMPS_Track.VoiceIndex(a5),d0		; Current voice
		jsr	SetVoice(pc)
		movea.l	a3,a5

.locexit:
		addq.w	#8,sp				; Tamper with return value so we don't return to caller
		rts
; ---------------------------------------------------------------------------

cfFE_SpcFM3Mode:
		lea	SMPS_RAM.v_detune_start(a6),a0
		moveq	#SMPS_RAM.v_detune_end-SMPS_RAM.v_detune_start-1,d0

.clear:
		move.b	(a4)+,(a0)+
		dbf	d0,.clear
		move.b	#$80,SMPS_RAM.v_se_mode_flag(a6)
		move.b	#$27,d0
		moveq	#$40,d1
		bra.w	WriteFMI
; ---------------------------------------------------------------------------

cfSSG_Reg:
		lea	SSG_Reg_Table(pc),a1
		moveq	#bytesToWcnt(SSG_Reg_Table_End-SSG_Reg_Table),d3

.loop:
		move.b	(a1)+,d0
		move.b	(a4)+,d1
		bset	#3,d1
		jsr	WriteFMIorIIMain(pc)
		move.b	(a1)+,d0
		moveq	#$1F,d1
		jsr	WriteFMIorIIMain(pc)
		dbf	d3,.loop
		rts
; ---------------------------------------------------------------------------

SSG_Reg_Table:	dc.b $90, $50
		dc.b $98, $58
		dc.b $94, $54
		dc.b $9C, $5C
SSG_Reg_Table_End

DACDriver:	include	"sound/z80.asm"
DACDriver_End
; ---------------------------------------------------------------------------
; SMPS2ASM - A collection of macros that make SMPS's bytecode human-readable.
; ---------------------------------------------------------------------------
FixMusicAndSFXDataBugs = FixBugs
SonicDriverVer = 1 ; Tell SMPS2ASM that we're using Sonic 1's driver.
		include "sound/_smps2asm_inc.asm"

Music81:	include	"sound/music/Mus81 - GHZ.asm"
		even
Music82:	include	"sound/music/Mus82 - LZ.asm"
		even
Music83:	include	"sound/music/Mus83 - MZ.asm"
		even
Music84:	include	"sound/music/Mus84 - SLZ.asm"
		even
Music85:	include	"sound/music/Mus85 - SZ.asm"
		even
Music86:	include	"sound/music/Mus86 - CWZ.asm"
		even
Music87:	include	"sound/music/Mus87 - Invincibility.asm"
		even
Music88:	include	"sound/music/Mus88 - Extra Life.asm"
		even
Music89:	include	"sound/music/Mus89 - Special Stage.asm"
		even
Music8A:	include	"sound/music/Mus8A - Title Screen.asm"
		even
Music8B:	include	"sound/music/Mus8B - Ending.asm"
		even
Music8C:	include	"sound/music/Mus8C - Boss.asm"
		even
Music8D:	include	"sound/music/Mus8D - FZ.asm"
		even
Music8E:	include	"sound/music/Mus8E - Sonic Got Through.asm"
		even
Music8F:	include	"sound/music/Mus8F - Game Over.asm"
		even
Music90:	include	"sound/music/Mus90 - Continue Screen.asm"
		even
Music91:	include	"sound/music/Mus91 - Credits.asm"
		even
; ---------------------------------------------------------------------------
; Sound	effect pointers
; ---------------------------------------------------------------------------
SoundIndex:
ptr_sndA0:	dc.l SoundA0
ptr_sndA1:	dc.l SoundA1
ptr_sndA2:	dc.l SoundA2
ptr_sndA3:	dc.l SoundA3
ptr_sndA4:	dc.l SoundA4
ptr_sndA5:	dc.l SoundA5
ptr_sndA6:	dc.l SoundA6
ptr_sndA7:	dc.l SoundA7
ptr_sndA8:	dc.l SoundA8
ptr_sndA9:	dc.l SoundA9
ptr_sndAA:	dc.l SoundAA
ptr_sndAB:	dc.l SoundAB
ptr_sndAC:	dc.l SoundAC
ptr_sndAD:	dc.l SoundAD
ptr_sndAE:	dc.l SoundAE
ptr_sndAF:	dc.l SoundAF
ptr_sndB0:	dc.l SoundB0
ptr_sndB1:	dc.l SoundB1
ptr_sndB2:	dc.l SoundB2
ptr_sndB3:	dc.l SoundB3
ptr_sndB4:	dc.l SoundB4
ptr_sndB5:	dc.l SoundB5
ptr_sndB6:	dc.l SoundB6
ptr_sndB7:	dc.l SoundB7
ptr_sndB8:	dc.l SoundB8
ptr_sndB9:	dc.l SoundB9
ptr_sndBA:	dc.l SoundBA
ptr_sndBB:	dc.l SoundBB
ptr_sndBC:	dc.l SoundBC
ptr_sndBD:	dc.l SoundBD
ptr_sndBE:	dc.l SoundBE
ptr_sndBF:	dc.l SoundBF
ptr_sndC0:	dc.l SoundC0
ptr_sndC1:	dc.l SoundC1
ptr_sndC2:	dc.l SoundC2
ptr_sndC3:	dc.l SoundC3
ptr_sndC4:	dc.l SoundC4
ptr_sndC5:	dc.l SoundC5
ptr_sndC6:	dc.l SoundC6
ptr_sndC7:	dc.l SoundC7
ptr_sndC8:	dc.l SoundC8
ptr_sndC9:	dc.l SoundC9
ptr_sndCA:	dc.l SoundCA
ptr_sndCB:	dc.l SoundCB
ptr_sndCC:	dc.l SoundCC
ptr_sndCD:	dc.l SoundCD
ptr_sndCE:	dc.l SoundCE
ptr_sndCF:	dc.l SoundCF
ptr_sndend:
; ---------------------------------------------------------------------------
; Special sound effect pointers
; ---------------------------------------------------------------------------
SpecSoundIndex:
ptr_sndD0:	dc.l SoundD0
ptr_sndD1:	dc.l SoundD1				; leftover from Michael Jackson's Moonwalker
ptr_sndD2:	dc.l SoundD2				; leftover from Michael Jackson's Moonwalker
ptr_specend:

SoundA0:	include "sound/sfx/SndA0 - Jump.asm"
		even
SoundA1:	include "sound/sfx/SndA1.asm"
		even
SoundA2:	include "sound/sfx/SndA2.asm"
		even
SoundA3:	include "sound/sfx/SndA3 - Death.asm"
		even
SoundA4:	include "sound/sfx/SndA4 - Skid.asm"
		even
SoundA5:	include "sound/sfx/SndA5.asm"
		even
SoundA6:	include "sound/sfx/SndA6 - Hit Spikes.asm"
		even
SoundA7:	include "sound/sfx/SndA7 - Push Block.asm"
		even
SoundA8:	include "sound/sfx/SndA8.asm"
		even
SoundA9:	include "sound/sfx/SndA9.asm"
		even
SoundAA:	include "sound/sfx/SndAA - Splash.asm"
		even
SoundAB:	include "sound/sfx/SndAB.asm"
		even
SoundAC:	include "sound/sfx/SndAC - Hit Boss.asm"
		even
SoundAD:	include "sound/sfx/SndAD.asm"
		even
SoundAE:	include "sound/sfx/SndAE - Fireball.asm"
		even
SoundAF:	include "sound/sfx/SndAF - Shield.asm"
		even
SoundB0:	include "sound/sfx/SndB0.asm"
		even
SoundB1:	include "sound/sfx/SndB1.asm"
		even
SoundB2:	include "sound/sfx/SndB2.asm"
		even
SoundB3:	include "sound/sfx/SndB3.asm"
		even
SoundB4:	include "sound/sfx/SndB4 - Bumper.asm"
		even
SoundB5:	include "sound/sfx/SndB5 - Ring.asm"
		even
SoundB6:	include "sound/sfx/SndB6 - Spikes Move.asm"
		even
SoundB7:	include "sound/sfx/SndB7 - Rumbling.asm"
		even
SoundB8:	include "sound/sfx/SndB8.asm"
		even
SoundB9:	include "sound/sfx/SndB9 - Collapse.asm"
		even
SoundBA:	include "sound/sfx/SndBA.asm"
		even
SoundBB:	include "sound/sfx/SndBB - Door.asm"
		even
SoundBC:	include "sound/sfx/SndBC - Teleport.asm"
		even
SoundBD:	include "sound/sfx/SndBD - ChainStomp.asm"
		even
SoundBE:	include "sound/sfx/SndBE - Roll.asm"
		even
SoundBF:	include "sound/sfx/SndBF.asm"
		even
SoundC0:	include "sound/sfx/SndC0 - Basaran Flap.asm"
		even
SoundC1:	include "sound/sfx/SndC1 - Break Item.asm"
		even
SoundC2:	include "sound/sfx/SndC2.asm"
		even
SoundC3:	include "sound/sfx/SndC3.asm"
		even
SoundC4:	include "sound/sfx/SndC4 - Bomb.asm"
		even
SoundC5:	include "sound/sfx/SndC5 - Cash Register.asm"
		even
SoundC6:	include "sound/sfx/SndC6 - Ring Loss.asm"
		even
SoundC7:	include "sound/sfx/SndC7 - Chain Rising.asm"
		even
SoundC8:	include "sound/sfx/SndC8 - Burning.asm"
		even
SoundC9:	include "sound/sfx/SndC9.asm"
		even
SoundCA:	include "sound/sfx/SndCA.asm"
		even
SoundCB:	include "sound/sfx/SndCB - Wall Smash.asm"
		even
SoundCC:	include "sound/sfx/SndCC - Spring.asm"
		even
SoundCD:	include "sound/sfx/SndCD - Switch.asm"
		even
SoundCE:	include "sound/sfx/SndCE - Ring Left Speaker.asm"
		even
SoundCF:	include "sound/sfx/SndCF - Signpost.asm"
		even
SoundD0:	include "sound/sfx/SndD0 - Waterfall.asm"
		even
SoundD1:	include "sound/sfx/SndD1.asm"
		even
SoundD2:	include "sound/sfx/SndD2.asm"
		even
SoundD3:	include "sound/sfx/SndD3.asm"
		even