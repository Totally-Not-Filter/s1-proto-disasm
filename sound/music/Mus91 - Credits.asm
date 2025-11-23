Mus91_Credits_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice		Mus91_Credits_Voices
	smpsHeaderChan		$06, $03
	smpsHeaderTempo		$01, $33

	smpsHeaderDAC		Mus91_Credits_DAC
	smpsHeaderFM		Mus91_Credits_FM1,	$F4, $12
	smpsHeaderFM		Mus91_Credits_FM2,	$00, $0B
	smpsHeaderFM		Mus91_Credits_FM3,	$F4, $14
	smpsHeaderFM		Mus91_Credits_FM4,	$F4, $08
	smpsHeaderFM		Mus91_Credits_FM5,	$F4, $20
	smpsHeaderPSG		Mus91_Credits_PSG1,	$D0, $01, $00, $00
	smpsHeaderPSG		Mus91_Credits_PSG2,	$D0, $03, $00, $00
	smpsHeaderPSG		Mus91_Credits_PSG3,	$00, $03, $00, fTone_04

; FM1 Data
Mus91_Credits_FM1:
	dc.b	nRst, $30, $30
	smpsSetvoice		$1C
	smpsAlterPitch		$0C
	smpsAlterVol		$F8
	smpsNoteFill		$06
	smpsCall			Mus91_Credits_Call06
	smpsPan				panCenter, $00
	smpsNoteFill		$00
	smpsSetvoice		$03
	smpsGlobalMod		$01
	smpsAlterPitch		$E8
	smpsCall			Mus91_Credits_Call09
	smpsAlterPitch		$0C
	dc.b	nRst, $30, $30, $30, $30, $30, $30, $30, $30
	smpsModOff
	smpsSetTempoDiv		$0F
	smpsSetvoice		$05
	smpsAlterVol		$02
	dc.b	nRst, $06, nE5, nG5, nE5, nG5, $09
	dc.b	nA5, nB5, $0C, nC6, $06, nB5, nA5, nG5, $09, nA5, $06, nG5, $03, nE5, $06
	dc.b	nRst, $06, nA5, nC6, nA5, nC6, $09, nD6, nE6, $0C, nF6, $06, nE6, nD6, nC6
	dc.b	$0C, nA5, $0C, nD6, $04, nC6, nD6, nC6, $24
	smpsAlterPitch		$F4
	smpsAlterVol		$09
	smpsSetvoice		$08
	dc.b	nRst, $18, nA5, $06, nB5, nC6, nE6
	smpsCall			Mus91_Credits_Call03
	smpsSetvoice		$0B
	smpsAlterVol		$EB
	dc.b	nRst, $0C, nG5, nA5, nG6
	smpsCall			Mus91_Credits_Call04
	dc.b	nE6, $1E, nE7, $06, nC7, $18, nRst, $24
	smpsSetTempoMod		$0A
	smpsSetvoice		$0F
	smpsAlterPitch		$0C
	smpsAlterVol		$0B
	smpsCall			Mus91_Credits_Call05
	smpsSetTempoMod		$07
	dc.b	nRst, $30, nRst, $30
	smpsSetTempoMod		$03
	dc.b	nRst, $30
	smpsSetvoice		$17
	smpsAlterVol		$0E
	dc.b	nRst, $04, nF6, $08, nE6, $03, nRst, nD6, nRst, nC6, nRst, nD6, nRst, nC6
	dc.b	$04, nA5, nRst, $02, nBb5, nRst, $04, nBb5, $08, nC6, $03, nRst, nBb5, nRst, nA5, $04
	dc.b	nBb5, nRst, $02, nC6, $0E, nRst, $06, nE6, $02, nRst, $04, nE6, $0C, nF6, nE6, $0A, nD6, $02
	smpsSetTempoMod		$04
	smpsAlterVol		$F5
	smpsSetvoice		$1A
	dc.b	nRst, $30, nRst, $30, nRst, $0C, nCs6, $15, nRst, $03, nCs6, $06, nRst, nD6, $0F, nRst, $03, nB5, $18
	dc.b	nRst, $06, nCs6, $06, nRst, nCs6, nRst, nCs6, nRst, nA5, nRst, nG5, $0F, nRst, $03, nB5, $18, nRst, $06
	dc.b	nRst, $0C, nCs6, $15, nRst, $03, nCs6, $06, nRst, nD6, $0F, nRst, $03, nB5, $18, nRst, $06, nCs6, $06
	dc.b	nRst, nCs6, nRst, nCs6, nRst, nA5, nRst, nG5, $0F, nRst, $03, nB5, $18, nRst, $06, nRst, $30, nRst, $30
	smpsAlterVol		$FB
	dc.b	nRst, $0C, nE6, $06, nRst, nB6, nE6, $06, nRst, $0C, nE6, $06, nRst, nB6, nE6, $06, nRst, $18
	smpsAlterVol		$05
	dc.b	nRst, $0C, nA3, nRst, nA3
	smpsSetvoice		$1B
	dc.b	nRst, $24
	smpsDetune			$02
	smpsAlterVol		$F8
	dc.b	nA1, $0C, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $30
	smpsStop

; FM2 Data
Mus91_Credits_FM2:
	dc.b	nRst, $30, $30
	smpsSetvoice		$1D

Mus91_Credits_Loop0A:
	dc.b	nD3, $0C, nD3, nB3, nB3, nG3, nG3, nA3, nA3, nD3, nD3, nA3
	dc.b	nA3, nFs3, nFs3, nG3, nG3, nC3, nC3, nG3, nG3, nFs3, nFs3, nG3
	dc.b	nG3, nA2, nA2, nA2, nA2, nD3, nD3, nD3, nE3
	smpsLoop			$00, $02, Mus91_Credits_Loop0A
	smpsSetvoice		$00
	smpsNoteFill		$05
	dc.b	nF3, $0C, nF3, nF3, nF3, nF3, nF3, nF3
	smpsNoteFill		$00
	dc.b	nF3
	smpsNoteFill		$05
	dc.b	nE3, $0C, nE3, nE3, nE3, nE3
	smpsNoteFill		$00
	dc.b	nC3, nD3, nE3
	smpsNoteFill		$05
	dc.b	nF3, $0C, nF3, nF3, nF3, nF3, nF3, nF3
	smpsNoteFill		$00
	dc.b	nF3
	smpsNoteFill		$05
	dc.b	nE3, $0C, nE3, nE3, nE3, nE3
	smpsNoteFill		$00
	dc.b	nC3, nD3, nE3
	smpsNoteFill		$05
	dc.b	nF3, $0C, nF3, nF3, nF3, nF3, nF3, nF3
	smpsNoteFill		$00
	dc.b	nF3
	smpsNoteFill		$05
	dc.b	nE3, $0C, nE3, nE3, nE3, nE3, nE3, nE3
	smpsNoteFill		$00
	dc.b	nE3
	smpsNoteFill		$05
	dc.b	nD3, $0C, nD3, nD3, nD3, nD3, nD3, nD3
	smpsNoteFill		$00
	dc.b	nD3
	smpsNoteFill		$05
	dc.b	nC3, $0C, nC3, nC3, nC3, nC3
	smpsNoteFill		$00
	dc.b	nG2, nA2, nB2
	smpsNoteFill		$05
	dc.b	nC3, $0C, nC3, nC3, nC3, nC3, nC3, nC3, nC3, nC3, $0C, nC3
	dc.b	nC3, nC3, nC3, nC3, nC3, nC3, nC3, $0C, nC3, nC3, nC3, nC3
	dc.b	nC3, nC3, nC3
	smpsNoteFill		$00
	dc.b	nC3, $06, nRst, nC3, $0C, nA2, $06, nRst, nA2, $0C, nBb2, $06
	dc.b	nRst, nBb2, $0C, nB2, $06, nRst, nB2, $0C
	smpsSetvoice		$06
	smpsAlterPitch		$E8
	smpsAlterVol		$02
	dc.b	nC4, $0F, nRst, $03, nE4, nRst, nG4, $09, nRst, $03, nA4
	dc.b	$09, nRst, $03, nB4, $0F, nRst, $03, nA4, nRst, nG4, $09, nRst
	dc.b	$03, nE4, $09, nRst, $03, nF4, $0F, nRst, $03, nA4, nRst, nC5
	dc.b	$09, nRst, $03, nD5, $09, nRst, $03, nE5, $0F, nRst, $03, nD5
	dc.b	nRst, nC5, $09, nRst, $03, nA4, $09, nRst, $03, nC4, $0F, nRst
	dc.b	$03, nE4, nRst, nG4, $09, nRst, $03, nE4, $09, nRst, $03, nC4
	dc.b	$06, nRst, $12, nE4, $18
	smpsAlterVol		$01
	smpsSetvoice		$09
	dc.b	nA3, $03, nRst, nA3, $06, nE4, $03, nRst, nE4, $06, nD4, $03
	dc.b	nRst, nD4, $06, nE4, $03, nRst, nE4, $06, nA3, $03, nRst, nA3
	dc.b	$06, nE4, $03, nRst, nE4, $06, nD4, $03, nRst, nD4, $06, nE4
	dc.b	$03, nRst, nE4, $06, nD4, $03, nRst, nD4, $06, nA4, $03, nRst
	dc.b	nA4, $06, nF4, $03, nRst, nF4, $06, nA4, $03, nRst, nA4, $06
	dc.b	nD4, $03, nRst, nD4, $06, nA4, $03, nRst, nA4, $06, nF4, $03
	dc.b	nRst, nF4, $06, nA4, $03, nRst, nA4, $06, nB3, $03, nRst, nB3
	dc.b	$06, nF4, $03, nRst, nF4, $06, nD4, $03, nRst, nD4, $06, nF4
	dc.b	$03, nRst, nF4, $06, nE4, $03, nRst, nE4, $06, nB4, $03, nRst
	dc.b	nB4, $06, nAb4, $03, nRst, nAb4, $06, nB4, $03, nRst, nB4, $06
	dc.b	nA3, $03, nRst, nA3, $06, nE4, $03, nRst, nE4, $06, nC4, $03
	dc.b	nRst, nC4, $06, nE4, $03, nRst, nE4, $06, nA3, $03, nRst, $09
	dc.b	nRst, $24
	smpsAlterVol		$F8
	dc.b	nC4, $06, nRst, $03, nC4, nRst, $06, nC4, $12, nRst, $06, nC4
	dc.b	$02, nRst, $01, nC4, $02, nRst, $01, nBb3, $06, nRst, $03, nBb3
	dc.b	$03, nRst, $06, nA3, $12, nRst, $06, nA3, $02, nRst, $01, nA3
	dc.b	$02, nRst, $01, nD4, $06, nRst, $03, nD4, $06, nRst, $03, nD4
	dc.b	$02, nRst, $01, nD4, $02, nRst, $01, nCs4, $06, nRst, $03, nCs4
	dc.b	$06, nRst, $03, nCs4, $02, nRst, $01, nCs4, $02, nRst, $01, nC4
	dc.b	$06, nRst, $03, nC4, $06, nRst, $03, nC4, $02, nRst, $01, nC4
	dc.b	$02, nRst, $01, nB3, $06, nRst, $03, nB3, $06, nRst, $03, nB3
	dc.b	$02, nRst, $01, nB3, $02, nRst, $01, nG3, $06, nRst, $03, nG3
	dc.b	nRst, $06, nG3, $12, nRst, $06, nG3, $02, nRst, $01, nG3, $02
	dc.b	nRst, $01, nB3, $06, nRst, $03, nB3, nRst, $06, nB3, $12, nRst
	dc.b	$06, nD4, $02, nRst, $01, nB3, $02, nRst, $01, nC4, $06, nRst
	dc.b	$03, nC4, nRst, $06, nC4, $12, nRst, $06, nE4, $02, nRst, $01
	dc.b	nF4, $02, nRst, $01, nG4, $06, nRst, nG3, $24
	smpsSetvoice		$10
	smpsAlterPitch		$0C
	smpsAlterVol		$07
	smpsNoteFill		$06
	dc.b	nC4, $03, $03, nG3, nG3, nA3, nA3, nG3, nG3, nC4, nC4, nG3
	dc.b	nG3, nA3, nA3, nG3, nG3, nFs4, nFs4, nCs4, nCs4, nEb4, nEb4, nCs4
	dc.b	nCs4, nFs4, nFs4, nCs4, nCs4, nEb4, nEb4, nCs4, nCs4, nF4, nF4, nC4
	dc.b	nC4, nD4, nD4, nC4, nC4, nF4, nF4, nC4, nC4, nD4, nD4, nC4
	dc.b	nC4, nG4, nG4, nD4, nD4, nE4, nE4, nD4, nD4, nG4, nG4, nD4
	dc.b	nD4, nE4, nE4, nD4, nD4, nC4, nC4, nG3, nG3, nA3, nA3, nG3
	dc.b	nG3, nC4, nC4, nG3, nG3, nA3, nA3, nG3, nG3, nFs4, nFs4, nCs4
	dc.b	nCs4, nEb4, nEb4, nCs4, nCs4, nFs4, nFs4, nCs4, nCs4, nEb4, nEb4, nCs4
	dc.b	nCs4, nF4, nF4, nC4, nC4, nD4, nD4, nC4, nC4, nF4, nF4, nC4
	dc.b	nC4, nD4, nD4, nC4, nC4, nG4, nG4, nD4, nD4, nE4, nE4, nD4
	dc.b	nD4, nG4, nG4, nD4, nD4, nE4, nE4, nD4, nD4
	smpsNoteFill		$00
	smpsAlterPitch		$F4
	smpsAlterVol		$FC
	smpsSetvoice		$14
	dc.b	nRst, $30, nRst, $30, nA4, $03, nRst, nA4, nRst, nG4, nRst, nG4
	dc.b	nRst, nF4, nRst, nF4, nRst, nE4, nRst, nE4, $02, nRst, nBb4
	smpsAlterVol		$02
	dc.b	nRst, $04, nBb4, $08, nC5, $03, nRst, nBb4, nRst, nA4, $06, nRst
	dc.b	nBb4, $04, nA4, nRst, $02, nG4, nRst, $04, nG4, $08, nA4, $03
	dc.b	nRst, nG4, nRst, nF4, nRst, nF4, nRst, nG4, $04, nF4, nRst, $02
	dc.b	nE4, nRst, $04, nE4, $08, nE4, $03, nRst, nE4, nRst, nA4, $09
	dc.b	nRst, $03, nA4, $0A, nD4, $02
	smpsAlterPitch		$0C
	smpsAlterVol		$FE
	smpsSetvoice		$19
	dc.b	nRst, $30, nRst, $30, nA3, $06, nRst, nA3, nRst, nE3, nRst, nE3
	dc.b	nRst, nG3, $12, nFs3, $0C, nG3, $06, nFs3, $0C, nA3, $06, nRst
	dc.b	nA3, nRst, nE3, nRst, nE3, nRst, nD4, $12, nCs4, $0C, nD4, $06
	dc.b	nCs4, $0C, nA3, $06, nRst, nA3, nRst, nE3, nRst, nE3, nRst, nG3
	dc.b	$12, nFs3, $0C, nG3, $06, nFs3, $0C, nA3, $06, nRst, nA3, nRst
	dc.b	nE3, nRst, nE3, nRst, nD4, $12, nCs4, $0C, nD4, $06, nCs4, $0C
	dc.b	nG3, $06, nRst, nE3, nRst, nF3, nRst, nFs3, nRst, nG3, $06, nG3
	dc.b	$06, nE3, $06, nRst, nF3, nRst, nG3, nRst, nE3, $06, nRst, nE3
	dc.b	nRst, nAb3, nRst, nAb3, nRst, nB3, $06, nRst, nB3, nRst, nD4, nRst
	dc.b	nD4, nRst, nRst, $0C, nA3, $12, nRst, $06, nA3, $0C, smpsNoAttack, $06
	dc.b	nAb3, $12, nA3, $06, nRst, $06
	smpsAlterVol		$FD
	dc.b	nA2, $0C, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $30
	smpsStop

