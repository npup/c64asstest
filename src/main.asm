
#import "./macros.asm"
#import "./textscroll.asm"
#import "./spritescroll.asm"

BasicUpstart2(main)

* = ADDRESSES.Main

main:
    lda #$01
    sta $d020
    rts

main2:
    sei

    // CIA1 and CIA2
    // switch off interrupt signals
    lda #%01111111
    sta $dc0d
    sta $dd0d
    // acknowledge pending interrupts
    lda $dc0d
    lda $dd0d

    // VIC
    // enable raster interrupt signals
    lda #$01
    sta $d01a

    // set up interrupt1
    nextIrq(TEXTSCROLL.irq_raster)
    

    // clear bit 7 of $d011 ("9th bit of $d012")
    lda $d011
    and #%01111111
    sta $d011
    nextRasterLine(TEXTSCROLL.line_irq_raster)

    cli
    rts

