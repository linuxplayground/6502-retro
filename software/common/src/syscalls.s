        .include "console.inc"
        .include "wozmon.inc"
        .include "sysram.inc"
        .include "utils.inc"

        ; console
        .export _syscall__con_in
        .export _syscall__con_out
        .export _syscall__con_print
        .export _syscall__con_nl
        .export _syscall__con_prompt
        ; wozmon
        .export _syscall__prbyte
        ; memory
        .export _system_con_buf
        .export _system_Rbuff
        .export _system_wozmon_buf
        ; utils
        .export _system__delay_ms
        .export _system__delay_sec

        .segment "SYSCALLS"
; console
_syscall__con_in:                       .word _con_in
_syscall__con_out:                      .word _con_out
_syscall__con_print:                    .word _con_print
_syscall__con_nl:                       .word _con_nl
_syscall__con_prompt:                   .word _con_prompt
; wozmon
_syscall__prbyte:                       .word _prbyte
; memory
_system_con_buf:                        .word con_buf
_system_Rbuff:                          .word Rbuff
_system_wozmon_buf:                     .word wozmon_buf
; utils
_system__delay_ms:                      .word _delay_ms
_system__delay_sec:                     .word _delay_sec