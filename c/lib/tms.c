#include "tms.h"

int i;

void tms_writereg(uint8_t reg, uint8_t val) {
        POKE(TMS_REG, val);
        POKE(TMS_REG, reg | 0x80);
}

void tms_clearvram() {
        POKE(TMS_REG, 0);
        POKE(TMS_REG, 0x40);
        for (i=0; i<0x4000; ++i) {
                POKE(TMS_RAM,0);
        }
}
