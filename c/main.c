#include "xmodem.h"
#include "conio.h"
#include <stdlib.h>
#include <stdio.h>

#define MAX_CHARS 79
#define PROGRAM_RAM 0x1000

unsigned char c;

void greet() {
        con_nl();
        con_nl();
        con_puts("6502-Retro!");
        con_nl();
        con_puts("[x] load a program with Xmodem");
        con_nl();
        con_puts("[r] to run program");
        con_nl();
        con_prompt();
}

void handler_run()
{
    __asm__("jsr %w", PROGRAM_RAM);
}


void main(void) {
       
        greet();

        while (1) {
                c = con_getc();
                if (c > 0) {
                        switch(c) {
                                case 0x1b:
                                case (char)'h':
                                        greet();
                                        break;
                                case (char)'x':
                                        __asm__("sei");
                                        xmodem();
                                        __asm__("cli");
                                        greet();
                                        break;
                                case (char)'r':
                                        handler_run();
                                        greet();
                                        break;
                                case (char)'c':
                                        con_cls();
                                        con_prompt();
                                        break;
                                default:
                                        con_putc(c);
                                        con_prompt();
                                        con_nl();
                        }
                }
        }
}
