.import __VIA_START__

.export VIA_PORTB
.export VIA_PORTA
.export VIA_DDRB
.export VIA_DDRA
.export VIA_T1CL
.export VIA_T1CH
.export VIA_T1LL
.export VIA_T1LH
.export VIA_T2CL
.export VIA_T2CH
.export VIA_SR
.export VIA_ACR
.export VIA_PCR
.export VIA_IFR
.export VIA_IER
.export VIA_PANH

VIA_PORTB = __VIA_START__ + $0
VIA_PORTA = __VIA_START__ + $1
VIA_DDRB  = __VIA_START__ + $2
VIA_DDRA  = __VIA_START__ + $3
VIA_T1CL  = __VIA_START__ + $4
VIA_T1CH  = __VIA_START__ + $5
VIA_T1LL  = __VIA_START__ + $6
VIA_T1LH  = __VIA_START__ + $7
VIA_T2CL  = __VIA_START__ + $8
VIA_T2CH  = __VIA_START__ + $9
VIA_SR    = __VIA_START__ + $a
VIA_ACR   = __VIA_START__ + $b
VIA_PCR   = __VIA_START__ + $c
VIA_IFR   = __VIA_START__ + $d
VIA_IER   = __VIA_START__ + $e
VIA_PANH  = __VIA_START__ + $f
