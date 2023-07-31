.macro mac_con_print addr
        lda #<addr
        ldx #>addr
        jsr _con_puts
.endmacro