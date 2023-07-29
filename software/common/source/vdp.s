        .include "zeropage.inc"
        .include "sysram.inc"
        .include "math.inc"
        .include "vdp_macros.inc"

        .export VDP_RAM
        .export VDP_REG
        
        .export _vdp_init
        .export _vdp_set_write_address
        .export _vdp_set_read_address
        .export _vdp_xy_to_screen_buf_ptr
        .export _vdp_clear_screen_buf
        .export _vdp_buf_cursor
        .export _vdp_buf_out
        .export _vdp_wait
        .export _vdp_flush

        .import __TMS_START__
VDP_RAM = __TMS_START__ + 0
VDP_REG = __TMS_START__ + 1

VDP_SPRITE_PATTERN_TABLE    = 0
VDP_PATTERN_TABLE           = $800
VDP_SPRITE_ATTRIBUTE_TABLE  = $1000
VDP_NAME_TABLE              = $1400
VDP_COLOR_TABLE             = $2000

        .code
; PUBLIC FUNCTIONS
_vdp_init:
        jsr     vdp_clear_ram
        jsr     vdp_init_registers
        jsr     vdp_init_patterns
        jsr     _vdp_clear_screen_buf
        stz     scrx
        stz     scry
        stz     vdp_con_mode
        lda     #40
        sta     vdp_con_width
        rts

_vdp_set_write_address:
        sta     VDP_REG
        vdp_delay_fast
        txa
        ora     #$40
        sta     VDP_REG
        vdp_delay_fast
        rts

_vdp_set_read_address:
        sta     VDP_REG
        vdp_delay_fast
        txa
        sta     VDP_REG
        vdp_delay_fast
        rts

_vdp_clear_screen_buf:
        lda     #<screen
        sta     scr_ptr
        lda     #>screen
        sta     scr_ptr+1

        ldx     #4
        lda     #$20            ; fill with spaces not nulls.
        ldy     #0
:       sta     (scr_ptr),y
        iny
        bne     :-
        inc     scr_ptr+1
        dex
        bne     :-
        stz     scrx
        stz     scry
        rts

_vdp_xy_to_screen_buf_ptr:
        pha
        lda     #<screen
        sta     scr_ptr
        lda     #>screen
        sta     scr_ptr+1
        
        tya
        div8
        clc
        adc     scr_ptr+1
        sta     scr_ptr+1
        tya
        and      #$07
        mul32
        sta     scr_ptr
        lda     vdp_con_mode
        bne     @add_x
        tya
        mul8
        clc 
        adc     scr_ptr
        sta     scr_ptr
        lda     #0
        adc     scr_ptr+1
        sta     scr_ptr+1
@add_x:
        clc
        txa
        adc     scr_ptr
        sta     scr_ptr
        lda     #0
        adc     scr_ptr+1
        sta     scr_ptr+1
@return:
        pla
        rts

_vdp_wait:
        lda     vdp_sync
        cmp     #$80
        bne     _vdp_wait
        stz     vdp_sync
        rts

_vdp_flush:
        lda     #<screen
        sta     scr_ptr
        lda     #>screen
        sta     scr_ptr+1
        vdp_set_write_address VDP_NAME_TABLE
        ldx     #4
        ldy     #0
:       lda     (scr_ptr),y
        sta     VDP_RAM
        vdp_delay_fast
        inc     scr_ptr
        bne     :-
        inc     scr_ptr+1
        dex
        bne     :-
        rts

_vdp_buf_out:
        phx
        phy
        pha
        cmp     #$0d
        beq     @do_term_return
        cmp     #$08
        beq     @do_term_backspace
        bra     @out
@do_term_return:        
        jsr     buf_newline
        stz     scrx
        bra     @exit
@do_term_backspace:
        jsr     buf_backspace
        bra     @exit
@out:
        scrxy_to_scr_ptr
        sta     (scr_ptr)
        jsr     advance_buf_pos
@exit:
        pla
        ply
        plx
        rts

_vdp_buf_cursor:
        lda     vdp_sync
        cmp     #$80
        bne     :++
        stz     vdp_sync
        jsr     _vdp_wait
        jsr     _vdp_flush  
        inc     tick
        lda     tick
        cmp     #15
        beq     :+
        cmp     #30
        bmi     :++
        stz     tick
        scrxy_to_scr_ptr
        lda     #' '
        sta     (scr_ptr)
        rts
:
        scrxy_to_scr_ptr
        lda     #$01
        sta     (scr_ptr)
