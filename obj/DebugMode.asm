; ---------------------------------------------------------------------------

DebugMode:
		moveq	#0,d0
		move.b	(v_debuguse).w,d0
		move.w	off_11E74(pc,d0.w),d1
		jmp	off_11E74(pc,d1.w)
; ===========================================================================
off_11E74:
		dc.w	loc_11E78-off_11E74
		dc.w	loc_11EB8-off_11E74
; ===========================================================================

loc_11E78:
		addq.b	#2,(v_debuguse).w
		move.b	#0,obFrame(a0)
		move.b	#0,obAnim(a0)
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(DebugLists).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		cmp.b	(v_debugitem).w,d6
		bhi.s	loc_11EA8
		move.b	#0,(v_debugitem).w

loc_11EA8:
		bsr.w	sub_11FCE
		move.b	#$C,(v_debugxspeed).w
		move.b	#1,(v_debugyspeed).w

loc_11EB8:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(DebugLists).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		bsr.w	sub_11ED6
		jmp	(DisplaySprite).l
; ===========================================================================

sub_11ED6:
		moveq	#0,d4
		move.w	#1,d1
		move.b	(v_jpadpress1).w,d4
		bne.s	loc_11F0E
		tst.b	(v_jpadhold1).w
		bne.s	loc_11EF6
		move.b	#$C,(v_debugxspeed).w
		move.b	#$F,(v_debugyspeed).w
		rts
; ===========================================================================

loc_11EF6:
		subq.b	#1,(v_debugxspeed).w
		bne.s	loc_11F12
		move.b	#1,(v_debugxspeed).w
		addq.b	#1,(v_debugyspeed).w
		bne.s	loc_11F0E
		move.b	#-1,(v_debugyspeed).w

loc_11F0E:
		move.b	(v_jpadhold1).w,d4

loc_11F12:
		moveq	#0,d1
		move.b	(v_debugyspeed).w,d1
		addq.w	#1,d1
		swap	d1
		asr.l	#4,d1
		move.l	obY(a0),d2
		move.l	obX(a0),d3
		btst	#bitUp,d4
		beq.s	loc_11F32
		sub.l	d1,d2
		bcc.s	loc_11F32
		moveq	#0,d2

loc_11F32:
		btst	#bitDn,d4
		beq.s	loc_11F48
		add.l	d1,d2
		cmpi.l	#$7FF0000,d2
		bcs.s	loc_11F48
		move.l	#$7FF0000,d2

loc_11F48:
		btst	#bitL,d4
		beq.s	loc_11F54
		sub.l	d1,d3
		bcc.s	loc_11F54
		moveq	#0,d3

loc_11F54:
		btst	#bitR,d4
		beq.s	loc_11F5C
		add.l	d1,d3

loc_11F5C:
		move.l	d2,obY(a0)
		move.l	d3,obX(a0)
		btst	#bitA,(v_jpadpress2).w
		beq.s	loc_11F80
		addq.b	#1,(v_debugitem).w
		cmp.b	(v_debugitem).w,d6
		bhi.s	loc_11F7C
		move.b	#0,(v_debugitem).w

loc_11F7C:
		bra.w	sub_11FCE
; ===========================================================================

loc_11F80:
		btst	#bitC,(v_jpadpress2).w
		beq.s	loc_11FA4
		jsr	(FindFreeObj).l
		bne.s	loc_11FA4
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		_move.b	obMap(a0),obID(a1)
		rts
; ===========================================================================

loc_11FA4:
		btst	#bitB,(v_jpadpress2).w
		beq.s	locret_11FCC
		moveq	#0,d0
		move.w	d0,(v_debuguse).w
		move.l	#Map_Sonic,(v_player+obMap).w
		move.w	#ArtTile_Sonic,(v_player+obGfx).w
		move.b	d0,(v_player+obAnim).w
		move.w	d0,obX+2(a0)
		move.w	d0,obY+2(a0)

locret_11FCC:
		rts
; ===========================================================================

