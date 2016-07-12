;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;
; The Uni Games: https://github.com/ricardoquesada/c64-the-uni-games
;
; music tables
;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

; main title (popcorn2): uses a NTSC table... WTF?
; road race (12 Bar Blues): same
; cyclo cross (Action G): same
;  $1647 lo
;  $16a7 hi
SONG1_FREQ_TBL_LO = $1647
SONG1_FREQ_TBL_HI = $16a7

; cross country (Sunny Day): uses a PAL table.
;  $1634 lo
;  $1694 hi
SONG2_FREQ_TBL_LO = $1634
SONG2_FREQ_TBL_HI = $1694

.import ut_vic_video_type

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void music_patch_table_1()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.export music_patch_table_1
.proc music_patch_table_1
        lda ut_vic_video_type                   ; $01 --> PAL
                                                ; $2F --> PAL-N
                                                ; $28 --> NTSC
                                                ; $2e --> NTSC-OLD
        cmp #1                                  ; table is already in NTSC
        bne end                                 ; only patch it if in PAL

        ldx #MUSIC_TABLE_SIZE-1
l0:     lda palb_freq_table_lo,x
        sta SONG1_FREQ_TBL_LO,x
        lda palb_freq_table_hi,x
        sta SONG1_FREQ_TBL_HI,x
        dex
        bpl l0

end:
        rts
.endproc

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void music_patch_table_2()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.export music_patch_table_2
.proc music_patch_table_2
        lda ut_vic_video_type                   ; $01 --> PAL
                                                ; $2F --> PAL-N
                                                ; $28 --> NTSC
                                                ; $2e --> NTSC-OLD
        cmp #1                                  ; table is already in PAL
        beq end                                 ; only patch it is not

        ldx #MUSIC_TABLE_SIZE-1
l0:     lda ntsc_freq_table_lo,x
        sta SONG2_FREQ_TBL_LO,x
        lda ntsc_freq_table_hi,x
        sta SONG2_FREQ_TBL_HI,x
        dex
        bpl l0

end:
        rts
.endproc

; autogenerated table: freq_table_generator.py -b440 -o8 -s12 985248
.export palb_freq_table_lo
palb_freq_table_lo:
.byte $16,$27,$39,$4b,$5f,$74,$8a,$a1,$ba,$d4,$f0,$0e  ; 0
.byte $2d,$4e,$71,$96,$be,$e7,$14,$42,$74,$a9,$e0,$1b  ; 1
.byte $5a,$9c,$e2,$2d,$7b,$cf,$27,$85,$e8,$51,$c1,$37  ; 2
.byte $b4,$38,$c4,$59,$f7,$9d,$4e,$0a,$d0,$a2,$81,$6d  ; 3
.byte $67,$70,$89,$b2,$ed,$3b,$9c,$13,$a0,$45,$02,$da  ; 4
.byte $ce,$e0,$11,$64,$da,$76,$39,$26,$40,$89,$04,$b4  ; 5
.byte $9c,$c0,$23,$c8,$b4,$eb,$72,$4c,$80,$12,$08,$68  ; 6
.byte $39,$80,$45,$90,$68,$d6,$e3,$99,$00,$24,$10,$ff  ; 7
MUSIC_TABLE_SIZE = * - palb_freq_table_lo

.export palb_freq_table_hi
palb_freq_table_hi:
.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02  ; 0
.byte $02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03,$04  ; 1
.byte $04,$04,$04,$05,$05,$05,$06,$06,$06,$07,$07,$08  ; 2
.byte $08,$09,$09,$0a,$0a,$0b,$0c,$0d,$0d,$0e,$0f,$10  ; 3
.byte $11,$12,$13,$14,$15,$17,$18,$1a,$1b,$1d,$1f,$20  ; 4
.byte $22,$24,$27,$29,$2b,$2e,$31,$34,$37,$3a,$3e,$41  ; 5
.byte $45,$49,$4e,$52,$57,$5c,$62,$68,$6e,$75,$7c,$83  ; 6
.byte $8b,$93,$9c,$a5,$af,$b9,$c4,$d0,$dd,$ea,$f8,$ff  ; 7


; autogenerated table: freq_table_generator.py -b440 -o8 -s12 1022727
.export ntsc_freq_table_lo
ntsc_freq_table_lo:
.byte $0c,$1c,$2d,$3f,$52,$66,$7b,$92,$aa,$c3,$de,$fa  ; 0
.byte $18,$38,$5a,$7e,$a4,$cc,$f7,$24,$54,$86,$bc,$f5  ; 1
.byte $31,$71,$b4,$fc,$48,$98,$ed,$48,$a7,$0c,$78,$e9  ; 2
.byte $62,$e2,$69,$f8,$90,$30,$db,$8f,$4e,$19,$f0,$d3  ; 3
.byte $c4,$c3,$d1,$f0,$1f,$61,$b6,$1e,$9d,$32,$df,$a6  ; 4
.byte $88,$86,$a3,$e0,$3f,$c2,$6b,$3d,$3a,$64,$be,$4c  ; 5
.byte $0f,$0c,$46,$bf,$7d,$84,$d6,$7a,$73,$c8,$7d,$97  ; 6
.byte $1e,$18,$8b,$7f,$fb,$07,$ac,$f4,$e7,$8f,$f9,$2f  ; 7
.export ntsc_freq_table_hi
ntsc_freq_table_hi:
.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01  ; 0
.byte $02,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03  ; 1
.byte $04,$04,$04,$04,$05,$05,$05,$06,$06,$07,$07,$07  ; 2
.byte $08,$08,$09,$09,$0a,$0b,$0b,$0c,$0d,$0e,$0e,$0f  ; 3
.byte $10,$11,$12,$13,$15,$16,$17,$19,$1a,$1c,$1d,$1f  ; 4
.byte $21,$23,$25,$27,$2a,$2c,$2f,$32,$35,$38,$3b,$3f  ; 5
.byte $43,$47,$4b,$4f,$54,$59,$5e,$64,$6a,$70,$77,$7e  ; 6
.byte $86,$8e,$96,$9f,$a8,$b3,$bd,$c8,$d4,$e1,$ee,$fd  ; 7


; autogenerated table: freq_table_generator.py -b440 -o8 -s12 1023440
.export paln_freq_table_lo
paln_freq_table_lo:
.byte $0c,$1c,$2d,$3f,$52,$66,$7b,$92,$aa,$c3,$de,$fa  ; 0
.byte $18,$38,$5a,$7e,$a3,$cc,$f6,$23,$53,$86,$bb,$f4  ; 1
.byte $30,$70,$b4,$fb,$47,$97,$ec,$46,$a6,$0b,$76,$e8  ; 2
.byte $60,$e0,$67,$f6,$8e,$2e,$d9,$8d,$4c,$16,$ed,$d0  ; 3
.byte $c1,$c0,$ce,$ec,$1c,$5d,$b1,$1a,$98,$2d,$da,$a0  ; 4
.byte $82,$80,$9c,$d9,$37,$ba,$63,$34,$30,$5a,$b4,$40  ; 5
.byte $03,$ff,$38,$b1,$6e,$74,$c5,$68,$60,$b4,$67,$81  ; 6
.byte $07,$ff,$70,$62,$dd,$e7,$8a,$d0,$c1,$67,$ce,$02  ; 7
.export paln_freq_table_hi
paln_freq_table_hi:
.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01  ; 0
.byte $02,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03  ; 1
.byte $04,$04,$04,$04,$05,$05,$05,$06,$06,$07,$07,$07  ; 2
.byte $08,$08,$09,$09,$0a,$0b,$0b,$0c,$0d,$0e,$0e,$0f  ; 3
.byte $10,$11,$12,$13,$15,$16,$17,$19,$1a,$1c,$1d,$1f  ; 4
.byte $21,$23,$25,$27,$2a,$2c,$2f,$32,$35,$38,$3b,$3f  ; 5
.byte $43,$46,$4b,$4f,$54,$59,$5e,$64,$6a,$70,$77,$7e  ; 6
.byte $86,$8d,$96,$9f,$a8,$b2,$bd,$c8,$d4,$e1,$ee,$fd  ; 7

.export music_speed
music_speed:    .word $4cc7             ; default: playing at PAL speed in PAL computer

.export PALB_MUSIC_SPEED
PALB_MUSIC_SPEED = $4cc7                ; playing at PAL speed in PAL computer
.export NTSC_MUSIC_SPEED
NTSC_MUSIC_SPEED = $4fb2                ; playing at PAL speed in NTSC computer
.export PALN_MUSIC_SPEED
PALN_MUSIC_SPEED = $4fc1                ; playing at PAL seped in Drean computer
