		include	"s1.sounddriver.ram.asm"

; Variables (v) and Flags (f)

	rsset $FFFF0000
v_start:		rs.b 0
v_256x256:		rs.b $52*$200	; 256x256 tile mappings ($A400 bytes)
v_256x256_end:	rs.b 0

layoutsize:		= $40

v_lvllayout:	rs.b layoutsize*$10	; level layout buffer ($400 bytes)
v_lvllayoutbg:	= v_lvllayout+layoutsize
v_lvllayout_end:	rs.b 0

v_bgscroll_buffer:	rs.b $200
v_ngfx_buffer:	rs.b $200
v_ngfx_buffer_end:	rs.b 0
v_spritequeue:	rs.b $400
v_16x16:		rs.w 4*$300	; 16x16 tile mappings ($1800 bytes)
v_16x16_end:	rs.b 0
v_sgfx_buffer:	rs.b 23*tile_size	; sonic graphics ram buffer ($2E0 bytes)
v_sgfx_buffer_end:	rs.b 0
			rs.b $20	; unused
v_tracksonic:	rs.b $100	; sonic position table ($100 bytes)
v_hscrolltablebuffer:	rs.b $380
v_hscrolltablebuffer_end:	rs.b 0
			rs.b $80
v_hscrolltablebuffer_end_padded:	rs.b 0
v_objspace:		rs.b 0			; RAM for object space ($600 bytes)
v_objslot0:		rs.b obj.Size
v_objslot1:		rs.b obj.Size
v_objslot2:		rs.b obj.Size
v_objslot3:		rs.b obj.Size
v_objslot4:		rs.b obj.Size
v_objslot5:		rs.b obj.Size
v_objslot6:		rs.b obj.Size
v_objslot7:		rs.b obj.Size
v_objslot8:		rs.b obj.Size
v_objslot9:		rs.b obj.Size
v_objslotA:		rs.b obj.Size
v_objslotB:		rs.b obj.Size
v_objslotC:		rs.b obj.Size
v_objslotD:		rs.b obj.Size
v_objslotE:		rs.b obj.Size
v_objslotF:		rs.b obj.Size
v_objslot10:	rs.b obj.Size
v_objslot11:	rs.b obj.Size
v_objslot12:	rs.b obj.Size
v_objslot13:	rs.b obj.Size
v_objslot14:	rs.b obj.Size
v_objslot15:	rs.b obj.Size
v_objslot16:	rs.b obj.Size
v_objslot17:	rs.b obj.Size
v_objslot18:	rs.b obj.Size	; flag for victory animation (1 byte)
v_objslot19:	rs.b obj.Size
v_objslot1A:	rs.b obj.Size
v_objslot1B:	rs.b obj.Size
v_objslot1C:	rs.b obj.Size
v_objslot1D:	rs.b obj.Size
v_objslot1E:	rs.b obj.Size
v_objslot1F:	rs.b obj.Size

v_player:	= v_objslot0
v_hud:	= v_objslot1

v_lvlobjspace:	rs.b 0
	rept 96
			rs.b obj.Size
	endr
v_lvlobjend:	rs.b 0
v_objspace_end:	rs.b 0
; $FFFFF000
v_snddriver_ram:	rs.b	SMPS_RAM	; start of RAM for the sound driver data ($600 bytes)
v_snddriver_ram.v_soundqueue0:	equ v_snddriver_ram+SMPS_RAM.v_soundqueue0
v_snddriver_ram.v_soundqueue1:	equ v_snddriver_ram+SMPS_RAM.v_soundqueue1
v_snddriver_ram.v_soundqueue2:	equ v_snddriver_ram+SMPS_RAM.v_soundqueue2
v_snddriver_ram.v_music_fm3_track:	equ v_snddriver_ram+SMPS_RAM.v_music_fm3_track
v_snddriver_ram.v_music_fm4_track:	equ v_snddriver_ram+SMPS_RAM.v_music_fm4_track
v_snddriver_ram.v_music_fm5_track:	equ v_snddriver_ram+SMPS_RAM.v_music_fm5_track
v_snddriver_ram.v_music_psg1_track:	equ v_snddriver_ram+SMPS_RAM.v_music_psg1_track
v_snddriver_ram.v_music_psg2_track:	equ v_snddriver_ram+SMPS_RAM.v_music_psg2_track
v_snddriver_ram.v_music_psg3_track:	equ v_snddriver_ram+SMPS_RAM.v_music_psg3_track
v_snddriver_ram.v_sfx_fm3_track:	equ v_snddriver_ram+SMPS_RAM.v_sfx_fm3_track
v_snddriver_ram.v_sfx_fm4_track:	equ v_snddriver_ram+SMPS_RAM.v_sfx_fm4_track
v_snddriver_ram.v_sfx_fm5_track:	equ v_snddriver_ram+SMPS_RAM.v_sfx_fm5_track
v_snddriver_ram.v_sfx_psg1_track:	equ v_snddriver_ram+SMPS_RAM.v_sfx_psg1_track
v_snddriver_ram.v_sfx_psg2_track:	equ v_snddriver_ram+SMPS_RAM.v_sfx_psg2_track
v_snddriver_ram.v_sfx_psg3_track:	equ v_snddriver_ram+SMPS_RAM.v_sfx_psg3_track
v_snddriver_ram.v_spcsfx_fm4_track:	equ v_snddriver_ram+SMPS_RAM.v_spcsfx_fm4_track
v_snddriver_ram.v_spcsfx_psg3_track:	equ v_snddriver_ram+SMPS_RAM.v_spcsfx_psg3_track
v_snddriver_ram_end:	rs.b 0
			rs.b $40	; unused
