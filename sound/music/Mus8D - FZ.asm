Mus8D_FZ_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     Mus8D_FZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $06

	smpsHeaderDAC       Mus8D_FZ_DAC
	smpsHeaderFM        Mus8D_FZ_FM1,	$00, $12
	smpsHeaderFM        Mus8D_FZ_FM2,	$F4, $0D
	smpsHeaderFM        Mus8D_FZ_FM3,	$F4, $0A
	smpsHeaderFM        Mus8D_FZ_FM4,	$F4, $0F
	smpsHeaderFM        Mus8D_FZ_FM5,	$00, $12
	smpsHeaderPSG       Mus8D_FZ_PSG1,	$D0, $03, $00, fTone_05
	smpsHeaderPSG       Mus8D_FZ_PSG2,	$DC, $06, $00, fTone_05
	smpsHeaderPSG       Mus8D_FZ_PSG3,	$DC, $00, $00, fTone_04

; FM1 Data
Mus8D_FZ_FM1:
	smpsSetvoice        $00
	smpsModSet          $1A, $01, $06, $04
	dc.b	nB6, $03, nRst, nAb6, nRst, nAb6, nRst, nB6, nB6, nRst, $18

Mus8D_FZ_Jump05:
	dc.b	nRst, $0C, nA5, nB5, nC6, nD6, nC6, nB5, nC6, nE6, $30, smpsNoAttack
	dc.b	$30, nRst, $0C, nA5, nB5, nC6, nD6, nC6, nB5, nC6, nF6, $30
	dc.b	nG6, $18, nAb6, nA5, $0C, nA5, nA5, nA5, nB5, nB5, nB5, nB5
	smpsJump            Mus8D_FZ_Jump05

; Unreachable
	smpsStop

; FM2 Data
Mus8D_FZ_FM2:
	smpsSetvoice        $01
	dc.b	nE4, $03, nRst, nE3, nRst, nE3, nRst, nE4, nE4, nRst, $12, nC4
	dc.b	$03, nB3

Mus8D_FZ_Jump04:
	dc.b	nA3, $0C, nA3, $09, nA3, $03, nA3, $06, nA3, $0C, nE3, $06
	dc.b	nA3, $03, nE3, nA3, $0C, nE3, $06, nA3, $0C, nG3, nF3, $0C
	dc.b	nF3, $09, nF3, $03, nF3, $06, nF3, $0C, nC3, $06, nG3, $06
	dc.b	nG3, $0C, nG3, $06, nAb3, nAb3, $0C, nC4, $03, nB3, nA3, $0C
	dc.b	nA3, $09, nA3, $03, nA3, $06, nA3, $0C, nE3, $06, nA3, $03
	dc.b	nE3, nA3, $0C, nE3, $06, nA3, $0C, nG3, nF3, $0C, nF3, $09
	dc.b	nF3, $03, nF3, $06, nF3, $0C, nC3, $06, nG3, $06, nG3, $0C
	dc.b	nG3, $06, nAb3, nAb3, $0C, nAb3, $06, nF3, $0C, nF3, $09, nF3
	dc.b	$03, nF3, $06, nF3, $0C, nC3, $06, nG3, $06, nG3, $0C, nG3
	dc.b	$06, nE3, nE3, $0C, nC4, $03, nB3
	smpsJump            Mus8D_FZ_Jump04

; Unreachable
	smpsStop


; FM3 Data
Mus8D_FZ_FM3:
	smpsSetvoice        $02
	dc.b	nE7, $03, nRst, nE6, nRst, nE6, nRst, nE7, nE7, $03, nRst, $18

Mus8D_FZ_Jump03:
	dc.b	nRst, $1E, nA4, $03, nRst, nC5, nRst, nE5, nRst, nA5, $03, nG5
	dc.b	nA5, $06, smpsNoAttack, $24, smpsNoAttack, $06, nC7, nRst, nA6, $03, nRst, nF6
	dc.b	nRst, nD6, $12, smpsNoAttack, $06, nD7, $06, nRst, nC7, $03, nRst, nB6
	dc.b	nRst, nAb6, $12, nRst, $1E, nA4, $03, nRst, nC5, nRst, nE5, nRst
	dc.b	nA5, $03, nG5, $03, nA5, $06, smpsNoAttack, $24, smpsNoAttack, $06, nC7, $06
	dc.b	nRst, nA6, $03, nRst, nF6, nRst, nD6, $12, smpsNoAttack, $06, nD7, $06
	dc.b	nRst, nC7, $03, nRst, nB6, nRst, nAb6, $12, nA5, $18, nB5, $0C
	dc.b	nC6, nB5, $18, nC6, $0C, nD6
	smpsJump            Mus8D_FZ_Jump03

; Unreachable
	smpsStop

; FM4 Data
Mus8D_FZ_FM4:
	smpsSetvoice        $02
	smpsAlterVol        $FC
	smpsDetune          $03
	dc.b	nE7, $03, nRst, nE6, nRst, nE6, nRst, nE7, nE7, $03, nRst, $18
	smpsAlterVol        $04
	smpsSetvoice        $03

Mus8D_FZ_Jump02:
	dc.b	nA4, $06, nE4, nB4, nE4, nC5, nE4, nB4, nE4, nA4, nE4, nB4
	dc.b	nE4, nC5, nE4, nB4, nE4, nA4, nE4, nB4, nE4, nC5, nE4, nA4
	dc.b	nE4, nB4, nE4, nD5, nE4, nC5, nE4, nB4, nE4, nA4, nE4, nB4
	dc.b	nE4, nC5, nE4, nB4, nE4, nA4, nE4, nB4, nE4, nC5, nE4, nB4
	dc.b	nE4, nA4, nE4, nB4, nE4, nC5, nE4, nA4, nE4, nB4, nE4, nD5
	dc.b	nE4, nC5, nE4, nB4, nE4, $06, nC7, $03, nB6, nBb6, nA6, nC7
	dc.b	nB6, nBb6, nA6, nC7, nB6, nBb6, nA6, nC7, nB6, nBb6, nA6, nD7
	dc.b	nCs7, nC7, nB6, nD7, nCs7, nC7, nB6, nD7, nCs7, nC7, nB6, nD7
	dc.b	nCs7, nC7, nB6
	smpsJump            Mus8D_FZ_Jump02

; Unreachable
	smpsStop

; FM5 Data
Mus8D_FZ_FM5:
	smpsSetvoice        $00
	smpsDetune          $03
	dc.b	nB6, $03, nRst, nAb6, nRst, nAb6, nRst, nB6, nB6, $03, nRst, $18

Mus8D_FZ_Jump01:
	dc.b	nRst, $0C, nA5, nB5, nC6, nD6, nC6, nB5, nC6, nE6, $30, smpsNoAttack
	dc.b	$30, nRst, $0C, nA5, nB5, nC6, nD6, nC6, nB5, nC6, nF6, $30
	dc.b	nG6, $18, nAb6, nA5, $0C, nA5, nA5, nA5, nB5, nB5, nB5, nB5
	smpsJump            Mus8D_FZ_Jump01

; Unreachable
	smpsStop

; PSG1 Data
Mus8D_FZ_PSG1:
	smpsStop

; PSG2 Data
Mus8D_FZ_PSG2:
	smpsStop

; PSG3 Data
Mus8D_FZ_PSG3:
	smpsStop

; DAC Data
Mus8D_FZ_DAC:
	smpsNoteFill        $0A
	dc.b	dHiTimpani, $06, dLowTimpani, dLowTimpani
	smpsNoteFill        $00
	dc.b	dHiTimpani, $03, dHiTimpani, $09, dSnare, $03, dSnare, $03, dSnare, $03, dSnare, $03
	dc.b	dLowTimpani, dLowTimpani

Mus8D_FZ_Jump00:
	dc.b	dSnare, $0C, dSnare, $09, dSnare, $03, dSnare, $06, dSnare, $06, dHiTimpani, $06
	dc.b	dLowTimpani, dSnare, $06, dSnare, $0C, dSnare, $06, dSnare, $0C, dSnare, $0C, dSnare
	dc.b	$0C, dSnare, $09, dSnare, $03, dSnare, $06, dSnare, $06, dHiTimpani, $03, dHiTimpani
	dc.b	$03, dLowTimpani, $06, dSnare, $06, dSnare, $0C, dSnare, $06, dSnare, dSnare, $0C
	dc.b	dSnare, $06, dSnare, $0C, dSnare, $09, dSnare, $03, dSnare, $06, dSnare, $06
	dc.b	dHiTimpani, dLowTimpani, dSnare, $06, dSnare, $0C, dSnare, $06, dSnare, $0C, dSnare, $0C
	dc.b	dSnare, $0C, dSnare, $09, dSnare, $03, dSnare, $06, dSnare, $06, dHiTimpani, $03
	dc.b	dHiTimpani, $03, dLowTimpani, $06, dSnare, $06, dSnare, $0C, dSnare, $06, dSnare, dSnare
	dc.b	$0C, dSnare, $06, dSnare, $0C, dSnare, $09, dSnare, $03, dSnare, $06, dSnare
	dc.b	$0C, dSnare, $06, dHiTimpani, $06, dLowTimpani, dHiTimpani, dLowTimpani, dHiTimpani, dLowTimpani, dHiTimpani, dLowTimpani
	smpsJump            Mus8D_FZ_Jump00
	
; Unreachable
	smpsStop

Mus8D_FZ_Voices:
;	Voice $00
;	$3D
;	$01, $02, $02, $02, 	$14, $0E, $8C, $0E, 	$08, $05, $02, $05
;	$00, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$1A, $92, $A7, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $02, $02, $01
	smpsVcRateScale     $00, $02, $00, $00
	smpsVcAttackRate    $0E, $0C, $0E, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $02, $05, $08
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $27, $12, $1A

;	Voice $01
;	$20
;	$36, $35, $30, $31, 	$DF, $DF, $9F, $9F, 	$07, $06, $09, $06
;	$07, $06, $06, $08, 	$2F, $1F, $1F, $FF, 	$19, $37, $13, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $00, $05, $06
	smpsVcRateScale     $02, $02, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $09, $06, $07
	smpsVcDecayRate2    $08, $06, $06, $07
	smpsVcDecayLevel    $0F, $01, $01, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $13, $37, $19

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
;	$3A
;	$42, $43, $14, $71, 	$1F, $12, $1F, $1F, 	$04, $02, $04, $0A
;	$01, $01, $02, $02, 	$1F, $1F, $1F, $1F, 	$1A, $16, $19, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $01, $04, $04
	smpsVcCoarseFreq    $01, $04, $03, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $12, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $04, $02, $04
	smpsVcDecayRate2    $02, $02, $01, $01
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $19, $16, $1A