; FM3 Data
Mus91_Credits_FM3:
	dc.b	nRst, $30, $30
	smpsLoop			$00, $08, Mus91_Credits_FM3
	smpsSetvoice		$1F
	smpsAlterVol		$01
	smpsPan				panRight, $00
	dc.b	nD6, $06, nE6, nFs6, nG6, nE6, nFs6, nG6, nA6, nFs6, $06, nG6
	dc.b	nA6, nB6, nA6, nB6, nC7, nD7

Mus91_Credits_Loop09:
	smpsPan				panLeft, $00
	dc.b	nE7, $06
	smpsPan				panRight, $00
	dc.b	nC7
	smpsAlterVol		$02
	smpsLoop			$00, $0D, Mus91_Credits_Loop09
	smpsPan				panCenter, $00
	smpsSetvoice		$02
	smpsAlterVol		$E5
	smpsAlterPitch		$E8
	dc.b	nG6, $06, nA6, nC7, $0C, nA6, nRst, $4E, nRst, nG6, $06, nA6, nC7
	dc.b	$0C, nE7, nRst, $4E, nRst, nG6, $06, nA6, nC7, $0C, nA6, nRst
	dc.b	$36, nRst, nC7, $06, nRst, $12, nA6, $18, nG6, $06, nRst, nA6
	dc.b	nRst, nC7, nRst
	smpsModOff
	smpsSetvoice		$04
	smpsAlterVol		$FE
	dc.b	nC6, $01, smpsNoAttack, nB5, $1B, nRst, $08, nBb5, $01, smpsNoAttack, nA5, $1B
	dc.b	nRst, $08, nC6, $01, smpsNoAttack, nB5, $1B, nRst, $08, nBb5, $01, smpsNoAttack
	dc.b	nA5, $1B, nRst, $08, nC6, $01, smpsNoAttack, nB5, $0B, nRst, $0C, nBb5
	dc.b	$01, smpsNoAttack, nA5, $0B, nRst, $0C, nCs6, $01, smpsNoAttack, nC6, $1B, nRst
	dc.b	$08, nC6, $01, smpsNoAttack, nB5, $24, smpsNoAttack, $18, smpsNoAttack, $5A, nRst, $06
	smpsAlterPitch		$18
	dc.b	nRst, $30, nRst, $30, nRst, $30, nRst, $30, nRst, $30
	smpsAlterPitch		$E8
	smpsSetvoice		$08
	smpsAlterPitch		$0C
	smpsAlterVol		$03
	smpsDetune			$02
	dc.b	nRst, $18, nA5, $06, nB5, nC6, nE6
	smpsCall			Mus91_Credits_Call03
	smpsSetvoice		$0D
	smpsAlterPitch		$0C
	smpsAlterVol		$0B
	dc.b	nRst, $0C, nG5, nA5, nG6
	smpsCall			Mus91_Credits_Call04
	smpsSetvoice		$0A
	smpsAlterVol		$EC
	dc.b	nRst, $06
	smpsDetune			$14
	dc.b	nG5, $01, smpsNoAttack
	smpsDetune			$00
	dc.b	$02, nA5, $03
	smpsNoteFill		$05
	dc.b	nC6, $03, nC6, $06, nA5, $03, nC6, $03
	smpsNoteFill		$00
	dc.b	nC6, $03
	smpsAlterVol		$FC
	smpsAlterPitch		$33
	smpsSetvoice		$0E
	dc.b	nEb4, $03
	smpsAlterVol		$07
	dc.b	nEb4, $03
	smpsAlterVol		$07
	dc.b	nEb4, $03
	smpsAlterVol		$07
	dc.b	nEb4, $03
	smpsAlterVol		$07
	smpsSetvoice		$0A
	smpsAlterVol		$E8
	smpsAlterPitch		$CD
	dc.b	nE6, $03, nF6, $03, nG6, $03, nRst, $09
	smpsDetune			$EC
	dc.b	nC7, $01, smpsNoAttack
	smpsDetune			$00
	smpsModSet			$2C, $01, $04, $04
	dc.b	nC7, $23
	smpsModOff
	smpsSetvoice		$0F
	smpsAlterVol		$FF
	smpsDetune			$03
	smpsCall			Mus91_Credits_Call05
	smpsDetune			$00
	smpsSetvoice		$15
	smpsAlterVol		$09
	dc.b	nRst, $30, nRst, $30, nRst, $2E, nF5, $02, nRst, $04, nF5, $08
	dc.b	nF5, $03, nRst, nF5, nRst, nE5, $03, nRst, $13, nD5, $02, nRst
	dc.b	$04, nD5, $08, nD5, $03, nRst, nD5, nRst, nC5, $03, nRst, $15
	dc.b	nRst, $04, nA6, $08, nG6, $03, nRst, nG6, nRst, nF6, nRst, nF6
	dc.b	nRst, nE6, $04, nF6, $02, nE6, $04, nD6, $02
	smpsSetvoice		$0A
	smpsAlterVol		$F9
	dc.b	nRst, $30, nRst, $30, nE6, $06, nRst, nE6, nRst, nCs6, nRst, nCs6
	dc.b	nRst, nD6, $12, nD6, $1E, nE6, $06, nRst, nE6, nRst, nCs6, nRst
	dc.b	nCs6, nRst, nG6, $12, nG6, $1E, nE6, $06, nRst, nE6, nRst, nCs6
	dc.b	nRst, nCs6, nRst, nD6, $12, nD6, $1E, nE6, $06, nRst, nE6, nRst
	dc.b	nCs6, nRst, nCs6, nRst, nG6, $12, nG6, $1E, nRst, $0C, nD6, $12
	dc.b	nRst, $06, nD6, nRst, nCs6, $12, nD6, $12, nCs6, $0C, nAb5, $18
	dc.b	nB5, $18, nD6, $18, nAb6, $18, nRst, $0C, nE6, $0C, nRst, $0C
	dc.b	nE6, $0C, smpsNoAttack, $06, nEb6, $12, nE6, $06, nRst, $06
	smpsAlterVol		$F8
	smpsSetvoice		$19
	smpsDetune			$03
	dc.b	nA2, $0C, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $30
	smpsStop

; FM4 Data
Mus91_Credits_FM4:
	smpsSetvoice		$20
	dc.b	nRst, $30, $30
	smpsAlterVol		$08
	dc.b	nB5, $24, $24, $18, nA5, $24, $24, $18, nG5, $24, $24, $18
	dc.b	nFs5, $0C, $0C, nRst, $18, nA5, $0C, $0C, nRst, $18, nB5, $24
	dc.b	$24, $18, nA5, $24, $24, $18, nG5, $24, $24, $18, nA5, $24
	dc.b	$24, $18
	smpsSetvoice		$02
	smpsAlterPitch		$E8
	smpsAlterVol		$0D
	smpsPan				panLeft, $00
	dc.b	nE5, $0C, nE5, nC5, nC5, nA4, nA4, nF4, nF4, nD5, nD5, nB4
	dc.b	nB4, nG4, nG4, nD5, nD5, nE5, nE5, nC5, nC5, nA4, nA4, nF4
	dc.b	nF4, nD5, nD5, nB4, nB4, nG4, nG4, nD5, nD5, nE5, nE5, nC5
	dc.b	nC5, nA4, nA4, nF4, nF4, nD5, nD5, nB4, nB4, nG4, nG4, nE4
	dc.b	nE4, nC5, nC5, nA4, nA4, nF4, nF4, nD4, nD4, nB4, nB4
	smpsAlterVol		$03
	smpsAlterPitch		$18
	smpsAlterPitch		$F4
	smpsSetvoice		$01
	dc.b	nG6, $18, nA6, nB6
	smpsSetvoice		$04
	smpsPan				panLeft, $00
	smpsAlterPitch		$F4
	smpsAlterVol		$F2
	dc.b	nAb5, $01, smpsNoAttack, nG5, $1B, nRst, $08, nFs5, $01, smpsNoAttack, nF5, $1B
	dc.b	nRst, $08, nAb5, $01, smpsNoAttack, nG5, $1B, nRst, $08, nFs5, $01, smpsNoAttack
	dc.b	nF5, $1B, nRst, $08, nAb5, $01, smpsNoAttack, nG5, $0B, nRst, $0C, nFs5
	dc.b	$01, smpsNoAttack, nF5, $0B, nRst, $0C, nBb5, $01, smpsNoAttack, nA5, $1B, nRst
	dc.b	$08, nAb5, $01, smpsNoAttack, nG5, $24, smpsNoAttack, $18, smpsNoAttack, $5A, nRst, $06
	smpsAlterPitch		$18
	dc.b	nRst, $30, nRst, $30, nRst, $30, nRst, $30, nRst, $30, nRst, $2A
	smpsPan				panCenter, $00
	smpsSetvoice		$0A
	smpsAlterPitch		$F4
	smpsAlterVol		$05
	dc.b	nB6, $06, smpsNoAttack, $03, nRst, nB6, nRst, nC7, $06, nRst, nB6, $0C
	dc.b	nRst, $06, nB6, smpsNoAttack, $03, nRst, nB6, nRst, nC7, $06, nRst, nB6
	dc.b	$0C, nRst, nRst, $0C, nC7, $03, nRst, $0F, nC7, $03, nRst, $0F
	dc.b	nRst, $0C, nC7, $03, nRst, $0F, nC7, $03, nRst, $09, nF6, $06
	dc.b	smpsNoAttack, $03, nRst, nF6, nRst, nA6, $06, nRst, nF6, $0C, nRst, $06
	dc.b	nAb6, smpsNoAttack, $03, nRst, nAb6, nRst, nB6, $06, nRst, nAb6, $0C, nRst
	dc.b	nRst, $0C, nC7, $03, nRst, $0F, nC7, $03, nRst, $0F, nC7, $03
	dc.b	nRst, $09, nRst, $24
	smpsAlterPitch		$F4
	smpsAlterVol		$03
	smpsSetvoice		$0C
	smpsPan				panLeft, $00
	smpsCall			Mus91_Credits_Call02
	smpsSetvoice		$11
	smpsAlterVol		$F6
	smpsAlterPitch		$18
	dc.b	nRst, $0C
	smpsDetune			$EC
	dc.b	nG5, $02
	smpsDetune			$00
	dc.b	smpsNoAttack, $06, nRst, $01, nG5, $03, nRst, $18, nRst, $0C
	smpsDetune			$EC
	dc.b	nCs6, $02
	smpsDetune			$00
	dc.b	smpsNoAttack, $06, nRst, $01, nCs6, $03, nRst, $18, nRst, $0C
	smpsDetune			$EC
	dc.b	nC6, $02
	smpsDetune			$00
	dc.b	smpsNoAttack, $06, nRst, $01, nC6, $03, nRst, $18, nRst, $0C
	smpsDetune			$EC
	dc.b	nA5, $02
	smpsDetune			$00
	dc.b	smpsNoAttack, $0A, nRst, $03, nA5, nRst, nRst, nA5, nRst, $09, nRst, $0C
	smpsDetune			$EC
	dc.b	nG5, $02
	smpsDetune			$00
	dc.b	smpsNoAttack, $06, nRst, $01, nG5, $03, nRst, $18, nRst, $0C
	smpsDetune			$EC
	dc.b	nCs6, $02
	smpsDetune			$00
	dc.b	smpsNoAttack, $06, nRst, $01, nCs6, $03, nRst, $18, nRst, $0C
	smpsDetune			$EC
	dc.b	nC6, $02
	smpsDetune			$00
	dc.b	smpsNoAttack, $06, nRst, $01, nC6, $03, nRst, $18
	smpsDetune			$EC
	dc.b	nA5, $02
	smpsDetune			$00
	dc.b	$0A, nRst, $06
	smpsModSet			$18, $01, $07, $04
	smpsDetune			$E2
	dc.b	nA5, $02, smpsNoAttack
	smpsDetune			$00
	dc.b	$1C
	smpsDetune			$00
	smpsAlterVol		$08
	smpsSetvoice		$16
	dc.b	nRst, $30, nRst, $30
	smpsChanTempoDiv	$01
	smpsAlterVol		$FE
	smpsDetune			$03
	dc.b	nBb3, $01, smpsNoAttack, nA3, $04, nRst, $07, nBb3, $01, smpsNoAttack, nA3, $04
	dc.b	nRst, $07, nC4, $01, smpsNoAttack, nB3, $04, nRst, $07, nC4, $01, smpsNoAttack
	dc.b	nB3, $04, nRst, $07, nCs4, $01, smpsNoAttack, nC4, $04, nRst, $07, nCs4
	dc.b	$01, smpsNoAttack, nC4, $04, nRst, $07, nD4, $01, smpsNoAttack, nCs4, $04, nRst
	dc.b	$07, nD4, $01, smpsNoAttack, nCs4, $04, nRst, $03
	smpsChanTempoDiv	$02
	smpsAlterVol		$02
	smpsDetune			$00
	smpsSetvoice		$12
	smpsGlobalMod		$02
	dc.b	nD6, $02, nRst, $04, nD6, $08, nD6, $03, nRst, nD6, nRst, nC6, nRst, nA6, nRst, nF6, nRst, $07, nBb5, $02, nRst, $04
	dc.b	nBb5, $08, nBb5, $03, nRst, nBb5, nRst, nA5, $03, nRst, $13, nA5, $0E, nCs6, $0C, nE6, nCs7, $0A, nD7, $02
	smpsPan				panCenter,$00
	smpsSetvoice		$0A
	smpsAlterVol		$F5
	dc.b	nRst, $30, nRst, $30, nCs6, $06, nRst, nCs6, nRst, nA5, nRst, nA5, nRst, nB5, $12, nB5, $06, smpsNoAttack, $18, nCs6, $06, nRst
	dc.b	nCs6, nRst, nA5, nRst, nA5, nRst, nD6, $12, nD6, $06, smpsNoAttack, $18, nCs6, $06, nRst, nCs6, nRst, nA5, nRst, nA5, nRst, nB5, $12, nB5, $06
	dc.b	smpsNoAttack, $18, nCs6, $06, nRst, nCs6, nRst, nA5, nRst, nA5, nRst, nD6, $12, nD6, $06, smpsNoAttack, $18
	smpsSetvoice		$18
	smpsDetune			$03
	smpsAlterVol		$08
	dc.b	nRst, $0C, nG6, $0C, nB6, $0C, nD7, $0C, nFs7, $0C, nRst, $06, nFs7, $0C, nG7, $06, nFs7, $0C, nAb7, $30, smpsNoAttack, $24, nRst, $0C
	dc.b	nA7, $0C, nRst, $0C, nA7, $0C, nRst, $0C, nRst, $06, nAb7, $12, nA7, $0C
	smpsAlterVol		$F0
	smpsSetvoice		$19
	smpsModSet			$00, $01, $06, $04
	dc.b	nA2, $0C, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $30
	smpsStop

; FM5 Data
Mus91_Credits_FM5:
	smpsSetvoice		$20
	dc.b	nRst, $30, $30
	smpsAlterVol		$F0
	dc.b	nG5, $24, $24, $18, nFs5, $24, $24, $18, nE5, $24, $24, $18
	dc.b	nD5, $0C, $0C, nRst, $18, nFs5, $0C, $0C, nRst, $18, nG5, $24
	dc.b	$24, $18, nFs5, $24, $24, $18, nE5, $24, $24, $18, nFs5, $24
	dc.b	$24, $18
	smpsSetvoice		$02
	smpsAlterPitch		$E8
	smpsPan				panRight, $00
	smpsAlterVol		$0D
	dc.b	nE5, $0C, nE5, nC5, nC5, nA4, nA4, nF4, nF4, nD5, nD5, nB4
	dc.b	nB4, nG4, nG4, nD5, nD5, nE5, nE5, nC5, nC5, nA4, nA4, nF4
	dc.b	nF4, nD5, nD5, nB4, nB4, nG4, nG4, nD5, nD5, nE5, nE5, nC5
	dc.b	nC5, nA4, nA4, nF4, nF4, nD5, nD5, nB4, nB4, nG4, nG4, nE4
	dc.b	nE4, nC5, nC5, nA4, nA4, nF4, nF4, nD4, nD4, nB4, nB4
	smpsAlterPitch		$18
	smpsAlterVol		$03
	smpsAlterPitch		$F4
	smpsSetvoice		$01
	smpsDetune			$02
	dc.b	nG6, $18, nA6, nB6
	smpsSetvoice		$04
	smpsDetune			$00
	smpsPan				panRight, $00
	smpsAlterPitch		$F4
	smpsAlterVol		$F2
	dc.b	nF5, $01, smpsNoAttack, nE5, $1B, nRst, $08, nEb5, $01, smpsNoAttack, nD5, $1B
	dc.b	nRst, $08, nF5, $01, smpsNoAttack, nE5, $1B, nRst, $08, nEb5, $01, smpsNoAttack
	dc.b	nD5, $1B, nRst, $08, nF5, $01, smpsNoAttack, nE5, $0B, nRst, $0C, nEb5
	dc.b	$01, smpsNoAttack, nD5, $0B, nRst, $0C, nFs5, $01, smpsNoAttack, nF5, $1B, nRst
	dc.b	$08, nF5, $01, smpsNoAttack, nE5, $24, smpsNoAttack, $18, smpsNoAttack, $5A, nRst, $06
	smpsAlterPitch		$18
	smpsPan				panCenter, $00
	smpsAlterVol		$03
	smpsAlterPitch		$0C
	smpsSetvoice		$07
	dc.b	nRst, $30, nRst, $1E, nG4, $03, nA4, nC5, nRst, nA4, nRst, nRst
	dc.b	$30, nRst, $1E, nA5, $03, nF5, nC5, nRst, nF5, nRst, nRst, $30
	dc.b	nRst, $2A
	smpsSetvoice		$0A
	smpsAlterPitch		$E8
	smpsAlterVol		$02
	dc.b	nG6, $06, smpsNoAttack, $03, nRst, nG6, nRst, nA6, $06, nRst, nG6
	dc.b	$0C, nRst, $06, nG6, smpsNoAttack, $03, nRst, nG6, nRst, nA6, $06, nRst
	dc.b	nG6, $0C, nRst, nRst, $0C, nA6, $03, nRst, $0F, nA6, $03, nRst
	dc.b	$0F, nRst, $0C, nA6, $03, nRst, $0F, nA6, $03, nRst, $09, nD6
	dc.b	$06, smpsNoAttack, $03, nRst, nD6, nRst, nF6, $06, nRst, nD6, $0C, nRst
	dc.b	$06, nE6, smpsNoAttack, $03, nRst, nE6, nRst, nAb6, $06, nRst, nE6, $0C
	dc.b	nRst, nRst, $0C, nA6, $03, nRst, $0F, nA6, $03, nRst, $0F, nA6
	dc.b	$03, nRst, $09, nRst, $24
	smpsSetvoice		$0C
	smpsPan				panRight, $00
	smpsAlterPitch		$F4
	smpsAlterVol		$03
	smpsCall			Mus91_Credits_Call00
	smpsSetvoice		$12
	smpsAlterPitch		$24
	smpsAlterVol		$F4
	smpsCall			Mus91_Credits_Call01
	dc.b	nE6, nF6, nG6
	smpsCall			Mus91_Credits_Call01
	dc.b	nG6, nF6, nE6
	smpsAlterVol		$08
	smpsAlterPitch		$F4
	smpsSetvoice		$16
	dc.b	nRst, $30, nRst, $30
	smpsChanTempoDiv	$01
	dc.b	nBb3, $01, smpsNoAttack, nA3, $04, nRst, $07, nBb3, $01, smpsNoAttack, nA3
	dc.b	$04, nRst, $07, nC4, $01, smpsNoAttack, nB3, $04, nRst, $07, nC4, $01
	dc.b	smpsNoAttack, nB3, $04, nRst, $07, nCs4, $01, smpsNoAttack, nC4, $04, nRst, $07
	dc.b	nCs4, $01, smpsNoAttack, nC4, $04, nRst, $07, nD4, $01, smpsNoAttack, nCs4, $04
	dc.b	nRst, $07, nD4, $01, smpsNoAttack, nCs4, $04, nRst, $03
	smpsChanTempoDiv	$02
	smpsDetune			$02
	smpsGlobalMod		$03
	smpsSetvoice		$12
	dc.b	nD6, $02, nRst, $04, nD6, $08, nD6, $03, nRst, nD6, nRst, nC6, nRst, nA6, nRst
	dc.b	nF6, nRst, $07, nBb5, $02, nRst, $04, nBb5, $08, nBb5, $03, nRst, nBb5, nRst, nA5, $03
	dc.b	nRst, $13, nA5, $0E, nCs6, $0C, nE6, nCs7, $0A, nD7, $02
	smpsPan				panCentre, $00
	smpsSetvoice		$1A
	smpsDetune			$03
	smpsAlterVol		$F8
	dc.b	nRst, $30, nRst, $30, nRst, $0C, nCs6, $15, nRst, $03, nCs6, $06, nRst, nD6, $0F
	dc.b	nRst, $03, nB5, $18, nRst, $06, nCs6, $06, nRst, nCs6, nRst, nCs6, nRst, nA5, nRst, nG5, $0F
	dc.b	nRst, $03, nB5, $18, nRst, $06, nRst, $0C, nCs6, $15, nRst, $03, nCs6, $06, nRst, nD6, $0F
	dc.b	nRst, $03, nB5, $18, nRst, $06, nCs6, $06, nRst, nCs6, nRst, nCs6, nRst, nA5, nRst, nG5, $0F
	dc.b	nRst, $03, nB5, $18, nRst, $06
	smpsSetvoice		$18
	smpsAlterVol		$09
	smpsModSet			$00, $01, $06, $04
 	dc.b	nRst, $0C, nG6, $0C, nB6, $0C, nD7, $0C, nFs7, $0C, nRst, $06, nFs7, $0C, nG7, $06, nFs7, $0C, nAb7, $30
	dc.b	smpsNoAttack, $24, nRst, $0C, nA7, $0C, nRst, $0C, nA7, $0C, nRst, $0C, nRst, $06, nAb7, $12, nA7, $0C, nRst, $0C
	smpsStop

; PSG1 Data
Mus91_Credits_PSG1:
	dc.b	nRst, $30, $30
	smpsPSGvoice		fTone_08
	smpsPSGAlterVol		$03
	smpsNoteFill		$06
	smpsAlterPitch		$0C
	smpsCall			Mus91_Credits_Call06
	smpsPSGvoice		fTone_01
	smpsNoteFill		$00
	smpsAlterPitch		$F4
	smpsPSGAlterVol		$FD
	dc.b	nRst, $18, nC6, $06, nRst, $1E, nC6, $0C, nRst, $18, nRst, $18
	dc.b	nB5, $06, nRst, $1E, nB5, $0C, nRst, $18, nRst, $18, nC6, $06
	dc.b	nRst, $1E, nC6, $0C, nRst, $18, nRst, $18, nB5, $06, nRst, $1E
	dc.b	nB5, $0C, nRst, $18, nRst, $18, nC6, $06, nRst, $1E, nC6, $0C
	dc.b	nRst, $18, nRst, $18, nB5, $06, nRst, $1E, nB5, $0C, nRst, $18
	dc.b	nRst, $18, nA5, $06, nRst, $1E, nA5, $0C, nRst, $18, nRst, $18
	dc.b	nG5, $06, nRst, $1E, nG5, $0C, nRst, $18
	smpsPSGvoice		fTone_05
	smpsModSet			$0E, $01, $01, $03
	dc.b	nE5, $24, nD5, nE5, nD5, nE5, $0C, nRst, nD5, nRst, nF5, $24
	dc.b	nE5, smpsNoAttack, $3C, smpsNoAttack, $3C
	smpsModOff
	smpsPSGvoice		fTone_09
	smpsPSGAlterVol		$01
	dc.b	nRst, $06, nE6, $0C, nE6, nE6, nE6, $06, nRst, nE6, $0C, nE6
	dc.b	nE6, $03, $09, $06, nRst, $06, nA6, $0C, nA6, nA6, nA6, $06
	dc.b	nRst, nA6, $0C, nA6, nA6, $03, $09, $06, nRst, $06, nE6, $0C
	dc.b	nE6, nE6, nE6, $06, nRst, $30
	smpsPSGvoice		fTone_08
	smpsPSGAlterVol		$01
	smpsCall			Mus91_Credits_Call08
	dc.b	nRst, $30, nRst, $30
	smpsPSGAlterVol		$03
	smpsAlterPitch		$F4
	smpsPSGvoice		fTone_05
	smpsCall			Mus91_Credits_Call02
	smpsAlterPitch		$0C
	smpsPSGAlterVol		$FC
	smpsPSGvoice		$00
	dc.b	nRst, $0C, nE5, $07, nRst, $02, nE5, $03, nRst, $18, nRst, $0C
	dc.b	nBb5, $07, nRst, $02, nBb5, $03, nRst, $18, nRst, $0C, nA5, $07
	dc.b	nRst, $02, nA5, $03, nRst, $18, nRst, $0C, nF5, nRst, $03, nF5
	dc.b	nRst, nRst, nF5, nRst, $09, nRst, $0C, nE5, $07, nRst, $02, nE5
	dc.b	$03, nRst, $18, nRst, $0C, nBb5, $07, nRst, $02, nBb5, $03, nRst
	dc.b	$18, nRst, $0C, nA5, $07, nRst, $02, nA5, $03, nRst, $18, nF5
	dc.b	$0C, nRst, $06, nF5, $1E
	smpsPSGvoice		fTone_06
	smpsPSGAlterVol		$04
	dc.b	nRst, $30, nRst, $30
	smpsChanTempoDiv	$01
	dc.b	nBb3, $01, smpsNoAttack, nA3, $04, nRst, $07, nBb3, $01, smpsNoAttack, nA3
	dc.b	$04, nRst, $07, nC4, $01, smpsNoAttack, nB3, $04, nRst, $07, nC4, $01
	dc.b	smpsNoAttack, nB3, $04, nRst, $07, nCs4, $01, smpsNoAttack, nC4, $04, nRst, $07
	dc.b	nCs4, $01, smpsNoAttack, nC4, $04, nRst, $07, nD4, $01, smpsNoAttack, nCs4, $04
	dc.b	nRst, $07, nD4, $01, smpsNoAttack, nCs4, $04, nRst, $03
	smpsChanTempoDiv	$02
	dc.b	nD6, $02, nRst, $04, nD6, $08, nD6, $03, nRst, nD6, nRst
	dc.b	nC6, nRst, nA6, nRst, nF6, nRst, $07, nBb5, $02, nRst, $04, nBb5
	dc.b	$08, nBb5, $03, nRst, nBb5, nRst, nA5, $03, nRst, $13, nA5, $0E
	dc.b	nCs6, $0C, nE6, nCs7, $0A, nD7, $02, nRst, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30
	smpsPSGAlterVol		$FF
	dc.b	nRst, $0C, nB5, $12, nRst, $06, nB5, nRst, nA5, $12, nB5, $12
	dc.b	nA5, $0C, nE5, $18, nAb5, $18, nB5, $18, nD6, $18, nRst, $0C
	dc.b	nCs6, $0C, nRst, $0C, nCs6, $0C, smpsNoAttack, $06, nC6, $12, nCs6, $06
	dc.b	nRst, $12
	smpsStop

