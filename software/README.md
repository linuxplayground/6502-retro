# 6502-Retro Software

This software repository is compiled using the CA65 assembler and linker software
from: https://cc65.github.io/

## ROM

There are a few ROM examples provided that are useful for initial testing of the
board.  It's assumed that these can be compiled and the binaries burned to the
28C256 EEPROM using an EEPPROM programmer like the XGecu T48 Universal Programmer
or the now legacy XGecu TL866A+ version.

These ROM programs are designed to work without any additional hardware besides
the boards.

## Interrupts

The 6502-Retro does not provide any mechanism for user defined interrupt service
routines. Well nothing elegant anyway.  One way to solve this problem is to have
the Minimal Bootlaoder support at least the ACIA as this is "onboard".

If the minimal bootloader receives an interrupt that was not triggered by the
ACIA, it will jump to an address pointed to by 0000.  This jump vector is
reserved by the OS.  If the pointer at 0000 is equal to 0000 then the minimal
loader will simply return from the interrupt.  If, however, it is not 0000 it is
assumed the programmer has defined an interrupt service routine for whatever
peice of software needs interrupts.  This routine will be user defined and will
be responsible for figuring out the interrupt source, servicing the interrupt
and returnning from the interrupt (RTI)

The user IRQ *must* restore the registers before returning from the interrupt.

## LOAD

The Load software is software that is compiled against the same system calls
as the rom and can leverage many of the built in ROM routines.  These are meant
to be loaded with XMODEM and executed either from within Wozmon or using the
minimal 6502-retro bootloader.
