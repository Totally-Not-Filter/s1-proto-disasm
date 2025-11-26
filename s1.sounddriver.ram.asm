	rsset	0
SMPS_Track.PlaybackControl:	rs.b	1	; All tracks
SMPS_Track.VoiceControl:	rs.b	1	; All tracks
SMPS_Track.TempoDivider:	rs.b	1	; All tracks
		rs.b	1	; Unused
SMPS_Track.DataPointer:	rs.l	1	; All tracks (4 bytes)
SMPS_Track.Transpose:		rs.b	1	; FM/PSG only (sometimes written to as a word, to include TrackVolume)
SMPS_Track.Volume:			rs.b	1	; FM/PSG only
SMPS_Track.AMSFMSPan:		rs.b	1	; FM/DAC only
SMPS_Track.VoiceIndex:		rs.b	1	; FM/PSG only
SMPS_Track.VolEnvIndex:	rs.b	1	; PSG only
SMPS_Track.StackPointer:	rs.b	1	; All tracks
SMPS_Track.DurationTimeout:	rs.b	1	; All tracks
SMPS_Track.SavedDuration:	rs.b	1	; All tracks
SMPS_Track.SavedDAC:		rs.b	0	; DAC only
SMPS_Track.Freq:			rs.w	1	; FM/PSG only (2 bytes)
SMPS_Track.NoteTimeout:	rs.b	1	; FM/PSG only
SMPS_Track.NoteTimeoutMaster:	rs.b	1	; FM/PSG only
SMPS_Track.ModulationPtr:	rs.l	1	; FM/PSG only (4 bytes)
SMPS_Track.ModulationWait:	rs.b	1	; FM/PSG only
SMPS_Track.ModulationSpeed:	rs.b	1	; FM/PSG only
SMPS_Track.ModulationDelta:	rs.b	1	; FM/PSG only
SMPS_Track.ModulationSteps:	rs.b	1	; FM/PSG only
SMPS_Track.ModulationVal:	rs.w	1	; FM/PSG only (2 bytes)
SMPS_Track.Detune:			rs.b	1	; FM/PSG only
SMPS_Track.PanNumber:		rs.b	1	; FM only
SMPS_Track.PanTable:		rs.b	1	; FM only
SMPS_Track.PanStart:		rs.b	1	; FM only
SMPS_Track.PanLimit:		rs.b	1	; FM only
SMPS_Track.PanLength:		rs.b	1	; FM only
SMPS_Track.PanContinue:	rs.b	1	; FM only
SMPS_Track.FeedbackAlgo:	rs.b	1	; FM only
SMPS_Track.PSGNoise:		rs.b	1	; PSG only
		rs.b	1	; Unused
