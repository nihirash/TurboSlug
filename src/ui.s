RenderUI: .(
    jsr ClearScreen

    lda #<header
    ldx #>header
    jsr PrintStrInv

    lda #<url
    ldx #>url
    jsr PrintStr

    lda #<domain
    ldx #>domain
    jsr Print70

    jsr NewLine

    lda #<blank
    ldx #>blank
    jsr PrintStrInv

    ldy #0
    lda #22
    jsr SetXY

    lda #<footer
    ldx #>footer
    jsr PrintStrInv

    jsr RenderGopherPage
    jmp WaitAnyKey

header:
    .asc "     TurboSlug - Gopher Browser for Apple IIe with FujiNet (c) 2025 Nihirash    ",0
footer:
    .asc "       Arrows - move cursor   Enter - navigate    ESC - exit                    ",0
url:
    .asc "URL: ", 0
.)

blank:
    .dsb 80, ' '
    .db 0

RenderGopherPage: .(
    ldy #0
    sty LINES_ON_SCREEN
    lda #3
    jsr SetXY

    lda page_offset
    jsr FindBufferOffset

    lda #PER_PAGE
    sta LINE
    
loop:
    jsr RenderGopherLine
    jsr NewLine

    inc LINES_ON_SCREEN
    jsr FindNextLine
    bne done

    dec LINE
    beq done

    bra loop
done:
    rts
    .)
    
RenderGopherLine: .(
    jsr ClearLine

    ldy #$00
    lda (DE), y

    cmp #'1'
    beq set_page_msg

    cmp #'9'
    beq set_bin_msg

    cmp #'7'
    beq set_search_msg

    cmp #'0'
    beq set_txt_msg

    lda #<no_msg
    ldx #>no_msg

render_type:
    jsr GopherPrint
    
    clc
    lda #$01
    adc DE
    sta DE

    lda DE+1
    adc #$00
    sta DE+1

    lda DE
    ldx DE+1
    jsr GopherPrint

    rts
set_page_msg:
    lda #<page_mgs
    ldx #>page_mgs  
    bra render_type
set_bin_msg:
    lda #<bin_msg
    ldx #>bin_msg
    bra render_type
set_search_msg:
    lda #<src_msg
    ldx #>src_msg
    bra render_type
set_txt_msg:
    lda #<txt_msg
    ldx #>txt_msg
    bra render_type
no_msg:
    .asc "         ", 0
page_mgs:
    .asc "<PAGE>   ", 0
bin_msg:
    .asc "<BIN>    ", 0
src_msg:
    .asc "<SEARCH> ", 0
txt_msg:
    .asc "<TEXT>   ", 0
.)

ClearLine: .(

    lda current_line
    cmp LINES_ON_SCREEN
    bne not_current

    lda #<blank
    ldx #>blank
    jsr PrintStrInv
    jmp CursorUp
not_current
    lda #<blank
    ldx #>blank
    jsr PrintStr
    jmp CursorUp

    .)

GopherPrint: .(
    pha

    lda current_line
    cmp LINES_ON_SCREEN

    bne not_current

    pla
    jmp Print70I
not_current:
    pla
    jmp Print70
.)