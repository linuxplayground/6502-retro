#include "conio.h"
unsigned char c;

unsigned char main(void) {
        cputs("Hello, conio from C\n\n");
        while (c!=0x1b) {
                c = cgetc();
                cputc(c);
        }
        return 0;
}