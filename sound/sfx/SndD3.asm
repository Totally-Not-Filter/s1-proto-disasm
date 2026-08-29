SndD3_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndD3_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, SndD3_PSG3,	$00, $01

; PSG3 Data
SndD3_PSG3:
	smpsPSGform         $E7
	smpsModSet          $01, $01, $03, $08

SndD3_Loop00:
	dc.b	nD3, $01
	smpsAlterPitch      $01
	smpsLoop            $00, $1A, SndD3_Loop00

SndD3_Jump00:
	dc.b	$14
	smpsJump            SndD3_Jump00

; Unreachable
	smpsStop

; Sound seems to not use any FM voices
SndD3_Voices: