; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

Size_of_DAC_driver_guess:	equ $1C5C

; Clocks
Master_Clock:	equ 53693175
M68000_Clock:	equ Master_Clock/7
Z80_Clock:		equ Master_Clock/15
FM_Sample_Rate:	equ M68000_Clock/(6*6*4)
PSG_Sample_Rate:	equ Z80_Clock/16
VDP_Clock:		equ Master_Clock/4
VDP_Pixel_Clock:	equ VDP_Clock/2

; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004
vdp_counter:		equ $C00008

psg_input:		equ $C00011
debug_reg:		equ $C0001C

	phase	$1FF4
zStack:		ds.w 1
zDAC_Update:	ds.b 1
zVoiceFlag:	ds.b 1
zVoiceTblAdr:	ds.w 1
zBankLow:	ds.b 1
zBankHigh:	ds.b 1
zLoopDataStr:	ds.b 1
zDAC_Status:	ds.b 1	; Bit 7 set if the driver is not accepting new samples, it is clear otherwise
zRepeatFlag:	ds.b 1
zDAC_Sample:	ds.b 1	; Sample to play, the 68k will move into this location whatever sample that's supposed to be played.
	dephase
	!org 0

zYM2612_A0:	equ $4000
zYM2612_D0:	equ $4001
zYM2612_A1:	equ $4002
zYM2612_D1:	equ $4003
zBankRegister:	equ $6000
zROMWindow:	equ $8000

; Z80 addresses
z80_ram:		equ $A00000			; start of Z80 RAM
z80_dac3_pitch:		equ z80_ram+zTimpani_Pitch
z80_dac_update:		equ z80_ram+zDAC_Update
z80_dac_voicetbladr:	equ z80_ram+zVoiceTblAdr
z80_dac_status:		equ z80_ram+zDAC_Status
z80_dac_sample:		equ z80_ram+zDAC_Sample
z80_ram_end:		equ $A02000			; end of non-reserved Z80 RAM
ym2612_a0:		equ z80_ram+zYM2612_A0
ym2612_d0:		equ z80_ram+zYM2612_D0
ym2612_a1:		equ z80_ram+zYM2612_A1
ym2612_d1:		equ z80_ram+zYM2612_D1
console_version:	equ $A10001
port_1_data_hi:		equ $A10002
port_1_data:		equ $A10003
port_2_data_hi:		equ $A10004
port_2_data:		equ $A10005
port_1_control_hi:	equ $A10008
port_1_control:		equ $A10009
port_2_control_hi:	equ $A1000A
port_2_control:		equ $A1000B
expansion_control_hi:	equ $A1000C
expansion_control:	equ $A1000D
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200

; Misc addresses
sram_port:		equ $A130F1
security_addr:		equ $A14000

; VRAM data
window_plane:	equ $A000	; window plane
vram_fg:	equ $C000	; plane A (foreground namespace)
vram_special:	equ $D000	; plane A (foreground namespace)
vram_bg:	equ $E000	; plane B (background namespace)
vram_sprites:	equ $F800	; sprite table
vram_hscroll:	equ $FC00	; horizontal scroll table

tile_size:	equ 8*8/2	; size of a single 8x8 tile
chunk_size:	equ $200	; size of a single 256x256 chunk
plane_size_64x32: equ 64*32*2	; size of plane in 512x256 mode

; VRAM data from ICD_BLK4
vram_sprites_prev:	equ $D800	; sprite table
vram_hscroll_prev:	equ $DC00	; horizontal scroll table
window_plane_prev:	equ $F000	; window plane

; CRAM equates
palette_size:	equ $80

; Levels
id_GHZ:		equ 0
id_LZ:		equ 1
id_MZ:		equ 2
id_SLZ:		equ 3
id_SZ:		equ 4
id_CWZ:		equ 5
id_06:		equ 6
id_SS:		equ 7

; Colours
cBlack:		equ $000			; colour black
cWhite:		equ $EEE			; colour white
cBlue:		equ $E00			; colour blue
cGreen:		equ $0E0			; colour green
cRed:		equ $00E			; colour red
cYellow:	equ cGreen+cRed		; colour yellow
cAqua:		equ cGreen+cBlue	; colour aqua
cMagenta:	equ cBlue+cRed		; colour magenta

