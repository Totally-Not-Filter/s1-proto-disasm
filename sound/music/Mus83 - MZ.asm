Mus83_MZ_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Mus83_MZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $09

	smpsHeaderDAC       Mus83_MZ_DAC
	smpsHeaderFM        Mus83_MZ_FM1,	$E8, $15
	smpsHeaderFM        Mus83_MZ_FM2,	$E8, $0E
	smpsHeaderFM        Mus83_MZ_FM3,	$E8, $15
	smpsHeaderFM        Mus83_MZ_FM4,	$E8, $17
	smpsHeaderFM        Mus83_MZ_FM5,	$E8, $17
	smpsHeaderPSG       Mus83_MZ_PSG1,	$D0, $03, $00, fTone_08
	smpsHeaderPSG       Mus83_MZ_PSG2,	$D0, $05, $00, fTone_08
	smpsHeaderPSG       Mus83_MZ_PSG3,	$0B, $03, $00, fTone_09

; FM1 Data
Mus83_MZ_FM1:
	smpsSetvoice        $00
	dc.b	nRst, $0C, nRst, $18, nA5, $06, nB5, nC6, nE6

Mus83_MZ_Jump05:
	smpsCall            Mus83_MZ_Call01
	smpsJump            Mus83_MZ_Jump05
	
; Unreachable
	smpsStop

; FM3 Data
Mus83_MZ_FM3:
	smpsSetvoice        $00
	smpsDetune          $02
	dc.b	nRst, $0C, nRst, $18, nA5, $06, nB5, nC6, nE6

Mus83_MZ_Jump04:
	smpsCall            Mus83_MZ_Call01
	smpsJump            Mus83_MZ_Jump04
	
; Unreachable
	smpsStop

; FM4 Data
Mus83_MZ_FM4:
	smpsSetvoice        $03
	smpsAlterVol        $F7
	dc.b	nRst, $06, nE5, $03, nE5, nE5, $06, nRst, nE4, $1E
	smpsSetvoice        $02
	smpsAlterVol        $09
	dc.b	nB6, $06

Mus83_MZ_Jump03:
	dc.b	smpsNoAttack, $03, nRst, nB6, nRst, nC7, $06, nRst, nB6, $0C, nRst, $06
	dc.b	nB6, smpsNoAttack, $03, nRst, nB6, nRst, nC7, $06, nRst, nB6, $0C, nRst
	dc.b	nRst, $0C, nC7, $03, nRst, $0F, nC7, $03, nRst, $0F, nRst, $0C
	dc.b	nC7, $03, nRst, $0F, nC7, $03, nRst, $09, nA6, $06, smpsNoAttack, $03
	dc.b	nRst, nA6, nRst, nB6, $06, nRst, nA6, $0C, nRst, $06, nA6, smpsNoAttack
	dc.b	$03, nRst, $03, nA6, nRst, nB6, $06, nRst, nA6, $0C, nRst, nRst
	dc.b	$0C, nG6, $03, nRst, $0F, nG6, $03, nRst, $0F, nRst, $2A, nB6
	dc.b	$06, smpsNoAttack, $03, nRst, nB6, nRst, nC7, $06, nRst, nB6, $0C, nRst
	dc.b	$06, nB6, smpsNoAttack, $03, nRst, nB6, nRst, nC7, $06, nRst, nB6, $0C
	dc.b	nRst, nRst, $0C, nC7, $03, nRst, $0F, nC7, $03, nRst, $0F, nRst
	dc.b	$0C, nC7, $03, nRst, $0F, nC7, $03, nRst, $09, nF6, $06, smpsNoAttack
	dc.b	$03, nRst, nF6, nRst, nA6, $06, nRst, nF6, $0C, nRst, $06, nAb6
	dc.b	smpsNoAttack, $03, nRst, nAb6, nRst, nB6, $06, nRst, nAb6, $0C, nRst, nRst
	dc.b	$0C, nC7, $03, nRst, $0F, nC7, $03, nRst, $09, nE7, $06, smpsNoAttack
	dc.b	$03, nRst, nE7, nRst, nD7, $06, nRst, nC7, $03, nRst, nB6, $12
	smpsCall            Mus83_MZ_Call00
	smpsJump            Mus83_MZ_Jump03