v_gamemode:		rs.b 1
			rs.b 1		; unused
v_jpadhold2:	rs.b 1
v_jpadpress2:	rs.b 1
v_jpadhold1:	rs.b 1
v_jpadpress1:	rs.b 1
			rs.b 6		; unused
v_vdp_buffer1:	rs.w 1
			rs.b 6		; unused
v_generictimer:	rs.w 1
v_scrposy_dup:	rs.w 1
v_bgscrposy_dup:	rs.w 1		; background screen position y (duplicate) (2 bytes)
v_scrposx_dup:	rs.w 1
v_bgscrposx_dup:	rs.w 1		; background screen position x (duplicate) (2 bytes)
v_bg3scrposy_vdp:	rs.w 1
v_bg3scrposx_vdp:	rs.w 1
v_bg3scrposy_vdp_dup:	rs.w 1
v_hint_hreg:	rs.b 1		; VDP H.interrupt register buffer (8Axx)
v_hint_line:	rs.b 1		; screen line where water starts and palette is changed by HBlank
v_pfade_start:	rs.b 1		; palette fading - start position in bytes
v_pfade_size:	rs.b 1		; palette fading - number of colouds
v_lvlcount:		rs.b 1
v_lvlcount2:	rs.b 1
v_vint_routine:	rs.w 1
v_spritecount:	rs.b 1
			rs.b 5		; unused
v_pcyc_num:		rs.w 1		; palette cycling - current reference number (2 bytes)
v_pcyc_time:	rs.w 1		; palette cycling - time until the next change (2 bytes)
v_random:		rs.l 1
f_pause:		rs.w 1
			rs.b 8		; unused
v_vdp_buffer2:	rs.w 1
			rs.w 1		; unused
f_hint:		rs.w 1
			rs.w 1		; unused
f_water:		rs.w 1
			rs.w 1		; unused
v_pal_buffer:	rs.b $16	; palette data buffer (used for palette cycling) ($16 bytes)
v_levseldelay:	rs.w 1		; level select - time until change when up/down is held (2 bytes)
v_levselitem:	rs.w 1		; level select - item selected (2 bytes)
v_levselsound:	rs.w 1		; level select - sound selected (2 bytes)
			rs.b $14	; unused
v_plc_buffer:	rs.b 6*16	; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_plc_buffer_only_end:	rs.b 0
v_plc_ptrnemcode:	rs.l 1		; pattern load cues buffer (4 bytes)
v_plc_repeatcount:	rs.l 1		; pattern load cues buffer (4 bytes)
v_plc_paletteindex:	rs.l 1		; pattern load cues buffer (4 bytes)
v_plc_previousrow:	rs.l 1		; pattern load cues buffer (4 bytes)
v_plc_dataword:		rs.l 1		; pattern load cues buffer (4 bytes)
v_plc_shiftvalue:	rs.l 1		; pattern load cues buffer (4 bytes)
v_plc_patternsleft:	rs.w 1		; flag set for pattern load cue execution (2 bytes)
v_plc_framepatternsleft:	rs.w 1
			rs.l 1		; unused
v_plc_buffer_end:	rs.b 0
v_misc_variables:	rs.b 0
v_scrposx:	rs.l 1
v_scrposy:	rs.l 1
v_bgscrposx:	rs.l 1
v_bgscrposy:	rs.l 1
v_bg2scrposx:	rs.l 1
v_bg2scrposy:	rs.l 1
v_bg3scrposx:	rs.l 1
v_bg3scrposy:	rs.l 1
v_limitleft1:	rs.w 1
			rs.w 1		; unused, was probably v_limitright1
