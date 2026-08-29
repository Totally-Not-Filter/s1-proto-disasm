SndA3_Death_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndA3_Death_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndA3_Death_FM5,	$F4, $00

; FM5 Data
SndA3_Death_FM5:
	smpsSetvoice        $00
	dc.b	nB3, $07, smpsNoAttack, nAb3

SndA3_Death_Loop00:
	dc.b	$01
	smpsAlterVol        $01
	smpsLoop            $00, $2F, SndA3_Death_Loop00
	smpsStop

SndA3_Death_Voices:
;	Voice $00
;	$30
;	$30, $30, $30, $30, 	$9E, $D8, $DC, $DC, 	$0E, $0A, $04, $05
;	$08, $08, $08, $08, 	$BF, $BF, $BF, $BF, 	$14, $3C, $14, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $03, $03, $03, $02
	smpsVcAttackRate    $1C, $1C, $18, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $04, $0A, $0E
	smpsVcDecayRate2    $08, $08, $08, $08
	smpsVcDecayLevel    $0B, $0B, $0B, $0B
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $14, $3C, $14

;	Voice $01 (unused)
;	$3A
;	$00, $00, $00, $00, 	$1D, $1F, $1F, $1F, 	$12, $0F, $19, $19
;	$00, $12, $0C, $0C, 	$FF, $3F, $0F, $0F, 	$27, $0F, $2B, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $19, $19, $0F, $12
	smpsVcDecayRate2    $0C, $0C, $12, $00
	smpsVcDecayLevel    $00, $00, $03, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $2B, $0F, $27

;	Voice $02 (unused)
;	$02
;	$00, $00, $00, $00, 	$5C, $54, $1C, $D0, 	$0C, $08, $0A, $05
;	$00, $00, $00, $00, 	$FF, $FF, $FF, $FF, 	$24, $1B, $22, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $D0, $1C, $54, $5C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $0A, $08, $0C
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $0F, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $22, $1B, $24