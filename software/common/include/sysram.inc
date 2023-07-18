        .forceimport con_buf         ; console
        .forceimport Rbuff           ; xmodem
        .forceimport screen          ; display memory
        .forceimport wozmon_buf      ; wozmon input buffer
        ; .forceimport scrollbuf       ; vdp single line scroll buffer 900-920
        .forceimport vdp_x           ; vdp console x
        .forceimport vdp_y           ; vdp console y
        .forceimport linebuf         ; vdp scroll line buffer
        .forceimport scroll_read     ; vdp scroll read line num
        .forceimport scroll_write    ; vdp scroll write line num
        .forceimport vdp_reg_x       ; vdp temp storage for reg x
        .forceimport vdp_reg_y       ; vdp temp storage for reg y
        .forceimport vdp_status      ; vdp status reg