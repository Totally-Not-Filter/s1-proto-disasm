; ---------------------------------------------------------------------------
; Palette pointers
; ---------------------------------------------------------------------------

palp:	macro paladdress,ramaddress,colours
	dc.l paladdress
	dc.w ramaddress, (colours>>1)-1
	endm

PalPointers:

; palette address, RAM address, colours

ptr_Pal_SegaBG:		palp	Pal_SegaBG,v_palette,$40 ; 0 - Sega logo
ptr_Pal_Title:		palp	Pal_Title,v_palette,$40	; 1 - title screen
ptr_Pal_LevelSel:	palp	Pal_LevelSel,v_palette,$40 ; 2 - level select
ptr_Pal_Sonic:		palp	Pal_Sonic,v_palette,$10	; 3 - Sonic
Pal_Levels:
ptr_Pal_GHZ:		palp	Pal_GHZ,v_palette+$20, $30 ; 4 - GHZ
ptr_Pal_LZ:		palp	Pal_LZ,v_palette+$20,$30 ; 5 - LZ
ptr_Pal_MZ:		palp	Pal_MZ,v_palette+$20,$30 ; 6 - MZ
ptr_Pal_SLZ:		palp	Pal_SLZ,v_palette+$20,$30 ; 7 - SLZ
ptr_Pal_SZ:		palp	Pal_SZ,v_palette+$20,$30 ; 8 - SZ
ptr_Pal_CWZ:		palp	Pal_CWZ,v_palette+$20,$30 ; 9 - CWZ

ptr_Pal_Special:	palp	Pal_Special,v_palette,$40 ; $A (10) - special stage
ptr_Pal_Ending:		palp	Pal_Ending,v_palette,$40 ; $B (11) - ending sequence

palid_SegaBG:	= (ptr_Pal_SegaBG-PalPointers)/8
palid_Title:	= (ptr_Pal_Title-PalPointers)/8
palid_LevelSel:	= (ptr_Pal_LevelSel-PalPointers)/8
palid_Sonic:	= (ptr_Pal_Sonic-PalPointers)/8
palid_GHZ:	= (ptr_Pal_GHZ-PalPointers)/8
palid_LZ:	= (ptr_Pal_LZ-PalPointers)/8
palid_MZ:	= (ptr_Pal_MZ-PalPointers)/8
palid_SLZ:	= (ptr_Pal_SLZ-PalPointers)/8
palid_SZ:	= (ptr_Pal_SZ-PalPointers)/8
palid_CWZ:	= (ptr_Pal_CWZ-PalPointers)/8
palid_Special:	= (ptr_Pal_Special-PalPointers)/8
palid_Ending:	= (ptr_Pal_Ending-PalPointers)/8