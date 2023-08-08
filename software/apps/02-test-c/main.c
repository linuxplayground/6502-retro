#include "main.h"
unsigned char main(void) {
        acia_puts("Hello, from C\n\n");
        while (c != 0x1b) {
                c = acia_getc();
                acia_putc(c);
        }
        return 0;
}
