; ---------------------------------------------------------------------------
; Sonic start location array
; ---------------------------------------------------------------------------

		incbin	"startpos/ghz1.bin"
		incbin	"startpos/ghz2.bin"
		incbin	"startpos/ghz3.bin"
		dc.w	$80,$A8

		incbin	"startpos/lz1.bin"
		incbin	"startpos/lz2.bin"
		incbin	"startpos/lz3.bin"
		dc.w	$80,$A8

		incbin	"startpos/mz1.bin"
		incbin	"startpos/mz2.bin"
		incbin	"startpos/mz3.bin"
		dc.w	$80,$A8

		incbin	"startpos/slz1.bin"
		incbin	"startpos/slz2.bin"
		incbin	"startpos/slz3.bin"
		dc.w	$80,$A8

		incbin	"startpos/sz1.bin"
		incbin	"startpos/sz2.bin"
		incbin	"startpos/sz3.bin"
		dc.w	$80,$A8

		incbin	"startpos/cwz1.bin"
		incbin	"startpos/cwz2.bin"
		incbin	"startpos/cwz3.bin"
		dc.w	$80,$A8

		dc.w	$80,$A8
		dc.w	$80,$A8
		dc.w	$80,$A8
		dc.w	$80,$A8

		even