; building on the wozmon rom from before, this version now includes XModem
; as well as a simple menu for selecting either xmodem or wozmon.

    .include "acia.inc"
    .include "console.inc"
    .include "console_macros.inc"
    .include "sysram.inc"
    .include "wozmon.inc"
    .include "xmodem.inc"
    .include "zeropage.inc"

    .code 
cold_boot:
    ldx #$ff
    txs

    jsr _acia_init
    mac_con_print welcome_message
    jsr _con_nl
loop:
    mac_con_print menu_message
    jsr _con_nl
wait:
    jsr _con_in
    bcc wait
    cmp #'w'
    beq @do_wozmon
    cmp #'x'
    beq @do_xmodem
    cmp #'r'
    beq @do_run
    jsr _con_nl
    mac_con_print err_message
    jsr _con_nl
    jmp loop
@do_wozmon:
    jsr _wozmon
    jmp cold_boot
@do_xmodem:
    sei                             ; disable interrupts so xmodem can own the acia.
    jsr _xmodem
    cli
    jmp cold_boot
@do_run:
    jsr $1000
    jmp cold_boot

welcome_message: .asciiz "Welcome to the 6502-Retro!"
menu_message: .asciiz "[r]un, [w]ozmon, [x]modem"
err_message:  .asciiz "ERROR>"

nmi:
        rti
irq:
        pha
        phx
        phy
        bit ACIA_STATUS
        bpl @user_irq
        jsr _acia_read_byte
        ldx con_w_idx
        sta con_buf,x
        inc con_w_idx
        bra @exit_irq
@user_irq:
        lda $00
        bne @jump_to_user_irq
        lda $01
        beq @exit_irq
@jump_to_user_irq:
        jmp ($00)
@exit_irq:
        ply
        plx
        pla

        rti

    .segment "VECTORS"

    .word nmi
    .word cold_boot
    .word irq