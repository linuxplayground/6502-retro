; test program to see how to use the console with a framebuffer.
; thinking that the primary VDP console functions will be replaced with
; buffer functions.

        .include "vdp.inc"
        .include "vdp_macros.inc"
        .include "console.inc"
        .include "console_macros.inc"
        .include "zeropage.inc"
        .include "sysram.inc"
        .include "math.inc"

        .code

.macro fillmem dest, count, value
        lda     #<dest
        sta     STL
        lda     #>dest
        sta     STH
        lda     #<count
        sta     ut1_pl
        lda     #>count
        sta     ut1_ph
        lda     #value
        jsr     fill_mem
.endmacro

main:
        vdp_con_g1_mode
        fillmem screen, $0300, $20
        ldx     #16
        ldy     #12
        lda     #'#'
        jsr     char_at_xy_buff
        jsr     _vdp_wait
        jsr     _vdp_flush
:       jsr     _con_in
        bcc     :-
        cmp     #$1b
        bne     :-
        jsr     _vdp_wait
        jsr     _vdp_flush
        vdp_con_text_mode
        jsr     _vdp_clear_screen
        rts

; function to find the buffer memory location of X and Y
; works on 32x24 mode
; x, y and A
char_at_xy_buff:
        pha
        lda #<screen
        sta vdp_ptr
        lda #>screen
        sta vdp_ptr + 1
        ; applies to g1 and g2 mode
        tya
        div8
        clc
        adc     vdp_ptr + 1
        sta     vdp_ptr + 1
        tya
        and     #$07
        mul32
        sta     vdp_ptr
        txa
        ora     vdp_ptr
        sta     vdp_ptr
:       ldy     #0
        pla
        sta     (vdp_ptr),y
        rts

; function to fill a block of ram with a single value
; STL   = dest  (16 bit)
; ut1_pl= count (16 bit)
; X   = value to write
fill_mem:
        ldy     0
:       sta     (STL),y
        inc     STL
        bne     :+
        inc     STH
:       dec     ut1_pl
        bne     :--
        dec     ut1_ph
        bne     :--
        rts
