#include <stdlib.h>
#include "tty.h"

unsigned char c;
int main() {
        tty_cls();
        acia_puts("Hello, World! from demo");
        tty_newline();
        acia_puts("Press a key...");
        c = acia_getc();
        return 0;
}