; PSG2 Data
Mus91_Credits_PSG2:
	dc.b	nRst, $30, $30
	smpsLoop			$00, $08, Mus91_Credits_PSG2
	dc.b	nRst, $02
	smpsPan				panLeft, $00
	dc.b	nD6, $06, nE6, nFs6, nG6, nE6, nFs6, nG6, nA6, nFs6, $06, nG6
	dc.b	nA6, nB6, nA6, nB6, nC7, nD7
	smpsPan				panCenter, $00
	smpsPSGAlterVol		$FE
	smpsPSGvoice		fTone_01
	dc.b	nRst, $16, nE6, $06, nRst, $1E, nE6, $0C, nRst, $18, nRst, $18
	dc.b	nD6, $06, nRst, $1E, nD6, $0C, nRst, $18, nRst, $18, nE6, $06
	dc.b	nRst, $1E, nE6, $0C, nRst, $18, nRst, $18, nD6, $06, nRst, $1E
	dc.b	nD6, $0C, nRst, $18, nRst, $18, nE6, $06, nRst, $1E, nE6, $0C
	dc.b	nRst, $18, nRst, $18, nD6, $06, nRst, $1E, nD6, $0C, nRst, $18
	dc.b	nRst, $18, nC6, $06, nRst, $1E, nC6, $0C, nRst, $18, nRst, $18
	dc.b	nB5, $06, nRst, $1E, nB5, $0C, nRst, $18

Mus91_Credits_Loop15:
	smpsNoteFill		$07
	smpsPSGvoice		fTone_06
	dc.b	nC7, $0C, nB6, nA6, nG6, nC7, nB6, nA6, nG6
	smpsLoop			$00, $04, Mus91_Credits_Loop15
	smpsNoteFill		$00
	smpsPSGvoice		fTone_09
	smpsPSGAlterVol		$01
	dc.b	nRst, $06, nG6, $0C, nG6, nG6, nG6, $06, nRst, nG6, $0C, nG6
	dc.b	nG6, $03, $09, $06, nRst, $06, nC7, $0C, nC7, nC7, nC7, $06
	dc.b	nRst, nC7, $0C, nC7, nC7, $03, $09, $06, nRst, $06, nG6, $0C
	dc.b	nG6, nG6, nG6, $06, nRst, $30, nRst, $02
	smpsDetune			$01
	smpsPSGAlterVol		$03
	smpsCall			Mus91_Credits_Call08
	dc.b	nRst, $2E
	smpsDetune			$00
	dc.b	nRst, $30
	smpsPSGAlterVol		$01
	smpsAlterPitch		$F4
	smpsPSGvoice		fTone_05
	smpsCall			Mus91_Credits_Call00
	smpsAlterPitch		$0C
	smpsPSGAlterVol		$FD
	smpsNoteFill		$03

Mus91_Credits_Loop16:
	dc.b	nC7, $03, $03, nG7, nC7, nF7, nC7, nE7, nC7, nC7, nC7, nG7
	dc.b	nC7, nF7, nC7, nE7, nC7, nBb6, nBb6, nF7, nBb6, nEb7, nBb6, nCs7
	dc.b	nBb6, nBb6, nBb6, nF7, nB6, nEb7, nBb6, nCs7, nBb6, nA6, nA6, nE7
	dc.b	nA6, nD7, nA6, nC7, nA6, nA6, nA6, nE7, nA6, nD7, nA6, nC7
	dc.b	nA6, nA6, nA6, nE7, nA6, nD7, nA6, nC7, nA6, nA6, nA6, nE7
	dc.b	nA6, nD7, nA6, nC7, nA6
	smpsLoop			$00, $02, Mus91_Credits_Loop16
	dc.b	nRst, $30, $30, $30, $30, $30, $30, nRst, $30, $30, $30, $30
	dc.b	$30, $30, $30, $30, $30, $30, $30, $30
	smpsAlterVol		$0C
	smpsDetune			$02
	smpsPSGAlterVol		$02
	dc.b	nRst, $0C, nE6, $06, nRst, nB6, nE6, $06, nRst, $0C, nE6, $06
	dc.b	nRst, nB6, nE6, $06, nRst, $18
	smpsStop

; PSG3 Data
Mus91_Credits_PSG3:
	smpsPSGform			$E7
	smpsNoteFill		$04

Mus91_Credits_Loop0B:
	dc.b	nMaxPSG, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	smpsLoop			$00, $09, Mus91_Credits_Loop0B
	smpsPSGform			$E7
	smpsNoteFill		$06

Mus91_Credits_Loop0C:
	dc.b	nMaxPSG, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	smpsLoop			$00, $0C, Mus91_Credits_Loop0C
	smpsPSGform			$E7
	smpsPSGAlterVol		$FF
	smpsCall			Mus91_Credits_Call07
	smpsNoteFill		$0E
	dc.b	nMaxPSG, $0C
	smpsNoteFill		$03
	dc.b	$06, $06, $03, $03, $06, $03, $03, $06

Mus91_Credits_Loop0D:
	smpsCall			Mus91_Credits_Call07
	smpsLoop			$00, $04, Mus91_Credits_Loop0D
	smpsPSGform			$E7
	smpsPSGvoice		fTone_09
	smpsPSGAlterVol		$01
	smpsAlterPitch		$0B
	dc.b	nA3, $06, nA3, nE4, nE4, nD4, nD4, nE4, nE4, nA3, nA3
	dc.b	nE4, nE4, nD4, nD4, nE4, nE4, nD4, nD4, nA4, nA4, nF4, nF4
	dc.b	nA4, nA4, nD4, nD4, nA4, nA4, nF4, nF4, nA4, nA4, nB3, nB3
	dc.b	nF4, nF4, nD4, nD4, nF4, nF4, nE4, nE4, nB4, nB4, nAb4, nAb4
	dc.b	nB4, nB4, nA3, nA3, nE4, nE4, nC4, nC4, nE4, nE4
	smpsPSGform			$E7
	dc.b	nA3, $06, nRst, $06, nRst, $18
	smpsNoteFill		$02
	smpsAlterPitch		$F5

Mus91_Credits_Loop0E:
	smpsPSGvoice		fTone_04
	dc.b	nMaxPSG, $03, $03
	smpsPSGAlterVol		$02
	smpsPSGvoice		fTone_08
	smpsNoteFill		$08
	dc.b	$06
	smpsNoteFill		$03
	smpsPSGAlterVol		$FE
	smpsLoop			$00, $1E, Mus91_Credits_Loop0E
	dc.b	nRst, $24

Mus91_Credits_Loop0F:
	smpsPSGform			$E7
	smpsPSGvoice		fTone_04
	dc.b	nMaxPSG, $03, $03
	smpsPSGAlterVol		$02
	smpsPSGvoice		fTone_08
	smpsNoteFill		$08
	dc.b	$06
	smpsNoteFill		$03
	smpsPSGAlterVol		$FE
	smpsLoop			$00, $20, Mus91_Credits_Loop0F
	smpsPSGform			$E7
	dc.b	nRst, $30
	smpsNoteFill		$01
	smpsPSGvoice		fTone_04
	smpsPSGAlterVol		$03

Mus91_Credits_Loop10:
	dc.b	nMaxPSG, $02, nRst, nMaxPSG
	smpsLoop			$00, $08, Mus91_Credits_Loop10

Mus91_Credits_Loop11:
	dc.b	nRst, $04, nMaxPSG, $02
	smpsLoop			$00, $08, Mus91_Credits_Loop11
	smpsPSGAlterVol		$FF

Mus91_Credits_Loop12:
	dc.b	nMaxPSG, $02, nRst, nMaxPSG
	smpsLoop			$00, $18, Mus91_Credits_Loop12
	smpsPSGAlterVol		$FE
	smpsPSGform			$E7

Mus91_Credits_Loop13:
	dc.b	nMaxPSG, $04, nRst, nMaxPSG
	smpsLoop			$00, $08, Mus91_Credits_Loop13

Mus91_Credits_Loop14:
	smpsNoteFill		$03
	dc.b	nMaxPSG, $0C
	smpsNoteFill		$0C
	dc.b	$0C
	smpsNoteFill		$03
	dc.b	$0C
	smpsNoteFill		$0C
	dc.b	$0C
	smpsLoop			$00, $0D, Mus91_Credits_Loop14
	smpsNoteFill		$03
	dc.b	nMaxPSG, $06
	smpsNoteFill		$0E
	dc.b	$12
	smpsNoteFill		$03
	dc.b	$0C
	smpsNoteFill		$0F
	dc.b	$0C
	smpsStop

; DAC Data
Mus91_Credits_DAC:
	dc.b	dSnare, $06, dSnare, dSnare, dSnare, dSnare, $0C, $06, $0C, $06, $0C, $0C, $0C

Mus91_Credits_Loop00:
	dc.b	dKick, $18, dSnare, $0C, dKick, $18, dKick, $0C, dSnare, dKick
	smpsLoop			$00, $03, Mus91_Credits_Loop00
	dc.b	dKick, $18, dSnare, $0C, dSnare, dKick, $18, dSnare, $0C, dSnare

Mus91_Credits_Loop01:
	dc.b	dKick, $18, dSnare, $0C, dKick, $18, dKick, $0C, dSnare, dKick
	smpsLoop			$00, $03, Mus91_Credits_Loop01
	dc.b	dKick, $0C, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare

Mus91_Credits_Loop02:
	dc.b	dKick, $18, dSnare, $0C, dKick, $18, $0C, dSnare, $18
	smpsLoop			$00, $07, Mus91_Credits_Loop02
	dc.b	dKick, $18, dSnare, $0C, dKick, $18, dSnare, $0C, $0C, $0C

Mus91_Credits_Loop03:
	dc.b	dKick, $18, dSnare, $0C, dKick, $18, $0C, dSnare, $18
	smpsLoop			$00, $03, Mus91_Credits_Loop03
	dc.b	dKick, $18, dSnare, $0C, dKick, $18, dSnare, $0C, dSnare, dSnare
	dc.b	$FC, $02

Mus91_Credits_Loop04:
	dc.b	dKick, $12, dKick, $06, dKick, $0C, dSnare
	smpsLoop			$00, $05, Mus91_Credits_Loop04
	dc.b	dKick, $12, dKick, $06, dKick, $06, dSnare, dSnare, dSnare

Mus91_Credits_Loop05:
	dc.b	dKick, $0C, dKick, dKick, dKick
	smpsLoop			$00, $06, Mus91_Credits_Loop05
	dc.b	dKick, $0C, dKick, dKick, dKick, $06, dKick, $02, dKick, dSnare, dSnare, $0C
	dc.b	nRst, $24

Mus91_Credits_Loop06:
	dc.b	dKick, $0C, dKick, dKick, dKick
	smpsLoop			$00, $07, Mus91_Credits_Loop06
	dc.b	dKick, $0C, dKick, dSnare, $03, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare
	dc.b	dKick, $0C, dSnare, $09, dKick, $06, $03, dKick, $01, dHiTimpani, $02, dMidTimpani
	dc.b	$03, dSnare, $01, dHiTimpani, $0B, dKick, $0C, dSnare, $09, dKick, $06, $03
	dc.b	dKick, $01, dHiTimpani, $02, dMidTimpani, $03, dSnare, $01, dHiTimpani, $0B, dKick, $0C
	dc.b	dSnare, $09, dKick, $06, $03, dKick, $01, dHiTimpani, $02, dMidTimpani, $03, dSnare
	dc.b	$01, dHiTimpani, $0B, dKick, $0C, dSnare, $09, dKick, $06, dSnare, $01, dHiTimpani
	dc.b	$02, dKick, $01, dMidTimpani, $05, dSnare, $01, dHiTimpani, $05, dMidTimpani, $06, dKick
	dc.b	$0C, dSnare, $09, dKick, $06, $03, dKick, $01, dHiTimpani, $02, dMidTimpani, $03
	dc.b	dSnare, $01, dHiTimpani, $0B, dKick, $0C, dSnare, $09, dKick, $06, $03, dKick
	dc.b	$01, dHiTimpani, $02, dMidTimpani, $03, dSnare, $01, dHiTimpani, $0B, dKick, $0C, dSnare
	dc.b	$09, dKick, $06, $03, dKick, $01, dHiTimpani, $02, dMidTimpani, $03, dSnare, $01
	dc.b	dHiTimpani, $0B, dKick, $0C, dSnare, $09, dKick, $06, dSnare, $01, dMidTimpani, $02
	dc.b	dSnare, $01, dHiTimpani, $05, dSnare, $01, dMidTimpani, $05, dSnare, $01, dHiTimpani, $02
	dc.b	dSnare, $03, dSnare, $03, dSnare, dKick, dKick, dSnare, dSnare, dKick, dKick, dKick
	dc.b	dSnare, $09, dSnare, $06, $03, $03, dKick, $09, $03, dSnare, $09, dKick
	dc.b	$06, $06, $03, dSnare, $06, $03, $03, dSnare, $06, dSnare, dSnare, dSnare
	dc.b	dSnare, dSnare, dSnare, $04, $02, $04, dKick, $02

Mus91_Credits_Loop07:
	dc.b	nRst, $04, dKick, $08, dSnare, $06, dKick, dKick, $0C, dSnare, $0A, dKick
	dc.b	$02
	smpsLoop			$00, $03, Mus91_Credits_Loop07
	dc.b	$FC, $01
	dc.b	nRst, $18, dSnare, $14, dKick, $04, dSnare, $0C, dSnare, dSnare, $0C
	dc.b	$08, dKick, $04

Mus91_Credits_Loop08:
	dc.b	dKick, $0C, dSnare, dKick, dSnare, dKick, $0C, dSnare, dKick, dSnare, dKick, $0C
	dc.b	dSnare, dKick, dSnare, dKick, $0C, dSnare, dKick, $06, nRst, $02, dSnare, dSnare
	dc.b	dSnare, $09, dSnare, $03
	smpsLoop			$00, $03, Mus91_Credits_Loop08
	dc.b	dKick, $0C, dSnare, dKick, dSnare, dKick, $06, dSnare, $12, dSnare, $0C, dKick
	smpsStop

Mus91_Credits_Call06:
	dc.b	nB4, $0C, nG4, nB4, nD5, nC5, nB4, nA4, nB4, nA4, nFs4, nA4
	dc.b	nC5, nB4, nA4, nG4, nA4, nG4, nE4, nG4, nB4, nA4, nG4, nFs4
	dc.b	nG4, nFs4, nG4, nA4, nFs4, nD4, nE4, nFs4, nD4, nB4, nG4, nB4
	dc.b	nD5, nC5, nB4, nA4, nB4, nA4, nFs4, nA4, nC5, nB4, nA4, nG4
	dc.b	nA4, nG4, nE4, nG4, nB4, nA4, nG4, nFs4, nG4, nFs4, nG4, nA4
	dc.b	nB4, nA4, nB4, nC5, nD5
	smpsReturn

; Unreachable
	dc.b	nRst, $0C, nG6, nB6, nD7, nFs7, $0C, nRst, $06, nFs7, $0C, nG7
	dc.b	$06, nFs7, $0C, nE7, $60, nRst, $0C, nG6, nB6, nD7, nFs7, $0C
	dc.b	nRst, $06, nFs7, $0C, nG7, $06, nFs7, $0C, nAb7, $5D, nRst, $03
	dc.b	nA7, $12, nRst, $06, nA7, $12, nRst, $06, nRst, $06, nAb7, $12
	dc.b	nA7, $06, nRst, $12
	smpsReturn

Mus91_Credits_Call09:
	dc.b	nRst, $30, nC7, $0C, nA6, $18, nC7, $0C, nB6, $18, nC7, $0C
	dc.b	nB6, $18, nG6, $48, nA6, $0C, nE7, nD7, $18, nC7, $0C, nB6
	dc.b	$18, nC7, $0C, nB6, $18, nG6, $54, nC7, $0C, nA6, $18, nC7
	dc.b	$0C, nB6, $18, nC7, $0C, nB6, $18, nG6, $48, nA6, $0C, $0C
	dc.b	nF6, $18, nA6, $0C, nG6, $18, nA6, $0C, nG6, $18, nC6, $24
	smpsReturn

Mus91_Credits_Call07:
	smpsNoteFill		$0E
	dc.b	nA5, $0C
	smpsNoteFill		$03
	dc.b	$06, $06, $06, $06, $06, $06
	smpsReturn

Mus91_Credits_Call03:
	dc.b	nB6, $09, nRst, $03, nB6, $06, nA6, $06, nB6, $09, nRst, $03
	dc.b	nB6, $06, nA6, $06, nB6, $09, nRst, $03, nB6, $06, nA6, $06
	dc.b	nB6, $06, nA6, $06, nE6, $06, nC6, $06, nG6, $0C, nA6, $06
	dc.b	smpsNoAttack, nF6, $06, smpsNoAttack, $18, smpsNoAttack, $2F, nRst, $01, nA6, $24, nB6
	dc.b	$0C, nAb6, $24, nB6, $09, nRst, $03, nB6, $12, nA6, $06, smpsNoAttack
	dc.b	$18
	smpsReturn

Mus91_Credits_Call08:
	dc.b	nRst, $30, $30, $30, nF7, $03, nD7, nA6, nF6, nD7, nA6, nF6
	dc.b	nD6, nA6, nF6, nD6, nA5, nF6, nD6, nA5, nF5, smpsNoAttack, $30, nRst
	dc.b	$30
	smpsReturn

Mus91_Credits_Call04:
	dc.b	nE6, $2A, nE6, $03, nF6, nG6, $09, nA6, nBb6, $06, nA6, $0C
	dc.b	nG6, nF6, $1E, nF6, $06, nE6, nF6, $1E, nD6, $0C, nE6, nF6
	dc.b	$2A, nD6, $03, nE6, nF6, $09, nG6, nAb6, $06, nG6, $0C, nF6
	smpsReturn

Mus91_Credits_Call00:
	dc.b	nE6, $06, nRst, $03, nE6, nRst, $06, nE6, $18, nRst, $06, nD6
	dc.b	$06, nRst, $03, nD6, nRst, $06, nCs6, $18, nRst, $06, nF6, $06
	dc.b	nRst, $03, nE6, $06, nRst, $03, nD6, nRst, nF6, $06, nRst, $03
	dc.b	nE6, $06, nRst, $03, nD6, nRst, nF6, $06, nRst, $03, nE6, $06
	dc.b	nRst, $03, nD6, $18, nRst, $06, nD6, $06, nRst, $03, nD6, nRst
	dc.b	$06, nD6, $18, nRst, $06, nF6, $06, nRst, $03, nF6, nRst, $06
	dc.b	nF6, $18, nRst, $06, nRst, $06
	smpsNoteFill		$08
	dc.b	nG6, $09, $09, $09, $09
	smpsNoteFill		$05
	dc.b	$03, $03
	smpsNoteFill		$00
	dc.b	nRst, $0C, nF6, $24
	smpsReturn

Mus91_Credits_Call02:
	dc.b	nG6, $06, nRst, $03, nG6, nRst, $06, nG6, $18, nRst, $06, nF6
	dc.b	$06, nRst, $03, nF6, nRst, $06, nE6, $18, nRst, $06, nA6, $06
	dc.b	nRst, $03, nG6, $06, nRst, $03, nF6, nRst, nA6, $06, nRst, $03
	dc.b	nG6, $06, nRst, $03, nF6, nRst, nA6, $06, nRst, $03, nG6, $06
	dc.b	nRst, $03, nF6, $18, nRst, $06, nF6, $06, nRst, $03, nF6, nRst
	dc.b	$06, nF6, $18, nRst, $06, nAb6, $06, nRst, $03, nAb6, nRst, $06
	dc.b	nAb6, $18, nRst, $06, nRst, $06
	smpsNoteFill		$08
	dc.b	nB6, $09, $09, $09, $09
	smpsNoteFill		$05
	dc.b	$03, $03
	smpsNoteFill		$00
	dc.b	nRst, $0C, nA6, $24
	smpsReturn

Mus91_Credits_Call05:
	dc.b	nG6, $1E, nE6, $06, nC6, nC7, nBb6, $0C, nC7, $06, nBb6, $0C
	dc.b	nG6, $06, nBb6, nA6, $24, nE6, $06, nF6, nG6, $12, nA6, $06
	dc.b	nG6, $12, nE6, $0C, nG6, $1E, nE6, $06, nC6, nC7, nBb6, $0C
	dc.b	nC7, $06, nBb6, $0C, nG6, $06, nBb6, nA6, $24, nE6, $06, nF6
	dc.b	nG6, $30, nRst, $06
	smpsReturn

Mus91_Credits_Call01:
	dc.b	nRst, $03, nE6, nC6, $06, $06, nG5, nC6, $09, nE6, $09, nRst
	dc.b	$06, nRst, $03, nF6, nCs6, $06, $06, nBb5, nCs6, $09, nF6, $09
	dc.b	nRst, $06, nRst, $03, nE6, nC6, $06, $06, nA5, nC6, $09, nE6
	dc.b	$0F, nD6, $0C
	smpsReturn