; FM5 Data
Mus83_MZ_FM5:
	smpsSetvoice        $04
	smpsAlterVol        $FC
	smpsAlterPitch      $24
	dc.b	nRst, $06, nE4, $03, nE4, nE4, $06, nRst, nE3, $1E
	smpsAlterPitch      $DC
	smpsAlterVol        $04
	smpsSetvoice        $02
	dc.b	nG6, $06

Mus83_MZ_Jump02:
	dc.b	smpsNoAttack, $03, nRst, nG6, nRst, nA6, $06, nRst, nG6, $0C, nRst, $06
	dc.b	nG6, smpsNoAttack, $03, nRst, nG6, nRst, nA6, $06, nRst, nG6, $0C, nRst
	dc.b	nRst, $0C, nA6, $03, nRst, $0F, nA6, $03, nRst, $0F, nRst, $0C
	dc.b	nA6, $03, nRst, $0F, nA6, $03, nRst, $09, nF6, $06, smpsNoAttack, $03
	dc.b	nRst, nF6, nRst, nG6, $06, nRst, nF6, $0C, nRst, $06, nF6, smpsNoAttack
	dc.b	$03, nRst, nF6, nRst, nG6, $06, nRst, nF6, $0C, nRst, nRst, $0C
	dc.b	nE6, $03, nRst, $0F, nE6, $03, nRst, $0F, nRst, $2A, nG6, $06
	dc.b	smpsNoAttack, $03, nRst, nG6, nRst, nA6, $06, nRst, nG6, $0C, nRst, $06
	dc.b	nG6, smpsNoAttack, $03, nRst, nG6, nRst, nA6, $06, nRst, nG6, $0C, nRst
	dc.b	nRst, $0C, nA6, $03, nRst, $0F, nA6, $03, nRst, $0F, nRst, $0C
	dc.b	nA6, $03, nRst, $0F, nA6, $03, nRst, $09, nD6, $06, smpsNoAttack, $03
	dc.b	nRst, nD6, nRst, nF6, $06, nRst, nD6, $0C, nRst, $06, nE6, smpsNoAttack
	dc.b	$03, nRst, nE6, nRst, nAb6, $06, nRst, nE6, $0C, nRst, nRst, $0C
	dc.b	nA6, $03, nRst, $0F, nA6, $03, nRst, $09, nC7, $06, smpsNoAttack, $03
	dc.b	nRst, nC7, nRst, nB6, $06, nRst, nA6, $03, nRst, nAb6, $12
	smpsDetune          $03
	smpsCall            Mus83_MZ_Call00
	smpsDetune          $00
	smpsJump            Mus83_MZ_Jump02

; FM2 Data
Mus83_MZ_FM2:
	smpsSetvoice        $01
	dc.b	nRst, $06, nE4, $03, nE4, nE4, $06, nRst, nE3, $24

