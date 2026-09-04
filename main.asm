; Sonic the Hedgehog (Prototype)
; Split/Text Disassembly.

; Intended for tab width of 8

; ===========================================================================
; ASSEMBLY OPTIONS:

FixBugs	= 0
;	| If 1, enables various bugfixes across the game and sound driver
;	| See also FixMusicAndSFXDataBugs

AllOptimizations = 0
;	| If 1, enables all optimizations
ZeroOffsetOptimization = 0|AllOptimizations
;	| If 1, makes a handful of zero-offset instructions smaller
PaddingOptimization = 0|AllOptimizations
;	| If 1, removes about 64 KB of various superfluous padding

; ===========================================================================
; AS-specific macros and assembler settings
	cpu 68000
	include "MacroSetup.asm"

; ===========================================================================
; Simplifying macros and functions
	include "Macros.asm"

; ===========================================================================
; Equates section - Names for constants
	include "_Constants.asm"

; ===========================================================================
; Equates section - Names for variables
	include "_Variables.asm"

; ===========================================================================
; Expressing sprite mappings and DPLCs in a portable and human-readable form
SonicMappingsVer = 1
SonicDplcVer = 1
	include	"_maps/_MapMacros.asm"

; ===========================================================================
; start of ROM

StartOfROM:
	if * <> 0
		fatal "StartOfROM was $\{*} but it should be 0"
	endif

Vectors:
		dc.l v_systemstack&$FFFFFF			; Initial stack pointer value
		dc.l EntryPoint					; Start of program
		dc.l BusError					; Bus error
		dc.l AddressError				; Address error (4)
		dc.l IllegalInstr				; Illegal instruction
		dc.l ZeroDivide					; Division by zero
		dc.l ChkInstr					; CHK exception
		dc.l TrapvInstr					; TRAPV exception (8)
		dc.l PrivilegeViol				; Privilege violation
		dc.l Trace					; TRACE exception
		dc.l Line1010Emu				; Line-A emulator
		dc.l Line1111Emu				; Line-F emulator (12)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved) (16)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved) (20)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved)
		dc.l ErrorExcept				; Unused (reserved) (24)
		dc.l ErrorExcept				; Spurious exception
		dc.l ErrorTrap					; IRQ level 1
		dc.l ErrorTrap					; IRQ level 2
		dc.l ErrorTrap					; IRQ level 3 (28)
		dc.l HBlank					; IRQ level 4 (horizontal retrace interrupt)
		dc.l ErrorTrap					; IRQ level 5
		dc.l VBlank					; IRQ level 6 (vertical retrace interrupt)
		dc.l ErrorTrap					; IRQ level 7 (32)
		dc.l ErrorTrap					; TRAP #00 exception
		dc.l ErrorTrap					; TRAP #01 exception
		dc.l ErrorTrap					; TRAP #02 exception
		dc.l ErrorTrap					; TRAP #03 exception (36)
		dc.l ErrorTrap					; TRAP #04 exception
		dc.l ErrorTrap					; TRAP #05 exception
		dc.l ErrorTrap					; TRAP #06 exception
		dc.l ErrorTrap					; TRAP #07 exception (40)
		dc.l ErrorTrap					; TRAP #08 exception
		dc.l ErrorTrap					; TRAP #09 exception
		dc.l ErrorTrap					; TRAP #10 exception
		dc.l ErrorTrap					; TRAP #11 exception (44)
		dc.l ErrorTrap					; TRAP #12 exception
		dc.l ErrorTrap					; TRAP #13 exception
		dc.l ErrorTrap					; TRAP #14 exception
		dc.l ErrorTrap					; TRAP #15 exception (48)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.l ErrorTrap					; Unused (reserved)
		dc.b "SEGA MEGA DRIVE "				; Hardware system ID (Console name.)
		dc.b "(C)SEGA 1989.JAN"				; Copyright holder and release date (Year and month.)
	rept 2
		dc.b "                "				; Domestic/International name (Blank, both are identical.)
		dc.b "                "
		dc.b "                "
	endr
		dc.b "GM 00000000-00"				; Serial/version number (Has not been set yet aside from being classed as game.)
Checksum:	dc.w 0						; Checksum
		dc.b "J               "				; I/O support (Only supports 3 button controllers.)
ROMStartLoc:	dc.l StartOfROM					; Start address of ROM
ROMEndLoc:	dc.l EndOfROM-1					; End address of ROM
RAMStartLoc:	dc.l v_ram_start				; Start address of RAM
RAMEndLoc:	dc.l (v_ram_end-1)&$FFFFFF			; End address of RAM
		dc.l $20202020					; SRAM (none)
		dc.l $20202020					; SRAM start ($200001)
		dc.l $20202020					; SRAM end ($20xxxx)
