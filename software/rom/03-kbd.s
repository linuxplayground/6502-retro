.include "zeropage.inc"
.include "sysram.inc"
.include "acia.inc"
.include "conio.inc"
.include "kbd.inc"
.include "via.inc"
.include "wozmon.inc"
.include "xmodem.inc"

.import _init
.import __RAM_START__
.export _main

.macro print addr
        lda     #<addr
        ldx     #>addr
        jsr     _cputs
.endmacro

.code
_main:
        sei
        cld
        ldx     #$ff
        txs

        jsr     _acia_init
        jsr     _kbd_init
        stz     con_w_idx
        stz     con_r_idx
        cli
        
        print banner
        print help

loop:
        print prompt
        jsr     _cgetc
        jsr     _cputc
        cmp     #'x'
        beq     run_xmodem
        cmp     #'r'
        beq     run_prog
        cmp     #'w'
        beq     run_wozmon
        cmp     #'h'
        beq     run_help
        print error
        jmp     loop

run_xmodem:
        print nl
        sei
        jsr     _xmodem
        cli
        print nl
        jmp     loop
run_prog:
        print nl
        jsr     __RAM_START__
        print nl
        jmp     loop
run_wozmon:
        print nl
        jsr     _wozmon
        jmp     loop
run_help:
        print nl
        print help
        jmp     loop


nmi_handler:
        rti

irq_handler:
        pha
        phx
        phy
        cld
; @vdp_irq:
;         bit VDP_REG
;         bpl @kbd_irq
;         lda VDP_REG
;         sta vdp_status
;         lda #$80
;         sta vdp_sync
;         ; bra @exit_irq
@kbd_irq:
        bit     VIA_IFR
        bpl     @acia_irq
        jsr     _kbd_isr
@acia_irq:
        bit     ACIA_STATUS
        bpl     @exit_irq
        jsr     _acia_getc
        ldx     con_w_idx
        sta     con_buf,x
        inc     con_w_idx
@exit_irq:
        ply
        plx
        pla
        rti

.rodata
banner: .byte $0d, "6502-Retro", $0a, $0d, $0
help:   .byte "x-load", $0a, $0d
        .byte "r-run", $0a, $0d
        .byte "w-monitor", $0a, $0d
        .byte "h-help", $0a, $0d, $0
prompt: .byte $0a, $0d, "> ", $0
error:  .byte "error",$0a, $0d, $0
nl:     .byte $0a, $0d, $0

.segment "VECTORS"
        .word nmi_handler
        .word _init
        .word irq_handler