v_limittop1:	rs.w 1
v_limitbtm1:	rs.w 1
v_limitleft2:	rs.w 1
v_limitright2:	rs.w 1
v_limittop2:	rs.w 1
v_limitbtm2:	rs.w 1
unk_FFF730:		rs.w 1
v_limitleft3:	rs.w 1
			rs.b 6		; unused
v_scrshiftx:	rs.w 1
v_scrshifty:	rs.w 1
v_lookshift:	rs.w 1
f_rst_hscroll:	rs.b 1
f_rst_vscroll:	rs.b 1
v_dle_routine:	rs.w 1
f_nobgscroll:	rs.w 1
unk_FFF746:		rs.w 1
unk_FFF748:		rs.w 1
v_fg_xblock:	rs.b 1
v_fg_yblock:	rs.b 1
v_bg1_xblock:	rs.b 1
v_bg1_yblock:	rs.b 1
v_bg2_xblock:	rs.b 1
			rs.b 5		; unused
v_fg_scroll_flags:	rs.w 1
v_bg1_scroll_flags:	rs.w 1
v_bg2_scroll_flags:	rs.w 1
			rs.w 1		; unused
f_bgscrollvert:	rs.b 1
			rs.b 3		; unused
v_sonspeedmax:	rs.w 1
v_sonspeedacc:	rs.w 1
v_sonspeeddec:	rs.w 1
v_sonframenum:	rs.b 1		; frame to display for Sonic
f_sonframechg:	rs.b 1
v_anglebuffer:	rs.w 1		; primary angle buffer (2 bytes)
v_anglebuffer2:	rs.w 1		; secondary angle buffer (2 bytes)
v_opl_routine:	rs.w 1		; ObjPosLoad - routine counter (2 bytes)
v_opl_screen:	rs.w 1		; ObjPosLoad - screen variable (2 bytes)
v_opl_data:		rs.b $10	; ObjPosLoad - data buffer ($10 bytes)
v_ssangle:		rs.w 1		; Special Stage angle (2 bytes)
v_ssrotate:		rs.w 1		; Special Stage rotation speed (2 bytes)
			rs.b $C		; unused
v_btnpushtime1:	rs.w 1
v_btnpushtime2:	rs.w 1
v_palchgspeed:	rs.w 1
v_collindex:	rs.l 1
v_palss_num:	rs.w 1
v_palss_time:	rs.w 1
v_palss_index:	rs.w 1
v_ssbganim:		rs.w 1
			rs.w 1		; unused
v_obj31ypos:	rs.w 1		; y-position of object 31 (MZ stomper) (2 bytes)
			rs.b 1		; unused
v_bossstatus:	rs.b 1
v_trackpos:		rs.b 1
v_trackbyte:	rs.b 1
f_lockscreen:	rs.b 1
			rs.b 1		; unused
v_256loop1:		rs.b 1		; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256loop2:		rs.b 1		; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256roll1:		rs.b 1		; 256x256 level tile which contains a roll tunnel (GHZ)
v_256roll2:		rs.b 1		; 256x256 level tile which contains a roll tunnel (GHZ)
v_lani0_frame:	rs.b 1		; level graphics animation 0 - current frame
v_lani0_time:	rs.b 1		; level graphics animation 0 - time until next frame
v_lani1_frame:	rs.b 1		; level graphics animation 1 - current frame
v_lani1_time:	rs.b 1		; level graphics animation 1 - time until next frame
v_lani2_frame:	rs.b 1		; level graphics animation 2 - current frame
v_lani2_time:	rs.b 1		; level graphics animation 2 - time until next frame
v_lani3_frame:	rs.b 1		; level graphics animation 3 - current frame
			rs.b $29	; unused
f_switch:		rs.w 1
			rs.b $E		; unused
v_scroll_block_size:	rs.w 1
			rs.b $E		; unused
v_misc_variables_end:	rs.b 0
v_spritetablebuffer:	rs.b $280
v_spritetablebuffer_end:	rs.b 0
			rs.b $80	; unused
v_palette:		rs.b $80
v_palette_end:	rs.b 0
v_palette_fading:	rs.b $80
v_palette_fading_end:	rs.b 0
v_objstate:		rs.b $C0	; object state list
v_objstate_end:	rs.b 0
			rs.b $140	; stack
