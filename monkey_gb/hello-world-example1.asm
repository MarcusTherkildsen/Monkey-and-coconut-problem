; Hello World 1.0
; February 2, 2007
; John Harrison
; Based mostly from GALP

INCLUDE "gbhw.inc" ; standard hardware definitions from devrs.com
INCLUDE "ibmpc1.inc" ; ASCII character set from devrs.com
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
	ROM_HEADER	ROM_NOMBC, ROM_SIZE_32KBYTE, RAM_SIZE_0KBYTE
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
	ld	hl, Title
	ld	de, _SCRN0+3+(SCRN_VY_B*7) ; 
	ld	bc, TitleEnd-Title
	
;* mem_CopyVRAM - "Copy" a memory region to or from VRAM
;*
;* input:
;*   hl - pSource
;*   de - pDest
;*   bc - bytecount

	;call	mem_CopyVRAM
	;ld	bc, DELAYTIME
	;call	simpleDelay
	;call	simpleDelay
	;call	simpleDelay


;* mem_SetVRAM - "Set" a memory region in VRAM
;*
;* input:
;*    a - value
;*   hl - pMem
;*   bc - bytecount

	ld b, 4


	ld [hl], b
	call printnum
	;call	mem_CopyVRAM
	
	
	ld	bc, DELAYTIME
	call	simpleDelay
	call	simpleDelay
	call	simpleDelay
	
	ld	hl, Title2
	ld	de, _SCRN0+3+(SCRN_VY_B*7) ; 
	ld	bc, Title2End-Title2
	call	mem_CopyVRAM
	ld	bc, DELAYTIME
	call	simpleDelay
	call	simpleDelay
	call	simpleDelay
	
	ld	hl, Title3
	ld	de, _SCRN0+3+(SCRN_VY_B*7) ; 
	ld	bc, Title3End-Title3
	call	mem_CopyVRAM
	ld	bc, DELAYTIME
	call	simpleDelay
	call	simpleDelay
	call	simpleDelay

	ld	hl, Title4
	;ld	de, _SCRN0+3+(SCRN_VY_B*7) ; 
	;ld	bc, Title4End-Title4
	;call	mem_CopyVRAM
	;ld	bc, DELAYTIME
	;call	simpleDelay
	;call	simpleDelay
	;call	simpleDelay
	;ld	hl, Title5

	;ld	de, _SCRN0+0+(SCRN_VY_B*7) ; 
	

	; put zero into register A
	;ld a, 05
	;ld b, 06
	; Copy the value in A into the memory location 8000 hexidecimal
	;ld ($C000), A
	;ld $8000, a
	;add a, b

	;inc A

	; get the score
	;ld A, (8000H)
	; increment A by 1
	;inc A
	; copy A back to memory
	;ld (8000H), A
	; subtract 100 from A
	;sub 101
	; jump to the position "after" if the previous operation went below zero -> when score is above 100
	;jp c, after
	;ld A, 0
	;ld (8000H), A
	;ld A, (8000H)
	;inc A
	;ld (8001H), A
	;after:
	
	;ld	bc, Title5End-Title5
	;call	mem_CopyVRAM
	;ld	bc, DELAYTIME
	;call	simpleDelay
	;call	simpleDelay
	;call	simpleDelay

	;ld	bc, 5
	;ld	de, 3
	;ld 	hl, 0
	;add	hl, bc
	;add  hl, de
	;ld 	bc, -2
	;add  hl, bc
	;ld 	b, h
	;ld	c, l


	;ld	de, _SCRN0+4+(SCRN_VY_B*9) ; 
	;call	mem_CopyVRAM
;	ld	bc, DELAYTIME
;	call	simpleDelay

	jr	main

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
	;DB	"Monkey & Cocs"
TitleEnd:

Title2:
	DB	"Wassupp Yo???"
Title2End:

Title3:
	DB	"Hey asslicker"
Title3End:

Title4:
	DB	"Math on da GB"
Title4End:

Title5:
	;DB	"suck numba 66"
Title5End:

printnum:
    ld a, 0         ; cursor position
    ld b, 65        ; ASCII 'A'
    ld hl, Number   ; set pointer to address of Number
overwrite:
    ld [hl], b      ; set dereference to 'A' ???
    inc hl          ; increment pointer
    inc a           ; increment acc
    cp 7            ; are we done?
    jp z, overwrite ; continue if not

    ; V output to screen V
    ld  hl, Number
    ld  de, _SCRN0+3+(SCRN_VY_B*7) ;
    ld  bc, NumberEnd-Number
    call mem_CopyVRAM

    ret             ; done
Number:
    DB  "BBBBBBBB"  ; placeholder
NumberEnd:

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

.wait:
        ld      a,[rLY]
        cp      145             ; Is display on scan line 145 yet?
        jr      nz,.wait        ; no, keep waiting

; Turn off the LCD

        ld      a,[rLCDC]
        res     7,a             ; Reset bit 7 of LCDC
        ld      [rLCDC],a

        ret
