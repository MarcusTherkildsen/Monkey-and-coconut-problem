; Hello World 1.0
; February 17, 2007
; Austin Patten
; Based mostly from GALP, John Harrison and Clint Houchin

INCLUDE "gbhw.inc" ; standard hardware definitions from devrs.com
INCLUDE "ibmpc1.inc" ; ASCII character set from devrs.com
;INCLUDE "standard-defs.inc"
;INCLUDE "print-number.asm" ; Routine to print out numbers



DELAYTIME	equ	$ffff	; how long we delay between text readouts
; IRQs
SECTION	"Vblank",HOME[$0040]
	reti
SECTION	"LCDC",HOME[$0048]
	reti
SECTION	"Timer_Overflow",HOME[$0050]
	reti
SECTION	"Serial",HOME[$0058]
	reti
SECTION	"p1thru4",HOME[$0060]
	reti

; ****************************************************************************************
; boot loader jumps to here.
; ****************************************************************************************
SECTION	"start",HOME[$0100]
nop
jp	begin

; ****************************************************************************************
; ROM HEADER and ASCII character set
; ****************************************************************************************
; ROM header
	NINTENDO_LOGO	CART_ROM, CART_ROM_1M, CART_RAM_NONE
;NINTENDO_LOGO	ROM_NOMBC, ROM_SIZE_32KBYTE, RAM_SIZE_0KBYTE
INCLUDE "memory.asm"
TileData:
	chr_IBMPC1	1,8 ; LOAD ENTIRE CHARACTER SET

; ****************************************************************************************
; Main code Initialization:
; set the stack pointer, enable interrupts, set the palette, set the screen relative to the window
; copy the ASCII character table, clear the screen
; ****************************************************************************************
begin:
	nop
	di
	ld	sp, $ffff		; set the stack pointer to highest mem location + 1
init:
	ld	a, %11100100 	; Window palette colors, from darkest to lightest
	ld	[rBGP], a		; CLEAR THE SCREEN

	ld	a,0			; SET SCREEN TO TO UPPER RIGHT HAND CORNER
	ld	[rSCX], a
	ld	[rSCY], a		
	call	StopLCD		; YOU CAN NOT LOAD $8000 WITH LCD ON
	ld	hl, TileData
	ld	de, _VRAM		; $8000
	ld	bc, 8*256 		; the ASCII character set: 256 characters, each with 8 bytes of display data
	call	mem_CopyMono	; load tile data
	ld	a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ16|LCDCF_OBJOFF 
	ld	[rLCDC], a	
	ld	a, 32		; ASCII FOR BLANK SPACE
	ld	hl, _SCRN0
	ld	bc, SCRN_VX_B * SCRN_VY_B
	call	mem_SetVRAM
; ****************************************************************************************
; Main code:
; Print a character string in the middle of the screen
; ****************************************************************************************
main:
	call loopnum



; ****************************************************************************************
; Prologue
; Wait patiently 'til somebody kills you
; ****************************************************************************************
wait:
	halt
	nop
	jr	wait

; ****************************************************************************************
; Delay
; This is simple, but there are better ways to do this
; so that the delay would be the same no matter the speed of the processor...
; ****************************************************************************************
simpleDelay:
	dec	bc
	ld	a,b
	or	c
	jr	nz, simpleDelay
	ret
; ****************************************************************************************
; hard-coded data
; ****************************************************************************************
Title:
	DB	"Hello World !"
TitleEnd:

Title2:
	DB	"I wish the world was in color"
Title2End:

Title3:
	DB 	"I wonder what 5+3-2="
Title3End:

; ****************************************************************************************
; StopLCD:
; turn off LCD if it is on
; and wait until the LCD is off
; ****************************************************************************************
StopLCD:
        ld      a,[rLCDC]
        rlca                    ; Put the high bit of LCDC into the Carry flag
        ret     nc              ; Screen is off already. Exit.

; Loop until we are in VBlank

waiter:
        ld      a,[rLY]
        cp      145             ; Is display on scan line 145 yet?
        jr      nz, waiter     ; no, keep waiting
	ret

; Turn off the LCD

        ld      a,[rLCDC]
        res     7,a             ; Reset bit 7 of LCDC
        ld      [rLCDC],a

        ret


loopnum:
	ld	de, _SCRN0+3+(SCRN_VY_B*7)
	ld bc, 1
	ld [hl], 49
	call mem_CopyVRAM

	ld	bc, DELAYTIME
	call	simpleDelay
	ld bc, 1
	ld [hl], 50
	call mem_CopyVRAM

	ld	bc, DELAYTIME
	call	simpleDelay
	ld bc, 1
	ld [hl], 51
	call mem_CopyVRAM

	ld	bc, DELAYTIME
	call	simpleDelay

	call init

	jp z, loopnum

	ret 
	