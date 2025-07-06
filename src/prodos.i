PRODOS = $BF00

Die .(
                lda #<msg
                ldx #>msg
                jsr PrintStr

                jsr WaitAnyKey

                sta SET_ROM
                jsr PRODOS
                .db $65
                .dw table
table
                .db 4, 0
                .dw 0000
                .db 0
                .dw 0
msg
                .asc 13, 13, "Press any key to exit.", 0
                .)          