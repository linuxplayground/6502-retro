#include <stdlib.h>
#include <stdint.h>
#include <peekpoke.h>
#include "tms.h"

void main(void) {
        tms_clearvram();
        tms_writereg(7,0xe2);
}
