Mus90_Continue_Screen_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Mus90_Continue_Screen_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $07

	smpsHeaderDAC       Mus90_Continue_Screen_DAC
	smpsHeaderFM        Mus90_Continue_Screen_FM1,	$E8, $08
	smpsHeaderFM        Mus90_Continue_Screen_FM2,	$E8, $08
	smpsHeaderFM        Mus90_Continue_Screen_FM3,	$F4, $0F
	smpsHeaderFM        Mus90_Continue_Screen_FM4,	$F4, $0F
	smpsHeaderFM        Mus90_Continue_Screen_FM5,	$F4, $0A
	smpsHeaderPSG       Mus90_Continue_Screen_PSG1,	$D0, $03, $00, fTone_05
	smpsHeaderPSG       Mus90_Continue_Screen_PSG2,	$DC, $06, $00, fTone_05
	smpsHeaderPSG       Mus90_Continue_Screen_PSG3,	$DC, $00, $00, fTone_04

; FM1 Data
Mus90_Continue_Screen_FM1:
	smpsSetvoice        $00
	dc.b	nRst, $30, nRst, $0C, nCs6, $12, nRst, $06, nCs6, nRst, nD6, $0C
	dc.b	nRst, $06, nB5, $18, nRst, $06, nRst, $0C, nD6, $12, nRst, $06
	dc.b	nD6, nRst, nEb6, $0C, nRst, $06, nC6, $18, nRst, $06, nRst, $0C
	dc.b	nEb6, $12, nRst, $06, nEb6, nRst, nE6, $0C, nRst, $06, nCs6, $18
	dc.b	nRst, $06, nF6, $06, nRst, nF6, nRst, nF6, nRst, nC6, nRst, nBb5
	dc.b	$0C, nRst, $06, nD6, $06, smpsNoAttack, $18, smpsNoAttack, $30
	smpsStop

; FM2 Data
Mus90_Continue_Screen_FM2:
	smpsSetvoice        $01
	smpsAlterVol        $02
	smpsAlterPitch      $F4
	dc.b	nA5, $0C, nAb5, $0C, nG5, $0C, nFs5, $0C
	smpsAlterVol        $FE
	smpsAlterPitch      $0C
	smpsSetvoice        $02
	dc.b	nA4, $06, nRst, nA4, nRst, nE4, nRst, nE4, nRst, nG4, $15, nFs4
	dc.b	$0C, nG4, $03, nFs4, $0C, nBb4, $06, nRst, nBb4, nRst, nF4, nRst
	dc.b	nF4, nRst, nAb4, $15, nG4, $0C, nAb4, $03, nG4, $0C, nB4, $06
	dc.b	nRst, nB4, nRst, nFs4, nRst, nFs4, nRst, nA4, $12, nAb4, $0C, nA4
	dc.b	$06, nAb4, $0C, nB4, $06, nRst, nB4, nRst, nFs4, nRst, nFs4, nRst
	dc.b	nE5, $0C, nRst, $06, nEb5, $06, smpsNoAttack, $18, smpsNoAttack, $30
	smpsStop

; FM3 Data
Mus90_Continue_Screen_FM3:
	smpsSetvoice        $03
	dc.b	nRst, $30, nE6, $06, nRst, nE6, nRst, nCs6, nRst, nCs6, nRst, nD6
	dc.b	$12, nD6, $1E, nE6, $06, nRst, nE6, nRst, nCs6, nRst, nCs6, nRst
	dc.b	nD6, $12, nD6, $1E, nE6, $06, nRst, nE6, nRst, nCs6, nRst, nCs6
	dc.b	nRst, nD6, $12, nD6, $1E, nE6, $06, nRst, nE6, nRst, nCs6, nRst
	dc.b	nCs6, nRst, nG6, $0C, nRst, $06, nG6, $06, smpsNoAttack, $18, smpsNoAttack, $30
	smpsStop

