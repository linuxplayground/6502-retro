        .include "console.inc"
        .include "wozmon.inc"
        .include "vdp.inc"
        .include "audiolib.inc"
        .include "sysram.inc"

        ; console
        .export _syscall__con_in
        .export _syscall__con_out
        .export _syscall__con_print
        .export _syscall__con_nl
        .export _syscall__con_prompt
        ; wozmon
        .export _syscall__prbyte
        ; vdp
        .export _syscall__vdp_reset
        .export _syscall__vdp_home
        .export _syscall__vdp_clear_screen
        .export _syscall__vdp_get
        .export _syscall__vdp_put
        .export _syscall__vdp_set_write_address
        .export _syscall__vdp_set_read_address
        .export _syscall__vdp_xy_to_ptr
        .export _syscall__vdp_increment_pos_console
        .export _syscall__vdp_decrement_pos_console
        .export _syscall__vdp_console_out
        .export _syscall__vdp_console_newline
        .export _syscall__vdp_console_backspace
        .export _syscall__vdp_write_reg
        .export _syscall__vdp_disable_interrupts
        .export _syscall__vdp_enable_interrupts
        .export _syscall__vdp_flush
        .export _syscall__vdp_wait
        ;audio
        .export _syscall__psg_init
        .export _syscall__play_vgm_data

        .segment "SYSCALLS"
; console
_syscall__con_in:                       .word _con_in
_syscall__con_out:                      .word _con_out
_syscall__con_print:                    .word _con_print
_syscall__con_nl:                       .word _con_nl
_syscall__con_prompt:                   .word _con_prompt
;wozmon
_syscall__prbyte:                       .word _prbyte
;vdp
_syscall__vdp_reset:                    .word _vdp_reset
_syscall__vdp_home:                     .word _vdp_home
_syscall__vdp_clear_screen:             .word _vdp_clear_screen
_syscall__vdp_get:                      .word _vdp_get
_syscall__vdp_put:                      .word _vdp_put
_syscall__vdp_set_write_address:        .word _vdp_set_write_address
_syscall__vdp_set_read_address:         .word _vdp_set_read_address
_syscall__vdp_xy_to_ptr:                .word _vdp_xy_to_ptr
_syscall__vdp_increment_pos_console:    .word _vdp_increment_pos_console
_syscall__vdp_decrement_pos_console:    .word _vdp_decrement_pos_console
_syscall__vdp_console_out:              .word _vdp_console_out
_syscall__vdp_console_newline:          .word _vdp_console_newline
_syscall__vdp_console_backspace:        .word _vdp_console_backspace
_syscall__vdp_write_reg:                .word _vdp_write_reg
_syscall__vdp_enable_interrupts:        .word _vdp_enable_interrupts
_syscall__vdp_disable_interrupts:       .word _vdp_disable_interrupts
_syscall__vdp_flush:                    .word _vdp_flush
_syscall__vdp_wait:                     .word _vdp_wait
;audio
_syscall__psg_init:                     .word _psg_init
_syscall__play_vgm_data:                .word _play_vgm_data

