#import "memorymap.asm"


TEXTSCROLL: {

// which part of screen? (raster/character line)
.label line_irq_raster = $f2
.label line_irq_work = $fa
.label scroll_line_start = $07c0

// smooth scrolling 8 steps
.label scrollmin = $bf
.label scrollmax = $c7


scrollx: .byte $c7 // XXX: would like to use the scrollmax defined above


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
    lda scrollx
    sta $d016
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
    dec scrollx
    lda scrollx
    cmp #scrollmin
    bne irq_work_exit
    lda #scrollmax
    sta scrollx
    ldx #$00
move_chars:
    lda scroll_line_start+1,x
    sta scroll_line_start,x
    inx
    cpx #$27
    bne move_chars
read_char:
    lda ScrollText
    bne write_char
    lda #<ADDRESSES.ScrollTextStart
    ldx #>ADDRESSES.ScrollTextStart
    sta read_char+1
    stx read_char+2
    jmp read_char
write_char:
    sta scroll_line_start+$27
next_char:
    inc read_char+1
    bne irq_work_exit
    inc read_char+2
irq_work_exit:
    nextIrq(SPRITESCROLL.irq_raster)
    nextRasterLine(SPRITESCROLL.line_irq_raster)
    jmp $ea31

* = ADDRESSES.ScrollTextStart
ScrollText:
    .text "hello, lamerz! you suck.... 123... "
    .byte 0

}
