.include "zeropage.inc"
.include "sysram.inc"
.include "acia.inc"
.include "xmodem.inc"

.import _init
.export _main
.code
_main:
        jsr _acia_init
loop:
        jsr _acia_getc
        cmp #'x'
        beq run_xmodem
        cmp #'r'
        beq run_prog
        jsr _acia_putc
        jmp loop

run_xmodem:
        sei
        jsr _xmodem
        cli
        jmp loop

run_prog:
        jsr $1000
        jmp loop

.segment "VECTORS"
        .word 0
        .word _init
        .word 0
