; Snake game for the 6502-Retro!
; keybaord input arrow keys
; (c) David Latham = 2023

; ------------------------------------------------------------------------------
; TODO
; ------------------------------------------------------------------------------
; + Speed up snake every 5 apples eaten

; ------------------------------------------------------------------------------
; INCLUDES
; ------------------------------------------------------------------------------
        .include "zeropage.inc"
        .include "sysram.inc"
        .include "console.inc"
        .include "vdp.inc"
        .include "vdp_macros.inc"

        .import __TMS_START__
        .import __CODE_LOAD__
        .import __CODE_SIZE__

; ------------------------------------------------------------------------------
; DEFINES
; ------------------------------------------------------------------------------
LVDP_RAM                        = __TMS_START__ + 0
LVDP_REG                        = __TMS_START__ + 1

snake                           = $2000
                                        ; buffer at the end of the code.

vdp_patternTable                = $0000 ; vdp vram address table
vdp_nameTable                   = $3800
vdp_spriteAttributeTable        = $3b00
vdp_colorTable                  = $2000
vdp_spritePatternTable          = $1800

head_ptr                        = $E0   ; Zeropage addresses for pointers
tail_ptr                        = $E2   ;

head_up                         = $01   ; Ascii chars for snake head
head_dn                         = $02   ; see res/chunky.asm
head_lt                         = $03
head_rt                         = $04
apple                           = $05

default_speed                   = 6     ; game defaults
default_length                  = 2

; ------------------------------------------------------------------------------
; MACROS
; ------------------------------------------------------------------------------
; print a zero terminated string pointed to by `addr` at location px, py
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

.macro colourise_pattern pattern,colour
        ldx     #pattern
        lda     #colour
        jsr     vdp_set_pattern_colour
.endmacro
; ------------------------------------------------------------------------------
; CODE
; ------------------------------------------------------------------------------
        .code
main:
        jsr     _vdp_clear_screen_buf   ; empty framebuffer
        jsr     vdp_clear_ram           ; clear out all vram
        jsr     vdp_init_g2             ; switch to 32x24 graphics mode
        jsr     vdp_init_patterns       ; set up the font
        jsr     vdp_init_colours        ; set characater colours
        colourise_pattern apple,$21
        colourise_pattern head_up,$61
        colourise_pattern head_dn,$61
        colourise_pattern head_lt,$61
        colourise_pattern head_rt,$61
        

start_menu:
        printxy start_menu_1,3,5
        printxy start_menu_2,3,7
        printxy start_menu_3,3,9
        jsr     _vdp_wait               ; wait for vsync interrupt and flush
        jsr     vdp_flush
:
        jsr     _con_in                 ; wait for keypress
        inc     seed                    ; Time it takes to press creates the
        bcc     :-                      ; seed

new_game:
        jsr     _vdp_clear_screen_buf   ; clear screen

        ldx     #15                     ; position snake head in middle of
        stx     head_x                  ; of the screen
        ldy     #12
        sty     head_y
        jsr     _vdp_xy_to_screen_buf_ptr ; set up screen buffer pointer
        lda     #<snake                 ; set up snake body pointers
        sta     head_ptr                ; pointer to location in snake body
        sta     tail_ptr                ; holding the screen address of the head
        lda     #>snake                 ; and the tail of our snake
        sta     head_ptr + 1
        sta     tail_ptr + 1

        lda     #default_length         ; number of segments to grow on game
        sta     is_growing              ; start

        lda     #default_speed          ; set up initial game speed measured in
        sta     speed                   ; 60ths of a second

        lda     #1                      ; snake direction for auto update if
        sta     dir                     ; no player inputs detected
        lda     #head_rt                ; snake head character
        sta     head_char

        lda     #1                      ; bios function for calculating the
        sta     vdp_con_mode            ; the screen buffer address from x and y
        lda     #32                     ; needs to know the char width of the
        sta     vdp_con_width           ; display

        stz     tick                    ; reset tick counter
        stz     score                   ; and score
        stz     score+1

        jsr     new_apple               ; create a new apple


game_loop:                              ; game loop
do_tick:
        jsr     _vdp_wait               ; wait for vsync - 1/60th of a second
        inc     tick                    ; count ticks until ticks == speed
        lda     tick                    ; then update snake, check collisions
        sec                             ; and draw snake
        sbc     speed
        bcc     do_tick
        stz     tick
        jsr     _con_in                 ; get user input after frame refresh is
        bcc     update                  ; decided.  If no input, just update
