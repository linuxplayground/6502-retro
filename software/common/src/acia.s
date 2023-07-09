        .import __ACIA_START__
        .export ACIA_DATA
        .export ACIA_STATUS
        .export ACIA_COMMAND
        .export ACIA_CONTROL
        .export _acia_init
        .export _acia_read_byte
        .export _acia_read_byte_nw
        .export _acia_write_byte

ACIA_DATA    = __ACIA_START__ + $00
ACIA_STATUS  = __ACIA_START__ + $01
ACIA_COMMAND = __ACIA_START__ + $02
ACIA_CONTROL = __ACIA_START__ + $03

; ACIA command register bit values

ACIA_PARITY_ODD              = %00000000
ACIA_PARITY_EVEN             = %01000000
ACIA_PARITY_MARK             = %10000000
ACIA_PARITY_SPACE            = %11000000
ACIA_PARITY_DISABLE          = %00000000
ACIA_PARITY_ENABLE           = %00100000
ACIA_ECHO_DISABLE            = %00000000
ACIA_ECHO_ENABLE             = %00010000
ACIA_TX_INT_DISABLE_RTS_HIGH = %00000000
ACIA_TX_INT_ENABLE_RTS_LOW   = %00000100
ACIA_TX_INT_DISABLE_RTS_LOW  = %00001000
ACIA_TX_INT_DISABLE_BREAK    = %00001100
ACIA_RX_INT_ENABLE           = %00000000
ACIA_RX_INT_DISABLE          = %00000010
ACIA_DTR_HIGH                = %00000000
ACIA_DTR_LOW                 = %00000001

        .code
; initialise the ACIA
_acia_init:
        lda #$00
        sta ACIA_STATUS
        lda #(ACIA_PARITY_DISABLE | ACIA_ECHO_DISABLE | ACIA_TX_INT_DISABLE_RTS_LOW | ACIA_RX_INT_ENABLE | ACIA_DTR_LOW)
        sta ACIA_COMMAND
        ; lda #$1f        ; 19200
        lda #$10        ; 1/16th of clock (115200)
        sta ACIA_CONTROL
        rts

; Read a byte from the ACIA device - do not block.
; Carry is set if a byte was received.
; Carry clear if no byte received.
; Byte received in A
_acia_read_byte_nw:
        clc
        lda    ACIA_STATUS
        and    #$08
        beq    @done
        lda    ACIA_DATA
        sec
@done:
        rts

; Read a byte from the ACIA - block
; Byte received in A
_acia_read_byte:
@wait_rxd_full:
        lda ACIA_STATUS
        and #$08
        beq @wait_rxd_full
        lda ACIA_DATA
        rts

; Write a byte to the ACIA.  Note - this only works with the Rockwell type
; ACIA.  If using the WDC65C51 device, you will need to insert a short delay
; rather than polling the ACIA_STATUS register.
_acia_write_byte:
        pha                     ; save char
@wait_txd_empty:
        lda ACIA_STATUS
        and #$10
        beq @wait_txd_empty
        pla                     ; restore char
        sta ACIA_DATA
        rts