:
        rts

; PRIVATE FUNCTIONS
vdp_clear_ram:
        lda     #0
        sta     VDP_REG
        ora     #$40
        sta     VDP_REG
        lda     #$FF
        sta     vdp_ptr
        lda     #$3F
        sta     vdp_ptr + 1
@clr_1:
        lda     #$00
        sta     VDP_RAM
        vdp_delay_slow
        dec     vdp_ptr
        lda     vdp_ptr
        bne     @clr_1
        dec     vdp_ptr + 1
        lda     vdp_ptr + 1
        bne     @clr_1
        rts

; scroll screen buf up
buf_scroll_up:
        clc
        lda     #<screen
        sta     scr_ptr
        lda     #<screen + 40
        sta     vdp_ptr
        lda     #>screen
        sta     scr_ptr + 1
        sta     vdp_ptr + 1
        ldy     #24
@buf_scroll_up_loop_row:
        ldx     #39
@buf_scroll_up_loop_col:
        lda     (vdp_ptr)
        sta     (scr_ptr)
        clc
        lda     #1
        adc     scr_ptr
        sta     scr_ptr
        lda     #0
        adc     scr_ptr+1
        sta     scr_ptr+1
        lda     #1
        adc     vdp_ptr
        sta     vdp_ptr
        lda     #0
        adc     vdp_ptr+1
        sta     vdp_ptr+1
        dex
        bne     @buf_scroll_up_loop_col
        dey
        bne     @buf_scroll_up_loop_row
        ldy     #39
        lda     #$98
        sta     scr_ptr
        lda     #$0f
        sta     scr_ptr + 1
@buf_scroll_up_blank_row:
        lda     #0
        sta     (scr_ptr),y
        dey
        bpl     @buf_scroll_up_blank_row
        rts

buf_newline:
        lda     #' '
        scrxy_to_scr_ptr
        sta     (scr_ptr)
        stz     scrx
        inc     scry
        lda     scry
        cmp     #24
        bmi     :+
        jsr     buf_scroll_up
        lda     #23
        sta     scry
:
        rts

buf_backspace:
        pha
        lda     #' '
        scrxy_to_scr_ptr
        sta     (scr_ptr)
        lda     scrx
        beq     :+
        dec     scrx
        bra     :++
:       lda     vdp_con_width
        dec     a
        sta     scrx
        dec     scry
        bpl     :+
        stz     scry
        stz     scrx
:       lda     #$20
        scrxy_to_scr_ptr
        sta     (scr_ptr)
        pla
        rts

advance_buf_pos:
        inc     scrx
        sec
        lda     vdp_con_width
        sbc     scrx
        bcs     :+
        stz     scrx
        inc     scry
        lda     scry
        cmp     #24
        bmi     :+
        phy
        pha
        jsr     buf_scroll_up
        lda     #23
        sta     scry
        pla
        ply
:       
        rts

vdp_init_patterns:
        vdp_set_write_address VDP_PATTERN_TABLE

        lda     #<patterns
        sta     vdp_ptr
        lda     #>patterns
        sta     vdp_ptr + 1
        ldy     #0
:
        lda     (vdp_ptr),y
        sta     VDP_RAM
        lda     vdp_ptr
        clc
        adc     #1
        sta     vdp_ptr
        lda     #0
        adc     vdp_ptr + 1
        sta     vdp_ptr + 1
        cmp     #>end_patterns
        bne     :-
        lda     vdp_ptr
        cmp     #<end_patterns
        bne     :-
        rts

vdp_init_registers:
        ldx     #$00
:       
        lda     vdp_inits,x
        sta     VDP_REG
        vdp_delay_slow
        txa
        ora     #$80
        sta     VDP_REG
        vdp_delay_slow
        inx
        cpx     #8
        bne     :-
        rts


vdp_inits:
reg_0: .byte $00                ; r0
reg_1: .byte $F0                ; r1 16kb ram + M1, interrupts enabled, text mode
reg_2: .byte $05                ; r2 name table at 0x1400
reg_3: .byte $80                ; r3 color start 0x2000
reg_4: .byte $01                ; r4 pattern generator start at 0x800
reg_5: .byte $20                ; r5 Sprite attriutes start at 0x1000
reg_6: .byte $00                ; r6 Sprite pattern table at 0x0000
reg_7: .byte $E1                ; r7 Set forground and background color (grey on black)
vdp_inits_end:

patterns:
        .include "font.asm"
end_patterns: