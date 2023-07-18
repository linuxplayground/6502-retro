; Example loadable that demonstrates how to interface with the F18A card and
; how to run a frambebuffered application.

        .include "zeropage.inc"
        .include "console.inc"
        .include "wozmon.inc"
        .include "console_macros.inc"
        .include "sysram.inc"
        .include "vdp.inc"
        .include "vdp_macros.inc"

start_char              = $F0
        .code

main:
        vdp_con_g1_mode
        mac_con_print greet
        jsr _con_nl
        lda     #$20
        sta     start_char
loop:
        jsr     clear_screen
        jsr     iniscreen
        jsr     _con_in ; get key
        bcc     :+
        cmp     #$1b    ; escape?
        beq     exit
:       inc     start_char
        lda     start_char
        cmp     #$80
        bne     :+
        lda     #$20
:       sta     start_char
        jsr     _vdp_wait
        jsr     _vdp_flush
        jmp     loop
exit:
        jsr     clear_screen
        jsr     _vdp_wait
        jsr     _vdp_flush
        vdp_con_text_mode
        rts

clear_screen:
        lda     #<screen
        sta     L
        lda     #>screen
        sta     H

        ldx     #4
        lda     #0
        ldy     #0
:       sta     (L),y
        iny
        bne     :-
        inc     H
        dex
        bne     :-
        rts

iniscreen:
        lda     #<screen
        sta     L
        lda     #>screen
        sta     H

        ldx     #4
        lda     start_char
        ldy     #0
:       sta     (L),y
        inc     a
        cmp     #$80
        bne     :+
        lda     #$20
:       iny
        bne     :--
        inc     H
        dex
        bne     :--
        rts


        .rodata
greet:          .asciiz "VDP Tick Counter - ESC to exit."
