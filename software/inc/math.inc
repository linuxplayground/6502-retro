.macro div8
    .repeat 3
        lsr
    .endrepeat
.endmacro
.macro mul8
    .repeat 3
        asl
    .endrepeat
.endmacro
.macro mul32
    .repeat 5
        asl
    .endrepeat
.endmacro