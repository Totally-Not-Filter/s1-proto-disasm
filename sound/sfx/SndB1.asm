SndB1_Header:
	smpsHeaderStartSong 1, 1
	smpsHeaderVoice     SndB1_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndB1_FM5,	$00, $08

; FM5 Data
SndB1_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $E0, $0C

SndB1_Jump00:
	dc.b	nC6, $6A
	smpsJump            SndB1_Jump00

; Unreachable
	smpsStop

SndB1_Voices:
;	Voice $00
;	$FA
;	$02, $00, $01, $01, 	$1F, $1F, $1F, $15, 	$1F, $1F, $1F, $9F
;	$00, $40, $00, $00, 	$01, $01, $01, $06, 	$24, $00, $28, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $03
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $00, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $15, $1F, $1F, $1F
	smpsVcAmpMod        $01, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $1F
	smpsVcDecayRate2    $00, $00, $40, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $06, $01, $01, $01
	smpsVcTotalLevel    $00, $28, $00, $24