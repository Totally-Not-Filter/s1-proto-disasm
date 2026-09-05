; ---------------------------------------------------------------------------
; Palette index
; ---------------------------------------------------------------------------

makePalEntry:	macro paletteLabel,paletteRAMaddress,paletteSize,{INTLABEL},{GLOBALSYMBOLS}
__LABEL__:	label	(*-Pal_Index)/8
		dc.l paletteLabel
		dc.w paletteRAMaddress,(paletteLabel_end-paletteLabel)/4-1
		endm
; ---------------------------------------------------------------------------

Pal_Index:

; Id			Palette label,		RAM location
; NOTE: Palette size is calculated dynamically using an end marker made by bincludeEndMarker
palid_SegaBG:		makePalEntry	Pal_SegaBG, 		v_palette_line_1
palid_Title:		makePalEntry	Pal_Title,		v_palette_line_1
palid_LevelSel:		makePalEntry	Pal_LevelSel,		v_palette_line_1
palid_Sonic:		makePalEntry	Pal_Sonic,		v_palette_line_1

	Pal_Levels:
palid_GHZ:		makePalEntry	Pal_GHZ, 		v_palette_line_2
palid_LZ:		makePalEntry	Pal_LZ, 		v_palette_line_2
palid_MZ:		makePalEntry	Pal_MZ, 		v_palette_line_2
palid_SLZ:		makePalEntry	Pal_SLZ,		v_palette_line_2
palid_SZ:		makePalEntry	Pal_SZ,			v_palette_line_2
palid_CWZ:		makePalEntry	Pal_CWZ, 		v_palette_line_2

palid_Special:		makePalEntry	Pal_Special, 		v_palette_line_1
palid_Unused:		makePalEntry	Pal_Unused, 		v_palette_line_1
	even


; ===========================================================================
; ---------------------------------------------------------------------------
; Palette data bincludes
; ---------------------------------------------------------------------------


Pal_SegaBG:		bincludeEndMarker	"palette/Sega Screen.bin"
Pal_Title:		bincludeEndMarker	"palette/Title Screen.bin"
Pal_LevelSel:		bincludeEndMarker	"palette/Level Select.bin"
Pal_Sonic:		bincludeEndMarker	"palette/Sonic.bin"
Pal_GHZ:		bincludeEndMarker	"palette/Green Hill Zone.bin"
Pal_LZ:			bincludeEndMarker	"palette/Labyrinth Zone.bin"
Pal_Unused:		bincludeEndMarker	"palette/Unused.bin"
Pal_MZ:			bincludeEndMarker	"palette/Marble Zone.bin"
Pal_SLZ:		bincludeEndMarker	"palette/Star Light Zone.bin"
Pal_SZ:			bincludeEndMarker	"palette/Sparkling Zone.bin"
Pal_CWZ:		bincludeEndMarker	"palette/Clock Work Zone.bin"
Pal_Special:		bincludeEndMarker	"palette/Special Stage.bin"