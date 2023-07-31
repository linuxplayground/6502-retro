        .include "kbd.inc"
        .include "via.inc"
        .include "acia.inc"
        .include "zeropage.inc"
        .include "sysram.inc"

        .export _nmi_handler
        .export _irq_handler
        .export _irq_init

        .code

_irq_init:
        jsr     _kbd_init
        stz     con_r_idx
        stz     con_w_idx
        rts

_nmi_handler:
        rti
        
_irq_handler:
        pha
        phx
        phy
@kbd_irq:
        bit VIA_IFR
        bpl @acia_irq
        jsr _kbd_isr
        ; bra @exit_irq
@acia_irq:
        bit ACIA_STATUS
        bpl @exit_irq
        jsr _acia_getc
        ldx con_w_idx
        sta con_buf,x
        inc con_w_idx
@exit_irq:
        ply
        plx
        pla
        rti