Mus91_Credits_Voices:
;	Voice $00
;	$20
;	$36, $35, $30, $31, 	$DF, $DF, $9F, $9F, 	$07, $06, $09, $06
;	$07, $06, $06, $08, 	$20, $10, $10, $F8, 	$19, $37, $13, $80
	smpsVcAlgorithm		$00
	smpsVcFeedback		$04
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $03, $03, $03
	smpsVcCoarseFreq	$01, $00, $05, $06
	smpsVcRateScale		$02, $02, $03, $03
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$06, $09, $06, $07
	smpsVcDecayRate2	$08, $06, $06, $07
	smpsVcDecayLevel	$0F, $01, $01, $02
	smpsVcReleaseRate	$08, $00, $00, $00
	smpsVcTotalLevel	$00, $13, $37, $19

;	Voice $01
;	$2C
;	$72, $78, $34, $34, 	$1F, $12, $1F, $12, 	$00, $0A, $00, $0A
;	$00, $00, $00, $00, 	$0F, $1F, $0F, $1F, 	$16, $80, $17, $80
	smpsVcAlgorithm		$04
	smpsVcFeedback		$05
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $03, $07, $07
	smpsVcCoarseFreq	$04, $04, $08, $02
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$12, $1F, $12, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$0A, $00, $0A, $00
	smpsVcDecayRate2	$00, $00, $00, $00
	smpsVcDecayLevel	$01, $00, $01, $00
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $17, $00, $16

;	Voice $02
;	$2C
;	$74, $74, $34, $34, 	$1F, $12, $1F, $1F, 	$00, $00, $00, $00
;	$00, $01, $00, $01, 	$0F, $3F, $0F, $3F, 	$16, $80, $17, $80
	smpsVcAlgorithm		$04
	smpsVcFeedback		$05
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $03, $07, $07
	smpsVcCoarseFreq	$04, $04, $04, $04
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$1F, $1F, $12, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$00, $00, $00, $00
	smpsVcDecayRate2	$01, $00, $01, $00
	smpsVcDecayLevel	$03, $00, $03, $00
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $17, $00, $16

;	Voice $03
;	$04
;	$72, $42, $32, $32, 	$12, $12, $12, $12, 	$00, $08, $00, $08
;	$00, $08, $00, $08, 	$0F, $1F, $0F, $1F, 	$23, $80, $23, $80
	smpsVcAlgorithm		$04
	smpsVcFeedback		$00
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $03, $04, $07
	smpsVcCoarseFreq	$02, $02, $02, $02
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$12, $12, $12, $12
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$08, $00, $08, $00
	smpsVcDecayRate2	$08, $00, $08, $00
	smpsVcDecayLevel	$01, $00, $01, $00
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $23, $00, $23

;	Voice $04
;	$2C
;	$74, $74, $34, $34, 	$1F, $12, $1F, $1F, 	$00, $07, $00, $07
;	$00, $07, $00, $07, 	$00, $38, $00, $38, 	$16, $80, $17, $80
	smpsVcAlgorithm		$04
	smpsVcFeedback		$05
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $03, $07, $07
	smpsVcCoarseFreq	$04, $04, $04, $04
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$1F, $1F, $12, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$07, $00, $07, $00
	smpsVcDecayRate2	$07, $00, $07, $00
	smpsVcDecayLevel	$03, $00, $03, $00
	smpsVcReleaseRate	$08, $00, $08, $00
	smpsVcTotalLevel	$00, $17, $00, $16

;	Voice $05
;	$31
;	$34, $35, $30, $31, 	$DF, $DF, $9F, $9F, 	$0C, $07, $0C, $09
;	$07, $07, $07, $08, 	$2F, $1F, $1F, $2F, 	$17, $32, $14, $80
	smpsVcAlgorithm		$01
	smpsVcFeedback		$06
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $03, $03, $03
	smpsVcCoarseFreq	$01, $00, $05, $04
	smpsVcRateScale		$02, $02, $03, $03
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$09, $0C, $07, $0C
	smpsVcDecayRate2	$08, $07, $07, $07
	smpsVcDecayLevel	$02, $01, $01, $02
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $14, $32, $17

;	Voice $06
;	$18
;	$37, $30, $30, $31, 	$9E, $DC, $1C, $9C, 	$0D, $06, $04, $01
;	$08, $0A, $03, $05, 	$BF, $BF, $3F, $2F, 	$2C, $22, $14, $80
	smpsVcAlgorithm		$00
	smpsVcFeedback		$03
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $03, $03, $03
	smpsVcCoarseFreq	$01, $00, $00, $07
	smpsVcRateScale		$02, $00, $03, $02
	smpsVcAttackRate	$1C, $1C, $1C, $1E
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$01, $04, $06, $0D
	smpsVcDecayRate2	$05, $03, $0A, $08
	smpsVcDecayLevel	$02, $03, $0B, $0B
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $14, $22, $2C

;	Voice $07
;	$3C
;	$31, $52, $50, $30, 	$52, $53, $52, $53, 	$08, $00, $08, $00
;	$04, $00, $04, $00, 	$1F, $0F, $1F, $0F, 	$1A, $80, $16, $80
	smpsVcAlgorithm		$04
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $05, $05, $03
	smpsVcCoarseFreq	$00, $00, $02, $01
	smpsVcRateScale		$01, $01, $01, $01
	smpsVcAttackRate	$13, $12, $13, $12
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$00, $08, $00, $08
	smpsVcDecayRate2	$00, $04, $00, $04
	smpsVcDecayLevel	$00, $01, $00, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $16, $00, $1A

;	Voice $08
;	$22
;	$0A, $13, $05, $11, 	$03, $12, $12, $11, 	$00, $13, $13, $00
;	$03, $02, $02, $01, 	$1F, $1F, $0F, $0F, 	$1E, $18, $26, $81
	smpsVcAlgorithm		$02
	smpsVcFeedback		$04
	smpsVcUnusedBits	$00
	smpsVcDetune		$01, $00, $01, $00
	smpsVcCoarseFreq	$01, $05, $03, $0A
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$11, $12, $12, $03
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$00, $13, $13, $00
	smpsVcDecayRate2	$01, $02, $02, $03
	smpsVcDecayLevel	$00, $00, $01, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$01, $26, $18, $1E

;	Voice $09
;	$3A
;	$61, $3C, $14, $31, 	$9C, $DB, $9C, $DA, 	$04, $09, $04, $03
;	$03, $01, $03, $00, 	$1F, $0F, $0F, $AF, 	$21, $47, $31, $80
	smpsVcAlgorithm		$02
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $01, $03, $06
	smpsVcCoarseFreq	$01, $04, $0C, $01
	smpsVcRateScale		$03, $02, $03, $02
	smpsVcAttackRate	$1A, $1C, $1B, $1C
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$03, $04, $09, $04
	smpsVcDecayRate2	$00, $03, $01, $03
	smpsVcDecayLevel	$0A, $00, $00, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $31, $47, $21

;	Voice $0A
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $80
	smpsVcAlgorithm		$02
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$01, $01, $07, $01
	smpsVcRateScale		$01, $02, $02, $02
	smpsVcAttackRate	$13, $0D, $0E, $0E
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$03, $0E, $0E, $0E
	smpsVcDecayRate2	$00, $00, $00, $00
	smpsVcDecayLevel	$00, $01, $0F, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $27, $28, $18

;	Voice $0B
;	$34
;	$33, $41, $7E, $74, 	$5B, $9F, $5F, $1F, 	$04, $07, $07, $08
;	$00, $00, $00, $00, 	$FF, $FF, $EF, $FF, 	$23, $90, $29, $97
	smpsVcAlgorithm		$04
	smpsVcFeedback		$06
	smpsVcUnusedBits	$00
	smpsVcDetune		$07, $07, $04, $03
	smpsVcCoarseFreq	$04, $0E, $01, $03
	smpsVcRateScale		$00, $01, $02, $01
	smpsVcAttackRate	$1F, $1F, $1F, $1B
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$08, $07, $07, $04
	smpsVcDecayRate2	$00, $00, $00, $00
	smpsVcDecayLevel	$0F, $0E, $0F, $0F
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$17, $29, $10, $23

;	Voice $0C
;	$04
;	$72, $42, $32, $32, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$00, $07, $00, $07, 	$23, $80, $23, $80
	smpsVcAlgorithm		$04
	smpsVcFeedback		$00
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $03, $04, $07
	smpsVcCoarseFreq	$02, $02, $02, $02
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$00, $00, $00, $00
	smpsVcDecayRate2	$00, $00, $00, $00
	smpsVcDecayLevel	$00, $00, $00, $00
	smpsVcReleaseRate	$07, $00, $07, $00
	smpsVcTotalLevel	$00, $23, $00, $23

;	Voice $0D
;	$3C
;	$38, $74, $76, $33, 	$10, $10, $10, $10, 	$02, $07, $04, $07
;	$03, $09, $03, $09, 	$2F, $2F, $2F, $2F, 	$1E, $80, $1E, $80
	smpsVcAlgorithm		$04
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $07, $07, $03
	smpsVcCoarseFreq	$03, $06, $04, $08
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$10, $10, $10, $10
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$07, $04, $07, $02
	smpsVcDecayRate2	$09, $03, $09, $03
	smpsVcDecayLevel	$02, $02, $02, $02
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $1E, $00, $1E

;	Voice $0E
;	$F4
;	$06, $04, $0F, $0E, 	$1F, $1F, $1F, $1F, 	$00, $00, $0B, $0B
;	$00, $00, $05, $08, 	$0F, $0F, $FF, $FF, 	$15, $85, $02, $8A
	smpsVcAlgorithm		$04
	smpsVcFeedback		$06
	smpsVcUnusedBits	$03
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$0E, $0F, $04, $06
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$0B, $0B, $00, $00
	smpsVcDecayRate2	$08, $05, $00, $00
	smpsVcDecayLevel	$0F, $0F, $00, $00
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$0A, $02, $05, $15

;	Voice $0F
;	$29
;	$36, $74, $71, $31, 	$04, $04, $05, $1D, 	$12, $0E, $1F, $1F
;	$04, $06, $03, $01, 	$5F, $6F, $0F, $0F, 	$27, $27, $2E, $80
	smpsVcAlgorithm		$01
	smpsVcFeedback		$05
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $07, $07, $03
	smpsVcCoarseFreq	$01, $01, $04, $06
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$1D, $05, $04, $04
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$1F, $1F, $0E, $12
	smpsVcDecayRate2	$01, $03, $06, $04
	smpsVcDecayLevel	$00, $00, $06, $05
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $2E, $27, $27

