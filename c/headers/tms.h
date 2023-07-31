#ifndef _TMS_H
#define _TMS_H
#include <stdint.h>
#include <peekpoke.h>

#define TMS_RAM 0x7F40
#define TMS_REG 0x7f41

void tms_writereg(uint8_t reg, uint8_t val);
void tms_clearvram(void);

#endif
