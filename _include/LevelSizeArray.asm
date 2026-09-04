; ===========================================================================
; ---------------------------------------------------------------------------
; Level size array
; ---------------------------------------------------------------------------

lvlsize macro left,right,top,bottom
	; $0004 is an unused value, $0060 is the default vertical screen shift.
	; Both are always the same and redundant.
	dc.w $0004, left, right, top, bottom, $0060
	endm

; ---------------------------------------------------------------------------

		;           |---------------------------------Left boundary
		;           |      |--------------------------Right boundary
		;           |      |      |-------------------Top boundary
		;           |      |      |      |------------Bottom boundary
		; GHZ       |      |      |      |
		lvlsize     0, $24BF,     0,  $300 ; GHZ1
		lvlsize     0, $1EBF,     0,  $300 ; GHZ2
		lvlsize     0, $2960,     0,  $300 ; GHZ3
		lvlsize     0, $2ABF,     0,  $300 ; GHZ4 (unused)
		; LZ
		lvlsize     0, $17BF,     0,  $720 ; LZ1
		lvlsize     0,  $EBF,     0,  $720 ; LZ2
		lvlsize     0, $1EBF,     0,  $720 ; LZ3
		lvlsize     0, $1EBF,     0,  $720 ; LZ4 (unused)
		; MZ
		lvlsize     0, $17BF,     0,  $1D0 ; MZ1
		lvlsize     0, $1BBF,     0,  $520 ; MZ2
		lvlsize     0, $163F,     0,  $720 ; MZ3
		lvlsize     0, $16BF,     0,  $720 ; MZ4 (unused)
		; SLZ
		lvlsize     0, $1EBF,     0,  $640 ; SLZ1
		lvlsize     0, $20BF,     0,  $640 ; SLZ2
		lvlsize     0, $1EBF,     0,  $6C0 ; SLZ3
		lvlsize     0, $3EC0,     0,  $720 ; SLZ4 (unused)
		; SYZ
		lvlsize     0, $22C0,     0,  $420 ; SZ1
		lvlsize     0, $28C0,     0,  $520 ; SZ2
		lvlsize     0, $2EC0,     0,  $620 ; SZ3
		lvlsize     0, $29C0,     0,  $620 ; SZ4 (unused)
		; SBZ
		lvlsize     0, $3EC0,     0,  $720 ; CWZ1
		lvlsize     0, $3EC0,     0,  $720 ; CWZ2
		lvlsize     0, $3EC0,     0,  $720 ; CWZ3 (unused)
		lvlsize     0, $3EC0,     0,  $720 ; CWZ4 (unused)
;		zonewarning LevelSizeArray,$30
		; 06
		lvlsize     0, $2FFF,     0,  $320 ; (unused)
		lvlsize     0, $2FFF,     0,  $320 ; (unused)
		lvlsize     0, $2FFF,     0,  $320 ; (unused)
		lvlsize     0, $2FFF,     0,  $320 ; (unused)
		even
