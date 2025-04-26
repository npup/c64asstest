// NOTE: manipulates registers: A
.macro ackRasterInterrupt() {
    lda #$01
    sta $d019
}

// NOTE: manipulates registers: A
.macro nextRasterLine(line) {
    lda #line
    sta $d012
}

// NOTE: manipulates registers: A, X
.macro nextIrq(address) {
    lda #<address
    ldx #>address
    sta $0314
    stx $0315
}