Mus83_MZ_Jump01:
	dc.b	nA3, $03, nRst, nA3, $06, nE4, $03, nRst, nE4, $06, nD4, $03
	dc.b	nRst, nD4, $06, nE4, $03, nRst, nE4, $06, nA3, $03, nRst, nA3
	dc.b	$06, nE4, $03, nRst, nE4, $06, nD4, $03, nRst, nD4, $06, nE4
	dc.b	$03, nRst, nE4, $06, nD4, $03, nRst, nD4, $06, nA4, $03, nRst
	dc.b	nA4, $06, nF4, $03, nRst, nF4, $06, nA4, $03, nRst, nA4, $06
	dc.b	nD4, $03, nRst, nD4, $06, nA4, $03, nRst, nA4, $06, nF4, $03
	dc.b	nRst, nF4, $06, nA4, $03, nRst, nA4, $06, nG3, $03, nRst, nG3
	dc.b	$06, nD4, $03, nRst, nD4, $06, nB3, $03, nRst, nB3, $06, nD4
	dc.b	$03, nRst, nD4, $06, nG3, $03, nRst, nG3, $06, nD4, $03, nRst
	dc.b	nD4, $06, nB3, $03, nRst, nB3, $06, nD4, $03, nRst, nD4, $06
	dc.b	nC4, $03, nRst, nC4, $06, nG4, $03, nRst, nG4, $06, nE4, $03
	dc.b	nRst, nE4, $06, nG4, $03, nRst, nG4, $06, nB3, $03, nRst, nB3
	dc.b	$06, nF4, $03, nRst, nF4, $06, nE4, $03, nRst, nE4, $06, nB3
	dc.b	$03, nRst, nB3, $06, nA3, $03, nRst, nA3, $06, nE4, $03, nRst
	dc.b	nE4, $06, nD4, $03, nRst, nD4, $06, nE4, $03, nRst, nE4, $06
	dc.b	nA3, $03, nRst, nA3, $06, nE4, $03, nRst, nE4, $06, nD4, $03
	dc.b	nRst, nD4, $06, nE4, $03, nRst, nE4, $06, nD4, $03, nRst, nD4
	dc.b	$06, nA4, $03, nRst, nA4, $06, nF4, $03, nRst, nF4, $06, nA4
	dc.b	$03, nRst, nA4, $06, nD4, $03, nRst, nD4, $06, nA4, $03, nRst
	dc.b	nA4, $06, nF4, $03, nRst, nF4, $06, nA4, $03, nRst, nA4, $06
	dc.b	nB3, $03, nRst, nB3, $06, nF4, $03, nRst, nF4, $06, nD4, $03
	dc.b	nRst, nD4, $06, nF4, $03, nRst, nF4, $06, nE4, $03, nRst, nE4
	dc.b	$06, nB4, $03, nRst, nB4, $06, nAb4, $03, nRst, nAb4, $06, nB4
	dc.b	$03, nRst, nB4, $06, nA3, $03, nRst, nA3, $06, nE4, $03, nRst
	dc.b	nE4, $06, nC4, $03, nRst, nC4, $06, nE4, $03, nRst, nE4, $06
	dc.b	nA3, $03, nRst, nA3, $06, nE4, $03, nRst, nE4, $06, nD4, $03
	dc.b	nRst, nD4, $06, nE4, $03, nRst, nE4, $06, nA3, $12, nA3, $06
	dc.b	nG3, $12, nG3, $06, nF3, $12, nF3, $06, nG3, $12, nG3, $06
	dc.b	nA3, $12, nA3, $06, nG3, $12, nG3, $06, nF3, $12, nF3, $06
	dc.b	nG3, $12, nG3, $06
	smpsJump            Mus83_MZ_Jump01

; PSG1 Data
Mus83_MZ_PSG1:
	dc.b	nRst, $0C, nRst, $30

Mus83_MZ_Jump07:
	dc.b	nRst, $30, nRst, nRst, $30, nF7, $03, nD7, nA6, nF6, nD7, nA6
	dc.b	nF6, nD6, nA6, nF6, nD6, nA5, nF6, nD6, nA5, nF5, smpsNoAttack, $24
	dc.b	nRst, $0C, nRst, $30, nRst, $2A, nF7, $06, smpsNoAttack, $06, nF7, $06
	dc.b	nD7, $0C, nB6, $06, nAb6, $12, smpsNoAttack, $18, nRst, $18, nRst, $30
	dc.b	nRst, $30, nF7, $03, nD7, nA6, nF6, nD7, nA6, nF6, nD6, nA6
	dc.b	nF6, nD6, nA5, nF6, nD6, nA5, nF5, smpsNoAttack, $24, nRst, $0C, nRst
	dc.b	$30, nRst, $30, nRst, nA6, $06, nC7, $03, nA6, nC7, $06, nA6
	dc.b	$06, nB6, nG6, nD6, nB6, nF6, $06, nA6, $03, nF6, $03, nA6
	dc.b	$06, nF6, $06, nG6, nA6, nB6, nG6, nA6, $06, nC7, $03, nA6
	dc.b	$03, nC7, $06, nA6, $06, nB6, nG6, nD6, nB6, nF6, $06, nA6
	dc.b	$03, nF6, $03, nA6, $06, nF6, $06, nG6, nA6, nB6, nG6
	smpsJump            Mus83_MZ_Jump07

; PSG2 Data
Mus83_MZ_PSG2:
	dc.b	nRst, $02
	smpsDetune          $01
	smpsJump            Mus83_MZ_PSG1

; PSG3 Data
Mus83_MZ_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $06
	smpsAlterPitch      $0C
	smpsPSGAlterVol     $FF
	dc.b	nE4, $03, nE4, nE4, $06, nRst, nE3, $24
	smpsAlterPitch      $F4
	smpsPSGAlterVol     $01

Mus83_MZ_Jump06:
	dc.b	nA3, $06, nA3, nE4, nE4, nD4, nD4, nE4, nE4, nA3, nA3, nE4
	dc.b	nE4, nD4, nD4, nE4, nE4, nD4, nD4, nA4, nA4, nF4, nF4, nA4
	dc.b	nA4, nD4, nD4, nA4, nA4, nF4, nF4, nA4, nA4, nG3, nG3, nD4
	dc.b	nD4, nB3, nB3, nD4, nD4, nG3, nG3, nD4, nD4, nB3, nB3, nD4
	dc.b	nD4, nC4, nC4, nG4, nG4, nE4, nE4, nG4, nG4, nB3, nB3, nF4
	dc.b	nF4, nE4, nE4, nB3, nB3, nA3, nA3, nE4, nE4, nD4, nD4, nE4
	dc.b	nE4, nA3, nA3, nE4, nE4, nD4, nD4, nE4, nE4, nD4, nD4, nA4
	dc.b	nA4, nF4, nF4, nA4, nA4, nD4, nD4, nA4, nA4, nF4, nF4, nA4
	dc.b	nA4, nB3, nB3, nF4, nF4, nD4, nD4, nF4, nF4, nE4, nE4, nB4
	dc.b	nB4, nAb4, nAb4, nB4, nB4, nA3, nA3, nE4, nE4, nC4, nC4, nE4
	dc.b	nE4, nA3, nA3, nE4, nE4, nD4, nD4, nE4, nE4
	smpsAlterPitch      $0C
	smpsPSGAlterVol     $FF
	dc.b	nA3, $12, nA3, $06, nG3, $12, nG3, $06, nF3, $12, nF3, $06
	dc.b	nG3, $12, nG3, $06, nA3, $12, nA3, $06, nG3, $12, nG3, $06
	dc.b	nF3, $12, nF3, $06, nG3, $12, nG3, $06
	smpsAlterPitch      $F4
	smpsPSGAlterVol     $01
	smpsJump            Mus83_MZ_Jump06

; DAC Data
Mus83_MZ_DAC:
	dc.b	nRst, $06, dSnare, $03, dSnare, $03, dSnare, $0C, dKick, dKick, dKick

Mus83_MZ_Jump00:
	dc.b	dKick, $0C, dKick, dKick, dKick
	smpsJump            Mus83_MZ_Jump00

Mus83_MZ_Call01:
	dc.b	nB6, $09, nRst, $03, nB6, $06, nA6, $06, nB6, $09, nRst, $03
	dc.b	nB6, $06, nA6, $06, nB6, $09, nRst, $03, nB6, $06, nA6, $06
	dc.b	nB6, $06, nA6, $06, nE6, $06, nC6, $06, nG6, $0C, nA6, $06
	dc.b	smpsNoAttack, nF6, $06, smpsNoAttack, $18, smpsNoAttack, $2F, nRst, $01, nA6, $09, nRst
	dc.b	$03, nA6, $06, nG6, $06, nA6, $09, nRst, $03, nA6, $06, nG6
	dc.b	$06, nA6, $09, nRst, $03, nA6, $06, nG6, $06, nA6, $0C, nB6
	dc.b	$0C, nF6, $12, nE6, $06, smpsNoAttack, $18, smpsNoAttack, $17, nRst, $01, nA5
	dc.b	$06, nB5, $06, nC6, $06, nE6, $06, nB6, $09, nRst, $03, nB6
	dc.b	$06, nA6, $06, nB6, $09, nRst, $03, nB6, $06, nA6, $06, nB6
	dc.b	$09, nRst, $03, nB6, $06, nA6, $06, nB6, $06, nA6, $06, nE6
	dc.b	$06, nC6, $06, nG6, $0C, nA6, $06, smpsNoAttack, nF6, $06, smpsNoAttack, $18
	dc.b	smpsNoAttack, $2F, nRst, $01, nA6, $24, nB6, $0C, nAb6, $24, nB6, $09
	dc.b	nRst, $03, nB6, $12, nA6, $06, smpsNoAttack, $18, smpsNoAttack, $2F, nRst, $01
	dc.b	nRst, $30, nRst, $30, nRst, $30, nRst, $18, nA5, $06, nB5, $06
	dc.b	nC6, $06, nE6, $06
	smpsReturn