SMPS_Track.LoopCounters:	rs.l	2	; All tracks (multiple bytes)
SMPS_Track.GoSubStack:		rs.b	0	; All tracks (multiple bytes. This label won't get to be used because of an optimisation that just uses SMPS_Track.len)
SMPS_Track:					rs.b	0
	rsreset

	rsset	0
SMPS_RAM.v_1up_ram:		rs.b	0
SMPS_RAM.v_sndprio:		rs.b	1	; sound priority (priority of new music/SFX must be higher or equal to this value or it won't play; bit 7 of priority being set prevents this value from changing)
SMPS_RAM.v_main_tempo_timeout:	rs.b	1	; Counts down to zero; when zero, resets to next value and delays song by 1 frame
SMPS_RAM.v_main_tempo:	rs.b	1	; Used for music only
SMPS_RAM.f_pausemusic:	rs.b	1	; flag set to stop music when paused
SMPS_RAM.v_fadeout_counter:	rs.b	1
		rs.b	1	; unused
SMPS_RAM.v_fadeout_delay:	rs.b	1
SMPS_RAM.v_communication_byte:	rs.b	1	; used in Ristar to sync with a boss' attacks; unused here
SMPS_RAM.f_updating_dac:	rs.b	1	; $80 if updating DAC, $00 otherwise
SMPS_RAM.v_sound_id:		rs.b	1	; sound or music copied from below
SMPS_RAM.v_soundqueue_start:	rs.b	0
SMPS_RAM.v_soundqueue0:	rs.b	1	; sound or music to play
SMPS_RAM.v_soundqueue1:	rs.b	1	; special sound to play
SMPS_RAM.v_soundqueue2:	rs.b	1	; unused sound to play
SMPS_RAM.v_soundqueue_end:	rs.b	0
		rs.b	1	; unused
SMPS_RAM.f_voice_selector:	rs.b	1	; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer
SMPS_RAM.v_se_mode_flag:	rs.b	1	; effect mode
SMPS_RAM.v_detune_start:	rs.b	0
SMPS_RAM.v_detune_freq1:	rs.w	1	; store slot 1 detune frequency (2 bytes)
SMPS_RAM.v_detune_freq2:	rs.w	1	; store slot 2 detune frequency (2 bytes)
SMPS_RAM.v_detune_freq3:	rs.w	1	; store slot 3 detune frequency (2 bytes)
SMPS_RAM.v_detune_freq4:	rs.w	1	; store slot 4 detune frequency (2 bytes)
SMPS_RAM.v_detune_end:	rs.b	0

SMPS_RAM.v_voice_ptr:	rs.l	1	; voice data pointer (4 bytes)
SMPS_RAM.v_lfo_voice_ptr:	rs.l	1	; lfo voice data pointer (4 bytes)
SMPS_RAM.v_special_voice_ptr:	rs.l	1	; voice data pointer for special SFX ($D0-$DF) (4 bytes)

SMPS_RAM.f_fadein_flag:	rs.b	1	; Flag for fade in
SMPS_RAM.v_fadein_delay:	rs.b	1
SMPS_RAM.v_fadein_counter:	rs.b	1	; Timer for fade in/out
SMPS_RAM.f_1up_playing:	rs.b	1	; flag indicating 1-up song is playing
SMPS_RAM.v_tempo_mod:	rs.b	1	; music - tempo modifier
SMPS_RAM.v_speeduptempo:	rs.b	1	; music - tempo modifier with speed shoes
SMPS_RAM.f_speedup:		rs.b	1	; flag indicating whether speed shoes tempo is on ($80) or off ($00)
SMPS_RAM.v_ring_speaker:	rs.b	1	; which speaker the "ring" sound is played in (00 = right; 01 = left)
SMPS_RAM.f_push_playing:	rs.b	1	; if set, prevents further push sounds from playing
		rs.b	$13	; unused
SMPS_RAM.v_track_ram:	rs.b	0
SMPS_RAM.v_music_track_ram:		rs.b	0		; Start of music RAM
SMPS_RAM.v_music_fmdac_tracks:	rs.b	0
SMPS_RAM.v_music_dac_track:		rs.b	SMPS_Track
SMPS_RAM.v_music_fm_tracks:		rs.b	0
SMPS_RAM.v_music_fm1_track:		rs.b	SMPS_Track
SMPS_RAM.v_music_fm2_track:		rs.b	SMPS_Track
SMPS_RAM.v_music_fm3_track:		rs.b	SMPS_Track
SMPS_RAM.v_music_fm4_track:		rs.b	SMPS_Track
SMPS_RAM.v_music_fm5_track:		rs.b	SMPS_Track
SMPS_RAM.v_music_fm6_track:		rs.b	SMPS_Track
SMPS_RAM.v_music_fm_tracks_end:	rs.b	0
SMPS_RAM.v_music_fmdac_tracks_end:	rs.b	0
SMPS_RAM.v_music_psg_tracks:	rs.b	0
SMPS_RAM.v_music_psg1_track:	rs.b	SMPS_Track
SMPS_RAM.v_music_psg2_track:	rs.b	SMPS_Track
SMPS_RAM.v_music_psg3_track:	rs.b	SMPS_Track
SMPS_RAM.v_music_psg_tracks_end:	rs.b	0
SMPS_RAM.v_music_track_ram_end:	rs.b	0
SMPS_RAM.v_1up_ram_end:	rs.b	0
SMPS_RAM.v_sfx_track_ram:		rs.b	0		; Start of SFX RAM, straight after the end of music RAM
SMPS_RAM.v_sfx_fm_tracks:		rs.b	0
SMPS_RAM.v_sfx_fm3_track:		rs.b	SMPS_Track
SMPS_RAM.v_sfx_fm4_track:		rs.b	SMPS_Track
SMPS_RAM.v_sfx_fm5_track:		rs.b	SMPS_Track
SMPS_RAM.v_sfx_fm_tracks_end:	rs.b	0
SMPS_RAM.v_sfx_psg_tracks:		rs.b	0
SMPS_RAM.v_sfx_psg1_track:		rs.b	SMPS_Track
SMPS_RAM.v_sfx_psg2_track:		rs.b	SMPS_Track
SMPS_RAM.v_sfx_psg3_track:		rs.b	SMPS_Track
SMPS_RAM.v_sfx_psg_tracks_end:	rs.b	0
SMPS_RAM.v_sfx_track_ram_end:	rs.b	0
SMPS_RAM.v_spcsfx_track_ram:	rs.b	0			; Start of special SFX RAM, straight after the end of SFX RAM
SMPS_RAM.v_spcsfx_fm_tracks:	rs.b	0
SMPS_RAM.v_spcsfx_fm4_track:	rs.b	SMPS_Track
SMPS_RAM.v_spcsfx_fm_tracks_end:	rs.b	0
SMPS_RAM.v_spcsfx_psg_tracks:	rs.b	0
SMPS_RAM.v_spcsfx_psg3_track:	rs.b	SMPS_Track
SMPS_RAM.v_spcsfx_psg_tracks_end:	rs.b	0
SMPS_RAM.v_spcsfx_track_ram_end:	rs.b	0
SMPS_RAM.v_track_ram_end:	rs.b	0

SMPS_RAM.v_1up_ram_copy:		rs.b	SMPS_RAM.v_1up_ram_end-SMPS_RAM.v_1up_ram
SMPS_RAM:	rs.b	0
	rsreset