DebugLists:
		dc.w .GHZ-DebugLists
		dc.w .LZ-DebugLists
		dc.w .MZ-DebugLists
		dc.w .SLZ-DebugLists
		dc.w .SZ-DebugLists
		dc.w .CWZ-DebugLists

dbug:	macro map,object,subtype,frame,vram
	dc.l map+(object<<24)
	dc.b subtype,frame
	dc.w vram
	endm

.GHZ:
	dc.w (.GHZend-.GHZ-2)/8
;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	make_art_tile(ArtTile_Crabmeat,0,0)
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	make_art_tile(ArtTile_Buzz_Bomber,0,0)
	dbug	Map_Chop,	id_Chopper,	0,	0,	make_art_tile(ArtTile_Chopper,0,0)
	dbug	Map_Spike,	id_Spikes,	0,	0,	make_art_tile(ArtTile_Spikes,0,0)
	dbug	Map_Plat_GHZ,	id_BasicPlatform,	0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_PRock,	id_PurpleRock,	0,	0,	make_art_tile(ArtTile_GHZ_Purple_Rock,3,0)
	dbug	Map_Moto,	id_MotoBug,	0,	0,	make_art_tile(ArtTile_Moto_Bug,0,0)
	dbug	Map_Spring,	id_Springs,	0,	0,	make_art_tile(ArtTile_Spring_Horizontal,0,0)
	dbug	Map_Newt,	id_Newtron,	0,	0,	make_art_tile(ArtTile_Newtron,1,0)
	dbug	Map_Edge,	id_EdgeWalls,	0,	0,	make_art_tile(ArtTile_GHZ_Edge_Wall,2,0)
	dbug	Map_GBall,	id_GBall,	0,	0,	make_art_tile(ArtTile_GHZ_Giant_Ball,2,0)
.GHZend:

.LZ:
	dc.w (.LZend-.LZ-2)/8
;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	make_art_tile(ArtTile_Crabmeat,0,0)
.LZend:

.MZ:
	dc.w (.MZend-.MZ-2)/8
;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	make_art_tile(ArtTile_Buzz_Bomber,0,0)
	dbug	Map_Spike,	id_Spikes,	0,	0,	make_art_tile(ArtTile_Spikes,0,0)
	dbug	Map_Spring,	id_Springs,	0,	0,	make_art_tile(ArtTile_Spring_Horizontal,0,0)
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	make_art_tile(ArtTile_MZ_Fireball,0,0)
	dbug	Map_Brick,	id_MarbleBrick,	0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_Geyser,	id_GeyserMaker,	0,	0,	make_art_tile(ArtTile_MZ_Lava,3,0)
	dbug	Map_LWall,	id_LavaWall,	0,	0,	make_art_tile(ArtTile_MZ_Lava,3,0)
	dbug	Map_Push,	id_PushBlock,	0,	0,	make_art_tile(ArtTile_MZ_Block,2,0)
	dbug	Map_Splats,	id_Splats,	0,	0,	make_art_tile(ArtTile_Splats,0,0)
	if FixBugs
	dbug	Map_Yadrin,	id_Yadrin,	0,	0,	make_art_tile(ArtTile_Yadrin,1,0)
	else
	; Yadrin is using Sonic's palette, when it should be using it's own.
	dbug	Map_Yadrin,	id_Yadrin,	0,	0,	make_art_tile(ArtTile_Yadrin,0,0)
	endif
	dbug	Map_Smab,	id_SmashBlock,	0,	0,	make_art_tile(ArtTile_MZ_Block,2,0)
	if FixBugs
	dbug	Map_MBlock,	id_MovingBlock,	0,	0,	make_art_tile(ArtTile_MZ_Block,2,0)
	dbug	Map_CFlo,	id_CollapseFloor,	0,	0,	make_art_tile(ArtTile_MZ_Block,2,0)
	else
	; The moving block is using Sonic's palette, when it should be using the 2nd level palette line.
	dbug	Map_MBlock,	id_MovingBlock,	0,	0,	make_art_tile(ArtTile_MZ_Block,0,0)
	; The collapsing floor is using the last palette, when it should be using the 2nd level palette line.
	dbug	Map_CFlo,	id_CollapseFloor,	0,	0,	make_art_tile(ArtTile_MZ_Block,3,0)
	endif
	dbug	Map_LTag,	id_LavaTag,	0,	0,	make_art_tile(ArtTile_Monitor,0,1)
	dbug	Map_Bas,	id_Basaran,	0,	0,	make_art_tile(ArtTile_Basaran,1,0)
.MZend:

.SLZ:
	dc.w (.SLZend-.SLZ-2)/8
;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Elev,	id_Elevator,	0,	0,	make_art_tile(ArtTile_SLZ_Platform,2,0)
	dbug	Map_CFlo,	id_CollapseFloor,	0,	2,	make_art_tile(ArtTile_SLZ_Smashable_Wall,2,0)
	dbug	Map_Plat_SLZ,	id_BasicPlatform,	0,	0,	make_art_tile(ArtTile_SLZ_Platform,2,0)
	dbug	Map_Circ,	id_CirclingPlatform,	0,	0,	make_art_tile(ArtTile_SLZ_Platform,2,0)
	dbug	Map_Stair,	id_Staircase,	0,	0,	make_art_tile(ArtTile_SLZ_Platform,2,0)
	dbug	Map_Fan,	id_Fan,		0,	0,	make_art_tile(ArtTile_SLZ_Fan,2,0)
	dbug	Map_Seesaw,	id_Seesaw,	0,	0,	make_art_tile(ArtTile_SLZ_Seesaw,0,0)
	dbug	Map_Spring,	id_Springs,	0,	0,	make_art_tile(ArtTile_Spring_Horizontal,0,0)
	dbug	Map_Fire,	id_LavaMaker,	0,	0,	make_art_tile(ArtTile_SLZ_Fireball,0,0)
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	make_art_tile(ArtTile_Crabmeat,0,0)
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	make_art_tile(ArtTile_Buzz_Bomber,0,0)
.SLZend:

.SZ:
	dc.w (.SZend-.SZ-2)/8
;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Spike,	id_Spikes,	0,	0,	make_art_tile(ArtTile_Spikes,0,0)
	dbug	Map_Spring,	id_Springs,	0,	0,	make_art_tile(ArtTile_Spring_Horizontal,0,0)
	dbug	Map_Roll,	id_Roller,	0,	0,	make_art_tile(ArtTile_Roller,1,0)
	dbug	Map_Light,	id_SpinningLight,	0,	0,	make_art_tile(ArtTile_Level,0,0)
	dbug	Map_Bump,	id_Bumper,	0,	0,	make_art_tile(ArtTile_SZ_Bumper,0,0)
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	make_art_tile(ArtTile_Crabmeat,0,0)
	dbug	Map_Buzz,	id_BuzzBomber,	0,	0,	make_art_tile(ArtTile_Buzz_Bomber,0,0)
	if FixBugs
	dbug	Map_Yadrin,	id_Yadrin,	0,	0,	make_art_tile(ArtTile_Yadrin,1,0)
	else
	; Yadrin is using Sonic's palette, when it should be using it's own.
	dbug	Map_Yadrin,	id_Yadrin,	0,	0,	make_art_tile(ArtTile_Yadrin,0,0)
	endif
	dbug	Map_Plat_SZ,	id_BasicPlatform,	0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_FBlock,	id_FloatingBlock,	0,	0,	make_art_tile(ArtTile_Level,2,0)
	dbug	Map_But,	id_Button,	0,	0,	make_art_tile(ArtTile_Button+4,0,0)
.SZend:

.CWZ:
	dc.w (.CWZend-.CWZ-2)/8
;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Ring,	id_Rings,	0,	0,	make_art_tile(ArtTile_Ring,1,0)
	dbug	Map_Monitor,	id_Monitor,	0,	0,	make_art_tile(ArtTile_Monitor,0,0)
	dbug	Map_Crab,	id_Crabmeat,	0,	0,	make_art_tile(ArtTile_Crabmeat,0,0)
.CWZend:

;.DebugUnk:
;		mappings	object		subtype	frame	VRAM setting
	dbug 	Map_Hog,	id_BallHog,	0,	0,	make_art_tile(ArtTile_Ball_Hog,1,0)
	dbug	Map_Jaws,	id_Jaws,	0,	0,	make_art_tile(ArtTile_Jaws,0,0)
	if FixBugs
	dbug	Map_Burro,	id_Burrobot,	0,	0,	make_art_tile(ArtTile_Burrobot,1,0)
	else
	; This will use Jaws's art instead of Burrobot's art.
	dbug	Map_Burro,	id_Burrobot,	0,	0,	make_art_tile(ArtTile_Jaws,1,0)
	endif
;.DebugUnkend: