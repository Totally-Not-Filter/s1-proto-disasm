SndAA_Splash_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice		SndAA_Splash_Voices
	smpsHeaderTempoSFX	$01
	smpsHeaderChanSFX	$02

	smpsHeaderSFXChannel cPSG3, SndAA_Splash_PSG3,	$00, $00
	smpsHeaderSFXChannel cFM5, SndAA_Splash_FM5,	$00, $03

; PSG3 Data
SndAA_Splash_PSG3:
	smpsPSGvoice		$00
	smpsPSGform			$E7
	dc.b	nF5, $05, nMaxPSG, $05, smpsNoAttack

SndAA_Splash_Loop00:
	dc.b	$07
	smpsPSGAlterVol		$01
	dc.b	smpsNoAttack
	smpsLoop			$00, $0F, SndAA_Splash_Loop00
	smpsStop

; FM5 Data
SndAA_Splash_FM5:
	smpsSetvoice		$01
	dc.b	nCs3, $14
	smpsStop

SndAA_Splash_Voices:
; Unused voice
;	Voice $00
;	$3C
;	$00, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$00, $16, $0F, $0F
;	$00, $00, $00, $00, 	$0F, $AF, $FF, $FF, 	$00, $80, $0A, $80
	smpsVcAlgorithm		$04
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$00, $00, $00, $00
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$0F, $0F, $16, $00
	smpsVcDecayRate2	$00, $00, $00, $00
	smpsVcDecayLevel	$0F, $0F, $0A, $00
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$80, $0A, $80, $00

;	Voice $01
;	$00
;	$00, $03, $02, $00, 	$D9, $DF, $1F, $1F, 	$12, $11, $14, $0F
;	$0A, $00, $0A, $0D, 	$FF, $FF, $FF, $FF, 	$22, $07, $27, $80
	smpsVcAlgorithm		$00
	smpsVcFeedback		$00
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$00, $02, $03, $00
	smpsVcRateScale		$00, $00, $03, $03
	smpsVcAttackRate	$1F, $1F, $1F, $19
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$0F, $14, $11, $12
	smpsVcDecayRate2	$0D, $0A, $00, $0A
	smpsVcDecayLevel	$0F, $0F, $0F, $0F
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$80, $27, $07, $22