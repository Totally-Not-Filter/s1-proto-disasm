SndC9_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndC9_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndC9_FM5,	$E8, $00

; FM5 Data
SndC9_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $CF, $02
	dc.b	nCs5, $72
	smpsStop
	
; Unreachable
	smpsStop

SndC9_Voices:
;	Voice $00
;	$83
;	$13, $32, $33, $44, 	$1F, $1F, $1F, $1F, 	$14, $0D, $06, $0A
;	$06, $05, $06, $06, 	$2F, $4F, $FF, $3F, 	$00, $15, $34, $8C
	smpsVcAlgorithm     $03
	smpsVcFeedback      $00
	smpsVcUnusedBits    $02
	smpsVcDetune        $04, $03, $03, $01
	smpsVcCoarseFreq    $04, $03, $02, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $06, $0D, $14
	smpsVcDecayRate2    $06, $06, $05, $06
	smpsVcDecayLevel    $03, $0F, $04, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $0C, $34, $15, $00