; FM4 Data
Mus90_Continue_Screen_FM4:
	smpsSetvoice        $03
	dc.b	nRst, $30, nCs6, $06, nRst, nCs6, nRst, nA5, nRst, nA5, nRst, nB5
	dc.b	$12, nB5, $1E, nCs6, $06, nRst, nCs6, nRst, nA5, nRst, nA5, nRst
	dc.b	nB5, $12, nB5, $1E, nCs6, $06, nRst, nCs6, nRst, nA5, nRst, nA5
	dc.b	nRst, nB5, $12, nB5, $1E, nCs6, $06, nRst, nCs6, nRst, nA5, nRst
	dc.b	nA5, nRst, nD6, $0C, nRst, $06, nD6, $06, smpsNoAttack, $18, smpsNoAttack, $30
	smpsStop

; FM5 Data
Mus90_Continue_Screen_FM5:
	smpsStop

; PSG1 Data
Mus90_Continue_Screen_PSG1:
	smpsStop

; PSG2 Data
Mus90_Continue_Screen_PSG2:
	smpsStop

; PSG3 Data
Mus90_Continue_Screen_PSG3:
	smpsStop

; DAC Data
Mus90_Continue_Screen_DAC:
	dc.b	nRst, $30, dKick, $0C, dSnare, $0C, dKick, $0C, dSnare, $0C, dKick, $0C
	dc.b	dSnare, $0C, dKick, $0C, dSnare, $0C, dKick, $0C, dSnare, $0C, dKick, $0C
	dc.b	dSnare, $0C, dKick, $0C, dSnare, $0C, dKick, $0C, dSnare, $0C, dKick, $0C
	dc.b	dSnare, $0C, dKick, $0C, dSnare, $0C, dKick, $0C, dSnare, $0C, dKick, $0C
	dc.b	dSnare, $0C, dKick, $0C, dSnare, $0C, dKick, $0C, dSnare, $0C, dKick, $0C
	dc.b	dSnare, $06, dKick, $1E, nRst, $30
	smpsStop

Mus90_Continue_Screen_Voices:
;	Voice $00
;	$3A
;	$51, $08, $51, $02, 	$1E, $1E, $1E, $10, 	$1F, $1F, $1F, $0F
;	$00, $00, $00, $02, 	$0F, $0F, $0F, $1F, 	$18, $24, $22, $81
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $05, $00, $05
	smpsVcCoarseFreq    $02, $01, $08, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $10, $1E, $1E, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0F, $1F, $1F, $1F
	smpsVcDecayRate2    $02, $00, $00, $00
	smpsVcDecayLevel    $01, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $01, $22, $24, $18

;	Voice $01
;	$3B
;	$52, $31, $31, $51, 	$12, $14, $12, $14, 	$0D, $00, $0D, $02
;	$00, $00, $00, $01, 	$4F, $0F, $5F, $3F, 	$1E, $18, $2D, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $05, $03, $03, $05
	smpsVcCoarseFreq    $01, $01, $01, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $14, $12, $14, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $0D, $00, $0D
	smpsVcDecayRate2    $01, $00, $00, $00
	smpsVcDecayLevel    $03, $05, $00, $04
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $2D, $18, $1E

;	Voice $02
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

;	Voice $03
;	$1C
;	$6F, $01, $21, $71, 	$9F, $DB, $9E, $5E, 	$0F, $07, $06, $07
;	$08, $0A, $0B, $00, 	$8F, $8F, $FF, $FF, 	$18, $8D, $26, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $03
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $02, $00, $06
	smpsVcCoarseFreq    $01, $01, $01, $0F
	smpsVcRateScale     $01, $02, $03, $02
	smpsVcAttackRate    $1E, $1E, $1B, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $06, $07, $0F
	smpsVcDecayRate2    $00, $0B, $0A, $08
	smpsVcDecayLevel    $0F, $0F, $08, $08
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $26, $0D, $18