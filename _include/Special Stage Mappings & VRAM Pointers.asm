; ---------------------------------------------------------------------------
; Special stage mappings and VRAM pointers
; ---------------------------------------------------------------------------
specialStageData: macro frame,mappings,palette,vram
		dc.l	mappings|(frame<<24)
		dc.w	vram|palette
		endm

		specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal4, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   Tile_Pal3, ArtTile_SS_Wall
		specialStageData	0, Map_Ring,      Tile_Pal2, ArtTile_Ring
		specialStageData	0, Map_Bump,      Tile_Pal1, ArtTile_SS_Bumper
		specialStageData	0, Map_SS_Goal,   Tile_Pal1, ArtTile_SS_Goal
		specialStageData	0, Map_SS_Goal_R, Tile_Pal1, ArtTile_SS_Goal
		specialStageData	0, Map_SS_Up,     Tile_Pal1, ArtTile_SS_Up_Down
		specialStageData	0, Map_SS_Down,   Tile_Pal1, ArtTile_SS_Up_Down
		specialStageData	4, Map_Ring,      Tile_Pal2, ArtTile_Ring
		specialStageData	5, Map_Ring,      Tile_Pal2, ArtTile_Ring
		specialStageData	6, Map_Ring,      Tile_Pal2, ArtTile_Ring
		specialStageData	7, Map_Ring,      Tile_Pal2, ArtTile_Ring
		specialStageData	1, Map_Bump,      Tile_Pal1, ArtTile_SS_Bumper
		specialStageData	2, Map_Bump,      Tile_Pal1, ArtTile_SS_Bumper