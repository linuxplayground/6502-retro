.include "sysram.inc"
.include "acia.inc"
.include "zeropage.inc"

.export _cgetc
.export _cputc
.export _cputs
.export _cgetc_nw

.code
; C Compliant: returns a key in A.  Waits for a keypress.
; preserves Y
_cgetc:
        phx
:
        lda con_r_idx
        cmp con_w_idx
        beq :-
        tax
        lda con_buf,x
        inc con_r_idx
        sec
        plx
        rts

; C Compliant: writes A.  Passes to _acia or _vdp
_cputc:
        jmp     _acia_putc

; C Compliant: Writes string pointed to by XA to _acia or _vdp
_cputs:
        jmp     _acia_puts

; C Compliant, .C. is clear if no data, .A. is 0 if no data otherwise .C. is
; set and A is value.
_cgetc_nw:
        phx
        sei
        lda con_r_idx
        cmp con_w_idx
        cli
        beq @no_data
        tax
        lda con_buf,x
        inc con_r_idx
        sec
        plx
        rts
@no_data:
        clc
        lda #0
        plx
        rts