; Joypad input
bitUp:		equ 0
bitDn:		equ 1
bitL:		equ 2
bitR:		equ 3
bitB:		equ 4
bitC:		equ 5
bitA:		equ 6
bitStart:	equ 7
btnUp:		equ 1<<bitUp		; ($01)
btnDn:		equ 1<<bitDn		; ($02)
btnL:		equ 1<<bitL			; ($04)
btnR:		equ 1<<bitR			; ($08)
btnB:		equ 1<<bitB			; ($10)
btnC:		equ 1<<bitC			; ($20)
btnA:		equ 1<<bitA			; ($40)
btnStart:	equ 1<<bitStart		; ($80)
btnDir:		equ btnUp|btnDn|btnL|btnR	; ($0F)
btnABC:		equ btnA|btnB|btnC	; ($70)

; Object variables
obj STRUCT DOTS
ID:		ds.b 1	; id of object (this is put here for readability, when utilized, it makes routines slower by 4 cycles)
Render:		ds.b 1	; bitfield for x/y flip, display mode
Gfx:		ds.w 1	; palette line & VRAM setting (2 bytes)
Map:		ds.l 1	; mappings address (4 bytes)
X:		ds.w 1	; x-axis position (2-4 bytes)
ScreenY:	ds.w 1	; y-axis position for screen-fixed items (2 bytes)
Y:		ds.l 1	; y-axis position (2-4 bytes)
VelX:		ds.w 1	; x-axis velocity (2 bytes)
VelY:		ds.w 1	; y-axis velocity (2 bytes)
Inertia:	ds.w 1	; potential speed (2 bytes)
Height:		ds.b 1	; height/2
Width:		ds.b 1	; width/2
ActWid:		ds.b 1	; action width
Priority:	ds.b 1	; sprite stack priority -- 0 is front
Frame:		ds.b 1	; current frame displayed
AniFrame:	ds.b 1	; current frame in animation script
Anim:		ds.b 1	; current animation
PrevAni:	ds.b 1	; previous animation
TimeFrame:	ds.b 1	; time to next frame
DelayAni:	ds.b 1	; time to delay animation
ColType:	ds.b 1	; collision response type
ColProp:	ds.b 1	; collision extra property
Status:		ds.b 1	; orientation or mode
RespawnNo:	ds.b 1	; respawn list index number
Routine:	ds.b 1	; routine number
Solid:		ds.b 1	; solid status flag, and also secondary routine number
Angle:		ds.w 1	; angle
Subtype:	ds.b 1	; object subtype
off_29:		ds.b 1
off_2A:		ds.b 1
off_2B:		ds.b 1
off_2C:		ds.b 1
off_2D:		ds.b 1
off_2E:		ds.b 1
off_2F:		ds.b 1
off_30:		ds.b 1
off_31:		ds.b 1
off_32:		ds.b 1
off_33:		ds.b 1
off_34:		ds.b 1
off_35:		ds.b 1
off_36:		ds.b 1
off_37:		ds.b 1
off_38:		ds.b 1
off_39:		ds.b 1
off_3A:		ds.b 1
off_3B:		ds.b 1
off_3C:		ds.b 1
off_3D:		ds.b 1
off_3E:		ds.b 1
off_3F:		ds.b 1
obj ENDSTRUCT
	!org 0

; Compatibility constants with Sonic Retro's Sonic 1 disassembly
obID:		equ obj.ID
obRender:	equ obj.Render
obGfx:		equ obj.Gfx
obMap:		equ obj.Map
obX:		equ obj.X
obScreenY:	equ obj.ScreenY
obY:		equ obj.Y
obVelX:		equ obj.VelX
obVelY:		equ obj.VelY
obInertia:	equ obj.Inertia
obHeight:	equ obj.Height
obWidth:	equ obj.Width
obActWid:	equ obj.ActWid
obPriority:	equ obj.Priority
obFrame:	equ obj.Frame
obAniFrame:	equ obj.AniFrame
obAnim:		equ obj.Anim
obPrevAni:	equ obj.PrevAni
obTimeFrame:	equ obj.TimeFrame
obDelayAni:	equ obj.DelayAni
obColType:	equ obj.ColType
obColProp:	equ obj.ColProp
obStatus:	equ obj.Status
obRespawnNo:	equ obj.RespawnNo
obRoutine:	equ obj.Routine
ob2ndRout:	equ obj.Solid
obAngle:	equ obj.Angle
obSubtype:	equ obj.Subtype
obSolid:	equ obj.Solid
objoff_25:	equ obj.Solid
objoff_26:	equ obj.Angle
objoff_29:	equ obj.off_29
objoff_2A:	equ obj.off_2A
objoff_2B:	equ obj.off_2B
objoff_2C:	equ obj.off_2C
objoff_2E:	equ obj.off_2E
objoff_2F:	equ obj.off_2F
obBossX:	equ obj.off_30
objoff_30:	equ obj.off_30
objoff_32:	equ obj.off_32
objoff_33:	equ obj.off_33
objoff_34:	equ obj.off_34
objoff_35:	equ obj.off_35
objoff_36:	equ obj.off_36
objoff_37:	equ obj.off_37
obBossY:	equ obj.off_38
objoff_38:	equ obj.off_38
objoff_39:	equ obj.off_39
objoff_3A:	equ obj.off_3A
objoff_3B:	equ obj.off_3B
objoff_3C:	equ obj.off_3C
objoff_3D:	equ obj.off_3D
objoff_3E:	equ obj.off_3E
objoff_3F:	equ obj.off_3F
object_size:	equ obj.len
object_size_bits:	equ 6

