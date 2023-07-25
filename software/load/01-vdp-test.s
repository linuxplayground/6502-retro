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

        jsr     _vdp_clear_screen_buf
        jsr     _vdp_wait
        jsr     _vdp_flush

        ldx     #0
        ldy     #0
        jsr     _vdp_xy_to_screen_buf_ptr

        lda     #$20
        sta     start
loop1:
        lda     start
        sta     current
        lda     #$C0
        sta     count
        lda     #$04
        sta     count + 1
loop2:
        lda     current
        sta     (scr_ptr)

        inc     current
        lda     current
        cmp     #$80
        bne     :+
        lda     #$20
        sta     current
:
        inc     scr_ptr
        bne     :+
        inc     scr_ptr + 1
:
        dec     count
        bne     loop2
        dec     count + 1
        bne     loop2

        inc     start
        lda     start
        cmp     #$80
        bne     :+
        lda     #$20
        sta     start
:
        stz     vdp_sync
        jsr     _vdp_wait
        jsr     _vdp_flush

        ldx     #0
        ldy     #0
        jsr     _vdp_xy_to_screen_buf_ptr

        jsr     _con_in
        bcc     loop1

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

start:  .byte 0
current:.byte 0
count:  .word 0

banner:
        .byte "Test application showing how to write to"
        .byte "the VDP Buffer and have it sync to the",$0d
        .byte "display.",$0d
        .byte 0

prompt: .asciiz "Press any key to continue"