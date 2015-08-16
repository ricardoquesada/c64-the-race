;--------------------------------------------------------------------------
;
; The MUni Race: https://github.com/ricardoquesada/c64-the-muni-race
;
; game scene
;
;--------------------------------------------------------------------------

; exported by the linker
.import __MAIN_CODE_LOAD__, __ABOUT_CODE_LOAD__, __SIDMUSIC_LOAD__, __MAIN_SPRITES_LOAD__

; from main.s
.import selected_rider

; from utils.s
.import clear_screen, clear_color, get_key, read_joy2

;--------------------------------------------------------------------------
; Macros
;--------------------------------------------------------------------------
.macpack cbm			; adds support for scrcode
.macpack mymacros		; my own macros

;--------------------------------------------------------------------------
; Constants
;--------------------------------------------------------------------------
.include "c64.inc"		; c64 constants

RASTER_TOP = 12			; first raster line
RASTER_BOTTOM = 50 + 8*3	; moving part of the screen

.segment "GAME_CODE"

	sei

	lda #01
	jsr clear_color
	jsr init_screen
	jsr init_sprites

	; enable raster irq
	lda #01
	sta $d01a

	; raster irq vector
	ldx #<irq_top
	ldy #>irq_top
	stx $fffe
	sty $ffff

	lda #RASTER_TOP
	sta $d012

	; clear interrupts and ACK irq
	lda $dc0d
	lda $dd0d
	asl $d019

	cli

	jmp *

;--------------------------------------------------------------------------
; IRQ handler: RASTER_TOP
;--------------------------------------------------------------------------
.proc irq_top
	pha			; saves A, X, Y
	txa
	pha
	tya
	pha

	STABILIZE_RASTER

	lda #00
	sta $d020
	lda #00
	sta $d021

	lda #<irq_bottom
	sta $fffe
	lda #>irq_bottom
	sta $ffff

	lda #RASTER_BOTTOM
	sta $d012

	asl $d019

	pla			; restores A, X, Y
	tay
	pla
	tax
	pla
	rti			; restores previous PC, status
.endproc

;--------------------------------------------------------------------------
; IRQ handler: RASTER_BOTTOM
;--------------------------------------------------------------------------
.proc irq_bottom
	pha			; saves A, X, Y
	txa
	pha
	tya
	pha

	STABILIZE_RASTER

	lda #$00
	sta $d020
	lda #14
	sta $d021

	lda #<irq_top
	sta $fffe
	lda #>irq_top
	sta $ffff

	lda #RASTER_TOP
	sta $d012

	asl $d019

	pla			; restores A, X, Y
	tay
	pla
	tax
	pla
	rti			; restores previous PC, status
.endproc


;--------------------------------------------------------------------------
; void init_screen() 
;--------------------------------------------------------------------------
.proc init_screen

	lda #14
	sta $d020
	sta $d021

	; screen is at $8400
	ldx #$00
@loop:
	lda #$20
	sta $8400,x
	sta $8400+$0100,x
	sta $8400+$0200,x
	sta $8400+$02e8,x
	inx
	bne @loop

	ldx #40*2-1
:	lda screen,x
	ora #$80		; using second half of the romset
	sta $8400,x
	dex
	bpl :-

	rts
.endproc

;--------------------------------------------------------------------------
; void init_screen() 
;--------------------------------------------------------------------------
.proc init_sprites
	; in case rider 1 is selected (instead of 0)
	; sprite pointer and sprite color need to be changed
	lda selected_rider
	cmp #$01
	bne :+

	lda #$08		; sprite pointer 8
	sta $87f8

	lda __MAIN_SPRITES_LOAD__ + 64 * 8 + 63 ; sprite color
	and #$0f
	sta VIC_SPR0_COLOR

:
	lda #%00000001
	sta VIC_SPR_ENA
	lda #40
	sta VIC_SPR0_X
	lda #80
	sta VIC_SPR0_Y
	rts
.endproc

smooth_scroll_x:
	.byte $07

screen:
		;0123456789|123456789|123456789|123456789|
	scrcode " score                             time "
	scrcode " 00000                              90  "
