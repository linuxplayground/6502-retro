        .include "syscalls.inc"

        ; console
        .export _con_in
        .export _con_out
        .export _con_print
        .export _con_prompt
        .export _con_nl
        ; wozmon
        .export _prbyte
        ; vdp
        .export _vdp_reset
        .export _vdp_home
        .export _vdp_clear_screen
        .export _vdp_get
        .export _vdp_put
        .export _vdp_set_write_address
        .export _vdp_set_read_address
        .export _vdp_xy_to_ptr
        .export _vdp_increment_pos_console
        .export _vdp_decrement_pos_console
        .export _vdp_console_out
        .export _vdp_console_newline
        .export _vdp_console_backspace
        .export _vdp_write_reg
        .export _vdp_disable_interrupts
        .export _vdp_enable_interrupts
        .export _vdp_flush
        .export _vdp_wait
        ;audio
        .export _psg_init
        .export _play_vgm_data

        .code

; console
_con_in:                        jmp (_syscall__con_in)
_con_out:                       jmp (_syscall__con_out)
_con_print:                     jmp (_syscall__con_print)
_con_prompt:                    jmp (_syscall__con_prompt)
_con_nl:                        jmp (_syscall__con_nl)
;wozmon
_prbyte:                        jmp (_syscall__prbyte)
;vdp
_vdp_reset:                     jmp (_syscall__vdp_reset)
_vdp_home:                      jmp (_syscall__vdp_home)
_vdp_clear_screen:              jmp (_syscall__vdp_clear_screen)
_vdp_get:                       jmp (_syscall__vdp_get)
_vdp_put:                       jmp (_syscall__vdp_put)
_vdp_set_write_address:         jmp (_syscall__vdp_set_write_address)
_vdp_set_read_address:          jmp (_syscall__vdp_set_read_address)
_vdp_xy_to_ptr:                 jmp (_syscall__vdp_xy_to_ptr)
_vdp_increment_pos_console:     jmp (_syscall__vdp_increment_pos_console)
_vdp_decrement_pos_console:     jmp (_syscall__vdp_decrement_pos_console)
_vdp_console_out:               jmp (_syscall__vdp_console_out)
_vdp_console_newline:           jmp (_syscall__vdp_console_newline)
_vdp_console_backspace:         jmp (_syscall__vdp_console_backspace)
_vdp_write_reg:                 jmp (_syscall__vdp_write_reg)
_vdp_disable_interrupts:        jmp (_syscall__vdp_disable_interrupts)
_vdp_enable_interrupts:         jmp (_syscall__vdp_enable_interrupts)
_vdp_flush:                     jmp (_syscall__vdp_flush)
_vdp_wait:                      jmp (_syscall__vdp_wait)
;audio
_psg_init:                      jmp (_syscall__psg_init)
_play_vgm_data:                 jmp (_syscall__play_vgm_data)