Notes:		dc.b "                                                    " ; Notes (Unused, anything can be put in this space, but it has to be 52 bytes.)
		dc.b "JU              "				; Region (Country code. Oddly, there's no European region set, although, it can still be played in those regions.)
EndOfHeader:

; ===========================================================================
; Crash/Freeze the 68000.
ErrorTrap:
		nop						; no operation
		nop						; ''
		bra.s	ErrorTrap				; loop forever
; ===========================================================================

; ---------------------------------------------------------------------------
; Entry point for the game on boot or soft-reset
; (This section from a standard Mega Drive devkit library)
; ---------------------------------------------------------------------------

EntryPoint:
		tst.l	(port_1_control_hi).l			; test port A & B control registers

SkipSetup:
		bne.w	GameProgram				; if either of them are already initialized, branch
		tst.w	(expansion_control_hi).l		; test port C control register
		bne.s	SkipSetup				; if any port was already initialized, skip the VDP and Z80 setup code (this is a soft-reset)

		lea	SetupValues(pc),a5			; load setup values array address
		movem.l	(a5)+,d5-a4				; d5 = VDP register start number; d6 = size of RAM/4; d7 = VDP register diff;a0 = start of Z80 RAM; a1 = Z80 bus request; a2 = Z80 reset; a3 = VDP data; a4 = VDP control

		move.w	console_version-1-z80_bus_request(a1),d0 ; get hardware version (from $A10001)
		andi.w	#$F<<8,d0				; only look at Mega Drive version
		beq.s	SkipSecurity				; if the console has no TMSS, skip the security stuff
		move.l	#"SEGA",security_addr-z80_bus_request(a1) ; write "SEGA" to TMSS security register ($A14000)

SkipSecurity:
		move.w	(a4),d0					; clear write-pending flag in VDP (prevents issues if 68k was reset while writing a command to VDP)
		moveq	#0,d0					; clear d0
		movea.l	d0,a6					; clear a6
		move.l	a6,usp					; set usp to $0

		moveq	#SetupValues_VDP_End-SetupValues_VDP-1,d1 ; write to all VDP registers
VDPInitLoop:	move.b	(a5)+,d5				; add $8000 to value
		move.w	d5,(a4)					; write value to VDP register
		add.w	d7,d5					; next register
		dbf	d1,VDPInitLoop				; loop until all registers are set up

		move.l	#$40000080,(a4)				; write DMA destination to VDP (VRAM 0000)
		move.w	d0,(a3)					; set DMA fill value to 00 (DMA starts here, clears entire VRAM)

		move.w	d7,(a1)					; stop the Z80
		move.w	d7,(a2)					; reset the Z80
WaitForZ80:	btst	d0,(a1)					; has the Z80 stopped?
		bne.s	WaitForZ80				; if not, loop until it has

		moveq	#SetupValues_Z80_End-SetupValues_Z80-1,d2 ; write all Z80 boot code
Z80InitLoop:	move.b	(a5)+,(a0)+				; write boot code to Z80 RAM
		dbf	d2,Z80InitLoop				; loop until all boot code has been written

		move.w	d0,(a2)					; set Z80 reset on
		move.w	d0,(a1)					; set Z80 stop off
		move.w	d7,(a2)					; set Z80 reset off

ClrRAMLoop:	move.l	d0,-(a6)				; clear 4 bytes of RAM
		dbf	d6,ClrRAMLoop				; repeat until the entire RAM is cleared

		move.l	#($8100+%0100)<<16|$8F00+%0010,(a4)	; VDP display mode and VDP increment
		move.l	#$C0000000,(a4)				; CRAM write mode
		moveq	#(palette_size)/4-1,d3

ClrCRAMLoop:	move.l	d0,(a3)
		dbf	d3,ClrCRAMLoop				; repeat until the entire CRAM is clear

		move.l	#$40000010,(a4)				; set VDP to VSRAM write
		moveq	#(vsram_size)/4-1,d4
ClrVSRAMLoop:	move.l	d0,(a3)					; clear 4 bytes of VSRAM
		dbf	d4,ClrVSRAMLoop				; repeat until the entire VSRAM is clear

		moveq	#SetupValues_PSG_End-SetupValues_PSG-1,d5 ; write to all PSG registers
PSGInitLoop:	move.b	(a5)+,psg_input-vdp_data_port-1(a3)	; write PSG volume values to PSG port ($C00011)
		dbf	d5,PSGInitLoop				; repeat for all channels

		move.w	d0,(a2)					; set Z80 reset on
		movem.l	(a6),d0-a6				; clear all registers
		disable_ints					; disable interrupts
		bra.s	GameProgram				; begin actual game
; ===========================================================================

SetupValues:	dc.l $8000					; VDP register start number
		dc.l (v_ram_end-v_ram_start_def)/4-1		; size of RAM/4 ($3FFF)
		dc.l $100					; VDP register diff

		dc.l z80_ram					; start of Z80 RAM
		dc.l z80_bus_request				; Z80 bus request
		dc.l z80_reset					; Z80 reset
		dc.l vdp_data_port				; VDP data
		dc.l vdp_control_port				; VDP control

	SetupValues_VDP:
		; Note that most of these are immediately overwritten again in VDPSetupArray
		dc.b %0100					; VDP $80 - 8-colour mode
		dc.b %00010100					; VDP $81 - Megadrive mode, DMA enable
		dc.b vram_fg>>10				; VDP $82 - foreground nametable address
		dc.b window_plane_icd>>10			; VDP $83 - window nametable address
		dc.b vram_bg>>13				; VDP $84 - background nametable address
		dc.b vram_sprites_icd>>9			; VDP $85 - sprite table address
		dc.b 0						; VDP $86 - unused
		dc.b 0						; VDP $87 - background colour
		dc.b 0						; VDP $88 - unused
		dc.b 0						; VDP $89 - unused
		dc.b 255					; VDP $8A - H_Int register
		dc.b 0						; VDP $8B - full screen scroll
		dc.b %10000001					; VDP $8C - 40 cell display
		dc.b vram_hscroll_icd>>10			; VDP $8D - hscroll table address
		dc.b 0						; VDP $8E - unused
		dc.b 1						; VDP $8F - VDP increment
		dc.b 1						; VDP $90 - 64 cell hscroll size
		dc.b 0						; VDP $91 - window h position
		dc.b 0						; VDP $92 - window v position
		dc.w $FFFF					; VDP $93/94 - DMA length
		dc.w 0						; VDP $95/96 - DMA source
		dc.b %10000000					; VDP $97 - DMA fill VRAM
	SetupValues_VDP_End:

	SetupValues_Z80:
		; Z80 instructions (not the sound driver; that gets loaded later)
		save
		CPU Z80						; start assembling Z80 code
		phase	0					; pretend we're at address 0

	zStartupCodeStartLoc:
		xor	a					; clear a to 0
		ld	bc,(z80_ram_end-z80_ram)-(zStartupCodeEndLoc-zStartupCodeStartLoc)-1 ; prepare to loop this many times
		ld	de,zStartupCodeEndLoc-zStartupCodeStartLoc+1 ; initial destination address
		ld	hl,zStartupCodeEndLoc-zStartupCodeStartLoc ; initial source address
		ld	sp,hl					; set the address the stack starts at
		ld	(hl),a					; set first byte of the stack to 0
		ldir						; loop to fill the stack (entire remaining available Z80 RAM) with 0
		pop	ix					; clear ix
		pop	iy					; clear iy
		ld	i,a					; clear i
		ld	r,a					; clear r
		ex	af,af'					; swap af with af'
		exx						; swap bc/de/hl with their shadow registers too
		pop	af					; clear af
		pop	bc					; clear bc
		pop	de					; clear de
		pop	hl					; clear hl
		ex	af,af'					; swap af with af'
		exx						; swap bc/de/hl with their shadow registers too
		pop	af					; clear af
		pop	de					; clear de
		pop	hl					; clear hl
		ld	sp,hl					; clear sp
		di						; clear iff1 (for interrupt handler)
		im	1					; interrupt handling mode = 1
		ld	(hl),0E9h				; replace the first instruction with a jump to itself
		jp	(hl)	 				; jump to the first instruction (to stay there forever)
	zStartupCodeEndLoc:
		dephase						; stop pretending
		restore
		padding off					; unfortunately our flags got reset so we have to set them again...
	SetupValues_Z80_End:

	SetupValues_PSG:
		dc.b $9F,$BF,$DF,$FF				; values for PSG channel volumes
	SetupValues_PSG_End:
; End of SetupValues


; ===========================================================================
; ---------------------------------------------------------------------------
; Proper game entry point for Sonic the Hedgehog after initialization
; ---------------------------------------------------------------------------

GameProgram:
		btst	#6,(expansion_control).l		; has port C been initialized?
		beq.s	CheckSumCheck				; if not, branch
		cmpi.l	#"init",(v_init).w			; has checksum routine already run?
		beq.w	GameInit				; if yes, branch

CheckSumCheck:
		movea.l	#EndOfHeader,a0				; start checking bytes after the header ($200)
		movea.l	#ROMEndLoc,a1				; stop at end of ROM
		move.l	(a1),d0					; retrieve long of ROM end
		moveq	#0,d1					; clear d1
	.loop:	add.w	(a0)+,d1				; add next byte value of ROM word
		cmp.l	a0,d0					; has iterator reached end of ROM?
		bhs.s	.loop					; if not, loop until so
		movea.l	#Checksum,a1				; read the checksum
		cmp.w	(a1),d1					; compare calculated value with checksum in ROM header
	if 0
		bne.w	CheckSumError				; if they don't match, a checksum error has occurred
	else
		nop						; removed the branch to the checksum error, so the checksum won't throw an error regardless of the value
		nop
	endif

CheckSumOk:
		lea	(v_crossresetram).w,a6			; load cross-reset RAM location
		moveq	#0,d7					; overwrite with 0
		move.w	#(v_ram_end-v_crossresetram)/4-1,d6	; write to all of cross-reset RAM ($FE00-$FFFF)
.clearRAM:	move.l	d7,(a6)+				; clear RAM
		dbf	d6,.clearRAM				; loop until done

		move.b	(console_version).l,d0			; get hardware information from console
		andi.b	#%11000000,d0				; filter to only overseas flag and PAL flag
		move.b	d0,(v_megadrive).w			; store region settings

		move.w	#1,(v_unused12).w			; set an unused flag to 1

		move.l	#"init",(v_init).w			; set flag so checksum won't run again

GameInit:
		lea	(v_ram_start).l,a6			; load start location of RAM
		moveq	#0,d7					; overwrite with 0
		move.w	#(v_crossresetram-v_ram_start_def)/4-1,d6 ; write to all of RAM except cross-reset RAM ($0000-$FDFF)
.clearRAM:	move.l	d7,(a6)+				; clear RAM
		dbf	d6,.clearRAM				; loop until done

		bsr.w	VDPSetupGame				; initialize (proper) VDP registers
		bsr.w	DACDriverLoad				; initialize Z80 DAC driver
		bsr.w	JoypadInit				; initialize controller ports
		move.b	#id_Sega,(v_gamemode).w			; set first Game Mode to Sega Screen

MainGameLoop:
		move.b	(v_gamemode).w,d0			; load Game Mode
		andi.w	#$1C,d0					; limit Game Mode value to $1C max (change to a maximum of 7C to add more game modes)
		jsr	GameModeArray(pc,d0.w)			; jump to apt location in ROM
		bra.s	MainGameLoop				; loop indefinitely
; ===========================================================================
; ---------------------------------------------------------------------------
; Main game mode array
; ---------------------------------------------------------------------------

GameModeArray:

gmptr:		macro gamemode,{INTLABEL}
__LABEL__:	label	*-GameModeArray
		bra.w	gamemode
		endm

id_Sega:	gmptr	GM_Sega					; Sega Screen ($00)
id_Title:	gmptr	GM_Title				; Title Screen ($04)
id_Demo:	gmptr	GM_Level				; Demo Mode ($08)
id_Level:	gmptr	GM_Level				; Normal Level ($0C)
id_Special:	gmptr	GM_Special				; Special Stage ($10)

		rts						; redundant rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Error handler
; ---------------------------------------------------------------------------

; Unused, as the checksum check doesn't care if the checksum is wrong.
ChecksumError:
		bsr.w	VDPSetupGame
		move.l	#$C0000000,(vdp_control_port).l		; Set VDP to CRAM write
		moveq	#(palette_size)/2-1,d7			; write to entire palette
.fillred:	move.w	#cRed,(vdp_data_port).l			; fill palette with red
		dbf	d7,.fillred				; repeat until CRAM is filled
		bra.s	*
; ===========================================================================

BusError:	move.b	#2,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithAddress		; continue to handler (with pc value)
; ---------------------------------------------------------------------------
AddressError:	move.b	#4,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithAddress		; continue to handler (with pc value)
; ---------------------------------------------------------------------------
IllegalInstr:	move.b	#6,(v_errortype).w			; set error code
		addq.l	#2,2(sp)				; skip over illegal instruction on recovery
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
ZeroDivide:	move.b	#8,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
ChkInstr:	move.b	#$A,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
TrapvInstr:	move.b	#$C,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
PrivilegeViol:	move.b	#$E,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
Trace:		move.b	#$10,(v_errortype).w			; set error code
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
Line1010Emu:	move.b	#$12,(v_errortype).w			; set error code
		addq.l	#2,2(sp)				; skip over illegal instruction on recovery
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
Line1111Emu:	move.b	#$14,(v_errortype).w			; set error code
		addq.l	#2,2(sp)				; skip over illegal instruction on recovery
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ---------------------------------------------------------------------------
ErrorExcept:	move.b	#0,(v_errortype).w			; set error code (generic fallback error)
		bra.s	ErrorHandler_WithoutAddress		; continue to handler
; ===========================================================================

; loc_43A:
ErrorHandler_WithAddress:
		disable_ints					; disable interrupts so we stay here
		addq.w	#2,sp					; skip sr value
		move.l	(sp)+,(v_spbuffer).w			; retrieve pc value from before the crash
		addq.w	#2,sp					; skip second sr value
		movem.l	d0-a7,(v_regbuffer).w			; backup all registers values from before the crash

		bsr.w	ShowErrorMessage			; write error text to screen
		move.l	2(sp),d0				; get error address
		bsr.w	ShowErrorValue				; write value to screen
		move.l	(v_spbuffer).w,d0			; get origin pc value
		bsr.w	ShowErrorValue				; write value to screen
		bra.s	ErrorHandler_TryRecovery		; skip over
; ===========================================================================

; loc_462:
ErrorHandler_WithoutAddress:
		disable_ints					; disable interrupts so we stay here
		movem.l	d0-a7,(v_regbuffer).w			; backup all registers values from before the crash

		bsr.w	ShowErrorMessage			; write error text to screen
		move.l	2(sp),d0				; load error address
		bsr.w	ShowErrorValue				; write value to screen
; ---------------------------------------------------------------------------

; loc_478:
ErrorHandler_TryRecovery:
		bsr.w	ErrorWaitForC				; loop until C has been pressed
		movem.l	(v_regbuffer).w,d0-a7			; restore registers before exception
		enable_ints					; enable ints
		rte						; try resuming normal operation (may or may not work, depending on type of crash)
; ===========================================================================

ShowErrorMessage:
		lea	(vdp_data_port).l,a6			; set VDP data port
		locVRAM	ArtTile_Error_Handler_Font*tile_size	; set target VRAM location for error text font
		lea	(Art_Text).l,a0				; load error text font
		move.w	#(Art_Text_end-Art_Text-tile_size)/2-1,d1 ; load font (strangely, this does not load the final tile)
.loadgfx:	move.w	(a0)+,(a6)				; dump graphics to VRAM
		dbf	d1,.loadgfx				; loop until font has been loaded

		moveq	#0,d0					; clear d0
		move.b	(v_errortype).w,d0			; load error code
		move.w	ErrorText(pc,d0.w),d0			; find offset in error texts array
		lea	ErrorText(pc,d0.w),a0			; load error text for error code
		locVRAM	vram_fg+(12*$80)+(2*2)			; write error message directly to plane A nametable (row 12 + column 2 = $C04)
		moveq	#19-1,d1				; number of characters in error text message (minus 1)
.showchars:	moveq	#0,d0					; clear d0
		move.b	(a0)+,d0				; get next character from error text
		addi.w	#-'0'+ArtTile_Error_Handler_Font,d0	; rebase from ASCII to a VRAM index
		move.w	d0,(a6)					; write to VRAM
		dbf	d1,.showchars				; repeat for number of characters
		rts						; return
; End of function ShowErrorMessage
; ===========================================================================

ErrorText:	dc.w .exception-ErrorText			; 0
		dc.w .bus-ErrorText				; 2
		dc.w .address-ErrorText				; 4
		dc.w .illinstruct-ErrorText			; 6
		dc.w .zerodivide-ErrorText			; 8
		dc.w .chkinstruct-ErrorText			; $A
		dc.w .trapv-ErrorText				; $C
		dc.w .privilege-ErrorText			; $E
		dc.w .trace-ErrorText				; $10
		dc.w .line1010-ErrorText			; $12
		dc.w .line1111-ErrorText			; $14

.exception:	dc.b "ERROR EXCEPTION    "
.bus:		dc.b "BUS ERROR          "
.address:	dc.b "ADDRESS ERROR      "
.illinstruct:	dc.b "ILLEGAL INSTRUCTION"
.zerodivide:	dc.b "@ERO DIVIDE        "			; Note: @ is Z due to the font arrangement
.chkinstruct:	dc.b "CHK INSTRUCTION    "
.trapv:		dc.b "TRAPV INSTRUCTION  "
.privilege:	dc.b "PRIVILEGE VIOLATION"
.trace:		dc.b "TRACE              "
.line1010:	dc.b "LINE 1010 EMULATOR "
.line1111:	dc.b "LINE 1111 EMULATOR "
		even

; ===========================================================================

; Input: d0 = number to write (8 digits)
ShowErrorValue:
		move.w	#ArtTile_Error_Handler_Font+$A,(a6)	; display "$" symbol
		moveq	#8-1,d2					; write 8 digits
	.loop:	rol.l	#4,d0					; shift to next digit
		bsr.s	.writeDigit				; write number to VRAM
		dbf	d2,.loop				; loop until done
		rts						; return
; ---------------------------------------------------------------------------

.writeDigit:
		move.w	d0,d1					; make a copy (need to preserve d0 for the loop)
		andi.w	#$F,d1					; limit digit to one nybble
		cmpi.w	#$A,d1					; is digit $A-$F?
		blo.s	.write					; if not, branch
		addq.w	#7,d1					; adjust tile offset for hex letters
	.write:	addi.w	#ArtTile_Error_Handler_Font,d1		; add art tile offset
		move.w	d1,(a6)					; write to VRAM nametable
		rts						; return
; End of function ShowErrorValue
; ===========================================================================

ErrorWaitForC:
		bsr.w	ReadJoypads				; keep reading joypads
		cmpi.b	#btnC,(v_jpadpress1).w			; has button C been pressed?
		bne.w	ErrorWaitForC				; if not, keep looping
		rts						; return to try recovering execution
; End of function ErrorWaitForC
; End of error handler (as a whole)


; ===========================================================================
; ---------------------------------------------------------------------------
; Uncompressed art text for debug mode, level select, and errors
; (formerly "menutext.bin")
; ---------------------------------------------------------------------------

Art_Text:	binclude	"artunc/Level Select & Debug Text.bin"
Art_Text_end:
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Vertical interrupt
; ---------------------------------------------------------------------------

VBlank:
		movem.l	d0-a6,-(sp)				; backup all registers except stack pointer (a7)

		tst.b	(v_vblank_routine).w			; was a VBlank routine set?
		beq.s	VBlank_Exit

		move.w	(vdp_control_port).l,d0			; clear write-pending flag in VDP (prevents issues if 68k was reset while writing a command to VDP)
		move.l	#$40000010,(vdp_control_port).l		; set VDP to VSRAM write mode
		move.l	(v_scrposy_vdp).w,(vdp_data_port).l	; send screen y-axis pos. to VSRAM

		; Wait here in a loop doing nothing for a while. This seems to be a pretty harsh attempt
		; to push CRAM dots outside of the visible view area, due to Sonic 1 not using all
		; the available screen space PAL offers, as they would otherwise be seen at the bottom.
		btst	#6,(v_megadrive).w			; are we on a PAL machine?
		beq.s	.notPAL					; if not, branch
		move.w	#$700,d0				; intentionally lag the control port to move the CRAM dots on PAL machines
	.waitPAL:
		dbf	d0,.waitPAL

.notPAL:
		move.b	(v_vblank_routine).w,d0			; copy specified VBlank routine to d0
		move.b	#id_VBlank_00,(v_vblank_routine).w		; reset actual routine to return
		move.w	#1,(f_hblank).w				; set HInt flag (unused)
		andi.w	#$3E,d0					; mask out irrelevant bits in VBlank routine
		move.w	VBlank_Index(pc,d0.w),d0			; load address to relevant VBlank routine
		jsr	VBlank_Index(pc,d0.w)			; jump to VBlank routine and then return here

VBlank_Exit:
		addq.l	#1,(v_vblank_count).w			; increment VBlank counter
		jsr	(UpdateMusic).l				; run sound driver to advance music
		movem.l	(sp)+,d0-a6				; restore all backed-up registers
		rte						; return from interrupt and resume normal operation

; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 00 - Return to caller
; ---------------------------------------------------------------------------

VBlank_00:
		rts
; ===========================================================================
VBlank_Index:

vbptr:		macro vblankmode,{INTLABEL}
__LABEL__:	label	*-VBlank_Index
		dc.w	vblankmode-VBlank_Index
		endm

id_VBlank_00:	vbptr	VBlank_00				; $00 - (return to caller)
id_VBlank_02:	vbptr	VBlank_02				; $02 - Sega Screen
id_VBlank_04:	vbptr	VBlank_04				; $04 - Title Screen
id_VBlank_06:	vbptr	VBlank_06				; $06 - (unused)
id_VBlank_08:	vbptr	VBlank_08				; $08 - Levels, Demos
id_VBlank_0A:	vbptr	VBlank_0A				; $0A - Special Stage
id_VBlank_0C:	vbptr	VBlank_0C				; $0C - Title Cards
id_VBlank_0E:	vbptr	VBlank_0E				; $0E - (unused)
id_VBlank_10:	vbptr	VBlank_10				; $10 - Paused
id_VBlank_12:	vbptr	VBlank_12				; $12 - Palette Fade
; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 02 - Sega Screen
; ---------------------------------------------------------------------------

VBlank_02:
		bsr.w	VBlank_StandardTransfers		; do standard screen transfers
		tst.w	(v_generictimer).w			; is generic timer set?
		beq.w	.end					; if not, branch
		subq.w	#1,(v_generictimer).w			; decrement generic timer
	.end:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 04 - Title Screen, Level Select
; ---------------------------------------------------------------------------

VBlank_04:
		bsr.w	VBlank_StandardTransfers		; do standard screen transfers
		bsr.w	LoadTilesAsYouMove_BGOnly		; update background tiles as title screen scrolls
		bsr.w	ProcessPLC_9Tiles			; decompress up to 9 Nemesis-compressed tiles

		tst.w	(v_generictimer).w			; is generic timer set?
		beq.w	.end					; if not, branch
		subq.w	#1,(v_generictimer).w			; decrement generic timer
	.end:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 06 - Unused
; ---------------------------------------------------------------------------

VBlank_06:
		bsr.w	VBlank_StandardTransfers		; do standard screen transfers
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 10 - While game is paused
; ---------------------------------------------------------------------------

VBlank_10:
		cmpi.b	#id_Special,(v_gamemode).w		; is game on special stage?
		beq.w	VBlank_0A				; if yes, branch
		; fall-through...

; ---------------------------------------------------------------------------
; VBlank 08 - Levels and Demos
; ---------------------------------------------------------------------------

VBlank_08:
		bsr.w	ReadJoypads				; read joypads and update buffered inputs in RAM
		stopZ80						; request Z80 stop
		waitZ80						; wait until Z80 has stopped

		writeCRAM	v_palette,0			; write palette buffer to CRAM
		writeVRAM	v_hscrolltablebuffer,vram_hscroll ; transfer H-scroll buffer table to actual H-scroll VRAM

		move.w	#vreg_bgvram|vram_bg>>13,(a5)		; set vram for background plane register
		move.w	(v_hblank_hreg).w,(a5)			; write HBlank trigger scan line for water palette swap to VDP
		move.w	(v_bg3scrposy_vdp).w,(v_bg3scrposy_vdp_dup).w

		writeVRAM	v_spritetablebuffer,vram_sprites  ; transfer sprite buffer table to actual sprites VRAM

		tst.b	(f_sonframechg).w			; has Sonic's sprite changed?
		beq.s	.nochg					; if not, branch
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w			; clear Sonic gfx update flag
	.nochg:

		startZ80					; restart Z80
		bsr.w	LoadTilesAsYouMove			; update level tiles while screen is moving
		jsr	(AnimateLevelGfx).l			; updated animated tiles
		jsr	(UpdateHUD).l				; update HUD data
		bsr.w	ProcessPLC_3Tiles			; decompress up to 3 Nemesis-compressed tiles (instead of the usual 9)
		moveq	#0,d0
		move.b	(v_lvlcount).w,d0			; get level counter
		move.b	(v_lvlcount2).w,d1			; get secondary level counter
		cmp.b	d0,d1					; compare level counters
		bhs.s	.higherorequal				; if higher or equal, branch
		move.b	d0,(v_lvlcount2).w			; send level counter value to secondary level counter
	.higherorequal:

		move.b	#0,(v_lvlcount).w			; clear level counter
		tst.w	(v_generictimer).w			; is generic timer set?
		beq.w	.end					; if not, branch
		subq.w	#1,(v_generictimer).w			; decrement generic timer
	.end:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 0A - Special Stages
; ---------------------------------------------------------------------------

VBlank_0A:
		bsr.w	ReadJoypads				; read joypads and update buffered inputs in RAM
		stopZ80						; request Z80 stop
		waitZ80						; wait until Z80 has stopped
		writeCRAM	v_palette,0			; write palette buffer to CRAM
		writeVRAM	v_spritetablebuffer,vram_sprites  ; transfer sprite buffer table to actual sprites VRAM
		writeVRAM	v_hscrolltablebuffer,vram_hscroll ; transfer H-scroll buffer table to actual H-scroll VRAM
		startZ80					; restart Z80

		bsr.w	PalCycle_SS				; advance special stage palette cycle and animate bird/fish graphics

		tst.b	(f_sonframechg).w			; has Sonic's sprite changed?
		beq.s	.nochg					; if not, branch
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w			; clear Sonic gfx update flag
	.nochg:

		tst.w	(v_generictimer).w			; is generic timer set?
		beq.w	.end					; if not, branch
		subq.w	#1,(v_generictimer).w			; decrement generic timer
	.end:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 0C - While title cards are displayed (Levels)
; ---------------------------------------------------------------------------

VBlank_0C:
		bsr.w	ReadJoypads				; read joypads and update buffered inputs in RAM
		stopZ80						; request Z80 stop
		waitZ80						; wait until Z80 has stopped
		writeCRAM	v_palette,0			; write palette buffer to CRAM
		writeVRAM	v_spritetablebuffer,vram_sprites  ; transfer sprite buffer table to actual sprites VRAM
		writeVRAM	v_hscrolltablebuffer,vram_hscroll ; transfer H-scroll buffer table to actual H-scroll VRAM
		tst.b	(f_sonframechg).w			; has Sonic's sprite changed?
		beq.s	.nochg					; if not, branch
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size ; load new Sonic gfx
		move.b	#0,(f_sonframechg).w			; clear Sonic gfx update flag
	.nochg:

		startZ80					; restart Z80
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(UpdateHUD).l
		bsr.w	ProcessPLC_9Tiles			; decompress up to 9 Nemesis-compressed tiles
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 0E - Unused
; ---------------------------------------------------------------------------

VBlank_0E:
		bsr.w	VBlank_StandardTransfers		; do standard screen transfers
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		addq.b	#1,(v_lvlcount).w			; increase level counter
		move.b	#id_VBlank_0E,(v_vblank_routine).w	; set itself to land back here again if not further altered
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; VBlank 12 - During palette fades
; ---------------------------------------------------------------------------

VBlank_12:
		bsr.w	VBlank_StandardTransfers		; do standard screen transfers
		bra.w	ProcessPLC_9Tiles			; decompress up to 9 Nemesis-compressed tiles
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to perform standard VRAM transfers (palette, sprites, H-scroll)
; ---------------------------------------------------------------------------

VBlank_StandardTransfers:
		bsr.w	ReadJoypads				; read joypads and update buffered inputs in RAM
		stopZ80						; request Z80 stop
		waitZ80						; wait until Z80 has stopped
		writeCRAM	v_palette,0			; write palette buffer to CRAM
		writeVRAM	v_spritetablebuffer,vram_sprites  ; transfer sprite buffer table to actual sprites VRAM
		writeVRAM	v_hscrolltablebuffer,vram_hscroll ; transfer H-scroll buffer table to actual H-scroll VRAM
		startZ80					; restart Z80
		rts
; End of function VBla_StandardTransfers

; ===========================================================================
; ---------------------------------------------------------------------------
; Horizontal interrupt (unused)
; Transfers 68K fading palette to CRAM.
; ---------------------------------------------------------------------------

HBlank:
		tst.w	(f_hblank).w				; is hblank flag enabled?
		beq.s	.return					; if not, branch

		move.l	a5,-(sp)				; backup a5 register
		writeCRAM	v_palette_fading,0		; write fading palette buffer to CRAM
		movem.l	(sp)+,a5				; pop register from stack

		move.w	#0,(f_hblank).w				; clear hblank flag

.return:
		rte						; return from horizontal interrupt and resume normal operation
; End of function HBlank


; ===========================================================================
; ---------------------------------------------------------------------------
; Secondary horizontal interrupt (unused)
; Initializes background plane and sprite locations, loads sprites into VRAM,
; transfers sprite table into sprite VRAM.
; ---------------------------------------------------------------------------

HBlank2:
		tst.w	(f_hblank).w				; is hblank flag enabled?
		beq.s	.return					; if not, branch

		movem.l	d0/a0/a5,-(sp)				; backup d0, a0 and a5 registers
		move.w	#0,(f_hblank).w				; clear hblank flag
		move.w	#vreg_bgvram|(vram_win>>13),(vdp_control_port).l ; set background nametable address
		move.w	#vreg_spritevram|(vram_sprites>>9),(vdp_control_port).l	; set sprite table address
		locVRAM vram_sprites				; set VRAM target location to sprite table
		lea	(v_spritetablebuffer).w,a0		; load sprite table buffer to a0
		lea	(vdp_data_port).l,a5			; load VDP data port to a5
		move.w	#(v_spritetablebuffer_end-v_spritetablebuffer)/4-1,d0 ; set repeat times

.spriteTableToVDP:
		move.l	(a0)+,(a5)				; move sprite table buffer to VDP data port
		dbf	d0,.spriteTableToVDP			; repeat until the entirety of the sprite table buffer has been written

		movem.l	(sp)+,d0/a0/a5				; restore d0, a0 and a5

.return:
		rte						; return from horizontal interrupt and resume normal operation
; End of function HBlank2


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to initialise joypads (run once during boot)
; ---------------------------------------------------------------------------

JoypadInit:
		stopZ80						; request Z80 stop on
		waitZ80						; wait until it has stopped
		moveq	#$40,d0					; prepare initialise value
		move.b	d0,(port_1_control).l			; init port 1 (joypad 1)
		move.b	d0,(port_2_control).l			; init port 2 (joypad 2)
		move.b	d0,(expansion_control).l		; init port 3 (expansion/extra)
		startZ80					; request Z80 stop off
		rts
; End of function JoypadInit

; ---------------------------------------------------------------------------
; Subroutine to read joypad input, and send it to the RAM
; ---------------------------------------------------------------------------

ReadJoypads:
		stopZ80						; request Z80 stop on
		waitZ80						; wait until it has stopped
		lea	(v_jpadhold1).w,a0			; address where joypad states are written
		lea	(port_1_data).l,a1			; first joypad port
		bsr.s	.read					; do the first joypad
		addq.w	#2,a1					; do the second joypad (port_2_data)
		bsr.s	.read					; second joypad port
		startZ80					; request Z80 stop off
		rts

.read:
		move.b	#0,(a1)					; read A and Start input (TH poll low)
		nop						; wait a bit
		nop						; ''
		move.b	(a1),d0					; write A and Start input states to d0

		lsl.b	#2,d0					; move A and Start to topmost bits
		andi.b	#%11000000,d0				; clear all other inputs from the poll

		move.b	#$40,(a1)				; read D-Pad, B, and C input (TH poll high)
		nop						; wait a bit
		nop						; ''
		move.b	(a1),d1					; write D-Pad, B, and C input states to d1

		andi.b	#%00111111,d1				; clear all other inputs from the poll
		or.b	d1,d0					; merge but poll results into d0
		not.b	d0					; flip bits so that 0=released and 1=pressed

		move.b	(a0),d1					; get buttons pressed the previous frame
		eor.b	d0,d1					; XOR with buttons pressed this frame

		move.b	d0,(a0)+				; write HELD buttons
		and.b	d0,d1					; find buttons pressed this frame
		move.b	d1,(a0)+				; write PRESSED buttons
		rts						; return to VBlank routine
; End of function ReadJoypads


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to setup the VDP with values used for the game itself
; ---------------------------------------------------------------------------

VDPSetupGame:
		lea	(vdp_control_port).l,a0
		lea	(vdp_data_port).l,a1
		lea	(VDPSetupArray).l,a2
		moveq	#(VDPSetupArray_End-VDPSetupArray)/2-1,d7

.setreg:
		move.w	(a2)+,(a0)
		dbf	d7,.setreg
		move.w	(VDPSetupArray+2).l,d0
		move.w	d0,(v_vdp_buffer1).w
		moveq	#0,d0
		move.l	#$C0000000,(vdp_control_port).l
		move.w	#(palette_size)/2-1,d7

.clrCRAM:
		move.w	d0,(a1)
		dbf	d7,.clrCRAM
		clr.l	(v_scrposy_vdp).w
		clr.l	(v_scrposx_vdp).w
		move.l	d1,-(sp)
		fillVRAM	0,0,$10000
		move.l	(sp)+,d1
		rts
; ===========================================================================
VDPSetupArray:
		dc.w vreg_mode1|%000100				; 8-color mode
		dc.w vreg_mode2|%00110100			; vertical interrupts, DMA, Mega Drive display
		dc.w vreg_fgvram|(vram_fg>>10)			; foreground nametable address
		dc.w vreg_winvram|(vram_win>>10)		; window nametable address
		dc.w vreg_bgvram|(vram_bg>>13)			; background nametable address
		dc.w vreg_spritevram|(vram_sprites>>9)		; sprite table address
		dc.w $8600					; (unused, only relevant for 128KB VRAM mode)
		dc.w vreg_bgcolor|0<<4|0			; background colour (palette line 0, entry 0)
		dc.w $8800					; (unused, only relevant for Master System)
		dc.w $8900					; (unused, only relevant for Master System)
		dc.w vreg_hintrate|$00				; horizontal interrupt register
		dc.w vreg_mode3|%0000				; full-screen vertical scrolling
		dc.w vreg_mode4|%10000001			; 40-cell display mode
		dc.w vreg_hscrollvram|(vram_hscroll>>10)	; background H-scroll address
		dc.w $8E00					; (unused, only relevant for 128KB VRAM mode)
		dc.w vreg_autoinc|2				; VDP auto-increment size (2)
		dc.w vreg_planesize|%000001			; 64-cell H-scroll size
		dc.w vreg_winxpos|0				; window horizontal position
		dc.w vreg_winypos|0				; window vertical position
VDPSetupArray_End:

; ---------------------------------------------------------------------------
; Subroutine to clear the screen
; ---------------------------------------------------------------------------

ClearScreen:
		fillVRAM	0, vram_fg, vram_fg+plane_size_64x32		; clear foreground namespace
		fillVRAM	0, vram_bg, vram_bg+plane_size_64x32		; clear background namespace

		move.l	#0,(v_scrposy_vdp).w
		move.l	#0,(v_scrposx_vdp).w

	if FixBugs
		clearRAM v_spritetablebuffer,v_spritetablebuffer_end
		clearRAM v_hscrolltablebuffer,v_hscrolltablebuffer_end_padded
	else
		clearRAM v_spritetablebuffer,v_spritetablebuffer_end+4	; This clears too much RAM, but this won't effect much since water palettes don't exist.
		clearRAM v_hscrolltablebuffer,v_hscrolltablebuffer_end_padded+4	; This clears too much RAM, leading to a slight bug (first bit of the Sonic object's RAM is cleared)
	endif

		rts
; End of function ClearScreen

; ---------------------------------------------------------------------------
; Subroutine to load the DAC driver
; ---------------------------------------------------------------------------

; SoundDriverLoad:
DACDriverLoad:
		nop
		stopZ80
		deassertZ80Reset
		lea	(DACDriver).l,a0
		lea	(z80_ram).l,a1
		move.w	#(DACDriver_End-DACDriver)-1,d0

.loadDAC:
		move.b	(a0)+,(a1)+
		dbf	d0,.loadDAC

		moveq	#0,d0
		lea	(z80_ram+zVoiceTblAdr).l,a1
		move.b	d0,(a1)+				; Write 0 to 1FF8
		move.b	#$80,(a1)+				; Write $80 to 1FF9 (zVoiceTblAdr = 8000h)
		move.b	#make68kBank($38000),(a1)+		; Write unknown bank address $38000 (7) to 1FFA
		move.b	#$80,(a1)+				; Write $80 to 1FFB (zBank = 8007h)
		move.b	d0,(a1)+				; Write 0 to 1FFC
		move.b	d0,(a1)+				; Write 0 to 1FFD
		move.b	d0,(a1)+				; Write 0 to 1FFE
		move.b	d0,(a1)+				; Write 0 to 1FFF
		assertZ80Reset
		nop
		nop
		nop
		nop
		deassertZ80Reset
		startZ80
		rts
; End of function DACDriverLoad

; ---------------------------------------------------------------------------
; Unused bytes.
; My thought is that these are external variables for a Z80 Sound Driver (which doesn't exist here).
; ---------------------------------------------------------------------------
;unk_119C:
		dc.b 3
		dc.b 0
		dc.w little_endian($1400)
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0

		include	"_include/Queue Sound Routines.asm"
		include "_include/PauseGame.asm"

; ---------------------------------------------------------------------------
; Subroutine to copy a tile map from RAM to VRAM namespace

; input:
;	a1 = tile map address
;	d0 = VRAM address
;	d1 = width (cells)
;	d2 = height (cells)
; ---------------------------------------------------------------------------

TilemapToVRAM:
		lea	(vdp_data_port).l,a6
		move.l	#$800000,d4

Tilemap_Line:
		move.l	d0,4(a6)				; move d0 to VDP_control_port
		move.w	d1,d3

Tilemap_Cell:
		move.w	(a1)+,(a6)				; write value to namespace
		dbf	d3,Tilemap_Cell				; next tile
		add.l	d4,d0					; go to next line
		dbf	d2,Tilemap_Line				; next line
		rts
; End of function TilemapToVRAM

		include "_include/Decompression/Nemesis Decompression.asm"

; ---------------------------------------------------------------------------
; Subroutine to load pattern load cues (aka to queue pattern load requests)
; ---------------------------------------------------------------------------

; ARGUMENTS
; d0 = index of PLC list
; ---------------------------------------------------------------------------

; LoadPLC:
AddPLC:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1				; jump to relevant PLC
		lea	(v_plc_buffer).w,a2			; PLC buffer space

.findspace:
		tst.l	(a2)					; is space available in RAM?
		beq.s	.copytoRAM				; if yes, branch
		addq.w	#6,a2					; if not, try next space
		bra.s	.findspace
; ===========================================================================

.copytoRAM:
		move.w	(a1)+,d0				; get length of PLC
		bmi.s	.skip

.loop:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+				; copy PLC to RAM
		dbf	d0,.loop				; repeat for length of PLC

.skip:
		movem.l	(sp)+,a1-a2				; a1=object
		rts
; End of function AddPLC

; ---------------------------------------------------------------------------
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
		lea	(a1,d0.w),a1				; jump to relevant PLC
		bsr.s	ClearPLC				; erase any data in PLC buffer space
		lea	(v_plc_buffer).w,a2
		move.w	(a1)+,d0				; get length of PLC
		bmi.s	.skip					; if it's negative, skip the next loop

.loop:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+				; copy PLC to RAM
		dbf	d0,.loop				; repeat for length of PLC

.skip:
		movem.l	(sp)+,a1-a2
		rts
; End of function NewPLC

; ---------------------------------------------------------------------------
; Subroutine to	clear the pattern load cues
; ---------------------------------------------------------------------------

; Clear the pattern load queue ($FFF680 - $FFF700)

ClearPLC:
		lea	(v_plc_buffer).w,a2			; PLC buffer space in RAM
		moveq	#(v_plc_buffer_end-v_plc_buffer)/4-1,d0

.clrRAM:
		clr.l	(a2)+
		dbf	d0,.clrRAM
		rts
; End of function ClearPLC

; ---------------------------------------------------------------------------
; Subroutine to use graphics listed in a pattern load cue
; ---------------------------------------------------------------------------

RunPLC:
		tst.l	(v_plc_buffer).w
		beq.s	Rplc_Exit
		tst.w	(v_plc_patternsleft).w
		bne.s	Rplc_Exit
		movea.l	(v_plc_buffer).w,a0
		lea	(NemPCD_WriteRowToVDP).l,a3
		lea	(v_ngfx_buffer).w,a1
		move.w	(a0)+,d2
		bpl.s	loc_1404
		adda.w	#NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP,a3

loc_1404:
		andi.w	#$7FFF,d2
	if FixBugs=0
		move.w	d2,(v_plc_patternsleft).w
	endif
		bsr.w	NemDec_BuildCodeTable
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6
		moveq	#0,d0
		move.l	a0,(v_plc_buffer).w
		move.l	a3,(v_plc_ptrnemcode).w
		move.l	d0,(v_plc_repeatcount).w
		move.l	d0,(v_plc_paletteindex).w
		move.l	d0,(v_plc_previousrow).w
		move.l	d5,(v_plc_dataword).w
		move.l	d6,(v_plc_shiftvalue).w
	if FixBugs
		; Fix a race condition with Pattern Load Cues
		; https://info.sonicretro.org/SCHG_How-to:Fix_a_race_condition_with_Pattern_Load_Cues
		move.w	d2,(v_plc_patternsleft).w
	endif

Rplc_Exit:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to decompress and dump a specified number of Nemesis-compressed
; PLC tiles from the PLC process list to VRAM. These are called from VBlank,
; probably done to smooth out level loading because of how slow Nemesis is.
; ---------------------------------------------------------------------------

ProcessPLC_9Tiles:
		tst.w	(v_plc_patternsleft).w
		beq.w	locret_14D0
		move.w	#9,(v_plc_framepatternsleft).w		; process 9 Nemesis-compressed tiles
		moveq	#0,d0
		move.w	(v_plc_buffer+4).w,d0
		addi.w	#$120,(v_plc_buffer+4).w
		bra.s	ProcessDPLC
; ===========================================================================

ProcessPLC_3Tiles:
		tst.w	(v_plc_patternsleft).w
		beq.s	locret_14D0
		move.w	#3,(v_plc_framepatternsleft).w		; process 3 Nemesis-compressed tiles
		moveq	#0,d0
		move.w	(v_plc_buffer+4).w,d0
		addi.w	#$60,(v_plc_buffer+4).w

ProcessDPLC:
		lea	(vdp_control_port).l,a4
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(a4)
		subq.w	#4,a4
		movea.l	(v_plc_buffer).w,a0
		movea.l	(v_plc_ptrnemcode).w,a3
		move.l	(v_plc_repeatcount).w,d0
		move.l	(v_plc_paletteindex).w,d1
		move.l	(v_plc_previousrow).w,d2
		move.l	(v_plc_dataword).w,d5
		move.l	(v_plc_shiftvalue).w,d6
		lea	(v_ngfx_buffer).w,a1

loc_14A0:
		movea.w	#8,a5
		bsr.w	NemPCD_NewRow
		subq.w	#1,(v_plc_patternsleft).w
		beq.s	ShiftPLC
		subq.w	#1,(v_plc_framepatternsleft).w
		bne.s	loc_14A0
		move.l	a0,(v_plc_buffer).w
		move.l	a3,(v_plc_ptrnemcode).w
		move.l	d0,(v_plc_repeatcount).w
		move.l	d1,(v_plc_paletteindex).w
		move.l	d2,(v_plc_previousrow).w
		move.l	d5,(v_plc_dataword).w
		move.l	d6,(v_plc_shiftvalue).w

locret_14D0:
		rts
; ===========================================================================

ShiftPLC:
		lea	(v_plc_buffer).w,a0
		moveq	#(v_plc_buffer_only_end-v_plc_buffer-6)/4-1,d0

.loop:
		move.l	6(a0),(a0)+
		dbf	d0,.loop

	if FixBugs
		; The above code does not properly 'pop' the 16th PLC entry.
		; Because of this, occupying the 16th slot will cause it to
		; be repeatedly decompressed infinitely.
		; Granted, this could be conisdered more of an optimisation
		; than a bug: treating the 16th entry as a dummy that
		; should never be occupied makes this code unnecessary.
		; Still, the overhead of this code is minimal.
	if (v_plc_buffer_only_end-v_plc_buffer-6)&2
		move.w	6(a0),(a0)
	endif

		clr.l	(v_plc_buffer_only_end-6).w
	endif

		rts
; ===========================================================================

QuickPLC:
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,d1

.loop:
		movea.l	(a1)+,a0
		moveq	#0,d0
		move.w	(a1)+,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(vdp_control_port).l
		bsr.w	NemDec
		dbf	d1,.loop
		rts

		include "_include/Decompression/Enigma Decompression.asm"
		include "_include/Decompression/Kosinski Decompression.asm"
		include "_include/PaletteCycle.asm"

Pal_TitleCyc:	binclude	"palette/Cycle - Title.bin"
Pal_GHZCyc:	binclude	"palette/Cycle - GHZ.bin"
Pal_LZCyc:	binclude	"palette/Cycle - LZ (Unused).bin"
Pal_MZCyc:	binclude	"palette/Cycle - MZ (Unused).bin"
Pal_SLZCyc:	binclude	"palette/Cycle - SLZ.bin"
Pal_SZ1Cyc:	binclude	"palette/Cycle - SZ1.bin"
Pal_SZ2Cyc:	binclude	"palette/Cycle - SZ2.bin"

		include	"_include/Palette Fading.asm"

; ===========================================================================

PalCycle_Sega:
		subq.w	#1,(v_pcyc_time).w	; decrement timer
		bpl.s	.return	; if time remains, branch

		move.w	#3,(v_pcyc_time).w	; reset timer to 3 frames
		move.w	(v_pcyc_num).w,d0	; get cycle number
		bmi.s	.return	; if negative, return
		subq.w	#2,(v_pcyc_num).w	; decrement cycle number by 2
		lea	(Pal_SegaCyc).l,a0
		lea	(v_palette_line_1+4).w,a1
		adda.w	d0,a0
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)+

.return:
		rts
; End of function PalCycle_Sega

; ===========================================================================
Pal_SegaCyc:	binclude	"palette/Cycle - Sega.bin"
; ===========================================================================

PalLoad1:
		lea	(Pal_Index).l,a1
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
; ===========================================================================

PalLoad2:
		lea	(Pal_Index).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		move.w	(a1)+,d7

.loop:
		move.l	(a2)+,(a3)+
		dbf	d7,.loop
		rts
; ===========================================================================

		include "_include/Palette Index.asm"

Pal_SegaBG:	binclude	"palette/Sega Screen.bin"
Pal_Title:	binclude	"palette/Title Screen.bin"
Pal_LevelSel:	binclude	"palette/Level Select.bin"
Pal_Sonic:	binclude	"palette/Sonic.bin"
Pal_GHZ:	binclude	"palette/Green Hill Zone.bin"
Pal_LZ:		binclude	"palette/Labyrinth Zone.bin"
Pal_Unused:	binclude	"palette/Unused.bin"
Pal_MZ:		binclude	"palette/Marble Zone.bin"
Pal_SLZ:	binclude	"palette/Star Light Zone.bin"
Pal_SZ:		binclude	"palette/Sparkling Zone.bin"
Pal_CWZ:	binclude	"palette/Clock Work Zone.bin"
Pal_Special:	binclude	"palette/Special Stage.bin"

; ===========================================================================

WaitForVBlank:
		enable_ints

.wait:
		tst.b	(v_vblank_routine).w
		bne.s	.wait
		rts
; ===========================================================================

		include	"obj/sub RandomNumber.asm"
		include	"obj/sub CalcSine.asm"
		include	"obj/sub CalcSqrt.asm"
		include	"obj/sub CalcAngle.asm"

; ===========================================================================

GM_Sega:
		move.b	#bgm_Fade,d0
		bsr.w	QueueSound2
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#vreg_mode1|%0100,(a6)
		move.w	#vreg_fgvram|(vram_fg>>10),(a6)
		move.w	#vreg_bgvram|(vram_bg>>13),(a6)
		move.w	#vreg_bgcolor|0,(a6)
		move.w	#vreg_mode3|0,(a6)
		disable_display
		bsr.w	ClearScreen
		locVRAM ArtTile_Sega_Tiles*tile_size
		lea	(Nem_SegaLogo).l,a0
		bsr.w	NemDec
		lea	(v_ram_start).l,a1
		lea	(Eni_SegaLogo).l,a0
		move.w	#ArtTile_Sega_Tiles,d0
		bsr.w	EniDec

		copyTilemap	v_ram_start,vram_fg+$61C,12,4

		moveq	#palid_SegaBG,d0
		bsr.w	PalLoad2
		move.w	#40,(v_pcyc_num).w			; set cycle number to 40
		move.w	#0,(v_pal_buffer+$12).w
		move.w	#0,(v_pal_buffer+$10).w
		move.w	#60*3,(v_generictimer).w		; run Sega screen for 3 seconds
		enable_display

Sega_MainLoop:
		move.b	#id_VBlank_02,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	PalCycle_Sega
		tst.w	(v_generictimer).w			; has generic timer reached zero?
		beq.s	.timerfinished				; if so, branch
		andi.b	#btnStart,(v_jpadpress1).w		; check if Start is pressed
		beq.s	Sega_MainLoop				; if not, branch

.timerfinished:
		move.b	#id_Title,(v_gamemode).w		; go to Title screen
		rts
; ===========================================================================

GM_Title:
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#vreg_mode1|%0100,(a6)
		move.w	#vreg_fgvram|(vram_fg>>10),(a6)
		move.w	#vreg_bgvram|(vram_bg>>13),(a6)
		move.w	#vreg_planesize|%0001,(a6)
		move.w	#vreg_winypos|0,(a6)
		move.w	#vreg_mode3|%0011,(a6)
		move.w	#vreg_bgcolor|%00100000,(a6)
		disable_display
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
		move.w	#(Art_Text_end-Art_Text)/2-1,d1

.loadtext:
		move.w	(a5)+,(a6)
		dbf	d1,.loadtext

	if FixBugs
		; Fix title screen position
		; https://info.sonicretro.org/SCHG_How-to:Fix_the_Title_Screen_position_in_Sonic_1
		copyTilemap	Unc_Title,vram_fg+$208,34,22
	else
		copyTilemap	Unc_Title,vram_fg+$206,34,22
	endif

		move.w	#0,(v_debuguse).w
		move.w	#0,(f_demo).w
		move.w	#0,(v_zone).w
		bsr.w	LevelSizeLoad
		bsr.w	DeformLayers
		locVRAM ArtTile_Level*tile_size
		lea	(Nem_GHZ_1st).l,a0
		bsr.w	NemDec
		lea	(Blk16_GHZ).l,a0
		lea	(v_16x16).w,a4
		move.w	#(v_16x16_end-v_16x16)/4-1,d0

.loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,.loadblocks
		lea	(Blk256_GHZ).l,a0
		lea	(v_256x256).l,a1
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bgscrposx).w,a3
		lea	(v_lvllayout_bg).w,a4
		move.w	#$4000+vram_bg-vram_fg,d2
		bsr.w	DrawChunks
		moveq	#palid_Title,d0
		bsr.w	PalLoad1
		move.b	#bgm_Title,d0
		bsr.w	QueueSound2
		move.b	#0,(f_debugmode).w
		move.w	#376,(v_generictimer).w			; run title screen for 376 frames
		move.b	#id_TitleSonic,(v_titlesonic).w		; load big sonic object
		move.b	#id_PSBTM,(v_pressstart).w		; load "PRESS START BUTTON" object
		move.b	#id_PSBTM,(v_ttlsonichide).w		; load object which hides sonic
		move.b	#2,(v_ttlsonichide+obFrame).w		; set the object prior to use the correct frame
		moveq	#plcid_Main,d0
		bsr.w	NewPLC
		enable_display
		bsr.w	PaletteFadeIn

Tit_MainLoop:
		move.b	#id_VBlank_04,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	ExecuteObjects
		bsr.w	DeformLayers
		bsr.w	BuildSprites
		bsr.w	PalCycle_Title
		bsr.w	RunPLC
		move.w	(v_player+obX).w,d0
		addq.w	#2,d0
		move.w	d0,(v_player+obX).w			; move Sonic to the right
		cmpi.w	#$1C00,d0				; has Sonic object passed $1C00 on x-axis?
		blo.s	loc_26E4				; if not, branch
		move.b	#id_Sega,(v_gamemode).w			; go to Sega screen
		rts
; ===========================================================================

loc_26E4:
		tst.w	(v_generictimer).w			; has generic timer reached zero?
		beq.w	GotoDemo				; if so, branch
		andi.b	#btnStart,(v_jpadpress1).w		; check if Start is pressed
		beq.w	Tit_MainLoop				; if not, branch
		btst	#bitA,(v_jpadhold1).w			; check if A is held
		beq.w	PlayLevel				; if not, play level

	if FixBugs
		; Fix the level selects graphics bug
		; https://info.sonicretro.org/SCHG_How-to:Fix_the_Level_Select_graphics_bug
		move.b	#id_VBlank_04,(v_vblank_routine).w
		bsr.w	WaitForVBlank
	endif

		moveq	#palid_LevelSel,d0
		bsr.w	PalLoad2				; load level select palette

		clearRAM v_hscrolltablebuffer,v_hscrolltablebuffer_end

		move.l	d0,(v_scrposy_vdp).w
		disable_ints
		lea	(vdp_data_port).l,a6
		locVRAM	vram_bg
		move.w	#(plane_size_64x32)/4-1,d1

Tit_ClrScroll:
		move.l	d0,(a6)
		dbf	d1,Tit_ClrScroll			; clear scroll data (in VRAM)

		bsr.w	LevSelTextLoad

; ---------------------------------------------------------------------------
; Level Select
; ---------------------------------------------------------------------------

LevelSelect:
		move.b	#id_VBlank_04,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	LevSelControls
		bsr.w	RunPLC
		tst.l	(v_plc_buffer).w
		bne.s	LevelSelect
		andi.b	#btnABC+btnStart,(v_jpadpress1).w
		beq.s	LevelSelect
		move.w	(v_levselitem).w,d0
		cmpi.w	#$13,d0					; are we on sound select?
		bne.s	LevSel_Level				; if not, branch
		move.w	(v_levselsound).w,d0
		addi.w	#$80,d0
		; What follows below are workarounds for bugs within the Sound Driver, these can be removed if FixBugs is enabled, but these are kept here for documentation.
	if FixBugs
		cmpi.w	#bgm__Last,d0				; compare the last BGM with the level select sound
		bls.s	.notBGM					; if lower than or same, branch
	else
		; Bug: There's no pointers for BGM ids $92 or $93, so the game crashes when it tries to play them
		cmpi.w	#bgm__Last+2,d0				; compare the last BGM+2 ($93) with the level select sound
		blo.s	.notBGM					; if lower than $93, branch
	endif
		cmpi.w	#sfx__First,d0				; compare the first SFX with the level select sound
		blo.s	LevelSelect				; if lower than SFX, branch

.notBGM:
		bsr.w	QueueSound2
		bra.s	LevelSelect
; ===========================================================================

LevSel_Level:
		add.w	d0,d0
		move.w	LevSelOrder(pc,d0.w),d0
		bmi.s	LevelSelect
		cmpi.w	#id_SS<<8,d0				; are we on the Special Stage?
		bne.s	.notSS					; if not, branch
		move.b	#id_Special,(v_gamemode).w
		rts
; ===========================================================================

.notSS:
		andi.w	#$3FFF,d0
		btst	#bitB,(v_jpadhold1).w			; is B held?
		beq.s	.notB					; if not, ignore below
		move.w	#id_GHZ_act4,d0				; Set the zone and act to Green Hill Act 4

.notB:
		move.w	d0,(v_zone).w

PlayLevel:
		move.b	#id_Level,(v_gamemode).w
		move.b	#3,(v_lives).w
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.l	d0,(v_score).w
		move.b	#bgm_Fade,d0
		bsr.w	QueueSound2
		rts
; ===========================================================================
LevSelOrder:
		dc.w	id_GHZ_act1		; GHZ1
		dc.w	id_GHZ_act2		; GHZ2
		dc.w	id_GHZ_act3		; GHZ3
		dc.w	id_LZ_act1		; LZ1
		dc.w	id_LZ_act2		; LZ2
		dc.w	id_LZ_act3		; LZ3
		dc.w	id_MZ_act1		; MZ1
		dc.w	id_MZ_act2		; MZ2
		dc.w	id_MZ_act3		; MZ3
		dc.w	id_SLZ_act1		; SLZ1
		dc.w	id_SLZ_act2		; SLZ2
		dc.w	id_SLZ_act3		; SLZ3
		dc.w	id_SZ_act1		; SZ1
		dc.w	id_SZ_act2		; SZ2
		dc.w	id_SZ_act3		; SZ3
		dc.w	id_CWZ_act1		; CWZ1
		dc.w	id_CWZ_act2		; CWZ2
		dc.w	id_CWZ_act1+$8000	; CWZ3
		dc.w	id_SS<<8		; SS
		dc.w	id_SS<<8		; SS (Sound Select)
		dc.w	$8000
; ===========================================================================

; ---------------------------------------------------------------------------
; Demo mode
; ---------------------------------------------------------------------------

GotoDemo:
		move.w	#30,(v_generictimer).w

loc_27FE:
		move.b	#id_VBlank_04,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	DeformLayers
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		move.w	(v_player+obX).w,d0
		addq.w	#2,d0
		move.w	d0,(v_player+obX).w
		cmpi.w	#$1C00,d0
		blo.s	loc_282C
		move.b	#id_Sega,(v_gamemode).w
		rts
; ===========================================================================

loc_282C:
		tst.w	(v_generictimer).w
		bne.w	loc_27FE
		move.b	#bgm_Fade,d0
		bsr.w	QueueSound2				; fade out music
		move.w	(v_demonum).w,d0			; load demo number
		andi.w	#7,d0
		add.w	d0,d0
		move.w	Demo_Levels(pc,d0.w),d0			; load level number for demo
		move.w	d0,(v_zone).w
		addq.w	#1,(v_demonum).w			; add 1 to demo number
		cmpi.w	#6,(v_demonum).w			; is demo number less than 6?
		blo.s	loc_2860				; if yes, branch
		move.w	#0,(v_demonum).w			; reset demo number to 0

loc_2860:
		move.w	#1,(f_demo).w				; turn demo mode on
		move.b	#id_Demo,(v_gamemode).w			; set screen mode to 08 (demo)
		cmpi.w	#(id_SS-1)<<8,d0			; is level number 0600 (special stage)?
		bne.s	Demo_Level				; if not, branch
		move.b	#id_Special,(v_gamemode).w		; set screen mode to $10 (Special Stage)

Demo_Level:
		move.b	#3,(v_lives).w				; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.l	d0,(v_score).w				; clear score
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Levels used in demos
; ---------------------------------------------------------------------------
Demo_Levels:
		dc.w	id_GHZ_act1	; 1
		dc.w	(id_SS-1)<<8	; 2
		dc.w	id_MZ_act1	; 3
		dc.w	(id_SS-1)<<8	; 4
		dc.w	id_SZ_act1	; 5
		dc.w	(id_SS-1)<<8	; 6
		; The demo levels below are unused
		dc.w	id_SLZ_act1	; 7
		dc.w	(id_SS-1)<<8	; 8
		dc.w	id_MZ_act1	; 9
		dc.w	(id_SS-1)<<8	; 10
		dc.w	id_SZ_act1	; 11
		dc.w	(id_SS-1)<<8	; 12
		even

; ---------------------------------------------------------------------------
; Subroutine to change what you're selecting in the level select
; ---------------------------------------------------------------------------

LevSelControls:
		move.b	(v_jpadpress1).w,d1
		andi.b	#btnUp+btnDn,d1
		bne.s	LevSel_UpDown
		subq.w	#1,(v_levseldelay).w
		bpl.s	LevSel_SndTest

LevSel_UpDown:
		move.w	#12-1,(v_levseldelay).w
		move.b	(v_jpadhold1).w,d1
		andi.b	#btnUp+btnDn,d1
		beq.s	LevSel_SndTest
		move.w	(v_levselitem).w,d0
		btst	#bitUp,d1
		beq.s	LevSel_Down
		subq.w	#1,d0
		bhs.s	LevSel_Down
		moveq	#$13,d0

LevSel_Down:
		btst	#bitDn,d1
		beq.s	LevSel_Refresh
		addq.w	#1,d0
		cmpi.w	#$14,d0
		blo.s	LevSel_Refresh
		moveq	#0,d0

LevSel_Refresh:
		move.w	d0,(v_levselitem).w
		bsr.w	LevSelTextLoad
		rts
; ===========================================================================

LevSel_SndTest:
		cmpi.w	#$13,(v_levselitem).w
		bne.s	LevSel_NoMove
		move.b	(v_jpadpress1).w,d1
		andi.b	#btnL+btnR,d1
		beq.s	LevSel_NoMove
		move.w	(v_levselsound).w,d0
		btst	#bitL,d1
		beq.s	LevSel_Right
		subq.w	#1,d0
		bhs.s	LevSel_Right
		moveq	#sfx__Last-$80,d0

LevSel_Right:
		btst	#bitR,d1
		beq.s	LevSel_Refresh2
		addq.w	#1,d0
		cmpi.w	#spec__First-$80,d0
		blo.s	LevSel_Refresh2
		moveq	#0,d0

LevSel_Refresh2:
		move.w	d0,(v_levselsound).w
		bsr.w	LevSelTextLoad

LevSel_NoMove:
		rts
; ===========================================================================

LevSelTextLoad:

textpos:	= ($40000000+(($E210&$3FFF)<<16)+(($E210&$C000)>>14))
					; $E210 is a VRAM address

		lea	(LevelSelectText).l,a1
		lea	(vdp_data_port).l,a6
		move.l	#textpos,d4
		move.w	#$E680,d3
		moveq	#(LevelSelectText_End-LevelSelectText)/24-1,d1	; Only load 20 lines.

LevSel_DrawAll:
		move.l	d4,4(a6)
		bsr.w	LevSel_ChgLine
		addi.l	#$800000,d4
		dbf	d1,LevSel_DrawAll

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
		bsr.w	LevSel_ChgLine
		move.w	#$E680,d3
		cmpi.w	#$13,(v_levselitem).w	; are we on Sound Select?
		bne.s	LevSel_DrawSnd	; if not, branch
		move.w	#$C680,d3

LevSel_DrawSnd:
		locVRAM vram_bg+$BB0
		move.w	(v_levselsound).w,d0
		addi.w	#$80,d0
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.w	LevSel_ChgSnd
		move.b	d2,d0
		bsr.w	LevSel_ChgSnd
		rts
; ===========================================================================

LevSel_ChgSnd:
		andi.w	#$F,d0
		cmpi.b	#$A,d0
		blo.s	LevSel_Numb
		addi.b	#7,d0

LevSel_Numb:
		add.w	d3,d0
		move.w	d0,(a6)
		rts
; ===========================================================================

LevSel_ChgLine:
		moveq	#24-1,d2

LevSel_LineLoop:
		moveq	#0,d0
		move.b	(a1)+,d0
		bpl.s	LevSel_CharOk
		move.w	#0,(a6)
		dbf	d2,LevSel_LineLoop

		rts
; ===========================================================================

LevSel_CharOk:
		add.w	d3,d0
		move.w	d0,(a6)
		dbf	d2,LevSel_LineLoop

		rts
; ===========================================================================

LevelSelectText:
		charset ' ', $FF
		charset '0','9',$00
		charset '$', $0A
		charset '-', $0B
		charset '=', $0C
		charset '>', $0D
		;charset '>', $0E ; there are two right arrows in the font for some reason
		charset 'Y','Z',$0F ; Y and Z come before A-X
		charset 'A','X',$11

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

LevelSelectText_End:

; ---------------------------------------------------------------------------
; Music playlist
; ---------------------------------------------------------------------------
MusicList:
		dc.b	bgm_GHZ
		dc.b	bgm_LZ
		dc.b	bgm_MZ
		dc.b	bgm_SLZ
		dc.b	bgm_SZ
		dc.b	bgm_CWZ
		even
; ===========================================================================

; ---------------------------------------------------------------------------
; Level
; ---------------------------------------------------------------------------

GM_Level:
		move.b	#bgm_Fade,d0
		bsr.w	QueueSound2
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
		move.w	#vreg_mode3|%0011,(a6)
		move.w	#vreg_fgvram|(vram_fg>>10),(a6)
		move.w	#vreg_bgvram|(vram_bg>>13),(a6)
		move.w	#vreg_spritevram|(vram_sprites>>9),(a6)
		move.w	#0,(v_unused13).w
		move.w	#vreg_hintrate|175,(v_hblank_hreg).w	; set HBlank counter to scanline 175 (even though horizontal interrupts aren't normally used here...)
		move.w	#vreg_mode1|%0100,(a6)
		move.w	#vreg_bgcolor|%00100000,(a6)

		clearRAM v_objspace,v_objspace_end
		clearRAM v_misc_variables,v_misc_variables_end
		clearRAM v_timingandscreenvariables,v_timingandscreenvariables_end

		moveq	#palid_Sonic,d0
		bsr.w	PalLoad2
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lea	(MusicList).l,a1
		move.b	(a1,d0.w),d0
		bsr.w	QueueSound1
		move.b	#id_TitleCard,(v_titlecard).w		; load title card object

Level_TtlCardLoop:
		move.b	#id_VBlank_0C,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	ExecuteObjects
		bsr.w	BuildSprites
		bsr.w	RunPLC
		move.w	(v_ttlcardact+obX).w,d0
		cmp.w	(v_ttlcardact+card_mainX).w,d0
		bne.s	Level_TtlCardLoop
		tst.l	(v_plc_buffer).w
		bne.s	Level_TtlCardLoop
		bsr.w	DebugPosLoadArt
		jsr	(Hud_Base).l
		moveq	#palid_Sonic,d0
		bsr.w	PalLoad1
		bsr.w	LevelSizeLoad
		bsr.w	DeformLayers
		bsr.w	LevelDataLoad
		bsr.w	LoadAnimatedBlocks
		bsr.w	LoadTilesFromStart
		jsr	(ConvertCollisionArray).l
		move.l	#Col_GHZ,(v_collindex).w		; load Green Hill's collision
		cmpi.b	#id_LZ,(v_zone).w			; is the current zone Labyrinth?
		bne.s	.notLZ					; if not, go to the next condition
		move.l	#Col_LZ,(v_collindex).w			; load Labyrinth's collision

.notLZ:
		cmpi.b	#id_MZ,(v_zone).w			; is the current zone Marble?
		bne.s	.notMZ					; if not, go to the next condition
		move.l	#Col_MZ,(v_collindex).w			; load Marble's collision

.notMZ:
		cmpi.b	#id_SLZ,(v_zone).w			; is the current zone Star Light?
		bne.s	.notSLZ					; if not, go to the next condition
		move.l	#Col_SLZ,(v_collindex).w		; load Star Light's collision

.notSLZ:
		cmpi.b	#id_SZ,(v_zone).w			; is the current zone Sparkling?
		bne.s	.notSZ					; if not, go to the last condition
		move.l	#Col_SZ,(v_collindex).w			; load Sparkling's collision

.notSZ:
		cmpi.b	#id_CWZ,(v_zone).w			; is the current zone Clock Work?
		bne.s	.notCWZ					; if not, then just skip loading collision
		move.l	#Col_CWZ,(v_collindex).w		; load Clock Work's collision

.notCWZ:
		move.b	#id_SonicPlayer,(v_player).w
		move.b	#id_HUD,(v_hud).w
		btst	#bitA,(v_jpadhold1).w			; is button A held?
		beq.s	loc_2D54				; if not, branch
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
		move.b	d0,(v_unused1).w
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
		move.b	#id_VBlank_08,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		move.w	#$202F,(v_pfade_start).w
		bsr.w	PalFadeIn_Alt
		addq.b	#2,(v_ttlcardname+obRoutine).w
		addq.b	#4,(v_ttlcardzone+obRoutine).w
		addq.b	#4,(v_ttlcardact+obRoutine).w
		addq.b	#4,(v_ttlcardoval+obRoutine).w

GM_LevelLoop:
		bsr.w	PauseGame
		move.b	#id_VBlank_08,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		addq.w	#1,(v_framecount).w
		bsr.w	WaterFeatures
		bsr.w	MoveSonicInDemo
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
		bsr.w	SynchroAnimate
		bsr.w	SignpostArtLoad
		cmpi.b	#id_Demo,(v_gamemode).w
		beq.s	loc_2E66
		tst.w	(f_restart).w
		bne.w	GM_Level
		cmpi.b	#id_Level,(v_gamemode).w
		beq.w	GM_LevelLoop
		rts
; ===========================================================================

loc_2E66:
		tst.w	(f_restart).w
		bne.s	loc_2E84
		tst.w	(v_generictimer).w
		beq.s	loc_2E84
		cmpi.b	#id_Demo,(v_gamemode).w
		beq.w	GM_LevelLoop
		move.b	#id_Sega,(v_gamemode).w
		rts
; ===========================================================================

loc_2E84:
		cmpi.b	#id_Demo,(v_gamemode).w
		bne.s	loc_2E92
		move.b	#id_Sega,(v_gamemode).w

loc_2E92:
		move.w	#60,(v_generictimer).w
		move.w	#$3F,(v_pfade_start).w

loc_2E9E:
		move.b	#id_VBlank_08,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	MoveSonicInDemo
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
; ===========================================================================

		include "leftovers/routines/Debug Coordinate Sprites.asm"
		include	"leftovers/routines/Window Plane Mask.asm"

		include "_include/WaterFeatures.asm"
		include	"_include/MoveSonicInDemo.asm"

; ===========================================================================

;sub_314C:
		cmpi.b	#id_06,(v_zone).w			; is this Zone 6?
		bne.s	locret_3176				; if not, branch
		bsr.w	sub_3178
		lea	(v_256x256+$900).l,a1
		bsr.s	sub_3166
		lea	(v_256x256+$3380).l,a1

sub_3166:
		lea	(Anim256Unk1).l,a0
		move.w	#(Anim256Unk1_End-Anim256Unk1)/2-1,d1

.loadchunks:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadchunks

locret_3176:
		rts
; ===========================================================================

sub_3178:
		lea	(v_256x256).l,a1
		lea	(Anim256Unk2).l,a0
		move.w	#(Anim256Unk2_End-Anim256Unk2)/2-1,d1

.loadchunks2:
		move.w	(a0)+,d0
		ori.w	#$2000,(a1,d0.w)
		dbf	d1,.loadchunks2
		rts
; ===========================================================================
Anim256Unk1:
		binclude	"level/map256/Anim Unknown 1.bin"
Anim256Unk1_End:
		even

Anim256Unk2:
		binclude	"level/map256/Anim Unknown 2.bin"
Anim256Unk2_End:
		even
; ===========================================================================

LoadAnimatedBlocks:
		cmpi.b	#id_MZ,(v_zone).w			; is this Marble Zone?
		beq.s	.MZ					; if yes, branch
		cmpi.b	#id_SLZ,(v_zone).w			; is this Star Light Zone?
		beq.s	.SLZ					; if yes, branch
		tst.b	(v_zone).w				; is this Green Hill Zone?
		bne.s	.notGHZ					; if not, branch

.SLZ:
		lea	(v_16x16+$1790).w,a1			; load ROM address for animated blocks to load in the main block RAM into a1
		lea	(Anim16GHZ).l,a0			; load animated GHZ blocks into a0
		move.w	#(Anim16GHZ_End-Anim16GHZ)/2-1,d1	; load approx. size of the blocks into d1

	.loadGHZ:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadGHZ

.notGHZ:
		rts
; ===========================================================================

.MZ:
		lea	(v_16x16+$17A0).w,a1			; load ROM address for animated blocks to load in the main block RAM into a1
		lea	(Anim16MZ).l,a0				; load animated MZ blocks into a0
		move.w	#(Anim16MZ_End-Anim16MZ)/2-1,d1		; load approx. size of the blocks into d1

	.loadMZ:
		move.w	(a0)+,(a1)+
		dbf	d1,.loadMZ
		rts
; ===========================================================================
Anim16GHZ:
		binclude	"level/map16/Anim GHZ.bin"
Anim16GHZ_End:
		even

Anim16MZ:
		binclude	"level/map16/Anim MZ.bin"
Anim16MZ_End:
		even
; ===========================================================================

DebugPosLoadArt:
		rts

		locVRAM ArtTile_Debug_Numbers*tile_size
		lea	(Art_Text).l,a0
		move.w	#(Art_Text_end-Art_Text-tile_size*31)/2-1,d1
		bsr.s	.loadText
		lea	(Art_Text).l,a0
		adda.w	#tile_size*17,a0
		move.w	#(Art_Text_end-Art_Text-tile_size*35)/2-1,d1

	.loadText:
		move.w	(a0)+,(vdp_data_port).l
		dbf	d1,.loadText
		rts
; ===========================================================================

;1bppConvert:
		moveq	#0,d0
		move.b	(a0)+,d0
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
		dbf	d1,.loadText
		rts
; ===========================================================================

.1bpp:
		dc.b	0, 6, $60, $66
		even

		include "_include/Oscillatory Routines.asm"

; ---------------------------------------------------------------------------
; Subroutine to change synchronised animation variables (rings)
; ---------------------------------------------------------------------------

SynchroAnimate:

; Used for GHZ spiked log
Sync1:
		subq.b	#1,(v_ani0_time).w ; has timer reached 0?
		bpl.s	Sync2		; if not, branch
		move.b	#12-1,(v_ani0_time).w ; reset timer
		subq.b	#1,(v_ani0_frame).w ; next frame
		andi.b	#8-1,(v_ani0_frame).w ; max frame is 7

; Used for rings
Sync2:
		subq.b	#1,(v_ani1_time).w
		bpl.s	Sync3
		move.b	#8-1,(v_ani1_time).w
		addq.b	#1,(v_ani1_frame).w
		andi.b	#4-1,(v_ani1_frame).w

; Used for nothing
Sync3:
		subq.b	#1,(v_ani2_time).w
		bpl.s	Sync4
		move.b	#8-1,(v_ani2_time).w
		addq.b	#1,(v_ani2_frame).w
		cmpi.b	#6,(v_ani2_frame).w
		blo.s	Sync4
		move.b	#0,(v_ani2_frame).w

; Used for bouncing rings
Sync4:
		tst.b	(v_ani3_time).w
		beq.s	SyncEnd
		moveq	#0,d0
		move.b	(v_ani3_time).w,d0
		add.w	(v_ani3_buf).w,d0
		move.w	d0,(v_ani3_buf).w
		rol.w	#7,d0
		andi.w	#3,d0
		move.b	d0,(v_ani3_frame).w
		subq.b	#1,(v_ani3_time).w

SyncEnd:
		rts
; End of function SynchroAnimate

; ---------------------------------------------------------------------------
; End-of-act signpost pattern loading subroutine
; ---------------------------------------------------------------------------

SignpostArtLoad:
		tst.w	(v_debuguse).w
		bne.w	.exit
		cmpi.w	#id_MZ_act3,(v_zone).w			; is this MZ3?
		beq.s	.isMZ3					; if so, load the signpost
		cmpi.b	#act3,(v_act).w
		beq.s	.exit

	.isMZ3:
		move.w	(v_scrposx).w,d0
		move.w	(v_limitright2).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0
		blt.s	.exit
		tst.b	(f_timecount).w
		beq.s	.exit
		cmp.w	(v_limitleft2).w,d1
		beq.s	.exit
		move.w	d1,(v_limitleft2).w
		moveq	#plcid_Signpost,d0
		bra.w	NewPLC

	.exit:
		rts
; End of function SignpostArtLoad

; ===========================================================================

GM_Special:
		bsr.w	PaletteFadeOut
		disable_display					; disable screen output
		bsr.w	ClearScreen				; wipe screen

		fillVRAM 0, ArtTile_SS_Plane_1*tile_size+plane_size_64x32, ArtTile_SS_Plane_5*tile_size ; clear nametables
		moveq	#plcid_SpecialStage,d0			; load special stage patterns
		bsr.w	QuickPLC				; execute PLCs immediately (no queue)
		bsr.w	SS_BGLoad				; load background clouds/bubbles/birds/fish mappings

		clearRAM v_objspace,v_objspace_end
		clearRAM v_misc_variables,v_misc_variables_end
		clearRAM v_timingandscreenvariables,v_timingandscreenvariables_end
		clearRAM v_ngfx_buffer,v_ngfx_buffer_end

		moveq	#palid_Special,d0			; load special stage palette...
		bsr.w	PalLoad1				; ...into the palette fade-in buffer
		jsr	(SS_Load).l				; load SS layout data

		move.l	#0,(v_scrposx).w			; reset X-camera position
		move.l	#0,(v_scrposy).w			; reset Y-camera position
		move.b	#id_SonicSpecial,(v_player).w		; load special stage Sonic object
		move.w	#$458,(v_player+obX).w
		move.w	#$4A0,(v_player+obY).w

		lea	(vdp_control_port).l,a6			; load VDP control port
		move.w	#vreg_mode3|%0011,(a6)			; line scroll mode (per-row horizontally, full-screen vertically)
		move.w	#vreg_mode1|%000100,(a6)		; use 8-colour mode
		move.w	#vreg_hintrate|175,(v_hblank_hreg).w	; set HBlank counter to scanline 175 (even though horizontal interrupts aren't used here...)
		move.w	#$9011,(a6)				; 128-cell hscroll size
		bsr.w	PalCycle_SS				; initialize palette cycle and background for fade-in
		clr.w	(v_ssangle).w				; set stage angle to "upright"
		move.w	#$40,(v_ssrotate).w			; set initial stage rotation speed ($40, see object 09)
		move.w	#bgm_SS,d0				; play special stage BG music
		bsr.w	QueueSound2				; play it

		move.w	#0,(v_btnpushtime1).w			; clear button push counters for demos
		lea	(DemoDataPtr).l,a1			; load demo data
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0					; multiply by 4 for longword-based indexing
		movea.l	(a1,d0.w),a1				; get demo pointer for current level
		move.b	1(a1),(v_btnpushtime2).w		; load initial demo key press duration
		subq.b	#1,(v_btnpushtime2).w			; subtract 1 from demo key pressduration
		move.w	#1800,(v_generictimer).w		; run regular demos for 30 seconds
		enable_display					; enable screen out-put
		bsr.w	PaletteFadeIn

; ---------------------------------------------------------------------------
; Special Stage main loop
; ---------------------------------------------------------------------------

SS_MainLoop:
		bsr.w	PauseGame				; handle pausing the game when pressing start
		move.b	#id_VBlank_0A,(v_vblank_routine).w
		bsr.w	WaitForVBlank				; wait until VBlank has finished
		bsr.w	MoveSonicInDemo				; simulate controls in demos (immediately returns outside demos)
		move.w	(v_jpadhold1).w,(v_jpadhold2).w		; copy controller 1 inputs to Sonic player object inputs

		bsr.w	ExecuteObjects				; execute Special Stage object
		bsr.w	BuildSprites				; build sprites
		jsr	(SS_ShowLayout).l			; render Special Stage layout
		bsr.w	SS_BGAnimate				; animate Special Stage background

		tst.w	(f_demo).w				; is demo mode on?
		beq.s	SS_ChkEnd				; if not, branch
		tst.w	(v_generictimer).w			; is there time left on the demo?
		beq.s	SS_ToSegaScreen				; if not, return to Sega screen

SS_ChkEnd:
		cmpi.b	#id_Special,(v_gamemode).w		; is game mode still the Special Stage?
		beq.w	SS_MainLoop				; if yes, loop game mode
		rts
; ===========================================================================

SS_ToSegaScreen:
		move.b	#id_Sega,(v_gamemode).w			; set game mode to Sega screen
		rts
; ===========================================================================

; >>> Special Stage background drawing and palette cycle logic
	include	"_include/Special Stage Background & Palette Cycle.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; >> END OF MAIN GAME LOGIC - Everything below this point is file includes <<
; ---------------------------------------------------------------------------
; ===========================================================================
; >>> Level rendering, loading, and updating
		include "_include/LevelSizeLoad & BgScrollSpeed.asm"
		include "_include/DeformLayers.asm"
		include	"_include/Level Drawing.asm"
		include	"_include/LevelLayoutLoad.asm"

		include "_include/DynamicLevelEvents.asm"


; ===========================================================================
; >>> Various level objects
		include "obj/02, 03, 04.asm"
		include "obj/05, 06, 07 Debug Numbers.asm"
		include "obj/11 Bridge.asm"
		include "obj/15 Swinging Platforms.asm"
		include "obj/17 GHZ Spiked Pole Helix.asm"
		include "obj/18 Platforms.asm"
		include "obj/19 GHZ Ball.asm"
		include "obj/1A, 53 Collapsing Ledge and Floors.asm"
		include "obj/1B.asm"
		include "obj/1C GHZ Scenery.asm"
		include "obj/1D Unused - Switch.asm"
		include "obj/2A GHZ Edge Door.asm"


; ===========================================================================
; >>> Title screen objects (includes AnimateSprite)
		include "obj/0E, 0F Title Screen - Sonic, Press Start.asm"


; ===========================================================================
; >>> Badniks, explosions, and Badnik-related objects
		include "obj/1E, 20 Badnik - Ball Hog and Cannonball.asm"
		include "obj/24 Unused - Small Explosion.asm"
		include "obj/27, 3F Explosions.asm"
		include "_anim/Ball Hog.asm"
Map_Hog:	include "_maps/Ball Hog.asm"
Map_Cannonball:	include "_maps/Cannonball.asm"
Map_UnkExplode:	include "_maps/Missile Dissolve.asm"
		include "_maps/Explosions.asm"
		include "obj/28, 29 Animals and Points.asm"
		include "obj/1F Badnik - Crabmeat.asm"
		include "obj/22, 23 Badnik - Buzz Bomber and Missile.asm"


; ===========================================================================
; >>> Rings
		include "obj/25, 37 Rings.asm"
		include "obj/4B Giant Ring.asm"
		include "_anim/Rings.asm"
Map_Ring:	include "_maps/Rings.asm"
Map_GRing:	include "_maps/Giant Ring.asm"


; ===========================================================================
; >>> Monitors
		include "obj/26, 2E Monitors and Power-Ups.asm"


; ===========================================================================
; Subroutines to run, render, and update objects
		include	"_include/ExecuteObjects.asm"
		include "_include/Object Pointers.asm" ; includes Obj_Index
		include "obj/sub ObjectFall & SpeedToPos.asm"
		include "obj/sub DisplaySprite.asm"
		include "obj/sub DeleteObject.asm"
		include	"_include/BuildSprites.asm"
		include	"obj/sub ChkObjectVisible.asm"
		include	"_include/ObjPosLoad.asm"
		include	"obj/sub FindFreeObj.asm"


; ===========================================================================
; >>> More level objects
		include "obj/2B Badnik - Chopper.asm"
		include "obj/2C Badnik - Jaws.asm"
		include "obj/2D Badnik - Burrobot.asm"
		include "obj/2F, 35 MZ Large Grassy Platforms and Burning Grass.asm"
Map_Fire:	include "_maps/Fireballs.asm"
		include "obj/30 MZ Large Green Glass Blocks.asm"
		include "obj/31 MZ Chained Stompers.asm"
		include "obj/45 MZ Sideways Stomper.asm"
Map_CStom:	include "_maps/Chained Stompers.asm"
Map_SStom:	include "_maps/Sideways Stomper.asm"
		include "obj/32 Button.asm"
		include "obj/33 MZ Pushable Blocks.asm"
		include "obj/sub SolidObject.asm"


; ===========================================================================
; >>> Title card objects
		include "obj/34 Title Cards.asm"
		include "obj/39 Game Over.asm"
		include "obj/3A Got Through Act.asm"
		include	"_maps/Title Cards.asm" ; includes "Map_Card", "Map_Over", and "Map_Got"


; ===========================================================================
; >>> More level objects
		include "obj/36 Spikes.asm"
		include "obj/3B Purple Rock.asm"
		include "obj/49 GHZ Waterfall Sound.asm"
Map_PRock:	include "_maps/Purple Rock.asm"
		include "obj/3C GHZ, SLZ Smashable Wall.asm" ; includes SmashObject


; ===========================================================================
; >>> Bosses and related objects
		include "obj/3D, 48 Boss - GHZ Main and Wrecking Ball.asm"
		include "_anim/Eggman.asm"
Map_Eggman:	include "_maps/Eggman.asm"
Map_BossItems:	include "_maps/Boss Items.asm"
		include "obj/3E Prison Capsule.asm"


; ===========================================================================
; >>> More level objects
		include "obj/40 Badnik - Motobug.asm" ; includes "obj/sub RememberState.asm" subroutine
		include "obj/41 Springs.asm"
		include "obj/42 Badnik - Newtron.asm"
		include "obj/43 Badnik - Roller.asm"
		include "obj/44 GHZ Edge Walls.asm"
		include "obj/13, 14 MZ Fire Balls and Maker.asm"
		include "obj/46 MZ Bricks.asm"
		include "obj/12 SZ Search Light.asm"
		include "obj/47 SZ Bumper.asm"
		include "obj/0D Signpost.asm" ; includes "GotThroughAct" subroutine
		include "obj/4C, 4D MZ Lava Geyser and Maker.asm"
		include "obj/4E MZ Wall of Lava.asm"
		include "obj/54 MZ Invisible Lava Tag.asm"
		include "_anim/Lava Geyser.asm"
		include "_anim/Wall of Lava.asm"
Map_Geyser:	include "_maps/Lava Geyser.asm"
Map_LWall:	include "_maps/Wall of Lava.asm"
		include "obj/4F, 50 Badnik - Splats and Yadrin.asm"
		include "obj/51 MZ Smashable Green Block.asm"
		include "obj/52 Moving Blocks.asm"
		include "obj/55 Badnik - Basaran.asm"
		include "obj/56 Floating Blocks and Doors.asm"
		include "obj/57 SZ Spiked Ball and Chain.asm"
		include "obj/58 SZ Big Spiked Ball.asm"
		include "obj/59 SLZ Elevators.asm"
		include "obj/5A SLZ Circling Platform.asm"
		include "obj/5B SLZ Staircase.asm"
		include "obj/5C SLZ Foreground Pylon.asm"
		include "obj/5D SLZ Fan.asm"
		include "obj/5E SLZ Seesaw.asm"


; ===========================================================================
; >>> Main Sonic player object
		include	"obj/01 Sonic.asm"


; ===========================================================================
; >>> Various unique objects
		include "obj/38 Shield and Invincibility.asm"
		include "obj/4A Special Stage Entry (Unused).asm"
		include "_anim/Shield and Invincibility.asm"
Map_Shield:	include "_maps/Shield and Invincibility.asm"
		include "_anim/Special Stage Entry (Unused).asm"
Map_Vanish:	include "_maps/Special Stage Entry (Unused).asm"


; ===========================================================================
; >>> Object-to-object touch response handler for Sonic
		include "obj/Sonic ReactToItem.asm"


; ===========================================================================
; >>> Collision subroutines for Sonic and other objects
		include "obj/Sonic AnglePos.asm"
		include "obj/sub FindNearestTile.asm"
		include "obj/sub FindFloor.asm"
		include "obj/sub FindWall.asm"
		include	"_include/ConvertCollisionArray (Unused).asm"
		include	"obj/Sonic Collision.asm"


; ===========================================================================
; >>> Special Stage rendering and objects
		; The following includes "SS_ShowLayout", "SS_AniWallsRings",
		; "SS_FindFreeAnimationSlot", "SS_AniItems", and "SS_Load"
		include	"_include/Special Stage Loading & Drawing.asm"

		include "_include/Special Stage Mappings & VRAM Pointers.asm"
Map_SS_Up:
Map_SS_Goal:	include	"_maps/SS UP Block.asm"

Map_SS_Down:
Map_SS_Goal_R:	include	"_maps/SS DOWN Block.asm"
		include	"leftovers/routines/Special Stage Layout Load.asm"
		include "obj/09 Sonic in Special Stage.asm"


; ===========================================================================
; >>> Sonic animation test object that is randomly mixed in here
		include "obj/10 Sonic Animation Test.asm"


; ===========================================================================
; >>> Subroutine for in-place level animations in VRAM
		include "_include/AnimateLevelGfx.asm"


; ===========================================================================
; >>> HUD objects
		include "obj/21 HUD.asm"
		include	"obj/sub AddPoints.asm"
		include	"_include/HUD Update.asm"

Art_Hud:	binclude	"artunc/HUD Numbers.bin" ; 8x16 pixel numbers on HUD
		even
Art_LivesNums:	binclude	"artunc/Lives Counter Numbers.bin" ; 8x8 pixel numbers on lives counter
		even


; ===========================================================================
; >>> Debug Mode
		include "obj/DebugMode.asm"


; ===========================================================================
; >>> Level definitions
		include "_include/LevelHeaders.asm"
		include "_include/Pattern Load Cues.asm"


; ===========================================================================

; ---------------------------------------------------------------------------
; >> END OF PRIMARY INCLUDES - Everything below this point is art includes <<
; ---------------------------------------------------------------------------

		; Unused ASCII art starts at $30000 in this prototype, which amounts
		; to $5A90 bytes of padding.
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		align	$8000
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Compressed graphics - Unused 8x8 ASCII Art
; ---------------------------------------------------------------------------
byte_18000:	binclude	"leftovers/artnem/8x8 ASCII.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics and mappings - Sega screen
; ---------------------------------------------------------------------------
Nem_SegaLogo:	binclude	"artnem/Sega Logo.nem"
		even
Eni_SegaLogo:	binclude	"tilemaps/Sega Logo.eni"
		even

; ---------------------------------------------------------------------------
; Compressed graphics and uncompressed mappings - Title screen
; ---------------------------------------------------------------------------
Unc_Title:	binclude	"tilemaps/Title Screen.bin" ; title screen foreground (mappings)
		even
Nem_TitleFg:	binclude	"artnem/Title Screen Foreground.nem"
		even
Nem_TitleSonic:	binclude	"artnem/Title Screen Sonic.nem"
		even

; ---------------------------------------------------------------------------
; Uncompressed graphics - Sonic
; ---------------------------------------------------------------------------

		; Sonic's data starts at $1C000 in this prototype, which amounts
		; to $5EC bytes of padding.
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		align	$4000
	endif

Map_Sonic:	include	"_maps/Sonic.asm"

SonicDynPLC:	include	"_maps/Sonic - Dynamic Gfx Script.asm"

Art_Sonic:	binclude	"artunc/Sonic.bin"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_Smoke:	binclude	"artnem/Unused - Smoke.nem"
		even
Nem_Splash:	binclude	"artnem/Unused - Water Splashes.nem"
		even
Nem_SzSparkle:	binclude	"artnem/Unused - SZ Sparkles.nem"
		even
Nem_Shield:	binclude	"artnem/Shield.nem"
		even
Nem_Stars:	binclude	"artnem/Invincibility Stars.nem"
		even
Nem_LzSonic:	binclude	"artnem/Unused - LZ Sonic.nem" ; Sonic holding his breath
		even
Nem_UnkFire:	binclude	"artnem/Unused - Fireball.nem" ; unused fireball
		even
Nem_Warp:	binclude	"artnem/Unused - SStage Flash.nem"
		even
Nem_Goggle:	binclude	"artnem/Unused - Goggles.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - GHZ stuff
; ---------------------------------------------------------------------------

		; GHZ compressed graphics start at $27400 in this prototype, which amounts
		; to $3EA bytes of padding.
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		align	$400
	endif

Nem_Stalk:	binclude	"artnem/GHZ Flower Stalk.nem"
		even
Nem_Swing:	binclude	"artnem/GHZ Swinging Platform.nem"
		even
Nem_Bridge:	binclude	"artnem/GHZ Bridge.nem"
		even
Nem_GhzMovingBlock:	binclude	"artnem/Unused - GHZ Block.nem"
		even
Nem_Ball:	binclude	"artnem/GHZ Giant Ball.nem"
		even
Nem_Spikes:	binclude	"artnem/Spikes.nem"
		even
Nem_GhzLog:	binclude	"artnem/Unused - GHZ Log.nem"
		even
Nem_SpikePole:	binclude	"artnem/GHZ Spiked Log.nem"
		even
Nem_PplRock:	binclude	"artnem/GHZ Purple Rock.nem"
		even
Nem_GhzWall1:	binclude	"artnem/GHZ Breakable Wall.nem"
		even
Nem_GhzWall2:	binclude	"artnem/GHZ Edge Wall.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - MZ stuff
; ---------------------------------------------------------------------------
Nem_MzMetal:	binclude	"artnem/MZ Metal Blocks.nem"
		even
Nem_MzSwitch:	binclude	"artnem/MZ Switch.nem"
		even
Nem_MzGlass:	binclude	"artnem/MZ Green Glass Block.nem"
		even
Nem_UnkGrass:	binclude	"artnem/Unused - Grass.nem"
		even
Nem_MzFire:	binclude	"artnem/Fireballs.nem"
		even
Nem_Lava:	binclude	"artnem/MZ Lava.nem"
		even
Nem_MzBlock:	binclude	"artnem/MZ Green Pushable Block.nem"
		even
Nem_MzUnkBlock:	binclude	"artnem/Unused - MZ Background.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - SLZ stuff
; ---------------------------------------------------------------------------
Nem_Seesaw:	binclude	"artnem/SLZ Seesaw.nem"
		even
Nem_Fan:	binclude	"artnem/SLZ Fan.nem"
		even
Nem_SlzWall:	binclude	"artnem/SLZ Breakable Wall.nem"
		even
Nem_Pylon:	binclude	"artnem/SLZ Pylon.nem"
		even
Nem_SlzSwing:	binclude	"artnem/SLZ Swinging Platform.nem"
		even
Nem_SlzPlatfm:	binclude	"artnem/SLZ Platforms.nem"
		even
Nem_SlzBlock:	binclude	"artnem/SLZ 32x32 Block.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - SZ stuff
; ---------------------------------------------------------------------------
Nem_Bumper:	binclude	"artnem/SZ Bumper.nem"
		even
Nem_SyzSpike2:	binclude	"artnem/SZ Small Spikeball.nem"
		even
Nem_Switch:	binclude	"artnem/Switch.nem"
		even
Nem_SyzSpike1:	binclude	"artnem/SZ Large Spikeball.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - enemies
; ---------------------------------------------------------------------------
Nem_BallHog:	binclude	"artnem/Unused - Enemy Ball Hog.nem"
		even
Nem_Crabmeat:	binclude	"artnem/Enemy Crabmeat.nem"
		even
Nem_Buzz:	binclude	"artnem/Enemy Buzz Bomber.nem"
		even
Nem_Ball_Explosion:	binclude	"artnem/Unused - Ball Hog's Ball Explosion.nem"
		even
Nem_Burrobot:	binclude	"artnem/Enemy Burrobot.nem"
		even
Nem_Chopper:	binclude	"artnem/Enemy Chopper.nem"
		even
Nem_Jaws:	binclude	"artnem/Enemy Jaws.nem"
		even
Nem_BallHog_Ball:	binclude	"artnem/Unused - Ball Hog's Ball.nem"
		even
Nem_Roller:	binclude	"artnem/Enemy Roller.nem"
		even
Nem_Motobug:	binclude	"artnem/Enemy Motobug.nem"
		even
Nem_Newtron:	binclude	"artnem/Enemy Newtron.nem"
		even
Nem_Yadrin:	binclude	"artnem/Enemy Yadrin.nem"
		even
Nem_Basaran:	binclude	"artnem/Enemy Basaran.nem"
		even
Nem_Splats:	binclude	"artnem/Enemy Splats.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_TitleCard:	binclude	"artnem/Title Cards.nem"
		even
Nem_HUD:	binclude	"artnem/HUD.nem"
		even
Nem_Lives:	binclude	"artnem/HUD - Life Counter Icon.nem"
		even
Nem_Ring:	binclude	"artnem/Rings.nem"
		even
Nem_Monitors:	binclude	"artnem/Monitors.nem"
		even
Nem_Explode:	binclude	"artnem/Explosion.nem"
		even
Nem_Points:	binclude	"artnem/Points.nem"
		even
Nem_GameOver:	binclude	"artnem/Game Over.nem"
		even
Nem_HSpring:	binclude	"artnem/Spring Horizontal.nem"
		even
Nem_VSpring:	binclude	"artnem/Spring Vertical.nem"
		even
Nem_SignPost:	binclude	"artnem/Signpost.nem"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - animals
; ---------------------------------------------------------------------------
Nem_Rabbit:	binclude	"artnem/Animal Rabbit.nem"
		even
Nem_Chicken:	binclude	"artnem/Animal Chicken.nem"
		even
Nem_Penguin:	binclude	"artnem/Animal Blackbird.nem"
		even
Nem_Seal:	binclude	"artnem/Animal Seal.nem"
		even
Nem_Pig:	binclude	"artnem/Animal Pig.nem"
		even
Nem_Flicky:	binclude	"artnem/Animal Flicky.nem"
		even
Nem_Squirrel:	binclude	"artnem/Animal Squirrel.nem"
		even

; ---------------------------------------------------------------------------
; Level data
; ---------------------------------------------------------------------------

		; Level data starts at $30000 in this prototype, which amounts
		; to $3B2 bytes of padding.
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		align	$1000
	endif

Blk16_GHZ:	binclude	"level/map16/GHZ.bin"
		even
Nem_GHZ_1st:	binclude	"artnem/8x8 - GHZ1.nem"
		even
Nem_GHZ_2nd:	binclude	"artnem/8x8 - GHZ2.nem"
		even
Blk256_GHZ:	binclude	"level/map256/GHZ.kos"
		even

Blk16_LZ:	binclude	"level/map16/LZ.bin"
		even
Nem_LZ:		binclude	"artnem/8x8 - LZ.nem"
		even
Blk256_LZ:	binclude	"level/map256/LZ.kos"
		even

Blk16_MZ:	binclude	"level/map16/MZ.bin"
		even
Nem_MZ:		binclude	"artnem/8x8 - MZ.nem"
		even
Blk256_MZ:	binclude	"level/map256/MZ.kos"
		even

;0x3DA48
; Duplicate cut-off chunk data from MZ.
		dc.w $F0, 0, 0, 0, 0, 0, 0, 0

;0x3DA58
; Cut-off chunk data.
		binclude	"leftovers/level/map256/Chunk Data.kos"
		even

;0x3DB78
		binclude	"unknown/3DB78.dat"
		even

Blk16_SLZ:	binclude	"level/map16/SLZ.bin"
		even
Nem_SLZ:	binclude	"artnem/8x8 - SLZ.nem"
		even
Blk256_SLZ:	binclude	"level/map256/SLZ.kos"
		even

Blk16_SZ:	binclude	"level/map16/SZ.bin"
		even
Nem_SZ:		binclude	"artnem/8x8 - SZ.nem"
		even
Blk256_SZ:	binclude	"level/map256/SZ.kos"
		even

Blk16_CWZ:	binclude	"level/map16/CWZ.bin"
		even
Nem_CWZ:	binclude	"artnem/8x8 - CWZ.nem"
		even
Blk256_CWZ:	binclude	"level/map256/CWZ.kos"
		even

;0x570DC
; Duplicate cut-off chunk data from CWZ.
		dc.w $FFF8, $FCAA, $AAFF, $F8FC, $FFF8, $FCFF, $F8FC, $FFF8
		dc.w $FC00, $F001, $FFF8, $FCFF, $F8FC, $FFF8, $FC02, $FF
		dc.w $F89F, $F0, 0, 0, 0, 0, 0, 0
; And another duplicate of cut-off chunk data from CWZ.
		dc.w $F89F, $F0, 0, 0, 0, 0, 0, 0

;0x5711C
		binclude	"unknown/5711C.dat"
		even

; ---------------------------------------------------------------------------
; Compressed graphics - bosses
; ---------------------------------------------------------------------------
Nem_Eggman:	binclude	"artnem/Boss - Main.nem"
		even
Nem_Weapons:	binclude	"artnem/Boss - Weapons.nem"
		even
Nem_Prison:	binclude	"artnem/Prison Capsule.nem"
		even

; ---------------------------------------------------------------------------
; Demos
; ---------------------------------------------------------------------------
Demo_GHZ:	include "demodata/Intro - GHZ.asm"	; Green Hill's demo (act 2?)
Demo_MZ:	include "demodata/Intro - MZ.asm"	; Marble's demo
Demo_SZ:	include "demodata/Intro - SZ.asm"	; Sparkling's demo (?)
Demo_SS:	include "demodata/Intro - Special Stage.asm" ; Special stage demo

; ---------------------------------------------------------------------------
; Compressed graphics - special stage
; ---------------------------------------------------------------------------

		; Special stage data starts at $63000 in this prototype, which amounts
		; to $1972 bytes of padding.
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		align	$3000
	endif

Map_SSWalls:	include "_maps/SS Walls.asm"

Nem_SSWalls:	binclude	"artnem/Special Walls.nem"
		even
Eni_SSBg1:	binclude	"tilemaps/SS Background 1.eni"
		even
Nem_SSBgFish:	binclude	"artnem/Special Birds & Fish.nem"
		even
Eni_SSBg2:	binclude	"tilemaps/SS Background 2.eni"
		even
Nem_SSBgCloud:	binclude	"artnem/Special Clouds.nem"
		even
Nem_SSGOAL:	binclude	"artnem/Special GOAL.nem"
		even
Nem_SSRBlock:	binclude	"artnem/Special R.nem"
		even
Nem_SSSkull:	binclude	"artnem/Special Skull.nem"
		even
Nem_SSUBlock:	binclude	"artnem/Special U.nem"
		even
Nem_SS1UpBlock:	binclude	"artnem/Special 1UP.nem"
		even
Nem_SSEmStars:	binclude	"artnem/Special Emerald Twinkle.nem"
		even
Nem_SSRedWhite:	binclude	"artnem/Special Red-White.nem"
		even
Nem_SSZone1:	binclude	"artnem/Special ZONE1.nem"
		even
Nem_SSZone2:	binclude	"artnem/Special ZONE2.nem"
		even
Nem_SSZone3:	binclude	"artnem/Special ZONE3.nem"
		even
Nem_SSZone4:	binclude	"artnem/Special ZONE4.nem"
		even
Nem_SSZone5:	binclude	"artnem/Special ZONE5.nem"
		even
Nem_SSZone6:	binclude	"artnem/Special ZONE6.nem"
		even
Nem_SSUpDown:	binclude	"artnem/Special UP-DOWN.nem"
		even
Nem_SSEmerald:	binclude	"artnem/Special Emeralds.nem"
		even

; ---------------------------------------------------------------------------
; Collision data
; ---------------------------------------------------------------------------

		; Collision data starts at $68000 in this prototype, which amounts
		; to $241A bytes of padding.
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		align	$4000
	endif

AngleMap:	binclude	"collide/Angle Map.bin"
		even
CollArray1:	binclude	"collide/Collision Array (Normal).bin"
		even
CollArray2:	binclude	"collide/Collision Array (Rotated).bin"
		even
Col_GHZ:	binclude	"collide/GHZ.bin"
		even
Col_LZ:		binclude	"collide/LZ.bin"
		even
Col_MZ:		binclude	"collide/MZ.bin"
		even
Col_SLZ:	binclude	"collide/SLZ.bin"
		even
Col_SZ:		binclude	"collide/SZ.bin"
		even
Col_CWZ:	binclude	"collide/CWZ.bin"
		even

; ---------------------------------------------------------------------------
; Special Stage layout
; ---------------------------------------------------------------------------
SS_1:		binclude	"sslayout/1.bin"
SS_1_End:	even

; ---------------------------------------------------------------------------
; Animated uncompressed graphics
; ---------------------------------------------------------------------------
Art_GhzWater:	binclude	"artunc/GHZ Waterfall.bin"
		even
Art_GhzFlower1:	binclude	"artunc/GHZ Flower Large.bin"
		even
Art_GhzFlower2:	binclude	"artunc/GHZ Flower Small.bin"
		even
Art_MzLava1:	binclude	"artunc/MZ Lava Surface.bin"
		even
Art_MzLava2:	binclude	"artunc/MZ Lava.bin"
		even
Art_MzSaturns:	binclude	"artunc/MZ Saturns.bin"
		even
Art_MzTorch:	binclude	"artunc/MZ Background Torch.bin"
		even

; ---------------------------------------------------------------------------
; Level	layout index
; Format: foreground, background, leftover/unused
; ---------------------------------------------------------------------------
Level_Index:
		; GHZ
		dc.w Level_GHZ1-Level_Index, Level_GHZ1BG-Level_Index, Level_GHZ1Unk-Level_Index
		dc.w Level_GHZ2-Level_Index, Level_GHZ2BG-Level_Index, Level_GHZ2Unk-Level_Index
		dc.w Level_GHZ3-Level_Index, Level_GHZ3BG-Level_Index, Level_GHZ3Unk-Level_Index
		dc.w Level_GHZ4Unk-Level_Index, Level_GHZ4Unk-Level_Index, Level_GHZ4Unk-Level_Index
		; LZ
		dc.w Level_LZ1-Level_Index, Level_LZBG-Level_Index, Level_LZ1Unk-Level_Index
		dc.w Level_LZ2-Level_Index, Level_LZBG-Level_Index, Level_LZ2Unk-Level_Index
		dc.w Level_LZ3-Level_Index, Level_LZBG-Level_Index, Level_LZ3Unk-Level_Index
		dc.w Level_LZ4Unk-Level_Index, Level_LZ4Unk-Level_Index, Level_LZ4Unk-Level_Index
		; MZ
		dc.w Level_MZ1-Level_Index, Level_MZ1BG-Level_Index, Level_MZ1-Level_Index
		dc.w Level_MZ2-Level_Index, Level_MZ2BG-Level_Index, Level_MZ2Unk-Level_Index
		dc.w Level_MZ3-Level_Index, Level_MZ3BG-Level_Index, Level_MZ3Unk-Level_Index
		dc.w Level_MZ4Unk-Level_Index, Level_MZ4Unk-Level_Index, Level_MZ4Unk-Level_Index
		; SLZ
		dc.w Level_SLZ1-Level_Index, Level_SLZBG-Level_Index, Level_SLZUnk-Level_Index
		dc.w Level_SLZ2-Level_Index, Level_SLZBG-Level_Index, Level_SLZUnk-Level_Index
		dc.w Level_SLZ3-Level_Index, Level_SLZBG-Level_Index, Level_SLZUnk-Level_Index
		dc.w Level_SLZUnk-Level_Index, Level_SLZUnk-Level_Index, Level_SLZUnk-Level_Index
		; SZ
		dc.w Level_SZ1-Level_Index, Level_SZBG-Level_Index, Level_SZ1Unk-Level_Index
		dc.w Level_SZ2-Level_Index, Level_SZBG-Level_Index, Level_SZ2Unk-Level_Index
		dc.w Level_SZ3-Level_Index, Level_SZBG-Level_Index, Level_SZ3Unk-Level_Index
		dc.w Level_SZ4Unk-Level_Index, Level_SZ4Unk-Level_Index, Level_SZ4Unk-Level_Index
		; CWZ
		dc.w Level_CWZ1-Level_Index, Level_CWZ2-Level_Index, Level_CWZ2-Level_Index
		dc.w Level_CWZ2-Level_Index, Level_CWZ2BG-Level_Index, Level_CWZ2BG-Level_Index
		dc.w Level_CWZ3-Level_Index, Level_CWZ3-Level_Index, Level_CWZ3-Level_Index
		dc.w Level_CWZ4-Level_Index, Level_CWZ4-Level_Index, Level_CWZ4-Level_Index
		; Zone 6
		dc.w Level_0601-Level_Index, Level_06BG-Level_Index, Level_06BG-Level_Index
		dc.w Level_0602-Level_Index, Level_0602-Level_Index, Level_0602-Level_Index
		dc.w Level_0603-Level_Index, Level_0603-Level_Index, Level_0603-Level_Index
		dc.w Level_0604-Level_Index, Level_0604-Level_Index, Level_0604-Level_Index

Level_GHZ1:	binclude	"level/layout/ghz1.bin"
		even
Level_GHZ1BG:	binclude	"level/layout/ghzbg1.bin"
		even
Level_GHZ1Unk:	dc.l 0
Level_GHZ2:	binclude	"level/layout/ghz2.bin"
		even
Level_GHZ2BG:	binclude	"level/layout/ghzbg2.bin"
		even
Level_GHZ2Unk:	dc.l 0
Level_GHZ3:	binclude	"level/layout/ghz3.bin"
		even
Level_GHZ3BG:	binclude	"level/layout/ghzbg3.bin"
		even
Level_GHZ3Unk:	dc.l 0
Level_GHZ4Unk:	dc.l 0

Level_LZ1:	binclude	"level/layout/lz1.bin"
		even
Level_LZBG:	binclude	"level/layout/lzbg.bin"
		even
Level_LZ1Unk:	dc.l 0
Level_LZ2:	binclude	"level/layout/lz2.bin"
		even
Level_LZ2Unk:	dc.l 0
Level_LZ3:	binclude	"level/layout/lz3.bin"
		even
Level_LZ3Unk:	dc.l 0
Level_LZ4Unk:	dc.l 0

Level_MZ1:	binclude	"level/layout/mz1.bin"
		even
Level_MZ1BG:	binclude	"level/layout/mzbg1.bin"
		even
Level_MZ2:	binclude	"level/layout/mz2.bin"
		even
Level_MZ2BG:	binclude	"level/layout/mzbg2.bin"
		even
Level_MZ2Unk:	dc.l 0
Level_MZ3:	binclude	"level/layout/mz3.bin"
		even
Level_MZ3BG:	binclude	"level/layout/mzbg3.bin"
		even
Level_MZ3Unk:	dc.l 0
Level_MZ4Unk:	dc.l 0

Level_SLZ1:	binclude	"level/layout/slz1.bin"
		even
Level_SLZBG:	binclude	"level/layout/slzbg.bin"
		even
Level_SLZ2:	binclude	"level/layout/slz2.bin"
		even
Level_SLZ3:	binclude	"level/layout/slz3.bin"
		even
Level_SLZUnk:	dc.l 0

Level_SZ1:	binclude	"level/layout/sz1.bin"
		even
Level_SZBG:	binclude	"level/layout/szbg.bin"
		even
Level_SZ1Unk:	dc.l 0
Level_SZ2:	binclude	"level/layout/sz2.bin"
		even
Level_SZ2Unk:	dc.l 0
Level_SZ3:	binclude	"level/layout/sz3.bin"
		even
Level_SZ3Unk:	dc.l 0
Level_SZ4Unk:	dc.l 0

Level_CWZ1:	binclude	"level/layout/cwz1.bin"
		even
Level_CWZ2:	binclude	"level/layout/cwz2.bin"
		even
Level_CWZ2BG:	binclude	"level/layout/cwz2bg.bin"
		even
Level_CWZ3:	binclude	"level/layout/cwz3.bin"
		even
Level_CWZ4:	dc.l 0

Level_0601:	binclude	"leftovers/level/layout/test.bin"
		even
Level_06BG:	dc.l 0
Level_0602:	dc.l 0
Level_0603:	dc.l 0
Level_0604:	dc.l 0

; ---------------------------------------------------------------------------

		; ObjPos_Index starts at $70000 in this prototype, which amounts
		; to $1C26 bytes of padding.
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		align	$2000
	endif

; ---------------------------------------------------------------------------
; Object locations index
; ---------------------------------------------------------------------------
ObjPos_Index:
		; GHZ
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
		; No entries for Zone 6
		dc.w $FFFF, 0, 0

ObjPos_GHZ1:	binclude	"level/objpos/ghz1.bin"
		even
ObjPos_GHZ2:	binclude	"level/objpos/ghz2.bin"
		even
ObjPos_GHZ3:	binclude	"level/objpos/ghz3.bin"
		even

ObjPos_LZ1:	binclude	"level/objpos/lz1.bin"
		even
ObjPos_LZ2:	binclude	"level/objpos/lz2.bin"
		even
ObjPos_LZ3:	binclude	"level/objpos/lz3.bin"
		even

ObjPos_MZ1:	binclude	"level/objpos/mz1.bin"
		even
ObjPos_MZ2:	binclude	"level/objpos/mz2.bin"
		even
ObjPos_MZ3:	binclude	"level/objpos/mz3.bin"
		even

ObjPos_SLZ1:	binclude	"level/objpos/slz1.bin"
		even
ObjPos_SLZ2:	binclude	"level/objpos/slz2.bin"
		even
ObjPos_SLZ3:	binclude	"level/objpos/slz3.bin"
		even

ObjPos_SZ1:	binclude	"level/objpos/sz1.bin"
		even
ObjPos_SZ2:	binclude	"level/objpos/sz2.bin"
		even
ObjPos_SZ1_PB:	binclude	"leftovers/level/objpos/sz1.bin"
		even
ObjPos_SZ3:	binclude	"level/objpos/sz3.bin"
		even

ObjPos_CWZ1:	binclude	"level/objpos/cwz1.bin"
		even
ObjPos_CWZ2:	binclude	"level/objpos/cwz2.bin"
		even
ObjPos_CWZ3:	binclude	"level/objpos/cwz3.bin"
		even

ObjPos_Null:	dc.b $FF, $FF, 0, 0, 0,	0

; ---------------------------------------------------------------------------

		; SoundDriver starts at $74000 in this prototype, which amounts
		; to $12DC bytes of padding.
		; From a technical standpoint, this padding serves no purpose.
	if PaddingOptimization=0
		align	$2000
	endif

; ---------------------------------------------------------------------------

SoundDriver:
		include "s1.sounddriver.asm"
		even

; ---------------------------------------------------------------------------

	if PaddingOptimization=0
		cnop -1,2<<lastbit(*-1)
		dc.b $FF
	endif

; end of 'ROM'
EndOfROM:

		END
