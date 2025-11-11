; +-----------------------------------------------------+
; | Sonic the Hedgehog (Prototype)						|
; | Split/Text Disassembly.								|
; | Originally done by Mega Drive Developers Collective.|
; +-----------------------------------------------------+

; Processor: Motorola 68000 (M68K)
; Sound Processor: Zilog Z80 (Z80)
; Intended for tab width of 8

; ---------------------------------------------------------------------------

	cpu 68000

FixBugs	= 0
;	| If 1, fixes a handful of bugs in the game
zeroOffsetOptimization = 0
;	| If 1, makes a handful of zero-offset instructions smaller

		include "MacroSetup.asm"
		include "Constants.asm"
		include "Variables.asm"
		include "Macros.asm"
; ---------------------------------------------------------------------------

StartOfROM:
Vectors:
		dc.l v_systemstack&$FFFFFF	; Initial stack pointer value
		dc.l EntryPoint			; Start of program
		dc.l BusError			; Bus error
		dc.l AddressError		; Address error (4)
		dc.l IllegalInstr		; Illegal instruction
		dc.l ZeroDivide			; Division by zero
		dc.l ChkInstr			; CHK exception
		dc.l TrapvInstr			; TRAPV exception (8)
		dc.l PrivilegeViol		; Privilege violation
		dc.l Trace				; TRACE exception
		dc.l Line1010Emu		; Line-A emulator
		dc.l Line1111Emu		; Line-F emulator (12)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (16)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (20)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (24)
		dc.l ErrorExcept		; Spurious exception
		dc.l ErrorTrap			; IRQ level 1
		dc.l ErrorTrap			; IRQ level 2
		dc.l ErrorTrap			; IRQ level 3 (28)
		dc.l H_Int				; IRQ level 4 (horizontal retrace interrupt)
		dc.l ErrorTrap			; IRQ level 5
		dc.l V_Int				; IRQ level 6 (vertical retrace interrupt)
		dc.l ErrorTrap			; IRQ level 7 (32)
		dc.l ErrorTrap			; TRAP #00 exception
		dc.l ErrorTrap			; TRAP #01 exception
		dc.l ErrorTrap			; TRAP #02 exception
		dc.l ErrorTrap			; TRAP #03 exception (36)
		dc.l ErrorTrap			; TRAP #04 exception
		dc.l ErrorTrap			; TRAP #05 exception
		dc.l ErrorTrap			; TRAP #06 exception
		dc.l ErrorTrap			; TRAP #07 exception (40)
		dc.l ErrorTrap			; TRAP #08 exception
		dc.l ErrorTrap			; TRAP #09 exception
		dc.l ErrorTrap			; TRAP #10 exception
		dc.l ErrorTrap			; TRAP #11 exception (44)
		dc.l ErrorTrap			; TRAP #12 exception
		dc.l ErrorTrap			; TRAP #13 exception
		dc.l ErrorTrap			; TRAP #14 exception
		dc.l ErrorTrap			; TRAP #15 exception (48)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.b "SEGA MEGA DRIVE "			; Hardware system ID (Console name)
		dc.b "(C)SEGA 1989.JAN"			; Copyright holder and release date (generally year)
		dc.b "                                                " ; Domestic name (blank)
		dc.b "                                                " ; International name (blank)
		dc.b "GM 00000000-00"			; Serial\version number
Checksum:	dc.w 0					; Checksum
		dc.b "J               "			; I\O support
RomStartLoc:	dc.l StartOfROM				; Start address of ROM
RomEndLoc:		dc.l EndOfROM-1				; End address of ROM
RamStartLoc:	dc.l v_start&$FFFFFF			; Start address of RAM
RamEndLoc:		dc.l (v_end-1)&$FFFFFF			; End address of RAM
		dc.l $20202020				; SRAM (none)
		dc.l $20202020				; SRAM start ($200001)
		dc.l $20202020				; SRAM end ($20xxxx)
Notes:	dc.b "                                                    " ; Notes (unused, anything can be put in this space, but it has to be 52 bytes.)
		dc.b "JU              "			; Region (Country code)
EndOfHeader:

; ===========================================================================
; Crash/Freeze the 68000.

ErrorTrap:
		nop
		nop
		bra.s	ErrorTrap
; ===========================================================================

; This contains an earlier version of ICD_BLK4.PRG
EntryPoint:
		tst.l	(z80_port_1_control).l
loc_20C:
		bne.w	loc_306
		tst.w	(z80_expansion_control).l
		bne.s	loc_20C
		lea	SetupValues(pc),a5
		movem.l	(a5)+,d5-a4
		move.w	z80_version-1-z80_bus_request(a1),d0
		andi.w	#$F00,d0
		beq.s	loc_232
		move.l	#"SEGA",security_addr-z80_bus_request(a1)

loc_232:
		move.w	(a4),d0
		moveq	#0,d0
		movea.l	d0,a6
		move.l	a6,usp
		moveq	#VDPInitValues_End-VDPInitValues-1,d1

loc_23C:
		move.b	(a5)+,d5
		move.w	d5,(a4)
		add.w	d7,d5
		dbf	d1,loc_23C
		move.l	#$40000080,(a4)
		move.w	d0,(a3)
		move.w	d7,(a1)
		move.w	d7,(a2)

loc_252:
		btst	d0,(a1)
		bne.s	loc_252
		moveq	#Z80StartupCodeEnd-Z80StartupCodeBegin-1,d2

loc_258:
		move.b	(a5)+,(a0)+
		dbf	d2,loc_258
		move.w	d0,(a2)
		move.w	d0,(a1)
		move.w	d7,(a2)

loc_264:
		move.l	d0,-(a6)
		dbf	d6,loc_264
		move.l	#($8100+%0100)<<16|$8F00+%0010,(a4)
		move.l	#$C0000000,(a4)
		moveq	#bytesToLcnt(v_palette_end-v_palette),d3

loc_278:
		move.l	d0,(a3)
		dbf	d3,loc_278
		move.l	#$40000010,(a4)
		moveq	#bytesToLcnt($50),d4

loc_286:
		move.l	d0,(a3)
		dbf	d4,loc_286
		moveq	#PSGInitValues_End-PSGInitValues-1,d5

loc_28E:
		move.b	(a5)+,psg_input-vdp_data_port-1(a3)
		dbf	d5,loc_28E
		move.w	d0,(a2)
		movem.l	(a6),d0-a6
		disable_ints
		bra.s	loc_306
; ---------------------------------------------------------------------------
SetupValues:	dc.l $8000			; VDP register start number
		dc.l bytesToLcnt(v_end-v_start)		; size of RAM divided by 4
		dc.l $100					; VDP register diff

		dc.l z80_ram				; start of Z80 RAM
		dc.l z80_bus_request		; Z80 bus request
		dc.l z80_reset				; Z80 reset
		dc.l vdp_data_port			; VDP data
		dc.l vdp_control_port		; VDP control

VDPInitValues:
		dc.b 4			; VDP $80 - 8-colour mode
		dc.b $14		; VDP $81 - Megadrive mode, DMA enable
		dc.b vram_fg>>10	; VDP $82 - foreground nametable address
		dc.b window_plane_prev>>10	; VDP $83 - window nametable address
		dc.b vram_bg>>13	; VDP $84 - background nametable address
		dc.b vram_sprites_prev>>9		; VDP $85 - sprite table address
		dc.b 0			; VDP $86 - unused
		dc.b 0			; VDP $87 - background colour
		dc.b 0			; VDP $88 - unused
		dc.b 0			; VDP $89 - unused
		dc.b 255		; VDP $8A - H_Int register
		dc.b 0			; VDP $8B - full screen scroll
		dc.b $81		; VDP $8C - 40 cell display
		dc.b vram_hscroll_prev>>10	; VDP $8D - hscroll table address
		dc.b 0			; VDP $8E - unused
		dc.b 1			; VDP $8F - VDP increment
		dc.b 1			; VDP $90 - 64 cell hscroll size
		dc.b 0			; VDP $91 - window h position
		dc.b 0			; VDP $92 - window v position
		dc.w $FFFF		; VDP $93/94 - DMA length
		dc.w 0			; VDP $95/96 - DMA source
		dc.b $80		; VDP $97 - DMA fill VRAM
VDPInitValues_End:

; Z80 initalization
Z80StartupCodeBegin:
	save
	cpu z80	; use Z80 cpu
	phase	0
	listing purecode	; add to listing file
zStartupCodeStartLoc:
	xor	a
	ld	bc,(z80_ram_end-z80_ram)-(zStartupCodeEndLoc-zStartupCodeStartLoc)-1
	ld	de,zStartupCodeEndLoc-zStartupCodeStartLoc+1
	ld	hl,zStartupCodeEndLoc-zStartupCodeStartLoc
	ld	sp,hl
	ld	(hl),a
	ldir
	pop	ix
	pop	iy
	ld	i,a
	ld	r,a
	ex	af,af'
	exx
	pop	af
	pop	bc
	pop	de
	pop	hl
	ex	af,af'
	exx
	pop	af
	pop	de
	pop	hl
	ld	sp,hl
	di
	im	1
	ld	(hl),0E9h
	jp	(hl)
zStartupCodeEndLoc:
	dephase
	restore
	padding off
Z80StartupCodeEnd:

PSGInitValues:
		dc.b $9F,$BF,$DF,$FF		; values for PSG channel volumes
PSGInitValues_End:
; ---------------------------------------------------------------------------

loc_306:
		btst	#6,(z80_expansion_control+1).l
		beq.s	CheckSumCheck
		cmpi.l	#"init",(v_init).w ; has checksum routine already run?
		beq.w	GameInit	; if yes, branch

CheckSumCheck:
		movea.l	#EndOfHeader,a0	; start checking bytes after the header ($200)
		movea.l	#RomEndLoc,a1	; stop at end of ROM
		move.l	(a1),d0
		moveq	#0,d1

.loop:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bhs.s	.loop
		movea.l	#Checksum,a1	; read the checksum
		cmp.w	(a1),d1		; compare checksum in header to ROM
	if 0
		bne.w	CheckSumError	; if they don't match, branch
	else
		nop	; removed the branch to the checksum error, so the checksum will not throw an error regardless of the value
		nop
	endif
		lea	(v_crossresetram).w,a6
		moveq	#0,d7
		move.w	#bytesToLcnt(v_end-v_crossresetram),d6

.clearRAM:
		move.l	d7,(a6)+
		dbf	d6,.clearRAM
		move.b	(z80_version).l,d0
		andi.b	#$C0,d0
		move.b	d0,(v_megadrive).w	; get region setting
		move.w	#1,(word_FFFFE0).w	; set an unused flag to 1
		move.l	#"init",(v_init).w	; set flag so checksum won't run again

GameInit:
		lea	(v_start&$FFFFFF).l,a6
		moveq	#0,d7
		move.w	#bytesToLcnt(v_crossresetram-v_start),d6

.clearRAM:
		move.l	d7,(a6)+
		dbf	d6,.clearRAM
		bsr.w	VDPSetupGame
		bsr.w	SoundDriverLoad
		bsr.w	InitJoypads
		move.b	#id_Sega,(v_gamemode).w

MainGameLoop:
		move.b	(v_gamemode).w,d0 ; load Game Mode
		andi.w	#$1C,d0	; limit Game Mode value to $1C max (change to a maximum of 7C to add more game modes)
		jsr	GameModeArray(pc,d0.w) ; jump to apt location in ROM
		bra.s	MainGameLoop	; loop indefinitely
; ===========================================================================
; ---------------------------------------------------------------------------
; Main game mode array
; ---------------------------------------------------------------------------

GameModeArray:

ptr_GM_Sega:	bra.w	GM_Sega

ptr_GM_Title:	bra.w	GM_Title

ptr_GM_Demo:	bra.w	GM_Level

ptr_GM_Level:	bra.w	GM_Level

ptr_GM_Special:	bra.w	GM_Special

		rts
; ---------------------------------------------------------------------------

; Unused, as the checksum check doesn't care if the checksum is wrong.
ChecksumError:
		bsr.w	VDPSetupGame
		move.l	#$C0000000,(vdp_control_port).l	; Set VDP to CRAM write
		moveq	#bytesToWcnt(v_palette_end-v_palette),d7

.palette:
		move.w	#cRed,(vdp_data_port).l		; Write red to data
		dbf	d7,.palette

.endlessloop:
		bra.s	.endlessloop
; ---------------------------------------------------------------------------

BusError:
		move.b	#2,(v_errortype).w
		bra.s	ErrorAddress
; ---------------------------------------------------------------------------

AddressError:
		move.b	#4,(v_errortype).w
		bra.s	ErrorAddress
; ---------------------------------------------------------------------------

IllegalInstr:
		move.b	#6,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ZeroDivide:
		move.b	#8,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ChkInstr:
		move.b	#$A,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

TrapvInstr:
		move.b	#$C,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

PrivilegeViol:
		move.b	#$E,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

Trace:
		move.b	#$10,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

Line1010Emu:
		move.b	#$12,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

Line1111Emu:
		move.b	#$14,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ErrorExcept:
		move.b	#0,(v_errortype).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ErrorAddress:
		disable_ints
		addq.w	#2,sp
		move.l	(sp)+,(v_spbuffer).w
		addq.w	#2,sp
		movem.l	d0-sp,(v_regbuffer).w
		bsr.w	ErrorPrint
		move.l	2(sp),d0
		bsr.w	ErrorPrintAddr
		move.l	(v_spbuffer).w,d0
		bsr.w	ErrorPrintAddr
		bra.s	loc_472
; ---------------------------------------------------------------------------

ErrorNormal:
		disable_ints
		movem.l	d0-sp,(v_regbuffer).w
		bsr.w	ErrorPrint
		move.l	2(sp),d0
		bsr.w	ErrorPrintAddr

loc_472:
		bsr.w	ErrorWaitForC
		movem.l	(v_regbuffer).w,d0-sp
		enable_ints
		rte
; ---------------------------------------------------------------------------

ErrorPrint:
		lea	(vdp_data_port).l,a6
		locVRAM	ArtTile_Error_Handler_Font*tile_size
		lea	(Art_Text).l,a0
		move.w	#bytesToWcnt(Art_Text_End-Art_Text-tile_size),d1

.loadart:
		move.w	(a0)+,(a6)
		dbf	d1,.loadart
		moveq	#0,d0
		move.b	(v_errortype).w,d0
		move.w	Error_Text(pc,d0.w),d0
		lea	Error_Text(pc,d0.w),a0
		locVRAM vram_fg+$604
		moveq	#19-1,d1

.loadtext:
		moveq	#0,d0
		move.b	(a0)+,d0
		addi.w	#-'0'+ArtTile_Error_Handler_Font,d0
		move.w	d0,(a6)
		dbf	d1,.loadtext
		rts
; ---------------------------------------------------------------------------

Error_Text:
		dc.w .exception-Error_Text
		dc.w .bus-Error_Text
		dc.w .address-Error_Text
		dc.w .illinstruct-Error_Text
		dc.w .zerodivide-Error_Text
		dc.w .chkinstruct-Error_Text
		dc.w .trapv-Error_Text
		dc.w .privilege-Error_Text
		dc.w .trace-Error_Text
		dc.w .line1010-Error_Text
		dc.w .line1111-Error_Text
.exception:	dc.b "ERROR EXCEPTION    "
.bus:		dc.b "BUS ERROR          "
.address:	dc.b "ADDRESS ERROR      "
.illinstruct:	dc.b "ILLEGAL INSTRUCTION"
.zerodivide:	dc.b "@ERO DIVIDE        "
.chkinstruct:	dc.b "CHK INSTRUCTION    "
.trapv:		dc.b "TRAPV INSTRUCTION  "
.privilege:	dc.b "PRIVILEGE VIOLATION"
.trace:		dc.b "TRACE              "
.line1010:	dc.b "LINE 1010 EMULATOR "
.line1111:	dc.b "LINE 1111 EMULATOR "
		even
; ---------------------------------------------------------------------------

ErrorPrintAddr:
		move.w	#ArtTile_Error_Handler_Font+10,(a6)	; display "$" symbol
		moveq	#8-1,d2

.loop:
		rol.l	#4,d0
		bsr.s	.shownumber	; display 8 numbers
		dbf	d2,.loop
		rts
; ---------------------------------------------------------------------------

.shownumber:
		move.w	d0,d1
		andi.w	#$F,d1
		cmpi.w	#$A,d1
		blo.s	.chars0to9
		addq.w	#7,d1		; add 7 for characters A-F

.chars0to9:
		addi.w	#ArtTile_Error_Handler_Font,d1
		move.w	d1,(a6)
		rts
; ---------------------------------------------------------------------------

ErrorWaitForC:
		bsr.w	ReadJoypads
		cmpi.b	#btnC,(v_jpadpress1).w	; is button C pressed?
		bne.w	ErrorWaitForC	; if not, branch
		rts
; ---------------------------------------------------------------------------

Art_Text:	binclude "artunc/menutext.bin"
Art_Text_End

; ===========================================================================
; ---------------------------------------------------------------------------
; Vertical interrupt
; ---------------------------------------------------------------------------

V_Int:
		movem.l	d0-a6,-(sp)
		tst.b	(v_vbla_routine).w
		beq.s	VBla_Exit
		move.w	(vdp_control_port).l,d0
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_scrposy_dup).w,(vdp_data_port).l
		btst	#6,(v_megadrive).w	; are we on a PAL machine?
		beq.s	.notPAL	; if not, branch
		move.w	#17930/10-1,d0	; intentionally lag the system to move the CRAM dots on PAL machines
		dbf	d0,*

.notPAL:
		move.b	(v_vbla_routine).w,d0
		move.b	#0,(v_vbla_routine).w
		move.w	#1,(f_hint).w
		andi.w	#$3E,d0
		move.w	VBla_Index(pc,d0.w),d0
		jsr	VBla_Index(pc,d0.w)

VBla_Exit:
		addq.l	#1,(v_vbla_count).w
		jsr	(UpdateMusic).l
		movem.l	(sp)+,d0-a6
		rte
; ---------------------------------------------------------------------------

VBla_00:
		rts
; ---------------------------------------------------------------------------

VBla_Index:
ptr_VBla_00:	dc.w VBla_00-VBla_Index
ptr_VBla_02:	dc.w VBla_02-VBla_Index
ptr_VBla_04:	dc.w VBla_04-VBla_Index
ptr_VBla_06:	dc.w VBla_06-VBla_Index
ptr_VBla_08:	dc.w VBla_08-VBla_Index
ptr_VBla_0A:	dc.w VBla_0A-VBla_Index
ptr_VBla_0C:	dc.w VBla_0C-VBla_Index
ptr_VBla_0E:	dc.w VBla_0E-VBla_Index
ptr_VBla_10:	dc.w VBla_10-VBla_Index
ptr_VBla_12:	dc.w VBla_12-VBla_Index
; ---------------------------------------------------------------------------

VBla_02:
		bsr.w	sub_E78
		tst.w	(v_generictimer).w
		beq.w	.end
		subq.w	#1,(v_generictimer).w

.end:
		rts
; ---------------------------------------------------------------------------

VBla_04:
		bsr.w	sub_E78
		bsr.w	LoadTilesAsYouMove_BGOnly
		bsr.w	ProcessDPLC2
		tst.w	(v_generictimer).w
		beq.w	.end
		subq.w	#1,(v_generictimer).w

.end:
		rts
; ---------------------------------------------------------------------------

VBla_06:
		bsr.w	sub_E78
		rts
; ---------------------------------------------------------------------------

VBla_10:
		cmpi.b	#id_Special,(v_gamemode).w
		beq.w	VBla_0A

VBla_08:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM	v_palette,0
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		move.w	#$8400+(vram_bg>>13),(a5)
		move.w	(v_hint_hreg).w,(a5)
		move.w	(v_bg3scrposy_vdp).w,(v_bg3scrposy_vdp_dup).w
		writeVRAM	v_spritetablebuffer,vram_sprites
		tst.b	(f_sonframechg).w
		beq.s	.nochg
		writeVRAM	v_sgfx_buffer,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

.nochg:
		startZ80
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(UpdateHUD).l
		bsr.w	loc_1454
		moveq	#0,d0
		move.b	(byte_FFF628).w,d0
		move.b	(byte_FFF629).w,d1
		cmp.b	d0,d1
		bhs.s	.higherorequal
		move.b	d0,(byte_FFF629).w

.higherorequal:
		move.b	#0,(byte_FFF628).w
		tst.w	(v_generictimer).w
		beq.w	.end
		subq.w	#1,(v_generictimer).w

.end:
		rts
; ---------------------------------------------------------------------------

VBla_0A:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM	v_palette,0
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		startZ80
		bsr.w	SS_PalCycle
		tst.b	(f_sonframechg).w
		beq.s	.nochg
		writeVRAM	v_sgfx_buffer,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

.nochg:
		tst.w	(v_generictimer).w
		beq.w	.end
		subq.w	#1,(v_generictimer).w

.end:
		rts
; ---------------------------------------------------------------------------

VBla_0C:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM	v_palette,0
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		tst.b	(f_sonframechg).w
		beq.s	.nochg
		writeVRAM	v_sgfx_buffer,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w

.nochg:
		startZ80
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(UpdateHUD).l
		bsr.w	ProcessDPLC2
		rts
; ---------------------------------------------------------------------------

VBla_0E:
		bsr.w	sub_E78
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		addq.b	#1,(byte_FFF628).w
		move.b	#$E,(v_vbla_routine).w
		rts
; ---------------------------------------------------------------------------

VBla_12:
		bsr.w	sub_E78
		bra.w	ProcessDPLC2
