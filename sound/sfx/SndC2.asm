SndC2_Header:
	smpsHeaderStartSong 1, 1
	smpsHeaderVoice     SndC2_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndC2_FM5,	$00, $00

; FM5 Data
SndC2_FM5:
	smpsModSet          $03, $01, $72, $0B
	smpsSetvoice        $00
	dc.b	nA4, $16
	smpsStop

SndC2_Voices:
;	Voice $00
;	$3C
;	$02, $01, $01, $01, 	$1F, $1F, $1F, $1F, 	$14, $0F, $14, $0F
;	$01, $0F, $0A, $0F, 	$0F, $0F, $EF, $5F, 	$0D, $06, $0A, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $01, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0F, $14, $0F, $14
	smpsVcDecayRate2    $0F, $0A, $0F, $01
	smpsVcDecayLevel    $05, $0E, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $0A, $06, $0D