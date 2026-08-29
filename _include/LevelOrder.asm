; ===========================================================================
; ---------------------------------------------------------------------------
; Level order array (extracted from "_incObj/3A Got Through Card.asm").
; An entry specifying "0" as next level (technically GHZ1) will immediately
; return to the Sega screen instead (see Got_NextLevel in object 3A).
; ---------------------------------------------------------------------------

		; Green Hill Zone
		dc.w id_GHZ_act2	; Act 1
		dc.w id_GHZ_act3	; Act 2
		dc.w id_MZ_act1		; Act 3
		dc.w 0			; Act 4 (unused)

		; Labyrinth Zone
		dc.w id_LZ_act2		; Act 1
		dc.w id_LZ_act3		; Act 2
		dc.w id_MZ_act1		; Act 3
		dc.w 0			; Act 4 (unused)

		; Marble Zone
		dc.w id_MZ_act2		; Act 1
		dc.w id_MZ_act3		; Act 2
		dc.w id_SZ_act1		; Act 3
		dc.w 0			; Act 4 (unused)

		; Star Light Zone
		dc.w 0			; Act 1
		dc.w id_SLZ_act3	; Act 2
		dc.w id_MZ_act1		; Act 3
		dc.w 0			; Act 4 (unused)

		; Sparkling Zone
		dc.w id_SLZ_act1	; Act 1
		dc.w id_SZ_act3		; Act 2
		dc.w id_CWZ_act1	; Act 3
		dc.w 0			; Act 4 (unused)

		; Clock Work Zone
		dc.w id_CWZ_act2	; Act 1
		dc.w id_CWZ_act3	; Act 2
		dc.w 0			; Act 3
		dc.w 0			; Act 4 (unused)

		even
