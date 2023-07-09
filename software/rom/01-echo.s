; simple rom file to demonstrate working ACIA, RAM and ROM.
; When the reset button is pressed, a welcome message will appear.
; every keystroke entered will be echoed back to you.

    .include "acia.inc"
    .include "console.inc"
    .include "console_macros.inc"
    .include "sysram.inc"
    .include "zeropage.inc"

    .code 
cold_boot:
    ldx #$ff
    txs

    jsr _acia_init

    mac_con_print acia_message
    jsr _con_nl

; just echo stuff.
loop:
    jsr _con_in
    bcc loop
    jsr _con_out
    jmp loop

acia_message: .asciiz "Welcome to the 6502-Retro!"


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