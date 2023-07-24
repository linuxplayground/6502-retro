        .include "console.inc"
        .include "wozmon.inc"
        .include "vdp.inc"
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
        .export _syscall__vdp_init
        .export _syscall__vdp_set_write_address
        .export _syscall__vdp_set_read_address
        .export _syscall__vdp_xy_to_screen_buf_ptr
        .export _syscall__vdp_clear_screen_buf
        .export _syscall__vdp_buf_cursor
        .export _syscall__vdp_buf_out
        .export _syscall__vdp_wait
        .export _syscall__vdp_flush

        .segment "SYSCALLS"
; console
_syscall__con_in:                       .word _con_in
_syscall__con_out:                      .word _con_out
_syscall__con_print:                    .word _con_print
_syscall__con_nl:                       .word _con_nl
_syscall__con_prompt:                   .word _con_prompt
; wozmon
_syscall__prbyte:                       .word _prbyte
; vdp
_syscall__vdp_init:                     .word _vdp_init
_syscall__vdp_set_write_address:        .word _vdp_set_write_address
_syscall__vdp_set_read_address:         .word _vdp_set_read_address
_syscall__vdp_xy_to_screen_buf_ptr:     .word _vdp_xy_to_screen_buf_ptr
_syscall__vdp_clear_screen_buf:         .word _vdp_clear_screen_buf
_syscall__vdp_buf_cursor:               .word _vdp_buf_cursor
_syscall__vdp_buf_out:                  .word _vdp_buf_out
_syscall__vdp_wait:                     .word _vdp_wait
_syscall__vdp_flush:                    .word _vdp_flush