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

        jsr     _vdp_wait
        jsr     _vdp_flush

key_input:
        jsr     _con_in
        bcc     key_input

        jsr     _vdp_clear_screen_buf

        lda     #20
        sta     scrx
        lda     #0
        sta     scry
        lda     #1
        sta     dirx
        lda     #1
        sta     diry

loop:
        jsr     _con_in
        bcs     exit

        lda     #$20
        scrxy_to_scr_ptr
        sta     (scr_ptr)

        clc
        lda     scrx
        adc     dirx
        sta     scrx
        cmp     #39
        bne     :+
        lda     #$FF
        sta     dirx
:       
        cmp     #0
        bne     :+
        lda     #1
        sta     dirx
:
        clc
        lda     scry
        adc     diry
        sta     scry
        cmp     #23
        bne     :+
        lda     #$FF
        sta     diry
:
        cmp     #0
        bne     :+
        lda     #1
        sta     diry
:
        scrxy_to_scr_ptr
        lda     #$7f
        sta     (scr_ptr)
flush:
        jsr     _vdp_wait
        jsr     _vdp_flush
        inc     tick
        lda     tick
        cmp     #$04
        bne     flush
        stz     tick
        jmp     loop

exit:
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

dirx:   .byte 0
diry:   .byte 0

banner:
        .byte "Press a key to start.", $0d
        .byte "Press ESC to quit", $0d
        .byte 0