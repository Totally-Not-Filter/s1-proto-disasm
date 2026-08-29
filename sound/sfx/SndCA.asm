SndCA_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndCA_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, SndCA_PSG3,	$00, $00

; PSG3 Data
SndCA_PSG3:
	smpsPSGform         $E7
	smpsPSGvoice        fTone_02

SndCA_Loop00:
	dc.b	nEb5, $0A, nRst, $06
	smpsPSGAlterVol     $02
	smpsLoop            $00, $06, SndCA_Loop00
	smpsStop

; Sound seems to not use any FM voices
SndCA_Voices: