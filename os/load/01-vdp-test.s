        .include "zeropage.inc"
        .include "sysram.inc"
        .include "vdp.inc"
        .include "console.inc"
        .include "vdp_macros.inc"

        .code

main:
        jsr     _vdp_init

        lda     #<banner
        sta     str_ptr
        lda     #>banner
        sta     str_ptr + 1
        jsr     vdp_print

        lda     #10
        sta     scry
        stz     scrx
        lda     #<prompt
        sta     str_ptr
        lda     #>prompt
        sta     str_ptr + 1
        jsr     vdp_print

        jsr     _vdp_wait
        jsr     _vdp_flush

key_input:
        jsr     _con_in
        bcc     key_input

fill:
        
        rts

vdp_print:
        ldy     #0
:
        lda     (str_ptr),y
        beq     :+
        jsr     _vdp_buf_out
        iny
        jmp     :-
:
        rts

banner:
        .byte "Test application showing how to write to"
        .byte "the VDP Buffer and have it sync to the",$0d
        .byte "display.",$0d
        .byte 0

prompt: .asciiz "Press any key to continue"