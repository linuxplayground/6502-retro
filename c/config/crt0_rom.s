            .include "zeropage.inc"
            .include "acia.inc"
            .include "interrupt.inc"

            .export __STARTUP__ : absolute = 1
            .export _init
            .export _exit

            .import __RAM_START__
            .import __RAM_SIZE__
            .import _main
            .import zerobss
            .import copydata
            .import initlib
            .import donelib
            .import irq_init

            .segment "VECTORS"

            .addr _nmi_handler
            .addr _init
            .addr _irq_handler

            .segment  "STARTUP"

_init:      sei
            cld
            ldx #$ff
            txs

            lda #<(__RAM_START__ + __RAM_SIZE__)
            sta sp
            lda #>(__RAM_START__ + __RAM_SIZE__)
            sta sp + 1

            jsr zerobss
            jsr copydata
            jsr initlib

            jsr _acia_init
            jsr _irq_init
            cli

            jsr _main

_exit:      jsr donelib
end:        jmp end
