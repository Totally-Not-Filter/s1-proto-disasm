		include	"s1.sounddriver.ram.asm"

; Variables (v) and Flags (f)

	phase $FFFF0000
v_start:
v_256x256:		ds.b $52*$200	; 256x256 tile mappings ($A400 bytes)
v_256x256_end:

layoutsize:		= $40

v_lvllayout:	ds.b layoutsize*$10	; level layout buffer ($400 bytes)
v_lvllayoutbg:	= v_lvllayout+layoutsize
v_lvllayout_end:

v_bgscroll_buffer:	ds.b $200
v_ngfx_buffer:	ds.b $200
v_ngfx_buffer_end:
v_spritequeue:	ds.b $400
v_16x16:		ds.w 4*$300	; 16x16 tile mappings ($1800 bytes)
v_16x16_end:
v_sgfx_buffer:	ds.b $2E0	; sonic graphics ram buffer ($2E0 bytes)
v_sgfx_buffer_end:
			ds.b $20	; unused
v_tracksonic:	ds.b $100	; sonic position table ($100 bytes)
v_hscrolltablebuffer:	ds.b $380
v_hscrolltablebuffer_end:
			ds.b $80
v_hscrolltablebuffer_end_padded:
v_objspace:				; RAM for object space ($600 bytes)
v_objslot0:		ds.b obj.Size
v_objslot1:		ds.b obj.Size
v_objslot2:		ds.b obj.Size
v_objslot3:		ds.b obj.Size
v_objslot4:		ds.b obj.Size
v_objslot5:		ds.b obj.Size
v_objslot6:		ds.b obj.Size
v_objslot7:		ds.b obj.Size
v_objslot8:		ds.b obj.Size
v_objslot9:		ds.b obj.Size
v_objslotA:		ds.b obj.Size
v_objslotB:		ds.b obj.Size
v_objslotC:		ds.b obj.Size
v_objslotD:		ds.b obj.Size
v_objslotE:		ds.b obj.Size
v_objslotF:		ds.b obj.Size
v_objslot10:	ds.b obj.Size
v_objslot11:	ds.b obj.Size
v_objslot12:	ds.b obj.Size
v_objslot13:	ds.b obj.Size
v_objslot14:	ds.b obj.Size
v_objslot15:	ds.b obj.Size
v_objslot16:	ds.b obj.Size
v_objslot17:	ds.b obj.Size
v_objslot18:	ds.b obj.Size	; flag for victory animation (1 byte)
v_objslot19:	ds.b obj.Size
v_objslot1A:	ds.b obj.Size
v_objslot1B:	ds.b obj.Size
v_objslot1C:	ds.b obj.Size
v_objslot1D:	ds.b obj.Size
v_objslot1E:	ds.b obj.Size
v_objslot1F:	ds.b obj.Size

v_player:	= v_objslot0
v_hud:	= v_objslot1

v_lvlobjspace:
	rept 96
			ds.b obj.Size
	endm
v_lvlobjend:
v_objspace_end:
; $FFFFF000
v_snddriver_ram:	SMPS_RAM	; start of RAM for the sound driver data ($600 bytes)
			ds.b $40	; unused
v_snddriver_ram_end:
v_gamemode:		ds.b 1
			ds.b 1		; unused
v_jpadhold2:	ds.b 1
v_jpadpress2:	ds.b 1
v_jpadhold1:	ds.b 1
v_jpadpress1:	ds.b 1
			ds.b 6		; unused
v_vdp_buffer1:	ds.w 1
			ds.b 6		; unused
v_generictimer:	ds.w 1
v_scrposy_dup:	ds.w 1
v_bgscrposy_dup:	ds.w 1		; background screen position y (duplicate) (2 bytes)
v_scrposx_dup:	ds.w 1
v_bgscrposx_dup:	ds.w 1		; background screen position x (duplicate) (2 bytes)
v_bg3scrposy_vdp:	ds.w 1
v_bg3scrposx_vdp:	ds.w 1
v_bg3scrposy_vdp_dup:	ds.w 1
v_hint_hreg:	ds.b 1		; VDP H.interrupt register buffer (8Axx)
v_hint_line:	ds.b 1		; screen line where water starts and palette is changed by HBlank
v_pfade_start:	ds.b 1		; palette fading - start position in bytes
v_pfade_size:	ds.b 1		; palette fading - number of colouds
byte_FFF628:	ds.b 1
byte_FFF629:	ds.b 1
v_vbla_routine:	ds.w 1
v_spritecount:	ds.b 1
			ds.b 5		; unused
v_pcyc_num:		ds.w 1		; palette cycling - current reference number (2 bytes)
v_pcyc_time:	ds.w 1		; palette cycling - time until the next change (2 bytes)
v_random:		ds.l 1
f_pause:		ds.w 1
			ds.b 8		; unused
v_vdp_buffer2:	ds.w 1
			ds.w 1		; unused
f_hint:		ds.w 1
			ds.w 1		; unused
f_water:		ds.w 1
			ds.w 1		; unused
v_pal_buffer:	ds.b $16	; palette data buffer (used for palette cycling) ($16 bytes)
v_levseldelay:	ds.w 1		; level select - time until change when up/down is held (2 bytes)
v_levselitem:	ds.w 1		; level select - item selected (2 bytes)
v_levselsound:	ds.w 1		; level select - sound selected (2 bytes)
			ds.b $14	; unused
v_plc_buffer:	ds.b 6*16	; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_plc_buffer_only_end:
v_plc_buffer_reg0:	ds.l 1		; pattern load cues buffer (4 bytes)
v_plc_buffer_reg4:	ds.l 1		; pattern load cues buffer (4 bytes)
v_plc_buffer_reg8:	ds.l 1		; pattern load cues buffer (4 bytes)
v_plc_buffer_regC:	ds.l 1		; pattern load cues buffer (4 bytes)
v_plc_buffer_reg10:	ds.l 1		; pattern load cues buffer (4 bytes)
v_plc_buffer_reg14:	ds.l 1		; pattern load cues buffer (4 bytes)
f_plc_execute:	ds.w 1		; flag set for pattern load cue execution (2 bytes)
v_plc_buffer_reg1A:	ds.w 1
			ds.l 1		; unused
v_plc_buffer_end:
v_misc_variables:
v_scrposx:	ds.l 1
v_scrposy:	ds.l 1
v_bgscrposx:	ds.l 1
v_bgscrposy:	ds.l 1
v_bg2scrposx:	ds.l 1
v_bg2scrposy:	ds.l 1
v_bg3scrposx:	ds.l 1
v_bg3scrposy:	ds.l 1
v_limitleft1:	ds.w 1
			ds.w 1		; unused, was probably v_limitright1
v_limittop1:	ds.w 1
v_limitbtm1:	ds.w 1
v_limitleft2:	ds.w 1
v_limitright2:	ds.w 1
v_limittop2:	ds.w 1
v_limitbtm2:	ds.w 1
unk_FFF730:		ds.w 1
v_limitleft3:	ds.w 1
			ds.b 6		; unused
v_scrshiftx:	ds.w 1
v_scrshifty:	ds.w 1
v_lookshift:	ds.w 1
f_res_hscroll:	ds.b 1
f_res_vscroll:	ds.b 1
v_dle_routine:	ds.w 1
f_nobgscroll:	ds.w 1
unk_FFF746:		ds.w 1
unk_FFF748:		ds.w 1
v_fg_xblock:	ds.b 1
v_fg_yblock:	ds.b 1
v_bg1_xblock:	ds.b 1
v_bg1_yblock:	ds.b 1
v_bg2_xblock:	ds.b 1
			ds.b 5		; unused
v_fg_scroll_flags:	ds.w 1
v_bg1_scroll_flags:	ds.w 1
v_bg2_scroll_flags:	ds.w 1
			ds.w 1		; unused
f_bgscrollvert:	ds.b 1
			ds.b 3		; unused
v_sonspeedmax:	ds.w 1
v_sonspeedacc:	ds.w 1
v_sonspeeddec:	ds.w 1
v_sonframenum:	ds.b 1		; frame to display for Sonic
f_sonframechg:	ds.b 1
v_anglebuffer:	ds.w 1		; primary angle buffer (2 bytes)
v_anglebuffer2:	ds.w 1		; secondary angle buffer (2 bytes)
v_opl_routine:	ds.w 1		; ObjPosLoad - routine counter (2 bytes)
v_opl_screen:	ds.w 1		; ObjPosLoad - screen variable (2 bytes)
v_opl_data:		ds.b $10	; ObjPosLoad - data buffer ($10 bytes)
v_ssangle:		ds.w 1		; Special Stage angle (2 bytes)
v_ssrotate:		ds.w 1		; Special Stage rotation speed (2 bytes)
			ds.b $C		; unused
v_btnpushtime1:	ds.w 1
v_btnpushtime2:	ds.w 1
v_palchgspeed:	ds.w 1
v_collindex:	ds.l 1
v_palss_num:	ds.w 1
v_palss_time:	ds.w 1
v_palss_index:	ds.w 1
v_ssbganim:		ds.w 1
			ds.w 1		; unused
v_obj31ypos:	ds.w 1		; y-position of object 31 (MZ stomper) (2 bytes)
			ds.b 1		; unused
v_bossstatus:	ds.b 1
v_trackpos:		ds.b 1
v_trackbyte:	ds.b 1
f_lockscreen:	ds.b 1
			ds.b 1		; unused
v_256loop1:		ds.b 1		; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256loop2:		ds.b 1		; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256roll1:		ds.b 1		; 256x256 level tile which contains a roll tunnel (GHZ)
v_256roll2:		ds.b 1		; 256x256 level tile which contains a roll tunnel (GHZ)
v_lani0_frame:	ds.b 1		; level graphics animation 0 - current frame
v_lani0_time:	ds.b 1		; level graphics animation 0 - time until next frame
v_lani1_frame:	ds.b 1		; level graphics animation 1 - current frame
v_lani1_time:	ds.b 1		; level graphics animation 1 - time until next frame
v_lani2_frame:	ds.b 1		; level graphics animation 2 - current frame
v_lani2_time:	ds.b 1		; level graphics animation 2 - time until next frame
v_lani3_frame:	ds.b 1		; level graphics animation 3 - current frame
			ds.b $29	; unused
f_switch:		ds.w 1
			ds.b $E		; unused
v_scroll_block_1_size:	ds.w 1
			ds.b $E		; unused
v_misc_variables_end:
v_spritetablebuffer:	ds.b $280
v_spritetablebuffer_end
			ds.b $80	; unused
v_palette:		ds.b $80
v_palette_end:
v_palette_fading:	ds.b $80
v_palette_fading_end:
v_objstate:		ds.b $C0	; object state list
v_objstate_end:
			ds.b $140	; stack
v_systemstack:
v_crossresetram:
			ds.w 1
f_restart:		ds.w 1		; restart level flag (2 bytes)
v_framecount:	ds.b 1		; frame counter (adds 1 every frame) (2 bytes)
v_framebyte:	ds.b 1		; low byte for frame counter
v_debugitem:	ds.w 1
v_debuguse:		ds.w 1
v_debugxspeed:	ds.b 1
v_debugyspeed:	ds.b 1
v_vbla_count:	ds.w 1
v_vbla_word:	ds.b 1		; low word for vertical interrupt counter (2 bytes)
v_vbla_byte:	ds.b 1		; low byte for vertical interrupt counter
v_zone:			ds.b 1
v_act:			ds.b 1
v_lives:		ds.b 1
			ds.b 8		; unused
v_lifecount:	ds.b 1		; lives counter value (for actual number, see "v_lives")
f_lifecount:	ds.b 1		; lives counter update flag
f_ringcount:	ds.b 1
f_timecount:	ds.b 1
f_scorecount:	ds.b 1		; score counter update flag
v_rings:		ds.b 1
v_ringbyte:		ds.b 1		; low byte for rings
v_time:			ds.b 1
v_timemin:		ds.b 1		; time - minutes
v_timesec:		ds.b 1		; time - seconds
			ds.b 1		; unused
v_score:		ds.l 1
			ds.w 1		; unused
v_shield:		ds.b 1
v_invinc:		ds.b 1
v_shoes:		ds.b 1
byte_FFFE2F:	ds.b 1
			ds.b $20	; unused
v_scorecopy:	ds.l 1
v_timebonus:	ds.w 1
v_ringbonus:	ds.w 1
f_endactbonus:	ds.b 1
			ds.b 5		; unused
v_oscillate:	ds.w 1		; oscillation bitfield
v_timingandscreenvariables:
			ds.b $40	; values which oscillate - for swinging platforms, et al
			ds.b $20	; unused
v_ani0_time:	ds.b 1		; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:	ds.b 1		; synchronised sprite animation 0 - current frame
v_ani1_time:	ds.b 1		; synchronised sprite animation 1 - time until next frame
v_ani1_frame:	ds.b 1		; synchronised sprite animation 1 - current frame
v_ani2_time:	ds.b 1		; synchronised sprite animation 2 - time until next frame
v_ani2_frame:	ds.b 1		; synchronised sprite animation 2 - current frame
v_ani3_time:	ds.b 1		; synchronised sprite animation 3 - time until next frame
v_ani3_frame:	ds.b 1		; synchronised sprite animation 3 - current frame
v_ani3_buf:		ds.w 1		; synchronised sprite animation 3 - info buffer (2 bytes)
			ds.b $36	; unused
v_timingandscreenvariables_end:
			ds.b $E0	; unused
word_FFFFE0:	ds.w 1		; value that's set to 1 during initation, unused otherwise (2 bytes)
			ds.b 6		; unused
word_FFFFE8:	ds.w 1		; value that's set to 0 during initation of a level, unused otherwise (2 bytes)
			ds.b 6		; unused
f_demo:			ds.w 1
v_demonum:		ds.w 1
			ds.l 1		; unused
v_megadrive:	ds.b 1
			ds.b 1		; unused
f_debugmode:	ds.b 1
			ds.b 1		; unused
v_init:			ds.l 1		; 'init' text string (4 bytes)
v_end:
	dephase

; Special Stage Variables
v_ssbuffer1		= v_start&$FFFFFF
v_ssblockbuffer	= v_ssbuffer1+$1020 ; ($2000 bytes)
v_ssblockbuffer_end	= v_ssblockbuffer+$80*$40
v_sslayout		= v_start&$FFFFFF+$172E
v_ssbuffer2		= v_start&$FFFFFF+$4000
v_ssblocktypes	= v_ssbuffer2
v_ssitembuffer	= v_ssbuffer2+$400 ; ($100 bytes)
v_ssitembuffer_end	= v_ssitembuffer+$100
v_ssbuffer3		= v_start+$8000
v_ssscroll_buffer	= v_ngfx_buffer+$100

	phase v_objstate
v_regbuffer:	ds.b obj.Size	; stores registers d0-a7 during an error event
v_spbuffer:		ds.l 1		; stores most recent sp address
v_errortype:	ds.b 1		; error type
	dephase

	phase v_objslot18
f_victory:		ds.b 1		; flag for victory animation (1 byte)
	dephase
	!org 0