; snake game for the 6502-Retro!
; keybaord input arrow keys
; (c) David Latham = 2023

        .include "zeropage.inc"
        .include "sysram.inc"
        .include "console.inc"
        .include "vdp.inc"
        .include "vdp_macros.inc"

        .import __TMS_START__

; ------------------------------------------------------------------------------
; DEFINES
; ------------------------------------------------------------------------------
LVDP_RAM                        = __TMS_START__ + 0
LVDP_REG                        = __TMS_START__ + 1

snake                           = $2000

vdp_patternTable                = $0000
vdp_nameTable                   = $3800
vdp_spriteAttributeTable        = $3b00
vdp_colorTable                  = $2000
vdp_spritePatternTable          = $1800

default_speed                   = 4
default_length                  = 6

head_ptr                        = $E0   ; Zeropage addresses for pointers
tail_ptr                        = $E2   ;

head_up                         = $01   ; Ascii chars for snake head
head_dn                         = $02   ; see res/chunky.asm
head_lt                         = $03
head_rt                         = $04

; ------------------------------------------------------------------------------
; MACROS
; ------------------------------------------------------------------------------
.macro printxy  addr,px,py
        lda     #<addr
        sta     str_ptr
        lda     #>addr
        sta     str_ptr+1
        ldx     #px
        ldy     #py
        jsr     _vdp_xy_to_screen_buf_ptr
        jsr     vdp_print
.endmacro

; ------------------------------------------------------------------------------
; CODE
; ------------------------------------------------------------------------------
        .code
main:
        jsr     _vdp_clear_screen_buf   ; empty framebuffer
        jsr     vdp_clear_ram
        jsr     vdp_init_g2             ; switch to 32x24 graphics mode
        jsr     vdp_init_patterns       ; set up the font
        jsr     vdp_init_colours        ; set characater colours


start_menu:
        printxy start_menu_1,3,5
        printxy start_menu_2,3,7
        printxy start_menu_3,3,9
        jsr     _vdp_wait
        jsr     vdp_flush
:
        jsr     _con_in
        bcc     :-
new_game:
        jsr     _vdp_clear_screen_buf
        
        ldx     #15
        stx     head_x
        ldy     #12
        sty     head_y
        jsr     _vdp_xy_to_screen_buf_ptr
        lda     #<snake
        sta     head_ptr
        sta     tail_ptr
        lda     #>snake
        sta     head_ptr + 1
        sta     tail_ptr + 1

        lda     #default_length
        sta     is_growing

        lda     #default_speed
        sta     speed

        lda     #1
        sta     dir
        lda     #head_rt
        sta     head_char

        lda     #1
        sta     vdp_con_mode
        lda     #32
        sta     vdp_con_width
game_loop:
do_tick:
        jsr     _vdp_wait
        inc     tick
        lda     tick
        sec
        sbc     speed
        bcc     do_tick
        stz     tick
        jsr     _con_in
        bcc     update
process_key:
        cmp     #$1B                    ; ESCAPE
        bne     :+
        jmp     exit
:
        cmp     #$A1                    ; LEFT -0
        bne     :+
        lda     dir
        cmp     #1
        beq     update
        lda     #0
        sta     dir
        jmp     update
:
        cmp     #$A2                    ; RIGHT -1
        bne     :+
        lda     dir
        cmp     #0
        beq     update
        lda     #1
        sta     dir
        jmp     update
:
        cmp     #$A3                    ; UP -2
        bne     :+
        lda     dir
        cmp     #3
        beq     update
        lda     #2
        sta     dir
        jmp     update
:
        cmp     #$A4                    ; DOWN -3
        bne     update
        lda     dir
        cmp     #2
        beq     update
        lda     #3
        sta     dir
        ; fall through
update:
        ldx     head_x
        ldy     head_y

        lda     dir
        bne     :+                      ; left?
        ldx     head_x
        dex
        stx     head_x
        lda     #head_lt
        jmp     check_collision
:
        cmp     #1
        bne     :+                      ; right?
        ldx     head_x
        inx
        stx     head_x
        lda     #head_rt
        jmp     check_collision
:
        cmp     #2
        bne     :+                      ; up?
        ldy     head_y
        dey
        sty     head_y
        lda     #head_up
        jmp     check_collision
:
        cmp     #3
        bne     :+                      ; down?
        ldy     head_y
        iny
        sty     head_y
        lda     #head_dn
        ; fall through
check_collision:
        sta     head_char               ; save the head character
        ; check for border collision
        lda     head_y
        bpl     :+
        jmp     exit
:
        cmp     #24
        bmi     :+
        jmp     exit
:
        lda     head_x
        bpl     :+
        jmp     exit
:
        cmp     #32
        bmi     :+
        jmp     exit
:
        jsr     _vdp_xy_to_screen_buf_ptr
        lda     (scr_ptr)
        cmp     #$20
        beq     draw
        cmp     #$90                    ; is it an apple
        bne     :+
        jsr     eat_apple
:       jmp     exit                    ; Hit tail
draw:
        lda     scr_ptr
        ldy     #0
        sta     (head_ptr),y
        lda     scr_ptr + 1
        ldy     #1
        sta     (head_ptr),y

        lda     head_char
        sta     (scr_ptr)
        jsr     advance_head_pointer

        ldy     #0
        lda     (tail_ptr),y
        sta     scr_ptr
        ldy     #1
        lda     (tail_ptr),y
        sta     scr_ptr + 1

        lda     #$20
        sta     (scr_ptr)
        lda     is_growing
        bne     :+
        jsr     advance_tail_pointer
        bra     :++
:
        dec     is_growing
