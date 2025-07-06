; A - line number
FindBufferOffset: .(
    ldx #<buffer
    stx DE
    ldx #>buffer
    stx DE+1

    and #$ff
    beq Exit

    tax
    ldy #0
LineLoop:
    lda (DE),y
    beq BufferEnded
    
    cmp #10
    beq NextLine

    iny
    bra LineLoop
NextLine:
    iny

    clc
    tya
    adc DE
    sta DE

    lda DE+1
    adc #0
    sta DE+1

    dex
    txa
    cmp #0
    beq Exit

    ldy #0
    bra LineLoop

Exit:
    lda #0
    rts

BufferEnded:
    lda #$ff
    rts
    .)

FindNextLine: .(
    ldy #0
loop:
    lda (DE),y
    beq Exit
    cmp #10
    beq Found
    iny
    bra loop 
Exit:
    lda #$ff
    rts  
Found:
    iny
    clc
    tya
    adc DE
    sta DE

    lda DE+1
    adc #0
    sta DE+1

    lda #$00
    rts
.)