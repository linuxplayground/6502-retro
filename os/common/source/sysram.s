        .export con_buf
        .export Rbuff
        .export wozmon_buf
        

        .segment "BSS"
con_buf:        .res $0100      ; console
Rbuff:          .res $0300      ; xmodem
wozmon_buf:     .res $000F      ; wozmon input buffer
