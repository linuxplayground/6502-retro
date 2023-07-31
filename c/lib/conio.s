        .include "sysram.inc"
        .include "acia.inc"
        .include "console_macros.inc"
        .include "zeropage.inc"

        .export _con_getc
        .export _con_putc
        .export _con_prompt
        .export _con_nl
        .export _con_puts
        .export _con_nl
        .export _con_cls

        .code

_con_getc:
        sei
        lda con_r_idx
        cmp con_w_idx
        cli
        beq @no_data
        tax
        lda con_buf,x
        inc con_r_idx
        bra @exit
@no_data:
        lda #0
@exit:        
        ldx #0
        rts

_con_putc:
        jsr _acia_putc
        rts

_con_prompt:
        mac_con_print str_prompt
        rts

_con_nl:
        mac_con_print str_nl
        rts

_con_puts:
        sta ptr1
        stx ptr1 + 1
        ldy #0
@loop:
        lda (ptr1),y
        beq @return
        jsr _con_putc
        iny
        jmp @loop
@return:
        rts

_con_cls:
        mac_con_print str_cls
        rts

        .rodata
str_prompt:
        .asciiz "> "

str_nl: .byte $0a,$0d,$00
str_cls: .byte $1b,"[H",$1b,"[J"
