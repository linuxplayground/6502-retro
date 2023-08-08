.include "zeropage.inc"
.include "sysram.inc"
.include "acia.inc"
.include "xmodem.inc"
.include "wozmon.inc"

.import _init
.export _main

.macro print addr
        lda #<addr
        ldx #>addr
        jsr _acia_puts
.endmacro

.code
_main:
        jsr _acia_init
        print banner
        print help
loop:
        print prompt
        jsr _acia_getc
        jsr _acia_putc
        cmp #'x'
        beq run_xmodem
        cmp #'r'
        beq run_prog
        cmp #'w'
        beq run_wozmon
        cmp #'h'
        beq run_help
        print error
        jmp loop

run_xmodem:
        sei
        jsr _xmodem
        cli
        jmp loop
run_prog:
        jsr $1000
        jmp loop
run_wozmon:
        jsr _wozmon
        jmp loop
run_help:
        print help
        jmp loop


.rodata
banner: .byte $0d, "6502-Retro", $0a, $0d, $0
help:   .byte "x-load", $0a, $0d
        .byte "r-run", $0a, $0d
        .byte "w-monitor", $0a, $0d
        .byte "h-help", $0a, $0d, $0
prompt: .byte $0a, $0d, "> ", $0
error:  .byte "error",$0a, $0d, $0

.segment "VECTORS"
        .word 0
        .word _init
        .word 0