:
        stz     vdp_sync
        jsr     _vdp_wait
        jsr     vdp_flush
        stz     tick
        jmp     do_tick
exit:
        printxy game_over_1,3,5
        printxy game_over_2,3,7
        jsr     _vdp_wait
        jsr     vdp_flush
:
        jsr     _con_in
        bcc     :-
        cmp     #$1b
        beq     :+
        cmp     #$20
        bne     :-
        jmp     new_game
:
        jmp     _vdp_init

new_apple:
        rts

eat_apple:
        rts

; ------------------------------------------------------------------------------
; FUNCTIONS
; ------------------------------------------------------------------------------
; advance head pointer
advance_head_pointer:
        inc     head_ptr
        inc     head_ptr
        lda     head_ptr
        bne     :+
        inc     head_ptr+1
        lda     head_ptr+1
        cmp     #>snake + $20
        bne     :+
        lda     #>snake
        sta     head_ptr+1
:
        rts
; advance tail pointer
advance_tail_pointer:
        inc     tail_ptr
        inc     tail_ptr
        lda     tail_ptr
        bne     :+
        inc     tail_ptr+1
        lda     tail_ptr+1
        cmp     #>snake + $20
        bne     :+
        lda     #>snake
        sta     tail_ptr+1
:
        rts

; print text pointed to by str_ptr to screen at scr_ptr
vdp_print:
        ldy     #0
:
        lda     (str_ptr),y
        beq     :+
        sta     (scr_ptr),y
        iny
        jmp     :-
:
        rts

; copy screen buffer to vdp ram
vdp_flush:
        lda     #<screen
        sta     scr_ptr
        lda     #>screen
        sta     scr_ptr+1
        vdp_set_write_address vdp_nameTable
        ldx     #4
        ldy     #0
:       lda     (scr_ptr),y
        sta     LVDP_RAM
        vdp_delay_fast
        inc     scr_ptr
        bne     :-
        inc     scr_ptr+1
        dex
        bne     :-
        rts

; setup colours - maps a character to a specific colour.
vdp_init_colours:
        ; first set up all colours the same
        vdp_set_write_address vdp_colorTable
        ldx     #$09
        ldy     #$00
        jsr     _vdp_wait               ; wait to do this during vblank period
:
        lda     #$21
        sta     LVDP_RAM
        vdp_delay_fast
        iny
        bne     :-
        dex
        bne     :-
        rts

; load the font
vdp_init_patterns:
        vdp_set_write_address vdp_patternTable

        lda     #<patterns_start
        sta     vdp_ptr
        lda     #>patterns_start
        sta     vdp_ptr + 1
        jsr     _vdp_wait               ; wait to do this during vblank period
:
        lda     (vdp_ptr)
        sta     LVDP_RAM
        vdp_delay_fast
        lda     vdp_ptr
        clc
        adc     #1
        sta     vdp_ptr
        lda     #0
        adc     vdp_ptr + 1
        sta     vdp_ptr + 1
        cmp     #>patterns_end
        bne     :-
        lda     vdp_ptr
        cmp     #<patterns_end
        bne     :-
        rts

; clear out all vdp ram
vdp_clear_ram:
        lda     #0
        sta     LVDP_REG
        ora     #$40
        sta     LVDP_REG
        lda     #$FF
        sta     vdp_ptr
        lda     #$3F
        sta     vdp_ptr + 1
        jsr     _vdp_wait               ; wait to do this during vblank period
:
        lda     #$00
        sta     LVDP_RAM
        vdp_delay_fast
        dec     vdp_ptr
        lda     vdp_ptr
        bne     :-
        dec     vdp_ptr + 1
        lda     vdp_ptr + 1
        bne     :-
        rts

; set up graphics mode 2 for the game
vdp_init_g2:
        ldx     #$00
:
        lda     g2_registers_start,x
        sta     LVDP_REG
        vdp_delay_slow
        txa
        ora     #$80
        sta     LVDP_REG
        vdp_delay_slow
        inx
        cpx     #8
        bne     :-
        rts

; ------------------------------------------------------------------------------
; GAME DATA
; ------------------------------------------------------------------------------

g2_registers_start:
reg_0:  .byte $02        ; Graphics II Mode,No External Video
reg_1:  .byte $e0        ; 16K,Enable Disp.,Enable int., 8x8 Sprites,Mag.Off
reg_2:  .byte $0e        ; Address of Name Table in VRAM = Hex 3800
reg_3:  .byte $9f        ; Color Table Address = Hex 2000 to Hex 280
reg_4:  .byte $00        ; Pattern Table Address = Hex 0000 to Hex 0800
reg_5:  .byte $76        ; Address of Sprite Attribute Table in VRAM = Hex 3BOO
reg_6:  .byte $03        ; Address of Sprite Pattern Table in VRAM = 1800
reg_7:  .byte $2b        ; white on black
g2_registers_end:

start_menu_1:   .asciiz "SNAKE - V1.0"
start_menu_2:   .asciiz "BY - PRODUCTIONDAVE"
start_menu_3:   .asciiz "PRESS ANY KEY TO PLAY"

game_over_1:    .asciiz "GAME OVER"
game_over_2:    .asciiz "SCORE:"

; ------------------------------------------------------------------------------
; GAME FONT
; ------------------------------------------------------------------------------
patterns_start:
        .include "chunky.asm"
patterns_end:

; ------------------------------------------------------------------------------
; GAME VARIABLES
; ------------------------------------------------------------------------------
dir:            .byte 0         ; start game going right
head_x:         .byte 0
head_y:         .byte 0
speed:          .byte 0
is_growing:     .byte 0
head_char:      .byte 0
score:          .word 0
high_score:     .word 0
