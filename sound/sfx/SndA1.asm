SndA1_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndA1_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM4, SndA1_FM4,	$F2, $04

; FM4 Data
SndA1_FM4:
	smpsSetvoice        $00
	dc.b	nBb3

SndA1_Loop00:
	dc.b	$02, smpsNoAttack, nAb3, $01, smpsNoAttack
	smpsAlterPitch      $01
	smpsLoop            $00, $30, SndA1_Loop00
	smpsStop

SndA1_Voices:
;	Voice $00
;	$3B
;	$3C, $39, $30, $31, 	$DF, $1F, $1F, $DF, 	$04, $05, $04, $01
;	$04, $04, $04, $02, 	$FF, $0F, $1F, $AF, 	$29, $20, $0F, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $00, $09, $0C
	smpsVcRateScale     $03, $00, $00, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $01, $04, $05, $04
	smpsVcDecayRate2    $02, $04, $04, $04
	smpsVcDecayLevel    $0A, $01, $00, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $0F, $20, $29