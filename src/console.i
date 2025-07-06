_NewLine = $FC62
; Don't call without switching to ROM first
; A - character to print
PutCharInv = $FDED
;; Make a noise
Bell = $FBDD
;; Clear the screen
ClrScr = $E5E8
BasCalc = $FB5B

NewLine: .(
                sta SET_ROM
                lda #$8D
                jsr PutCharInv
                lda SET_RAM
                lda SET_RAM
                rts
        .)

ClearScreen: .(
                sta SET_ROM
                jsr ClrScr
                lda SET_RAM
                lda SET_RAM
                rts
        .)

Beep: .(
                sta SET_ROM
                jsr Bell
                lda SET_RAM
                lda SET_RAM
                rts
        .)

;; Set the cursor position
;; Use A and Y Registers
SetXY: .(
                sta SET_ROM
                jsr BasCalc
                lda SET_RAM
                lda SET_RAM
                rts
        .)

CursorUp: .(
                sta SET_ROM
                ldy #3
                dec YPOS
                lda YPOS
                jsr BasCalc 
                lda SET_RAM
                lda SET_RAM
                rts
        .)

;; Checks if an 80 column card is available
;; Returns 0 if not available
Is80ColAvailable .(
                lda $BF98
                and #$02
                rts
    .)

; Initializes the text mode for 80 column display
TextModeInit .(
                sta SET_ROM
                
                jsr $C300

                lda #3
                jsr $FE95

                lda SET_RAM
                lda SET_RAM
                rts
    .)

; Don't call without switching to ROM first
; A - character to print
PutChar .(    
    eor #$80
    jsr PutCharInv
    rts
    .)

; Prints a string to the screen(inverted colors)
; X, A - string address
PrintStrInv .(
                sta SET_ROM
                sta HL
                stx HL+1
                ldy #$00
loop:           lda (HL),y
                beq exit
                jsr PutCharInv
                iny
                bra loop
exit:           lda SET_RAM
                lda SET_RAM
                rts
          .)

; Prints a string to the screen
; X, A - string address
PrintStr .(
                    sta SET_ROM

                    sta HL
                    stx HL+1

                    ldy #$00
loop:               lda (HL),y
                    beq exit
                    jsr PutChar
                    iny
                    bra loop
exit:               
                    lda SET_RAM
                    lda SET_RAM
                    rts
                    .)
Print70: .(
                    sta SET_ROM
                    
                    sta HL
                    stx HL+1
                    ldx #70
                    ldy #$00
loop:               lda (HL),y
                    beq exit
                    ; Tab is sepparator
                    cmp #$09
                    beq exit
                    ; CR and LF are too
                    cmp #$0A
                    beq exit

                    cmp #$0D
                    beq exit
                    
                    jsr PutChar
                    iny
                    dex
                    bne loop
exit:               lda SET_RAM
                    lda SET_RAM
                    rts
            .)

Print70I: .(
                    sta SET_ROM
                    
                    sta HL
                    stx HL+1
                    ldx #70
                    ldy #$00
loop:               lda (HL),y
                    beq exit
                    ; Tab is sepparator
                    cmp #$09
                    beq exit
                    ; CR and LF are too
                    cmp #$0A
                    beq exit

                    cmp #$0D
                    beq exit
                    
                    jsr PutCharInv
                    iny
                    dex
                    bne loop
exit:               lda SET_RAM
                    lda SET_RAM
                    rts
            .)

;;; Waits for any key to be pressed
WaitAnyKey .(
                    sta $C010
wait
                    lda $c000
                    and #$80
                    beq wait
                    rts
            .)