; ---------------------------------------------------------------------------
; Palette index
; ---------------------------------------------------------------------------

paletteIndexEntry:	macro paletteLabel,paletteRAMaddress,paletteSize,{GLOBALSYMBOLS}

ptr_paletteLabel:
	dc.l paletteLabel
	dc.w paletteRAMaddress,(paletteSize)/2-1
	endm

Pal_Index:
	; FORMAT:			Palette label,		RAM location,		Amount of colors in palette
	paletteIndexEntry	Pal_SegaBG, 		v_palette_line_1,	16*4
	paletteIndexEntry	Pal_Title,			v_palette_line_1,	16*4
	paletteIndexEntry	Pal_LevelSel,		v_palette_line_1, 	16*4
	paletteIndexEntry	Pal_Sonic,			v_palette_line_1,	16
	paletteIndexEntry	Pal_GHZ, 			v_palette_line_2,	16*3
	paletteIndexEntry	Pal_LZ, 			v_palette_line_2,	16*3
	paletteIndexEntry	Pal_MZ, 			v_palette_line_2,	16*3
	paletteIndexEntry	Pal_SLZ,			v_palette_line_2,	16*3
	paletteIndexEntry	Pal_SZ,				v_palette_line_2,	16*3
	paletteIndexEntry	Pal_CWZ, 			v_palette_line_2,	16*3
	paletteIndexEntry	Pal_Special, 		v_palette_line_1,	16*4
	paletteIndexEntry	Pal_Ending, 		v_palette_line_1,	16*4
	even

; ---------------------------------------------------------------------------
; Palette index IDs
; ---------------------------------------------------------------------------

palid_SegaBG:	= (ptr_Pal_SegaBG-Pal_Index)/8
palid_Title:	= (ptr_Pal_Title-Pal_Index)/8
palid_LevelSel:	= (ptr_Pal_LevelSel-Pal_Index)/8
palid_Sonic:	= (ptr_Pal_Sonic-Pal_Index)/8
palid_GHZ:	= (ptr_Pal_GHZ-Pal_Index)/8
palid_LZ:	= (ptr_Pal_LZ-Pal_Index)/8
palid_MZ:	= (ptr_Pal_MZ-Pal_Index)/8
palid_SLZ:	= (ptr_Pal_SLZ-Pal_Index)/8
palid_SZ:	= (ptr_Pal_SZ-Pal_Index)/8
palid_CWZ:	= (ptr_Pal_CWZ-Pal_Index)/8
palid_Special:	= (ptr_Pal_Special-Pal_Index)/8
palid_Ending:	= (ptr_Pal_Ending-Pal_Index)/8