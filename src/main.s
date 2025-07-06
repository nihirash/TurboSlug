                *=$2000
                
                jsr main
#include "zp_vars.i"
#include "console.i"
#include "errors.i"
#include "memory.i"
#include "prodos.i"
#include "ui.s"
#include "vars.i"
#include "buffer.i"
main:
                jsr Is80ColAvailable
                beq no80colcard               
                jsr TextModeInit

                jsr RenderUI

                jmp Die

no80colcard:
                lda #<ErrNo80ColCard
                ldx #>ErrNo80ColCard
                jmp FatalError

buffer:
    .bin 0, 0, "assets/example.gph"
    .db 0
    .db 0