sub_11FCE:
		moveq	#0,d0
		move.b	(v_debugitem).w,d0
		lsl.w	#3,d0
		move.l	(a2,d0.w),obMap(a0)
		move.w	6(a2,d0.w),obGfx(a0)
		move.b	5(a2,d0.w),obFrame(a0)
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Debug mode item lists
; ---------------------------------------------------------------------------
DebugLists:
		dc.w .GHZ-DebugLists
		dc.w .LZ-DebugLists
		dc.w .MZ-DebugLists
		dc.w .SLZ-DebugLists
		dc.w .SZ-DebugLists
		dc.w .CWZ-DebugLists

dbug:		macro map,object,subtype,frame,vram
		dc.l map+(object<<24)
		dc.b subtype,frame
		dc.w vram
		endm

.GHZ:
		dc.w (.GHZend-.GHZ-2)/8
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Crab,	id_Crabmeat,		0,	0,	ArtTile_Crabmeat
		dbug	Map_Buzz,	id_BuzzBomber,		0,	0,	ArtTile_Buzz_Bomber
		dbug	Map_Chop,	id_Chopper,		0,	0,	ArtTile_Chopper
		dbug	Map_Spike,	id_Spikes,		0,	0,	ArtTile_Spikes
		dbug	Map_Plat_GHZ,	id_BasicPlatform,	0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_PRock,	id_PurpleRock,		0,	0,	ArtTile_GHZ_Purple_Rock|Tile_Pal4
		dbug	Map_Moto,	id_MotoBug,		0,	0,	ArtTile_Moto_Bug
		dbug	Map_Spring,	id_Springs,		0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Newt,	id_Newtron,		0,	0,	ArtTile_Newtron|Tile_Pal2
		dbug	Map_Edge,	id_EdgeWalls,		0,	0,	ArtTile_GHZ_Edge_Wall|Tile_Pal3
		dbug	Map_GBall,	id_GHZBall,		0,	0,	ArtTile_GHZ_Giant_Ball|Tile_Pal3
.GHZend:

.LZ:
		dc.w (.LZend-.LZ-2)/8
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Crab,	id_Crabmeat,		0,	0,	ArtTile_Crabmeat
.LZend:

.MZ:
		dc.w (.MZend-.MZ-2)/8
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Buzz,	id_BuzzBomber,		0,	0,	ArtTile_Buzz_Bomber
		dbug	Map_Spike,	id_Spikes,		0,	0,	ArtTile_Spikes
		dbug	Map_Spring,	id_Springs,		0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Fire,	id_LavaMaker,		0,	0,	ArtTile_MZ_Fireball
		dbug	Map_Brick,	id_MarbleBrick,		0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_Geyser,	id_GeyserMaker,		0,	0,	ArtTile_MZ_Lava|Tile_Pal4
		dbug	Map_LWall,	id_LavaWall,		0,	0,	ArtTile_MZ_Lava|Tile_Pal4
		dbug	Map_Push,	id_PushBlock,		0,	0,	ArtTile_MZ_Block|Tile_Pal3
		dbug	Map_Splats,	id_Splats,		0,	0,	ArtTile_Splats
	if FixBugs
		dbug	Map_Yad,	id_Yadrin,		0,	0,	ArtTile_Yadrin|Tile_Pal2
	else
		; Yadrin is using Sonic's palette, when it should be using it's own.
		dbug	Map_Yad,	id_Yadrin,		0,	0,	ArtTile_Yadrin
	endif
		dbug	Map_Smab,	id_SmashBlock,		0,	0,	ArtTile_MZ_Block|Tile_Pal3
	if FixBugs
		dbug	Map_MBlock,	id_MovingBlock,		0,	0,	ArtTile_MZ_Block|Tile_Pal3
		dbug	Map_CFlo,	id_CollapseFloor,	0,	0,	ArtTile_MZ_Block|Tile_Pal3
	else
		; The moving block is using Sonic's palette, when it should be using the 2nd level palette line.
		dbug	Map_MBlock,	id_MovingBlock,		0,	0,	ArtTile_MZ_Block
		; The collapsing floor is using the last palette, when it should be using the 2nd level palette line.
		dbug	Map_CFlo,	id_CollapseFloor,	0,	0,	ArtTile_MZ_Block|Tile_Pal4
	endif
		dbug	Map_LTag,	id_LavaTag,		0,	0,	ArtTile_Monitor|Tile_Prio
		dbug	Map_Bas,	id_Basaran,		0,	0,	ArtTile_Basaran|Tile_Pal2