Mus83_MZ_Call00:
	smpsNoteFill        $06
	dc.b	nRst, $06, nE7, $06, nC7, $06, nA6, $0C, nD7, $06, nB6, $06
	dc.b	nG6, $06, nRst, $06, nC7, $06, nA6, $06, nF6, $0C, nD7, $06
	dc.b	nB6, $06, nG6, $06, nRst, $06, nE7, $06, nC7, $06, nA6, $0C
	dc.b	nD7, $06, nB6, $06, nG6, $06, nRst, $06, nC7, $06, nA6, $06
	dc.b	nF6, $0C, nD7, $06, nB6, $06, nB6, $06
	smpsNoteFill        $00
	smpsReturn

Mus83_MZ_Voices:
;	Voice $00
;	$22
;	$0A, $13, $05, $11, 	$03, $12, $12, $11, 	$00, $13, $13, $00
;	$03, $02, $02, $01, 	$1F, $1F, $0F, $0F, 	$1E, $18, $26, $81
	smpsVcAlgorithm     $02
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $00, $01, $00
	smpsVcCoarseFreq    $01, $05, $03, $0A
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $11, $12, $12, $03
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $13, $13, $00
	smpsVcDecayRate2    $01, $02, $02, $03
	smpsVcDecayLevel    $00, $00, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $01, $26, $18, $1E

;	Voice $01
;	$3A
;	$61, $3C, $14, $31, 	$9C, $DB, $9C, $DA, 	$04, $09, $04, $03
;	$03, $01, $03, $00, 	$1F, $0F, $0F, $AF, 	$21, $47, $31, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $01, $03, $06
	smpsVcCoarseFreq    $01, $04, $0C, $01
	smpsVcRateScale     $03, $02, $03, $02
	smpsVcAttackRate    $1A, $1C, $1B, $1C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $04, $09, $04
	smpsVcDecayRate2    $00, $03, $01, $03
	smpsVcDecayLevel    $0A, $00, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $31, $47, $21

;	Voice $02
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $27, $28, $18

;	Voice $03
;	$23
;	$7C, $32, $00, $00, 	$5F, $58, $DC, $DF, 	$04, $0B, $04, $04
;	$06, $0C, $08, $08, 	$1F, $1F, $BF, $BF, 	$24, $26, $16, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $03, $07
	smpsVcCoarseFreq    $00, $00, $02, $0C
	smpsVcRateScale     $03, $03, $01, $01
	smpsVcAttackRate    $1F, $1C, $18, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $04, $0B, $04
	smpsVcDecayRate2    $08, $08, $0C, $06
	smpsVcDecayLevel    $0B, $0B, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $16, $26, $24

;	Voice $04
;	$02
;	$3C, $32, $55, $51, 	$1F, $98, $1F, $9F, 	$0F, $11, $0E, $11
;	$0E, $05, $08, $05, 	$5F, $0F, $6F, $0F, 	$2D, $2D, $2F, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $05, $05, $03, $03
	smpsVcCoarseFreq    $01, $05, $02, $0C
	smpsVcRateScale     $02, $00, $02, $00
	smpsVcAttackRate    $1F, $1F, $18, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $11, $0E, $11, $0F
	smpsVcDecayRate2    $05, $08, $05, $0E
	smpsVcDecayLevel    $00, $06, $00, $05
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $2F, $2D, $2D