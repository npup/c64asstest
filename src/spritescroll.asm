

SPRITESCROLL: {

// which part of screen? (raster/character line)
.label line_irq_raster = $50
.label line_irq_work = $70


irq_raster:
    ackRasterInterrupt()
    nop
    nop
    nop
    nop
    nop
    lda #$00
    sta $d020
    sta $d021

    nextIrq(irq_work)
    nextRasterLine(line_irq_work)
    // we have about 6 raster lines of time available here
    jmp $ea81


irq_work:
    ackRasterInterrupt()
    nop
    nop
    nop
    nop
    nop
    lda #$06
    sta $d021
    lda #$c8
    sta $d016
    lda #$0e
    sta $d020

irq_work_exit:
    nextIrq(TEXTSCROLL.irq_raster)
    nextRasterLine(TEXTSCROLL.line_irq_raster)
    jmp $ea81



}
