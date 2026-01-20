Ani_Sonic_internal:

ptr_Walk:	dc.w SonAni_Walk-Ani_Sonic_internal
ptr_Run:	dc.w SonAni_Run-Ani_Sonic_internal
ptr_Roll:	dc.w SonAni_Roll-Ani_Sonic_internal
ptr_Roll2:	dc.w SonAni_Roll2-Ani_Sonic_internal
ptr_Push:	dc.w SonAni_Push-Ani_Sonic_internal
ptr_Wait:	dc.w byte_F674-Ani_Sonic_internal
ptr_Balance:	dc.w byte_F68A-Ani_Sonic_internal
ptr_LookUp:	dc.w byte_F68E-Ani_Sonic_internal
ptr_Duck:	dc.w byte_F692-Ani_Sonic_internal
ptr_Warp1:	dc.w byte_F696-Ani_Sonic_internal
ptr_Warp2:	dc.w byte_F69A-Ani_Sonic_internal
ptr_Warp3:	dc.w byte_F69E-Ani_Sonic_internal
ptr_Warp4:	dc.w byte_F6A2-Ani_Sonic_internal
ptr_Stop:	dc.w byte_F6A6-Ani_Sonic_internal
ptr_Float1:	dc.w byte_F6AA-Ani_Sonic_internal
ptr_Float2:	dc.w byte_F6AE-Ani_Sonic_internal
ptr_Spring:	dc.w byte_F6B6-Ani_Sonic_internal
ptr_Hang:	dc.w byte_F6BA-Ani_Sonic_internal
ptr_Leap1:	dc.w byte_F6BE-Ani_Sonic_internal
ptr_Leap2:	dc.w byte_F6C4-Ani_Sonic_internal
ptr_Surf:	dc.w byte_F6CA-Ani_Sonic_internal
ptr_GetAir:	dc.w byte_F6CE-Ani_Sonic_internal
ptr_Burnt:	dc.w byte_F6D2-Ani_Sonic_internal
ptr_Drown:	dc.w byte_F6D6-Ani_Sonic_internal
ptr_Death:	dc.w byte_F6DA-Ani_Sonic_internal
ptr_Shrink:	dc.w byte_F6DE-Ani_Sonic_internal
ptr_Hurt:	dc.w byte_F6E8-Ani_Sonic_internal

SonAni_Walk:	dc.b $FF, 8, 9, $A, $B, 6, 7, afEnd
		even
SonAni_Run:	dc.b $FF, $1E, $1F, $20, $21, afEnd, afEnd, afEnd
		even
SonAni_Roll:	dc.b $FE, $2E, $2F, $30, $31, $32, afEnd, afEnd
		even
SonAni_Roll2:	dc.b $FE, $2E, $2F, $32, $30, $31, $32, afEnd
		even
SonAni_Push:	dc.b $FD, $45, $46, $47, $48, afEnd, afEnd, afEnd
		even
byte_F674:	dc.b $17, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 2
		dc.b 2, 3, 4, afBack, 2
		even
byte_F68A:	dc.b $1F, $3A, $3B, afEnd
		even
byte_F68E:	dc.b $3F, 5, afEnd
		even
byte_F692:	dc.b $3F, $39, afEnd
		even
byte_F696:	dc.b $3F, $33, afEnd
		even
byte_F69A:	dc.b $3F, $34, afEnd
		even
byte_F69E:	dc.b $3F, $35, afEnd
		even
byte_F6A2:	dc.b $3F, $36, afEnd
		even
byte_F6A6:	dc.b 7, $37, $38, afEnd
		even
byte_F6AA:	dc.b 7, $3C, $3F, afEnd
		even
byte_F6AE:	dc.b 7, $3C, $3D, $53, $3E, $54, afEnd
		even
byte_F6B6:	dc.b $2F, $40, afChange
		even
byte_F6BA:	dc.b 4, $41, $42, afEnd
		even
byte_F6BE:	dc.b $F, $43, $43, $43, afBack, 1
		even
byte_F6C4:	dc.b $F, $43, $44, afBack, 1
		even
byte_F6CA:	dc.b $3F, $49, afEnd
		even
byte_F6CE:	dc.b $3F, $4A, afEnd
		even
byte_F6D2:	dc.b 3, $4B, afEnd
		even
byte_F6D6:	dc.b 3, $4C, afEnd
		even
byte_F6DA:	dc.b 3, $4D, afEnd
		even
byte_F6DE:	dc.b 3, $4E, $4F, $50, $51, $52, 0, afBack, 1
		even
byte_F6E8:	dc.b 3, $55, afEnd
		even

id_Walk:	equ (ptr_Walk-Ani_Sonic_internal)/2	; 0
id_Run:		equ (ptr_Run-Ani_Sonic_internal)/2	; 1
id_Roll:	equ (ptr_Roll-Ani_Sonic_internal)/2	; 2
id_Roll2:	equ (ptr_Roll2-Ani_Sonic_internal)/2	; 3
id_Push:	equ (ptr_Push-Ani_Sonic_internal)/2	; 4
id_Wait:	equ (ptr_Wait-Ani_Sonic_internal)/2	; 5
id_Balance:	equ (ptr_Balance-Ani_Sonic_internal)/2	; 6
id_LookUp:	equ (ptr_LookUp-Ani_Sonic_internal)/2	; 7
id_Duck:	equ (ptr_Duck-Ani_Sonic_internal)/2	; 8
id_Warp1:	equ (ptr_Warp1-Ani_Sonic_internal)/2	; 9
id_Warp2:	equ (ptr_Warp2-Ani_Sonic_internal)/2	; $A
id_Warp3:	equ (ptr_Warp3-Ani_Sonic_internal)/2	; $B
id_Warp4:	equ (ptr_Warp4-Ani_Sonic_internal)/2	; $C
id_Stop:	equ (ptr_Stop-Ani_Sonic_internal)/2	; $D
id_Float1:	equ (ptr_Float1-Ani_Sonic_internal)/2	; $E
id_Float2:	equ (ptr_Float2-Ani_Sonic_internal)/2	; $F
id_Spring:	equ (ptr_Spring-Ani_Sonic_internal)/2	; $10
id_Hang:	equ (ptr_Hang-Ani_Sonic_internal)/2	; $11
id_Leap1:	equ (ptr_Leap1-Ani_Sonic_internal)/2	; $12
id_Leap2:	equ (ptr_Leap2-Ani_Sonic_internal)/2	; $13
id_Surf:	equ (ptr_Surf-Ani_Sonic_internal)/2	; $14
id_GetAir:	equ (ptr_GetAir-Ani_Sonic_internal)/2	; $15
id_Burnt:	equ (ptr_Burnt-Ani_Sonic_internal)/2	; $16
id_Drown:	equ (ptr_Drown-Ani_Sonic_internal)/2	; $17
id_Death:	equ (ptr_Death-Ani_Sonic_internal)/2	; $18
id_Shrink:	equ (ptr_Shrink-Ani_Sonic_internal)/2	; $19
id_Hurt:	equ (ptr_Hurt-Ani_Sonic_internal)/2	; $1A