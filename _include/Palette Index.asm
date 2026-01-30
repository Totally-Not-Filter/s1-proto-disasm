; ---------------------------------------------------------------------------
; Palette index
; ---------------------------------------------------------------------------

makePalEntry:	macro paletteLabel,paletteRAMaddress,paletteSize,{INTLABEL},{GLOBALSYMBOLS}

__LABEL__: = (*-Pal_Index)/8
	dc.l paletteLabel
	dc.w paletteRAMaddress,bytesToWcnt(paletteSize)
	endm

Pal_Index:
; Id							Palette label,		RAM location,		Amount of colours in palette
palid_SegaBG:	makePalEntry	Pal_SegaBG, 		v_palette_line_1,	16*4
palid_Title:	makePalEntry	Pal_Title,			v_palette_line_1,	16*4
palid_LevelSel:	makePalEntry	Pal_LevelSel,		v_palette_line_1, 	16*4
palid_Sonic:	makePalEntry	Pal_Sonic,			v_palette_line_1,	16

Pal_Levels:

palid_GHZ:		makePalEntry	Pal_GHZ, 			v_palette_line_2,	16*3
palid_LZ:		makePalEntry	Pal_LZ, 			v_palette_line_2,	16*3
palid_MZ:		makePalEntry	Pal_MZ, 			v_palette_line_2,	16*3
palid_SLZ:		makePalEntry	Pal_SLZ,			v_palette_line_2,	16*3
palid_SZ:		makePalEntry	Pal_SZ,				v_palette_line_2,	16*3
palid_CWZ:		makePalEntry	Pal_CWZ, 			v_palette_line_2,	16*3
palid_Special:	makePalEntry	Pal_Special, 		v_palette_line_1,	16*4
palid_Ending:	makePalEntry	Pal_Ending, 		v_palette_line_1,	16*4
	even