.macro vdp_delay_slow
        .repeat 8
                nop
        .endrepeat
.endmacro
.macro vdp_delay_fast
        .repeat 4
                nop
        .endrepeat
.endmacro
.macro vdp_set_write_address addr
        lda #<addr
        ldx #>addr
        jsr _vdp_set_write_address
.endmacro
.macro vdp_ptr_to_RAM_write_addr
        lda vdp_ptr
        ldx vdp_ptr + 1
        jsr _vdp_set_write_address
.endmacro
.macro scrxy_to_scr_ptr
        ldx scrx
        ldy scry
        jsr _vdp_xy_to_screen_buf_ptr
.endmacro
