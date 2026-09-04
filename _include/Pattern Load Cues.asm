; ===========================================================================
; ---------------------------------------------------------------------------
; Pattern load cues
; ---------------------------------------------------------------------------

; Macro to define PLC pointer entry
plcptr:		macro plc,{INTLABEL}
__LABEL__:	label	(*-ArtLoadCues)/2
		dc.w	plc-ArtLoadCues
		endm

; Macro for the header of a PLC list
plcheader:	macro {INTLABEL}
__LABEL__:	label	*
		dc.w ((__LABEL___end-__LABEL__-2)/6)-1
		endm

; Macro for single pattern load cue entry
plcm:		macro gfx,vram
		dc.l gfx
		dc.w (vram)*tile_size
		endm

; ---------------------------------------------------------------------------

; Index and ID definitions
ArtLoadCues:

plcid_Main:		plcptr	PLC_Main
plcid_Main2:		plcptr	PLC_Main2
plcid_Explode:		plcptr	PLC_Explode
plcid_GameOver:		plcptr	PLC_GameOver

	PLC_Levels:
plcid_GHZ:		plcptr	PLC_GHZ
plcid_GHZ2:		plcptr	PLC_GHZ2
plcid_LZ:		plcptr	PLC_LZ
plcid_LZ2:		plcptr	PLC_LZ2
plcid_MZ:		plcptr	PLC_MZ
plcid_MZ2:		plcptr	PLC_MZ2
plcid_SLZ:		plcptr	PLC_SLZ
plcid_SLZ2:		plcptr	PLC_SLZ2
plcid_SZ:		plcptr	PLC_SZ
plcid_SZ2:		plcptr	PLC_SZ2
plcid_CWZ:		plcptr	PLC_CWZ
plcid_CWZ2:		plcptr	PLC_CWZ2

plcid_TitleCard:	plcptr	PLC_TitleCard
plcid_Boss:		plcptr	PLC_Boss
plcid_Signpost:		plcptr	PLC_Signpost
plcid_Warp:		plcptr	PLC_Warp
plcid_SpecialStage:	plcptr	PLC_SpecialStage

	PLC_Animals:
plcid_GHZAnimals:	plcptr	PLC_GHZAnimals
plcid_LZAnimals:	plcptr	PLC_LZAnimals
plcid_MZAnimals:	plcptr	PLC_MZAnimals
plcid_SLZAnimals:	plcptr	PLC_SLZAnimals
plcid_SZAnimals:	plcptr	PLC_SZAnimals
plcid_CWZAnimals:	plcptr	PLC_CWZAnimals

; ---------------------------------------------------------------------------
; Pattern load cues - standard block 1
; ---------------------------------------------------------------------------
PLC_Main:	plcheader
		plcm	Nem_Smoke,	ArtTile_Smoke			; smoke
		plcm	Nem_HUD,	ArtTile_HUD			; HUD
		plcm	Nem_Lives,	ArtTile_Lives_Counter		; lives counter
		plcm	Nem_Ring,	ArtTile_Ring			; rings
		plcm	Nem_Points,	ArtTile_Points			; points from enemy
PLC_Main_end:

; ---------------------------------------------------------------------------
; Pattern load cues - standard block 2
; ---------------------------------------------------------------------------
PLC_Main2:	plcheader
		plcm	Nem_Monitors,	ArtTile_Monitor			; monitors
		plcm	Nem_Shield,	ArtTile_Shield			; shield
		plcm	Nem_Stars,	ArtTile_Invincibility		; invincibility stars
PLC_Main2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - explosion
; ---------------------------------------------------------------------------
PLC_Explode:	plcheader
		plcm	Nem_Explode,	ArtTile_Explosion		; explosion
PLC_Explode_end:

; ---------------------------------------------------------------------------
; Pattern load cues - game/time	over
; ---------------------------------------------------------------------------
PLC_GameOver:	plcheader
		plcm	Nem_GameOver,	ArtTile_Game_Over		; game/time over
PLC_GameOver_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Green Hill
; ---------------------------------------------------------------------------
PLC_GHZ:	plcheader
		plcm	Nem_GHZ_1st,	ArtTile_Level			; GHZ main patterns
		plcm	Nem_GHZ_2nd,	ArtTile_Level+$1CD		; GHZ secondary patterns
		plcm	Nem_Stalk,	ArtTile_GHZ_Flower_Stalk	; flower stalk
		plcm	Nem_PplRock,	ArtTile_GHZ_Purple_Rock		; purple rock
		plcm	Nem_Crabmeat,	ArtTile_Crabmeat		; crabmeat enemy
		plcm	Nem_Buzz,	ArtTile_Buzz_Bomber		; buzz bomber enemy
		plcm	Nem_Chopper,	ArtTile_Chopper			; chopper enemy
		plcm	Nem_Newtron,	ArtTile_Newtron			; newtron enemy
		plcm	Nem_Motobug,	ArtTile_Moto_Bug		; motobug enemy
		plcm	Nem_Spikes,	ArtTile_Spikes			; spikes
		plcm	Nem_HSpring,	ArtTile_Spring_Horizontal	; horizontal spring
		plcm	Nem_VSpring,	ArtTile_Spring_Vertical		; vertical spring
PLC_GHZ_end:

PLC_GHZ2:	plcheader
		plcm	Nem_Swing,	ArtTile_GHZ_MZ_Swing		; swinging platform
		plcm	Nem_Bridge,	ArtTile_GHZ_Bridge		; bridge
		plcm	Nem_SpikePole,	ArtTile_GHZ_Spike_Pole		; spiked pole
		plcm	Nem_Ball,	ArtTile_GHZ_Giant_Ball		; giant ball
		plcm	Nem_GhzWall1,	ArtTile_GHZ_SLZ_Smashable_Wall	; breakable wall
		plcm	Nem_GhzWall2,	ArtTile_GHZ_Edge_Wall		; normal wall
PLC_GHZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Labyrinth
; ---------------------------------------------------------------------------
PLC_LZ:		plcheader
		plcm	Nem_LZ,	ArtTile_Level				; LZ main patterns
PLC_LZ_end:

PLC_LZ2:	plcheader
		plcm	Nem_Jaws,	ArtTile_Jaws_2			; jaws enemy
PLC_LZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Marble
; ---------------------------------------------------------------------------
PLC_MZ:		plcheader
		plcm	Nem_MZ,	ArtTile_Level				; MZ main patterns
		plcm	Nem_MzMetal,	ArtTile_MZ_Spike_Stomper	; metal blocks
		plcm	Nem_MzFire,	ArtTile_MZ_Fireball		; fireballs
		plcm	Nem_Swing,	ArtTile_GHZ_MZ_Swing		; swinging platform
		plcm	Nem_MzGlass,	ArtTile_MZ_Glass_Pillar		; green glassy block
		plcm	Nem_Lava,	ArtTile_MZ_Lava			; lava
		plcm	Nem_Buzz,	ArtTile_Buzz_Bomber		; buzz bomber enemy
		plcm	Nem_Yadrin,	ArtTile_Yadrin			; yadrin enemy
		plcm	Nem_Basaran,	ArtTile_Basaran			; basaran enemy
		plcm	Nem_Splats,	ArtTile_Splats			; splats enemy
PLC_MZ_end:

PLC_MZ2:	plcheader
		plcm	Nem_MzSwitch,	ArtTile_Button_Main		; switch
		plcm	Nem_Spikes,	ArtTile_Spikes			; spikes
		plcm	Nem_HSpring,	ArtTile_Spring_Horizontal	; horizontal spring
		plcm	Nem_VSpring,	ArtTile_Spring_Vertical		; vertical spring
		plcm	Nem_MzBlock,	ArtTile_MZ_Block		; green stone block
PLC_MZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Star Light
; ---------------------------------------------------------------------------
PLC_SLZ:	plcheader
		plcm	Nem_SLZ,	ArtTile_Level			; SLZ main patterns
		plcm	Nem_MzFire,	ArtTile_SLZ_Fireball		; fireballs
		plcm	Nem_Crabmeat,	ArtTile_Crabmeat		; crabmeat enemy
		plcm	Nem_Buzz,	ArtTile_Buzz_Bomber		; buzz bomber enemy
		plcm	Nem_SlzPlatfm,	ArtTile_SLZ_Platform		; platform
		plcm	Nem_SlzBlock,	ArtTile_SLZ_Smashable_Wall	; breakable wall
		plcm	Nem_Motobug,	ArtTile_Moto_Bug		; motobug enemy
		plcm	Nem_SlzWall,	ArtTile_SLZ_Fireball_Launcher	; fireball launcher
		plcm	Nem_Spikes,	ArtTile_Spikes			; spikes
		plcm	Nem_HSpring,	ArtTile_Spring_Horizontal	; horizontal spring
		plcm	Nem_VSpring,	ArtTile_Spring_Vertical		; vertical spring
PLC_SLZ_end:

PLC_SLZ2:	plcheader
		plcm	Nem_Seesaw,	ArtTile_SLZ_Seesaw		; seesaw
		plcm	Nem_Fan,	ArtTile_SLZ_Fan			; fan
		plcm	Nem_Pylon,	ArtTile_SLZ_Pylon		; foreground pylon
		plcm	Nem_SlzSwing,	ArtTile_SLZ_Swing		; swinging platform
PLC_SLZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Sparkling
; ---------------------------------------------------------------------------
PLC_SZ:		plcheader
		plcm	Nem_SZ,	ArtTile_Level				; SZ main patterns
		plcm	Nem_Crabmeat,	ArtTile_Crabmeat		; crabmeat enemy
		plcm	Nem_Buzz,	ArtTile_Buzz_Bomber		; buzz bomber enemy
		plcm	Nem_Yadrin,	ArtTile_Yadrin			; yadrin enemy
		plcm	Nem_Roller,	ArtTile_Roller			; roller enemy
PLC_SZ_end:

PLC_SZ2:	plcheader
		plcm	Nem_Bumper,	ArtTile_SZ_Bumper		; bumper
		plcm	Nem_SyzSpike1,	ArtTile_SZ_Big_Spikeball	; large spikeball
		plcm	Nem_SyzSpike2,	ArtTile_SZ_Spikeball_Chain	; small spikeball
		plcm	Nem_Switch,	ArtTile_Button			; switch
		plcm	Nem_Spikes,	ArtTile_Spikes			; spikes
		plcm	Nem_HSpring,	ArtTile_Spring_Horizontal	; horizontal spring
		plcm	Nem_VSpring,	ArtTile_Spring_Vertical		; vertical spring
PLC_SZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - Clock Work
; ---------------------------------------------------------------------------
PLC_CWZ:	plcheader
		plcm	Nem_CWZ,	ArtTile_Level			; CWZ main patterns
PLC_CWZ_end:

PLC_CWZ2:	plcheader
		plcm	Nem_Jaws,	ArtTile_Jaws_2			; jaws enemy
PLC_CWZ2_end:

; ---------------------------------------------------------------------------
; Pattern load cues - title card
; ---------------------------------------------------------------------------
PLC_TitleCard:	plcheader
		plcm	Nem_TitleCard,	ArtTile_Title_Card
PLC_TitleCard_end:

; ---------------------------------------------------------------------------
; Pattern load cues - act 3 boss
; ---------------------------------------------------------------------------
PLC_Boss:	plcheader
		plcm	Nem_Eggman,	ArtTile_Eggman			; Eggman main patterns
		plcm	Nem_Weapons,	ArtTile_Eggman_Weapons		; Eggman's weapons
		plcm	Nem_Prison,	ArtTile_Prison_Capsule		; prison capsule
PLC_Boss_end:

; ---------------------------------------------------------------------------
; Pattern load cues - act 1/2 signpost
; ---------------------------------------------------------------------------
PLC_Signpost:	plcheader
		plcm	Nem_SignPost,	ArtTile_Signpost		; signpost
PLC_Signpost_end:

; ---------------------------------------------------------------------------
; Pattern load cues - special stage warp effect
; ---------------------------------------------------------------------------
PLC_Warp:	plcheader
		plcm	Nem_Warp,	ArtTile_Warp
PLC_Warp_end:

; ---------------------------------------------------------------------------
; Pattern load cues - special stage
; ---------------------------------------------------------------------------
PLC_SpecialStage:	plcheader
		plcm	Nem_SSBgCloud,	ArtTile_SS_Background_Clouds	; bubble and cloud background
		plcm	Nem_SSBgFish,	ArtTile_SS_Background_Fish	; bird and fish background
		plcm	Nem_SSWalls,	ArtTile_SS_Wall			; walls
		plcm	Nem_Bumper,	ArtTile_SS_Bumper		; bumper
		plcm	Nem_SSGOAL,	ArtTile_SS_Goal			; GOAL block
		plcm	Nem_SSUpDown,	ArtTile_SS_Up_Down		; UP and DOWN blocks
		plcm	Nem_SSRBlock,	ArtTile_SS_R_Block		; R block
		plcm	Nem_SS1UpBlock,	ArtTile_SS_Extra_Life		; 1UP block
		plcm	Nem_SSEmStars,	ArtTile_SS_Emerald_Sparkle	; emerald collection stars
		plcm	Nem_SSRedWhite,	ArtTile_SS_Red_White_Block	; red and white block
		plcm	Nem_SSSkull,	ArtTile_SS_Skull_Block		; skull block
		plcm	Nem_SSUBlock,	ArtTile_SS_U_Block		; U block
PLC_SpecialStage_end:

		; Unused
		plcm	Nem_SSEmerald,	0				; emeralds
		plcm	Nem_SSZone1,	0				; ZONE 1 block
		plcm	Nem_SSZone2,	0				; ZONE 2 block
		plcm	Nem_SSZone3,	0				; ZONE 3 block
		plcm	Nem_SSZone4,	0				; ZONE 4 block
		plcm	Nem_SSZone5,	0				; ZONE 5 block
		plcm	Nem_SSZone6,	0				; ZONE 6 block

; ---------------------------------------------------------------------------
; Pattern load cues - GHZ animals
; ---------------------------------------------------------------------------
PLC_GHZAnimals:	plcheader
		plcm	Nem_Rabbit,	ArtTile_Animal_1		; rabbit
		plcm	Nem_Chicken,	ArtTile_Animal_2		; chicken
PLC_GHZAnimals_end:

; ---------------------------------------------------------------------------
; Pattern load cues - LZ animals
; ---------------------------------------------------------------------------
PLC_LZAnimals:	plcheader
		plcm	Nem_Penguin,	ArtTile_Animal_1		; penguin
		plcm	Nem_Seal,	ArtTile_Animal_2		; seal
PLC_LZAnimals_end:

; ---------------------------------------------------------------------------
; Pattern load cues - MZ animals
; ---------------------------------------------------------------------------
PLC_MZAnimals:	plcheader
		plcm	Nem_Pig,	ArtTile_Animal_1		; pig
		plcm	Nem_Flicky,	ArtTile_Animal_2		; flicky
PLC_MZAnimals_end:

; ---------------------------------------------------------------------------
; Pattern load cues - SLZ animals
; ---------------------------------------------------------------------------
PLC_SLZAnimals:	plcheader
		plcm	Nem_Squirrel,	ArtTile_Animal_1		; squirrel
		plcm	Nem_Seal,	ArtTile_Animal_2		; seal
PLC_SLZAnimals_end:

; ---------------------------------------------------------------------------
; Pattern load cues - SZ animals
; ---------------------------------------------------------------------------
PLC_SZAnimals:	plcheader
		plcm	Nem_Pig,	ArtTile_Animal_1		; pig
		plcm	Nem_Chicken,	ArtTile_Animal_2		; chicken
PLC_SZAnimals_end:

; ---------------------------------------------------------------------------
; Pattern load cues - CWZ animals
; ---------------------------------------------------------------------------
PLC_CWZAnimals:	plcheader
		plcm	Nem_Rabbit,	ArtTile_Animal_1		; rabbit
		plcm	Nem_Flicky,	ArtTile_Animal_2		; flicky
PLC_CWZAnimals_end: