#include "vdp.h"
#include "conio.h"
#include <stdio.h>
#include <stdlib.h>
#include <peekpoke.h>

unsigned char x, y, c, r, i, j;
char print_buf[80];

void scroll_up() {
        i,j = 0;
        for (i=0; i<24; ++i) {
                for (j=0; j<40; ++j) {
                        r = vdp_read_from_screen_xy(j, i+1);
                        vdp_write_to_screen_xy(j, i, r);
                }
        }
        for (i=0; i<40; ++i) {
                vdp_write_to_screen_xy(i,23,0x20);
        }
}

void main(void) {
        vdp_init();
        x,y = 0;
        cputs("6502-Retro!\n");
        sprintf(print_buf, "%u bytes free.\n", _heapmemavail());
        cputs(print_buf);
        cputs("===========================\n");

        cputs("Ready.\n");

        while(1) {
                c = cgetc();
                if (c == 0x1b) {
                        break;
                } else if (c == 0x0d) {
                        ++y;
                        x = 0;
                } else if (c == 0x08) {
                        if (x >0) {
                                --x;
                                vdp_write_to_screen_xy(x,y,' ');
                        }
                } else {
                        vdp_write_to_screen_xy(x,y,c);
                        ++x;
                }

                if (x > 39) {
                        x = 0;
                        ++y;
                } 
                if (y > 23) {
                        scroll_up();
                        x = 0;
                        y = 23;
                        POKE(0xA10, 0);
                }

                vdp_wait();
                vdp_flush();
        }
        cputs("Bye.\n");
}