; ---------------------------------------------------------------------------

sub_E78:
		bsr.w	ReadJoypads
		stopZ80
		waitZ80
		writeCRAM	v_palette,0
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		startZ80
		rts
; ---------------------------------------------------------------------------

H_Int:
		tst.w	(f_hint).w
		beq.s	.return
		move.l	a5,-(sp)
		writeCRAM	v_palette_fading,0
		movem.l	(sp)+,a5
		move.w	#0,(f_hint).w

.return:
		rte
; ---------------------------------------------------------------------------

H_Int2:
		tst.w	(f_hint).w
		beq.s	.return
		movem.l	d0/a0/a5,-(sp)
		move.w	#0,(f_hint).w
		move.w	#$8400+(window_plane>>13),(vdp_control_port).l
		move.w	#$8500+(vram_sprites>>9),(vdp_control_port).l
		locVRAM vram_sprites
		lea	(v_spritetablebuffer).w,a0
		lea	(vdp_data_port).l,a5
		move.w	#bytesToLcnt(v_spritetablebuffer_end-v_spritetablebuffer),d0

.spritetabletovdp:
		move.l	(a0)+,(a5)
		dbf	d0,.spritetabletovdp
		movem.l	(sp)+,d0/a0/a5

.return:
		rte
; ---------------------------------------------------------------------------

InitJoypads:
		stopZ80
		waitZ80
		moveq	#$40,d0
		move.b	d0,(z80_port_1_control+1).l
		move.b	d0,(z80_port_2_control+1).l
		move.b	d0,(z80_expansion_control+1).l
		startZ80
		rts
; ---------------------------------------------------------------------------

ReadJoypads:
		stopZ80
		waitZ80
		lea	(v_jpadhold1).w,a0
		lea	(z80_port_1_data+1).l,a1
		bsr.s	Joypad_Read
		addq.w	#2,a1
		bsr.s	Joypad_Read
		startZ80
		rts
; ---------------------------------------------------------------------------

Joypad_Read:
		move.b	#0,(a1)
		nop
		nop
		move.b	(a1),d0
		lsl.b	#2,d0
		andi.b	#$C0,d0
		move.b	#$40,(a1)
		nop
		nop
		move.b	(a1),d1
		andi.b	#$3F,d1
		or.b	d1,d0
		not.b	d0
		move.b	(a0),d1
		eor.b	d0,d1
		move.b	d0,(a0)+
		and.b	d0,d1
		move.b	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

VDPSetupGame:
		lea	(vdp_control_port).l,a0
		lea	(vdp_data_port).l,a1
		lea	(VDPSetupArray).l,a2
		moveq	#bytesToWcnt(VDPSetupArray_End-VDPSetupArray),d7

loc_101E:
		move.w	(a2)+,(a0)
		dbf	d7,loc_101E
		move.w	(VDPSetupArray+2).l,d0
		move.w	d0,(v_vdp_buffer1).w
		moveq	#0,d0
		move.l	#$C0000000,(vdp_control_port).l
		move.w	#bytesToWcnt(v_palette_end-v_palette),d7

loc_103E:
		move.w	d0,(a1)
		dbf	d7,loc_103E
		clr.l	(v_scrposy_dup).w
		clr.l	(v_scrposx_dup).w
		move.l	d1,-(sp)
		fillVRAM	0,0,$10000
		move.l	(sp)+,d1
		rts
; ---------------------------------------------------------------------------
VDPSetupArray:
		dc.w $8000+%0100
		dc.w $8100+%00110100
		dc.w $8200+(vram_fg>>10)
		dc.w $8300+(window_plane>>10)
		dc.w $8400+(vram_bg>>13)
		dc.w $8500+(vram_sprites>>9)
		dc.w $8600
		dc.w $8700
		dc.w $8800
		dc.w $8900
		dc.w $8A00
		dc.w $8B00
		dc.w $8C00+%10000001
		dc.w $8D00+(vram_hscroll>>10)
		dc.w $8E00
		dc.w $8F00+%0010
		dc.w $9000+%0001
		dc.w $9100
		dc.w $9200
VDPSetupArray_End
; ---------------------------------------------------------------------------

ClearScreen:
		fillVRAM	0, vram_fg, vram_fg+plane_size_64x32		; clear foreground namespace
		fillVRAM	0, vram_bg, vram_bg+plane_size_64x32		; clear background namespace

		move.l	#0,(v_scrposy_dup).w
		move.l	#0,(v_scrposx_dup).w

	if FixBugs
		clearRAM v_spritetablebuffer,v_spritetablebuffer_end
		clearRAM v_hscrolltablebuffer,v_hscrolltablebuffer_end_padded
	else
		clearRAM v_spritetablebuffer,v_spritetablebuffer_end+4	; This clears too much RAM, but this won't effect much since water palettes don't exist.
		clearRAM v_hscrolltablebuffer,v_hscrolltablebuffer_end_padded+4	; This clears too much RAM, leading to a slight bug (first bit of the Sonic object's RAM is cleared)
	endif

		rts
; ---------------------------------------------------------------------------

SoundDriverLoad:
		nop
		stopZ80
		resetZ80
		lea	(DACDriver).l,a0
		lea	(z80_ram).l,a1
		move.w	#DACDriver_End-DACDriver-1,d0

.loop:
		move.b	(a0)+,(a1)+
		dbf	d0,.loop
		moveq	#0,d0
		lea	(z80_dac_voicetbladr).l,a1
		move.b	d0,(a1)+	; Write 0 to 1FF8
		move.b	#$80,(a1)+	; Write $80 to 1FF9 (zVoiceTblAdr = 8000h)
		move.b	#7,(a1)+	; Write 7 to 1FFA
		move.b	#$80,(a1)+	; Write $80 to 1FFB (zBankStore = 8007h)
		move.b	d0,(a1)+	; Write 0 to 1FFC
		move.b	d0,(a1)+	; Write 0 to 1FFD
		move.b	d0,(a1)+	; Write 0 to 1FFE
		move.b	d0,(a1)+	; Write 0 to 1FFF
		resetZ80a
		nop
		nop
		nop
		nop
		resetZ80
		startZ80
		rts
; ---------------------------------------------------------------------------
; This could potentially be leftover Z80 variables for the above, unused
; ---------------------------------------------------------------------------
;unk_119C:
		dc.b 3
		dc.b 0
		dc.b 0
		dc.b $14
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
; ---------------------------------------------------------------------------

PlaySound:
		move.b	d0,(v_snddriver_ram.v_soundqueue0).w
		rts
; ---------------------------------------------------------------------------

PlaySound_Special:
		move.b	d0,(v_snddriver_ram.v_soundqueue1).w
		rts
; ---------------------------------------------------------------------------

PlaySound_Unused:
		move.b	d0,(v_snddriver_ram.v_soundqueue2).w
		rts

		include "include/PauseGame.asm"
; ---------------------------------------------------------------------------

TilemapToVRAM:
		lea	(vdp_data_port).l,a6
		move.l	#$800000,d4

loc_1222:
		move.l	d0,4(a6)
		move.w	d1,d3

loc_1228:
		move.w	(a1)+,(a6)
		dbf	d3,loc_1228
		add.l	d4,d0
		dbf	d2,loc_1222
		rts
; ---------------------------------------------------------------------------
		include "include/Nemesis Decompression.asm"
; ---------------------------------------------------------------------------

AddPLC:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		lea	(v_plc_buffer).w,a2

loc_138E:
		tst.l	(a2)
		beq.s	loc_1396
		addq.w	#6,a2
		bra.s	loc_138E
; ---------------------------------------------------------------------------

loc_1396:
		move.w	(a1)+,d0
		bmi.s	loc_13A2

loc_139A:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		dbf	d0,loc_139A

loc_13A2:
		movem.l	(sp)+,a1-a2
		rts

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; Queue pattern load requests, but clear the PLQ first

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;	(or hacker) is responsible for making sure that no more than
;	16 load requests are copied into the buffer.
;	_________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;	(or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)

; LoadPLC2:
NewPLC:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1			; jump to relevant PLC
		bsr.s	ClearPLC			; erase any data in PLC buffer space
		lea	(v_plc_buffer).w,a2
		move.w	(a1)+,d0			; get length of PLC
		bmi.s	.skip				; if it's negative, skip the next loop

.loop:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+			; copy PLC to RAM
		dbf	d0,.loop			; repeat for length of PLC

.skip:
		movem.l	(sp)+,a1-a2
		rts
; End of function NewPLC

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; ---------------------------------------------------------------------------
; Subroutine to	clear the pattern load cues
; ---------------------------------------------------------------------------

; Clear the pattern load queue ($FFF680 - $FFF700)


ClearPLC:
		lea	(v_plc_buffer).w,a2		; PLC buffer space in RAM
		moveq	#bytesToLcnt(v_plc_buffer_end-v_plc_buffer),d0

.clearRAM:
		clr.l	(a2)+
		dbf	d0,.clearRAM
		rts
; End of function ClearPLC
; ---------------------------------------------------------------------------

RunPLC:
		tst.l	(v_plc_buffer).w
		beq.s	locret_1436
		tst.w	(f_plc_execute).w
		bne.s	locret_1436
		movea.l	(v_plc_buffer).w,a0
		lea	(NemPCD_WriteRowToVDP).l,a3
		lea	(v_ngfx_buffer).w,a1
		move.w	(a0)+,d2
		bpl.s	loc_1404
		adda.w	#NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP,a3

loc_1404:
		andi.w	#$7FFF,d2
	if ~~FixBugs
		move.w	d2,(f_plc_execute).w
	endif
		bsr.w	NemDec_BuildCodeTable
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6
		moveq	#0,d0
		move.l	a0,(v_plc_buffer).w
		move.l	a3,(v_plc_buffer_reg0).w
		move.l	d0,(v_plc_buffer_reg4).w
		move.l	d0,(v_plc_buffer_reg8).w
		move.l	d0,(v_plc_buffer_regC).w
		move.l	d5,(v_plc_buffer_reg10).w
		move.l	d6,(v_plc_buffer_reg14).w
	if FixBugs
		move.w	d2,(f_plc_execute).w
	endif

locret_1436:
		rts
; ---------------------------------------------------------------------------

; sub_1438:
ProcessDPLC2:
		tst.w	(f_plc_execute).w
		beq.w	locret_14D0
		move.w	#9,(v_plc_buffer_reg1A).w
		moveq	#0,d0
		move.w	(v_plc_buffer+4).w,d0
		addi.w	#$120,(v_plc_buffer+4).w
		bra.s	loc_146C
; ---------------------------------------------------------------------------

loc_1454:
		tst.w	(f_plc_execute).w
		beq.s	locret_14D0
		move.w	#3,(v_plc_buffer_reg1A).w
		moveq	#0,d0
		move.w	(v_plc_buffer+4).w,d0
		addi.w	#$60,(v_plc_buffer+4).w

loc_146C:
		lea	(vdp_control_port).l,a4
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(a4)
		subq.w	#4,a4
		movea.l	(v_plc_buffer).w,a0
		movea.l	(v_plc_buffer_reg0).w,a3
		move.l	(v_plc_buffer_reg4).w,d0
		move.l	(v_plc_buffer_reg8).w,d1
		move.l	(v_plc_buffer_regC).w,d2
		move.l	(v_plc_buffer_reg10).w,d5
		move.l	(v_plc_buffer_reg14).w,d6
		lea	(v_ngfx_buffer).w,a1

loc_14A0:
		movea.w	#8,a5
		bsr.w	NemPCD_NewRow
		subq.w	#1,(f_plc_execute).w
		beq.s	ShiftPLC
		subq.w	#1,(v_plc_buffer_reg1A).w
		bne.s	loc_14A0
		move.l	a0,(v_plc_buffer).w

loc_14B8:
		move.l	a3,(v_plc_buffer_reg0).w
		move.l	d0,(v_plc_buffer_reg4).w
		move.l	d1,(v_plc_buffer_reg8).w
		move.l	d2,(v_plc_buffer_regC).w
		move.l	d5,(v_plc_buffer_reg10).w
		move.l	d6,(v_plc_buffer_reg14).w

locret_14D0:
		rts
; ---------------------------------------------------------------------------

ShiftPLC:
		lea	(v_plc_buffer).w,a0
		moveq	#bytesToLcnt(v_plc_buffer_only_end-v_plc_buffer-6),d0

loc_14D8:
		move.l	6(a0),(a0)+
		dbf	d0,loc_14D8
		rts
; ---------------------------------------------------------------------------

QuickPLC:
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,d1

Qplc_Loop:
		movea.l	(a1)+,a0
		moveq	#0,d0
		move.w	(a1)+,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(vdp_control_port).l
		bsr.w	NemDec
		dbf	d1,Qplc_Loop
		rts
; ---------------------------------------------------------------------------

		include "include/Enigma Decompression.asm"
		include "include/Kosinski Decompression.asm"
		include "include/PaletteCycle.asm"

Cyc_Title:	binclude "palette/Cycle - Title.bin"
Cyc_GHZ:	binclude "palette/Cycle - GHZ.bin"
Cyc_LZ:	binclude "palette/Cycle - LZ (Unused).bin"
Cyc_MZ:	binclude "palette/Cycle - MZ (Unused).bin"
Cyc_SLZ:	binclude "palette/Cycle - SLZ.bin"
Cyc_SZ1:	binclude "palette/Cycle - SZ1.bin"
Cyc_SZ2:	binclude "palette/Cycle - SZ2.bin"
; ---------------------------------------------------------------------------

PaletteWhiteIn:
		move.w	#$3F,(v_pfade_start).w

PaletteWhiteIn_Sub:
		moveq	#0,d0
		lea	(v_palette).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		moveq	#0,d1
		move.b	(v_pfade_size).w,d0

loc_1968:
		move.w	d1,(a0)+
		dbf	d0,loc_1968
		move.w	#$15-1,d4

loc_1972:
		move.b	#$12,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	sub_1988
		bsr.w	RunPLC
		dbf	d4,loc_1972
		rts
; ---------------------------------------------------------------------------

sub_1988:
		moveq	#0,d0
		lea	(v_palette).w,a0
		lea	(v_palette_fading).w,a1
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_pfade_size).w,d0

loc_199E:
		bsr.s	sub_19A6
		dbf	d0,loc_199E
		rts
; ---------------------------------------------------------------------------

sub_19A6:
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3
		beq.s	loc_19CE
		move.w	d3,d1
		addi.w	#$200,d1
		cmp.w	d2,d1
		bhi.s	loc_19BC
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19BC:
		move.w	d3,d1
		addi.w	#$20,d1
		cmp.w	d2,d1
		bhi.s	loc_19CA
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19CA:
		addq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19CE:
		addq.w	#2,a0
		rts
; ---------------------------------------------------------------------------

PaletteFadeOut:
		move.w	#$3F,(v_pfade_start).w
		move.w	#$15-1,d4

loc_19DC:
		move.b	#$12,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	FadeOut_ToBlack
		bsr.w	RunPLC
		dbf	d4,loc_19DC
		rts
; ---------------------------------------------------------------------------

FadeOut_ToBlack:
		moveq	#0,d0
		lea	(v_palette).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_pfade_size).w,d0

loc_1A02:
		bsr.s	sub_1A0A
		dbf	d0,loc_1A02
		rts
; ---------------------------------------------------------------------------

sub_1A0A:
		move.w	(a0),d2
		beq.s	loc_1A36
		move.w	d2,d1
		andi.w	#$E,d1
		beq.s	loc_1A1A
		subq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A1A:
		move.w	d2,d1
		andi.w	#$E0,d1
		beq.s	loc_1A28
		subi.w	#$20,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A28:
		move.w	d2,d1
		andi.w	#$E00,d1
		beq.s	loc_1A36
		subi.w	#$200,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A36:
		addq.w	#2,a0
		rts
; ---------------------------------------------------------------------------

PalCycSega:
		subq.w	#1,(v_pcyc_time).w
		bpl.s	.return
		move.w	#4-1,(v_pcyc_time).w
		move.w	(v_pcyc_num).w,d0	; get cycle number
		bmi.s	.return	; if negative, return
		subq.w	#2,(v_pcyc_num).w	; subtract 2 from cycle number
		lea	(Cyc_Sega).l,a0
		lea	(v_palette+4).w,a1
		adda.w	d0,a0
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)+

.return:
		rts
; ---------------------------------------------------------------------------
Cyc_Sega:	binclude "palette/Cycle - Sega.bin"
; ---------------------------------------------------------------------------

PalLoad1:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		adda.w	#v_palette_fading-v_palette,a3
		move.w	(a1)+,d7

.loop:
		move.l	(a2)+,(a3)+
		dbf	d7,.loop
		rts
; ---------------------------------------------------------------------------

PalLoad2:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		move.w	(a1)+,d7

.loop:
		move.l	(a2)+,(a3)+
		dbf	d7,.loop
		rts

		include "include/Palette Pointers.asm"

Pal_SegaBG:	binclude "palette/Sega Screen.bin"
Pal_Title:	binclude "palette/Title Screen.bin"
Pal_LevelSel:	binclude "palette/Level Select.bin"
Pal_Sonic:	binclude "palette/Sonic.bin"
Pal_GHZ:	binclude "palette/Green Hill Zone.bin"
Pal_LZ:	binclude "palette/Labyrinth Zone.bin"
Pal_Ending:	binclude "palette/Ending.bin"
Pal_MZ:	binclude "palette/Marble Zone.bin"
Pal_SLZ:	binclude "palette/Star Light Zone.bin"
Pal_SZ:	binclude "palette/Sparkling Zone.bin"
Pal_CWZ:	binclude "palette/Clock Work Zone.bin"
Pal_Special:	binclude "palette/Special Stage.bin"
; ---------------------------------------------------------------------------

WaitForVBla:
		enable_ints

.wait:
		tst.b	(v_vbla_routine).w
		bne.s	.wait
		rts
; ---------------------------------------------------------------------------

RandomNumber:
		move.l	(v_random).w,d1
		bne.s	.noreset
		move.l	#$2A6D365A,d1

.noreset:
		move.l	d1,d0
		asl.l	#2,d1
		add.l	d0,d1
		asl.l	#3,d1
		add.l	d0,d1
		move.w	d1,d0
		swap	d1
		add.w	d1,d0
		move.w	d0,d1
		swap	d1
		move.l	d1,(v_random).w
		rts
; ---------------------------------------------------------------------------

CalcSine:
		andi.w	#$FF,d0
		add.w	d0,d0
		addi.w	#$80,d0
		move.w	SineTable(pc,d0.w),d1
		subi.w	#$80,d0
		move.w	SineTable(pc,d0.w),d0
		rts
; ---------------------------------------------------------------------------
SineTable:	binclude "misc/sinewave.bin"
; ---------------------------------------------------------------------------

;GetSqrt:						; Leftover in the final game (REV00 only)
		movem.l	d1-d2,-(sp)
		move.w	d0,d1
		swap	d1
		moveq	#0,d0
		move.w	d0,d1
		moveq	#8-1,d2

loc_22F4:
		rol.l	#2,d1
		add.w	d0,d0
		addq.w	#1,d0
		sub.w	d0,d1
		bhs.s	loc_230E
		add.w	d0,d1
		subq.w	#1,d0
		dbf	d2,loc_22F4
		lsr.w	#1,d0
		movem.l	(sp)+,d1-d2
		rts
; ---------------------------------------------------------------------------

loc_230E:
		addq.w	#1,d0
		dbf	d2,loc_22F4
		lsr.w	#1,d0
		movem.l	(sp)+,d1-d2
		rts
; ---------------------------------------------------------------------------

CalcAngle:
		movem.l	d3-d4,-(sp)
		moveq	#0,d3
		moveq	#0,d4
		move.w	d1,d3
		move.w	d2,d4
		or.w	d3,d4
		beq.s	loc_2378
		move.w	d2,d4
		tst.w	d3
		bpl.w	loc_2336
		neg.w	d3

loc_2336:
		tst.w	d4
		bpl.w	loc_233E
		neg.w	d4

loc_233E:
		cmp.w	d3,d4
		bhs.w	loc_2350
		lsl.l	#8,d4
		divu.w	d3,d4
		moveq	#0,d0
		move.b	AngleTable(pc,d4.w),d0
		bra.s	loc_235A
; ---------------------------------------------------------------------------

loc_2350:
		lsl.l	#8,d3
		divu.w	d4,d3
		moveq	#$40,d0
		sub.b	AngleTable(pc,d3.w),d0

loc_235A:
		tst.w	d1
		bpl.w	loc_2366
		neg.w	d0
		addi.w	#$80,d0

loc_2366:
		tst.w	d2
		bpl.w	loc_2372
		neg.w	d0
		addi.w	#$100,d0

loc_2372:
		movem.l	(sp)+,d3-d4
		rts
; ---------------------------------------------------------------------------

loc_2378:
		move.w	#$40,d0
		movem.l	(sp)+,d3-d4
		rts
; ---------------------------------------------------------------------------
AngleTable:	binclude "misc/angles.bin"
		even
; ---------------------------------------------------------------------------

GM_Sega:
		move.b	#bgm_Fade,d0
		bsr.w	PlaySound_Special
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8000+%0100,(a6)
		move.w	#$8200+(vram_fg>>10),(a6)
		move.w	#$8400+(vram_bg>>13),(a6)
		move.w	#$8700,(a6)
		move.w	#$8B00,(a6)
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		locVRAM ArtTile_Sega_Tiles*tile_size
		lea	(Nem_SegaLogo).l,a0
		bsr.w	NemDec
		lea	(v_start&$FFFFFF).l,a1
		lea	(Eni_SegaLogo).l,a0
		move.w	#make_art_tile(0,0,0),d0
		bsr.w	EniDec

		copyTilemap	v_start&$FFFFFF,vram_fg+$61C,12,4

		moveq	#palid_SegaBG,d0
		bsr.w	PalLoad2
		move.w	#40,(v_pcyc_num).w	; set cycle number to 40
		move.w	#0,(v_pal_buffer+$12).w
		move.w	#0,(v_pal_buffer+$10).w
		move.w	#180,(v_generictimer).w
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l

loc_2528:
		move.b	#2,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	PalCycSega
		tst.w	(v_generictimer).w
		beq.s	loc_2544
		andi.b	#btnStart,(v_jpadpress1).w	; is start pressed?
		beq.s	loc_2528	; if not, loop

loc_2544:
		move.b	#id_Title,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

GM_Title:
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8000+%0100,(a6)
		move.w	#$8200+(vram_fg>>10),(a6)
		move.w	#$8400+(vram_bg>>13),(a6)
		move.w	#$9000+%0001,(a6)
		move.w	#$9200,(a6)
		move.w	#$8B00+%0011,(a6)
		move.w	#$8700+%00100000,(a6)
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen

		clearRAM v_objspace,v_objspace_end

		locVRAM ArtTile_Title_Foreground*tile_size
		lea	(Nem_TitleFg).l,a0
		bsr.w	NemDec
		locVRAM ArtTile_Title_Sonic*tile_size
		lea	(Nem_TitleSonic).l,a0
		bsr.w	NemDec
		lea	(vdp_data_port).l,a6
		locVRAM ArtTile_Level_Select_Font*tile_size,vdp_control_port-vdp_data_port(a6)
		lea	(Art_Text).l,a5
		move.w	#bytesToWcnt(Art_Text_End-Art_Text),d1

loc_25D8:
		move.w	(a5)+,(a6)
		dbf	d1,loc_25D8

		lea	(Unc_Title).l,a1

		copyUncTilemap	vram_fg+$206,34,22

		move.w	#0,(v_debuguse).w
		move.w	#0,(f_demo).w
		move.w	#0,(v_zone).w
		bsr.w	LoadLevelBounds
		bsr.w	DeformLayers
		locVRAM ArtTile_Level*tile_size
		lea	(Nem_GHZ_1st).l,a0
		bsr.w	NemDec
		lea	(Blk16_GHZ).l,a0
		lea	(v_16x16).w,a4
		move.w	#bytesToLcnt(v_16x16_end-v_16x16),d0

.loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,.loadblocks
		lea	(Blk256_GHZ).l,a0
		lea	(v_256x256&$FFFFFF).l,a1
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayoutbg).w,a4
		move.w	#$6000,d2
		bsr.w	DrawChunks
		moveq	#palid_Title,d0
		bsr.w	PalLoad1
		move.b	#bgm_Title,d0
		bsr.w	PlaySound_Special
		move.b	#0,(f_debugmode).w
		move.w	#376,(v_generictimer).w	; run title screen for 376 frames
		move.b	#id_TitleSonic,(v_objslot1).w	; load big sonic object
		move.b	#id_PSBTM,(v_objslot2).w	; load press start button text
		move.b	#id_PSBTM,(v_objslot3).w	; load object which hides sonic
		move.b	#2,(v_objslot3+obFrame).w
		moveq	#plcid_Main,d0
		bsr.w	NewPLC
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteWhiteIn

loc_26AE:
		move.b	#4,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	ExecuteObjects
		bsr.w	DeformLayers
		bsr.w	BuildSprites
		bsr.w	PalCycTitle
		bsr.w	RunPLC
		move.w	(v_objslot0+obX).w,d0
		addq.w	#2,d0	; set object scroll right speed
		move.w	d0,(v_objslot0+obX).w	; move sonic to the right
		cmpi.w	#$1C00,d0	; has object passed $1C00?
		blo.s	loc_26E4	; if not, branch
		move.b	#id_Sega,(v_gamemode).w	; go to Sega Screen
		rts
; ---------------------------------------------------------------------------

loc_26E4:
		tst.w	(v_generictimer).w
		beq.w	loc_27F8
		andi.b	#btnStart,(v_jpadpress1).w
		beq.w	loc_26AE
		btst	#bitA,(v_jpadhold1).w
		beq.w	loc_27AA
		moveq	#palid_LevelSel,d0
		bsr.w	PalLoad2
		clearRAM v_hscrolltablebuffer,v_hscrolltablebuffer_end
		move.l	d0,(v_scrposy_dup).w
		disable_ints
		lea	(vdp_data_port).l,a6
		move.l	#$60000003,(vdp_control_port).l
		move.w	#bytesToLcnt($1000),d1

loc_2732:
		move.l	d0,(a6)
		dbf	d1,loc_2732
		bsr.w	LevSelTextLoad

;loc_273C:
LevelSelect:
		move.b	#4,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	sub_28A6
		bsr.w	RunPLC
		tst.l	(v_plc_buffer).w
		bne.s	LevelSelect
		andi.b	#btnABC+btnStart,(v_jpadpress1).w
		beq.s	LevelSelect
		move.w	(v_levselitem).w,d0
		cmpi.w	#$13,d0
		bne.s	loc_2780
		move.w	(v_levselsound).w,d0
		addi.w	#$80,d0
		cmpi.w	#bgm__Last+2,d0	; There's no pointer for music $92 or $93
		blo.s	loc_277A	; So the game crashes when played
		cmpi.w	#sfx__First,d0
		blo.s	LevelSelect

loc_277A:
		bsr.w	PlaySound_Special
		bra.s	LevelSelect
; ---------------------------------------------------------------------------

loc_2780:
		add.w	d0,d0
		move.w	LevSelOrder(pc,d0.w),d0
		bmi.s	LevelSelect
		cmpi.w	#id_SS<<8,d0
		bne.s	loc_2796
		move.b	#id_Special,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_2796:
		andi.w	#$3FFF,d0
		btst	#bitB,(v_jpadhold1).w		; Is B pressed?
		beq.s	loc_27A6			; If not, ignore below
		move.w	#id_GHZ<<8+3,d0			; Set the zone to Green Hill Act 4

loc_27A6:
		move.w	d0,(v_zone).w

loc_27AA:
		move.b	#id_Level,(v_gamemode).w
		move.b	#3,(v_lives).w
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.l	d0,(v_score).w
		move.b	#bgm_Fade,d0
		bsr.w	PlaySound_Special
		rts
; ---------------------------------------------------------------------------
LevSelOrder:
		dc.b id_GHZ,0	; GHZ1
		dc.b id_GHZ,1	; GHZ2
		dc.b id_GHZ,2	; GHZ3
		dc.b id_LZ,0	; LZ1
		dc.b id_LZ,1	; LZ2
		dc.b id_LZ,2	; LZ3
		dc.b id_MZ,0	; MZ1
		dc.b id_MZ,1	; MZ2
		dc.b id_MZ,2	; MZ3
		dc.b id_SLZ,0	; SLZ1
		dc.b id_SLZ,1	; SLZ2
		dc.b id_SLZ,2	; SLZ3
		dc.b id_SZ,0	; SZ1
		dc.b id_SZ,1	; SZ2
		dc.b id_SZ,2	; SZ3
		dc.b id_CWZ,0	; CWZ1
		dc.b id_CWZ,1	; CWZ2
		dc.b id_CWZ+$80,0	; CWZ3
		dc.b id_SS,0	; SS
		dc.b id_SS,0	; SS (Sound Select)
		dc.w $8000
; ---------------------------------------------------------------------------

loc_27F8:
		move.w	#30,(v_generictimer).w

loc_27FE:
		move.b	#4,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	DeformLayers
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		move.w	(v_objslot0+obX).w,d0
		addq.w	#2,d0
		move.w	d0,(v_objslot0+obX).w
		cmpi.w	#$1C00,d0
		blo.s	loc_282C
		move.b	#id_Sega,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_282C:
		tst.w	(v_generictimer).w
		bne.w	loc_27FE
		move.b	#bgm_Fade,d0
		bsr.w	PlaySound_Special
		move.w	(v_demonum).w,d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	DemoLevels(pc,d0.w),d0
		move.w	d0,(v_zone).w
		addq.w	#1,(v_demonum).w
		cmpi.w	#6,(v_demonum).w
		blo.s	loc_2860
		move.w	#0,(v_demonum).w

loc_2860:
		move.w	#1,(f_demo).w
		move.b	#id_Demo,(v_gamemode).w
		cmpi.w	#(id_SS-1)<<8,d0
		bne.s	loc_2878
		move.b	#id_Special,(v_gamemode).w

loc_2878:
		move.b	#3,(v_lives).w
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.l	d0,(v_score).w
		rts
; ---------------------------------------------------------------------------

DemoLevels:
		dc.b	id_GHZ,0
		dc.b	(id_SS-1),0
		dc.b	id_MZ,0
		dc.b	(id_SS-1),0
		dc.b	id_SZ,0
		dc.b	(id_SS-1),0
		dc.b	id_SLZ,0
		dc.b	(id_SS-1),0
		dc.b	id_MZ,0
		dc.b	(id_SS-1),0
		dc.b	id_SZ,0
		dc.b	(id_SS-1),0
; ---------------------------------------------------------------------------

sub_28A6:
		move.b	(v_jpadpress1).w,d1
		andi.b	#btnUp+btnDn,d1
		bne.s	loc_28B6
		subq.w	#1,(v_levseldelay).w
		bpl.s	loc_28F0

loc_28B6:
		move.w	#12-1,(v_levseldelay).w
		move.b	(v_jpadhold1).w,d1
		andi.b	#btnUp+btnDn,d1
		beq.s	loc_28F0
		move.w	(v_levselitem).w,d0
		btst	#bitUp,d1
		beq.s	loc_28D6
		subq.w	#1,d0
		bhs.s	loc_28D6
		moveq	#$13,d0

loc_28D6:
		btst	#bitDn,d1
		beq.s	loc_28E6
		addq.w	#1,d0
		cmpi.w	#$14,d0
		blo.s	loc_28E6
		moveq	#0,d0

loc_28E6:
		move.w	d0,(v_levselitem).w
		bsr.w	LevSelTextLoad
		rts
; ---------------------------------------------------------------------------

loc_28F0:
		cmpi.w	#$13,(v_levselitem).w
		bne.s	locret_292A
		move.b	(v_jpadpress1).w,d1
		andi.b	#btnL+btnR,d1
		beq.s	locret_292A
		move.w	(v_levselsound).w,d0
		btst	#bitL,d1
		beq.s	loc_2912
		subq.w	#1,d0
		bhs.s	loc_2912
		moveq	#sfx__Last-$80,d0

loc_2912:
		btst	#bitR,d1
		beq.s	loc_2922
		addq.w	#1,d0
		cmpi.w	#spec__First-$80,d0
		blo.s	loc_2922
		moveq	#0,d0

loc_2922:
		move.w	d0,(v_levselsound).w
		bsr.w	LevSelTextLoad

locret_292A:
		rts
; ---------------------------------------------------------------------------

LevSelTextLoad:

textpos:	= ($40000000+(($E210&$3FFF)<<16)+(($E210&$C000)>>14))
					; $E210 is a VRAM address

		lea	(LevelSelectText).l,a1
		lea	(vdp_data_port).l,a6
		move.l	#textpos,d4
		move.w	#$E680,d3
		moveq	#20-1,d1	; Only load 20 lines.

loc_2944:
		move.l	d4,4(a6)
		bsr.w	sub_29CC
		addi.l	#$800000,d4
		dbf	d1,loc_2944
		moveq	#0,d0
		move.w	(v_levselitem).w,d0
		move.w	d0,d1
		move.l	#textpos,d4
		lsl.w	#7,d0
		swap	d0
		add.l	d0,d4
		lea	(LevelSelectText).l,a1
		lsl.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		adda.w	d1,a1
		move.w	#$C680,d3
		move.l	d4,4(a6)
		bsr.w	sub_29CC
		move.w	#$E680,d3
		cmpi.w	#$13,(v_levselitem).w		; are we on Sound Select?
		bne.s	loc_2996			; if not, branch
		move.w	#$C680,d3

loc_2996:
		locVRAM vram_bg+$BB0
		move.w	(v_levselsound).w,d0
		addi.w	#$80,d0
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.w	sub_29B8
		move.b	d2,d0
		bsr.w	sub_29B8
		rts
; ---------------------------------------------------------------------------

sub_29B8:
		andi.w	#$F,d0
		cmpi.b	#$A,d0
		blo.s	loc_29C6
		addi.b	#7,d0

loc_29C6:
		add.w	d3,d0
		move.w	d0,(a6)
		rts
; ---------------------------------------------------------------------------

sub_29CC:
		moveq	#24-1,d2

loc_29CE:
		moveq	#0,d0
		move.b	(a1)+,d0
		bpl.s	loc_29DE
		move.w	#0,(a6)
		dbf	d2,loc_29CE
		rts
; ---------------------------------------------------------------------------

loc_29DE:
		add.w	d3,d0
		move.w	d0,(a6)
		dbf	d2,loc_29CE
		rts
; ---------------------------------------------------------------------------

LevelSelectText:
		charset ' ', $FF
		charset '0', "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09"
		charset '$', $0A
		charset '-', $0B
		charset '=', $0C
		charset '>', $0D
		;charset '>', $0E ; there are two identical right arrows back-to-back in the menutext font, for some reason
		charset 'Y', "\x0F\x10" ; Y and Z come before A-X
		charset 'A', "\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F\x20\x21\x22\x23\x24\x25\x26\x27\x28"

		dc.b "GREEN HILL ZONE STAGE 1 "
		dc.b "                STAGE 2 "
		dc.b "                STAGE 3 "
		dc.b "LABYRINTH ZONE  STAGE 1 "
		dc.b "                STAGE 2 "
		dc.b "                STAGE 3 "
		dc.b "MARBLE ZONE     STAGE 1 "
		dc.b "                STAGE 2 "
		dc.b "                STAGE 3 "
		dc.b "STAR LIGHT ZONE STAGE 1X"
		dc.b "                STAGE 2X"
		dc.b "                STAGE 3X"
		dc.b "SPARKLING ZONE  STAGE 1 "
		dc.b "                STAGE 2 "
		dc.b "                STAGE 3 "
		dc.b "CLOCK WORK ZONE STAGE 1 "
		dc.b "                STAGE 2 "
		dc.b "                STAGE 3X"
		dc.b "SPECIAL STAGE           "
		dc.b "SOUND SELECT            "

		charset

MusicList:
		dc.b bgm_GHZ
		dc.b bgm_LZ
		dc.b bgm_MZ
		dc.b bgm_SLZ
		dc.b bgm_SZ
		dc.b bgm_CWZ
		even
; ---------------------------------------------------------------------------

GM_Level:
		move.b	#bgm_Fade,d0
		bsr.w	PlaySound_Special
		locVRAM ArtTile_Title_Card*tile_size
		lea	(Nem_TitleCard).l,a0
		bsr.w	NemDec
		bsr.w	ClearPLC
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	loc_2C0A
		bsr.w	AddPLC

loc_2C0A:
		moveq	#plcid_Main2,d0
		bsr.w	AddPLC
		bsr.w	PaletteFadeOut
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a6
		move.w	#$8B00+%0011,(a6)
		move.w	#$8200+(vram_fg>>10),(a6)
		move.w	#$8400+(vram_bg>>13),(a6)
		move.w	#$8500+(vram_sprites>>9),(a6)
		move.w	#0,(word_FFFFE8).w
		move.w	#$8A00+175,(v_hint_hreg).w
		move.w	#$8000+%0100,(a6)
		move.w	#$8700+%00100000,(a6)

		clearRAM v_objspace,v_objspace_end
		clearRAM v_misc_variables,v_misc_variables_end
		clearRAM v_timingandscreenvariables,v_timingandscreenvariables_end

		moveq	#palid_Sonic,d0
		bsr.w	PalLoad2
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(MusicList).l,a1
		move.b	(a1,d0.w),d0
		bsr.w	PlaySound
		move.b	#id_TitleCard,(v_objslot2).w	; load title card object

loc_2C92:
		move.b	#$C,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		bsr.w	RunPLC
		move.w	(v_objslot4+obX).w,d0
		cmp.w	(v_objslot4+card_mainX).w,d0
		bne.s	loc_2C92
		tst.l	(v_plc_buffer).w
		bne.s	loc_2C92
		bsr.w	DebugPosLoadArt
		jsr	(Hud_Base).l
		moveq	#palid_Sonic,d0
		bsr.w	PalLoad1
		bsr.w	LoadLevelBounds
		bsr.w	DeformLayers
		bsr.w	LoadLevelData
		bsr.w	LoadAnimatedBlocks
		bsr.w	LoadTilesFromStart
		jsr	(ConvertCollisionArray).l
		move.l	#Col_GHZ,(v_collindex).w		; Load Green Hill's collision - what follows are some C style conditional statements, really unnecessary and replaced with a table in the final game
		cmpi.b	#id_LZ,(v_zone).w		; Is the current zone Labyrinth?
		bne.s	loc_2CFA			; If not, go to the next condition
		move.l	#Col_LZ,(v_collindex).w		; Load Labyrinth's collision

loc_2CFA:
		cmpi.b	#id_MZ,(v_zone).w		; Is the current zone Marble?
		bne.s	loc_2D0A			; If not, go to the next condition
		move.l	#Col_MZ,(v_collindex).w		; Load Marble's collision

loc_2D0A:
		cmpi.b	#id_SLZ,(v_zone).w		; Is the current zone Star Light?
		bne.s	loc_2D1A			; If not, go to the next condition
		move.l	#Col_SLZ,(v_collindex).w		; Load Star Light's collision

loc_2D1A:
		cmpi.b	#id_SZ,(v_zone).w		; Is the current zone Sparkling?
		bne.s	loc_2D2A			; If not, go to the last condition
		move.l	#Col_SZ,(v_collindex).w		; Load Sparkling's collision

loc_2D2A:
		cmpi.b	#id_CWZ,(v_zone).w		; Is the current zone Clock Work?
		bne.s	loc_2D3A			; If not, then just skip loading collision
		move.l	#Col_CWZ,(v_collindex).w		; Load Clock Work's collision

loc_2D3A:
		move.b	#id_SonicPlayer,(v_player).w
		move.b	#id_HUD,(v_hud).w
		btst	#bitA,(v_jpadhold1).w
		beq.s	loc_2D54
		move.b	#1,(f_debugmode).w

loc_2D54:
		move.w	#0,(v_jpadhold2).w
		move.w	#0,(v_jpadhold1).w
		bsr.w	ObjPosLoad
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.b	d0,(v_lifecount).w
		move.l	d0,(v_time).w
		move.b	d0,(v_shield).w
		move.b	d0,(v_invinc).w
		move.b	d0,(v_shoes).w
		move.b	d0,(byte_FFFE2F).w
		move.w	d0,(v_debuguse).w
		move.w	d0,(f_restart).w
		move.w	d0,(v_framecount).w
		bsr.w	OscillateNumInit
		move.b	#1,(f_scorecount).w
		move.b	#1,(f_ringcount).w
		move.b	#1,(f_timecount).w
		move.w	#0,(v_btnpushtime1).w
		lea	(DemoDataPtr).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.b	1(a1),(v_btnpushtime2).w
		subq.b	#1,(v_btnpushtime2).w
		move.w	#1800,(v_generictimer).w
		move.b	#8,(v_vbla_routine).w
		bsr.w	WaitForVBla
		move.w	#$202F,(v_pfade_start).w
		bsr.w	PaletteWhiteIn_Sub
		addq.b	#2,(v_objslot2+obRoutine).w
		addq.b	#4,(v_objslot3+obRoutine).w
		addq.b	#4,(v_objslot4+obRoutine).w
		addq.b	#4,(v_objslot5+obRoutine).w

GM_LevelLoop:
		bsr.w	PauseGame
		move.b	#8,(v_vbla_routine).w
		bsr.w	WaitForVBla
		addq.w	#1,(v_framecount).w
		bsr.w	LZWaterFeatures
		bsr.w	DemoPlayback
		move.w	(v_jpadhold1).w,(v_jpadhold2).w
		bsr.w	ExecuteObjects
		tst.w	(v_debuguse).w
		bne.s	loc_2E2A
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	loc_2E2E

loc_2E2A:
		bsr.w	DeformLayers

loc_2E2E:
		bsr.w	BuildSprites
		bsr.w	ObjPosLoad
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		bsr.w	OscillateNumDo
		bsr.w	UpdateTimers
		bsr.w	LoadSignpostPLC
		cmpi.b	#id_Demo,(v_gamemode).w
		beq.s	loc_2E66
		tst.w	(f_restart).w
		bne.w	GM_Level
		cmpi.b	#id_Level,(v_gamemode).w
		beq.w	GM_LevelLoop
		rts
; ---------------------------------------------------------------------------

loc_2E66:
		tst.w	(f_restart).w
		bne.s	loc_2E84
		tst.w	(v_generictimer).w
		beq.s	loc_2E84
		cmpi.b	#id_Demo,(v_gamemode).w
		beq.w	GM_LevelLoop
		move.b	#id_Sega,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

loc_2E84:
		cmpi.b	#id_Demo,(v_gamemode).w
		bne.s	loc_2E92
		move.b	#id_Sega,(v_gamemode).w

loc_2E92:
		move.w	#60,(v_generictimer).w
		move.w	#$3F,(v_pfade_start).w

loc_2E9E:
		move.b	#8,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	DemoPlayback
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		bsr.w	ObjPosLoad
		subq.w	#1,(v_palchgspeed).w
		bpl.s	loc_2EC8
		move.w	#3-1,(v_palchgspeed).w
		bsr.w	FadeOut_ToBlack

loc_2EC8:
		tst.w	(v_generictimer).w
		bne.s	loc_2E9E
		rts
; ---------------------------------------------------------------------------
		include "leftovers/obj/Debug Coordinate Sprites.asm"
; ---------------------------------------------------------------------------
; Unused, Speculated to have been for a window plane wavy masking effect
; involving writes during H_Int. It writes its tables in the Nemesis GFX
; buffer, only seemingly needing to be called once.
; Discovered by Filter, reconstructed by KatKuriN, Rivet, and ProjectFM
; ---------------------------------------------------------------------------
;sub_3018:
		lea	(v_ngfx_buffer).w,a0
		move.w	(f_water).w,d2
		move.w	#$9100,d3
		move.w	#bytesToWcnt($200),d7

loc_3028:
		move.w	d2,d0
		bsr.w	CalcSine
		asr.w	#4,d0
		bpl.s	loc_3034
		moveq	#0,d0

loc_3034:
		andi.w	#$1F,d0
		move.b	d0,d3
		move.w	d3,(a0)+
		addq.w	#2,d2
		dbf	d7,loc_3028
		addq.w	#2,(f_water).w
		rts

		include "include/LZWaterFeatures.asm"
; ---------------------------------------------------------------------------

DemoPlayback:
		tst.w	(f_demo).w
		bne.s	loc_30B8
		rts
; ---------------------------------------------------------------------------

;DemoRecord:
		lea	(EndOfROM).l,a1
		move.w	(v_btnpushtime1).w,d0
		adda.w	d0,a1
		move.b	(v_jpadhold1).w,d0
		cmp.b	(a1),d0
		bne.s	loc_30A2
		addq.b	#1,1(a1)
		cmpi.b	#$FF,1(a1)
		beq.s	loc_30A2
		rts
; ---------------------------------------------------------------------------

loc_30A2:
		move.b	d0,2(a1)
		move.b	#0,3(a1)
		addq.w	#2,(v_btnpushtime1).w
		andi.w	#$3FF,(v_btnpushtime1).w
		rts
; ---------------------------------------------------------------------------

loc_30B8:
		tst.b	(v_jpadhold1).w
		bpl.s	loc_30C4
		move.b	#id_Title,(v_gamemode).w

loc_30C4:
		lea	(DemoDataPtr).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.w	(v_btnpushtime1).w,d0
		adda.w	d0,a1
		move.b	(a1),d0
		lea	(v_jpadhold1).w,a0
		move.b	d0,d1
	if FixBugs
		move.b	v_jpadhold2-v_jpadhold1(a0),d2
	else
		move.b	(a0),d2
	endif
		eor.b	d2,d0
		move.b	d1,(a0)+
		and.b	d1,d0
		move.b	d0,(a0)+
		subq.b	#1,(v_btnpushtime2).w
		bhs.s	locret_30FE
		move.b	3(a1),(v_btnpushtime2).w
		addq.w	#2,(v_btnpushtime1).w

locret_30FE:
		rts
; ---------------------------------------------------------------------------
DemoDataPtr:
		dc.l Demo_MZ
		dc.l Demo_MZ
		dc.l Demo_MZ
		dc.l Demo_GHZ
		dc.l Demo_SZ
		dc.l Demo_SZ
		dc.l Demo_SS

		include	"demodata/Unused.asm"
; ---------------------------------------------------------------------------
;sub_314C:
		cmpi.b	#id_06,(v_zone).w	; are we on Zone 6?
		bne.s	locret_3176	; if not, branch
		bsr.w	sub_3178
		lea	(v_256x256&$FFFFFF+$900).l,a1
		bsr.s	sub_3166
		lea	(v_256x256&$FFFFFF+$3380).l,a1

sub_3166:
		lea	(Anim256Unk1).l,a0
		move.w	#bytesToWcnt(Anim256Unk1_End-Anim256Unk1),d1

.loadchunks:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadchunks

locret_3176:
		rts
; ---------------------------------------------------------------------------

sub_3178:
		lea	(v_256x256&$FFFFFF).l,a1
		lea	(Anim256Unk2).l,a0
		move.w	#bytesToWcnt(Anim256Unk2_End-Anim256Unk2),d1

.loadchunks2:
		move.w	(a0)+,d0
		ori.w	#$2000,(a1,d0.w)
		dbf	d1,.loadchunks2
		rts
; ---------------------------------------------------------------------------
Anim256Unk1:	binclude "level/map256/Anim Unknown 1.bin"
Anim256Unk1_End
Anim256Unk2:	binclude "level/map256/Anim Unknown 2.bin"
Anim256Unk2_End
; ---------------------------------------------------------------------------

LoadAnimatedBlocks:
		cmpi.b	#id_MZ,(v_zone).w	; are we on Marble Zone?
		beq.s	.ismz	; if yes, branch
		cmpi.b	#id_SLZ,(v_zone).w	; are we on Star Light Zone?
		beq.s	.isslz	; if yes, branch
		tst.b	(v_zone).w	; are we on Green Hill Zone?
		bne.s	.notghz	; if not, branch

.isslz:
		lea	(v_16x16+$1790).w,a1	; load ROM address for animated blocks to load in the main block RAM into a1.
		lea	(Anim16GHZ).l,a0	; load animated GHZ blocks into a0.
		move.w	#bytesToWcnt(Anim16GHZ_End-Anim16GHZ),d1	; load approximate size of the blocks into d1.

.loadghz:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadghz

.notghz:
		rts
; ---------------------------------------------------------------------------

.ismz:
		lea	(v_16x16+$17A0).w,a1	; load ROM address for animated blocks to load in the main block RAM into a1.
		lea	(Anim16MZ).l,a0	; load animated MZ blocks into a0.
		move.w	#bytesToWcnt(Anim16MZ_End-Anim16MZ),d1	; load approximate size of the blocks into d1.

.loadmz:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadmz
		rts
; ---------------------------------------------------------------------------
Anim16GHZ:	binclude "level/map16/Anim GHZ.bin"
Anim16GHZ_End
Anim16MZ:	binclude "level/map16/Anim MZ.bin"
Anim16MZ_End
; ---------------------------------------------------------------------------

DebugPosLoadArt:
		rts
; ---------------------------------------------------------------------------
		locVRAM $4F0*tile_size
		lea	(Art_Text).l,a0
		move.w	#bytesToWcnt(Art_Text_End-Art_Text-tile_size*$1F),d1
		bsr.s	.loadtext
		lea	(Art_Text).l,a0
		adda.w	#$11*tile_size,a0
		move.w	#bytesToWcnt(Art_Text_End-Art_Text-tile_size*$23),d1

.loadtext:
		move.w	(a0)+,(vdp_data_port).l
		dbf	d1,.loadtext
		rts
; ---------------------------------------------------------------------------
;1bppConvert:
		moveq	#0,d0	; this code converts palette indices from 1 to 6
		move.b	(a0)+,d0	; for example, $11 will be turned into $66
		ror.w	#1,d0
		lsr.b	#3,d0
		rol.w	#1,d0
		move.b	.1bpp(pc,d0.w),d2
		lsl.w	#8,d2
		moveq	#0,d0
		move.b	(a0)+,d0
		ror.w	#1,d0
		lsr.b	#3,d0
		rol.w	#1,d0
		move.b	.1bpp(pc,d0.w),d2
		move.w	d2,(vdp_data_port).l
		dbf	d1,.loadtext
		rts
; ---------------------------------------------------------------------------
.1bpp:	dc.b 0, 6, $60, $66

		include "include/Oscillatory Routines.asm"
; ---------------------------------------------------------------------------

UpdateTimers:
		subq.b	#1,(v_ani0_time).w
		bpl.s	loc_3464
		move.b	#12-1,(v_ani0_time).w
		subq.b	#1,(v_ani0_frame).w
		andi.b	#8-1,(v_ani0_frame).w

loc_3464:
		subq.b	#1,(v_ani1_time).w
		bpl.s	loc_347A
		move.b	#8-1,(v_ani1_time).w
		addq.b	#1,(v_ani1_frame).w
		andi.b	#4-1,(v_ani1_frame).w

loc_347A:
		subq.b	#1,(v_ani2_time).w
		bpl.s	loc_3498
		move.b	#8-1,(v_ani2_time).w
		addq.b	#1,(v_ani2_frame).w
		cmpi.b	#6,(v_ani2_frame).w
		blo.s	loc_3498
		move.b	#0,(v_ani2_frame).w

loc_3498:
		tst.b	(v_ani3_time).w
		beq.s	locret_34BA
		moveq	#0,d0
		move.b	(v_ani3_time).w,d0
		add.w	(v_ani3_buf).w,d0
		move.w	d0,(v_ani3_buf).w
		rol.w	#7,d0
		andi.w	#3,d0
		move.b	d0,(v_ani3_frame).w
		subq.b	#1,(v_ani3_time).w

locret_34BA:
		rts
; ---------------------------------------------------------------------------

LoadSignpostPLC:
		tst.w	(v_debuguse).w
		bne.w	locret_34FA
		cmpi.w	#id_MZ<<8+2,(v_zone).w	; are we on Marble Zone Act 3?
		beq.s	loc_34D4	; if so, load the signpost
		cmpi.b	#2,(v_act).w
		beq.s	locret_34FA

loc_34D4:
		move.w	(v_screenposx).w,d0
		move.w	(v_limitright2).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0
		blt.s	locret_34FA
		tst.b	(f_timecount).w
		beq.s	locret_34FA
		cmp.w	(v_limitleft2).w,d1
		beq.s	locret_34FA
		move.w	d1,(v_limitleft2).w
		moveq	#plcid_Signpost,d0
		bra.w	NewPLC
; ---------------------------------------------------------------------------

locret_34FA:
		rts
; ---------------------------------------------------------------------------

GM_Special:
		bsr.w	PaletteFadeOut
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		fillVRAM	0, ArtTile_SS_Plane_1*tile_size+plane_size_64x32, ArtTile_SS_Plane_5*tile_size
		moveq	#plcid_SpecialStage,d0
		bsr.w	QuickPLC
		bsr.w	SS_BGLoad
		clearRAM v_objspace,v_objspace_end
		clearRAM v_misc_variables,v_misc_variables_end
		clearRAM v_timingandscreenvariables,v_timingandscreenvariables_end
		clearRAM v_ngfx_buffer,v_ngfx_buffer_end
		moveq	#palid_Special,d0
		bsr.w	PalLoad1
		jsr	(SS_Load).l
		move.l	#0,(v_screenposx).w
		move.l	#0,(v_screenposy).w
		move.b	#id_SonicSpecial,(v_player).w
		move.w	#$458,(v_player+obX).w
		move.w	#$4A0,(v_player+obY).w
		lea	(vdp_control_port).l,a6
		move.w	#$8B00+%0011,(a6)
		move.w	#$8000+%0100,(a6)
		move.w	#$8A00+175,(v_hint_hreg).w
		move.w	#$9000+%00010001,(a6)
		bsr.w	SS_PalCycle
		clr.w	(v_ssangle).w
		move.w	#$40,(v_ssrotate).w
		move.w	#bgm_SS,d0
		bsr.w	PlaySound_Special
		move.w	#0,(v_btnpushtime1).w
		lea	(DemoDataPtr).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.b	1(a1),(v_btnpushtime2).w
		subq.b	#1,(v_btnpushtime2).w
		move.w	#1800,(v_generictimer).w
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteWhiteIn

loc_3620:
		bsr.w	PauseGame
		move.b	#$A,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	DemoPlayback
		move.w	(v_jpadhold1).w,(v_jpadhold2).w
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		jsr	(SS_ShowLayout).l
		bsr.w	SS_AnimateBG
		tst.w	(f_demo).w
		beq.s	loc_3656
		tst.w	(v_generictimer).w
		beq.s	loc_3662

loc_3656:
		cmpi.b	#id_Special,(v_gamemode).w
		beq.w	loc_3620
		rts
; ---------------------------------------------------------------------------

loc_3662:
		move.b	#id_Sega,(v_gamemode).w
		rts
; ---------------------------------------------------------------------------

SS_BGLoad:
		lea	(v_start&$FFFFFF).l,a1
		lea	(Eni_SSBg1).l,a0
		move.w	#make_art_tile(ArtTile_SS_Background_Fish,2,0),d0
		bsr.w	EniDec
		move.l	#$50000001,d3
		lea	(v_start&$FFFFFF+$80).l,a2
		moveq	#6,d7

loc_368C:
		move.l	d3,d0
		moveq	#4-1,d6
		moveq	#0,d4
		cmpi.w	#3,d7
		bhs.s	loc_369A
		moveq	#1,d4

loc_369A:
		moveq	#8-1,d5

loc_369C:
		movea.l	a2,a1
		eori.b	#1,d4
		bne.s	loc_36B0
		cmpi.w	#6,d7
		bne.s	loc_36C0
		lea	(v_start&$FFFFFF).l,a1

loc_36B0:
		movem.l	d0-d4,-(sp)
		moveq	#8-1,d1
		moveq	#8-1,d2
		bsr.w	TilemapToVRAM
		movem.l	(sp)+,d0-d4

loc_36C0:
		addi.l	#$100000,d0
		dbf	d5,loc_369C
		addi.l	#$3800000,d0
		eori.b	#1,d4
		dbf	d6,loc_369A
		addi.l	#$10000000,d3
		bpl.s	loc_36EA
		swap	d3
		addi.l	#$C000,d3
		swap	d3

loc_36EA:
		adda.w	#$80,a2
		dbf	d7,loc_368C
		lea	(v_start&$FFFFFF).l,a1
		lea	(Eni_SSBg2).l,a0
		move.w	#make_art_tile(ArtTile_SS_Background_Clouds,2,0),d0
		bsr.w	EniDec
		copyTilemap	v_start&$FFFFFF,vram_fg,64,32
		copyTilemap	v_start&$FFFFFF,vram_fg+$1000,64,64
		rts
; ---------------------------------------------------------------------------

SS_PalCycle:
		tst.w	(f_pause).w
		bmi.s	locret_37B4
		subq.w	#1,(v_palss_time).w
		bpl.s	locret_37B4
		lea	(vdp_control_port).l,a6
		move.w	(v_palss_num).w,d0
		addq.w	#1,(v_palss_num).w
		andi.w	#$1F,d0
		lsl.w	#2,d0
		lea	(byte_380A).l,a0
		adda.w	d0,a0
		move.b	(a0)+,d0
		bpl.s	loc_3760
		move.w	#$1FF,d0

loc_3760:
		move.w	d0,(v_palss_time).w
		moveq	#0,d0
		move.b	(a0)+,d0
		move.w	d0,(v_ssbganim).w
		lea	(byte_388A).l,a1
		lea	(a1,d0.w),a1
		move.w	#$8200,d0
		move.b	(a1)+,d0
		move.w	d0,(a6)
		move.b	(a1),(v_scrposy_dup).w
		move.w	#$8400,d0
		move.b	(a0)+,d0
		move.w	d0,(a6)
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_scrposy_dup).w,(vdp_data_port).l
		moveq	#0,d0
		move.b	(a0)+,d0
		bmi.s	loc_37B6
		lea	(Pal_SSCyc1).l,a1
		adda.w	d0,a1
		lea	(v_palette+$4E).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+

locret_37B4:
		rts
; ---------------------------------------------------------------------------

loc_37B6:
		move.w	(v_palss_index).w,d1
		cmpi.w	#$8A,d0
		blo.s	loc_37C2
		addq.w	#1,d1

loc_37C2:
		mulu.w	#$2A,d1
		lea	(Pal_SSCyc2).l,a1
		adda.w	d1,a1
		andi.w	#$7F,d0
		bclr	#0,d0
		beq.s	loc_37E6
		lea	(v_palette+$6E).w,a2
		move.l	(a1),(a2)+
		move.l	4(a1),(a2)+
		move.l	8(a1),(a2)+

loc_37E6:
		adda.w	#$C,a1
		lea	(v_palette+$5A).w,a2
		cmpi.w	#$A,d0
		blo.s	loc_37FC
		subi.w	#$A,d0
		lea	(v_palette+$7A).w,a2

loc_37FC:
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		adda.w	d0,a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		rts
; ---------------------------------------------------------------------------
SSBGData:	macro time,anim,vram,index,flag1,flag2
		dc.b	(time), (anim), ((vram)*tile_size)>>13
	if flag1
		dc.b	(index)|$80|(flag2)
	else
		dc.b	(index)*12
	endif
		endm

byte_380A:
		; Time, anim, BG VRAM, palette cycle index & flags
		SSBGData  3,  0, ArtTile_SS_Plane_6, 18, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_6, 16, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_6, 14, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_6, 12, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_6, 10, TRUE , TRUE

		SSBGData  3,  0, ArtTile_SS_Plane_6,  0, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_6,  2, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_6,  4, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_6,  6, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_6,  8, TRUE , FALSE


		SSBGData  7,  8, ArtTile_SS_Plane_6,  0, FALSE, FALSE
		SSBGData  7, 10, ArtTile_SS_Plane_6,  1, FALSE, FALSE
		SSBGData -1, 12, ArtTile_SS_Plane_6,  2, FALSE, FALSE
		SSBGData -1, 12, ArtTile_SS_Plane_6,  2, FALSE, FALSE
		SSBGData  7, 10, ArtTile_SS_Plane_6,  1, FALSE, FALSE
		SSBGData  7,  8, ArtTile_SS_Plane_6,  0, FALSE, FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_5,  8, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_5,  6, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_5,  4, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_5,  2, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_5,  0, TRUE , TRUE

		SSBGData  3,  0, ArtTile_SS_Plane_5, 10, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_5, 12, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_5, 14, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_5, 16, TRUE , FALSE
		SSBGData  3,  0, ArtTile_SS_Plane_5, 18, TRUE , FALSE

		SSBGData  7,  2, ArtTile_SS_Plane_5,  3, FALSE, FALSE
		SSBGData  7,  4, ArtTile_SS_Plane_5,  4, FALSE, FALSE
		SSBGData -1,  6, ArtTile_SS_Plane_5,  5, FALSE, FALSE
		SSBGData -1,  6, ArtTile_SS_Plane_5,  5, FALSE, FALSE
		SSBGData  7,  4, ArtTile_SS_Plane_5,  4, FALSE, FALSE
		SSBGData  7,  2, ArtTile_SS_Plane_5,  3, FALSE, FALSE
		even

SSFGData:	macro vram,y
		dc.b ((vram)*tile_size)>>10, (y)>>8
		endm

byte_388A:
		; FG VRAM, Y coordinate
		SSFGData ArtTile_SS_Plane_1, $100
		SSFGData ArtTile_SS_Plane_2,    0
		SSFGData ArtTile_SS_Plane_2, $100
		SSFGData ArtTile_SS_Plane_3,    0
		SSFGData ArtTile_SS_Plane_3, $100
		SSFGData ArtTile_SS_Plane_4,    0
		SSFGData ArtTile_SS_Plane_4, $100
		even

Pal_SSCyc1:	binclude "palette/Cycle - Special Stage 1.bin"
Pal_SSCyc2:	binclude "palette/Cycle - Special Stage 2.bin"
; ---------------------------------------------------------------------------

SS_AnimateBG:
		move.w	(v_ssbganim).w,d0
		bne.s	loc_39C4
		move.w	#0,(v_bgscreenposy).w
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w

loc_39C4:
		cmpi.w	#8,d0
		bhs.s	loc_3A1C
		cmpi.w	#6,d0
		bne.s	loc_39DE
		addq.w	#1,(v_bg3screenposx).w
		addq.w	#1,(v_bgscreenposy).w
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w

loc_39DE:
		moveq	#0,d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
		swap	d0
		lea	(byte_3A9A).l,a1
		lea	(v_ngfx_buffer).w,a3
		moveq	#$A-1,d3

loc_39F4:
		move.w	2(a3),d0
		bsr.w	CalcSine
		moveq	#0,d2
		move.b	(a1)+,d2
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,(a3)+
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d2,(a3)+
		dbf	d3,loc_39F4
		lea	(v_ngfx_buffer).w,a3
		lea	(byte_3A86).l,a2
		bra.s	loc_3A4C
; ---------------------------------------------------------------------------

loc_3A1C:
		cmpi.w	#$C,d0
		bne.s	loc_3A42
		subq.w	#1,(v_bg3screenposx).w
		lea	(v_ssscroll_buffer).w,a3
		move.l	#$18000,d2
		moveq	#7-1,d1

loc_3A32:
		move.l	(a3),d0
		sub.l	d2,d0
		move.l	d0,(a3)+
		subi.l	#$2000,d2
		dbf	d1,loc_3A32

loc_3A42:
		lea	(v_ssscroll_buffer).w,a3
		lea	(byte_3A92).l,a2

loc_3A4C:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
		swap	d0
		moveq	#0,d3
		move.b	(a2)+,d3
		move.w	(v_bgscreenposy).w,d2
		neg.w	d2
		andi.w	#$FF,d2
		lsl.w	#2,d2

loc_3A68:
		move.w	(a3)+,d0
		addq.w	#2,a3
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.w	#1,d1

loc_3A72:
		move.l	d0,(a1,d2.w)
		addq.w	#4,d2
		andi.w	#$3FC,d2
		dbf	d1,loc_3A72
		dbf	d3,loc_3A68
		rts
; ---------------------------------------------------------------------------
byte_3A86:	dc.b 9, $28, $18, $10, $28, $18, $10, $30, $18, 8, $10
		even
