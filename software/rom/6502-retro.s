        .include "zeropage.inc"
        .include "sysram.inc"
        .include "syscalls.inc"
        .include "console.inc"
        .include "console_macros.inc"
        .include "ehbasic.inc"
        .include "acia.inc"
        .include "kbd.inc"
        .include "via.inc"
        .include "vdp.inc"
        .include "xmodem.inc"
        .include "wozmon.inc"

        .export menu

        .code
cold_boot:
        sei
        cld
        ldx #$ff
        txs

        jsr _con_init
        jsr _acia_init
        jsr _kbd_init
        jsr _vdp_init
        cli
menu:
        mac_con_print str_help
prompt:
        jsr _con_prompt
wait_for_input:
        jsr _con_in
        bcc wait_for_input
inkey:
        cmp #'x'
        beq run_xmodem
        cmp #'m'
        beq run_wozmon
        cmp #'r'
        beq run_program
        cmp #'h'
        beq run_help
        cmp #'b'
        beq run_basic
        cmp #'w'
        beq run_warm_boot
        cmp #$0a                        ; CR
        beq new_line
        jsr _con_out
        jmp prompt
        jmp wait_for_input

run_warm_boot:
        jmp cold_boot

run_xmodem:
        jsr _con_nl
        sei                             ; disable interrupts so xmodem can own the acia.
        jsr _xmodem
        cli
        jmp menu
run_basic:
        jmp BASIC_init
run_help:
        jsr _con_nl
        mac_con_print str_help
        jsr _con_prompt
        jmp wait_for_input

run_wozmon:
        jsr _con_nl
        jsr _wozmon
        jmp menu

run_program:
        jsr _con_nl
        jsr $1000
        jmp menu

new_line:
        jsr _con_nl
        jmp prompt

nmi:
        rti

irq:
        pha
        phx
        phy
        cld
@vdp_irq:
        bit VDP_REG
        bpl @kbd_irq
        lda VDP_REG
        sta vdp_status
        lda #$80
        sta vdp_sync
        ; bra @exit_irq
@kbd_irq:
        bit VIA_IFR
        bpl @acia_irq
        jsr _kbd_isr
        ; bra @exit_irq
@acia_irq:
        bit ACIA_STATUS
        bpl @exit_irq
        jsr _acia_read_byte
        ldx con_w_idx
        sta con_buf,x
        inc con_w_idx
@exit_irq:
        ply
        plx
        pla

        rti

        .segment "VECTORS"

        .word nmi
        .word cold_boot
        .word irq

        .rodata
str_help:
load_message: .byte "6502-Retro!", $0a, $0d
              .byte $0a, $0d
              .byte "Press 'w' to warm boot ...", $0a, $0d
              .byte "Press 'x' to start xmodem receive ...", $0a, $0d
              .byte "Press 'r' to run your program ...", $0a, $0d
              .byte "Press 'b' to run basic ...", $0a, $0d
              .byte "Press 'm' to start Wozmon ...", $0a, $0d, $00
