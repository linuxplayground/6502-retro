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
        .export _vdp_init
        .export _vdp_set_write_address
        .export _vdp_set_read_address
        .export _vdp_xy_to_screen_buf_ptr
        .export _vdp_clear_screen_buf
        .export _vdp_buf_cursor
        .export _vdp_buf_out
        .export _vdp_wait
        .export _vdp_flush

        .code

; console
_con_in:                        jmp (_syscall__con_in)
_con_out:                       jmp (_syscall__con_out)
_con_print:                     jmp (_syscall__con_print)
_con_prompt:                    jmp (_syscall__con_prompt)
_con_nl:                        jmp (_syscall__con_nl)
; wozmon
_prbyte:                        jmp (_syscall__prbyte)
; vdp
_vdp_init:                      jmp (_syscall__vdp_init)
_vdp_set_write_address:         jmp (_syscall__vdp_set_write_address)
_vdp_set_read_address:          jmp (_syscall__vdp_set_read_address)
_vdp_xy_to_screen_buf_ptr:      jmp (_syscall__vdp_xy_to_screen_buf_ptr)
_vdp_clear_screen_buf:          jmp (_syscall__vdp_clear_screen_buf)
_vdp_buf_cursor:                jmp (_syscall__vdp_buf_cursor)
_vdp_buf_out:                   jmp (_syscall__vdp_buf_out)
_vdp_wait:                      jmp (_syscall__vdp_wait)
_vdp_flush:                     jmp (_syscall__vdp_flush)
