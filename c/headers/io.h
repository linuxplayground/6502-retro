#define ACIA 0x7F20
#define ACIA_DATA ACIA + 0x0
#define ACIA_STATUS    + 0x1
#define ACIA_COMMAND   + 0x2
#define ACIA_CONTROL   + 0x3

#define VIA 0x7F90
#define VIA_PORTB VIA + 0x0
#define VIA_PORTA VIA + 0x1
#define VIA_DDRB VIA  + 0x2
#define VIA_DDRA VIA  + 0x3
#define VIA_T1CL VIA  + 0x4
#define VIA_T1CH VIA  + 0x5
#define VIA_T1LL VIA  + 0x6
#define VIA_T1LH VIA  + 0x7
#define VIA_T2CL VIA  + 0x8
#define VIA_T2CH VIA  + 0x9
#define VIA_SR VIA    + 0xA
#define VIA_ACR VIA   + 0xB
#define VIA_PCR VIA   + 0xC
#define VIA_IFR VIA   + 0xD
#define VIA_IER VIA   + 0xE
