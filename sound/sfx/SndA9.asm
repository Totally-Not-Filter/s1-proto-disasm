SndA9_Header:
	smpsHeaderStartSong 1, 1
	smpsHeaderVoice     SndA9_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndA9_FM5,	$0C, $05

; FM5 Data
SndA9_FM5:
	smpsSetvoice        $00
	dc.b	nRst, $01
	smpsModSet          $03, $01, $09, $FF
	dc.b	nBb5, $5A
	smpsModOff

SndA9_Loop00:
	dc.b	smpsNoAttack
	smpsAlterVol        $01
	dc.b	nG6, $02
	smpsLoop            $00, $2A, SndA9_Loop00
	smpsStop

SndA9_Voices:
;	Voice $00
;	$3C
;	$00, $44, $02, $02, 	$1F, $1F, $1F, $15, 	$00, $1F, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$0D, $00, $28, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $04, $00
	smpsVcCoarseFreq    $02, $02, $04, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $15, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $1F, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $28, $00, $0D