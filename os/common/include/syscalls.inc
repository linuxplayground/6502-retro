        ; console
        .forceimport _syscall__con_in
        .forceimport _syscall__con_out
        .forceimport _syscall__con_print
        .forceimport _syscall__con_prompt
        .forceimport _syscall__con_nl
        ; wozmon
        .forceimport _syscall__prbyte
        ; vdp
        .forceimport _syscall__vdp_init                     
        .forceimport _syscall__vdp_set_write_address        
        .forceimport _syscall__vdp_set_read_address         
        .forceimport _syscall__vdp_xy_to_screen_buf_ptr     
        .forceimport _syscall__vdp_clear_screen_buf         
        .forceimport _syscall__vdp_buf_cursor               
        .forceimport _syscall__vdp_buf_out                  
        .forceimport _syscall__vdp_wait                     
        .forceimport _syscall__vdp_flush                    