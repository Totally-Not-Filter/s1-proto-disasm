SndB3_Header:
	smpsHeaderStartSong 1, 1
	smpsHeaderVoice     SndB3_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM3, SndB3_FM3,	$0C, $00

; FM3 Data
SndB3_FM3:
	smpsSetvoice        $00
	smpsModSet          $05, $01, $60, $0F
	dc.b	nAb2, $14

SndB3_Loop00:
	dc.b	smpsNoAttack, $02
	smpsAlterVol        $02
	smpsLoop            $00, $11, SndB3_Loop00
	smpsStop

SndB3_Voices:
;	Voice $00
;	$3A
;	$00, $40, $03, $00, 	$1F, $1F, $1F, $15, 	$00, $1F, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$08, $08, $38, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $04, $00
	smpsVcCoarseFreq    $00, $03, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $15, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $1F, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $38, $08, $08