byte_3A92:	dc.b 6, $30, $30, $30, $28, $18, $18, $18
		even
byte_3A9A:	dc.b 8, 2, 4, $FF, 2, 3, 8, $FF, 4, 2, 2, 3, 8, $FD, 4
		dc.b 2, 2, 3, 2, $FF
		even
; ---------------------------------------------------------------------------
		include "include/LevelSizeLoad & BgScrollSpeed.asm"
		include "include/DeformLayers.asm"
		include	"include/Level Drawing.asm"
; ---------------------------------------------------------------------------

LoadLevelData:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		addq.l	#4,a2
		movea.l	(a2)+,a0
		lea	(v_16x16).w,a4
		move.w	#bytesToLcnt(v_16x16_end-v_16x16),d0

.loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,.loadblocks
		movea.l	(a2)+,a0
		lea	(v_256x256&$FFFFFF).l,a1
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad
		move.w	(a2)+,d0
		move.w	(a2),d0
		andi.w	#$FF,d0
		bsr.w	PalLoad1
		movea.l	(sp)+,a2
		addq.w	#4,a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	.skipPLC
		bsr.w	AddPLC

.skipPLC:
		rts
; ---------------------------------------------------------------------------
;sub_485C:
		moveq	#0,d0
		move.b	(v_lives).w,d1
		cmpi.b	#2,d1
		blo.s	loc_4876
		move.b	d1,d0
		subq.b	#1,d0
		cmpi.b	#5,d0
		blo.s	loc_4876
		move.b	#4,d0

loc_4876:
		lea	(vdp_data_port).l,a6
		locVRAM window_plane+$CBE
		move.l	#($8500+(vram_sprite1>>9))<<16|$8500+(vram_sprite2>>9),d2
		bsr.s	sub_489E
		locVRAM window_plane+$D3E
		move.l	#($8500+(vram_sprite3>>9))<<16|$8500+(vram_sprite4>>9),d2

sub_489E:
		moveq	#0,d3
		moveq	#4-1,d1
		sub.w	d0,d1
		blo.s	loc_48AC

loc_48A6:
		move.l	d3,(a6)
		dbf	d1,loc_48A6

loc_48AC:
		move.w	d0,d1
		subq.w	#1,d1
		blo.s	locret_48B8

loc_48B2:
		move.l	d2,(a6)
		dbf	d1,loc_48B2

locret_48B8:
		rts
; ---------------------------------------------------------------------------

LevelLayoutLoad:
		lea	(v_lvllayout).w,a3
	if FixBugs
		move.w	#bytesToLcnt(v_lvllayout_end-v_lvllayout),d1
	else
		; Bug: This clears too much data!
		move.w	#bytesToWcnt(v_lvllayout_end-v_lvllayout),d1
	endif
		moveq	#0,d0

loc_48C4:
		move.l	d0,(a3)+
		dbf	d1,loc_48C4
		lea	(v_lvllayout).w,a3
		moveq	#0,d1
		bsr.w	sub_48DA
		lea	(v_lvllayoutbg).w,a3
		moveq	#2,d1

sub_48DA:
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0
		add.w	d1,d0
		lea	(LayoutArray).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1
		move.b	(a1)+,d2

loc_4900:
		move.w	d1,d0
		movea.l	a3,a0

loc_4904:
		move.b	(a1)+,(a0)+
		dbf	d0,loc_4904
		lea	layoutsize*2(a3),a3
		dbf	d2,loc_4900
		rts
; ---------------------------------------------------------------------------
		include "include/DynamicLevelEvents.asm"

		include "obj/02.asm"
Map_02:	include "_maps/02.asm"

		include "obj/03.asm"
		include "obj/04.asm"
		include "obj/05.asm"
Map_05:	include "_maps/05.asm"

		include "obj/06.asm"
		include "obj/07.asm"
		include "obj/11 Bridge (part 1).asm"
; ---------------------------------------------------------------------------

PtfmBridge:
		moveq	#0,d1
		move.b	obSubtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	locret_5048
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		cmp.w	d2,d0
		bhs.w	locret_5048
		bra.s	PtfmNormal2
; ---------------------------------------------------------------------------

PtfmNormal:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	locret_5048
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	locret_5048

PtfmNormal2:
		move.w	obY(a0),d0
		subq.w	#8,d0

PtfmNormal3:
		move.w	obY(a1),d2
		move.b	obHeight(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.w	locret_5048
		cmpi.w	#-$10,d0
		blo.w	locret_5048
		cmpi.b	#6,obRoutine(a1)
		bhs.w	locret_5048
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,obY(a1)
		addq.b	#2,obRoutine(a0)

loc_4FD4:
		btst	#3,obStatus(a1)
		beq.s	loc_4FFC
		moveq	#0,d0
		move.b	standonobject(a1),d0
		lsl.w	#object_size_bits,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a2
		cmpi.b	#4,obRoutine(a2)
		bne.s	loc_4FFC
		subq.b	#2,obRoutine(a2)
		clr.b	ob2ndRout(a2)

loc_4FFC:
		move.w	a0,d0
		subi.w	#v_objspace,d0
		lsr.w	#object_size_bits,d0
		andi.w	#$7F,d0
		move.b	d0,standonobject(a1)
		move.b	#0,obAngle(a1)
		move.w	#0,obVelY(a1)
		move.w	obVelX(a1),d0
		asr.w	#2,d0
		sub.w	d0,obVelX(a1)
		move.w	obVelX(a1),obInertia(a1)
		btst	#status_in_air,obStatus(a1)
		beq.s	loc_503C
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(Sonic_ResetOnFloor).l
		movea.l	(sp)+,a0

loc_503C:
		bset	#3,obStatus(a1)
		bset	#3,obStatus(a0)

locret_5048:
		rts
; ---------------------------------------------------------------------------

PtfmSloped:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	locret_5048
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.s	locret_5048
		btst	#0,obRender(a0)
		beq.s	loc_5074
		not.w	d0
		add.w	d1,d0

loc_5074:
		lsr.w	#1,d0
		moveq	#0,d3
		move.b	(a2,d0.w),d3
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	PtfmNormal3
; ---------------------------------------------------------------------------

PtfmNormalHeight:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	locret_5048
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	locret_5048
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	PtfmNormal3

		include "obj/11 Bridge (part 2).asm"
; ---------------------------------------------------------------------------

PtfmCheckExit:
		move.w	d1,d2

PtfmCheckExit2:
		add.w	d2,d2
		lea	(v_player).w,a1
		btst	#status_in_air,obStatus(a1)
		bne.s	loc_510A
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_510A
		cmp.w	d2,d0
		blo.s	locret_511C

loc_510A:
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a0)
		bclr	#3,obStatus(a0)

locret_511C:
		rts

		include "obj/11 Bridge (part 3).asm"
MapBridge:	include "_maps/Bridge.asm"

		include "obj/15 Swinging Platform.asm"
Map_Swing_GHZ:	include "_maps/Swinging Platforms (GHZ).asm"
Map_Swing_SLZ:	include "_maps/Swinging Platforms (SLZ).asm"

		include "obj/17 Spiked Pole Helix.asm"
Map_Hel:	include "_maps/Spiked Pole Helix.asm"

		include "obj/18 Platforms.asm"
		include "_maps/Platforms (unused).asm"
Map_Plat_GHZ:	include "_maps/Platforms (GHZ).asm"
Map_Plat_SZ:	include "_maps/Platforms (SZ).asm"
Map_Plat_SLZ:	include "_maps/Platforms (SLZ).asm"

		include "obj/19 GHZ Ball.asm"
Map_GBall:	include "_maps/GHZ Ball.asm"

		include "obj/1A Collapsing Ledge (part 1).asm"
		include "obj/53 Collapsing Floors.asm"
; ---------------------------------------------------------------------------

loc_612A:
		move.b	#0,ledge_collapse_flag(a0)

loc_6130:
		lea	(CFlo_Data1).l,a4
		moveq	#25-1,d1
		addq.b	#2,obFrame(a0)

loc_613C:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		add.w	d0,d0
		movea.l	obMap(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,obRender(a0)
		_move.b	obID(a0),d4
		move.b	obRender(a0),d5
		movea.l	a0,a1
		bra.s	loc_6168
; ---------------------------------------------------------------------------

loc_6160:
		bsr.w	FindFreeObj
		bne.s	loc_61A8
		addq.w	#5,a3

loc_6168:
		move.b	#6,obRoutine(a1)
		_move.b	d4,obID(a1)
		move.l	a3,obMap(a1)
		move.b	d5,obRender(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.b	obPriority(a0),obPriority(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.b	(a4)+,ledge_timedelay(a1)
		cmpa.l	a0,a1
		bhs.s	loc_61A4
		bsr.w	DisplaySprite1

loc_61A4:
		dbf	d1,loc_6160

loc_61A8:
		bsr.w	DisplaySprite
		move.w	#sfx_Collapse,d0
		jmp	(PlaySound_Special).l
; ---------------------------------------------------------------------------

CFlo_Data1:	dc.b $1C, $18, $14, $10, $1A, $16, $12, $E, $A, 6, $18
		dc.b $14, $10, $C, 8, 4, $16, $12, $E, $A, 6, 2, $14, $10
		dc.b $C
		even
CFlo_Data2:	dc.b $1E, $16, $E, 6, $1A, $12, $A, 2
		even
CFlo_Data3:	dc.b $16, $1E, $1A, $12, 6, $E, $A, 2
		even
; ---------------------------------------------------------------------------

sub_61E0:
		lea	(v_player).w,a1
		btst	#3,obStatus(a1)
		beq.s	locret_6224
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		lsr.w	#1,d0
		btst	#0,obRender(a0)
		beq.s	loc_6204
		not.w	d0
		add.w	d1,d0

loc_6204:
		moveq	#0,d1
		move.b	(a2,d0.w),d1
		move.w	obY(a0),d0
		sub.w	d1,d0
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		sub.w	obX(a0),d2
		sub.w	d2,obX(a1)

locret_6224:
		rts
; ---------------------------------------------------------------------------

ObjCollapsePtfm_Slope:dc.b $20, $20, $20, $20, $20, $20, $20, $20, $21, $21
		dc.b $22, $22, $23, $23, $24, $24, $25, $25, $26, $26
		dc.b $27, $27, $28, $28, $29, $29, $2A, $2A, $2B, $2B
		dc.b $2C, $2C, $2D, $2D, $2E, $2E, $2F, $2F, $30, $30
		dc.b $30, $30, $30, $30, $30, $30, $30, $30
		even

		include "_maps/Collapsing Ledge (Unused).asm"
Map_Ledge:	include "_maps/Collapsing Ledge.asm"
Map_CFlo:	include "_maps/Collapsing Floors.asm"

		include "obj/1B.asm"
Map_1B:	include "_maps/1B.asm"

		include "obj/1C Scenery.asm"
Map_Scen:	include "_maps/Scenery.asm"

		include "obj/1D Unused Switch.asm"
Map_UnkSwitch:	include "_maps/Unknown Switch.asm"

		include "obj/2A Switch Door.asm"
; ---------------------------------------------------------------------------

sub_6936:
		tst.w	(v_debuguse).w
		bne.w	locret_69A6
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	locret_69A6
		bsr.w	Obj44_SolidWall2
		beq.s	loc_698C
		bmi.w	loc_69A8
		tst.w	d0
		beq.w	loc_6976
		bmi.s	loc_6960
		tst.w	obVelX(a1)
		bmi.s	loc_6976
		bra.s	loc_6966
; ---------------------------------------------------------------------------

loc_6960:
		tst.w	obVelX(a1)
		bpl.s	loc_6976

loc_6966:
		sub.w	d0,obX(a1)
		move.w	#0,obInertia(a1)
		move.w	#0,obVelX(a1)

loc_6976:
		btst	#status_in_air,obStatus(a1)
		bne.s	loc_699A
		bset	#5,obStatus(a1)
		bset	#5,obStatus(a0)
		rts
; ---------------------------------------------------------------------------

loc_698C:
		btst	#5,obStatus(a0)
		beq.s	locret_69A6
		move.w	#id_Run,obAnim(a1)	; and obNextAni

loc_699A:
		bclr	#5,obStatus(a0)
		bclr	#5,obStatus(a1)

locret_69A6:
		rts
; ---------------------------------------------------------------------------

loc_69A8:
		tst.w	obVelY(a1)
		beq.s	loc_69C0
		bpl.s	locret_69BE
		tst.w	d3
		bpl.s	locret_69BE
		sub.w	d3,obY(a1)
		move.w	#0,obVelY(a1)

locret_69BE:
		rts
; ---------------------------------------------------------------------------

loc_69C0:
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(loc_FD78).l
		movea.l	(sp)+,a0
		rts
; ---------------------------------------------------------------------------

Obj44_SolidWall2:
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_6A28
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_6A28
		move.b	obHeight(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	obY(a1),d3
		sub.w	obY(a0),d3
		add.w	d2,d3
		bmi.s	loc_6A28
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bhs.s	loc_6A28
		move.w	d0,d5
		cmp.w	d0,d1
		bhs.s	loc_6A10
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_6A10:
		move.w	d3,d1
		cmp.w	d3,d2
		bhs.s	loc_6A1C
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_6A1C:
		cmp.w	d1,d5
		bhi.s	loc_6A24
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_6A24:
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_6A28:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------
Map_2A:	include "_maps/2A.asm"

		include "obj/0E Title Screen Sonic.asm"
		include "obj/0F Press Start.asm"
		include "_anim/Title Screen Sonic.asm"
		include "_anim/Press Start.asm"
; ---------------------------------------------------------------------------

AnimateSprite:
		moveq	#0,d0
		move.b	obAnim(a0),d0
		cmp.b	obNextAni(a0),d0
		beq.s	loc_6B54
		move.b	d0,obNextAni(a0)
		move.b	#0,obAniFrame(a0)
		move.b	#0,obTimeFrame(a0)

loc_6B54:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		subq.b	#1,obTimeFrame(a0)
		bpl.s	locret_6B94
		move.b	(a1),obTimeFrame(a0)
		moveq	#0,d1
		move.b	obAniFrame(a0),d1
		move.b	1(a1,d1.w),d0
		bmi.s	loc_6B96

loc_6B70:
		move.b	d0,d1
		andi.b	#$1F,d0
		move.b	d0,obFrame(a0)
		move.b	obStatus(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,obRender(a0)
		lsr.b	#5,d1
		eor.b	d0,d1
		or.b	d1,obRender(a0)
		addq.b	#1,obAniFrame(a0)

locret_6B94:
		rts
; ---------------------------------------------------------------------------

loc_6B96:
		addq.b	#1,d0
		bne.s	loc_6BA6
		move.b	#0,obAniFrame(a0)
		move.b	obRender(a1),d0
		bra.s	loc_6B70
; ---------------------------------------------------------------------------

loc_6BA6:
		addq.b	#1,d0
		bne.s	loc_6BBA
		move.b	2(a1,d1.w),d0
		sub.b	d0,obAniFrame(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	loc_6B70
; ---------------------------------------------------------------------------

loc_6BBA:
		addq.b	#1,d0
		bne.s	loc_6BC4
		move.b	2(a1,d1.w),obAnim(a0)

loc_6BC4:
		addq.b	#1,d0
		bne.s	loc_6BCC
		addq.b	#2,obRoutine(a0)

loc_6BCC:
		addq.b	#1,d0
		bne.s	locret_6BDA
		move.b	#0,obAniFrame(a0)
		clr.b	ob2ndRout(a0)

locret_6BDA:
		rts
; ---------------------------------------------------------------------------
Map_TitleText:	include "_maps/Press Start.asm"
Map_TitleSonic:	include "_maps/Title Screen Sonic.asm"

		include "obj/1E Ball Hog.asm"
		include "obj/20 Ball Hog's Bomb.asm"
		include "obj/24, 27 & 3F Explosions.asm"
		include "_anim/Ball Hog.asm"
Map_Hog:	include "_maps/Ball Hog.asm"
		include "_maps/Ball Hog's Bomb.asm"
		include "_maps/Ball Hog's Bomb Explosion.asm"
		include "_maps/Explosions.asm"

		include "obj/28 Animals.asm"
		include "obj/29 Points.asm"
Map_Animal1:	include "_maps/Animals 1.asm"
Map_Animal2:	include "_maps/Animals 2.asm"
Map_Animal3:	include "_maps/Animals 3.asm"
Map_Poi:	include "_maps/Points.asm"

		include "obj/1F Crabmeat.asm"
		include "_anim/Crabmeat.asm"
Map_Crab:	include "_maps/Crabmeat.asm"

		include "obj/22 Buzz Bomber.asm"
		include "obj/23 Buzz Bomber Missile.asm"
		include "_anim/Buzz Bomber.asm"
		include "_anim/Buzz Bomber Missile.asm"
Map_Buzz:	include "_maps/Buzz Bomber.asm"
Map_Missile:	include "_maps/Buzz Bomber Missile.asm"

		include "obj/25 & 37 Rings.asm"
		include "obj/4B Giant Ring Flash.asm"
		include "_anim/Rings.asm"
Map_Ring:	include "_maps/Rings.asm"
Map_GRing:	include "_maps/Giant Ring.asm"

		include "obj/26 Monitor.asm"
		include "obj/2E Monitor Content Power-Up.asm"
		include "obj/26 Monitor (SolidSides subroutine).asm"
		include "_anim/Monitor.asm"
Map_Monitor:	include "_maps/Monitor.asm"
; ---------------------------------------------------------------------------

ExecuteObjects:
		lea	(v_objspace).w,a0
		moveq	#bytesToXcnt(v_objspace_end-v_objspace,object_size),d7
		moveq	#0,d0
		cmpi.b	#6,(v_player+obRoutine).w	; has sonic died?
		bhs.s	loc_8560			; if so, branch

sub_8546:
		move.b	obID(a0),d0
		beq.s	loc_8556
		add.w	d0,d0
		add.w	d0,d0
		movea.l	Obj_Index-4(pc,d0.w),a1
		jsr	(a1)
		moveq	#0,d0

loc_8556:
		lea	object_size(a0),a0
		dbf	d7,sub_8546
		rts
; ---------------------------------------------------------------------------

loc_8560:
		moveq	#bytesToXcnt(v_lvlobjspace-v_objspace,object_size),d7
		bsr.s	sub_8546
		moveq	#bytesToXcnt(v_lvlobjend-v_lvlobjspace,object_size),d7

loc_8566:
		moveq	#0,d0
		move.b	obID(a0),d0
		beq.s	loc_8576
		tst.b	obRender(a0)
		bpl.s	loc_8576
		bsr.w	DisplaySprite

loc_8576:
		lea	object_size(a0),a0
		dbf	d7,loc_8566
		rts
; ---------------------------------------------------------------------------
Obj_Index:
		include "include/Object Pointers.asm"
		include "obj/sub ObjectFall.asm"
		include "obj/sub SpeedToPos.asm"
		include "obj/sub DisplaySprite.asm"
		include "obj/sub DeleteObject.asm"
; ---------------------------------------------------------------------------

off_8796:	dc.l 0
		dc.l v_screenposx&$FFFFFF
		dc.l v_bgscreenposx&$FFFFFF
		dc.l v_bg3screenposx&$FFFFFF
; ---------------------------------------------------------------------------

BuildSprites:
		lea	(v_spritetablebuffer).w,a2
		moveq	#0,d5
		lea	(v_spritequeue).w,a4
		moveq	#7,d7

loc_87B2:
		tst.w	(a4)
		beq.w	loc_8876
		moveq	#2,d6

loc_87BA:
		movea.w	(a4,d6.w),a0
		tst.b	obID(a0)
		beq.w	loc_886E
		bclr	#7,obRender(a0)
		move.b	obRender(a0),d0
		move.b	d0,d4
		andi.w	#$C,d0
		beq.s	loc_8826
		movea.l	off_8796(pc,d0.w),a1
		moveq	#0,d0
		move.b	obActWid(a0),d0
		move.w	obX(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_886E
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#320,d1
		bge.s	loc_886E
		addi.w	#128,d3
		btst	#4,d4
		beq.s	loc_8830
		moveq	#0,d0
		move.b	obHeight(a0),d0
		move.w	obY(a0),d2
		sub.w	obMap(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	loc_886E
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#224,d1
		bge.s	loc_886E
		addi.w	#128,d2
		bra.s	loc_8848
; ---------------------------------------------------------------------------

loc_8826:
		move.w	obScreenY(a0),d2
		move.w	obX(a0),d3
		bra.s	loc_8848
; ---------------------------------------------------------------------------

loc_8830:
		move.w	obY(a0),d2
		sub.w	obMap(a1),d2
		addi.w	#128,d2
		cmpi.w	#320/2-64,d2
		blo.s	loc_886E
		cmpi.w	#320+64,d2
		bhs.s	loc_886E

loc_8848:
		movea.l	obMap(a0),a1
		moveq	#0,d1
		btst	#5,d4
		bne.s	loc_8864
		move.b	obFrame(a0),d1
		add.b	d1,d1
		adda.w	(a1,d1.w),a1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_8868

loc_8864:
		bsr.w	sub_8898

loc_8868:
		bset	#7,obRender(a0)

loc_886E:
		addq.w	#2,d6
		subq.w	#2,(a4)
		bne.w	loc_87BA

loc_8876:
		lea	$80(a4),a4
		dbf	d7,loc_87B2
		move.b	d5,(v_spritecount).w
		cmpi.b	#80,d5
		beq.s	loc_8890
		move.l	#0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_8890:
		move.b	#0,-5(a2)
		rts
; ---------------------------------------------------------------------------

sub_8898:
		movea.w	obGfx(a0),a3
		btst	#0,d4
		bne.s	loc_88DE
		btst	#1,d4
		bne.w	loc_892C

sub_88AA:
		cmpi.b	#80,d5
		beq.s	locret_88DC
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_88D6
		addq.w	#1,d0

loc_88D6:
		move.w	d0,(a2)+
		dbf	d1,sub_88AA

locret_88DC:
		rts
; ---------------------------------------------------------------------------

loc_88DE:
		btst	#1,d4
		bne.w	loc_8972

loc_88E6:
		cmpi.b	#80,d5
		beq.s	locret_892A
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$800,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_8924
		addq.w	#1,d0

loc_8924:
		move.w	d0,(a2)+
		dbf	d1,loc_88E6

locret_892A:
		rts
; ---------------------------------------------------------------------------

loc_892C:
		cmpi.b	#80,d5
		beq.s	locret_8970
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_896A
		addq.w	#1,d0

loc_896A:
		move.w	d0,(a2)+
		dbf	d1,loc_892C

locret_8970:
		rts
; ---------------------------------------------------------------------------

loc_8972:
		cmpi.b	#80,d5
		beq.s	locret_89C4
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_89BE
		addq.w	#1,d0

loc_89BE:
		move.w	d0,(a2)+
		dbf	d1,loc_8972

locret_89C4:
		rts
; ---------------------------------------------------------------------------

ObjectChkOffscreen:
		move.w	obX(a0),d0
		sub.w	(v_screenposx).w,d0
		bmi.s	.offscreen
		cmpi.w	#320,d0
		bge.s	.offscreen
		move.w	obY(a0),d1
		sub.w	(v_screenposy).w,d1
		bmi.s	.offscreen
		cmpi.w	#224,d1
		bge.s	.offscreen
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

.offscreen:
		moveq	#1,d0
		rts
; ---------------------------------------------------------------------------

ObjPosLoad:
		moveq	#0,d0
		move.b	(v_opl_routine).w,d0
		move.w	off_89FC(pc,d0.w),d0
		jmp	off_89FC(pc,d0.w)
; ---------------------------------------------------------------------------

off_89FC:	dc.w loc_8A00-off_89FC, loc_8A44-off_89FC
; ---------------------------------------------------------------------------

loc_8A00:
		addq.b	#2,(v_opl_routine).w
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1
		adda.w	(a0,d0.w),a0
		move.l	a0,(v_opl_data).w
		move.l	a0,(v_opl_data+4).w
		adda.w	2(a1,d0.w),a1
		move.l	a1,(v_opl_data+8).w
		move.l	a1,(v_opl_data+$C).w
		lea	(v_objstate).w,a2
		move.w	#$101,(a2)+
	if FixBugs
		move.w	#bytesToLcnt(v_objstate_end-v_objstate-2),d0
	else
		; Bug: This does word when it should be doing longword and the last 2 bytes of v_objstate are not accounted for.
		move.w	#bytesToWcnt(v_objstate_end-v_objstate-2),d0
	endif

loc_8A38:
		clr.l	(a2)+
		dbf	d0,loc_8A38
	if FixBugs
		clr.w	(a2)+
	endif
		move.w	#-1,(v_opl_screen).w

loc_8A44:
		lea	(v_objstate).w,a2
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		andi.w	#-$80,d6
		cmp.w	(v_opl_screen).w,d6
		beq.w	locret_8B20
		bge.s	loc_8ABA
		move.w	d6,(v_opl_screen).w
		movea.l	(v_opl_data+4).w,a0
		subi.w	#$80,d6
		blo.s	loc_8A96

loc_8A6A:
		cmp.w	-6(a0),d6
		bge.s	loc_8A96
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.s	loc_8A80
		subq.b	#1,1(a2)
		move.b	1(a2),d2

loc_8A80:
		bsr.w	sub_8B22
		bne.s	loc_8A8A
		subq.w	#6,a0
		bra.s	loc_8A6A
; ---------------------------------------------------------------------------

loc_8A8A:
		tst.b	4(a0)
		bpl.s	loc_8A94
		addq.b	#1,1(a2)

loc_8A94:
		addq.w	#6,a0

loc_8A96:
		move.l	a0,(v_opl_data+4).w
		movea.l	(v_opl_data).w,a0
		addi.w	#$300,d6

loc_8AA2:
		cmp.w	-6(a0),d6
		bgt.s	loc_8AB4
		tst.b	-2(a0)
		bpl.s	loc_8AB0
		subq.b	#1,(a2)

loc_8AB0:
		subq.w	#6,a0
		bra.s	loc_8AA2
; ---------------------------------------------------------------------------

loc_8AB4:
		move.l	a0,(v_opl_data).w
		rts
; ---------------------------------------------------------------------------

loc_8ABA:
		move.w	d6,(v_opl_screen).w
		movea.l	(v_opl_data).w,a0
		addi.w	#$280,d6

loc_8AC6:
		cmp.w	(a0),d6
		bls.s	loc_8ADA
		tst.b	4(a0)
		bpl.s	loc_8AD4
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_8AD4:
		bsr.w	sub_8B22
		beq.s	loc_8AC6

loc_8ADA:
		move.l	a0,(v_opl_data).w
		movea.l	(v_opl_data+4).w,a0
		subi.w	#$300,d6
		blo.s	loc_8AFA

loc_8AE8:
		cmp.w	(a0),d6
		bls.s	loc_8AFA
		tst.b	4(a0)
		bpl.s	loc_8AF6
		addq.b	#1,1(a2)

loc_8AF6:
		addq.w	#6,a0
		bra.s	loc_8AE8
; ---------------------------------------------------------------------------

loc_8AFA:
		move.l	a0,(v_opl_data+4).w
		rts
; ---------------------------------------------------------------------------

loc_8B00:
		movea.l	(v_opl_data+8).w,a0
		move.w	(v_bg3screenposx).w,d0
		addi.w	#$200,d0
		andi.w	#-$80,d0
		cmp.w	(a0),d0
		blo.s	locret_8B20
		bsr.w	sub_8B22
		move.l	a0,(v_opl_data+8).w
		bra.w	loc_8B00
; ---------------------------------------------------------------------------

locret_8B20:
		rts
; ---------------------------------------------------------------------------

sub_8B22:
		tst.b	4(a0)
		bpl.s	loc_8B36
		bset	#7,2(a2,d2.w)
		beq.s	loc_8B36
		addq.w	#6,a0
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_8B36:
		bsr.w	FindFreeObj
		bne.s	locret_8B70
		move.w	(a0)+,obX(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		move.w	d0,obY(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,obRender(a1)
		move.b	d1,obStatus(a1)
		move.b	(a0)+,d0
		bpl.s	loc_8B66
		andi.b	#$7F,d0
		move.b	d2,obRespawnNo(a1)

loc_8B66:
		_move.b	d0,obID(a1)
		move.b	(a0)+,obSubtype(a1)
		moveq	#0,d0

locret_8B70:
		rts
; ---------------------------------------------------------------------------

FindFreeObj:
		lea	(v_lvlobjspace).w,a1
		move.w	#bytesToXcnt(v_lvlobjend-v_lvlobjspace,object_size),d0

loc_8B7A:
		tst.b	obID(a1)
		beq.s	locret_8B86
		lea	object_size(a1),a1
		dbf	d0,loc_8B7A

locret_8B86:
		rts
; ---------------------------------------------------------------------------

FindNextFreeObj:
		movea.l	a0,a1
		move.w	#v_lvlobjend,d0
		sub.w	a0,d0
		lsr.w	#object_size_bits,d0
		subq.w	#1,d0
		blo.s	locret_8BA2

loc_8B96:
		tst.b	obID(a1)
		beq.s	locret_8BA2
		lea	object_size(a1),a1
		dbf	d0,loc_8B96

locret_8BA2:
		rts

		include "obj/2B Chopper.asm"
		include "_anim/Chopper.asm"
Map_Chop:	include "_maps/Chopper.asm"

		include "obj/2C Jaws.asm"
		include "_anim/Jaws.asm"
Map_Jaws:	include "_maps/Jaws.asm"

		include "obj/2D Burrobot.asm"
		include "_anim/Burrobot.asm"
Map_Burro:	include "_maps/Burrobot.asm"

		include "obj/2F MZ Large Grassy Platforms.asm"

		include "obj/35 Burning Grass.asm"
		include "_anim/Burning Grass.asm"
Map_LGrass:	include "_maps/MZ Large Grassy Platforms.asm"
Map_Fire:	include "_maps/Fireballs.asm"

		include "obj/30 MZ Large Green Glass Blocks.asm"
Map_Glass:	include "_maps/MZ Large Green Glass Blocks.asm"

		include "obj/31 Chained Stompers.asm"
		include "obj/45 Sideways Stomper.asm"
Map_CStom:	include "_maps/Chained Stompers.asm"
Map_SStom:	include "_maps/Sideways Stomper.asm"

		include "obj/32 Button.asm"
Map_But:	include "_maps/Button.asm"

		include "obj/33 Pushable Blocks.asm"
Map_Push:	include "_maps/Pushable Blocks.asm"

		include "obj/sub SolidObject.asm"

		include "obj/34 Title Cards.asm"
		include "obj/39 Game Over.asm"
		include "obj/3A Got Through Act.asm"

Map_TitleCard:	dc.w byte_A8A4-Map_TitleCard, byte_A8D2-Map_TitleCard, byte_A900-Map_TitleCard
		dc.w byte_A920-Map_TitleCard, byte_A94E-Map_TitleCard, byte_A97C-Map_TitleCard
		dc.w byte_A9A6-Map_TitleCard, byte_A9BC-Map_TitleCard, byte_A9C7-Map_TitleCard
		dc.w byte_A9D2-Map_TitleCard, byte_A9DD-Map_TitleCard
byte_A8A4:	dc.b 9
		dc.b $F8, 5, 0, $18, $B4
		dc.b $F8, 5, 0, $3A, $C4
		dc.b $F8, 5, 0, $10, $D4
		dc.b $F8, 5, 0, $10, $E4
		dc.b $F8, 5, 0, $2E, $F4
		dc.b $F8, 5, 0, $1C, $14
		dc.b $F8, 1, 0, $20, $24
		dc.b $F8, 5, 0, $26, $2C
		dc.b $F8, 5, 0, $26, $3C
byte_A8D2:	dc.b 9
		dc.b $F8, 5, 0, $26, $BC
		dc.b $F8, 5, 0, 0, $CC
		dc.b $F8, 5, 0, 4, $DC
		dc.b $F8, 5, 0, $4A, $EC
		dc.b $F8, 5, 0, $3A, $FC
		dc.b $F8, 1, 0, $20, $C
		dc.b $F8, 5, 0, $2E, $14
		dc.b $F8, 5, 0, $42, $24
		dc.b $F8, 5, 0, $1C, $34
byte_A900:	dc.b 6
		dc.b $F8, 5, 0, $2A, $CF
		dc.b $F8, 5, 0, 0, $E0
		dc.b $F8, 5, 0, $3A, $F0
		dc.b $F8, 5, 0, 4, 0
		dc.b $F8, 5, 0, $26, $10
		dc.b $F8, 5, 0, $10, $20
		even
byte_A920:	dc.b 9
		dc.b $F8, 5, 0, $3E, $B4
		dc.b $F8, 5, 0, $42, $C4
		dc.b $F8, 5, 0, 0, $D4
		dc.b $F8, 5, 0, $3A, $E4
		dc.b $F8, 5, 0, $26, 4
		dc.b $F8, 1, 0, $20, $14
		dc.b $F8, 5, 0, $18, $1C
		dc.b $F8, 5, 0, $1C, $2C
		dc.b $F8, 5, 0, $42, $3C
byte_A94E:	dc.b 9
		dc.b $F8, 5, 0, $3E, $BC
		dc.b $F8, 5, 0, $36, $CC
		dc.b $F8, 5, 0, 0, $DC
		dc.b $F8, 5, 0, $3A, $EC
		dc.b $F8, 5, 0, $22, $FC
		dc.b $F8, 5, 0, $26, $C
		dc.b $F8, 1, 0, $20, $1C
		dc.b $F8, 5, 0, $2E, $24
		dc.b $F8, 5, 0, $18, $34
byte_A97C:	dc.b 8
		dc.b $F8, 5, 0, 8, $B0
		dc.b $F8, 5, 0, $26, $C0
		dc.b $F8, 5, 0, $32, $D0
		dc.b $F8, 5, 0, 8, $E0
		dc.b $F8, 5, 0, $22, $F0
		dc.b $F8, 5, 0, $32, $20
		dc.b $F8, 5, 0, $3A, $30
		dc.b $F8, 5, 0, $22, $40
		even
byte_A9A6:	dc.b 4
		dc.b $F8, 5, 0, $4E, $E0
		dc.b $F8, 5, 0, $32, $F0
		dc.b $F8, 5, 0, $2E, 0
		dc.b $F8, 5, 0, $10, $10
		even
byte_A9BC:	dc.b 2
		dc.b 4, $C, 0, $53, $EC
		dc.b $F4, 2, 0, $57, $C
byte_A9C7:	dc.b 2
		dc.b 4, $C, 0, $53, $EC
		dc.b $F4, 6, 0, $5A, 8
byte_A9D2:	dc.b 2
		dc.b 4, $C, 0, $53, $EC
		dc.b $F4, 6, 0, $60, 8
byte_A9DD:	dc.b $D
		dc.b $E4, $C, 0, $70, $F4
		dc.b $E4, 2, 0, $74, $14
		dc.b $EC, 4, 0, $77, $EC
		dc.b $F4, 5, 0, $79, $E4
		dc.b $14, $C, $18, $70, $EC
		dc.b 4, 2, $18, $74, $E4
		dc.b $C, 4, $18, $77, 4
		dc.b $FC, 5, $18, $79, $C
		dc.b $EC, 8, 0, $7D, $FC
		dc.b $F4, $C, 0, $7C, $F4
		dc.b $FC, 8, 0, $7C, $F4
		dc.b 4, $C, 0, $7C, $EC
		dc.b $C, 8, 0, $7C, $EC
		even

Map_Over:	include "_maps/Game Over.asm"

; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC HAS PASSED" title card
; ---------------------------------------------------------------------------
Map_Got:	dc.w M_Got_SonicHas-Map_Got
		dc.w byte_AA75-Map_Got
		dc.w byte_AA94-Map_Got
		dc.w byte_AAB3-Map_Got
		dc.w byte_AAD7-Map_Got
		dc.w byte_A9DD-Map_Got
		dc.w byte_A9BC-Map_Got
		dc.w byte_A9C7-Map_Got
		dc.w byte_A9D2-Map_Got
M_Got_SonicHas:	dc.b 8
		dc.b $F8, 5, 0, $3E, $B8
		dc.b $F8, 5, 0, $32, $C8
		dc.b $F8, 5, 0, $2E, $D8
		dc.b $F8, 1, 0, $20, $E8
		dc.b $F8, 5, 0, 8, $F0
		dc.b $F8, 5, 0, $1C, $10
		dc.b $F8, 5, 0, 0, $20
		dc.b $F8, 5, 0, $3E, $30
byte_AA75:	dc.b 6
		dc.b $F8, 5, 0, $36, $D0
		dc.b $F8, 5, 0, 0, $E0
		dc.b $F8, 5, 0, $3E, $F0
		dc.b $F8, 5, 0, $3E, 0
		dc.b $F8, 5, 0, $10, $10
		dc.b $F8, 5, 0, $C, $20
byte_AA94:	dc.b 6
		dc.b $F8, $D, 1, $4A, $B0
		dc.b $F8, 1, 1, $62, $D0
		dc.b $F8, 9, 1, $64, $18
		dc.b $F8, $D, 1, $6A, $30
		dc.b $F7, 4, 0, $6E, $CD
		dc.b $FF, 4, $18, $6E, $CD
byte_AAB3:	dc.b 7
		dc.b $F8, $D, 1, $5A, $B0
		dc.b $F8, $D, 0, $66, $D9
		dc.b $F8, 1, 1, $4A, $F9
		dc.b $F7, 4, 0, $6E, $F6
		dc.b $FF, 4, $18, $6E, $F6
		dc.b $F8, $D, $FF, $F0, $28
		dc.b $F8, 1, 1, $70, $48
byte_AAD7:	dc.b 7
		dc.b $F8, $D, 1, $52, $B0
		dc.b $F8, $D, 0, $66, $D9
		dc.b $F8, 1, 1, $4A, $F9
		dc.b $F7, 4, 0, $6E, $F6
		dc.b $FF, 4, $18, $6E, $F6
		dc.b $F8, $D, $FF, $F8, $28
		dc.b $F8, 1, 1, $70, $48
		even

		include "obj/36 Spikes.asm"
Map_Spike:	include "_maps/Spikes.asm"

		include "obj/3B Purple Rock.asm"
		include "obj/49 Waterfall Sound.asm"

Map_PRock:	include "_maps/Purple Rock.asm"

		include "obj/3C Smashable Wall.asm"
		include "obj/sub SmashObject.asm"

ObjSmashWall_FragRight:
		dc.w $400, -$500
		dc.w $600, -$100
		dc.w $600, $100
		dc.w $400, $500
		dc.w $600, -$600
		dc.w $800, -$200
		dc.w $800, $200
		dc.w $600, $600

ObjSmashWall_FragLeft:
		dc.w -$600, -$600
		dc.w -$800, -$200
		dc.w -$800, $200
		dc.w -$600, $600
		dc.w -$400, -$500
		dc.w -$600, -$100
		dc.w -$600, $100
		dc.w -$400, $500

Map_Smash:	include "_maps/Smashable Walls.asm"

		include "obj/3D Boss - Green Hill (part 1).asm"

sub_B146:
		move.b	(v_vbla_byte).w,d0
		andi.b	#7,d0
		bne.s	locret_B186
		bsr.w	FindFreeObj
		bne.s	locret_B186
		_move.b	#id_ExplosionBomb,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,obX(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,obY(a1)

locret_B186:
		rts
; ---------------------------------------------------------------------------

BossMove:
		move.l	obBossX(a0),d2
		move.l	obBossY(a0),d3
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	obVelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,obBossX(a0)
		move.l	d3,obBossY(a0)
		rts

		include "obj/3D Boss - Green Hill (part 2).asm"
		include "obj/48 Eggman's Swinging Ball.asm"

		include "_anim/Eggman.asm"
Map_Eggman:	include "_maps/Eggman.asm"

Map_BossItems:	include "_maps/Boss Items.asm"

		include "obj/3E Prison Capsule.asm"

		include "_anim/Prison Capsule.asm"
Map_Pri:	include "_maps/Prison Capsule.asm"

		include "obj/40 Motobug.asm"

		include "_anim/Moto Bug.asm"
Map_Moto:	include "_maps/Moto Bug.asm"

		include "obj/41 Springs.asm"

		include "_anim/Springs.asm"
Map_Spring:	include "_maps/Springs.asm"

		include "obj/42 Newtron.asm"

		include "_anim/Newtron.asm"
Map_Newt:	include "_maps/Newtron.asm"

		include "obj/43 Roller.asm"
		include "_anim/Roller.asm"
Map_Roll:	include "_maps/Roller.asm"

		include "obj/44 GHZ Edge Walls.asm"
Map_Edge:	include "_maps/GHZ Edge Walls.asm"

		include "obj/13 Lava Ball Maker.asm"
		include "obj/14 Lava Ball.asm"
		include "_anim/Fireballs.asm"

		include "obj/46 MZ Bricks.asm"
Map_Brick:	include "_maps/MZ Bricks.asm"

		include "obj/12 Light.asm"
Map_Light:	include "_maps/Light.asm"

		include "obj/47 Bumper.asm"
		include "_anim/Bumper.asm"
Map_Bump:	include "_maps/Bumper.asm"

		include "obj/0D Signpost.asm"
Ani_Sign:	include "_anim/Signpost.asm"
Map_Sign:	include "_maps/Signpost.asm"

		include "obj/4C & 4D Lava Geyser Maker.asm"

		include "obj/4E Wall of Lava.asm"

		include "obj/54 Lava Tag.asm"
Map_LTag:	include "_maps/Lava Tag.asm"
		include "_anim/Lava Geyser.asm"
		include "_anim/Wall of Lava.asm"
Map_Geyser:	include "_maps/Lava Geyser.asm"
Map_LWall:	include "_maps/Wall of Lava.asm"

		include "obj/4F Splats.asm"
Map_Splats:	include "_maps/Splats.asm"

		include "obj/50 Yadrin.asm"
Ani_Yadrin:	include "_anim/Yadrin.asm"
Map_Yadrin:	include "_maps/Yadrin.asm"

		include "obj/51 Smashable Green Block.asm"

ObjSmashBlock_Frag:
		dc.w -$200, -$200
		dc.w -$100, -$100
		dc.w $200, -$200
		dc.w $100, -$100

Map_Smab:	include "_maps/Smashable Green Block.asm"

		include "obj/52 Moving Blocks.asm"
Map_MBlock:	include "_maps/Moving Blocks (MZ).asm"

		include "obj/55 Basaran.asm"
		include "_anim/Basaran.asm"
Map_Bas:	include "_maps/Basaran.asm"

		include "obj/56 Floating Blocks and Doors.asm"
Map_FBlock:	include "_maps/Floating Blocks and Doors.asm"

		include "obj/57 Spiked Ball and Chain.asm"
Map_SBall:	include "_maps/Spiked Ball and Chain (SZ).asm"

		include "obj/58 Big Spiked Ball.asm"
Map_BBall:	include "_maps/Big Spiked Ball.asm"

		include "obj/59 SLZ Elevators.asm"
Map_Elev:	include "_maps/SLZ Elevators.asm"

		include "obj/5A SLZ Circling Platform.asm"
Map_Circ:	include "_maps/SLZ Circling Platform.asm"

		include "obj/5B Staircase.asm"
Map_Stair:	include "_maps/Staircase.asm"

		include "obj/5C Pylon.asm"
Map_Pylon:	include "_maps/Pylon.asm"

		include "obj/5D Fan.asm"
Map_Fan:	include "_maps/Fan.asm"

		include "obj/5E Seesaw.asm"

ObjSeeSaw_SlopeTilt:dc.b $24, $24, $26, $28, $2A, $2C, $2A, $28, $26, $24
		dc.b $23, $22, $21, $20, $1F, $1E, $1D, $1C, $1B, $1A
		dc.b $19, $18, $17, $16, $15, $14, $13, $12, $11, $10
		dc.b $F, $E, $D, $C, $B, $A, 9, 8, 7, 6, 5, 4, 3, 2, 2
		dc.b 2, 2, 2
		even

ObjSeeSaw_SlopeLine:dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15
		even

Map_Seesaw:	include "_maps/Seesaw.asm"

		include	"obj/01 Sonic.asm"

		include "obj/38 Shield and Invincibility.asm"
		include "obj/4A Giant Ring.asm"

		include "_anim/Shield.asm"
		include "_maps/Shield.asm"

		include "_anim/Special Stage Entry (Unused).asm"
Map_Vanish:	include "_maps/Special Stage Entry (Unused).asm"

		include "obj/sub ReactToItem.asm"

		include "obj/Sonic AnglePos.asm"

		include "obj/sub FindNearestTile.asm"
		include "obj/sub FindFloor.asm"
		include "obj/sub FindWall.asm"
; ---------------------------------------------------------------------------
; This subroutine takes 'raw' bitmap-like collision block data as input and
; converts it into the proper collision arrays (ColArray and ColArray2).
; Pointers to said raw data are dummied out.
; Curiously, an example of the original 'raw' data that this was intended
; to process can be found in the J2ME version, in a file called 'blkcol.bct'.
; ---------------------------------------------------------------------------

RawColBlocks		equ CollArray1
ConvRowColBlocks	equ CollArray1

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


ConvertCollisionArray:
		rts
; ---------------------------------------------------------------------------
		; The raw format stores the collision data column by column for the normal collision array.
		; This makes a copy of the data, but stored row by row, for the rotated collision array.
		lea	(RawColBlocks).l,a1	; Source location of raw collision block data
		lea	(ConvRowColBlocks).l,a2	; Destinatation location for row-converted collision block data

		move.w	#$100-1,d3		; Number of blocks in collision data

.blockLoop:
		moveq	#16,d5			; Start on the 16th bit (the leftmost pixel)

		move.w	#16-1,d2		; Width of a block in pixels

.columnLoop:
		moveq	#0,d4

		move.w	#16-1,d1		; Height of a block in pixels

.rowLoop:
		move.w	(a1)+,d0		; Get row of collision bits
		lsr.l	d5,d0			; Push the selected bit of this row into the 'eXtend' flag
		addx.w	d4,d4			; Shift d4 to the left, and insert the selected bit into bit 0
		dbf	d1,.rowLoop		; Loop for each row of pixels in a block

		move.w	d4,(a2)+		; Store column of collision bits
		suba.w	#2*16,a1		; Back to the start of the block
		subq.w	#1,d5			; Get next bit in the row
		dbf	d2,.columnLoop		; Loop for each column of pixels in a block

		adda.w	#2*16,a1		; Next block
		dbf	d3,.blockLoop		; Loop for each block in the raw collision block data

		; This then converts the collision data into the final collision arrays
		lea	(ConvRowColBlocks).l,a1
		lea	(CollArray2).l,a2	; Convert the row-converted collision block data into final rotated collision array
		bsr.s	.convertArray
		lea	(RawColBlocks).l,a1
		lea	(CollArray1).l,a2	; Convert the raw collision block data into final normal collision array


.convertArray:
		move.w	#$1000-1,d3		; Size of the collision array

.processLoop:
		moveq	#0,d2
		move.w	#$F,d1
		move.w	(a1)+,d0		; Get current column of collision pixels
		beq.s	.noCollision		; Branch if there's no collision in this column
		bmi.s	.topPixelSolid		; Branch if top pixel of collision is solid

	; Here we count, starting from the bottom, how many pixels tall
	; the collision in this column is.
.processColumnLoop1:
		lsr.w	#1,d0
		bhs.s	.pixelNotSolid1
		addq.b	#1,d2

.pixelNotSolid1:
		dbf	d1,.processColumnLoop1

		bra.s	.columnProcessed
; ===========================================================================

.topPixelSolid:
		cmpi.w	#$FFFF,d0		; Is entire column solid?
		beq.s	.entireColumnSolid	; Branch if so

	; Here we count, starting from the top, how many pixels tall
	; the collision in this column is (the resulting number is negative).
.processColumnLoop2:
		lsl.w	#1,d0
		bhs.s	.pixelNotSolid2
		subq.b	#1,d2

.pixelNotSolid2:
		dbf	d1,.processColumnLoop2

		bra.s	.columnProcessed
; ===========================================================================

.entireColumnSolid:
		move.w	#$10,d0

.noCollision:
		move.w	d0,d2

.columnProcessed:
		move.b	d2,(a2)+		; Store column collision height
		dbf	d3,.processLoop

		rts
; End of function ConvertCollisionArray
; ---------------------------------------------------------------------------

Sonic_WalkSpeed:
		move.l	obX(a0),d3
		move.l	obY(a0),d2
		move.w	obVelX(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d3
		move.w	obVelY(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d2
		swap	d2
		swap	d3
		move.b	d0,(v_anglebuffer).w
		move.b	d0,(v_anglebuffer2).w
		move.b	d0,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.w	loc_105C8
		cmpi.b	#$80,d0
		beq.w	loc_10754
		andi.b	#$38,d1
		bne.s	loc_10514
		addq.w	#8,d2

loc_10514:
		cmpi.b	#$40,d0
		beq.w	loc_10822
		bra.w	loc_10694
; ---------------------------------------------------------------------------

sub_10520:
		move.b	d0,(v_anglebuffer).w
		move.b	d0,(v_anglebuffer2).w
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_107AE
		cmpi.b	#$80,d0
		beq.w	Sonic_NoRunningOnWalls
		cmpi.b	#$C0,d0
		beq.w	loc_10628

Sonic_HitFloor:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#0,d2

loc_105A8:
		move.b	(v_anglebuffer2).w,d3
		cmp.w	d0,d1
		ble.s	loc_105B6
		move.b	(v_anglebuffer).w,d3
		move.w	d0,d1	; this line was changed to exg in the final game

loc_105B6:
		btst	#0,d3
		beq.s	locret_105BE
		move.b	d2,d3

locret_105BE:
		rts
; ---------------------------------------------------------------------------
		; unused
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_105C8:
		addi.w	#$A,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#0,d2

loc_105E2:
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_105EE
		move.b	d2,d3

locret_105EE:
		rts
; ---------------------------------------------------------------------------

ObjFloorDist:
		move.w	obX(a0),d3

ObjFloorDist2:
		move.w	obY(a0),d2
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		lea	(v_anglebuffer).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_10626
		move.b	#0,d3

locret_10626:
		rts
; ---------------------------------------------------------------------------

loc_10628:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	(sp)+,d0
		move.b	#-$40,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------

sub_1068C:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_10694:
		addi.w	#$A,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	#-$40,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjHitWallRight:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
		lea	(v_anglebuffer).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_106DE
		move.b	#-$40,d3

locret_106DE:
		rts
; ---------------------------------------------------------------------------

Sonic_NoRunningOnWalls:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#$80,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------
		; unused
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_10754:
		subi.w	#$A,d2
		eori.w	#$F,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#$80,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjHitCeiling:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_107AC
		move.b	#$80,d3

locret_107AC:
		rts
; ---------------------------------------------------------------------------

loc_107AE:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer2).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	(sp)+,d0
		move.b	#$40,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------

Sonic_HitWall:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_10822:
		subi.w	#$A,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	#$40,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

ObjHitWallLeft:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
	if FixBugs
		; Engine bug: colliding with left walls is erratic with this function.
		; The cause is this: a missing instruction to flip collision on the found
		; 16x16 block; this one:
		eori.w	#$F,d3
	endif
		lea	(v_anglebuffer).w,a4
		move.b	#0,(a4)
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_10870
		move.b	#$40,d3

locret_10870:
		rts
; ---------------------------------------------------------------------------

SS_ShowLayout:
		bsr.w	SS_AniWallsandRings
		bsr.w	SS_AniItems
		move.w	d5,-(sp)
		lea	(v_ssbuffer3).w,a1
		move.b	(v_ssangle).w,d0
		andi.b	#$FC,d0
		jsr	(CalcSine).l
		move.w	d0,d4
		move.w	d1,d5
		muls.w	#24,d4
		muls.w	#24,d5
		moveq	#0,d2
		move.w	(v_screenposx).w,d2
		divu.w	#24,d2
		swap	d2
		neg.w	d2
		addi.w	#-$B4,d2
		moveq	#0,d3
		move.w	(v_screenposy).w,d3
		divu.w	#24,d3
		swap	d3
		neg.w	d3
		addi.w	#-$B4,d3
		move.w	#$10-1,d7

loc_108C2:
		movem.w	d0-d2,-(sp)
		movem.w	d0-d1,-(sp)
		neg.w	d0
		muls.w	d2,d1
		muls.w	d3,d0
		move.l	d0,d6
		add.l	d1,d6
		movem.w	(sp)+,d0-d1
		muls.w	d2,d0
		muls.w	d3,d1
		add.l	d0,d1
		move.l	d6,d2
		move.w	#$10-1,d6

loc_108E4:
		move.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		move.l	d1,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		add.l	d5,d2
		add.l	d4,d1
		dbf	d6,loc_108E4

		movem.w	(sp)+,d0-d2
		addi.w	#$18,d3
		dbf	d7,loc_108C2

		move.w	(sp)+,d5
		lea	(v_ssbuffer1).l,a0
		moveq	#0,d0
		move.w	(v_screenposy).w,d0
		divu.w	#24,d0
		mulu.w	#128,d0
		adda.l	d0,a0
		moveq	#0,d0
		move.w	(v_screenposx).w,d0
		divu.w	#24,d0
		adda.w	d0,a0
		lea	(v_ssbuffer3).w,a4
		move.w	#$10-1,d7

loc_10930:
		move.w	#$10-1,d6

loc_10934:
		moveq	#0,d0
		move.b	(a0)+,d0
		beq.s	loc_10986
		move.w	(a4),d3
		addi.w	#$120,d3
		cmpi.w	#$70,d3
		blo.s	loc_10986
		cmpi.w	#$1D0,d3
		bhs.s	loc_10986
		move.w	2(a4),d2
		addi.w	#$F0,d2
		cmpi.w	#$70,d2
		blo.s	loc_10986
		cmpi.w	#$170,d2
		bhs.s	loc_10986
		lea	(v_ssbuffer2).l,a5
		lsl.w	#3,d0
		lea	(a5,d0.w),a5
		movea.l	(a5)+,a1
		move.w	(a5)+,d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		movea.w	(a5)+,a3
		moveq	#0,d1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_10986
		jsr	(sub_88AA).l

loc_10986:
		addq.w	#4,a4
		dbf	d6,loc_10934

		lea	$70(a0),a0
		dbf	d7,loc_10930

		move.b	d5,(v_spritecount).w
		cmpi.b	#80,d5
		beq.s	loc_109A6
		move.l	#0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_109A6:
		move.b	#0,-5(a2)
		rts
; ---------------------------------------------------------------------------

SS_AniWallsandRings:
		lea	(v_ssblocktypes+$C).l,a1
		moveq	#0,d0
		move.b	(v_ssangle).w,d0
		lsr.b	#2,d0
		andi.w	#$F,d0
		moveq	#bytesToWcnt($20),d1

loc_109C2:
		move.w	d0,(a1)
		addq.w	#8,a1
		dbf	d1,loc_109C2

		subq.b	#1,(v_ani1_time).w
		bpl.s	loc_109E0
		move.b	#8-1,(v_ani1_time).w
		addq.b	#1,(v_ani1_frame).w
		andi.b	#4-1,(v_ani1_frame).w

loc_109E0:
		move.b	(v_ani1_frame).w,1(a1)
		addq.w	#8,a1
		addq.w	#8,a1
		subq.b	#1,(v_ani2_time).w
		bpl.s	loc_10A02
		move.b	#8-1,(v_ani2_time).w
		bra.s	loc_10A02
; ---------------------------------------------------------------------------
; unused
		addq.b	#1,(v_ani2_frame).w		; the GOAL blocks were meant to flash yellow
		andi.b	#2-1,(v_ani2_frame).w

loc_10A02:
		move.b	(v_ani2_frame).w,1(a1)
		addq.w	#8,a1
		move.b	(v_ani2_frame).w,1(a1)
		subq.b	#1,(v_ani0_time).w
		bpl.s	loc_10A26
		move.b	#8-1,(v_ani0_time).w
		subq.b	#1,(v_ani0_frame).w
		andi.b	#4-1,(v_ani0_frame).w

loc_10A26:
		lea	(v_ssblocktypes+$2E).l,a1
		lea	(SS_WaRiVramSet).l,a0
		moveq	#0,d0
		move.b	(v_ani0_frame).w,d0
		add.w	d0,d0
		lea	(a0,d0.w),a0
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		adda.w	#$10,a0
		adda.w	#$20,a1
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		adda.w	#$10,a0
		adda.w	#$20,a1
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		rts
; ---------------------------------------------------------------------------
SS_WaRiVramSet:
		dc.w make_art_tile(ArtTile_SS_Wall,0,0)
		dc.w make_art_tile(ArtTile_SS_Wall,0,0)
		dc.w make_art_tile(ArtTile_SS_Wall,0,0)
		dc.w make_art_tile(ArtTile_SS_Wall,1,0)
		dc.w make_art_tile(ArtTile_SS_Wall,0,0)
		dc.w make_art_tile(ArtTile_SS_Wall,0,0)
		dc.w make_art_tile(ArtTile_SS_Wall,0,0)
		dc.w make_art_tile(ArtTile_SS_Wall,0,0)
		dc.w make_art_tile(ArtTile_SS_Wall,1,0)
		dc.w make_art_tile(ArtTile_SS_Wall,1,0)
		dc.w make_art_tile(ArtTile_SS_Wall,1,0)
		dc.w make_art_tile(ArtTile_SS_Wall,0,0)
		dc.w make_art_tile(ArtTile_SS_Wall,1,0)
		dc.w make_art_tile(ArtTile_SS_Wall,1,0)
		dc.w make_art_tile(ArtTile_SS_Wall,1,0)
		dc.w make_art_tile(ArtTile_SS_Wall,1,0)
		dc.w make_art_tile(ArtTile_SS_Wall,2,0)
		dc.w make_art_tile(ArtTile_SS_Wall,2,0)
		dc.w make_art_tile(ArtTile_SS_Wall,2,0)
		dc.w make_art_tile(ArtTile_SS_Wall,1,0)
		dc.w make_art_tile(ArtTile_SS_Wall,2,0)
		dc.w make_art_tile(ArtTile_SS_Wall,2,0)
		dc.w make_art_tile(ArtTile_SS_Wall,2,0)
		dc.w make_art_tile(ArtTile_SS_Wall,2,0)
		dc.w make_art_tile(ArtTile_SS_Wall,3,0)
		dc.w make_art_tile(ArtTile_SS_Wall,3,0)
		dc.w make_art_tile(ArtTile_SS_Wall,3,0)
		dc.w make_art_tile(ArtTile_SS_Wall,1,0)
		dc.w make_art_tile(ArtTile_SS_Wall,3,0)
		dc.w make_art_tile(ArtTile_SS_Wall,3,0)
		dc.w make_art_tile(ArtTile_SS_Wall,3,0)
		dc.w make_art_tile(ArtTile_SS_Wall,3,0)
; ---------------------------------------------------------------------------

SS_RemoveCollectedItem:
		lea	(v_ssitembuffer).l,a2
		move.w	#bytesToXcnt(v_ssitembuffer_end-v_ssitembuffer,8),d0

loc_10AD6:
		tst.b	(a2)
		beq.s	locret_10AE0
		addq.w	#8,a2
		dbf	d0,loc_10AD6

locret_10AE0:
		rts
; ---------------------------------------------------------------------------

SS_AniItems:
		lea	(v_ssitembuffer).l,a0
		move.w	#bytesToXcnt(v_ssitembuffer_end-v_ssitembuffer,8),d7

loc_10AEC:
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	loc_10AFA
		lsl.w	#2,d0
		movea.l	SS_AniIndex-4(pc,d0.w),a1
		jsr	(a1)

loc_10AFA:
		addq.w	#8,a0

loc_10AFC:
		dbf	d7,loc_10AEC
		rts
; ---------------------------------------------------------------------------
SS_AniIndex:	dc.l SS_AniRingSparks
		dc.l SS_AniBumper
; ---------------------------------------------------------------------------

SS_AniRingSparks:
		subq.b	#1,2(a0)
		bpl.s	locret_10B32
		move.b	#6-1,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	byte_10B34(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_10B32
		clr.l	(a0)
		clr.l	4(a0)

locret_10B32:
		rts
; ---------------------------------------------------------------------------

byte_10B34:	dc.b $17, $18, $19, $1A, 0, 0
		even
; ---------------------------------------------------------------------------

SS_AniBumper:
		subq.b	#1,2(a0)
		bpl.s	locret_10B68
		move.b	#8-1,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	byte_10B6A(pc,d0.w),d0
		bne.s	loc_10B66
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$12,(a1)
		rts
; ---------------------------------------------------------------------------

loc_10B66:
		move.b	d0,(a1)

locret_10B68:
		rts
; ---------------------------------------------------------------------------
byte_10B6A:	dc.b $1B, $1C, $1B, $1C, 0, 0
		even
; ---------------------------------------------------------------------------

SS_Load:
		lea	(v_ssbuffer1).l,a1
		move.w	#bytesToLcnt(v_ssbuffer2-v_ssbuffer1),d0

loc_10B7A:
		clr.l	(a1)+
		dbf	d0,loc_10B7A

		lea	(v_sslayout).l,a1
		lea	(SS_1).l,a0
		moveq	#$24-1,d1

loc_10B8E:
		moveq	#bytesToLcnt($24),d2

loc_10B90:
		move.l	(a0)+,(a1)+
		dbf	d2,loc_10B90

		lea	$5C(a1),a1
		dbf	d1,loc_10B8E

		lea	(v_ssblocktypes+8).l,a1
		lea	(SS_MapIndex).l,a0
		moveq	#bytesToXcnt(SS_MapIndex_End-SS_MapIndex,6),d1

loc_10BAC:
		move.l	(a0)+,(a1)+
		move.w	#0,(a1)+
		move.b	-4(a0),-1(a1)
		move.w	(a0)+,(a1)+
		dbf	d1,loc_10BAC

		lea	(v_ssitembuffer).l,a1
		move.w	#bytesToLcnt(v_ssitembuffer_end-v_ssitembuffer),d1

loc_10BC8:

		clr.l	(a1)+
		dbf	d1,loc_10BC8

		rts
; ---------------------------------------------------------------------------

SS_MapIndex:	include "include/Special Stage Mappings & VRAM Pointers.asm"
SS_MapIndex_End

Map_SS_Up:
Map_SS_Goal:	include	"_maps/SS UP Block.asm"

Map_SS_Down:
Map_SS_Goal_R:	include	"_maps/SS DOWN Block.asm"

; unused
;sub_10C98:
		lea	(v_ssblockbuffer).l,a1
		lea	(SS_1).l,a0
		moveq	#$40-1,d1

loc_10CA6:
		moveq	#bytesToLcnt($40),d2

loc_10CA8:
		move.l	(a0)+,(a1)+
		dbf	d2,loc_10CA8
		lea	$40(a1),a1
		dbf	d1,loc_10CA6
		rts

		include "obj/09 Sonic in Special Stage.asm"
		include "obj/10 Sonic Animation Test.asm"

		include "include/AnimateLevelGfx.asm"

		include "obj/21 HUD.asm"
Map_HUD:	include "_maps/HUD.asm"
; ---------------------------------------------------------------------------

ScoreAdd:
		move.b	#1,(f_scorecount).w
		lea	(v_scorecopy).w,a2
		lea	(v_score).w,a3
		add.l	d0,(a3)
		move.l	#999999,d1
		cmp.l	(a3),d1
		bhi.w	loc_1166E
		move.l	d1,(a3)
		move.l	d1,(a2)

loc_1166E:
		move.l	(a3),d0
		cmp.l	(a2),d0
		blo.w	locret_11678
		move.l	d0,(a2)

locret_11678:
		rts
; ---------------------------------------------------------------------------

		include	"include/HUD_Update.asm"

byte_11A26:	binclude "artunc/HUD Numbers.bin"
byte_11D26:	binclude "artunc/Lives Counter Numbers.bin"

		include "obj/DebugMode.asm"
		include "include/DebugList.asm"
		include "include/LevelHeaders.asm"
		include "include/Pattern Load Cues.asm"

		align	$8000
; ===========================================================================
; Unused 8x8 ASCII Art
; ===========================================================================
;byte_18000:
		binclude "leftovers/artnem/8x8 ASCII.nem"
		even
; ===========================================================================
; Sega Screen/Title Screen Art and Mappings
; ===========================================================================
Nem_SegaLogo:	binclude "artnem/Sega Logo.nem"
		even
Eni_SegaLogo:	binclude "tilemaps/Sega Logo.eni"
		even
Unc_Title:	binclude "tilemaps/Title Screen.bin"
Nem_TitleFg:	binclude "artnem/Title Screen Foreground.nem"
		even
Nem_TitleSonic:	binclude "artnem/Title Screen Sonic.nem"
		even

		align	$4000
Map_Sonic:	include "_maps/Sonic.asm"
SonicDynPLC:	include "_maps/Sonic - Dynamic Gfx Script.asm"
; ---------------------------------------------------------------------------
; Uncompressed graphics	- Sonic
; ---------------------------------------------------------------------------
Art_Sonic:	binclude "artunc/Sonic.bin"
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_Smoke:	binclude "artnem/Smoke.nem"
		even
Nem_Shield:	binclude "artnem/Shield.nem"
		even
Nem_Stars:	binclude "artnem/Stars.nem"
		even
Nem_Flash:	binclude "artnem/Flash.nem"
		even
;Nem_Goggles:
		binclude "artnem/Unused - Goggles.nem"
		even

		align	$400
; ---------------------------------------------------------------------------
; Compressed graphics - GHZ stuff
; ---------------------------------------------------------------------------
Nem_Stalk:	binclude "artnem/GHZ Flower Stalk.nem"
		even
Nem_Swing:	binclude "artnem/GHZ Swinging Platform.nem"
		even
Nem_Bridge:	binclude "artnem/GHZ Bridge.nem"
		even
Nem_Ball:	binclude "artnem/GHZ Giant Ball.nem"
		even
Nem_Spikes:	binclude "artnem/Spikes.nem"
		even
Nem_SpikePole:	binclude "artnem/GHZ Spiked Log.nem"
		even
Nem_PplRock:	binclude "artnem/GHZ Purple Rock.nem"
		even
Nem_GhzWall1:	binclude "artnem/GHZ Breakable Wall.nem"
		even
Nem_GhzWall2:	binclude "artnem/GHZ Edge Wall.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - MZ stuff
; ---------------------------------------------------------------------------
Nem_MzMetal:	binclude "artnem/MZ Metal Blocks.nem"
		even
Nem_MzSwitch:	binclude "artnem/MZ Switch.nem"
		even
Nem_MzGlass:	binclude "artnem/MZ Green Glass Block.nem"
		even
		binclude "artnem/Unused - Grass.nem"
		even
Nem_MzFire:	binclude "artnem/Fireballs.nem"
		even
Nem_Lava:	binclude "artnem/MZ Lava.nem"
		even
Nem_MzBlock:	binclude "artnem/MZ Green Pushable Block.nem"
		even
		binclude "artnem/Unused - MZ Background.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - SLZ stuff
; ---------------------------------------------------------------------------
Nem_Seesaw:	binclude "artnem/SLZ Seesaw.nem"
		even
Nem_Fan:	binclude "artnem/SLZ Fan.nem"
		even
byte_294DA:	binclude "artnem/SLZ Breakable Wall.nem"
		even
Nem_Pylon:	binclude "artnem/SLZ Pylon.nem"
		even
Nem_SlzSwing:	binclude "artnem/SLZ Swinging Platform.nem"
		even
Nem_SLZ_Platfm:	binclude "artnem/SLZ Platforms.nem"
		even
Nem_SlzBlock:	binclude "artnem/SLZ 32x32 Block.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - SZ stuff
; ---------------------------------------------------------------------------
Nem_Bumper:	binclude "artnem/SZ Bumper.nem"
		even
Nem_SyzSpike2:	binclude "artnem/SZ Small Spikeball.nem"
		even
Nem_Switch:	binclude "artnem/Switch.nem"
		even
Nem_SyzSpike1:	binclude "artnem/SZ Large Spikeball.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - enemies
; ---------------------------------------------------------------------------
;Nem_BallHog:
		binclude "artnem/Unused - Enemy Ball Hog.nem"
		even
Nem_Crabmeat:	binclude "artnem/Enemy Crabmeat.nem"
		even
Nem_Buzz:	binclude "artnem/Enemy Buzz Bomber.nem"
		even
;Nem_Ball_Explosion:
		binclude "artnem/Unused - Ball Hog's Bomb Explosion.nem"
		even
Nem_Burrobot:	binclude "artnem/Enemy Burrobot.nem"
		even
Nem_Chopper:	binclude "artnem/Enemy Chopper.nem"
		even
Nem_Jaws:	binclude "artnem/Enemy Jaws.nem"
		even
;Nem_BallBomb:
		binclude "artnem/Unused - Ball Hog's Bomb.nem"
		even
Nem_Roller:	binclude "artnem/Enemy Roller.nem"
		even
Nem_Motobug:	binclude "artnem/Enemy Motobug.nem"
		even
Nem_Newtron:	binclude "artnem/Enemy Newtron.nem"
		even
Nem_Yadrin:	binclude "artnem/Enemy Yadrin.nem"
		even
Nem_Basaran:	binclude "artnem/Enemy Basaran.nem"
		even
Nem_Splats:	binclude "artnem/Enemy Splats.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_TitleCard:	binclude "artnem/Title Cards.nem"
		even
Nem_HUD:	binclude "artnem/HUD.nem"
		even
Nem_Lives:	binclude "artnem/HUD - Life Counter Icon.nem"
		even
Nem_Ring:	binclude "artnem/Rings.nem"
		even
Nem_Monitors:	binclude "artnem/Monitors.nem"
		even
Nem_Explode:	binclude "artnem/Explosion.nem"
		even
Nem_Points:	binclude "artnem/Points.nem"
		even
Nem_GameOver:	binclude "artnem/Game Over.nem"
		even
Nem_HSpring:	binclude "artnem/Spring Horizontal.nem"
		even
Nem_VSpring:	binclude "artnem/Spring Vertical.nem"
		even
Nem_SignPost:	binclude "artnem/Signpost.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - animals
; ---------------------------------------------------------------------------
Nem_Rabbit:	binclude "artnem/Animal Rabbit.nem"
		even
Nem_Chicken:	binclude "artnem/Animal Chicken.nem"
		even
Nem_Penguin:	binclude "artnem/Animal Blackbird.nem"
		even
Nem_Seal:	binclude "artnem/Animal Seal.nem"
		even
Nem_Pig:	binclude "artnem/Animal Pig.nem"
		even
Nem_Flicky:	binclude "artnem/Animal Flicky.nem"
		even
Nem_Squirrel:	binclude "artnem/Animal Squirrel.nem"
		even

		align	$1000
; ---------------------------------------------------------------------------
; Compressed graphics - primary patterns
; Blocks are Uncompressed
; ---------------------------------------------------------------------------
Blk16_GHZ:	binclude "level/map16/GHZ.bin"
Nem_GHZ_1st:	binclude "artnem/8x8 - GHZ1.nem"
		even
Nem_GHZ_2nd:	binclude "artnem/8x8 - GHZ2.nem"
		even
Blk256_GHZ:	binclude "level/map256/GHZ.kos"
		even
Blk16_LZ:	binclude "level/map16/LZ.bin"
Nem_LZ:	binclude "artnem/8x8 - LZ.nem"
		even
Blk256_LZ:	binclude "level/map256/LZ.kos"
		even
Blk16_MZ:	binclude "level/map16/MZ.bin"
Nem_MZ:	binclude "artnem/8x8 - MZ.nem"
		even
Blk256_MZ:	binclude "level/map256/MZ.kos"
		even
;0x3DA48
; end chunk data
		dc.w $F0, 0, 0, 0, 0, 0, 0, 0
;0x3DA58
		binclude "leftovers/level/map256/Chunk Data.kos"
		even
;0x3DB78
		binclude "unknown/3DB78.dat"
		even
Blk16_SLZ:	binclude "level/map16/SLZ.bin"
Nem_SLZ:	binclude "artnem/8x8 - SLZ.nem"
		even
Blk256_SLZ:	binclude "level/map256/SLZ.kos"
		even
Blk16_SZ:	binclude "level/map16/SZ.bin"
Nem_SZ:	binclude "artnem/8x8 - SZ.nem"
		even
Blk256_SZ:	binclude "level/map256/SZ.kos"
		even
Blk16_CWZ:	binclude "level/map16/CWZ.bin"
Nem_CWZ:	binclude "artnem/8x8 - CWZ.nem"
		even
Blk256_CWZ:	binclude "level/map256/CWZ.kos"
		even
;0x570DC
; duplicate cut-off chunk data from CWZ
		dc.w $FFF8, $FCAA, $AAFF, $F8FC, $FFF8, $FCFF, $F8FC, $FFF8
		dc.w $FC00, $F001, $FFF8, $FCFF, $F8FC, $FFF8, $FC02, $FF
		dc.w $F89F, $F0, 0, 0, 0, 0, 0, 0
; and a duplicate of a duplicate end of chunk data pointer
		dc.w $F89F, $F0, 0, 0, 0, 0, 0, 0

;0x5711C
		binclude "unknown/5711C.dat"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - bosses and ending sequence
; ---------------------------------------------------------------------------
Nem_Eggman:	binclude "artnem/Boss - Main.nem"
		even
Nem_Weapons:	binclude "artnem/Boss - Weapons.nem"
		even
Nem_Prison:	binclude "artnem/Prison Capsule.nem"
		even
; ===========================================================================
; Demos
; ===========================================================================
Demo_GHZ:	include "demodata/Intro - GHZ.asm"	; Green Hill's demo (act 2?)
Demo_MZ:	include "demodata/Intro - MZ.asm"	; Marble's demo
Demo_SZ:	binclude "demodata/Intro - SZ.bin"	; Sparkling's demo (?)
		even
Demo_SS:	include "demodata/Intro - Special Stage.asm" ; Special stage demo

		align	$3000

		include "_maps/SS Walls.asm"
; ---------------------------------------------------------------------------
; Compressed graphics - special stage
; ---------------------------------------------------------------------------
Nem_SSWalls:	binclude "artnem/Special Walls.nem"
		even
Eni_SSBg1:	binclude "tilemaps/SS Background 1.eni"
		even
Nem_SSBgFish:	binclude "artnem/Special Birds & Fish.nem"
		even
Eni_SSBg2:	binclude "tilemaps/SS Background 2.eni"
		even
Nem_SSBgCloud:	binclude "artnem/Special Clouds.nem"
		even
Nem_SSGOAL:	binclude "artnem/Special GOAL.nem"
		even
Nem_SSRBlock:	binclude "artnem/Special R.nem"
		even
Nem_SSSkull:	binclude "artnem/Special Skull.nem"
		even
Nem_SSUBlock:	binclude "artnem/Special U.nem"
		even
Nem_SS1UpBlock:	binclude "artnem/Special 1UP.nem"
		even
Nem_SSEmStars:	binclude "artnem/Special Emerald Twinkle.nem"
		even
Nem_SSRedWhite:	binclude "artnem/Special Red-White.nem"
		even
Nem_SSZone1:	binclude "artnem/Special ZONE1.nem"
		even
Nem_SSZone2:	binclude "artnem/Special ZONE2.nem"
		even
Nem_SSZone3:	binclude "artnem/Special ZONE3.nem"
		even
Nem_SSZone4:	binclude "artnem/Special ZONE4.nem"
		even
Nem_SSZone5:	binclude "artnem/Special ZONE5.nem"
		even
Nem_SSZone6:	binclude "artnem/Special ZONE6.nem"
		even
Nem_SSUpDown:	binclude "artnem/Special UP-DOWN.nem"
		even
Nem_SSEmerald:	binclude "artnem/Special Emeralds.nem"
		even

		align	$4000
; ---------------------------------------------------------------------------
; Collision data
; ---------------------------------------------------------------------------
AngleMap:	binclude "collide/Angle Map.bin"
CollArray1:	binclude "collide/Collision Array (Normal).bin"
CollArray2:	binclude "collide/Collision Array (Rotated).bin"
Col_GHZ:	binclude "collide/GHZ.bin"
Col_LZ:	binclude "collide/LZ.bin"
Col_MZ:	binclude "collide/MZ.bin"
Col_SLZ:	binclude "collide/SLZ.bin"
Col_SZ:	binclude "collide/SZ.bin"
Col_CWZ:	binclude "collide/CWZ.bin"
; ---------------------------------------------------------------------------
; Special Stage layout (uncompressed)
; ---------------------------------------------------------------------------
SS_1:	binclude "sslayout/1.bin"
SS_1_End:
; ---------------------------------------------------------------------------
; Animated uncompressed graphics
; ---------------------------------------------------------------------------
Art_GhzWater:	binclude "artunc/GHZ Waterfall.bin"
Art_GhzFlower1:	binclude "artunc/GHZ Flower Large.bin"
Art_GhzFlower2:	binclude "artunc/GHZ Flower Small.bin"
Art_MzLava1:	binclude "artunc/MZ Lava Surface.bin"
Art_MzLava2:	binclude "artunc/MZ Lava.bin"
Art_MzSaturns:	binclude "artunc/MZ Saturns.bin"
Art_MzTorch:	binclude "artunc/MZ Background Torch.bin"
; ---------------------------------------------------------------------------
; Level	layout index
; ---------------------------------------------------------------------------
LayoutArray:	; GHZ
		dc.w LayoutGHZ1FG-LayoutArray, LayoutGHZ1BG-LayoutArray, byte_6CE54-LayoutArray
		dc.w LayoutGHZ2FG-LayoutArray, LayoutGHZ2BG-LayoutArray, byte_6CF3C-LayoutArray
		dc.w LayoutGHZ3FG-LayoutArray, LayoutGHZ3BG-LayoutArray, byte_6D084-LayoutArray
		dc.w byte_6D088-LayoutArray, byte_6D088-LayoutArray, byte_6D088-LayoutArray
		; LZ
		dc.w LayoutLZ1FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D190-LayoutArray
		dc.w LayoutLZ2FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D216-LayoutArray
		dc.w LayoutLZ3FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D31C-LayoutArray
		dc.w byte_6D320-LayoutArray, byte_6D320-LayoutArray, byte_6D320-LayoutArray
		; MZ
		dc.w LayoutMZ1FG-LayoutArray, LayoutMZ1BG-LayoutArray, LayoutMZ1FG-LayoutArray
		dc.w LayoutMZ2FG-LayoutArray, LayoutMZ2BG-LayoutArray, byte_6D614-LayoutArray
		dc.w LayoutMZ3FG-LayoutArray, LayoutMZ3BG-LayoutArray, byte_6D7DC-LayoutArray
		dc.w byte_6D7E0-LayoutArray, byte_6D7E0-LayoutArray, byte_6D7E0-LayoutArray
		; SLZ
		dc.w LayoutSLZ1FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w LayoutSLZ2FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w LayoutSLZ3FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w byte_6DBE4-LayoutArray, byte_6DBE4-LayoutArray, byte_6DBE4-LayoutArray
		; SZ
		dc.w LayoutSZ1FG-LayoutArray, LayoutSZBG-LayoutArray, byte_6DCD8-LayoutArray
		dc.w LayoutSZ2FG-LayoutArray, LayoutSZBG-LayoutArray, byte_6DDDA-LayoutArray
		dc.w LayoutSZ3FG-LayoutArray, LayoutSZBG-LayoutArray, byte_6DF30-LayoutArray
		dc.w byte_6DF34-LayoutArray, byte_6DF34-LayoutArray, byte_6DF34-LayoutArray
		; CWZ
		dc.w LayoutCWZ1-LayoutArray, LayoutCWZ2-LayoutArray, LayoutCWZ2-LayoutArray
		dc.w LayoutCWZ2-LayoutArray, byte_6E33C-LayoutArray, byte_6E33C-LayoutArray
		dc.w LayoutCWZ3-LayoutArray, LayoutCWZ3-LayoutArray, LayoutCWZ3-LayoutArray
		dc.w byte_6E344-LayoutArray, byte_6E344-LayoutArray, byte_6E344-LayoutArray
		; Ending
		dc.w LayoutTest-LayoutArray, byte_6E3CA-LayoutArray, byte_6E3CA-LayoutArray
		dc.w byte_6E3CE-LayoutArray, byte_6E3CE-LayoutArray, byte_6E3CE-LayoutArray
		dc.w byte_6E3D2-LayoutArray, byte_6E3D2-LayoutArray, byte_6E3D2-LayoutArray
		dc.w byte_6E3D6-LayoutArray, byte_6E3D6-LayoutArray, byte_6E3D6-LayoutArray

LayoutGHZ1FG:	binclude "level/layout/ghz1.bin"
LayoutGHZ1BG:	binclude "level/layout/ghzbg1.bin"
byte_6CE54:	dc.l 0
LayoutGHZ2FG:	binclude "level/layout/ghz2.bin"
LayoutGHZ2BG:	binclude "level/layout/ghzbg2.bin"
byte_6CF3C:	dc.l 0
LayoutGHZ3FG:	binclude "level/layout/ghz3.bin"
LayoutGHZ3BG:	binclude "level/layout/ghzbg3.bin"
byte_6D084:	dc.l 0
byte_6D088:	dc.l 0
LayoutLZ1FG:	binclude "level/layout/lz1.bin"
LayoutLZBG:	binclude "level/layout/lzbg.bin"
byte_6D190:	dc.l 0
LayoutLZ2FG:	binclude "level/layout/lz2.bin"
byte_6D216:	dc.l 0
LayoutLZ3FG:	binclude "level/layout/lz3.bin"
byte_6D31C:	dc.l 0
byte_6D320:	dc.l 0
LayoutMZ1FG:	binclude "level/layout/mz1.bin"
LayoutMZ1BG:	binclude "level/layout/mzbg1.bin"
LayoutMZ2FG:	binclude "level/layout/mz2.bin"
LayoutMZ2BG:	binclude "level/layout/mzbg2.bin"
byte_6D614:	dc.l 0
LayoutMZ3FG:	binclude "level/layout/mz3.bin"
LayoutMZ3BG:	binclude "level/layout/mzbg3.bin"
byte_6D7DC:	dc.l 0
byte_6D7E0:	dc.l 0
LayoutSLZ1FG:	binclude "level/layout/slz1.bin"
LayoutSLZBG:	binclude "level/layout/slzbg.bin"
LayoutSLZ2FG:	binclude "level/layout/slz2.bin"
LayoutSLZ3FG:	binclude "level/layout/slz3.bin"
byte_6DBE4:	dc.l 0
LayoutSZ1FG:	binclude "level/layout/sz1.bin"
LayoutSZBG:	binclude "level/layout/szbg.bin"
byte_6DCD8:	dc.l 0
LayoutSZ2FG:	binclude "level/layout/sz2.bin"
byte_6DDDA:	dc.l 0
LayoutSZ3FG:	binclude "level/layout/sz3.bin"
byte_6DF30:	dc.l 0
byte_6DF34:	dc.l 0
LayoutCWZ1:	binclude "level/layout/cwz1.bin"
LayoutCWZ2:	binclude "level/layout/cwz2.bin"
byte_6E33C:	binclude "level/layout/cwz2bg.bin"
LayoutCWZ3:	binclude "level/layout/cwz3.bin"
byte_6E344:	dc.l 0
LayoutTest:	binclude "leftovers/level/layout/test.bin"
byte_6E3CA:	dc.l 0
byte_6E3CE:	dc.l 0
byte_6E3D2:	dc.l 0
byte_6E3D6:	dc.l 0

		align	$2000
; ===========================================================================
; Object Layout Index
; ===========================================================================
ObjPos_Index:	; GHZ
		dc.w ObjPos_GHZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; LZ
		dc.w ObjPos_LZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; MZ
		dc.w ObjPos_MZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SLZ
		dc.w ObjPos_SLZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SZ
		dc.w ObjPos_SZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; CWZ
		dc.w ObjPos_CWZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_CWZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_CWZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_CWZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w $FFFF, 0, 0

ObjPos_GHZ1:	binclude "level/objpos/ghz1.bin"
ObjPos_GHZ2:	binclude "level/objpos/ghz2.bin"
ObjPos_GHZ3:	binclude "level/objpos/ghz3.bin"
ObjPos_LZ1:	binclude "level/objpos/lz1.bin"
ObjPos_LZ2:	binclude "level/objpos/lz2.bin"
ObjPos_LZ3:	binclude "level/objpos/lz3.bin"
ObjPos_MZ1:	binclude "level/objpos/mz1.bin"
ObjPos_MZ2:	binclude "level/objpos/mz2.bin"
ObjPos_MZ3:	binclude "level/objpos/mz3.bin"
ObjPos_SLZ1:	binclude "level/objpos/slz1.bin"
ObjPos_SLZ2:	binclude "level/objpos/slz2.bin"
ObjPos_SLZ3:	binclude "level/objpos/slz3.bin"
ObjPos_SZ1:	binclude "level/objpos/sz1.bin"
ObjPos_SZ2:	binclude "level/objpos/sz2.bin"
;0x729CA
		binclude "leftovers/level/objpos/sz1.bin"
ObjPos_SZ3:	binclude "level/objpos/sz3.bin"
ObjPos_CWZ1:	binclude "level/objpos/cwz1.bin"
ObjPos_CWZ2:	binclude "level/objpos/cwz2.bin"
ObjPos_CWZ3:	binclude "level/objpos/cwz3.bin"
ObjPos_Null:	dc.w $FFFF, 0, 0

		align	$2000

		include "s1.sounddriver.asm"

		cnop -1,2<<lastbit(*-1)
		dc.b $FF
EndOfROM: