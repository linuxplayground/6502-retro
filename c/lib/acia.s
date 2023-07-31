        .include "zeropage.inc"
        .import __ACIA_START__
        .import popax

        .export _acia_init
        .export _acia_putc
        .export _acia_puts
        .export _acia_getc
        .export _acia_gets

        .export acia_read_byte_nw

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

; void acia_init()
; Initialize the ACIA
_acia_init:
        lda #$00
        sta ACIA_STATUS
        lda #(ACIA_PARITY_DISABLE | ACIA_ECHO_DISABLE | ACIA_TX_INT_DISABLE_RTS_LOW | ACIA_RX_INT_DISABLE | ACIA_DTR_LOW)
        sta ACIA_COMMAND
        lda #$10
        sta ACIA_CONTROL
        rts

; void acia_put(char c)
; Send the character c to the serial terminal
; @in A (c) character to send
_acia_putc:
        pha                     ; save char
@wait_txd_empty:
        lda ACIA_STATUS
        and #$10
        beq @wait_txd_empty
        pla                     ; restore char
        sta ACIA_DATA
        rts

; void acia_puts(const char * s)
; send the zero terminated string pointed to by A/X
; @in A/X (s) pointer to the string to send
; @mod ptr1
_acia_puts:
        pha
        phy
        sta ptr1
        stx ptr1 + 1
        ldy #0
@next_char:
        lda (ptr1),y
        beq @eos
        jsr _acia_putc
        iny
        bne @next_char
@eos:
        ply
        pla
        rts

; char acia_getc()
; Wait until a character was received and return it
; @out A the received character
_acia_getc:
@wait_rxd_full:
        lda ACIA_STATUS
        and #$08
        beq @wait_rxd_full
        lda ACIA_DATA
        rts

acia_read_byte_nw:
        clc
        lda    ACIA_STATUS
        and    #$08
        beq    @done
        lda    ACIA_DATA
        sec
@done:
        rts

; void acia_gets(char * buffer, unsigned char n)
; Wait until a \n terminated string was received and store it at buffer
; n is the maximum number of characters to read
; The \n is removed and the string is zero terminated
; After receiving the maximum number of characters, any following characters are discarded
; The buffer must be of size maximum number of characters plus 1
; @in A (n) The buffer length minus one
; @in popax (buffer) A pointer to the buffer
_acia_gets:         sta tmp1
                    pha
                    phy
                    jsr popax
                    sta ptr1
                    stx ptr1 + 1
                    ldy #0
@next_char:         jsr _acia_getc
                    cmp #$0a
                    beq @eos
                    cmp #$0d
                    beq @eos
                    ; Check if end of buffer reached
                    cpy tmp1
                    beq @eos
                    sta (ptr1),y
                    iny
                    bne @next_char
@eos:               lda #0
                    sta (ptr1),y
                    ply
                    pla
                    rts
