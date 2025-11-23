; ---------------------------------------------------------------------------
; Special stage mappings and VRAM pointers
; ---------------------------------------------------------------------------
specialStageData: macro frame,mappings,palette,vram
		dc.l	mappings|(frame<<24)
		dc.w	make_art_tile(vram,palette,0)
		endm

		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   3, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   0, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   1, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_SSWalls,   2, ArtTile_SS_Wall
		specialStageData	0, Map_Ring,      1, ArtTile_Ring
		specialStageData	0, Map_Bump,      0, ArtTile_SS_Bumper
		specialStageData	0, Map_SS_Goal,   0, ArtTile_SS_Goal
		specialStageData	0, Map_SS_Goal_R, 0, ArtTile_SS_Goal
		specialStageData	0, Map_SS_Up,     0, ArtTile_SS_Up_Down
		specialStageData	0, Map_SS_Down,   0, ArtTile_SS_Up_Down
		specialStageData	4, Map_Ring,      1, ArtTile_Ring
		specialStageData	5, Map_Ring,      1, ArtTile_Ring
		specialStageData	6, Map_Ring,      1, ArtTile_Ring
		specialStageData	7, Map_Ring,      1, ArtTile_Ring
		specialStageData	1, Map_Bump,      0, ArtTile_SS_Bumper
		specialStageData	2, Map_Bump,      0, ArtTile_SS_Bumper