.MZend:

.SLZ:
		dc.w (.SLZend-.SLZ-2)/8
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Elev,	id_Elevator,		0,	0,	ArtTile_SLZ_Platform|Tile_Pal3
		dbug	Map_CFlo,	id_CollapseFloor,	0,	2,	ArtTile_SLZ_Smashable_Wall|Tile_Pal3
		dbug	Map_Plat_SLZ,	id_BasicPlatform,	0,	0,	ArtTile_SLZ_Platform|Tile_Pal3
		dbug	Map_Circ,	id_CirclingPlatform,	0,	0,	ArtTile_SLZ_Platform|Tile_Pal3
		dbug	Map_Stair,	id_Staircase,		0,	0,	ArtTile_SLZ_Platform|Tile_Pal3
		dbug	Map_Fan,	id_Fan,			0,	0,	ArtTile_SLZ_Fan|Tile_Pal3
		dbug	Map_Seesaw,	id_Seesaw,		0,	0,	ArtTile_SLZ_Seesaw
		dbug	Map_Spring,	id_Springs,		0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Fire,	id_LavaMaker,		0,	0,	ArtTile_SLZ_Fireball
		dbug	Map_Crab,	id_Crabmeat,		0,	0,	ArtTile_Crabmeat
		dbug	Map_Buzz,	id_BuzzBomber,		0,	0,	ArtTile_Buzz_Bomber
.SLZend:

.SZ:
		dc.w (.SZend-.SZ-2)/8
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Spike,	id_Spikes,		0,	0,	ArtTile_Spikes
		dbug	Map_Spring,	id_Springs,		0,	0,	ArtTile_Spring_Horizontal
		dbug	Map_Roll,	id_Roller,		0,	0,	ArtTile_Roller|Tile_Pal2
		dbug	Map_Light,	id_SpinningLight,	0,	0,	ArtTile_Level
		dbug	Map_Bump,	id_Bumper,		0,	0,	ArtTile_SZ_Bumper
		dbug	Map_Crab,	id_Crabmeat,		0,	0,	ArtTile_Crabmeat
		dbug	Map_Buzz,	id_BuzzBomber,		0,	0,	ArtTile_Buzz_Bomber
	if FixBugs
		dbug	Map_Yad,	id_Yadrin,		0,	0,	ArtTile_Yadrin|Tile_Pal2
	else
		; Yadrin is using Sonic's palette, when it should be using it's own.
		dbug	Map_Yad,	id_Yadrin,		0,	0,	ArtTile_Yadrin
	endif
		dbug	Map_Plat_SZ,	id_BasicPlatform,	0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_FBlock,	id_FloatingBlock,	0,	0,	ArtTile_Level|Tile_Pal3
		dbug	Map_But,	id_Button,		0,	0,	ArtTile_Button+4
.SZend:

.CWZ:
		dc.w (.CWZend-.CWZ-2)/8
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Ring,	id_Rings,		0,	0,	ArtTile_Ring|Tile_Pal2
		dbug	Map_Monitor,	id_Monitor,		0,	0,	ArtTile_Monitor
		dbug	Map_Crab,	id_Crabmeat,		0,	0,	ArtTile_Crabmeat
.CWZend:

;.DebugUnused:
		;	mappings	object			subtype	frame	VRAM setting
		dbug 	Map_Hog,	id_BallHog,		0,	0,	ArtTile_Ball_Hog|Tile_Pal2
		dbug	Map_Jaws,	id_Jaws,		0,	0,	ArtTile_Jaws
	if FixBugs
		dbug	Map_Burro,	id_Burrobot,		0,	0,	ArtTile_Burrobot|Tile_Pal2
	else
		; This uses Jaws's art tile instead of Burrobot's art tile.
		dbug	Map_Burro,	id_Burrobot,		0,	0,	ArtTile_Jaws|Tile_Pal2
	endif
;.DebugUnusedend: