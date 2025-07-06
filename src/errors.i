; X, A - string address
FatalError:
    jsr PrintStr
    jsr Beep
    jmp Die


ErrNo80ColCard:
                .asc 13, "This software requires a 80 column card.", 13, 0