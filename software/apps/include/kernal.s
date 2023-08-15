.export _acia_init
.export _acia_getc
.export _acia_putc
.export _acia_getc_nw
.export _acia_puts
.export _cgetc
.export _cputc
.export _cputs
.export _cgetc_nw
.export _delay_ms
.export _wozmon
.export _prbyte
.export _vdp_init
.export _vdp_init_g2
.export _vdp_set_write_address
.export _vdp_set_read_address
.export _vdp_wait
.export _vdp_flush
.export _vdp_write_to_screen_xy
.export _vdp_read_from_screen_xy
.export _vdp_clear_screen_buf

.export vdp_write_to_screen_xy
.export vdp_read_from_screen_xy

.export _via_portb
.export _via_porta
.export _via_ddrb
.export _via_ddra

.import __VIA_START__
_via_portb = __VIA_START__ + $0
_via_porta = __VIA_START__ + $1
_via_ddrb  = __VIA_START__ + $2
_via_ddra  = __VIA_START__ + $3

.code
_acia_init:               jmp ($FF00)
_acia_getc:               jmp ($FF02)
_acia_putc:               jmp ($FF04)
_acia_getc_nw:            jmp ($FF06)
_acia_puts:               jmp ($FF08)
_cgetc:                   jmp ($FF0A)
_cputc:                   jmp ($FF0C)
_cputs:                   jmp ($FF0E)
_cgetc_nw:                jmp ($FF10)
_delay_ms:                jmp ($FF12)
_wozmon:                  jmp ($FF14)
_prbyte:                  jmp ($FF16)
_vdp_init:                jmp ($FF18)
_vdp_init_g2:             jmp ($FF1A)
_vdp_set_write_address:   jmp ($FF1C)
_vdp_set_read_address:    jmp ($FF1E)
_vdp_wait:                jmp ($FF20)
_vdp_flush:               jmp ($FF22)
_vdp_write_to_screen_xy:  jmp ($FF24)
_vdp_read_from_screen_xy: jmp ($FF26)
_vdp_clear_screen_buf:    jmp ($FF28)

vdp_write_to_screen_xy:   jmp ($FF2A)
vdp_read_from_screen_xy:  jmp ($FF2C)
