.include "sysram.inc"
.segment "SYSRAM"
con_buf:        .res $0100
Rbuff:          .res $0300
_screen_buf:    .res $0400      ; only max 03c0 is actually used in text mode
wozmon_buf:     .res $000F
_vdp_status:    .res 1
_vdp_sync:      .res 1
_vdp_con_mode:  .res 1
_vdp_con_width: .res 1
scrx:           .res 1
scry:           .res 1
tick:           .res 1
