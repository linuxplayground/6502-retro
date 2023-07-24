        .export con_buf
        .export Rbuff
        .export screen
        .export wozmon_buf
        .export vdp_status
        .export vdp_sync
        .export vdp_con_mode
        .export vdp_con_width
        .export scrx
        .export scry
        .export tick
        

        .segment "BSS"
con_buf:        .res $0100      ; console
Rbuff:          .res $0300      ; xmodem
screen:         .res $03C0      ; screen
wozmon_buf:     .res $000F      ; wozmon input buffer
vdp_status:     .res 1          ; vdp register value on interrupt
vdp_sync:       .res 1          ; vdp sync is triggered can poll this
vdp_con_mode:   .res 1          ; vdp graphics or text mode. textmode = 0
vdp_con_width:  .res 1          ; vdp console width, textmode = 40, graphics mode = 32
scrx:           .res 1          ; vdp x location on console
scry:           .res 1          ; vdp y location on console
tick:           .res 1          ; vdp ticks used to count frames - cursor