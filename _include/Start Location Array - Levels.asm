; ---------------------------------------------------------------------------
; Sonic start location array
; ---------------------------------------------------------------------------

		binclude	"../startpos/ghz1.bin"
		binclude	"../startpos/ghz2.bin"
		binclude	"../startpos/ghz3.bin"
		dc.w	$80,$A8

		binclude	"../startpos/lz1.bin"
		binclude	"../startpos/lz2.bin"
		binclude	"../startpos/lz3.bin"
		dc.w	$80,$A8

		binclude	"../startpos/mz1.bin"
		binclude	"../startpos/mz2.bin"
		binclude	"../startpos/mz3.bin"
		dc.w	$80,$A8

		binclude	"../startpos/slz1.bin"
		binclude	"../startpos/slz2.bin"
		binclude	"../startpos/slz3.bin"
		dc.w	$80,$A8

		binclude	"../startpos/sz1.bin"
		binclude	"../startpos/sz2.bin"
		binclude	"../startpos/sz3.bin"
		dc.w	$80,$A8

		binclude	"../startpos/cwz1.bin"
		binclude	"../startpos/cwz2.bin"
		binclude	"../startpos/cwz3.bin"
		dc.w	$80,$A8

		dc.w	$80,$A8
		dc.w	$80,$A8
		dc.w	$80,$A8
		dc.w	$80,$A8

		even