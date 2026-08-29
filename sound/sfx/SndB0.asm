SndB0_Header:
	smpsHeaderStartSong 1, 1
	smpsHeaderVoice     SndB0_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndB0_FM5,	$00, $11

; FM5 Data
SndB0_FM5:
	smpsSetvoice        $00
	smpsModSet          $05, $01, $19, $73

SndB0_Jump00:
	dc.b	nB2, $7A
	smpsJump            SndB0_Jump00

; Unreachable
	smpsStop

SndB0_Voices:
;	Voice $00
;	$C4
;	$02, $02, $02, $02, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$00, $00, $00, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $03
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $02, $02, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $00