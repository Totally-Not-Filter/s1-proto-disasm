SndA8_EnterGiantRing_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndA8_EnterGiantRing_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, SndA8_EnterGiantRing_PSG3,	$00, $01

; PSG3 Data
SndA8_EnterGiantRing_PSG3:
	smpsPSGvoice        $00
	smpsModSet          $01, $02, $02, $FF
	smpsPSGform         $E7
	dc.b	nMaxPSG, $7F

SndA8_EnterGiantRing_Loop00:
	smpsPSGAlterVol     $01
	dc.b	smpsNoAttack, nA1, $0F
	smpsLoop            $00, $08, SndA8_EnterGiantRing_Loop00
	smpsStop

; Sound seems to not use any FM voices
SndA8_EnterGiantRing_Voices: