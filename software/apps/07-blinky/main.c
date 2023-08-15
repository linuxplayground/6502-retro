#include "conio.h"
#include "vdp.h"

unsigned char original_ddrb;
unsigned char original_port;
unsigned char c, d, r;
extern unsigned char via_ddrb;
extern unsigned char via_portb;

void __fastcall__ delay(unsigned char jiffies);

void delay(unsigned char jiffies) {
        do {
                vdp_wait();
        } while (--jiffies > 0);
}

void main(void) {
        original_ddrb = via_ddrb;
        original_port = via_portb;

        via_ddrb = 0xff;

        d = 1;
        r = 0;
        while (1) {
                if (r==0) {
                        d = d << 1;
                        if (d == 0x80) {
                                r = 1;
                        }
                }
                if (r == 1) {
                        d = d >> 1;
                        if (d  == 1) {
                                r = 0;
                        }
                }

                via_portb = d;

                delay(7);
                c = cgetc_nw();
                if (c == 0x1b) break;
        }

        via_ddrb = original_ddrb;
        via_portb = original_port;
        return;
}