; ---------------------------------------------------------------------------
; Pattern load cues
; ---------------------------------------------------------------------------
ArtLoadCues:

ptr_PLC_Main:		dc.w PLC_Main-ArtLoadCues
ptr_PLC_Main2:		dc.w PLC_Main2-ArtLoadCues
ptr_PLC_Explode:	dc.w PLC_Explode-ArtLoadCues
ptr_PLC_GameOver:	dc.w PLC_GameOver-ArtLoadCues
PLC_Levels:
ptr_PLC_GHZ:		dc.w PLC_GHZ-ArtLoadCues
ptr_PLC_GHZ2:		dc.w PLC_GHZ2-ArtLoadCues
ptr_PLC_LZ:			dc.w PLC_LZ-ArtLoadCues
ptr_PLC_LZ2:		dc.w PLC_LZ2-ArtLoadCues
ptr_PLC_MZ:			dc.w PLC_MZ-ArtLoadCues
ptr_PLC_MZ2:		dc.w PLC_MZ2-ArtLoadCues
ptr_PLC_SLZ:		dc.w PLC_SLZ-ArtLoadCues
ptr_PLC_SLZ2:		dc.w PLC_SLZ2-ArtLoadCues
ptr_PLC_SZ:			dc.w PLC_SZ-ArtLoadCues
ptr_PLC_SZ2:		dc.w PLC_SZ2-ArtLoadCues
ptr_PLC_CWZ:		dc.w PLC_CWZ-ArtLoadCues
ptr_PLC_CWZ2:		dc.w PLC_CWZ2-ArtLoadCues

ptr_PLC_TitleCard:	dc.w PLC_TitleCard-ArtLoadCues
ptr_PLC_Boss:		dc.w PLC_Boss-ArtLoadCues
ptr_PLC_Signpost:	dc.w PLC_Signpost-ArtLoadCues
ptr_PLC_Warp:		dc.w PLC_Warp-ArtLoadCues
ptr_PLC_SpecialStage:	dc.w PLC_SpecialStage-ArtLoadCues
PLC_Animals:
ptr_PLC_GHZAnimals:	dc.w PLC_GHZAnimals-ArtLoadCues
ptr_PLC_LZAnimals:	dc.w PLC_LZAnimals-ArtLoadCues
ptr_PLC_MZAnimals:	dc.w PLC_MZAnimals-ArtLoadCues
ptr_PLC_SLZAnimals:	dc.w PLC_SLZAnimals-ArtLoadCues
ptr_PLC_SZAnimals:	dc.w PLC_SZAnimals-ArtLoadCues
ptr_PLC_CWZAnimals:	dc.w PLC_CWZAnimals-ArtLoadCues
		
plcm:	macro gfx,vram
	dc.l gfx
	dc.w (vram)*tile_size
	endm

; ---------------------------------------------------------------------------
; Pattern load cues - standard block 1
; ---------------------------------------------------------------------------
PLC_Main:	dc.w ((PLC_Mainend-PLC_Main-2)/6)-1
		plcm	Nem_Smoke,  ArtTile_Lamppost      ; smoke
		plcm	Nem_HUD,    ArtTile_HUD           ; HUD
		plcm	Nem_Lives,  ArtTile_Lives_Counter ; lives counter
		plcm	Nem_Ring,   ArtTile_Ring          ; rings
		plcm    Nem_Points, ArtTile_Points        ; points from enemy
PLC_Mainend:
; ---------------------------------------------------------------------------
; Pattern load cues - standard block 2
; ---------------------------------------------------------------------------
PLC_Main2:	dc.w ((PLC_Main2end-PLC_Main2-2)/6)-1
		plcm    Nem_Monitors, ArtTile_Monitor       ; monitors
		plcm    Nem_Shield,   ArtTile_Shield        ; shield
		plcm    Nem_Stars,    ArtTile_Invincibility ; invincibility stars
PLC_Main2end:
; ---------------------------------------------------------------------------
; Pattern load cues - explosion
; ---------------------------------------------------------------------------
PLC_Explode:	dc.w ((PLC_Explodeend-PLC_Explode-2)/6)-1
		plcm    Nem_Explode, ArtTile_Explosion ; explosion
PLC_Explodeend:
; ---------------------------------------------------------------------------
; Pattern load cues - game/time	over
; ---------------------------------------------------------------------------
PLC_GameOver:	dc.w ((PLC_GameOverend-PLC_GameOver-2)/6)-1
		plcm    Nem_GameOver, ArtTile_Game_Over ; game/time over
PLC_GameOverend:
; ---------------------------------------------------------------------------
; Pattern load cues - Green Hill
; ---------------------------------------------------------------------------
PLC_GHZ:	dc.w ((PLC_GHZ2-PLC_GHZ-2)/6)-1
		plcm    Nem_GHZ_1st, ArtTile_Level
		plcm    Nem_GHZ_2nd, ArtTile_Level+$1CD
		plcm    Nem_Stalk, ArtTile_GHZ_Flower_Stalk
		plcm    Nem_PplRock, ArtTile_GHZ_Purple_Rock
		plcm    Nem_Crabmeat, ArtTile_Crabmeat
		plcm    Nem_Buzz, ArtTile_Buzz_Bomber
		plcm    Nem_Chopper, ArtTile_Chopper
		plcm    Nem_Newtron, ArtTile_Newtron
		plcm    Nem_Motobug, ArtTile_Moto_Bug
		plcm    Nem_Spikes, ArtTile_Spikes
		plcm    Nem_HSpring, ArtTile_Spring_Horizontal
		plcm    Nem_VSpring, ArtTile_Spring_Vertical

PLC_GHZ2:	dc.w ((PLC_GHZ2end-PLC_GHZ2-2)/6)-1
		plcm    Nem_Swing, ArtTile_GHZ_MZ_Swing
		plcm    Nem_Bridge, ArtTile_GHZ_Bridge
		plcm    Nem_SpikePole, ArtTile_GHZ_Spike_Pole
		plcm    Nem_Ball, ArtTile_GHZ_Giant_Ball
		plcm    Nem_GhzWall1, ArtTile_GHZ_SLZ_Smashable_Wall
		plcm    Nem_GhzWall2, ArtTile_GHZ_Edge_Wall
PLC_GHZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Labyrinth
; ---------------------------------------------------------------------------
PLC_LZ:		dc.w ((PLC_LZ2-PLC_LZ-2)/6)-1
		plcm    Nem_LZ, ArtTile_Level

PLC_LZ2:	dc.w ((PLC_LZ2end-PLC_LZ2-2)/6)-1
		plcm    Nem_Jaws, $4CE
PLC_LZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Marble
; ---------------------------------------------------------------------------
PLC_MZ:		dc.w ((PLC_MZ2-PLC_MZ-2)/6)-1
		plcm    Nem_MZ, ArtTile_Level
		plcm    Nem_MzMetal, ArtTile_MZ_Spike_Stomper
		plcm    Nem_MzFire, ArtTile_MZ_Fireball
		plcm    Nem_Swing, ArtTile_GHZ_MZ_Swing
		plcm    Nem_MzGlass, ArtTile_MZ_Glass_Pillar
		plcm    Nem_Lava, ArtTile_MZ_Lava
		plcm    Nem_Buzz, ArtTile_Buzz_Bomber
		plcm    Nem_Yadrin, ArtTile_Yadrin
		plcm    Nem_Basaran, ArtTile_Basaran
		plcm    Nem_Splats, ArtTile_Splats

PLC_MZ2:	dc.w ((PLC_MZ2end-PLC_MZ2-2)/6)-1
		plcm    Nem_MzSwitch, ArtTile_Button+4
		plcm    Nem_Spikes, ArtTile_Spikes
		plcm    Nem_HSpring, ArtTile_Spring_Horizontal
		plcm    Nem_VSpring, ArtTile_Spring_Vertical
		plcm    Nem_MzBlock, ArtTile_MZ_Block
PLC_MZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Star Light
; ---------------------------------------------------------------------------
PLC_SLZ:	dc.w ((PLC_SLZ2-PLC_SLZ-2)/6)-1
		plcm    Nem_SLZ, ArtTile_Level
		plcm    Nem_MzFire, ArtTile_SLZ_Fireball
		plcm    Nem_Crabmeat, ArtTile_Crabmeat
		plcm    Nem_Buzz, ArtTile_Buzz_Bomber
		plcm    Nem_SLZ_Platfm, ArtTile_SLZ_Platform
		plcm    Nem_SlzBlock, ArtTile_SLZ_Smashable_Wall
		plcm    Nem_Motobug, ArtTile_Moto_Bug
		plcm    byte_294DA, ArtTile_SLZ_Fireball_Launcher
		plcm    Nem_Spikes, ArtTile_Spikes
		plcm    Nem_HSpring, ArtTile_Spring_Horizontal
		plcm    Nem_VSpring, ArtTile_Spring_Vertical

PLC_SLZ2:	dc.w ((PLC_SLZ2end-PLC_SLZ2-2)/6)-1
		plcm    Nem_Seesaw, ArtTile_SLZ_Seesaw
		plcm    Nem_Fan, ArtTile_SLZ_Fan
		plcm    Nem_Pylon, ArtTile_SLZ_Pylon
		plcm    Nem_SlzSwing, ArtTile_SLZ_Swing
PLC_SLZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Sparkling
; ---------------------------------------------------------------------------
PLC_SZ:		dc.w ((PLC_SZ2-PLC_SZ-2)/6)-1
		plcm    Nem_SZ, ArtTile_Level
		plcm    Nem_Crabmeat, ArtTile_Crabmeat
		plcm    Nem_Buzz, ArtTile_Buzz_Bomber
		plcm    Nem_Yadrin, ArtTile_Yadrin
		plcm    Nem_Roller, ArtTile_Roller

PLC_SZ2:	dc.w ((PLC_SZ2end-PLC_SZ2-2)/6)-1
		plcm    Nem_Bumper, ArtTile_SZ_Bumper
		plcm    Nem_SyzSpike1, ArtTile_SZ_Big_Spikeball
		plcm    Nem_SyzSpike2, ArtTile_SZ_Spikeball_Chain
		plcm    Nem_Switch, ArtTile_Button
		plcm    Nem_Spikes, ArtTile_Spikes
		plcm    Nem_HSpring, ArtTile_Spring_Horizontal
		plcm    Nem_VSpring, ArtTile_Spring_Vertical
PLC_SZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - Clock Work
; ---------------------------------------------------------------------------
PLC_CWZ:	dc.w ((PLC_CWZ2-PLC_CWZ-2)/6)-1
		plcm    Nem_CWZ, ArtTile_Level

PLC_CWZ2:	dc.w ((PLC_CWZ2end-PLC_CWZ2-2)/6)-1
		plcm    Nem_Jaws, $4CE
PLC_CWZ2end:
; ---------------------------------------------------------------------------
; Pattern load cues - title card
; ---------------------------------------------------------------------------
PLC_TitleCard:	dc.w ((PLC_TitleCardend-PLC_TitleCard-2)/6)-1
		plcm    Nem_TitleCard, ArtTile_Title_Card
PLC_TitleCardend:
; ---------------------------------------------------------------------------
; Pattern load cues - act 3 boss
; ---------------------------------------------------------------------------
PLC_Boss:	dc.w ((PLC_Bossend-PLC_Boss-2)/6)-1
		plcm    Nem_Eggman, ArtTile_Eggman
		plcm    Nem_Weapons, ArtTile_Eggman_Weapons
		plcm    Nem_Prison, ArtTile_Prison_Capsule
PLC_Bossend:
; ---------------------------------------------------------------------------
; Pattern load cues - act 1/2 signpost
; ---------------------------------------------------------------------------
PLC_Signpost:	dc.w ((PLC_Signpostend-PLC_Signpost-2)/6)-1
		plcm    Nem_SignPost, ArtTile_Signpost
PLC_Signpostend:
; ---------------------------------------------------------------------------
; Pattern load cues - special stage warp effect
; ---------------------------------------------------------------------------
PLC_Warp:	dc.w ((PLC_Warpend-PLC_Warp-2)/6)-1
		plcm    Nem_Flash, ArtTile_Warp
PLC_Warpend:
; ---------------------------------------------------------------------------
; Pattern load cues - special stage
; ---------------------------------------------------------------------------
PLC_SpecialStage:	dc.w ((PLC_SpeStageend-PLC_SpecialStage-2)/6)-1
		plcm    Nem_SSBgCloud, ArtTile_SS_Background_Clouds
		plcm    Nem_SSBgFish, ArtTile_SS_Background_Fish
		plcm    Nem_SSWalls, ArtTile_SS_Wall
		plcm    Nem_Bumper, ArtTile_SS_Bumper
		plcm    Nem_SSGOAL, ArtTile_SS_Goal
		plcm    Nem_SSUpDown, ArtTile_SS_Up_Down
		plcm    Nem_SSRBlock, ArtTile_SS_R_Block
		plcm    Nem_SS1UpBlock, ArtTile_SS_Extra_Life
		plcm    Nem_SSEmStars, ArtTile_SS_Emerald_Sparkle
		plcm    Nem_SSRedWhite, ArtTile_SS_Red_White_Block
		plcm    Nem_SSSkull, ArtTile_SS_Skull_Block
		plcm    Nem_SSUBlock, ArtTile_SS_U_Block
PLC_SpeStageend:
		; unused
		plcm    Nem_SSEmerald, 0
		plcm    Nem_SSZone1, 0
		plcm    Nem_SSZone2, 0
		plcm    Nem_SSZone3, 0
		plcm    Nem_SSZone4, 0
		plcm    Nem_SSZone5, 0
		plcm    Nem_SSZone6, 0
; ---------------------------------------------------------------------------
; Pattern load cues - GHZ animals
; ---------------------------------------------------------------------------
PLC_GHZAnimals:	dc.w ((PLC_GHZAnimalsend-PLC_GHZAnimals-2)/6)-1
		plcm    Nem_Rabbit, ArtTile_Animal_1
		plcm    Nem_Chicken, ArtTile_Animal_2
PLC_GHZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - LZ animals
; ---------------------------------------------------------------------------
PLC_LZAnimals:	dc.w ((PLC_LZAnimalsend-PLC_LZAnimals-2)/6)-1
		plcm    Nem_Penguin, ArtTile_Animal_1
		plcm    Nem_Seal, ArtTile_Animal_2
PLC_LZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - MZ animals
; ---------------------------------------------------------------------------
PLC_MZAnimals:	dc.w ((PLC_MZAnimalsend-PLC_MZAnimals-2)/6)-1
		plcm    Nem_Pig, ArtTile_Animal_1
		plcm    Nem_Flicky, ArtTile_Animal_2
PLC_MZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - SLZ animals
; ---------------------------------------------------------------------------
PLC_SLZAnimals:	dc.w ((PLC_SLZAnimalsend-PLC_SLZAnimals-2)/6)-1
		plcm    Nem_Squirrel, ArtTile_Animal_1
		plcm    Nem_Seal, ArtTile_Animal_2
PLC_SLZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - SZ animals
; ---------------------------------------------------------------------------
PLC_SZAnimals:	dc.w ((PLC_SZAnimalsend-PLC_SZAnimals-2)/6)-1
		plcm    Nem_Pig, ArtTile_Animal_1
		plcm    Nem_Chicken, ArtTile_Animal_2
PLC_SZAnimalsend:
; ---------------------------------------------------------------------------
; Pattern load cues - CWZ animals
; ---------------------------------------------------------------------------
PLC_CWZAnimals:	dc.w ((PLC_CWZAnimalsend-PLC_CWZAnimals-2)/6)-1
		plcm    Nem_Rabbit, ArtTile_Animal_1
		plcm    Nem_Flicky, ArtTile_Animal_2
PLC_CWZAnimalsend:
		even
                
; ---------------------------------------------------------------------------
; Pattern load cue IDs
; ---------------------------------------------------------------------------
plcid_Main:		= (ptr_PLC_Main-ArtLoadCues)/2 ; 0
plcid_Main2:	= (ptr_PLC_Main2-ArtLoadCues)/2 ; 1
plcid_Explode:	= (ptr_PLC_Explode-ArtLoadCues)/2 ; 2
plcid_GameOver:	= (ptr_PLC_GameOver-ArtLoadCues)/2 ; 3
plcid_GHZ:		= (ptr_PLC_GHZ-ArtLoadCues)/2	; 4
plcid_GHZ2:		= (ptr_PLC_GHZ2-ArtLoadCues)/2 ; 5
plcid_LZ:		= (ptr_PLC_LZ-ArtLoadCues)/2	; 6
plcid_LZ2:		= (ptr_PLC_LZ2-ArtLoadCues)/2	; 7
plcid_MZ:		= (ptr_PLC_MZ-ArtLoadCues)/2	; 8
plcid_MZ2:		= (ptr_PLC_MZ2-ArtLoadCues)/2	; 9
plcid_SLZ:		= (ptr_PLC_SLZ-ArtLoadCues)/2	; $A
plcid_SLZ2:		= (ptr_PLC_SLZ2-ArtLoadCues)/2 ; $B
plcid_SZ:		= (ptr_PLC_SZ-ArtLoadCues)/2	; $C
plcid_SZ2:		= (ptr_PLC_SZ2-ArtLoadCues)/2	; $D
plcid_CWZ:		= (ptr_PLC_CWZ-ArtLoadCues)/2	; $E
plcid_CWZ2:		= (ptr_PLC_CWZ2-ArtLoadCues)/2 ; $F
plcid_TitleCard:	= (ptr_PLC_TitleCard-ArtLoadCues)/2 ; $10
plcid_Boss:		= (ptr_PLC_Boss-ArtLoadCues)/2 ; $11
plcid_Signpost:		= (ptr_PLC_Signpost-ArtLoadCues)/2 ; $12
plcid_Warp:		= (ptr_PLC_Warp-ArtLoadCues)/2 ; $13
plcid_SpecialStage:	= (ptr_PLC_SpecialStage-ArtLoadCues)/2 ; $14
plcid_GHZAnimals:	= (ptr_PLC_GHZAnimals-ArtLoadCues)/2 ; $15
plcid_LZAnimals:	= (ptr_PLC_LZAnimals-ArtLoadCues)/2 ; $16
plcid_MZAnimals:	= (ptr_PLC_MZAnimals-ArtLoadCues)/2 ; $17
plcid_SLZAnimals:	= (ptr_PLC_SLZAnimals-ArtLoadCues)/2 ; $18
plcid_SZAnimals:	= (ptr_PLC_SZAnimals-ArtLoadCues)/2 ; $19
plcid_CWZAnimals:	= (ptr_PLC_CWZAnimals-ArtLoadCues)/2 ; $1A