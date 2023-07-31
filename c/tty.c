#include "tty.h"

const char * str_cls = "\x1b[H\x1b[2J";
const uint8_t chr_newline = 0x0d;

void tty_newline() {
        acia_putc(chr_newline);
}

void tty_cls() {
        acia_puts(str_cls);
}
