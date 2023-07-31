                .include "zeropage.inc"
                .zeropage

sp:             .res 2
sreg:           .res 2
regsave:        .res 4
ptr1:           .res 2
ptr2:           .res 2
ptr3:           .res 2
ptr4:           .res 2
tmp1:           .res 1
tmp2:           .res 1
tmp3:           .res 1
tmp4:           .res 1
regbank:        .res 6
tmpstack:       .res 1
; xmodem
crc:            .res 1
crch:           .res 1
ptr:            .res 1
ptrh:           .res 1
blkno:          .res 1
retry:          .res 1
retry2:         .res 1
bflag:          .res 1
XAML:           .res 1
XAMH:           .res 1
STL:            .res 1
STH:            .res 1
L:              .res 1
H:              .res 1
YSAV:           .res 1
MODE:           .res 1
MSGL:           .res 1
MSGH:           .res 1
; keyboard + console
con_r_idx:      .res 1
con_w_idx:      .res 1
kbd_flags:      .res 1
kbd_scankey:    .res 1