process_key:
        cmp     #$1B                    ; ESCAPE Did the user quit
        bne     :+
        jmp     exit
:                                       ; process user input keys checking for
        cmp     #$A1                    ; LEFT -0    direction and updating the
        bne     :+                      ; dir variable for the update function
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
        ldx     head_x                  ; We don't know which direction the user
        ldy     head_y                  ; picked so set x and y to whatever was
                                        ; set before
        lda     dir                     ; process the direction and update x or
        bne     :+                      ; left?     y accordingly
        ldx     head_x                  ; then jump to check collision function
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
check_collision:                        ; The direction processing in update
        sta     head_char               ; selected an appropriate head_char -
                                        ; save it now.
        lda     head_y
        bpl     :+                      ; check for collisions with the screen
        jmp     exit                    ; edges.  if hit, it's game over.
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
        jsr     _vdp_xy_to_screen_buf_ptr ; calculate the screen address for x/y
        lda     (scr_ptr)               ; and check what's at that location
        cmp     #$20                    ; if a space, we can carry on playing
        beq     draw
        cmp     #apple                  ; if an apple, we need to eat the apple
        bne     :+
        jsr     eat_apple
        jmp     draw
:                                       ; if anything else then assume we hit
        jmp     exit                    ; an obsticle or our tail
draw:
        lda     scr_ptr                 ; save the current screen address
        ldy     #0                      ; pointer into the snake body buffer at
        sta     (head_ptr),y            ; the address pointed to by head_ptr
        lda     scr_ptr + 1
        ldy     #1
        sta     (head_ptr),y

        lda     head_char               ; write the current head_char to the
        sta     (scr_ptr)               ; screen at the address pointed to by
        jsr     advance_head_pointer    ; the screen pointer and advance the
                                        ; snake body buffer head pointer
        ldy     #0                      ; fetch the screen address stored in the
        lda     (tail_ptr),y            ; snake body buffer at the location
        sta     scr_ptr                 ; pointed to by tail_ptr and store it
        ldy     #1                      ; into the screen address pointer
        lda     (tail_ptr),y
        sta     scr_ptr + 1

        lda     #$20                    ; write a SPACE into the screen address
        sta     (scr_ptr)               ; of the tail of the snake
        lda     is_growing              ; check if we are growing
        bne     :+                      ; if so, then do not advance the tail
        jsr     advance_tail_pointer    ; pointer otherwise, advance it
        bra     :++
:
        dec     is_growing              ; we are growing so decrement the
:                                       ; growing counter
        stz     vdp_sync                ; Reset the vsync screen interrupt in
        jsr     _vdp_wait               ; case we have gone past the last one
        jsr     vdp_flush               ; wait for the next interrupt and flush
        stz     tick                    ; the screen buffer to the VDP ram
        jmp     game_loop               ; update the tick counter and loop
exit:
        printxy game_over_1,3,5         ; display a game over message and wait
        printxy game_over_2,3,7         ; for user input to decide to play again

        ldx     #10
        ldy     #7
        jsr     _vdp_xy_to_screen_buf_ptr

        lda     score + 1
        jsr     bcd_out_l
        lda     score
        jsr     bcd_out

        jsr     _vdp_wait               ; or exit altogether
        jsr     vdp_flush
:
        jsr     _con_in
        bcc     :-
        cmp     #$1b
        beq     :+
        cmp     #$20
        bne     :-
        jmp     new_game                ; play again
:
        jmp     _vdp_init               ; reset video dsiplay and return from
                                        ; there back to the OS Monitor

; ------------------------------------------------------------------------------
; GAME FUNCTIONS
; ------------------------------------------------------------------------------
new_apple:
@get_rand_x:
        jsr     prng                    ; collect an X and Y address using the
        and     #$1f                    ; psuedo random number function. Make
        clc                             ; sure it's within the boundary of the
        cmp     #30                     ; game and that it does not overlap
        bcs     @get_rand_x             ; the snake body
        cmp     #1
        bcc     @get_rand_x
        tax
@get_rand_y:
        jsr     prng
        and     #$17
        clc
        cmp     #22
        bcs     @get_rand_y
        cmp     #1
        bcc     @get_rand_y
        tay
        jsr     _vdp_xy_to_screen_buf_ptr
        lda     (scr_ptr)
        cmp     #$20
        bne     @get_rand_x
        lda     #apple
        sta     (scr_ptr)

        ldx     head_x                  ; as we used the screen pointer to
        ldy     head_y                  ; check if the apple location was free
        jsr     _vdp_xy_to_screen_buf_ptr ; we must reset it to the head X/Y
        rts

eat_apple:
        sed                             ; set decimal mode
        clc
        lda     #1
        adc     score
        sta     score
        bcc     :+
        lda     #0
        adc     score+1
        sta     score+1
:
        cld                             ; clear decimal mode
        lda     #2
        sta     is_growing
        jmp     new_apple               ; jump to new_apple and return from
                                        ; from there.

; Found this on the internet somewhere.
prng:
        lda     seed                    ; seed was calculated by counting until
        beq     @doEor                  ; the player started the game
        asl
        bcc     @noEor
@doEor:
        eor     #$1d
@noEor:
        sta     seed
        rts

; advance head pointer
advance_head_pointer:                   ; the total buffer we are allowing for
        inc     head_ptr                ; the snake body is actually quite big
        inc     head_ptr                ; it doesn't have to be this big, but
        lda     head_ptr                ; we are not using the ram for anything
        bne     :+                      ; else so I figured YOLO.
        inc     head_ptr+1
        lda     head_ptr+1
        cmp     #>snake + $20           ; check if high byte of the head pointer
        bne     :+                      ; is $20 more than the high byte of the
        lda     #>snake                 ; start of the buffer
        sta     head_ptr+1
:
        rts
; advance tail pointer
advance_tail_pointer:                   ; this is just the same as what we did
        inc     tail_ptr                ; for the head
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


; ------------------------------------------------------------------------------
; SYSTEM FUNCTIONS
; Many of these system functions appear to be duplicated in the ROM.  They
; are repeated here because the ROM versions are set up for the VDP in text mode
; while the snake game is running in Graphics 2 (not split thirds) mode.
; XXX - In future, the ROM functions should provide options for handling
; different graphics modes and then these functions do not need to be repeated
; in user applications
; ------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Print 1 byte BCD value
;------------------------------------------------------------------------------
bcd_out:
        pha
        .repeat 4
        lsr
        .endrepeat
        ora     #'0'
        sta     (scr_ptr)

        inc     scr_ptr
        bne     :+
        inc     scr_ptr+1
:
        pla
bcd_out_l:
        and     #$0f
        ora     #'0'
        sta     (scr_ptr)
        inc     scr_ptr
        bne     :+
        inc     scr_ptr+1
:
        rts

; set a specific pattern to a colour given by x and a
; x = pattern name and a = colour
vdp_set_pattern_colour:
        pha
        txa

        sta     vdp_ptr
        lda     #0
        sta     vdp_ptr+1
        
        asl     vdp_ptr
        rol     vdp_ptr+1
        asl     vdp_ptr
        rol     vdp_ptr+1
        asl     vdp_ptr
        rol     vdp_ptr+1
        
        clc
        lda     #<vdp_colorTable
        adc     vdp_ptr
        sta     vdp_ptr
        lda     #>vdp_colorTable
        adc     vdp_ptr+1
        sta     vdp_ptr+1

        lda     vdp_ptr
        ldx     vdp_ptr+1
        jsr     _vdp_set_write_address
        pla
        ldx     #8
:
        sta     LVDP_RAM
        dex
        bne     :-
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
        lda     #$e1
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
; This font is the same as the one used in NABU-GAMES.  It's a thick font that
; renders well on crappy NTSC graphics
; ------------------------------------------------------------------------------
patterns_start:
        .include "chunky.asm"
patterns_end:

; ------------------------------------------------------------------------------
; GAME VARIABLES
; ------------------------------------------------------------------------------
dir:            .byte 0         ; store current direction of snake
head_x:         .byte 0         ; X location of HEAD
head_y:         .byte 0         ; Y location of HEAD
speed:          .byte 0         ; current speed
is_growing:     .byte 0         ; set to increase length of snake
head_char:      .byte 0         ; current head character
score:          .word 0         ; 16bit score
seed:           .byte 0         ; random number generator seed

                ; The table below has high byte first just to
                ; make it easier to see the number progression.
hex2dec16_table:
        .byte    0, $0, $1,  0, $0, $2,  0, $0, $4,  0, $0, $8
    	.byte    0, $0,$16,  0, $0,$32,  0, $0,$64,  0, $1,$28
    	.byte    0, $2,$56,  0, $5,$12,  0,$10,$24,  0,$20,$48
    	.byte    0,$40,$96,  0,$81,$92,  1,$63,$84,  3,$27,$68