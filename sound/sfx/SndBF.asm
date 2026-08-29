SndBF_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndBF_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndBF_FM5,	$00, $00

; FM5 Data
SndBF_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $06, $0F, $05

SndBF_Jump00:
	dc.b	nA6, $05, nRst, $02

SndBF_Loop00:
	dc.b	nA6, $02, smpsNoAttack
	smpsAlterVol        $05
	smpsLoop            $00, $08, SndBF_Loop00
	smpsAlterVol        $D8
	smpsJump            SndBF_Jump00
	
; Unreachable
	smpsStop

SndBF_Voices:
;	Voice $00
;	$28
;	$33, $4F, $17, $71, 	$1F, $12, $1F, $1F, 	$04, $01, $04, $0C
;	$01, $01, $01, $00, 	$1F, $1F, $1F, $1F, 	$11, $16, $19, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $01, $04, $03
	smpsVcCoarseFreq    $01, $07, $0F, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $12, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0C, $04, $01, $04
	smpsVcDecayRate2    $00, $01, $01, $01
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $19, $16, $11