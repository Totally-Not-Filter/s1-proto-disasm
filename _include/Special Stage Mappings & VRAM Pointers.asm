; ===========================================================================
; ---------------------------------------------------------------------------
; Special stage mappings and VRAM pointers (loaded into v_ss_spritesettings)
; ---------------------------------------------------------------------------

SS_MapIndex:

specialStageData: macro frame,mappings,palette,vram,{INTLABEL}
__LABEL__:	label	(*-SS_MapIndex)/(4+2)+1
		dc.l	(frame<<24)|mappings
		dc.w	palette|vram
		endm

; Blank block is implicitly added to v_ss_spritesettings by skipping over the first 8 bytes
; id_SS_Blank:		specialStageData	0, 0		  0,	     0				; $00 - blank block

; Square wall blocks (0th blocks per color are static and don't animate)
id_SS_WallBlue_0:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $01 - wall block (blue)
id_SS_WallYellow_0:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $02 - wall block (yellow)
id_SS_WallPink_0:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $03 - wall block (pink)
id_SS_WallGreen_0:	specialStageData	0, Map_SSWalls,   Tile_Pal4, ArtTile_SS_Wall		; $04 - wall block (green)

id_SS_WallBlue_1:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $05 - wall block (blue)
id_SS_WallBlue_2:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $06 - ''
id_SS_WallBlue_3:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $07 - ''
id_SS_WallBlue_4:	specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall		; $08 - ''

id_SS_WallYellow_1:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $09 - wall block (yellow)
id_SS_WallYellow_2:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $0A - ''
id_SS_WallYellow_3:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $0B - ''
id_SS_WallYellow_4:	specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall		; $0C - ''

id_SS_WallPink_1:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $0D - wall block (pink)
id_SS_WallPink_2:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $0E - ''
id_SS_WallPink_3:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $0F - ''
id_SS_WallPink_4:	specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall		; $10 - ''

; Action blocks
id_SS_Ring:		specialStageData	0, Map_Ring,      Tile_Pal2, ArtTile_Ring		; $11 - ring
id_SS_Bumper:		specialStageData	0, Map_Bump,      Tile_Pal1, ArtTile_SS_Bumper		; $12 - bumper (idle)
id_SS_GOAL:		specialStageData	0, Map_SS_Goal,   Tile_Pal1, ArtTile_SS_Goal		; $13 - GOAL block
id_SS_GOAL_R:		specialStageData	0, Map_SS_Goal_R, Tile_Pal1, ArtTile_SS_Goal		; $14 - Red GOAL block
id_SS_UP:		specialStageData	0, Map_SS_Up,     Tile_Pal1, ArtTile_SS_Up_Down		; $15 - UP block
id_SS_DOWN:		specialStageData	0, Map_SS_Down,   Tile_Pal1, ArtTile_SS_Up_Down		; $16 - DOWN block
id_SS_Ring_Ani1:	specialStageData	4, Map_Ring,      Tile_Pal2, ArtTile_Ring		; $17 - ring (sparkle when collecting)
id_SS_Ring_Ani2:	specialStageData	5, Map_Ring,      Tile_Pal2, ArtTile_Ring		; $18 - ''
id_SS_Ring_Ani3:	specialStageData	6, Map_Ring,      Tile_Pal2, ArtTile_Ring		; $19 - ''
id_SS_Ring_Ani4:	specialStageData	7, Map_Ring,      Tile_Pal2, ArtTile_Ring		; $1A - ''
id_SS_Bumper_Ani1:	specialStageData	1, Map_Bump,      Tile_Pal1, ArtTile_SS_Bumper		; $1B - bumper (touched 1)
id_SS_Bumper_Ani2:	specialStageData	2, Map_Bump,      Tile_Pal1, ArtTile_SS_Bumper		; $1C - ''

SS_MapIndex_End: