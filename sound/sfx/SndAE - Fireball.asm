SndAE_Fireball_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice		SndAE_Fireball_Voices
	smpsHeaderTempoSFX	$01
	smpsHeaderChanSFX	$02

	smpsHeaderSFXChannel cFM5, SndAE_Fireball_FM5,	$00, $00
	smpsHeaderSFXChannel cPSG3, SndAE_Fireball_PSG3,	$00, $00

; FM5 Data
SndAE_Fireball_FM5:
	smpsSetvoice		$00
	dc.b	nRst, $01
	smpsModSet			$01, $01, $40, $48
	dc.b	nD0, $06, nE0, $02
	smpsStop

; PSG3 Data
SndAE_Fireball_PSG3:
	smpsPSGvoice		$00
	dc.b	nRst, $0B
	smpsPSGform			$E7
	dc.b	nMaxPSG, $01, smpsNoAttack

SndAE_Fireball_Loop00:
	dc.b	$02
	smpsPSGAlterVol		$01
	dc.b	smpsNoAttack
	smpsLoop			$00, $10, SndAE_Fireball_Loop00
	smpsStop

SndAE_Fireball_Voices:
;	Voice $00
;	$FA
;	$02, $03, $00, $05, 	$12, $11, $0F, $13, 	$05, $18, $09, $02
;	$06, $0F, $06, $02, 	$1F, $2F, $4F, $2F, 	$2F, $1A, $0E, $80
	smpsVcAlgorithm		$02
	smpsVcFeedback		$07
	smpsVcUnusedBits	$03
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$05, $00, $03, $02
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$13, $0F, $11, $12
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$02, $09, $18, $05
	smpsVcDecayRate2	$02, $06, $0F, $06
	smpsVcDecayLevel	$02, $04, $02, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $0E, $1A, $2F
	
; Unused voice
;	Voice $01
;	$02
;	$02, $0A, $01, $00, 	$21, $18, $0F, $1F, 	$1C, $1C, $0F, $0F
;	$00, $00, $00, $05, 	$FF, $FF, $FF, $FF, 	$06, $00, $0F, $80
	smpsVcAlgorithm		$02
	smpsVcFeedback		$00
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$00, $01, $0A, $02
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$1F, $0F, $18, $21
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$0F, $0F, $1C, $1C
	smpsVcDecayRate2	$05, $00, $00, $00
	smpsVcDecayLevel	$0F, $0F, $0F, $0F
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $0F, $00, $06