v_systemstack:	rs.b 0
v_crossresetram:	rs.b 0
			rs.w 1
f_restart:		rs.w 1		; restart level flag (2 bytes)
v_framecount:	rs.b 1		; frame counter (adds 1 every frame) (2 bytes)
v_framebyte:	rs.b 1		; low byte for frame counter
v_debugitem:	rs.w 1
v_debuguse:		rs.w 1
v_debugxspeed:	rs.b 1
v_debugyspeed:	rs.b 1
v_vint_count:	rs.w 1
v_vint_word:	rs.b 1		; low word for vertical interrupt counter (2 bytes)
v_vint_byte:	rs.b 1		; low byte for vertical interrupt counter
v_zone:			rs.b 1
v_act:			rs.b 1
v_lives:		rs.b 1
			rs.b 8		; unused
v_lifecount:	rs.b 1		; lives counter value (for actual number, see "v_lives")
f_lifecount:	rs.b 1		; lives counter update flag
f_ringcount:	rs.b 1
f_timecount:	rs.b 1
f_scorecount:	rs.b 1		; score counter update flag
v_rings:		rs.b 1
v_ringbyte:		rs.b 1		; low byte for rings
v_time:			rs.b 1
v_timemin:		rs.b 1		; time - minutes
v_timesec:		rs.b 1		; time - seconds
			rs.b 1		; unused
v_score:		rs.l 1
			rs.w 1		; unused
v_shield:		rs.b 1
v_invinc:		rs.b 1
v_shoes:		rs.b 1
byte_FFFE2F:	rs.b 1
			rs.b $20	; unused
v_scorecopy:	rs.l 1
v_timebonus:	rs.w 1
v_ringbonus:	rs.w 1
f_endactbonus:	rs.b 1
			rs.b 5		; unused
v_oscillate:	rs.w 1		; oscillation bitfield
v_timingandscreenvariables:	rs.b 0
			rs.b $40	; values which oscillate - for swinging platforms, et al
			rs.b $20	; unused
v_ani0_time:	rs.b 1		; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:	rs.b 1		; synchronised sprite animation 0 - current frame
v_ani1_time:	rs.b 1		; synchronised sprite animation 1 - time until next frame
v_ani1_frame:	rs.b 1		; synchronised sprite animation 1 - current frame
v_ani2_time:	rs.b 1		; synchronised sprite animation 2 - time until next frame
v_ani2_frame:	rs.b 1		; synchronised sprite animation 2 - current frame
v_ani3_time:	rs.b 1		; synchronised sprite animation 3 - time until next frame
v_ani3_frame:	rs.b 1		; synchronised sprite animation 3 - current frame
v_ani3_buf:		rs.w 1		; synchronised sprite animation 3 - info buffer (2 bytes)
			rs.b $36	; unused
v_timingandscreenvariables_end:	rs.b 0
			rs.b $E0	; unused
word_FFFFE0:	rs.w 1		; value that's set to 1 during initation, unused otherwise (2 bytes)
			rs.b 6		; unused
word_FFFFE8:	rs.w 1		; value that's set to 0 during initation of a level, unused otherwise (2 bytes)
			rs.b 6		; unused
f_demo:			rs.w 1
v_demonum:		rs.w 1
			rs.l 1		; unused
v_megadrive:	rs.b 1
			rs.b 1		; unused
f_debugmode:	rs.b 1
			rs.b 1		; unused
v_init:			rs.l 1		; 'init' text string (4 bytes)
v_end:		rs.b 0
	rsreset

; Special Stage Variables
v_ssbuffer1		= v_start&$FFFFFF
v_ssblockbuffer	= v_ssbuffer1+$1020 ; ($2000 bytes)
v_ssblockbuffer_end	= v_ssblockbuffer+$80*$40
v_sslayout		= v_start&$FFFFFF+$172E	; ($510 bytes)
v_ssbuffer2		= v_start&$FFFFFF+$4000
v_ssblocktypes	= v_ssbuffer2
v_ssitembuffer	= v_ssbuffer2+$400 ; ($100 bytes)
v_ssitembuffer_end	= v_ssitembuffer+$100
v_ssbuffer3		= v_start+$8000
v_ssscroll_buffer	= v_ngfx_buffer+$100

	rsset v_objstate
v_regbuffer:	rs.b obj.Size	; stores registers d0-a7 during an error event
v_spbuffer:		rs.l 1		; stores most recent sp address
v_errortype:	rs.b 1		; error type
	rsreset

	rsset v_objslot18
f_victory:		rs.b 1		; flag for victory animation (1 byte)
	rsreset