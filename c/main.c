#include "xmodem.h"
#include "tty.h"
#include <stdlib.h>
#include <stdio.h>

#define MAX_CHARS 79
#define PROGRAM_RAM 0x1000

unsigned char c;
char line[MAX_CHARS];

void greet() {
        tty_cls();
        tty_newline();
        acia_puts("6502-Retro!");
        tty_newline();
        acia_puts("[x] load a program with Xmodem");
        tty_newline();
        acia_puts("[r] to run program");
        tty_newline();
}


void handler_run()
{
    __asm__("jsr %w", PROGRAM_RAM);
}


void main(void) {
        acia_init();
        
        greet();

        while (1) {
                acia_putc('>');
                c = acia_getc();
                switch(c) {
                        case 0x1b:
                                greet();
                                break;
                        case (char)'x':
                                xmodem();
                                greet();
                                break;
                        case (char)'r':
                                handler_run();
                                greet();
                                break;
                        default:
                                acia_putc(c);
                                acia_putc('\\');
                                tty_newline();
                }
                
        }
}
