.include "zeropage.inc"
.include "sysram.inc"
.include "acia.inc"
.include "conio.inc"
.include "ehbasic.inc"
.include "kbd.inc"
.include "vdp.inc"
.include "via.inc"
.include "wozmon.inc"
.include "xmodem.inc"

.import _init
.import __RAM_START__
.import __TMS_START__
.export _main

VDP_REG = __TMS_START__ + 1
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
        jsr     _vdp_init
        
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
        cmp     #'m'
        beq     run_wozmon
        cmp     #'b'
        beq     run_basic
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
run_basic:
        print nl
        jmp     BASIC_init
run_help:
        print nl
        print banner
        print help
        jmp     loop



nmi_handler:
        rti

irq_handler:
        pha
        phx
        phy
        cld
@vdp_irq:
        bit     VDP_REG
        bpl     @kbd_irq
        lda     VDP_REG
        sta     _vdp_status
        lda     #$80
        sta     _vdp_sync
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
banner: .byte $0a,$0d
        .byte "+========================+",$0a, $0d
        .byte "|       6502-Retro       |",$0a, $0d
        .byte "+========================+",$0a, $0d
        .byte $00

help:   .byte "| x-load                 |", $0a, $0d
        .byte "| r-run                  |", $0a, $0d
        .byte "| m-monitor              |", $0a, $0d
        .byte "| b-basic                |", $0a, $0d
        .byte "| h-help                 |", $0a, $0d
        .byte "+========================+", $0a, $0d
        .byte $00

prompt: .byte $0a, $0d, ">  ", $0
error:  .byte $0a, $0d, " \\", $0a, $0d, $0
nl:     .byte $0a, $0d, $0

.segment "VECTORS"
        .word nmi_handler
        .word _init
        .word irq_handler