;	Voice $10
;	$08
;	$0A, $70, $30, $00, 	$1F, $1F, $5F, $5F, 	$12, $0E, $0A, $0A
;	$00, $04, $04, $03, 	$2F, $2F, $2F, $2F, 	$24, $2D, $13, $80
	smpsVcAlgorithm		$00
	smpsVcFeedback		$01
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $03, $07, $00
	smpsVcCoarseFreq	$00, $00, $00, $0A
	smpsVcRateScale		$01, $01, $00, $00
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$0A, $0A, $0E, $12
	smpsVcDecayRate2	$03, $04, $04, $00
	smpsVcDecayLevel	$02, $02, $02, $02
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $13, $2D, $24

;	Voice $11
;	$3D
;	$01, $01, $01, $01, 	$8E, $52, $14, $4C, 	$08, $08, $0E, $03
;	$00, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$1B, $80, $80, $9B
	smpsVcAlgorithm		$05
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$01, $01, $01, $01
	smpsVcRateScale		$01, $00, $01, $02
	smpsVcAttackRate	$0C, $14, $12, $0E
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$03, $0E, $08, $08
	smpsVcDecayRate2	$00, $00, $00, $00
	smpsVcDecayLevel	$01, $01, $01, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$1B, $00, $00, $1B

;	Voice $12
;	$3D
;	$01, $02, $00, $01, 	$1F, $0E, $0E, $0E, 	$07, $1F, $1F, $1F
;	$00, $00, $00, $00, 	$1F, $0F, $0F, $0F, 	$17, $8D, $8C, $8C
	smpsVcAlgorithm		$05
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$01, $00, $02, $01
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$0E, $0E, $0E, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$1F, $1F, $1F, $07
	smpsVcDecayRate2	$00, $00, $00, $00
	smpsVcDecayLevel	$00, $00, $00, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$0C, $0C, $0D, $17

;	Voice $13
;	$3C
;	$31, $52, $50, $30, 	$52, $53, $52, $53, 	$08, $00, $08, $00
;	$04, $00, $04, $00, 	$10, $07, $10, $07, 	$1A, $80, $16, $80
	smpsVcAlgorithm		$04
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $05, $05, $03
	smpsVcCoarseFreq	$00, $00, $02, $01
	smpsVcRateScale		$01, $01, $01, $01
	smpsVcAttackRate	$13, $12, $13, $12
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$00, $08, $00, $08
	smpsVcDecayRate2	$00, $04, $00, $04
	smpsVcDecayLevel	$00, $01, $00, $01
	smpsVcReleaseRate	$07, $00, $07, $00
	smpsVcTotalLevel	$00, $16, $00, $1A

;	Voice $14
;	$18
;	$37, $30, $30, $31, 	$9E, $DC, $1C, $9C, 	$0D, $06, $04, $01
;	$08, $0A, $03, $05, 	$BF, $BF, $3F, $2F, 	$32, $22, $14, $80
	smpsVcAlgorithm		$00
	smpsVcFeedback		$03
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $03, $03, $03
	smpsVcCoarseFreq	$01, $00, $00, $07
	smpsVcRateScale		$02, $00, $03, $02
	smpsVcAttackRate	$1C, $1C, $1C, $1E
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$01, $04, $06, $0D
	smpsVcDecayRate2	$05, $03, $0A, $08
	smpsVcDecayLevel	$02, $03, $0B, $0B
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $14, $22, $32

;	Voice $15
;	$3A
;	$01, $01, $01, $02, 	$8D, $07, $07, $52, 	$09, $00, $00, $03
;	$01, $02, $02, $00, 	$5F, $0F, $0F, $2F, 	$18, $22, $18, $80
	smpsVcAlgorithm		$02
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$02, $01, $01, $01
	smpsVcRateScale		$01, $00, $00, $02
	smpsVcAttackRate	$12, $07, $07, $0D
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$03, $00, $00, $09
	smpsVcDecayRate2	$00, $02, $02, $01
	smpsVcDecayLevel	$02, $00, $00, $05
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $18, $22, $18

;	Voice $16
;	$2C
;	$74, $74, $34, $34, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $01, $00, $01, 	$0F, $3F, $0F, $3F, 	$16, $80, $17, $80
	smpsVcAlgorithm		$04
	smpsVcFeedback		$05
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $03, $07, $07
	smpsVcCoarseFreq	$04, $04, $04, $04
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$00, $00, $00, $00
	smpsVcDecayRate2	$01, $00, $01, $00
	smpsVcDecayLevel	$03, $00, $03, $00
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $17, $00, $16

;	Voice $17
;	$04
;	$37, $72, $77, $49, 	$1F, $1F, $1F, $1F, 	$07, $0A, $07, $0D
;	$00, $00, $00, $00, 	$10, $07, $10, $07, 	$23, $80, $23, $80
	smpsVcAlgorithm		$04
	smpsVcFeedback		$00
	smpsVcUnusedBits	$00
	smpsVcDetune		$04, $07, $07, $03
	smpsVcCoarseFreq	$09, $07, $02, $07
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$0D, $07, $0A, $07
	smpsVcDecayRate2	$00, $00, $00, $00
	smpsVcDecayLevel	$00, $01, $00, $01
	smpsVcReleaseRate	$07, $00, $07, $00
	smpsVcTotalLevel	$00, $23, $00, $23

;	Voice $18
;	$3D
;	$01, $02, $02, $02, 	$14, $0E, $8C, $0E, 	$08, $05, $02, $05
;	$00, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$1A, $80, $80, $80
	smpsVcAlgorithm		$05
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$02, $02, $02, $01
	smpsVcRateScale		$00, $02, $00, $00
	smpsVcAttackRate	$0E, $0C, $0E, $14
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$05, $02, $05, $08
	smpsVcDecayRate2	$00, $00, $00, $00
	smpsVcDecayLevel	$01, $01, $01, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $00, $00, $1A

;	Voice $19
;	$20
;	$36, $35, $30, $31, 	$DF, $DF, $9F, $9F, 	$07, $06, $09, $06
;	$07, $06, $06, $08, 	$2F, $1F, $1F, $FF, 	$19, $37, $13, $80
	smpsVcAlgorithm		$00
	smpsVcFeedback		$04
	smpsVcUnusedBits	$00
	smpsVcDetune		$03, $03, $03, $03
	smpsVcCoarseFreq	$01, $00, $05, $06
	smpsVcRateScale		$02, $02, $03, $03
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$06, $09, $06, $07
	smpsVcDecayRate2	$08, $06, $06, $07
	smpsVcDecayLevel	$0F, $01, $01, $02
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $13, $37, $19

;	Voice $1A
;	$3A
;	$51, $08, $51, $02, 	$1E, $1E, $1E, $10, 	$1F, $1F, $1F, $0F
;	$00, $00, $00, $02, 	$0F, $0F, $0F, $1F, 	$18, $24, $22, $81
	smpsVcAlgorithm		$02
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $05, $00, $05
	smpsVcCoarseFreq	$02, $01, $08, $01
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$10, $1E, $1E, $1E
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$0F, $1F, $1F, $1F
	smpsVcDecayRate2	$02, $00, $00, $00
	smpsVcDecayLevel	$01, $00, $00, $00
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$01, $22, $24, $18

;	Voice $1B
;	$3A
;	$32, $56, $32, $42, 	$8D, $4F, $15, $52, 	$06, $08, $07, $04
;	$02, $00, $00, $00, 	$1F, $1F, $2F, $2F, 	$19, $20, $2A, $80
	smpsVcAlgorithm		$02
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$04, $03, $05, $03
	smpsVcCoarseFreq	$02, $02, $06, $02
	smpsVcRateScale		$01, $00, $01, $02
	smpsVcAttackRate	$12, $15, $0F, $0D
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$04, $07, $08, $06
	smpsVcDecayRate2	$00, $00, $00, $02
	smpsVcDecayLevel	$02, $02, $01, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $2A, $20, $19

;	Voice $1C
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $80
	smpsVcAlgorithm		$02
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$01, $01, $07, $01
	smpsVcRateScale		$01, $02, $02, $02
	smpsVcAttackRate	$13, $0D, $0E, $0E
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$03, $0E, $0E, $0E
	smpsVcDecayRate2	$00, $00, $00, $00
	smpsVcDecayLevel	$00, $01, $0F, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $27, $28, $18

;	Voice $1D
;	$08
;	$0A, $70, $30, $00, 	$1F, $1F, $5F, $5F, 	$12, $0E, $0A, $0A
;	$00, $04, $04, $03, 	$2F, $2F, $2F, $2F, 	$24, $2D, $13, $80
	smpsVcAlgorithm		$00
	smpsVcFeedback		$01
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $03, $07, $00
	smpsVcCoarseFreq	$00, $00, $00, $0A
	smpsVcRateScale		$01, $01, $00, $00
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$0A, $0A, $0E, $12
	smpsVcDecayRate2	$03, $04, $04, $00
	smpsVcDecayLevel	$02, $02, $02, $02
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $13, $2D, $24

;	Voice $1E
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $07, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $80
	smpsVcAlgorithm		$02
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$01, $01, $07, $01
	smpsVcRateScale		$01, $02, $02, $02
	smpsVcAttackRate	$13, $0D, $0E, $0E
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$03, $0E, $0E, $0E
	smpsVcDecayRate2	$07, $00, $00, $00
	smpsVcDecayLevel	$00, $01, $0F, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $27, $28, $18

;	Voice $1F
;	$36
;	$0F, $01, $01, $01, 	$1F, $1F, $1F, $1F, 	$12, $11, $0E, $00
;	$00, $0A, $07, $09, 	$FF, $0F, $1F, $0F, 	$18, $80, $80, $80
	smpsVcAlgorithm		$06
	smpsVcFeedback		$06
	smpsVcUnusedBits	$00
	smpsVcDetune		$00, $00, $00, $00
	smpsVcCoarseFreq	$01, $01, $01, $0F
	smpsVcRateScale		$00, $00, $00, $00
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$00, $0E, $11, $12
	smpsVcDecayRate2	$09, $07, $0A, $00
	smpsVcDecayLevel	$00, $01, $00, $0F
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $00, $00, $18

;	Voice $20
;	$3A
;	$03, $19, $01, $53, 	$1F, $DF, $1F, $9F, 	$0C, $02, $0C, $05
;	$04, $04, $04, $07, 	$1F, $FF, $0F, $2F, 	$1D, $36, $1B, $80
	smpsVcAlgorithm		$02
	smpsVcFeedback		$07
	smpsVcUnusedBits	$00
	smpsVcDetune		$05, $00, $01, $00
	smpsVcCoarseFreq	$03, $01, $09, $03
	smpsVcRateScale		$02, $00, $03, $00
	smpsVcAttackRate	$1F, $1F, $1F, $1F
	smpsVcAmpMod		$00, $00, $00, $00
	smpsVcDecayRate1	$05, $0C, $02, $0C
	smpsVcDecayRate2	$07, $04, $04, $04
	smpsVcDecayLevel	$02, $00, $0F, $01
	smpsVcReleaseRate	$0F, $0F, $0F, $0F
	smpsVcTotalLevel	$00, $1B, $36, $1D