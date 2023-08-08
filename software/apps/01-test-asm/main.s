.include "zeropage.inc"
.include "sysram.inc"
.include "kernal.inc"

.export _main
.code


_main:
        jsr _acia_getc
        cmp #$1b
        beq exit
        jsr _acia_putc
        jmp _main
exit:
        rts
