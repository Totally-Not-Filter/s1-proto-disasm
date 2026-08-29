SndB2_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndB2_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndB2_FM5,	$00, $09

; FM5 Data
SndB2_FM5:
	smpsSetvoice        $00
	dc.b	nAb3, $1C
	smpsStop

SndB2_Voices:
;	Voice $00
;	$2C
;	$72, $72, $33, $32, 	$1F, $1F, $1F, $1F, 	$01, $03, $01, $03
;	$01, $01, $01, $01, 	$1F, $2F, $1F, $2F, 	$19, $80, $17, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $02, $03, $02, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $01, $03, $01
	smpsVcDecayRate2    $01, $01, $01, $01
	smpsVcDecayLevel    $02, $01, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $17, $00, $19