; Object variables used by Sonic
flashtime:	equ objoff_30	; time between flashes after getting hit
invtime:	equ objoff_32	; time left for invincibility
shoetime:	equ objoff_34	; time left for speed shoes
angleright:	equ objoff_36	; angle of floor on Sonic's right side
angleleft:	equ objoff_37	; angle of floor on Sonic's left side
respawny:	equ objoff_38	; Sonic's Y position when he dies (2 bytes)
restartime:	equ objoff_3A	; time left before level restarts after dying (2 bytes)
jumping:	equ objoff_3C	; flag for when Sonic is jumping
standonobject:	equ objoff_3D	; object Sonic stands on
locktime:	equ objoff_3E	; temporary D-Pad control lock timer (2 bytes)

; Object variables used by the title card
card_mainX:	equ objoff_30	; position for card to display on
card_finalX:	equ objoff_32	; position for card to finish on

; Animation flags
af2ndRoutine:	equ $FA	; increment 2nd routine counter
afReset:	equ $FB	; reset animation and 2nd object routine counter
afRoutine:	equ $FC	; increment routine counter
afChange:	equ $FD	; run specified animation
afBack:		equ $FE	; go back (specified number) bytes
afEnd:		equ $FF	; return to beginning of animation

; Backwards compatibility with older Sonic Retro disassemblies
obNextAni:	equ obPrevAni

; Background music
bgm__First:	equ $81
bgm_GHZ:	equ ((ptr_mus81-MusicIndex)/4)+bgm__First
bgm_LZ:		equ ((ptr_mus82-MusicIndex)/4)+bgm__First
bgm_MZ:		equ ((ptr_mus83-MusicIndex)/4)+bgm__First
bgm_SLZ:	equ ((ptr_mus84-MusicIndex)/4)+bgm__First
bgm_SZ:	        equ ((ptr_mus85-MusicIndex)/4)+bgm__First
bgm_CWZ:	equ ((ptr_mus86-MusicIndex)/4)+bgm__First
bgm_Invincible:	equ ((ptr_mus87-MusicIndex)/4)+bgm__First
bgm_ExtraLife:	equ ((ptr_mus88-MusicIndex)/4)+bgm__First
bgm_SS:		equ ((ptr_mus89-MusicIndex)/4)+bgm__First
bgm_Title:	equ ((ptr_mus8A-MusicIndex)/4)+bgm__First
bgm_Ending:	equ ((ptr_mus8B-MusicIndex)/4)+bgm__First
bgm_Boss:	equ ((ptr_mus8C-MusicIndex)/4)+bgm__First
bgm_FZ:		equ ((ptr_mus8D-MusicIndex)/4)+bgm__First
bgm_GotThrough:	equ ((ptr_mus8E-MusicIndex)/4)+bgm__First
bgm_GameOver:	equ ((ptr_mus8F-MusicIndex)/4)+bgm__First
bgm_Continue:	equ ((ptr_mus90-MusicIndex)/4)+bgm__First
bgm_Credits:	equ ((ptr_mus91-MusicIndex)/4)+bgm__First
bgm__Last:	equ ((ptr_musend-MusicIndex-4)/4)+bgm__First

; Sound effects
sfx__First:	equ $A0
sfx_Jump:	equ ((ptr_sndA0-SoundIndex)/4)+sfx__First
sfx_Lamppost:	equ ((ptr_sndA1-SoundIndex)/4)+sfx__First
sfx_A2:		equ ((ptr_sndA2-SoundIndex)/4)+sfx__First
sfx_Death:	equ ((ptr_sndA3-SoundIndex)/4)+sfx__First
sfx_Skid:	equ ((ptr_sndA4-SoundIndex)/4)+sfx__First
sfx_A5:		equ ((ptr_sndA5-SoundIndex)/4)+sfx__First
sfx_HitSpikes:	equ ((ptr_sndA6-SoundIndex)/4)+sfx__First
sfx_Push:	equ ((ptr_sndA7-SoundIndex)/4)+sfx__First
sfx_SSGoal:	equ ((ptr_sndA8-SoundIndex)/4)+sfx__First
sfx_SSItem:	equ ((ptr_sndA9-SoundIndex)/4)+sfx__First
sfx_Splash:	equ ((ptr_sndAA-SoundIndex)/4)+sfx__First
sfx_AB:		equ ((ptr_sndAB-SoundIndex)/4)+sfx__First
sfx_HitBoss:	equ ((ptr_sndAC-SoundIndex)/4)+sfx__First
sfx_Bubble:	equ ((ptr_sndAD-SoundIndex)/4)+sfx__First
sfx_Fireball:	equ ((ptr_sndAE-SoundIndex)/4)+sfx__First
sfx_Shield:	equ ((ptr_sndAF-SoundIndex)/4)+sfx__First
sfx_Saw:	equ ((ptr_sndB0-SoundIndex)/4)+sfx__First
sfx_Electric:	equ ((ptr_sndB1-SoundIndex)/4)+sfx__First
sfx_Drown:	equ ((ptr_sndB2-SoundIndex)/4)+sfx__First
sfx_Flamethrower:equ ((ptr_sndB3-SoundIndex)/4)+sfx__First
sfx_Bumper:	equ ((ptr_sndB4-SoundIndex)/4)+sfx__First
sfx_Ring:	equ ((ptr_sndB5-SoundIndex)/4)+sfx__First
sfx_SpikesMove:	equ ((ptr_sndB6-SoundIndex)/4)+sfx__First
sfx_Rumbling:	equ ((ptr_sndB7-SoundIndex)/4)+sfx__First
sfx_B8:		equ ((ptr_sndB8-SoundIndex)/4)+sfx__First
sfx_Collapse:	equ ((ptr_sndB9-SoundIndex)/4)+sfx__First
sfx_SSGlass:	equ ((ptr_sndBA-SoundIndex)/4)+sfx__First
sfx_Door:	equ ((ptr_sndBB-SoundIndex)/4)+sfx__First
sfx_Teleport:	equ ((ptr_sndBC-SoundIndex)/4)+sfx__First
sfx_ChainStomp:	equ ((ptr_sndBD-SoundIndex)/4)+sfx__First
sfx_Roll:	equ ((ptr_sndBE-SoundIndex)/4)+sfx__First
sfx_Continue:	equ ((ptr_sndBF-SoundIndex)/4)+sfx__First
sfx_Basaran:	equ ((ptr_sndC0-SoundIndex)/4)+sfx__First
sfx_BreakItem:	equ ((ptr_sndC1-SoundIndex)/4)+sfx__First
sfx_Warning:	equ ((ptr_sndC2-SoundIndex)/4)+sfx__First
sfx_GiantRing:	equ ((ptr_sndC3-SoundIndex)/4)+sfx__First
sfx_Bomb:	equ ((ptr_sndC4-SoundIndex)/4)+sfx__First
sfx_Cash:	equ ((ptr_sndC5-SoundIndex)/4)+sfx__First
sfx_RingLoss:	equ ((ptr_sndC6-SoundIndex)/4)+sfx__First
sfx_ChainRise:	equ ((ptr_sndC7-SoundIndex)/4)+sfx__First
sfx_Burning:	equ ((ptr_sndC8-SoundIndex)/4)+sfx__First
sfx_Bonus:	equ ((ptr_sndC9-SoundIndex)/4)+sfx__First
sfx_EnterSS:	equ ((ptr_sndCA-SoundIndex)/4)+sfx__First
sfx_WallSmash:	equ ((ptr_sndCB-SoundIndex)/4)+sfx__First
sfx_Spring:	equ ((ptr_sndCC-SoundIndex)/4)+sfx__First
sfx_Switch:	equ ((ptr_sndCD-SoundIndex)/4)+sfx__First
sfx_RingLeft:	equ ((ptr_sndCE-SoundIndex)/4)+sfx__First
sfx_Signpost:	equ ((ptr_sndCF-SoundIndex)/4)+sfx__First
sfx__Last:	equ ((ptr_sndend-SoundIndex-4)/4)+sfx__First

; Special sound effects
spec__First:	equ $D0
sfx_Waterfall:	equ ((ptr_sndD0-SpecSoundIndex)/4)+spec__First
sfx_Loud_Waterfall:	equ ((ptr_sndD1-SpecSoundIndex)/4)+spec__First
sfx_Pounding:	equ ((ptr_sndD2-SpecSoundIndex)/4)+spec__First
spec__Last:	equ ((ptr_specend-SpecSoundIndex-4)/4)+spec__First

; DAC samples
dac__First:	equ $D7

flg__First:	equ $E0
bgm_Fade:	equ ((ptr_flgE0-Sound_ExIndex)/4)+flg__First
bgm_Stop:	equ ((ptr_flgE1-Sound_ExIndex)/4)+flg__First
bgm_Speedup:	equ ((ptr_flgE2-Sound_ExIndex)/4)+flg__First
bgm_Slowdown:	equ ((ptr_flgE3-Sound_ExIndex)/4)+flg__First
bgm_StopSpec:	equ ((ptr_flgE4-Sound_ExIndex)/4)+flg__First
flg__Last:	equ ((ptr_flgend-Sound_ExIndex-4)/4)+flg__First

;=======================================;
; PSG envelope commands
;=======================================;
TBREPT:	equ	$80		; table repeat sign
TBSTAY:	equ	$81		; table staying sign
TBEND:	equ	$83		; table end sign
TBADD:	equ	$84		; after this command
				; data=([table data]-0)*[add data]
TBBAK:	equ	$85		; table pointer set next data

; Boss locations
; The main values are based on where the camera boundaries mainly lie
; The end values are where the camera scrolls towards after defeat
boss_ghz_x:	equ $2960		; Green Hill Zone
boss_ghz_y:	equ $300
boss_ghz_end:	equ boss_ghz_x+$160

; Tile flags (replaces the old "make_art_tile" function)
Tile_Prio:	equ	1<<15
Tile_Pal1:	equ	0<<13
Tile_Pal2:	equ	1<<13
Tile_Pal3:	equ	2<<13
Tile_Pal4:	equ	3<<13

; VRAM ArtTile definitions
; Multiply by $20 (tile_size) to get the actual location in VRAM

; Shared
ArtTile_GHZ_MZ_Swing:		equ $380
ArtTile_GHZ_SLZ_Smashable_Wall:	equ $50F

; Green Hill Zone
ArtTile_GHZ_Flower_4:		equ ArtTile_Level+$340
ArtTile_GHZ_Edge_Wall:		equ $34C
ArtTile_GHZ_Flower_Stalk:	equ ArtTile_Level+$358
ArtTile_GHZ_Big_Flower_1:	equ ArtTile_Level+$35C
ArtTile_GHZ_Small_Flower:	equ ArtTile_Level+$36C
ArtTile_GHZ_Waterfall:		equ ArtTile_Level+$378
ArtTile_GHZ_Flower_3:		equ ArtTile_Level+$380
ArtTile_GHZ_Bridge:		equ $38E
ArtTile_GHZ_Big_Flower_2:	equ ArtTile_Level+$390
ArtTile_GHZ_Spike_Pole:		equ $398
ArtTile_GHZ_Giant_Ball:		equ $3AA
ArtTile_GHZ_Purple_Rock:	equ $3D0

; Marble Zone
ArtTile_MZ_Block:		equ $2B8
ArtTile_MZ_Animated_Magma:	equ ArtTile_Level+$2D2
ArtTile_MZ_Animated_Lava:	equ ArtTile_Level+$2E2
ArtTile_MZ_Saturns:		equ ArtTile_Level+$2EA
ArtTile_MZ_Torch:		equ ArtTile_Level+$2F2
ArtTile_MZ_Spike_Stomper:	equ $300
ArtTile_MZ_Fireball:		equ $345
ArtTile_MZ_Glass_Pillar:	equ $38E
ArtTile_MZ_Lava:		equ $3A8

; Sparkling Zone
ArtTile_SZ_Bumper:		equ $380
ArtTile_SZ_Big_Spikeball:	equ $396
ArtTile_SZ_Spikeball_Chain:	equ $3BA

; Star Light Zone
ArtTile_SLZ_Seesaw:		equ $374
ArtTile_SLZ_Fan:		equ $3A0
ArtTile_SLZ_Pylon:		equ $3CC
ArtTile_SLZ_Swing:		equ $3DC
ArtTile_SLZ_Orbinaut:		equ $429
ArtTile_SLZ_Fireball:		equ $345
ArtTile_SLZ_Fireball_Launcher:	equ $513
ArtTile_SLZ_Platform:		equ $480
ArtTile_SLZ_Smashable_Wall:	equ $4E0
ArtTile_SLZ_Spikeball:		equ $4F0

; General Level Art
ArtTile_Level:			equ $000
ArtTile_Burrobot:		equ $39C
ArtTile_Ball_Hog:		equ $400
ArtTile_Bomb:			equ $400
ArtTile_Crabmeat:		equ $400
ArtTile_Cannonball:		equ $418
ArtTile_Missile_Disolve:	equ $41C ; Unused
ArtTile_Buzz_Bomber:		equ $444
ArtTile_Chopper:		equ $47B
ArtTile_Yadrin:			equ $47B
ArtTile_Jaws:			equ $47B
ArtTile_Newtron:		equ $49B
ArtTile_Basaran:		equ $4B8
ArtTile_Roller:			equ $4B8
ArtTile_Jaws_2:			equ $4CE
ArtTile_Splats:			equ $4E4
ArtTile_Moto_Bug:		equ $4F0
ArtTile_Button:			equ $50F
ArtTile_Spikes:			equ $51B
ArtTile_Spring_Horizontal:	equ $523
ArtTile_Spring_Vertical:	equ $533
ArtTile_Shield:			equ $541
ArtTile_Invincibility:		equ $55C
ArtTile_Game_Over:		equ $580
ArtTile_Title_Card:		equ $580
ArtTile_Animal_1:		equ $580
ArtTile_Animal_2:		equ $592
ArtTile_Explosion:		equ $5A0
ArtTile_Monitor:		equ $680
ArtTile_HUD:			equ $6CA
ArtTile_Sonic:			equ $780
ArtTile_Points:			equ $797
ArtTile_Smoke:			equ $7A0
ArtTile_Ring:			equ $7B2
ArtTile_Lives_Counter:		equ $7D4

; Eggman
ArtTile_Eggman:			equ $400
ArtTile_Eggman_Weapons:		equ $46C

; End of Level
ArtTile_Prison_Capsule:		equ $49D
ArtTile_Giant_Ring:		equ $4EC
ArtTile_Warp:			equ $541
ArtTile_Bonuses:		equ $570
ArtTile_Signpost:		equ $680

; Sega Screen
ArtTile_Sega_Tiles:		equ $000

; Title Screen
ArtTile_Title_Foreground:	equ $200
ArtTile_Title_Sonic:		equ $300
ArtTile_Level_Select_Font:	equ $680

; Special Stage
ArtTile_SS_Background_Clouds:	equ $000
ArtTile_SS_Background_Fish:	equ $051
ArtTile_SS_Wall:		equ $142
ArtTile_SS_Plane_1:		equ $200
ArtTile_SS_Bumper:		equ $23B
ArtTile_SS_Goal:		equ $251
ArtTile_SS_Up_Down:		equ $263
ArtTile_SS_R_Block:		equ $2F0
ArtTile_SS_Plane_2:		equ $300
ArtTile_SS_Extra_Life:		equ $370
ArtTile_SS_Emerald_Sparkle:	equ $3F0
ArtTile_SS_Plane_3:		equ $400
ArtTile_SS_Red_White_Block:	equ $470
ArtTile_SS_Skull_Block:		equ $4F0
ArtTile_SS_Plane_4:		equ $500
ArtTile_SS_U_Block:		equ $570
ArtTile_SS_Plane_5:		equ $600
ArtTile_SS_Plane_6:		equ $700

; Error Handler
ArtTile_Error_Handler_Font:	equ $7C0

; Early VRAM locations
ArtTile_Obj06:			equ $470
ArtTile_Debug_Numbers:		equ $4F0	; Note: This overwrites the Moto Bug graphics.

ArtTile_Early_Lives_Icon:	equ $579